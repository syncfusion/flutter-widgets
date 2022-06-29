import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pdfBrushes() {
  group('Brushes', () {
    final PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    const String s = 'Hello World!..';
    page.graphics
        .drawString(s, font, brush: PdfBrushes.aliceBlue, bounds: Rect.zero);
    page.graphics.drawString(s, font,
        brush: PdfBrushes.antiqueWhite,
        bounds: const Rect.fromLTWH(100, 0, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.aqua, bounds: const Rect.fromLTWH(200, 0, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.aquamarine,
        bounds: const Rect.fromLTWH(300, 0, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.azure, bounds: const Rect.fromLTWH(400, 0, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.beige, bounds: const Rect.fromLTWH(0, 20, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.bisque, bounds: const Rect.fromLTWH(100, 20, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.black, bounds: const Rect.fromLTWH(200, 20, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.blanchedAlmond,
        bounds: const Rect.fromLTWH(300, 20, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.blue, bounds: const Rect.fromLTWH(400, 20, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.blueViolet, bounds: const Rect.fromLTWH(0, 40, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.brown, bounds: const Rect.fromLTWH(100, 40, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.burlyWood,
        bounds: const Rect.fromLTWH(200, 40, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.cadetBlue,
        bounds: const Rect.fromLTWH(300, 40, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.chartreuse,
        bounds: const Rect.fromLTWH(400, 40, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.chocolate, bounds: const Rect.fromLTWH(0, 60, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.coral, bounds: const Rect.fromLTWH(100, 60, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.cornflowerBlue,
        bounds: const Rect.fromLTWH(200, 60, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.cornsilk, bounds: const Rect.fromLTWH(300, 60, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.crimson, bounds: const Rect.fromLTWH(400, 60, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.cyan, bounds: const Rect.fromLTWH(0, 80, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(100, 80, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkCyan, bounds: const Rect.fromLTWH(200, 80, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkGoldenrod,
        bounds: const Rect.fromLTWH(300, 80, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkGray, bounds: const Rect.fromLTWH(400, 80, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkGreen, bounds: const Rect.fromLTWH(0, 100, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkKhaki,
        bounds: const Rect.fromLTWH(100, 100, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkMagenta,
        bounds: const Rect.fromLTWH(200, 100, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkOliveGreen,
        bounds: const Rect.fromLTWH(300, 100, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkOrange,
        bounds: const Rect.fromLTWH(400, 100, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkOrchid,
        bounds: const Rect.fromLTWH(0, 120, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkRed, bounds: const Rect.fromLTWH(100, 120, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkSalmon,
        bounds: const Rect.fromLTWH(200, 120, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkSeaGreen,
        bounds: const Rect.fromLTWH(300, 120, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkSlateBlue,
        bounds: const Rect.fromLTWH(400, 120, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkSlateGray,
        bounds: const Rect.fromLTWH(0, 140, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkTurquoise,
        bounds: const Rect.fromLTWH(100, 140, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkViolet,
        bounds: const Rect.fromLTWH(200, 140, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.deepPink,
        bounds: const Rect.fromLTWH(300, 140, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.deepSkyBlue,
        bounds: const Rect.fromLTWH(400, 140, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.dimGray, bounds: const Rect.fromLTWH(0, 160, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.dodgerBlue,
        bounds: const Rect.fromLTWH(100, 160, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.firebrick,
        bounds: const Rect.fromLTWH(200, 160, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.floralWhite,
        bounds: const Rect.fromLTWH(300, 160, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.forestGreen,
        bounds: const Rect.fromLTWH(400, 160, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.fuchsia, bounds: const Rect.fromLTWH(0, 180, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.gainsboro,
        bounds: const Rect.fromLTWH(100, 180, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.ghostWhite,
        bounds: const Rect.fromLTWH(200, 180, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.gold, bounds: const Rect.fromLTWH(300, 180, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.goldenrod,
        bounds: const Rect.fromLTWH(400, 180, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.gray, bounds: const Rect.fromLTWH(0, 200, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.green, bounds: const Rect.fromLTWH(100, 200, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.greenYellow,
        bounds: const Rect.fromLTWH(200, 200, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.honeydew,
        bounds: const Rect.fromLTWH(300, 200, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.hotPink, bounds: const Rect.fromLTWH(400, 200, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.indianRed, bounds: const Rect.fromLTWH(0, 220, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.indigo, bounds: const Rect.fromLTWH(100, 220, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.ivory, bounds: const Rect.fromLTWH(200, 220, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.khaki, bounds: const Rect.fromLTWH(300, 220, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lavender,
        bounds: const Rect.fromLTWH(400, 220, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lavenderBlush,
        bounds: const Rect.fromLTWH(0, 240, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lawnGreen,
        bounds: const Rect.fromLTWH(100, 240, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lemonChiffon,
        bounds: const Rect.fromLTWH(200, 240, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightBlue,
        bounds: const Rect.fromLTWH(300, 240, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightCoral,
        bounds: const Rect.fromLTWH(400, 240, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightCyan, bounds: const Rect.fromLTWH(0, 260, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightGoldenrodYellow,
        bounds: const Rect.fromLTWH(100, 260, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightGray,
        bounds: const Rect.fromLTWH(200, 260, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightGreen,
        bounds: const Rect.fromLTWH(300, 260, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightPink,
        bounds: const Rect.fromLTWH(400, 260, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightSalmon,
        bounds: const Rect.fromLTWH(0, 280, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightSeaGreen,
        bounds: const Rect.fromLTWH(100, 280, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightSkyBlue,
        bounds: const Rect.fromLTWH(200, 280, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightSlateGray,
        bounds: const Rect.fromLTWH(300, 280, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightSteelBlue,
        bounds: const Rect.fromLTWH(400, 280, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightYellow,
        bounds: const Rect.fromLTWH(0, 300, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lime, bounds: const Rect.fromLTWH(100, 300, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.limeGreen,
        bounds: const Rect.fromLTWH(200, 300, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.linen, bounds: const Rect.fromLTWH(300, 300, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.magenta, bounds: const Rect.fromLTWH(400, 300, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.maroon, bounds: const Rect.fromLTWH(0, 320, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumAquamarine,
        bounds: const Rect.fromLTWH(100, 320, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumBlue,
        bounds: const Rect.fromLTWH(200, 320, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumOrchid,
        bounds: const Rect.fromLTWH(300, 320, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumPurple,
        bounds: const Rect.fromLTWH(400, 320, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumSeaGreen,
        bounds: const Rect.fromLTWH(0, 340, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumSlateBlue,
        bounds: const Rect.fromLTWH(100, 340, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumSpringGreen,
        bounds: const Rect.fromLTWH(200, 340, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumTurquoise,
        bounds: const Rect.fromLTWH(300, 340, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumVioletRed,
        bounds: const Rect.fromLTWH(400, 340, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.midnightBlue,
        bounds: const Rect.fromLTWH(0, 360, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mintCream,
        bounds: const Rect.fromLTWH(100, 360, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mistyRose,
        bounds: const Rect.fromLTWH(200, 360, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.moccasin,
        bounds: const Rect.fromLTWH(300, 360, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.navajoWhite,
        bounds: const Rect.fromLTWH(400, 360, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.navy, bounds: const Rect.fromLTWH(0, 380, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.oldLace, bounds: const Rect.fromLTWH(100, 380, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.olive, bounds: const Rect.fromLTWH(200, 380, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.oliveDrab,
        bounds: const Rect.fromLTWH(300, 380, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.orange, bounds: const Rect.fromLTWH(400, 380, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.orangeRed, bounds: const Rect.fromLTWH(0, 400, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.orchid, bounds: const Rect.fromLTWH(100, 400, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.paleGoldenrod,
        bounds: const Rect.fromLTWH(200, 400, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.paleGreen,
        bounds: const Rect.fromLTWH(300, 400, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.paleTurquoise,
        bounds: const Rect.fromLTWH(400, 400, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.paleVioletRed,
        bounds: const Rect.fromLTWH(0, 420, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.papayaWhip,
        bounds: const Rect.fromLTWH(100, 420, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.peachPuff,
        bounds: const Rect.fromLTWH(200, 420, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.peru, bounds: const Rect.fromLTWH(300, 420, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.pink, bounds: const Rect.fromLTWH(400, 420, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.plum, bounds: const Rect.fromLTWH(0, 440, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.powderBlue,
        bounds: const Rect.fromLTWH(100, 440, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.purple, bounds: const Rect.fromLTWH(200, 440, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.red, bounds: const Rect.fromLTWH(300, 440, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.rosyBrown,
        bounds: const Rect.fromLTWH(400, 440, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.royalBlue, bounds: const Rect.fromLTWH(0, 460, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.saddleBrown,
        bounds: const Rect.fromLTWH(100, 460, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.salmon, bounds: const Rect.fromLTWH(200, 460, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.sandyBrown,
        bounds: const Rect.fromLTWH(300, 460, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.seaGreen,
        bounds: const Rect.fromLTWH(400, 460, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.seaShell, bounds: const Rect.fromLTWH(0, 480, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.sienna, bounds: const Rect.fromLTWH(100, 480, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.silver, bounds: const Rect.fromLTWH(200, 480, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.skyBlue, bounds: const Rect.fromLTWH(300, 480, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.slateBlue,
        bounds: const Rect.fromLTWH(400, 480, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.slateGray, bounds: const Rect.fromLTWH(0, 500, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.snow, bounds: const Rect.fromLTWH(100, 500, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.springGreen,
        bounds: const Rect.fromLTWH(200, 500, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.steelBlue,
        bounds: const Rect.fromLTWH(300, 500, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.tan, bounds: const Rect.fromLTWH(400, 500, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.teal, bounds: const Rect.fromLTWH(0, 520, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.thistle, bounds: const Rect.fromLTWH(100, 520, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.tomato, bounds: const Rect.fromLTWH(200, 520, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.transparent,
        bounds: const Rect.fromLTWH(300, 520, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.turquoise,
        bounds: const Rect.fromLTWH(400, 520, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.violet, bounds: const Rect.fromLTWH(0, 540, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.wheat, bounds: const Rect.fromLTWH(100, 540, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.white, bounds: const Rect.fromLTWH(200, 540, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.whiteSmoke,
        bounds: const Rect.fromLTWH(300, 540, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.yellow, bounds: const Rect.fromLTWH(400, 540, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.yellowGreen,
        bounds: const Rect.fromLTWH(0, 560, 0, 0));

    page = document.pages.add();
    page.graphics
        .drawString(s, font, brush: PdfBrushes.aliceBlue, bounds: Rect.zero);
    page.graphics.drawString(s, font,
        brush: PdfBrushes.antiqueWhite,
        bounds: const Rect.fromLTWH(100, 0, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.aqua, bounds: const Rect.fromLTWH(200, 0, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.aquamarine,
        bounds: const Rect.fromLTWH(300, 0, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.azure, bounds: const Rect.fromLTWH(400, 0, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.beige, bounds: const Rect.fromLTWH(0, 20, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.bisque, bounds: const Rect.fromLTWH(100, 20, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.black, bounds: const Rect.fromLTWH(200, 20, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.blanchedAlmond,
        bounds: const Rect.fromLTWH(300, 20, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.blue, bounds: const Rect.fromLTWH(400, 20, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.blueViolet, bounds: const Rect.fromLTWH(0, 40, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.brown, bounds: const Rect.fromLTWH(100, 40, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.burlyWood,
        bounds: const Rect.fromLTWH(200, 40, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.cadetBlue,
        bounds: const Rect.fromLTWH(300, 40, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.chartreuse,
        bounds: const Rect.fromLTWH(400, 40, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.chocolate, bounds: const Rect.fromLTWH(0, 60, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.coral, bounds: const Rect.fromLTWH(100, 60, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.cornflowerBlue,
        bounds: const Rect.fromLTWH(200, 60, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.cornsilk, bounds: const Rect.fromLTWH(300, 60, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.crimson, bounds: const Rect.fromLTWH(400, 60, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.cyan, bounds: const Rect.fromLTWH(0, 80, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(100, 80, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkCyan, bounds: const Rect.fromLTWH(200, 80, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkGoldenrod,
        bounds: const Rect.fromLTWH(300, 80, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkGray, bounds: const Rect.fromLTWH(400, 80, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkGreen, bounds: const Rect.fromLTWH(0, 100, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkKhaki,
        bounds: const Rect.fromLTWH(100, 100, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkMagenta,
        bounds: const Rect.fromLTWH(200, 100, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkOliveGreen,
        bounds: const Rect.fromLTWH(300, 100, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkOrange,
        bounds: const Rect.fromLTWH(400, 100, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkOrchid,
        bounds: const Rect.fromLTWH(0, 120, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkRed, bounds: const Rect.fromLTWH(100, 120, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkSalmon,
        bounds: const Rect.fromLTWH(200, 120, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkSeaGreen,
        bounds: const Rect.fromLTWH(300, 120, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkSlateBlue,
        bounds: const Rect.fromLTWH(400, 120, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkSlateGray,
        bounds: const Rect.fromLTWH(0, 140, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkTurquoise,
        bounds: const Rect.fromLTWH(100, 140, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.darkViolet,
        bounds: const Rect.fromLTWH(200, 140, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.deepPink,
        bounds: const Rect.fromLTWH(300, 140, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.deepSkyBlue,
        bounds: const Rect.fromLTWH(400, 140, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.dimGray, bounds: const Rect.fromLTWH(0, 160, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.dodgerBlue,
        bounds: const Rect.fromLTWH(100, 160, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.firebrick,
        bounds: const Rect.fromLTWH(200, 160, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.floralWhite,
        bounds: const Rect.fromLTWH(300, 160, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.forestGreen,
        bounds: const Rect.fromLTWH(400, 160, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.fuchsia, bounds: const Rect.fromLTWH(0, 180, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.gainsboro,
        bounds: const Rect.fromLTWH(100, 180, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.ghostWhite,
        bounds: const Rect.fromLTWH(200, 180, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.gold, bounds: const Rect.fromLTWH(300, 180, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.goldenrod,
        bounds: const Rect.fromLTWH(400, 180, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.gray, bounds: const Rect.fromLTWH(0, 200, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.green, bounds: const Rect.fromLTWH(100, 200, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.greenYellow,
        bounds: const Rect.fromLTWH(200, 200, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.honeydew,
        bounds: const Rect.fromLTWH(300, 200, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.hotPink, bounds: const Rect.fromLTWH(400, 200, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.indianRed, bounds: const Rect.fromLTWH(0, 220, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.indigo, bounds: const Rect.fromLTWH(100, 220, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.ivory, bounds: const Rect.fromLTWH(200, 220, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.khaki, bounds: const Rect.fromLTWH(300, 220, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lavender,
        bounds: const Rect.fromLTWH(400, 220, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lavenderBlush,
        bounds: const Rect.fromLTWH(0, 240, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lawnGreen,
        bounds: const Rect.fromLTWH(100, 240, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lemonChiffon,
        bounds: const Rect.fromLTWH(200, 240, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightBlue,
        bounds: const Rect.fromLTWH(300, 240, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightCoral,
        bounds: const Rect.fromLTWH(400, 240, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightCyan, bounds: const Rect.fromLTWH(0, 260, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightGoldenrodYellow,
        bounds: const Rect.fromLTWH(100, 260, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightGray,
        bounds: const Rect.fromLTWH(200, 260, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightGreen,
        bounds: const Rect.fromLTWH(300, 260, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightPink,
        bounds: const Rect.fromLTWH(400, 260, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightSalmon,
        bounds: const Rect.fromLTWH(0, 280, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightSeaGreen,
        bounds: const Rect.fromLTWH(100, 280, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightSkyBlue,
        bounds: const Rect.fromLTWH(200, 280, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightSlateGray,
        bounds: const Rect.fromLTWH(300, 280, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightSteelBlue,
        bounds: const Rect.fromLTWH(400, 280, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lightYellow,
        bounds: const Rect.fromLTWH(0, 300, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.lime, bounds: const Rect.fromLTWH(100, 300, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.limeGreen,
        bounds: const Rect.fromLTWH(200, 300, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.linen, bounds: const Rect.fromLTWH(300, 300, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.magenta, bounds: const Rect.fromLTWH(400, 300, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.maroon, bounds: const Rect.fromLTWH(0, 320, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumAquamarine,
        bounds: const Rect.fromLTWH(100, 320, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumBlue,
        bounds: const Rect.fromLTWH(200, 320, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumOrchid,
        bounds: const Rect.fromLTWH(300, 320, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumPurple,
        bounds: const Rect.fromLTWH(400, 320, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumSeaGreen,
        bounds: const Rect.fromLTWH(0, 340, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumSlateBlue,
        bounds: const Rect.fromLTWH(100, 340, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumSpringGreen,
        bounds: const Rect.fromLTWH(200, 340, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumTurquoise,
        bounds: const Rect.fromLTWH(300, 340, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mediumVioletRed,
        bounds: const Rect.fromLTWH(400, 340, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.midnightBlue,
        bounds: const Rect.fromLTWH(0, 360, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mintCream,
        bounds: const Rect.fromLTWH(100, 360, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.mistyRose,
        bounds: const Rect.fromLTWH(200, 360, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.moccasin,
        bounds: const Rect.fromLTWH(300, 360, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.navajoWhite,
        bounds: const Rect.fromLTWH(400, 360, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.navy, bounds: const Rect.fromLTWH(0, 380, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.oldLace, bounds: const Rect.fromLTWH(100, 380, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.olive, bounds: const Rect.fromLTWH(200, 380, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.oliveDrab,
        bounds: const Rect.fromLTWH(300, 380, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.orange, bounds: const Rect.fromLTWH(400, 380, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.orangeRed, bounds: const Rect.fromLTWH(0, 400, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.orchid, bounds: const Rect.fromLTWH(100, 400, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.paleGoldenrod,
        bounds: const Rect.fromLTWH(200, 400, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.paleGreen,
        bounds: const Rect.fromLTWH(300, 400, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.paleTurquoise,
        bounds: const Rect.fromLTWH(400, 400, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.paleVioletRed,
        bounds: const Rect.fromLTWH(0, 420, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.papayaWhip,
        bounds: const Rect.fromLTWH(100, 420, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.peachPuff,
        bounds: const Rect.fromLTWH(200, 420, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.peru, bounds: const Rect.fromLTWH(300, 420, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.pink, bounds: const Rect.fromLTWH(400, 420, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.plum, bounds: const Rect.fromLTWH(0, 440, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.powderBlue,
        bounds: const Rect.fromLTWH(100, 440, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.purple, bounds: const Rect.fromLTWH(200, 440, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.red, bounds: const Rect.fromLTWH(300, 440, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.rosyBrown,
        bounds: const Rect.fromLTWH(400, 440, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.royalBlue, bounds: const Rect.fromLTWH(0, 460, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.saddleBrown,
        bounds: const Rect.fromLTWH(100, 460, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.salmon, bounds: const Rect.fromLTWH(200, 460, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.sandyBrown,
        bounds: const Rect.fromLTWH(300, 460, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.seaGreen,
        bounds: const Rect.fromLTWH(400, 460, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.seaShell, bounds: const Rect.fromLTWH(0, 480, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.sienna, bounds: const Rect.fromLTWH(100, 480, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.silver, bounds: const Rect.fromLTWH(200, 480, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.skyBlue, bounds: const Rect.fromLTWH(300, 480, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.slateBlue,
        bounds: const Rect.fromLTWH(400, 480, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.slateGray, bounds: const Rect.fromLTWH(0, 500, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.snow, bounds: const Rect.fromLTWH(100, 500, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.springGreen,
        bounds: const Rect.fromLTWH(200, 500, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.steelBlue,
        bounds: const Rect.fromLTWH(300, 500, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.tan, bounds: const Rect.fromLTWH(400, 500, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.teal, bounds: const Rect.fromLTWH(0, 520, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.thistle, bounds: const Rect.fromLTWH(100, 520, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.tomato, bounds: const Rect.fromLTWH(200, 520, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.transparent,
        bounds: const Rect.fromLTWH(300, 520, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.turquoise,
        bounds: const Rect.fromLTWH(400, 520, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.violet, bounds: const Rect.fromLTWH(0, 540, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.wheat, bounds: const Rect.fromLTWH(100, 540, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.white, bounds: const Rect.fromLTWH(200, 540, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.whiteSmoke,
        bounds: const Rect.fromLTWH(300, 540, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.yellow, bounds: const Rect.fromLTWH(400, 540, 0, 0));
    page.graphics.drawString(s, font,
        brush: PdfBrushes.yellowGreen,
        bounds: const Rect.fromLTWH(0, 560, 0, 0));
    final List<int> bytes = document.saveSync();
    savePdf(bytes, 'brushes.pdf');
    document.dispose();
  });
  group('pens', () {
    //Create a new PDF document.
    final PdfDocument doc = PdfDocument();
    doc.pageSettings.size = PdfPageSize.a3;
    //Add a page to the document.
    PdfPage page = doc.pages.add();
    //Create PDF graphics for the page
    PdfGraphics graphics = page.graphics;
    //Draw rectangle.
    graphics.drawRectangle(
        pen: PdfPens.aliceBlue, bounds: const Rect.fromLTWH(0, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.antiqueWhite, bounds: const Rect.fromLTWH(70, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.aqua, bounds: const Rect.fromLTWH(140, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.aquamarine, bounds: const Rect.fromLTWH(210, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.azure, bounds: const Rect.fromLTWH(280, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.beige, bounds: const Rect.fromLTWH(350, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.bisque, bounds: const Rect.fromLTWH(420, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.black, bounds: const Rect.fromLTWH(0, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.blanchedAlmond,
        bounds: const Rect.fromLTWH(70, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.blue, bounds: const Rect.fromLTWH(140, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.blueViolet, bounds: const Rect.fromLTWH(210, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.brown, bounds: const Rect.fromLTWH(280, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.burlyWood, bounds: const Rect.fromLTWH(350, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.cadetBlue, bounds: const Rect.fromLTWH(420, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.chartreuse, bounds: const Rect.fromLTWH(0, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.chocolate, bounds: const Rect.fromLTWH(70, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.coral, bounds: const Rect.fromLTWH(140, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.cornflowerBlue,
        bounds: const Rect.fromLTWH(210, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.cornsilk, bounds: const Rect.fromLTWH(280, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.crimson, bounds: const Rect.fromLTWH(350, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.cyan, bounds: const Rect.fromLTWH(420, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkBlue, bounds: const Rect.fromLTWH(0, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkCyan, bounds: const Rect.fromLTWH(70, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkGoldenrod,
        bounds: const Rect.fromLTWH(140, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkGray, bounds: const Rect.fromLTWH(210, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkGreen, bounds: const Rect.fromLTWH(280, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkKhaki, bounds: const Rect.fromLTWH(350, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkMagenta,
        bounds: const Rect.fromLTWH(420, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkOliveGreen,
        bounds: const Rect.fromLTWH(0, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkOrange, bounds: const Rect.fromLTWH(70, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkOrchid, bounds: const Rect.fromLTWH(140, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkRed, bounds: const Rect.fromLTWH(210, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkSalmon, bounds: const Rect.fromLTWH(280, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkSeaGreen,
        bounds: const Rect.fromLTWH(350, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkSlateBlue,
        bounds: const Rect.fromLTWH(420, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkSlateGray,
        bounds: const Rect.fromLTWH(0, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkTurquoise,
        bounds: const Rect.fromLTWH(70, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkViolet, bounds: const Rect.fromLTWH(140, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.deepPink, bounds: const Rect.fromLTWH(210, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.deepSkyBlue,
        bounds: const Rect.fromLTWH(280, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.dimGray, bounds: const Rect.fromLTWH(350, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.dodgerBlue, bounds: const Rect.fromLTWH(420, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.firebrick, bounds: const Rect.fromLTWH(0, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.floralWhite, bounds: const Rect.fromLTWH(70, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.forestGreen,
        bounds: const Rect.fromLTWH(140, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.fuchsia, bounds: const Rect.fromLTWH(210, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.gainsboro, bounds: const Rect.fromLTWH(280, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.ghostWhite, bounds: const Rect.fromLTWH(350, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.gold, bounds: const Rect.fromLTWH(420, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.goldenrod, bounds: const Rect.fromLTWH(0, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.gray, bounds: const Rect.fromLTWH(70, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.green, bounds: const Rect.fromLTWH(140, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.greenYellow,
        bounds: const Rect.fromLTWH(210, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.honeydew, bounds: const Rect.fromLTWH(280, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.hotPink, bounds: const Rect.fromLTWH(350, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.indianRed, bounds: const Rect.fromLTWH(420, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.indigo, bounds: const Rect.fromLTWH(0, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.ivory, bounds: const Rect.fromLTWH(70, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.khaki, bounds: const Rect.fromLTWH(140, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lavender, bounds: const Rect.fromLTWH(210, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lavenderBlush,
        bounds: const Rect.fromLTWH(280, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lawnGreen, bounds: const Rect.fromLTWH(350, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lemonChiffon,
        bounds: const Rect.fromLTWH(420, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightBlue, bounds: const Rect.fromLTWH(0, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightCoral, bounds: const Rect.fromLTWH(70, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightCyan, bounds: const Rect.fromLTWH(140, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightGoldenrodYellow,
        bounds: const Rect.fromLTWH(210, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightGray, bounds: const Rect.fromLTWH(280, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightGreen, bounds: const Rect.fromLTWH(350, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightPink, bounds: const Rect.fromLTWH(420, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightSalmon, bounds: const Rect.fromLTWH(0, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightSeaGreen,
        bounds: const Rect.fromLTWH(70, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightSkyBlue,
        bounds: const Rect.fromLTWH(140, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightSlateGray,
        bounds: const Rect.fromLTWH(210, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightSteelBlue,
        bounds: const Rect.fromLTWH(280, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightYellow,
        bounds: const Rect.fromLTWH(350, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lime, bounds: const Rect.fromLTWH(420, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.limeGreen, bounds: const Rect.fromLTWH(0, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.linen, bounds: const Rect.fromLTWH(70, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.magenta, bounds: const Rect.fromLTWH(140, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.maroon, bounds: const Rect.fromLTWH(210, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumAquamarine,
        bounds: const Rect.fromLTWH(280, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumBlue, bounds: const Rect.fromLTWH(350, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumOrchid,
        bounds: const Rect.fromLTWH(420, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumPurple, bounds: const Rect.fromLTWH(0, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumSeaGreen,
        bounds: const Rect.fromLTWH(70, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumSlateBlue,
        bounds: const Rect.fromLTWH(140, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumSpringGreen,
        bounds: const Rect.fromLTWH(210, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumTurquoise,
        bounds: const Rect.fromLTWH(280, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumVioletRed,
        bounds: const Rect.fromLTWH(350, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.midnightBlue,
        bounds: const Rect.fromLTWH(420, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mintCream, bounds: const Rect.fromLTWH(0, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mistyRose, bounds: const Rect.fromLTWH(70, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.moccasin, bounds: const Rect.fromLTWH(140, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.navajoWhite,
        bounds: const Rect.fromLTWH(210, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.navy, bounds: const Rect.fromLTWH(280, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.oldLace, bounds: const Rect.fromLTWH(350, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.olive, bounds: const Rect.fromLTWH(420, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.oliveDrab, bounds: const Rect.fromLTWH(0, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.orange, bounds: const Rect.fromLTWH(70, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.orangeRed, bounds: const Rect.fromLTWH(140, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.orchid, bounds: const Rect.fromLTWH(210, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.paleGoldenrod,
        bounds: const Rect.fromLTWH(280, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.paleGreen, bounds: const Rect.fromLTWH(350, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.paleTurquoise,
        bounds: const Rect.fromLTWH(420, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.paleVioletRed,
        bounds: const Rect.fromLTWH(0, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.papayaWhip, bounds: const Rect.fromLTWH(70, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.peachPuff, bounds: const Rect.fromLTWH(140, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.peru, bounds: const Rect.fromLTWH(210, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.pink, bounds: const Rect.fromLTWH(280, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.plum, bounds: const Rect.fromLTWH(350, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.powderBlue, bounds: const Rect.fromLTWH(420, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.purple, bounds: const Rect.fromLTWH(0, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.red, bounds: const Rect.fromLTWH(70, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.rosyBrown, bounds: const Rect.fromLTWH(140, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.royalBlue, bounds: const Rect.fromLTWH(210, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.saddleBrown,
        bounds: const Rect.fromLTWH(280, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.salmon, bounds: const Rect.fromLTWH(350, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.sandyBrown, bounds: const Rect.fromLTWH(420, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.seaGreen, bounds: const Rect.fromLTWH(0, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.seaShell, bounds: const Rect.fromLTWH(70, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.sienna, bounds: const Rect.fromLTWH(140, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.silver, bounds: const Rect.fromLTWH(210, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.skyBlue, bounds: const Rect.fromLTWH(280, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.slateBlue, bounds: const Rect.fromLTWH(350, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.slateGray, bounds: const Rect.fromLTWH(420, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.snow, bounds: const Rect.fromLTWH(0, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.springGreen, bounds: const Rect.fromLTWH(70, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.steelBlue, bounds: const Rect.fromLTWH(140, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.tan, bounds: const Rect.fromLTWH(210, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.teal, bounds: const Rect.fromLTWH(280, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.thistle, bounds: const Rect.fromLTWH(350, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.tomato, bounds: const Rect.fromLTWH(420, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.transparent, bounds: const Rect.fromLTWH(0, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.turquoise, bounds: const Rect.fromLTWH(70, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.violet, bounds: const Rect.fromLTWH(140, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.wheat, bounds: const Rect.fromLTWH(210, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.white, bounds: const Rect.fromLTWH(280, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.whiteSmoke, bounds: const Rect.fromLTWH(350, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.yellow, bounds: const Rect.fromLTWH(420, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.yellowGreen, bounds: const Rect.fromLTWH(0, 800, 50, 20));

    page = doc.pages.add();
    graphics = page.graphics;
    graphics.drawRectangle(
        pen: PdfPens.aliceBlue, bounds: const Rect.fromLTWH(0, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.antiqueWhite, bounds: const Rect.fromLTWH(70, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.aqua, bounds: const Rect.fromLTWH(140, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.aquamarine, bounds: const Rect.fromLTWH(210, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.azure, bounds: const Rect.fromLTWH(280, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.beige, bounds: const Rect.fromLTWH(350, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.bisque, bounds: const Rect.fromLTWH(420, 0, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.black, bounds: const Rect.fromLTWH(0, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.blanchedAlmond,
        bounds: const Rect.fromLTWH(70, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.blue, bounds: const Rect.fromLTWH(140, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.blueViolet, bounds: const Rect.fromLTWH(210, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.brown, bounds: const Rect.fromLTWH(280, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.burlyWood, bounds: const Rect.fromLTWH(350, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.cadetBlue, bounds: const Rect.fromLTWH(420, 40, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.chartreuse, bounds: const Rect.fromLTWH(0, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.chocolate, bounds: const Rect.fromLTWH(70, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.coral, bounds: const Rect.fromLTWH(140, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.cornflowerBlue,
        bounds: const Rect.fromLTWH(210, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.cornsilk, bounds: const Rect.fromLTWH(280, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.crimson, bounds: const Rect.fromLTWH(350, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.cyan, bounds: const Rect.fromLTWH(420, 80, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkBlue, bounds: const Rect.fromLTWH(0, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkCyan, bounds: const Rect.fromLTWH(70, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkGoldenrod,
        bounds: const Rect.fromLTWH(140, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkGray, bounds: const Rect.fromLTWH(210, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkGreen, bounds: const Rect.fromLTWH(280, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkKhaki, bounds: const Rect.fromLTWH(350, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkMagenta,
        bounds: const Rect.fromLTWH(420, 120, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkOliveGreen,
        bounds: const Rect.fromLTWH(0, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkOrange, bounds: const Rect.fromLTWH(70, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkOrchid, bounds: const Rect.fromLTWH(140, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkRed, bounds: const Rect.fromLTWH(210, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkSalmon, bounds: const Rect.fromLTWH(280, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkSeaGreen,
        bounds: const Rect.fromLTWH(350, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkSlateBlue,
        bounds: const Rect.fromLTWH(420, 160, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkSlateGray,
        bounds: const Rect.fromLTWH(0, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkTurquoise,
        bounds: const Rect.fromLTWH(70, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.darkViolet, bounds: const Rect.fromLTWH(140, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.deepPink, bounds: const Rect.fromLTWH(210, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.deepSkyBlue,
        bounds: const Rect.fromLTWH(280, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.dimGray, bounds: const Rect.fromLTWH(350, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.dodgerBlue, bounds: const Rect.fromLTWH(420, 200, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.firebrick, bounds: const Rect.fromLTWH(0, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.floralWhite, bounds: const Rect.fromLTWH(70, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.forestGreen,
        bounds: const Rect.fromLTWH(140, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.fuchsia, bounds: const Rect.fromLTWH(210, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.gainsboro, bounds: const Rect.fromLTWH(280, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.ghostWhite, bounds: const Rect.fromLTWH(350, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.gold, bounds: const Rect.fromLTWH(420, 240, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.goldenrod, bounds: const Rect.fromLTWH(0, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.gray, bounds: const Rect.fromLTWH(70, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.green, bounds: const Rect.fromLTWH(140, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.greenYellow,
        bounds: const Rect.fromLTWH(210, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.honeydew, bounds: const Rect.fromLTWH(280, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.hotPink, bounds: const Rect.fromLTWH(350, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.indianRed, bounds: const Rect.fromLTWH(420, 280, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.indigo, bounds: const Rect.fromLTWH(0, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.ivory, bounds: const Rect.fromLTWH(70, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.khaki, bounds: const Rect.fromLTWH(140, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lavender, bounds: const Rect.fromLTWH(210, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lavenderBlush,
        bounds: const Rect.fromLTWH(280, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lawnGreen, bounds: const Rect.fromLTWH(350, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lemonChiffon,
        bounds: const Rect.fromLTWH(420, 320, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightBlue, bounds: const Rect.fromLTWH(0, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightCoral, bounds: const Rect.fromLTWH(70, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightCyan, bounds: const Rect.fromLTWH(140, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightGoldenrodYellow,
        bounds: const Rect.fromLTWH(210, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightGray, bounds: const Rect.fromLTWH(280, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightGreen, bounds: const Rect.fromLTWH(350, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightPink, bounds: const Rect.fromLTWH(420, 360, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightSalmon, bounds: const Rect.fromLTWH(0, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightSeaGreen,
        bounds: const Rect.fromLTWH(70, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightSkyBlue,
        bounds: const Rect.fromLTWH(140, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightSlateGray,
        bounds: const Rect.fromLTWH(210, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightSteelBlue,
        bounds: const Rect.fromLTWH(280, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lightYellow,
        bounds: const Rect.fromLTWH(350, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.lime, bounds: const Rect.fromLTWH(420, 400, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.limeGreen, bounds: const Rect.fromLTWH(0, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.linen, bounds: const Rect.fromLTWH(70, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.magenta, bounds: const Rect.fromLTWH(140, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.maroon, bounds: const Rect.fromLTWH(210, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumAquamarine,
        bounds: const Rect.fromLTWH(280, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumBlue, bounds: const Rect.fromLTWH(350, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumOrchid,
        bounds: const Rect.fromLTWH(420, 440, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumPurple, bounds: const Rect.fromLTWH(0, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumSeaGreen,
        bounds: const Rect.fromLTWH(70, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumSlateBlue,
        bounds: const Rect.fromLTWH(140, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumSpringGreen,
        bounds: const Rect.fromLTWH(210, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumTurquoise,
        bounds: const Rect.fromLTWH(280, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mediumVioletRed,
        bounds: const Rect.fromLTWH(350, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.midnightBlue,
        bounds: const Rect.fromLTWH(420, 480, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mintCream, bounds: const Rect.fromLTWH(0, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.mistyRose, bounds: const Rect.fromLTWH(70, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.moccasin, bounds: const Rect.fromLTWH(140, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.navajoWhite,
        bounds: const Rect.fromLTWH(210, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.navy, bounds: const Rect.fromLTWH(280, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.oldLace, bounds: const Rect.fromLTWH(350, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.olive, bounds: const Rect.fromLTWH(420, 520, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.oliveDrab, bounds: const Rect.fromLTWH(0, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.orange, bounds: const Rect.fromLTWH(70, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.orangeRed, bounds: const Rect.fromLTWH(140, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.orchid, bounds: const Rect.fromLTWH(210, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.paleGoldenrod,
        bounds: const Rect.fromLTWH(280, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.paleGreen, bounds: const Rect.fromLTWH(350, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.paleTurquoise,
        bounds: const Rect.fromLTWH(420, 560, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.paleVioletRed,
        bounds: const Rect.fromLTWH(0, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.papayaWhip, bounds: const Rect.fromLTWH(70, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.peachPuff, bounds: const Rect.fromLTWH(140, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.peru, bounds: const Rect.fromLTWH(210, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.pink, bounds: const Rect.fromLTWH(280, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.plum, bounds: const Rect.fromLTWH(350, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.powderBlue, bounds: const Rect.fromLTWH(420, 600, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.purple, bounds: const Rect.fromLTWH(0, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.red, bounds: const Rect.fromLTWH(70, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.rosyBrown, bounds: const Rect.fromLTWH(140, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.royalBlue, bounds: const Rect.fromLTWH(210, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.saddleBrown,
        bounds: const Rect.fromLTWH(280, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.salmon, bounds: const Rect.fromLTWH(350, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.sandyBrown, bounds: const Rect.fromLTWH(420, 640, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.seaGreen, bounds: const Rect.fromLTWH(0, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.seaShell, bounds: const Rect.fromLTWH(70, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.sienna, bounds: const Rect.fromLTWH(140, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.silver, bounds: const Rect.fromLTWH(210, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.skyBlue, bounds: const Rect.fromLTWH(280, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.slateBlue, bounds: const Rect.fromLTWH(350, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.slateGray, bounds: const Rect.fromLTWH(420, 680, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.snow, bounds: const Rect.fromLTWH(0, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.springGreen, bounds: const Rect.fromLTWH(70, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.steelBlue, bounds: const Rect.fromLTWH(140, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.tan, bounds: const Rect.fromLTWH(210, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.teal, bounds: const Rect.fromLTWH(280, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.thistle, bounds: const Rect.fromLTWH(350, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.tomato, bounds: const Rect.fromLTWH(420, 720, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.transparent, bounds: const Rect.fromLTWH(0, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.turquoise, bounds: const Rect.fromLTWH(70, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.violet, bounds: const Rect.fromLTWH(140, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.wheat, bounds: const Rect.fromLTWH(210, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.white, bounds: const Rect.fromLTWH(280, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.whiteSmoke, bounds: const Rect.fromLTWH(350, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.yellow, bounds: const Rect.fromLTWH(420, 760, 50, 20));
    graphics.drawRectangle(
        pen: PdfPens.yellowGreen, bounds: const Rect.fromLTWH(0, 800, 50, 20));
    //Save the document.
    final List<int> bytes = doc.saveSync();
    savePdf(bytes, 'pens.pdf');
    //Close the document.
    doc.dispose();
  });
  // group('immutable pen', () {
  //   final PdfPen pen = PdfPens.black;
  //   test('color', () {
  //     try {
  //       pen.color = PdfColor(0, 0, 0);
  //     } catch (e) {
  //       expect(e.message, 'The immutable object can\'t be changed');
  //     }
  //   });
  //   test('brush', () {
  //     try {
  //       pen.brush = PdfBrushes.black;
  //     } catch (e) {
  //       expect(e.message, 'The immutable object can\'t be changed');
  //     }
  //   });
  //   test('dash offset', () {
  //     try {
  //       pen.dashOffset = 3;
  //     } catch (e) {
  //       expect(e.message, 'The immutable object can\'t be changed');
  //     }
  //   });
  //   test('dash style', () {
  //     try {
  //       pen.dashStyle = PdfDashStyle.custom;
  //     } catch (e) {
  //       expect(e.message, 'The immutable object can\'t be changed');
  //     }
  //   });
  //   test('dash pattern', () {
  //     try {
  //       pen.dashPattern = <double>[1, 2, 3];
  //     } catch (e) {
  //       expect(e.message, 'The immutable object can\'t be changed');
  //     }
  //   });
  //   test('line cap', () {
  //     try {
  //       pen.lineCap = PdfLineCap.square;
  //     } catch (e) {
  //       expect(e.message, 'The immutable object can\'t be changed');
  //     }
  //   });
  //   test('line join', () {
  //     try {
  //       pen.lineJoin = PdfLineJoin.miter;
  //     } catch (e) {
  //       expect(e.message, 'The immutable object can\'t be changed');
  //     }
  //   });
  //   test('width', () {
  //     try {
  //       pen.width = 2;
  //     } catch (e) {
  //       expect(e.message, 'The immutable object can\'t be changed');
  //     }
  //   });
  //   test('miter', () {
  //     try {
  //       pen.miterLimit = 3;
  //     } catch (e) {
  //       expect(e.message, 'The immutable object can\'t be changed');
  //     }
  //   });
  // });
}
