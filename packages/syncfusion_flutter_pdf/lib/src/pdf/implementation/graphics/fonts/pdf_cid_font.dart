part of pdf;

class _PdfCidFont extends _PdfDictionary {
  /// Initializes a new instance of the [_PdfCidFont] class.
  _PdfCidFont(PdfCjkFontFamily? fontFamily, int? fontStyle,
      _PdfFontMetrics fontMetrics) {
    this[_DictionaryProperties.type] = _PdfName(_DictionaryProperties.font);
    this[_DictionaryProperties.subtype] =
        _PdfName(_DictionaryProperties.cidFontType2);
    this[_DictionaryProperties.baseFont] = _PdfName(fontMetrics.postScriptName);
    this[_DictionaryProperties.dw] =
        _PdfNumber((fontMetrics._widthTable! as _CjkWidthTable).defaultWidth);
    this[_DictionaryProperties.w] = fontMetrics._widthTable!.toArray();
    this[_DictionaryProperties.fontDescriptor] =
        _getFontDescryptor(fontFamily, fontStyle, fontMetrics);
    this[_DictionaryProperties.cidSystemInfo] = _getSystemInfo(fontFamily);
  }

  /// Gets the system info.
  _PdfDictionary _getSystemInfo(PdfCjkFontFamily? fontFamily) {
    final _PdfDictionary sysInfo = _PdfDictionary();
    sysInfo[_DictionaryProperties.registry] = _PdfString('Adobe');
    switch (fontFamily) {
      case PdfCjkFontFamily.hanyangSystemsGothicMedium:
      case PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium:
        sysInfo[_DictionaryProperties.ordering] = _PdfString('Korea1');
        sysInfo[_DictionaryProperties.supplement] = _PdfNumber(1);
        break;
      case PdfCjkFontFamily.heiseiKakuGothicW5:
      case PdfCjkFontFamily.heiseiMinchoW3:
        sysInfo[_DictionaryProperties.ordering] = _PdfString('Japan1');
        sysInfo[_DictionaryProperties.supplement] = _PdfNumber(2);
        break;
      case PdfCjkFontFamily.monotypeHeiMedium:
      case PdfCjkFontFamily.monotypeSungLight:
        sysInfo[_DictionaryProperties.ordering] = _PdfString('CNS1');
        sysInfo[_DictionaryProperties.supplement] = _PdfNumber(0);
        break;
      case PdfCjkFontFamily.sinoTypeSongLight:
        sysInfo[_DictionaryProperties.ordering] = _PdfString('GB1');
        sysInfo[_DictionaryProperties.supplement] = _PdfNumber(2);
        break;
      default:
        break;
    }
    return sysInfo;
  }

  _PdfDictionary _getFontDescryptor(PdfCjkFontFamily? fontFamily,
      int? fontStyle, _PdfFontMetrics fontMetrics) {
    final _PdfDictionary fontDescryptor = _PdfDictionary();
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
        _fillHeiseiKakuGothicW5(
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
      default:
        break;
    }
    return fontDescryptor;
  }

  /// Fills the monotype sung light font descryptor.
  void _fillMonotypeSungLight(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-160, -249, 1175, 1137);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
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
  void _fillHeiseiKakuGothicW5(_PdfDictionary fontDescryptor, int fontStyle,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-92, -250, 1102, 1175);
    final _Rectangle fontBBoxI = _Rectangle(-92, -250, 1102, 1932);
    if ((fontStyle &
            (PdfFont._getPdfFontStyle(PdfFontStyle.italic) |
                PdfFont._getPdfFontStyle(PdfFontStyle.bold))) !=
        PdfFont._getPdfFontStyle(PdfFontStyle.italic)) {
      _fillFontBBox(fontDescryptor, fontBBox);
    } else {
      _fillFontBBox(fontDescryptor, fontBBoxI);
    }
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
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
  void _fillHanyangSystemsShinMyeongJoMedium(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(0, -148, 1001, 1028);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
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
  void _fillHeiseiMinchoW3(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-123, -257, 1124, 1167);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
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
  void _fillSinoTypeSongLight(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-25, -254, 1025, 1134);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
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
  void _fillMonotypeHeiMedium(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-45, -250, 1060, 1137);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
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
  void _fillHanyangSystemsGothicMedium(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    final _Rectangle fontBBox = _Rectangle(-6, -145, 1009, 1025);
    _fillFontBBox(fontDescryptor, fontBBox);
    _fillKnownInfo(fontDescryptor, fontFamily, fontMetrics);
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
  void _fillKnownInfo(_PdfDictionary fontDescryptor,
      PdfCjkFontFamily? fontFamily, _PdfFontMetrics fontMetrics) {
    fontDescryptor[_DictionaryProperties.fontName] =
        _PdfName(fontMetrics.postScriptName);
    fontDescryptor[_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.fontDescriptor);
    fontDescryptor[_DictionaryProperties.italicAngle] = _PdfNumber(0);
    fontDescryptor[_DictionaryProperties.missingWidth] =
        _PdfNumber((fontMetrics._widthTable! as _CjkWidthTable).defaultWidth);
    fontDescryptor[_DictionaryProperties.ascent] =
        _PdfNumber(fontMetrics.ascent);
    fontDescryptor[_DictionaryProperties.descent] =
        _PdfNumber(fontMetrics.descent);
    _fillFlags(fontDescryptor, fontFamily);
  }

  /// Fills the flags.
  void _fillFlags(_PdfDictionary fontDescryptor, PdfCjkFontFamily? fontFamily) {
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
  void _fillFontBBox(_PdfDictionary fontDescryptor, _Rectangle fontBBox) {
    fontDescryptor[_DictionaryProperties.fontBBox] =
        _PdfArray.fromRectangle(fontBBox);
  }
}
