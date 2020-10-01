part of pdf;

/// Represents marker alignment.
enum PdfListMarkerAlignment {
  /// Left alignment for marker.
  left,

  /// Right alignment for marker.
  right
}

/// Specifies the marker style.
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
