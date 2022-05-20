import '../../drawing/drawing.dart';
import '../../io/pdf_constants.dart';
import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_name.dart';
import '../../primitives/pdf_number.dart';
import '../../primitives/pdf_string.dart';
import 'enums.dart';
import 'pdf_font.dart';
import 'pdf_font_metrics.dart';

/// internal class
class PdfCidFont extends PdfDictionary {
  /// Initializes a new instance of the [PdfCidFont] class.
  PdfCidFont(PdfCjkFontFamily? fontFamily, int? fontStyle,
      PdfFontMetrics fontMetrics) {
    this[PdfDictionaryProperties.type] = PdfName(PdfDictionaryProperties.font);
    this[PdfDictionaryProperties.subtype] =
        PdfName(PdfDictionaryProperties.cidFontType2);
    this[PdfDictionaryProperties.baseFont] =
        PdfName(fontMetrics.postScriptName);
    this[PdfDictionaryProperties.dw] =
        PdfNumber((fontMetrics.widthTable! as CjkWidthTable).defaultWidth);
    this[PdfDictionaryProperties.w] = fontMetrics.widthTable!.toArray();
    this[PdfDictionaryProperties.fontDescriptor] =
        _getFontDescryptor(fontFamily, fontStyle, fontMetrics);
    this[PdfDictionaryProperties.cidSystemInfo] = _getSystemInfo(fontFamily);
  }

  /// Gets the system info.
  PdfDictionary _getSystemInfo(PdfCjkFontFamily? fontFamily) {
    final PdfDictionary sysInfo = PdfDictionary();
    sysInfo[PdfDictionaryProperties.registry] = PdfString('Adobe');
    switch (fontFamily) {
      case PdfCjkFontFamily.hanyangSystemsGothicMedium:
      case PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium:
        sysInfo[PdfDictionaryProperties.ordering] = PdfString('Korea1');
        sysInfo[PdfDictionaryProperties.supplement] = PdfNumber(1);
        break;
      case PdfCjkFontFamily.heiseiKakuGothicW5:
      case PdfCjkFontFamily.heiseiMinchoW3:
        sysInfo[PdfDictionaryProperties.ordering] = PdfString('Japan1');
        sysInfo[PdfDictionaryProperties.supplement] = PdfNumber(2);
        break;
      case PdfCjkFontFamily.monotypeHeiMedium:
      case PdfCjkFontFamily.monotypeSungLight:
        sysInfo[PdfDictionaryProperties.ordering] = PdfString('CNS1');
        sysInfo[PdfDictionaryProperties.supplement] = PdfNumber(0);
        break;
      case PdfCjkFontFamily.sinoTypeSongLight:
        sysInfo[PdfDictionaryProperties.ordering] = PdfString('GB1');
        sysInfo[PdfDictionaryProperties.supplement] = PdfNumber(2);
        break;
      // ignore: no_default_cases
      default:
        break;
    }
    return sysInfo;
  }

  /// internal method
  PdfDictionary _getFontDescryptor(PdfCjkFontFamily? fontFamily, int? fontStyle,
      PdfFontMetrics fontMetrics) {
    final PdfDictionary fontDescryptor = PdfDictionary();
    switch (fontFamily) {
      case PdfCjkFontFamily.hanyangSystemsGothicMedium:
        _fillHanyangSystemsGothicMedium(
            fontDescryptor, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium:
        _fillHanyangSystemsShinMyeongJoMedium(
            fontDescryptor, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.heiseiKakuGothicW5:
        _fillHanyangSystemsGothicMediumWithStyle(
            fontDescryptor, fontStyle!, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.heiseiMinchoW3:
        _fillHeiseiMinchoW3(fontDescryptor, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.monotypeHeiMedium:
        _fillMonotypeHeiMedium(fontDescryptor, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.monotypeSungLight:
        _fillMonotypeSungLight(fontDescryptor, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.sinoTypeSongLight:
        _fillSinoTypeSongLight(fontDescryptor, fontFamily, fontMetrics);
        break;
      // ignore: no_default_cases
      default:
        break;
    }
    return fontDescryptor;
  }

  /// Fills the monotype sung light font descryptor.
  void _fillMonotypeSungLight(PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, PdfFontMetrics fontMetrics) {
    final PdfRectangle fontBBox = PdfRectangle(-160, -249, 1175, 1137);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final PdfNumber stem = PdfNumber(93);
    fontDescryptor[PdfDictionaryProperties.stemV] = stem;
    fontDescryptor[PdfDictionaryProperties.stemH] = stem;
    final PdfNumber width = PdfNumber(1000);
    fontDescryptor[PdfDictionaryProperties.avgWidth] = width;
    fontDescryptor[PdfDictionaryProperties.maxWidth] = width;
    fontDescryptor[PdfDictionaryProperties.capHeight] = PdfNumber(880);
    fontDescryptor[PdfDictionaryProperties.xHeight] = PdfNumber(616);
    fontDescryptor[PdfDictionaryProperties.leading] = PdfNumber(250);
  }

  /// Fills the hanyang systems shin myeong jo medium font descryptor.
  void _fillHanyangSystemsShinMyeongJoMedium(PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, PdfFontMetrics fontMetrics) {
    final PdfRectangle fontBBox = PdfRectangle(0, -148, 1001, 1028);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final PdfNumber stem = PdfNumber(93);
    fontDescryptor[PdfDictionaryProperties.stemV] = stem;
    fontDescryptor[PdfDictionaryProperties.stemH] = stem;
    final PdfNumber width = PdfNumber(1000);
    fontDescryptor[PdfDictionaryProperties.avgWidth] = width;
    fontDescryptor[PdfDictionaryProperties.maxWidth] = width;
    fontDescryptor[PdfDictionaryProperties.capHeight] = PdfNumber(880);
    fontDescryptor[PdfDictionaryProperties.xHeight] = PdfNumber(616);
    fontDescryptor[PdfDictionaryProperties.leading] = PdfNumber(250);
  }

  /// Fills the heisei mincho w3 font descryptor.
  void _fillHeiseiMinchoW3(PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, PdfFontMetrics fontMetrics) {
    final PdfRectangle fontBBox = PdfRectangle(-123, -257, 1124, 1167);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final PdfNumber stem = PdfNumber(93);
    fontDescryptor[PdfDictionaryProperties.stemV] = stem;
    fontDescryptor[PdfDictionaryProperties.stemH] = stem;
    final PdfNumber width = PdfNumber(1000);
    fontDescryptor[PdfDictionaryProperties.avgWidth] = PdfNumber(702);
    fontDescryptor[PdfDictionaryProperties.maxWidth] = width;
    fontDescryptor[PdfDictionaryProperties.capHeight] = PdfNumber(718);
    fontDescryptor[PdfDictionaryProperties.xHeight] = PdfNumber(500);
    fontDescryptor[PdfDictionaryProperties.leading] = PdfNumber(250);
  }

  /// Fills the sino type song light font descryptor.
  void _fillSinoTypeSongLight(PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, PdfFontMetrics fontMetrics) {
    final PdfRectangle fontBBox = PdfRectangle(-25, -254, 1025, 1134);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final PdfNumber stem = PdfNumber(93);
    fontDescryptor[PdfDictionaryProperties.stemV] = stem;
    fontDescryptor[PdfDictionaryProperties.stemH] = stem;
    final PdfNumber width = PdfNumber(1000);
    fontDescryptor[PdfDictionaryProperties.avgWidth] = width;
    fontDescryptor[PdfDictionaryProperties.maxWidth] = width;
    fontDescryptor[PdfDictionaryProperties.capHeight] = PdfNumber(880);
    fontDescryptor[PdfDictionaryProperties.xHeight] = PdfNumber(616);
    fontDescryptor[PdfDictionaryProperties.leading] = PdfNumber(250);
  }

  /// Fills the monotype hei medium font descryptor.
  void _fillMonotypeHeiMedium(PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, PdfFontMetrics fontMetrics) {
    final PdfRectangle fontBBox = PdfRectangle(-45, -250, 1060, 1137);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final PdfNumber stem = PdfNumber(93);
    fontDescryptor[PdfDictionaryProperties.stemV] = stem;
    fontDescryptor[PdfDictionaryProperties.stemH] = stem;
    final PdfNumber width = PdfNumber(1000);
    fontDescryptor[PdfDictionaryProperties.avgWidth] = width;
    fontDescryptor[PdfDictionaryProperties.maxWidth] = width;
    fontDescryptor[PdfDictionaryProperties.capHeight] = PdfNumber(880);
    fontDescryptor[PdfDictionaryProperties.xHeight] = PdfNumber(616);
    fontDescryptor[PdfDictionaryProperties.leading] = PdfNumber(250);
  }

  /// Fills the hanyang systems gothic medium font descryptor.
  void _fillHanyangSystemsGothicMedium(PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, PdfFontMetrics fontMetrics) {
    final PdfRectangle fontBBox = PdfRectangle(-6, -145, 1009, 1025);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    fontDescryptor[PdfDictionaryProperties.flags] = PdfNumber(4);
    final PdfNumber stem = PdfNumber(93);
    fontDescryptor[PdfDictionaryProperties.stemV] = stem;
    fontDescryptor[PdfDictionaryProperties.stemH] = stem;
    final PdfNumber width = PdfNumber(1000);
    fontDescryptor[PdfDictionaryProperties.avgWidth] = width;
    fontDescryptor[PdfDictionaryProperties.maxWidth] = width;
    fontDescryptor[PdfDictionaryProperties.capHeight] = PdfNumber(880);
    fontDescryptor[PdfDictionaryProperties.xHeight] = PdfNumber(616);
    fontDescryptor[PdfDictionaryProperties.leading] = PdfNumber(250);
  }

  /// Fills the heisei kaku gothic w5 font descryptor.
  void _fillHanyangSystemsGothicMediumWithStyle(PdfDictionary fontDescryptor,
      int fontStyle, PdfCjkFontFamily? fontFamily, PdfFontMetrics fontMetrics) {
    final PdfRectangle fontBBox = PdfRectangle(-92, -250, 1102, 1175);
    final PdfRectangle fontBBoxI = PdfRectangle(-92, -250, 1102, 1932);
    if ((fontStyle &
            (PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic) |
                PdfFontHelper.getPdfFontStyle(PdfFontStyle.bold))) !=
        PdfFontHelper.getPdfFontStyle(PdfFontStyle.italic)) {
      _fillFontBBox(fontDescryptor, fontBBox);
    } else {
      _fillFontBBox(fontDescryptor, fontBBoxI);
    }
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final PdfNumber stem = PdfNumber(93);
    fontDescryptor[PdfDictionaryProperties.stemV] = stem;
    fontDescryptor[PdfDictionaryProperties.stemH] = stem;
    final PdfNumber width = PdfNumber(1000);
    fontDescryptor[PdfDictionaryProperties.avgWidth] = PdfNumber(689);
    fontDescryptor[PdfDictionaryProperties.maxWidth] = width;
    fontDescryptor[PdfDictionaryProperties.capHeight] = PdfNumber(718);
    fontDescryptor[PdfDictionaryProperties.xHeight] = PdfNumber(500);
    fontDescryptor[PdfDictionaryProperties.leading] = PdfNumber(250);
  }

  /// Fills the known info.
  void _fillKnownInfo(PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, PdfFontMetrics fontMetrics) {
    fontDescryptor[PdfDictionaryProperties.fontName] =
        PdfName(fontMetrics.postScriptName);
    fontDescryptor[PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.fontDescriptor);
    fontDescryptor[PdfDictionaryProperties.italicAngle] = PdfNumber(0);
    fontDescryptor[PdfDictionaryProperties.missingWidth] =
        PdfNumber((fontMetrics.widthTable! as CjkWidthTable).defaultWidth);
    fontDescryptor[PdfDictionaryProperties.ascent] =
        PdfNumber(fontMetrics.ascent);
    fontDescryptor[PdfDictionaryProperties.descent] =
        PdfNumber(fontMetrics.descent);
    _fillFlags(fontDescryptor, fontFamily);
  }

  /// Fills the flags.
  void _fillFlags(PdfDictionary fontDescryptor, PdfCjkFontFamily? fontFamily) {
    switch (fontFamily) {
      case PdfCjkFontFamily.monotypeHeiMedium:
      case PdfCjkFontFamily.hanyangSystemsGothicMedium:
      case PdfCjkFontFamily.heiseiKakuGothicW5:
        fontDescryptor[PdfDictionaryProperties.flags] = PdfNumber(4);
        break;
      case PdfCjkFontFamily.sinoTypeSongLight:
      case PdfCjkFontFamily.monotypeSungLight:
      case PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium:
      case PdfCjkFontFamily.heiseiMinchoW3:
        fontDescryptor[PdfDictionaryProperties.flags] = PdfNumber(6);
        break;
      // ignore: no_default_cases
      default:
        break;
    }
  }

  /// Fills the font BBox.
  void _fillFontBBox(PdfDictionary fontDescryptor, PdfRectangle fontBBox) {
    fontDescryptor[PdfDictionaryProperties.fontBBox] =
        PdfArray.fromRectangle(fontBBox);
  }
}
