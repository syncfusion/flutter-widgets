/// Used by Tree Table to balance the tree with algorithm based
/// on Red - Black tree.
enum TreeTableNodeColor {
  /// TreeTableNodeColoe.red, will represented the Red color.
  red,

  /// TreeTableNodeColoe.black, will represented the Black color.
  black
}

/// Type of scroll axis regions
///
/// A scroll axis has three regions: Header, Body and Footer.
enum ScrollAxisRegion {
  /// - ScrollAxisRegion.header specifies the header region
  /// (at top or left side).
  header,

  /// - ScrollAxisRegion.body Specifies the body region
  /// (center between header and footer).
  body,

  /// - ScrollAxisRegion.footer Specifies the footer region
  /// (at bottom or right side).
  footer
}

/// Corner side enumeration.
enum CornerSide {
  /// Includes both Left and right side or top and bottom side.
  both,

  /// Left side alone.
  left,

  /// Right side alone.
  right,

  /// Bottom side alone.
  bottom
}
