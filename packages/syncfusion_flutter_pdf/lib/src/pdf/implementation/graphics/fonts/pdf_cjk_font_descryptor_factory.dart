part of pdf;

class _PdfCjkFontDescryptorFactory {
  static _PdfDictionary getFontDescryptor(PdfCjkFontFamily? fontFamily,
      int? fontStyle, _PdfFontMetrics fontMetrics) {
    final _PdfDictionary fontDescryptor = _PdfDictionary();
    switch (fontFamily) {
      case PdfCjkFontFamily.hanyangSystemsGothicMedium:
        fillHanyangSystemsGothicMedium(fontDescryptor, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium:
        fillHanyangSystemsShinMyeongJoMedium(
            fontDescryptor, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.heiseiKakuGothicW5:
        fillHeiseiKakuGothicW5(
            fontDescryptor, fontStyle!, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.heiseiMinchoW3:
        fillHeiseiMinchoW3(fontDescryptor, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.monotypeHeiMedium:
        fillMonotypeHeiMedium(fontDescryptor, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.monotypeSungLight:
        fillMonotypeSungLight(fontDescryptor, fontFamily, fontMetrics);
        break;
      case PdfCjkFontFamily.sinoTypeSongLight:
        fillSinoTypeSongLight(fontDescryptor, fontFamily, fontMetrics);
        break;
      default:
        break;
    }
    return fontDescryptor;
  }

  /// Fills the monotype sung light font descryptor.
  static void fillMonotypeSungLight(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-160, -249, 1175, 1137);
    fillFontBBox(fontDescryptor, fontBBox);
    fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final _PdfNumber stem = _PdfNumber(93);
    fontDescryptor[_DictionaryProperties.stemV] = stem;
    fontDescryptor[_DictionaryProperties.stemH] = stem;
    final _PdfNumber width = _PdfNumber(1000);
    fontDescryptor[_DictionaryProperties.avgWidth] = width;
    fontDescryptor[_DictionaryProperties.maxWidth] = width;
    fontDescryptor[_DictionaryProperties.capHeight] = _PdfNumber(880);
    fontDescryptor[_DictionaryProperties.xHeight] = _PdfNumber(616);
    fontDescryptor[_DictionaryProperties.leading] = _PdfNumber(250);
  }

  /// Fills the heisei kaku gothic w5 font descryptor.
  static void fillHeiseiKakuGothicW5(
      _PdfDictionary fontDescryptor,
      int fontStyle,
      PdfCjkFontFamily? fontFamily,
      _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-92, -250, 1102, 1175);
    final _Rectangle fontBBoxI = _Rectangle(-92, -250, 1102, 1932);
    if ((fontStyle &
            (PdfFont._getPdfFontStyle(PdfFontStyle.italic) |
                PdfFont._getPdfFontStyle(PdfFontStyle.bold))) !=
        PdfFont._getPdfFontStyle(PdfFontStyle.italic)) {
      fillFontBBox(fontDescryptor, fontBBox);
    } else {
      fillFontBBox(fontDescryptor, fontBBoxI);
    }
    fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final _PdfNumber stem = _PdfNumber(93);
    fontDescryptor[_DictionaryProperties.stemV] = stem;
    fontDescryptor[_DictionaryProperties.stemH] = stem;
    final _PdfNumber width = _PdfNumber(1000);
    fontDescryptor[_DictionaryProperties.avgWidth] = _PdfNumber(689);
    fontDescryptor[_DictionaryProperties.maxWidth] = width;
    fontDescryptor[_DictionaryProperties.capHeight] = _PdfNumber(718);
    fontDescryptor[_DictionaryProperties.xHeight] = _PdfNumber(500);
    fontDescryptor[_DictionaryProperties.leading] = _PdfNumber(250);
  }

  /// Fills the hanyang systems shin myeong jo medium font descryptor.
  static void fillHanyangSystemsShinMyeongJoMedium(
      _PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily,
      _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(0, -148, 1001, 1028);
    fillFontBBox(fontDescryptor, fontBBox);
    fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final _PdfNumber stem = _PdfNumber(93);
    fontDescryptor[_DictionaryProperties.stemV] = stem;
    fontDescryptor[_DictionaryProperties.stemH] = stem;
    final _PdfNumber width = _PdfNumber(1000);
    fontDescryptor[_DictionaryProperties.avgWidth] = width;
    fontDescryptor[_DictionaryProperties.maxWidth] = width;
    fontDescryptor[_DictionaryProperties.capHeight] = _PdfNumber(880);
    fontDescryptor[_DictionaryProperties.xHeight] = _PdfNumber(616);
    fontDescryptor[_DictionaryProperties.leading] = _PdfNumber(250);
  }

  /// Fills the heisei mincho w3 font descryptor.
  static void fillHeiseiMinchoW3(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-123, -257, 1124, 1167);
    fillFontBBox(fontDescryptor, fontBBox);
    fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final _PdfNumber stem = _PdfNumber(93);
    fontDescryptor[_DictionaryProperties.stemV] = stem;
    fontDescryptor[_DictionaryProperties.stemH] = stem;
    final _PdfNumber width = _PdfNumber(1000);
    fontDescryptor[_DictionaryProperties.avgWidth] = _PdfNumber(702);
    fontDescryptor[_DictionaryProperties.maxWidth] = width;
    fontDescryptor[_DictionaryProperties.capHeight] = _PdfNumber(718);
    fontDescryptor[_DictionaryProperties.xHeight] = _PdfNumber(500);
    fontDescryptor[_DictionaryProperties.leading] = _PdfNumber(250);
  }

  /// Fills the sino type song light font descryptor.
  static void fillSinoTypeSongLight(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-25, -254, 1025, 1134);
    fillFontBBox(fontDescryptor, fontBBox);
    fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final _PdfNumber stem = _PdfNumber(93);
    fontDescryptor[_DictionaryProperties.stemV] = stem;
    fontDescryptor[_DictionaryProperties.stemH] = stem;
    final _PdfNumber width = _PdfNumber(1000);
    fontDescryptor[_DictionaryProperties.avgWidth] = width;
    fontDescryptor[_DictionaryProperties.maxWidth] = width;
    fontDescryptor[_DictionaryProperties.capHeight] = _PdfNumber(880);
    fontDescryptor[_DictionaryProperties.xHeight] = _PdfNumber(616);
    fontDescryptor[_DictionaryProperties.leading] = _PdfNumber(250);
  }

  /// Fills the monotype hei medium font descryptor.
  static void fillMonotypeHeiMedium(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-45, -250, 1060, 1137);
    fillFontBBox(fontDescryptor, fontBBox);
    fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    final _PdfNumber stem = _PdfNumber(93);
    fontDescryptor[_DictionaryProperties.stemV] = stem;
    fontDescryptor[_DictionaryProperties.stemH] = stem;
    final _PdfNumber width = _PdfNumber(1000);
    fontDescryptor[_DictionaryProperties.avgWidth] = width;
    fontDescryptor[_DictionaryProperties.maxWidth] = width;
    fontDescryptor[_DictionaryProperties.capHeight] = _PdfNumber(880);
    fontDescryptor[_DictionaryProperties.xHeight] = _PdfNumber(616);
    fontDescryptor[_DictionaryProperties.leading] = _PdfNumber(250);
  }

  /// Fills the hanyang systems gothic medium font descryptor.
  static void fillHanyangSystemsGothicMedium(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-6, -145, 1009, 1025);
    fillFontBBox(fontDescryptor, fontBBox);
    fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
    fontDescryptor[_DictionaryProperties.flags] = _PdfNumber(4);
    final _PdfNumber stem = _PdfNumber(93);
    fontDescryptor[_DictionaryProperties.stemV] = stem;
    fontDescryptor[_DictionaryProperties.stemH] = stem;
    final _PdfNumber width = _PdfNumber(1000);
    fontDescryptor[_DictionaryProperties.avgWidth] = width;
    fontDescryptor[_DictionaryProperties.maxWidth] = width;
    fontDescryptor[_DictionaryProperties.capHeight] = _PdfNumber(880);
    fontDescryptor[_DictionaryProperties.xHeight] = _PdfNumber(616);
    fontDescryptor[_DictionaryProperties.leading] = _PdfNumber(250);
  }

  /// Fills the known info.
  static void fillKnownInfo(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    fontDescryptor[_DictionaryProperties.fontName] =
        _PdfName(fontMetrics.postScriptName);
    fontDescryptor[_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.fontDescriptor);
    fontDescryptor[_DictionaryProperties.italicAngle] = _PdfNumber(0);
    fontDescryptor[_DictionaryProperties.missingWidth] =
        _PdfNumber((fontMetrics._widthTable as _CjkWidthTable).defaultWidth);
    fontDescryptor[_DictionaryProperties.ascent] =
        _PdfNumber(fontMetrics.ascent);
    fontDescryptor[_DictionaryProperties.descent] =
        _PdfNumber(fontMetrics.descent);
    fillFlags(fontDescryptor, fontFamily);
  }

  /// Fills the flags.
  static void fillFlags(
      _PdfDictionary fontDescryptor, PdfCjkFontFamily? fontFamily) {
    switch (fontFamily) {
      case PdfCjkFontFamily.monotypeHeiMedium:
      case PdfCjkFontFamily.hanyangSystemsGothicMedium:
      case PdfCjkFontFamily.heiseiKakuGothicW5:
        fontDescryptor[_DictionaryProperties.flags] = _PdfNumber(4);
        break;
      case PdfCjkFontFamily.sinoTypeSongLight:
      case PdfCjkFontFamily.monotypeSungLight:
      case PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium:
      case PdfCjkFontFamily.heiseiMinchoW3:
        fontDescryptor[_DictionaryProperties.flags] = _PdfNumber(6);
        break;
      default:
        break;
    }
  }

  /// Fills the font BBox.
  static void fillFontBBox(_PdfDictionary fontDescryptor, _Rectangle fontBBox) {
    fontDescryptor[_DictionaryProperties.fontBBox] =
        _PdfArray.fromRectangle(fontBBox);
  }
}
