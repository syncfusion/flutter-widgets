import 'dart:convert';
import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'fonts.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';
import 'rtl_fonts.dart';

// ignore: public_member_api_docs
void pdfTrueTypeFont() {
  group('True type font', () {
    test('symbol type - hello world', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfTrueTypeFont trueTypeFont = PdfTrueTypeFont.fromBase64String(
          symbolTTF, 20, multiStyle: <PdfFontStyle>[
        PdfFontStyle.underline,
        PdfFontStyle.strikethrough
      ]);
      page.graphics.drawString('Hello World!!!', trueTypeFont);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true);
      savePdf(bytes, 'FLUT_551_SymbolTTF.pdf');
    });
    test('Arial font', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(arialTTF, 20);
      page.graphics.drawString('Hello World!!!', trueTypeFont);
      page.graphics.drawString(
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890', trueTypeFont,
          bounds: const Rect.fromLTWH(0, 50, 0, 0));
      page.graphics.drawString(
          // ignore: use_raw_strings
          '~(`!{@#%}^\\|[]{}*()"/[/]..<,,<>>)~~`',
          trueTypeFont,
          bounds: const Rect.fromLTWH(0, 100, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true);
      savePdf(bytes, 'FLUT_551_ArialTTF_1.pdf');
    });
    test('Arabic font', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(arabicTTF, 20);
      // expect(
      //     PdfTrueTypeFontHelper.getFontInternal(trueTypeFont)
      //         .getFontName('()[]<>{}/% ABCD')
      //         .substring(7),
      //     '#28#29#5B#5D#3C#3E#7B#7D#2F#25#20ABCD',
      //     reason: 'Failed to replace tokens in font name creation');
      page.graphics
          .drawString('کمان العربی مجهز بالمقام موسیقی العربی', trueTypeFont);
      final PdfStringFormat format = PdfStringFormat();
      format.wordSpacing = 10;
      page.graphics.drawString(
          'کمان العربی مجهز بالمقام موسیقی العربی', trueTypeFont,
          bounds: const Rect.fromLTWH(0, 40, 0, 0), format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true);
      savePdf(bytes, 'FLUT_551_Arabic.pdf');
    });
    test('Thai text - ', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfTrueTypeFont trueTypeFont =
          PdfTrueTypeFont.fromBase64String(thaiTTF, 20);
      page.graphics.drawString('Thai 보관 상태 점검 및', trueTypeFont);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true);
      savePdf(bytes, 'FLUT_551_ThaiTTF.pdf');
    });
  });

  group('FLUT-1232 euro symbol', () {
    test('8332 char code drawing', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();

      final PdfFont font1 = PdfTrueTypeFont.fromBase64String(openSansTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font1,
          bounds: const Rect.fromLTWH(10, 10, 200, 50));

      final PdfFont font2 =
          PdfTrueTypeFont.fromBase64String(robotoBlackTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font2,
          bounds: const Rect.fromLTWH(10, 60, 200, 50));

      final PdfFont font3 =
          PdfTrueTypeFont.fromBase64String(robotoBlackItalicTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font3,
          bounds: const Rect.fromLTWH(10, 110, 200, 50));

      final PdfFont font4 = PdfTrueTypeFont.fromBase64String(robotoBoldTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font4,
          bounds: const Rect.fromLTWH(10, 160, 200, 50));

      final PdfFont font5 =
          PdfTrueTypeFont.fromBase64String(robotoBoldItalicTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font5,
          bounds: const Rect.fromLTWH(10, 210, 200, 50));

      final PdfFont font6 =
          PdfTrueTypeFont.fromBase64String(robotoItalicTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font6,
          bounds: const Rect.fromLTWH(10, 260, 200, 50));

      final PdfFont font7 =
          PdfTrueTypeFont.fromBase64String(robotoLightTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font7,
          bounds: const Rect.fromLTWH(10, 310, 200, 50));

      final PdfFont font8 =
          PdfTrueTypeFont.fromBase64String(robotoLightItalicTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font8,
          bounds: const Rect.fromLTWH(10, 360, 200, 50));

      final PdfFont font9 =
          PdfTrueTypeFont.fromBase64String(robotoMediumTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font9,
          bounds: const Rect.fromLTWH(10, 410, 200, 50));

      final PdfFont font10 =
          PdfTrueTypeFont.fromBase64String(robotoMediumItalicTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font10,
          bounds: const Rect.fromLTWH(10, 460, 200, 50));

      final PdfFont font11 =
          PdfTrueTypeFont.fromBase64String(robotoThinTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font11,
          bounds: const Rect.fromLTWH(10, 510, 200, 50));

      final PdfFont font12 =
          PdfTrueTypeFont.fromBase64String(robotoThinItalicTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font12,
          bounds: const Rect.fromLTWH(10, 560, 200, 50));

      final PdfFont font13 = PdfTrueTypeFont.fromBase64String(symbolTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font13,
          bounds: const Rect.fromLTWH(210, 10, 200, 50));

      final PdfFont font14 = PdfTrueTypeFont.fromBase64String(arialTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font14,
          bounds: const Rect.fromLTWH(210, 60, 200, 50));

      final PdfFont font15 = PdfTrueTypeFont.fromBase64String(arabicTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font15,
          bounds: const Rect.fromLTWH(210, 110, 200, 50));

      final PdfFont font16 = PdfTrueTypeFont.fromBase64String(thaiTTF, 20);
      page.graphics.drawString('${String.fromCharCode(8364)}100', font16,
          bounds: const Rect.fromLTWH(210, 160, 200, 50));

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw 9332 char code with standard font');
      savePdf(bytes, 'FLUT_1232.pdf');
      document.dispose();
    });
  });

  group('FLUT-1378 Material Icons Font', () {
    test('Font loading throws an exception', () {
      try {
        PdfTrueTypeFont.fromBase64String(materialIconsTTF, 15);
      } catch (e) {
        expect(e is ArgumentError, true,
            reason:
                'Failed to load material icons TTF font without null reference exception');
      }
    });
  });

  group(
      'FLUT-835909 Preservation issue occurs while drawing bold and italic style',
      () {
    final List<String> fonts = <String>[
      arialTTF,
      courierTTF,
      openSansTTF,
      robotoTTF
    ];
    test('test 1', () {
      for (int i = 0; i < fonts.length; i++) {
        final PdfDocument document = PdfDocument();
        final PdfPage page = document.pages.add();
        final List<int> fontStream = base64.decode(fonts[i]);
        final double height = page.size.height;
        final double width = page.size.width;
        final PdfFont regular =
            PdfTrueTypeFont(fontStream, 14, style: PdfFontStyle.regular);
        final PdfFont bold =
            PdfTrueTypeFont(fontStream, 14, style: PdfFontStyle.bold);
        final PdfFont italic =
            PdfTrueTypeFont(fontStream, 14, style: PdfFontStyle.italic);
        final PdfFont bolditalic = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
        final PdfFont boldunderline = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.underline
            ]);
        final PdfFont boldstrikethrough = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont italicunderline = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.italic,
              PdfFontStyle.underline
            ]);
        final PdfFont italicstrikethrough = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.italic,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont bolditalicunderline = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.italic,
              PdfFontStyle.underline
            ]);
        final PdfFont bolditalicstrikethrough = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.italic,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont boldunderlinestrikethrough = PdfTrueTypeFont(
            fontStream, 14, multiStyle: <PdfFontStyle>[
          PdfFontStyle.bold,
          PdfFontStyle.underline,
          PdfFontStyle.strikethrough
        ]);
        final PdfFont italicunderlinestrikethrough = PdfTrueTypeFont(
            fontStream, 14, multiStyle: <PdfFontStyle>[
          PdfFontStyle.italic,
          PdfFontStyle.underline,
          PdfFontStyle.strikethrough
        ]);
        final PdfFont bolditalicunderlinestrikethrough =
            PdfTrueTypeFont(fontStream, 14, multiStyle: <PdfFontStyle>[
          PdfFontStyle.bold,
          PdfFontStyle.italic,
          PdfFontStyle.underline,
          PdfFontStyle.strikethrough
        ]);
        page.graphics.drawString('Regular', regular);
        page.graphics.drawString('bold', bold,
            bounds: Rect.fromLTWH(200, 0, width, height));
        page.graphics.drawString('italic', italic,
            bounds: Rect.fromLTWH(0, 50, width, height));
        page.graphics.drawString('bold italic', bolditalic,
            bounds: Rect.fromLTWH(200, 50, width, height));
        page.graphics.drawString('bold underline', boldunderline,
            bounds: Rect.fromLTWH(0, 100, width, height));
        page.graphics.drawString('bold strikethrough', boldstrikethrough,
            bounds: Rect.fromLTWH(200, 100, width, height));
        page.graphics.drawString('italic underline', italicunderline,
            bounds: Rect.fromLTWH(0, 150, width, height));
        page.graphics.drawString('italic strikethrough', italicstrikethrough,
            bounds: Rect.fromLTWH(200, 150, width, height));
        page.graphics.drawString('bold italic underline', bolditalicunderline,
            bounds: Rect.fromLTWH(0, 200, width, height));
        page.graphics.drawString(
            'bold italic strikethrough', bolditalicstrikethrough,
            bounds: Rect.fromLTWH(200, 200, width, height));
        page.graphics.drawString(
            'bold underline strikethrough', boldunderlinestrikethrough,
            bounds: Rect.fromLTWH(0, 250, width, height));
        page.graphics.drawString(
            'italic underline strikethrough', italicunderlinestrikethrough,
            bounds: Rect.fromLTWH(200, 250, width, height));
        page.graphics.drawString('bold italic underline strikethrough',
            bolditalicunderlinestrikethrough,
            bounds: Rect.fromLTWH(0, 300, width, height));
        savePdf(document.saveSync(), 'FLUT-835909-${regular.name}.pdf');
        document.dispose();
      }
    });
    test('test 2', () {
      for (int i = 0; i < fonts.length; i++) {
        PdfDocument document = PdfDocument();
        PdfPage page = document.pages.add();
        document = PdfDocument(inputBytes: document.saveSync());
        page = document.pages[0];
        final List<int> fontStream = base64.decode(fonts[i]);
        final double height = page.size.height;
        final double width = page.size.width;
        final PdfFont regular =
            PdfTrueTypeFont(fontStream, 14, style: PdfFontStyle.regular);
        final PdfFont bold =
            PdfTrueTypeFont(fontStream, 14, style: PdfFontStyle.bold);
        final PdfFont italic =
            PdfTrueTypeFont(fontStream, 14, style: PdfFontStyle.italic);
        final PdfFont bolditalic = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
        final PdfFont boldunderline = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.underline
            ]);
        final PdfFont boldstrikethrough = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont italicunderline = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.italic,
              PdfFontStyle.underline
            ]);
        final PdfFont italicstrikethrough = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.italic,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont bolditalicunderline = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.italic,
              PdfFontStyle.underline
            ]);
        final PdfFont bolditalicstrikethrough = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.italic,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont boldunderlinestrikethrough = PdfTrueTypeFont(
            fontStream, 14, multiStyle: <PdfFontStyle>[
          PdfFontStyle.bold,
          PdfFontStyle.underline,
          PdfFontStyle.strikethrough
        ]);
        final PdfFont italicunderlinestrikethrough = PdfTrueTypeFont(
            fontStream, 14, multiStyle: <PdfFontStyle>[
          PdfFontStyle.italic,
          PdfFontStyle.underline,
          PdfFontStyle.strikethrough
        ]);
        final PdfFont bolditalicunderlinestrikethrough =
            PdfTrueTypeFont(fontStream, 14, multiStyle: <PdfFontStyle>[
          PdfFontStyle.bold,
          PdfFontStyle.italic,
          PdfFontStyle.underline,
          PdfFontStyle.strikethrough
        ]);
        page.graphics.drawString('Regular', regular);
        page.graphics.drawString('bold', bold,
            bounds: Rect.fromLTWH(200, 0, width, height));
        page.graphics.drawString('italic', italic,
            bounds: Rect.fromLTWH(0, 50, width, height));
        page.graphics.drawString('bold italic', bolditalic,
            bounds: Rect.fromLTWH(200, 50, width, height));
        page.graphics.drawString('bold underline', boldunderline,
            bounds: Rect.fromLTWH(0, 100, width, height));
        page.graphics.drawString('bold strikethrough', boldstrikethrough,
            bounds: Rect.fromLTWH(200, 100, width, height));
        page.graphics.drawString('italic underline', italicunderline,
            bounds: Rect.fromLTWH(0, 150, width, height));
        page.graphics.drawString('italic strikethrough', italicstrikethrough,
            bounds: Rect.fromLTWH(200, 150, width, height));
        page.graphics.drawString('bold italic underline', bolditalicunderline,
            bounds: Rect.fromLTWH(0, 200, width, height));
        page.graphics.drawString(
            'bold italic strikethrough', bolditalicstrikethrough,
            bounds: Rect.fromLTWH(200, 200, width, height));
        page.graphics.drawString(
            'bold underline strikethrough', boldunderlinestrikethrough,
            bounds: Rect.fromLTWH(0, 250, width, height));
        page.graphics.drawString(
            'italic underline strikethrough', italicunderlinestrikethrough,
            bounds: Rect.fromLTWH(200, 250, width, height));
        page.graphics.drawString('bold italic underline strikethrough',
            bolditalicunderlinestrikethrough,
            bounds: Rect.fromLTWH(0, 300, width, height));
        savePdf(document.saveSync(), 'FLUT-835909-${regular.name}_2.pdf');
        document.dispose();
      }
    });
    test('test 3', () {
      for (int i = 0; i < fonts.length; i++) {
        const String text =
            'line1 line2   line3\tline4 line5 line7 line8\nline9\tline10 line11\nline12\t\tline13\nÞí³êîä ñòð³÷êà';
        const String text2 =
            'Adventure Works Cycles, the fictitious company on which the AdventureWorks sample databases are based, is a large, multinational manufacturing company. The company manufactures and sells metal and composite bicycles to North American, European and Asian commercial markets. While its base operation is located in Washington with 290 employees, several regional sales teams are located throughout their market base.';
        final PdfDocument document = PdfDocument();
        final List<int> fontStream = base64.decode(fonts[i]);
        final PdfFont regular =
            PdfTrueTypeFont(fontStream, 14, style: PdfFontStyle.regular);
        final PdfFont bold =
            PdfTrueTypeFont(fontStream, 14, style: PdfFontStyle.bold);
        final PdfFont italic =
            PdfTrueTypeFont(fontStream, 14, style: PdfFontStyle.italic);
        final PdfFont boldItalic = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
        final PdfFont boldUnderline = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.underline
            ]);
        final PdfFont boldStrikeout = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont italicUnderline = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.italic,
              PdfFontStyle.underline
            ]);
        final PdfFont italicStrikeout = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.italic,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont boldItalicUnderline = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.italic,
              PdfFontStyle.underline
            ]);
        final PdfFont boldItalicStrikeout = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.italic,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont boldUnderlineStrikeout = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.bold,
              PdfFontStyle.underline,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont italicUnderlineStrikeout = PdfTrueTypeFont(fontStream, 14,
            multiStyle: <PdfFontStyle>[
              PdfFontStyle.italic,
              PdfFontStyle.underline,
              PdfFontStyle.strikethrough
            ]);
        final PdfFont boldItalicUnderlineStrikeout =
            PdfTrueTypeFont(fontStream, 14, multiStyle: <PdfFontStyle>[
          PdfFontStyle.bold,
          PdfFontStyle.italic,
          PdfFontStyle.underline,
          PdfFontStyle.strikethrough
        ]);
        PdfPage page = document.pages.add();
        page.graphics.drawString(text, regular);
        page.graphics.drawString(text2, regular,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, regular,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, regular,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, bold);
        page.graphics.drawString(text2, bold,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, bold,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, bold,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, italic);
        page.graphics.drawString(text2, italic,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, italic,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, italic,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, boldItalic);
        page.graphics.drawString(text2, boldItalic,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, boldItalic,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, boldItalic,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, boldUnderline);
        page.graphics.drawString(text2, boldUnderline,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, boldUnderline,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, boldUnderline,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, boldStrikeout);
        page.graphics.drawString(text2, boldStrikeout,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, boldStrikeout,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, boldStrikeout,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, italicUnderline);
        page.graphics.drawString(text2, italicUnderline,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, italicUnderline,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, italicUnderline,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, italicStrikeout);
        page.graphics.drawString(text2, italicStrikeout,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, italicStrikeout,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, italicStrikeout,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, boldItalicUnderline);
        page.graphics.drawString(text2, boldItalicUnderline,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, boldItalicUnderline,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, boldItalicUnderline,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, boldItalicStrikeout);
        page.graphics.drawString(text2, boldItalicStrikeout,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, boldItalicStrikeout,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, boldItalicStrikeout,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, boldUnderlineStrikeout);
        page.graphics.drawString(text2, boldUnderlineStrikeout,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, boldUnderlineStrikeout,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, boldUnderlineStrikeout,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, italicUnderlineStrikeout);
        page.graphics.drawString(text2, italicUnderlineStrikeout,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, italicUnderlineStrikeout,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, italicUnderlineStrikeout,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        page = document.pages.add();
        page.graphics.drawString(text, boldItalicUnderlineStrikeout);
        page.graphics.drawString(text2, boldItalicUnderlineStrikeout,
            bounds: Rect.fromLTWH(0, 100, page.getClientSize().width,
                page.getClientSize().height - 100));
        page.graphics.drawString(text, boldItalicUnderlineStrikeout,
            bounds: Rect.fromLTWH(100, 200, page.getClientSize().width - 100,
                page.getClientSize().height - 200));
        page.graphics.drawString(text2, boldItalicUnderlineStrikeout,
            bounds: Rect.fromLTWH(150, 300, page.getClientSize().width - 150,
                page.getClientSize().height - 300));
        savePdf(document.saveSync(), 'FLUT-835909-${regular.name}_3.pdf');
        document.dispose();
      }
    });
    test('test 4', () {
      final PdfDocument doc = PdfDocument();
      doc.pageSettings.setMargins(20);
      final PdfTrueTypeFont pdfFont = PdfTrueTypeFont.fromBase64String(
          arialTTF, 11,
          style: PdfFontStyle.italic);
      final PdfBrush brush = PdfBrushes.blue;
      final PdfPen pen = PdfPens.black;
      const String text =
          'line1 line2   line3\tline4 line5 line7 line8\n\nline9\tline10 line11\nline12\t\tline13\nÞí³êîä ñòð³÷êà';
      doc.pageSettings.size = PdfPageSize.a3;
      doc.pageSettings.orientation = PdfPageOrientation.landscape;
      final PdfPage page = doc.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.characterSpacing = 2;
      format.wordSpacing = 3;
      const double offset = 20;
      const double xOffset = 500;
      const double yOffset = 200;
      Rect bounds = const Rect.fromLTWH(30, 30, 0, 0);
      format.alignment = PdfTextAlignment.left;
      format.lineAlignment = PdfVerticalAlignment.top;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(bounds.left + xOffset, bounds.top, 0, 0);
      format.alignment = PdfTextAlignment.center;
      format.lineAlignment = PdfVerticalAlignment.top;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(bounds.left + xOffset, bounds.top, 0, 0);
      format.alignment = PdfTextAlignment.right;
      format.lineAlignment = PdfVerticalAlignment.top;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(
          bounds.left - (2 * xOffset), bounds.top + yOffset, 0, 0);
      format.alignment = PdfTextAlignment.left;
      format.lineAlignment = PdfVerticalAlignment.middle;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(bounds.left + xOffset, bounds.top, 0, 0);
      format.alignment = PdfTextAlignment.center;
      format.lineAlignment = PdfVerticalAlignment.middle;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(bounds.left + xOffset, bounds.top, 0, 0);
      format.alignment = PdfTextAlignment.right;
      format.lineAlignment = PdfVerticalAlignment.middle;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(
          bounds.left - (2 * xOffset), bounds.top + yOffset, 0, 0);
      format.alignment = PdfTextAlignment.left;
      format.lineAlignment = PdfVerticalAlignment.bottom;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(bounds.left + xOffset, bounds.top, 0, 0);
      format.alignment = PdfTextAlignment.center;
      format.lineAlignment = PdfVerticalAlignment.bottom;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(bounds.left + xOffset, bounds.top, 0, 0);
      format.alignment = PdfTextAlignment.right;
      format.lineAlignment = PdfVerticalAlignment.bottom;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(
          bounds.left - (2 * xOffset), bounds.top + yOffset, 0, 0);
      format.alignment = PdfTextAlignment.justify;
      format.lineAlignment = PdfVerticalAlignment.top;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(bounds.left + xOffset, bounds.top, 0, 0);
      format.alignment = PdfTextAlignment.justify;
      format.lineAlignment = PdfVerticalAlignment.middle;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      bounds = Rect.fromLTWH(bounds.left + xOffset, bounds.top, 0, 0);
      format.alignment = PdfTextAlignment.justify;
      format.lineAlignment = PdfVerticalAlignment.bottom;
      page.graphics.drawString(text, pdfFont,
          brush: brush, bounds: bounds, format: format);
      page.graphics.drawLine(pen, Offset(bounds.left - offset, bounds.top),
          Offset(bounds.left + offset, bounds.top));
      page.graphics.drawLine(pen, Offset(bounds.left, bounds.top - offset),
          Offset(bounds.left, bounds.top + offset));
      savePdf(doc.saveSync(), 'LayoutText.pdf');
      doc.dispose();
    });
  });
}
