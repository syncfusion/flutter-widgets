import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: public_member_api_docs
void pdfCoverage() {
  group('PDF Coverage', () {
    // test('FLUT-1746 -1', () {
    //   final PdfDocument document = PdfDocument.fromBase64String(wf43816);
    //   final _PdfParser parser = _PdfParser(document._crossTable._crossTable!,
    //       document._crossTable._crossTable!.reader, document._crossTable);
    //   parser._rebuildXrefTable(document._crossTable._crossTable!._objects,
    //       document._crossTable._crossTable);
    //   expect(document._crossTable.count, 24,
    //       reason: 'cross table count mismatch');
    //   document.dispose();
    // });
    // test('FLUT-1746 -2', () {
    //   final PdfDocument document = PdfDocument.fromBase64String(wf52195);
    //   final _PdfParser parser = _PdfParser(document._crossTable._crossTable!,
    //       document._crossTable._crossTable!.reader, document._crossTable);
    //   parser._readUnicodeString('þÿ');
    //   document.dispose();
    // });
    // test('FLUT-1746 -3', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();
    //   page.graphics._setTransparencyGroup(page);
    //   page.graphics._reset(PdfPageSize.a4);
    //   final PdfColor colors = PdfColor._empty();
    //   colors.r = 255;
    //   colors.g = 0;
    //   colors.b = 10;
    //   final _PdfTransparency trans =
    //       _PdfTransparency(10, 10, PdfBlendMode.normal);
    //   expect(10, trans.stroke);
    //   expect(10, trans.fill);
    //   final PdfPen pen = PdfPen._immutable(colors);
    //   pen._setDashStyle(PdfDashStyle.custom);
    //   pen._setDashStyle(PdfDashStyle.dash);
    //   pen._setDashStyle(PdfDashStyle.dot);
    //   pen._setDashStyle(PdfDashStyle.dashDot);
    //   pen._setDashStyle(PdfDashStyle.dashDotDot);
    //   pen._setDashStyle(PdfDashStyle.solid);
    //   final _DecompressedOutput output = _DecompressedOutput();
    //   expect(output.usedBytes, 0, reason: 'compressed used bytes mismatch');
    //   final PdfDictionary dict = PdfDictionary();
    //   expect(dict._getInt(''), 0);
    // });
    test('FLUT-1746 -4', () {
      final PdfDocument document = PdfDocument();
      const Rect bounds = Rect.fromLTWH(100, 150, 200, 200);
      final PdfPageTemplateElement element = PdfPageTemplateElement(bounds);
      final PdfSection section = document.sections!.add();
      final PdfPageSettings settings =
          PdfPageSettings(PdfPageSize.a4, PdfPageOrientation.portrait);
      section.pageSettings = settings;
      final PdfSectionTemplate template = PdfSectionTemplate();
      section.template = template;
      document.template = template;
      document.colorSpace = PdfColorSpace.rgb;
      element.width = 100;
      element.height = 100;
      expect(element.size.width, 100, reason: 'width mismatch');
    });
  });
}
