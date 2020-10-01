part of pdf;

/// Represents total PDF document page count automatic field.
/// Represents an automatic field to display total number of pages
/// in section(if set isSectionPageCount as true).
class PdfPageCountField extends _PdfSingleValueField {
  // constructor
  /// Initializes a new instance of the [PdfPageCountField] class
  /// and may also with the classes are [PdfFont], [PdfBrush] and [Rect].
  PdfPageCountField(
      {PdfFont font, PdfBrush brush, Rect bounds, bool isSectionPageCount})
      : super(font, brush, bounds) {
    _isSectionPageCount =
        (isSectionPageCount == null) ? false : isSectionPageCount;
  }

  // fields
  /// Gets or sets the specific number style.
  PdfNumberStyle numberStyle = PdfNumberStyle.numeric;

  /// Represents an automatic field to display total number of pages in section.
  bool _isSectionPageCount = false;

  // implementation
  @override
  String _getValue(PdfGraphics graphics) {
    String result;
    if (graphics._page is PdfPage) {
      final PdfPage page = _PdfDynamicField._getPageFromGraphics(graphics);
      if (_isSectionPageCount) {
        final PdfSection section = page._section;
        final int count = section._count;
        return _PdfNumberConvertor._convert(count, numberStyle);
      } else {
        final PdfDocument document = page._section._parent._document;
        final int number = document.pages.count;
        return _PdfNumberConvertor._convert(number, numberStyle);
      }
    }
    return result;
  }
}
