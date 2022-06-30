import 'dart:convert';
import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';
// ignore: avoid_relative_lib_imports
import 'pfx_files.dart';

/// Digest algorithm list for Unit test cases.
List<DigestAlgorithm> testDigestAlgorithms = <DigestAlgorithm>[
  DigestAlgorithm.sha1,
  DigestAlgorithm.sha256,
  DigestAlgorithm.sha384,
  DigestAlgorithm.sha512
];

/// Cryptographics standard list for Unit test cases.
List<CryptographicStandard> testCryptographicStandards =
    <CryptographicStandard>[
  CryptographicStandard.cms,
  CryptographicStandard.cades
];

/// PFX file data and names with password
Map<String, dynamic> pfxTestFiles = <String, dynamic>{
  'pdfPfx': <String>[pdfPfx, 'syncfusion'],
  'pdfPfx2': <String>[pdfPfx2, 'password123'],
  'atfsigner': <String>[atfsigner, 'ix3.1415926535'],
  'azure': <String>[azure, 'azure@123'],
  'ca': <String>[ca, 'sasikumar'],
  'comodofree': <String>[comodofree, 'sample@24'],
  'defect4639': <String>[defect4639, '111'],
  'defect4835': <String>[defect4835, '111'],
  'defect5483': <String>[defect5483, 'syncfusion'],
  'defectIDSD877': <String>[defectIDSD877, ' '],
  'defectIDSD3723': <String>[defectIDSD3723, 'syncfusion'],
  'defectIDSD9119': <String>[defectIDSD9119, 'syncfusion'],
  'defectIDWF21203': <String>[defectIDWF21203, 'syncfusion'],
  'defectIDWF21268': <String>[defectIDWF21268, 'syncfusion'],
  'defectIDWF23583': <String>[defectIDWF23583, 'syncfusion'],
  'demoPrimary': <String>[demoPrimary, 'syncfusion'],
  'ejdotnetcore1793': <String>[ejdotnetcore1793, 'syncdemo'],
  'ejdotnetcore25592': <String>[ejdotnetcore25592, 'syncfusion'],
  'entrustcert': <String>[entrustcert, 'EthosTest'],
  'privatecer': <String>[privatecer, '123'],
  'samplesign': <String>[samplesign, 'password'],
  'testCert': <String>[testCert, '111'],
  'wf11743': <String>[wf11743, 'syncfusion'],
  'wf21274': <String>[wf21274, 'syncfusion'],
  'wf22113': <String>[wf22113, 'syncfusion'],
  'wf23501': <String>[wf23501, 'syncfusion'],
  'wf31372': <String>[wf31372, 'EthosTest'],
  'wf55836': <String>[wf55836, 'syncfusion'],
  'wf57483': <String>[wf57483, 'syncfusion'],
  'wf47133': <String>[wf47133, '12345678'],
  'wf54460': <String>[wf54460, '1q2w3e4r5t'],
  'wf57537': <String>[wf57537, '1q2w3e4r5t'],
  'wf579901': <String>[wf579901, 'syncfusion'],
  'wf58403': <String>[wf58403, '1q2w3e4r5t']
};

/// Unit test cases for digital signature support.
void digitalSignatureTest() {
  group('Digital Signature - Default', () {
    test('Self signed certificate - pdfPfx', () {
      final List<int> pfxData = base64.decode(pdfPfx);
      final PdfCertificate certificate = PdfCertificate(pfxData, 'syncfusion');
      //expect(certificate != null, true, reason: 'Failed to parse certificate');
      expect(certificate.version == 3, true,
          reason: 'Failed to get certificate version');
      expect(certificate.serialNumber.length == 16, true,
          reason: 'Failed to get certificate serial number');
      expect(certificate.issuerName == 'Syncfusion', true,
          reason: 'Failed to get certificate issuer name');
      expect(certificate.subjectName == 'Syncfusion', true,
          reason: 'Failed to get certificate subject name');
      // expect(certificate.validTo != null, true,
      //     reason: 'Failed to get certificate validation date');
      // expect(certificate.validFrom != null, true,
      //     reason: 'Failed to get certificate validation date');
    });
    test('PDF signatue test with PFX files', () {
      // ignore: avoid_function_literals_in_foreach_calls
      testCryptographicStandards.forEach((CryptographicStandard standard) {
        pfxTestFiles.forEach((String key, dynamic value) {
          // ignore: avoid_function_literals_in_foreach_calls
          testDigestAlgorithms.forEach((DigestAlgorithm digest) {
            final PdfDocument document = PdfDocument();
            final PdfPage page = document.pages.add();
            final PdfGraphics graphics = page.graphics;
            final List<int> pfxData = base64.decode(value[0]);
            final PdfCertificate certificate =
                PdfCertificate(pfxData, value[1]);
            final PdfSignatureField field = PdfSignatureField(page, 'signature',
                bounds: const Rect.fromLTWH(0, 0, 200, 100),
                signature: PdfSignature(
                    certificate: certificate,
                    contactInfo: 'johndoe@owned.us',
                    locationInfo: 'Honolulu, Hawaii',
                    reason: 'I am author of this document.',
                    digestAlgorithm: digest,
                    cryptographicStandard: standard));
            document.form.fields.add(field);
            graphics.drawRectangle(
                bounds: const Rect.fromLTWH(0, 0, 200, 100),
                pen: PdfPen(PdfColor(142, 170, 219)));
            final List<int> bytes = document.saveSync();
            final String algorithmName = digest.toString().substring(16);
            final String standardName = standard.toString().substring(22);
            savePdf(
                bytes, 'FLUT_2551_${key}_${algorithmName}_$standardName.pdf');
          });
        });
      });
    });
  });
}

// ignore: public_member_api_docs
const String publicCert =
    'MIIDFTCCAf2gAwIBAgIQMjdwZGujtplDiSGarQzO1DANBgkqhkiG9w0BAQsFADAXMRUwEwYDVQQDEwxUZXN0Q2VydFJvb3QwHhcNMTkwOTA5MDg0MzM5WhcNMzkxMjMxMjM1OTU5WjAXMRUwEwYDVQQDEwxUZXN0Q2VydFJvb3QwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCWs+BZKfWf5cZauYDpXPlHUZour4oNaGoAfySXUD28KLNxCI6AWlK+UV+JJWgcrJ9SpLuoxQb1384gZhQMe4RFtILQpxx9nAxtwsd7/6OLI4G9TRIdy6PJ2OHyHKL9ZqI/+XkUbgznUF9o0F2VlQwszSCQREDQ5PxcGy/GWS71ZT1tvs8iqMVi3PCUH8ERwqTwIhWvRt6weVZ/daR9rNqkEPkpT5tQPMGvmqEinxbjpO8h8gU91rXbiHaY7QlDgCmEy3zWVIROR56x3ZJv5/xjJ/ya4X51P3DcLNGgUTRre0cYXHfnyTQAVFDGxEGsTd4xOnMWrbMaoeRBt8dtBGNBAgMBAAGjXTBbMA8GA1UdEwEB/wQFMAMBAf8wSAYDVR0BBEEwP4AQk/aIkhJaRQ2nRg1ECf13f6EZMBcxFTATBgNVBAMTDFRlc3RDZXJ0Um9vdIIQMjdwZGujtplDiSGarQzO1DANBgkqhkiG9w0BAQsFAAOCAQEAbcFInTXT+08eV1JyrkMsR3HZGtPXyAGRSiZkMJJKE1MU79fFXCiQf6/UpCV76vdCCSOrZLJweUeZPLznZhOxu9aEGnA0CPEcphYUVT9J8aV8MpQJu5DKGbphdBuZNlBQvVg9Yxs0T7Ne49S3s2EUL/w6tFoBuGh1ar9rc3IRmJA8WM2orz4Q8bVhYdtlxWynfx3idCv7pQDymHmB0Wt5iSlcAfcDrZb7YSq+VYIHzAZatefjGRSsbRuVpSfz3dt+cVttKbY3mOWD4zaUvPvKs6bWznxStEBHomcWd3DymekC78aI9XKLmetddpzx6eOgf9Vju8KuO+udGDpoPy2apw==';

// ignore: public_member_api_docs
void externalSigner() {
  group('External Signer', () {
    test('test 1', () {
      final PdfDocument doc = PdfDocument();
      final PdfDocument document = PdfDocument(inputBytes: doc.saveSync());
      final PdfPage page = document.pages[0];
      final PdfSignatureField signatureField = PdfSignatureField(
          page, 'Signature',
          bounds: const Rect.fromLTWH(0, 0, 100, 30));
      final PdfSignature sign = PdfSignature(
          cryptographicStandard: CryptographicStandard.cades,
          digestAlgorithm: DigestAlgorithm.sha1);
      final IPdfExternalSigner externalSignature =
          SignEmpty(DigestAlgorithm.sha1);
      sign.addExternalSigner(
          externalSignature, <List<int>>[base64.decode(publicCert)]);
      signatureField.signature = sign;
      document.form.fields.add(signatureField);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_2551_ExternalSigner_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument doc = PdfDocument();
      final PdfDocument document = PdfDocument(inputBytes: doc.saveSync());
      final PdfPage page = document.pages[0];
      final PdfSignatureField signatureField = PdfSignatureField(
          page, 'Signature',
          bounds: const Rect.fromLTWH(0, 0, 100, 30));
      final PdfSignature sign = PdfSignature(
          cryptographicStandard: CryptographicStandard.cades,
          digestAlgorithm: DigestAlgorithm.sha1);
      final IPdfExternalSigner externalSignature =
          ExternalSign(DigestAlgorithm.sha1);
      sign.addExternalSigner(
          externalSignature, <List<int>>[base64.decode(publicCert)]);
      signatureField.signature = sign;
      document.form.fields.add(signatureField);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_2551_ExternalSigner_2.pdf');
      document.dispose();
    });
  });
}

/// Represents an empty signer
class SignEmpty implements IPdfExternalSigner {
  //Constructor
  /// Initializes a new instance of the [SignEmpty] class.
  SignEmpty(this.hashAlgorithm);

  //Fields
  /// Returns Signed Message Digest.
  @override
  late DigestAlgorithm hashAlgorithm;

  //Public method
  /// Returns Signed Message Digest.
  @override
  SignerResult? sign(List<int> message) {
    return null;
  }
}

/// Represents an external signer
class ExternalSign implements IPdfExternalSigner {
  //Constructor
  /// Initializes a new instance of the [ExternalSign] class.
  ExternalSign(this.hashAlgorithm);

  //Fields
  /// Returns Signed Message Digest.
  @override
  late DigestAlgorithm hashAlgorithm;
  final String _signedDocumentHash =
      'AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+/w==';

  //Public method
  /// Returns Signed Message Digest.
  @override
  SignerResult? sign(List<int> message) {
    return SignerResult(base64.decode(_signedDocumentHash));
  }
}
