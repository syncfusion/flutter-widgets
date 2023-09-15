import 'dart:convert';

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
import '../../primitives/pdf_reference_holder.dart';
import '../../primitives/pdf_string.dart';
import '../enum.dart';
import '../pdf_security.dart';
import 'pdf_certificate.dart';
import 'pdf_external_signer.dart';
import 'pdf_signature_dictionary.dart';
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
      DateTime? signedDate}) {
    _helper = PdfSignatureHelper(this);
    _init(signedName, locationInfo, reason, contactInfo, documentPermissions,
        cryptographicStandard, digestAlgorithm, certificate, signedDate);
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
      DateTime? signedDate) {
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
}
