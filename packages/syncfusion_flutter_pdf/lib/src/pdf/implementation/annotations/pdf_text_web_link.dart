part of pdf;

/// Represents the class for text web link annotation.
class PdfTextWebLink extends PdfAnnotation {
  // Constructor
  /// Initializes a new instance of the [PdfTextWebLink] class.
  PdfTextWebLink(
      {String url,
      String text,
      PdfBrush brush,
      PdfFont font,
      PdfPen pen,
      PdfStringFormat format})
      : super._() {
    _initializeWebLink(text, font, pen, brush, format);
    this.url = url;
  }

  PdfTextWebLink._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text)
      : super._internal(dictionary, crossTable) {
    _crossTable = crossTable;
  }

  // fields
  String _url;
  PdfUriAnnotation _uriAnnotation;

  /// Get or sets the font.
  PdfFont font;

  /// Get or sets the pen.
  PdfPen pen;

  /// Get or sets the brush.
  PdfBrush brush;

  /// Get or sets the stringFormat.
  PdfStringFormat stringFormat;

  // properties
  /// Gets the Uri address.
  String get url {
    if (_isLoadedAnnotation) {
      return _obtainUrl();
    } else {
      return _url;
    }
  }

  /// Sets the Uri address.
  set url(String value) {
    ArgumentError.checkNotNull(value, 'url');
    if (value == '') {
      throw ArgumentError.value('Url - string can not be empty');
    }
    _url = value;
    if (_isLoadedAnnotation) {
      if (_dictionary.containsKey(_DictionaryProperties.a)) {
        final _PdfDictionary dictionary =
            _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.a])
                as _PdfDictionary;
        if (dictionary != null) {
          dictionary._setString(_DictionaryProperties.uri, _url);
        }
        _dictionary.modify();
      }
    }
  }

  // implementation
  void _initializeWebLink(String text, PdfFont font, PdfPen pen, PdfBrush brush,
      PdfStringFormat format) {
    this.text = text != null && text.isNotEmpty ? text : '';
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
  void draw(PdfPage page, Offset location) {
    if (!_isLoadedAnnotation) {
      final Size textSize = font.measureString(text);
      final Rect rect = Rect.fromLTWH(
          location.dx, location.dy, textSize.width, textSize.height);
      _uriAnnotation = PdfUriAnnotation(bounds: rect, uri: url);
      _uriAnnotation.border = PdfAnnotationBorder(0, 0, 0);
      page.annotations.add(_uriAnnotation);
      _drawInternal(page.graphics, rect);
    }
  }

  void _drawInternal(PdfGraphics graphics, Rect bounds) {
    ArgumentError.checkNotNull(graphics);
    ArgumentError.checkNotNull(font, 'Font cannot be null');
    graphics.drawString(text, font,
        pen: pen, brush: brush, bounds: bounds, format: stringFormat);
  }

  String _obtainUrl() {
    String url = '';
    if (_dictionary.containsKey(_DictionaryProperties.a)) {
      final _PdfDictionary dictionary =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.a])
              as _PdfDictionary;
      if (dictionary != null &&
          dictionary.containsKey(_DictionaryProperties.uri)) {
        final _PdfString text =
            _PdfCrossTable._dereference(dictionary[_DictionaryProperties.uri])
                as _PdfString;
        if (text != null) {
          url = text.value;
        }
      }
    }
    return url;
  }

  @override
  _IPdfPrimitive _element;
}
