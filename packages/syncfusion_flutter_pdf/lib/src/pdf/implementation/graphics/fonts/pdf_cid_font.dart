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
        _PdfNumber((fontMetrics._widthTable as _CjkWidthTable).defaultWidth);
    this[_DictionaryProperties.w] = fontMetrics._widthTable!.toArray();
    this[_DictionaryProperties.fontDescriptor] =
        _PdfCjkFontDescryptorFactory.getFontDescryptor(
            fontFamily, fontStyle, fontMetrics);
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
}
