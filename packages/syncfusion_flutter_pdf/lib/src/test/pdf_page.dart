// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_docs.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pdfPage() {
  group('PdfPage', () {
    final PdfDocument doc1 = PdfDocument();
    final PdfPage page = doc1.pages.add();
    test('default properties', () {
      expect(
          page.size.width == PdfPageSize.a4.width &&
              page.size.height == PdfPageSize.a4.height,
          true,
          reason: 'Failed to preserve default page size as A4');
    });
    doc1.dispose();
  });
  group('Page rotation', () {
    test('FLUT_5132 - Page rotation', () {
      final PdfDocument document = PdfDocument.fromBase64String(flut5132Pdf);
      final PdfDocument newDocument = PdfDocument();
      final PdfPage page = document.pages[0];
      expect(page.rotation, PdfPageRotateAngle.rotateAngle270,
          reason: 'failed  to get page rotation from existing PDF');
      final PdfTemplate pageTemplate = page.createTemplate();
      final PdfSection section1 = newDocument.sections!.add();
      section1.pageSettings.rotate = page.rotation;
      if (page.size.height < page.size.width) {
        section1.pageSettings.orientation = PdfPageOrientation.landscape;
      } else {
        section1.pageSettings.orientation = PdfPageOrientation.portrait;
      }
      section1.pageSettings.size = page.size;
      section1.pageSettings.margins.all = 0;
      final PdfPage newPage = section1.pages.add();
      newPage.graphics.drawPdfTemplate(pageTemplate, Offset.zero);
      //Save the document.
      final List<int> bytes = newDocument.saveSync();
      savePdf(bytes, 'FLUT_5132_Issue.pdf');
      //Close the document.
      newDocument.dispose();
    });
    test('FLUT_5132 - 0 rotation', () {
      final List<PdfPageRotateAngle> angle = <PdfPageRotateAngle>[
        PdfPageRotateAngle.rotateAngle0,
        PdfPageRotateAngle.rotateAngle90,
        PdfPageRotateAngle.rotateAngle180,
        PdfPageRotateAngle.rotateAngle270
      ];
      for (int i = 0; i < 4; i++) {
        final PdfDocument document = PdfDocument.fromBase64String(flut5132Pdf);
        final PdfPage page = document.pages[0];
        page.rotation = angle[i];
        //Save the document.
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason: 'failed  to get page rotation from existing PDF');
        savePdf(bytes, 'FLUT_5132_$i.pdf');
        //Close the document.
        document.dispose();
      }
    });
  });
  group('FLUT-7372 - Form fields not removed while removing page', () {
    test('test - 1', () {
      PdfDocument document = PdfDocument.fromBase64String(flut7372_1);
      document.fileStructure.incrementalUpdate = false;
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      while (document.pages.count > 1) {
        document.pages.removeAt(1);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.length < 148500, true);
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      expect(document.pages.count, 1);
      expect(document.form.fields.count, 39);
      savePdf(bytes, 'FLUT-7372_1.pdf');
      document.dispose();
    });
    test('test - 2', () async {
      PdfDocument document = PdfDocument.fromBase64String(flut7372_1);
      document.fileStructure.incrementalUpdate = false;
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      while (document.pages.count > 1) {
        document.pages.removeAt(1);
      }
      final List<int> bytes = await document.save();
      expect(bytes.length < 148500, true);
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      expect(document.pages.count, 1);
      expect(document.form.fields.count, 39);
      savePdf(bytes, 'FLUT-7372_2.pdf');
      document.dispose();
    });
    test('test - 3', () {
      PdfDocument document = PdfDocument.fromBase64String(flut7372_2);
      document.fileStructure.incrementalUpdate = false;
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      while (document.pages.count > 1) {
        document.pages.removeAt(1);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.length < 1600, true);
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      expect(document.pages.count, 1);
      expect(document.form.fields.count, 1);
      savePdf(bytes, 'FLUT-7372_3.pdf');
      document.dispose();
    });
    test('test - 4', () async {
      PdfDocument document = PdfDocument.fromBase64String(flut7372_2);
      document.fileStructure.incrementalUpdate = false;
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      while (document.pages.count > 1) {
        document.pages.removeAt(1);
      }
      final List<int> bytes = await document.save();
      expect(bytes.length < 1600, true);
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      expect(document.pages.count, 1);
      expect(document.form.fields.count, 1);
      savePdf(bytes, 'FLUT-7372_4.pdf');
      document.dispose();
    });
  });
}
