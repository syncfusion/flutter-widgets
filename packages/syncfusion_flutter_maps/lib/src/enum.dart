/// Position of the legend.
enum MapLegendPosition {
  /// Places the legend at left to the map area.
  left,

  /// Places the legend at right to the map area.
  right,

  /// Places the legend at top of the map area.
  top,

  /// Places the legend at bottom of the map area.
  bottom,
}

/// Shapes of the legend's and marker's icon.
enum MapIconType {
  /// Legend's and marker's icon will be drawn in the circle shape.
  circle,

  /// Legend's and marker's icon will be drawn in the rectangle shape.
  rectangle,

  /// Legend's and marker's icon will be drawn in the triangle shape.
  triangle,

  /// Legend's and marker's icon will be drawn in the diamond shape.
  diamond,
}

/// Behavior of the legend items when it overflows.
enum MapLegendOverflowMode {
  /// It will place all the legend items in single line and enables scrolling.
  scroll,

  /// It will wrap and place the remaining legend items to next line.
  wrap,
}

/// Behavior of the labels when it overflowed from the shape.
enum MapLabelOverflow {
  /// It hides the overflowed labels.
  hide,

  /// It does not make any change even if the labels overflowed.
  visible,

  /// It trims the labels based on the available space in their respective
  /// shape.
  ellipsis
}

/// Shows legend for the shapes or the bubbles.
enum MapElement {
  /// [MapElement.shape], shows legend for shapes.
  shape,

  /// [MapElement.bubble], shows legend for the bubbles.
  bubble,
}

/// Specifies the zooming toolbar position.
enum MapToolbarPosition {
  /// Positions the toolbar on left top.
  topLeft,

  /// Positions the toolbar on right top.
  topRight,

  /// Positions the toolbar on left bottom.
  bottomLeft,

  /// Positions the toolbar on right bottom.
  bottomRight
}

/// Option to place the labels either between the bars or on the bar in bar
/// legend.
enum MapLegendLabelsPlacement {
  /// [MapLegendLabelsPlacement.onItem] places labels in the center of the bar.
  onItem,

  /// [MapLegendLabelsPlacement.betweenItems] places labels in-between two bars.
  betweenItems
}

/// Placement of edge labels in the bar legend.
enum MapLegendEdgeLabelsPlacement {
  /// Places the edge labels in inside of the legend items.
  inside,

  /// Place the edge labels in the center of the starting position of the
  /// legend bars.
  center
}

/// Applies gradient or solid color for the bar segments.
enum MapLegendPaintingStyle {
  /// Applies solid color for bar segments.
  solid,

  /// Applies gradient color for bar segments.
  gradient
}
