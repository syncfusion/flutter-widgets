part of pdf;

/// Represents the ordered list.
class PdfOrderedList extends PdfList {
  /// Initialize a new instance of the [PdfOrderedList] class.
  PdfOrderedList(
      {PdfOrderedMarker marker,
      PdfListItemCollection items,
      String text,
      PdfFont font,
      PdfNumberStyle style = PdfNumberStyle.numeric,
      PdfStringFormat format,
      this.markerHierarchy = false,
      double indent = 10,
      double textIndent = 5})
      : super() {
    _marker = marker ?? _createMarker(style);
    stringFormat = format;
    super.indent = indent;
    super.textIndent = textIndent;
    if (font != null) {
      _font = font;
    }
    if (items != null) {
      ArgumentError.checkNotNull(items, 'Items collection can\'t be null');
      _items = items;
    } else if (text != null) {
      _items = PdfList._createItems(text);
    }
  }

  /// Marker of the list.
  PdfOrderedMarker _marker;

  /// True if user want to use numbering hierarchy, otherwise false.
  bool markerHierarchy;

  /// Gets marker of the list items.
  PdfOrderedMarker get marker => _marker;

  /// Sets marker of the list items.
  set marker(PdfOrderedMarker value) {
    ArgumentError.checkNotNull(value, 'marker');
    _marker = value;
  }

  /// Creates the marker.
  static PdfOrderedMarker _createMarker(PdfNumberStyle style) {
    return PdfOrderedMarker(style: style, font: null);
  }
}
