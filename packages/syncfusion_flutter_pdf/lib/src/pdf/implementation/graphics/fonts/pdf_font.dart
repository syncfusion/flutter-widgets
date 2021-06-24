part of pdf;

/// Defines a particular format for text, including font face, size,
/// and style attributes.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString('Hello World!',
///       PdfStandardFont(PdfFontFamily.helvetica, 12),
///       brush: PdfBrushes.black);
/// //Save the document.
/// List<int> bytes = document.save();
/// //Close the document.
/// document.dispose();
/// ```
abstract class PdfFont implements _IPdfWrapper {
  //Constants
  static const double _characterSizeMultiplier = 0.001;
  static const List<String> _standardFontNames = <String>[
    'Helvetica',
    'courier',
    'TimesRoman',
    'Symbol',
    'ZapfDingbats'
  ];
  static const List<String> _standardCjkFontNames = <String>[
    'HanyangSystemsGothicMedium',
    'HanyangSystemsShinMyeongJoMedium',
    'HeiseiKakuGothicW5',
    'HeiseiMinchoW3',
    'MonotypeHeiMedium',
    'MonotypeSungLight',
    'SinoTypeSongLight'
  ];

  //Fields
  //Size of the font.
  late double _size;

  //Metrics of the font.
  _PdfFontMetrics? _metrics;

  //PDF primitive of the font.
  _IPdfPrimitive? _fontInternals;

  //Number format of [PdfFontStyle].
  int _fontStyle = 0;

  PdfFontStyle _style = PdfFontStyle.regular;

  //Properties
  /// Gets style of the font.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF font instance.
  /// PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// //Draw string to PDF page.
  /// document.pages.add().graphics.drawString(
  ///     'Font Name: ${font.name}\nFont Size: ${font.size}\nFont Height: ${font.height}\nFont Style: ${font.style}',
  ///     font);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfFontStyle get style => _style;

  /// Gets the font name.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF font instance.
  /// PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// //Draw string to PDF page.
  /// document.pages.add().graphics.drawString(
  ///     'Font Name: ${font.name}\nFont Size: ${font.size}\nFont Height: ${font.height}\nFont Style: ${font.style}',
  ///     font);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  String get name => _metrics!.name;

  /// Gets the font size.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF font instance.
  /// PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// //Draw string to PDF page.
  /// document.pages.add().graphics.drawString(
  ///     'Font Name: ${font.name}\nFont Size: ${font.size}\nFont Height: ${font.height}\nFont Style: ${font.style}',
  ///     font);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  double get size => _size;

  /// Gets the height of the font in points.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF font instance.
  /// PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// //Draw string to PDF page.
  /// document.pages.add().graphics.drawString(
  ///     'Font Name: ${font.name}\nFont Size: ${font.size}\nFont Height: ${font.height}\nFont Style: ${font.style}',
  ///     font);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  double get height => _metrics!._getHeight(null);

  //ignore:unused_element
  bool get _isUnderline =>
      _fontStyle & _getPdfFontStyle(PdfFontStyle.underline) > 0;
  //ignore:unused_element
  bool get _isStrikeout =>
      _fontStyle & _getPdfFontStyle(PdfFontStyle.strikethrough) > 0;

  //Public methods
  /// Measures a string by using this font.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Add a page to the document.
  /// PdfPage page = document.pages.add();
  /// //Create PDF graphics for the page.
  /// PdfGraphics graphics = page.graphics;
  /// //Create a new PDF font instance.
  /// PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// String text = "Hello World!";
  /// //Measure the text.
  /// Size size = font.measureString(text);
  /// //Draw string to PDF page.
  /// graphics.drawString(text, font,
  ///     brush: PdfBrushes.black,
  ///     bounds: Rect.fromLTWH(0, 0, size.width, size.height));
  /// //Saves the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Size measureString(String text, {Size? layoutArea, PdfStringFormat? format}) {
    layoutArea ??= const Size(0, 0);
    final _PdfStringLayouter layouter = _PdfStringLayouter();
    final _PdfStringLayoutResult result = layouter._layout(text, this, format,
        width: layoutArea.width, height: layoutArea.height);
    return result._size.size;
  }

  //Implementation
  /// Initializes a new instance of the [PdfFont] class
  /// with font size and style.
  void _initialize(double size,
      {PdfFontStyle? style, List<PdfFontStyle>? multiStyle}) {
    _setSize(size);
    _setStyle(style, multiStyle);
  }

  ///Sets the style.
  void _setStyle(PdfFontStyle? style, List<PdfFontStyle>? multiStyle) {
    if (style != null) {
      _style = style;
      _fontStyle = _getPdfFontStyle(style);
    }
    if (multiStyle != null && multiStyle.isNotEmpty) {
      for (int i = 0; i < multiStyle.length; i++) {
        _fontStyle = _fontStyle | _getPdfFontStyle(multiStyle[i]);
      }
    } else if (style == null) {
      _style = PdfFontStyle.regular;
    }
  }

  ///Sets the font size.
  void _setSize(double value) {
    if (_metrics != null) {
      _metrics!.size = value;
    }
    _size = value;
  }

  /// Gets the value for PdfFontStyle.
  static int _getPdfFontStyle(PdfFontStyle value) {
    switch (value) {
      case PdfFontStyle.bold:
        return 1;
      case PdfFontStyle.italic:
        return 2;
      case PdfFontStyle.underline:
        return 4;
      case PdfFontStyle.strikethrough:
        return 8;
      default:
        return 0;
    }
  }

  /// Returns width of the line.
  double _getLineWidth(String line, PdfStringFormat? format);

  /// Applies settings to the default line width.
  double _applyFormatSettings(
      String line, PdfStringFormat? format, double width) {
    double realWidth = width;
    if (format != null && width > 0) {
      if (format.characterSpacing != 0) {
        realWidth += (line.length - 1) * format.characterSpacing;
      }
      if (format.wordSpacing != 0) {
        final int whitespacesCount =
            _StringTokenizer._getCharacterCount(line, _StringTokenizer._spaces);
        realWidth += whitespacesCount * format.wordSpacing;
      }
    }
    return realWidth;
  }
}
