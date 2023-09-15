import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_docs.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void createPdfTemplate() {
  // ignore: public_member_api_docs
  const String template1 =
      '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PD12nt+SmZRcGbCoemYvdQD0/XoL+GZ/xZf5fErJBsW8AHsrQG4NCmVuZHN0cmVhbQ0KZW5kb2JqDQoxMCAwIG9iag0KPDwNCi9UeXBlIC9Gb250DQovU3VidHlwZSAvVHlwZTENCi9CYXNlRm9udCAvQ291cmllcg0KL0VuY29kaW5nIC9XaW5BbnNpRW5jb2RpbmcNCj4+DQplbmRvYmoNCnhyZWYNCjAgMTENCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAxNyAwMDAwMCBuDQowMDAwMDAwMDcyIDAwMDAwIG4NCjAwMDAwMDAxODAgMDAwMDAgbg0KMDAwMDAwMDI1OSAwMDAwMCBuDQowMDAwMDAwNTIwIDAwMDAwIG4NCjAwMDAwMDA2MDggMDAwMDAgbg0KMDAwMDAwMDY5NiAwMDAwMCBuDQowMDAwMDAwOTg0IDAwMDAwIG4NCjAwMDAwMDE0MjAgMDAwMDAgbg0KMDAwMDAwMTg1OSAwMDAwMCBuDQp0cmFpbGVyDQo8PA0KL1Jvb3QgMSAwIFINCi9TaXplIDExDQo+Pg0KDQpzdGFydHhyZWYNCjE5NjMNCiUlRU9G';

  group('Create template from the existing document', () {
    test('test case 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(template1);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.none;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreaion1.pdf');
      nDocument.dispose();
      document.dispose();
    });
  });

  group('Create template from the existing document', () {
    test('test case 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(barcodePdf);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.none;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreaion2.pdf');
      nDocument.dispose();
      document.dispose();
    });
  });

  group('Create template from the existing document', () {
    test('test case 3', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(webLinkWExternalFile1);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.none;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreaion3.pdf');
      nDocument.dispose();
      document.dispose();
    });
  });

  group('Create template from the existing document', () {
    test('test case 4', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(complexScriptPdf);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.none;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreaion4.pdf');
      nDocument.dispose();
      document.dispose();
    });
  });

  group('Create template from the existing document', () {
    test('test case 5', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(trueTypeFontPdf);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.none;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreaion5.pdf');
      nDocument.dispose();
      document.dispose();
    });
  });

  group('Create template from the existing document', () {
    test('test case 6', () {
      final PdfDocument document = PdfDocument.fromBase64String(ms3dmdtpPdf);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.none;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreaion6.pdf');
      nDocument.dispose();
      document.dispose();
    });
  });

  group('Create template from the existing document', () {
    test('test case 7', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkPageRemove);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.none;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreaion7.pdf');
      nDocument.dispose();
      document.dispose();
    });
  });

  group('Create template from the existing document', () {
    test('test case 8', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkPageRemove);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();
      final PdfTemplate template1 = document.pages[1].createTemplate();
      final PdfTemplate template2 = document.pages[3].createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      nDocument.pages.add().graphics.drawPdfTemplate(template1,
          const Offset(20, 0), Size(nPage.size.width / 2, nPage.size.height));
      nDocument.pages.add().graphics.drawPdfTemplate(template2,
          const Offset(20, 0), Size(nPage.size.width / 2, nPage.size.height));

      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreaion8.pdf');
      nDocument.dispose();
      document.dispose();
    });
  });

  group('Create template from the existing document compressionLevel', () {
    test('test case 1', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkPageRemove);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();
      final PdfTemplate template1 = document.pages[1].createTemplate();
      final PdfTemplate template2 = document.pages[3].createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.normal;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      nDocument.pages.add().graphics.drawPdfTemplate(template1,
          const Offset(20, 0), Size(nPage.size.width / 2, nPage.size.height));
      nDocument.pages.add().graphics.drawPdfTemplate(template2,
          const Offset(20, 0), Size(nPage.size.width / 2, nPage.size.height));

      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreationCmpL1.pdf');
      nDocument.dispose();
      document.dispose();
    });

    test('test case 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(ms3dmdtpPdf);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();
      final PdfTemplate template1 = document.pages[1].createTemplate();
      final PdfTemplate template2 = document.pages[3].createTemplate();
      final PdfTemplate template3 = document.pages[5].createTemplate();
      final PdfTemplate template4 = document.pages[6].createTemplate();
      final PdfTemplate template5 = document.pages[7].createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.best;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      nDocument.pages.add().graphics.drawPdfTemplate(template1,
          const Offset(20, 0), Size(nPage.size.width / 2, nPage.size.height));
      nDocument.pages.add().graphics.drawPdfTemplate(template2,
          const Offset(20, 0), Size(nPage.size.width / 2, nPage.size.height));
      nDocument.pages.add().graphics.drawPdfTemplate(template3,
          const Offset(20, 0), Size(nPage.size.width / 2, nPage.size.height));
      nDocument.pages.add().graphics.drawPdfTemplate(template4,
          const Offset(20, 0), Size(nPage.size.width / 2, nPage.size.height));
      nDocument.pages.add().graphics.drawPdfTemplate(template5,
          const Offset(20, 0), Size(nPage.size.width / 2, nPage.size.height));

      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreationCmpL2.pdf');
      nDocument.dispose();
      document.dispose();
    });

    test('test case 3', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(trueTypeFontPdf);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.bestSpeed;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));

      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreationCmpL3.pdf');
      nDocument.dispose();
      document.dispose();
    });

    test('test case 4', () {
      final PdfDocument document = PdfDocument.fromBase64String(template1);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.belowNormal;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreationCmpL4.pdf');
      nDocument.dispose();
      document.dispose();
    });

    test('test case 5', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(complexScriptPdf);
      final PdfPage page = document.pages[0];
      final PdfTemplate template = page.createTemplate();
      final PdfTemplate template1 = document.pages[1].createTemplate();

      final PdfDocument nDocument = PdfDocument();
      nDocument.compressionLevel = PdfCompressionLevel.aboveNormal;
      nDocument.pageSettings.setMargins(2);
      final PdfPage nPage = nDocument.pages.add();
      nPage.graphics.drawPdfTemplate(template, const Offset(20, 0),
          Size(nPage.size.width / 2, nPage.size.height));
      nDocument.pages.add().graphics.drawPdfTemplate(template1,
          const Offset(20, 0), Size(nPage.size.width / 2, nPage.size.height));

      final List<int> bytes = nDocument.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to create the template');
      savePdf(bytes, 'FLUT-1420-templateCreationCmpL5.pdf');
      nDocument.dispose();
      document.dispose();
    });
  });
}
