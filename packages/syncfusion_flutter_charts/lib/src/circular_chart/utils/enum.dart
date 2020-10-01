part of charts;

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
  ///- `LabelIntersectAction.hide,`, hides the intersecting labels.
  hide,

  /// - `LabelIntersectAction.none`, will not perform any action on intersection.
  none
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
