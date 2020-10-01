part of maps;

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

  /// Legend's and marker's icon will be drawn in the square shape.
  square,

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

/// Behavior of the data labels when it overflowed from the shape.
enum MapLabelOverflowMode {
  /// It hides the overflowed labels.
  hide,

  /// It does not make any change even if the labels overflowed.
  none,

  /// It trims the labels based on the available space in their respective
  /// shape.
  trim
}

/// Shows legend for the shapes or the bubbles.
enum MapElement {
  /// [MapElement.shape], shows legend for shapes.
  shape,

  /// [MapElement.bubble], shows legend for the bubbles.
  bubble,

  /// [MapElement.none], hides the legend.
  none
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

enum _Gesture { scale, pan }

enum _Layer { shape, bubble }
