import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'fonts.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

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
}
