part of pdf;

/// Represents signature dictionary.
class _PdfSignatureDictionary implements _IPdfWrapper {
  //Constructors
  _PdfSignatureDictionary(PdfDocument doc, PdfSignature sig) {
    _doc = doc;
    _sig = sig;
    doc._documentSavedList ??= [];
    doc._documentSavedList!.add(_documentSaved);
    _dictionary._beginSaveList ??= [];
    _dictionary._beginSaveList!.add(_dictionaryBeginSave);
    _cert = sig.certificate;
  }

  _PdfSignatureDictionary._fromDictionary(PdfDocument doc, _PdfDictionary dic) {
    _doc = doc;
    _dictionary = dic;
    doc._documentSavedList ??= [];
    doc._documentSavedList!.add(_documentSaved);
    _dictionary._beginSaveList ??= [];
    _dictionary._beginSaveList!.add(_dictionaryBeginSave);
  }

  //Fields
  late PdfDocument _doc;
  PdfSignature? _sig;
  _PdfDictionary _dictionary = _PdfDictionary();
  final String _transParam = 'TransformParams';
  final String _docMdp = 'DocMDP';
  final String _cmsFilterType = 'adbe.pkcs7.detached';
  final String _cadasFilterType = 'ETSI.CAdES.detached';
  int? _firstRangeLength;
  int? _secondRangeIndex;
  int? _startPositionByteRange;
  int _estimatedSize = 8192;
  PdfCertificate? _cert;
  late List<int> _range;
  List<int>? _stream;

  //Implementations
  void _dictionaryBeginSave(Object sender, _SavePdfPrimitiveArgs? args) {
    final bool state = _doc.security._encryptor.encrypt;
    _dictionary.encrypt = state;
    if (_sig != null) {
      _addRequiredItems();
      _addOptionalItems();
    }
    _doc.security._encryptor.encrypt = false;
    _addContents(args!.writer!);
    _addRange(args.writer!);
    if (_sig != null) {
      if (_sig!._certificated) {
        _addDigest(args.writer);
      }
    }
    _doc.security._encryptor.encrypt = state;
  }

  void _addRequiredItems() {
    if (_sig!._certificated && _allowMDP()) {
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
        _dictionary.setProperty(
            _DictionaryProperties.reason, _PdfString(_sig!.reason!));
      }
      if (_sig!.locationInfo != null) {
        _dictionary.setProperty(
            _DictionaryProperties.location, _PdfString(_sig!.locationInfo!));
      }
      if (_sig!.contactInfo != null) {
        _dictionary.setProperty(
            _DictionaryProperties.contactInfo, _PdfString(_sig!.contactInfo!));
      }
      if (_sig!.signedName != null) {
        _dictionary._setString(_DictionaryProperties.name, _sig!.signedName);
        final _PdfDictionary dictionary = _PdfDictionary();
        final _PdfDictionary appDictionary = _PdfDictionary();
        dictionary._setName(
            _PdfName(_DictionaryProperties.name), _sig!.signedName);
        appDictionary.setProperty('App', _PdfReferenceHolder(dictionary));
        _dictionary.setProperty(
            _PdfName('Prop_Build'), _PdfReferenceHolder(appDictionary));
      }
    }
  }

  bool _allowMDP() {
    final _IPdfPrimitive? perms =
        _PdfCrossTable._dereference(_doc._catalog[_DictionaryProperties.perms]);
    if (perms != null && perms is _PdfDictionary) {
      final _IPdfPrimitive? docMDP =
          _PdfCrossTable._dereference(perms[_DictionaryProperties.docMDP]);
      final _IPdfPrimitive dicSig = _dictionary;
      return dicSig == docMDP;
    }
    return false;
  }

  void _addReference() {
    final _PdfDictionary trans = _PdfDictionary();
    final _PdfDictionary reference = _PdfDictionary();
    final _PdfArray array = _PdfArray();
    trans[_DictionaryProperties.v] = _PdfName('1.2');
    trans[_DictionaryProperties.p] =
        _PdfNumber(_sig!._getCertificateFlagResult(_sig!.documentPermissions));
    trans[_DictionaryProperties.type] = _PdfName(_transParam);
    reference[_DictionaryProperties.transformMethod] = _PdfName(_docMdp);
    reference[_DictionaryProperties.type] = _PdfName('SigRef');
    reference[_transParam] = trans;
    array._add(reference);
    _dictionary.setProperty('Reference', array);
  }

  void _addType() {
    _dictionary._setName(_PdfName(_DictionaryProperties.type), 'Sig');
  }

  void _addDate() {
    final DateTime dateTime = DateTime.now();
    final DateFormat dateFormat = DateFormat('yyyyMMddHHmmss');
    final int regionMinutes = dateTime.timeZoneOffset.inMinutes ~/ 11;
    String offsetMinutes = regionMinutes.toString();
    if (regionMinutes >= 0 && regionMinutes <= 9) {
      offsetMinutes = '0' + offsetMinutes;
    }
    final int regionHours = dateTime.timeZoneOffset.inHours;
    String offsetHours = regionHours.toString();
    if (regionHours >= 0 && regionHours <= 9) {
      offsetHours = '0' + offsetHours;
    }
    _dictionary.setProperty(
        _DictionaryProperties.m,
        _PdfString(
            "D:${dateFormat.format(dateTime)}+$offsetHours'$offsetMinutes'"));
  }

  void _addFilter() {
    _dictionary._setName(
        _PdfName(_DictionaryProperties.filter), 'Adobe.PPKLite');
  }

  void _addSubFilter() {
    _dictionary._setName(
        _PdfName(_DictionaryProperties.subFilter),
        _sig!.cryptographicStandard == CryptographicStandard.cades
            ? _cadasFilterType
            : _cmsFilterType);
  }

  void _addContents(_IPdfWriter writer) {
    writer._write(_Operators.slash +
        _DictionaryProperties.contents +
        _Operators.whiteSpace);
    _firstRangeLength = writer._position;
    int length = _estimatedSize * 2;
    if (_sig != null && _cert != null) {
      length = _estimatedSize;
    }
    final List<int> contents =
        List<int>.filled(length * 2 + 2, 0, growable: true);
    writer._write(contents);
    _secondRangeIndex = writer._position;
    writer._write(_Operators.newLine);
  }

  void _addRange(_IPdfWriter writer) {
    writer._write(_Operators.slash +
        _DictionaryProperties.byteRange +
        _Operators.whiteSpace +
        _PdfArray.startMark);
    _startPositionByteRange = writer._position;
    for (int i = 0; i < 32; i++) {
      writer._write(_Operators.whiteSpace);
    }
    writer._write(_PdfArray.endMark + _Operators.newLine);
  }

  void _addDigest(_IPdfWriter? writer) {
    if (_allowMDP()) {
      final _PdfDictionary? cat = writer!._document!._catalog;
      writer._write(_PdfName(_DictionaryProperties.reference));
      writer._write(_PdfArray.startMark);
      writer._write('<<');
      writer._write(_Operators.slash + _transParam);
      _PdfDictionary trans = _PdfDictionary();
      trans[_DictionaryProperties.v] = _PdfName('1.2');
      trans[_DictionaryProperties.p] = _PdfNumber(
          _sig!._getCertificateFlagResult(_sig!.documentPermissions));
      trans[_DictionaryProperties.type] = _PdfName(_transParam);
      writer._write(trans);
      writer._write(_PdfName(_DictionaryProperties.transformMethod));
      writer._write(_PdfName(_docMdp));
      writer._write(_PdfName(_DictionaryProperties.type));
      writer._write(_PdfName(_DictionaryProperties.sigRef));
      writer._write(_PdfName('DigestValue'));
      int position = writer._position!;
      // _docDigestPosition = position;
      writer._write(
          _PdfString.fromBytes(List<int>.filled(16, 0, growable: true)));
      _PdfArray digestLocation = _PdfArray();
      digestLocation._add(_PdfNumber(position));
      digestLocation._add(_PdfNumber(34));
      writer._write(_PdfName('DigestLocation'));
      writer._write(digestLocation);
      writer._write(_PdfName('DigestMethod'));
      writer._write(_PdfName('MD5'));
      writer._write(_PdfName(_DictionaryProperties.data));
      final _PdfReferenceHolder refh = _PdfReferenceHolder(cat);
      writer._write(_Operators.whiteSpace);
      writer._write(refh);
      writer._write('>>');
      writer._write('<<');
      writer._write(_PdfName(_transParam));
      trans = _PdfDictionary();
      trans[_DictionaryProperties.v] = _PdfName('1.2');
      final _PdfArray fields = _PdfArray();
      fields._add(_PdfString(_sig!._field!.name!));
      trans[_DictionaryProperties.fields] = fields;
      trans[_DictionaryProperties.type] = _PdfName(_transParam);
      trans[_DictionaryProperties.action] = _PdfName('Include');
      writer._write(trans);
      writer._write(_PdfName(_DictionaryProperties.transformMethod));
      writer._write(_PdfName('FieldMDP'));
      writer._write(_PdfName(_DictionaryProperties.type));
      writer._write(_PdfName(_DictionaryProperties.sigRef));
      writer._write(_PdfName('DigestValue'));
      position = writer._position!;
      // _fieldsDigestPosition = position;
      writer._write(
          _PdfString.fromBytes(List<int>.filled(16, 0, growable: true)));
      digestLocation = _PdfArray();
      digestLocation._add(_PdfNumber(position));
      digestLocation._add(_PdfNumber(34));
      writer._write(_PdfName('DigestLocation'));
      writer._write(digestLocation);
      writer._write(_PdfName('DigestMethod'));
      writer._write(_PdfName('MD5'));
      writer._write(_PdfName(_DictionaryProperties.data));
      writer._write(_Operators.whiteSpace);
      writer._write(_PdfReferenceHolder(cat));
      writer._write('>>');
      writer._write(_PdfArray.endMark);
      writer._write(_Operators.whiteSpace);
    }
  }

  void _documentSaved(Object sender, _DocumentSavedArgs e) {
    final bool enabled = _doc.security._encryptor.encrypt;
    _doc.security._encryptor.encrypt = false;
    final _PdfWriter writer = e.writer as _PdfWriter;
    final int number = e.writer!._length! - _secondRangeIndex!;
    final String str = '0 ';
    final String str2 = _firstRangeLength.toString() + ' ';
    final String str3 = _secondRangeIndex.toString() + ' ';
    final String str4 = number.toString();
    int startPosition = _saveRangeItem(writer, str, _startPositionByteRange!);
    startPosition = _saveRangeItem(writer, str2, startPosition);
    startPosition = _saveRangeItem(writer, str3, startPosition);
    _saveRangeItem(e.writer as _PdfWriter, str4, startPosition);
    _range = <int>[0, int.parse(str2), int.parse(str3), int.parse(str4)];
    _stream = writer._buffer;
    final String text = _PdfString._bytesToHex(getPkcs7Content()!);
    _stream!.replaceRange(
        _firstRangeLength!, _firstRangeLength! + 1, utf8.encode('<'));
    final int newPos = _firstRangeLength! + 1 + text.length;
    _stream!.replaceRange(_firstRangeLength! + 1, newPos, utf8.encode(text));
    final int num3 = (_secondRangeIndex! - newPos) ~/ 2;
    final String emptyText =
        _PdfString._bytesToHex(List<int>.generate(num3, (i) => 0));
    _stream!.replaceRange(
        newPos, newPos + emptyText.length, utf8.encode(emptyText));
    _stream!.replaceRange(newPos + emptyText.length,
        newPos + emptyText.length + 1, utf8.encode('>'));
    _doc.security._encryptor.encrypt = enabled;
  }

  List<int>? getPkcs7Content() {
    String? hasalgorithm = '';
    _SignaturePrivateKey externalSignature;
    List<List<int>>? crlBytes;
    List<int>? ocspByte;
    List<_X509Certificate?>? chain = <_X509Certificate?>[];
    final IPdfExternalSigner? externalSigner = _sig!._externalSigner;
    if (externalSigner != null && _sig!._externalChain != null) {
      chain = _sig!._externalChain;
      final String digest = getDigestAlgorithm(externalSigner.hashAlgorithm);
      final _SignaturePrivateKey pks = _SignaturePrivateKey(digest);
      hasalgorithm = pks.getHashAlgorithm();
      externalSignature = pks;
    } else {
      String certificateAlias = '';
      final List<String> keys =
          _cert!._pkcsCertificate.getContentTable().keys.toList();
      bool isContinue = true;
      keys.forEach((key) {
        if (isContinue &&
            _cert!._pkcsCertificate.isKey(key) &&
            _cert!._pkcsCertificate.getKey(key)!._key!.isPrivate!) {
          certificateAlias = key;
          isContinue = false;
        }
      });
      final _KeyEntry pk = _cert!._pkcsCertificate.getKey(certificateAlias)!;
      final List<_X509Certificates> certificates =
          _cert!._pkcsCertificate.getCertificateChain(certificateAlias)!;
      certificates.forEach((c) {
        chain!.add(c.certificate);
      });
      final _RsaPrivateKeyParam? parameters = pk._key as _RsaPrivateKeyParam?;
      final String digest = _sig != null
          ? getDigestAlgorithm(_sig!.digestAlgorithm)
          : _MessageDigestAlgorithms.secureHash256;
      final _SignaturePrivateKey pks = _SignaturePrivateKey(digest, parameters);
      hasalgorithm = pks.getHashAlgorithm();
      externalSignature = pks;
    }
    final _PdfCmsSigner pkcs7 =
        _PdfCmsSigner(null, chain!, hasalgorithm!, false);
    final _IRandom source = getUnderlyingSource();
    final List<_IRandom?> sources =
        List<_IRandom?>.generate(_range.length ~/ 2, (i) => null);
    for (int j = 0; j < _range.length; j += 2) {
      sources[j ~/ 2] = _WindowRandom(source, _range[j], _range[j + 1]);
    }
    final _StreamReader data = _RandomStream(_RandomGroup(sources));
    final List<int> hash = pkcs7._digestAlgorithm.digest(data, hasalgorithm)!;
    final List<int>? sh = pkcs7
        .getSequenceDataSet(
            hash, ocspByte, crlBytes, _sig!.cryptographicStandard)
        .getEncoded(_Asn1Constants.der);
    List<int>? extSignature;
    if (externalSigner != null) {
      final SignerResult? signerResult = externalSigner.sign(sh!);
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
    return pkcs7.sign(hash, null, null, ocspByte, crlBytes,
        _sig!.cryptographicStandard, hasalgorithm);
  }

  _IRandom getUnderlyingSource() {
    return _RandomArray(_stream!.sublist(0));
  }

  String getDigestAlgorithm(DigestAlgorithm? digest) {
    String digestAlgorithm;
    switch (digest) {
      case DigestAlgorithm.sha1:
        digestAlgorithm = _MessageDigestAlgorithms.secureHash1;
        break;
      case DigestAlgorithm.sha384:
        digestAlgorithm = _MessageDigestAlgorithms.secureHash384;
        break;
      case DigestAlgorithm.sha512:
        digestAlgorithm = _MessageDigestAlgorithms.secureHash512;
        break;
      default:
        digestAlgorithm = _MessageDigestAlgorithms.secureHash256;
        break;
    }
    return digestAlgorithm;
  }

  int _saveRangeItem(_PdfWriter writer, String str, int startPosition) {
    final List<int> date = utf8.encode(str);
    writer._buffer!
        .replaceRange(startPosition, startPosition + date.length, date);
    return startPosition + str.length;
  }

  //Overrides
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError('Primitive element can\'t be set');
  }
}

class _MessageDigestAlgorithms {
  _MessageDigestAlgorithms() {
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
    _algorithms[_DerObjectID('1.3.14.3.2.26')._id] = 'SHA-1';
    _algorithms['SHA256'] = 'SHA-256';
    _algorithms[_NistObjectIds.sha256._id] = 'SHA-256';
    _algorithms["SHA384"] = 'SHA-384';
    _algorithms[_NistObjectIds.sha384._id] = 'SHA-384';
    _algorithms["SHA512"] = 'SHA-512';
    _algorithms[_NistObjectIds.sha512._id] = 'SHA-512';
    _algorithms["MD5"] = 'MD5';
    _algorithms[_PkcsObjectId.md5._id] = 'MD5';
    _algorithms["RIPEMD-160"] = 'RIPEMD160';
    _algorithms["RIPEMD160"] = 'RIPEMD160';
    _algorithms[_NistObjectIds.ripeMD160._id] = 'RIPEMD160';
  }
  static const String secureHash1 = 'SHA-1';
  static const String secureHash256 = 'SHA-256';
  static const String secureHash384 = 'SHA-384';
  static const String secureHash512 = 'SHA-512';
  late Map<String, String> _names;
  late Map<String, String> _digests;
  late Map<String?, String> _algorithms;
  String? getDigest(String? id) {
    String? result;
    if (_names.containsKey(id)) {
      result = _names[id!];
    } else {
      result = id;
    }
    return result;
  }

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

  List<int>? digest(_StreamReader data, dynamic hashAlgorithm) {
    dynamic algorithm;
    if (hashAlgorithm is String) {
      algorithm = getMessageDigest(hashAlgorithm);
    } else {
      algorithm = hashAlgorithm;
    }
    final dynamic output = AccumulatorSink<Digest>();
    final dynamic input = algorithm.startChunkedConversion(output);
    int? count;
    final List<int> bytes = List<int>.generate(8192, (i) => 0);
    while ((count = data.read(bytes, 0, bytes.length))! > 0) {
      input.add(bytes.sublist(0, count));
    }
    input.close();
    return output.events.single.bytes;
  }
}
