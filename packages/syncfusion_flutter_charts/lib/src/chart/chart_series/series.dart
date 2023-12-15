import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/template/rendering.dart';
import '../../common/user_interaction/tooltip.dart';
import '../../common/user_interaction/tooltip_rendering_details.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../chart_segment/chart_segment.dart';
import '../common/cartesian_state_properties.dart';
import '../common/interactive_tooltip.dart';
import '../trendlines/trendlines.dart';
import '../user_interaction/trackball.dart';
import '../user_interaction/trackball_painter.dart';
import '../user_interaction/trackball_template.dart';
import '../utils/helper.dart';
import 'series_renderer_properties.dart';

/// This class has the properties of the cartesian series.
///
/// The cartesian series provides a variety of options, such as animation, dynamic animation, transpose, color palette,
/// color mapping to customize the Cartesian chart. The chart’s data source can be sorted using the sorting order and
/// [sortFieldValueMapper] properties of series.
///
/// Provides the options for animation, color palette, sorting, and empty point mode to customize the charts.
///
abstract class CartesianSeries<T, D> extends ChartSeries<T, D> {
  /// Creating an argument constructor of [CartesianSeries] class.
  CartesianSeries(
      {this.key,
      this.xValueMapper,
      this.yValueMapper,
      this.dataLabelMapper,
      this.name,
      required this.dataSource,
      this.xAxisName,
      this.yAxisName,
      this.sizeValueMapper,
      this.pointColorMapper,
      this.color,
      this.legendItemText,
      this.sortFieldValueMapper,
      this.gradient,
      this.borderGradient,
      this.width,
      this.highValueMapper,
      this.lowValueMapper,
      this.intermediateSumPredicate,
      this.totalSumPredicate,
      this.trendlines,
      this.onRendererCreated,
      this.onCreateRenderer,
      this.onPointTap,
      this.onPointDoubleTap,
      this.onPointLongPress,
      this.onCreateShader,
      MarkerSettings? markerSettings,
      bool? isVisible,
      bool? enableTooltip,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      double? animationDuration,
      List<double>? dashArray,
      List<int>? initialSelectedDataIndexes,
      Color? borderColor,
      double? borderWidth,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      double? opacity,
      double? animationDelay,
      SortingOrder? sortingOrder})
      : isVisible = isVisible ?? true,
        markerSettings = markerSettings ?? const MarkerSettings(),
        dataLabelSettings = dataLabelSettings ?? const DataLabelSettings(),
        enableTooltip = enableTooltip ?? true,
        emptyPointSettings = emptyPointSettings ?? EmptyPointSettings(),
        dashArray = dashArray ?? <double>[0, 0],
        assert(dashArray == null || dashArray.isNotEmpty,
            'The dashArray list must not be empty'),
        initialSelectedDataIndexes = initialSelectedDataIndexes ?? <int>[],
        animationDuration = animationDuration ?? 1500,
        borderColor = borderColor ?? Colors.transparent,
        selectionBehavior = selectionBehavior ?? SelectionBehavior(),
        legendIconType = legendIconType ?? LegendIconType.seriesType,
        isVisibleInLegend = isVisibleInLegend ?? true,
        borderWidth = borderWidth ?? 0,
        opacity = opacity ?? 1,
        animationDelay = animationDelay ?? 0,
        sortingOrder = sortingOrder ?? SortingOrder.none,
        super(
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            selectionBehavior: selectionBehavior,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            animationDelay: animationDelay,
            opacity: opacity);

  /// Key to identify a series in a collection.
  ///
  /// On specifying [ValueKey] as the series [key], existing series index can be changed in the series collection without losing its state.
  ///
  /// When a new series is added dynamically to the collection, existing series index will be changed. On that case,
  /// the existing series and its state will be linked based on its chart type and this key value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<SalesData, num>>[
  ///       LineSeries<SalesData, num>(
  ///         key: const ValueKey<String>('line_series_key'),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ValueKey<String>? key;

  /// Used to create the renderer for custom series.
  ///
  /// This is applicable only when the custom series is defined in the sample
  /// and for built-in series types, it is not applicable.
  ///
  /// Renderer created in this will hold the series state and
  /// this should be created for each series. [onCreateRenderer] callback
  /// function should return the renderer class and should not return null.
  ///
  /// Series state will be created only once per series and will not be created
  /// again when we update the series.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<SalesData, num>>[
  ///       LineSeries<SalesData, num>(
  ///         onCreateRenderer:(ChartSeries<dynamic, dynamic> series){
  ///           return CustomLinerSeriesRenderer();
  ///         }
  ///       ),
  ///     ],
  ///   );
  /// }
  /// class CustomLinerSeriesRenderer extends LineSeriesRenderer {
  ///   CustomLinerSeriesRenderer(this.series);
  ///     final ColumnSeries<SalesData, num> series;
  ///
  ///    @override
  ///    int get currentSegmentIndex => super.currentSegmentIndex!;
  ///
  ///    @override
  ///    Paint getFillPaint() {
  ///      final Paint customerFillPaint = Paint();
  ///      customerFillPaint.color = series.dataSource[currentSegmentIndex].y > 30
  ///        ? Colors.red
  ///        : Colors.green;
  ///      customerFillPaint.style = PaintingStyle.fill;
  ///      return customerFillPaint;
  ///    }
  ///
  ///    @override
  ///    void onPaint(Canvas canvas) {
  ///      super.onPaint(canvas);
  ///    }
  /// }
  /// ```
  final ChartSeriesRendererFactory<T, D>? onCreateRenderer;

  /// Triggers when the series renderer is created.
  ///
  /// Using this callback, able to get the [ChartSeriesController] instance, which is used to access the public methods in the series.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   ChartSeriesController? _chartSeriesController;
  ///   return Column(
  ///     children: <Widget>[
  ///       SfCartesianChart(
  ///         series: <LineSeries<SalesData, num>>[
  ///           LineSeries<SalesData, num>(
  ///             onRendererCreated: (ChartSeriesController controller) {
  ///               _chartSeriesController = controller;
  ///             },
  ///           ),
  ///         ]
  ///       ),
  ///       TextButton(
  ///         child: Text("Animate series"),
  ///         onPressed: () {
  ///           _chartSeriesController?.animate();
  ///         }
  ///       )
  ///     ]
  ///   );
  ///  }
  /// ```
  final SeriesRendererCreatedCallback? onRendererCreated;

  /// Called when tapped on the chart data point.
  ///
  /// The user can fetch the series index, point index, viewport point index and
  /// data of the tapped data point.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<SalesData, num>>[
  ///       LineSeries<SalesData, num>(
  ///         onPointTap: (ChartPointDetails details) {
  ///           print(details.pointIndex);
  ///         },
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ChartPointInteractionCallback? onPointTap;

  /// Called when double tapped on the chart data point.
  ///
  /// The user can fetch the series index, point index, viewport point index and
  /// data of the double-tapped data point.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<SalesData, num>>[
  ///       LineSeries<SalesData, num>(
  ///         onPointDoubleTap: (ChartPointDetails details) {
  ///           print(details.pointIndex);
  ///         },
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ChartPointInteractionCallback? onPointDoubleTap;

  /// Called when long pressed on the chart data point.
  ///
  /// The user can fetch the series index, point index, viewport point index and
  /// data of the long-pressed data point.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<SalesData, num>>[
  ///       LineSeries<SalesData, num>(
  ///         onPointLongPress: (ChartPointDetails details) {
  ///           print(details.pointIndex);
  ///         },
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ChartPointInteractionCallback? onPointLongPress;

  /// Data required for rendering the series.
  ///
  /// If no data source is specified, empty chart will be rendered without series.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<SalesData, num>>[
  ///       ColumnSeries<SalesData, num>(
  ///         dataSource: chartData,
  ///         xValueMapper: (SalesData sales, _) => sales.x,
  ///         yValueMapper: (SalesData sales, _) => sales.y,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// final List<SalesData> chartData = <SalesData>[
  ///   SalesData(1, 23),
  ///   SalesData(2, 35),
  ///   SalesData(3, 19)
  /// ];
  ///
  /// class SalesData {
  ///   SalesData(this.x, this.y);
  ///     final double x;
  ///     final double y;
  /// }
  /// ```
  @override
  final List<T> dataSource;

  /// Field in the data source, which is considered as x-value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<SalesData, num>>[
  ///       ColumnSeries<SalesData, num>(
  ///         dataSource: chartData,
  ///         xValueMapper: (SalesData sales, _) => sales.x,
  ///         yValueMapper: (SalesData sales, _) => sales.y,
  ///       ),
  ///     ],
  ///   );
  /// }
  ///
  /// final List<SalesData> chartData = <SalesData>[
  ///   SalesData(1, 23),
  ///   SalesData(2, 35),
  ///   SalesData(3, 19)
  /// ];
  ///
  /// class SalesData {
  ///   SalesData(this.x, this.y);
  ///     final double x;
  ///     final double y;
  /// }
  /// ```
  @override
  final ChartIndexedValueMapper<D>? xValueMapper;

  /// Field in the data source, which is considered as y-value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<SalesData, num>>[
  ///       ColumnSeries<SalesData, num>(
  ///         dataSource: chartData,
  ///         xValueMapper: (SalesData sales, _) => sales.x,
  ///         yValueMapper: (SalesData sales, _) => sales.y,
  ///       ),
  ///     ],
  ///   );
  /// }
  ///
  /// final List<SalesData> chartData = <SalesData>[
  ///   SalesData(1, 23),
  ///   SalesData(2, 35),
  ///   SalesData(3, 19)
  /// ];
  ///
  /// class SalesData {
  ///   SalesData(this.x, this.y);
  ///     final double x;
  ///     final double y;
  /// }
  /// ```
  @override
  final ChartIndexedValueMapper<dynamic>? yValueMapper;

  /// Field in the data source, which is considered as fill color for the data points.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<ColumnColors, num>>[
  ///       ColumnSeries<ColumnColors, num>(
  ///         dataSource: chartData,
  ///         xValueMapper: (ColumnColors sales, _) => sales.x,
  ///         yValueMapper: (ColumnColors sales, _) => sales.y,
  ///         pointColorMapper: (ColumnColors sales, _) => sales.pointColorMapper,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// final List<ColumnColors> chartData = <ColumnColors>[
  ///   ColumnColors(1991, 7.8, const Color.fromRGBO(0, 0, 255, 1)),
  ///   ColumnColors(1992, 6.5, const Color.fromRGBO(255, 0, 0, 1)),
  ///   ColumnColors(1993, 6.0, const Color.fromRGBO(255, 100, 102, 1)),
  /// ];
  /// class ColumnColors {
  ///   ColumnColors(this.x, this.y,this.pointColorMapper);
  ///     final num x;
  ///     final num y;
  ///     final Color pointColorMapper;
  /// }
  /// ```
  @override
  final ChartIndexedValueMapper<Color>? pointColorMapper;

  /// Field in the data source, which is considered as text for the data points.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         dataSource: <SalesData>[
  ///           SalesData(DateTime(2005, 0, 1), 'India', 16),
  ///           SalesData(DateTime(2006, 0, 1), 'China', 12),
  ///           SalesData(DateTime(2007, 0, 1), 'USA',18),
  ///         ],
  ///         dataLabelSettings: DataLabelSettings(isVisible:true),
  ///         dataLabelMapper: (SalesData data, _) => data.category,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// class SalesData {
  ///   SalesData(this.year, this.category, this.sales1);
  ///     final DateTime year;
  ///     final String category;
  ///     final int sales1;
  /// }
  /// ```
  @override
  final ChartIndexedValueMapper<String>? dataLabelMapper;

  /// Field in the data source, which is considered as size of the bubble for
  /// all the data points.
  ///
  /// _Note:_ This is applicable only for bubble series.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         dataSource: chartData,
  ///         sizeValueMapper: (BubbleColors sales, _) => sales.bubbleSize,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// final List<BubbleColors> chartData = <BubbleColors>[
  ///   BubbleColors(92.2, 7.8, 1.347),
  ///   BubbleColors(74, 6.5, 1.241),
  ///   BubbleColors(90.4, 6.0, 0.238),
  ///   BubbleColors(99.4, 2.2, 0.197),
  /// ];
  /// class BubbleColors {
  ///   BubbleColors(this.year, this.growth,[this.bubbleSize]);
  ///     final num year;
  ///     final num growth;
  ///     final num bubbleSize;
  /// }
  /// ```
  final ChartIndexedValueMapper<num>? sizeValueMapper;

  /// Field in the data source, which is considered as high value for the data points.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <RangeColumnSeries<SalesData, num>>[
  ///       RangeColumnSeries<SalesData, num>(
  ///         dataSource: <SalesData>[
  ///           SalesData(2005, 24, 16),
  ///           SalesData(2006, 22, 12),
  ///           SalesData(2007, 31, 18),
  ///         ],
  ///         xValueMapper: (SalesData data, _) => data.year,
  ///         lowValueMapper: (SalesData data, _) => data.low,
  ///         highValueMapper: (SalesData data, _) => data.high,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// class SalesData {
  ///   SalesData(this.year, this.high, this.low);
  ///     final num year;
  ///     final num high;
  ///     final num low;
  /// }
  /// ```
  final ChartIndexedValueMapper<num>? highValueMapper;

  /// Field in the data source, which is considered as low value for the data points.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return SfCartesianChart(
  ///      series: <RangeColumnSeries<SalesData, num>>[
  ///        RangeColumnSeries<SalesData, num>(
  ///          dataSource: <SalesData>[
  ///            SalesData(2005, 24, 16),
  ///            SalesData(2006, 22, 12),
  ///            SalesData(2007, 31, 18),
  ///          ],
  ///         xValueMapper: (SalesData data, _) => data.year,
  ///         lowValueMapper: (SalesData data, _) => data.low,
  ///         highValueMapper: (SalesData data, _) => data.high,
  ///        ),
  ///      ],
  ///    );
  /// }
  /// class SalesData {
  ///   SalesData(this.year, this.high, this.low);
  ///     final num year;
  ///     final num high;
  ///     final num low;
  /// }
  /// ```
  final ChartIndexedValueMapper<num>? lowValueMapper;

  /// A boolean value, based on which the data point will be considered as intermediate sum or not.
  ///
  /// If this has true value, then that point will be considered as an intermediate sum. Else if
  /// it has false, then it will be considered as a normal data point in chart.
  ///
  /// This callback will be called for all the data points to check if the data is intermediate sum.
  ///
  /// _Note:_  This is applicable only for waterfall chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         dataSource: <SalesData>[
  ///           SalesData(2, 24, true),
  ///           SalesData(3, 22, false),
  ///           SalesData(4, 31, true),
  ///         ],
  ///         xValueMapper: (SalesData sales, _) => sales.x,
  ///         yValueMapper: (SalesData sales, _) => sales.y,
  ///         intermediateSumPredicate: (SalesData data, _) => data.isIntermediate,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// class SalesData {
  ///   SalesData(this.x, this.y, this.isIntermediate);
  ///     final num x;
  ///     final num y;
  ///     final bool isIntermediate;
  /// }
  /// ```
  final ChartIndexedValueMapper<bool>? intermediateSumPredicate;

  /// A boolean value, based on which the data point will be considered as total sum or not.
  ///
  /// If this has true value, then that point will be considered as a total sum. Else if
  /// it has false, then it will be considered as a normal data point in chart.
  ///
  /// This callback will be called for all the data points to check if the data is total sum.
  ///
  /// _Note:_ This is applicable only for waterfall chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         dataSource: <SalesData>[
  ///           SalesData(2, 24, true),
  ///           SalesData(3, 22, true),
  ///           SalesData(4, 31, false),
  ///         ],
  ///         xValueMapper: (SalesData sales, _) => sales.x,
  ///         yValueMapper: (SalesData sales, _) => sales.y,
  ///         totalSumPredicate: (SalesData data, _) => data.isTotalSum,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// class SalesData {
  ///   SalesData(this.x, this.y, this.isTotalSum);
  ///     final num x;
  ///     final num y;
  ///     final bool isTotalSum;
  /// }
  /// ```
  final ChartIndexedValueMapper<bool>? totalSumPredicate;

  /// Name of the x-axis to bind the series.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return SfCartesianChart(
  ///      axes: <ChartAxis>[
  ///        NumericAxis(
  ///          name: 'xAxis1'
  ///        )
  ///      ],
  ///      series: <BubbleSeries<BubbleColors, num>>[
  ///        BubbleSeries<BubbleColors, num>(
  ///          xAxisName: 'xAxis1',
  ///        ),
  ///      ],
  ///    );
  /// }
  /// ```
  final String? xAxisName;

  /// Name of the y-axis to bind the series.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return SfCartesianChart(
  ///      axes: <ChartAxis>[
  ///        NumericAxis(
  ///          name: 'yAxis1'
  ///        )
  ///      ],
  ///      series: <BubbleSeries<BubbleColors, num>>[
  ///        BubbleSeries<BubbleColors, num>(
  ///          yAxisName: 'yAxis1',
  ///        ),
  ///      ],
  ///    );
  /// }
  /// ```
  final String? yAxisName;

  /// Color of the series.
  ///
  /// If no color is specified, then the series will be rendered
  /// with the default palette color.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         color: const Color.fromRGBO(255, 0, 102, 1),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? color;

  /// Width of the series.
  ///
  /// In line, spline, step line, and fast line series, width
  /// of the line will be changed. In column series, width of the column rectangle will
  /// be changed. In bar series, the height of the bar rectangle will be changed.
  ///
  /// _Note:_ This is not applicable for area, scatter, and bubble series.
  ///
  /// Default to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<LineData, num>>[
  ///       LineSeries<LineData, num>(
  ///         width: 3,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? width;

  /// Indication of data points.
  ///
  /// Marks the data point location with symbols for better
  /// indication. The shape, color, border, and size of the marker can be customized.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<LineData, num>>[
  ///       LineSeries<LineData, num>(
  ///         markerSettings: MarkerSettings(isVisible: true)
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final MarkerSettings markerSettings;

  /// Customizes the empty points, i.e. null data points in a series.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<ColumnData, num>>[
  ///       ColumnSeries<ColumnData, num>(
  ///         emptyPointSettings: EmptyPointSettings(color: Colors.black)
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final EmptyPointSettings emptyPointSettings;

  /// Customizes the data labels in a series. Data label is a text, which displays
  /// the details about the data point.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<ChartData, num>>[
  ///       LineSeries<ChartData, num>(
  ///         dataLabelSettings: DataLabelSettings(isVisible: true),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final DataLabelSettings dataLabelSettings;

  /// Customizes the trendlines.
  ///
  /// Trendline are used to mark the specific area of interest
  /// in the plot area with texts, shapes, or images.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<ChartData, num>>[
  ///       LineSeries<ChartData, num>(
  ///         trendlines: <ChartTrendline>[
  ///           Trendline(
  ///             type: TrendlineType.linear
  ///           )
  ///         ]
  ///       )
  ///     ],
  ///   );
  /// }
  /// ```
  final List<Trendline>? trendlines;

  /// Fills the chart series with gradient color.
  ///
  /// Default to `null`.
  ///
  /// ```dart
  /// final List<Color> color = <Color>[Colors.red, Colors.blue, Colors.pink];
  /// final List<double> stops = <double>[0.0, 0.5, 1.0];
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, String>>[
  ///       BarSeries<SalesData, String>(
  ///         gradient: LinearGradient(colors: color, stops: stops)
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final LinearGradient? gradient;

  /// Fills the border of the chart series with gradient color.
  ///
  /// Default to `null`.
  ///
  /// ```dart
  /// final List<Color> color = <Color>[Colors.red, Colors.blue, Colors.pink];
  /// final List<double> stops = <double>[0.0, 0.5, 1.0];
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, String>>[
  ///       BarSeries<SalesData, String>(
  ///         borderGradient: LinearGradient(colors: color, stops: stops),
  ///         borderWidth: 3
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final LinearGradient? borderGradient;

  /// Name of the series.
  ///
  /// The name will be displayed in legend item by default.
  /// If name is not specified for the series, then the current series index with series
  /// text prefix will be considered as series name.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleData, num>>[
  ///       BubbleSeries<BubbleData, num>(
  ///         name: 'Bubble Series',
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final String? name;

  /// Enables or disables the tooltip for this series.
  ///
  /// Tooltip will display more details about data points when tapping the data point region.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: TooltipBehavior(enable: true),
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         enableTooltip: true,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final bool enableTooltip;

  /// Dashes of the series.
  ///
  /// Any number of values can be provided in the list. Odd value
  /// is considered as rendering size and even value is considered as gap.
  ///
  /// _Note:_ This is applicable for line, spline, step line, and fast line series only.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return SfCartesianChart(
  ///      series: <LineSeries<SalesData, String>>[
  ///        LineSeries<SalesData, String>(
  ///          dashArray: <double>[10, 10],
  ///        ),
  ///      ],
  ///    );
  /// }
  /// ```
  final List<double> dashArray;

  /// Duration of the series animation. It takes millisecond value as input.
  ///
  /// Series will be animated while rendering. Animation is enabled by default,
  /// you can also control the duration of the animation using `animationDuration` property.
  /// You can disable the animation by setting 0 value to that property.
  ///
  /// Defaults to `1500`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<SalesData, String>>[
  ///       LineSeries<SalesData, String>(
  ///         animationDuration: 1000,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final double animationDuration;

  /// Border color of the series.
  ///
  /// _Note:_ This is not applicable for line, spline, step line, stacked line, stacked line 100
  /// and fast line series types.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<SalesData, String>>[
  ///       ColumnSeries<SalesData, String>(
  ///         borderColor: Colors.red,
  ///         borderWidth: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final Color borderColor;

  /// Border width of the series.
  ///
  /// _Note:_ This is not applicable for line, spline, step line, stacked line, stacked line 100
  /// and fast line series types.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<SalesData, String>>[
  ///       ColumnSeries<SalesData, String>(
  ///         borderColor: Colors.red,
  ///         borderWidth: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final double borderWidth;

  /// Shape of the legend icon.
  ///
  /// Any shape in the LegendIconType can be applied to this property. By default, icon will be rendered based on the type of the series.
  ///
  /// Defaults to `LegendIconType.seriesType`.
  ///
  /// Also refer [LegendIconType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(isVisible:true),
  ///     series: <LineSeries<SalesData, String>>[
  ///       LineSeries<SalesData, String>(
  ///         legendIconType: LegendIconType.diamond,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final LegendIconType legendIconType;

  /// Toggles the visibility of the legend item of this specific series in the legend.
  ///
  /// If it is set to false, the legend item for this series will not be visible in the legend.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(isVisible:true),
  ///     series: <LineSeries<SalesData, String>>[
  ///       LineSeries<SalesData, String>(
  ///         isVisibleInLegend: false
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool isVisibleInLegend;

  /// Text to be displayed in legend.
  ///
  /// By default, the series name will be displayed in the legend. You can change this by setting values to this property.
  ///
  /// Defaults to `‘’`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(isVisible:true),
  ///     series: <LineSeries<SalesData, String>>[
  ///       LineSeries<SalesData, String>(
  ///         legendItemText: 'Legend'
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final String? legendItemText;

  /// Customizes the data points or series on selection.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: SelectionBehavior(
  ///           enable:true
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final SelectionBehavior selectionBehavior;

  /// Opacity of the series.
  ///
  /// The value ranges from 0 to 1. It used to control the transparency of the legend icon shape.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         opacity: 0.8
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final double opacity;

  /// Field in the data source, which is considered for sorting the data points.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<SalesData, num>>[
  ///       ColumnSeries<SalesData, num>(
  ///         dataSource: chartData,
  ///         xValueMapper: (SalesData sales, _) => sales.x,
  ///         yValueMapper: (SalesData sales, _) => sales.y,
  ///         sortFieldValueMapper: (SalesData sales, _) => sales.x,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// final List<SalesData> chartData = <SalesData>[
  ///   SalesData(1, 23),
  ///   SalesData(2, 35),
  ///   SalesData(3, 19)
  /// ];
  ///
  /// class SalesData {
  ///   SalesData(this.x, this.y);
  ///     final double x;
  ///     final double y;
  /// }
  /// ```
  @override
  final ChartIndexedValueMapper<dynamic>? sortFieldValueMapper;

  /// The data points in the series can be sorted in ascending or descending order.
  ///
  /// The data points will be rendered in the specified order if it is set to none.
  ///
  /// Default to `SortingOrder.none`.
  ///
  /// Also refer [SortingOrder].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<SalesData, num>>[
  ///       ColumnSeries<SalesData, num>(
  ///         dataSource: chartData,
  ///         xValueMapper: (SalesData sales, _) => sales.x,
  ///         yValueMapper: (SalesData sales, _) => sales.y,
  ///         sortFieldValueMapper: (SalesData sales, _) => sales.x,
  ///         sortingOrder: SortingOrder.descending
  ///       ),
  ///     ],
  ///   );
  /// }
  /// final List<SalesData> chartData = <SalesData>[
  ///   SalesData(1, 23),
  ///   SalesData(2, 35),
  ///   SalesData(3, 19)
  /// ];
  ///
  /// class SalesData {
  ///   SalesData(this.x, this.y);
  ///     final double x;
  ///     final double y;
  /// }
  /// ```
  @override
  final SortingOrder sortingOrder;

  /// Toggles the visibility of the series.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         isVisible: false
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final bool isVisible;

  /// Delay duration of the series animation.It takes a millisecond value as input.
  /// By default, the series will get animated for the specified duration.
  /// If animationDelay is specified, then the series will begin to animate
  /// after the specified duration.
  ///
  /// Defaults to 0 for all the series except ErrorBarSeries.
  /// The default value for the ErrorBarSeries is 1500.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         animationDelay: 300
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  @override
  final double? animationDelay;

  /// List of data indexes to initially be selected.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: SelectionBehavior(
  ///           enable:true
  ///         ),
  ///         initialSelectedDataIndexes: <int>[0]
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final List<int>? initialSelectedDataIndexes;

  /// Fills the data points with the gradient and image shaders.
  ///
  /// The data points of pie, doughnut and radial bar charts can be filled with [gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html)
  /// (linear, radial and sweep gradient) and [image shaders](https://api.flutter.dev/flutter/dart-ui/ImageShader-class.html).
  ///
  /// All the data points are together considered as a single segment and the shader is applied commonly.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///        BarSeries<SalesData, num>(
  ///          // To use the gradient for shader rendering,
  ///          // `import 'dart:ui' as ui;` this file should be imported.
  ///          onCreateShader: (ShaderDetails details) {
  ///            return ui.Gradient.linear(
  ///              details.rect.topRight,
  ///              details.rect.bottomLeft,
  ///              <Color>[Colors.yellow, Colors.lightBlue, Colors.brown],
  ///              <double>[0.2,0.6,1]
  ///            );
  ///          },
  ///        ),
  ///     ]
  ///   );
  /// }
  /// ```
  final CartesianShaderCallback? onCreateShader;
}

/// Creates a series renderer for chart series.
abstract class ChartSeriesRenderer {}

/// We can redraw the series with updating or creating new points by using this controller. If we need to access the redrawing methods
/// in this before we must get the ChartSeriesController [onRendererCreated] event.
class ChartSeriesController {
  /// Creating an argument constructor of ChartSeriesController class.
  ChartSeriesController(this.seriesRenderer);

  /// Used to access the series properties.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <LineSeries<SalesData, num>>[
  ///       LineSeries<SalesData, num>(
  ///         onRendererCreated: (ChartSeriesController controller) {
  ///           print(controller.seriesRenderer is LineSeriesRenderer);
  ///         },
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final XyDataSeriesRenderer seriesRenderer;

  bool _needXRecalculation = false,
      _needYRecalculation = false,
      _needRemove = false;

  /// Used to process only the newly added, updated and removed data points in a series,
  /// instead of processing all the data points.
  ///
  /// To re-render the chart with modified data points, setState() will be called.
  /// This will render the process and render the chart from scratch.
  /// Thus, the app’s performance will be degraded on continuous update.
  /// To overcome this problem, [updateDataSource] method can be called by passing updated data points indexes.
  /// Chart will process only that point and skip various steps like bounds calculation,
  /// old data points processing, etc. Thus, this will improve the app’s performance.
  ///
  /// The following are the arguments of this method.
  /// * addedDataIndexes – `List<int>` type – Indexes of newly added data points in the existing series.
  /// * removedDataIndexes – `List<int>` type – Indexes of removed data points in the existing series.
  /// * updatedDataIndexes – `List<int>` type – Indexes of updated data points in the existing series.
  /// * addedDataIndex – `int` type – Index of newly added data point in the existing series.
  /// * removedDataIndex – `int` type – Index of removed data point in the existing series.
  /// * updatedDataIndex – `int` type – Index of updated data point in the existing series.
  ///
  /// Returns `void`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   ChartSeriesController? _chartSeriesController;
  ///   return Column(
  ///     children: <Widget>[
  ///       SfCartesianChart(
  ///         series: <LineSeries<SalesData, num>>[
  ///           LineSeries<SalesData, num>(
  ///             onRendererCreated: (ChartSeriesController controller) {
  ///               _chartSeriesController = controller;
  ///             },
  ///           ),
  ///         ]
  ///       ),
  ///       TextButton(
  ///         child: Text("Update data source"),
  ///         onPressed: () {
  ///           chartData.removeAt(0);
  ///           chartData.add(ChartData(3,23));
  ///           _chartSeriesController?.updateDataSource(
  ///             addedDataIndexes: <int>[chartData.length -1],
  ///             removedDataIndexes: <int>[0],
  ///           );
  ///         }
  ///       )
  ///     ]
  ///   );
  ///  }
  ///  ```
  void updateDataSource(
      {List<int>? addedDataIndexes,
      List<int>? removedDataIndexes,
      List<int>? updatedDataIndexes,
      int? addedDataIndex,
      int? removedDataIndex,
      int? updatedDataIndex}) {
    bool needUpdate = false;
    if (removedDataIndexes != null && removedDataIndexes.isNotEmpty) {
      _removeDataPointsList(removedDataIndexes);
    } else if (removedDataIndex != null) {
      _removeDataPoint(removedDataIndex);
    }
    if (addedDataIndexes != null && addedDataIndexes.isNotEmpty) {
      _addOrUpdateDataPoints(addedDataIndexes, false);
    } else if (addedDataIndex != null) {
      _addOrUpdateDataPoint(addedDataIndex, false);
    }
    if (updatedDataIndexes != null && updatedDataIndexes.isNotEmpty) {
      needUpdate = true;
      _addOrUpdateDataPoints(updatedDataIndexes, true);
    } else if (updatedDataIndex != null) {
      needUpdate = true;
      _addOrUpdateDataPoint(updatedDataIndex, true);
    }
    _updateCartesianSeries(
        _needXRecalculation, _needYRecalculation, needUpdate);
  }

  /// Add or update the data points on dynamic series update.
  void _addOrUpdateDataPoints(List<int> indexes, bool needUpdate) {
    for (int i = 0; i < indexes.length; i++) {
      final int dataIndex = indexes[i];
      _addOrUpdateDataPoint(dataIndex, needUpdate);
    }
  }

  /// Add or update a data point in the given index.
  void _addOrUpdateDataPoint(int index, bool needUpdate) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    final CartesianSeries<dynamic, dynamic> series =
        seriesRendererDetails.series;
    if (index >= 0 &&
        series.dataSource.length > index &&
        series.dataSource[index] != null) {
      final VisibleRange xRange =
          seriesRendererDetails.xAxisDetails!.visibleRange!;
      final VisibleRange yRange =
          seriesRendererDetails.yAxisDetails!.visibleRange!;
      final CartesianChartPoint<dynamic> currentPoint =
          getChartPoint(seriesRenderer, series.dataSource[index], index)!;
      final String seriesType = seriesRendererDetails.seriesType;
      dynamic x = currentPoint.x;
      if (seriesRendererDetails.xAxisDetails is DateTimeAxisDetails ||
          seriesRendererDetails.xAxisDetails is DateTimeCategoryAxisDetails) {
        x = x.millisecondsSinceEpoch;
      } else if (seriesRendererDetails.xAxisDetails is LogarithmicAxisDetails) {
        final LogarithmicAxis axis =
            seriesRendererDetails.xAxisDetails!.axis as LogarithmicAxis;
        currentPoint.xValue = currentPoint.x;
        x = calculateLogBaseValue((x > 1) == true ? x : 1, axis.logBase);
      } else if (seriesRendererDetails.xAxisDetails is CategoryAxisDetails) {
        final CategoryAxisDetails axisDetails =
            seriesRendererDetails.xAxisDetails as CategoryAxisDetails;
        final CategoryAxis categoryAxis = axisDetails.axis as CategoryAxis;
        if (categoryAxis.arrangeByIndex) {
          // ignore: unnecessary_null_comparison
          index < axisDetails.labels.length && axisDetails.labels[index] != null
              ? axisDetails.labels[index] += ', ${currentPoint.x}'
              : axisDetails.labels.add(currentPoint.x.toString());
          x = index;
        } else {
          if (!axisDetails.labels.contains(currentPoint.x.toString())) {
            axisDetails.labels.add(currentPoint.x.toString());
          }
          x = axisDetails.labels.indexOf(currentPoint.x.toString());
        }
      }
      currentPoint.xValue ??= x;
      currentPoint.yValue = currentPoint.y;
      currentPoint.overallDataPointIndex = index;
      // This sets the minimumX and maximumX the same value when there is only one datapoint
      if (series.dataSource.length == 1) {
        seriesRendererDetails.minimumX = x;
        seriesRendererDetails.maximumX = x;
      }
      if (((xRange.minimum >= x) == true || (xRange.maximum <= x) == true) &&
          seriesRendererDetails.visible!) {
        _needXRecalculation = true;
        if (seriesRendererDetails.minimumX! >= x) {
          seriesRendererDetails.minimumX = x;
        }
        if (seriesRendererDetails.maximumX! <= x) {
          seriesRendererDetails.maximumX = x;
        }
      }
      num? minYVal = currentPoint.y ?? currentPoint.low;
      num? maxYVal = currentPoint.y ?? currentPoint.high;
      if (seriesRendererDetails.yAxisDetails is LogarithmicAxisRenderer &&
          minYVal != null &&
          maxYVal != null) {
        final LogarithmicAxis axis =
            seriesRendererDetails.yAxisDetails!.axis as LogarithmicAxis;
        minYVal =
            calculateLogBaseValue(minYVal > 1 ? minYVal : 1, axis.logBase);
        maxYVal =
            calculateLogBaseValue(maxYVal > 1 ? maxYVal : 1, axis.logBase);
      }
      // This sets the minimumY and maximumY the same value when there is only one datapoint
      if (series.dataSource.length == 1) {
        seriesRendererDetails.minimumY = minYVal;
        seriesRendererDetails.maximumY = maxYVal;
      }
      if (minYVal != null &&
          maxYVal != null &&
          ((yRange.minimum >= minYVal) == true ||
              (yRange.maximum <= maxYVal) == true) &&
          seriesRendererDetails.visible!) {
        _needYRecalculation = true;
        if (seriesRendererDetails.minimumY! >= minYVal) {
          seriesRendererDetails.minimumY = minYVal;
        }
        if (seriesRendererDetails.maximumY! <= maxYVal) {
          seriesRendererDetails.maximumY = maxYVal;
        }
      }

      if (needUpdate) {
        if (seriesRendererDetails.dataPoints.length > index == true) {
          seriesRendererDetails.dataPoints[index] = currentPoint;
          seriesRendererDetails.overAllDataPoints[index] = currentPoint;
        }
      } else {
        if (seriesRendererDetails.dataPoints.length == index) {
          seriesRendererDetails.dataPoints.add(currentPoint);
          seriesRendererDetails.overAllDataPoints.add(currentPoint);
        } else if (seriesRendererDetails.dataPoints.length > index == true &&
            index >= 0) {
          seriesRendererDetails.dataPoints.insert(index, currentPoint);
          seriesRendererDetails.overAllDataPoints.insert(index, currentPoint);
        }
      }

      if (seriesType.contains('range') ||
              seriesType.contains('hilo') ||
              seriesType.contains('candle')
          ? seriesType == 'hiloopenclose' || seriesType.contains('candle')
              ? (currentPoint.low == null ||
                  currentPoint.high == null ||
                  currentPoint.open == null ||
                  currentPoint.close == null)
              : (currentPoint.low == null || currentPoint.high == null)
          : currentPoint.y == null) {
        // ignore: unnecessary_type_check
        if (seriesRenderer is XyDataSeriesRenderer) {
          if (seriesRenderer is FastLineSeriesRenderer &&
              !seriesRendererDetails.containsEmptyPoints) {
            seriesRendererDetails.containsEmptyPoints = true;
          }
          seriesRenderer.calculateEmptyPointValue(
              index, currentPoint, seriesRenderer);
        }
      }

      /// Below lines for changing high, low values based on input.
      if ((seriesType.contains('range') ||
              seriesType.contains('hilo') ||
              seriesType.contains('candle')) &&
          currentPoint.isVisible) {
        final num high = currentPoint.high;
        final num low = currentPoint.low;
        currentPoint.high = math.max<num>(high, low);
        currentPoint.low = math.min<num>(high, low);
      }
    }
  }

  /// Converts logical pixel value to the data point value.
  ///
  /// The [pixelToPoint] method takes logical pixel value as input and returns a chart data point.
  ///
  /// Since this method is in the series controller, x and y-axis associated with this particular series will be
  /// considering for conversion value.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   ChartSeriesController? _chartSeriesController;
  ///   return SfCartesianChart(
  ///     series: <LineSeries<SalesData, num>>[
  ///       LineSeries<SalesData, num>(
  ///         onRendererCreated: (ChartSeriesController controller) {
  ///           _chartSeriesController = controller;
  ///         },
  ///       ),
  ///     ],
  ///     onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
  ///       final Offset value = Offset(args.position.dx, args.position.dy);
  ///       final CartesianChartPoint<dynamic>? chartpoint = _chartSeriesController?.pixelToPoint(value);
  ///       print('X point: ${chartpoint?.x}');
  ///       print('Y point: ${chartpoint?.y}');
  ///     },
  ///   );
  /// }
  /// ```
  CartesianChartPoint<dynamic> pixelToPoint(Offset position) {
    return calculatePixelToPoint(position, seriesRenderer);
  }

  /// Converts chart data point value to logical pixel value.
  ///
  /// The [pointToPixel] method takes chart data point value as input and returns logical pixel value.
  ///
  /// Since this method is in the series controller, x and y-axis associated with this particular series will be
  /// considering for conversion value.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   ChartSeriesController? _chartSeriesController;
  ///   return SfCartesianChart(
  ///     series: <LineSeries<SalesData, num>>[
  ///       LineSeries<SalesData, num>(
  ///         onRendererCreated: (ChartSeriesController controller) {
  ///           _chartSeriesController = controller;
  ///         },
  ///         onPointTap: (ChartPointDetails args) {
  ///           final CartesianChartPoint<dynamic> chartPoint = CartesianChartPoint<dynamic>(
  ///             chartData[args.pointIndex!].x,
  ///             chartData[args.pointIndex!].y);
  ///           final Offset? pointLocation = _chartSeriesController?.pointToPixel(chartPoint);
  ///           print('X location: ${pointLocation!.dx}');
  ///           print('Y location: ${pointLocation.dy}');
  ///         },
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  Offset pointToPixel(CartesianChartPoint<dynamic> point) {
    return calculatePointToPixel(point, seriesRenderer);
  }

  /// If you wish to perform initial animation again in the existing series, this method can be called.
  /// On calling this method, this particular series will be animated again based on the `animationDuration`
  /// property's value in the series. If the value is 0, then the animation will not be performed.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   ChartSeriesController? _chartSeriesController;
  ///   return Column(
  ///     children: <Widget>[
  ///       SfCartesianChart(
  ///         series: <LineSeries<SalesData, num>>[
  ///           LineSeries<SalesData, num>(
  ///             onRendererCreated: (ChartSeriesController controller) {
  ///               _chartSeriesController = controller;
  ///             },
  ///           ),
  ///         ]
  ///       ),
  ///       TextButton(
  ///         child: Text("Animate series"),
  ///         onPressed: () {
  ///           _chartSeriesController?.animate();
  ///         }
  ///       )
  ///     ]
  ///   );
  ///  }
  /// ```
  void animate() {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    if (seriesRendererDetails.visible! == true &&
        seriesRendererDetails.series.animationDuration > 0 == true) {
      final CartesianStateProperties stateProperties =
          seriesRendererDetails.stateProperties;
      final SfCartesianChart chart =
          seriesRendererDetails.stateProperties.chart;
      final TooltipBehavior tooltip = chart.tooltipBehavior;
      final TrackballBehavior trackball = chart.trackballBehavior;
      final TrackballRenderingDetails trackballRenderingDetails =
          TrackballHelper.getRenderingDetails(
              stateProperties.trackballBehaviorRenderer);
      final TrackballPainter? trackballPainter =
          trackballRenderingDetails.trackballPainter;
      final RenderingDetails renderingDetails =
          stateProperties.renderingDetails;
      final TooltipRenderingDetails tooltipRenderingDetails =
          TooltipHelper.getRenderingDetails(
              renderingDetails.tooltipBehaviorRenderer);
      //This hides the tooltip if rendered for this current series renderer
      if (tooltip.enable &&
          (tooltip.builder != null
              ? tooltipRenderingDetails.seriesIndex ==
                  SegmentHelper.getSegmentProperties(
                          seriesRendererDetails.segments[0])
                      .seriesIndex
              : tooltipRenderingDetails.currentSeriesDetails?.renderer ==
                  seriesRenderer)) {
        tooltip.hide();
      }
      // This hides the trackball if rendered for this current series renderer.
      if (trackball.enable) {
        for (final ChartPointInfo point
            in trackballRenderingDetails.chartPointInfo) {
          if (point.seriesRendererDetails?.renderer == seriesRenderer) {
            if (trackballPainter != null) {
              stateProperties.repaintNotifiers['trackball']!.value++;
              trackballPainter.canResetPath = true;
              break;
            } else {
              final GlobalKey key =
                  trackballRenderingDetails.trackballTemplate!.key as GlobalKey;
              final TrackballTemplateState trackballTemplateState =
                  key.currentState! as TrackballTemplateState;
              trackballTemplateState.hideTrackballTemplate();
              break;
            }
          }
        }
      }
      seriesRendererDetails.reAnimate = seriesRendererDetails.needsAnimation =
          seriesRendererDetails.needAnimateSeriesElements = true;
      renderingDetails.initialRender = false;
      // This repaints the datalabels for the series if renderered.
      stateProperties.renderDataLabel?.state?.repaintDataLabelElements();

      // This animates the datalabel templates of the animating series.
      if (seriesRendererDetails.series.dataLabelSettings.builder != null) {
        for (final ChartTemplateInfo template in renderingDetails.templates) {
          if (template.templateType == 'DataLabel' &&
              template.animationDuration > 0 &&
              template.seriesIndex ==
                  SegmentHelper.getSegmentProperties(
                          seriesRendererDetails.segments[0])
                      .seriesIndex) {
            template.animationController.forward(from: 0.0);
          }
        }
      }
      stateProperties.totalAnimatingSeries = 1;
      stateProperties.animationCompleteCount = 0;
      stateProperties.forwardAnimation(seriesRendererDetails);
      // This animates the trendlines of the animating series.
      if (seriesRendererDetails.trendlineRenderer.isNotEmpty == true) {
        for (final TrendlineRenderer trendlineRenderer
            in seriesRendererDetails.trendlineRenderer) {
          if (trendlineRenderer.visible) {
            final Trendline trendline = trendlineRenderer.trendline;
            trendlineRenderer.animationController.duration =
                Duration(milliseconds: trendline.animationDuration.toInt());
            trendlineRenderer.animationController.forward(from: 0.0);
          }
        }
      }
    }
  }

  /// Remove list of points.
  void _removeDataPointsList(List<int> removedDataIndexes) {
    /// Remove the redudant index from the list.
    final List<int> indexList = removedDataIndexes.toSet().toList();
    indexList.sort((int b, int a) => a.compareTo(b));
    for (int i = 0; i < indexList.length; i++) {
      final int dataIndex = indexList[i];
      _removeDataPoint(dataIndex);
    }
  }

  /// Remove a data point in the given index.
  void _removeDataPoint(int index) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    if (seriesRendererDetails.dataPoints.isNotEmpty == true &&
        index >= 0 &&
        index < seriesRendererDetails.dataPoints.length) {
      final CartesianChartPoint<dynamic> currentPoint =
          seriesRendererDetails.dataPoints[index];
      final ChartAxisRendererDetails xAxisDetails =
          seriesRendererDetails.xAxisDetails!;
      if (xAxisDetails is DateTimeCategoryAxisRenderer ||
          xAxisDetails is CategoryAxisRenderer) {
        _needXRecalculation = true;
      }
      seriesRendererDetails.dataPoints.removeAt(index);
      seriesRendererDetails.overAllDataPoints.removeAt(index);
      // ignore: unnecessary_null_comparison
      if (currentPoint != null) {
        if (!_needXRecalculation &&
            (seriesRendererDetails.minimumX == currentPoint.xValue ||
                seriesRendererDetails.maximumX == currentPoint.xValue)) {
          _needXRecalculation = true;
          _needRemove = true;
        }
        final String seriesType = seriesRendererDetails.seriesType;

        /// Below lines for changing high, low values based on input.
        if ((seriesType.contains('range') ||
                seriesType.contains('hilo') ||
                seriesType.contains('candle')) &&
            currentPoint.isVisible) {
          final num high = currentPoint.high;
          final num low = currentPoint.low;
          currentPoint.high = math.max<num>(high, low);
          currentPoint.low = math.min<num>(high, low);
        }
        final num? minYVal = currentPoint.y ?? currentPoint.low;
        final num? maxYVal = currentPoint.y ?? currentPoint.high;
        if (!_needYRecalculation &&
            minYVal != null &&
            maxYVal != null &&
            (seriesRendererDetails.minimumY == minYVal ||
                seriesRendererDetails.maximumY == maxYVal)) {
          _needYRecalculation = true;
          _needRemove = true;
        }
      }
    }
  }

  /// After add/remove/update data points, recalculate the x, y range and interval.
  void _updateCartesianSeries(
      bool needXRecalculation, bool needYRecalculation, bool needUpdate) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    final CartesianStateProperties stateProperties =
        seriesRendererDetails.stateProperties;
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final String seriesType = seriesRendererDetails.seriesType;
    final bool isFindSeriesMinMax =
        xAxisDetails is DateTimeCategoryAxisDetails ||
            seriesType == 'boxandwhisker' ||
            seriesType == 'waterfall' ||
            seriesType == 'errorbar' ||
            seriesRendererDetails.seriesType.contains('stacked') == true;
    stateProperties.isRedrawByZoomPan = false;
    if (needXRecalculation || needYRecalculation || needUpdate) {
      if (isFindSeriesMinMax || _needRemove) {
        if (needXRecalculation) {
          seriesRendererDetails.minimumX =
              seriesRendererDetails.maximumX = null;
          if (xAxisDetails is DateTimeCategoryAxisDetails) {
            xAxisDetails.labels.clear();
          }
        }
        if (needYRecalculation) {
          seriesRendererDetails.minimumY =
              seriesRendererDetails.maximumY = null;
        }
        stateProperties.chartSeries.findSeriesMinMax(seriesRendererDetails);
        if (seriesRendererDetails.seriesType.contains('stacked') == true) {
          stateProperties.chartSeries
              .calculateStackedValues(findSeriesCollection(stateProperties));
        }
      }
    }
    if (needXRecalculation) {
      final dynamic axisRenderer = seriesRendererDetails.xAxisDetails!;
      axisRenderer.calculateRangeAndInterval(stateProperties);
    }
    if (needYRecalculation) {
      final dynamic axisRenderer = seriesRendererDetails.yAxisDetails!;
      axisRenderer.calculateRangeAndInterval(stateProperties);
    }
    if (needXRecalculation || needYRecalculation) {
      stateProperties.plotBandRepaintNotifier.value++;
      stateProperties.renderOutsideAxis.state.axisRepaintNotifier.value++;
      stateProperties.renderInsideAxis.state.axisRepaintNotifier.value++;
      for (final CartesianSeriesRenderer seriesRenderer
          in stateProperties.chartSeries.visibleSeriesRenderers) {
        _repaintSeries(stateProperties,
            SeriesHelper.getSeriesRendererDetails(seriesRenderer));
      }
    } else {
      _repaintSeries(stateProperties, seriesRendererDetails);
    }
    stateProperties.isLoadMoreIndicator = false;
    if (!isFindSeriesMinMax) {
      _needXRecalculation = false;
      _needYRecalculation = false;
    }
    //This makes the update data source method work with dynamic animation(scheduled for release)
    // seriesRenderer.seriesRendererDetails.needsAnimation = seriesRenderer.seriesRendererDetails.needAnimateSeriesElements =
    //     chartState.widgetNeedUpdate = true;
    // chartState.initialRender = false;
    // seriesRenderer.seriesRendererDetails.stateProperties.totalAnimatingSeries = 1;
    // seriesRenderer.seriesRendererDetails.stateProperties.animationCompleteCount = 0;
    // seriesRenderer.seriesRendererDetails.stateProperties.forwardAnimation(
    //     seriesRenderer, seriesRenderer.seriesRendererDetails.series.animationDuration);
  }

  // This method repaints the series and its elements for the given series renderer.
  void _repaintSeries(CartesianStateProperties stateProperties,
      SeriesRendererDetails seriesRendererDetails) {
    seriesRendererDetails.calculateRegion = true;
    seriesRendererDetails.repaintNotifier.value++;
    if (seriesRendererDetails.series.dataLabelSettings.isVisible == true) {
      stateProperties.renderDataLabel?.state!.dataLabelRepaintNotifier.value++;
    }
  }
}

/// Creates a series renderer for Cartesian series.
abstract class CartesianSeriesRenderer extends ChartSeriesRenderer {
  /// Holds the properties required to render the series.
  late SeriesRendererDetails _seriesRendererDetails;

  /// To create segment for series.
  ChartSegment createSegment();

  /// To customize each segments.
  // ignore: unused_element
  void customizeSegment(ChartSegment segment);

  /// To customize each data markers.
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer seriesRenderer]);

  /// To customize each data labels.
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
      double pointY, int angle, TextStyle style);

  /// To calculate the value of empty points.
  void calculateEmptyPointValue(
      int pointIndex, CartesianChartPoint<dynamic> currentPoint,
      [CartesianSeriesRenderer seriesRenderer]);

  /// To dispose the CartesianSeriesRenderer class objects.
  void dispose() {
    _seriesRendererDetails.dispose();
  }
}

// ignore: avoid_classes_with_only_static_members
/// Helper class to get the private fields of chart series renderer.
class SeriesHelper {
  /// Method to get the series renderer details of corresponding series renderer.
  static SeriesRendererDetails getSeriesRendererDetails(
          CartesianSeriesRenderer renderer) =>
      renderer._seriesRendererDetails;

  /// Method to set the series renderer details of corresponding series renderer.
  static void setSeriesRendererDetails(CartesianSeriesRenderer renderer,
          SeriesRendererDetails rendererDetails) =>
      renderer._seriesRendererDetails = rendererDetails;
}
