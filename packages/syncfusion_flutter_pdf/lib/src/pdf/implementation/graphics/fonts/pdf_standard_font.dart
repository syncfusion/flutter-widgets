part of pdf;

/// Represents one of the 14 standard PDF fonts.
/// It's used to create a standard PDF font to draw the text in to the PDF
class PdfStandardFont extends PdfFont {
  //Constructors
  /// Initializes a new instance of the [PdfStandardFont] class
  /// with font family, size and font style.
  PdfStandardFont(PdfFontFamily fontFamily, double size,
      {PdfFontStyle style, List<PdfFontStyle> multiStyle}) {
    _initialize(size, style: style, multiStyle: multiStyle);
    _fontFamily = fontFamily;
    _checkStyle();
    _initializeInternals();
  }

  /// Initializes a new instance of the [PdfStandardFont] class
  /// with [PdfStandardFont] as prototype, size and font style.
  PdfStandardFont.prototype(PdfStandardFont prototype, double size,
      {PdfFontStyle style, List<PdfFontStyle> multiStyle}) {
    _initialize(size, style: style, multiStyle: multiStyle);
    _fontFamily = prototype.fontFamily;
    if (style == null && (multiStyle == null || multiStyle.isEmpty)) {
      _setStyle(prototype.style, null);
    }
    _checkStyle();
    _initializeInternals();
  }

  //Fields
  /// FontFamily of the font.
  PdfFontFamily _fontFamily;

  /// First character position.
  static const int _charOffset = 32;

  //Properties
  /// Gets the font family.
  PdfFontFamily get fontFamily => _fontFamily;

  //Implementation
  /// Checks font style of the font.
  void _checkStyle() {
    if (fontFamily == PdfFontFamily.symbol ||
        fontFamily == PdfFontFamily.zapfDingbats) {
      _fontStyle &= ~(PdfFont._getPdfFontStyle(PdfFontStyle.bold) |
          PdfFont._getPdfFontStyle(PdfFontStyle.italic));
      _style = PdfFontStyle.regular;
    }
  }

  /// Initializes font internals.
  void _initializeInternals() {
    _metrics = _PdfStandardFontMetricsFactory._getMetrics(
        _fontFamily, _fontStyle, size);
    _fontInternals = _createInternals();
  }

  /// Returns width of the char.
  /// This methods doesn't takes into consideration font's size.
  double _getCharWidthInternal(String charCode) {
    int code = 0;
    code = charCode.codeUnitAt(0);
    if (PdfFont._standardFontNames.contains(name)) {
      code = code - PdfStandardFont._charOffset;
    }
    code = (code >= 0 && code != 128) ? code : 0;
    return _metrics._widthTable[code].toDouble();
  }

  /// Creates font's dictionary.
  _PdfDictionary _createInternals() {
    final _PdfDictionary dictionary = _PdfDictionary();
    dictionary[_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.font);
    dictionary[_DictionaryProperties.subtype] =
        _PdfName(_DictionaryProperties.type1);
    dictionary[_DictionaryProperties.baseFont] =
        _PdfName(_metrics.postScriptName);
    if (fontFamily != PdfFontFamily.symbol &&
        fontFamily != PdfFontFamily.zapfDingbats) {
      dictionary[_DictionaryProperties.encoding] = _PdfName('WinAnsiEncoding');
    }
    return dictionary;
  }

  /// Returns width of the line.
  @override
  double _getLineWidth(String line, [PdfStringFormat format]) {
    ArgumentError.checkNotNull(line, 'line');
    double width = 0;
    for (int i = 0; i < line.length; i++) {
      final String character = line[i];
      final double charWidth = _getCharWidthInternal(character);
      width += charWidth;
    }
    final double size = _metrics._getSize(format);
    width *= PdfFont._characterSizeMultiplier * size;
    width = _applyFormatSettings(line, format, width);
    return width;
  }

  //_IPdfWrapper elements
  @override
  _IPdfPrimitive get _element => _fontInternals;

  @override
  //ignore: unused_element
  set _element(_IPdfPrimitive value) {
    _fontInternals = value;
  }
}
