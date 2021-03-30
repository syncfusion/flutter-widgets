part of pdf;

/// Represents class which can concatenate multiple automatic fields
/// into single string.
abstract class _PdfDynamicField extends PdfAutomaticField {
  // constructor
  _PdfDynamicField({PdfFont? font, Rect? bounds, PdfBrush? brush})
      : super._(font, bounds: bounds, brush: brush);

  // public methods
  static PdfPage _getPageFromGraphics(PdfGraphics graphics) {
    final PdfPage? page = graphics._page;
    ArgumentError.checkNotNull(page, 'page');
    return page!;
  }
}
