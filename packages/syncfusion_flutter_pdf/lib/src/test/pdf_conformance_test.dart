import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'fonts.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pdfConformance() {
  group('Pdf conformance level A1B', () {
    test('test 1', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      page.graphics.drawString('Hello World!', trueTypeFont,
          bounds: const Rect.fromLTWH(20, 20, 200, 50));
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
      expect(() => security.userPassword = 'password',
          throwsA(isInstanceOf<ArgumentError>()));
      expect(() => security.ownerPassword = 'syncfusion',
          throwsA(isInstanceOf<ArgumentError>()));
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      expect(() => page.graphics.drawString('Hello World!', font),
          throwsA(isInstanceOf<ArgumentError>()));
      final PdfActionAnnotation annotation = PdfActionAnnotation(
          const Rect.fromLTWH(100, 100, 50, 50),
          PdfUriAction('http://www.google.com'));
      page.annotations.add(annotation);
      expect(() => document.saveSync(), throwsA(isInstanceOf<ArgumentError>()));
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfGraphicsState state = graphics.save();
      graphics.setTransparency(0.5);
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(thaiTTF, 20);
      page.graphics.drawString('Thai 보관 상태 점검 및', trueTypeFont,
          bounds: const Rect.fromLTWH(20, 20, 200, 50));
      graphics.restore(state);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_2.pdf');
      document.dispose();
    });
    test('test 4', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation',
          innerColor: PdfColor(255, 0, 0), color: PdfColor(255, 255, 0));
      page.annotations.add(ellipseAnnotation);
      final PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 200, 80, 80), 'SquareAnnotation',
          innerColor: PdfColor(255, 0, 0), color: PdfColor(255, 255, 0));
      page.annotations.add(rectangleAnnotation);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_3.pdf');
      document.dispose();
    });
    test('test 5', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfTemplate template = PdfTemplate(100, 50);
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      template.graphics!.drawString('Hello World!', trueTypeFont,
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(5, 5, 0, 0));
      document.pages.add().graphics.drawPdfTemplate(template, Offset.zero);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_4.pdf');
      document.dispose();
    });
    test('test 6', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfTemplate template = PdfTemplate(100, 50);
      final PdfStandardFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      template.graphics!.drawString('Hello World!', font,
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(5, 5, 0, 0));
      expect(
          () => document.pages
              .add()
              .graphics
              .drawPdfTemplate(template, Offset.zero),
          throwsA(isInstanceOf<ArgumentError>()));
      document.dispose();
    });
    test('test 7', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      expect(
          () => page.graphics.drawString(
              '보관 상태 점검 및',
              PdfCjkStandardFont(
                  PdfCjkFontFamily.hanyangSystemsGothicMedium, 14),
              bounds: const Rect.fromLTWH(20, 20, 200, 50)),
          throwsA(isInstanceOf<ArgumentError>()));
      document.dispose();
    });
    test('test 8', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      final PdfListItem listItem1 = PdfListItem(text: 'Pdf');
      final PdfListItem listItem2 = PdfListItem(text: 'XlsIO');
      final PdfListItem listItem3 = PdfListItem(text: 'DocIO');
      final PdfListItem listItem4 = PdfListItem(text: 'PPT');
      final PdfListItemCollection collection1 = PdfListItemCollection();
      collection1.add(listItem1);
      collection1.add(listItem2);
      collection1.add(listItem3);
      collection1.add(listItem4);
      final PdfStringFormat format1 = PdfStringFormat();
      format1.lineSpacing = 20;
      final PdfOrderedList oList = PdfOrderedList(items: collection1);
      oList.indent = 20;
      oList.textIndent = 10;
      oList.stringFormat = format1;
      oList.font = font;
      oList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_5.pdf');
      document.dispose();
    });
    test('test 9', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      final PdfBookmark bookmark1 = document.bookmarks.add('bookmark 1');
      bookmark1.destination = PdfDestination(page);
      bookmark1.destination!.location = const Offset(300, 400);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_6.pdf');
      document.dispose();
    });
    test('test 10', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfGrid grid1 = PdfGrid();
      grid1.style =
          PdfGridStyle(font: PdfTrueTypeFont.fromBase64String(arialTTF, 12));
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = 'Row - 2 Cell - 1';
      row2_1.cells[1].value = 'Row - 2 Cell - 2';
      row2_1.cells[2].value = 'Row - 2 Cell - 3';
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_7.pdf');
      document.dispose();
    });
    test('test 11', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.invert;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_8.pdf');
      document.dispose();
    });
    test('test 12', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.outline;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_9.pdf');
      document.dispose();
    });
    test('test 13', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.push;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_10.pdf');
      document.dispose();
    });
    test('test 14', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.noHighlighting;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a1b_11.pdf');
      document.dispose();
    });
  });
  group('Pdf conformance level A2B', () {
    test('test 1', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      page.graphics.drawString('Hello World!', trueTypeFont,
          bounds: const Rect.fromLTWH(20, 20, 200, 50));
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfPageLayer layer = page.layers.add(name: 'Layer');
      final PdfGraphics graphics = layer.graphics;
      graphics.translateTransform(100, 60);
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      graphics.drawString('Hello World!!!', trueTypeFont);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_2.pdf');
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfGraphicsState state = graphics.save();
      graphics.setTransparency(0.25);
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(thaiTTF, 20);
      page.graphics.drawString('Thai 보관 상태 점검 및', trueTypeFont,
          bounds: const Rect.fromLTWH(20, 20, 200, 50));
      graphics.restore(state);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_3.pdf');
      document.dispose();
    });
    test('test 4', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation',
          innerColor: PdfColor(255, 0, 0),
          color: PdfColor(255, 255, 0),
          setAppearance: true);
      page.annotations.add(ellipseAnnotation);
      final PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 200, 80, 80), 'SquareAnnotation',
          innerColor: PdfColor(255, 0, 0),
          color: PdfColor(255, 255, 0),
          setAppearance: true);
      page.annotations.add(rectangleAnnotation);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_4.pdf');
      document.dispose();
    });
    test('test 5', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfTemplate template = PdfTemplate(100, 50);
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      template.graphics!.drawString('Hello World!', trueTypeFont,
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(5, 5, 0, 0));
      document.pages.add().graphics.drawPdfTemplate(template, Offset.zero);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_5.pdf');
      document.dispose();
    });
    test('test 6', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation',
          innerColor: PdfColor(255, 0, 0), color: PdfColor(255, 255, 0));
      page.annotations.add(ellipseAnnotation);
      expect(() => document.saveSync(), throwsA(isInstanceOf<ArgumentError>()));
      document.dispose();
    });
    test('test 7', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      final PdfListItem listItem1 = PdfListItem(text: 'Pdf');
      final PdfListItem listItem2 = PdfListItem(text: 'XlsIO');
      final PdfListItem listItem3 = PdfListItem(text: 'DocIO');
      final PdfListItem listItem4 = PdfListItem(text: 'PPT');
      final PdfListItemCollection collection1 = PdfListItemCollection();
      collection1.add(listItem1);
      collection1.add(listItem2);
      collection1.add(listItem3);
      collection1.add(listItem4);
      final PdfStringFormat format1 = PdfStringFormat();
      format1.lineSpacing = 20;
      final PdfOrderedList oList = PdfOrderedList(items: collection1);
      oList.indent = 20;
      oList.textIndent = 10;
      oList.stringFormat = format1;
      oList.font = font;
      oList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_6.pdf');
      document.dispose();
    });
    test('test 8', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfBookmark bookmark1 = document.bookmarks.add('bookmark 1');
      bookmark1.destination = PdfDestination(page);
      bookmark1.destination!.location = const Offset(300, 400);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_7.pdf');
      document.dispose();
    });
    test('test 9', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfGrid grid1 = PdfGrid();
      grid1.style =
          PdfGridStyle(font: PdfTrueTypeFont.fromBase64String(arialTTF, 12));
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = 'Row - 2 Cell - 1';
      row2_1.cells[1].value = 'Row - 2 Cell - 2';
      row2_1.cells[2].value = 'Row - 2 Cell - 3';
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_8.pdf');
      document.dispose();
    });
    test('test 10', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.invert;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_9.pdf');
      document.dispose();
    });
    test('test 11', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.outline;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_10.pdf');
      document.dispose();
    });
    test('test 12', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.push;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_11.pdf');
      document.dispose();
    });
    test('test 13', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.noHighlighting;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2675_conformance_a2b_12.pdf');
      document.dispose();
    });
  });
  group('Pdf conformance level A3B', () {
    test('test 1', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      page.graphics.drawString('Hello World!', trueTypeFont,
          bounds: const Rect.fromLTWH(20, 20, 200, 50));
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfPageLayer layer = page.layers.add(name: 'Layer');
      final PdfGraphics graphics = layer.graphics;
      graphics.translateTransform(100, 60);
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      graphics.drawString('Hello World!!!', trueTypeFont);
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_2.pdf');
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfTemplate template = PdfTemplate(100, 50);
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      template.graphics!.drawString('Hello World!', trueTypeFont,
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(5, 5, 0, 0));
      document.pages.add().graphics.drawPdfTemplate(template, Offset.zero);
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_3.pdf');
      document.dispose();
    });
    test('test 4', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation',
          innerColor: PdfColor(255, 0, 0), color: PdfColor(255, 255, 0));
      page.annotations.add(ellipseAnnotation);
      expect(() => document.saveSync(), throwsA(isInstanceOf<ArgumentError>()));
      document.dispose();
    });
    test('test 5', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation',
          innerColor: PdfColor(255, 0, 0),
          color: PdfColor(255, 255, 0),
          setAppearance: true);
      page.annotations.add(ellipseAnnotation);
      final PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 200, 80, 80), 'SquareAnnotation',
          innerColor: PdfColor(255, 0, 0),
          color: PdfColor(255, 255, 0),
          setAppearance: true);
      page.annotations.add(rectangleAnnotation);
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_4.pdf');
      document.dispose();
    });
    test('test 6', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfGraphicsState state = graphics.save();
      graphics.setTransparency(0.25);
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(thaiTTF, 20);
      page.graphics.drawString('Thai 보관 상태 점검 및', trueTypeFont,
          bounds: const Rect.fromLTWH(20, 20, 200, 50));
      graphics.restore(state);
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_5.pdf');
      document.dispose();
    });
    test('test 7', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      final PdfListItem listItem1 = PdfListItem(text: 'Pdf');
      final PdfListItem listItem2 = PdfListItem(text: 'XlsIO');
      final PdfListItem listItem3 = PdfListItem(text: 'DocIO');
      final PdfListItem listItem4 = PdfListItem(text: 'PPT');
      final PdfListItemCollection collection1 = PdfListItemCollection();
      collection1.add(listItem1);
      collection1.add(listItem2);
      collection1.add(listItem3);
      collection1.add(listItem4);
      final PdfStringFormat format1 = PdfStringFormat();
      format1.lineSpacing = 20;
      final PdfOrderedList oList = PdfOrderedList(items: collection1);
      oList.indent = 20;
      oList.textIndent = 10;
      oList.stringFormat = format1;
      oList.font = font;
      oList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_6.pdf');
      document.dispose();
    });
    test('test 8', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfBookmark bookmark1 = document.bookmarks.add('bookmark 1');
      bookmark1.destination = PdfDestination(page);
      bookmark1.destination!.location = const Offset(300, 400);
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_7.pdf');
      document.dispose();
    });
    test('test 9', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfGrid grid1 = PdfGrid();
      grid1.style =
          PdfGridStyle(font: PdfTrueTypeFont.fromBase64String(arialTTF, 12));
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = 'Row - 2 Cell - 1';
      row2_1.cells[1].value = 'Row - 2 Cell - 2';
      row2_1.cells[2].value = 'Row - 2 Cell - 3';
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_8.pdf');
      document.dispose();
    });
    test('test 10', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.invert;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_9.pdf');
      document.dispose();
    });
    test('test 11', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.outline;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_10.pdf');
      document.dispose();
    });
    test('test 12', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.push;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_11.pdf');
      document.dispose();
    });
    test('test 13', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfPage page = document.pages.add();
      final PdfDocumentLinkAnnotation annotation = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(20, 20, 100, 50),
          PdfDestination(page, const Offset(400, 400)));
      annotation.highlightMode = PdfHighlightMode.noHighlighting;
      page.annotations.add(annotation);
      savePdf(document.saveSync(), 'FLUT_2677_conformance_a3b_12.pdf');
      document.dispose();
    });
  });
}
