/// Represents different pdf interaction modes.
enum PdfInteractionMode {
  /// Enables the text selection mode in a desktop browser to select the text using mouse dragging.
  selection,

  /// Enables the panning mode in a desktop browser to move or scroll through the pages using mouse dragging.
  pan
}

/// Represents different scrolling direction.
enum PdfScrollDirection {
  /// Pages will be scrolled up and down.
  vertical,

  /// Pages will be scrolled left and right.
  horizontal
}

/// Represents different pdf layout mode.
enum PdfPageLayoutMode {
  /// Continuous transition of pages.
  continuous,

  /// Page by page transition of pages.
  single
}
