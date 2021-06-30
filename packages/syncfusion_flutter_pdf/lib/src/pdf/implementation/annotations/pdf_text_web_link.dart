part of pdf;

/// Represents the class for text web link annotation.
/// ``` dart
/// //Create a new Pdf document
/// PdfDocument document = PdfDocument();
/// //Create and draw the web link in the PDF page
/// PdfTextWebLink(
///         url: 'www.google.co.in',
///         text: 'google',
///         font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
///         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
///         pen: PdfPens.brown,
///         format: PdfStringFormat(
///             alignment: PdfTextAlignment.center,
///             lineAlignment: PdfVerticalAlignment.middle))
///     .draw(document.pages.add(), Offset(50, 40));
/// //Save the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfTextWebLink extends PdfAnnotation {
  // Constructor
  /// Initializes a new instance of the [PdfTextWebLink] class.
  /// ``` dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create and draw the web link in the PDF page
  /// PdfTextWebLink(
  ///         url: 'www.google.co.in',
  ///         text: 'google',
  ///         font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///         pen: PdfPens.brown,
  ///         format: PdfStringFormat(
  ///             alignment: PdfTextAlignment.center,
  ///             lineAlignment: PdfVerticalAlignment.middle))
  ///     .draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfTextWebLink(
      {required String url,
      String? text,
      PdfBrush? brush,
      PdfFont? font,
      PdfPen? pen,
      PdfStringFormat? format})
      : super._() {
    _initializeWebLink(text, font, pen, brush, format);
    this.url = url;
  }

  PdfTextWebLink._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String? annotText)
      : super._internal(dictionary, crossTable) {
    text = annotText != null && annotText.isNotEmpty ? annotText : '';
    _crossTable = crossTable;
  }

  // fields
  String? _url;
  late PdfUriAnnotation _uriAnnotation;

  /// Get or sets the font.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     pen: PdfPens.brown,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle));
  /// //Gets or sets the font
  /// textWebLink.font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfFont? font;

  /// Get or sets the pen.
  ///```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle));
  /// //Gets or sets the pen
  /// textWebLink.pen = PdfPens.brown;
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPen? pen;

  /// Get or sets the brush.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///     pen: PdfPens.brown,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle));
  /// //Gets or sets the brush
  /// textWebLink.brush = PdfSolidBrush(PdfColor(0, 0, 0));
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBrush? brush;

  /// Get or sets the stringFormat.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     pen: PdfPens.brown);
  /// //Gets or sets the stringFormat
  /// textWebLink.stringFormat  = PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle);
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfStringFormat? stringFormat;

  // properties
  /// Gets or sets the Uri address.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     pen: PdfPens.brown,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle));
  /// //Sets the url
  /// textWebLink.url = 'www.google.co.in';
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String get url {
    if (_isLoadedAnnotation) {
      return _obtainUrl()!;
    } else {
      return _url!;
    }
  }

  set url(String value) {
    if (value == '') {
      throw ArgumentError.value('Url - string can not be empty');
    }
    _url = value;
    if (_isLoadedAnnotation) {
      if (_dictionary.containsKey(_DictionaryProperties.a)) {
        final _PdfDictionary? dictionary =
            _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.a])
                as _PdfDictionary?;
        if (dictionary != null) {
          dictionary._setString(_DictionaryProperties.uri, _url);
        }
        _dictionary.modify();
      }
    }
  }

  // implementation
  void _initializeWebLink(String? annotText, PdfFont? font, PdfPen? pen,
      PdfBrush? brush, PdfStringFormat? format) {
    text = annotText != null && annotText.isNotEmpty ? annotText : '';
    if (font != null) {
      this.font = font;
    }
    if (brush != null) {
      this.brush = brush;
    }
    if (pen != null) {
      this.pen = pen;
    }
    if (format != null) {
      stringFormat = format;
    }
  }

  /// Draws a text web link on the PDF page.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     pen: PdfPens.brown,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle));
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void draw(PdfPage page, Offset location) {
    if (!_isLoadedAnnotation) {
      final PdfFont pdfFont =
          font != null ? font! : PdfStandardFont(PdfFontFamily.helvetica, 8);
      final Size textSize = pdfFont.measureString(text);
      final Rect rect = Rect.fromLTWH(
          location.dx, location.dy, textSize.width, textSize.height);
      _uriAnnotation = PdfUriAnnotation(bounds: rect, uri: url);
      _uriAnnotation.border = PdfAnnotationBorder(0, 0, 0);
      page.annotations.add(_uriAnnotation);
      _drawInternal(page.graphics, rect, pdfFont);
    }
  }

  void _drawInternal(PdfGraphics graphics, Rect bounds, PdfFont pdfFont) {
    graphics.drawString(text, pdfFont,
        pen: pen, brush: brush, bounds: bounds, format: stringFormat);
  }

  String? _obtainUrl() {
    String? url = '';
    if (_dictionary.containsKey(_DictionaryProperties.a)) {
      final _PdfDictionary? dictionary =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.a])
              as _PdfDictionary?;
      if (dictionary != null &&
          dictionary.containsKey(_DictionaryProperties.uri)) {
        final _PdfString? uriText =
            _PdfCrossTable._dereference(dictionary[_DictionaryProperties.uri])
                as _PdfString?;
        if (uriText != null) {
          url = uriText.value;
        }
      }
    }
    return url;
  }

  @override
  _IPdfPrimitive? _element;
}
