part of pdf;

/// Represents class which displays destination page's number.
class PdfDestinationPageNumberField extends PdfPageNumberField {
  // constructor
  /// Initializes a new instance of the [PdfDestinationPageNumberField] class
  /// may include with [PdfFont], [PdfBrush] and [Rect].
  PdfDestinationPageNumberField(
      {PdfPage? page, PdfFont? font, PdfBrush? brush, Rect? bounds})
      : super(font: font, brush: brush, bounds: bounds) {
    if (page != null) {
      this.page = page;
    }
  }

  /// Gets or sets the page.
  PdfPage? page;

  // implementation
  @override
  String _getValue(PdfGraphics graphics) {
    return _internalGetValue(page);
  }
}
