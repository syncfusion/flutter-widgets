import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'images.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void drawStringSupport() {
  group('Drawing string with PdfStandardFont', () {
    test('"hello world" draw with courier font', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont courier1 = PdfStandardFont(PdfFontFamily.courier, 12);
      final PdfFont courier2 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular);
      final PdfFont courier3 =
          PdfStandardFont(PdfFontFamily.courier, 12, style: PdfFontStyle.bold);
      final PdfFont courier4 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.italic);
      final PdfFont courier5 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.strikethrough);
      final PdfFont courier6 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.underline);
      final PdfFont courier7 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont courier8 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont courier9 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont courier10 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont courier11 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont courier12 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont courier13 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont courier14 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont courier15 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont courier16 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont courier17 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont courier18 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont courier19 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont courier20 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont courier21 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont courier22 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont courier23 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont courier24 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont courier25 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont courier26 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont courier27 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont courier28 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont courier29 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont courier30 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont courier31 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont courier32 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.underline
          ]);
      final PdfFont courier33 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont courier34 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont courier35 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont courier36 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont courier37 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont courier38 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
      final PdfFont courier39 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont courier40 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont courier41 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont courier42 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont courier43 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular, PdfFontStyle.bold]);
      final PdfFont courier44 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.underline
          ]);
      final PdfFont courier45 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont courier46 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont courier47 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic
          ]);
      final PdfFont courier48 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont courier49 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont courier50 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont courier51 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic
          ]);
      final PdfFont courier52 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont courier53 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont courier54 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont courier55 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.underline
          ]);
      final PdfFont courier56 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont courier57 = PdfStandardFont(PdfFontFamily.courier, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('hello world', courier1);
      graphics.drawString('hello world', courier2,
          bounds: const Rect.fromLTWH(20, 40, 0, 0));
      graphics.drawString('hello world', courier3,
          bounds: const Rect.fromLTWH(20, 80, 0, 0));
      graphics.drawString('hello world', courier4,
          bounds: const Rect.fromLTWH(20, 120, 0, 0));
      graphics.drawString('hello world', courier5,
          bounds: const Rect.fromLTWH(20, 160, 0, 0));
      graphics.drawString('hello world', courier6,
          bounds: const Rect.fromLTWH(20, 200, 0, 0));
      graphics.drawString('hello world', courier7,
          bounds: const Rect.fromLTWH(20, 240, 0, 0));
      graphics.drawString('hello world', courier8,
          bounds: const Rect.fromLTWH(20, 280, 0, 0));
      graphics.drawString('hello world', courier9,
          bounds: const Rect.fromLTWH(20, 320, 0, 0));
      graphics.drawString('hello world', courier10,
          bounds: const Rect.fromLTWH(20, 360, 0, 0));
      graphics.drawString('hello world', courier11,
          bounds: const Rect.fromLTWH(20, 400, 0, 0));
      graphics.drawString('hello world', courier12,
          bounds: const Rect.fromLTWH(20, 440, 0, 0));
      graphics.drawString('hello world', courier13,
          bounds: const Rect.fromLTWH(20, 480, 0, 0));
      graphics.drawString('hello world', courier14,
          bounds: const Rect.fromLTWH(20, 520, 0, 0));
      graphics.drawString('hello world', courier15,
          bounds: const Rect.fromLTWH(20, 560, 0, 0));
      graphics.drawString('hello world', courier16,
          bounds: const Rect.fromLTWH(20, 600, 0, 0));
      graphics.drawString('hello world', courier17,
          bounds: const Rect.fromLTWH(150, 0, 0, 0));
      graphics.drawString('hello world', courier18,
          bounds: const Rect.fromLTWH(150, 40, 0, 0));
      graphics.drawString('hello world', courier19,
          bounds: const Rect.fromLTWH(150, 80, 0, 0));
      graphics.drawString('hello world', courier20,
          bounds: const Rect.fromLTWH(150, 120, 0, 0));
      graphics.drawString('hello world', courier21,
          bounds: const Rect.fromLTWH(150, 160, 0, 0));
      graphics.drawString('hello world', courier22,
          bounds: const Rect.fromLTWH(150, 200, 0, 0));
      graphics.drawString('hello world', courier23,
          bounds: const Rect.fromLTWH(150, 240, 0, 0));
      graphics.drawString('hello world', courier24,
          bounds: const Rect.fromLTWH(150, 280, 0, 0));
      graphics.drawString('hello world', courier25,
          bounds: const Rect.fromLTWH(150, 320, 0, 0));
      graphics.drawString('hello world', courier26,
          bounds: const Rect.fromLTWH(150, 360, 0, 0));
      graphics.drawString('hello world', courier27,
          bounds: const Rect.fromLTWH(150, 400, 0, 0));
      graphics.drawString('hello world', courier28,
          bounds: const Rect.fromLTWH(150, 440, 0, 0));
      graphics.drawString('hello world', courier29,
          bounds: const Rect.fromLTWH(150, 480, 0, 0));
      graphics.drawString('hello world', courier30,
          bounds: const Rect.fromLTWH(150, 520, 0, 0));
      graphics.drawString('hello world', courier31,
          bounds: const Rect.fromLTWH(150, 560, 0, 0));
      graphics.drawString('hello world', courier32,
          bounds: const Rect.fromLTWH(150, 600, 0, 0));
      graphics.drawString('hello world', courier33,
          bounds: const Rect.fromLTWH(280, 0, 0, 0));
      graphics.drawString('hello world', courier34,
          bounds: const Rect.fromLTWH(280, 40, 0, 0));
      graphics.drawString('hello world', courier35,
          bounds: const Rect.fromLTWH(280, 80, 0, 0));
      graphics.drawString('hello world', courier36,
          bounds: const Rect.fromLTWH(280, 120, 0, 0));
      graphics.drawString('hello world', courier37,
          bounds: const Rect.fromLTWH(280, 160, 0, 0));
      graphics.drawString('hello world', courier38,
          bounds: const Rect.fromLTWH(280, 200, 0, 0));
      graphics.drawString('hello world', courier39,
          bounds: const Rect.fromLTWH(280, 240, 0, 0));
      graphics.drawString('hello world', courier40,
          bounds: const Rect.fromLTWH(280, 280, 0, 0));
      graphics.drawString('hello world', courier41,
          bounds: const Rect.fromLTWH(280, 320, 0, 0));
      graphics.drawString('hello world', courier42,
          bounds: const Rect.fromLTWH(280, 360, 0, 0));
      graphics.drawString('hello world', courier43,
          bounds: const Rect.fromLTWH(280, 400, 0, 0));
      graphics.drawString('hello world', courier44,
          bounds: const Rect.fromLTWH(280, 440, 0, 0));
      graphics.drawString('hello world', courier45,
          bounds: const Rect.fromLTWH(280, 480, 0, 0));
      graphics.drawString('hello world', courier46,
          bounds: const Rect.fromLTWH(280, 520, 0, 0));
      graphics.drawString('hello world', courier47,
          bounds: const Rect.fromLTWH(280, 560, 0, 0));
      graphics.drawString('hello world', courier48,
          bounds: const Rect.fromLTWH(280, 600, 0, 0));
      graphics.drawString('hello world', courier49,
          bounds: const Rect.fromLTWH(410, 0, 0, 0));
      graphics.drawString('hello world', courier50,
          bounds: const Rect.fromLTWH(410, 40, 0, 0));
      graphics.drawString('hello world', courier51,
          bounds: const Rect.fromLTWH(410, 80, 0, 0));
      graphics.drawString('hello world', courier52,
          bounds: const Rect.fromLTWH(410, 120, 0, 0));
      graphics.drawString('hello world', courier53,
          bounds: const Rect.fromLTWH(410, 160, 0, 0));
      graphics.drawString('hello world', courier54,
          bounds: const Rect.fromLTWH(410, 200, 0, 0));
      graphics.drawString('hello world', courier55,
          bounds: const Rect.fromLTWH(410, 240, 0, 0));
      graphics.drawString('hello world', courier56,
          bounds: const Rect.fromLTWH(410, 280, 0, 0));
      graphics.drawString('hello world', courier57,
          bounds: const Rect.fromLTWH(410, 320, 0, 0));

      final PdfPage newPage = document.pages.add();
      newPage.graphics.drawString('1234567890', courier1);
      newPage.graphics.drawString(
          '( - ) ) < > ( // ? ., " :; [ } { ] ++= -- _ ) ( *&^%#@!~ `',
          courier1,
          bounds: const Rect.fromLTWH(0, 40, 0, 0));
      newPage.graphics.drawString('ABCDEFGHIJKLMNOPQRSTUVWXYZ', courier1,
          bounds: const Rect.fromLTWH(0, 80, 0, 0));

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw "hello world with courier font');
      savePdf(bytes, 'FLUT_492_DrawString1.pdf');
      document.dispose();
    });
    test('"hello world" draw with helvetica font', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont helvetica1 = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfFont helvetica2 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular);
      final PdfFont helvetica3 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold);
      final PdfFont helvetica4 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.italic);
      final PdfFont helvetica5 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.strikethrough);
      final PdfFont helvetica6 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.underline);
      final PdfFont helvetica7 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont helvetica8 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont helvetica9 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont helvetica10 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont helvetica11 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont helvetica12 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont helvetica13 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont helvetica14 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont helvetica15 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont helvetica16 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont helvetica17 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont helvetica18 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont helvetica19 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont helvetica20 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont helvetica21 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont helvetica22 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont helvetica23 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont helvetica24 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont helvetica25 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont helvetica26 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont helvetica27 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont helvetica28 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont helvetica29 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont helvetica30 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont helvetica31 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont helvetica32 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica33 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont helvetica34 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica35 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica36 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont helvetica37 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica38 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
      final PdfFont helvetica39 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica40 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont helvetica41 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica42 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica43 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular, PdfFontStyle.bold]);
      final PdfFont helvetica44 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica45 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont helvetica46 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica47 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic
          ]);
      final PdfFont helvetica48 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica49 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont helvetica50 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica51 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic
          ]);
      final PdfFont helvetica52 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica53 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont helvetica54 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica55 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.underline
          ]);
      final PdfFont helvetica56 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont helvetica57 = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('hello world', helvetica1);
      graphics.drawString('hello world', helvetica2,
          bounds: const Rect.fromLTWH(20, 40, 0, 0));
      graphics.drawString('hello world', helvetica3,
          bounds: const Rect.fromLTWH(20, 80, 0, 0));
      graphics.drawString('hello world', helvetica4,
          bounds: const Rect.fromLTWH(20, 120, 0, 0));
      graphics.drawString('hello world', helvetica5,
          bounds: const Rect.fromLTWH(20, 160, 0, 0));
      graphics.drawString('hello world', helvetica6,
          bounds: const Rect.fromLTWH(20, 200, 0, 0));
      graphics.drawString('hello world', helvetica7,
          bounds: const Rect.fromLTWH(20, 240, 0, 0));
      graphics.drawString('hello world', helvetica8,
          bounds: const Rect.fromLTWH(20, 280, 0, 0));
      graphics.drawString('hello world', helvetica9,
          bounds: const Rect.fromLTWH(20, 320, 0, 0));
      graphics.drawString('hello world', helvetica10,
          bounds: const Rect.fromLTWH(20, 360, 0, 0));
      graphics.drawString('hello world', helvetica11,
          bounds: const Rect.fromLTWH(20, 400, 0, 0));
      graphics.drawString('hello world', helvetica12,
          bounds: const Rect.fromLTWH(20, 440, 0, 0));
      graphics.drawString('hello world', helvetica13,
          bounds: const Rect.fromLTWH(20, 480, 0, 0));
      graphics.drawString('hello world', helvetica14,
          bounds: const Rect.fromLTWH(20, 520, 0, 0));
      graphics.drawString('hello world', helvetica15,
          bounds: const Rect.fromLTWH(20, 560, 0, 0));
      graphics.drawString('hello world', helvetica16,
          bounds: const Rect.fromLTWH(20, 600, 0, 0));
      graphics.drawString('hello world', helvetica17,
          bounds: const Rect.fromLTWH(150, 0, 0, 0));
      graphics.drawString('hello world', helvetica18,
          bounds: const Rect.fromLTWH(150, 40, 0, 0));
      graphics.drawString('hello world', helvetica19,
          bounds: const Rect.fromLTWH(150, 80, 0, 0));
      graphics.drawString('hello world', helvetica20,
          bounds: const Rect.fromLTWH(150, 120, 0, 0));
      graphics.drawString('hello world', helvetica21,
          bounds: const Rect.fromLTWH(150, 160, 0, 0));
      graphics.drawString('hello world', helvetica22,
          bounds: const Rect.fromLTWH(150, 200, 0, 0));
      graphics.drawString('hello world', helvetica23,
          bounds: const Rect.fromLTWH(150, 240, 0, 0));
      graphics.drawString('hello world', helvetica24,
          bounds: const Rect.fromLTWH(150, 280, 0, 0));
      graphics.drawString('hello world', helvetica25,
          bounds: const Rect.fromLTWH(150, 320, 0, 0));
      graphics.drawString('hello world', helvetica26,
          bounds: const Rect.fromLTWH(150, 360, 0, 0));
      graphics.drawString('hello world', helvetica27,
          bounds: const Rect.fromLTWH(150, 400, 0, 0));
      graphics.drawString('hello world', helvetica28,
          bounds: const Rect.fromLTWH(150, 440, 0, 0));
      graphics.drawString('hello world', helvetica29,
          bounds: const Rect.fromLTWH(150, 480, 0, 0));
      graphics.drawString('hello world', helvetica30,
          bounds: const Rect.fromLTWH(150, 520, 0, 0));
      graphics.drawString('hello world', helvetica31,
          bounds: const Rect.fromLTWH(150, 560, 0, 0));
      graphics.drawString('hello world', helvetica32,
          bounds: const Rect.fromLTWH(150, 600, 0, 0));
      graphics.drawString('hello world', helvetica33,
          bounds: const Rect.fromLTWH(280, 0, 0, 0));
      graphics.drawString('hello world', helvetica34,
          bounds: const Rect.fromLTWH(280, 40, 0, 0));
      graphics.drawString('hello world', helvetica35,
          bounds: const Rect.fromLTWH(280, 80, 0, 0));
      graphics.drawString('hello world', helvetica36,
          bounds: const Rect.fromLTWH(280, 120, 0, 0));
      graphics.drawString('hello world', helvetica37,
          bounds: const Rect.fromLTWH(280, 160, 0, 0));
      graphics.drawString('hello world', helvetica38,
          bounds: const Rect.fromLTWH(280, 200, 0, 0));
      graphics.drawString('hello world', helvetica39,
          bounds: const Rect.fromLTWH(280, 240, 0, 0));
      graphics.drawString('hello world', helvetica40,
          bounds: const Rect.fromLTWH(280, 280, 0, 0));
      graphics.drawString('hello world', helvetica41,
          bounds: const Rect.fromLTWH(280, 320, 0, 0));
      graphics.drawString('hello world', helvetica42,
          bounds: const Rect.fromLTWH(280, 360, 0, 0));
      graphics.drawString('hello world', helvetica43,
          bounds: const Rect.fromLTWH(280, 400, 0, 0));
      graphics.drawString('hello world', helvetica44,
          bounds: const Rect.fromLTWH(280, 440, 0, 0));
      graphics.drawString('hello world', helvetica45,
          bounds: const Rect.fromLTWH(280, 480, 0, 0));
      graphics.drawString('hello world', helvetica46,
          bounds: const Rect.fromLTWH(280, 520, 0, 0));
      graphics.drawString('hello world', helvetica47,
          bounds: const Rect.fromLTWH(280, 560, 0, 0));
      graphics.drawString('hello world', helvetica48,
          bounds: const Rect.fromLTWH(280, 600, 0, 0));
      graphics.drawString('hello world', helvetica49,
          bounds: const Rect.fromLTWH(410, 0, 0, 0));
      graphics.drawString('hello world', helvetica50,
          bounds: const Rect.fromLTWH(410, 40, 0, 0));
      graphics.drawString('hello world', helvetica51,
          bounds: const Rect.fromLTWH(410, 80, 0, 0));
      graphics.drawString('hello world', helvetica52,
          bounds: const Rect.fromLTWH(410, 120, 0, 0));
      graphics.drawString('hello world', helvetica53,
          bounds: const Rect.fromLTWH(410, 160, 0, 0));
      graphics.drawString('hello world', helvetica54,
          bounds: const Rect.fromLTWH(410, 200, 0, 0));
      graphics.drawString('hello world', helvetica55,
          bounds: const Rect.fromLTWH(410, 240, 0, 0));
      graphics.drawString('hello world', helvetica56,
          bounds: const Rect.fromLTWH(410, 280, 0, 0));
      graphics.drawString('hello world', helvetica57,
          bounds: const Rect.fromLTWH(410, 320, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw "hello world with helvetica font');
      savePdf(bytes, 'FLUT_492_DrawString2.pdf');
      document.dispose();
    });
    test('"hello world" draw with helvetica font', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont timesRoman1 = PdfStandardFont(PdfFontFamily.timesRoman, 12);
      final PdfFont timesRoman2 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular);
      final PdfFont timesRoman3 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.bold);
      final PdfFont timesRoman4 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.italic);
      final PdfFont timesRoman5 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.strikethrough);
      final PdfFont timesRoman6 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.underline);
      final PdfFont timesRoman7 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont timesRoman8 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont timesRoman9 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont timesRoman10 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont timesRoman11 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont timesRoman12 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont timesRoman13 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont timesRoman14 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont timesRoman15 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont timesRoman16 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont timesRoman17 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont timesRoman18 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont timesRoman19 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont timesRoman20 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont timesRoman21 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont timesRoman22 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont timesRoman23 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont timesRoman24 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont timesRoman25 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont timesRoman26 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont timesRoman27 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont timesRoman28 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont timesRoman29 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont timesRoman30 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont timesRoman31 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont timesRoman32 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman33 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont timesRoman34 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman35 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman36 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont timesRoman37 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman38 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
      final PdfFont timesRoman39 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman40 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont timesRoman41 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman42 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman43 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular, PdfFontStyle.bold]);
      final PdfFont timesRoman44 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman45 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont timesRoman46 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman47 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic
          ]);
      final PdfFont timesRoman48 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman49 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont timesRoman50 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman51 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic
          ]);
      final PdfFont timesRoman52 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman53 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont timesRoman54 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman55 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.underline
          ]);
      final PdfFont timesRoman56 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont timesRoman57 = PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('hello world', timesRoman1);
      graphics.drawString('hello world', timesRoman2,
          bounds: const Rect.fromLTWH(20, 40, 0, 0));
      graphics.drawString('hello world', timesRoman3,
          bounds: const Rect.fromLTWH(20, 80, 0, 0));
      graphics.drawString('hello world', timesRoman4,
          bounds: const Rect.fromLTWH(20, 120, 0, 0));
      graphics.drawString('hello world', timesRoman5,
          bounds: const Rect.fromLTWH(20, 160, 0, 0));
      graphics.drawString('hello world', timesRoman6,
          bounds: const Rect.fromLTWH(20, 200, 0, 0));
      graphics.drawString('hello world', timesRoman7,
          bounds: const Rect.fromLTWH(20, 240, 0, 0));
      graphics.drawString('hello world', timesRoman8,
          bounds: const Rect.fromLTWH(20, 280, 0, 0));
      graphics.drawString('hello world', timesRoman9,
          bounds: const Rect.fromLTWH(20, 320, 0, 0));
      graphics.drawString('hello world', timesRoman10,
          bounds: const Rect.fromLTWH(20, 360, 0, 0));
      graphics.drawString('hello world', timesRoman11,
          bounds: const Rect.fromLTWH(20, 400, 0, 0));
      graphics.drawString('hello world', timesRoman12,
          bounds: const Rect.fromLTWH(20, 440, 0, 0));
      graphics.drawString('hello world', timesRoman13,
          bounds: const Rect.fromLTWH(20, 480, 0, 0));
      graphics.drawString('hello world', timesRoman14,
          bounds: const Rect.fromLTWH(20, 520, 0, 0));
      graphics.drawString('hello world', timesRoman15,
          bounds: const Rect.fromLTWH(20, 560, 0, 0));
      graphics.drawString('hello world', timesRoman16,
          bounds: const Rect.fromLTWH(20, 600, 0, 0));
      graphics.drawString('hello world', timesRoman17,
          bounds: const Rect.fromLTWH(150, 0, 0, 0));
      graphics.drawString('hello world', timesRoman18,
          bounds: const Rect.fromLTWH(150, 40, 0, 0));
      graphics.drawString('hello world', timesRoman19,
          bounds: const Rect.fromLTWH(150, 80, 0, 0));
      graphics.drawString('hello world', timesRoman20,
          bounds: const Rect.fromLTWH(150, 120, 0, 0));
      graphics.drawString('hello world', timesRoman21,
          bounds: const Rect.fromLTWH(150, 160, 0, 0));
      graphics.drawString('hello world', timesRoman22,
          bounds: const Rect.fromLTWH(150, 200, 0, 0));
      graphics.drawString('hello world', timesRoman23,
          bounds: const Rect.fromLTWH(150, 240, 0, 0));
      graphics.drawString('hello world', timesRoman24,
          bounds: const Rect.fromLTWH(150, 280, 0, 0));
      graphics.drawString('hello world', timesRoman25,
          bounds: const Rect.fromLTWH(150, 320, 0, 0));
      graphics.drawString('hello world', timesRoman26,
          bounds: const Rect.fromLTWH(150, 360, 0, 0));
      graphics.drawString('hello world', timesRoman27,
          bounds: const Rect.fromLTWH(150, 400, 0, 0));
      graphics.drawString('hello world', timesRoman28,
          bounds: const Rect.fromLTWH(150, 440, 0, 0));
      graphics.drawString('hello world', timesRoman29,
          bounds: const Rect.fromLTWH(150, 480, 0, 0));
      graphics.drawString('hello world', timesRoman30,
          bounds: const Rect.fromLTWH(150, 520, 0, 0));
      graphics.drawString('hello world', timesRoman31,
          bounds: const Rect.fromLTWH(150, 560, 0, 0));
      graphics.drawString('hello world', timesRoman32,
          bounds: const Rect.fromLTWH(150, 600, 0, 0));
      graphics.drawString('hello world', timesRoman33,
          bounds: const Rect.fromLTWH(280, 0, 0, 0));
      graphics.drawString('hello world', timesRoman34,
          bounds: const Rect.fromLTWH(280, 40, 0, 0));
      graphics.drawString('hello world', timesRoman35,
          bounds: const Rect.fromLTWH(280, 80, 0, 0));
      graphics.drawString('hello world', timesRoman36,
          bounds: const Rect.fromLTWH(280, 120, 0, 0));
      graphics.drawString('hello world', timesRoman37,
          bounds: const Rect.fromLTWH(280, 160, 0, 0));
      graphics.drawString('hello world', timesRoman38,
          bounds: const Rect.fromLTWH(280, 200, 0, 0));
      graphics.drawString('hello world', timesRoman39,
          bounds: const Rect.fromLTWH(280, 240, 0, 0));
      graphics.drawString('hello world', timesRoman40,
          bounds: const Rect.fromLTWH(280, 280, 0, 0));
      graphics.drawString('hello world', timesRoman41,
          bounds: const Rect.fromLTWH(280, 320, 0, 0));
      graphics.drawString('hello world', timesRoman42,
          bounds: const Rect.fromLTWH(280, 360, 0, 0));
      graphics.drawString('hello world', timesRoman43,
          bounds: const Rect.fromLTWH(280, 400, 0, 0));
      graphics.drawString('hello world', timesRoman44,
          bounds: const Rect.fromLTWH(280, 440, 0, 0));
      graphics.drawString('hello world', timesRoman45,
          bounds: const Rect.fromLTWH(280, 480, 0, 0));
      graphics.drawString('hello world', timesRoman46,
          bounds: const Rect.fromLTWH(280, 520, 0, 0));
      graphics.drawString('hello world', timesRoman47,
          bounds: const Rect.fromLTWH(280, 560, 0, 0));
      graphics.drawString('hello world', timesRoman48,
          bounds: const Rect.fromLTWH(280, 600, 0, 0));
      graphics.drawString('hello world', timesRoman49,
          bounds: const Rect.fromLTWH(410, 0, 0, 0));
      graphics.drawString('hello world', timesRoman50,
          bounds: const Rect.fromLTWH(410, 40, 0, 0));
      graphics.drawString('hello world', timesRoman51,
          bounds: const Rect.fromLTWH(410, 80, 0, 0));
      graphics.drawString('hello world', timesRoman52,
          bounds: const Rect.fromLTWH(410, 120, 0, 0));
      graphics.drawString('hello world', timesRoman53,
          bounds: const Rect.fromLTWH(410, 160, 0, 0));
      graphics.drawString('hello world', timesRoman54,
          bounds: const Rect.fromLTWH(410, 200, 0, 0));
      graphics.drawString('hello world', timesRoman55,
          bounds: const Rect.fromLTWH(410, 240, 0, 0));
      graphics.drawString('hello world', timesRoman56,
          bounds: const Rect.fromLTWH(410, 280, 0, 0));
      graphics.drawString('hello world', timesRoman57,
          bounds: const Rect.fromLTWH(410, 320, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw "hello world with timesRoman font');
      savePdf(bytes, 'FLUT_492_DrawString3.pdf');
      document.dispose();
    });
    test('"hello world" draw with helvetica font', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont symbol1 = PdfStandardFont(PdfFontFamily.symbol, 12);
      final PdfFont symbol2 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular);
      final PdfFont symbol3 =
          PdfStandardFont(PdfFontFamily.symbol, 12, style: PdfFontStyle.bold);
      final PdfFont symbol4 =
          PdfStandardFont(PdfFontFamily.symbol, 12, style: PdfFontStyle.italic);
      final PdfFont symbol5 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.strikethrough);
      final PdfFont symbol6 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.underline);
      final PdfFont symbol7 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont symbol8 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont symbol9 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont symbol10 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont symbol11 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont symbol12 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont symbol13 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont symbol14 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont symbol15 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont symbol16 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont symbol17 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont symbol18 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont symbol19 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont symbol20 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont symbol21 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont symbol22 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont symbol23 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont symbol24 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont symbol25 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont symbol26 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont symbol27 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont symbol28 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont symbol29 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont symbol30 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont symbol31 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont symbol32 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol33 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont symbol34 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol35 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol36 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont symbol37 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol38 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
      final PdfFont symbol39 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol40 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont symbol41 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol42 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol43 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular, PdfFontStyle.bold]);
      final PdfFont symbol44 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol45 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont symbol46 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol47 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic
          ]);
      final PdfFont symbol48 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol49 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont symbol50 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol51 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic
          ]);
      final PdfFont symbol52 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol53 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont symbol54 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol55 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.underline
          ]);
      final PdfFont symbol56 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont symbol57 = PdfStandardFont(PdfFontFamily.symbol, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('hello world', symbol1);
      graphics.drawString('hello world', symbol2,
          bounds: const Rect.fromLTWH(20, 40, 0, 0));
      graphics.drawString('hello world', symbol3,
          bounds: const Rect.fromLTWH(20, 80, 0, 0));
      graphics.drawString('hello world', symbol4,
          bounds: const Rect.fromLTWH(20, 120, 0, 0));
      graphics.drawString('hello world', symbol5,
          bounds: const Rect.fromLTWH(20, 160, 0, 0));
      graphics.drawString('hello world', symbol6,
          bounds: const Rect.fromLTWH(20, 200, 0, 0));
      graphics.drawString('hello world', symbol7,
          bounds: const Rect.fromLTWH(20, 240, 0, 0));
      graphics.drawString('hello world', symbol8,
          bounds: const Rect.fromLTWH(20, 280, 0, 0));
      graphics.drawString('hello world', symbol9,
          bounds: const Rect.fromLTWH(20, 320, 0, 0));
      graphics.drawString('hello world', symbol10,
          bounds: const Rect.fromLTWH(20, 360, 0, 0));
      graphics.drawString('hello world', symbol11,
          bounds: const Rect.fromLTWH(20, 400, 0, 0));
      graphics.drawString('hello world', symbol12,
          bounds: const Rect.fromLTWH(20, 440, 0, 0));
      graphics.drawString('hello world', symbol13,
          bounds: const Rect.fromLTWH(20, 480, 0, 0));
      graphics.drawString('hello world', symbol14,
          bounds: const Rect.fromLTWH(20, 520, 0, 0));
      graphics.drawString('hello world', symbol15,
          bounds: const Rect.fromLTWH(20, 560, 0, 0));
      graphics.drawString('hello world', symbol16,
          bounds: const Rect.fromLTWH(20, 600, 0, 0));
      graphics.drawString('hello world', symbol17,
          bounds: const Rect.fromLTWH(150, 0, 0, 0));
      graphics.drawString('hello world', symbol18,
          bounds: const Rect.fromLTWH(150, 40, 0, 0));
      graphics.drawString('hello world', symbol19,
          bounds: const Rect.fromLTWH(150, 80, 0, 0));
      graphics.drawString('hello world', symbol20,
          bounds: const Rect.fromLTWH(150, 120, 0, 0));
      graphics.drawString('hello world', symbol21,
          bounds: const Rect.fromLTWH(150, 160, 0, 0));
      graphics.drawString('hello world', symbol22,
          bounds: const Rect.fromLTWH(150, 200, 0, 0));
      graphics.drawString('hello world', symbol23,
          bounds: const Rect.fromLTWH(150, 240, 0, 0));
      graphics.drawString('hello world', symbol24,
          bounds: const Rect.fromLTWH(150, 280, 0, 0));
      graphics.drawString('hello world', symbol25,
          bounds: const Rect.fromLTWH(150, 320, 0, 0));
      graphics.drawString('hello world', symbol26,
          bounds: const Rect.fromLTWH(150, 360, 0, 0));
      graphics.drawString('hello world', symbol27,
          bounds: const Rect.fromLTWH(150, 400, 0, 0));
      graphics.drawString('hello world', symbol28,
          bounds: const Rect.fromLTWH(150, 440, 0, 0));
      graphics.drawString('hello world', symbol29,
          bounds: const Rect.fromLTWH(150, 480, 0, 0));
      graphics.drawString('hello world', symbol30,
          bounds: const Rect.fromLTWH(150, 520, 0, 0));
      graphics.drawString('hello world', symbol31,
          bounds: const Rect.fromLTWH(150, 560, 0, 0));
      graphics.drawString('hello world', symbol32,
          bounds: const Rect.fromLTWH(150, 600, 0, 0));
      graphics.drawString('hello world', symbol33,
          bounds: const Rect.fromLTWH(280, 0, 0, 0));
      graphics.drawString('hello world', symbol34,
          bounds: const Rect.fromLTWH(280, 40, 0, 0));
      graphics.drawString('hello world', symbol35,
          bounds: const Rect.fromLTWH(280, 80, 0, 0));
      graphics.drawString('hello world', symbol36,
          bounds: const Rect.fromLTWH(280, 120, 0, 0));
      graphics.drawString('hello world', symbol37,
          bounds: const Rect.fromLTWH(280, 160, 0, 0));
      graphics.drawString('hello world', symbol38,
          bounds: const Rect.fromLTWH(280, 200, 0, 0));
      graphics.drawString('hello world', symbol39,
          bounds: const Rect.fromLTWH(280, 240, 0, 0));
      graphics.drawString('hello world', symbol40,
          bounds: const Rect.fromLTWH(280, 280, 0, 0));
      graphics.drawString('hello world', symbol41,
          bounds: const Rect.fromLTWH(280, 320, 0, 0));
      graphics.drawString('hello world', symbol42,
          bounds: const Rect.fromLTWH(280, 360, 0, 0));
      graphics.drawString('hello world', symbol43,
          bounds: const Rect.fromLTWH(280, 400, 0, 0));
      graphics.drawString('hello world', symbol44,
          bounds: const Rect.fromLTWH(280, 440, 0, 0));
      graphics.drawString('hello world', symbol45,
          bounds: const Rect.fromLTWH(280, 480, 0, 0));
      graphics.drawString('hello world', symbol46,
          bounds: const Rect.fromLTWH(280, 520, 0, 0));
      graphics.drawString('hello world', symbol47,
          bounds: const Rect.fromLTWH(280, 560, 0, 0));
      graphics.drawString('hello world', symbol48,
          bounds: const Rect.fromLTWH(280, 600, 0, 0));
      graphics.drawString('hello world', symbol49,
          bounds: const Rect.fromLTWH(410, 0, 0, 0));
      graphics.drawString('hello world', symbol50,
          bounds: const Rect.fromLTWH(410, 40, 0, 0));
      graphics.drawString('hello world', symbol51,
          bounds: const Rect.fromLTWH(410, 80, 0, 0));
      graphics.drawString('hello world', symbol52,
          bounds: const Rect.fromLTWH(410, 120, 0, 0));
      graphics.drawString('hello world', symbol53,
          bounds: const Rect.fromLTWH(410, 160, 0, 0));
      graphics.drawString('hello world', symbol54,
          bounds: const Rect.fromLTWH(410, 200, 0, 0));
      graphics.drawString('hello world', symbol55,
          bounds: const Rect.fromLTWH(410, 240, 0, 0));
      graphics.drawString('hello world', symbol56,
          bounds: const Rect.fromLTWH(410, 280, 0, 0));
      graphics.drawString('hello world', symbol57,
          bounds: const Rect.fromLTWH(410, 320, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw "hello world with symbol font');
      savePdf(bytes, 'FLUT_492_DrawString4.pdf');
      document.dispose();
    });
    test('"hello world" draw with helvetica font', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont zapfDingbats1 =
          PdfStandardFont(PdfFontFamily.zapfDingbats, 12);
      final PdfFont zapfDingbats2 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular);
      final PdfFont zapfDingbats3 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.bold);
      final PdfFont zapfDingbats4 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.italic);
      final PdfFont zapfDingbats5 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.strikethrough);
      final PdfFont zapfDingbats6 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.underline);
      final PdfFont zapfDingbats7 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont zapfDingbats8 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont zapfDingbats9 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont zapfDingbats10 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont zapfDingbats11 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont zapfDingbats12 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont zapfDingbats13 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont zapfDingbats14 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont zapfDingbats15 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont zapfDingbats16 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont zapfDingbats17 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont zapfDingbats18 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont zapfDingbats19 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont zapfDingbats20 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont zapfDingbats21 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.italic,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont zapfDingbats22 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont zapfDingbats23 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont zapfDingbats24 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont zapfDingbats25 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont zapfDingbats26 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.strikethrough,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont zapfDingbats27 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular]);
      final PdfFont zapfDingbats28 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold]);
      final PdfFont zapfDingbats29 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont zapfDingbats30 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.strikethrough]);
      final PdfFont zapfDingbats31 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.underline,
          multiStyle: <PdfFontStyle>[PdfFontStyle.underline]);
      final PdfFont zapfDingbats32 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats33 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont zapfDingbats34 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats35 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats36 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont zapfDingbats37 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats38 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
      final PdfFont zapfDingbats39 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats40 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont zapfDingbats41 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats42 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats43 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[PdfFontStyle.regular, PdfFontStyle.bold]);
      final PdfFont zapfDingbats44 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats45 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont zapfDingbats46 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats47 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic
          ]);
      final PdfFont zapfDingbats48 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats49 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont zapfDingbats50 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats51 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic
          ]);
      final PdfFont zapfDingbats52 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats53 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont zapfDingbats54 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats55 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.underline
          ]);
      final PdfFont zapfDingbats56 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont zapfDingbats57 = PdfStandardFont(
          PdfFontFamily.zapfDingbats, 12,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.regular,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('hello world', zapfDingbats1);
      graphics.drawString('hello world', zapfDingbats2,
          bounds: const Rect.fromLTWH(20, 40, 0, 0));
      graphics.drawString('hello world', zapfDingbats3,
          bounds: const Rect.fromLTWH(20, 80, 0, 0));
      graphics.drawString('hello world', zapfDingbats4,
          bounds: const Rect.fromLTWH(20, 120, 0, 0));
      graphics.drawString('hello world', zapfDingbats5,
          bounds: const Rect.fromLTWH(20, 160, 0, 0));
      graphics.drawString('hello world', zapfDingbats6,
          bounds: const Rect.fromLTWH(20, 200, 0, 0));
      graphics.drawString('hello world', zapfDingbats7,
          bounds: const Rect.fromLTWH(20, 240, 0, 0));
      graphics.drawString('hello world', zapfDingbats8,
          bounds: const Rect.fromLTWH(20, 280, 0, 0));
      graphics.drawString('hello world', zapfDingbats9,
          bounds: const Rect.fromLTWH(20, 320, 0, 0));
      graphics.drawString('hello world', zapfDingbats10,
          bounds: const Rect.fromLTWH(20, 360, 0, 0));
      graphics.drawString('hello world', zapfDingbats11,
          bounds: const Rect.fromLTWH(20, 400, 0, 0));
      graphics.drawString('hello world', zapfDingbats12,
          bounds: const Rect.fromLTWH(20, 440, 0, 0));
      graphics.drawString('hello world', zapfDingbats13,
          bounds: const Rect.fromLTWH(20, 480, 0, 0));
      graphics.drawString('hello world', zapfDingbats14,
          bounds: const Rect.fromLTWH(20, 520, 0, 0));
      graphics.drawString('hello world', zapfDingbats15,
          bounds: const Rect.fromLTWH(20, 560, 0, 0));
      graphics.drawString('hello world', zapfDingbats16,
          bounds: const Rect.fromLTWH(20, 600, 0, 0));
      graphics.drawString('hello world', zapfDingbats17,
          bounds: const Rect.fromLTWH(150, 0, 0, 0));
      graphics.drawString('hello world', zapfDingbats18,
          bounds: const Rect.fromLTWH(150, 40, 0, 0));
      graphics.drawString('hello world', zapfDingbats19,
          bounds: const Rect.fromLTWH(150, 80, 0, 0));
      graphics.drawString('hello world', zapfDingbats20,
          bounds: const Rect.fromLTWH(150, 120, 0, 0));
      graphics.drawString('hello world', zapfDingbats21,
          bounds: const Rect.fromLTWH(150, 160, 0, 0));
      graphics.drawString('hello world', zapfDingbats22,
          bounds: const Rect.fromLTWH(150, 200, 0, 0));
      graphics.drawString('hello world', zapfDingbats23,
          bounds: const Rect.fromLTWH(150, 240, 0, 0));
      graphics.drawString('hello world', zapfDingbats24,
          bounds: const Rect.fromLTWH(150, 280, 0, 0));
      graphics.drawString('hello world', zapfDingbats25,
          bounds: const Rect.fromLTWH(150, 320, 0, 0));
      graphics.drawString('hello world', zapfDingbats26,
          bounds: const Rect.fromLTWH(150, 360, 0, 0));
      graphics.drawString('hello world', zapfDingbats27,
          bounds: const Rect.fromLTWH(150, 400, 0, 0));
      graphics.drawString('hello world', zapfDingbats28,
          bounds: const Rect.fromLTWH(150, 440, 0, 0));
      graphics.drawString('hello world', zapfDingbats29,
          bounds: const Rect.fromLTWH(150, 480, 0, 0));
      graphics.drawString('hello world', zapfDingbats30,
          bounds: const Rect.fromLTWH(150, 520, 0, 0));
      graphics.drawString('hello world', zapfDingbats31,
          bounds: const Rect.fromLTWH(150, 560, 0, 0));
      graphics.drawString('hello world', zapfDingbats32,
          bounds: const Rect.fromLTWH(150, 600, 0, 0));
      graphics.drawString('hello world', zapfDingbats33,
          bounds: const Rect.fromLTWH(280, 0, 0, 0));
      graphics.drawString('hello world', zapfDingbats34,
          bounds: const Rect.fromLTWH(280, 40, 0, 0));
      graphics.drawString('hello world', zapfDingbats35,
          bounds: const Rect.fromLTWH(280, 80, 0, 0));
      graphics.drawString('hello world', zapfDingbats36,
          bounds: const Rect.fromLTWH(280, 120, 0, 0));
      graphics.drawString('hello world', zapfDingbats37,
          bounds: const Rect.fromLTWH(280, 160, 0, 0));
      graphics.drawString('hello world', zapfDingbats38,
          bounds: const Rect.fromLTWH(280, 200, 0, 0));
      graphics.drawString('hello world', zapfDingbats39,
          bounds: const Rect.fromLTWH(280, 240, 0, 0));
      graphics.drawString('hello world', zapfDingbats40,
          bounds: const Rect.fromLTWH(280, 280, 0, 0));
      graphics.drawString('hello world', zapfDingbats41,
          bounds: const Rect.fromLTWH(280, 320, 0, 0));
      graphics.drawString('hello world', zapfDingbats42,
          bounds: const Rect.fromLTWH(280, 360, 0, 0));
      graphics.drawString('hello world', zapfDingbats43,
          bounds: const Rect.fromLTWH(280, 400, 0, 0));
      graphics.drawString('hello world', zapfDingbats44,
          bounds: const Rect.fromLTWH(280, 440, 0, 0));
      graphics.drawString('hello world', zapfDingbats45,
          bounds: const Rect.fromLTWH(280, 480, 0, 0));
      graphics.drawString('hello world', zapfDingbats46,
          bounds: const Rect.fromLTWH(280, 520, 0, 0));
      graphics.drawString('hello world', zapfDingbats47,
          bounds: const Rect.fromLTWH(280, 560, 0, 0));
      graphics.drawString('hello world', zapfDingbats48,
          bounds: const Rect.fromLTWH(280, 600, 0, 0));
      graphics.drawString('hello world', zapfDingbats49,
          bounds: const Rect.fromLTWH(410, 0, 0, 0));
      graphics.drawString('hello world', zapfDingbats50,
          bounds: const Rect.fromLTWH(410, 40, 0, 0));
      graphics.drawString('hello world', zapfDingbats51,
          bounds: const Rect.fromLTWH(410, 80, 0, 0));
      graphics.drawString('hello world', zapfDingbats52,
          bounds: const Rect.fromLTWH(410, 120, 0, 0));
      graphics.drawString('hello world', zapfDingbats53,
          bounds: const Rect.fromLTWH(410, 160, 0, 0));
      graphics.drawString('hello world', zapfDingbats54,
          bounds: const Rect.fromLTWH(410, 200, 0, 0));
      graphics.drawString('hello world', zapfDingbats55,
          bounds: const Rect.fromLTWH(410, 240, 0, 0));
      graphics.drawString('hello world', zapfDingbats56,
          bounds: const Rect.fromLTWH(410, 280, 0, 0));
      graphics.drawString('hello world', zapfDingbats57,
          bounds: const Rect.fromLTWH(410, 320, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw "hello world with zapfDingbats font');
      savePdf(bytes, 'FLUT_492_DrawString5.pdf');
      document.dispose();
    });
    test('"hello world" draw with all standard fonts in same page', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont courier = PdfStandardFont(PdfFontFamily.courier, 12);
      final PdfFont helvetica = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 12);
      final PdfFont symbol = PdfStandardFont(PdfFontFamily.symbol, 12);
      final PdfFont zapfDingbats =
          PdfStandardFont(PdfFontFamily.zapfDingbats, 12);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('hello world', courier,
          bounds: const Rect.fromLTWH(20, 0, 0, 0));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(20, 40, 0, 0));
      graphics.drawString('hello world', timesRoman,
          bounds: const Rect.fromLTWH(20, 80, 0, 0));
      graphics.drawString('hello world', symbol,
          bounds: const Rect.fromLTWH(20, 120, 0, 0));
      graphics.drawString('hello world', zapfDingbats,
          bounds: const Rect.fromLTWH(20, 160, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to save empty PDF document without page.add() call');
      savePdf(bytes, 'FLUT_492_DrawString.pdf');
      document.dispose();
    });
    test('"hello world" draw with x, y, width, height and bounds values', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont helvetica = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('hello world', helvetica);
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(100, 0, 0, 0));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(200, 0, 50, 0));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(300, 0, 0, 20));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(400, 0, 50, 20));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(10, 80, 0, 0));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(110, 80, 50, 0));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(210, 80, 0, 20));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(310, 80, 50, 20));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(0, 120, 0, 0));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(0, 160, 50, 0));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(0, 200, 0, 20));
      graphics.drawString('hello world', helvetica,
          bounds: const Rect.fromLTWH(0, 240, 50, 20));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to save empty PDF document without page.add() call');
      savePdf(bytes, 'FLUT_492_DrawString6.pdf');
      document.dispose();
    });
  });
  group('Drawing string with PdfStringFormat', () {
    test('PdfTextAlignment types', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfStringFormat format1 = PdfStringFormat();
      format1.alignment = PdfTextAlignment.left;
      final PdfStringFormat format2 = PdfStringFormat();
      format2.alignment = PdfTextAlignment.right;
      final PdfStringFormat format3 = PdfStringFormat();
      format3.alignment = PdfTextAlignment.center;
      final PdfStringFormat format4 = PdfStringFormat();
      format4.alignment = PdfTextAlignment.justify;
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 0, 200, 100));
      graphics.drawString('Hello World !!! - PdfTextAlignment Left', font,
          bounds: const Rect.fromLTWH(0, 0, 200, 100), format: format1);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(220, 0, 200, 100));
      graphics.drawString('Hello World !!! - PdfTextAlignment Right', font,
          bounds: const Rect.fromLTWH(220, 0, 200, 100), format: format2);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 120, 200, 100));
      graphics.drawString('Hello World !!! - PdfTextAlignment Center', font,
          bounds: const Rect.fromLTWH(0, 120, 200, 100), format: format3);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(220, 120, 200, 100));
      graphics.drawString('Hello World !!! - PdfTextAlignment Justify', font,
          bounds: const Rect.fromLTWH(220, 120, 200, 100), format: format4);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw string with PdfTextAlignment');
      savePdf(bytes, 'FLUT_492_PdfStringFormat_TextAlignment.pdf');
      document.dispose();
    });
    test('PdfVerticalAlignment types', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfStringFormat format1 = PdfStringFormat();
      format1.lineAlignment = PdfVerticalAlignment.top;
      final PdfStringFormat format2 = PdfStringFormat();
      format2.lineAlignment = PdfVerticalAlignment.middle;
      final PdfStringFormat format3 = PdfStringFormat();
      format3.lineAlignment = PdfVerticalAlignment.bottom;
      final PdfStringFormat format4 = PdfStringFormat();
      //Overloads
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 0, 200, 100));
      graphics.drawString('Hello World !!! - PdfVerticalAlignment.top', font,
          bounds: const Rect.fromLTWH(0, 0, 200, 100), format: format1);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 120, 200, 100));
      graphics.drawString('Hello World !!! - PdfVerticalAlignment.middle', font,
          bounds: const Rect.fromLTWH(0, 120, 200, 100), format: format2);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 240, 200, 100));
      graphics.drawString('Hello World !!! - PdfVerticalAlignment.bottom', font,
          bounds: const Rect.fromLTWH(0, 240, 200, 100), format: format3);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 360, 200, 100));
      //Default
      graphics.drawString('Hello World !!! - PdfVerticalAlignment empty', font,
          bounds: const Rect.fromLTWH(0, 360, 200, 100), format: format4);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 360, 200, 100));
      graphics.drawString(
          'Hello World !!! - PdfVerticalAlignment default', font,
          bounds: const Rect.fromLTWH(0, 480, 200, 100));
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 480, 200, 100));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw string with PdfVerticalAlignment');
      savePdf(bytes, 'FLUT_492_PdfStringFormat_VerticalAlignment.pdf');
      document.dispose();
    });
    test('Character Spacing', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfStringFormat empty = PdfStringFormat();
      final PdfStringFormat format1 = PdfStringFormat();
      format1.alignment = PdfTextAlignment.center;
      format1.lineAlignment = PdfVerticalAlignment.middle;
      format1.characterSpacing = 1;
      final PdfStringFormat format2 = PdfStringFormat();
      format2.alignment = PdfTextAlignment.center;
      format2.lineAlignment = PdfVerticalAlignment.middle;
      //Overloads
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 0, 200, 100));
      graphics.drawString('Hello World !!! - Character Spacing 1', font,
          bounds: const Rect.fromLTWH(0, 0, 200, 100), format: format1);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(250, 0, 200, 100));
      graphics.drawString('Hello World !!! - Character Spacing 1', font,
          bounds: const Rect.fromLTWH(250, 0, 200, 100), format: format2);
      //Default
      graphics.drawString('Hello World !!! - Character Spacing empty', font,
          bounds: const Rect.fromLTWH(0, 120, 200, 100), format: empty);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 120, 200, 100));
      graphics.drawString('Hello World !!! - Character Spacing default', font,
          bounds: const Rect.fromLTWH(0, 240, 200, 100));
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 240, 200, 100));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw string with Character Spacing');
      savePdf(bytes, 'FLUT_492_PdfStringFormat_CharacterSpacing.pdf');
      document.dispose();
    });
    test('Word Spacing', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfStringFormat empty = PdfStringFormat();
      final PdfStringFormat format1 = PdfStringFormat();
      format1.alignment = PdfTextAlignment.center;
      format1.lineAlignment = PdfVerticalAlignment.middle;
      format1.wordSpacing = 5;
      final PdfStringFormat format2 = PdfStringFormat();
      format2.alignment = PdfTextAlignment.center;
      format2.lineAlignment = PdfVerticalAlignment.middle;
      //Overloads
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 0, 200, 100));
      graphics.drawString('Hello World !!! - Word Spacing 5', font,
          bounds: const Rect.fromLTWH(0, 0, 200, 100), format: format1);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(250, 0, 200, 100));
      graphics.drawString('Hello World !!! - Word Spacing 5', font,
          bounds: const Rect.fromLTWH(250, 0, 200, 100), format: format2);
      //Default
      graphics.drawString('Hello World !!! - Word Spacing empty', font,
          bounds: const Rect.fromLTWH(0, 120, 200, 100), format: empty);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 120, 200, 100));
      graphics.drawString('Hello World !!! - Word Spacing default', font,
          bounds: const Rect.fromLTWH(0, 240, 200, 100));
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 240, 200, 100));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw string with Word Spacing');
      savePdf(bytes, 'FLUT_492_PdfStringFormat_WordSpacing.pdf');
      document.dispose();
    });
    test('Clip Path', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfGraphics graphics1 = page1.graphics;
      final PdfPage page2 = document.pages.add();
      final PdfGraphics graphics2 = page2.graphics;
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfBrush redBrush = PdfSolidBrush(PdfColor(255, 0, 0));
      final PdfStringFormat format1 = PdfStringFormat();
      format1.alignment = PdfTextAlignment.center;
      format1.lineAlignment = PdfVerticalAlignment.middle;
      format1.characterSpacing = 1;
      format1.clipPath = true;
      final PdfStringFormat format2 = PdfStringFormat();
      format2.alignment = PdfTextAlignment.center;
      format2.lineAlignment = PdfVerticalAlignment.middle;
      format2.characterSpacing = 1;
      format2.clipPath = false;
      //Overloads
      graphics1.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 0, 200, 100));
      graphics1.drawString('Hello World !!! - ClipPath true', font,
          bounds: const Rect.fromLTWH(0, 0, 200, 100), format: format1);
      graphics1.drawRectangle(
          brush: redBrush, bounds: const Rect.fromLTWH(150, 20, 20, 60));
      graphics1.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(50, 20, 200, 60));
      graphics1.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 150, 200, 100));
      graphics2.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 0, 200, 100));
      graphics2.drawString('Hello World !!! - ClipPath false', font,
          bounds: const Rect.fromLTWH(0, 0, 200, 100), format: format2);
      graphics2.drawRectangle(
          brush: redBrush, bounds: const Rect.fromLTWH(150, 20, 20, 60));
      graphics2.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(50, 20, 200, 60));
      graphics2.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 150, 200, 100));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw string with Clip Path');
      savePdf(bytes, 'FLUT_492_PdfStringFormat_ClipPath.pdf');
      document.dispose();
    });
    test('Line Spacing', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfStringFormat format1 = PdfStringFormat();
      format1.alignment = PdfTextAlignment.center;
      format1.lineAlignment = PdfVerticalAlignment.middle;
      format1.lineSpacing = 5;
      final PdfStringFormat format2 = PdfStringFormat();
      format2.alignment = PdfTextAlignment.center;
      format2.lineAlignment = PdfVerticalAlignment.middle;
      //Overloads
      graphics.drawString('Hello World !!! - Line Spacing 3', font,
          bounds: const Rect.fromLTWH(0, 0, 70, 100), format: format1);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 0, 70, 100));
      graphics.drawString('Hello World !!! - Line Spacing empty', font,
          bounds: const Rect.fromLTWH(100, 0, 70, 100), format: format2);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(100, 0, 70, 100));
      graphics.drawString('Hello World !!! - Line Spacing default', font,
          bounds: const Rect.fromLTWH(200, 0, 70, 100));
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(200, 0, 70, 100));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw string with Line Spacing');
      savePdf(bytes, 'FLUT_492_PdfStringFormat_LineSpacing.pdf');
      document.dispose();
    });
    test('Word Wrap', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfStringFormat format1 = PdfStringFormat();
      format1.alignment = PdfTextAlignment.center;
      format1.lineAlignment = PdfVerticalAlignment.middle;
      format1.wordWrap = PdfWordWrapType.word;
      final PdfStringFormat format2 = PdfStringFormat();
      format2.alignment = PdfTextAlignment.center;
      format2.lineAlignment = PdfVerticalAlignment.middle;
      format2.wordWrap = PdfWordWrapType.character;
      final PdfStringFormat format3 = PdfStringFormat();
      format3.alignment = PdfTextAlignment.center;
      format3.lineAlignment = PdfVerticalAlignment.middle;
      format3.wordWrap = PdfWordWrapType.wordOnly;
      final PdfStringFormat format4 = PdfStringFormat();
      format4.alignment = PdfTextAlignment.center;
      format4.lineAlignment = PdfVerticalAlignment.middle;
      //Overloads
      graphics.drawString('HelloWorld!!!Test - Word Wrap - word', font,
          bounds: const Rect.fromLTWH(0, 0, 70, 100), format: format1);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 0, 70, 100));
      graphics.drawString('HelloWorld!!!Test - Word Wrap - character', font,
          bounds: const Rect.fromLTWH(100, 0, 70, 100), format: format2);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(100, 0, 70, 100));
      graphics.drawString('HelloWorld!!!Test - Word Wrap - word only', font,
          bounds: const Rect.fromLTWH(200, 0, 70, 100), format: format3);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(200, 0, 70, 100));
      graphics.drawString('HelloWorld!!!Test - Word Wrap - empty', font,
          bounds: const Rect.fromLTWH(300, 0, 70, 100), format: format4);
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(300, 0, 70, 100));
      graphics.drawString('HelloWorld!!!Test - Word Wrap - default', font,
          bounds: const Rect.fromLTWH(400, 0, 70, 100));
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(400, 0, 70, 100));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw string with Word wrap');
      savePdf(bytes, 'FLUT_492_PdfStringFormat_WordWrap.pdf');
      document.dispose();
    });
  });
  group('Drawing string with PdfCjkStandardFont', () {
    test(
        '안녕 세상 (hello world_korean) draw with hanyang Systems Gothic Medium font',
        () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont hGMedium1 =
          PdfCjkStandardFont(PdfCjkFontFamily.hanyangSystemsGothicMedium, 14);
      final PdfFont hGMedium2 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsGothicMedium, 14,
          style: PdfFontStyle.bold);
      final PdfFont hGMedium3 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsGothicMedium, 14,
          style: PdfFontStyle.italic);
      final PdfFont hGMedium4 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsGothicMedium, 14,
          style: PdfFontStyle.underline);
      final PdfFont hGMedium5 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsGothicMedium, 14,
          style: PdfFontStyle.strikethrough);
      final PdfFont hGMedium6 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsGothicMedium, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont hGMedium7 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsGothicMedium, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont hGMedium8 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsGothicMedium, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont hGMedium9 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsGothicMedium, 14,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont hGMedium10 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsGothicMedium, 14,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('안녕 세상', hGMedium1, bounds: Rect.zero);
      graphics.drawString('안녕 세상', hGMedium2,
          bounds: const Rect.fromLTWH(100, 0, 0, 0));
      graphics.drawString('안녕 세상', hGMedium3,
          bounds: const Rect.fromLTWH(200, 0, 0, 0));
      graphics.drawString('안녕 세상', hGMedium4,
          bounds: const Rect.fromLTWH(300, 0, 0, 0));
      graphics.drawString('안녕 세상', hGMedium5,
          bounds: const Rect.fromLTWH(400, 0, 0, 0));
      graphics.drawString('안녕 세상', hGMedium6,
          bounds: const Rect.fromLTWH(0, 100, 0, 0));
      graphics.drawString('안녕 세상', hGMedium7,
          bounds: const Rect.fromLTWH(100, 100, 0, 0));
      graphics.drawString('안녕 세상', hGMedium8,
          bounds: const Rect.fromLTWH(200, 100, 0, 0));
      graphics.drawString('안녕 세상', hGMedium9,
          bounds: const Rect.fromLTWH(300, 100, 0, 0));
      graphics.drawString('안녕 세상', hGMedium10,
          bounds: const Rect.fromLTWH(400, 100, 0, 0));
      const String text1 =
          '표준 글꼴 지원 표준 글꼴 지원 표준 글꼴 지원 표준 글꼴 지원 표준 글꼴 지원 표준 글꼴 지원';
      const String text2 = '표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원';
      graphics.drawString(text1, hGMedium1,
          bounds: const Rect.fromLTWH(0, 200, 500, 800));
      graphics.drawString(text1, hGMedium10,
          bounds: const Rect.fromLTWH(0, 300, 500, 800));
      graphics.drawString(text2, hGMedium1,
          bounds: const Rect.fromLTWH(0, 400, 500, 800));
      graphics.drawString(text2, hGMedium10,
          bounds: const Rect.fromLTWH(0, 500, 500, 800));
      final List<int> bytes = document.saveSync();
      savePdf(
          bytes, 'FLUT-550-PdfCjkStandardFontSupport_hanyangSGothicMedium.pdf');
      document.dispose();
    });
    test(
        '안녕 세상 (hello world_korean) draw with hanyang Systems Shin Myeong JoMedium font',
        () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont hMMedium1 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14);
      final PdfFont hMMedium2 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14,
          style: PdfFontStyle.bold);
      final PdfFont hMMedium3 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14,
          style: PdfFontStyle.italic);
      final PdfFont hMMedium4 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14,
          style: PdfFontStyle.underline);
      final PdfFont hMMedium5 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14,
          style: PdfFontStyle.strikethrough);
      final PdfFont hMMedium6 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont hMMedium7 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont hMMedium8 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont hMMedium9 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont hMMedium10 = PdfCjkStandardFont(
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('안녕 세상', hMMedium1, bounds: Rect.zero);
      graphics.drawString('안녕 세상', hMMedium2,
          bounds: const Rect.fromLTWH(100, 0, 0, 0));
      graphics.drawString('안녕 세상', hMMedium3,
          bounds: const Rect.fromLTWH(200, 0, 0, 0));
      graphics.drawString('안녕 세상', hMMedium4,
          bounds: const Rect.fromLTWH(300, 0, 0, 0));
      graphics.drawString('안녕 세상', hMMedium5,
          bounds: const Rect.fromLTWH(400, 0, 0, 0));
      graphics.drawString('안녕 세상', hMMedium6,
          bounds: const Rect.fromLTWH(0, 100, 0, 0));
      graphics.drawString('안녕 세상', hMMedium7,
          bounds: const Rect.fromLTWH(100, 100, 0, 0));
      graphics.drawString('안녕 세상', hMMedium8,
          bounds: const Rect.fromLTWH(200, 100, 0, 0));
      graphics.drawString('안녕 세상', hMMedium9,
          bounds: const Rect.fromLTWH(300, 100, 0, 0));
      graphics.drawString('안녕 세상', hMMedium10,
          bounds: const Rect.fromLTWH(400, 100, 0, 0));
      const String text1 =
          '표준 글꼴 지원 표준 글꼴 지원 표준 글꼴 지원 표준 글꼴 지원 표준 글꼴 지원 표준 글꼴 지원';
      const String text2 = '표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원';
      graphics.drawString(text1, hMMedium1,
          bounds: const Rect.fromLTWH(0, 200, 500, 800));
      graphics.drawString(text1, hMMedium10,
          bounds: const Rect.fromLTWH(0, 300, 500, 800));
      graphics.drawString(text2, hMMedium1,
          bounds: const Rect.fromLTWH(0, 400, 500, 800));
      graphics.drawString(text2, hMMedium10,
          bounds: const Rect.fromLTWH(0, 500, 500, 800));
      final List<int> bytes = document.saveSync();
      savePdf(bytes,
          'FLUT-550-PdfCjkStandardFontSupport_hanyangSSMyeongJoMedium.pdf');
      document.dispose();
    });
    test('こんにちは世界 (hello world_japanese) draw with heisei Kaku Gothic W5 font',
        () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont hKGothicW5_1 =
          PdfCjkStandardFont(PdfCjkFontFamily.heiseiKakuGothicW5, 14);
      final PdfFont hKGothicW5_2 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiKakuGothicW5, 14,
          style: PdfFontStyle.bold);
      final PdfFont hKGothicW5_3 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiKakuGothicW5, 14,
          style: PdfFontStyle.italic);
      final PdfFont hKGothicW5_4 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiKakuGothicW5, 14,
          style: PdfFontStyle.underline);
      final PdfFont hKGothicW5_5 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiKakuGothicW5, 14,
          style: PdfFontStyle.strikethrough);
      final PdfFont hKGothicW5_6 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiKakuGothicW5, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont hKGothicW5_7 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiKakuGothicW5, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont hKGothicW5_8 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiKakuGothicW5, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont hKGothicW5_9 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiKakuGothicW5, 14,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont hKGothicW5_10 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiKakuGothicW5, 14,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('こんにちは世界', hKGothicW5_1, bounds: Rect.zero);
      graphics.drawString('こんにちは世界', hKGothicW5_2,
          bounds: const Rect.fromLTWH(100, 0, 0, 0));
      graphics.drawString('こんにちは世界', hKGothicW5_3,
          bounds: const Rect.fromLTWH(200, 0, 0, 0));
      graphics.drawString('こんにちは世界', hKGothicW5_4,
          bounds: const Rect.fromLTWH(300, 0, 0, 0));
      graphics.drawString('こんにちは世界', hKGothicW5_5,
          bounds: const Rect.fromLTWH(400, 0, 0, 0));
      graphics.drawString('こんにちは世界', hKGothicW5_6,
          bounds: const Rect.fromLTWH(0, 100, 0, 0));
      graphics.drawString('こんにちは世界', hKGothicW5_7,
          bounds: const Rect.fromLTWH(100, 100, 0, 0));
      graphics.drawString('こんにちは世界', hKGothicW5_8,
          bounds: const Rect.fromLTWH(200, 100, 0, 0));
      graphics.drawString('こんにちは世界', hKGothicW5_9,
          bounds: const Rect.fromLTWH(300, 100, 0, 0));
      graphics.drawString('こんにちは世界', hKGothicW5_10,
          bounds: const Rect.fromLTWH(400, 100, 0, 0));
      const String text1 = '標準フォントのサポート 標準フォントのサポート 標準フォントのサポート 標準フォントのサポート';
      const String text2 = '標準フォントのサポート標準フォントのサポート標準フォントのサポート標準フォントのサポート';
      graphics.drawString(text1, hKGothicW5_1,
          bounds: const Rect.fromLTWH(0, 200, 500, 800));
      graphics.drawString(text1, hKGothicW5_10,
          bounds: const Rect.fromLTWH(0, 300, 500, 800));
      graphics.drawString(text2, hKGothicW5_1,
          bounds: const Rect.fromLTWH(0, 400, 500, 800));
      graphics.drawString(text2, hKGothicW5_10,
          bounds: const Rect.fromLTWH(0, 500, 500, 800));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-550-PdfCjkStandardFontSupport_hKakuGothicW5.pdf');
      document.dispose();
    });
    test('こんにちは世界 (hello world_japanese) draw with heisei Mincho W3 font', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont hMinchoW3_1 =
          PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 14);
      final PdfFont hMinchoW3_2 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiMinchoW3, 14,
          style: PdfFontStyle.bold);
      final PdfFont hMinchoW3_3 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiMinchoW3, 14,
          style: PdfFontStyle.italic);
      final PdfFont hMinchoW3_4 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiMinchoW3, 14,
          style: PdfFontStyle.underline);
      final PdfFont hMinchoW3_5 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiMinchoW3, 14,
          style: PdfFontStyle.strikethrough);
      final PdfFont hMinchoW3_6 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiMinchoW3, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont hMinchoW3_7 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiMinchoW3, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont hMinchoW3_8 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiMinchoW3, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont hMinchoW3_9 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiMinchoW3, 14,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont hMinchoW3_10 = PdfCjkStandardFont(
          PdfCjkFontFamily.heiseiMinchoW3, 14,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('こんにちは世界', hMinchoW3_1, bounds: Rect.zero);
      graphics.drawString('こんにちは世界', hMinchoW3_2,
          bounds: const Rect.fromLTWH(100, 0, 0, 0));
      graphics.drawString('こんにちは世界', hMinchoW3_3,
          bounds: const Rect.fromLTWH(200, 0, 0, 0));
      graphics.drawString('こんにちは世界', hMinchoW3_4,
          bounds: const Rect.fromLTWH(300, 0, 0, 0));
      graphics.drawString('こんにちは世界', hMinchoW3_5,
          bounds: const Rect.fromLTWH(400, 0, 0, 0));
      graphics.drawString('こんにちは世界', hMinchoW3_6,
          bounds: const Rect.fromLTWH(0, 100, 0, 0));
      graphics.drawString('こんにちは世界', hMinchoW3_7,
          bounds: const Rect.fromLTWH(100, 100, 0, 0));
      graphics.drawString('こんにちは世界', hMinchoW3_8,
          bounds: const Rect.fromLTWH(200, 100, 0, 0));
      graphics.drawString('こんにちは世界', hMinchoW3_9,
          bounds: const Rect.fromLTWH(300, 100, 0, 0));
      graphics.drawString('こんにちは世界', hMinchoW3_10,
          bounds: const Rect.fromLTWH(400, 100, 0, 0));
      const String text1 = '標準フォントのサポート 標準フォントのサポート 標準フォントのサポート 標準フォントのサポート';
      const String text2 = '標準フォントのサポート標準フォントのサポート標準フォントのサポート標準フォントのサポート';
      graphics.drawString(text1, hMinchoW3_1,
          bounds: const Rect.fromLTWH(0, 200, 500, 800));
      graphics.drawString(text1, hMinchoW3_10,
          bounds: const Rect.fromLTWH(0, 300, 500, 800));
      graphics.drawString(text2, hMinchoW3_1,
          bounds: const Rect.fromLTWH(0, 400, 500, 800));
      graphics.drawString(text2, hMinchoW3_10,
          bounds: const Rect.fromLTWH(0, 500, 500, 800));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-550-PdfCjkStandardFontSupport_hMinchoW3.pdf');
      document.dispose();
    });
    test('你好，世界 (hello world_chinese) draw with monotype Hei Medium font', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont mTHeiMedium1 =
          PdfCjkStandardFont(PdfCjkFontFamily.monotypeHeiMedium, 14);
      final PdfFont mTHeiMedium2 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeHeiMedium, 14,
          style: PdfFontStyle.bold);
      final PdfFont mTHeiMedium3 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeHeiMedium, 14,
          style: PdfFontStyle.italic);
      final PdfFont mTHeiMedium4 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeHeiMedium, 14,
          style: PdfFontStyle.underline);
      final PdfFont mTHeiMedium5 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeHeiMedium, 14,
          style: PdfFontStyle.strikethrough);
      final PdfFont mTHeiMedium6 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeHeiMedium, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont mTHeiMedium7 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeHeiMedium, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont mTHeiMedium8 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeHeiMedium, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont mTHeiMedium9 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeHeiMedium, 14,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont mTHeiMedium10 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeHeiMedium, 14,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('你好，世界', mTHeiMedium1, bounds: Rect.zero);
      graphics.drawString('你好，世界', mTHeiMedium2,
          bounds: const Rect.fromLTWH(100, 0, 0, 0));
      graphics.drawString('你好，世界', mTHeiMedium3,
          bounds: const Rect.fromLTWH(200, 0, 0, 0));
      graphics.drawString('你好，世界', mTHeiMedium4,
          bounds: const Rect.fromLTWH(300, 0, 0, 0));
      graphics.drawString('你好，世界', mTHeiMedium5,
          bounds: const Rect.fromLTWH(400, 0, 0, 0));
      graphics.drawString('你好，世界', mTHeiMedium6,
          bounds: const Rect.fromLTWH(0, 100, 0, 0));
      graphics.drawString('你好，世界', mTHeiMedium7,
          bounds: const Rect.fromLTWH(100, 100, 0, 0));
      graphics.drawString('你好，世界', mTHeiMedium8,
          bounds: const Rect.fromLTWH(200, 100, 0, 0));
      graphics.drawString('你好，世界', mTHeiMedium9,
          bounds: const Rect.fromLTWH(300, 100, 0, 0));
      graphics.drawString('你好，世界', mTHeiMedium10,
          bounds: const Rect.fromLTWH(400, 100, 0, 0));
      const String text1 = '標準字體支持 標準字體支持 標準字體支持 標準字體支持 標準字體支持 標準字體支持 標準字體支持';
      const String text2 = '標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持';
      graphics.drawString(text1, mTHeiMedium1,
          bounds: const Rect.fromLTWH(0, 200, 500, 800));
      graphics.drawString(text1, mTHeiMedium10,
          bounds: const Rect.fromLTWH(0, 300, 500, 800));
      graphics.drawString(text2, mTHeiMedium1,
          bounds: const Rect.fromLTWH(0, 400, 500, 800));
      graphics.drawString(text2, mTHeiMedium10,
          bounds: const Rect.fromLTWH(0, 500, 500, 800));
      final List<int> bytes = document.saveSync();
      savePdf(
          bytes, 'FLUT-550-PdfCjkStandardFontSupport_monotypeHeiMedium.pdf');
      document.dispose();
    });
    test('你好，世界 (hello world_chinese) draw with mono type Sung Light font', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont mTSungLight1 =
          PdfCjkStandardFont(PdfCjkFontFamily.monotypeSungLight, 14);
      final PdfFont mTSungLight2 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeSungLight, 14,
          style: PdfFontStyle.bold);
      final PdfFont mTSungLight3 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeSungLight, 14,
          style: PdfFontStyle.italic);
      final PdfFont mTSungLight4 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeSungLight, 14,
          style: PdfFontStyle.underline);
      final PdfFont mTSungLight5 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeSungLight, 14,
          style: PdfFontStyle.strikethrough);
      final PdfFont mTSungLight6 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeSungLight, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont mTSungLight7 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeSungLight, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont mTSungLight8 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeSungLight, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont mTSungLight9 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeSungLight, 14,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont mTSungLight10 = PdfCjkStandardFont(
          PdfCjkFontFamily.monotypeSungLight, 14,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('你好，世界', mTSungLight1, bounds: Rect.zero);
      graphics.drawString('你好，世界', mTSungLight2,
          bounds: const Rect.fromLTWH(100, 0, 0, 0));
      graphics.drawString('你好，世界', mTSungLight3,
          bounds: const Rect.fromLTWH(200, 0, 0, 0));
      graphics.drawString('你好，世界', mTSungLight4,
          bounds: const Rect.fromLTWH(300, 0, 0, 0));
      graphics.drawString('你好，世界', mTSungLight5,
          bounds: const Rect.fromLTWH(400, 0, 0, 0));
      graphics.drawString('你好，世界', mTSungLight6,
          bounds: const Rect.fromLTWH(0, 100, 0, 0));
      graphics.drawString('你好，世界', mTSungLight7,
          bounds: const Rect.fromLTWH(100, 100, 0, 0));
      graphics.drawString('你好，世界', mTSungLight8,
          bounds: const Rect.fromLTWH(200, 100, 0, 0));
      graphics.drawString('你好，世界', mTSungLight9,
          bounds: const Rect.fromLTWH(300, 100, 0, 0));
      graphics.drawString('你好，世界', mTSungLight10,
          bounds: const Rect.fromLTWH(400, 100, 0, 0));
      const String text1 = '標準字體支持 標準字體支持 標準字體支持 標準字體支持 標準字體支持 標準字體支持 標準字體支持';
      const String text2 = '標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持';
      graphics.drawString(text1, mTSungLight1,
          bounds: const Rect.fromLTWH(0, 200, 500, 800));
      graphics.drawString(text1, mTSungLight10,
          bounds: const Rect.fromLTWH(0, 300, 500, 800));
      graphics.drawString(text2, mTSungLight1,
          bounds: const Rect.fromLTWH(0, 400, 500, 800));
      graphics.drawString(text2, mTSungLight10,
          bounds: const Rect.fromLTWH(0, 500, 500, 800));
      final List<int> bytes = document.saveSync();
      savePdf(
          bytes, 'FLUT-550-PdfCjkStandardFontSupport_monotypeSungLight.pdf');
      document.dispose();
    });
    test('你好，世界 (hello world_chinese) draw with sino Type Song Light font', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont sTSongLight1 =
          PdfCjkStandardFont(PdfCjkFontFamily.sinoTypeSongLight, 14);
      final PdfFont sTSongLight2 = PdfCjkStandardFont(
          PdfCjkFontFamily.sinoTypeSongLight, 14,
          style: PdfFontStyle.bold);
      final PdfFont sTSongLight3 = PdfCjkStandardFont(
          PdfCjkFontFamily.sinoTypeSongLight, 14,
          style: PdfFontStyle.italic);
      final PdfFont sTSongLight4 = PdfCjkStandardFont(
          PdfCjkFontFamily.sinoTypeSongLight, 14,
          style: PdfFontStyle.underline);
      final PdfFont sTSongLight5 = PdfCjkStandardFont(
          PdfCjkFontFamily.sinoTypeSongLight, 14,
          style: PdfFontStyle.strikethrough);
      final PdfFont sTSongLight6 = PdfCjkStandardFont(
          PdfCjkFontFamily.sinoTypeSongLight, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic]);
      final PdfFont sTSongLight7 = PdfCjkStandardFont(
          PdfCjkFontFamily.sinoTypeSongLight, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline
          ]);
      final PdfFont sTSongLight8 = PdfCjkStandardFont(
          PdfCjkFontFamily.sinoTypeSongLight, 14,
          style: PdfFontStyle.bold,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont sTSongLight9 = PdfCjkStandardFont(
          PdfCjkFontFamily.sinoTypeSongLight, 14,
          style: PdfFontStyle.regular,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfFont sTSongLight10 = PdfCjkStandardFont(
          PdfCjkFontFamily.sinoTypeSongLight, 14,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.underline,
            PdfFontStyle.strikethrough
          ]);
      final PdfGraphics graphics = page.graphics;
      graphics.drawString('你好，世界', sTSongLight1, bounds: Rect.zero);
      graphics.drawString('你好，世界', sTSongLight2,
          bounds: const Rect.fromLTWH(100, 0, 0, 0));
      graphics.drawString('你好，世界', sTSongLight3,
          bounds: const Rect.fromLTWH(200, 0, 0, 0));
      graphics.drawString('你好，世界', sTSongLight4,
          bounds: const Rect.fromLTWH(300, 0, 0, 0));
      graphics.drawString('你好，世界', sTSongLight5,
          bounds: const Rect.fromLTWH(400, 0, 0, 0));
      graphics.drawString('你好，世界', sTSongLight6,
          bounds: const Rect.fromLTWH(0, 100, 0, 0));
      graphics.drawString('你好，世界', sTSongLight7,
          bounds: const Rect.fromLTWH(100, 100, 0, 0));
      graphics.drawString('你好，世界', sTSongLight8,
          bounds: const Rect.fromLTWH(200, 100, 0, 0));
      graphics.drawString('你好，世界', sTSongLight9,
          bounds: const Rect.fromLTWH(300, 100, 0, 0));
      graphics.drawString('你好，世界', sTSongLight10,
          bounds: const Rect.fromLTWH(400, 100, 0, 0));
      const String text1 = '標準字體支持 標準字體支持 標準字體支持 標準字體支持 標準字體支持 標準字體支持 標準字體支持';
      const String text2 = '標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持';
      graphics.drawString(text1, sTSongLight1,
          bounds: const Rect.fromLTWH(0, 200, 500, 800));
      graphics.drawString(text1, sTSongLight10,
          bounds: const Rect.fromLTWH(0, 300, 500, 800));
      graphics.drawString(text2, sTSongLight1,
          bounds: const Rect.fromLTWH(0, 400, 500, 800));
      graphics.drawString(text2, sTSongLight10,
          bounds: const Rect.fromLTWH(0, 500, 500, 800));
      final List<int> bytes = document.saveSync();
      savePdf(
          bytes, 'FLUT-550-PdfCjkStandardFontSupport_sinoTypeSongLight.pdf');
      document.dispose();
    });
  });
  test('Cjk Standard font differences', () {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
    const String text1 = '표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원표준 글꼴 지원';
    const String text2 = '標準フォントのサポート標準フォントのサポート標準フォントのサポート標準フォントのサポート';
    const String text3 = '標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持標準字體支持';
    final PdfGraphics graphics = page.graphics;
    graphics.drawString('hanyang Systems Gothic Medium:', font,
        bounds: Rect.zero);
    graphics.drawString(text1,
        PdfCjkStandardFont(PdfCjkFontFamily.hanyangSystemsGothicMedium, 14),
        bounds: const Rect.fromLTWH(0, 50, 500, 800));
    graphics.drawString('hanyang Systems Shin Myeong Jo Medium:', font,
        bounds: const Rect.fromLTWH(0, 100, 0, 0));
    graphics.drawString(
        text1,
        PdfCjkStandardFont(
            PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 14),
        bounds: const Rect.fromLTWH(0, 150, 500, 800));
    graphics.drawString('heisei Kaku Gothic W5:', font,
        bounds: const Rect.fromLTWH(0, 200, 0, 0));
    graphics.drawString(
        text2, PdfCjkStandardFont(PdfCjkFontFamily.heiseiKakuGothicW5, 14),
        bounds: const Rect.fromLTWH(0, 250, 500, 800));
    graphics.drawString('heisei Mincho W3:', font,
        bounds: const Rect.fromLTWH(0, 300, 0, 0));
    graphics.drawString(
        text2, PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 14),
        bounds: const Rect.fromLTWH(0, 350, 500, 800));
    graphics.drawString('monotype Hei Medium:', font,
        bounds: const Rect.fromLTWH(0, 400, 0, 0));
    graphics.drawString(
        text3, PdfCjkStandardFont(PdfCjkFontFamily.monotypeHeiMedium, 14),
        bounds: const Rect.fromLTWH(0, 450, 500, 800));
    graphics.drawString('mono type Sung Light:', font,
        bounds: const Rect.fromLTWH(0, 500, 0, 0));
    graphics.drawString(
        text3, PdfCjkStandardFont(PdfCjkFontFamily.monotypeSungLight, 14),
        bounds: const Rect.fromLTWH(0, 550, 500, 800));
    graphics.drawString('sino Type Song Light:', font,
        bounds: const Rect.fromLTWH(0, 600, 0, 0));
    graphics.drawString(
        text3, PdfCjkStandardFont(PdfCjkFontFamily.sinoTypeSongLight, 14),
        bounds: const Rect.fromLTWH(0, 650, 500, 800));
    final List<int> bytes = document.saveSync();
    savePdf(bytes, 'FLUT-550-PdfCjkStandardFontSupport_AllFontDifferences.pdf');
    document.dispose();
  });
  test('Cjk Prototype font', () {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfGraphics graphics = page.graphics;
    final PdfCjkStandardFont font1 = PdfCjkStandardFont.protoType(
        PdfCjkStandardFont(PdfCjkFontFamily.hanyangSystemsGothicMedium, 14), 14,
        style: PdfFontStyle.bold);
    final PdfCjkStandardFont font2 = PdfCjkStandardFont.protoType(
        PdfCjkStandardFont(PdfCjkFontFamily.heiseiKakuGothicW5, 14,
            style: PdfFontStyle.underline),
        16,
        multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
    final PdfCjkStandardFont font3 = PdfCjkStandardFont.protoType(
        PdfCjkStandardFont(PdfCjkFontFamily.monotypeHeiMedium, 14), 20,
        multiStyle: <PdfFontStyle>[
          PdfFontStyle.bold,
          PdfFontStyle.italic,
          PdfFontStyle.strikethrough,
          PdfFontStyle.underline
        ]);
    graphics.drawString('안녕 세상', font1, bounds: Rect.zero);
    graphics.drawString('こんにちは世界', font2,
        bounds: const Rect.fromLTWH(0, 100, 0, 0));
    graphics.drawString('你好，世界', font3,
        bounds: const Rect.fromLTWH(0, 200, 0, 0));
    final List<int> bytes = document.saveSync();
    savePdf(bytes, 'FLUT-550-PdfCjkStandardFontSupport_protoTypeFont.pdf');
    document.dispose();
  });
}

// ignore: public_member_api_docs
void drawShapeSupport() {
  group('Drawing rectangle in PDF graphics', () {
    test('drawRectangle() overloads', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfBrush redBrush = PdfSolidBrush(PdfColor(255, 0, 0));
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(10, 10, 50, 20));
      graphics.drawRectangle(
          brush: redBrush, bounds: const Rect.fromLTWH(100, 10, 50, 20));
      graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(10, 40, 50, 20));
      graphics.drawRectangle(
          brush: redBrush, bounds: const Rect.fromLTWH(100, 40, 50, 20));
      graphics.drawRectangle(
          pen: greenPen,
          brush: redBrush,
          bounds: const Rect.fromLTWH(10, 70, 50, 20));
      graphics.drawRectangle(
          pen: greenPen,
          brush: redBrush,
          bounds: const Rect.fromLTWH(100, 70, 50, 20));
      graphics.drawRectangle(bounds: const Rect.fromLTWH(10, 100, 50, 20));
      graphics.drawRectangle(bounds: const Rect.fromLTWH(100, 100, 50, 20));
      graphics.drawRectangle(bounds: const Rect.fromLTWH(100, 130, 50, 20));
      graphics.drawRectangle(
          pen: greenPen,
          brush: redBrush,
          bounds: const Rect.fromLTWH(100, 160, 50, 20));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw rectangle in PDF graphics');
      savePdf(bytes, 'FLUT_492_ShapeRectangle.pdf');
      document.dispose();
    });
  });
  group('Draw line', () {
    test('draw line with pen', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      PdfPen pen = PdfPen(PdfColor(255, 0, 0));
      page.graphics.drawLine(pen, Offset.zero, const Offset(300, 0));
      pen = PdfPen(PdfColor(0, 255, 0));
      page.graphics.drawLine(pen, Offset.zero, const Offset(0, 300));
      pen = PdfPen(PdfColor(0, 0, 255), width: 2);
      page.graphics.drawLine(pen, Offset.zero, const Offset(300, 300));
      pen = PdfPen(PdfColor(0, 255, 255));
      page.graphics.drawLine(pen, const Offset(0, 300), const Offset(300, 300));
      pen = PdfPen(PdfColor(255, 255, 0));
      page.graphics.drawLine(pen, const Offset(300, 0), const Offset(300, 300));
      pen = PdfPen(PdfColor.fromCMYK(100, 20, 200, 10));
      page.graphics.drawLine(pen, const Offset(300, 0), const Offset(0, 300));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed');
      savePdf(bytes, 'DrawLine.pdf');
      document.dispose();
    });
  });
  group('Draw template', () {
    test('constructor overloads', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(255, 0, 0));
      final PdfTemplate template1 = PdfTemplate(200, 100);
      template1.graphics!.drawRectangle(
          brush: brush, bounds: const Rect.fromLTWH(0, 20, 200, 50));
      template1.graphics!.drawString('This is PDF template.', font);
      final PdfTemplate template2 = PdfTemplate(200, 100);
      template2.graphics!.drawRectangle(
          brush: brush, bounds: const Rect.fromLTWH(0, 20, 200, 50));
      template2.graphics!.drawString('This is PDF template.', font);
      page.graphics.drawPdfTemplate(template1, const Offset(100, 100));
      page.graphics.drawPdfTemplate(
          template2, const Offset(100, 300), const Size(150, 50));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed');
      savePdf(bytes, 'DrawTemplate1.pdf');
      document.dispose();
    });
    test('graphics accessability', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(255, 0, 0));

      //Accessing templates graphics first
      final PdfTemplate template1 = PdfTemplate(200, 100);
      template1.graphics!.drawRectangle(
          brush: brush, bounds: const Rect.fromLTWH(0, 20, 200, 50));
      template1.graphics!.drawString('This is PDF template.', font);
      //Accessing page graphics
      page1.graphics.drawPdfTemplate(template1, const Offset(100, 100));
      //Accessing templates graphics
      final PdfTemplate template2 = PdfTemplate(200, 100);
      template2.graphics!.drawRectangle(
          brush: brush, bounds: const Rect.fromLTWH(0, 20, 200, 50));
      template2.graphics!.drawString('This is PDF template.', font);
      //Accessing page graphics
      page1.graphics.drawPdfTemplate(
          template2, const Offset(100, 300), const Size(150, 50));

      //Accessing page graphics first
      final PdfGraphics pageGraphics = page2.graphics;
      final PdfTemplate template3 = PdfTemplate(200, 100);
      //Accessing templates graphics
      template3.graphics!.drawRectangle(
          brush: brush, bounds: const Rect.fromLTWH(0, 20, 200, 50));
      template3.graphics!.drawString('This is PDF template.', font);
      pageGraphics.drawPdfTemplate(template1, const Offset(100, 100));
      //Accessing templates graphics
      final PdfTemplate template4 = PdfTemplate(200, 100);
      template4.graphics!.drawRectangle(
          brush: brush, bounds: const Rect.fromLTWH(0, 20, 200, 50));
      template4.graphics!.drawString('This is PDF template.', font);
      //Accessing page graphics
      pageGraphics.drawPdfTemplate(
          template2, const Offset(100, 300), const Size(150, 50));

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed');
      savePdf(bytes, 'DrawTemplate2.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
void drawTextElement() {
  group('PdfTextElement', () {
    test('Text drawing', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfBrush redBrush = PdfSolidBrush(PdfColor(255, 0, 0));
      final PdfStringFormat format =
          PdfStringFormat(alignment: PdfTextAlignment.center);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitPage,
          paginateBounds: Rect.zero);

      final PdfTextElement element1 = PdfTextElement();
      element1.text = 'Hello World!!!';
      element1.font = font;
      element1.draw(graphics: page.graphics);

      final PdfTextElement element2 = PdfTextElement();
      element2.text = 'Hello World!!!';
      element2.font = font;
      element2.pen = greenPen;
      element2.brush = redBrush;
      element2.stringFormat = format;
      element2.draw(
          graphics: page.graphics, bounds: const Rect.fromLTWH(200, 0, 0, 0));

      final PdfTextElement element3 = PdfTextElement(
          text: 'Hello World',
          brush: redBrush,
          pen: greenPen,
          font: font,
          format: format);
      element3.draw(
          page: page,
          bounds: const Rect.fromLTWH(0, 50, 200, 20),
          format: PdfLayoutFormat.fromFormat(layoutFormat));
      page.graphics.drawRectangle(
          pen: greenPen, bounds: const Rect.fromLTWH(0, 50, 200, 20));

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw text using PDF text element');
      savePdf(bytes, 'FLUT_492_TextElement1.pdf');
      document.dispose();
    });
    test('page break type', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfBrush redBrush = PdfSolidBrush(PdfColor(255, 0, 0));
      final PdfStringFormat format =
          PdfStringFormat(alignment: PdfTextAlignment.center);
      final PdfLayoutFormat layoutFormat1 = PdfLayoutFormat();
      layoutFormat1.layoutType = PdfLayoutType.paginate;
      final PdfLayoutFormat layoutFormat2 = PdfLayoutFormat();
      layoutFormat2.layoutType = PdfLayoutType.onePage;

      final PdfTextElement element1 = PdfTextElement(
          text:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          brush: redBrush,
          pen: greenPen,
          font: font,
          format: format);
      final PdfLayoutResult? result = element1.draw(
          page: page,
          bounds: const Rect.fromLTWH(0, 500, 200, 500),
          format: layoutFormat1);
      final PdfTextElement element2 = PdfTextElement(
          text:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          brush: redBrush,
          pen: greenPen,
          font: font,
          format: format);
      element2.draw(
          page: result!.page,
          bounds: const Rect.fromLTWH(0, 500, 200, 500),
          format: layoutFormat2);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'Failed to draw text by PDF text element with layout break type');
      savePdf(bytes, 'FLUT_492_TextElement2.pdf');
      document.dispose();
    });
    test('Event handler', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
      final PdfPen greenPen = PdfPen(PdfColor(0, 255, 0));
      final PdfBrush redBrush = PdfSolidBrush(PdfColor(255, 0, 0));
      final PdfStringFormat format =
          PdfStringFormat(alignment: PdfTextAlignment.center);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat();

      final PdfTextElement element = PdfTextElement(
          text:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          brush: redBrush,
          pen: greenPen,
          font: font,
          format: format);

      element.beginPageLayout = (Object sender, BeginPageLayoutArgs args) {
        args.page.graphics.drawRectangle(
            pen: PdfPen(PdfColor(0, 0, 0)),
            bounds: const Rect.fromLTWH(10, 10, 100, 50));
      };
      element.endPageLayout = (Object sender, EndPageLayoutArgs args) {
        final EndTextPageLayoutArgs textArgs = args as EndTextPageLayoutArgs;
        final PdfTextLayoutResult tlr = textArgs.result as PdfTextLayoutResult;
        textArgs.nextPage = tlr.page;
      };
      element.draw(
          page: page,
          bounds: const Rect.fromLTWH(0, 500, 200, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw text by PDF text element with events');
      savePdf(bytes, 'FLUT_492_TextElement3.pdf');
      document.dispose();
    });
    test('Graphics overload behavior changes', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfTextElement element = PdfTextElement();
      element.text =
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
      element.font = PdfStandardFont(PdfFontFamily.helvetica, 20);
      element.brush = PdfBrushes.red;
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.layoutType = PdfLayoutType.paginate;
      format.breakType = PdfLayoutBreakType.fitElement;
      element.draw(
          graphics: page.graphics,
          format: format,
          bounds: const Rect.fromLTWH(0, 0, 200, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'Failed to draw text element with graphics and Rect.fromLTWH(0, 0, 200, 0) overload');
      savePdf(bytes, 'FLUT_492_TextElement4.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
void colorWithOpacity() {
  group('Color and opacity', () {
    test('ARGB test', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      final PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
      final PdfColor color1 = PdfColor(255, 0, 0);
      final PdfColor color2 = PdfColor(255, 0, 0, 200);
      final PdfColor color3 = PdfColor(255, 0, 0, 100);
      final PdfColor color4 = PdfColor(255, 0, 0, 0);
      final PdfColor color5 = PdfColor(255, 0, 0);

      graphics.drawRectangle(
          pen: PdfPen(color1), bounds: const Rect.fromLTWH(0, 0, 40, 15));
      graphics.drawRectangle(
          pen: PdfPen(color2), bounds: const Rect.fromLTWH(50, 0, 40, 15));
      graphics.drawRectangle(
          pen: PdfPen(color3), bounds: const Rect.fromLTWH(100, 0, 40, 15));
      graphics.drawRectangle(
          pen: PdfPen(color4), bounds: const Rect.fromLTWH(150, 0, 40, 15));
      graphics.drawRectangle(
          pen: PdfPen(color5), bounds: const Rect.fromLTWH(200, 0, 40, 15));

      graphics.drawRectangle(
          brush: PdfSolidBrush(color1),
          bounds: const Rect.fromLTWH(0, 20, 40, 15));
      graphics.drawRectangle(
          brush: PdfSolidBrush(color2),
          bounds: const Rect.fromLTWH(50, 20, 40, 15));
      graphics.drawRectangle(
          brush: PdfSolidBrush(color3),
          bounds: const Rect.fromLTWH(100, 20, 40, 15));
      graphics.drawRectangle(
          brush: PdfSolidBrush(color4),
          bounds: const Rect.fromLTWH(150, 20, 40, 15));
      graphics.drawRectangle(
          brush: PdfSolidBrush(color5),
          bounds: const Rect.fromLTWH(200, 20, 40, 15));

      graphics.drawString('hello world', font,
          brush: PdfSolidBrush(color1),
          bounds: const Rect.fromLTWH(0, 40, 0, 0));
      graphics.drawString('hello world', font,
          brush: PdfSolidBrush(color2),
          bounds: const Rect.fromLTWH(0, 60, 0, 0));
      graphics.drawString('hello world', font,
          brush: PdfSolidBrush(color3),
          bounds: const Rect.fromLTWH(0, 80, 0, 0));
      graphics.drawString('hello world', font,
          brush: PdfSolidBrush(color4),
          bounds: const Rect.fromLTWH(0, 100, 0, 0));
      graphics.drawString('hello world', font,
          brush: PdfSolidBrush(color5),
          bounds: const Rect.fromLTWH(0, 120, 0, 0));

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve opacity value for the color');
      savePdf(bytes, 'FLUT_492_ColorWithOpacity.pdf');
      document.dispose();
    });
  });
  group('PDF graphics', () {
    test('Rotation', () {
      //Creates a new PDF document.
      final PdfDocument doc = PdfDocument();
      //Adds a page to the PDF document.
      final PdfPage page = doc.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
      //Set rotate transform
      page.graphics.rotateTransform(-90);
      //Draws the text into PDF graphics in 90 rotation.
      page.graphics.drawString('Hello world.', font,
          bounds: const Rect.fromLTWH(-100, 0, 200, 50));
      page.graphics.rotateTransform(-90);
      //Draws the text into PDF graphics in 180 rotation..
      page.graphics.drawString('Hello world.', font,
          bounds: const Rect.fromLTWH(-200, -100, 200, 50));
      //Saves the document.
      final List<int> bytes = doc.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve graphics rotation');
      savePdf(bytes, 'TextRotation.pdf');
      doc.dispose();
    });
  });
}

// ignore: public_member_api_docs
void pdfTransparency() {
  group('PDF Transparency', () {
    test('Image', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      page.graphics.setTransparency(0.5, alphaBrush: 0.5);
      page.graphics.drawImage(PdfBitmap.fromBase64String(logoJpeg),
          const Rect.fromLTWH(10, 10, 40, 25));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve PDF Transparency');
      savePdf(bytes, 'Image_transparency.pdf');
      document.dispose();
    });
    test('Text', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
      page.graphics.setTransparency(0.5);
      page.graphics.drawString('This is PDF Transparency.', font);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve PDF Transparency');
      savePdf(bytes, 'Text_transparency.pdf');
      document.dispose();
    });
    test('Template', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      page.graphics
          .setTransparency(0.5, alphaBrush: 0.5, mode: PdfBlendMode.multiply);
      final PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
      final PdfBrush brush = PdfSolidBrush(PdfColor(255, 0, 0));
      //Create a PDF Template.
      final PdfTemplate template = PdfTemplate(200, 100);
      final PdfImage image = PdfBitmap.fromBase64String(logoJpeg);
      template.graphics!.drawImage(image, const Rect.fromLTWH(0, 0, 200, 100));
      //Draws a rectangle into the graphics of the template.
      template.graphics!.drawRectangle(
          brush: brush, bounds: const Rect.fromLTWH(0, 20, 200, 50));
      //Draws a string into the graphics of the template.
      template.graphics!.drawString('This is PDF template.', font);
      //Draws the template into the page graphics of the document.
      page.graphics.drawPdfTemplate(template, const Offset(100, 100));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve PDF Transparency');
      savePdf(bytes, 'TransparencyWithTemplate.pdf');
      document.dispose();
    });
  });
  group('PdfStringFormat issue fixes', () {
    test('paragraph indent preservation', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
      final PdfStringFormat format = PdfStringFormat();
      format.paragraphIndent = 20;
      page.graphics.drawString(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          font,
          bounds: const Rect.fromLTWH(100, 100, 300, 400),
          format: format);
      page.graphics.drawRectangle(
          pen: PdfPens.blue, bounds: const Rect.fromLTWH(100, 100, 300, 400));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed');
      savePdf(bytes, 'FLUT_554_ParagraphIndent.pdf');
      document.dispose();
    });
  });
  group('FLUT-3727 Exception when adding watermarks to the PDF document', () {
    test('test', () {
      final PdfDocument document = PdfDocument.fromBase64String(
          'JVBERi0xLjMNCiXi48/TDQoNCjEgMCBvYmoNCjw8DQovVHlwZSAvQ2F0YWxvZw0KL091dGxpbmVzIDIgMCBSDQovUGFnZXMgMyAwIFINCj4+DQplbmRvYmoNCg0KMiAwIG9iag0KPDwNCi9UeXBlIC9PdXRsaW5lcw0KL0NvdW50IDANCj4+DQplbmRvYmoNCg0KMyAwIG9iag0KPDwNCi9UeXBlIC9QYWdlcw0KL0NvdW50IDINCi9LaWRzIFsgNCAwIFIgNiAwIFIgXSANCj4+DQplbmRvYmoNCg0KNCAwIG9iag0KPDwNCi9UeXBlIC9QYWdlDQovUGFyZW50IDMgMCBSDQovUmVzb3VyY2VzIDw8DQovRm9udCA8PA0KL0YxIDkgMCBSIA0KPj4NCi9Qcm9jU2V0IDggMCBSDQo+Pg0KL01lZGlhQm94IFswIDAgNjEyLjAwMDAgNzkyLjAwMDBdDQovQ29udGVudHMgNSAwIFINCj4+DQplbmRvYmoNCg0KNSAwIG9iag0KPDwgL0xlbmd0aCAxMDc0ID4+DQpzdHJlYW0NCjIgSg0KQlQNCjAgMCAwIHJnDQovRjEgMDAyNyBUZg0KNTcuMzc1MCA3MjIuMjgwMCBUZA0KKCBBIFNpbXBsZSBQREYgRmlsZSApIFRqDQpFVA0KQlQNCi9GMSAwMDEwIFRmDQo2OS4yNTAwIDY4OC42MDgwIFRkDQooIFRoaXMgaXMgYSBzbWFsbCBkZW1vbnN0cmF0aW9uIC5wZGYgZmlsZSAtICkgVGoNCkVUDQpCVA0KL0YxIDAwMTAgVGYNCjY5LjI1MDAgNjY0LjcwNDAgVGQNCigganVzdCBmb3IgdXNlIGluIHRoZSBWaXJ0dWFsIE1lY2hhbmljcyB0dXRvcmlhbHMuIE1vcmUgdGV4dC4gQW5kIG1vcmUgKSBUag0KRVQNCkJUDQovRjEgMDAxMCBUZg0KNjkuMjUwMCA2NTIuNzUyMCBUZA0KKCB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiApIFRqDQpFVA0KQlQNCi9GMSAwMDEwIFRmDQo2OS4yNTAwIDYyOC44NDgwIFRkDQooIEFuZCBtb3JlIHRleHQuIEFuZCBtb3JlIHRleHQuIEFuZCBtb3JlIHRleHQuIEFuZCBtb3JlIHRleHQuIEFuZCBtb3JlICkgVGoNCkVUDQpCVA0KL0YxIDAwMTAgVGYNCjY5LjI1MDAgNjE2Ljg5NjAgVGQNCiggdGV4dC4gQW5kIG1vcmUgdGV4dC4gQm9yaW5nLCB6enp6ei4gQW5kIG1vcmUgdGV4dC4gQW5kIG1vcmUgdGV4dC4gQW5kICkgVGoNCkVUDQpCVA0KL0YxIDAwMTAgVGYNCjY5LjI1MDAgNjA0Ljk0NDAgVGQNCiggbW9yZSB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiApIFRqDQpFVA0KQlQNCi9GMSAwMDEwIFRmDQo2OS4yNTAwIDU5Mi45OTIwIFRkDQooIEFuZCBtb3JlIHRleHQuIEFuZCBtb3JlIHRleHQuICkgVGoNCkVUDQpCVA0KL0YxIDAwMTAgVGYNCjY5LjI1MDAgNTY5LjA4ODAgVGQNCiggQW5kIG1vcmUgdGV4dC4gQW5kIG1vcmUgdGV4dC4gQW5kIG1vcmUgdGV4dC4gQW5kIG1vcmUgdGV4dC4gQW5kIG1vcmUgKSBUag0KRVQNCkJUDQovRjEgMDAxMCBUZg0KNjkuMjUwMCA1NTcuMTM2MCBUZA0KKCB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiBFdmVuIG1vcmUuIENvbnRpbnVlZCBvbiBwYWdlIDIgLi4uKSBUag0KRVQNCmVuZHN0cmVhbQ0KZW5kb2JqDQoNCjYgMCBvYmoNCjw8DQovVHlwZSAvUGFnZQ0KL1BhcmVudCAzIDAgUg0KL1Jlc291cmNlcyA8PA0KL0ZvbnQgPDwNCi9GMSA5IDAgUiANCj4+DQovUHJvY1NldCA4IDAgUg0KPj4NCi9NZWRpYUJveCBbMCAwIDYxMi4wMDAwIDc5Mi4wMDAwXQ0KL0NvbnRlbnRzIDcgMCBSDQo+Pg0KZW5kb2JqDQoNCjcgMCBvYmoNCjw8IC9MZW5ndGggNjc2ID4+DQpzdHJlYW0NCjIgSg0KQlQNCjAgMCAwIHJnDQovRjEgMDAyNyBUZg0KNTcuMzc1MCA3MjIuMjgwMCBUZA0KKCBTaW1wbGUgUERGIEZpbGUgMiApIFRqDQpFVA0KQlQNCi9GMSAwMDEwIFRmDQo2OS4yNTAwIDY4OC42MDgwIFRkDQooIC4uLmNvbnRpbnVlZCBmcm9tIHBhZ2UgMS4gWWV0IG1vcmUgdGV4dC4gQW5kIG1vcmUgdGV4dC4gQW5kIG1vcmUgdGV4dC4gKSBUag0KRVQNCkJUDQovRjEgMDAxMCBUZg0KNjkuMjUwMCA2NzYuNjU2MCBUZA0KKCBBbmQgbW9yZSB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiBBbmQgbW9yZSB0ZXh0LiBBbmQgbW9yZSApIFRqDQpFVA0KQlQNCi9GMSAwMDEwIFRmDQo2OS4yNTAwIDY2NC43MDQwIFRkDQooIHRleHQuIE9oLCBob3cgYm9yaW5nIHR5cGluZyB0aGlzIHN0dWZmLiBCdXQgbm90IGFzIGJvcmluZyBhcyB3YXRjaGluZyApIFRqDQpFVA0KQlQNCi9GMSAwMDEwIFRmDQo2OS4yNTAwIDY1Mi43NTIwIFRkDQooIHBhaW50IGRyeS4gQW5kIG1vcmUgdGV4dC4gQW5kIG1vcmUgdGV4dC4gQW5kIG1vcmUgdGV4dC4gQW5kIG1vcmUgdGV4dC4gKSBUag0KRVQNCkJUDQovRjEgMDAxMCBUZg0KNjkuMjUwMCA2NDAuODAwMCBUZA0KKCBCb3JpbmcuICBNb3JlLCBhIGxpdHRsZSBtb3JlIHRleHQuIFRoZSBlbmQsIGFuZCBqdXN0IGFzIHdlbGwuICkgVGoNCkVUDQplbmRzdHJlYW0NCmVuZG9iag0KDQo4IDAgb2JqDQpbL1BERiAvVGV4dF0NCmVuZG9iag0KDQo5IDAgb2JqDQo8PA0KL1R5cGUgL0ZvbnQNCi9TdWJ0eXBlIC9UeXBlMQ0KL05hbWUgL0YxDQovQmFzZUZvbnQgL0hlbHZldGljYQ0KL0VuY29kaW5nIC9XaW5BbnNpRW5jb2RpbmcNCj4+DQplbmRvYmoNCg0KMTAgMCBvYmoNCjw8DQovQ3JlYXRvciAoUmF2ZSBcKGh0dHA6Ly93d3cubmV2cm9uYS5jb20vcmF2ZVwpKQ0KL1Byb2R1Y2VyIChOZXZyb25hIERlc2lnbnMpDQovQ3JlYXRpb25EYXRlIChEOjIwMDYwMzAxMDcyODI2KQ0KPj4NCmVuZG9iag0KDQp4cmVmDQowIDExDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMTkgMDAwMDAgbg0KMDAwMDAwMDA5MyAwMDAwMCBuDQowMDAwMDAwMTQ3IDAwMDAwIG4NCjAwMDAwMDAyMjIgMDAwMDAgbg0KMDAwMDAwMDM5MCAwMDAwMCBuDQowMDAwMDAxNTIyIDAwMDAwIG4NCjAwMDAwMDE2OTAgMDAwMDAgbg0KMDAwMDAwMjQyMyAwMDAwMCBuDQowMDAwMDAyNDU2IDAwMDAwIG4NCjAwMDAwMDI1NzQgMDAwMDAgbg0KDQp0cmFpbGVyDQo8PA0KL1NpemUgMTENCi9Sb290IDEgMCBSDQovSW5mbyAxMCAwIFINCj4+DQoNCnN0YXJ0eHJlZg0KMjcxNA0KJSVFT0YNCg==');
      final PdfPageCollection collection = document.pages;
      for (int i = 0; i < collection.count; i++) {
        final PdfPage page = collection[i];
        final PdfGraphics graphics = page.graphics;
        graphics.save();
        graphics.setTransparency(0.25);
        graphics.rotateTransform(-40);
        graphics.drawString(
            'Confidential', PdfStandardFont(PdfFontFamily.helvetica, 40),
            pen: PdfPen(PdfColor(255, 0, 0)),
            brush: PdfBrushes.red,
            bounds: const Rect.fromLTWH(0, 300, 0, 0));
        graphics.restore();
      }
      savePdf(document.saveSync(), 'FLUT_3727_Watermark_exception.pdf');
      document.dispose();
    });
  });
}
