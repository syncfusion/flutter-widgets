import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/pdf_document/automatic_fields/pdf_automatic_field.dart';
import '../pdf/implementation/pdf_document/automatic_fields/pdf_date_time_field.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void headerAndFooter() {
  group('Header test1', () {
    test('Top', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      header.graphics.drawString('This is header at top', font, brush: brush);
      document.template.top = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw header at top');
      document.dispose();
    });
    test('Even top', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      header.graphics
          .drawString('This is header at even top', font, brush: brush);
      document.template.evenTop = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw header at top even');
      document.dispose();
    });
    test('Odd top', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      header.graphics
          .drawString('This is header at odd top', font, brush: brush);
      document.template.oddTop = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw header at top odd');
      document.dispose();
    });
  });

  group('Header test2', () {
    test('Right', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      header.graphics.drawString('This is header at Right', font, brush: brush);
      document.template.right = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw header at right');
      document.dispose();
    });
    test('Even right', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      header.graphics
          .drawString('This is header at even right', font, brush: brush);
      document.template.evenRight = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw header at right even');
      document.dispose();
    });
    test('Odd right', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      header.graphics
          .drawString('This is header at odd right', font, brush: brush);
      document.template.oddRight = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw header at right odd');
      document.dispose();
    });
    test('left', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      header.graphics.drawString('This is header at left', font, brush: brush);
      document.template.left = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw header at left');
      document.dispose();
    });
    test('Even left', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      header.graphics
          .drawString('This is header at even left', font, brush: brush);
      document.template.evenLeft = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw header at left even');
      document.dispose();
    });
    test('Odd left', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      header.graphics
          .drawString('This is header at odd right', font, brush: brush);
      document.template.oddLeft = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw header at left odd');
      document.dispose();
    });
  });

  group('Footer test', () {
    test('Bottom', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement footer =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      footer.graphics
          .drawString('This is footer at bottom', font, brush: brush);
      document.template.bottom = footer;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw footer at bottom');
      document.dispose();
    });
    test('Even bottom', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement footer =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      footer.graphics
          .drawString('This is footer at even buttom', font, brush: brush);
      document.template.evenBottom = footer;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw footer at bottom even');
      document.dispose();
    });
    test('Odd bottom', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page1.graphics.drawString('page1', font);
      page2.graphics.drawString('page2', font);
      page3.graphics.drawString('page3', font);
      page4.graphics.drawString('page4', font);
      page5.graphics.drawString('page5', font);
      final PdfPageTemplateElement footer =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 512, 50));
      footer.graphics
          .drawString('This is footer at odd bottom', font, brush: brush);
      document.template.oddTop = footer;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw footer at bottom odd');
      document.dispose();
    });
  });
  group('HeaderFooter test case with sample', () {
    test('Top', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement header = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
      header.graphics.drawString('Top', font1, brush: brush);
      document.template.top = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw header at top');
      document.dispose();
    });
    test('Bottom', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement footer = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
      footer.graphics.drawString('Bottom', font1, brush: brush);
      document.template.bottom = footer;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw footer at bottom');
      savePdf(bytes, 'FLUT-552-HeaderFooterSample.pdf');
      document.dispose();
    });
  });

  group('HeaderFooter right left with sample', () {
    test('Left', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement header = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, 50, document.pages[0].getClientSize().width));
      header.graphics.rotateTransform(-270);
      header.graphics.drawString('left template', font1,
          brush: brush, bounds: const Rect.fromLTWH(10, -50, 0, 0));
      document.template.left = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw template at left');
      document.dispose();
    });
    test('Right', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement footer = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, 50, document.pages[0].getClientSize().width));
      footer.graphics.rotateTransform(-270);
      footer.graphics.drawString('right template', font1,
          brush: brush, bounds: const Rect.fromLTWH(10, -50, 0, 0));
      document.template.right = footer;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw template at right');
      savePdf(bytes, 'FLUT-552-HeaderFooterRightLeft.pdf');
      document.dispose();
    });
  });

  group('HeaderFooter EvenOdd test case with sample', () {
    test('Even Top', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement header = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
      header.graphics.drawString('Even top', font1, brush: brush);
      document.template.evenTop = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw header at top even');
      document.dispose();
    });
    test('Odd top', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement header = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
      header.graphics.drawString('Odd top', font1, brush: brush);
      document.template.oddTop = header;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw header at top odd');
      savePdf(bytes, 'FLUT-552-HeaderFooterOddEven_1.pdf');
      document.dispose();
    });
    test('Even buttom', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement footer = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
      footer.graphics.drawString('Even bottom', font1, brush: brush);
      document.template.evenBottom = footer;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw footer at even bottom');
      document.dispose();
    });
    test('Odd top', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement footer = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
      footer.graphics.drawString('Odd bottom', font1, brush: brush);
      document.template.oddBottom = footer;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw footer odd bottom');
      savePdf(bytes, 'FLUT-552-HeaderFooterOddEven_2.pdf');
      document.dispose();
    });
  });

  group('HeaderFooter EvenOdd test case with sample', () {
    test('Even Left', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement template = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, 50, document.pages[0].getClientSize().width));
      template.graphics.rotateTransform(-270);
      template.graphics.drawString('Even left template', font1,
          brush: brush, bounds: const Rect.fromLTWH(10, -50, 0, 0));
      document.template.evenLeft = template;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw template at even left');
      document.dispose();
    });
    test('Odd left', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement template1 = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, 50, document.pages[0].getClientSize().width));
      template1.graphics.rotateTransform(-270);
      template1.graphics.drawString('Odd left template', font1,
          brush: brush, bounds: const Rect.fromLTWH(10, -50, 0, 0));
      document.template.oddLeft = template1;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw header at top odd');
      savePdf(bytes, 'FLUT-552-HeaderFooterOddEven.pdf');
      document.dispose();
    });
    test('Even right', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement template2 = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, 50, document.pages[0].getClientSize().width));
      template2.graphics.rotateTransform(-270);
      template2.graphics.drawString('Even right template', font1,
          brush: brush, bounds: const Rect.fromLTWH(10, -50, 0, 0));
      document.template.evenRight = template2;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw footer at even bottom');
      document.dispose();
    });
    test('Odd right', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement template3 = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, 50, document.pages[0].getClientSize().width));
      template3.graphics.rotateTransform(-270);
      template3.graphics.drawString('Odd right template', font1,
          brush: brush, bounds: const Rect.fromLTWH(10, -50, 0, 0));
      document.template.oddRight = template3;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw footer odd bottom');
      savePdf(bytes, 'FLUT-552-HeaderFooterRightLeftOddEven.pdf');
      document.dispose();
    });
  });

  group('Header footer with page number, count and composite field', () {
    test('sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 300));
      final PdfCompositeField compositefields = PdfCompositeField();
      compositefields.text = '{0}      Header';
      compositefields.font = font1;
      final PdfDateTimeField dateAndTimeField =
          PdfDateTimeField(font: font1, brush: brush);
      dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
      compositefields.fields.add(dateAndTimeField);
      compositefields.draw(header.graphics, Offset(0, 50 - font.height));
      document.template.top = header;
      final PdfPageTemplateElement footer =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
      final PdfPageNumberField pageNumber =
          PdfPageNumberField(font: font1, brush: brush);
      pageNumber.numberStyle = PdfNumberStyle.upperRoman;
      final PdfPageCountField count =
          PdfPageCountField(font: font1, brush: brush);
      count.numberStyle = PdfNumberStyle.upperRoman;
      final PdfCompositeField compositeField = PdfCompositeField(
          font: font1, brush: brush, text: 'Page {0} of {1}, Time:{2}');
      final PdfDateTimeField dateTimeField =
          PdfDateTimeField(font: font1, brush: brush);
      dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateTimeField.dateFormatString = "hh':'mm':'ss";
      compositeField.fields.add(pageNumber);
      compositeField.fields.add(count);
      compositeField.fields.add(dateTimeField);
      compositeField.bounds = footer.bounds;
      compositeField.draw(footer.graphics, Offset(290, 50 - font1.height));
      document.template.bottom = footer;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw Header footer.');
      savePdf(bytes, 'FLUT-552-HeaderFooter.pdf');
      document.dispose();
    });
  });

  group('templateElement test case with sample', () {
    test('Docks', () {
      final PdfDocument document = PdfDocument();
      document.pageSettings.setMargins(25);
      final PdfPage page = document.pages.add();
      const Rect rect = Rect.fromLTWH(0, 0, 100, 100);
      final PdfSolidBrush brush = PdfSolidBrush(PdfColor(173, 255, 47));
      final PdfPen pen = PdfPen(PdfColor(255, 165, 0), width: 3);
      final PdfPageTemplateElement custom = PdfPageTemplateElement(rect, page);
      document.template.stamps.add(custom);
      custom.dock = PdfDockStyle.fill;
      custom.graphics.drawRectangle(pen: pen, brush: brush, bounds: rect);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw dock style with template');
      savePdf(bytes, 'FLUT-552-TemplateElementWithDockFill.pdf');
      document.dispose();
    });
  });

  group('templateElement test case with sample', () {
    test('Docks', () {
      for (final PdfDockStyle dock in PdfDockStyle.values) {
        final PdfDocument document = PdfDocument();
        document.pageSettings.setMargins(25);
        final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
        final PdfPage page = document.pages.add();
        page.graphics.drawString('$dock', font,
            bounds: const Rect.fromLTWH(250, 0, 615, 100));
        const Rect rect = Rect.fromLTWH(0, 0, 100, 100);
        final PdfSolidBrush brush = PdfSolidBrush(PdfColor(173, 255, 47));
        final PdfPen pen = PdfPen(PdfColor(255, 165, 0), width: 3);
        final PdfPageTemplateElement custom = PdfPageTemplateElement(rect);
        document.template.stamps.add(custom);
        custom.dock = dock;
        custom.graphics.drawRectangle(pen: pen, brush: brush, bounds: rect);
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason: 'failed  to draw dock style with template');
        savePdf(bytes, 'FLUT-552-TemplateElementWith$dock.pdf');
        document.dispose();
      }
    });
  });

  group('templateElement test case with sample', () {
    test('Aligments', () {
      final PdfDocument document = PdfDocument();
      document.pageSettings.setMargins(25);
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfPage page = document.pages.add();
      page.graphics.drawString('alignment', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      for (final PdfAlignmentStyle alignment in PdfAlignmentStyle.values) {
        const Rect rect = Rect.fromLTWH(0, 0, 100, 100);
        final PdfSolidBrush brush = PdfSolidBrush(PdfColor(173, 255, 47));
        final PdfPen pen = PdfPen(PdfColor(255, 165, 0), width: 3);
        final PdfPageTemplateElement custom = PdfPageTemplateElement(rect);
        document.template.stamps.add(custom);
        custom.alignment = alignment;
        custom.graphics.drawRectangle(pen: pen, brush: brush, bounds: rect);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw Alignments with template');
      savePdf(bytes, 'FLUT-552-TemplateElementWithAlignment.pdf');
      document.dispose();
    });
  });

  group('templateElement test case with sample', () {
    test('Aligments', () {
      final PdfDocument document = PdfDocument();
      document.pageSettings.setMargins(25);
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfPage page = document.pages.add();
      page.graphics.drawString('alignment', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      const Rect rect = Rect.fromLTWH(0, 0, 100, 100);
      final PdfSolidBrush brush = PdfSolidBrush(PdfColor(173, 255, 47));
      final PdfPen pen = PdfPen(PdfColor(255, 165, 0), width: 3);
      final PdfPageTemplateElement custom = PdfPageTemplateElement(rect);
      document.template.stamps.add(custom);
      custom.dock = PdfDockStyle.top;
      custom.alignment = PdfAlignmentStyle.middleCenter;
      custom.graphics.drawRectangle(pen: pen, brush: brush, bounds: rect);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw Alignments with template');
      savePdf(bytes, 'FLUT-552-TemplateElementWithAlignmentDock.pdf');
      document.dispose();
    });
  });
  group('templateElement test case with sample', () {
    test('right, left, top, bottom', () {
      final PdfDocument document = PdfDocument();
      document.pageSettings.setMargins(25);
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfPage page = document.pages.add();
      page.graphics.drawString('alignment', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      const Rect rect1 = Rect.fromLTWH(0, 0, 100, 100);
      final PdfSolidBrush brush1 = PdfSolidBrush(PdfColor(173, 255, 47));
      final PdfPen pen1 = PdfPen(PdfColor(255, 165, 0), width: 3);
      final PdfPageTemplateElement custom1 = PdfPageTemplateElement(rect1);
      document.template.stamps.add(custom1);
      custom1.alignment = PdfAlignmentStyle.bottomCenter;
      custom1.graphics.drawRectangle(pen: pen1, brush: brush1, bounds: rect1);
      document.template.top = custom1;
      const Rect rect2 = Rect.fromLTWH(0, 0, 100, 100);
      final PdfSolidBrush brush2 = PdfSolidBrush(PdfColor(173, 255, 47));
      final PdfPen pen2 = PdfPen(PdfColor(255, 165, 0), width: 3);
      final PdfPageTemplateElement custom2 = PdfPageTemplateElement(rect2);
      document.template.stamps.add(custom2);
      custom2.alignment = PdfAlignmentStyle.bottomCenter;
      custom2.graphics.drawRectangle(pen: pen2, brush: brush2, bounds: rect2);
      document.template.bottom = custom2;
      const Rect rect3 = Rect.fromLTWH(0, 0, 100, 100);
      final PdfSolidBrush brush3 = PdfSolidBrush(PdfColor(173, 255, 47));
      final PdfPen pen3 = PdfPen(PdfColor(255, 165, 0), width: 3);
      final PdfPageTemplateElement custom3 = PdfPageTemplateElement(rect3);
      document.template.stamps.add(custom3);
      custom3.alignment = PdfAlignmentStyle.bottomCenter;
      custom3.graphics.drawRectangle(pen: pen3, brush: brush3, bounds: rect3);
      document.template.left = custom3;
      for (final PdfAlignmentStyle alignment in PdfAlignmentStyle.values) {
        const Rect rect4 = Rect.fromLTWH(0, 0, 100, 100);
        final PdfSolidBrush brush4 = PdfSolidBrush(PdfColor(173, 255, 47));
        final PdfPen pen4 = PdfPen(PdfColor(255, 165, 0), width: 3);
        final PdfPageTemplateElement custom4 = PdfPageTemplateElement(rect4);
        document.template.stamps.add(custom4);
        custom4.alignment = alignment;
        custom4.graphics.drawRectangle(pen: pen4, brush: brush4, bounds: rect4);
        document.template.right = custom4;
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw Alignments with template');
      savePdf(bytes, 'FLUT-552-TemplateElementWithAlignment&Dock.pdf');
      document.dispose();
    });
  });

  group('templateElement test case with sample', () {
    test('Aligments', () {
      final PdfDocument document = PdfDocument();
      document.pageSettings.setMargins(25);
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfPage page = document.pages.add();
      page.graphics.drawString('alignment', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      const Rect rect = Rect.fromLTWH(0, 0, 100, 100);
      final PdfSolidBrush brush = PdfSolidBrush(PdfColor(173, 255, 47));
      final PdfPen pen = PdfPen(PdfColor(255, 165, 0), width: 3);
      final PdfPageTemplateElement custom = PdfPageTemplateElement(rect);
      const Rect bounds = Rect.fromLTWH(0, 0, 105, 105);
      if (custom.bounds != bounds) {
        custom.bounds = bounds;
      }
      custom.background = true;
      expect(custom.background, !custom.foreground,
          reason: 'template background not to be valid');
      custom.bounds = const Offset(5, 5) & const Size(110, 110);
      document.template.stamps.add(custom);
      custom.dock = PdfDockStyle.top;
      if (custom.alignment != PdfAlignmentStyle.middleCenter) {
        custom.alignment = PdfAlignmentStyle.middleCenter;
      }
      custom.graphics.drawRectangle(pen: pen, brush: brush, bounds: rect);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw Alignments with template');
      savePdf(bytes, 'FLUT-552-TemplateElementWithTestFile.pdf');
      document.dispose();
    });
  });

  group('Page Number Convertion', () {
    test('Page number convertor 1', () {
      expect(
          PdfAutomaticFieldHelper.convert(26, PdfNumberStyle.lowerLatin), 'z',
          reason: 'failed to perform number convertion');
    });
    test('Page number convertor 3', () {
      expect(
          PdfAutomaticFieldHelper.convert(29, PdfNumberStyle.lowerLatin), 'ac',
          reason: 'failed to perform number convertion');
    });
  });

  group('Page number field test', () {
    test('Page number with numeric', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200));
      pageNumber.numberStyle = PdfNumberStyle.numeric;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = document.pages.add();
        pageNumber.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw numeric page number');
      document.dispose();
    });
    test('Page number with upperLatin', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200));
      pageNumber.numberStyle = PdfNumberStyle.upperLatin;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = document.pages.add();
        pageNumber.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw upperLatin page number');
      document.dispose();
    });
    test('Page number with lowerLatin', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200));
      pageNumber.numberStyle = PdfNumberStyle.lowerLatin;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = document.pages.add();
        pageNumber.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw lowerLatin page number');
      document.dispose();
    });
    test('Page number with upperRoman', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200));
      pageNumber.numberStyle = PdfNumberStyle.upperRoman;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = document.pages.add();
        pageNumber.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw upperRoman page number');
      document.dispose();
    });
    test('Page number with lowerRoman', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200));
      pageNumber.numberStyle = PdfNumberStyle.lowerRoman;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = document.pages.add();
        pageNumber.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw lowerRoman page number');
      document.dispose();
    });
  });

  group('Section page number field test', () {
    test('Section page number with numeric', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section = document.sections!.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200),
          isSectionPageNumber: true);
      pageNumber.numberStyle = PdfNumberStyle.numeric;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = section.pages.add();
        pageNumber.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw numeric Section page number');
      document.dispose();
    });
    test('Section page number with upperLatin', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section = document.sections!.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200),
          isSectionPageNumber: true);
      pageNumber.numberStyle = PdfNumberStyle.upperLatin;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = section.pages.add();
        pageNumber.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw upperLatin Section page number');
      document.dispose();
    });
    test('Section page number with lowerLatin', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section = document.sections!.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200),
          isSectionPageNumber: true);
      pageNumber.numberStyle = PdfNumberStyle.lowerLatin;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = section.pages.add();
        pageNumber.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw lowerLatin Section page number');
      document.dispose();
    });
    test('Section page number with upperRoman', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section = document.sections!.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200),
          isSectionPageNumber: true);
      pageNumber.numberStyle = PdfNumberStyle.upperRoman;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = section.pages.add();
        pageNumber.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw upperRoman Section page number');
      document.dispose();
    });
    test('Section page number with lowerRoman', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section = document.sections!.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200),
          isSectionPageNumber: true);
      pageNumber.numberStyle = PdfNumberStyle.lowerRoman;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = section.pages.add();
        pageNumber.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw lowerRoman Section page number');
      document.dispose();
    });
  });

  group('Page count field test', () {
    test('Page count', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageCountField pageCount = PdfPageCountField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200));
      pageCount.numberStyle = PdfNumberStyle.numeric;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = document.pages.add();
        pageCount.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw page count');
      document.dispose();
    });
  });

  group('Section page count field test', () {
    test('Section page count', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section = document.sections!.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageCountField pageCount = PdfPageCountField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200),
          isSectionPageCount: true);
      pageCount.numberStyle = PdfNumberStyle.numeric;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = section.pages.add();
        pageCount.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw Section page count');
      document.dispose();
    });
  });

  group('Page number and section number with sample', () {
    test('file', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 24);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200));
      pageNumber.numberStyle = PdfNumberStyle.numeric;
      final PdfPageCountField pageCount = PdfPageCountField();
      pageCount.font = font;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = document.pages.add();
        page.graphics.drawString('Page number', font,
            bounds: const Rect.fromLTWH(0, 100, 0, 0));
        pageNumber.draw(page.graphics, const Offset(250, 100));
        page.graphics.drawString('Total page count', font,
            bounds: const Rect.fromLTWH(0, 250, 0, 0));
        pageCount.draw(page.graphics, const Offset(250, 250));
      }
      final PdfSection section = document.sections!.add();
      final PdfPageCountField sectionCount =
          PdfPageCountField(isSectionPageCount: true);
      sectionCount.font = font;
      final PdfPageNumberField sectionNumber = PdfPageNumberField(
          font: font,
          brush: brush,
          bounds: const Rect.fromLTWH(10, 10, 100, 200),
          isSectionPageNumber: true);
      sectionNumber.numberStyle = PdfNumberStyle.upperLatin;
      for (int i = 0; i != 3; i++) {
        final PdfPage page = section.pages.add();
        page.graphics.drawString('SectionPage number', font,
            bounds: const Rect.fromLTWH(0, 100, 0, 0));
        sectionNumber.draw(page.graphics, const Offset(250, 100));
        page.graphics.drawString('Section page count', font,
            bounds: const Rect.fromLTWH(0, 250, 0, 0));
        sectionCount.draw(page.graphics, const Offset(250, 250));
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw numeric page number');
      savePdf(bytes, 'FLUT-552-PageSectionNumber.pdf');
      document.dispose();
    });
  });

  group('Page number and destination page number sample file', () {
    test('Page number with different type of number style', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      page.graphics
          .drawString('Page number with different type of number style', font);
      double y = 20;
      for (final PdfNumberStyle numberStyle in PdfNumberStyle.values) {
        final PdfPageNumberField pageNumber = PdfPageNumberField(
            font: font,
            brush: brush,
            bounds: const Rect.fromLTWH(10, 10, 100, 200));
        pageNumber.numberStyle = numberStyle;
        pageNumber.draw(page.graphics, Offset(200, y));
        y += font.height + 10;
      }
      final PdfPage page1 = document.pages.add();
      page.graphics.drawString(
          'Assign the second page as destination page and draw that value in it:',
          font,
          bounds: Rect.fromLTWH(0, y + 30, 0, 0));
      for (final PdfNumberStyle numberStyle in PdfNumberStyle.values) {
        final PdfDestinationPageNumberField des =
            PdfDestinationPageNumberField(font: font, page: page1);
        des.numberStyle = numberStyle;
        des.draw(page.graphics, Offset(200, y + 50));
        y += font.height + 10;
      }
      final PdfDestinationPageNumberField destination =
          PdfDestinationPageNumberField(font: font);
      if (destination.page != page1) {
        destination.page = page1;
      }
      final PdfCompositeField compositeField = PdfCompositeField(
          font: font,
          text: 'The Destination page number: {0}',
          fields: <PdfAutomaticField>[destination]);
      compositeField.draw(page1.graphics);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw numeric page number');
      savePdf(bytes, 'FLUT-552-PageNumberWithStyle.pdf');
      document.dispose();
    });
  });

  group('Composite field with page graphics', () {
    test('sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 18);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPen pen = PdfPens.black;
      final PdfCompositeField compositeField = PdfCompositeField();
      if (compositeField.font != font) {
        compositeField.font = font;
      }
      if (compositeField.brush != brush) {
        compositeField.brush = brush;
      }
      if (compositeField.pen != pen) {
        compositeField.pen = pen;
      }
      if (compositeField.text.isEmpty) {
        compositeField.text =
            'Simple compositeField-text can be drawn with the page graphics';
      }
      final PdfPage page = document.pages.add();
      compositeField.draw(page.graphics, const Offset(30, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw composite field with page graphics');
      savePdf(bytes, 'FLUT-552-CompositeFieldsWithPage.pdf');
      document.dispose();
    });
  });

  group('Composite field with template graphics', () {
    test('sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement templateElement =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
      final PdfCompositeField compositeField = PdfCompositeField(
          font: font1,
          brush: brush,
          text:
              'Composite field text can be drawn with the template graphics at bottom');
      compositeField.bounds = templateElement.bounds;
      compositeField.draw(templateElement.graphics);
      document.template.bottom = templateElement;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw composite field with tempate graphics');
      savePdf(bytes, 'FLUT-552-CompositeFieldsWithTemplate.pdf');
      document.dispose();
    });
  });

  group(
      'Composite field with automatic fields (page number, page count, dateTime fields and destination fields)',
      () {
    test('sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 150, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 150, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 150, 615, 100));
      final PdfPageTemplateElement templateElement =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 150));
      final PdfPageNumberField pageNumber =
          PdfPageNumberField(font: font1, brush: brush);
      pageNumber.numberStyle = PdfNumberStyle.numeric;
      final PdfPageCountField count =
          PdfPageCountField(font: font1, brush: brush);
      final PdfCompositeField compositeField = PdfCompositeField(
          font: font1,
          brush: brush,
          text:
              'Page number: {0} \nPage count: {1} \nDate and Time: {2}\nDestination page assigned to second page: {3}',
          fields: <PdfAutomaticField>[pageNumber, count]);
      final PdfDateTimeField dateAndTimeField =
          PdfDateTimeField(font: font1, brush: brush);
      dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateAndTimeField.dateFormatString = "E, MMMM.dd.yyyy hh':'mm':'ss";
      compositeField.fields.add(dateAndTimeField);
      final PdfDestinationPageNumberField destination =
          PdfDestinationPageNumberField(font: font);
      destination.page = page2;
      compositeField.fields.add(destination);
      compositeField.bounds = templateElement.bounds;
      compositeField.draw(
          templateElement.graphics, Offset(0, 50 - font.height));
      document.template.top = templateElement;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'failed to draw composite field with autoamtic fields in tempate graphics');
      savePdf(bytes, 'FLUT-552-CompositeFieldsWithAutomaticFileds.pdf');
      document.dispose();
    });
  });

  group('Header footer with page number, count and composite field', () {
    test('sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfPage page4 = document.pages.add();
      final PdfPage page5 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page4.graphics.drawString('page4', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page5.graphics.drawString('page5', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement header =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 300));
      final PdfCompositeField compositefields = PdfCompositeField();
      compositefields.text = '{0}      Header';
      compositefields.font = font1;
      final PdfDateTimeField dateAndTimeField =
          PdfDateTimeField(font: font1, brush: brush);
      dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
      compositefields.fields.add(dateAndTimeField);
      compositefields.draw(header.graphics, Offset(0, 50 - font.height));
      document.template.top = header;
      final PdfPageTemplateElement footer =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
      final PdfPageNumberField pageNumber =
          PdfPageNumberField(font: font1, brush: brush);
      pageNumber.numberStyle = PdfNumberStyle.upperRoman;
      final PdfPageCountField count =
          PdfPageCountField(font: font1, brush: brush);
      count.numberStyle = PdfNumberStyle.upperRoman;
      final PdfCompositeField compositeField = PdfCompositeField(
          font: font1, brush: brush, text: 'Page {0} of {1}, Time:{2}');
      final PdfDateTimeField dateTimeField =
          PdfDateTimeField(font: font1, brush: brush);
      dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateTimeField.dateFormatString = "hh':'mm':'ss";
      compositeField.fields.add(pageNumber);
      compositeField.fields.add(count);
      compositeField.fields.add(dateTimeField);
      compositeField.bounds = footer.bounds;
      compositeField.draw(footer.graphics, Offset(290, 50 - font1.height));
      document.template.bottom = footer;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw Header footer.');
      savePdf(bytes, 'FLUT-552-HeaderFooter.pdf');
      document.dispose();
    });
  });

  group('date and time field test', () {
    test("date and time with locale:'en_US'", () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 12, 12, 12, 12, 12);
      dateTimeField.dateFormatString = "EEEE, MMMM.dd.yyyy hh':'mm':'ss";
      dateTimeField.locale = 'en_US';
      final String result =
          PdfDateTimeFieldHelper.getValue(dateTimeField, page.graphics);
      expect(result, 'Monday, February.10.2020 12:12:12',
          reason: 'failed to draw date and time with locale');
      document.dispose();
    });
    test("date and time with locale:'da'", () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 12, 12, 12, 12, 12);
      dateTimeField.dateFormatString = "EEEE, MMMM.dd.yyyy hh':'mm':'ss";
      dateTimeField.locale = 'da';
      final String result =
          PdfDateTimeFieldHelper.getValue(dateTimeField, page.graphics);
      expect(result, 'mandag, februar.10.2020 12:12:12',
          reason: 'failed to draw date and time with locale');
      document.dispose();
    });
    test("date and time with locale:'de-DE'", () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 12, 12, 12, 12, 12);
      dateTimeField.dateFormatString = "EEEE, MMMM.dd.yyyy hh':'mm':'ss";
      dateTimeField.locale = 'de-DE';
      final String result =
          PdfDateTimeFieldHelper.getValue(dateTimeField, page.graphics);
      expect(result, 'Montag, Februar.10.2020 12:12:12',
          reason: 'failed to draw date and time with locale');
      document.dispose();
    });
    test("date and time with locale:'sw'", () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 12, 12, 12, 12, 12);
      dateTimeField.dateFormatString = "EEEE, MMMM.dd.yyyy hh':'mm':'ss";
      dateTimeField.locale = 'sw';
      final String result =
          PdfDateTimeFieldHelper.getValue(dateTimeField, page.graphics);
      expect(result, 'Jumatatu, Februari.10.2020 12:12:12',
          reason: 'failed to draw date and time with locale');
      document.dispose();
    });
    test("date and time with locale:'en_AU'", () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 12, 12, 12, 12, 12);
      dateTimeField.dateFormatString = "EEEE, MMMM.dd.yyyy hh':'mm':'ss";
      dateTimeField.locale = 'en_AU';
      final String result =
          PdfDateTimeFieldHelper.getValue(dateTimeField, page.graphics);
      expect(result, 'Monday, February.10.2020 12:12:12',
          reason: 'failed to draw date and time with locale');
      document.dispose();
    });
    test("date and time with locale:'it-CH'", () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 12, 12, 12, 12, 12);
      dateTimeField.dateFormatString = "EEEE, MMMM.dd.yyyy hh':'mm':'ss";
      dateTimeField.locale = 'it-CH';
      final String result =
          PdfDateTimeFieldHelper.getValue(dateTimeField, page.graphics);
      expect(result, 'lunedì, febbraio.10.2020 12:12:12',
          reason: 'failed to draw date and time with locale');
      document.dispose();
    });
    test("date and time with locale:'pt'", () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 12, 12, 12, 12, 12);
      dateTimeField.dateFormatString = "EEEE, MMMM.dd.yyyy hh':'mm':'ss";
      dateTimeField.locale = 'pt';
      final String result =
          PdfDateTimeFieldHelper.getValue(dateTimeField, page.graphics);
      expect(result, 'segunda-feira, fevereiro.10.2020 12:12:12',
          reason: 'failed to draw date and time with locale');
      document.dispose();
    });
    test('date and time with custom format 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 12, 12, 12, 12, 12);
      dateTimeField.dateFormatString = "EEEE, MMMM.dd.yyyy hh':'mm':'ss";
      dateTimeField.locale = 'pt';
      dateTimeField.dateFormatString = "E'/'MMMM'/'yyyy";
      final String result =
          PdfDateTimeFieldHelper.getValue(dateTimeField, page.graphics);
      expect(result, 'seg./fevereiro/2020',
          reason: 'failed to draw date and time with locale');
      document.dispose();
    });
    test('date and time with custom format 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 12, 12, 12, 12, 12);
      dateTimeField.dateFormatString = "EEEE, MMMM.dd.yyyy hh':'mm':'ss";
      dateTimeField.locale = 'it-CH';
      dateTimeField.dateFormatString = 'EEEE, MMMM.dd.yyyy';
      final String result =
          PdfDateTimeFieldHelper.getValue(dateTimeField, page.graphics);
      expect(result, 'lunedì, febbraio.10.2020',
          reason: 'failed to draw date and time with locale');
      document.dispose();
    });
    test('date and time with custom format 3', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 12, 12, 12, 12, 12);
      dateTimeField.dateFormatString = "EEEE, MMMM.dd.yyyy hh':'mm':'ss";
      dateTimeField.locale = 'en_US';
      dateTimeField.dateFormatString = "dd'/'MM'/'yyyy";
      final String result =
          PdfDateTimeFieldHelper.getValue(dateTimeField, page.graphics);
      expect(result, '10/02/2020',
          reason: 'failed to draw date and time with locale');
      document.dispose();
    });
    test('date and time', () {
      final PdfDocument document = PdfDocument();
      document.pages.add();
      final PdfDateTimeField dateTimeField = PdfDateTimeField();
      dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      for (int i = 0; i != 3; i++) {
        final PdfPage page = document.pages.add();
        dateTimeField.draw(page.graphics);
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw date time field');
      document.dispose();
    });
  });
  final List<String> localeList = <String>[
    'en_US',
    'da',
    'de-DE',
    'sw',
    'pt',
    'it-CH',
    'en_AU'
  ];
  final List<String> patternList = <String>[
    "EEEE, MMMM.dd.yyyy hh':'mm':'ss",
    "MMMM.dddd.yyyy hh':'mm'",
    "E, dd.MM.yyyy hh':'mm':'ss",
    "EEE, MMM d, ''yy",
    'yyyyy.MMMMM.dd GGG hh:mm aaa',
    "EEEE, MMM d, ''yy"
  ];

  group('Date and time field sample file', () {
    test('with locale and corresponding formats', () {
      final PdfDocument document = PdfDocument();
      PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      double dateY = 30;
      for (int i = 0; i < localeList.length; i++) {
        if (dateY > 750) {
          page = document.pages.add();
          dateY = 30;
          page.graphics.drawString(
              'Date and time format with Locale: ${localeList[i]}', font,
              bounds: Rect.fromLTWH(50, dateY, 0, 0));
        } else {
          page.graphics.drawString(
              'Date and time format with Locale: ${localeList[i]}', font,
              bounds: Rect.fromLTWH(50, dateY, 0, 0));
        }
        for (int j = 0; j < patternList.length; j++) {
          final PdfDateTimeField dateTimeField =
              PdfDateTimeField(font: font, brush: brush);
          dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
          dateTimeField.dateFormatString = patternList[j];
          dateTimeField.locale = localeList[i];
          dateY += font.height + 3;
          dateTimeField.draw(page.graphics, Offset(100, dateY));
        }
        dateY += 40;
      }
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw date time field');
      savePdf(bytes, 'FLUT-552-DateTimeField1.pdf');
      document.dispose();
    });
  });
}
