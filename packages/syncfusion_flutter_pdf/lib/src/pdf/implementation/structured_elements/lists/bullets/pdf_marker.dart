part of pdf;

/// Represents base class for markers.
abstract class PdfMarker {
  /// Marker font.
  PdfFont font;

  /// Marker brush.
  PdfBrush brush;

  /// Marker pen.
  PdfPen pen;

  /// The string format of the marker.
  PdfStringFormat stringFormat;

  /// Marker alignment.
  PdfListMarkerAlignment alignment = PdfListMarkerAlignment.left;

  /// Indicates is alignment right.
  bool get _rightToLeft => alignment == PdfListMarkerAlignment.right;
}
