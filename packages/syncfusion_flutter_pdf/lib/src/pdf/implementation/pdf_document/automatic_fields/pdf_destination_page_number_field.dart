part of pdf;

/// Represents class which displays destination page's number.
class PdfDestinationPageNumberField extends PdfPageNumberField {
  // constructor
  /// Initializes a new instance of the [PdfDestinationPageNumberField] class
  /// may include with [PdfFont], [PdfBrush] and [Rect].
  PdfDestinationPageNumberField(
      {PdfPage page, PdfFont font, PdfBrush brush, Rect bounds})
      : super(font: font, brush: brush, bounds: bounds) {
    if (page != null) {
      _page = page;
    }
  }

  // fields
  PdfPage _page;

  // properties
  /// Gets the page.
  PdfPage get page => _page;

  /// Sets the page.
  set page(PdfPage value) {
    ArgumentError.checkNotNull(value, 'page');
    _page = value;
  }

  // implementation
  @override
  String _getValue(PdfGraphics graphics) {
    return _internalGetValue(_page);
  }
}
