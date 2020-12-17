import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../marker.dart';
import '../plot_band.dart';
import '../renderers/spark_line_renderer.dart';
import '../trackball/spark_chart_trackball.dart';
import '../trackball/trackball_renderer.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Represents the spark line chart
class SfSparkLineChart extends StatefulWidget {
  /// Creates the spark line chart
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkLineChart(
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  SfSparkLineChart(
      {Key key,
      List<num> data,
      this.plotBand,
      this.width = 2,
      this.dashArray,
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

  /// Create the spark line chart with custom data source
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
  ///        child: SfSparkLineChart.custom(
  ///         dataCount: 5,
  ///          xValueMapper: (int index) => data[index].month,
  ///          yValueMapper: (int index) => data[index].sales
  ///    )),
  ///  );
  /// }
  /// ```

  SfSparkLineChart.custom(
      {Key key,

      /// Data count for the spark charts.
      int dataCount,

      /// Specifies the x-value mapping field
      SparkChartIndexedValueMapper<dynamic> xValueMapper,

      /// Specifies the y-value maping field
      SparkChartIndexedValueMapper<num> yValueMapper,
      this.plotBand,
      this.width = 2,
      this.dashArray,
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
      this.trackball,
      this.marker,
      this.labelDisplayMode,
      this.labelStyle = const TextStyle(
          fontFamily: 'Roboto',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 12)})
      : _sparkChartDataDetails = SparkChartDataDetails(
            dataCount: dataCount,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper),
        super(key: key);

  /// Specifies whether to inverse the spark line chart rendering.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkLineChart(
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
  ///        child: SfSparkLineChart(
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
  ///        child: SfSparkLineChart(
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
  ///        child: SfSparkLineChart(
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
  ///        child: SfSparkLineChart(
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
  ///        child: SfSparkLineChart(
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
  ///        child: SfSparkLineChart(
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
  ///        child: SfSparkLineChart(
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
  ///        child: SfSparkLineChart(
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
  ///        child: SfSparkLineChart(
  ///      lastPointColor: Colors.red,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color lastPointColor;

  /// Specifies the color of the spark line chart.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkLineChart(
  ///      color: Colors.blue,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color color;

  /// Represents the plot band settings for spark line chart.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkLineChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final SparkChartPlotBand plotBand;

  /// Specifies the width of the series.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkLineChart(
  ///      width: 4,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final double width;

  /// Specifies the Dash array value of series.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkLineChart(
  ///      dashArray: <double>[2,2],
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final List<double> dashArray;

  /// Represents the track ball options of spark line chart.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkLineChart(
  ///      trackball:(borderWidth: 2,
  ///      borderColor: Colors.black, activationMode: SparkChartActivationMode.doubleTap),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final SparkChartTrackball trackball;

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

  /// Specifies the spark line data label
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

  /// Specifies the spark chart data details
  final SparkChartDataDetails _sparkChartDataDetails;

  @override
  State<StatefulWidget> createState() {
    return _SfSparkLineChartState();
  }
}

/// Represents the state class for spark line chart widget
class _SfSparkLineChartState extends State<SfSparkLineChart> {
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
  void didChangeDependencies() {
    _themeData = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfSparkLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.marker != null &&
        widget.marker.displayMode != SparkChartMarkerDisplayMode.none) {
      final double padding = widget.marker.size / 2;
      return RepaintBoundary(
          child: Padding(
              padding: EdgeInsets.all(padding), child: _getSparkLineChart()));
    } else {
      return RepaintBoundary(child: _getSparkLineChart());
    }
  }

  /// Method to return the spark line chart widget
  Widget _getSparkLineChart() {
    return SparkChartContainer(
        child: Stack(children: <Widget>[
      SfSparkLineChartRenderObjectWidget(
          data: widget._sparkChartDataDetails.data,
          dataCount: widget._sparkChartDataDetails.dataCount,
          xValueMapper: widget._sparkChartDataDetails.xValueMapper,
          yValueMapper: widget._sparkChartDataDetails.yValueMapper,
          width: widget.width,
          dashArray: widget.dashArray,
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
      )
    ]));
  }
}
