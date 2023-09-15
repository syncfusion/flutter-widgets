///  A alignment along either the horizontal or vertical.
enum GaugeAlignment {
  /// GaugeAlignment.near aligns the gauge element to near either
  /// the horizontal or vertical.
  near,

  /// GaugeAlignment.center aligns the gauge element to center either
  /// the horizontal or vertical.
  center,

  /// GaugeAlignment.far aligns the gauge element to far either
  /// the horizontal or vertical.
  far
}

/// Position the gauge element either inside or outside the axis.
enum ElementsPosition {
  /// ElementPosition.inside places the axis elements inside the axis.
  inside,

  /// ElementPosition.outside places the axis elements outside the axis.
  outside
}

/// Apply the corner style for range pointer.
enum CornerStyle {
  /// CornerStyle.bothFlat does not apply the rounded corner on both side
  bothFlat,

  /// CornerStyle.bothCurve apply the rounded corner on both side.
  bothCurve,

  /// CornerStyle.startCurve apply the rounded corner on start(left) side.
  startCurve,

  /// CornerStyle.endCurce apply the rounded corner on end(right) side.
  endCurve
}

/// Apply the different marker type for pointer.
enum MarkerType {
  /// MarkerText.invertedTriangle points the value with inverted triangle.
  invertedTriangle,

  /// MarkerText.triangle points the value with triangle.
  triangle,

  /// MarkerText.circle points the value with circle.
  circle,

  /// MarkerText.rectangle points the value with rectangle
  rectangle,

  /// MarkerText.diamond points the value with diamond.
  diamond,

  /// MarkerText.image points the value with image.
  image,

  /// MarkerText.text points the value with text.
  text
}

/// Apply the different types of animation to pointer.
enum AnimationType {
  /// AnimationType.bounceOut animates the pointer with Curves.bounceOut.
  bounceOut,

  /// AnimationType.ease animates the pointer with Curves.ease.
  ease,

  /// AnimationType.easeInCirc animates the pointer with Curves.easeInCirc.
  easeInCirc,

  /// AnimationType.easeOutBack animates the pointer with Curves.easeOutBack.
  easeOutBack,

  /// AnimationType.elasticOut animates the pointer with Curves.elasticOut.
  elasticOut,

  /// AnimationType.linear animates the pointer with Curves.linear.
  linear,

  /// AnimationType.slowMiddle animates the pointers with Curves.slowMiddle.
  slowMiddle
}

/// Size determined either the logical pixel or the radius factor.
enum GaugeSizeUnit {
  /// GaugeSizeUnit.factor specifies the value in factor from 0 to 1.
  factor,

  /// GaugeSizeUnit.logicalPixel specifies the value in logical pixel.
  logicalPixel
}
