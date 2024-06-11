import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

import '../../../interfaces/pdf_interface.dart';
import '../../io/pdf_constants.dart';
import '../../io/pdf_cross_table.dart';
import '../../io/pdf_writer.dart';
import '../../io/stream_reader.dart';
import '../../pdf_document/pdf_document.dart';
import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_name.dart';
import '../../primitives/pdf_number.dart';
import '../../primitives/pdf_reference_holder.dart';
import '../../primitives/pdf_string.dart';
import '../enum.dart';
import '../pdf_security.dart';
import 'asn1/asn1.dart';
import 'asn1/asn1_stream.dart';
import 'asn1/der.dart';
import 'cryptography/cipher_block_chaining_mode.dart';
import 'cryptography/cipher_utils.dart';
import 'cryptography/ipadding.dart';
import 'cryptography/pkcs1_encoding.dart';
import 'cryptography/rsa_algorithm.dart';
import 'cryptography/signature_utilities.dart';
import 'pdf_certificate.dart';
import 'pdf_external_signer.dart';
import 'pdf_signature.dart';
import 'pkcs/password_utility.dart';
import 'pkcs/pfx_data.dart';
import 'time_stamp_server/time_stamp_server.dart';
import 'x509/ocsp_utils.dart';
import 'x509/x509_certificates.dart';

/// Represents signature dictionary.
class PdfSignatureDictionary implements IPdfWrapper {
  /// internal constructor
  PdfSignatureDictionary(PdfDocument doc, PdfSignature sig) {
    _doc = doc;
    _sig = sig;
    (PdfDocumentHelper.getHelper(doc).documentSavedList ??=
            <DocumentSavedHandler>[])
        .add(_documentSaved);
    (PdfDocumentHelper.getHelper(doc).documentSavedListAsync ??=
            <DocumentSavedHandlerAsync>[])
        .add(_documentSavedAsync);
    dictionary!.beginSaveList ??= <SavePdfPrimitiveCallback>[];
    dictionary!.beginSaveList!.add(_dictionaryBeginSave);
    _cert = sig.certificate;
  }

  /// internal constructor
  PdfSignatureDictionary.fromDictionary(PdfDocument doc, this.dictionary) {
    _doc = doc;
    (PdfDocumentHelper.getHelper(doc).documentSavedList ??=
            <DocumentSavedHandler>[])
        .add(_documentSaved);
    (PdfDocumentHelper.getHelper(doc).documentSavedListAsync ??=
            <DocumentSavedHandlerAsync>[])
        .add(_documentSavedAsync);
    dictionary!.beginSaveList ??= <SavePdfPrimitiveCallback>[];
    dictionary!.beginSaveList!.add(_dictionaryBeginSave);
  }

  //Fields
  /// internal field
  PdfDictionary? dictionary = PdfDictionary();
  late PdfDocument _doc;
  PdfSignature? _sig;
  final String _transParam = 'TransformParams';
  final String _docMdp = 'DocMDP';
  final String _cmsFilterType = 'adbe.pkcs7.detached';
  final String _cadasFilterType = 'ETSI.CAdES.detached';
  final String _rfcFilterType = 'ETSI.RFC3161';
  int? _firstRangeLength;
  int? _secondRangeIndex;
  int? _startPositionByteRange;
  final int _estimatedSize = 8192;
  PdfCertificate? _cert;
  late List<int> _range;
  List<int>? _stream;

  //Implementations
  void _dictionaryBeginSave(Object sender, SavePdfPrimitiveArgs? args) {
    final bool state =
        PdfSecurityHelper.getHelper(_doc.security).encryptor.encrypt;
    dictionary!.encrypt = state;
    if (_sig != null) {
      _addRequiredItems();
      _addOptionalItems();
    }
    PdfSecurityHelper.getHelper(_doc.security).encryptor.encrypt = false;
    _addContents(args!.writer!);
    _addRange(args.writer!);
    if (_sig != null) {
      if (PdfSignatureHelper.getHelper(_sig!).certificated) {
        _addDigest(args.writer);
      }
    }
    PdfSecurityHelper.getHelper(_doc.security).encryptor.encrypt = state;
  }

  void _addRequiredItems() {
    if (PdfSignatureHelper.getHelper(_sig!).certificated && _allowMDP()) {
      _addReference();
    }
    _addType();
    _addDate();
    _addFilter();
    _addSubFilter();
  }

  void _addOptionalItems() {
    if (_sig != null) {
      if (_sig!.reason != null) {
        dictionary!.setProperty(
            PdfDictionaryProperties.reason, PdfString(_sig!.reason!));
      }
      if (_sig!.locationInfo != null) {
        dictionary!.setProperty(
            PdfDictionaryProperties.location, PdfString(_sig!.locationInfo!));
      }
      if (_sig!.contactInfo != null) {
        dictionary!.setProperty(
            PdfDictionaryProperties.contactInfo, PdfString(_sig!.contactInfo!));
      }
      if (_sig!.signedName != null) {
        dictionary!.setString(PdfDictionaryProperties.name, _sig!.signedName);
        final PdfDictionary tempDictionary = PdfDictionary();
        final PdfDictionary appDictionary = PdfDictionary();
        tempDictionary.setName(
            PdfName(PdfDictionaryProperties.name), _sig!.signedName);
        appDictionary.setProperty('App', PdfReferenceHolder(tempDictionary));
        dictionary!.setProperty(
            PdfName('Prop_Build'), PdfReferenceHolder(appDictionary));
      }
    }
  }

  bool _allowMDP() {
    final IPdfPrimitive? perms = PdfCrossTable.dereference(
        PdfDocumentHelper.getHelper(_doc)
            .catalog[PdfDictionaryProperties.perms]);
    if (perms != null && perms is PdfDictionary) {
      final IPdfPrimitive? docMDP =
          PdfCrossTable.dereference(perms[PdfDictionaryProperties.docMDP]);
      final IPdfPrimitive dicSig = dictionary!;
      return dicSig == docMDP;
    }
    return false;
  }

  void _addReference() {
    final PdfDictionary trans = PdfDictionary();
    final PdfDictionary reference = PdfDictionary();
    final PdfArray array = PdfArray();
    trans[PdfDictionaryProperties.v] = PdfName('1.2');
    trans[PdfDictionaryProperties.p] = PdfNumber(
        PdfSignatureHelper.getHelper(_sig!)
            .getCertificateFlagResult(_sig!.documentPermissions));
    trans[PdfDictionaryProperties.type] = PdfName(_transParam);
    reference[PdfDictionaryProperties.transformMethod] = PdfName(_docMdp);
    reference[PdfDictionaryProperties.type] = PdfName('SigRef');
    reference[_transParam] = trans;
    array.add(reference);
    dictionary!.setProperty('Reference', array);
  }

  void _addType() {
    if (_sig != null && _sig!.timestampServer != null && _cert == null) {
      dictionary!
          .setName(PdfName(PdfDictionaryProperties.type), 'DocTimeStamp');
    } else {
      dictionary!.setName(PdfName(PdfDictionaryProperties.type), 'Sig');
    }
  }

  void _addDate() {
    DateTime dateTime = DateTime.now();
    if (_sig != null && _sig!.signedDate != null) {
      dateTime = _sig!.signedDate!;
    }
    final DateFormat dateFormat = DateFormat('yyyyMMddHHmmss');
    final int regionMinutes = dateTime.timeZoneOffset.inMinutes ~/ 11;
    String offsetMinutes = regionMinutes.toString();
    if (regionMinutes >= 0 && regionMinutes <= 9) {
      offsetMinutes = '0$offsetMinutes';
    }
    final int regionHours = dateTime.timeZoneOffset.inHours;
    String offsetHours = regionHours.toString();
    if (regionHours >= 0 && regionHours <= 9) {
      offsetHours = '0$offsetHours';
    }
    dictionary!.setProperty(
        PdfDictionaryProperties.m,
        PdfString(
            "D:${dateFormat.format(dateTime)}+$offsetHours'$offsetMinutes'"));
  }

  void _addFilter() {
    dictionary!
        .setName(PdfName(PdfDictionaryProperties.filter), 'Adobe.PPKLite');
  }

  void _addSubFilter() {
    if (_sig != null && _sig!.timestampServer != null && _cert == null) {
      dictionary!
          .setName(PdfName(PdfDictionaryProperties.subFilter), _rfcFilterType);
    } else {
      dictionary!.setName(
          PdfName(PdfDictionaryProperties.subFilter),
          _sig!.cryptographicStandard == CryptographicStandard.cades
              ? _cadasFilterType
              : _cmsFilterType);
    }
  }

  void _addContents(IPdfWriter writer) {
    writer.write(PdfOperators.slash +
        PdfDictionaryProperties.contents +
        PdfOperators.whiteSpace);
    _firstRangeLength = writer.position;
    int length = _estimatedSize * 2;
    if (_sig != null && _cert != null) {
      length = _estimatedSize;
      if (_sig!.timestampServer != null) {
        length += 4192;
      }
    }
    final List<int> contents =
        List<int>.filled(length * 2 + 2, 0, growable: true);
    writer.write(contents);
    _secondRangeIndex = writer.position;
    writer.write(PdfOperators.newLine);
  }

  void _addRange(IPdfWriter writer) {
    writer.write(PdfOperators.slash +
        PdfDictionaryProperties.byteRange +
        PdfOperators.whiteSpace +
        PdfArray.startMark);
    _startPositionByteRange = writer.position;
    for (int i = 0; i < 32; i++) {
      writer.write(PdfOperators.whiteSpace);
    }
    writer.write(PdfArray.endMark + PdfOperators.newLine);
  }

  void _addDigest(IPdfWriter? writer) {
    if (_allowMDP()) {
      final PdfDictionary cat =
          PdfDocumentHelper.getHelper(writer!.document!).catalog;
      writer.write(PdfName(PdfDictionaryProperties.reference));
      writer.write(PdfArray.startMark);
      writer.write('<<');
      writer.write(PdfOperators.slash + _transParam);
      PdfDictionary trans = PdfDictionary();
      trans[PdfDictionaryProperties.v] = PdfName('1.2');
      trans[PdfDictionaryProperties.p] = PdfNumber(
          PdfSignatureHelper.getHelper(_sig!)
              .getCertificateFlagResult(_sig!.documentPermissions));
      trans[PdfDictionaryProperties.type] = PdfName(_transParam);
      writer.write(trans);
      writer.write(PdfName(PdfDictionaryProperties.transformMethod));
      writer.write(PdfName(_docMdp));
      writer.write(PdfName(PdfDictionaryProperties.type));
      writer.write(PdfName(PdfDictionaryProperties.sigRef));
      writer.write(PdfName('DigestValue'));
      int position = writer.position!;
      // _docDigestPosition = position;
      writer
          .write(PdfString.fromBytes(List<int>.filled(16, 0, growable: true)));
      PdfArray digestLocation = PdfArray();
      digestLocation.add(PdfNumber(position));
      digestLocation.add(PdfNumber(34));
      writer.write(PdfName('DigestLocation'));
      writer.write(digestLocation);
      writer.write(PdfName('DigestMethod'));
      writer.write(PdfName('MD5'));
      writer.write(PdfName(PdfDictionaryProperties.data));
      final PdfReferenceHolder refh = PdfReferenceHolder(cat);
      writer.write(PdfOperators.whiteSpace);
      writer.write(refh);
      writer.write('>>');
      writer.write('<<');
      writer.write(PdfName(_transParam));
      trans = PdfDictionary();
      trans[PdfDictionaryProperties.v] = PdfName('1.2');
      final PdfArray fields = PdfArray();
      fields.add(PdfString(PdfSignatureHelper.getHelper(_sig!).field!.name!));
      trans[PdfDictionaryProperties.fields] = fields;
      trans[PdfDictionaryProperties.type] = PdfName(_transParam);
      trans[PdfDictionaryProperties.action] = PdfName('Include');
      writer.write(trans);
      writer.write(PdfName(PdfDictionaryProperties.transformMethod));
      writer.write(PdfName('FieldMDP'));
      writer.write(PdfName(PdfDictionaryProperties.type));
      writer.write(PdfName(PdfDictionaryProperties.sigRef));
      writer.write(PdfName('DigestValue'));
      position = writer.position!;
      // _fieldsDigestPosition = position;
      writer
          .write(PdfString.fromBytes(List<int>.filled(16, 0, growable: true)));
      digestLocation = PdfArray();
      digestLocation.add(PdfNumber(position));
      digestLocation.add(PdfNumber(34));
      writer.write(PdfName('DigestLocation'));
      writer.write(digestLocation);
      writer.write(PdfName('DigestMethod'));
      writer.write(PdfName('MD5'));
      writer.write(PdfName(PdfDictionaryProperties.data));
      writer.write(PdfOperators.whiteSpace);
      writer.write(PdfReferenceHolder(cat));
      writer.write('>>');
      writer.write(PdfArray.endMark);
      writer.write(PdfOperators.whiteSpace);
    }
  }

  void _documentSaved(Object sender, DocumentSavedArgs e) {
    final bool enabled =
        PdfSecurityHelper.getHelper(_doc.security).encryptor.encrypt;
    PdfSecurityHelper.getHelper(_doc.security).encryptor.encrypt = false;
    final PdfWriter writer = e.writer! as PdfWriter;
    final int number = e.writer!.length! - _secondRangeIndex!;
    const String str = '0 ';
    final String str2 = '$_firstRangeLength ';
    final String str3 = '$_secondRangeIndex ';
    final String str4 = number.toString();
    int startPosition = _saveRangeItem(writer, str, _startPositionByteRange!);
    startPosition = _saveRangeItem(writer, str2, startPosition);
    startPosition = _saveRangeItem(writer, str3, startPosition);
    _saveRangeItem(e.writer! as PdfWriter, str4, startPosition);
    _range = <int>[0, int.parse(str2), int.parse(str3), int.parse(str4)];
    _stream = writer.buffer;
    final String text = PdfString.bytesToHex(getPkcs7Content()!);
    _stream!.replaceRange(
        _firstRangeLength!, _firstRangeLength! + 1, utf8.encode('<'));
    final int newPos = _firstRangeLength! + 1 + text.length;
    _stream!.replaceRange(_firstRangeLength! + 1, newPos, utf8.encode(text));
    final int num3 = (_secondRangeIndex! - newPos) ~/ 2;
    final String emptyText =
        PdfString.bytesToHex(List<int>.generate(num3, (int i) => 0));
    _stream!.replaceRange(
        newPos, newPos + emptyText.length, utf8.encode(emptyText));
    _stream!.replaceRange(newPos + emptyText.length,
        newPos + emptyText.length + 1, utf8.encode('>'));
    PdfSecurityHelper.getHelper(_doc.security).encryptor.encrypt = enabled;
  }

  Future<void> _documentSavedAsync(Object sender, DocumentSavedArgs e) async {
    final bool enabled =
        PdfSecurityHelper.getHelper(_doc.security).encryptor.encrypt;
    PdfSecurityHelper.getHelper(_doc.security).encryptor.encrypt = false;
    final PdfWriter writer = e.writer! as PdfWriter;
    final int number = e.writer!.length! - _secondRangeIndex!;
    const String str = '0 ';
    final String str2 = '$_firstRangeLength ';
    final String str3 = '$_secondRangeIndex ';
    final String str4 = number.toString();
    await _saveRangeItemAsync(writer, str, _startPositionByteRange!)
        .then((int startPosition) async {
      await _saveRangeItemAsync(writer, str2, startPosition)
          .then((int startPosition) async {
        await _saveRangeItemAsync(writer, str3, startPosition)
            .then((int startPosition) async {
          await _saveRangeItemAsync(e.writer! as PdfWriter, str4, startPosition)
              .then((int startPosition) async {
            _range = <int>[
              0,
              int.parse(str2),
              int.parse(str3),
              int.parse(str4)
            ];
            _stream = writer.buffer;
            if (_cert != null ||
                (_sig != null &&
                    PdfSignatureHelper.getHelper(_sig!).externalSigner !=
                        null)) {
              await getPkcs7ContentAsync().then((List<int>? value) async {
                await PdfString.bytesToHexAsync(value!)
                    .then((String text) async {
                  _stream!.replaceRange(_firstRangeLength!,
                      _firstRangeLength! + 1, utf8.encode('<'));
                  final int newPos = _firstRangeLength! + 1 + text.length;
                  _stream!.replaceRange(
                      _firstRangeLength! + 1, newPos, utf8.encode(text));
                  final int num3 = (_secondRangeIndex! - newPos) ~/ 2;
                  await PdfString.bytesToHexAsync(
                          List<int>.generate(num3, (int i) => 0))
                      .then((String emptyText) async {
                    _stream!.replaceRange(newPos, newPos + emptyText.length,
                        utf8.encode(emptyText));
                    _stream!.replaceRange(newPos + emptyText.length,
                        newPos + emptyText.length + 1, utf8.encode('>'));
                    PdfSecurityHelper.getHelper(_doc.security)
                        .encryptor
                        .encrypt = enabled;
                  });
                });
              });
            } else if (_sig != null && _sig!.timestampServer != null) {
              await _getPKCS7TimeStampContent().then((List<int>? value) async {
                await PdfString.bytesToHexAsync(value!)
                    .then((String text) async {
                  _stream!.replaceRange(_firstRangeLength!,
                      _firstRangeLength! + 1, utf8.encode('<'));
                  final int newPos = _firstRangeLength! + 1 + text.length;
                  _stream!.replaceRange(
                      _firstRangeLength! + 1, newPos, utf8.encode(text));
                  final int num3 = (_secondRangeIndex! - newPos) ~/ 2;
                  await PdfString.bytesToHexAsync(
                          List<int>.generate(num3, (int i) => 0))
                      .then((String emptyText) async {
                    _stream!.replaceRange(newPos, newPos + emptyText.length,
                        utf8.encode(emptyText));
                    _stream!.replaceRange(newPos + emptyText.length,
                        newPos + emptyText.length + 1, utf8.encode('>'));
                    PdfSecurityHelper.getHelper(_doc.security)
                        .encryptor
                        .encrypt = enabled;
                  });
                });
              });
            }
          });
        });
      });
    });
  }

  /// internal method
  List<int>? getPkcs7Content() {
    String? hasalgorithm = '';
    _SignaturePrivateKey externalSignature;
    List<List<int>>? crlBytes;
    List<int>? ocspByte;
    List<X509Certificate?>? chain = <X509Certificate?>[];
    final IPdfExternalSigner? externalSigner =
        PdfSignatureHelper.getHelper(_sig!).externalSigner;
    if (externalSigner != null &&
        PdfSignatureHelper.getHelper(_sig!).externalChain != null) {
      chain = PdfSignatureHelper.getHelper(_sig!).externalChain;
      final String digest = getDigestAlgorithm(externalSigner.hashAlgorithm);
      final _SignaturePrivateKey pks = _SignaturePrivateKey(digest);
      hasalgorithm = pks.getHashAlgorithm();
      externalSignature = pks;
    } else {
      String certificateAlias = '';
      final List<String> keys = PdfCertificateHelper.getPkcsCertificate(_cert!)
          .getContentTable()
          .keys
          .toList();
      bool isContinue = true;
      // ignore: avoid_function_literals_in_foreach_calls
      keys.forEach((String key) {
        if (isContinue &&
            PdfCertificateHelper.getPkcsCertificate(_cert!).isKey(key) &&
            PdfCertificateHelper.getPkcsCertificate(_cert!)
                .getKey(key)!
                .key!
                .isPrivate!) {
          certificateAlias = key;
          isContinue = false;
        }
      });
      final KeyEntry pk = PdfCertificateHelper.getPkcsCertificate(_cert!)
          .getKey(certificateAlias)!;
      final List<X509Certificates> certificates =
          PdfCertificateHelper.getPkcsCertificate(_cert!)
              .getCertificateChain(certificateAlias)!;
      // ignore: avoid_function_literals_in_foreach_calls
      certificates.forEach((X509Certificates c) {
        chain!.add(c.certificate);
      });
      final RsaPrivateKeyParam? parameters = pk.key as RsaPrivateKeyParam?;
      final String digest = _sig != null
          ? getDigestAlgorithm(_sig!.digestAlgorithm)
          : MessageDigestAlgorithms.secureHash256;
      final _SignaturePrivateKey pks = _SignaturePrivateKey(digest, parameters);
      hasalgorithm = pks.getHashAlgorithm();
      externalSignature = pks;
    }
    final _PdfCmsSigner pkcs7 =
        _PdfCmsSigner(null, chain, hasalgorithm!, false);
    final IRandom source = getUnderlyingSource();
    final List<IRandom?> sources =
        List<IRandom?>.generate(_range.length ~/ 2, (int i) => null);
    for (int j = 0; j < _range.length; j += 2) {
      sources[j ~/ 2] = _WindowRandom(source, _range[j], _range[j + 1]);
    }
    final PdfStreamReader data = _RandomStream(_RandomGroup(sources));
    final List<int> hash = pkcs7._digestAlgorithm.digest(data, hasalgorithm)!;
    final List<int>? sh = pkcs7
        .getSequenceDataSet(
            hash, ocspByte, crlBytes, _sig!.cryptographicStandard)
        .getEncoded(Asn1.der);
    List<int>? extSignature;
    if (externalSigner != null) {
      final SignerResult? signerResult = externalSigner.signSync(sh!);
      if (signerResult != null && signerResult.signedData.isNotEmpty) {
        extSignature = signerResult.signedData;
      }
      if (extSignature != null) {
        pkcs7.setSignedData(
            extSignature, null, externalSignature.getEncryptionAlgorithm());
      } else {
        return List<int>.filled(_estimatedSize, 0, growable: true);
      }
    } else {
      extSignature = externalSignature.sign(sh!);
    }
    pkcs7.setSignedData(
        extSignature!, null, externalSignature.getEncryptionAlgorithm());
    return pkcs7.sign(hash, _sig!.timestampServer, null, ocspByte, crlBytes,
        _sig!.cryptographicStandard, hasalgorithm);
  }

  /// internal method
  Future<List<int>?> getPkcs7ContentAsync() async {
    List<int>? pkcs7Content;
    String? hasalgorithm = '';
    _SignaturePrivateKey? externalSignature;
    List<List<int>>? crlBytes;
    List<int>? ocspByte;
    List<X509Certificate?>? chain = <X509Certificate?>[];
    final IPdfExternalSigner? externalSigner =
        PdfSignatureHelper.getHelper(_sig!).externalSigner;
    if (externalSigner != null &&
        PdfSignatureHelper.getHelper(_sig!).externalChain != null) {
      chain = PdfSignatureHelper.getHelper(_sig!).externalChain;
      final String digest = getDigestAlgorithm(externalSigner.hashAlgorithm);
      final _SignaturePrivateKey pks = _SignaturePrivateKey(digest);
      hasalgorithm = pks.getHashAlgorithm();
      externalSignature = pks;
    } else {
      String certificateAlias = '';
      await PdfCertificateHelper.getPkcsCertificate(_cert!)
          .getContentTableAsync()
          .then((Map<String, String> contentTable) async {
        final List<String> keys = contentTable.keys.toList();
        bool isContinue = true;
        // ignore: avoid_function_literals_in_foreach_calls
        keys.forEach((String key) {
          if (isContinue &&
              PdfCertificateHelper.getPkcsCertificate(_cert!).isKey(key) &&
              PdfCertificateHelper.getPkcsCertificate(_cert!)
                  .getKey(key)!
                  .key!
                  .isPrivate!) {
            certificateAlias = key;
            isContinue = false;
          }
        });
        final KeyEntry pk = PdfCertificateHelper.getPkcsCertificate(_cert!)
            .getKey(certificateAlias)!;
        await PdfCertificateHelper.getPkcsCertificate(_cert!)
            .getCertificateChainAsync(certificateAlias)
            .then((List<X509Certificates>? certificates) {
          // ignore: avoid_function_literals_in_foreach_calls
          certificates!.forEach((X509Certificates c) {
            chain!.add(c.certificate);
          });
          final RsaPrivateKeyParam? parameters = pk.key as RsaPrivateKeyParam?;
          final String digest = _sig != null
              ? getDigestAlgorithm(_sig!.digestAlgorithm)
              : MessageDigestAlgorithms.secureHash256;
          final _SignaturePrivateKey pks =
              _SignaturePrivateKey(digest, parameters);
          hasalgorithm = pks.getHashAlgorithm();
          externalSignature = pks;
        });
      });
    }
    final _PdfCmsSigner pkcs7 =
        _PdfCmsSigner(null, chain, hasalgorithm!, false);
    final IRandom source = getUnderlyingSource();
    final List<IRandom?> sources =
        List<IRandom?>.generate(_range.length ~/ 2, (int i) => null);
    for (int j = 0; j < _range.length; j += 2) {
      sources[j ~/ 2] = _WindowRandom(source, _range[j], _range[j + 1]);
    }
    final PdfStreamReader data = _RandomStream(_RandomGroup(sources));
    await pkcs7._digestAlgorithm
        .digestAsync(data, hasalgorithm)
        .then((List<int>? hash) async {
      await pkcs7
          .getSequenceDataSetAsync(
              hash!, ocspByte, crlBytes, _sig!.cryptographicStandard)
          .then((DerSet derSet) async {
        await derSet.getEncodedAsync(Asn1.der).then((List<int>? sh) async {
          List<int>? extSignature;
          if (externalSigner != null) {
            await externalSigner
                .sign(sh!)
                .then((SignerResult? signerResult) async {
              signerResult ??= externalSigner.signSync(sh);
              if (signerResult != null && signerResult.signedData.isNotEmpty) {
                extSignature = signerResult.signedData;
              }
              if (extSignature != null) {
                await pkcs7.setSignedDataAsync(extSignature!, null,
                    externalSignature!.getEncryptionAlgorithm());
              } else {
                pkcs7Content =
                    List<int>.filled(_estimatedSize, 0, growable: true);
              }
            });
          } else {
            await externalSignature!
                .signAsync(sh!)
                .then((List<int>? value) => extSignature = value);
          }
          if (pkcs7Content == null) {
            await pkcs7.setSignedDataAsync(extSignature!, null,
                externalSignature!.getEncryptionAlgorithm());
            pkcs7Content = await pkcs7.signAsync(
                hash,
                _sig!.timestampServer,
                null,
                ocspByte,
                crlBytes,
                _sig!.cryptographicStandard,
                hasalgorithm);
          }
        });
      });
    });
    return pkcs7Content;
  }

  Future<List<int>?> _getPKCS7TimeStampContent() async {
    final _SignaturePrivateKey externalSignature =
        _SignaturePrivateKey(MessageDigestAlgorithms.secureHash256);
    final String? hashAlgorithm = externalSignature.getHashAlgorithm();
    final _PdfCmsSigner pkcs7 =
        _PdfCmsSigner(null, null, hashAlgorithm!, false);
    final IRandom source = getUnderlyingSource();
    final List<IRandom?> sources =
        List<IRandom?>.filled(_range.length ~/ 2, null);
    for (int j = 0; j < _range.length; j += 2) {
      sources[j ~/ 2] = _WindowRandom(source, _range[j], _range[j + 1]);
    }
    final PdfStreamReader data = _RandomStream(_RandomGroup(sources));
    final MessageDigestAlgorithms alg = MessageDigestAlgorithms();
    final List<int>? hash = alg.digest(data, hashAlgorithm);
    if (hash != null) {
      pkcs7.setSignedData(
          hash, null, externalSignature.getEncryptionAlgorithm());
      return pkcs7.getEncodedTimestamp(hash, _sig!.timestampServer!);
    }
    return null;
  }

  /// internal method
  IRandom getUnderlyingSource() {
    return _RandomArray(_stream!.sublist(0));
  }

  /// internal method
  String getDigestAlgorithm(DigestAlgorithm? digest) {
    String digestAlgorithm;
    switch (digest) {
      case DigestAlgorithm.sha1:
        digestAlgorithm = MessageDigestAlgorithms.secureHash1;
        break;
      case DigestAlgorithm.sha384:
        digestAlgorithm = MessageDigestAlgorithms.secureHash384;
        break;
      case DigestAlgorithm.sha512:
        digestAlgorithm = MessageDigestAlgorithms.secureHash512;
        break;
      // ignore: no_default_cases
      default:
        digestAlgorithm = MessageDigestAlgorithms.secureHash256;
        break;
    }
    return digestAlgorithm;
  }

  int _saveRangeItem(PdfWriter writer, String str, int startPosition) {
    final List<int> date = utf8.encode(str);
    writer.buffer!
        .replaceRange(startPosition, startPosition + date.length, date);
    return startPosition + str.length;
  }

  Future<int> _saveRangeItemAsync(
      PdfWriter writer, String str, int startPosition) async {
    final List<int> date = utf8.encode(str);
    writer.buffer!
        .replaceRange(startPosition, startPosition + date.length, date);
    return startPosition + str.length;
  }

  /// internal property
  IPdfPrimitive? get element => dictionary;
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }
}

/// internal class
class MessageDigestAlgorithms {
  /// internal constructor
  MessageDigestAlgorithms() {
    _names = <String, String>{};
    _names['1.2.840.113549.2.5'] = 'MD5';
    _names['1.3.14.3.2.26'] = 'SHA1';
    _names['2.16.840.1.101.3.4.2.1'] = 'SHA256';
    _names['2.16.840.1.101.3.4.2.2'] = 'SHA384';
    _names['2.16.840.1.101.3.4.2.3'] = 'SHA512';
    _names['1.3.36.3.2.1'] = 'RIPEMD160';
    _names['1.2.840.113549.1.1.4'] = 'MD5';
    _names['1.2.840.113549.1.1.5'] = 'SHA1';
    _names['1.2.840.113549.1.1.11'] = 'SHA256';
    _names['1.2.840.113549.1.1.12'] = 'SHA384';
    _names['1.2.840.113549.1.1.13'] = 'SHA512';
    _names['1.2.840.113549.2.5'] = 'MD5';
    _names['1.2.840.10040.4.3'] = 'SHA1';
    _names['2.16.840.1.101.3.4.3.2'] = 'SHA256';
    _names['2.16.840.1.101.3.4.3.3'] = 'SHA384';
    _names['2.16.840.1.101.3.4.3.4'] = 'SHA512';
    _names['1.3.36.3.3.1.2'] = 'RIPEMD160';
    _digests = <String, String>{};
    _digests['MD5'] = '1.2.840.113549.2.5';
    _digests['MD-5'] = '1.2.840.113549.2.5';
    _digests['SHA1'] = '1.3.14.3.2.26';
    _digests['SHA-1'] = '1.3.14.3.2.26';
    _digests['SHA256'] = '2.16.840.1.101.3.4.2.1';
    _digests['SHA-256'] = '2.16.840.1.101.3.4.2.1';
    _digests['SHA384'] = '2.16.840.1.101.3.4.2.2';
    _digests['SHA-384'] = '2.16.840.1.101.3.4.2.2';
    _digests['SHA512'] = '2.16.840.1.101.3.4.2.3';
    _digests['SHA-512'] = '2.16.840.1.101.3.4.2.3';
    _digests['RIPEMD160'] = '1.3.36.3.2.1';
    _digests['RIPEMD-160'] = '1.3.36.3.2.1';
    _algorithms = <String?, String>{};
    _algorithms['SHA1'] = 'SHA-1';
    _algorithms[DerObjectID('1.3.14.3.2.26').id] = 'SHA-1';
    _algorithms['SHA256'] = 'SHA-256';
    _algorithms[NistObjectIds.sha256.id] = 'SHA-256';
    _algorithms['SHA384'] = 'SHA-384';
    _algorithms[NistObjectIds.sha384.id] = 'SHA-384';
    _algorithms['SHA512'] = 'SHA-512';
    _algorithms[NistObjectIds.sha512.id] = 'SHA-512';
    _algorithms['MD5'] = 'MD5';
    _algorithms[PkcsObjectId.md5.id] = 'MD5';
    _algorithms['RIPEMD-160'] = 'RIPEMD160';
    _algorithms['RIPEMD160'] = 'RIPEMD160';
    _algorithms[NistObjectIds.ripeMD160.id] = 'RIPEMD160';
  }

  /// internal field
  static const String secureHash1 = 'SHA-1';

  /// internal field
  static const String secureHash256 = 'SHA-256';

  /// internal field
  static const String secureHash384 = 'SHA-384';

  /// internal field
  static const String secureHash512 = 'SHA-512';
  late Map<String, String> _names;
  late Map<String, String> _digests;
  late Map<String?, String> _algorithms;

  /// internal method
  String? getDigest(String? id) {
    String? result;
    if (_names.containsKey(id)) {
      result = _names[id!];
    } else {
      result = id;
    }
    return result;
  }

  /// internal method
  String? getAllowedDigests(String name) {
    String? result;
    final String lower = name.toLowerCase();
    _digests.forEach((String key, String value) {
      if (lower == key.toLowerCase()) {
        result = _digests[key];
      }
    });
    return result;
  }

  /// internal method
  Future<String?> getAllowedDigestsAsync(String name) async {
    String? result;
    final String lower = name.toLowerCase();
    _digests.forEach((String key, String value) {
      if (lower == key.toLowerCase()) {
        result = _digests[key];
      }
    });
    return result;
  }

  /// internal method
  dynamic getMessageDigest(String hashAlgorithm) {
    String lower = hashAlgorithm.toLowerCase();
    String? digest = lower;
    bool isContinue = true;
    _algorithms.forEach((String? key, String value) {
      if (isContinue && key!.toLowerCase() == lower) {
        digest = _algorithms[key];
        isContinue = false;
      }
    });
    dynamic result;
    lower = digest!.toLowerCase();
    if (lower == 'sha1' || lower == 'sha-1' || lower == 'sha_1') {
      result = sha1;
    } else if (lower == 'sha256' || lower == 'sha-256' || lower == 'sha_256') {
      result = sha256;
    } else if (lower == 'sha384' || lower == 'sha-384' || lower == 'sha_384') {
      result = sha384;
    } else if (lower == 'sha512' || lower == 'sha-512' || lower == 'sha_512') {
      result = sha512;
    } else if (lower == 'md5' || lower == 'md-5' || lower == 'md_5') {
      result = md5;
    } else {
      throw ArgumentError.value(
          hashAlgorithm, 'hashAlgorithm', 'Invalid message digest algorithm');
    }
    return result;
  }

  /// internal method
  Future<dynamic> getMessageDigestAsync(String hashAlgorithm) async {
    String lower = hashAlgorithm.toLowerCase();
    String? digest = lower;
    bool isContinue = true;
    _algorithms.forEach((String? key, String value) {
      if (isContinue && key!.toLowerCase() == lower) {
        digest = _algorithms[key];
        isContinue = false;
      }
    });
    dynamic result;
    lower = digest!.toLowerCase();
    if (lower == 'sha1' || lower == 'sha-1' || lower == 'sha_1') {
      result = sha1;
    } else if (lower == 'sha256' || lower == 'sha-256' || lower == 'sha_256') {
      result = sha256;
    } else if (lower == 'sha384' || lower == 'sha-384' || lower == 'sha_384') {
      result = sha384;
    } else if (lower == 'sha512' || lower == 'sha-512' || lower == 'sha_512') {
      result = sha512;
    } else if (lower == 'md5' || lower == 'md-5' || lower == 'md_5') {
      result = md5;
    } else {
      throw ArgumentError.value(
          hashAlgorithm, 'hashAlgorithm', 'Invalid message digest algorithm');
    }
    return result;
  }

  /// internal method
  List<int>? digest(PdfStreamReader data, dynamic hashAlgorithm) {
    dynamic algorithm;
    if (hashAlgorithm is String) {
      algorithm = getMessageDigest(hashAlgorithm);
    } else {
      algorithm = hashAlgorithm;
    }
    final dynamic output = AccumulatorSink<Digest>();
    final dynamic input = algorithm.startChunkedConversion(output);
    int? count;
    final List<int> bytes = List<int>.generate(8192, (int i) => 0);
    while ((count = data.read(bytes, 0, bytes.length))! > 0) {
      input.add(bytes.sublist(0, count));
    }
    input.close();
    return output.events.single.bytes as List<int>?;
  }

  /// internal method
  Future<List<int>?> digestAsync(
      PdfStreamReader data, dynamic hashAlgorithm) async {
    dynamic algorithm;
    algorithm = hashAlgorithm is String
        ? await getMessageDigestAsync(hashAlgorithm)
        : hashAlgorithm;
    final dynamic output = AccumulatorSink<Digest>();
    final dynamic input = algorithm.startChunkedConversion(output);
    int? count;
    final List<int> bytes = List<int>.generate(8192, (int i) => 0);
    while ((count = data.read(bytes, 0, bytes.length))! > 0) {
      input.add(bytes.sublist(0, count));
    }
    input.close();
    return output.events.single.bytes as List<int>?;
  }
}

class _SignaturePrivateKey {
  _SignaturePrivateKey(String hashAlgorithm, [ICipherParameter? key]) {
    _key = key;
    final MessageDigestAlgorithms alg = MessageDigestAlgorithms();
    _hashAlgorithm = alg.getDigest(alg.getAllowedDigests(hashAlgorithm));
    if (key == null || key is RsaKeyParam) {
      _encryptionAlgorithm = 'RSA';
    } else {
      throw ArgumentError.value(key, 'key', 'Invalid key');
    }
  }
  //Fields
  ICipherParameter? _key;
  String? _hashAlgorithm;
  String? _encryptionAlgorithm;
  //Implementation
  List<int>? sign(List<int> bytes) {
    final String signMode = '${_hashAlgorithm!}with${_encryptionAlgorithm!}';
    final SignerUtilities util = SignerUtilities();
    final ISigner signer = util.getSigner(signMode);
    signer.initialize(true, _key);
    signer.blockUpdate(bytes, 0, bytes.length);
    return signer.generateSignature();
  }

  Future<List<int>?> signAsync(List<int> bytes) async {
    final String signMode = '${_hashAlgorithm!}with${_encryptionAlgorithm!}';
    final SignerUtilities util = SignerUtilities();
    final ISigner signer = util.getSigner(signMode);
    signer.initialize(true, _key);
    signer.blockUpdate(bytes, 0, bytes.length);
    return signer.generateSignature();
  }

  String? getHashAlgorithm() {
    return _hashAlgorithm;
  }

  String? getEncryptionAlgorithm() {
    return _encryptionAlgorithm;
  }
}

/// Internal class
class SignerUtilities {
  /// Internal consturctor
  SignerUtilities() {
    _algms['MD2WITHRSA'] = 'MD2withRSA';
    _algms['MD2WITHRSAENCRYPTION'] = 'MD2withRSA';
    _algms[PkcsObjectId.md2WithRsaEncryption.id] = 'MD2withRSA';
    _algms[PkcsObjectId.rsaEncryption.id] = 'RSA';
    _algms['SHA1WITHRSA'] = 'SHA-1withRSA';
    _algms['SHA1WITHRSAENCRYPTION'] = 'SHA-1withRSA';
    _algms[PkcsObjectId.sha1WithRsaEncryption.id] = 'SHA-1withRSA';
    _algms['SHA-1WITHRSA'] = 'SHA-1withRSA';
    _algms['SHA256WITHRSA'] = 'SHA-256withRSA';
    _algms['SHA256WITHRSAENCRYPTION'] = 'SHA-256withRSA';
    _algms[PkcsObjectId.sha256WithRsaEncryption.id] = 'SHA-256withRSA';
    _algms['SHA-256WITHRSA'] = 'SHA-256withRSA';
    _algms['SHA1WITHRSAANDMGF1'] = 'SHA-1withRSAandMGF1';
    _algms['SHA-1WITHRSAANDMGF1'] = 'SHA-1withRSAandMGF1';
    _algms['SHA1WITHRSA/PSS'] = 'SHA-1withRSAandMGF1';
    _algms['SHA-1WITHRSA/PSS'] = 'SHA-1withRSAandMGF1';
    _algms['SHA224WITHRSAANDMGF1'] = 'SHA-224withRSAandMGF1';
    _algms['SHA-224WITHRSAANDMGF1'] = 'SHA-224withRSAandMGF1';
    _algms['SHA224WITHRSA/PSS'] = 'SHA-224withRSAandMGF1';
    _algms['SHA-224WITHRSA/PSS'] = 'SHA-224withRSAandMGF1';
    _algms['SHA256WITHRSAANDMGF1'] = 'SHA-256withRSAandMGF1';
    _algms['SHA-256WITHRSAANDMGF1'] = 'SHA-256withRSAandMGF1';
    _algms['SHA256WITHRSA/PSS'] = 'SHA-256withRSAandMGF1';
    _algms['SHA-256WITHRSA/PSS'] = 'SHA-256withRSAandMGF1';
    _algms['SHA384WITHRSA'] = 'SHA-384withRSA';
    _algms['SHA512WITHRSA'] = 'SHA-512withRSA';
    _algms['SHA384WITHRSAENCRYPTION'] = 'SHA-384withRSA';
    _algms[PkcsObjectId.sha384WithRsaEncryption.id] = 'SHA-384withRSA';
    _algms['SHA-384WITHRSA'] = 'SHA-384withRSA';
    _algms['SHA-512WITHRSA'] = 'SHA-512withRSA';
    _algms['SHA384WITHRSAANDMGF1'] = 'SHA-384withRSAandMGF1';
    _algms['SHA-384WITHRSAANDMGF1'] = 'SHA-384withRSAandMGF1';
    _algms['SHA384WITHRSA/PSS'] = 'SHA-384withRSAandMGF1';
    _algms['SHA-384WITHRSA/PSS'] = 'SHA-384withRSAandMGF1';
    _algms['SHA512WITHRSAANDMGF1'] = 'SHA-512withRSAandMGF1';
    _algms['SHA-512WITHRSAANDMGF1'] = 'SHA-512withRSAandMGF1';
    _algms['SHA512WITHRSA/PSS'] = 'SHA-512withRSAandMGF1';
    _algms['SHA-512WITHRSA/PSS'] = 'SHA-512withRSAandMGF1';
    _algms['DSAWITHSHA256'] = 'SHA-256withDSA';
    _algms['DSAWITHSHA-256'] = 'SHA-256withDSA';
    _algms['SHA256/DSA'] = 'SHA-256withDSA';
    _algms['SHA-256/DSA'] = 'SHA-256withDSA';
    _algms['SHA256WITHDSA'] = 'SHA-256withDSA';
    _algms['SHA-256WITHDSA'] = 'SHA-256withDSA';
    _algms[NistObjectIds.dsaWithSHA256.id] = 'SHA-256withDSA';
    _algms['RIPEMD160WITHRSA'] = 'RIPEMD160withRSA';
    _algms['RIPEMD160WITHRSAENCRYPTION'] = 'RIPEMD160withRSA';
    _algms[NistObjectIds.rsaSignatureWithRipeMD160.id] = 'RIPEMD160withRSA';
    _oids['SHA-1withRSA'] = PkcsObjectId.sha1WithRsaEncryption;
    _oids['SHA-256withRSA'] = PkcsObjectId.sha256WithRsaEncryption;
    _oids['SHA-384withRSA'] = PkcsObjectId.sha384WithRsaEncryption;
    _oids['SHA-512withRSA'] = PkcsObjectId.sha512WithRsaEncryption;
    _oids['RIPEMD160withRSA'] = NistObjectIds.rsaSignatureWithRipeMD160;
  }
  //Fields
  final Map<String?, String> _algms = <String?, String>{};
  final Map<String, DerObjectID> _oids = <String, DerObjectID>{};
  //Implementation
  /// Internal method
  ISigner getSigner(String algorithm) {
    ISigner result;
    final String lower = algorithm.toLowerCase();
    String? mechanism = algorithm;
    bool isContinue = true;
    _algms.forEach((String? key, String value) {
      if (isContinue && key!.toLowerCase() == lower) {
        mechanism = _algms[key];
        isContinue = false;
      }
    });
    if (mechanism == 'SHA-1withRSA') {
      result = _RmdSigner(DigestAlgorithms.sha1);
    } else if (mechanism == 'SHA-256withRSA') {
      return _RmdSigner(DigestAlgorithms.sha256);
    } else if (mechanism == 'SHA-384withRSA') {
      return _RmdSigner(DigestAlgorithms.sha384);
    } else if (mechanism == 'SHA-512withRSA') {
      return _RmdSigner(DigestAlgorithms.sha512);
    } else {
      throw ArgumentError.value('Signer $algorithm not recognised.');
    }
    return result;
  }

  /// Internal method
  Future<ISigner> getSignerAsync(String algorithm) async {
    ISigner result;
    final String lower = algorithm.toLowerCase();
    String? mechanism = algorithm;
    bool isContinue = true;
    _algms.forEach((String? key, String value) {
      if (isContinue && key!.toLowerCase() == lower) {
        mechanism = _algms[key];
        isContinue = false;
      }
    });
    if (mechanism == 'SHA-1withRSA') {
      result = _RmdSigner(DigestAlgorithms.sha1);
    } else if (mechanism == 'SHA-256withRSA') {
      return _RmdSigner(DigestAlgorithms.sha256);
    } else if (mechanism == 'SHA-384withRSA') {
      return _RmdSigner(DigestAlgorithms.sha384);
    } else if (mechanism == 'SHA-512withRSA') {
      return _RmdSigner(DigestAlgorithms.sha512);
    } else {
      throw ArgumentError.value('Signer $algorithm not recognised.');
    }
    return result;
  }
}

class _PdfCmsSigner {
  _PdfCmsSigner(ICipherParameter? privateKey, List<X509Certificate?>? certChain,
      String hashAlgorithm, bool hasRSAdata) {
    _digestAlgorithm = MessageDigestAlgorithms();
    _digestAlgorithmOid = _digestAlgorithm.getAllowedDigests(hashAlgorithm);
    if (_digestAlgorithmOid == null) {
      throw ArgumentError.value(
          hashAlgorithm, 'hashAlgorithm', 'Unknown Hash Algorithm');
    }
    _version = 1;
    _signerVersion = 1;
    _digestOid = <String?, Object?>{};
    _digestOid[_digestAlgorithmOid] = null;
    if (certChain != null) {
      _certificates = List<X509Certificate?>.generate(
          certChain.length, (int i) => certChain[i]);
      _signCert = _certificates[0];
    }
    if (privateKey != null) {
      if (privateKey is RsaKeyParam) {
        _encryptionAlgorithmOid = _DigitalIdentifiers.rsa;
      } else {
        throw ArgumentError.value(
            privateKey, 'privateKey', 'Unknown key algorithm');
      }
    }
    if (hasRSAdata) {
      _rsaData = <int>[];
    }
  }

  //Fields
  late MessageDigestAlgorithms _digestAlgorithm;
  late int _version;
  late int _signerVersion;
  late List<X509Certificate?> _certificates;
  late Map<String?, Object?> _digestOid;
  String? _digestAlgorithmOid;
  X509Certificate? _signCert;
  late String _encryptionAlgorithmOid;
  String? _hashAlgorithm;
  List<int>? _rsaData;
  List<int>? _signedData;
  List<int>? _signedRsaData;
  List<int>? _digest;

  //Properties
  String? get hashAlgorithm {
    _hashAlgorithm ??= _digestAlgorithm.getDigest(_digestAlgorithmOid);
    return _hashAlgorithm;
  }

  //Implementation
  DerSet getSequenceDataSet(List<int> secondDigest, List<int>? ocsp,
      List<List<int>>? crlBytes, CryptographicStandard? sigtype) {
    final Asn1EncodeCollection attribute = Asn1EncodeCollection();
    Asn1EncodeCollection v = Asn1EncodeCollection();
    v.encodableObjects.add(DerObjectID(_DigitalIdentifiers.contentType));
    v.encodableObjects.add(DerSet(
        array: <Asn1Encode>[DerObjectID(_DigitalIdentifiers.pkcs7Data)]));
    attribute.encodableObjects.add(DerSequence(collection: v));
    v = Asn1EncodeCollection();
    v.encodableObjects.add(DerObjectID(_DigitalIdentifiers.messageDigest));
    v.encodableObjects.add(DerSet(array: <Asn1Encode>[DerOctet(secondDigest)]));
    attribute.encodableObjects.add(DerSequence(collection: v));
    if (sigtype == CryptographicStandard.cades) {
      v = Asn1EncodeCollection();
      v.encodableObjects
          .add(DerObjectID(_DigitalIdentifiers.aaSigningCertificateV2));
      final Asn1EncodeCollection aaV2 = Asn1EncodeCollection();
      final MessageDigestAlgorithms alg = MessageDigestAlgorithms();
      final String? sha256Oid =
          alg.getAllowedDigests(MessageDigestAlgorithms.secureHash256);
      if (sha256Oid != _digestAlgorithmOid) {
        aaV2.encodableObjects.add(Algorithms(DerObjectID(_digestAlgorithmOid)));
      }
      final List<int> dig = alg
          .getMessageDigest(hashAlgorithm!)
          .convert(_signCert!.c!.getEncoded(Asn1.der))
          .bytes as List<int>;
      aaV2.encodableObjects.add(DerOctet(dig));
      v.encodableObjects.add(DerSet(array: <Asn1Encode>[
        DerSequence.fromObject(
            DerSequence.fromObject(DerSequence(collection: aaV2)))
      ]));
      attribute.encodableObjects.add(DerSequence(collection: v));
    }
    return DerSet(collection: attribute);
  }

  //Implementation
  Future<DerSet> getSequenceDataSetAsync(
      List<int> secondDigest,
      List<int>? ocsp,
      List<List<int>>? crlBytes,
      CryptographicStandard? sigtype) async {
    final Asn1EncodeCollection attribute = Asn1EncodeCollection();
    Asn1EncodeCollection v = Asn1EncodeCollection();
    v.encodableObjects.add(DerObjectID(_DigitalIdentifiers.contentType));
    v.encodableObjects.add(DerSet(
        array: <Asn1Encode>[DerObjectID(_DigitalIdentifiers.pkcs7Data)]));
    attribute.encodableObjects.add(DerSequence(collection: v));
    v = Asn1EncodeCollection();
    v.encodableObjects.add(DerObjectID(_DigitalIdentifiers.messageDigest));
    v.encodableObjects.add(DerSet(array: <Asn1Encode>[DerOctet(secondDigest)]));
    attribute.encodableObjects.add(DerSequence(collection: v));
    if (sigtype == CryptographicStandard.cades) {
      v = Asn1EncodeCollection();
      v.encodableObjects
          .add(DerObjectID(_DigitalIdentifiers.aaSigningCertificateV2));
      final Asn1EncodeCollection aaV2 = Asn1EncodeCollection();
      final MessageDigestAlgorithms alg = MessageDigestAlgorithms();
      await alg
          .getAllowedDigestsAsync(MessageDigestAlgorithms.secureHash256)
          .then((String? sha256Oid) async {
        if (sha256Oid != _digestAlgorithmOid) {
          aaV2.encodableObjects
              .add(Algorithms(DerObjectID(_digestAlgorithmOid)));
        }
        await alg.getMessageDigestAsync(hashAlgorithm!).then((dynamic value) {
          aaV2.encodableObjects.add(DerOctet(value
              .convert(_signCert!.c!.getEncoded(Asn1.der))
              .bytes as List<int>));
          v.encodableObjects.add(DerSet(array: <Asn1Encode>[
            DerSequence.fromObject(
                DerSequence.fromObject(DerSequence(collection: aaV2)))
          ]));
          attribute.encodableObjects.add(DerSequence(collection: v));
        });
      });
    }
    return DerSet(collection: attribute);
  }

  void setSignedData(
      List<int> digest, List<int>? rsaData, String? digestEncryptionAlgorithm) {
    _signedData = digest;
    _signedRsaData = rsaData;
    if (digestEncryptionAlgorithm != null) {
      if (digestEncryptionAlgorithm == 'RSA') {
        _encryptionAlgorithmOid = _DigitalIdentifiers.rsa;
      } else if (digestEncryptionAlgorithm == 'DSA') {
        _encryptionAlgorithmOid = _DigitalIdentifiers.dsa;
      } else if (digestEncryptionAlgorithm == 'ECDSA') {
        _encryptionAlgorithmOid = _DigitalIdentifiers.ecdsa;
      } else {
        throw ArgumentError.value(
            digestEncryptionAlgorithm, 'algorithm', 'Invalid entry');
      }
    }
  }

  Future<void> setSignedDataAsync(List<int> digest, List<int>? rsaData,
      String? digestEncryptionAlgorithm) async {
    _signedData = digest;
    _signedRsaData = rsaData;
    if (digestEncryptionAlgorithm != null) {
      if (digestEncryptionAlgorithm == 'RSA') {
        _encryptionAlgorithmOid = _DigitalIdentifiers.rsa;
      } else if (digestEncryptionAlgorithm == 'DSA') {
        _encryptionAlgorithmOid = _DigitalIdentifiers.dsa;
      } else if (digestEncryptionAlgorithm == 'ECDSA') {
        _encryptionAlgorithmOid = _DigitalIdentifiers.ecdsa;
      } else {
        throw ArgumentError.value(
            digestEncryptionAlgorithm, 'algorithm', 'Invalid entry');
      }
    }
  }

  List<int>? sign(
      List<int> secondDigest,
      TimestampServer? server,
      List<int>? timeStampResponse,
      List<int>? ocsp,
      List<List<int>>? crls,
      CryptographicStandard? sigtype,
      String? hashAlgorithm) {
    if (_signedData != null) {
      _digest = _signedData;
      if (_rsaData != null) {
        _rsaData = _signedRsaData;
      }
    }
    final Asn1EncodeCollection digestAlgorithms = Asn1EncodeCollection();
    final List<String?> keys = _digestOid.keys.toList();
    // ignore: avoid_function_literals_in_foreach_calls
    keys.forEach((String? dal) {
      final Asn1EncodeCollection algos = Asn1EncodeCollection();
      algos.encodableObjects.add(DerObjectID(dal));
      algos.encodableObjects.add(DerNull.value);
      digestAlgorithms.encodableObjects.add(DerSequence(collection: algos));
    });
    Asn1EncodeCollection v = Asn1EncodeCollection();
    v.encodableObjects.add(DerObjectID(_DigitalIdentifiers.pkcs7Data));
    if (_rsaData != null) {
      v.encodableObjects.add(DerTag(0, DerOctet(_rsaData!)));
    }
    final DerSequence contentinfo = DerSequence(collection: v);

    v = Asn1EncodeCollection();
    // ignore: avoid_function_literals_in_foreach_calls
    _certificates.forEach((X509Certificate? xcert) {
      v.encodableObjects.add(
          Asn1Stream(PdfStreamReader(xcert!.c!.getEncoded(Asn1.der)))
              .readAsn1());
    });
    final DerSet dercertificates = DerSet(collection: v);
    final Asn1EncodeCollection signerinfo = Asn1EncodeCollection();
    signerinfo.encodableObjects
        .add(DerInteger(bigIntToBytes(BigInt.from(_signerVersion))));
    v = Asn1EncodeCollection();
    v.encodableObjects
        .add(getIssuer(_signCert!.c!.tbsCertificate!.getEncoded(Asn1.der)));
    v.encodableObjects
        .add(DerInteger(bigIntToBytes(_signCert!.c!.serialNumber!.value)));
    signerinfo.encodableObjects.add(DerSequence(collection: v));
    v = Asn1EncodeCollection();
    v.encodableObjects.add(DerObjectID(_digestAlgorithmOid));
    v.encodableObjects.add(DerNull.value);
    signerinfo.encodableObjects.add(DerSequence(collection: v));
    signerinfo.encodableObjects.add(DerTag(
        0, getSequenceDataSet(secondDigest, ocsp, crls, sigtype), false));
    v = Asn1EncodeCollection();
    v.encodableObjects.add(DerObjectID(_encryptionAlgorithmOid));
    v.encodableObjects.add(DerNull.value);
    signerinfo.encodableObjects.add(DerSequence(collection: v));
    signerinfo.encodableObjects.add(DerOctet(_digest!));
    final Asn1EncodeCollection body = Asn1EncodeCollection();
    body.encodableObjects.add(DerInteger(bigIntToBytes(BigInt.from(_version))));
    body.encodableObjects.add(DerSet(collection: digestAlgorithms));
    body.encodableObjects.add(contentinfo);
    body.encodableObjects.add(DerTag(0, dercertificates, false));
    body.encodableObjects
        .add(DerSet(array: <Asn1Encode>[DerSequence(collection: signerinfo)]));
    final Asn1EncodeCollection whole = Asn1EncodeCollection();
    whole.encodableObjects
        .add(DerObjectID(_DigitalIdentifiers.pkcs7SignedData));
    whole.encodableObjects.add(DerTag(0, DerSequence(collection: body)));
    final Asn1DerStream dout = Asn1DerStream(<int>[]);
    dout.writeObject(DerSequence(collection: whole));
    return dout.stream;
  }

  Asn1EncodeCollection? getAttributes(List<int> timeStampToken) {
    final Asn1Stream tempstream = Asn1Stream(PdfStreamReader(timeStampToken));
    final Asn1EncodeCollection attributes = Asn1EncodeCollection();
    final Asn1EncodeCollection asn1Encode = Asn1EncodeCollection();
    asn1Encode.add(<dynamic>[DerObjectID('1.2.840.113549.1.9.16.2.14')]);
    final Asn1? seq = tempstream.readAsn1();
    if (seq != null && seq is Asn1Sequence) {
      asn1Encode.add(<dynamic>[
        DerSet(array: <Asn1Encode>[seq])
      ]);
      attributes.add(<dynamic>[DerSequence(collection: asn1Encode)]);
    }
    return attributes;
  }

  Future<List<int>?> signAsync(
      List<int> secondDigest,
      TimestampServer? server,
      List<int>? timeStampResponse,
      List<int>? ocsp,
      List<List<int>>? crls,
      CryptographicStandard? sigtype,
      String? hashAlgorithm) async {
    if (_signedData != null) {
      _digest = _signedData;
      if (_rsaData != null) {
        _rsaData = _signedRsaData;
      }
    }
    final Asn1EncodeCollection digestAlgorithms = Asn1EncodeCollection();
    final List<String?> keys = _digestOid.keys.toList();
    // ignore: avoid_function_literals_in_foreach_calls
    keys.forEach((String? dal) {
      final Asn1EncodeCollection algos = Asn1EncodeCollection();
      algos.encodableObjects.add(DerObjectID(dal));
      algos.encodableObjects.add(DerNull.value);
      digestAlgorithms.encodableObjects.add(DerSequence(collection: algos));
    });
    Asn1EncodeCollection v = Asn1EncodeCollection();
    v.encodableObjects.add(DerObjectID(_DigitalIdentifiers.pkcs7Data));
    if (_rsaData != null) {
      v.encodableObjects.add(DerTag(0, DerOctet(_rsaData!)));
    }
    final DerSequence contentinfo = DerSequence(collection: v);

    v = Asn1EncodeCollection();
    // ignore: avoid_function_literals_in_foreach_calls
    _certificates.forEach((X509Certificate? xcert) {
      v.encodableObjects.add(
          Asn1Stream(PdfStreamReader(xcert!.c!.getEncoded(Asn1.der)))
              .readAsn1());
    });
    final DerSet dercertificates = DerSet(collection: v);
    final Asn1EncodeCollection signerinfo = Asn1EncodeCollection();
    signerinfo.encodableObjects
        .add(DerInteger(bigIntToBytes(BigInt.from(_signerVersion))));
    v = Asn1EncodeCollection();
    v.encodableObjects
        .add(getIssuer(_signCert!.c!.tbsCertificate!.getEncoded(Asn1.der)));
    v.encodableObjects
        .add(DerInteger(bigIntToBytes(_signCert!.c!.serialNumber!.value)));
    signerinfo.encodableObjects.add(DerSequence(collection: v));
    v = Asn1EncodeCollection();
    v.encodableObjects.add(DerObjectID(_digestAlgorithmOid));
    v.encodableObjects.add(DerNull.value);
    signerinfo.encodableObjects.add(DerSequence(collection: v));
    signerinfo.encodableObjects.add(DerTag(
        0, getSequenceDataSet(secondDigest, ocsp, crls, sigtype), false));
    v = Asn1EncodeCollection();
    v.encodableObjects.add(DerObjectID(_encryptionAlgorithmOid));
    v.encodableObjects.add(DerNull.value);
    signerinfo.encodableObjects.add(DerSequence(collection: v));
    signerinfo.encodableObjects.add(DerOctet(_digest!));
    if (timeStampResponse == null && server != null) {
      final dynamic output = AccumulatorSink<Digest>();
      final dynamic input = sha256.startChunkedConversion(output);
      input.add(_digest);
      input.close();
      final List<int> hash = output.events.single.bytes as List<int>;
      final List<int> asnEncodedTimestampRequest =
          TimeStampRequestCreator().getAsnEncodedTimestampRequest(hash);
      timeStampResponse = await fetchData(server.uri, 'POST',
          contentType: 'application/timestamp-query',
          userName: server.userName,
          password: server.password,
          data: asnEncodedTimestampRequest,
          timeOutDuration: server.timeOut);
      if (timeStampResponse != null) {
        final Asn1Stream stream =
            Asn1Stream(PdfStreamReader(timeStampResponse));
        final Asn1? asn1 = stream.readAsn1();
        if (asn1 != null &&
            asn1 is Asn1Sequence &&
            asn1.count > 1 &&
            asn1[1] != null &&
            asn1[1] is Asn1) {
          final Asn1 asn1Sequence = asn1[1]! as Asn1;
          final DerStream dOut = DerStream(<int>[]);
          asn1Sequence.encode(dOut);
          timeStampResponse = dOut.stream!.toList();
          dOut.stream!.clear();
        }
      }
    }
    if (timeStampResponse != null) {
      final Asn1EncodeCollection? timeAsn1Encoded =
          getAttributes(timeStampResponse);
      if (timeAsn1Encoded != null) {
        signerinfo.add(
            <dynamic>[DerTag(1, DerSet(collection: timeAsn1Encoded), false)]);
      }
    }
    final Asn1EncodeCollection body = Asn1EncodeCollection();
    body.encodableObjects.add(DerInteger(bigIntToBytes(BigInt.from(_version))));
    body.encodableObjects.add(DerSet(collection: digestAlgorithms));
    body.encodableObjects.add(contentinfo);
    body.encodableObjects.add(DerTag(0, dercertificates, false));
    body.encodableObjects
        .add(DerSet(array: <Asn1Encode>[DerSequence(collection: signerinfo)]));
    final Asn1EncodeCollection whole = Asn1EncodeCollection();
    whole.encodableObjects
        .add(DerObjectID(_DigitalIdentifiers.pkcs7SignedData));
    whole.encodableObjects.add(DerTag(0, DerSequence(collection: body)));
    final Asn1DerStream dout = Asn1DerStream(<int>[]);
    dout.writeObject(DerSequence(collection: whole));
    return dout.stream;
  }

  Asn1? getIssuer(List<int>? data) {
    final Asn1Sequence seq =
        Asn1Stream(PdfStreamReader(data)).readAsn1()! as Asn1Sequence;
    return seq[seq[0] is Asn1Tag ? 3 : 2] as Asn1?;
  }

  /// Internal method
  Future<List<int>?> getEncodedTimestamp(
      List<int> secondDigest, TimestampServer server) async {
    List<int>? encoded;
    final List<int> asnEncodedTimestampRequest =
        TimeStampRequestCreator().getAsnEncodedTimestampRequest(secondDigest);
    final List<int>? respBytes = await fetchData(server.uri, 'POST',
        contentType: 'application/timestamp-query',
        userName: server.userName,
        password: server.password,
        data: asnEncodedTimestampRequest,
        timeOutDuration: server.timeOut);
    if (respBytes != null) {
      final Asn1Stream stream = Asn1Stream(PdfStreamReader(respBytes));
      final Asn1? asn1 = stream.readAsn1();
      if (asn1 != null &&
          asn1 is Asn1Sequence &&
          asn1.count > 1 &&
          asn1[1] != null &&
          asn1[1] is Asn1) {
        final Asn1 asn1Sequence = asn1[1]! as Asn1;
        final DerStream dOut = DerStream(<int>[]);
        asn1Sequence.encode(dOut);
        encoded = dOut.stream!.toList();
        dOut.stream!.clear();
      }
    }
    return encoded;
  }
}

class _DigitalIdentifiers {
  static const String pkcs7Data = '1.2.840.113549.1.7.1';
  static const String pkcs7SignedData = '1.2.840.113549.1.7.2';
  static const String rsa = '1.2.840.113549.1.1.1';
  static const String dsa = '1.2.840.10040.4.1';
  static const String ecdsa = '1.2.840.10045.2.1';
  static const String contentType = '1.2.840.113549.1.9.3';
  static const String messageDigest = '1.2.840.113549.1.9.4';
  static const String aaSigningCertificateV2 = '1.2.840.113549.1.9.16.2.47';
}

class _RandomArray implements IRandom {
  _RandomArray(List<int> array) {
    _array = array;
  }
  //Fields
  late List<int> _array;
  //Properties
  @override
  int get length => _array.length;
  //Implementation
  @override
  int? getValue(int offset, [List<int>? bytes, int? off, int? length]) {
    if (bytes == null) {
      if (offset >= _array.length) {
        return -1;
      }
      return 0xff & _array[offset];
    } else {
      if (offset >= _array.length) {
        return -1;
      }
      if (offset + length! > _array.length) {
        length = (_array.length - offset).toSigned(32);
      }
      List.copyRange(bytes, off!, _array, offset, offset + length);
      return length;
    }
  }
}

class _WindowRandom implements IRandom {
  _WindowRandom(IRandom source, int offset, int length) {
    _source = source;
    _offset = offset;
    _length = length;
  }
  //Fields
  late IRandom _source;
  late int _offset;
  int? _length;
  //Properties
  @override
  int? get length => _length;
  //Implementation
  @override
  int? getValue(int position, [List<int>? bytes, int? off, int? len]) {
    if (position >= _length!) {
      return -1;
    }
    if (bytes == null) {
      return _source.getValue(_offset + position);
    } else {
      final int toRead = min(len!, _length! - position);
      return _source.getValue(_offset + position, bytes, off, toRead);
    }
  }
}

class _RandomGroup implements IRandom {
  _RandomGroup(List<IRandom?> sources) {
    _sources = <_SourceEntry>[];
    int totalSize = 0;
    int i = 0;
    sources.toList().forEach((IRandom? ras) {
      _sources.add(_SourceEntry(i, ras!, totalSize));
      ++i;
      totalSize += ras.length!;
    });
    _size = totalSize;
    _cse = _sources[sources.length - 1];
  }
  //Fields
  late List<_SourceEntry> _sources;
  _SourceEntry? _cse;
  int? _size;
  //Properties
  @override
  int? get length => _size;
  //Implementation
  @override
  int getValue(int position, [List<int>? bytes, int? off, int? len]) {
    _SourceEntry? entry = getEntry(position);
    if (entry == null) {
      return -1;
    }
    int offN = entry.offsetN(position);
    int? remaining = len;
    bool isContinue = true;
    while (isContinue && remaining! > 0) {
      if (entry == null || offN > entry._source.length!) {
        isContinue = false;
      } else {
        final int? count = entry._source.getValue(offN, bytes, off, remaining);
        if (count == -1) {
          isContinue = false;
        } else {
          off = off! + count!;
          position += count;
          remaining -= count;
          offN = 0;
          entry = getEntry(position);
        }
      }
    }
    return remaining == len ? -1 : len! - remaining!;
  }

  int? getStartIndex(int offset) {
    if (offset >= _cse!._startByte) {
      return _cse!._index;
    }
    return 0;
  }

  _SourceEntry? getEntry(int offset) {
    if (offset >= _size!) {
      return null;
    }
    if (offset >= _cse!._startByte && offset <= _cse!._endByte) {
      return _cse;
    }
    final int startAt = getStartIndex(offset)!;
    for (int i = startAt; i < _sources.length; i++) {
      if (offset >= _sources[i]._startByte && offset <= _sources[i]._endByte) {
        _cse = _sources[i];
        return _cse;
      }
    }
    return null;
  }
}

class _SourceEntry {
  _SourceEntry(int index, IRandom source, int offset) {
    _index = index;
    _source = source;
    _startByte = offset;
    _endByte = offset + source.length! - 1;
  }
  //Fields
  late IRandom _source;
  late int _startByte;
  late int _endByte;
  int? _index;
  //Implementation
  int offsetN(int absoluteOffset) {
    return absoluteOffset - _startByte;
  }
}

class _RandomStream extends PdfStreamReader {
  _RandomStream(IRandom source)
      : super(List<int>.generate(source.length!, (int i) => 0)) {
    _random = source;
  }
  //Fields
  late IRandom _random;
  @override
  int position = 0;
  //Properties
  @override
  int? get length => _random.length;

  //Implementation
  @override
  int? read(List<int> buffer, int offset, int length) {
    final int? count = _random.getValue(position, buffer, offset, length);
    if (count == -1) {
      return 0;
    }
    position += count!;
    return count;
  }

  @override
  int readByte() {
    final int c = _random.getValue(position)!;
    if (c >= 0) {
      ++position;
    }
    return c;
  }
}

class _RmdSigner implements ISigner {
  _RmdSigner(String digest) {
    _digest = getDigest(digest);
    _output = AccumulatorSink<Digest>();
    _input = _digest.startChunkedConversion(_output);
    _rsaEngine = Pkcs1Encoding(RsaAlgorithm());
    _id = Algorithms(map![digest], DerNull.value);
  }
  Map<String, DerObjectID>? _map;
  late ICipherBlock _rsaEngine;
  Algorithms? _id;
  late dynamic _digest;
  late dynamic _output;
  dynamic _input;
  late bool _isSigning;
  //Properties
  Map<String, DerObjectID>? get map {
    if (_map == null) {
      _map = <String, DerObjectID>{};
      _map![DigestAlgorithms.sha1] = X509Objects.idSha1;
      _map![DigestAlgorithms.sha256] = NistObjectIds.sha256;
      _map![DigestAlgorithms.sha384] = NistObjectIds.sha384;
      _map![DigestAlgorithms.sha512] = NistObjectIds.sha512;
    }
    return _map;
  }

  dynamic getDigest(String digest) {
    dynamic result;
    if (digest == DigestAlgorithms.sha1) {
      result = sha1;
    } else if (digest == DigestAlgorithms.sha256) {
      result = sha256;
    } else if (digest == DigestAlgorithms.sha384) {
      result = sha384;
    } else if (digest == DigestAlgorithms.sha512) {
      result = sha512;
    } else {
      throw ArgumentError.value(digest, 'digest', 'Invalid digest');
    }
    return result;
  }

  @override
  void initialize(bool isSigning, ICipherParameter? parameters) {
    _isSigning = isSigning;
    final CipherParameter? k = parameters as CipherParameter?;
    if (isSigning && !k!.isPrivate!) {
      throw ArgumentError.value('Private key required.');
    }
    if (!isSigning && k!.isPrivate!) {
      throw ArgumentError.value('Public key required.');
    }
    reset();
    _rsaEngine.initialize(isSigning, parameters);
  }

  @override
  void blockUpdate(List<int> input, int inOff, int length) {
    _input.add(input.sublist(inOff, inOff + length));
  }

  @override
  List<int>? generateSignature() {
    if (!_isSigning) {
      throw ArgumentError.value('Invalid entry');
    }
    _input.close();
    final List<int>? hash = _output.events.single.bytes as List<int>?;
    final List<int> data = derEncode(hash)!;
    return _rsaEngine.processBlock(data, 0, data.length);
  }

  @override
  bool validateSignature(List<int> signature) {
    if (_isSigning) {
      throw Exception('Invalid entry');
    }
    _input.close();
    final List<int>? hash = _output.events.single.bytes as List<int>?;
    List<int> sig;
    List<int> expected;
    try {
      sig = _rsaEngine.processBlock(signature, 0, signature.length)!;
      expected = derEncode(hash)!;
    } catch (e) {
      return false;
    }
    if (sig.length == expected.length) {
      for (int i = 0; i < sig.length; i++) {
        if (sig[i] != expected[i]) {
          return false;
        }
      }
    } else if (sig.length == expected.length - 2) {
      final int sigOffset = sig.length - hash!.length - 2;
      final int expectedOffset = expected.length - hash.length - 2;
      expected[1] -= 2;
      expected[3] -= 2;
      for (int i = 0; i < hash.length; i++) {
        if (sig[sigOffset + i] != expected[expectedOffset + i]) {
          return false;
        }
      }
      for (int i = 0; i < sigOffset; i++) {
        if (sig[i] != expected[i]) {
          return false;
        }
      }
    } else {
      return false;
    }
    return true;
  }

  List<int>? derEncode(List<int>? hash) {
    if (_id == null) {
      return hash;
    }
    return DigestInformation(_id, hash).getDerEncoded();
  }

  @override
  void reset() {
    _output = AccumulatorSink<Digest>();
    _input = _digest.startChunkedConversion(_output);
  }
}

// ignore: avoid_classes_with_only_static_members
/// internal class
class NistObjectIds {
  // ignore: public_member_api_docs
  static DerObjectID nistAlgorithm = DerObjectID('2.16.840.1.101.3.4');
  // ignore: public_member_api_docs
  static DerObjectID hashAlgs = DerObjectID('${nistAlgorithm.id!}.2');
  // ignore: public_member_api_docs
  static DerObjectID sha256 = DerObjectID('${hashAlgs.id!}.1');
  // ignore: public_member_api_docs
  static DerObjectID sha384 = DerObjectID('${hashAlgs.id!}.2');
  // ignore: public_member_api_docs
  static DerObjectID sha512 = DerObjectID('${hashAlgs.id!}.3');
  // ignore: public_member_api_docs
  static DerObjectID dsaWithSHA2 = DerObjectID('${nistAlgorithm.id!}.3');
  // ignore: public_member_api_docs
  static DerObjectID dsaWithSHA256 = DerObjectID('${dsaWithSHA2.id!}.2');
  // ignore: public_member_api_docs
  static DerObjectID tttAlgorithm = DerObjectID('1.3.36.3');
  // ignore: public_member_api_docs
  static DerObjectID ripeMD160 = DerObjectID('${tttAlgorithm.id!}.2.1');
  // ignore: public_member_api_docs
  static DerObjectID tttRsaSignatureAlgorithm =
      DerObjectID('${tttAlgorithm.id!}.3.1');
  // ignore: public_member_api_docs
  static DerObjectID rsaSignatureWithRipeMD160 =
      DerObjectID('${tttRsaSignatureAlgorithm.id!}.2');
}

/// internal type definition
typedef DocumentSavedHandler = void Function(
    Object sender, DocumentSavedArgs args);

/// internal type definition
typedef DocumentSavedHandlerAsync = Future<void> Function(
    Object sender, DocumentSavedArgs args);

/// internal class
class DocumentSavedArgs {
  /// internal constructor
  DocumentSavedArgs(IPdfWriter writer) {
    _writer = writer;
  }

  //Fields
  IPdfWriter? _writer;

  //Properties
  /// internal property
  IPdfWriter? get writer => _writer;
}
