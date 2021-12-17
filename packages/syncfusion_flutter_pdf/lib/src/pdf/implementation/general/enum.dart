/// Enumeration that represents fit mode.
enum PdfDestinationMode {
  /// Display the page designated by page, with the coordinates (left, top)
  /// positioned at the top-left corner of the window and the contents of
  /// the page magnified by the factor zoom. A NULL value for any of the
  /// parameters left, top, or zoom specifies that the current value of that
  ///  parameter is to be retained unchanged.
  /// A zoom value of 0 has the same meaning as a NULL value.
  location,

  /// Display the page designated by page, with its contents magnified
  ///  just enough to fit the entire page within the window both horizontally
  ///  and vertically. If the required horizontal and vertical magnification
  /// factors are different, use the smaller of the two, centering the page
  /// within the window in the other dimension.
  fitToPage,

  /// Display the page designated by page, with the horizontal coordinate
  /// left positioned at the left edge of the window and the contents of
  ///  the page magnified just enough to fit the entire height of the page
  ///  within the window.
  fitR,

  /// Display the page designated by page, with the vertical coordinate
  /// top positioned at the top edge of the window and the contents of the page
  /// magnified just enough to fit the entire width of the page
  /// within the window.
  fitH
}
