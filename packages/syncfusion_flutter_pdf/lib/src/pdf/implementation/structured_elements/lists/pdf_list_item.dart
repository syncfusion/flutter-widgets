part of pdf;

/// Represents list item of the list.
class PdfListItem {
  /// Initializes a new instance of the [PdfListItem] class.
  PdfListItem(
      {String text = '',
      this.font,
      PdfStringFormat format,
      this.pen,
      this.brush}) {
    ArgumentError.checkNotNull(text, 'text');
    _text = text;
    stringFormat = format;
  }

  /// Holds item font.
  PdfFont font;

  /// Holds item text.
  String _text;

  /// Holds text format.
  PdfStringFormat stringFormat;

  /// Holds pen.
  PdfPen pen;

  /// Holds brush.
  PdfBrush brush;

  /// Sub list.
  PdfList subList;

  /// Text indent for current item.
  double textIndent = 0;
  //PdfTag m_tag;

  /// Gets item text.
  String get text => _text;

  /// Sets item text.
  set text(String value) {
    ArgumentError.checkNotNull(text, 'text');
    _text = value;
  }
}
