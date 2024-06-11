import 'dart:convert';
import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import '../../pdf.dart';
import '../pdf/implementation/annotations/pdf_annotation.dart';
import '../pdf/implementation/forms/pdf_signature_field.dart';
import '../pdf/implementation/io/pdf_constants.dart';
import '../pdf/implementation/io/pdf_cross_table.dart';
import '../pdf/implementation/pages/pdf_page.dart';
import '../pdf/implementation/pdf_document/pdf_document.dart';
import '../pdf/implementation/primitives/pdf_array.dart';
import '../pdf/implementation/primitives/pdf_dictionary.dart';
import '../pdf/implementation/primitives/pdf_name.dart';
import '../pdf/implementation/primitives/pdf_number.dart';
import '../pdf/implementation/primitives/pdf_stream.dart';
import '../pdf/implementation/primitives/pdf_string.dart';
import '../pdf/implementation/security/digital_signature/pdf_signature.dart';
import '../pdf/interfaces/pdf_interface.dart';
import 'images.dart';
import 'pdf_docs.dart';
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
    test('Signed date test 1', () {
      PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfCertificate certificate =
          PdfCertificate(base64.decode(pdfPfx), 'syncfusion');
      final PdfSignatureField field = PdfSignatureField(page, 'signature',
          bounds: const Rect.fromLTWH(40, 40, 200, 100),
          signature: PdfSignature(
              certificate: certificate,
              contactInfo: 'johndoe@owned.us',
              locationInfo: 'Honolulu, Hawaii',
              reason: 'I am author of this document.',
              signedDate: DateTime(2015, 07, 21, 5, 50, 50)));
      document.form.fields.add(field);
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      expect(
          (document.form.fields[0] as PdfSignatureField)
              .signature!
              .signedDate
              .toString(),
          '2015-07-21 05:50:50.000');
      document.dispose();
      bytes.clear();
    });
    test('Signed date test 2', () {
      PdfDocument document = PdfDocument();
      List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfPage page = document.pages[0];
      final PdfCertificate certificate =
          PdfCertificate(base64.decode(pdfPfx), 'syncfusion');
      final PdfSignatureField field = PdfSignatureField(page, 'signature',
          bounds: const Rect.fromLTWH(40, 40, 200, 100),
          signature: PdfSignature(
              certificate: certificate,
              contactInfo: 'johndoe@owned.us',
              locationInfo: 'Honolulu, Hawaii',
              reason: 'I am author of this document.')
            ..signedDate = DateTime(2015, 07, 21, 5, 50, 50));
      document.form.fields.add(field);
      bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      expect(
          (document.form.fields[0] as PdfSignatureField)
              .signature!
              .signedDate
              .toString(),
          '2015-07-21 05:50:50.000');
      document.dispose();
      bytes.clear();
    });
    test('FLUT-7321', () {
      final PdfDocument document = PdfDocument.fromBase64String(flut7321);
      final PdfPage page = document.pages[0];
      final PdfSignatureField signatureField = PdfSignatureField(page, 'sig',
          bounds: const Rect.fromLTWH(100, 100, 200, 100),
          signature: PdfSignature(
              //Create a certificate instance from the PFX file with a private key.
              certificate: PdfCertificate(base64.decode(pdfPfx), 'syncfusion'),
              contactInfo: 'johndoe@owned.us',
              locationInfo: 'Honolulu, Hawaii',
              reason: 'I am author of this document.'));
      //Gets the signature field appearance graphics.
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      graphics!.drawString(
          'Digitally Signed', PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(0, 0, 200, 100));
      document.form.fields.add(signatureField);
      final List<int> bytes = document.saveSync();
      document.dispose();
      final PdfDocument doc1 = PdfDocument(inputBytes: bytes);
      final PdfTextExtractor extractor = PdfTextExtractor(doc1);
      final String text = extractor.extractText();
      expect(text, ' \r\n');
      doc1.dispose();
    });
  });
  group('FLUT-833443 Added PDF signature is not valid in Adobe viewer', () {
    test('Test 1', () {
      final PdfDocument document = PdfDocument();
      final PdfCertificate certificate =
          PdfCertificate(base64.decode(pdfPfx), 'syncfusion');
      final PdfSignature signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'insinfo@example.com',
          locationInfo: 'Rio das Ostras, Brasil',
          reason: 'Eu sou o autor deste documento.',
          signedName: 'Isaque Neves Sant Ana',
          signedDate: DateTime.now(),
          cryptographicStandard: CryptographicStandard.cades);
      final PdfSignatureField field = PdfSignatureField(
          document.pages.add(), 'signature',
          bounds: const Rect.fromLTWH(40, 40, 200, 100), signature: signature);
      document.form.fields.add(field);
      final PdfSignature signature2 = PdfSignature(
          certificate: certificate,
          contactInfo: 'insinfo@example.com',
          locationInfo: 'Rio das Ostras, Brasil',
          reason: 'Eu sou o autor deste documento.',
          signedName: 'Isaque\tNeves\tSant\tAna',
          signedDate: DateTime.now(),
          cryptographicStandard: CryptographicStandard.cades);
      final PdfSignatureField field2 = PdfSignatureField(
          document.pages.add(), 'signature',
          bounds: const Rect.fromLTWH(40, 40, 200, 100), signature: signature2);
      document.form.fields.add(field2);
      final PdfSignature signature3 = PdfSignature(
          certificate: certificate,
          contactInfo: 'insinfo@example.com',
          locationInfo: 'Rio das Ostras, Brasil',
          reason: 'Eu sou o autor deste documento.',
          signedName: 'Isaque\nNeves\nSant\nAna',
          signedDate: DateTime.now(),
          cryptographicStandard: CryptographicStandard.cades);
      final PdfSignatureField field3 = PdfSignatureField(
          document.pages.add(), 'signature',
          bounds: const Rect.fromLTWH(40, 40, 200, 100), signature: signature3);
      document.form.fields.add(field3);
      final PdfSignature signature4 = PdfSignature(
          certificate: certificate,
          contactInfo: 'insinfo@example.com',
          locationInfo: 'Rio das Ostras, Brasil',
          reason: 'Eu sou o autor deste documento.',
          signedName: 'Isaque\rNeves\rSant\rAna',
          signedDate: DateTime.now(),
          cryptographicStandard: CryptographicStandard.cades);
      final PdfSignatureField field4 = PdfSignatureField(
          document.pages.add(), 'signature',
          bounds: const Rect.fromLTWH(40, 40, 200, 100), signature: signature4);
      document.form.fields.add(field4);
      final List<int> bytes = document.saveSync();
      PdfDictionary? propBuild = PdfCrossTable.dereference(
          PdfSignatureHelper.getHelper(signature)
              .signatureDictionary!
              .dictionary!['Prop_Build']) as PdfDictionary?;
      PdfDictionary? app =
          PdfCrossTable.dereference(propBuild!['App']) as PdfDictionary?;
      PdfName? name = PdfCrossTable.dereference(app!['Name']) as PdfName?;
      expect(name!.name, 'Isaque#20Neves#20Sant#20Ana');
      propBuild = PdfCrossTable.dereference(
          PdfSignatureHelper.getHelper(signature2)
              .signatureDictionary!
              .dictionary!['Prop_Build']) as PdfDictionary?;
      app = PdfCrossTable.dereference(propBuild!['App']) as PdfDictionary?;
      name = PdfCrossTable.dereference(app!['Name']) as PdfName?;
      expect(name!.name, 'Isaque#09Neves#09Sant#09Ana');
      propBuild = PdfCrossTable.dereference(
          PdfSignatureHelper.getHelper(signature3)
              .signatureDictionary!
              .dictionary!['Prop_Build']) as PdfDictionary?;
      app = PdfCrossTable.dereference(propBuild!['App']) as PdfDictionary?;
      name = PdfCrossTable.dereference(app!['Name']) as PdfName?;
      expect(name!.name, 'Isaque#0ANeves#0ASant#0AAna');
      propBuild = PdfCrossTable.dereference(
          PdfSignatureHelper.getHelper(signature4)
              .signatureDictionary!
              .dictionary!['Prop_Build']) as PdfDictionary?;
      app = PdfCrossTable.dereference(propBuild!['App']) as PdfDictionary?;
      name = PdfCrossTable.dereference(app!['Name']) as PdfName?;
      expect(name!.name, 'Isaque#0DNeves#0DSant#0DAna');
      document.dispose();
      bytes.clear();
    });
    test('Test 2', () {
      PdfDocument document = PdfDocument();
      document.form.fields.add(PdfRadioButtonListField(
        document.pages.add(),
        ' Gender Gender ',
        items: <PdfRadioButtonListItem>[
          PdfRadioButtonListItem(
              '\tMale\tMale\t', const Rect.fromLTWH(100, 150, 35, 35)),
          PdfRadioButtonListItem(
              '\nFemale\nFemale\n', const Rect.fromLTWH(100, 200, 35, 35)),
          PdfRadioButtonListItem(
              '\rOthers\rOthers\r', const Rect.fromLTWH(100, 250, 35, 35))
        ],
        selectedIndex: 0,
      ));
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfRadioButtonListField field =
          document.form.fields[0] as PdfRadioButtonListField;
      expect(field.name, ' Gender Gender ');
      expect(field.selectedValue, '\tMale\tMale\t');
      final PdfRadioButtonItemCollection collection = field.items;
      expect(collection[0].value, '\tMale\tMale\t');
      expect(collection[1].value, '\nFemale\nFemale\n');
      expect(collection[2].value, '\rOthers\rOthers\r');
      document.dispose();
      bytes.clear();
    });
  });
  group(
      'FLUT-875380 Preservation issue occurs while flattening signature in specific PDF document',
      () {
    test('Test', () {
      final PdfDocument document = PdfDocument.fromBase64String(flut875380Pdf);
      document.form.flattenAllFields();
      savePdf(document.saveSync(), 'FLUT-875380-test.pdf');
      document.dispose();
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
  group('Async External Signer', () {
    test('test 1', () async {
      PdfDocument document = PdfDocument();
      List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
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
      bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField pdfSignatureField =
          document.form.fields[0] as PdfSignatureField;
      final PdfSignatureFieldHelper helper =
          PdfSignatureFieldHelper.getHelper(pdfSignatureField);
      final PdfDictionary signatureDictionary = PdfCrossTable.dereference(
          helper.dictionary![PdfDictionaryProperties.v])! as PdfDictionary;
      final PdfString signatureValue =
          signatureDictionary[PdfDictionaryProperties.contents]! as PdfString;
      expect(signatureValue.value!.length, 16384);
      expect(signatureValue.value!.startsWith(String.fromCharCode(0)), true,
          reason: 'Invalid signature value');
      document.dispose();
    });
    test('test 2', () async {
      PdfDocument document = PdfDocument();
      List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
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
      bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField pdfSignatureField =
          document.form.fields[0] as PdfSignatureField;
      final PdfSignatureFieldHelper helper =
          PdfSignatureFieldHelper.getHelper(pdfSignatureField);
      final PdfDictionary signatureDictionary = PdfCrossTable.dereference(
          helper.dictionary![PdfDictionaryProperties.v])! as PdfDictionary;
      final PdfString signatureValue =
          signatureDictionary[PdfDictionaryProperties.contents]! as PdfString;
      expect(signatureValue.value!.length, 16384);
      expect(!signatureValue.value!.startsWith(String.fromCharCode(0)), true,
          reason: 'Invalid signature value');
      document.dispose();
    });
    test('test 3', () async {
      PdfDocument document = PdfDocument();
      List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfPage page = document.pages[0];
      final PdfSignatureField signatureField = PdfSignatureField(
          page, 'Signature',
          bounds: const Rect.fromLTWH(0, 0, 100, 30));
      final PdfSignature sign = PdfSignature(
          cryptographicStandard: CryptographicStandard.cades,
          digestAlgorithm: DigestAlgorithm.sha1);
      final IPdfExternalSigner externalSignature =
          ExternalSignAsync(DigestAlgorithm.sha1);
      sign.addExternalSigner(
          externalSignature, <List<int>>[base64.decode(publicCert)]);
      signatureField.signature = sign;
      document.form.fields.add(signatureField);
      bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField pdfSignatureField =
          document.form.fields[0] as PdfSignatureField;
      final PdfSignatureFieldHelper helper =
          PdfSignatureFieldHelper.getHelper(pdfSignatureField);
      final PdfDictionary signatureDictionary = PdfCrossTable.dereference(
          helper.dictionary![PdfDictionaryProperties.v])! as PdfDictionary;
      final PdfString signatureValue =
          signatureDictionary[PdfDictionaryProperties.contents]! as PdfString;
      expect(signatureValue.value!.length, 16384);
      expect(!signatureValue.value!.startsWith(String.fromCharCode(0)), true,
          reason: 'Invalid signature value');
      document.dispose();
    });
  });
  group('FLUT875923- NullTest', () {
    test('Creation-test', () async {
      PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfSignatureField field = PdfSignatureField(page, 'signature',
          bounds: const Rect.fromLTWH(0, 0, 200, 100),
          signature: PdfSignature(
              certificate: PdfCertificate(base64.decode(pdfPfx), 'syncfusion'),
              contactInfo: 'johndoe@owned.us',
              locationInfo: 'Honolulu, Hawaii',
              reason: 'I am author of this document.'));
      document.form.fields.add(field);
      document.compressionLevel = PdfCompressionLevel.none;
      final List<int> bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField pdfSignatureField =
          document.form.fields[0] as PdfSignatureField;
      final PdfSignatureFieldHelper helper =
          PdfSignatureFieldHelper.getHelper(pdfSignatureField);
      final PdfDictionary appearanceDictionary = PdfCrossTable.dereference(
          helper.dictionary![PdfDictionaryProperties.ap])! as PdfDictionary;
      final IPdfPrimitive? appearanceRefHolder =
          appearanceDictionary[PdfDictionaryProperties.n];
      final IPdfPrimitive? objectDictionary =
          PdfCrossTable.dereference(appearanceRefHolder);
      if (objectDictionary != null && objectDictionary is PdfDictionary) {
        if (objectDictionary is PdfStream &&
            objectDictionary.dataStream != null) {
          expect(objectDictionary.dataStream!.isNotEmpty, true);
        }
      }
      document.dispose();
      bytes.clear();
    });
  });
  test('loadedDocument- Test', () async {
    PdfDocument document = PdfDocument.fromBase64String(flut7321);
    final PdfSignatureField field =
        document.form.fields[0] as PdfSignatureField;
    field.signature = PdfSignature(
        certificate: PdfCertificate(base64.decode(pdfPfx), 'syncfusion'),
        contactInfo: 'johndoe@owned.us',
        locationInfo: 'Honolulu, Hawaii',
        reason: 'I am author of this document.');
    document.form.fields.add(field);
    final List<int> bytes = await document.save();
    document.dispose();
    document = PdfDocument(inputBytes: bytes);
    final PdfSignatureField pdfSignatureField =
        document.form.fields[0] as PdfSignatureField;
    final PdfSignatureFieldHelper helper =
        PdfSignatureFieldHelper.getHelper(pdfSignatureField);
    final PdfDictionary appearanceDictionary = PdfCrossTable.dereference(
        helper.dictionary![PdfDictionaryProperties.ap])! as PdfDictionary;
    final IPdfPrimitive? appearanceRefHolder =
        appearanceDictionary[PdfDictionaryProperties.n];
    final IPdfPrimitive? objectDictionary =
        PdfCrossTable.dereference(appearanceRefHolder);
    if (objectDictionary != null && objectDictionary is PdfDictionary) {
      if (objectDictionary is PdfStream &&
          objectDictionary.dataStream != null) {
        expect(objectDictionary.dataStream!.isNotEmpty, true);
      }
    }
    document.dispose();
    bytes.clear();
  });
  group(
      'FLUT-881122- Existing signature gets invalid while adding second signature in the PDF document',
      () {
    test('test', () async {
      PdfDocument document = PdfDocument.fromBase64String(flut881122Pdf);
      final PdfPage page = document.pages[0];
      final PdfBitmap bitmap = PdfBitmap.fromBase64String(logoPng);
      final PdfSignatureField field = PdfSignatureField(page, 'signature',
          bounds: Rect.fromLTWH(
              210, 682, bitmap.width.toDouble(), bitmap.height.toDouble()),
          signature: PdfSignature(
              certificate: PdfCertificate(base64.decode(pdfPfx), 'syncfusion'),
              contactInfo: 'johndoe@owned.us',
              locationInfo: 'Honolulu, Hawaii',
              reason: 'I am author of this document.'));
      field.appearance.normal.graphics!.drawImage(
          bitmap,
          Rect.fromLTWH(
              0, 0, bitmap.width.toDouble(), bitmap.height.toDouble()));
      document.form.fields.add(field);
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfPage page1 = document.pages[0];
      final IPdfPrimitive? mediaBox = PdfCrossTable.dereference(
          PdfPageHelper.getHelper(page1).dictionary!['MediaBox']);
      if (mediaBox is PdfArray) {
        expect((mediaBox[0]! as PdfNumber).value.toString(), '0.0');
        expect((mediaBox[1]! as PdfNumber).value.toString(), '0');
        expect((mediaBox[2]! as PdfNumber).value.toString(), '595.2755905512');
        expect((mediaBox[3]! as PdfNumber).value.toString(), '841.8614173228');
      }
      final PdfAnnotationCollection annotations = page1.annotations;
      for (int i = 0; i < annotations.count; i++) {
        if (annotations[i] is PdfTextWebLink) {
          final IPdfPrimitive? rect = PdfCrossTable.dereference(
              PdfAnnotationHelper.getHelper(annotations[i])
                  .dictionary!['Rect']);
          if (rect is PdfArray) {
            expect((rect[0]! as PdfNumber).value.toString(), '217.3');
            expect((rect[1]! as PdfNumber).value.toString(), '329.6');
            expect((rect[2]! as PdfNumber).value.toString(), '442.3');
            expect((rect[3]! as PdfNumber).value.toString(), '343.4');
          }
        }
      }
      document.dispose();
      bytes.clear();
    });
  });
}

/// Represents an empty signer
class SignEmpty extends IPdfExternalSigner {
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
  SignerResult? signSync(List<int> message) {
    return null;
  }

  /// Returns async signed Message Digest.
  @override
  Future<SignerResult?> sign(List<int> message) async {
    await Future<void>.delayed(const Duration(seconds: 5));
    return null;
  }
}

/// Represents an external signer
class ExternalSign extends IPdfExternalSigner {
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
  SignerResult? signSync(List<int> message) {
    return SignerResult(base64.decode(_signedDocumentHash));
  }
}

/// Represents an external signer
class ExternalSignAsync extends IPdfExternalSigner {
  //Constructor
  /// Initializes a new instance of the [ExternalSignAsync] class.
  ExternalSignAsync(this.hashAlgorithm);

  //Fields
  /// Returns Signed Message Digest.
  @override
  late DigestAlgorithm hashAlgorithm;
  final String _signedDocumentHash =
      'AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+/w==';

  //Public method
  /// Returns async signed Message Digest.
  @override
  Future<SignerResult?> sign(List<int> message) async {
    await Future<void>.delayed(const Duration(seconds: 5));
    return SignerResult(base64.decode(_signedDocumentHash));
  }
}

/// Unit test cases for digital signature support.
void ltvAndTimestampTest() {
  group('LTV support', () {
    test('test 1', () async {
      PdfDocument document = PdfDocument.fromBase64String(ejDotNetCore4693Pdf);
      final PdfSignatureField field =
          document.form.fields[0] as PdfSignatureField;
      final PdfCertificate certificate =
          PdfCertificate(base64.decode(ejDotNetCore4693Pfx), 'moorthy');
      final bool isLTV = await field.signature!.createLongTermValidity(
          publicCertificatesData: certificate.getCertificateChain(),
          includePublicCertificates: true);
      expect(isLTV, true, reason: 'Failed to add LTV');
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      PdfDictionary? dictionary =
          PdfCrossTable.dereference(helper.catalog['DSS'])! as PdfDictionary;
      PdfArray? ocsps =
          PdfCrossTable.dereference(dictionary['OCSPs'])! as PdfArray;
      PdfStream? ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      PdfArray? crls =
          PdfCrossTable.dereference(dictionary['CRLs'])! as PdfArray;
      PdfStream? crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfDictionary? vri =
          PdfCrossTable.dereference(dictionary['VRI'])! as PdfDictionary;
      final PdfName vriName =
          PdfCrossTable.dereference(vri.items!.keys.toList()[0])! as PdfName;
      expect(vriName.name, 'E2F6FA4BC831D7619EF00E8081834B68B354D0F7',
          reason: 'VRI name is invalid');
      PdfDictionary? vris =
          PdfCrossTable.dereference(vri.items!.values.toList()[0])!
              as PdfDictionary;
      ocsps = PdfCrossTable.dereference(vris['OCSP'])! as PdfArray;
      ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      crls = PdfCrossTable.dereference(vris['CRL'])! as PdfArray;
      crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfArray? certs =
          PdfCrossTable.dereference(dictionary['Certs'])! as PdfArray;
      PdfStream? cert = PdfCrossTable.dereference(certs[0])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      cert = PdfCrossTable.dereference(certs[1])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      dictionary = null;
      ocsps = null;
      ocsp = null;
      crls = null;
      crl = null;
      vri = null;
      vris = null;
      certs = null;
      cert = null;
      document.dispose();
      bytes.clear();
    });
    test('test 2', () async {
      PdfDocument document = PdfDocument.fromBase64String(ejDotNetCore4693Pdf);
      final PdfSignatureField field =
          document.form.fields[0] as PdfSignatureField;
      final PdfCertificate certificate =
          PdfCertificate(base64.decode(ejDotNetCore4693Pfx), 'moorthy');
      final bool isLTV = await field.signature!.createLongTermValidity(
          publicCertificatesData: certificate.getCertificateChain(),
          type: RevocationType.crl,
          includePublicCertificates: true);
      expect(isLTV, true, reason: 'Failed to add LTV');
      final List<int> bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      PdfDictionary? dictionary =
          PdfCrossTable.dereference(helper.catalog['DSS'])! as PdfDictionary;
      PdfArray? crls =
          PdfCrossTable.dereference(dictionary['CRLs'])! as PdfArray;
      PdfStream? crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true);
      PdfDictionary? vri =
          PdfCrossTable.dereference(dictionary['VRI'])! as PdfDictionary;
      PdfDictionary? vris =
          PdfCrossTable.dereference(vri.items!.values.toList()[0])!
              as PdfDictionary;
      crls = PdfCrossTable.dereference(vris['CRL'])! as PdfArray;
      crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true);
      PdfArray? certs =
          PdfCrossTable.dereference(dictionary['Certs'])! as PdfArray;
      PdfStream? cert = PdfCrossTable.dereference(certs[0])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true);
      cert = PdfCrossTable.dereference(certs[1])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true);
      dictionary = null;
      crls = null;
      crl = null;
      vri = null;
      vris = null;
      certs = null;
      cert = null;
      document.dispose();
      bytes.clear();
    });
    test('test 3', () async {
      PdfDocument document = PdfDocument.fromBase64String(ejDotNetCore4693Pdf);
      final PdfSignatureField field =
          document.form.fields[0] as PdfSignatureField;
      final PdfCertificate certificate =
          PdfCertificate(base64.decode(ejDotNetCore4693Pfx), 'moorthy');
      final bool isLTV = await field.signature!.createLongTermValidity(
          publicCertificatesData: certificate.getCertificateChain(),
          type: RevocationType.ocspOrCrl,
          includePublicCertificates: true);
      expect(isLTV, true, reason: 'Failed to add LTV');
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      PdfDictionary? dictionary =
          PdfCrossTable.dereference(helper.catalog['DSS'])! as PdfDictionary;
      PdfArray? ocsps =
          PdfCrossTable.dereference(dictionary['OCSPs'])! as PdfArray;
      PdfStream? ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      PdfDictionary? vri =
          PdfCrossTable.dereference(dictionary['VRI'])! as PdfDictionary;
      PdfDictionary? vris =
          PdfCrossTable.dereference(vri.items!.values.toList()[0])!
              as PdfDictionary;
      ocsps = PdfCrossTable.dereference(vris['OCSP'])! as PdfArray;
      ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      PdfArray? certs =
          PdfCrossTable.dereference(dictionary['Certs'])! as PdfArray;
      PdfStream? cert = PdfCrossTable.dereference(certs[0])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      cert = PdfCrossTable.dereference(certs[1])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      dictionary = null;
      ocsps = null;
      ocsp = null;
      vri = null;
      vris = null;
      certs = null;
      cert = null;
      document.dispose();
      bytes.clear();
    });
    test('test 4', () async {
      PdfDocument document = PdfDocument.fromBase64String(ejDotNetCore4693Pdf);
      final PdfSignatureField field =
          document.form.fields[0] as PdfSignatureField;
      final PdfCertificate certificate =
          PdfCertificate(base64.decode(ejDotNetCore4693Pfx), 'moorthy');
      final bool isLTV = await field.signature!.createLongTermValidity(
          publicCertificatesData: certificate.getCertificateChain(),
          type: RevocationType.ocsp);
      expect(isLTV, true, reason: 'Failed to add LTV');
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      PdfDictionary? dictionary =
          PdfCrossTable.dereference(helper.catalog['DSS'])! as PdfDictionary;
      PdfArray? ocsps =
          PdfCrossTable.dereference(dictionary['OCSPs'])! as PdfArray;
      PdfStream? ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      PdfDictionary? vri =
          PdfCrossTable.dereference(dictionary['VRI'])! as PdfDictionary;
      PdfDictionary? vris =
          PdfCrossTable.dereference(vri.items!.values.toList()[0])!
              as PdfDictionary;
      ocsps = PdfCrossTable.dereference(vris['OCSP'])! as PdfArray;
      ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      dictionary = null;
      ocsps = null;
      ocsp = null;
      vri = null;
      vris = null;
      document.dispose();
      bytes.clear();
    });
    test('test 5', () async {
      PdfDocument document = PdfDocument.fromBase64String(ejDotNetCore4693Pdf);
      final PdfSignatureField field =
          document.form.fields[0] as PdfSignatureField;
      expect(field.isSigned, true,
          reason: 'Failed to retrieve signature state');
      if (field.isSigned) {
        final bool isLTV = await field.signature!
            .createLongTermValidity(includePublicCertificates: true);
        expect(isLTV, true, reason: 'Failed to add LTV');
      }
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      PdfDictionary? dictionary =
          PdfCrossTable.dereference(helper.catalog['DSS'])! as PdfDictionary;
      PdfArray? ocsps =
          PdfCrossTable.dereference(dictionary['OCSPs'])! as PdfArray;
      PdfStream? ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      PdfArray? crls =
          PdfCrossTable.dereference(dictionary['CRLs'])! as PdfArray;
      PdfStream? crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfDictionary? vri =
          PdfCrossTable.dereference(dictionary['VRI'])! as PdfDictionary;
      final PdfName vriName =
          PdfCrossTable.dereference(vri.items!.keys.toList()[0])! as PdfName;
      expect(vriName.name, 'E2F6FA4BC831D7619EF00E8081834B68B354D0F7',
          reason: 'VRI name is invalid');
      PdfDictionary? vris =
          PdfCrossTable.dereference(vri.items!.values.toList()[0])!
              as PdfDictionary;
      ocsps = PdfCrossTable.dereference(vris['OCSP'])! as PdfArray;
      ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      crls = PdfCrossTable.dereference(vris['CRL'])! as PdfArray;
      crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfArray? certs =
          PdfCrossTable.dereference(dictionary['Certs'])! as PdfArray;
      PdfStream? cert = PdfCrossTable.dereference(certs[0])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      cert = PdfCrossTable.dereference(certs[1])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      dictionary = null;
      ocsps = null;
      ocsp = null;
      crls = null;
      crl = null;
      vri = null;
      vris = null;
      certs = null;
      cert = null;
      document.dispose();
      bytes.clear();
    });
    test('test 6', () async {
      PdfDocument document = PdfDocument();
      final PdfSignatureField signatureField =
          PdfSignatureField(document.pages.add(), 'signature',
              bounds: const Rect.fromLTWH(0, 0, 200, 100),
              signature: PdfSignature(
                certificate: PdfCertificate(
                    base64.decode(ejDotNetCore4693Pfx), 'moorthy'),
                contactInfo: 'johndoe@owned.us',
                locationInfo: 'Honolulu, Hawaii',
                reason: 'I am author of this document.',
              ));
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      graphics!.drawImage(
          PdfBitmap.fromBase64String(logoPng),
          Rect.fromLTWH(
              0, 0, signatureField.bounds.width, signatureField.bounds.height));
      document.form.fields.add(signatureField);
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField field =
          document.form.fields[0] as PdfSignatureField;
      expect(field.isSigned, true,
          reason: 'Failed to retrieve signature state');
      if (field.isSigned) {
        final bool isLTV = await field.signature!
            .createLongTermValidity(includePublicCertificates: true);
        expect(isLTV, true, reason: 'Failed to add LTV');
      }
      final List<int> bytes1 = document.saveSync();
      document.dispose();
      bytes.clear();
      document = PdfDocument(inputBytes: bytes1);
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      PdfDictionary? dictionary =
          PdfCrossTable.dereference(helper.catalog['DSS'])! as PdfDictionary;
      PdfArray? ocsps =
          PdfCrossTable.dereference(dictionary['OCSPs'])! as PdfArray;
      PdfStream? ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      PdfArray? crls =
          PdfCrossTable.dereference(dictionary['CRLs'])! as PdfArray;
      PdfStream? crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfDictionary? vri =
          PdfCrossTable.dereference(dictionary['VRI'])! as PdfDictionary;
      PdfDictionary? vris =
          PdfCrossTable.dereference(vri.items!.values.toList()[0])!
              as PdfDictionary;
      ocsps = PdfCrossTable.dereference(vris['OCSP'])! as PdfArray;
      ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      crls = PdfCrossTable.dereference(vris['CRL'])! as PdfArray;
      crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfArray? certs =
          PdfCrossTable.dereference(dictionary['Certs'])! as PdfArray;
      PdfStream? cert = PdfCrossTable.dereference(certs[0])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      cert = PdfCrossTable.dereference(certs[1])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      dictionary = null;
      ocsps = null;
      ocsp = null;
      crls = null;
      crl = null;
      vri = null;
      vris = null;
      certs = null;
      cert = null;
      document.dispose();
      bytes1.clear();
    });
    test('test 7', () async {
      PdfDocument document = PdfDocument();
      final PdfSignatureField signatureField =
          PdfSignatureField(document.pages.add(), 'signature',
              bounds: const Rect.fromLTWH(0, 0, 200, 100),
              signature: PdfSignature(
                certificate: PdfCertificate(
                    base64.decode(ejDotNetCore4693Pfx), 'moorthy'),
                contactInfo: 'johndoe@owned.us',
                locationInfo: 'Honolulu, Hawaii',
                reason: 'I am author of this document.',
              ));
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      graphics!.drawImage(
          PdfBitmap.fromBase64String(logoPng),
          Rect.fromLTWH(
              0, 0, signatureField.bounds.width, signatureField.bounds.height));
      document.form.fields.add(signatureField);
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField field =
          document.form.fields[0] as PdfSignatureField;
      expect(field.isSigned, true,
          reason: 'Failed to retrieve signature state');
      if (field.isSigned) {
        final bool isLTV = await field.signature!.createLongTermValidity();
        expect(isLTV, true, reason: 'Failed to add LTV');
      }
      final List<int> bytes1 = document.saveSync();
      document.dispose();
      bytes.clear();
      document = PdfDocument(inputBytes: bytes1);
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      PdfDictionary? dictionary =
          PdfCrossTable.dereference(helper.catalog['DSS'])! as PdfDictionary;
      PdfArray? ocsps =
          PdfCrossTable.dereference(dictionary['OCSPs'])! as PdfArray;
      PdfStream? ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      PdfArray? crls =
          PdfCrossTable.dereference(dictionary['CRLs'])! as PdfArray;
      PdfStream? crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfDictionary? vri =
          PdfCrossTable.dereference(dictionary['VRI'])! as PdfDictionary;
      PdfDictionary? vris =
          PdfCrossTable.dereference(vri.items!.values.toList()[0])!
              as PdfDictionary;
      ocsps = PdfCrossTable.dereference(vris['OCSP'])! as PdfArray;
      ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      crls = PdfCrossTable.dereference(vris['CRL'])! as PdfArray;
      crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      expect(dictionary.containsKey('Certs'), false,
          reason: 'Certificates added');
      dictionary = null;
      ocsps = null;
      ocsp = null;
      crls = null;
      crl = null;
      vri = null;
      vris = null;
      document.dispose();
      bytes1.clear();
    });
    test('test 8', () async {
      PdfDocument document = PdfDocument();
      final PdfSignatureField signatureField =
          PdfSignatureField(document.pages.add(), 'signature',
              bounds: const Rect.fromLTWH(0, 0, 200, 100),
              signature: PdfSignature(
                certificate:
                    PdfCertificate(base64.decode(pdfPfx), 'syncfusion'),
                contactInfo: 'johndoe@owned.us',
                locationInfo: 'Honolulu, Hawaii',
                reason: 'I am author of this document.',
              ));
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      graphics!.drawImage(
          PdfBitmap.fromBase64String(logoPng),
          Rect.fromLTWH(
              0, 0, signatureField.bounds.width, signatureField.bounds.height));
      document.form.fields.add(signatureField);
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField field =
          document.form.fields[0] as PdfSignatureField;
      expect(field.isSigned, true,
          reason: 'Failed to retrieve signature state');
      if (field.isSigned) {
        final bool isLTV = await field.signature!.createLongTermValidity();
        expect(isLTV, false, reason: 'LTV Added for invalid certificate');
      }
      final List<int> bytes1 = document.saveSync();
      document.dispose();
      bytes.clear();
      document = PdfDocument(inputBytes: bytes1);
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      expect(helper.catalog.containsKey('DSS'), false,
          reason: 'DSS added for signature without LTV');
      document.dispose();
      bytes1.clear();
    });
  });
  group('Timestamp support', () {
    test('test 1', () async {
      PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final TimestampServer server = TimestampServer(
          Uri.parse('http://timestamp.entrust.net/TSS/RFC3161sha2TS'),
          timeOut: const Duration(milliseconds: 5000));
      expect(await server.isValid, true, reason: 'Invalid timestamp server');
      final PdfSignatureField field = PdfSignatureField(page, 'signature',
          bounds: const Rect.fromLTWH(0, 0, 200, 100),
          signature: PdfSignature(
              certificate:
                  PdfCertificate(base64.decode(ejDotNetCore4693Pfx), 'moorthy'),
              contactInfo: 'johndoe@owned.us',
              locationInfo: 'Honolulu, Hawaii',
              reason: 'I am author of this document.',
              timestampServer: server));
      final PdfGraphics? graphics = field.appearance.normal.graphics;
      graphics!.drawImage(PdfBitmap.fromBase64String(logoPng),
          Rect.fromLTWH(0, 0, field.bounds.width, field.bounds.height));
      document.form.fields.add(field);
      final List<int> bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField pdfSignatureField =
          document.form.fields[0] as PdfSignatureField;
      final PdfSignatureFieldHelper helper =
          PdfSignatureFieldHelper.getHelper(pdfSignatureField);
      final PdfDictionary signatureDictionary = PdfCrossTable.dereference(
          helper.dictionary![PdfDictionaryProperties.v])! as PdfDictionary;
      final PdfArray? byteRange =
          PdfCrossTable.dereference(PdfArray(signatureDictionary['ByteRange']))
              as PdfArray?;
      expect(byteRange!.count, 4);
      expect((byteRange[2]! as PdfNumber).value! > 24000, true,
          reason: 'Invalid byte range');
      document.dispose();
      bytes.clear();
    });
    test('test 2', () async {
      PdfDocument document = PdfDocument();
      List<int> bytes = await document.save();
      document = PdfDocument(inputBytes: bytes);
      final PdfPage page = document.pages[0];
      final PdfSignatureField field = PdfSignatureField(page, 'signature',
          bounds: const Rect.fromLTWH(0, 0, 200, 100),
          signature: PdfSignature(
              certificate:
                  PdfCertificate(base64.decode(ejDotNetCore4693Pfx), 'moorthy'),
              contactInfo: 'johndoe@owned.us',
              locationInfo: 'Honolulu, Hawaii',
              reason: 'I am author of this document.',
              timestampServer: TimestampServer(
                  Uri.parse(
                      'https://demo.postsignum.cz:444/DEMO-TSS/HttpTspServer/'),
                  userName: 'demoTSA',
                  password: 'demoTSA2010',
                  timeOut: const Duration(milliseconds: 5000))));
      final PdfGraphics? graphics = field.appearance.normal.graphics;
      graphics!.drawImage(PdfBitmap.fromBase64String(logoPng),
          Rect.fromLTWH(0, 0, field.bounds.width, field.bounds.height));
      document.form.fields.add(field);
      bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField pdfSignatureField =
          document.form.fields[0] as PdfSignatureField;
      final PdfSignatureFieldHelper helper =
          PdfSignatureFieldHelper.getHelper(pdfSignatureField);
      final PdfDictionary signatureDictionary = PdfCrossTable.dereference(
          helper.dictionary![PdfDictionaryProperties.v])! as PdfDictionary;
      final PdfArray? byteRange =
          PdfCrossTable.dereference(signatureDictionary['ByteRange'])
              as PdfArray?;
      expect(byteRange!.count, 4);
      expect((byteRange[2]! as PdfNumber).value! > 24000, true,
          reason: 'Invalid byte range');
      document.dispose();
      bytes.clear();
    });
    test('test 3', () async {
      TimestampServer tsServer =
          TimestampServer(Uri.parse('http://timestamp.digicert.com/'));
      expect(await tsServer.isValid, true, reason: 'Invalid timestamp server');
      tsServer = TimestampServer(Uri.parse('http://rootca.gov.eg/tmstpsrvGox'),
          timeOut: const Duration(milliseconds: 5000));
      expect(await tsServer.isValid, false, reason: 'Invalid timestamp server');
    });
    test('test 4', () async {
      PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final TimestampServer server = TimestampServer(
          Uri.parse('http://timestamp.digicert.com'),
          timeOut: const Duration(milliseconds: 5000));
      expect(await server.isValid, true, reason: 'Invalid timestamp server');
      final PdfSignatureField field = PdfSignatureField(page, 'signature',
          bounds: const Rect.fromLTWH(0, 0, 200, 100),
          signature: PdfSignature(timestampServer: server));
      document.form.fields.add(field);
      final List<int> bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField pdfSignatureField =
          document.form.fields[0] as PdfSignatureField;
      final PdfSignatureFieldHelper helper =
          PdfSignatureFieldHelper.getHelper(pdfSignatureField);
      final PdfDictionary signatureDictionary = PdfCrossTable.dereference(
          helper.dictionary![PdfDictionaryProperties.v])! as PdfDictionary;
      final PdfName type =
          PdfCrossTable.dereference(signatureDictionary['Type'])! as PdfName;
      expect(type.name, 'DocTimeStamp', reason: 'Invalid timestamp type');
      final PdfName subFilter =
          PdfCrossTable.dereference(signatureDictionary['SubFilter'])!
              as PdfName;
      expect(subFilter.name, 'ETSI.RFC3161', reason: 'Invalid timestamp type');
      document.dispose();
      bytes.clear();
    });
    test('test 5', () async {
      PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final TimestampServer server = TimestampServer(
          Uri.parse('http://timestamp.digicert.com'),
          timeOut: const Duration(milliseconds: 5000));
      expect(await server.isValid, true, reason: 'Invalid timestamp server');
      final PdfSignatureField field = PdfSignatureField(page, 'signature',
          bounds: const Rect.fromLTWH(0, 0, 200, 100),
          signature: PdfSignature(timestampServer: server));
      final bool isLTV = await field.signature!
          .createLongTermValidity(includePublicCertificates: true);
      expect(isLTV, true, reason: 'Failed to add LTV');
      document.form.fields.add(field);
      final List<int> bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField pdfSignatureField =
          document.form.fields[0] as PdfSignatureField;
      final PdfSignatureFieldHelper signatureHelper =
          PdfSignatureFieldHelper.getHelper(pdfSignatureField);
      final PdfDictionary signatureDictionary = PdfCrossTable.dereference(
              signatureHelper.dictionary![PdfDictionaryProperties.v])!
          as PdfDictionary;
      final PdfName type =
          PdfCrossTable.dereference(signatureDictionary['Type'])! as PdfName;
      expect(type.name, 'DocTimeStamp', reason: 'Invalid timestamp type');
      final PdfName subFilter =
          PdfCrossTable.dereference(signatureDictionary['SubFilter'])!
              as PdfName;
      expect(subFilter.name, 'ETSI.RFC3161', reason: 'Invalid timestamp type');
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      PdfDictionary? dictionary =
          PdfCrossTable.dereference(helper.catalog['DSS'])! as PdfDictionary;
      PdfArray? ocsps =
          PdfCrossTable.dereference(dictionary['OCSPs'])! as PdfArray;
      PdfStream? ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      PdfArray? crls =
          PdfCrossTable.dereference(dictionary['CRLs'])! as PdfArray;
      PdfStream? crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfDictionary? vri =
          PdfCrossTable.dereference(dictionary['VRI'])! as PdfDictionary;
      PdfDictionary? vris =
          PdfCrossTable.dereference(vri.items!.values.toList()[0])!
              as PdfDictionary;
      ocsps = PdfCrossTable.dereference(vris['OCSP'])! as PdfArray;
      ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      crls = PdfCrossTable.dereference(vris['CRL'])! as PdfArray;
      crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfArray? certs =
          PdfCrossTable.dereference(dictionary['Certs'])! as PdfArray;
      PdfStream? cert = PdfCrossTable.dereference(certs[0])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      cert = PdfCrossTable.dereference(certs[1])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      dictionary = null;
      ocsps = null;
      ocsp = null;
      crls = null;
      crl = null;
      vri = null;
      vris = null;
      certs = null;
      cert = null;
      document.dispose();
      bytes.clear();
    });
    test('test 6', () async {
      PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final TimestampServer server = TimestampServer(
          Uri.parse('http://timestamp.digicert.com'),
          timeOut: const Duration(milliseconds: 5000));
      expect(await server.isValid, true, reason: 'Invalid timestamp server');
      final PdfSignatureField field = PdfSignatureField(page, 'signature',
          bounds: const Rect.fromLTWH(0, 0, 200, 100),
          signature: PdfSignature(timestampServer: server));
      document.form.fields.add(field);
      final List<int> bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField signatureField =
          document.form.fields[0] as PdfSignatureField;
      final bool isLTV = await signatureField.signature!
          .createLongTermValidity(includePublicCertificates: true);
      expect(isLTV, true, reason: 'Failed to add LTV');
      final List<int> bytes1 = await document.save();
      document.dispose();
      bytes.clear();
      document = PdfDocument(inputBytes: bytes1);
      final PdfSignatureField pdfSignatureField =
          document.form.fields[0] as PdfSignatureField;
      final PdfSignatureFieldHelper signatureHelper =
          PdfSignatureFieldHelper.getHelper(pdfSignatureField);
      final PdfDictionary signatureDictionary = PdfCrossTable.dereference(
              signatureHelper.dictionary![PdfDictionaryProperties.v])!
          as PdfDictionary;
      final PdfName type =
          PdfCrossTable.dereference(signatureDictionary['Type'])! as PdfName;
      expect(type.name, 'DocTimeStamp', reason: 'Invalid timestamp type');
      final PdfName subFilter =
          PdfCrossTable.dereference(signatureDictionary['SubFilter'])!
              as PdfName;
      expect(subFilter.name, 'ETSI.RFC3161', reason: 'Invalid timestamp type');
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      PdfDictionary? dictionary =
          PdfCrossTable.dereference(helper.catalog['DSS'])! as PdfDictionary;
      PdfArray? ocsps =
          PdfCrossTable.dereference(dictionary['OCSPs'])! as PdfArray;
      PdfStream? ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      PdfArray? crls =
          PdfCrossTable.dereference(dictionary['CRLs'])! as PdfArray;
      PdfStream? crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfDictionary? vri =
          PdfCrossTable.dereference(dictionary['VRI'])! as PdfDictionary;
      PdfDictionary? vris =
          PdfCrossTable.dereference(vri.items!.values.toList()[0])!
              as PdfDictionary;
      ocsps = PdfCrossTable.dereference(vris['OCSP'])! as PdfArray;
      ocsp = PdfCrossTable.dereference(ocsps[0])! as PdfStream;
      expect(ocsp.dataStream!.isNotEmpty, true, reason: 'OCSP is empty');
      crls = PdfCrossTable.dereference(vris['CRL'])! as PdfArray;
      crl = PdfCrossTable.dereference(crls[0])! as PdfStream;
      expect(crl.dataStream!.isNotEmpty, true, reason: 'CRL is empty');
      PdfArray? certs =
          PdfCrossTable.dereference(dictionary['Certs'])! as PdfArray;
      PdfStream? cert = PdfCrossTable.dereference(certs[0])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      cert = PdfCrossTable.dereference(certs[1])! as PdfStream;
      expect(cert.dataStream!.isNotEmpty, true, reason: 'Certificate is empty');
      dictionary = null;
      ocsps = null;
      ocsp = null;
      crls = null;
      crl = null;
      vri = null;
      vris = null;
      certs = null;
      cert = null;
      document.dispose();
      bytes1.clear();
    });
    test('test 7', () async {
      PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final TimestampServer server = TimestampServer(
          Uri.parse('http://timestamp.digicert.com'),
          timeOut: const Duration(milliseconds: 5000));
      expect(await server.isValid, true, reason: 'Invalid timestamp server');
      final PdfSignatureField field = PdfSignatureField(page, 'signature',
          bounds: const Rect.fromLTWH(0, 0, 200, 100),
          signature: PdfSignature(timestampServer: server));
      document.form.fields.add(field);
      final PdfSignatureField signatureField =
          PdfSignatureField(document.pages.add(), 'signature',
              bounds: const Rect.fromLTWH(0, 0, 200, 100),
              signature: PdfSignature(
                certificate: PdfCertificate(
                    base64.decode(ejDotNetCore4693Pfx), 'moorthy'),
                contactInfo: 'johndoe@owned.us',
                locationInfo: 'Honolulu, Hawaii',
                reason: 'I am author of this document.',
              ));
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      graphics!.drawImage(
          PdfBitmap.fromBase64String(logoPng),
          Rect.fromLTWH(
              0, 0, signatureField.bounds.width, signatureField.bounds.height));
      document.form.fields.add(signatureField);
      final List<int> bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfSignatureField loadedField1 =
          document.form.fields[0] as PdfSignatureField;
      final bool isLTV = await loadedField1.signature!
          .createLongTermValidity(includePublicCertificates: true);
      final PdfSignatureField loadedField2 =
          document.form.fields[1] as PdfSignatureField;
      final bool isLTV2 = await loadedField2.signature!
          .createLongTermValidity(includePublicCertificates: true);
      expect(isLTV, true, reason: 'Failed to add LTV');
      expect(isLTV2, true, reason: 'Failed to add LTV');
      final List<int> bytes1 = await document.save();
      document.dispose();
      bytes.clear();
      document = PdfDocument(inputBytes: bytes1);
      final PdfSignatureField pdfSignatureField =
          document.form.fields[0] as PdfSignatureField;
      final PdfSignatureFieldHelper signatureHelper =
          PdfSignatureFieldHelper.getHelper(pdfSignatureField);
      final PdfDictionary signatureDictionary = PdfCrossTable.dereference(
              signatureHelper.dictionary![PdfDictionaryProperties.v])!
          as PdfDictionary;
      final PdfName type =
          PdfCrossTable.dereference(signatureDictionary['Type'])! as PdfName;
      expect(type.name, 'DocTimeStamp', reason: 'Invalid timestamp type');
      final PdfName subFilter =
          PdfCrossTable.dereference(signatureDictionary['SubFilter'])!
              as PdfName;
      expect(subFilter.name, 'ETSI.RFC3161', reason: 'Invalid timestamp type');
      final PdfDocumentHelper helper = PdfDocumentHelper.getHelper(document);
      PdfDictionary? dictionary =
          PdfCrossTable.dereference(helper.catalog['DSS'])! as PdfDictionary;
      PdfArray? ocsps =
          PdfCrossTable.dereference(dictionary['OCSPs'])! as PdfArray;
      expect(ocsps.count, 3, reason: 'OCSPs count is invalid');
      PdfArray? crls =
          PdfCrossTable.dereference(dictionary['CRLs'])! as PdfArray;
      expect(crls.count, 4, reason: 'OCSPs count is invalid');
      PdfArray? certs =
          PdfCrossTable.dereference(dictionary['Certs'])! as PdfArray;
      expect(certs.count, 5, reason: 'Certificates count is invalid');
      dictionary = null;
      ocsps = null;
      crls = null;
      certs = null;
      document.dispose();
      bytes1.clear();
    });
  });
}
