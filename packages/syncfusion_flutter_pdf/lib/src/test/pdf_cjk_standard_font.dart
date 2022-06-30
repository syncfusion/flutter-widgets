// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/graphics/fonts/pdf_font.dart';

// ignore: public_member_api_docs
void pdfCjkStandardFont() {
  group('cjk font settings', () {
    final PdfCjkStandardFont cjkStandardFont = PdfCjkStandardFont(
        PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium, 16);
    test('fontfamily, size', () {
      expect(cjkStandardFont.fontFamily,
          PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium);
      expect(PdfFontHelper.getHelper(cjkStandardFont).size, 16);
      expect(cjkStandardFont.style, PdfFontStyle.regular);
    });
  });
  group('cjk font Size', () {
    final PdfFont cjkStandardFont = PdfCjkStandardFont(
        PdfCjkFontFamily.heiseiMinchoW3, 20,
        style: PdfFontStyle.bold);
    final double size =
        PdfFontHelper.getHelper(cjkStandardFont).metrics!.getSize()!;
    test('fontfamily, size', () {
      expect(size, 20);
    });
  });
  group('cjk Multiplefont Style', () {
    final PdfFont cjkStandardFont = PdfCjkStandardFont(
        PdfCjkFontFamily.sinoTypeSongLight, 20,
        multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
    test('MultiplefontStyle', () {
      expect(PdfFontHelper.getHelper(cjkStandardFont).metrics!.postScriptName,
          'STSong-Light,BoldItalic');
    });
  });
}
