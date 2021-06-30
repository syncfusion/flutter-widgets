part of pdf;

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
      PdfCertificate? certificate}) {
    _init(signedName, locationInfo, reason, contactInfo, documentPermissions,
        cryptographicStandard, digestAlgorithm, certificate);
  }

  //Fields
  PdfPage? _page;
  PdfSignatureField? _field;
  PdfDocument? _document;
  // ignore: prefer_final_fields
  bool _certificated = false;
  _PdfSignatureDictionary? _signatureDictionary;
  _PdfArray? _byteRange;
  DateTime? _signedDate;
  IPdfExternalSigner? _externalSigner;
  List<List<int>>? _externalRootCert;
  List<_X509Certificate?>? _externalChain;

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

  /// Gets the signed date.
  DateTime? get signedDate => _signedDate;

  /// Gets or sets cryptographic standard.
  late CryptographicStandard cryptographicStandard;

  /// Gets or sets digestion algorithm.
  late DigestAlgorithm digestAlgorithm;

  /// Gets or sets information provided by the signer to enable a recipient to contact
  /// the signer to verify the signature; for example, a phone number.
  String? contactInfo;

  /// Gets or sets the certificate
  PdfCertificate? certificate;

  //Implementations
  //To check annotation last elements have signature field
  void _checkAnnotationElementsContainsSignature(
      PdfPage page, String? signatureName) {
    if (page._dictionary.containsKey(_DictionaryProperties.annots)) {
      final _IPdfPrimitive? annotationElements = _PdfCrossTable._dereference(
          page._dictionary[_DictionaryProperties.annots]);
      _IPdfPrimitive? lastElement;
      if (annotationElements != null &&
          annotationElements is _PdfArray &&
          annotationElements._elements.isNotEmpty) {
        lastElement = _PdfCrossTable._dereference(
            annotationElements[annotationElements._elements.length - 1]);
      }
      if (lastElement != null &&
          lastElement is _PdfDictionary &&
          lastElement.containsKey(_DictionaryProperties.t)) {
        final _IPdfPrimitive? name =
            _PdfCrossTable._dereference(lastElement[_DictionaryProperties.t]);
        String tempName = '';
        if (name != null && name is _PdfString) {
          tempName = utf8.decode(name.data!);
        }
        if (tempName == signatureName &&
            annotationElements != null &&
            annotationElements is _PdfArray &&
            annotationElements._elements.isNotEmpty) {
          annotationElements._elements
              .removeAt(annotationElements._elements.length - 1);
        }
      }
    }
  }

  void _catalogBeginSave(Object sender, _SavePdfPrimitiveArgs? ars) {
    if (_certificated) {
      _IPdfPrimitive? permission = _PdfCrossTable._dereference(
          _document!._catalog[_DictionaryProperties.perms]);
      if (permission == null) {
        permission = _PdfDictionary();
        (permission as _PdfDictionary)[_DictionaryProperties.docMDP] =
            _PdfReferenceHolder(_signatureDictionary);
        _document!._catalog[_DictionaryProperties.perms] = permission;
      } else if (permission is _PdfDictionary &&
          !permission.containsKey(_DictionaryProperties.docMDP)) {
        permission.setProperty(_DictionaryProperties.docMDP,
            _PdfReferenceHolder(_signatureDictionary));
      }
    }
  }

  void _dictionaryBeginSave(Object sender, _SavePdfPrimitiveArgs? ars) {
    if (_field != null) {
      _field!._dictionary.encrypt = _document!.security._encryptor.encrypt;
      _field!._dictionary
          .setProperty(_DictionaryProperties.ap, _field!.appearance);
    }
  }

  void _init(
      String? signedName,
      String? locationInfo,
      String? reason,
      String? contactInfo,
      List<PdfCertificationFlags>? documentPermissions,
      CryptographicStandard cryptographicStandard,
      DigestAlgorithm digestAlgorithm,
      PdfCertificate? pdfCertificate) {
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
  }

  /// Add external signer for signature.
  void addExternalSigner(
      IPdfExternalSigner signer, List<List<int>> publicCertificatesData) {
    _externalSigner = signer;
    _externalRootCert = publicCertificatesData;
    if (_externalRootCert != null) {
      final _X509CertificateParser parser = _X509CertificateParser();
      _externalChain = <_X509Certificate?>[];
      _externalRootCert!.toList().forEach((List<int> certRawData) =>
          _externalChain!
              .add(parser.readCertificate(_StreamReader(certRawData))));
    }
  }

  List<PdfCertificationFlags> _getCertificateFlags(int value) {
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

  int _getCertificateFlagResult(List<PdfCertificationFlags> flags) {
    int result = 0;
    flags.toList().forEach((PdfCertificationFlags flag) {
      result |= _getCertificateFlagValue(flag)!;
    });
    if (result == 0) {
      result = 1;
    }
    return result;
  }
}
