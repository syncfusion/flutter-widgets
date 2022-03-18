/// Orientation of the linear gauge.
enum LinearGaugeOrientation {
  ///LinearGaugeOrientation.horizontal will align the linear gauge in vertical orientation.
  vertical,

  ///LinearGaugeOrientation.horizontal will align the linear gauge in horizontal orientation.
  horizontal
}

/// Apply the shape style for range element.
enum LinearRangeShapeType {
  /// LinearRangeShapeType.flat apply the flat shape between start and end value.
  flat,

  /// LinearRangeShapeType.curve apply the curve shape between start and end value.
  curve
}

/// Apply the edge style for range pointer.
enum LinearEdgeStyle {
  /// LinearEdgeStyle.bothFlat does not apply the rounded corner on both side
  bothFlat,

  /// LinearEdgeStyle.bothCurve apply the rounded corner on both side.
  bothCurve,

  /// LinearEdgeStyle.startCurve apply the rounded corner on start(left) side.
  startCurve,

  /// LinearEdgeStyle.endCurve apply the rounded corner on end(right) side.
  endCurve
}

/// Apply the different marker pointer.
enum LinearShapePointerType {
  /// LinearShapePointerType.invertedTriangle points the value with inverted triangle.
  invertedTriangle,

  /// LinearShapePointerType.triangle points the value with triangle.
  triangle,

  /// LinearShapePointerType.circle points the value with circle.
  circle,

  /// LinearShapePointerType.rectangle points the value with rectangle
  rectangle,

  /// LinearShapePointerType.diamond points the value with diamond.
  diamond,
}

/// Apply the different types of animation to pointer.
enum LinearAnimationType {
  /// LinearAnimationType.bounceOut animates the pointer with Curves.bounceOut.
  bounceOut,

  /// LinearAnimationType.ease animates the pointer with Curves.ease.
  ease,

  /// LinearAnimationType.easeInCirc animates the pointer with Curves.easeInCirc.
  easeInCirc,

  /// LinearAnimationType.easeOutBack animates the pointer with Curves.easeOutBack.
  easeOutBack,

  /// LinearAnimationType.elasticOut animates the pointer with Curves.elasticOut.
  elasticOut,

  /// LinearAnimationType.linear animates the pointer with Curves.linear.
  linear,

  /// LinearAnimationType.slowMiddle animates the pointers with Curves.slowMiddle.
  slowMiddle
}

/// Apply the different label position based on Axis.
enum LinearLabelPosition {
  /// LinearAnimationType.inside places the elements inside the axis.
  inside,

  /// LinearAnimationType.outside places the elements inside the axis.
  outside
}

/// Apply the different element position based on Axis.
enum LinearElementPosition {
  /// LinearElementPosition.inside places the elements inside the axis.
  inside,

  /// LinearElementPosition.outside places the elements outside the axis.
  outside,

  /// LinearElementPosition.cross places the elements cross the axis.
  cross
}

/// Apply the different pointer alignment based on Axis.
enum LinearMarkerAlignment {
  /// LinearMarkerAlignment.center points the axis from center position.
  center,

  /// LinearMarkerAlignment.start points the axis from inside position.
  start,

  /// LinearMarkerAlignment.end points the axis from outside position.
  end
}

/// Apply the different drag behavior for marker pointers.
enum LinearMarkerDragBehavior {
  /// LinearMarkerDragBehavior.free default drag behavior for marker pointer.
  free,

  /// LinearMarkerDragBehavior.constrained the current marker pointer is not
  /// go beyond the reference marker pointer.
  constrained,
}

/// Find the Constrained state of the marker pointer.
enum ConstrainedBy {
  /// ConstrainedBy.min constrained the marker pointer in the minimum value.
  min,

  /// ConstrainedBy.max constrained the marker pointer in the maximum value.
  max,

  /// ConstrainedBy.none when the marker pointer is not constrained with any pointers.
  none,
}
