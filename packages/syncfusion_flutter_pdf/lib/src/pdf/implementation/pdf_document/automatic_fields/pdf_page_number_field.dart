part of pdf;

/// Represents PDF document page number field.
/// Represents an automatic field to display page number within a section.
class PdfPageNumberField extends _PdfMultipleValueField {
  // constructor
  /// Initializes a new instance of the [PdfPageNumberField] class
  /// and may also with the classes are [PdfFont], [PdfBrush] and [Rect].
  PdfPageNumberField(
      {PdfFont font, PdfBrush brush, Rect bounds, bool isSectionPageNumber})
      : super(font: font, brush: brush, bounds: bounds) {
    _isSectionPageNumber =
        (isSectionPageNumber == null) ? false : isSectionPageNumber;
  }

  // fields
  /// Gets or sets the specific number style.
  PdfNumberStyle numberStyle = PdfNumberStyle.numeric;

  /// Represents an automatic field to display page number within a section.
  bool _isSectionPageNumber = false;

  //implementation
  @override
  String _getValue(PdfGraphics graphics) {
    String result;
    if (graphics._page is PdfPage) {
      final PdfPage page = _PdfDynamicField._getPageFromGraphics(graphics);
      result = _internalGetValue(page);
    }
    return result;
  }

  String _internalGetValue(PdfPage page) {
    if (_isSectionPageNumber) {
      final PdfSection section = page._section;
      final int index = section._indexOf(page) + 1;
      return _PdfNumberConvertor._convert(index, numberStyle);
    } else {
      final PdfDocument document = page._section._parent._document;
      final int pageIndex = document.pages.indexOf(page) + 1;
      return _PdfNumberConvertor._convert(pageIndex, numberStyle);
    }
  }
}
