import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../marker.dart';
import '../plot_band.dart';
import '../renderers/spark_area_renderer.dart';
import '../trackball/spark_chart_trackball.dart';
import '../trackball/trackball_renderer.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Represents the spark area chart widget
class SfSparkAreaChart extends StatefulWidget {
  /// Creates the spark area chart
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  SfSparkAreaChart(
      {Key key,
      List<num> data,
      this.plotBand,
      this.borderWidth = 0,
      this.borderColor,
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
      this.marker,
      this.labelDisplayMode,
      this.labelStyle = const TextStyle(
          fontFamily: 'Roboto',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 12),
      this.trackball})
      : _sparkChartDataDetails = SparkChartDataDetails(data: data),
        super(key: key);

  /// Create the spark area chart with custom data source
  ///
  /// ```dart
  /// class SalesData {
  /// SalesData(this.month, this.sales);
  /// final String month;
  /// final double sales;
  /// }
  ///
  ///   List<SalesData> data;

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
  ///        child: SfSparkAreaChart.custom(
  ///         dataCount: 5,
  ///          xValueMapper: (int index) => data[index].month,
  ///          yValueMapper: (int index) => data[index].sales
  ///    )),
  ///  );
  /// }
  /// ```

  SfSparkAreaChart.custom(
      {Key key,

      /// Data count for the spark charts.
      int dataCount,

      /// Specifies the x-value mapping field
      SparkChartIndexedValueMapper<dynamic> xValueMapper,

      /// Specifies the y-value maping field
      SparkChartIndexedValueMapper<num> yValueMapper,
      this.plotBand,
      this.borderWidth = 2,
      this.borderColor,
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
      this.marker,
      this.labelDisplayMode,
      this.labelStyle = const TextStyle(
          fontFamily: 'Roboto',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 12),
      this.trackball})
      : _sparkChartDataDetails = SparkChartDataDetails(
            dataCount: dataCount,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper),
        super(key: key);

  /// Specifies whether to inverse the spark area chart rendering.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      isInversed: true,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final bool isInversed;

  /// Specifies the axis line's position.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      axisCrossesAt: 14,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final double axisCrossesAt;

  /// Specifies the width of the axis line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      axisLineWidth: 4,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final double axisLineWidth;

  /// Specified the color of the axis line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      axisLineColor: Colors.red,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color axisLineColor;

  /// Specifies the dash array value of the axis line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      axisLineDashArray: <double>[2,2],
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final List<double> axisLineDashArray;

  /// Specifies the highest data point color.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      highPointColor: Colors.red,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color highPointColor;

  /// Specifies the lowest data point color.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      lowPointColor: Colors.red,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color lowPointColor;

  /// Specifies the negative point color.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      negativePointColor: Colors.red,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color negativePointColor;

  /// Specifies the first point color.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      firstPointColor: Colors.red,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color firstPointColor;

  /// Specifies the last point color.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      lastPointColor: Colors.red,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color lastPointColor;

  /// Specifies the color of the spark area chart.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      color: Colors.blue,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color color;

  /// Represents the plot band settings for spark area chart.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final SparkChartPlotBand plotBand;

  /// Specifies the Border width of the series.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      boderWidth: 2,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final double borderWidth;

  /// Specifies the Border color of the series.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      boderWidth: 2,
  ///      borderColor: Colors.black,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color borderColor;

  /// Represents the marker settings of spark chart.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      boderWidth: 2,
  ///      marker: SparkChartMarker(borderWidth: 3, size: 20,
  ///    shape: MarkerShape.circle, displayMode: MarkerDisplayMode.all),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```

  final SparkChartMarker marker;

  /// Specifies the spark area data label
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      boderWidth: 2,
  ///      labelDisplayMode: SparkChartLabelDisplayode.high,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final SparkChartLabelDisplayMode labelDisplayMode;

  /// Specifies the spark area data label
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      boderWidth: 2,
  ///      labelStyle: TextStyle(fontStyle: FontStyle.italic),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final TextStyle labelStyle;

  /// Represents the track ball options of spark area chart.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(borderWidth: 2,
  ///      borderColor: Colors.black, SparkChartActivationMode: ActivationMode.doubleTap),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final SparkChartTrackball trackball;

  /// Specifies the spark chart data details
  final SparkChartDataDetails _sparkChartDataDetails;

  @override
  State<StatefulWidget> createState() {
    return _SfSparkAreaChartState();
  }
}

/// Represents the state class for spark area widget
class _SfSparkAreaChartState extends State<SfSparkAreaChart> {
  /// specifies the theme of the chart
  ThemeData _themeData;

  /// Specifies the series screen coordinate points
  List<Offset> _coordinatePoints;

  /// Specifies the series data points
  List<SparkChartPoint> _dataPoints;

  @override
  void initState() {
    _coordinatePoints = <Offset>[];
    _dataPoints = <SparkChartPoint>[];
    super.initState();
  }

  @override
  void didUpdateWidget(SfSparkAreaChart oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _themeData = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.marker != null &&
        widget.marker.displayMode != SparkChartMarkerDisplayMode.none) {
      final double padding = widget.marker.size / 2;
      return RepaintBoundary(
          child: Padding(
              padding: EdgeInsets.all(padding), child: _getSparkAreaChart()));
    } else {
      return RepaintBoundary(child: _getSparkAreaChart());
    }
  }

  /// Method to return the spark area chart widget
  Widget _getSparkAreaChart() {
    return SparkChartContainer(
        child: Stack(children: [
      SfSparkAreaChartRenderObjectWidget(
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
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth,
          plotBand: widget.plotBand,
          marker: widget.marker,
          labelDisplayMode: widget.labelDisplayMode,
          labelStyle: widget.labelStyle,
          themeData: _themeData,
          sparkChartDataDetails: widget._sparkChartDataDetails,
          dataPoints: _dataPoints,
          coordinatePoints: _coordinatePoints),
      SparkChartTrackballRenderer(
          trackball: widget.trackball,
          coordinatePoints: _coordinatePoints,
          dataPoints: _dataPoints,
          sparkChart: widget)
    ]));
  }
}
