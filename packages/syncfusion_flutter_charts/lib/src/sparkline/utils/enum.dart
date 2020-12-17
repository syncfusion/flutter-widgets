/// Maps the index value.
typedef SparkChartIndexedValueMapper<R> = R Function(int index);

/// Maps the tooltip label value
typedef SparkChartTooltipCallback<String> = String Function(
    TooltipFormatterDetails details);

/// Represents the marker display mode
enum SparkChartMarkerDisplayMode {
  /// SparkChartMarkerDisplayMode.none does not allow to display markers on any side
  none,

  /// SparkChartMarkerDisplayMode.all allows to display marker on all side
  all,

  /// SparkChartMarkerDisplayMode.high allows to display marker on high point
  high,

  /// SparkChartMarkerDisplayMode.low allows to display marker on low point
  low,

  /// SparkChartMarkerDisplayMode.first allows to display marker on first point
  first,

  /// SparkChartMarkerDisplayMode.last allows to display marker on last point
  last
}

/// Represents the marker shape
enum SparkChartMarkerShape {
  /// SparkChartMarkerShape.circle displays marker in circular shape
  circle,

  /// SparkChartMarkerShape.diamond displays marker in diamond shape
  diamond,

  /// SparkChartMarkerShape.square displays marker in square shape
  square,

  /// SparkChartMarkerShape.triangle displays marker in triangle shape
  triangle,

  /// SparkChartMarkerShape.invertedTriangle displays marker in inverted triangle shape
  invertedTriangle
}

/// Represents the trackball spark chart activation mode
enum SparkChartActivationMode {
  ///SparkChartActivationMode.tap allows to display the trackball on tap
  tap,

  /// SparkChartActivationMode.doubleTap allows to display the trackball on double tap
  doubleTap,

  /// SparkChartActivationMode.longPress allows to display the trckball on long press
  longPress,
}

/// Represents the label display mode
enum SparkChartLabelDisplayMode {
  /// SparkChartLabelDisplayMode.none does not allow to display data labels on any side
  none,

  ///SparkChartLabelDisplayMode.all allows to display data labels on all points
  all,

  /// SparkChartLabelDisplayMode.high allows to display data  on high point
  high,

  /// SparkChartLabelDisplayMode.low allows to display marker on low point
  low,

  /// SparkChartLabelDisplayMode.first allows to display marker on first point
  first,

  /// SparkChartLabelDisplayMode.last allows to display marker on last point
  last
}

/// Specifies the tooltip formatter details
class TooltipFormatterDetails {
  /// Creates the tooltip formatter details
  TooltipFormatterDetails({this.x, this.y, this.label});

  /// Specifies the x-value of data point
  final dynamic x;

  /// Specifies the y-value of data point
  final num y;

  /// Specifies the tooltip text
  final String label;
}
