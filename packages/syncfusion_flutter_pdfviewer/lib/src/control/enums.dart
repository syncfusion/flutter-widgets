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

/// Represents different flattening option.
enum PdfFlattenOption {
  /// Do not flatten any form fields or annotations .
  none,

  /// Flatten all the form fields.
  formFields
}

/// Enumerates the values that represent the type of annotation that should be drawn using UI interaction on the PDF pages.
enum PdfAnnotationMode {
  /// None
  none,

  /// Highlight
  highlight,

  /// Underline
  underline,

  /// Strikethrough
  strikethrough,

  /// Squiggly
  squiggly,
}
