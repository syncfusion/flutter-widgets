import 'enums.dart';
import 'pdf_font.dart';
import 'pdf_font_metrics.dart';

/// A Class representing PDF document which is used for
/// Cjk Font Metrics Factory.
class PdfCjkStandardFontMetricsFactory {
  /// internal constructor
  PdfCjkStandardFontMetricsFactory();

  /// Multiplier of subscript superscript.
  static const double _subSuperscriptFactor = 1.52;

  /// Returns font metrics depending on the font settings.
  static PdfFontMetrics getMetrics(
      PdfCjkFontFamily? fontFamily, int? fontStyle, double size) {
    PdfFontMetrics metrics;

    switch (fontFamily) {
      case PdfCjkFontFamily.hanyangSystemsGothicMedium:
        metrics =
            _getHanyangSystemsGothicMediumMetrix(fontFamily, fontStyle!, size);
        break;

      case PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium:
        metrics = _getHanyangSystemsShinMyeongJoMediumMetrix(
            fontFamily, fontStyle!, size);
        break;

      case PdfCjkFontFamily.heiseiKakuGothicW5:
        metrics = _getHeiseiKakuGothicW5Metrix(fontFamily, fontStyle!, size);
        break;

      case PdfCjkFontFamily.heiseiMinchoW3:
        metrics = _getHeiseiMinchoW3(fontFamily, fontStyle!, size);
        break;

      case PdfCjkFontFamily.monotypeHeiMedium:
        metrics = _getMonotypeHeiMedium(fontFamily, fontStyle!, size);
        break;

      case PdfCjkFontFamily.monotypeSungLight:
        metrics = _getMonotypeSungLightMetrix(fontFamily, fontStyle!, size);
        break;

      case PdfCjkFontFamily.sinoTypeSongLight:
        metrics = _getSinoTypeSongLight(fontFamily, fontStyle!, size);
        break;

      // ignore: no_default_cases
      default:
        throw Exception('Unsupported font family, $fontFamily');
    }

    metrics.name = PdfFontHelper.standardCjkFontNames[fontFamily!.index];
    metrics.subscriptSizeFactor = _subSuperscriptFactor;
    metrics.superscriptSizeFactor = _subSuperscriptFactor;

    return metrics;
  }

  /// Gets the hanyang systems gothic medium font metrix.
  static PdfFontMetrics _getHanyangSystemsGothicMediumMetrix(
      PdfCjkFontFamily? fontFamily, int fontStyle, double size) {
    final PdfFontMetrics metrics = PdfFontMetrics();
    final CjkWidthTable widthTable = CjkWidthTable(1000);
    metrics.widthTable = widthTable;
    widthTable.add(CjkSameWidth(1, 127, 500));
    widthTable.add(CjkSameWidth(8094, 8190, 500));

    metrics.ascent = 880;
    metrics.descent = -120;
    metrics.size = size;
    metrics.height = metrics.ascent - metrics.descent;

    if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) != 0 &&
        (fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) != 0) {
      metrics.postScriptName = 'HYGoThic-Medium,BoldItalic';
    } else if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) !=
        0) {
      metrics.postScriptName = 'HYGoThic-Medium,Bold';
    } else if ((fontStyle &
            PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) !=
        0) {
      metrics.postScriptName = 'HYGoThic-Medium,Italic';
    } else {
      metrics.postScriptName = 'HYGoThic-Medium';
    }

    return metrics;
  }

  /// Gets the monotype hei medium metrix.
  static PdfFontMetrics _getMonotypeHeiMedium(
      PdfCjkFontFamily? fontFamily, int fontStyle, double size) {
    final PdfFontMetrics metrics = PdfFontMetrics();
    final CjkWidthTable widthTable = CjkWidthTable(1000);
    metrics.widthTable = widthTable;
    widthTable.add(CjkSameWidth(1, 95, 500));
    widthTable.add(CjkSameWidth(13648, 13742, 500));

    metrics.ascent = 880;
    metrics.descent = -120;
    metrics.size = size;
    metrics.height = metrics.ascent - metrics.descent;

    if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) != 0 &&
        (fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) != 0) {
      metrics.postScriptName = 'MHei-Medium,BoldItalic';
    } else if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) !=
        0) {
      metrics.postScriptName = 'MHei-Medium,Bold';
    } else if ((fontStyle &
            PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) !=
        0) {
      metrics.postScriptName = 'MHei-Medium,Italic';
    } else {
      metrics.postScriptName = 'MHei-Medium';
    }

    return metrics;
  }

  /// Gets the monotype sung light metrix.
  static PdfFontMetrics _getMonotypeSungLightMetrix(
      PdfCjkFontFamily? fontFamily, int fontStyle, double size) {
    final PdfFontMetrics metrics = PdfFontMetrics();
    final CjkWidthTable widthTable = CjkWidthTable(1000);
    metrics.widthTable = widthTable;
    widthTable.add(CjkSameWidth(1, 95, 500));
    widthTable.add(CjkSameWidth(13648, 13742, 500));

    metrics.ascent = 880;
    metrics.descent = -120;
    metrics.size = size;
    metrics.height = metrics.ascent - metrics.descent;

    if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) != 0 &&
        (fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) != 0) {
      metrics.postScriptName = 'MSung-Light,BoldItalic';
    } else if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) !=
        0) {
      metrics.postScriptName = 'MSung-Light,Bold';
    } else if ((fontStyle &
            PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) !=
        0) {
      metrics.postScriptName = 'MSung-Light,Italic';
    } else {
      metrics.postScriptName = 'MSung-Light';
    }

    return metrics;
  }

  /// Gets the sino type song light font metrics.
  static PdfFontMetrics _getSinoTypeSongLight(
      PdfCjkFontFamily? fontFamily, int fontStyle, double size) {
    final PdfFontMetrics metrics = PdfFontMetrics();
    final CjkWidthTable widthTable = CjkWidthTable(1000);
    metrics.widthTable = widthTable;
    widthTable.add(CjkSameWidth(1, 95, 500));
    widthTable.add(CjkSameWidth(814, 939, 500));
    widthTable.add(CjkDifferentWidth(7712, <int>[500]));
    widthTable.add(CjkDifferentWidth(7716, <int>[500]));

    metrics.ascent = 880;
    metrics.descent = -120;
    metrics.size = size;
    metrics.height = metrics.ascent - metrics.descent;

    if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) != 0 &&
        (fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) != 0) {
      metrics.postScriptName = 'STSong-Light,BoldItalic';
    } else if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) !=
        0) {
      metrics.postScriptName = 'STSong-Light,Bold';
    } else if ((fontStyle &
            PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) !=
        0) {
      metrics.postScriptName = 'STSong-Light,Italic';
    } else {
      metrics.postScriptName = 'STSong-Light';
    }

    return metrics;
  }

  /// Gets the heisei mincho w3.
  static PdfFontMetrics _getHeiseiMinchoW3(
      PdfCjkFontFamily? fontFamily, int fontStyle, double size) {
    final PdfFontMetrics metrics = PdfFontMetrics();
    final CjkWidthTable widthTable = CjkWidthTable(1000);
    metrics.widthTable = widthTable;
    widthTable.add(CjkSameWidth(1, 95, 500));
    widthTable.add(CjkSameWidth(231, 632, 500));

    metrics.ascent = 857;
    metrics.descent = -143;
    metrics.size = size;
    metrics.height = metrics.ascent - metrics.descent;

    if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) != 0 &&
        (fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) != 0) {
      metrics.postScriptName = 'HeiseiMin-W3,BoldItalic';
    } else if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) !=
        0) {
      metrics.postScriptName = 'HeiseiMin-W3,Bold';
    } else if ((fontStyle &
            PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) !=
        0) {
      metrics.postScriptName = 'HeiseiMin-W3,Italic';
    } else {
      metrics.postScriptName = 'HeiseiMin-W3';
    }

    return metrics;
  }

  /// Gets the heisei kaku gothic w5 metrix.
  static PdfFontMetrics _getHeiseiKakuGothicW5Metrix(
      PdfCjkFontFamily? fontFamily, int fontStyle, double size) {
    final PdfFontMetrics metrics = PdfFontMetrics();
    final CjkWidthTable widthTable = CjkWidthTable(1000);
    metrics.widthTable = widthTable;
    widthTable.add(CjkSameWidth(1, 95, 500));
    widthTable.add(CjkSameWidth(231, 632, 500));

    metrics.ascent = 857;
    metrics.descent = -125;
    metrics.size = size;
    metrics.height = metrics.ascent - metrics.descent;

    if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) != 0 &&
        (fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) != 0) {
      metrics.postScriptName = 'HeiseiKakuGo-W5,BoldItalic';
    } else if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) !=
        0) {
      metrics.postScriptName = 'HeiseiKakuGo-W5,Bold';
    } else if ((fontStyle &
            PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) !=
        0) {
      metrics.postScriptName = 'HeiseiKakuGo-W5,Italic';
    } else {
      metrics.postScriptName = 'HeiseiKakuGo-W5';
    }

    return metrics;
  }

  /// Gets the hanyang systems shin myeong jo medium metrix.
  static PdfFontMetrics _getHanyangSystemsShinMyeongJoMediumMetrix(
      PdfCjkFontFamily? fontFamily, int fontStyle, double size) {
    final PdfFontMetrics metrics = PdfFontMetrics();
    final CjkWidthTable widthTable = CjkWidthTable(1000);
    metrics.widthTable = widthTable;
    widthTable.add(CjkSameWidth(1, 95, 500));
    widthTable.add(CjkSameWidth(8094, 8190, 500));

    metrics.ascent = 880;
    metrics.descent = -120;
    metrics.size = size;
    metrics.height = metrics.ascent - metrics.descent;

    if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) != 0 &&
        (fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) != 0) {
      metrics.postScriptName = 'HYSMyeongJo-Medium,BoldItalic';
    } else if ((fontStyle & PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold)) !=
        0) {
      metrics.postScriptName = 'HYSMyeongJo-Medium,Bold';
    } else if ((fontStyle &
            PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) !=
        0) {
      metrics.postScriptName = 'HYSMyeongJo-Medium,Italic';
    } else {
      metrics.postScriptName = 'HYSMyeongJo-Medium';
    }

    return metrics;
  }
}
