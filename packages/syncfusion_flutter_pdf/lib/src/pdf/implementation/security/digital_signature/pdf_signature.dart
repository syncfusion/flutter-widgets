import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../../../interfaces/pdf_interface.dart';
import '../../forms/pdf_field.dart';
import '../../forms/pdf_signature_field.dart';
import '../../io/pdf_constants.dart';
import '../../io/pdf_cross_table.dart';
import '../../io/stream_reader.dart';
import '../../pages/pdf_page.dart';
import '../../pdf_document/pdf_document.dart';
import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_name.dart';
import '../../primitives/pdf_reference_holder.dart';
import '../../primitives/pdf_stream.dart';
import '../../primitives/pdf_string.dart';
import '../enum.dart';
import '../pdf_security.dart';
import 'asn1/asn1.dart';
import 'asn1/asn1_stream.dart';
import 'asn1/der.dart';
import 'pdf_certificate.dart';
import 'pdf_external_signer.dart';
import 'pdf_signature_dictionary.dart';
import 'time_stamp_server/time_stamp_server.dart';
import 'x509/ocsp_utils.dart';
import 'x509/x509_certificates.dart';

/// Represents a digital signature used for signing a PDF document.
class PdfSignature {
  //Constructor
  /// Initializes a new instance of the [PdfSignature] class with the page and the signature name.
  PdfSignature(
      {String? signedName,
      String? locationInfo,
      String? reason,
      String? contactInfo,
      List<PdfCertificationFlags>? documentPermissions,
      CryptographicStandard cryptographicStandard = CryptographicStandard.cms,
      DigestAlgorithm digestAlgorithm = DigestAlgorithm.sha256,
      PdfCertificate? certificate,
      TimestampServer? timestampServer,
      DateTime? signedDate}) {
    _helper = PdfSignatureHelper(this);
    _init(
        signedName,
        locationInfo,
        reason,
        contactInfo,
        documentPermissions,
        cryptographicStandard,
        digestAlgorithm,
        certificate,
        signedDate,
        timestampServer);
  }

  //Fields
  late PdfSignatureHelper _helper;
  List<List<int>>? _externalRootCert;

  //Properties
  /// Gets or sets the permission for certificated document.
  List<PdfCertificationFlags> documentPermissions = <PdfCertificationFlags>[
    PdfCertificationFlags.forbidChanges
  ];

  /// Gets or sets reason of signing.
  String? reason;

  /// Gets or sets the physical location of the signing.
  String? locationInfo;

  /// Gets or sets the signed name
  String? signedName;

  /// Gets or sets the signed date.
  ///
  /// NOTE: The signed date can only be set when signing the PDF document and does not work on existing signatures.
  DateTime? get signedDate => _helper.dateOfSign;

  set signedDate(DateTime? value) {
    _helper.dateOfSign = value;
  }

  /// Gets or sets cryptographic standard.
  late CryptographicStandard cryptographicStandard;

  /// Gets or sets digestion algorithm.
  late DigestAlgorithm digestAlgorithm;

  /// Gets or sets information provided by the signer to enable a recipient to contact
  /// the signer to verify the signature; for example, a phone number.
  String? contactInfo;

  /// Gets or sets the certificate
  PdfCertificate? certificate;

  /// Gets or sets time stamping server unique resource identifier.
  ///
  /// The timestamp is only embedded when signing the PDF document and
  /// saving asynchronously.
  ///
  /// ```dart
  /// //Creates a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Adds a new page
  /// PdfPage page = document.pages.add();
  /// //Creates a digital signature and sets signature information
  /// PdfSignatureField field = PdfSignatureField(page, 'signature',
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100),
  ///     signature: PdfSignature(
  ///         //Creates a certificate instance from the PFX file with a private key
  ///         certificate: PdfCertificate(
  ///             File('D:/PDF.pfx').readAsBytesSync(), 'syncfusion'),
  ///         contactInfo: 'johndoe@owned.us',
  ///         locationInfo: 'Honolulu, Hawaii',
  ///         reason: 'I am author of this document.',
  ///         //Create a new PDF time stamp server
  ///         timestampServer:
  ///             TimestampServer(Uri.parse('http://syncfusion.digistamp.com'))));
  /// //Add a signature field to the form
  /// document.form.fields.add(field);
  /// //Save and dispose the PDF document
  /// File('Output.pdf').writeAsBytes(await document.save());
  /// document.dispose();
  /// ```
  TimestampServer? timestampServer;

  //Implementations
  void _init(
      String? signedName,
      String? locationInfo,
      String? reason,
      String? contactInfo,
      List<PdfCertificationFlags>? documentPermissions,
      CryptographicStandard cryptographicStandard,
      DigestAlgorithm digestAlgorithm,
      PdfCertificate? pdfCertificate,
      DateTime? signedDate,
      TimestampServer? timestampServer) {
    this.cryptographicStandard = cryptographicStandard;
    this.digestAlgorithm = digestAlgorithm;
    if (signedName != null) {
      this.signedName = signedName;
    }
    if (locationInfo != null) {
      this.locationInfo = locationInfo;
    }
    if (reason != null) {
      this.reason = reason;
    }
    if (contactInfo != null) {
      this.contactInfo = contactInfo;
    }
    if (documentPermissions != null && documentPermissions.isNotEmpty) {
      this.documentPermissions = documentPermissions;
    }
    if (pdfCertificate != null) {
      certificate = pdfCertificate;
    }
    if (signedDate != null) {
      this.signedDate = signedDate;
    }
    if (timestampServer != null) {
      this.timestampServer = timestampServer;
    }
  }

  /// Add external signer for signature.
  void addExternalSigner(
      IPdfExternalSigner signer, List<List<int>> publicCertificatesData) {
    _helper.externalSigner = signer;
    _externalRootCert = publicCertificatesData;
    if (_externalRootCert != null) {
      final X509CertificateParser parser = X509CertificateParser();
      _helper.externalChain = <X509Certificate?>[];
      _externalRootCert!.toList().forEach((List<int> certRawData) => _helper
          .externalChain!
          .add(parser.readCertificate(PdfStreamReader(certRawData))));
    }
  }

  /// Creates long-term validation of the signature.
  ///
  /// ``` dart
  /// // Load the existing PDF document.
  /// PdfDocument document =
  ///     PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());
  /// // Create a new PDF document.
  /// PdfSignatureField field = document.form.fields[0] as PdfSignatureField;
  /// // Check if field is signed.
  /// if (field.isSigned) {
  ///   // Create a long-term validation for the signature.
  ///   bool isLTV = await field.signature!
  ///       .createLongTermValidity(includePublicCertificates: true);
  /// }
  /// // Save the document.
  /// List<int> bytes = await document.save();
  /// // Dispose the document.
  /// document.dispose();
  /// ```
  Future<bool> createLongTermValidity(
      {List<List<int>>? publicCertificatesData,
      RevocationType type = RevocationType.ocspAndCrl,
      bool includePublicCertificates = false}) async {
    final List<X509Certificate> x509CertificateList = <X509Certificate>[];
    if (publicCertificatesData != null) {
      final X509CertificateParser parser = X509CertificateParser();
      for (final List<int> certRawData in publicCertificatesData) {
        final X509Certificate certificate =
            parser.readCertificate(PdfStreamReader(certRawData))!;
        x509CertificateList.add(certificate);
      }
    } else {
      final List<X509Certificate?>? certChain = timestampServer != null
          ? await _helper.getTimestampCertificateChain()
          : _helper.getCertificateChain();
      if (certChain != null) {
        for (final X509Certificate? certificate in certChain) {
          if (certificate != null) {
            x509CertificateList.add(certificate);
          }
        }
        certChain.clear();
      }
    }
    if (x509CertificateList.isNotEmpty) {
      return _helper.getDSSDetails(
          x509CertificateList, type, includePublicCertificates);
    } else {
      return false;
    }
  }
}

/// [PdfSignature] helper
class PdfSignatureHelper {
  /// internal constructor
  PdfSignatureHelper(this.base);

  /// internal field
  PdfSignature base;

  /// internal method
  static PdfSignatureHelper getHelper(PdfSignature signature) {
    return signature._helper;
  }

  /// internal field
  PdfPage? page;

  /// internal method
  PdfSignatureField? field;

  /// internal method
  PdfDocument? document;

  /// internal method
  // ignore: prefer_final_fields
  bool certificated = false;

  /// internal method
  PdfSignatureDictionary? signatureDictionary;

  /// internal method
  PdfArray? byteRange;

  /// internal method
  DateTime? dateOfSign;

  /// internal method
  IPdfExternalSigner? externalSigner;

  /// internal method
  List<X509Certificate?>? externalChain;
  List<int>? _nameData;

  /// internal method
  /// To check annotation last elements have signature field
  void checkAnnotationElementsContainsSignature(
      PdfPage page, String? signatureName) {
    if (PdfPageHelper.getHelper(page)
        .dictionary!
        .containsKey(PdfDictionaryProperties.annots)) {
      final IPdfPrimitive? annotationElements = PdfCrossTable.dereference(
          PdfPageHelper.getHelper(page)
              .dictionary![PdfDictionaryProperties.annots]);
      IPdfPrimitive? lastElement;
      if (annotationElements != null &&
          annotationElements is PdfArray &&
          annotationElements.elements.isNotEmpty) {
        lastElement = PdfCrossTable.dereference(
            annotationElements[annotationElements.elements.length - 1]);
      }
      if (lastElement != null &&
          lastElement is PdfDictionary &&
          lastElement.containsKey(PdfDictionaryProperties.t)) {
        final IPdfPrimitive? name =
            PdfCrossTable.dereference(lastElement[PdfDictionaryProperties.t]);
        String tempName = '';
        if (name != null && name is PdfString) {
          tempName = utf8.decode(name.data!);
        }
        if (tempName == signatureName &&
            annotationElements != null &&
            annotationElements is PdfArray &&
            annotationElements.elements.isNotEmpty) {
          annotationElements.elements
              .removeAt(annotationElements.elements.length - 1);
        }
      }
    }
  }

  /// internal method
  void catalogBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    if (certificated) {
      IPdfPrimitive? permission = PdfCrossTable.dereference(
          PdfDocumentHelper.getHelper(document!)
              .catalog[PdfDictionaryProperties.perms]);
      if (permission == null) {
        permission = PdfDictionary();
        (permission as PdfDictionary)[PdfDictionaryProperties.docMDP] =
            PdfReferenceHolder(signatureDictionary);
        PdfDocumentHelper.getHelper(document!)
            .catalog[PdfDictionaryProperties.perms] = permission;
      } else if (permission is PdfDictionary &&
          !permission.containsKey(PdfDictionaryProperties.docMDP)) {
        permission.setProperty(PdfDictionaryProperties.docMDP,
            PdfReferenceHolder(signatureDictionary));
      }
    }
  }

  /// internal method
  void dictionaryBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    if (field != null) {
      final PdfFieldHelper helper = PdfFieldHelper.getHelper(field!);
      helper.dictionary!.encrypt =
          PdfSecurityHelper.getHelper(document!.security).encryptor.encrypt;
      helper.dictionary!
          .setProperty(PdfDictionaryProperties.ap, field!.appearance);
    }
  }

  /// internal method
  List<PdfCertificationFlags> getCertificateFlags(int value) {
    final List<PdfCertificationFlags> result = <PdfCertificationFlags>[];
    if (value & _getCertificateFlagValue(PdfCertificationFlags.forbidChanges)! >
        0) {
      result.add(PdfCertificationFlags.forbidChanges);
    }
    if (value & _getCertificateFlagValue(PdfCertificationFlags.allowFormFill)! >
        0) {
      result.add(PdfCertificationFlags.allowFormFill);
    }
    if (value & _getCertificateFlagValue(PdfCertificationFlags.allowComments)! >
        0) {
      result.add(PdfCertificationFlags.allowComments);
    }
    return result;
  }

  /// internal method
  int getCertificateFlagResult(List<PdfCertificationFlags> flags) {
    int result = 0;
    flags.toList().forEach((PdfCertificationFlags flag) {
      result |= _getCertificateFlagValue(flag)!;
    });
    if (result == 0) {
      result = 1;
    }
    return result;
  }

  int? _getCertificateFlagValue(PdfCertificationFlags flag) {
    int? result;
    switch (flag) {
      case PdfCertificationFlags.forbidChanges:
        result = 1;
        break;
      case PdfCertificationFlags.allowFormFill:
        result = 2;
        break;
      case PdfCertificationFlags.allowComments:
        result = 3;
        break;
    }
    return result;
  }

  /// internal method
  X509Certificate? getRoot(X509Certificate cert, List<X509Certificate> certs) {
    X509Certificate parent;
    for (int i = 0; i < certs.length; i++) {
      parent = certs[i];
      if (!(cert.c!.issuer!.toString() == parent.c!.subject!.toString())) {
        continue;
      }
      try {
        cert.verify(parent.getPublicKey());
        return parent;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// internal method
  Future<bool> getDSSDetails(List<X509Certificate> certificates,
      RevocationType type, bool includePublicCertificates) async {
    final List<List<int>> crlCollection = <List<int>>[];
    final List<List<int>> ocspCollection = <List<int>>[];
    final List<List<int>> certCollection = <List<int>>[];
    if (includePublicCertificates) {
      for (int i = 0; i < certificates.length; i++) {
        certCollection.add(certificates[i].c!.getDerEncoded()!);
      }
    }
    for (int k = 0; k < certificates.length; ++k) {
      if (type == RevocationType.ocsp ||
          type == RevocationType.ocspAndCrl ||
          (crlCollection.isEmpty && type == RevocationType.ocspOrCrl)) {
        final Ocsp ocsp = Ocsp();
        final List<int>? ocspBytes = await ocsp.getEncodedOcspResponse(
            certificates[k], getRoot(certificates[k], certificates));
        if (ocspBytes != null) {
          ocspCollection.add(buildOCSPResponse(ocspBytes));
        }
      }
      if (type == RevocationType.crl ||
          type == RevocationType.ocspAndCrl ||
          (ocspCollection.isEmpty && type == RevocationType.ocspOrCrl)) {
        final List<List<int>> cim =
            await RevocationList().getEncoded(certificates[k]);
        if (cim.isNotEmpty) {
          for (final List<int> crl in cim) {
            bool duplicate = false;
            for (final List<int> element in crlCollection) {
              if (_listsAreEqual(element, crl)) {
                duplicate = true;
                continue;
              }
            }
            if (!duplicate) {
              crlCollection.add(crl);
            }
          }
        }
      }
    }
    return initializeDssDictionary(
        crlCollection, ocspCollection, certCollection);
  }

  bool _listsAreEqual(List<int> list1, List<int> list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

  /// internal method
  bool initializeDssDictionary(List<List<int>> crlCollection,
      List<List<int>> ocspCollection, List<List<int>> certCollection) {
    if (crlCollection.isEmpty &&
        ocspCollection.isEmpty &&
        certCollection.isEmpty) {
      return false;
    }
    PdfDictionary? dssDictionary;
    if (document != null) {
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document!);
      if (helper.catalog.containsKey(PdfDictionaryProperties.dss)) {
        final IPdfPrimitive? dss = PdfCrossTable.dereference(
            helper.catalog[PdfDictionaryProperties.dss]);
        if (dss != null && dss is PdfDictionary) {
          dssDictionary = dss;
        }
      }
    }
    dssDictionary ??= PdfDictionary();
    PdfArray ocspArray = PdfArray();
    PdfArray crlArray = PdfArray();
    final PdfArray ocspVRI = PdfArray();
    final PdfArray crlVRI = PdfArray();
    PdfArray cetrsArray = PdfArray();
    if (dssDictionary.containsKey(PdfDictionaryProperties.ocsps)) {
      final IPdfPrimitive? dssOcsp = PdfCrossTable.dereference(
          dssDictionary[PdfDictionaryProperties.ocsps]);
      if (dssOcsp != null && dssOcsp is PdfArray) {
        ocspArray = dssOcsp;
      }
    }
    if (dssDictionary.containsKey(PdfDictionaryProperties.crls)) {
      final IPdfPrimitive? dsscrl = PdfCrossTable.dereference(
          dssDictionary[PdfDictionaryProperties.crls]);
      if (dsscrl != null && dsscrl is PdfArray) {
        crlArray = dsscrl;
      }
    }
    PdfDictionary vriDictionary = PdfDictionary();
    if (dssDictionary.containsKey(PdfDictionaryProperties.vri)) {
      final IPdfPrimitive? dssVri =
          PdfCrossTable.dereference(dssDictionary[PdfDictionaryProperties.vri]);
      if (dssVri != null && dssVri is PdfDictionary) {
        vriDictionary = dssVri;
      }
    }
    if (dssDictionary.containsKey(PdfDictionaryProperties.certs)) {
      final IPdfPrimitive? dssCerts = PdfCrossTable.dereference(
          dssDictionary[PdfDictionaryProperties.certs]);
      if (dssCerts != null && dssCerts is PdfArray) {
        cetrsArray = dssCerts;
      }
    }
    for (int i = 0; i < ocspCollection.length; i++) {
      final PdfDictionary tempDictionary = PdfDictionary();
      final PdfStream stream = PdfStream(tempDictionary, ocspCollection[i]);
      stream.compress = true;
      final PdfReferenceHolder holder = PdfReferenceHolder(stream);
      ocspArray.add(holder);
      ocspVRI.add(holder);
    }
    for (int i = 0; i < crlCollection.length; i++) {
      final PdfDictionary tempDictionary = PdfDictionary();
      final PdfStream stream = PdfStream(tempDictionary, crlCollection[i]);
      stream.compress = true;
      final PdfReferenceHolder holder = PdfReferenceHolder(stream);
      crlArray.add(holder);
      crlVRI.add(holder);
    }
    for (int i = 0; i < certCollection.length; i++) {
      final PdfDictionary tempDictionary = PdfDictionary();
      final PdfStream stream = PdfStream(tempDictionary, certCollection[i]);
      stream.compress = true;
      final PdfReferenceHolder holder = PdfReferenceHolder(stream);
      cetrsArray.add(holder);
    }
    final String vriName = getVRIName().toUpperCase();
    PdfDictionary vriDataDictionary = PdfDictionary();
    if (vriDictionary.containsKey(vriName)) {
      final IPdfPrimitive? dssVriData =
          PdfCrossTable.dereference(vriDictionary[vriName]);
      if (dssVriData != null && dssVriData is PdfDictionary) {
        vriDataDictionary = dssVriData;
      }
      if (vriDataDictionary.containsKey(PdfDictionaryProperties.ocsp)) {
        final IPdfPrimitive? vriOCSP = PdfCrossTable.dereference(
            vriDataDictionary[PdfDictionaryProperties.ocsp]);
        if (vriOCSP != null && vriOCSP is PdfArray) {
          for (int i = 0; i < ocspVRI.count; i++) {
            if (!vriOCSP.contains(ocspVRI[i]!)) {
              vriOCSP.add(ocspVRI[i]!);
            }
          }
        }
      }
      if (vriDataDictionary.containsKey(PdfDictionaryProperties.crl)) {
        final IPdfPrimitive? vriCRL = PdfCrossTable.dereference(
            vriDataDictionary[PdfDictionaryProperties.crl]);
        if (vriCRL != null && vriCRL is PdfArray) {
          for (int i = 0; i < crlVRI.count; i++) {
            if (!vriCRL.contains(crlVRI[i]!)) {
              vriCRL.add(crlVRI[i]!);
            }
          }
        }
      }
    } else {
      vriDataDictionary.items![PdfName(PdfDictionaryProperties.ocsp)] =
          PdfReferenceHolder(ocspArray);
      vriDataDictionary.items![PdfName(PdfDictionaryProperties.crl)] =
          PdfReferenceHolder(crlArray);
      vriDictionary.items![PdfName(getVRIName().toUpperCase())] =
          PdfReferenceHolder(vriDataDictionary);
    }
    vriDictionary.modify();
    dssDictionary.items![PdfName(PdfDictionaryProperties.ocsps)] =
        PdfReferenceHolder(ocspArray);
    dssDictionary.items![PdfName(PdfDictionaryProperties.crls)] =
        PdfReferenceHolder(crlArray);
    dssDictionary.items![PdfName(PdfDictionaryProperties.vri)] =
        PdfReferenceHolder(vriDictionary);
    if (certCollection.isNotEmpty) {
      dssDictionary.items![PdfName(PdfDictionaryProperties.certs)] =
          PdfReferenceHolder(cetrsArray);
    }
    PdfDocumentHelper.getHelper(document!)
            .catalog[PdfDictionaryProperties.dss] =
        PdfReferenceHolder(dssDictionary);
    dssDictionary.modify();
    return true;
  }

  /// internal method
  List<int> buildOCSPResponse(List<int> basicOCSPResponse) {
    final DerOctet doctet = DerOctet(basicOCSPResponse);
    final Asn1EncodeCollection v2 = Asn1EncodeCollection();
    v2.add(<dynamic>[OcspConstants.ocspBasic]);
    v2.add(<dynamic>[doctet]);
    final DerCatalogue den = DerCatalogue(<int>[0]);
    final Asn1EncodeCollection v3 = Asn1EncodeCollection();
    v3.add(<dynamic>[den]);
    v3.add(<dynamic>[DerTag(0, DerSequence(collection: v2), true)]);
    final DerSequence seq = DerSequence(collection: v3);
    final List<int> b = seq.getEncoded()!;
    return b;
  }

  /// internal method
  String getVRIName() {
    if (_nameData == null && field != null) {
      final PdfSignatureFieldHelper helper =
          PdfSignatureFieldHelper.getHelper(field!);
      if (helper.dictionary!.containsKey(PdfDictionaryProperties.v)) {
        final IPdfPrimitive? v = PdfCrossTable.dereference(
            helper.dictionary![PdfDictionaryProperties.v]);
        if (v != null &&
            v is PdfDictionary &&
            v.containsKey(PdfDictionaryProperties.contents)) {
          final IPdfPrimitive? contents =
              PdfCrossTable.dereference(v[PdfDictionaryProperties.contents]);
          if (contents != null && contents is PdfString) {
            _nameData = contents.data;
          }
        }
      }
    }
    _nameData ??= utf8.encode(_generateUuid());
    final dynamic output = AccumulatorSink<Digest>();
    final dynamic input = sha1.startChunkedConversion(output);
    input.add(_nameData);
    input.close();
    final List<int> data = output.events.single.bytes as List<int>;
    return PdfString.bytesToHex(data);
  }

  String _generateUuid() {
    final Random random = Random();
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < 32; i++) {
      if (i == 8 || i == 12 || i == 16 || i == 20) {
        buffer.write('-');
      }
      final int digit = i == 12
          ? 4 // Specifies the version (4) for UUID v4
          : (i == 16 ? (random.nextInt(4) + 8) : random.nextInt(16));
      buffer.write(digit.toRadixString(16));
    }
    return buffer.toString();
  }

  /// internal method
  List<X509Certificate?>? getCertificateChain() {
    if (field != null) {
      try {
        final PdfSignatureFieldHelper helper =
            PdfSignatureFieldHelper.getHelper(field!);
        if (helper.dictionary!.containsKey(PdfDictionaryProperties.v)) {
          final IPdfPrimitive? v = PdfCrossTable.dereference(
              helper.dictionary![PdfDictionaryProperties.v]);
          if (v != null &&
              v is PdfDictionary &&
              v.containsKey(PdfDictionaryProperties.contents)) {
            final IPdfPrimitive? contents =
                PdfCrossTable.dereference(v[PdfDictionaryProperties.contents]);
            if (contents != null && contents is PdfString) {
              final List<int>? sigByte = contents.data;
              if (sigByte != null) {
                final X509CertificateParser parser = X509CertificateParser();
                final List<X509Certificate?>? certificateChain =
                    parser.getCertificateChain(PdfStreamReader(sigByte));
                if (certificateChain != null) {
                  return certificateChain;
                }
                _nameData = sigByte;
              }
            }
          }
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// internal method
  Future<List<X509Certificate?>?> getTimestampCertificateChain() async {
    try {
      final dynamic output = AccumulatorSink<Digest>();
      final dynamic input = sha256.startChunkedConversion(output);
      input.add(base64.decode('VABlAHMAdAAgAGQAYQB0AGEA')); //Test unicode data
      input.close();
      final List<int> hash = output.events.single.bytes as List<int>;
      final List<int> asnEncodedTimestampRequest =
          TimeStampRequestCreator().getAsnEncodedTimestampRequest(hash);
      final List<int>? timeStampResponse = await fetchData(
          base.timestampServer!.uri, 'POST',
          contentType: 'application/timestamp-query',
          userName: base.timestampServer!.userName,
          password: base.timestampServer!.password,
          data: asnEncodedTimestampRequest,
          timeOutDuration: base.timestampServer!.timeOut);
      if (timeStampResponse != null) {
        List<int>? encoded;
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
          encoded = dOut.stream!.toList();
          dOut.stream!.clear();
        }
        if (encoded != null) {
          final X509CertificateParser parser = X509CertificateParser();
          final List<X509Certificate?>? certificateChain =
              parser.getCertificateChain(PdfStreamReader(encoded));
          if (certificateChain != null) {
            return certificateChain;
          }
          _nameData = encoded;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}

/// Specifies the type of revocation to be considered during the LTV enable process and their corresponding actions.
enum RevocationType {
  /// Embeds the OCSP data to the PDF document.
  ocsp,

  /// Embeds the CRL data to the PDF document.
  crl,

  /// Embeds both OCSP and CRL data to the PDF document.
  ocspAndCrl,

  /// Embeds OCSP or CRL data to the PDF document.
  ocspOrCrl
}
