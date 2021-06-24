part of pdf;

/// Represents the standard CJK fonts.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString(
///       'こんにちは世界',
///       PdfCjkStandardFont(
///           PdfCjkFontFamily.heiseiMinchoW3, 20),
///       brush: PdfBrushes.black);
/// //Save the document.
/// List<int> bytes = document.save();
/// //Close the document.
/// document.dispose();
/// ```
class PdfCjkStandardFont extends PdfFont {
  //Constructors
  /// Initializes a new instance of the [PdfCjkStandardFont] class
  /// with font family, size and font style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'こんにちは世界',
  ///       PdfCjkStandardFont(
  ///           PdfCjkFontFamily.heiseiMinchoW3, 20),
  ///       brush: PdfBrushes.black);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfCjkStandardFont(PdfCjkFontFamily fontFamily, double size,
      {PdfFontStyle? style, List<PdfFontStyle>? multiStyle}) {
    _initialize(size, style: style, multiStyle: multiStyle);
    _fontFamily = fontFamily;
    _initializeInternals();
  }

  /// Initializes a new instance of the [PdfCjkStandardFont] class
  /// with [PdfCjkStandardFont] as prototype, size and font style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Draw the text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!',
  ///     PdfCjkStandardFont.prototype(
  ///         PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 12), 12),
  ///     brush: PdfBrushes.black);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfCjkStandardFont.protoType(PdfCjkStandardFont prototype, double size,
      {PdfFontStyle? style, List<PdfFontStyle>? multiStyle}) {
    _initialize(size, style: style, multiStyle: multiStyle);
    _fontFamily = prototype.fontFamily;
    if (style == null && (multiStyle == null || multiStyle.isEmpty)) {
      _setStyle(prototype.style, null);
    }
    _initializeInternals();
  }

  //Fields
  /// FontFamily of the font.
  PdfCjkFontFamily _fontFamily = PdfCjkFontFamily.heiseiKakuGothicW5;

  //Properties
  /// Gets the font family
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create PDF cjk font.
  /// PdfCjkStandardFont font =
  ///     PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 12);
  /// //Draw the text.
  /// document.pages.add().graphics.drawString(
  ///     '"The CJK font family name is ${font.fontFamily}', font,
  ///     brush: PdfBrushes.black);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfCjkFontFamily get fontFamily => _fontFamily;

  //_IPdfWrapper elements
  @override
  _IPdfPrimitive? get _element => _fontInternals;

  @override
  //ignore: unused_element
  set _element(_IPdfPrimitive? value) {
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
        _PdfName(_metrics!.postScriptName);

    dictionary[_DictionaryProperties.encoding] = _getEncoding(_fontFamily);
    dictionary[_DictionaryProperties.descendantFonts] = _getDescendantFont();

    return dictionary;
  }

  /// Gets the prope CJK encoding.
  static _PdfName _getEncoding(PdfCjkFontFamily? fontFamily) {
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
      default:
        break;
    }
    final _PdfName name = _PdfName(encoding);
    return name;
  }

  /// Returns descendant font.
  _PdfArray _getDescendantFont() {
    final _PdfArray df = _PdfArray();
    final _PdfCidFont cidFont = _PdfCidFont(_fontFamily, _fontStyle, _metrics!);
    df._add(cidFont);
    return df;
  }

  @override
  double _getLineWidth(String line, PdfStringFormat? format) {
    double width = 0;
    for (int i = 0; i < line.length; i++) {
      final String ch = line[i];
      final double charWidth = _getCharWidthInternal(ch);
      width += charWidth;
    }

    final double size = _metrics!._getSize(format)!;
    width *= PdfFont._characterSizeMultiplier * size;
    width = _applyFormatSettings(line, format, width);

    return width;
  }

  /// Gets the char width internal.
  double _getCharWidthInternal(String charCode) {
    int code = charCode.codeUnitAt(0);
    code = (code >= 0) ? code : 0;
    return _metrics!._widthTable![code]!.toDouble();
  }
}
