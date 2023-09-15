import 'package:flutter/material.dart';
import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../circular_chart/renderer/chart_point.dart';
import '../../circular_chart/renderer/renderer_base.dart';
import '../common.dart';
import '../user_interaction/selection_behavior.dart';
import '../utils/enum.dart';
import '../utils/typedef.dart';

/// This class holds the property of series.
///
/// Chart series has property to render the series if the property data source is empty it renders an empty chart.
/// [ChartSeries] is the base class, it has the property to set the name, data source, border color and width to customize the series.
///
/// Provides options that are extended by the other sub classes such as name, point color mapper, data label mapper, animation
/// duration and border-width and color for customize the appearance of the chart.
class ChartSeries<T, D> {
  /// Creating an argument constructor of ChartSeries class.
  const ChartSeries(
      {this.xValueMapper,
      this.yValueMapper,
      this.dataLabelMapper,
      this.name,
      this.dataSource,
      this.pointColorMapper,
      this.sortFieldValueMapper,
      bool? enableTooltip,
      this.emptyPointSettings,
      this.dataLabelSettings,
      this.animationDuration,
      this.borderColor,
      this.borderWidth,
      this.selectionBehavior,
      this.legendItemText,
      this.legendIconType,
      this.opacity,
      this.sortingOrder,
      this.animationDelay,
      this.isVisible})
      : enableTooltip = enableTooltip ?? true;

  /// Data required for rendering the series. If no data source is specified, empty
  /// chart will be rendered without series.
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
  final List<T>? dataSource;

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
  ///         dataLabelMapper: (SalesData data, _) => data.dataLabelText,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// class SalesData {
  ///   SalesData(this.year, this.dataLabelText, this.sales1);
  ///     final DateTime year;
  ///     final String dataLabelText;
  ///     final int sales1;
  /// }
  /// ```
  final ChartIndexedValueMapper<String>? dataLabelMapper;

  /// Customizes the empty points, i.e. null data points in a series.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<ChartData, num>>[
  ///       ColumnSeries<ChartData, num>(
  ///         emptyPointSettings: EmptyPointSettings(
  ///           mode: EmptyPointMode.average
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final EmptyPointSettings? emptyPointSettings;

  /// Customizes the data labels in a series. Data label is a text, which displays
  /// the details about the data point.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<ChartData, num>>[
  ///       ColumnSeries<ChartData, num>(
  ///         dataLabelSettings: DataLabelSettings(isVisible: true),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final DataLabelSettings? dataLabelSettings;

  /// Name of the series. The name will be displayed in legend item by default.
  /// If name is not specified for the series, then the current series index with ‘series’
  /// text prefix will be considered as series name.
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         name: 'Bubble Series'
  ///       )
  ///     ]
  ///   );
  /// }
  ///```
  final String? name;

  /// Enables or disables the tooltip for this series. Tooltip will display more details
  /// about data points when tapping the data point region.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: TooltipBehavior(enable: true),
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         enableTooltip: false,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool enableTooltip;

  /// Duration of the series animation. It takes millisecond value as input.
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
  final double? animationDuration;

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
  final Color? borderColor;

  /// Border width of the series.
  ///
  /// _Note:_ This is not applicable for line, spline, step line, and fast line series types.
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
  final double? borderWidth;

  /// Text to be displayed in legend. By default, the series name will be displayed
  /// in the legend. You can change this by setting values to this property.
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
  final String? legendItemText;

  /// Shape of the legend icon. Any shape in the LegendIconType can be applied
  /// to this property. By default, icon will be rendered based on the type of the series.
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
  final LegendIconType? legendIconType;

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
  final SelectionBehavior? selectionBehavior;

  /// Opacity of the series. The value ranges from 0 to 1.
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
  final double? opacity;

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
  final ChartIndexedValueMapper<dynamic>? sortFieldValueMapper;

  /// The data points in the series can be sorted in ascending or descending order.
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
  final SortingOrder? sortingOrder;

  /// Visibility of the series.
  ///
  /// Default to `true`.
  ///
  /// Also refer [SortingOrder].
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
  final bool? isVisible;

  /// Delay duration of the series animation.It takes a millisecond value as input.
  /// By default, the series will get animated for the specified duration.
  /// If animationDelay is specified, then the series will begin to animate
  /// after the specified duration.
  ///
  /// Defaults to `0` for all the series except ErrorBarSeries.
  /// The default value for the ErrorBarSeries is `1500`.
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
  final double? animationDelay;
}

/// This class provides method to calculate the empty point value.
abstract class CircularChartEmptyPointBehavior {
  /// To calculate the values of the empty points.
  void calculateEmptyPointValue(int pointIndex,
      ChartPoint<dynamic> currentPoint, CircularSeriesRenderer seriesRenderer);
}

/// Data points with a null value are considered empty points.
/// Empty data points are ignored and are not plotted in the chart.
///
/// Provides Empty points value calculations.
abstract class TriangularChartEmptyPointBehavior {
  /// To calculate the values of the empty points.
  void calculateEmptyPointValue(
      int pointIndex, dynamic currentPoint, dynamic seriesRenderer);
}
