/// Data points grouping mode.
enum CircularChartGroupMode {
  /// - CircularChartGroupMode.point, groups the points based on length.
  point,

  /// - CircularChartGroupMode.value, groups the points based on the y value.
  value
}

/// Data label position of range bar series.
enum Position {
  /// - Position.left, places the data label to the left side.
  left,

  /// - Position.right, places the data label to the right side.
  right
}

/// Data labels intersect action.
enum LabelIntersectAction {
  ///- `LabelIntersectAction.hide`, hides the intersecting labels.
  hide,

  /// - `LabelIntersectAction.none`, will not perform any action on intersection.
  none,

  /// - `LabelIntersectAction.shift`, will shift and position the intersecting labels smartly. If the labels are moved out of the chart area, then the labels will be trimmed and the eclipse will be shown for the trimmed labels.
  shift
}

/// Type of connector line.
enum ConnectorType {
  /// - ConnectorType.curve, will render the data label connector line curly.
  curve,

  /// - ConnectorType.line, will render the data label connector lien straightly.
  line
}

/// Corner style of range bar series.
enum CornerStyle {
  /// - CornerStyle.bothFlat, will render both the corners flatly.
  bothFlat,

  /// - CornerStyle.bothCurve, will render both the corners curly.
  bothCurve,

  /// - CornerStyle.startCurve, will render starting corner curly.
  startCurve,

  /// - CornerStyle.endCurve, will render ending corner curly.
  endCurve
}

/// Point Render Mode for circular charts
enum PointRenderMode {
  /// - PointRenderMode.segment, will render points in normal behavior.
  segment,

  /// - PointRenderMode.gradient, will render points making a sweep gradient based on their values and fill.
  gradient,
}

/// Data label overflow action when it’s overflowing from its region area.
enum OverflowMode {
  /// - OverflowMode.none, no action will be taken and priority goes for
  /// `LabelIntersectAction.shift` of `labelIntersectAction` property.
  none,

  /// - OverflowMode.trim, data label text will be trimmed.
  trim,

  /// - OverflowMode.shift, datalabel text will be shifted to outside.
  shift,

  /// - OverflowMode.hide, data label text will be hidden.
  hide,
}
