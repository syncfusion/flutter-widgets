import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pdfSection() {
  group('PdfSection', () {
    test('add pages in different sections - 1', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 20);
      final PdfSection section1 = document.sections!.add();
      final PdfSection section2 = document.sections!.add();
      section2.pageSettings.size = const Size(500, 650);
      final PdfPage page1_1 = section1.pages.add();
      page1_1.graphics.drawString('section 1, page 1', font);
      final PdfPage page2_1 = section2.pages.add();
      page2_1.graphics.drawString('section 2, page 1', font);
      final PdfPage page1_2 = section1.pages.add();
      page1_2.graphics.drawString('section 1, page 2', font);
      final PdfPage page2_2 = section2.pages.add();
      page2_2.graphics.drawString('section 2, page 2', font);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve section based page adding and accessing');
      savePdf(bytes, 'FLUT_492_Section1.pdf');
      document.dispose();
    });
    test('add pages in different sections - 2', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section1 = document.sections!.add();
      section1.pages.pageAdded = (Object obj, PageAddedArgs args) {
        args.page.graphics
            .drawLine(PdfPens.blue, const Offset(0, 50), const Offset(100, 50));
      };
      final PdfPage page1_1 = section1.pages.add();
      final PdfPage page1_2 = section1.pages.add();
      final PdfSection section2 = document.sections!.add();
      final PdfPage page2_1 = section2.pages.add();
      final PdfPage page2_2 = section2.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      page1_1.graphics.drawString('section 1, page 1', font);
      page2_1.graphics.drawString('section 2, page 1', font);
      page1_2.graphics.drawString('section 1, page 2', font);
      page2_2.graphics.drawString('section 2, page 2', font);
      document.pages[0].graphics.drawString(
          'document page collection indexers test - page 0', font,
          bounds: const Rect.fromLTWH(0, 50, 0, 0));
      document.pages[1].graphics.drawString(
          'document page collection indexers test - page 1', font,
          bounds: const Rect.fromLTWH(0, 50, 0, 0));
      document.pages[2].graphics.drawString(
          'document page collection indexers test - page 3', font,
          bounds: const Rect.fromLTWH(0, 50, 0, 0));
      document.pages[3].graphics.drawString(
          'document page collection indexers test - page 4', font,
          bounds: const Rect.fromLTWH(0, 50, 0, 0));
      section1.pages[0].graphics.drawString(
          'section page collection indexers test - page 0', font,
          bounds: const Rect.fromLTWH(0, 80, 0, 0));
      section1.pages[1].graphics.drawString(
          'section page collection indexers test - page 1', font,
          bounds: const Rect.fromLTWH(0, 80, 0, 0));
      section2.pages[0].graphics.drawString(
          'section page collection indexers test - page 0', font,
          bounds: const Rect.fromLTWH(0, 80, 0, 0));
      section2.pages[1].graphics.drawString(
          'section page collection indexers test - page 1', font,
          bounds: const Rect.fromLTWH(0, 80, 0, 0));

      final PdfPage newPage1 = document.pages.add();
      final PdfPage newPage2 = section1.pages.add();
      newPage1.graphics.drawString('document - pages added', font);
      newPage2.graphics.drawString('section - pages added', font);

      expect(section2.pages.indexOf(page2_2), 1,
          reason:
              'failed to return the index of page from section page collection');
      expect(document.pages.indexOf(page2_2), 4,
          reason:
              'failed to return the index of page from document page collection');

      expect(document.pages.count, 6,
          reason: 'Failed to retrieve the page count of PDF document');
      expect(section1.pages.count, 3,
          reason: 'Failed to retrieve the page count of PDF section');

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'Failed to support properties and methods in page collection for document and sections');
      savePdf(bytes, 'FLUT_492_Section2.pdf');
      document.dispose();
    });

    test('page settings', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      document.pageSettings.size = PdfPageSize.a3;
      final PdfPage pageStart = document.pages.add();
      pageStart.graphics.drawString('First page - A3 page size', font);
      final PdfSection section1 = document.sections!.add();
      section1.pageSettings.size = PdfPageSize.a4;
      final PdfPage page1_1 = section1.pages.add();
      final PdfPage page1_2 = section1.pages.add();
      final PdfSection section2 = document.sections!.add();
      section2.pageSettings.size = PdfPageSize.a5;
      final PdfPage page2_1 = section2.pages.add();
      final PdfPage page2_2 = section2.pages.add();
      page1_1.graphics.drawString('section 1, page 1 a4 page size', font);
      page2_1.graphics.drawString('section 2, page 1 a5 page size', font);
      page1_2.graphics.drawString('section 1, page 2 a4 page size', font);
      page2_2.graphics.drawString('section 2, page 2 a5 page size', font);

      final PdfPage pageEnd = document.pages.add();
      pageEnd.graphics.drawString('Second page - A5 page size', font);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve section based page settings');
      savePdf(bytes, 'FLUT_492_Section3.pdf');
      document.dispose();
    });
  });
}
