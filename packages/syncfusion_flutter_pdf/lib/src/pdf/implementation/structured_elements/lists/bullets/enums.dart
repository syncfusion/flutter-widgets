/// Represents marker alignment.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new ordered list.
/// PdfOrderedList(
///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric)
///       ..alignment = PdfListMarkerAlignment.right)
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
enum PdfListMarkerAlignment {
  /// Left alignment for marker.
  left,

  /// Right alignment for marker.
  right
}

/// Specifies the marker style.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new unordered list.
/// PdfUnorderedList(
///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     marker: PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.disk))
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
enum PdfUnorderedMarkerStyle {
  /// Marker have  no style.
  none,

  /// Marker is like a disk.
  disk,

  /// Marker is like a square.
  square,

  /// Marker is like a Asterisk.
  asterisk,

  /// Marker is like a circle.
  circle,

  /// Marker is custom string.
  customString,

  /// Marker is custom image.
  customImage,

  /// Marker is custom template.
  customTemplate
}
