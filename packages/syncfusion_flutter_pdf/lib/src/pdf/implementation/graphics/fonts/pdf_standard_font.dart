part of pdf;

/// Represents one of the 14 standard PDF fonts.
/// It's used to create a standard PDF font to draw the text in to the PDF
///
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString(
///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
///       brush: PdfBrushes.black);
/// //Save the document.
/// List<int> bytes = document.save();
/// //Close the document.
/// document.dispose();
/// ```
class PdfStandardFont extends PdfFont {
  //Constructors
  /// Initializes a new instance of the [PdfStandardFont] class
  /// with font family, size and font style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       brush: PdfBrushes.black);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfStandardFont(PdfFontFamily fontFamily, double size,
      {PdfFontStyle? style, List<PdfFontStyle>? multiStyle}) {
    _initialize(size, style: style, multiStyle: multiStyle);
    _fontFamily = fontFamily;
    _checkStyle();
    _initializeInternals();
  }

  /// Initializes a new instance of the [PdfStandardFont] class
  /// with [PdfStandardFont] as prototype, size and font style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create PDF standard font.
  /// PdfFont font = PdfStandardFont.prototype(
  ///     PdfStandardFont(PdfFontFamily.helvetica, 12), 12);
  /// //Draw the text.
  /// document.pages.add().graphics.drawString(
  ///     'The font family name is ${font.fontFamily}', font,
  ///     brush: PdfBrushes.black);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfStandardFont.prototype(PdfStandardFont prototype, double size,
      {PdfFontStyle? style, List<PdfFontStyle>? multiStyle}) {
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
  PdfFontFamily _fontFamily = PdfFontFamily.helvetica;

  /// First character position.
  static const int _charOffset = 32;

  //Properties
  /// Gets the font family.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create PDF standard font.
  /// PdfStandardFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// //Draw the text.
  /// document.pages.add().graphics.drawString(
  ///     'The font family name is ${font.fontFamily}', font,
  ///     brush: PdfBrushes.black);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfFontFamily get fontFamily => _fontFamily;
  List<String>? _windows1252MapTable;

  List<String>? get _windowsMapTable {
    _windows1252MapTable ??= <String>[
      '\u0000',
      '\u0001',
      '\u0002',
      '\u0003',
      '\u0004',
      '\u0005',
      '\u0006',
      '\u0007',
      '\b',
      '\t',
      '\n',
      '\v',
      '\f',
      '\r',
      '\u000e',
      '\u000f',
      '\u0010',
      '\u0011',
      '\u0012',
      '\u0013',
      '\u0014',
      '\u0015',
      '\u0016',
      '\u0017',
      '\u0018',
      '\u0019',
      '\u001a',
      '\u001b',
      '\u001c',
      '\u001d',
      '\u001e',
      '\u001f',
      ' ',
      '!',
      '"',
      '#',
      r'$',
      '%',
      '&',
      '\'',
      '(',
      ')',
      '*',
      '+',
      ',',
      '-',
      '.',
      '/',
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      ':',
      ';',
      '<',
      '=',
      '>',
      '?',
      '@',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      '[',
      r'\',
      ']',
      '^',
      '_',
      '`',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
      '{',
      '|',
      '}',
      '~',
      '\u007f',
      '€',
      '\u0081',
      '‚',
      'ƒ',
      '„',
      '…',
      '†',
      '‡',
      'ˆ',
      '‰',
      'Š',
      '‹',
      'Œ',
      '\u008d',
      'Ž',
      '\u008f',
      '\u0090',
      '‘',
      '’',
      '“',
      '”',
      '•',
      '–',
      '—',
      '˜',
      '™',
      'š',
      '›',
      'œ',
      '\u009d',
      'ž',
      'Ÿ',
      ' ',
      '¡',
      '¢',
      '£',
      '¤',
      '¥',
      '¦',
      '§',
      '¨',
      '©',
      'ª',
      '«',
      '¬',
      '­',
      '®',
      '¯',
      '°',
      '±',
      '²',
      '³',
      '´',
      'µ',
      '¶',
      '·',
      '¸',
      '¹',
      'º',
      '»',
      '¼',
      '½',
      '¾',
      '¿',
      'À',
      'Á',
      'Â',
      'Ã',
      'Ä',
      'Å',
      'Æ',
      'Ç',
      'È',
      'É',
      'Ê',
      'Ë',
      'Ì',
      'Í',
      'Î',
      'Ï',
      'Ð',
      'Ñ',
      'Ò',
      'Ó',
      'Ô',
      'Õ',
      'Ö',
      '×',
      'Ø',
      'Ù',
      'Ú',
      'Û',
      'Ü',
      'Ý',
      'Þ',
      'ß',
      'à',
      'á',
      'â',
      'ã',
      'ä',
      'å',
      'æ',
      'ç',
      'è',
      'é',
      'ê',
      'ë',
      'ì',
      'í',
      'î',
      'ï',
      'ð',
      'ñ',
      'ò',
      'ó',
      'ô',
      'õ',
      'ö',
      '÷',
      'ø',
      'ú',
      'û',
      'ü',
      'ý',
      'þ',
      'ÿ'
    ];
    return _windows1252MapTable;
  }

  //Implementation
  /// Checks font style of the font.
  void _checkStyle() {
    if (fontFamily == PdfFontFamily.symbol ||
        fontFamily == PdfFontFamily.zapfDingbats) {
      _fontStyle = _fontStyle &
          ~(PdfFont._getPdfFontStyle(PdfFontStyle.bold) |
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
    if (code >= 256 && _windowsMapTable!.contains(charCode)) {
      code = _windowsMapTable!.indexOf(charCode);
    }
    if (PdfFont._standardFontNames.contains(name)) {
      code = code - PdfStandardFont._charOffset;
    }
    code = (code >= 0 && code != 128) ? code : 0;
    return _metrics!._widthTable![code]!.toDouble();
  }

  /// Creates font's dictionary.
  _PdfDictionary _createInternals() {
    final _PdfDictionary dictionary = _PdfDictionary();
    dictionary[_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.font);
    dictionary[_DictionaryProperties.subtype] =
        _PdfName(_DictionaryProperties.type1);
    dictionary[_DictionaryProperties.baseFont] =
        _PdfName(_metrics!.postScriptName);
    if (fontFamily != PdfFontFamily.symbol &&
        fontFamily != PdfFontFamily.zapfDingbats) {
      dictionary[_DictionaryProperties.encoding] = _PdfName('WinAnsiEncoding');
    }
    return dictionary;
  }

  /// Returns width of the line.
  @override
  double _getLineWidth(String line, [PdfStringFormat? format]) {
    double width = 0;
    for (int i = 0; i < line.length; i++) {
      final String character = line[i];
      final double charWidth = _getCharWidthInternal(character);
      width += charWidth;
    }
    final double size = _metrics!._getSize(format)!;
    width *= PdfFont._characterSizeMultiplier * size;
    width = _applyFormatSettings(line, format, width);
    return width;
  }

  //_IPdfWrapper elements
  @override
  _IPdfPrimitive? get _element => _fontInternals;

  @override
  //ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _fontInternals = value;
  }
}
