// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/graphics/fonts/pdf_font.dart';
import '../pdf/implementation/graphics/fonts/pdf_font_metrics.dart';
import '../pdf/implementation/graphics/fonts/pdf_standard_font_metrics_factory.dart';

// ignore: public_member_api_docs
void pdfStandardFont() {
  group('font settings', () {
    final PdfStandardFont standardFont =
        PdfStandardFont(PdfFontFamily.helvetica, 14);
    test('fontfamily, size', () {
      expect(standardFont.fontFamily, PdfFontFamily.helvetica);
      expect(PdfFontHelper.getHelper(standardFont).size, 14);
      expect(standardFont.style, PdfFontStyle.regular);
    });
  });
  group('font settings', () {
    final PdfStandardFont standardFont = PdfStandardFont(
        PdfFontFamily.helvetica, 16,
        style: PdfFontStyle.italic);

    test('fontfamily, size', () {
      expect(standardFont.fontFamily, PdfFontFamily.helvetica);
      expect(PdfFontHelper.getHelper(standardFont).size, 16);
      expect(standardFont.style, PdfFontStyle.italic);
    });
  });
  group('prototypefont settings', () {
    final PdfFont standardFont =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    final PdfStandardFont prototypeFont =
        PdfStandardFont.prototype(standardFont as PdfStandardFont, 16);

    test('fontfamily, size', () {
      expect(prototypeFont.fontFamily, PdfFontFamily.helvetica);
      expect(prototypeFont.size, 16);
      expect(prototypeFont.style, PdfFontStyle.bold);
    });
  });
  group('fontSize', () {
    final PdfStandardFont standardFont =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    final PdfFontMetrics metrics = PdfStandardFontMetricsFactory.getMetrics(
        PdfFontFamily.helvetica,
        PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold),
        14);
    PdfFontHelper.getHelper(standardFont).metrics = metrics;
    final num size = PdfFontHelper.getHelper(standardFont).metrics!.getSize()!;
    test('fontfamily, size', () {
      expect(size, 14);
    });
  });
}
