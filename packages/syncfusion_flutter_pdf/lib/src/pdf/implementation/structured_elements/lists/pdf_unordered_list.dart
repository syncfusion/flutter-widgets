part of pdf;

/// Represents the ordered list.
class PdfUnorderedList extends PdfList {
  /// Initializes a new instance of the [PdfUnorderedList] class.
  PdfUnorderedList(
      {PdfUnorderedMarker marker,
      PdfListItemCollection items,
      String text,
      PdfFont font,
      PdfUnorderedMarkerStyle style = PdfUnorderedMarkerStyle.disk,
      PdfStringFormat format,
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

  /// Marker for the list.
  PdfUnorderedMarker _marker;

  /// Gets the marker.
  PdfUnorderedMarker get marker => _marker;

  /// Sets the marker.
  set marker(PdfUnorderedMarker value) {
    ArgumentError.checkNotNull(value, 'marker');
    _marker = value;
  }

  /// Creates the marker.
  static PdfUnorderedMarker _createMarker(PdfUnorderedMarkerStyle style) {
    return PdfUnorderedMarker(style: style);
  }
}
