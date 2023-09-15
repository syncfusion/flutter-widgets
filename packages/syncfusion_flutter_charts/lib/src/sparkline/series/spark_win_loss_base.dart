import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../plot_band.dart';
import '../renderers/spark_win_loss_renderer.dart';
import '../trackball/spark_chart_trackball.dart';
import '../trackball/trackball_renderer.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// This class renders a win loss spark chart. The [SfSparkWinLossChart] is a
/// very small chart, typically drawn without axis ticks and labels. It presents
/// the general shape of data in a simple and highly condensed way. It is used
/// to show whether each value is positive or negative visualizing a Win/Loss
/// scenario.
///
/// To render a bar spark chart, create the instance of [SfSparkWinLossChart].
/// Set the value for `data` property which of type List<num>. Now, it shows the
/// rectangular column to represent the provided data.
///
/// It provides option to customize its appearance with the properties such as
/// [color], [borderWidth], [borderColor]. To highlight the data point, which is
/// tapped, use its [trackball] property. To highlight the particular region
/// along with the vertical value, use its [plotBand] property.
///
class SfSparkWinLossChart extends StatefulWidget {
  /// Creates a spark win loss chart for the provided set of data with its
  /// default view.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      data: <double>[18, 24, 30, 14, 28],
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  SfSparkWinLossChart(
      {Key? key,
      List<num>? data,
      this.plotBand,
      this.borderWidth = 0,
      this.borderColor,
      this.tiePointColor,
      this.color = Colors.blue,
      this.isInversed = false,
      this.axisCrossesAt = 0,
      this.axisLineColor = Colors.black,
      this.axisLineWidth = 2,
      this.axisLineDashArray,
      this.highPointColor,
      this.lowPointColor,
      this.negativePointColor,
      this.firstPointColor,
      this.lastPointColor,
      this.trackball})
      : _sparkChartDataDetails = SparkChartDataDetails(data: data),
        super(key: key);

  /// Creates the spark win loss chart for the provided set of data with its
  /// default view.
  ///
  /// The difference between the default constructor and this constructor is, in
  /// the default constructor uses its data property to get the input data value.
  /// The `data` property of the default constructor is of type List<num>.
  ///
  /// The custom constructor uses its [dataCount], [xValueMapper] and
  /// [yValueMapper] to get the input data.
  ///
  /// The [dataCount] property allows declaring the total data count going to be
  /// displayed in the chart.
  ///
  /// The [xValueMapper] returns the x- value of the corresponding data point.
  /// The [xValueMapper] allows providing num, DateTime, or string as x-value.
  ///
  /// The [yValueMapper] returns the y-value of the corresponding data point.
  ///
  /// ```dart
  /// class SalesData {
  ///   SalesData(this.month, this.sales);
  ///   final String month;
  ///   final double sales;
  /// }
  ///
  ///  List<SalesData> data;
  ///
  /// @override
  /// void initState() {
  ///  super.initState();
  ///  data = <SalesData>[
  ///    SalesData('Jan', 200),
  ///    SalesData('Feb', 215),
  ///    SalesData('Mar', 380),
  ///    SalesData('Apr', 240),
  ///    SalesData('May', 280),
  ///  ];
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart.custom(
  ///         dataCount: 5,
  ///          xValueMapper: (int index) => data[index].month,
  ///          yValueMapper: (int index) => data[index].sales
  ///       )
  ///     ),
  ///  );
  /// }
  /// ```
  SfSparkWinLossChart.custom(
      {Key? key,

      /// Data count for the spark charts.
      int? dataCount,

      /// Specifies the x-value mapping field.
      SparkChartIndexedValueMapper<dynamic>? xValueMapper,

      /// Specifies the y-value maping field.
      SparkChartIndexedValueMapper<num>? yValueMapper,
      this.plotBand,
      this.borderWidth = 2,
      this.borderColor,
      this.tiePointColor,
      this.color = Colors.blue,
      this.isInversed = false,
      this.axisCrossesAt = 0,
      this.axisLineColor = Colors.black,
      this.axisLineWidth = 2,
      this.axisLineDashArray,
      this.highPointColor,
      this.lowPointColor,
      this.negativePointColor,
      this.firstPointColor,
      this.lastPointColor,
      this.trackball})
      : _sparkChartDataDetails = SparkChartDataDetails(
            dataCount: dataCount,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper),
        super(key: key);

  /// Inverts the axis from right to left.
  ///
  /// In the spark chart, the provided set of data are rendered from left to
  /// right by default and can be inverted to render the data points from
  /// right to left.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      isInversed: true,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final bool isInversed;

  /// Customize the axis position based on the provided y-value.
  /// The axis line is rendered on the minimum y-value and can be repositioned
  /// to required y-value .
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      axisCrossesAt: 24,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///       )
  ///     ),
  ///  );
  /// }
  /// ```
  final double axisCrossesAt;

  /// Customizes the width of the axis line.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      axisLineWidth: 4,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final double axisLineWidth;

  /// Customizes the color of the axis line.
  /// Colors.transparent can be set to [axisLineColor] to hide the axis line.
  ///
  /// Defaults to `Colors.black`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      axisLineColor: Colors.red,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final Color axisLineColor;

  /// Dashes of the axis line. Any number of values can be provided on the list.
  /// Odd value is considered as rendering size and even value is considered a gap.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      axisLineDashArray: <double>[2,2],
  ///      data: <double>[18, 24, 30, 14, 28],
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final List<double>? axisLineDashArray;

  /// Customizes the color of the highest rectangular column segment.
  ///
  /// When the high data point is the first or last data point of the provided
  /// data set, then either the first or last point color gets applied.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      highPointColor: Colors.red
  ///       )
  ///     ),
  ///  );
  /// }
  /// ```
  final Color? highPointColor;

  /// Customizes the color of the lowest rectangular column segment.
  ///
  /// When the lowest data point is the first or last data point of the provided
  /// data set, then either the first or last point color gets applied.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      lowPointColor: Colors.red
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? lowPointColor;

  /// Customizes the color of negative data point and data point value less than
  /// the [axisCrossesAt] value.
  ///
  /// If the negative data point is either the high or low, first or last data
  /// point, then priority will be given to those colors.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      negativePointColor: Colors.red
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? negativePointColor;

  /// Customizes the color of the first rectangular column segment.
  ///
  /// If the first data point is either the high data point or low data point,
  /// then the priority will be given to firstPointColor property.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      firstPointColor: Colors.red
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? firstPointColor;

  /// Customizes the color of the last rectangular column segment.
  ///
  /// If the last data point is either the high data point or low data point,
  /// then the priority will be given to lastPointColor propety.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      lastPointColor: Colors.red
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? lastPointColor;

  /// Customizes the spark win loss chart color.
  ///
  /// Defaults to `Colors.blue`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      color: Colors.blue
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final Color color;

  /// Render plot band.
  ///
  /// Plot band is also known as stripline, which is used to shade the different
  /// ranges in plot area with different colors to improve the readability of
  /// the chart.
  ///
  /// Plot bands are drawn based on the axis.
  ///
  /// Provides the property of `start`, `end`, `color`, `borderColor`, and
  /// `borderWidth` to customize the appearance.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25)
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final SparkChartPlotBand? plotBand;

  /// Customizes the border width of each rectangular column segment.
  /// To render the border, both the border width and border color property
  /// needs to be set.
  ///
  /// Defaults to `0`
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      borderWidth: 4
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// Customizes the border color of each rectangular column segment.
  /// The border will be rendered on the top of the spark area chart.
  /// To render the border, both the [borderWidth] and borderColor property
  /// needs to be set.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///       borderColor: Colors.red
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? borderColor;

  /// Customizes the color of tie data point rectangular segment and the data
  /// point value is equal to the [axisCrossesAt] value, is considered as a
  /// tie point.
  ///
  /// If the tie data point is either the high or low, first or last data point,
  /// then priority will be given to tie point color.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      tiePointColor: Colors.blue
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? tiePointColor;

  /// Enables and customizes the trackball.
  ///
  /// Trackball feature displays the tooltip for the data points that are closer
  /// to the point where you touch on the chart area. This feature can be
  /// enabled by creating an instance of [SparkChartTrackball].
  ///
  /// Provides option to customizes the `activationMode`, `width`, `color`,
  /// `labelStyle`, `backgroundColor`, `borderColor`, `borderWidth`.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkWinLossChart(
  ///      trackball: SparkChartTrackball(activationMode: SparkChartActivationMode.tap)
  ///       )
  ///     ),
  ///  );
  /// }
  final SparkChartTrackball? trackball;

  /// Specifies the spark chart data details.
  final SparkChartDataDetails _sparkChartDataDetails;

  @override
  State<StatefulWidget> createState() {
    return _SfSparkWinLossChartState();
  }
}

/// Represents the state class for spark win loss chart widget.
class _SfSparkWinLossChartState extends State<SfSparkWinLossChart> {
  /// specifies the theme of the chart.
  late SfChartThemeData _chartThemeData;

  /// Specifies the series screen coordinate points.
  late List<Offset> _coordinatePoints;

  /// Specifies the series data points.
  late List<SparkChartPoint> _dataPoints;

  /// Called when this object is inserted into the tree.
  ///
  /// The framework will call this method exactly once for each State object it creates.
  ///
  /// Override this method to perform initialization that depends on the location at
  /// which this object was inserted into the tree or on the widget used to configure this object.
  ///
  /// * In [initState], subscribe to the object.

  @override
  void initState() {
    _coordinatePoints = <Offset>[];
    _dataPoints = <SparkChartPoint>[];
    super.initState();
  }

  /// Called when a dependency of this [State] object changes.
  ///
  /// For example, if the previous call to [build] referenced an [InheritedWidget] that later changed,
  /// the framework would call this method to notify this object about the change.
  ///
  /// This method is also called immediately after [initState]. It is safe to call [BuildContext.dependOnInheritedWidgetOfExactType] from this method.

  @override
  void didChangeDependencies() {
    _chartThemeData = SfChartTheme.of(context);
    super.didChangeDependencies();
  }

  /// Called whenever the widget configuration changes.
  ///
  /// If the parent widget rebuilds and request that this location in the tree update to display a new widget with the same [runtimeType] and [Widget.key],
  /// the framework will update the widget property of this [State] object to refer to the new widget and then call this method with the previous widget as an argument.
  ///
  /// Override this method to respond when the widget changes.
  ///
  /// The framework always calls [build] after calling [didUpdateWidget], which means any calls to [setState] in [didUpdateWidget] are redundant.
  ///
  /// * In [didUpdateWidget] unsubscribe from the old object and subscribe to the new one if the updated widget configuration requires replacing the object.

  @override
  void didUpdateWidget(SfSparkWinLossChart oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method in a number of different situations. For example:
  ///
  /// * After calling [initState].
  /// * After calling [didUpdateWidget].
  /// * After receiving a call to [setState].
  /// * After a dependency of this [State] object changes.

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        child: SparkChartContainer(
            child: Stack(children: <Widget>[
      SfSparkWinLossChartRenderObjectWidget(
          data: widget._sparkChartDataDetails.data,
          dataCount: widget._sparkChartDataDetails.dataCount,
          xValueMapper: widget._sparkChartDataDetails.xValueMapper,
          yValueMapper: widget._sparkChartDataDetails.yValueMapper,
          isInversed: widget.isInversed,
          axisCrossesAt: widget.axisCrossesAt,
          axisLineColor: widget.axisLineColor,
          axisLineWidth: widget.axisLineWidth,
          axisLineDashArray: widget.axisLineDashArray,
          highPointColor: widget.highPointColor,
          lowPointColor: widget.lowPointColor,
          firstPointColor: widget.firstPointColor,
          lastPointColor: widget.lastPointColor,
          negativePointColor: widget.negativePointColor,
          color: widget.color,
          tiePointColor: widget.tiePointColor,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth,
          plotBand: widget.plotBand,
          themeData: _chartThemeData,
          sparkChartDataDetails: widget._sparkChartDataDetails,
          dataPoints: _dataPoints,
          coordinatePoints: _coordinatePoints),
      SparkChartTrackballRenderer(
        trackball: widget.trackball,
        coordinatePoints: _coordinatePoints,
        dataPoints: _dataPoints,
      )
    ])));
  }
}
