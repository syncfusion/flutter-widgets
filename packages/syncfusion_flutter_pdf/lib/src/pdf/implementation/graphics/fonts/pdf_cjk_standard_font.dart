part of pdf;

/// Represents the standard CJK fonts.
class PdfCjkStandardFont extends PdfFont {
  //Constructors
  /// Initializes a new instance of the [PdfCjkStandardFont] class
  /// with font family, size and font style.
  PdfCjkStandardFont(PdfCjkFontFamily fontFamily, double size,
      {PdfFontStyle style, List<PdfFontStyle> multiStyle}) {
    _initialize(size, style: style, multiStyle: multiStyle);
    _fontFamily = fontFamily;
    _initializeInternals();
  }

  /// Initializes a new instance of the [PdfCjkStandardFont] class
  /// with [PdfCjkStandardFont] as prototype, size and font style.
  PdfCjkStandardFont.protoType(PdfCjkStandardFont prototype, double size,
      {PdfFontStyle style, List<PdfFontStyle> multiStyle}) {
    _initialize(size, style: style, multiStyle: multiStyle);
    _fontFamily = prototype.fontFamily;
    if (style == null && (multiStyle == null || multiStyle.isEmpty)) {
      _setStyle(prototype.style, null);
    }
    _initializeInternals();
  }

  //Fields
  /// FontFamily of the font.
  PdfCjkFontFamily _fontFamily;

  //Properties
  /// Gets the font family
  PdfCjkFontFamily get fontFamily => _fontFamily;

  //_IPdfWrapper elements
  @override
  _IPdfPrimitive get _element => _fontInternals;

  @override
  //ignore: unused_element
  set _element(_IPdfPrimitive value) {
    _fontInternals = value;
  }

  void _initializeInternals() {
    _metrics = _PdfCjkStandardFontMetricsFactory._getMetrics(
        _fontFamily, _fontStyle, size);
    _fontInternals = _createInternals();
  }

  /// Creates font's dictionary.
  _PdfDictionary _createInternals() {
    final _PdfDictionary dictionary = _PdfDictionary();

    dictionary[_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.font);
    dictionary[_DictionaryProperties.subtype] =
        _PdfName(_DictionaryProperties.type0);
    dictionary[_DictionaryProperties.baseFont] =
        _PdfName(_metrics.postScriptName);

    dictionary[_DictionaryProperties.encoding] = _getEncoding(_fontFamily);
    dictionary[_DictionaryProperties.descendantFonts] = _getDescendantFont();

    return dictionary;
  }

  /// Gets the prope CJK encoding.
  static _PdfName _getEncoding(PdfCjkFontFamily fontFamily) {
    String encoding = 'Unknown';

    switch (fontFamily) {
      case PdfCjkFontFamily.hanyangSystemsGothicMedium:
      case PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium:
        encoding = 'UniKS-UCS2-H';
        break;
      case PdfCjkFontFamily.heiseiKakuGothicW5:
      case PdfCjkFontFamily.heiseiMinchoW3:
        encoding = 'UniJIS-UCS2-H';
        break;
      case PdfCjkFontFamily.monotypeHeiMedium:
      case PdfCjkFontFamily.monotypeSungLight:
        encoding = 'UniCNS-UCS2-H';
        break;
      case PdfCjkFontFamily.sinoTypeSongLight:
        encoding = 'UniGB-UCS2-H';
        break;
    }
    final _PdfName name = _PdfName(encoding);
    return name;
  }

  /// Returns descendant font.
  _PdfArray _getDescendantFont() {
    final _PdfArray df = _PdfArray();
    final _PdfCidFont cidFont = _PdfCidFont(_fontFamily, _fontStyle, _metrics);
    df._add(cidFont);
    return df;
  }

  @override
  double _getLineWidth(String line, PdfStringFormat format) {
    ArgumentError.checkNotNull(line, 'line');

    double width = 0;
    for (int i = 0; i < line.length; i++) {
      final String ch = line[i];
      final double charWidth = _getCharWidthInternal(ch);

      width += charWidth;
    }

    final double size = _metrics._getSize(format);
    width *= PdfFont._characterSizeMultiplier * size;
    width = _applyFormatSettings(line, format, width);

    return width;
  }

  /// Gets the char width internal.
  double _getCharWidthInternal(String charCode) {
    int code = charCode.codeUnitAt(0);
    code = (code >= 0) ? code : 0;
    return _metrics._widthTable[code].toDouble();
  }
}
