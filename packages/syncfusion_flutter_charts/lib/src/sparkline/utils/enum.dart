/// Signature for the callback that returns the dynamic value from the
/// data source based on the index.
///
typedef SparkChartIndexedValueMapper<R> = R Function(int index);

/// Signature for the callback that returns the string value to override the
/// default text format of trackball tooltip label.
///
typedef SparkChartTooltipCallback<String> = String Function(
    TooltipFormatterDetails details);

/// Displays the marker on the spark chart widget in different modes.
enum SparkChartMarkerDisplayMode {
  /// SparkChartMarkerDisplayMode.none does not allow to display a marker on any
  /// data points in the spark chart widget.
  none,

  /// SparkChartMarkerDisplayMode.all allows to display a marker on all the data points
  /// in the spark chart widget.
  all,

  /// SparkChartMarkerDisplayMode.high allows displaying marker only on the highest
  /// data points in the spark chart widget.
  high,

  /// SparkChartMarkerDisplayMode.low allows displaying marker only on the lowest data
  /// points in the spark chart widget.
  low,

  /// SparkChartMarkerDisplayMode.first allows displaying marker only on the first data
  /// points in the spark chart widget.
  first,

  /// SparkChartMarkerDisplayMode.last allows displaying marker only on the last data
  /// points in the spark chart widget.
  last
}

/// Displays the marker in different types of shape.
enum SparkChartMarkerShape {
  /// SparkChartMarkerShape.circle displays the marker in a circular shape.
  circle,

  /// SparkChartMarkerShape.diamond displays the marker in a diamond shape.
  diamond,

  /// SparkChartMarkerShape.square displays the marker in a square shape.
  square,

  /// SparkChartMarkerShape.triangle displays the marker in a triangle shape.
  triangle,

  /// SparkChartMarkerShape.invertedTriangle displays the marker in an inverted
  /// triangle shape
  invertedTriangle
}

/// Activates the trackball in different gestures.
enum SparkChartActivationMode {
  /// SparkChartActivationMode.tap activates the trackball on tap gesture.
  tap,

  /// SparkChartActivationMode.doubleTap activates the trackball on double tap
  /// gesture.
  doubleTap,

  /// SparkChartActivationMode.longPress activates the trackball on long press
  /// gesture.
  longPress,
}

/// Displays the data labels on the spark chart widget in different modes.
enum SparkChartLabelDisplayMode {
  /// SparkChartLabelDisplayMode.none does not allow to display the data label on any
  /// data points in the spark chart widget.
  none,

  /// SparkChartLabelDisplayMode.none allows to display data label on all the
  /// data points in the spark chart widget.
  all,

  /// SparkChartLabelDisplayMode.high allows displaying data label only on the
  /// highest data points in the spark chart widget.
  high,

  /// SparkChartLabelDisplayMode.low allows displaying data label only on the
  /// lowest data points in the spark chart widget.
  low,

  /// SparkChartLabelDisplayMode.first allows displaying data label only on the
  /// first data points in the spark chart widget.
  first,

  /// SparkChartLabelDisplayMode.first allows displaying data label only on the
  /// last data points in the spark chart widget.
  last
}

/// Passes as the argument in the `tooltipFormatter` callback of trackball.
/// The callback gets triggered when the trackball tooltip label text is created.
class TooltipFormatterDetails {
  /// Creates an instance of TooltipFormatterDetails, where the closest point’s
  ///  x value and y value and tooltip text is passed as its argument.
  ///
  TooltipFormatterDetails({this.x, this.y, this.label});

  /// Provides the x value of the closest data point.
  final dynamic x;

  /// Provides the y value of the closest data point.
  final num? y;

  /// Provides the tooltip label value. By default, the label displays the
  ///  x and the y value in the format of x : y.
  final String? label;
}
