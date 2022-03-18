/// Specifies type of paginating.
enum PdfLayoutType {
  /// If the element exceeds the page, proceed it on the next page.
  paginate,

  /// Draw the element on the one page only.
  onePage
}

/// Specifies how the element should be contained on the page.
enum PdfLayoutBreakType {
  /// Fit the element according to the bounds specified or the page bounds.
  fitPage,

  /// If the element doesn't fit at the first page, don't draw it on this page.
  fitElement,

  /// Fit the columns withtin the page.
  fitColumnsToPage
}

/// Specifies path point type
enum PathPointType {
  /// start type
  start,

  /// line type
  line,

  /// bezier3 type
  bezier3,

  /// closeSubpath type
  closeSubpath
}
