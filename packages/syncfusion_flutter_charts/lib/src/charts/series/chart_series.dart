import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../base.dart';
import '../behaviors/trackball.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../common/circular_data_label.dart';
import '../common/circular_data_label_helper.dart';
import '../common/connector_line.dart';
import '../common/core_legend.dart';
import '../common/core_tooltip.dart';
import '../common/data_label.dart';
import '../common/element_widget.dart';
import '../common/empty_points.dart';
import '../common/legend.dart';
import '../common/marker.dart';
import '../interactions/selection.dart';
import '../trendline/trendline.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/renderer_helper.dart';
import '../utils/typedef.dart';
import 'waterfall_series.dart';

enum SeriesSlot {
  trendline,
  marker,
  dataLabel,
}

class ChartSeriesParentData extends ContainerBoxParentData<RenderBox> {}

/// This class holds the property of series.
///
/// Chart series has property to render the series if the property data source
/// is empty it renders an empty chart.
/// [ChartSeries] is the base class, it has the property to set the name,
/// data source, border color and width to customize the series.
///
/// Provides options that are extended by the other sub classes such as name,
/// point color mapper, data label mapper, animation
/// duration and border-width and color for customize the
/// appearance of the chart.
abstract class ChartSeries<T, D>
    extends SlottedMultiChildRenderObjectWidget<SeriesSlot, RenderObject> {
  /// Creating an argument constructor of ChartSeries class.
  const ChartSeries({
    ValueKey<String>? key,
    this.dataSource,
    this.xValueMapper,
    this.pointColorMapper,
    this.sortingOrder = SortingOrder.none,
    this.sortFieldValueMapper,
    this.dataLabelMapper,
    this.name,
    this.enableTooltip = true,
    this.animationDuration = 1500,
    this.color,
    this.borderWidth = 2.0,
    this.isVisibleInLegend = true,
    this.legendIconType = LegendIconType.seriesType,
    this.legendItemText,
    this.opacity = 1.0,
    this.animationDelay = 0,
    this.initialIsVisible = true,
    this.selectionBehavior,
    this.initialSelectedDataIndexes,
    this.emptyPointSettings = const EmptyPointSettings(),
    this.dataLabelSettings = const DataLabelSettings(),
    this.markerSettings = const MarkerSettings(),
    this.onPointTap,
    this.onPointDoubleTap,
    this.onPointLongPress,
  }) : super(key: key);

  /// Data required for rendering the series. If no data source is specified,
  /// empty chart will be rendered without series.
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
  final ChartValueMapper<T, D>? xValueMapper;

  /// Field in the data source, which is considered as fill color
  /// for the data points.
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
  ///         pointColorMapper: (ColumnColors sales, _) =>
  ///           sales.pointColorMapper,
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
  final ChartValueMapper<T, Color>? pointColorMapper;

  /// Field in the data source, which is considered as text for the data points.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     primaryXAxis: DateTimeAxis(),
  ///     series: <BarSeries<SalesData, DateTime>>[
  ///       BarSeries<SalesData, DateTime>(
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
  final ChartValueMapper<T, String>? dataLabelMapper;

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
  final EmptyPointSettings emptyPointSettings;

  /// Customizes the data labels in a series. Data label is a text, which
  /// displays the details about the data point.
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
  final DataLabelSettings dataLabelSettings;

  /// Indication of data points.
  ///
  /// Marks the data point location with symbols for better
  /// indication. The shape, color, border, and size of the marker
  /// can be customized.
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

  /// Name of the series. The name will be displayed in legend item by default.
  /// If name is not specified for the series, then the current series index
  /// with ‘series’ text prefix will be considered as series name.
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

  /// Enables or disables the tooltip for this series. Tooltip will display more
  /// details about data points when tapping the data point region.
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
  final double animationDuration;

  /// Color of the series.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ColumnSeries<SalesData, String>>[
  ///       ColumnSeries<SalesData, String>(
  ///         color: Colors.red,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? color;

  /// Border width of the series.
  ///
  /// _Note:_ This is not applicable for line, spline, step line,
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
  final double borderWidth;

  /// Text to be displayed in legend. By default, the series name will be
  /// displayed in the legend. You can change this by
  /// setting values to this property.
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

  /// Toggles the visibility of the legend item of this specific series
  /// in the legend.
  ///
  /// If it is set to false, the legend item for this series
  /// will not be visible in the legend.
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

  /// Shape of the legend icon. Any shape in the LegendIconType can be applied
  /// to this property. By default, icon will be rendered based
  /// on the type of the series.
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
  final LegendIconType legendIconType;

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
  final ChartValueMapper<T, dynamic>? sortFieldValueMapper;

  /// The data points in the series can be sorted in ascending or descending
  /// order. The data points will be rendered in the specified order
  /// if it is set to none.
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
  final SortingOrder sortingOrder;

  /// Visibility of the series, which applies only during load time.
  ///
  /// Default to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<SalesData, num>>[
  ///       LineSeries<SalesData, num>(
  ///         initialIsVisible: false
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  /// Use the onRendererCreated callback, as shown in the code below, to update the visibility
  /// dynamically.
  ///
  /// ```dart
  /// ChartSeriesController? controller;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           series: <CartesianSeries<SalesData, num>>[
  ///             LineSeries<SalesData, num>(
  ///               dataSource: data,
  ///               xValueMapper: (SalesData sales, _) => sales.year,
  ///               yValueMapper: (SalesData sales, _) => sales.sales,
  ///               onRendererCreated: (ChartSeriesController seriesController) {
  ///                 controller = seriesController;
  ///               },
  ///             ),
  ///           ],
  ///         ),
  ///         TextButton(
  ///           onPressed: () {
  ///             if (controller != null) {
  ///               controller!.isVisible = true;
  ///             }
  ///           },
  ///           child: const Text('Update Series Visibility'),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final bool initialIsVisible;

  /// Delay duration of the series animation.It takes a millisecond value as
  /// input. By default, the series will get animated for the specified
  /// duration. If animationDelay is specified, then the series will begin to
  /// animate after the specified duration.
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
  final double animationDelay;

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

  @override
  Iterable<SeriesSlot> get slots => SeriesSlot.values;

  @protected
  List<ChartDataPointType> get positions;

  @override
  Widget? childForSlot(SeriesSlot slot) {
    return null;
  }

  @protected
  @factory
  ChartSeriesRenderer<T, D> createRenderer();

  @mustCallSuper
  @override
  ChartSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final ChartSeriesRenderer<T, D> renderer = createRenderer();
    renderer
      ..xValueMapper = xValueMapper
      ..dataSource = dataSource
      ..pointColorMapper = pointColorMapper
      ..dataLabelMapper = dataLabelMapper
      ..emptyPointSettings = emptyPointSettings
      ..dataLabelSettings = dataLabelSettings
      ..markerSettings = markerSettings
      ..name = name
      ..enableTooltip = enableTooltip
      ..animationDuration = animationDuration
      ..color = color
      ..borderWidth = borderWidth
      ..isVisibleInLegend = isVisibleInLegend
      ..legendItemText = legendItemText
      ..legendIconType = legendIconType
      ..selectionBehavior = selectionBehavior
      ..initialSelectedDataIndexes = initialSelectedDataIndexes
      ..opacity = opacity
      ..sortFieldValueMapper = sortFieldValueMapper
      ..sortingOrder = sortingOrder
      ..initialIsVisible = initialIsVisible
      ..animationDelay = animationDelay
      ..onPointTap = onPointTap
      ..onPointDoubleTap = onPointDoubleTap
      ..onPointLongPress = onPointLongPress
      ..textDirection = Directionality.of(context)
      ..widget = this;
    return renderer;
  }

  @mustCallSuper
  @override
  void updateRenderObject(
      BuildContext context, ChartSeriesRenderer<T, D> renderObject) {
    renderObject
      ..xValueMapper = xValueMapper
      ..dataSource = dataSource
      ..pointColorMapper = pointColorMapper
      ..dataLabelMapper = dataLabelMapper
      ..emptyPointSettings = emptyPointSettings
      ..dataLabelSettings = dataLabelSettings
      ..markerSettings = markerSettings
      ..name = name
      ..enableTooltip = enableTooltip
      ..animationDuration = animationDuration
      ..color = color
      ..borderWidth = borderWidth
      ..isVisibleInLegend = isVisibleInLegend
      ..legendItemText = legendItemText
      ..legendIconType = legendIconType
      ..selectionBehavior = selectionBehavior
      ..opacity = opacity
      ..sortFieldValueMapper = sortFieldValueMapper
      ..sortingOrder = sortingOrder
      ..animationDelay = animationDelay
      ..onPointTap = onPointTap
      ..onPointDoubleTap = onPointDoubleTap
      ..onPointLongPress = onPointLongPress
      ..textDirection = Directionality.of(context)
      ..widget = this;
  }
}

enum AnimationType {
  loading,
  realtime,
  none,
}

/// Creates a series renderer for chart series.
abstract class ChartSeriesRenderer<T, D> extends RenderBox
    with
        SlottedContainerRenderObjectMixin<SeriesSlot, RenderBox>,
        ChartAreaUpdateMixin,
        LegendItemProvider {
  ChartSeriesRenderer() {
    _fetchMarkerImage();
  }

  late ChartSeries<T, D> widget;

  AnimationController? get animationController => _animationController;
  AnimationController? _animationController;
  AnimationController? _markerAnimationController;
  AnimationController? _dataLabelAnimationController;

  CurvedAnimation? get animation => _animation;
  CurvedAnimation? _animation;

  CurvedAnimation? get markerAnimation => _markerAnimation;
  CurvedAnimation? _markerAnimation;

  CurvedAnimation? get dataLabelAnimation => _dataLabelAnimation;
  CurvedAnimation? _dataLabelAnimation;

  ChartSegment? _interactiveSegment;
  bool _isXRangeChanged = true;
  bool _isYRangeChanged = true;
  bool _isResized = true;
  Image? _markerImage;
  bool _canInvokePointerUp = true;

  RenderChartElementLayoutBuilder<T, D>? get dataLabelContainer =>
      childForSlot(SeriesSlot.dataLabel)
          as RenderChartElementLayoutBuilder<T, D>?;

  RenderChartElementLayoutBuilder<T, D>? get markerContainer =>
      childForSlot(SeriesSlot.marker) as RenderChartElementLayoutBuilder<T, D>?;

  RenderTrendlineStack? get trendlineContainer =>
      childForSlot(SeriesSlot.trendline) as RenderTrendlineStack?;

  @protected
  bool canUpdateOrCreateSegments = true;

  @protected
  bool forceTransformValues = false;

  bool _hasLinearDataSource = true;
  bool visibilityBeforeTogglingLegend = false;

  final List<D?> _chaoticRawXValues = <D?>[];
  List<D?> xRawValues = <D?>[];
  final List<num> _chaoticXValues = <num>[];
  List<num> xValues = <num>[];
  final List<dynamic> _chaoticRawSortValues = <dynamic>[];
  final List<dynamic> _sortValues = <dynamic>[];
  final List<Color?> _chaoticPointColors = <Color?>[];
  List<Color?> pointColors = <Color?>[];

  final List<int> emptyPointIndexes = <int>[];
  final List<int> _xNullPointIndexes = <int>[];
  List<int> sortedIndexes = <int>[];

  List<ChartPoint<D>> chartPoints = <ChartPoint<D>>[];

  List<ChartSegment> get segments => _segments;
  List<ChartSegment> _segments = <ChartSegment>[];

  ChartPointInteractionCallback? onPointTap;
  ChartPointInteractionCallback? onPointDoubleTap;
  ChartPointInteractionCallback? onPointLongPress;

  @override
  RenderChartPlotArea? get parent => super.parent as RenderChartPlotArea?;

  @override
  bool get sizedByParent => true;

  AnimationType? get animationType => _animationType;
  AnimationType? _animationType;
  set animationType(AnimationType? value) {
    if (_animationType != value) {
      _animationType = _animationType == null ? AnimationType.loading : value;
      _startAnimations();
    }
  }

  int get index => _index;
  int _index = -1;
  set index(int value) {
    if (_index != value) {
      // TODO(VijayakumarM): Add assertion.
      _index = value;
    }
  }

  List<Color> get palette => _palette;
  List<Color> _palette = <Color>[];
  set palette(List<Color> value) {
    if (_palette != value) {
      // TODO(VijayakumarM): Add assertion.
      _palette = value;
      // markNeedsLegendUpdate();
      markNeedsSegmentsPaint();
    }
  }

  int get dataCount => _dataCount;
  int _dataCount = 0;

  double _oldAnimationFactor = 0.0;
  double _oldSegmentAnimationFactor = 0.0;

  double get animationFactor => _animationFactor;
  double _animationFactor = 0.0;
  set animationFactor(double value) {
    if (_animationFactor != value) {
      _oldAnimationFactor = _animationFactor;
      _animationFactor = value;
    }
  }

  double get segmentAnimationFactor => _segmentAnimationFactor;
  double _segmentAnimationFactor = 0.0;
  set segmentAnimationFactor(double value) {
    if (_segmentAnimationFactor != value) {
      _oldSegmentAnimationFactor = _segmentAnimationFactor;
      _segmentAnimationFactor = value;
    }
  }

  bool get canFindLinearVisibleIndexes => _canFindLinearVisibleIndexes;
  bool _canFindLinearVisibleIndexes = true;

  List<T>? get dataSource => _dataSource;
  List<T>? _dataSource;
  set dataSource(List<T>? value) {
    if ((value == null || value.isEmpty) && !listEquals(_dataSource, value)) {
      _dataCount = 0;
      segments.clear();
      markNeedsUpdate();
    }

    if (_dataCount != value?.length || !listEquals(_dataSource, value)) {
      _dataSource = value;
      canUpdateOrCreateSegments = true;
      markNeedsUpdate();
      animationType = AnimationType.realtime;
    }
  }

  ChartValueMapper<T, D>? get xValueMapper => _xValueMapper;
  ChartValueMapper<T, D>? _xValueMapper;
  set xValueMapper(ChartValueMapper<T, D>? value) {
    if (_xValueMapper != value) {
      _xValueMapper = value;
    }
  }

  ChartValueMapper<T, String>? get dataLabelMapper => _dataLabelMapper;
  ChartValueMapper<T, String>? _dataLabelMapper;
  set dataLabelMapper(ChartValueMapper<T, String>? value) {
    if (_dataLabelMapper != value) {
      _dataLabelMapper = value;
    }
  }

  ChartValueMapper<T, Color>? get pointColorMapper => _pointColorMapper;
  ChartValueMapper<T, Color>? _pointColorMapper;
  set pointColorMapper(ChartValueMapper<T, Color>? value) {
    if (_pointColorMapper != value) {
      _pointColorMapper = value;
    }
  }

  ChartValueMapper<T, dynamic>? get sortFieldValueMapper =>
      _sortFieldValueMapper;
  ChartValueMapper<T, dynamic>? _sortFieldValueMapper;
  set sortFieldValueMapper(ChartValueMapper<T, dynamic>? value) {
    if (_sortFieldValueMapper != value) {
      _sortFieldValueMapper = value;
      canUpdateOrCreateSegments = true;
    }
  }

  Color? get color => _color;
  Color? _color;
  set color(Color? value) {
    if (_color != value) {
      _color = value;
      markNeedsLegendUpdate();
      markNeedsSegmentsPaint();
    }
  }

  Color get paletteColor => _paletteColor;
  Color _paletteColor = Colors.transparent;
  set paletteColor(Color value) {
    if (_paletteColor != value) {
      _paletteColor = value;
      // markNeedsLegendUpdate();
      markNeedsSegmentsPaint();
    }
  }

  double get borderWidth => _borderWidth;
  double _borderWidth = 2.0;
  set borderWidth(double value) {
    if (_borderWidth != value) {
      _borderWidth = value;
      markNeedsSegmentsPaint();
    }
  }

  bool get initialIsVisible => _initialIsVisible;
  bool _initialIsVisible = true;
  set initialIsVisible(bool value) {
    if (_initialIsVisible != value) {
      _initialIsVisible = value;
      markNeedsUpdate();
    }
  }

  String get name => _name ?? localizedName();
  String? _name;
  set name(String? value) {
    if (_name != value) {
      _name = value;
      markNeedsLegendUpdate();
    }
  }

  bool get enableTooltip => _enableTooltip;
  bool _enableTooltip = true;
  set enableTooltip(bool value) {
    if (_enableTooltip != value) {
      _enableTooltip = value;
    }
  }

  double get animationDuration => _animationDuration;
  double _animationDuration = 0;
  set animationDuration(double value) {
    if (_animationDuration != value) {
      _animationDuration = value;
      if (parent != null) {
        _initAnimations();
      }
    }
  }

  bool get isVisibleInLegend => _isVisibleInLegend;
  bool _isVisibleInLegend = true;
  set isVisibleInLegend(bool value) {
    if (_isVisibleInLegend != value) {
      _isVisibleInLegend = value;
      markNeedsLegendUpdate();
    }
  }

  String? get legendItemText => _legendItemText;
  String? _legendItemText;
  set legendItemText(String? value) {
    if (_legendItemText != value) {
      _legendItemText = value;
      markNeedsLegendUpdate();
    }
  }

  LegendIconType get legendIconType => _legendIconType;
  LegendIconType _legendIconType = LegendIconType.seriesType;
  set legendIconType(LegendIconType value) {
    if (_legendIconType != value) {
      _legendIconType = value;
      markNeedsLegendUpdate();
    }
  }

  SelectionBehavior? get selectionBehavior => _selectionBehavior;
  SelectionBehavior? _selectionBehavior;
  set selectionBehavior(SelectionBehavior? value) {
    if (_selectionBehavior != value) {
      _selectionBehavior?.selectionController
          ?.removeListener(_handleSelectionControllerChange);
      _selectionBehavior = value;
      _effectiveSelectionBehavior = value;
      _selectionBehavior?.selectionController
          ?.addListener(_handleSelectionControllerChange);
      if (_selectionEnabled) {
        _initSelection();
      } else {
        parent?.selectionController
          ?..removeSelectionListener(_handleSelection)
          ..removeDeselectionListener(_handleDeselection);
      }
    }
  }

  void _handleSelectionControllerChange() {}

  SelectionBehavior? get effectiveSelectionBehavior =>
      _effectiveSelectionBehavior;
  SelectionBehavior? _effectiveSelectionBehavior;

  List<int>? get initialSelectedDataIndexes => _initialSelectedDataIndexes;
  List<int>? _initialSelectedDataIndexes;
  set initialSelectedDataIndexes(List<int>? value) {
    if (_initialSelectedDataIndexes != value) {
      _initialSelectedDataIndexes = value;
    }
  }

  double get opacity => _opacity;
  double _opacity = 1.0;
  set opacity(double value) {
    if (_opacity != value) {
      _opacity = value;
      markNeedsSegmentsPaint();
    }
  }

  SortingOrder get sortingOrder => _sortingOrder;
  SortingOrder _sortingOrder = SortingOrder.none;
  set sortingOrder(SortingOrder value) {
    if (_sortingOrder != value) {
      _sortingOrder = value;
      canUpdateOrCreateSegments = true;
      markNeedsUpdate();
    }
  }

  double get animationDelay => _animationDelay;
  double _animationDelay = 0.0;
  set animationDelay(double value) {
    if (_animationDelay != value) {
      _animationDelay = value;
    }
  }

  DataLabelSettings get dataLabelSettings => _dataLabelSettings;
  DataLabelSettings _dataLabelSettings = const DataLabelSettings();
  set dataLabelSettings(DataLabelSettings value) {
    if (_dataLabelSettings != value) {
      _dataLabelSettings = value;
      markNeedsLayout();
    }
  }

  MarkerSettings get markerSettings => _markerSettings;
  MarkerSettings _markerSettings = const MarkerSettings();
  set markerSettings(MarkerSettings value) {
    if (_markerSettings != value) {
      _markerSettings = value;
      _fetchMarkerImage();
    }
  }

  EmptyPointSettings get emptyPointSettings => _emptyPointSettings;
  EmptyPointSettings _emptyPointSettings = const EmptyPointSettings();
  set emptyPointSettings(EmptyPointSettings value) {
    if (_emptyPointSettings != value) {
      if (emptyPointSettings.mode != value.mode) {
        _emptyPointSettings = value;
        canUpdateOrCreateSegments = true;
        markNeedsUpdate();
      } else {
        _emptyPointSettings = value;
        markNeedsSegmentsPaint();
      }
    }
  }

  SfChartThemeData? get chartThemeData => _chartThemeData;
  SfChartThemeData? _chartThemeData;
  set chartThemeData(SfChartThemeData? value) {
    if (_chartThemeData != value) {
      _chartThemeData = value;
      markNeedsSegmentsPaint();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection = TextDirection.ltr;
  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  bool get isSelected => _isSelected;
  bool _isSelected = false;
  set isSelected(bool value) {
    _isSelected = value;
    markNeedsSegmentsPaint();
  }

  bool get _tooltipEnabled =>
      enableTooltip &&
      parent != null &&
      parent!.tooltipBehavior != null &&
      parent!.tooltipBehavior!.enable;

  bool get _selectionEnabled =>
      selectionBehavior != null && selectionBehavior!.enable;

  bool isVisible() => true;

  @override
  void setupParentData(covariant RenderObject child) {
    if (child is! ChartSeriesParentData) {
      child.parentData = ChartSeriesParentData();
    }
  }

  @override
  List<LegendItem>? buildLegendItems(int index) {
    if (isVisibleInLegend) {
      final LegendItem legendItem = ChartLegendItem(
        text: legendItemText ?? name,
        iconType: toLegendShapeMarkerType(legendIconType, this),
        iconColor: legendIconColor(),
        iconBorderColor: legendIconBorderColor(),
        iconBorderWidth: legendIconBorderWidth(),
        series: this,
        seriesIndex: index,
        pointIndex: 0,
        isToggled: _isToggled(),
        shader: legendIconShader(),
        overlayMarkerType: markerSettings.isVisible
            ? toShapeMarkerType(markerSettings.shape)
            : null,
        imageProvider: legendIconType == LegendIconType.image
            ? parent?.legend?.image
            : null,
        onTap: handleLegendItemTapped,
        onRender: _handleLegendItemCreated,
      );
      return <LegendItem>[legendItem];
    } else {
      return null;
    }
  }

  bool _isToggled() {
    return true;
  }

  @protected
  Color legendIconColor() {
    return color ?? paletteColor;
  }

  @protected
  Color? legendIconBorderColor() {
    return null;
  }

  @protected
  double legendIconBorderWidth() {
    if (legendIconType == LegendIconType.horizontalLine ||
        legendIconType == LegendIconType.verticalLine) {
      return 2;
    }
    return 1;
  }

  @protected
  Shader? legendIconShader() {
    return null;
  }

  @protected
  void handleLegendItemTapped(LegendItem item, bool isToggled) {
    if (parent != null && parent!.onLegendTapped != null) {
      final ChartLegendItem legendItem = item as ChartLegendItem;
      final LegendTapArgs args = LegendTapArgs(
          legendItem.series, legendItem.seriesIndex, legendItem.pointIndex);
      parent!.onLegendTapped!(args);
    }
    parent!.behaviorArea?.hideInteractiveTooltip();
  }

  void _handleLegendItemCreated(ItemRendererDetails details) {
    if (parent != null && parent!.onLegendItemRender != null) {
      final ChartLegendItem item = details.item as ChartLegendItem;
      final LegendIconType iconType = toLegendIconType(details.iconType);
      final LegendRenderArgs args =
          LegendRenderArgs(item.seriesIndex, item.pointIndex)
            ..text = details.text
            ..legendIconType = iconType
            ..color = details.color;
      parent!.onLegendItemRender!(args);
      if (args.legendIconType != iconType) {
        details.iconType = toLegendShapeMarkerType(
            args.legendIconType ?? LegendIconType.seriesType, this);
      }

      details
        ..text = args.text ?? ''
        ..color = args.color ?? Colors.transparent;
    }
  }

  @override
  ShapeMarkerType effectiveLegendIconType() {
    return ShapeMarkerType.circle;
  }

  @override
  void attach(PipelineOwner owner) {
    _initSelection();
    _initAnimations();
    super.attach(owner);
  }

  @override
  void detach() {
    _animationController
      ?..removeStatusListener(_handleAnimationStatusChange)
      ..dispose();
    _animationController = null;
    _animation
      ?..removeListener(_handleAnimationUpdate)
      ..dispose();
    _animation = null;

    _selectionBehavior?.selectionController
        ?.removeListener(_handleSelectionControllerChange);
    _markerAnimationController?.dispose();
    _markerAnimationController = null;
    _markerAnimation?.dispose();
    _markerAnimation = null;

    _dataLabelAnimationController?.dispose();
    _dataLabelAnimationController = null;
    _dataLabelAnimation?.dispose();
    _dataLabelAnimation = null;

    parent?.selectionController
      ?..removeSelectionListener(_handleSelection)
      ..removeDeselectionListener(_handleDeselection);
    super.detach();
  }

  void _initSelection() {
    if (parent != null && _selectionEnabled) {
      parent!.selectionController.updateSelectionParent(selectionBehavior!);
      parent!.selectionController
        ..addSelectionListener(_handleSelection)
        ..addDeselectionListener(_handleDeselection);
    }
  }

  void _initAnimations() {
    final int duration = animationDuration.toInt();
    const double seriesDuration = 1.0;
    double markerDuration = 0.0;
    double dataLabelAnimationDuration = 0.0;
    if (markerSettings.isVisible) {
      markerDuration = 0.15;
    }
    if (dataLabelSettings.isVisible) {
      dataLabelAnimationDuration = 0.2;
    }

    double curveStart = 0.05;
    double curveEnd =
        seriesDuration - (markerDuration + dataLabelAnimationDuration);
    _animationController ??= AnimationController(vsync: parent!.vsync!)
      ..addStatusListener(_handleAnimationStatusChange);
    _animationController!.duration = Duration(milliseconds: duration);
    _animation ??= CurvedAnimation(
        parent: _animationController!, curve: Interval(curveStart, curveEnd))
      ..addListener(_handleAnimationUpdate);

    final double defaultElementAnimationValue =
        (animationDuration == 0 || animationType == AnimationType.none)
            ? 1.0
            : 0.0;

    curveStart = curveEnd;
    curveEnd = curveStart + markerDuration;
    _markerAnimationController ??= AnimationController(vsync: parent!.vsync!);
    _markerAnimationController!.duration = Duration(milliseconds: duration);
    _markerAnimationController!.value = defaultElementAnimationValue;
    _markerAnimation ??= CurvedAnimation(
      parent: _markerAnimationController!,
      curve: Interval(curveStart, curveEnd),
    );

    curveStart = curveEnd;
    curveEnd = curveStart + dataLabelAnimationDuration;
    _dataLabelAnimationController ??=
        AnimationController(vsync: parent!.vsync!);
    _dataLabelAnimationController!.duration = Duration(milliseconds: duration);
    _dataLabelAnimationController!.value = defaultElementAnimationValue;
    _dataLabelAnimation ??= CurvedAnimation(
      parent: _dataLabelAnimationController!,
      curve: Interval(curveStart, curveEnd),
    );

    if (animationDuration > 0) {
      Future<void>.delayed(Duration(milliseconds: animationDelay.toInt()), () {
        _startAnimations();
      });
    } else {
      _animationFactor = 1.0;
      segmentAnimationFactor = 1.0;
    }
  }

  void _startAnimations({double from = 0}) {
    if (animationType != AnimationType.none) {
      _animationController?.forward(from: from);
      _dataLabelAnimationController?.forward(from: from);
      _markerAnimationController?.forward(from: from);
    }
  }

  void _handleAnimationStatusChange(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        copyOldSegmentValues(_oldAnimationFactor, _oldSegmentAnimationFactor);
        break;

      case AnimationStatus.completed:
        _animationType = AnimationType.none;
        forceTransformValues = true;
        visibilityBeforeTogglingLegend = !_isToggled();
        markNeedsLayout();
        break;

      case AnimationStatus.dismissed:
      case AnimationStatus.reverse:
        break;
    }
  }

  void _handleAnimationUpdate() {
    if (animationType == null) {
      onLoadingAnimationUpdate();
      return;
    }

    switch (animationType!) {
      case AnimationType.loading:
        onLoadingAnimationUpdate();
        break;

      case AnimationType.realtime:
        onRealTimeAnimationUpdate();
        break;

      case AnimationType.none:
        _animationFactor = 1.0;
        segmentAnimationFactor = 1.0;
        break;
    }
    markNeedsPaint();
  }

  @protected
  void onLoadingAnimationUpdate() {
    _animationFactor = _animation!.value;
    segmentAnimationFactor = 1.0;
  }

  @protected
  void onRealTimeAnimationUpdate() {
    _animationFactor = 1.0;
    segmentAnimationFactor = _animation!.value;
  }

  @protected
  void _resetDataSourceHolders() {
    _chaoticRawXValues.clear();
    _chaoticXValues.clear();
    _sortValues.clear();
    _chaoticRawSortValues.clear();
    _chaoticPointColors.clear();
    xRawValues.clear();
    xValues.clear();
    emptyPointIndexes.clear();
    pointColors.clear();
    _xNullPointIndexes.clear();
    sortedIndexes.clear();
  }

  bool _canPopulateDataPoints(
      List<ChartValueMapper<T, num>>? yPaths, List<List<num>>? yLists) {
    return dataSource != null &&
        dataSource!.isNotEmpty &&
        xValueMapper != null &&
        yPaths != null &&
        yPaths.isNotEmpty &&
        yLists != null &&
        yLists.isNotEmpty;
  }

  @protected
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    // Here fPath is widget specific feature path.
    // For example, in pie series's pointRadiusMapper is a feature path.
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    _resetDataSourceHolders();
    if (!_canPopulateDataPoints(yPaths, chaoticYLists)) {
      return;
    }

    if (fPaths == null) {
      fPaths = <ChartValueMapper<T, Object>>[];
      chaoticFLists = <List<Object?>>[];
      fLists = <List<Object?>>[];
    }
    _addPointColorMapper(fPaths, chaoticFLists, fLists);
    _addSortValueMapper(fPaths, chaoticFLists, fLists);

    final int length = dataSource!.length;
    final int yPathLength = yPaths!.length;
    final int fPathLength = fPaths.length;

    final Function(int, D) preferredXValue = _valueToIndex;
    final Function(D? value, num x) addXValue =
        _addXValueIntoRawAndChaoticXLists;

    for (int i = 0; i < length; i++) {
      final T current = dataSource![i];
      final D? rawX = xValueMapper!(current, i);
      if (rawX == null) {
        _xNullPointIndexes.add(index);
        continue;
      }

      final num currentX = preferredXValue(i, rawX);
      addXValue(rawX, currentX);
      for (int j = 0; j < yPathLength; j++) {
        final ChartValueMapper<T, num> yPath = yPaths[j];
        final num? yValue = yPath(current, i);
        if (yValue == null || yValue.isNaN) {
          chaoticYLists![j].add(double.nan);
          if (!emptyPointIndexes.contains(i)) {
            emptyPointIndexes.add(i);
          }
        } else {
          chaoticYLists![j].add(yValue);
        }
      }

      for (int j = 0; j < fPathLength; j++) {
        final ChartValueMapper<T, Object> fPath = fPaths[j];
        final Object? fValue = fPath(current, i);
        chaoticFLists![j].add(fValue);
      }
    }

    _dataCount = _chaoticXValues.length;
    _applyEmptyPointModeIfNeeded(chaoticYLists!);
    _doSortingIfNeeded(chaoticYLists, yLists, chaoticFLists, fLists);
  }

  void _addPointColorMapper(List<ChartValueMapper<T, Object>>? fPaths,
      List<List<Object?>>? chaoticFLists, List<List<Object?>>? fLists) {
    if (fPaths != null && pointColorMapper != null) {
      fPaths.add(pointColorMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticFLists?.add(pointColors);
      } else {
        pointColors.clear();
        chaoticFLists?.add(_chaoticPointColors);
        fLists?.add(pointColors);
      }
    }
  }

  void _addSortValueMapper(List<ChartValueMapper<T, Object>>? fPaths,
      List<List<Object?>>? chaoticFLists, List<List<Object?>>? fLists) {
    if (fPaths != null && sortFieldValueMapper != null) {
      fPaths.add(sortFieldValueMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticFLists?.add(_sortValues);
      } else {
        _sortValues.clear();
        chaoticFLists?.add(_chaoticRawSortValues);
        fLists?.add(_sortValues);
      }
    }
  }

  num _valueAsNum(int index, D value) {
    return value as num;
  }

  num _dateToMilliseconds(int index, D value) {
    final DateTime date = value as DateTime;
    return date.millisecondsSinceEpoch;
  }

  num _valueToIndex(int index, D value) {
    return index;
  }

  void _addXValueIntoRawAndChaoticXLists(D? raw, num preferred) {
    _chaoticRawXValues.add(raw);
    _chaoticXValues.add(preferred);
  }

  @protected
  void _applyEmptyPointModeIfNeeded(List<List<num>> yLists) {
    if (emptyPointIndexes.isNotEmpty) {
      emptyPointIndexes.sort();
      switch (emptyPointSettings.mode) {
        case EmptyPointMode.gap:
        case EmptyPointMode.drop:
          break;

        case EmptyPointMode.zero:
          _applyZeroEmptyPointMode(yLists);
          break;

        case EmptyPointMode.average:
          _applyAverageEmptyPointMode(yLists);
          break;
      }
    }
  }

  void _applyZeroEmptyPointMode(List<List<num>> yLists) {
    final int yLength = yLists.length;
    for (int i = 0; i < dataCount; i++) {
      for (int j = 0; j < yLength; j++) {
        final List<num> yValues = yLists[j];
        final num value = yValues[i];
        if (value.isNaN) {
          yValues[i] = 0;
        }
      }
    }
  }

  void _applyAverageEmptyPointMode(List<List<num>> yLists) {
    final int lastIndex = dataCount - 1;
    final int yLength = yLists.length;
    for (int i = 0; i < dataCount; i++) {
      for (int j = 0; j < yLength; j++) {
        final List<num> yValues = yLists[j];
        final num currentValue = yValues[i];
        num previousValue = i > 0 ? yValues[i - 1] : currentValue;
        num nextValue = i < lastIndex ? yValues[i + 1] : currentValue;
        previousValue = previousValue.isNaN ? 0 : previousValue;
        nextValue = nextValue.isNaN ? 0 : nextValue;
        if (currentValue.isNaN) {
          if (i == 0) {
            yValues[i] = i == lastIndex ? 0 : nextValue / 2;
          } else if (i == lastIndex) {
            yValues[i] = previousValue / 2;
          } else {
            yValues[i] = (previousValue + nextValue) / 2;
          }
        }
      }
    }
  }

  void _doSortingIfNeeded(
      List<List<num>>? chaoticYLists,
      List<List<num>>? yLists,
      List<List<Object?>>? chaoticFLists,
      List<List<Object?>>? fLists) {
    if (sortingOrder != SortingOrder.none &&
        chaoticYLists != null &&
        chaoticYLists.isNotEmpty &&
        yLists != null &&
        yLists.isNotEmpty) {
      if (_chaoticRawSortValues.isEmpty) {
        if (_chaoticRawXValues.isNotEmpty) {
          _chaoticRawSortValues.addAll(_chaoticRawXValues);
        } else {
          _chaoticRawSortValues.addAll(_chaoticXValues);
        }
      }

      switch (sortingOrder) {
        case SortingOrder.ascending:
          _sort(chaoticYLists, yLists, chaoticFLists, fLists);
          break;

        case SortingOrder.descending:
          _sort(chaoticYLists, yLists, chaoticFLists, fLists, ascending: false);
          break;

        case SortingOrder.none:
          break;
      }
    } else {
      xValues.clear();
      xValues.addAll(_chaoticXValues);
      xRawValues.clear();
      xRawValues.addAll(_chaoticRawXValues);
    }
  }

  void _sort(List<List<num>> chaoticYLists, List<List<num>> yLists,
      List<List<Object?>>? chaoticFLists, List<List<Object?>>? fLists,
      {bool ascending = true}) {
    _computeSortedIndexes(ascending);
    if (sortedIndexes.isNotEmpty) {
      final void Function(int index, num xValue) copyX =
          _chaoticRawXValues.isNotEmpty ? _copyXAndRawXValue : _copyXValue;
      final int yLength = yLists.length;
      final int fLength = fLists!.length;
      final int length = sortedIndexes.length;

      xValues.clear();
      xRawValues.clear();

      for (int i = 0; i < length; i++) {
        final int sortedIndex = sortedIndexes[i];
        final num xValue = _chaoticXValues[sortedIndex];
        copyX(sortedIndex, xValue);
        for (int j = 0; j < yLength; j++) {
          final List<num> yValues = yLists[j];
          final List<num> chaoticYValues = chaoticYLists[j];
          yValues.add(chaoticYValues[sortedIndex]);
        }

        for (int k = 0; k < fLength; k++) {
          final List<Object?> fValues = fLists[k];
          final List<Object?> chaoticFValues = chaoticFLists![k];
          fValues.add(chaoticFValues[sortedIndex]);
        }

        // During sorting, determine data is linear or non-linear for
        // calculating visibleIndexes for proper axis range & segment rendering.
        if (_canFindLinearVisibleIndexes) {
          _canFindLinearVisibleIndexes = isValueLinear(i, xValue, xValues);
        }
      }
    }
  }

  void _computeSortedIndexes(bool ascending) {
    sortedIndexes.clear();
    int length = _chaoticRawSortValues.length;
    for (int i = 0; i < length; i++) {
      sortedIndexes.add(i);
    }
    final dynamic start = _chaoticRawSortValues[0];
    late dynamic canSwap;
    if (start is num) {
      canSwap = ascending ? _compareNumIsAscending : _compareNumIsDescending;
    } else if (start is DateTime) {
      canSwap = ascending ? _compareDateIsAscending : _compareDateIsDescending;
    } else {
      canSwap = ascending ? _compareStringAscending : _compareStringDescending;
    }

    bool swapped;
    do {
      swapped = false;
      for (int i = 0; i < length - 1; i++) {
        final int currentIndex = sortedIndexes[i];
        final int nextIndex = sortedIndexes[i + 1];
        if (canSwap(_chaoticRawSortValues[nextIndex],
            _chaoticRawSortValues[currentIndex])) {
          sortedIndexes[i] = nextIndex;
          sortedIndexes[i + 1] = currentIndex;
          swapped = true;
        }
      }
      length--;
    } while (swapped);
  }

  bool _compareNumIsAscending(num? a, num? b) {
    a ??= double.negativeInfinity;
    b ??= double.negativeInfinity;
    return a < b;
  }

  bool _compareNumIsDescending(num? a, num? b) {
    a ??= double.negativeInfinity;
    b ??= double.negativeInfinity;
    return a > b;
  }

  bool _compareDateIsAscending(DateTime a, DateTime b) => a.isBefore(b);

  bool _compareDateIsDescending(DateTime a, DateTime b) => a.isAfter(b);

  bool _compareStringAscending(String a, String b) => a.compareTo(b) < 0;

  bool _compareStringDescending(String a, String b) => a.compareTo(b) > 0;

  void _copyXAndRawXValue(int index, num xValue) {
    _copyXValue(index, xValue);
    xRawValues.add(_chaoticRawXValues[index]);
  }

  void _copyXValue(int index, num xValue) {
    xValues.add(xValue);
  }

  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    chartPoints.clear();
    if (parent == null || yLists == null || yLists.isEmpty) {
      return;
    }

    if (parent!.onDataLabelRender == null &&
        parent!.onTooltipRender == null &&
        parent!.legend?.legendItemBuilder == null &&
        dataLabelSettings.builder == null &&
        onPointLongPress == null &&
        onPointTap == null &&
        onPointDoubleTap == null) {
      return;
    }

    final int yLength = yLists.length;
    if (positions == null || positions.length != yLength) {
      return;
    }

    for (int i = 0; i < dataCount; i++) {
      final ChartPoint<D> point = ChartPoint<D>(x: xRawValues[i]);
      for (int j = 0; j < yLength; j++) {
        point[positions[j]] = yLists[j][i];
      }
      chartPoints.add(point);
    }
  }

  String localizedName() {
    if (parent != null && parent!.localizations != null) {
      return '${parent!.localizations!.series} $index';
    }
    return 'Series $index';
  }

  void updateSegmentColor(
      ChartSegment segment, Color? borderColor, double borderWidth,
      {Color? fillColor, bool isLineType = false}) {
    Color color;
    Color strokeColor;
    double strokeWidth;
    final Color effColor = effectiveColor(segment.currentSegmentIndex);
    if (segment.isEmpty) {
      color = (isLineType && emptyPointSettings.mode == EmptyPointMode.zero)
          ? fillColor ?? effColor
          : emptyPointSettings.color;
      // The purpose of isLineType is to set a default border color for
      // both line-type series and financial-type series.
      strokeColor = isLineType ? color : emptyPointSettings.borderColor;
      strokeWidth = emptyPointSettings.borderWidth;
    } else {
      color = fillColor ?? effColor;
      strokeColor = borderColor ?? effColor;
      strokeWidth = borderWidth;
    }

    if (opacity != 1.0) {
      if (color != Colors.transparent) {
        color = color.withOpacity(opacity);
      }
      if (strokeColor != Colors.transparent) {
        strokeColor = strokeColor.withOpacity(opacity);
      }
    }

    if (effectiveSelectionBehavior != null &&
        effectiveSelectionBehavior!.enable &&
        parent != null &&
        parent!.selectionController.hasSelection) {
      if (isSelected || segment.isSelected) {
        final double opacity = effectiveSelectionBehavior!.selectedOpacity;
        color = effectiveSelectionBehavior!.selectedColor ?? color;
        if (color != Colors.transparent) {
          color = color.withOpacity(opacity);
        }
        strokeColor =
            effectiveSelectionBehavior!.selectedBorderColor ?? strokeColor;
        if (strokeColor != Colors.transparent) {
          strokeColor = strokeColor.withOpacity(opacity);
        }
        strokeWidth =
            effectiveSelectionBehavior!.selectedBorderWidth ?? strokeWidth;
      } else {
        final double opacity = effectiveSelectionBehavior!.unselectedOpacity;
        color = effectiveSelectionBehavior!.unselectedColor ?? color;
        if (color != Colors.transparent) {
          color = color.withOpacity(opacity);
        }
        strokeColor =
            effectiveSelectionBehavior!.unselectedBorderColor ?? strokeColor;
        if (strokeColor != Colors.transparent) {
          strokeColor = strokeColor.withOpacity(opacity);
        }
        strokeWidth =
            effectiveSelectionBehavior!.unselectedBorderWidth ?? strokeWidth;
      }
    }

    segment.fillPaint.color = color;
    segment.strokePaint
      ..color = strokeColor
      ..strokeWidth = strokeWidth;
  }

  Color effectiveColor(int segmentIndex) {
    Color? pointColor;
    if (pointColorMapper != null && pointColors.isNotEmpty) {
      pointColor = pointColors[segmentIndex];
    }
    return pointColor ?? color ?? paletteColor;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (animationController != null && animationController!.isAnimating) {
      return false;
    }

    bool isDataLabelHit = false;
    if (dataLabelContainer != null) {
      final ChartSeriesParentData childParentData =
          dataLabelContainer!.parentData! as ChartSeriesParentData;
      isDataLabelHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return dataLabelContainer!.hitTest(result, position: transformed);
        },
      );
    }

    bool isTrendlineHit = false;
    if (trendlineContainer != null) {
      final ChartSeriesParentData childParentData =
          trendlineContainer!.parentData! as ChartSeriesParentData;
      isTrendlineHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return trendlineContainer!.hitTest(result, position: transformed);
        },
      );
    }

    final bool hasTouchCallback = onPointLongPress != null ||
        onPointTap != null ||
        onPointDoubleTap != null;
    bool isSeriesHit = false;
    if (isVisible() &&
        (_tooltipEnabled || _selectionEnabled || hasTouchCallback)) {
      if (hitInsideSegment(position)) {
        isSeriesHit = true;
      }
    }

    return isTrendlineHit || isDataLabelHit || isSeriesHit;
  }

  bool hitInsideSegment(Offset position) {
    _interactiveSegment = visibleSegmentAt(position);
    return _interactiveSegment != null;
  }

  void handleTapDown(TapDownDetails details) {}

  void handlePointerDown(PointerDownEvent details) {}

  void handleScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale != 0) {
      _canInvokePointerUp = false;
    }
  }

  void handlePointerUp(PointerUpEvent details) {
    final Offset localPosition = globalToLocal(details.position);
    if (onPointTap != null &&
        _interactiveSegment != null &&
        _canInvokePointerUp) {
      final int pointIndex =
          dataPointIndex(localPosition, _interactiveSegment!);
      final int segPointIndex =
          segmentPointIndex(localPosition, _interactiveSegment!);
      final ChartPointDetails pointDetails = ChartPointDetails(
        index,
        viewportIndex(segPointIndex),
        chartPoints,
        pointIndex,
      );
      onPointTap!(pointDetails);
    }
    _canInvokePointerUp = true;
  }

  void handlePointerHover(PointerHoverEvent details) {
    final Offset localPosition = globalToLocal(details.position);
    if (_interactiveSegment != null && isVisible()) {
      const bool hasSelection = false;
      final bool hasTooltip = _tooltipEnabled &&
          parent!.tooltipBehavior!.activationMode == ActivationMode.singleTap;
      _handleCurrentInteraction(hasSelection, hasTooltip, localPosition,
          kind: details.kind);
    }

    dataLabelContainer?.handlePointerHover(localPosition);
    trendlineContainer?.handlePointerHover(localPosition);
  }

  void handleLongPressStart(LongPressStartDetails details) {
    _canInvokePointerUp = false;
    final Offset localPosition = globalToLocal(details.globalPosition);
    if (onPointLongPress != null && _interactiveSegment != null) {
      final int pointIndex =
          dataPointIndex(localPosition, _interactiveSegment!);
      final int segPointIndex =
          segmentPointIndex(localPosition, _interactiveSegment!);
      final ChartPointDetails pointDetails = ChartPointDetails(
        index,
        viewportIndex(segPointIndex),
        chartPoints,
        pointIndex,
      );
      onPointLongPress!(pointDetails);
    }

    if (parent != null && _interactiveSegment != null) {
      final bool hasSelection = _selectionEnabled &&
          parent!.selectionGesture == ActivationMode.longPress;
      final bool hasTooltip = _tooltipEnabled &&
          parent!.tooltipBehavior!.activationMode == ActivationMode.longPress;
      _handleCurrentInteraction(hasSelection, hasTooltip, localPosition);
    }
  }

  void handleTapUp(TapUpDetails details) {
    final Offset localPosition = globalToLocal(details.globalPosition);
    if (parent != null && _interactiveSegment != null) {
      final bool hasSelection = _selectionEnabled &&
          parent!.selectionGesture == ActivationMode.singleTap;
      final bool hasTooltip = _tooltipEnabled &&
          parent!.tooltipBehavior!.activationMode == ActivationMode.singleTap;
      _handleCurrentInteraction(hasSelection, hasTooltip, localPosition);
    }

    dataLabelContainer?.handleTapUp(localPosition);
  }

  void handleDoubleTap(Offset position) {
    final Offset localPosition = globalToLocal(position);
    if (onPointDoubleTap != null && _interactiveSegment != null) {
      final int pointIndex =
          dataPointIndex(localPosition, _interactiveSegment!);
      final int segPointIndex =
          segmentPointIndex(localPosition, _interactiveSegment!);
      final ChartPointDetails pointDetails = ChartPointDetails(
        index,
        viewportIndex(segPointIndex),
        chartPoints,
        pointIndex,
      );
      onPointDoubleTap!(pointDetails);
    }

    if (parent != null && _interactiveSegment != null) {
      final bool hasSelection = _selectionEnabled &&
          parent!.selectionGesture == ActivationMode.doubleTap;
      final bool hasTooltip = _tooltipEnabled &&
          parent!.tooltipBehavior!.activationMode == ActivationMode.doubleTap;
      _handleCurrentInteraction(hasSelection, hasTooltip, localPosition);
    }
  }

  ChartSegment? visibleSegmentAt(Offset position) {
    for (final ChartSegment segment in segments) {
      if (segment.contains(position)) {
        return segment;
      }
    }

    return null;
  }

  int dataPointIndex(Offset position, ChartSegment segment) {
    int pointIndex = segment.currentSegmentIndex;
    if (_xNullPointIndexes.isNotEmpty) {
      for (final int xNullPointIndex in _xNullPointIndexes) {
        if (pointIndex >= xNullPointIndex) {
          pointIndex++;
        }
      }
    }
    return pointIndex;
  }

  int segmentPointIndex(Offset position, ChartSegment segment) {
    return segment.currentSegmentIndex;
  }

  int viewportIndex(int index, [List<int>? visibleIndexes]) {
    if (visibleIndexes != null && visibleIndexes.isNotEmpty) {
      if (canFindLinearVisibleIndexes) {
        final int start = visibleIndexes[0];
        final int end = visibleIndexes[1] + 1;
        int viewportIndex = 0;
        for (int i = start; i < end; i++) {
          if (i == index) {
            return viewportIndex;
          }
          viewportIndex++;
        }
      } else {
        return visibleIndexes.indexOf(index);
      }
    }
    return -1;
  }

  void _handleCurrentInteraction(
      bool hasSelection, bool hasTooltip, Offset position,
      {PointerDeviceKind kind = PointerDeviceKind.touch}) {
    if (parent != null && _interactiveSegment != null) {
      if (hasSelection) {
        _updateSelectionToController(
          index,
          _interactiveSegment!.currentSegmentIndex,
          selectionBehavior!.toggleSelection,
          selectionType: parent!.selectionMode,
        );
      }

      if (hasTooltip && !parent!.isTooltipActivated) {
        final TooltipInfo? info = tooltipInfo(position: position);
        if (info != null) {
          parent!.behaviorArea?.raiseTooltip(info, kind);
          parent!.isTooltipActivated = true;
        }
      }
    }
  }

  void _updateSelectionToController(
    int seriesIndex,
    int segmentPointIndex,
    bool togglingEnabled, {
    SelectionType? selectionType,
    bool forceSelection = false,
    bool forceDeselection = false,
  }) {
    parent?.selectionController.updateSelection(
      this,
      seriesIndex,
      segmentPointIndex,
      togglingEnabled,
      selectionType: selectionType,
      forceSelection: forceSelection,
      forceDeselection: forceDeselection,
    );
  }

  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (_interactiveSegment != null) {
      return _interactiveSegment!.tooltipInfo(position: position);
    }

    return null;
  }

  TooltipInfo? tooltipInfoFromPointIndex(int pointIndex) {
    if (segments.isNotEmpty && pointIndex < segments.length) {
      return segments[pointIndex].tooltipInfo(pointIndex: pointIndex);
    }
    return null;
  }

  void _updateSelectionToVisual(int seriesIndex, int segmentPointIndex,
      {bool elected = false}) {
    if (parent == null ||
        selectionBehavior == null ||
        !selectionBehavior!.enable) {
      return;
    }

    _invokeSelectionChangedCallback(seriesIndex, segmentPointIndex);
    switch (parent!.selectionMode) {
      case SelectionType.point:
        if (index == seriesIndex && segmentPointIndex < segments.length) {
          final ChartSegment segment = segmentAt(segmentPointIndex);
          segment.isSelected = elected;
        }
        break;

      case SelectionType.series:
        if (seriesIndex == index) {
          isSelected = elected;
        }
        break;

      case SelectionType.cluster:
        if (segmentPointIndex < segments.length) {
          segments[segmentPointIndex].isSelected = elected;
        }
        break;
    }

    markNeedsSegmentsPaint();
  }

  void _invokeSelectionChangedCallback(int seriesIndex, int segmentPointIndex) {
    if (parent != null && parent!.onSelectionChanged != null) {
      final SelectionArgs selectionArgs = SelectionArgs(
          seriesRenderer: this,
          seriesIndex: seriesIndex,
          pointIndex: segmentPointIndex,
          viewportPointIndex: viewportIndex(segmentPointIndex))
        ..selectedColor = selectionBehavior!.selectedColor
        ..unselectedColor = selectionBehavior!.unselectedColor
        ..selectedBorderColor = selectionBehavior!.selectedBorderColor
        ..unselectedBorderColor = selectionBehavior!.unselectedBorderColor
        ..selectedBorderWidth = selectionBehavior!.selectedBorderWidth
        ..unselectedBorderWidth = selectionBehavior!.unselectedBorderWidth;
      parent!.onSelectionChanged!(selectionArgs);
      _effectiveSelectionBehavior = selectionBehavior!.copyWith(
        selectedColor: selectionArgs.selectedColor,
        unselectedColor: selectionArgs.unselectedColor,
        selectedBorderColor: selectionArgs.selectedBorderColor,
        unselectedBorderColor: selectionArgs.unselectedBorderColor,
        selectedBorderWidth: selectionArgs.selectedBorderWidth,
        unselectedBorderWidth: selectionArgs.unselectedBorderWidth,
      );
    }
  }

  ChartSegment segmentAt(int segmentPointIndex) {
    return segments[segmentPointIndex];
  }

  @nonVirtual
  bool isEmpty(int segmentIndex) {
    // Handle sortedIndex for finding the empty point segment,
    // when segment rearrange with sorting.
    segmentIndex = sortedIndexes != null && sortedIndexes.isNotEmpty
        ? sortedIndexes[segmentIndex]
        : segmentIndex;
    int start = 0;
    int end = emptyPointIndexes.length - 1;
    while (start <= end) {
      final int mid = (start + end) ~/ 2;
      if (emptyPointIndexes[mid] == segmentIndex) {
        return true;
      } else if (emptyPointIndexes[mid] < segmentIndex) {
        start = mid + 1;
      } else {
        end = mid - 1;
      }
    }

    return false;
  }

  void _fetchMarkerImage() {
    if (markerSettings.shape == DataMarkerType.image &&
        markerSettings.image != null) {
      fetchImage(markerSettings.image).then((Image? value) {
        _markerImage = value;
        markNeedsPaint();
      });
    } else {
      _markerImage = null;
    }
  }

  void _calculateEffectiveSelectedIndexes() {
    if (parent != null &&
        _selectionEnabled &&
        effectiveSelectionBehavior != null &&
        effectiveSelectionBehavior!.enable) {
      final List<int> effectiveSelectedIndexes = <int>[];
      final RangeController? selectionController =
          effectiveSelectionBehavior?.selectionController;
      if (selectionController != null) {
        dynamic startRange = selectionController.start;
        dynamic endRange = selectionController.end;
        if (startRange is DateTime && endRange is DateTime) {
          startRange = startRange.millisecondsSinceEpoch;
          endRange = endRange.millisecondsSinceEpoch;
        }

        final int end = dataCount - 1;
        final int startIndex = findIndex(startRange, xValues, end: end);
        final int endIndex = findIndex(endRange, xValues, end: end);
        if (startIndex != endIndex) {
          for (int i = startIndex; i <= endIndex; i++) {
            effectiveSelectedIndexes.add(i);
          }
        }
      } else if (initialSelectedDataIndexes != null &&
          initialSelectedDataIndexes!.isNotEmpty) {
        effectiveSelectedIndexes.addAll(initialSelectedDataIndexes!);
      }
      initialSelectedDataIndexes?.clear();

      if (effectiveSelectedIndexes.isNotEmpty) {
        final int length = effectiveSelectedIndexes.length;
        for (int i = 0; i < length; i++) {
          _updateSelectionToController(
            index,
            effectiveSelectedIndexes[i],
            selectionBehavior!.toggleSelection,
            selectionType: parent!.selectionMode,
            forceSelection: true,
          );
        }

        if ((initialSelectedDataIndexes == null ||
                initialSelectedDataIndexes!.isEmpty) &&
            selectionController != null) {
          final List<int>? base =
              parent?.selectionController.selectedDataPoints[index];
          if (base != null) {
            final List<int> result = base
                .where((element) => !effectiveSelectedIndexes.contains(element))
                .toList();
            final int length = result.length;
            for (int i = 0; i < length; i++) {
              _updateSelectionToController(
                index,
                result[i],
                selectionBehavior!.toggleSelection,
                selectionType: parent!.selectionMode,
                forceDeselection: true,
              );
            }
          }
        }

        effectiveSelectedIndexes.clear();
      }
    }
  }

  void _handleSelection(int seriesIndex, int segmentPointIndex) {
    _updateSelectionToVisual(seriesIndex, segmentPointIndex, elected: true);
  }

  void _handleDeselection(int seriesIndex, int segmentPointIndex) {
    _updateSelectionToVisual(seriesIndex, segmentPointIndex);
  }

  @override
  void performUpdate() {
    populateDataSource();
    markNeedsLayout();
  }

  @override
  void markNeedsLayout() {
    super.markNeedsLayout();
    dataLabelContainer?.refresh();
    markerContainer?.refresh();
    trendlineContainer?.markNeedsLayout();
  }

  @protected
  void markNeedsSegmentsPaint() {
    segments.forEach(customizeSegment);
    markNeedsPaint();
  }

  @override
  void performResize() {
    _isResized = !hasSize || size != constraints.biggest;
    assert(!constraints.hasInfiniteWidth || !constraints.hasInfiniteWidth);
    size = constraints.biggest;
  }

  @override
  @mustCallSuper
  void performLayout() {
    if (!isVisible() ||
        constraints.maxWidth <= 0.0 ||
        constraints.maxHeight <= 0.0) {
      return;
    }

    if (canUpdateOrCreateSegments) {
      createOrUpdateSegments();
    }

    if (canUpdateOrCreateSegments ||
        _isXRangeChanged ||
        _isYRangeChanged ||
        _isResized ||
        forceTransformValues) {
      transformValues();
    }

    canUpdateOrCreateSegments = false;
    _isXRangeChanged = false;
    _isYRangeChanged = false;
    _isResized = false;
    forceTransformValues = false;
  }

  @protected
  void createOrUpdateSegments() {
    if (dataCount == 0) {
      segments.clear();
      return;
    }

    final int segmentsCount = segments.length;
    if (segmentsCount == dataCount) {
      for (int i = 0; i < segmentsCount; i++) {
        final ChartSegment segment = segments[i];
        setData(i, segment);
      }
    } else if (segmentsCount > dataCount) {
      _segments = segments.sublist(0, dataCount);
      for (int i = 0; i < dataCount; i++) {
        final ChartSegment segment = segments[i];
        setData(i, segment);
      }
    } else {
      for (int i = 0; i < segmentsCount; i++) {
        final ChartSegment segment = segments[i];
        setData(i, segment);
      }
      for (int i = segmentsCount; i < dataCount; i++) {
        final ChartSegment segment = createSegment();
        setData(i, segment);
        segments.add(segment);
      }
    }

    _calculateEffectiveSelectedIndexes();
  }

  /// To create segment for series.
  @protected
  ChartSegment createSegment();

  @protected
  @mustCallSuper
  void setData(int index, ChartSegment segment) {
    segment
      ..currentSegmentIndex = index
      ..animationFactor = segmentAnimationFactor;
  }

  void copyOldSegmentValues(
      double animationFactor, double segmentAnimationFactor) {
    for (int i = 0; i < segments.length; i++) {
      final ChartSegment segment = segments[i];
      segment.copyOldSegmentValues(animationFactor, segmentAnimationFactor);
    }
  }

  @protected
  void transformValues() {
    final int segmentsCount = segments.length;
    for (int i = 0; i < dataCount; i++) {
      if (i < segmentsCount) {
        final ChartSegment segment = segments[i];
        segment.animationFactor = segmentAnimationFactor;
        segment.transformValues();
        customizeSegment(segment);
      }
    }
  }

  /// To customize each segments.
  void customizeSegment(ChartSegment segment);

  @override
  @nonVirtual
  void paint(PaintingContext context, Offset offset) {
    if (!isVisible() || size.isEmpty) {
      return;
    }

    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);
    onPaint(context, offset);
    context.canvas.restore();
  }

  @protected
  void onPaint(PaintingContext context, Offset offset) {
    paintSegments(context, offset);
  }

  @protected
  void paintSegments(PaintingContext context, Offset offset) {
    if (segments.isNotEmpty) {
      for (final ChartSegment segment in segments) {
        segment.animationFactor = segmentAnimationFactor;
        segment.onPaint(context.canvas);
      }
    }
  }

  @override
  void dispose() {
    _animationController
      ?..removeStatusListener(_handleAnimationStatusChange)
      ..dispose();
    _animationController = null;
    _animation
      ?..removeListener(_handleAnimationUpdate)
      ..dispose();
    _animation = null;

    _markerAnimationController?.dispose();
    _markerAnimationController = null;
    _markerAnimation?.dispose();
    _markerAnimation = null;

    _dataLabelAnimationController?.dispose();
    _dataLabelAnimationController = null;
    _dataLabelAnimation?.dispose();
    _dataLabelAnimation = null;

    _resetDataSourceHolders();

    for (final ChartSegment segment in segments) {
      segment.dispose();
    }

    super.dispose();
  }
}

/// Creates the segments for chart series.
///
/// It has the public method and properties to customize the segment in the
/// chart series, User can customize the calculation of the segment points
/// by using the method [calculateSegmentPoints]. It has the property to
/// store the old value of the series to support dynamic animation.
///
/// Provides the public properties color, stroke color, fill paint,
/// stroke paint, series and old series to customize and dynamically
/// change each segment in the chart.
abstract class ChartSegment {
  // TODO(VijayakumarM): Mark it as abstract.
  /// Transforms the x and y values to screen coordinates.
  void transformValues() {}

  /// Gets the color of the series.
  Paint getFillPaint();

  /// Gets the border color of the series.
  Paint getStrokePaint();

  /// Calculates the rendering bounds of a segment.
  // TODO(VijayakumarM): Check and remove this method.
  // ! Breaking changes.
  void calculateSegmentPoints();

  /// Draws segment in series bounds.
  void onPaint(Canvas canvas);

  bool isSelected = false;

  bool contains(Offset position) {
    return false;
  }

  /// Fill paint of the segment.
  final Paint fillPaint = Paint()..isAntiAlias = true;

  /// Stroke paint of the segment.
  final Paint strokePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  /// Animation factor value.
  double animationFactor = 0.0;

  // TODO(VijayakumarM): Check and remove this.
  // ! Breaking changes.
  /// Current point offset value.
  List<Offset> points = <Offset>[];

  /// Current index value.
  int currentSegmentIndex = -1;

  /// Specifies the segment has empty point.
  bool isEmpty = false;

  /// Specifies the segment is visible or not for circular, funnel and pyramid segments only.
  /// Not applicable for cartesian segments.
  bool isVisible = true;

  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {}

  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) => null;

  TrackballInfo? trackballInfo(Offset position, int pointIndex) => null;

  /// To dispose the objects.
  void dispose() {
    points.clear();
    fillPaint.shader?.dispose();
    strokePaint.shader?.dispose();
  }
}

// We can redraw the series with updating or creating new points by
// using this controller. If we need to access the redrawing methods in this
// before we must get the ChartSeriesController [onRendererCreated] event.
class ChartSeriesController<T, D> {
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
  final CartesianSeriesRenderer<T, D> seriesRenderer;

  final List<VoidCallback> _visibleListeners = <VoidCallback>[];

  bool get isVisible => _isVisible;
  bool _isVisible = true;
  set isVisible(bool value) {
    if (_isVisible != value) {
      _isVisible = value;
      notifyVisibleListeners();
    }
  }

  void _addVisibleListener(VoidCallback listener) {
    _visibleListeners.add(listener);
  }

  void _removeVisibleListener(VoidCallback listener) {
    _visibleListeners.remove(listener);
  }

  @protected
  void notifyVisibleListeners() {
    for (final VoidCallback listener in _visibleListeners) {
      listener();
    }
  }

  void _dispose() {
    _visibleListeners.clear();
  }

  /// Used to process only the newly added, updated and removed data points
  /// in a series, instead of processing all the data points.
  ///
  /// To re-render the chart with modified data points,
  /// setState() will be called.
  /// This will render the process and render the chart from scratch.
  /// Thus, the app’s performance will be degraded on continuous update.
  /// To overcome this problem, [updateDataSource] method can be called
  ///  by passing updated data points indexes. Chart will process only
  /// that point and skip various steps like bounds calculation, old data points
  ///  processing, etc. Thus, this will improve the app’s performance.
  ///
  /// The following are the arguments of this method.
  /// * addedDataIndexes – `List<int>` type – Indexes of newly added data points
  /// in the existing series.
  /// * removedDataIndexes – `List<int>` type – Indexes of removed data points
  /// in the existing series.
  /// * updatedDataIndexes – `List<int>` type – Indexes of updated data points
  /// in the existing series.
  /// * addedDataIndex – `int` type – Index of newly added data point
  /// in the existing series.
  /// * removedDataIndex – `int` type – Index of removed data point
  /// in the existing series.
  /// * updatedDataIndex – `int` type – Index of updated data point
  /// in the existing series.
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
  void updateDataSource({
    List<int>? addedDataIndexes,
    List<int>? removedDataIndexes,
    List<int>? updatedDataIndexes,
    int addedDataIndex = -1,
    int removedDataIndex = -1,
    int updatedDataIndex = -1,
  }) {
    final CartesianRealTimeUpdateMixin<T, D>? renderer =
        seriesRenderer as CartesianRealTimeUpdateMixin<T, D>?;
    if (renderer != null) {
      List<int>? effectiveRemovedIndexes;
      List<int>? effectiveAddedIndexes;
      List<int>? effectiveReplacedIndexes;

      if (removedDataIndexes != null) {
        effectiveRemovedIndexes = List<int>.from(removedDataIndexes);
      }

      if (addedDataIndexes != null) {
        effectiveAddedIndexes = List<int>.from(addedDataIndexes);
      }

      if (updatedDataIndexes != null) {
        effectiveReplacedIndexes = List<int>.from(updatedDataIndexes);
      }

      if (removedDataIndex != -1) {
        effectiveRemovedIndexes ??= <int>[];
        effectiveRemovedIndexes.add(removedDataIndex);
      }

      if (addedDataIndex != -1) {
        effectiveAddedIndexes ??= <int>[];
        effectiveAddedIndexes.add(addedDataIndex);
      }

      if (updatedDataIndex != -1) {
        effectiveReplacedIndexes ??= <int>[];
        effectiveReplacedIndexes.add(updatedDataIndex);
      }

      renderer.updateDataPoints(
        effectiveRemovedIndexes,
        effectiveAddedIndexes,
        effectiveReplacedIndexes,
      );
    }
  }

  /// Converts logical pixel value to the data point value.
  ///
  /// The [pixelToPoint] method takes logical pixel value as input and returns
  /// a chart data point.
  ///
  /// Since this method is in the series controller, x and y-axis associated
  /// with this particular series will be considering for conversion value.
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
  ///       final CartesianChartPoint? chartPoint =
  ///         _chartSeriesController?.pixelToPoint(value);
  ///       print('X point: ${chartPoint?.x}');
  ///       print('Y point: ${chartPoint?.y}');
  ///     },
  ///   );
  /// }
  /// ```
  CartesianChartPoint<D> pixelToPoint(Offset position) {
    if (seriesRenderer.parent == null ||
        seriesRenderer.parent!.parentData == null ||
        seriesRenderer.xAxis == null) {
      return CartesianChartPoint<D>();
    }

    final BoxParentData parentData =
        seriesRenderer.parent!.parentData! as BoxParentData;
    final Rect seriesBounds = seriesRenderer.paintBounds;
    position -= parentData.offset;
    double xValue = seriesRenderer.xAxis!
        .pixelToPoint(seriesBounds, position.dx, position.dy);
    final num yValue = seriesRenderer.yAxis!
        .pixelToPoint(seriesBounds, position.dx, position.dy);

    if (seriesRenderer.xAxis is RenderCategoryAxis ||
        seriesRenderer.xAxis is RenderDateTimeCategoryAxis) {
      xValue = xValue.round().toDouble();
    }
    final dynamic rawX = _rawXValue(seriesRenderer, xValue) ?? xValue;
    return CartesianChartPoint<D>(x: rawX, xValue: xValue, y: yValue);
  }

  D? _rawXValue(CartesianSeriesRenderer seriesRenderer, num xValue) {
    final int index = seriesRenderer.xValues.indexOf(xValue);
    final RenderChartAxis xAxis = seriesRenderer.xAxis!;

    if (index == -1) {
      if (xAxis is RenderDateTimeAxis) {
        return DateTime.fromMillisecondsSinceEpoch(xValue.toInt()) as D;
      } else if (xAxis is RenderCategoryAxis ||
          xAxis is RenderDateTimeCategoryAxis) {
        return xValue.toString() as D;
      } else {
        return xValue as D;
      }
    }
    return index != -1 ? seriesRenderer.xRawValues[index] : null;
  }

  /// Converts chart data point value to logical pixel value.
  ///
  /// The [pointToPixel] method takes chart data point value as input and
  /// returns logical pixel value.
  ///
  /// Since this method is in the series controller, x and y-axis associated
  /// with this particular series will be
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
  ///           final CartesianChartPoint chartPoint =
  ///             CartesianChartPoint(
  ///             chartData[args.pointIndex!].x,
  ///             chartData[args.pointIndex!].y);
  ///           final Offset? pointLocation =
  ///             _chartSeriesController?.pointToPixel(chartPoint);
  ///           print('X location: ${pointLocation!.dx}');
  ///           print('Y location: ${pointLocation.dy}');
  ///         },
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  Offset pointToPixel(CartesianChartPoint<D> point) {
    if (point.x == null || point.y == null || seriesRenderer.xAxis == null) {
      return Offset.zero;
    }

    final RenderChartAxis xAxis = seriesRenderer.xAxis!;
    final D? x = point.x;
    num pointX;

    if (x is int) {
      pointX = x;
    } else {
      if (xAxis is RenderDateTimeAxis) {
        assert(x is DateTime);
        pointX = (x as DateTime).millisecondsSinceEpoch;
      } else if (xAxis is RenderDateTimeCategoryAxis) {
        assert(x is DateTime);
        pointX = xAxis.labels.indexOf((x as DateTime).millisecondsSinceEpoch);
      } else if (xAxis is RenderCategoryAxis) {
        assert(x is String);
        pointX = xAxis.labels.indexOf(x.toString());
      } else {
        pointX = x as num;
      }
    }

    final double pixelX = seriesRenderer.pointToPixelX(pointX, point.y!);
    final double pixelY = seriesRenderer.pointToPixelY(pointX, point.y!);
    return Offset(pixelX, pixelY);
  }

  /// If you wish to perform initial animation again in the existing series,
  /// this method can be called.
  /// On calling this method, this particular series will be animated again
  /// based on the `animationDuration`
  /// property's value in the series. If the value is 0, then the animation
  /// will not be performed.
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
    seriesRenderer.animationType = AnimationType.loading;
  }
}

/// This class has the properties of the cartesian series.
///
/// The cartesian series provides a variety of options, such as animation,
/// dynamic animation, transpose, color palette,
/// color mapping to customize the Cartesian chart. The chart’s data source
/// can be sorted using the sorting order and
/// [sortFieldValueMapper] properties of series.
///
/// Provides the options for animation, color palette, sorting, and empty point
/// mode to customize the charts.
///
abstract class CartesianSeries<T, D> extends ChartSeries<T, D> {
  /// Creating an argument constructor of [CartesianSeries] class.
  const CartesianSeries({
    super.key,
    super.xValueMapper,
    super.dataLabelMapper,
    super.name,
    super.dataSource,
    this.xAxisName,
    this.yAxisName,
    super.pointColorMapper,
    super.color,
    super.legendItemText,
    super.sortFieldValueMapper,
    this.gradient,
    this.borderGradient,
    this.trendlines,
    super.markerSettings,
    this.onRendererCreated,
    this.onCreateRenderer,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    this.onCreateShader,
    super.initialIsVisible,
    super.enableTooltip = true,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.animationDuration,
    this.dashArray,
    super.borderWidth,
    super.selectionBehavior,
    super.initialSelectedDataIndexes,
    super.isVisibleInLegend,
    super.legendIconType,
    super.opacity,
    super.animationDelay,
    super.sortingOrder,
  });

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
  ///  return SfCartesianChart(
  ///    series: <LineSeries<SalesData, num>>[
  ///      LineSeries<SalesData, num>(
  ///          dataSource: chartData,
  ///          xValueMapper: (datum, index) => datum.x,
  ///          yValueMapper: (datum, index) => datum.y,
  ///          onCreateRenderer: (ChartSeries<SalesData, num> series) {
  ///            return CustomLinerSeriesRenderer(
  ///                series as LineSeries<SalesData, num>);
  ///          }),
  ///    ],
  ///  );
  /// }
  ///
  /// class CustomLinerSeriesRenderer extends LineSeriesRenderer<SalesData, num> {
  ///   CustomLinerSeriesRenderer(this.series);
  ///   final LineSeries<SalesData, num> series;
  ///
  ///   @override
  ///   LineSegment<SalesData, num> createSegment() {
  ///     return _LineCustomPainter(series);
  ///   }
  /// }
  ///
  /// class _LineCustomPainter extends LineSegment<SalesData, num> {
  ///   _LineCustomPainter(this._series);
  ///   final LineSeries<SalesData, num> _series;
  ///
  ///   @override
  ///   int get currentSegmentIndex => super.currentSegmentIndex;
  ///
  ///   @override
  ///   Paint getFillPaint() {
  ///     final Paint customerFillPaint = Paint();
  ///     customerFillPaint.color = _series.dataSource![currentSegmentIndex].y > 30
  ///       ? Colors.red
  ///       : Colors.green;
  ///     customerFillPaint.style = PaintingStyle.fill;
  ///     return customerFillPaint;
  ///   }
  ///
  ///   @override
  ///   void onPaint(Canvas canvas) {
  ///      super.onPaint(canvas);
  ///    }
  ///  }
  /// ```
  final ChartSeriesRendererFactory<T, D>? onCreateRenderer;

  /// Triggers when the series renderer is created.
  ///
  /// Using this callback, able to get the [ChartSeriesController] instance,
  /// which is used to access the public methods in the series.
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
  final SeriesRendererCreatedCallback<T, D>? onRendererCreated;

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
  ///         trendlines: <Trendline>[
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

  /// Dashes of the series.
  ///
  /// Any number of values can be provided in the list. Odd value
  /// is considered as rendering size and even value is considered as gap.
  ///
  /// _Note:_ This is applicable for line, spline, step line,
  /// and fast line series only.
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
  final List<double>? dashArray;

  /// Fills the data points with the gradient and image shaders.
  ///
  /// The data points of pie, doughnut and radial bar charts can be filled with [gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html)
  /// (linear, radial and sweep gradient) and [image shaders](https://api.flutter.dev/flutter/dart-ui/ImageShader-class.html).
  ///
  /// All the data points are together considered as a single segment
  /// and the shader is applied commonly.
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

  bool transposed() => false;

  @override
  Widget? childForSlot(SeriesSlot slot) {
    if (dataSource == null) {
      return null;
    }
    switch (slot) {
      case SeriesSlot.dataLabel:
        return dataLabelSettings.isVisible
            ? CartesianDataLabelContainer<T, D>(
                series: this,
                dataSource: dataSource!,
                mapper: dataLabelMapper,
                builder: dataLabelSettings.builder,
                settings: dataLabelSettings,
                positions: positions,
              )
            : null;

      case SeriesSlot.marker:
        return markerSettings.isVisible
            // TODO(VijayakumarM): Check bang operator.
            ? MarkerContainer<T, D>(
                series: this, dataSource: dataSource!, settings: markerSettings)
            : null;

      case SeriesSlot.trendline:
        return trendlines != null
            ? TrendlineContainer(trendlines: trendlines!)
            : null;
    }
  }

  @override
  CartesianSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final CartesianSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as CartesianSeriesRenderer<T, D>;
    renderer
      ..xAxisName = xAxisName
      ..yAxisName = yAxisName
      ..color = color
      ..trendlines = trendlines
      ..gradient = gradient
      ..borderGradient = borderGradient
      ..dashArray = dashArray
      ..isVisibleInLegend = isVisibleInLegend
      ..initialSelectedDataIndexes = initialSelectedDataIndexes
      ..onCreateShader = onCreateShader
      ..onRendererCreated = onRendererCreated;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, CartesianSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..xAxisName = xAxisName
      ..yAxisName = yAxisName
      ..color = color
      ..trendlines = trendlines
      ..gradient = gradient
      ..borderGradient = borderGradient
      ..dashArray = dashArray
      ..isVisibleInLegend = isVisibleInLegend
      ..initialSelectedDataIndexes = initialSelectedDataIndexes
      ..onCreateShader = onCreateShader;
  }
}

/// Creates a series renderer for Cartesian series.
abstract class CartesianSeriesRenderer<T, D> extends ChartSeriesRenderer<T, D>
    with AxisDependent {
  List<int> visibleIndexes = <int>[];

  ChartSeriesController<T, D> get controller => _controller;
  late final ChartSeriesController<T, D> _controller =
      ChartSeriesController<T, D>(this);

  DoubleRange? _yVisibleRange;

  // TODO(VijayakumarM): Ensure the hit test order.
  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (trendlineContainer != null) trendlineContainer!,
      if (markerContainer != null) markerContainer!,
      if (dataLabelContainer != null) dataLabelContainer!,
    ];
  }

  @override
  RenderCartesianChartPlotArea? get parent =>
      super.parent as RenderCartesianChartPlotArea?;

  @override
  set dataSource(List<T>? value) {
    if ((value == null || value.isEmpty) && !listEquals(_dataSource, value)) {
      _dataCount = 0;
      segments.clear();
      markNeedsUpdate();
    }

    if (_dataCount != value?.length || !listEquals(_dataSource, value)) {
      _dataSource = value;
      canUpdateOrCreateSegments = true;
      parent?.isLegendToggled = false;
      if (xAxis != null &&
          yAxis != null &&
          parent != null &&
          parent!.enableAxisAnimation) {
        populateDataSource();
        xAxis!.calculateVisibleRangeAndInvokeAnimation();
        yAxis!.calculateVisibleRangeAndInvokeAnimation();
        markNeedsLayout();
      } else {
        markNeedsUpdate();
      }
      animationType = AnimationType.realtime;
    }
  }

  @override
  set initialIsVisible(bool value) {
    if (initialIsVisible != value) {
      super.initialIsVisible = value;
      includeRange = value;
      controller.isVisible = value;
    }
  }

  List<Trendline>? get trendlines => _trendlines;
  List<Trendline>? _trendlines;
  set trendlines(List<Trendline>? value) {
    if (_trendlines != value) {
      _trendlines = value;
      markNeedsUpdate();
    }
  }

  LinearGradient? get gradient => _gradient;
  LinearGradient? _gradient;
  set gradient(LinearGradient? value) {
    if (_gradient != value) {
      _gradient = value;
      markNeedsLegendUpdate();
      markNeedsSegmentsPaint();
    }
  }

  LinearGradient? get borderGradient => _borderGradient;
  LinearGradient? _borderGradient;
  set borderGradient(LinearGradient? value) {
    if (_borderGradient != value) {
      _borderGradient = value;
      markNeedsLegendUpdate();
      markNeedsSegmentsPaint();
    }
  }

  List<double>? get dashArray => _dashArray;
  List<double>? _dashArray;
  set dashArray(List<double>? value) {
    if (_dashArray != value) {
      _dashArray = value;
      markNeedsLegendUpdate();
      markNeedsSegmentsPaint();
    }
  }

  CartesianShaderCallback? get onCreateShader => _onCreateShader;
  CartesianShaderCallback? _onCreateShader;
  set onCreateShader(CartesianShaderCallback? value) {
    if (_onCreateShader != value) {
      _onCreateShader = value;
      markNeedsLegendUpdate();
      markNeedsSegmentsPaint();
    }
  }

  SeriesRendererCreatedCallback<T, D>? get onRendererCreated =>
      _onRendererCreated;
  SeriesRendererCreatedCallback<T, D>? _onRendererCreated;
  set onRendererCreated(SeriesRendererCreatedCallback<T, D>? value) {
    if (_onRendererCreated != value) {
      _onRendererCreated = value;
    }
  }

  @override
  set xAxis(RenderChartAxis? value) {
    super.xAxis = value;
    trendlineContainer?.setXAxis(value);
  }

  @override
  set yAxis(RenderChartAxis? value) {
    super.yAxis = value;
    trendlineContainer?.setYAxis(value);
  }

  @override
  bool isVisible() => controller.isVisible;

  @override
  List<LegendItem>? buildLegendItems(int index) {
    final List<LegendItem>? items = super.buildLegendItems(index);
    if (trendlineContainer != null) {
      items!.addAll(trendlineContainer!.buildLegendItems(index, this)!);
    }
    return items;
  }

  @override
  void handleLegendItemTapped(LegendItem item, bool isToggled) {
    super.handleLegendItemTapped(item, isToggled);
    controller.isVisible = !isToggled;
    if (controller.isVisible == !isToggled) {
      item.onToggled?.call();
    }

    if (trendlineContainer != null) {
      trendlineContainer!.updateLegendState(item, isToggled);
      markNeedsLegendUpdate();
    }
    markNeedsUpdate();
  }

  @override
  bool _isToggled() {
    return !controller.isVisible;
  }

  @override
  Shader? legendIconShader() {
    if (parent != null && parent!.legend != null) {
      final Rect legendIconBounds = Rect.fromLTWH(
          0.0, 0.0, parent!.legend!.iconWidth, parent!.legend!.iconHeight);
      if (onCreateShader != null) {
        final ShaderDetails details = ShaderDetails(legendIconBounds, 'legend');
        return onCreateShader?.call(details);
      } else {
        return gradient?.createShader(legendIconBounds);
      }
    }
    return null;
  }

  @override
  void attach(PipelineOwner owner) {
    controller._addVisibleListener(_handleIsVisibleChange);
    if (onRendererCreated != null) {
      onRendererCreated?.call(controller);
    }
    super.attach(owner);
  }

  @override
  void detach() {
    controller._removeVisibleListener(_handleIsVisibleChange);
    super.detach();
  }

  @override
  void _handleSelectionControllerChange() {
    _calculateEffectiveSelectedIndexes();
    markNeedsSegmentsPaint();
  }

  void _handleIsVisibleChange() {
    includeRange = controller.isVisible;
    markNeedsUpdate();
  }

  @override
  void copyOldSegmentValues(
      double animationFactor, double segmentAnimationFactor) {
    super.copyOldSegmentValues(animationFactor, segmentAnimationFactor);
    forceTransformValues = true;
    markNeedsLayout();
  }

  @override
  void _resetDataSourceHolders() {
    visibleIndexes.clear();
    final DoubleRange defaultXRange =
        xAxis?.defaultRange() ?? DoubleRange(0, 1);
    final DoubleRange defaultYRange =
        yAxis?.defaultRange() ?? DoubleRange(0, 1);
    xMin = defaultXRange.minimum;
    xMax = defaultXRange.maximum;
    yMin = defaultYRange.minimum;
    yMax = defaultYRange.maximum;
    super._resetDataSourceHolders();
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    // Here fPath is widget specific feature path.
    // For example, in bubble series's bubbleSizeMapper is a feature path.
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    _resetDataSourceHolders();
    if (!_canPopulateDataPoints(yPaths, chaoticYLists)) {
      return;
    }

    if (fPaths == null) {
      fPaths = <ChartValueMapper<T, Object>>[];
      chaoticFLists = <List<Object?>>[];
      fLists = <List<Object?>>[];
    }
    _addPointColorMapper(fPaths, chaoticFLists, fLists);
    _addSortValueMapper(fPaths, chaoticFLists, fLists);

    final int length = dataSource!.length;
    final int yPathLength = yPaths!.length;
    final int fPathLength = fPaths.length;

    num previousX = double.negativeInfinity;
    num xMinimum = double.infinity;
    num xMaximum = double.negativeInfinity;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;
    final Function(int, D) preferredXValue = _preferredXValue();
    final Function(D?, num) addXValue = _addXValueIntoRawAndChaoticXLists;

    for (int i = 0; i < length; i++) {
      final T current = dataSource![i];
      final D? rawX = xValueMapper!(current, i);
      if (rawX == null) {
        _xNullPointIndexes.add(i);
        continue;
      }

      final num currentX = preferredXValue(i, rawX);
      addXValue(rawX, currentX);
      xMinimum = min(xMinimum, currentX);
      xMaximum = max(xMaximum, currentX);
      if (_hasLinearDataSource) {
        _hasLinearDataSource = currentX >= previousX;
      }

      for (int j = 0; j < yPathLength; j++) {
        final ChartValueMapper<T, num> yPath = yPaths[j];
        final num? yValue = yPath(current, i);
        if (yValue == null || yValue.isNaN) {
          chaoticYLists![j].add(double.nan);
          if (!emptyPointIndexes.contains(i)) {
            emptyPointIndexes.add(i);
          }
        } else {
          chaoticYLists![j].add(yValue);
          yMinimum = min(yMinimum, yValue);
          yMaximum = max(yMaximum, yValue);
        }
      }

      for (int j = 0; j < fPathLength; j++) {
        final ChartValueMapper<T, Object> fPath = fPaths[j];
        final Object? fValue = fPath(current, i);
        chaoticFLists![j].add(fValue);
      }

      previousX = currentX;
    }

    xMin = xMinimum;
    xMax = xMaximum;
    yMin = yMinimum;
    yMax = yMaximum;
    _dataCount = _chaoticXValues.length;
    _canFindLinearVisibleIndexes = _hasLinearDataSource;

    _applyEmptyPointModeIfNeeded(chaoticYLists!);
    _doSortingIfNeeded(chaoticYLists, yLists, chaoticFLists, fLists);
    computeNonEmptyYValues();
    _populateTrendlineDataSource();
    _updateXValuesForCategoryTypeAxes();
  }

  Function(int, D) _preferredXValue() {
    if (xAxis is RenderNumericAxis || xAxis is RenderLogarithmicAxis) {
      return _valueAsNum;
    } else if (xAxis is RenderDateTimeAxis) {
      return _dateToMilliseconds;
    } else if (xAxis is RenderCategoryAxis ||
        xAxis is RenderDateTimeCategoryAxis) {
      return _valueToIndex;
    }
    return _valueAsNum;
  }

  void _updateXValuesForCategoryTypeAxes() {
    if (xAxis is RenderCategoryAxis) {
      (xAxis! as RenderCategoryAxis).updateXValuesWithArrangeByIndex();
    } else if (xAxis is RenderDateTimeCategoryAxis) {
      (xAxis! as RenderDateTimeCategoryAxis).updateXValues();
    }

    if (!_canFindLinearVisibleIndexes) {
      return;
    }

    for (int i = 0; i < dataCount; i++) {
      if (_canFindLinearVisibleIndexes) {
        _canFindLinearVisibleIndexes = isValueLinear(i, xValues[i], xValues);
        if (!_canFindLinearVisibleIndexes) {
          return;
        }
      }
    }
  }

  @protected
  void _populateTrendlineDataSource() {}

  @protected
  void computeNonEmptyYValues() {}

  num trackballYValue(int index) => index;

  /// Method excepts [BoxAndWhiskerSeries], and stacking series.
  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    chartPoints.clear();
    if (parent == null || yLists == null || yLists.isEmpty) {
      return;
    }

    if (parent!.onDataLabelRender == null &&
        parent!.onTooltipRender == null &&
        parent!.legend?.legendItemBuilder == null &&
        dataLabelSettings.builder == null &&
        onPointLongPress == null &&
        onPointTap == null &&
        onPointDoubleTap == null) {
      return;
    }

    final int yLength = yLists.length;
    if (positions == null || positions.length != yLength) {
      return;
    }

    for (int i = 0; i < dataCount; i++) {
      final num xValue = xValues[i];
      final CartesianChartPoint<D> point =
          CartesianChartPoint<D>(x: xRawValues[i], xValue: xValue);
      for (int j = 0; j < yLength; j++) {
        point[positions[j]] = yLists[j][i];
      }
      chartPoints.add(point);
    }
  }

  @override
  DoubleRange range(RenderChartAxis axis) {
    final RenderCartesianChartPlotArea? plotArea = parent;
    if (axis == yAxis &&
        axis.anchorRangeToVisiblePoints &&
        plotArea != null &&
        plotArea.zoomPanBehavior != null &&
        plotArea.zoomPanBehavior!.zoomMode == ZoomMode.x &&
        _yVisibleRange != null) {
      return _yVisibleRange!.copyWith();
    }

    final DoubleRange actualRange = super.range(axis).copyWith();
    if (trendlineContainer == null) {
      return actualRange;
    }

    return _trendlineRange(actualRange, axis);
  }

  DoubleRange _trendlineRange(DoubleRange actualRange, RenderChartAxis axis) {
    num minimum = actualRange.minimum;
    num maximum = actualRange.maximum;
    final DoubleRange trendlineRange =
        trendlineContainer!.range(axis, actualRange);
    minimum = min(minimum, trendlineRange.minimum);
    maximum = max(maximum, trendlineRange.maximum);

    return actualRange
      ..minimum = minimum
      ..maximum = maximum;
  }

  @override
  void didRangeChange(RenderChartAxis axis) {
    if (parent == null) {
      return;
    }

    if (axis == xAxis) {
      _isXRangeChanged = true;
      _findVisibleIndexes();
    }

    if (axis == yAxis) {
      _isYRangeChanged = true;
    }

    if (controller.isVisible) {
      markNeedsLayout();
    }
  }

  @protected
  void _findVisibleIndexes() {
    visibleIndexes.clear();
    if (xAxis == null ||
        xAxis!.visibleRange == null ||
        xAxis!.visibleInterval == 0) {
      return;
    }

    final DoubleRange baseRange = xAxis!.visibleRange!.copyWith();
    late DoubleRange range;
    if (xAxis is RenderLogarithmicAxis) {
      range = DoubleRange(
          _valueAsPow(baseRange.minimum), _valueAsPow(baseRange.maximum));
    } else {
      range = baseRange;
    }

    if (canFindLinearVisibleIndexes) {
      final int end = dataCount - 1;
      final int startIndex = findIndex(range.minimum, xValues, end: end);
      final int endIndex = findIndex(range.maximum, xValues, end: end);
      if (startIndex != -1) {
        final num startValue = xValues[startIndex];
        if (startIndex != 0 && startValue > range.minimum) {
          visibleIndexes.add(startIndex - 1);
        } else {
          visibleIndexes.add(startIndex);
        }
      }

      if (endIndex != -1) {
        final num endValue = xValues[endIndex];
        if (endIndex != dataCount - 1 && endValue < range.maximum) {
          visibleIndexes.add(endIndex + 1);
        } else {
          visibleIndexes.add(endIndex);
        }
      }
    } else {
      for (int i = 0; i < dataCount; i++) {
        final num current = xValues[i];
        if (range.contains(current)) {
          visibleIndexes.add(i);
        }
      }

      if (visibleIndexes.isNotEmpty) {
        final int startIndex = visibleIndexes[0];
        final num startValue = xValues[startIndex];
        if (startIndex != 0 && startValue > range.minimum) {
          visibleIndexes.insert(0, startIndex - 1);
        }

        final int length = visibleIndexes.length;
        final int endIndex = visibleIndexes[length - 1];
        final num endValue = xValues[endIndex];
        if (endIndex != dataCount - 1 && endValue < range.maximum) {
          visibleIndexes.add(endIndex + 1);
        }
      }
    }

    final RenderCartesianChartPlotArea? plotArea = parent;
    if (controller.isVisible &&
        yAxis != null &&
        yAxis!.anchorRangeToVisiblePoints &&
        plotArea != null &&
        plotArea.zoomPanBehavior != null &&
        plotArea.zoomPanBehavior!.zoomMode == ZoomMode.x) {
      final DoubleRange newYVisibleRange = _calculateYRange();
      if (_yVisibleRange != newYVisibleRange) {
        _yVisibleRange = newYVisibleRange;
        yAxis!.markNeedsRangeUpdate();
      }
    } else {
      _yVisibleRange = null;
    }
  }

  num _valueAsPow(num value) => (xAxis! as RenderLogarithmicAxis).toPow(value);

  DoubleRange _calculateYRange({List<List<num>>? yLists}) {
    num minimum = double.infinity;
    num maximum = double.negativeInfinity;
    if (canFindLinearVisibleIndexes) {
      if (visibleIndexes.isNotEmpty) {
        final int start = visibleIndexes[0];
        final int end = visibleIndexes[1];
        for (int i = start; i <= end; i++) {
          for (final List<num> list in yLists!) {
            final num value = list[i];
            if (!value.isNaN) {
              minimum = min(minimum, value);
              maximum = max(maximum, value);
            }
          }
        }
      }
    } else {
      for (final int index in visibleIndexes) {
        for (final List<num> list in yLists!) {
          final num value = list[index];
          if (!value.isNaN) {
            minimum = min(minimum, value);
            maximum = max(maximum, value);
          }
        }
      }
    }
    return DoubleRange(minimum, maximum);
  }

  ChartDataLabelAlignment effectiveDataLabelAlignment(
    ChartDataLabelAlignment alignment,
    ChartDataPointType position,
    ChartElementParentData? previous,
    ChartElementParentData current,
    ChartElementParentData? next,
  ) {
    if (alignment == ChartDataLabelAlignment.auto) {
      final bool isPrevEmpty = previous == null || previous.y!.isNaN;
      final bool isNextEmpty = next == null || next.y!.isNaN;
      if (isPrevEmpty && isNextEmpty) {
        return ChartDataLabelAlignment.top;
      } else if (isPrevEmpty) {
        return current.y! < next!.y!
            ? ChartDataLabelAlignment.bottom
            : ChartDataLabelAlignment.top;
      } else if (isNextEmpty) {
        return current.y! < previous.y!
            ? ChartDataLabelAlignment.bottom
            : ChartDataLabelAlignment.top;
      } else {
        final num slope = (next.y! - previous.y!) / 2;
        final num intersectY =
            (slope * index) + (next.y! - (slope * (index + 1)));
        return current.y! < intersectY
            ? ChartDataLabelAlignment.bottom
            : ChartDataLabelAlignment.top;
      }
    } else {
      return alignment;
    }
  }

  Color dataLabelSurfaceColor(CartesianChartDataLabelPositioned label) {
    final SfChartThemeData chartThemeData = parent!.chartThemeData!;
    final ThemeData themeData = parent!.themeData!;
    if (chartThemeData.plotAreaBackgroundColor != Colors.transparent) {
      return chartThemeData.plotAreaBackgroundColor!;
    } else if (chartThemeData.backgroundColor != Colors.transparent) {
      return chartThemeData.backgroundColor!;
    }
    return themeData.colorScheme.surface;
  }

  // This method applicable for below mentioned series.
  //  - Line series,
  //  - StepLine series,
  //  - Spline series,
  //  - StackedLine series,
  //  - StackedLine100 series,
  //  - FastLine series,
  //  - Area series,
  //  - StepArea series,
  //  - StackedArea series,
  //  - StackedArea100 series,
  //  - SplineArea series,
  //  - SplineRangeArea series,
  //  - RangeArea series
  //  - Hilo series,
  //  - Scatter series.
  Offset dataLabelPosition(
    ChartElementParentData current,
    ChartDataLabelAlignment alignment,
    Size size,
  ) {
    double markerHeightWithPadding = dataLabelPadding;
    double markerWidthWithPadding = dataLabelPadding;
    if (markerSettings.isVisible) {
      final ChartMarker marker = markerAt(current.dataPointIndex);
      markerHeightWithPadding += marker.height / 2;
      markerWidthWithPadding += marker.width / 2;
    }

    final EdgeInsets margin = dataLabelSettings.margin;
    double translationX = 0.0;
    double translationY = 0.0;
    switch (alignment) {
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
        if (isTransposed) {
          translationX = markerWidthWithPadding;
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY =
              -(markerHeightWithPadding + size.height + margin.vertical);
        }
        return translateTransform(
            current.x!, current.y!, translationX, translationY);

      case ChartDataLabelAlignment.bottom:
        if (isTransposed) {
          translationX =
              -(markerWidthWithPadding + size.width + margin.horizontal);
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = markerHeightWithPadding;
        }
        return translateTransform(
            current.x!, current.y!, translationX, translationY);

      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.middle:
        if (isTransposed) {
          translationX = -margin.left - size.width / 2;
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = -margin.top - size.height / 2;
        }
        return translateTransform(
            current.x!, current.y!, translationX, translationY);
    }
  }

  @override
  ChartSegment? visibleSegmentAt(Offset position) {
    if (segments.isEmpty) {
      return null;
    }

    final int segmentsCount = segments.length;
    if (canFindLinearVisibleIndexes) {
      if (visibleIndexes.isNotEmpty) {
        final int start = visibleIndexes[0];
        final int end = visibleIndexes[1];
        for (int i = start; i <= end; i++) {
          if (i < segmentsCount) {
            final ChartSegment segment = segments[i];
            if (segment.contains(position)) {
              return segment;
            }
          }
        }
      }
    } else {
      for (final int index in visibleIndexes) {
        if (index < segmentsCount) {
          final ChartSegment segment = segments[index];
          if (segment.contains(position)) {
            return segment;
          }
        }
      }
    }

    return null;
  }

  @override
  int viewportIndex(int index, [List<int>? visibleIndexes]) {
    return super.viewportIndex(index, visibleIndexes ?? this.visibleIndexes);
  }

  List<ChartSegment> contains(Offset position) {
    if (animationController != null && animationController!.isAnimating) {
      return <ChartSegment>[];
    }
    return <ChartSegment>[];
  }

  @nonVirtual
  double pointToPixelX(num x, num y) {
    return isTransposed
        ? yAxis!.pointToPixel(y, range: yAxis!.effectiveVisibleRange)
        : xAxis!.pointToPixel(x, range: xAxis!.effectiveVisibleRange);
  }

  @nonVirtual
  double pointToPixelY(num x, num y) {
    return isTransposed
        ? xAxis!.pointToPixel(x, range: xAxis!.effectiveVisibleRange)
        : yAxis!.pointToPixel(y, range: yAxis!.effectiveVisibleRange);
  }

  @override
  void performUpdate() {
    trendlineContainer?.performUpdate(this);
    super.performUpdate();
    _findVisibleIndexes();
  }

  @override
  void performLayout() {
    super.performLayout();
    trendlineContainer?.layout(constraints);
  }

  @override
  void transformValues() {
    if (xAxis == null ||
        yAxis == null ||
        segments.isEmpty ||
        xAxis!.visibleRange == null ||
        yAxis!.visibleRange == null) {
      return;
    }

    final int segmentsCount = segments.length;
    if (canFindLinearVisibleIndexes) {
      if (visibleIndexes.isNotEmpty) {
        final int start = visibleIndexes[0];
        final int end = visibleIndexes[1];
        for (int i = start; i <= end; i++) {
          if (i < segmentsCount) {
            final ChartSegment segment = segments[i];
            segment.animationFactor = segmentAnimationFactor;
            segment.transformValues();
            customizeSegment(segment);
          }
        }
      }
    } else {
      for (final int index in visibleIndexes) {
        if (index < segmentsCount) {
          final ChartSegment segment = segments[index];
          segment.animationFactor = segmentAnimationFactor;
          segment.transformValues();
          customizeSegment(segment);
        }
      }
    }
  }

  @nonVirtual
  void updateSegmentGradient(
    ChartSegment segment, {
    Rect? gradientBounds,
    LinearGradient? gradient,
    LinearGradient? borderGradient,
  }) {
    segment.fillPaint.shader = null;
    segment.strokePaint.shader = null;

    if (!segment.isEmpty) {
      if (onCreateShader != null) {
        final ShaderDetails details = ShaderDetails(paintBounds, 'series');
        segment.fillPaint.shader = onCreateShader!(details);
        segment.strokePaint.shader = onCreateShader!(details);
      } else if (gradient != null && gradientBounds != null) {
        segment.fillPaint.shader = gradient.createShader(gradientBounds);
      }

      if (borderGradient != null && gradientBounds != null) {
        // Border gradient is not working when border color is transparent.
        // Hence sets series color to border color.
        if (segment.strokePaint.color == Colors.transparent) {
          segment.strokePaint.color = segment.fillPaint.color;
        }

        segment.strokePaint.shader = borderGradient.createShader(
            gradientBounds.deflate(segment.strokePaint.strokeWidth / 2));
      }
    }
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    paintSegments(context, offset);
    paintMarkers(context, offset);
    paintDataLabels(context, offset);
    paintTrendline(context, offset);
  }

  @override
  void paintSegments(PaintingContext context, Offset offset) {
    if (parent != null && parent!.render != SeriesRender.normal) {
      return;
    }
    if (segments.isNotEmpty) {
      context.canvas.save();
      context.canvas.clipRect(paintBounds);
      if (canFindLinearVisibleIndexes) {
        if (visibleIndexes.isNotEmpty) {
          final int start = visibleIndexes[0];
          final int end = visibleIndexes[1];
          final int segmentsCount = segments.length;
          for (int i = start; i <= end && i > -1; i++) {
            if (i < segmentsCount) {
              final ChartSegment segment = segments[i];
              segment.animationFactor = segmentAnimationFactor;
              segment.onPaint(context.canvas);
            }
          }
        }
      } else {
        for (final int index in visibleIndexes) {
          final ChartSegment segment = segments[index];
          segment.animationFactor = segmentAnimationFactor;
          segment.onPaint(context.canvas);
        }
      }
      context.canvas.restore();
    }
  }

  void paintTrendline(PaintingContext context, Offset offset) {
    if (trendlineContainer != null &&
        parent != null &&
        parent!.render == SeriesRender.trendline) {
      context.canvas.save();
      context.canvas.clipRect(clipRect(paintBounds, animationFactor,
          isInversed: xAxis!.isInversed, isTransposed: isTransposed));
      context.paintChild(trendlineContainer!, offset);
      context.canvas.restore();
    }
  }

  @protected
  void paintMarkers(PaintingContext context, Offset offset) {
    if (markerContainer != null &&
        parent != null &&
        parent!.render == SeriesRender.normal) {
      context.paintChild(markerContainer!, offset);
    }
  }

  @protected
  void paintDataLabels(PaintingContext context, Offset offset) {
    if (dataLabelContainer != null &&
        parent != null &&
        parent!.render == SeriesRender.dataLabel) {
      context.paintChild(dataLabelContainer!, offset);
    }
  }

  void drawDataMarker(
    int index,
    Canvas canvas,
    Paint fillPaint,
    Paint strokePaint,
    Offset point,
    Size size,
    DataMarkerType type, [
    CartesianSeriesRenderer<T, D>? seriesRenderer,
  ]) {
    if (point.isNaN) {
      return;
    }

    if (type == DataMarkerType.image) {
      if (_markerImage != null) {
        paintImage(canvas: canvas, rect: point & size, image: _markerImage!);
      }
    } else if (type != DataMarkerType.none) {
      paint(
        canvas: canvas,
        rect: point & size,
        shapeType: toShapeMarkerType(type),
        paint: fillPaint,
        borderPaint: strokePaint,
      );
    }
  }

  void drawDataLabelWithBackground(
    int index,
    Canvas canvas,
    String dataLabel,
    Offset offset,
    int angle,
    TextStyle style,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final EdgeInsets margin = dataLabelSettings.margin;
    final Offset settingsOffset = dataLabelSettings.offset;
    if (!dataLabelSettings.showZeroValue && dataLabel == '0') {
      return;
    }
    if (!offset.dx.isNaN && !offset.dy.isNaN) {
      if (dataLabel.isNotEmpty) {
        // TODO(VijayakumarM): Check and optimize.
        if (fillPaint.color != Colors.transparent ||
            (strokePaint.color != const Color.fromARGB(0, 25, 5, 5) &&
                strokePaint.strokeWidth > 0)) {
          final TextPainter textPainter = TextPainter(
            text: TextSpan(text: dataLabel, style: style),
            textDirection: TextDirection.ltr,
          )..layout();
          final RRect labelRect = RRect.fromRectAndRadius(
              Rect.fromLTWH(
                offset.dx + settingsOffset.dx,
                offset.dy - settingsOffset.dy,
                textPainter.width + margin.horizontal,
                textPainter.height + margin.vertical,
              ),
              Radius.circular(dataLabelSettings.borderRadius));
          canvas.save();
          canvas.translate(labelRect.center.dx, labelRect.center.dy);
          canvas.rotate((angle * pi) / 180);
          canvas.translate(-labelRect.center.dx, -labelRect.center.dy);
          if (strokePaint.color != Colors.transparent &&
              strokePaint.strokeWidth > 0) {
            canvas.drawRRect(labelRect, strokePaint);
          }

          if (fillPaint.color != Colors.transparent) {
            canvas.drawRRect(labelRect, fillPaint);
          }
          canvas.restore();
        }
      }
    }
    drawDataLabel(
        index,
        canvas,
        dataLabel,
        offset.dx + settingsOffset.dx + margin.left,
        offset.dy - settingsOffset.dy + margin.top,
        angle,
        style);
  }

  /// To customize each data labels.
  void drawDataLabel(
    int index,
    Canvas canvas,
    String dataLabel,
    double pointX,
    double pointY,
    int angle,
    TextStyle style,
  ) {
    if (!pointX.isNaN && !pointY.isNaN) {
      final TextSpan span = TextSpan(text: dataLabel, style: style);
      final TextPainter textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      canvas.save();
      canvas.translate(
          pointX + textPainter.width / 2, pointY + textPainter.height / 2);
      canvas.rotate(degreeToRadian(angle));
      final Offset labelOffset =
          Offset(-textPainter.width / 2, -textPainter.height / 2);
      textPainter.paint(canvas, labelOffset);
      canvas.restore();
    }
  }

  @override
  void dispose() {
    _chaoticXValues.clear();
    xValues.clear();
    controller._dispose();
    super.dispose();
  }
}

mixin ContinuousSeriesMixin<T, D> on CartesianSeriesRenderer<T, D> {
  @override
  void createOrUpdateSegments() {
    if (dataCount == 0) {
      segments.clear();
      return;
    }

    final int segmentsCount = segments.length;
    if (segmentsCount == 0) {
      final ChartSegment segment = createSegment();
      setData(0, segment);
      segments.add(segment);
    } else {
      final ChartSegment segment = segments[0];
      setData(0, segment);
    }
  }

  @override
  void transformValues() {
    if (xAxis == null ||
        yAxis == null ||
        segments.isEmpty ||
        xAxis!.visibleRange == null ||
        yAxis!.visibleRange == null) {
      return;
    }

    final ChartSegment segment = segments[0];
    segment.animationFactor = segmentAnimationFactor;
    segment.transformValues();
    customizeSegment(segment);
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    paintSegments(context, offset);
    paintMarkers(context, offset);
    paintDataLabels(context, offset);
    paintTrendline(context, offset);
  }

  @override
  void paintSegments(PaintingContext context, Offset offset) {
    if (parent != null && parent!.render != SeriesRender.normal) {
      return;
    }

    if (segments.isNotEmpty) {
      context.canvas.save();
      context.canvas.clipRect(paintBounds);
      final ChartSegment segment = segments[0];
      segment.animationFactor = segmentAnimationFactor;
      segment.onPaint(context.canvas);
      context.canvas.restore();
    }
  }

  @override
  TooltipInfo? tooltipInfoFromPointIndex(int pointIndex) {
    if (segments.isNotEmpty && pointIndex < dataCount) {
      return segments[0].tooltipInfo(pointIndex: pointIndex);
    }
    return null;
  }

  @override
  int dataPointIndex(Offset position, ChartSegment segment) {
    final int segPointIndex = segmentPointIndex(position, segment);
    if (segPointIndex != -1) {
      return _dataPointIndex(segPointIndex);
    }
    return segPointIndex;
  }

  int _dataPointIndex(int pointIndex) {
    if (_xNullPointIndexes.isNotEmpty) {
      for (final int xNullPointIndex in _xNullPointIndexes) {
        if (pointIndex >= xNullPointIndex) {
          pointIndex++;
        }
      }
    }
    return pointIndex;
  }

  @override
  int segmentPointIndex(Offset position, ChartSegment segment) {
    final int length = segment.points.length;
    for (int i = 0; i < length; i++) {
      final Rect bounds = Rect.fromCenter(
          center: segment.points[i],
          width: tooltipPadding,
          height: tooltipPadding);
      if (bounds.contains(position)) {
        return i;
      }
    }
    return -1;
  }

  @override
  ChartSegment segmentAt(int segmentPointIndex) {
    return segments[0];
  }

  @override
  ChartSegment? visibleSegmentAt(Offset position) {
    if (segments.isEmpty) {
      return null;
    }

    final ChartSegment segment = segments[0];
    if (segment.contains(position)) {
      return segment;
    }

    return null;
  }
}

mixin RealTimeUpdateMixin<T, D> on ChartSeriesRenderer<T, D> {
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (!_canPopulateDataPoints(yPaths, chaoticYLists)) {
      return;
    }

    if (fPaths == null) {
      fPaths = <ChartValueMapper<T, Object>>[];
      chaoticFLists = <List<Object?>>[];
      fLists = <List<Object?>>[];
    }
    _addPointColorMapper(fPaths, chaoticFLists, fLists);
    _addSortValueMapper(fPaths, chaoticFLists, fLists);

    if (removedIndexes != null) {
      _removeDataPoints(removedIndexes, yPaths, chaoticYLists, yLists, fPaths,
          chaoticFLists, fLists);
    }

    if (addedIndexes != null) {
      _addDataPoints(addedIndexes, yPaths, chaoticYLists, yLists, fPaths,
          chaoticFLists, fLists);
    }

    if (replacedIndexes != null) {
      _replaceDataPoints(replacedIndexes, yPaths, chaoticYLists, yLists, fPaths,
          chaoticFLists, fLists);
    }

    createOrUpdateSegments();
    markNeedsLegendUpdate();
    markNeedsLayout();
  }

  void _removeDataPoints(
    List<int> indexes,
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ) {
    final int chaoticYLength = chaoticYLists?.length ?? 0;
    final int fPathLength = fPaths?.length ?? 0;
    for (final int index in indexes) {
      _removeXValueAt(index);
      _removeRawSortValueAt(index);
      for (int i = 0; i < chaoticYLength; i++) {
        if (index < chaoticYLists![i].length) {
          chaoticYLists[i].removeAt(index);
        }
      }

      for (int k = 0; k < fPathLength; k++) {
        chaoticFLists![k].removeAt(index);
      }

      if (emptyPointIndexes.contains(index)) {
        emptyPointIndexes.remove(index);
      }
    }

    _dataCount = _chaoticXValues.length;
    // Collecting previous and next index to update them.
    final List<int> mutableIndexes = _findMutableIndexes(indexes);
    _replaceDataPoints(mutableIndexes, yPaths, chaoticYLists, yLists, fPaths,
        chaoticFLists, fLists);
  }

  void _addDataPoints(
    List<int> indexes,
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ) {
    final int yPathLength = yPaths!.length;
    final int fPathLength = fPaths?.length ?? 0;

    for (final int index in indexes) {
      final T current = dataSource![index];
      final D? rawX = xValueMapper!(current, index);
      if (rawX == null) {
        _xNullPointIndexes.add(index);
        continue;
      }

      for (int i = 0; i < yPathLength; i++) {
        final num? yValue = yPaths[i]!(current, i);
        if (yValue == null || yValue.isNaN) {
          chaoticYLists![i].insert(index, double.nan);
          if (!emptyPointIndexes.contains(index)) {
            emptyPointIndexes.add(index);
          }
        } else {
          index > chaoticYLists![i].length - 1
              ? chaoticYLists[i].add(yValue)
              : chaoticYLists[i].insert(index, yValue);
          index > xValues.length - 1
              ? _chaoticXValues.add(index)
              : _chaoticXValues.insert(index, xValues[index]);
          index > xRawValues.length - 1
              ? _chaoticRawXValues.add(rawX)
              : _chaoticRawXValues.insert(index, rawX);

          if (sortFieldValueMapper == null &&
              sortingOrder != SortingOrder.none) {
            index > _chaoticRawSortValues.length - 1
                ? _chaoticRawSortValues.add(rawX)
                : _chaoticRawSortValues.insert(index, rawX);
          }
        }
      }

      for (int j = 0; j < fPathLength; j++) {
        final Object? fValue = fPaths![j](current, j);
        chaoticFLists![j].insert(index, fValue);
      }
    }

    _dataCount = _chaoticXValues.length;
    _applyEmptyPointModeIfNeeded(chaoticYLists!);
    _doSortingIfNeeded(chaoticYLists, yLists, chaoticFLists, fLists);
  }

  void _replaceDataPoints(
    List<int> indexes,
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ) {
    final int yPathLength = yPaths?.length ?? 0;
    final int fPathLength = fPaths?.length ?? 0;

    for (final int index in indexes) {
      if (index < dataSource!.length - 1) {
        final T current = dataSource![index];
        final D? rawX = xValueMapper!(current, index);
        if (_xNullPointIndexes.contains(index)) {
          _xNullPointIndexes.remove(index);
        }

        if (rawX == null) {
          _xNullPointIndexes.add(index);
          continue;
        }

        for (int i = 0; i < yPathLength; i++) {
          final num? yValue = yPaths![i]!(current, i);
          if (yValue == null || yValue.isNaN) {
            chaoticYLists![i][index] = double.nan;
            if (!emptyPointIndexes.contains(index)) {
              emptyPointIndexes.add(index);
            }
          } else {
            if (index < chaoticYLists![i].length) {
              chaoticYLists[i][index] = yValue;
              _chaoticXValues[index] = xValues[index];
              _chaoticRawXValues[index] = rawX;

              if (sortFieldValueMapper == null &&
                  sortingOrder != SortingOrder.none) {
                _chaoticRawSortValues[index] = rawX;
              }
            }
            if (emptyPointIndexes.contains(index)) {
              emptyPointIndexes.remove(index);
            }
          }
        }

        for (int j = 0; j < fPathLength; j++) {
          chaoticFLists![j][index] = fPaths![j](current, j);
        }
      }
    }

    _applyEmptyPointModeIfNeeded(chaoticYLists!);
    _doSortingIfNeeded(chaoticYLists, yLists, chaoticFLists, fLists);
  }

  void _removeXValueAt(int index) {
    _chaoticRawXValues.removeAt(index);
    if (xRawValues.length > index) {
      xRawValues.removeAt(index);
    }
    if (xValues.length > index) {
      _chaoticXValues.removeAt(index);
    }
  }

  void _removeRawSortValueAt(int index) {
    if (sortFieldValueMapper == null &&
        sortingOrder != SortingOrder.none &&
        _chaoticRawSortValues.isNotEmpty) {
      _chaoticRawSortValues.removeAt(index);
    }
  }

  List<int> _findMutableIndexes(List<int> indexes) {
    final List<int> mutableIndexes = <int>[];
    for (final int index in indexes) {
      final int previousIndex = index - 1;
      final int nextIndex = index + 1;
      if (previousIndex >= 0 && !indexes.contains(previousIndex)) {
        mutableIndexes.add(previousIndex);
      }
      mutableIndexes.add(index);
      if (nextIndex < dataCount && !indexes.contains(nextIndex)) {
        mutableIndexes.add(nextIndex);
      }
    }
    return mutableIndexes;
  }
}

mixin CartesianRealTimeUpdateMixin<T, D> on CartesianSeriesRenderer<T, D> {
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    // Here fPath is widget specific feature path.
    // For example, in bubble series's bubbleSizeMapper is a feature path.
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (xValueMapper == null ||
        yPaths == null ||
        yPaths.isEmpty ||
        chaoticYLists == null ||
        chaoticYLists.isEmpty) {
      return;
    }

    if (fPaths == null) {
      fPaths = <ChartValueMapper<T, Object>>[];
      chaoticFLists = <List<Object?>>[];
      fLists = <List<Object?>>[];
    }
    _addPointColorMapper(fPaths, chaoticFLists, fLists);
    _addSortValueMapper(fPaths, chaoticFLists, fLists);

    if (removedIndexes != null) {
      _removeDataPoints(removedIndexes, yPaths, chaoticYLists, yLists, fPaths,
          chaoticFLists, fLists);
    }

    if (addedIndexes != null) {
      _addDataPoints(addedIndexes, yPaths, chaoticYLists, yLists, fPaths,
          chaoticFLists, fLists);
    }

    if (replacedIndexes != null) {
      _replaceDataPoints(replacedIndexes, yPaths, chaoticYLists, yLists, fPaths,
          chaoticFLists, fLists);
    }

    _applyEmptyPointModeIfNeeded(chaoticYLists);
    _doSortingIfNeeded(chaoticYLists, yLists, chaoticFLists, fLists);
    final DoubleRange xRange = _findMinMaxXRange(xValues);
    final DoubleRange yRange = _findMinMaxYRange(chaoticYLists);
    _updateAxisRange(
        xRange.minimum, xRange.maximum, yRange.minimum, yRange.maximum);
    computeNonEmptyYValues();
    _populateTrendlineDataSource();
    _updateXValuesForCategoryTypeAxes();

    canUpdateOrCreateSegments = true;
    markNeedsLayout();
  }

  void _removeDataPoints(
    List<int> indexes,
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ) {
    // Removing a data point can cause the following:
    //  - Data points sorting will not be affected.
    //  - The minimum and maximum range will be affected.
    //  - Visible indexes may be affected.
    //  - Segment's index will be affected.
    //  - The bull segment of the candle series will be affected.
    //  - An existing null point may be removed.
    //  - The calculation of empty point averages will be affected.
    //  - Trendlines and indicators that rely on series data points
    //    will be affected.
    //  - The corresponding data label and marker will need to be removed.
    //  - The auto position of data labels will be affected for
    //    continuous series.
    final int chaoticYLength = chaoticYLists?.length ?? 0;
    final int fPathLength = fPaths?.length ?? 0;
    for (final int index in indexes) {
      if (index < 0 || index >= _dataCount) {
        continue;
      }

      _removeXValueAt(index);
      _removeRawSortValueAt(index);
      for (int i = 0; i < chaoticYLength; i++) {
        chaoticYLists![i].removeAt(index);
      }

      for (int k = 0; k < fPathLength; k++) {
        chaoticFLists![k].removeAt(index);
      }

      if (emptyPointIndexes.contains(index)) {
        emptyPointIndexes.remove(index);
      }
    }

    _dataCount = _chaoticXValues.length;
    // Collecting previous and next index to update them.
    final List<int> mutableIndexes = _findMutableIndexes(indexes);
    _replaceDataPoints(mutableIndexes, yPaths, chaoticYLists, yLists, fPaths,
        chaoticFLists, fLists);
  }

  void _addDataPoints(
    List<int> indexes,
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ) {
    // Updating a data point can cause the following:
    //  - Data points sorting will be affected.
    //  - The minimum and maximum range will be affected.
    //  - Visible indexes will be affected.
    //  - Segment's index will be affected.
    //  - The bull segment of the candle series will be affected.
    //  - A new null point may be added.
    //  - The calculation of empty point averages will be affected.
    //  - Trendlines and indicators that rely on series data points
    //    will be affected.
    //  - The corresponding data label and marker needs to be added.
    //  - The auto position of data labels will be affected for
    //    continuous series.
    final int yPathLength = yPaths!.length;
    final int fPathLength = fPaths?.length ?? 0;
    final Function(int, D) preferredXValue = _preferredXValue();
    final Function(int, D?, num) insertXValue =
        _insertXValueIntoRawAndChaoticXLists;
    final Function(int, D?) insertRawSortValue =
        _insertRawXValueIntoChaoticRawSortValue;

    num xMinimum = double.infinity;
    num xMaximum = double.negativeInfinity;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;

    for (final int index in indexes) {
      if (index < 0 || index >= dataSource!.length) {
        continue;
      }
      final T current = dataSource![index];
      final D? rawX = xValueMapper!(current, index);
      if (rawX == null) {
        _xNullPointIndexes.add(index);
        continue;
      }

      final num currentX = preferredXValue(index, rawX);
      insertXValue(index, rawX, currentX);
      insertRawSortValue(index, rawX);
      xMinimum = min(xMinimum, currentX);
      xMaximum = max(xMaximum, currentX);
      if (_hasLinearDataSource) {
        _hasLinearDataSource = isValueLinear(index, currentX, _chaoticXValues);
      }

      for (int i = 0; i < yPathLength; i++) {
        final num? yValue = yPaths[i]!(current, i);
        if (yValue == null || yValue.isNaN) {
          chaoticYLists![i].insert(index, double.nan);
          if (!emptyPointIndexes.contains(index)) {
            emptyPointIndexes.add(index);
          }
        } else {
          chaoticYLists![i].insert(index, yValue);
          yMinimum = min(yMinimum, yValue);
          yMaximum = max(yMaximum, yValue);
        }
      }

      for (int j = 0; j < fPathLength; j++) {
        final Object? fValue = fPaths![j](current, index);
        chaoticFLists![j].insert(index, fValue);
      }
    }

    _dataCount = _chaoticXValues.length;
    _canFindLinearVisibleIndexes = _hasLinearDataSource;
  }

  void _updateAxisRange(
      num xMinimum, num xMaximum, num yMinimum, num yMaximum) {
    if ((xMin.isInfinite && xMinimum.isFinite) || xMinimum != xMin) {
      xMin = xMinimum;
      _isXRangeChanged = true;
    }

    if ((xMax.isInfinite && xMaximum.isFinite) || xMaximum != xMax) {
      xMax = xMaximum;
      _isXRangeChanged = true;
    }

    // When adding data points between the default range, axis range won't
    // change. So, visible indexes remains empty.
    if (!_isXRangeChanged) {
      _findVisibleIndexes();
    } else {
      xAxis?.markNeedsLayout();
    }

    if ((yMin.isInfinite && yMinimum.isFinite) || yMinimum != yMin) {
      yMin = yMinimum;
      _isYRangeChanged = true;
      yAxis?.markNeedsLayout();
    }

    if ((yMax.isInfinite && yMaximum.isFinite) || yMaximum != yMax) {
      yMax = yMaximum;
      _isYRangeChanged = true;
      yAxis?.markNeedsLayout();
    }

    markNeedsLayout();
  }

  void _replaceDataPoints(
    List<int> indexes,
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ) {
    // Updating a data point can cause the following:
    //  - Data points sorting will be affected.
    //  - The minimum and maximum range will be affected.
    //  - Visible indexes will not be affected.
    //  - Segment's index will not be affected.
    //  - The bull segment of the candle series will be affected.
    //  - An existing null point may be removed or new null can be added.
    //  - The calculation of empty point averages will be affected.
    //  - Trendlines and indicators that rely on series data points
    //    will be affected.
    //  - The corresponding data label and marker will be affected.
    //  - The auto position of data labels will be affected for
    //    continuous series.
    final Function(int, D) preferredXValue = _preferredXValue();
    final Function(int, D?, num) replaceXValue =
        _updateXValueIntoRawAndChaoticXLists;
    final Function(int, D?) replaceRawSortValue =
        _updateRawXValueIntoChaoticRawSortValue;

    final int yPathLength = yPaths?.length ?? 0;
    final int fPathLength = fPaths?.length ?? 0;

    for (final int index in indexes) {
      if (index < 0 || index >= dataSource!.length) {
        continue;
      }
      final T current = dataSource![index];
      final D? rawX = xValueMapper!(current, index);
      if (_xNullPointIndexes.contains(index)) {
        _xNullPointIndexes.remove(index);
      }

      if (rawX == null) {
        _xNullPointIndexes.add(index);
        continue;
      }

      final num currentX = preferredXValue(index, rawX);
      replaceXValue(index, rawX, currentX);
      replaceRawSortValue(index, rawX);
      for (int i = 0; i < yPathLength; i++) {
        final num? yValue = yPaths![i]!(current, i);
        if (yValue == null || yValue.isNaN) {
          chaoticYLists![i][index] = double.nan;
          if (!emptyPointIndexes.contains(index)) {
            emptyPointIndexes.add(index);
          }
        } else {
          chaoticYLists![i][index] = yValue;
          if (emptyPointIndexes.contains(index)) {
            emptyPointIndexes.remove(index);
          }
        }
      }

      for (int j = 0; j < fPathLength; j++) {
        chaoticFLists![j][index] = fPaths![j](current, index);
      }
    }
  }

  DoubleRange _findMinMaxXRange(List<num> values) {
    num min = double.infinity;
    num max = double.negativeInfinity;
    for (final num value in values) {
      if (value < min) {
        min = value;
      }
      if (value > max) {
        max = value;
      }
    }

    return DoubleRange(min, max);
  }

  DoubleRange _findMinMaxYRange(List<List<num>> yLists) {
    num min = double.infinity;
    num max = double.negativeInfinity;
    for (final List<num> values in yLists) {
      for (final num value in values) {
        if (value < min) {
          min = value;
        }
        if (value > max) {
          max = value;
        }
      }
    }

    return DoubleRange(min, max);
  }

  void _removeXValueAt(int index) {
    _chaoticRawXValues.removeAt(index);
    if (xRawValues.length > index) {
      xRawValues.removeAt(index);
    }

    _chaoticXValues.removeAt(index);
    // TODO(VijayakumarM): Check with category axis.
    if (xValues.length > index) {
      xValues.removeAt(index);
    }
  }

  void _updateXValueIntoRawAndChaoticXLists(int index, D? raw, num preferred) {
    _chaoticRawXValues[index] = raw;
    _chaoticXValues[index] = preferred;
  }

  void _insertXValueIntoRawAndChaoticXLists(int index, D? raw, num preferred) {
    _chaoticRawXValues.insert(index, raw);
    _chaoticXValues.insert(index, preferred);
  }

  void _removeRawSortValueAt(int index) {
    if (sortFieldValueMapper == null &&
        sortingOrder != SortingOrder.none &&
        _chaoticRawSortValues.isNotEmpty) {
      _chaoticRawSortValues.removeAt(index);
    }
  }

  void _updateRawXValueIntoChaoticRawSortValue(int index, D? raw) {
    if (sortFieldValueMapper == null &&
        sortingOrder != SortingOrder.none &&
        _chaoticRawSortValues.isNotEmpty) {
      _chaoticRawSortValues[index] = raw;
    }
  }

  void _insertRawXValueIntoChaoticRawSortValue(int index, D? raw) {
    if (sortFieldValueMapper == null &&
        sortingOrder != SortingOrder.none &&
        _chaoticRawSortValues.isNotEmpty) {
      _chaoticRawSortValues.insert(index, raw);
    }
  }

  List<int> _findMutableIndexes(List<int> indexes) {
    final List<int> mutableIndexes = <int>[];
    for (final int index in indexes) {
      final int previousIndex = index - 1;
      final int nextIndex = index + 1;
      if (previousIndex >= 0 && !indexes.contains(previousIndex)) {
        mutableIndexes.add(previousIndex);
      }
      mutableIndexes.add(index);
      if (nextIndex < dataCount && !indexes.contains(nextIndex)) {
        mutableIndexes.add(nextIndex);
      }
    }

    return mutableIndexes;
  }
}

/// Represents the side by side series.
mixin SbsSeriesMixin<T, D> on CartesianSeriesRenderer<T, D> {
  double get spacing => _spacing;
  double _spacing = 0;
  set spacing(double value) {
    assert(value >= 0 && value <= 1,
        'The spacing of the series should be between 0 and 1');
    if (value != _spacing) {
      _spacing = value;
    }
  }

  double get width => _width;
  double _width = 0.7;
  set width(double value) {
    assert(value >= 0 && value <= 1,
        'The width of the series should be between 0 and 1');
    if (value != _width) {
      _width = value;
    }
  }

  num get bottom => _bottom;
  num _bottom = 0;

  DoubleRange get sbsInfo => _sbsInfo;
  DoubleRange _sbsInfo = DoubleRange.zero();
  set sbsInfo(DoubleRange value) {
    if (_sbsInfo != value) {
      _sbsInfo = value;
      canUpdateOrCreateSegments = true;
      markNeedsLayout();
    }
  }

  num primaryAxisAdjacentDataPointsMinDiff = 1;

  late List<num?> _sortedXValues;

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);

    if (dataCount < 1) {
      return;
    }

    _calculateSbsInfo();

    if (this is! WaterfallSeriesRenderer) {
      populateChartPoints();
    }
  }

  void _calculateSbsInfo() {
    if (canFindLinearVisibleIndexes) {
      _sortedXValues = xValues;
    } else {
      final List<num?> xValuesCopy = <num?>[...xValues];
      xValuesCopy.sort();
      _sortedXValues = xValuesCopy;
    }

    num minDelta = double.infinity;
    final int length = _sortedXValues.length;
    if (length == 1) {
      DateTime? minDate;
      num? minimumInSeconds;
      if (xAxis is RenderDateTimeAxis) {
        minDate = DateTime.fromMillisecondsSinceEpoch(_sortedXValues[0] as int);
        minDate = minDate.subtract(const Duration(days: 1));
        minimumInSeconds = minDate.millisecondsSinceEpoch;
      }
      final num seriesMin =
          (xAxis is RenderDateTimeAxis && xRange.minimum == xRange.maximum)
              ? minimumInSeconds!
              : xRange.minimum;
      final num minVal = xValues[0] - seriesMin;
      if (minVal != 0) {
        minDelta = min(minDelta, minVal);
      }
    } else {
      for (int i = 0; i < length - 1; i++) {
        final num? current = _sortedXValues[i];
        final num? next = _sortedXValues[i + 1];
        if (current == null || next == null) {
          continue;
        }

        final num delta = (next - current).abs();
        minDelta = min(delta == 0 ? minDelta : delta, minDelta);
      }
    }

    primaryAxisAdjacentDataPointsMinDiff = minDelta.isInfinite ? 1 : minDelta;
  }

  DoubleRange _sbsRange(RenderChartAxis axis) {
    if (axis == xAxis) {
      if (axis is RenderCategoryAxis || axis is RenderDateTimeCategoryAxis) {
        return xRange;
      }

      final double diff = primaryAxisAdjacentDataPointsMinDiff / 2;
      return xRange.copyWith(
        minimum: xRange.minimum - diff,
        maximum: xRange.maximum + diff,
      );
    } else {
      return super.range(axis);
    }
  }

  @override
  DoubleRange range(RenderChartAxis axis) {
    final RenderCartesianChartPlotArea? plotArea = parent;
    if (axis == yAxis &&
        axis.anchorRangeToVisiblePoints &&
        plotArea != null &&
        plotArea.zoomPanBehavior != null &&
        plotArea.zoomPanBehavior!.zoomMode == ZoomMode.x &&
        _yVisibleRange != null) {
      return _yVisibleRange!.copyWith();
    }

    final DoubleRange actualRange = _sbsRange(axis).copyWith();
    if (trendlineContainer == null) {
      return actualRange;
    }

    return _trendlineRange(actualRange, axis);
  }

  @nonVirtual
  void updateSegmentTrackerStyle(ChartSegment segment, Color trackColor,
      Color trackBorderColor, double trackBorderWidth) {
    if (segment is BarSeriesTrackerMixin) {
      segment.trackerFillPaint.color = trackColor;
      segment.trackerStrokePaint
        ..color = trackBorderColor
        ..strokeWidth = trackBorderWidth;
    }
  }

  @override
  void performLayout() {
    num minYValue = max(yAxis!.visibleRange!.minimum, 0);
    if (yAxis! is RenderLogarithmicAxis) {
      minYValue = (yAxis! as RenderLogarithmicAxis).toPow(minYValue);
    }

    _bottom = xAxis!.crossesAt ?? minYValue;
    markerContainer?.sbsInfo = sbsInfo;
    super.performLayout();
  }

  @override
  ChartDataLabelAlignment effectiveDataLabelAlignment(
    ChartDataLabelAlignment alignment,
    ChartDataPointType position,
    ChartElementParentData? previous,
    ChartElementParentData current,
    ChartElementParentData? next,
  ) {
    return alignment == ChartDataLabelAlignment.auto
        ? this is StackedSeriesRenderer
            ? ChartDataLabelAlignment.top
            : ChartDataLabelAlignment.outer
        : alignment;
  }

  @override
  Color dataLabelSurfaceColor(CartesianChartDataLabelPositioned label) {
    final ChartDataLabelAlignment alignment = label.labelAlignment;
    final ChartSegment segment = segments[label.dataPointIndex];
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
        return super.dataLabelSurfaceColor(label);

      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.middle:
      case ChartDataLabelAlignment.bottom:
        return segment.getFillPaint().color;
    }
  }

  @override
  Offset dataLabelPosition(ChartElementParentData current,
      ChartDataLabelAlignment alignment, Size size) {
    final num x = current.x! + (sbsInfo.maximum + sbsInfo.minimum) / 2;
    num y = current.y!;
    switch (current.position) {
      case ChartDataPointType.y:
        if (alignment == ChartDataLabelAlignment.bottom) {
          y = _bottom;
        } else if (alignment == ChartDataLabelAlignment.middle) {
          y = (y + _bottom) / 2;
        }
        return _calculateYPosition(x, y, alignment, size);

      case ChartDataPointType.high:
        return _calculateHighPosition(x, y, alignment, size);

      case ChartDataPointType.low:
        return _calculateLowPosition(x, y, alignment, size);

      case ChartDataPointType.open:
        return _calculateDataLabelOpenPosition(x, y, alignment, size);

      case ChartDataPointType.close:
        return _calculateDataLabelClosePosition(x, y, alignment, size);

      case ChartDataPointType.median:
        return _calculateMedianPosition(x, y, alignment, size);

      case ChartDataPointType.outliers:
        return _calculateOutlierPosition(x, y, alignment, size);

      case ChartDataPointType.volume:
      case ChartDataPointType.mean:
      case ChartDataPointType.bubbleSize:
      case ChartDataPointType.cumulative:
        break;
    }

    return Offset.zero;
  }

  Offset _calculateYPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    final EdgeInsets margin = dataLabelSettings.margin;
    double translationX = 0.0;
    double translationY = 0.0;
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.bottom:
        if (isTransposed) {
          translationX = dataLabelPadding;
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = -(dataLabelPadding + size.height + margin.vertical);
        }
        return translateTransform(x, y, translationX, translationY);

      case ChartDataLabelAlignment.top:
        if (isTransposed) {
          translationX = -(dataLabelPadding + size.width + margin.horizontal);
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = dataLabelPadding;
        }
        return translateTransform(x, y, translationX, translationY);

      case ChartDataLabelAlignment.middle:
        final Offset center = translateTransform(x, y);
        if (isTransposed) {
          translationX = -margin.left - size.width / 2;
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = -margin.top - size.height / 2;
        }
        return center.translate(translationX, translationY);
    }
  }

  Offset _calculateHighPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.bottom:
      case ChartDataLabelAlignment.middle:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.outer, size);

      case ChartDataLabelAlignment.top:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.top, size);
    }
  }

  Offset _calculateLowPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.bottom:
      case ChartDataLabelAlignment.middle:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.top, size);

      case ChartDataLabelAlignment.top:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.bottom, size);
    }
  }

  Offset _calculateDataLabelOpenPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.middle:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.outer, size);

      case ChartDataLabelAlignment.bottom:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.top, size);
    }
  }

  Offset _calculateDataLabelClosePosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.middle:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.outer, size);

      case ChartDataLabelAlignment.bottom:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.top, size);
    }
  }

  Offset _calculateMedianPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.middle:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.top, size);

      case ChartDataLabelAlignment.bottom:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.bottom, size);
    }
  }

  Offset _calculateOutlierPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.middle:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.outer, size);

      case ChartDataLabelAlignment.bottom:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.top, size);
    }
  }
}

/// Represents the stacking series.
mixin StackingSeriesMixin on AxisDependent {
  String get groupName => _groupName;
  String _groupName = '';
  set groupName(String value) {
    if (_groupName != value) {
      _groupName = value;
    }
  }
}

/// Represents the column and bar type series for the tracker support.
mixin BarSeriesTrackerMixin on ChartSegment {
  /// Gets the color of the tracker.
  Paint getTrackerFillPaint() => trackerFillPaint;

  /// Gets the border color of the tracker.
  Paint getTrackerStrokePaint() => trackerStrokePaint;

  /// Fill paint of the tracker segment.
  final Paint trackerFillPaint = Paint()..isAntiAlias = true;

  /// Stroke paint of the tracker segment.
  final Paint trackerStrokePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke;

  RRect? _trackerRect;

  void calculateTrackerBounds(
    num x,
    num y,
    BorderRadius borderRadius,
    double trackPadding,
    double trackBorderWidth,
    CartesianSeriesRenderer series,
  ) {
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;
    final bool isTransposed = series.isTransposed;
    final bool isInversed = series.xAxis!.isInversed;
    final num minimum = series.yAxis!.visibleRange!.minimum;
    final num maximum = series.yAxis!.visibleRange!.maximum;
    final double trackerPadding = trackBorderWidth + trackPadding;

    final num trackTop = max(maximum, minimum);
    final num trackBottom = min(maximum, minimum);
    double left = transformX(x, trackTop);
    double top = transformY(x, trackTop);
    double right = transformX(y, trackBottom);
    double bottom = transformY(y, trackBottom);

    // TODO(Natrayansf): Avoid isTransposed case checking.
    // And, calculate the tracker bounds within the plot area bounds.
    if (!isTransposed) {
      if (!isInversed) {
        left -= trackerPadding;
        right += trackerPadding;
      } else {
        left += trackerPadding;
        right -= trackerPadding;
      }
    } else {
      if (!isInversed) {
        top += trackerPadding;
        bottom -= trackerPadding;
      } else {
        top -= trackerPadding;
        bottom += trackerPadding;
      }
    }

    _trackerRect = toRRect(left, top, right, bottom, borderRadius);
  }

  @override
  void onPaint(Canvas canvas) {
    if (_trackerRect != null && !_trackerRect!.isEmpty) {
      Paint paint = getTrackerFillPaint();
      if (paint.color != Colors.transparent) {
        canvas.drawRRect(_trackerRect!, paint);
      }

      paint = getTrackerStrokePaint();
      if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
        canvas.drawRRect(_trackerRect!.deflate(paint.strokeWidth / 2), paint);
      }
    }
  }

  @override
  void dispose() {
    _trackerRect = null;
    super.dispose();
  }
}

mixin SegmentAnimationMixin<T, D> on ChartSeriesRenderer<T, D> {
  @override
  void onLoadingAnimationUpdate() {
    _animationFactor = _animation!.value;
    segmentAnimationFactor = _animationFactor;
  }
}

mixin LineSeriesMixin<T, D> on CartesianSeriesRenderer<T, D> {
  @override
  void paintSegments(PaintingContext context, Offset offset) {
    if (parent != null && parent!.render != SeriesRender.normal) {
      return;
    }
    if (segments.isEmpty) {
      return;
    }

    if (canFindLinearVisibleIndexes) {
      if (visibleIndexes.isNotEmpty) {
        final int start = visibleIndexes[0];
        int end = visibleIndexes[1];
        final int segmentsCount = segments.length;
        // Internally added empty last segment for handling realtime data point
        // update as common. While rendering, ignored the last segment paint.
        final int lastIndex = segmentsCount - 1;
        if (end == lastIndex) {
          end = lastIndex - 1;
        }
        for (int i = start; i <= end && i > -1; i++) {
          if (i < segmentsCount) {
            final ChartSegment segment = segments[i];
            segment.animationFactor = segmentAnimationFactor;
            segment.onPaint(context.canvas);
          }
        }
      }
    } else {
      for (final int index in visibleIndexes) {
        final ChartSegment segment = segments[index];
        segment.animationFactor = segmentAnimationFactor;
        segment.onPaint(context.canvas);
      }
    }
  }
}

/// Renders the xy series.
///
/// Cartesian charts uses two axis namely x and y, to render.
abstract class XyDataSeries<T, D> extends CartesianSeries<T, D> {
  /// Creating an argument constructor of XyDataSeries class.
  const XyDataSeries({
    super.key,
    this.yValueMapper,
    super.onCreateRenderer,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    super.xValueMapper,
    super.dataLabelMapper,
    super.name,
    super.dataSource,
    super.xAxisName,
    super.yAxisName,
    super.pointColorMapper,
    super.legendItemText,
    super.sortFieldValueMapper,
    super.gradient,
    super.borderGradient,
    super.trendlines,
    super.markerSettings,
    super.initialIsVisible,
    super.enableTooltip = true,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.animationDuration,
    super.dashArray,
    super.borderWidth,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.opacity,
    super.animationDelay,
    super.color,
    super.initialSelectedDataIndexes,
    super.sortingOrder,
  });

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
  final ChartValueMapper<T, num>? yValueMapper;

  @override
  List<ChartDataPointType> get positions =>
      <ChartDataPointType>[ChartDataPointType.y];

  @override
  XyDataSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final XyDataSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as XyDataSeriesRenderer<T, D>;
    renderer.yValueMapper = yValueMapper;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, XyDataSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.yValueMapper = yValueMapper;
  }
}

abstract class XyDataSeriesRenderer<T, D> extends CartesianSeriesRenderer<T, D>
    with CartesianRealTimeUpdateMixin<T, D> {
  final List<num> yValues = <num>[];
  List<num> nonEmptyYValues = <num>[];
  final List<num> _chaoticYValues = <num>[];

  ChartValueMapper<T, num>? yValueMapper;

  void _resetYLists() {
    yValues.clear();
    nonEmptyYValues.clear();
  }

  @override
  void _resetDataSourceHolders() {
    _chaoticYValues.clear();
    _resetYLists();
    super._resetDataSourceHolders();
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (yPaths == null) {
      yPaths = <ChartValueMapper<T, num>>[];
      chaoticYLists = <List<num>>[];
      yLists = <List<num>>[];
    }

    if (yValueMapper != null) {
      yPaths.add(yValueMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticYLists?.add(yValues);
      } else {
        chaoticYLists?.add(_chaoticYValues);
        yLists?.add(yValues);
      }
    }

    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
    if (this is! WaterfallSeriesRenderer) {
      populateChartPoints();
    }
  }

  @override
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (yPaths == null) {
      yPaths = <ChartValueMapper<T, num>>[];
      chaoticYLists = <List<num>>[];
      yLists = <List<num>>[];
    }

    if (yValueMapper != null) {
      yPaths.add(yValueMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticYLists?.add(yValues);
      } else {
        _resetYLists();
        chaoticYLists?.add(_chaoticYValues);
        yLists?.add(yValues);
      }
    }
    super.updateDataPoints(removedIndexes, addedIndexes, replacedIndexes,
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
  }

  @override
  DoubleRange _calculateYRange({List<List<num>>? yLists}) {
    if (yLists == null) {
      yLists = <List<num>>[yValues];
    } else {
      yLists.add(yValues);
    }
    return super._calculateYRange(yLists: yLists);
  }

  @override
  void computeNonEmptyYValues() {
    nonEmptyYValues.clear();
    if (emptyPointSettings.mode == EmptyPointMode.gap ||
        emptyPointSettings.mode == EmptyPointMode.drop) {
      final List<num> yValuesCopy = <num>[...yValues];
      nonEmptyYValues = yValuesCopy;
      for (int i = 0; i < dataCount; i++) {
        if (i == 0 && yValues[i].isNaN) {
          nonEmptyYValues[i] = 0;
        } else if (yValues[i].isNaN) {
          nonEmptyYValues[i] = nonEmptyYValues[i - 1];
        }
      }
    } else {
      final List<num> yValuesCopy = <num>[...yValues];
      nonEmptyYValues = yValuesCopy;
    }
  }

  @override
  void _populateTrendlineDataSource() {
    trendlineContainer?.populateDataSource(xValues,
        seriesYValues: nonEmptyYValues);
  }

  @override
  num trackballYValue(int index) => yValues[index];

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    if (this is WaterfallSeriesRenderer) {
      super.populateChartPoints(positions: positions, yLists: yLists);
      return;
    }

    if (yLists == null) {
      yLists = <List<num>>[yValues];
      positions = <ChartDataPointType>[ChartDataPointType.y];
    } else {
      yLists.add(yValues);
      positions!.add(ChartDataPointType.y);
    }

    super.populateChartPoints(positions: positions, yLists: yLists);
  }

  @override
  void performLayout() {
    super.performLayout();

    if (this is! StackedSeriesRenderer && this is! WaterfallSeriesRenderer) {
      if (markerContainer != null) {
        markerContainer!
          ..renderer = this
          ..xRawValues = xRawValues
          ..xValues = xValues
          ..yLists = <List<num>>[yValues]
          ..animation = markerAnimation
          ..layout(constraints);
      }

      if (dataLabelContainer != null) {
        dataLabelContainer!
          ..renderer = this
          ..xRawValues = xRawValues
          ..xValues = xValues
          ..yLists = <List<num>>[yValues]
          ..sortedIndexes = sortedIndexes
          ..animation = dataLabelAnimation
          ..layout(constraints);
      }
    }
  }

  @override
  void dispose() {
    _chaoticYValues.clear();
    _resetYLists();
    super.dispose();
  }
}

/// Represents the stacked series base class.
abstract class StackedSeriesBase<T, D> extends XyDataSeries<T, D> {
  /// Creates an instance of stacked series renderer.
  const StackedSeriesBase({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    super.xValueMapper,
    super.yValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    super.dashArray,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    super.markerSettings,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.gradient,
    super.borderGradient,
    this.trackColor = Colors.grey,
    this.trackBorderColor = Colors.transparent,
    this.trackBorderWidth = 1.0,
    this.trackPadding = 0.0,
    this.isTrackVisible = false,
    super.trendlines,
    super.enableTooltip = true,
    super.animationDuration,
    super.borderWidth,
    super.selectionBehavior,
    super.initialSelectedDataIndexes,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    super.animationDelay,
    super.opacity,
  });

  /// Renders column with track. Track is a rectangular bar rendered from the
  /// start to the end of the axis. Column series
  /// will be rendered above the track.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool isTrackVisible;

  /// Color of the track.
  ///
  /// Defaults to `Colors.grey`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackColor: Colors.red
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color trackColor;

  /// Color of the track border.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackBorderColor: Colors.red
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color trackBorderColor;

  /// Width of the track border.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackBorderColor: Colors.red ,
  ///         trackBorderWidth: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double trackBorderWidth;

  /// Padding of the track.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackPadding: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double trackPadding;

  @override
  StackedSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final StackedSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as StackedSeriesRenderer<T, D>;
    renderer
      ..trackColor = trackColor
      ..trackBorderColor = trackBorderColor
      ..trackBorderWidth = trackBorderWidth
      ..trackPadding = trackPadding
      ..isTrackVisible = isTrackVisible;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, StackedSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..trackColor = trackColor
      ..trackBorderColor = trackBorderColor
      ..trackBorderWidth = trackBorderWidth
      ..trackPadding = trackPadding
      ..isTrackVisible = isTrackVisible;
  }
}

/// Represents the stacked series renderer class.
abstract class StackedSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with StackingSeriesMixin {
  Color get trackBorderColor => _trackBorderColor;
  Color _trackBorderColor = Colors.transparent;
  set trackBorderColor(Color value) {
    if (_trackBorderColor != value) {
      _trackBorderColor = value;
    }
  }

  Color get trackColor => _trackColor;
  Color _trackColor = Colors.grey;
  set trackColor(Color value) {
    if (_trackColor != value) {
      _trackColor = value;
    }
  }

  double get trackBorderWidth => _trackBorderWidth;
  double _trackBorderWidth = 1.0;
  set trackBorderWidth(double value) {
    if (_trackBorderWidth != value) {
      _trackBorderWidth = value;
    }
  }

  double get trackPadding => _trackPadding;
  double _trackPadding = 0.0;
  set trackPadding(double value) {
    if (_trackPadding != value) {
      _trackPadding = value;
    }
  }

  bool get isTrackVisible => _isTrackVisible;
  bool _isTrackVisible = false;
  set isTrackVisible(bool value) {
    if (_isTrackVisible != value) {
      _isTrackVisible = value;
    }
  }

  List<num> topValues = <num>[];
  List<num> bottomValues = <num>[];

  // It specifies the rendering of bottom values for the stacked area and
  // stacked area 100 series while considering the 'drop empty point' mode.
  List<num> prevSeriesYValues = <num>[];

  // It both specifies for stacking 100 series.
  bool _isStacked100 = false;
  Map<num, num> _percentageValues = <num, num>{};

  // Stores StackYValues considering empty point modes with yValues.
  List<num> _stackYValues = <num>[];

  @override
  void _resetYLists() {
    _resetStackedYLists();
    super._resetYLists();
  }

  void _resetStackedYLists() {
    topValues.clear();
    bottomValues.clear();
    _percentageValues.clear();
    _stackYValues.clear();
  }

  @nonVirtual
  void _applyDropOrGapEmptyPointModes(StackedSeriesRenderer<T, D> series) {
    if (yValues.isEmpty) {
      return;
    }

    if (emptyPointSettings.mode == EmptyPointMode.gap ||
        emptyPointSettings.mode == EmptyPointMode.drop) {
      final List<num> yValuesCopy = <num>[...yValues];
      _stackYValues = yValuesCopy;
      final String seriesType = series.runtimeType.toString().toLowerCase();
      final bool isStackedBar = seriesType.contains('stackedcolumn') ||
          seriesType.contains('stackedbar');
      for (int i = 0; i < dataCount; i++) {
        if (_stackYValues[i].isNaN) {
          _stackYValues[i] = i != 0 && !isStackedBar ? _stackYValues[i - 1] : 0;
        }
      }
    } else {
      final List<num> yValuesCopy = <num>[...yValues];
      _stackYValues = yValuesCopy;
    }
  }

  @nonVirtual
  void _calculateStackingValues(StackedSeriesRenderer<T, D> series) {
    if (series.xAxis == null || series.yAxis == null) {
      return;
    }

    final List<AxisDependent> yDependents = series.yAxis!.dependents;
    if (yDependents.isEmpty) {
      return;
    }

    StackedSeriesRenderer<T, D>? current;
    StackedSeriesRenderer<T, D>? previous;
    String groupName = '';
    List<_StackingInfo>? positiveValues;
    List<_StackingInfo>? negativeValues;

    if (series is Stacking100SeriesMixin) {
      _isStacked100 = true;
      _calculatePercentageValues(yDependents);
    }

    for (final AxisDependent yDependant in yDependents) {
      if (yDependant is! StackedSeriesRenderer<T, D>) {
        continue;
      }

      current = yDependant;

      if (!current.controller.isVisible || current.dataCount == 0) {
        continue;
      }

      final String seriesType = current.runtimeType.toString().toLowerCase();
      final bool isStackedArea = seriesType.contains('stackedarea');
      groupName = isStackedArea ? 'stackedareagroup' : current.groupName;
      _StackingInfo? currentPositiveStackInfo;

      if (positiveValues == null || negativeValues == null) {
        positiveValues = <_StackingInfo>[];
        currentPositiveStackInfo = _StackingInfo(groupName, <num, num>{});
        positiveValues.add(currentPositiveStackInfo);
        negativeValues = <_StackingInfo>[];
        negativeValues.add(_StackingInfo(groupName, <num, num>{}));
      }

      _computeStackedValues(current, currentPositiveStackInfo, positiveValues,
          negativeValues, _isStacked100, groupName);

      if (previous != null) {
        current.prevSeriesYValues = previous.yValues;
      } else {
        current.prevSeriesYValues = current.yValues;
      }

      previous = current;
    }
  }

  void _computeStackedValues(
    StackedSeriesRenderer<T, D> current,
    _StackingInfo? currentPositiveStackInfo,
    List<_StackingInfo> positiveValues,
    List<_StackingInfo> negativeValues,
    bool isStacked100,
    String groupName,
  ) {
    final String seriesType = current.runtimeType.toString().toLowerCase();
    final bool isStackedArea = seriesType.contains('stackedarea');
    final bool isStackedLine = seriesType.contains('stackedline');
    final EmptyPointMode emptyPointMode = current.emptyPointSettings.mode;
    final bool isDropOrGapMode = emptyPointMode == EmptyPointMode.drop ||
        emptyPointMode == EmptyPointMode.gap;
    final List<num> actualYValues = <num>[...current._stackYValues];
    _StackingInfo? currentNegativeStackInfo;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;
    current.topValues.clear();
    current.bottomValues.clear();

    if (positiveValues.isNotEmpty) {
      for (int k = 0; k < positiveValues.length; k++) {
        if (groupName == positiveValues[k].groupName) {
          currentPositiveStackInfo = positiveValues[k];
          break;
        } else if (k == positiveValues.length - 1) {
          currentPositiveStackInfo = _StackingInfo(groupName, <num, num>{});
          positiveValues.add(currentPositiveStackInfo);
        }
      }
    }

    if (negativeValues.isNotEmpty) {
      for (int k = 0; k < negativeValues.length; k++) {
        if (groupName == negativeValues[k].groupName) {
          currentNegativeStackInfo = negativeValues[k];
          break;
        } else if (k == negativeValues.length - 1) {
          currentNegativeStackInfo = _StackingInfo(groupName, <num, num>{});
          negativeValues.add(currentNegativeStackInfo);
        }
      }
    }

    final int length = current.dataCount;
    for (int i = 0; i < length; i++) {
      final num xValue = current.xValues[i];
      num yValue = actualYValues[i];
      if (currentPositiveStackInfo?.stackingValues != null) {
        if (!currentPositiveStackInfo!.stackingValues.containsKey(xValue)) {
          currentPositiveStackInfo.stackingValues[xValue] = 0;
        }
      }

      if (currentNegativeStackInfo?.stackingValues != null) {
        if (!currentNegativeStackInfo!.stackingValues.containsKey(xValue)) {
          currentNegativeStackInfo.stackingValues[xValue] = 0;
        }
      }

      if (isStacked100) {
        yValue = yValue / current._percentageValues[xValue]! * 100;
        yValue = yValue.isNaN ? 0 : yValue;
      }

      num stackValue = 0;
      if (isStackedArea || yValue >= 0) {
        if (currentPositiveStackInfo!.stackingValues.containsKey(xValue)) {
          stackValue = currentPositiveStackInfo.stackingValues[xValue]!;
          currentPositiveStackInfo.stackingValues[xValue] = stackValue + yValue;
        }
      } else {
        if (currentNegativeStackInfo!.stackingValues.containsKey(xValue)) {
          stackValue = currentNegativeStackInfo.stackingValues[xValue]!;
          currentNegativeStackInfo.stackingValues[xValue] = stackValue + yValue;
        }
      }

      // Add stacking top and bottom values.
      current.bottomValues.add(stackValue.toDouble());
      current.topValues.add((stackValue + yValue).toDouble());
      if (isStacked100 && current.topValues[i] > 100) {
        current.topValues[i] = 100;
      }

      if (isStackedLine && current.yValues[i].isNaN && isDropOrGapMode) {
        current.topValues[i] = double.nan;
      }

      // Calculate current series minimum and maximum range.
      final num bottom = current.bottomValues[i];
      yMinimum = min(yMinimum, bottom.isNaN ? yMinimum : bottom);
      final num top = current.topValues[i];
      yMaximum = max(yMaximum, top.isNaN ? yMaximum : top);
    }

    num minY = yMinimum;
    num maxY = yMaximum;
    if (yMinimum > yMaximum) {
      minY = isStacked100 ? -100 : yMaximum;
    }

    if (yMaximum < yMinimum) {
      maxY = 0;
    }

    yMin = min(yMin, minY);
    yMax = max(yMax, maxY);
  }

  void _calculatePercentageValues(List<AxisDependent> yDependents) {
    StackedSeriesRenderer<T, D>? current;
    List<_StackingInfo>? percentageInfo;
    for (final AxisDependent yDependant in yDependents) {
      StackedSeriesRenderer<T, D>? yDependantSeries;
      if (yDependant is StackedSeriesRenderer<T, D>) {
        yDependantSeries = yDependant;
      }

      if (yDependantSeries != null) {
        current = yDependantSeries;
      }

      if (current == null) {
        continue;
      }

      final int length = current.dataCount;
      if (!current.controller.isVisible || length == 0) {
        continue;
      }

      final String seriesType = current.runtimeType.toString().toLowerCase();
      final bool isContainsStackedArea = seriesType.contains('stackedarea');
      final bool isContainsStackedArea100 =
          seriesType.contains('stackedarea100');
      final String groupName =
          isContainsStackedArea100 ? 'stackedareagroup' : current.groupName;

      _StackingInfo? stackingInfo;
      if (percentageInfo == null) {
        percentageInfo = <_StackingInfo>[];
        stackingInfo = _StackingInfo(groupName, <num, num>{});
      }

      for (int i = 0; i < length; i++) {
        final num xValue = current.xValues[i];
        final num yValue = current._stackYValues[i];
        if (percentageInfo.isNotEmpty) {
          final int percentageLength = percentageInfo.length;
          for (int k = 0; k < percentageLength; k++) {
            if (groupName == percentageInfo[k].groupName) {
              stackingInfo = percentageInfo[k];
              break;
            } else if (k == percentageLength - 1) {
              stackingInfo = _StackingInfo(groupName, <num, num>{});
              percentageInfo.add(stackingInfo);
            }
          }
        }

        if (stackingInfo?.stackingValues != null) {
          if (!stackingInfo!.stackingValues.containsKey(xValue)) {
            stackingInfo.stackingValues[xValue] = 0;
          }
        }

        if (stackingInfo!.stackingValues.containsKey(xValue)) {
          if (isContainsStackedArea || yValue >= 0) {
            stackingInfo.stackingValues[xValue] =
                stackingInfo.stackingValues[xValue]! + yValue;
          } else {
            stackingInfo.stackingValues[xValue] =
                stackingInfo.stackingValues[xValue]! - yValue;
          }
        }

        if (i == length - 1) {
          percentageInfo.add(stackingInfo);
        }
      }

      if (percentageInfo.isNotEmpty) {
        final int percentageLength = percentageInfo.length;
        for (int i = 0; i < percentageLength; i++) {
          if (isContainsStackedArea100) {
            current._percentageValues = percentageInfo[i].stackingValues;
          } else if (current.groupName == percentageInfo[i].groupName) {
            current._percentageValues = percentageInfo[i].stackingValues;
          }
        }
      }
    }
    percentageInfo?.clear();
  }

  @override
  void performUpdate() {
    /// One stacking series rely on the top/bottom values of adjacent stacking
    /// series. So, it is necessary to update the segment values whenever
    /// the data population is done.
    canUpdateOrCreateSegments = true;
    super.performUpdate();
  }

  @override
  void performLayout() {
    super.performLayout();

    if (markerContainer != null) {
      markerContainer!
        ..renderer = this
        ..xRawValues = xRawValues
        ..xValues = xValues
        ..yLists = <List<num>>[topValues]
        ..animation = markerAnimation
        ..layout(constraints);
    }

    if (dataLabelContainer != null) {
      dataLabelContainer!
        ..renderer = this
        ..xRawValues = xRawValues
        ..xValues = xValues
        ..yLists = <List<num>>[topValues]
        ..stackedYValues = yValues
        ..sortedIndexes = sortedIndexes
        ..animation = dataLabelAnimation
        ..layout(constraints);
    }
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);

    /// Calculate [StackYValues] based on empty point modes with yValues.
    _applyDropOrGapEmptyPointModes(this);

    /// Calculate [topValues] and [bottomValues] as stacked values.
    _calculateStackingValues(this);

    /// The [topValues] are not calculated,
    /// when chartSeriesRenderer populateDataSource method calling.
    /// So, only we invoke the trendline data source method calling after
    /// stacking values calculated.
    _populateTrendlineDataSource();
    populateChartPoints();
  }

  @override
  DoubleRange _calculateYRange({List<List<num>>? yLists}) {
    if (yLists == null) {
      yLists = <List<num>>[topValues];
    } else {
      yLists.add(topValues);
      yLists.add(bottomValues);
    }
    return super._calculateYRange(yLists: yLists);
  }

  @override
  void drawDataLabelWithBackground(
    int index,
    Canvas canvas,
    String dataLabel,
    Offset offset,
    int angle,
    TextStyle style,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    if (dataLabelMapper == null &&
        parent!.onDataLabelRender == null &&
        !dataLabelSettings.showCumulativeValues) {
      final num value = yValues[index];

      if ((!dataLabelSettings.showZeroValue && value == 0) || value.isNaN) {
        return;
      }

      dataLabel = formatNumericValue(value, yAxis);
    }
    super.drawDataLabelWithBackground(
        index, canvas, dataLabel, offset, angle, style, fillPaint, strokePaint);
  }

  @override
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    super.updateDataPoints(removedIndexes, addedIndexes, replacedIndexes,
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);

    /// Clear `stackedYLists` alone instead of resetting `YLists`.
    _resetStackedYLists();

    /// Calculate [StackYValues] based on empty point modes with yValues.
    _applyDropOrGapEmptyPointModes(this);

    /// Calculate [topValues] and [bottomValues] as stacked values.
    _calculateStackingValues(this);
    _populateTrendlineDataSource();
  }

  @override
  void _populateTrendlineDataSource() {
    trendlineContainer?.populateDataSource(xValues, seriesYValues: topValues);
  }

  @override
  num trackballYValue(int index) => topValues[index];

  @override
  void dispose() {
    _resetYLists();
    super.dispose();
  }
}

/// Represents the stacking info class.
class _StackingInfo {
  /// Creates an instance of stacking info class.
  _StackingInfo(this.groupName, this.stackingValues);

  /// Holds the group name.
  String groupName;

  /// Holds the list of stacking values.
  Map<num, num> stackingValues;
}

/// Renders the xy series.
///
/// Cartesian charts uses two axis namely x and y, to render.
abstract class RangeSeriesBase<T, D> extends CartesianSeries<T, D> {
  /// Creating an argument constructor of XyDataSeries class.
  const RangeSeriesBase({
    super.key,
    this.highValueMapper,
    this.lowValueMapper,
    super.onCreateRenderer,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    super.xValueMapper,
    super.dataLabelMapper,
    super.name,
    super.dataSource,
    super.xAxisName,
    super.yAxisName,
    super.pointColorMapper,
    super.legendItemText,
    super.sortFieldValueMapper,
    super.gradient,
    super.borderGradient,
    super.trendlines,
    super.markerSettings,
    super.initialIsVisible,
    super.enableTooltip = true,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.animationDuration,
    super.dashArray,
    this.borderColor = Colors.transparent,
    super.borderWidth,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.opacity,
    super.animationDelay,
    super.color,
    super.initialSelectedDataIndexes,
    super.sortingOrder,
  });

  /// Field in the data source, which is considered as high value for the
  /// data points.
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
  final ChartValueMapper<T, num>? highValueMapper;

  /// Field in the data source, which is considered as low value
  /// for the data points.
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
  final ChartValueMapper<T, num>? lowValueMapper;

  /// Border color of the series.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <RangeColumnSeries<SalesData, String>>[
  ///       RangeColumnSeries<SalesData, String>(
  ///         borderColor: Colors.red,
  ///         borderWidth: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color borderColor;

  @override
  List<ChartDataPointType> get positions =>
      <ChartDataPointType>[ChartDataPointType.high, ChartDataPointType.low];

  @override
  RangeSeriesRendererBase<T, D> createRenderObject(BuildContext context) {
    final RangeSeriesRendererBase<T, D> renderer =
        super.createRenderObject(context) as RangeSeriesRendererBase<T, D>;
    renderer.highValueMapper = highValueMapper;
    renderer.lowValueMapper = lowValueMapper;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, RangeSeriesRendererBase<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.highValueMapper = highValueMapper;
    renderObject.lowValueMapper = lowValueMapper;
  }
}

abstract class RangeSeriesRendererBase<T, D>
    extends CartesianSeriesRenderer<T, D>
    with CartesianRealTimeUpdateMixin<T, D> {
  final List<num> _chaoticHighValues = <num>[];
  final List<num> _chaoticLowValues = <num>[];
  final List<num> highValues = <num>[];
  final List<num> lowValues = <num>[];
  List<num> nonEmptyHighValues = <num>[];
  List<num> nonEmptyLowValues = <num>[];

  ChartValueMapper<T, num>? highValueMapper;
  ChartValueMapper<T, num>? lowValueMapper;

  void _resetYLists() {
    highValues.clear();
    lowValues.clear();
    nonEmptyHighValues.clear();
    nonEmptyLowValues.clear();
  }

  @override
  void _resetDataSourceHolders() {
    _resetYLists();
    super._resetDataSourceHolders();
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (highValueMapper != null && lowValueMapper != null) {
      if (sortingOrder == SortingOrder.none) {
        super.populateDataSource(
            <ChartValueMapper<T, num>>[highValueMapper!, lowValueMapper!],
            <List<num>>[highValues, lowValues],
            <List<num>>[],
            fPaths,
            chaoticFLists,
            fLists);
      } else {
        super.populateDataSource(
          <ChartValueMapper<T, num>>[highValueMapper!, lowValueMapper!],
          <List<num>>[_chaoticHighValues, _chaoticLowValues],
          <List<num>>[highValues, lowValues],
          fPaths,
          chaoticFLists,
          fLists,
        );
      }
    }

    _applyDropOrGapEmptyPointModes();
    populateChartPoints();
  }

  @override
  DoubleRange _calculateYRange({List<List<num>>? yLists}) {
    if (yLists == null) {
      yLists = <List<num>>[highValues, lowValues];
    } else {
      yLists.add(highValues);
      yLists.add(lowValues);
    }
    return super._calculateYRange(yLists: yLists);
  }

  @override
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (highValueMapper != null && lowValueMapper != null) {
      if (sortingOrder == SortingOrder.none) {
        super.updateDataPoints(
            removedIndexes,
            addedIndexes,
            replacedIndexes,
            <ChartValueMapper<T, num>>[highValueMapper!, lowValueMapper!],
            <List<num>>[highValues, lowValues],
            <List<num>>[],
            fPaths,
            chaoticFLists,
            fLists);
      } else {
        _resetYLists();
        super.updateDataPoints(
            removedIndexes,
            addedIndexes,
            replacedIndexes,
            <ChartValueMapper<T, num>>[highValueMapper!, lowValueMapper!],
            <List<num>>[_chaoticHighValues, _chaoticLowValues],
            <List<num>>[highValues, lowValues],
            fPaths,
            chaoticFLists,
            fLists);
      }
    }

    _applyDropOrGapEmptyPointModes();
  }

  @override
  void computeNonEmptyYValues() {
    // Swapping high and low values is necessary before invoking
    // _populateTrendlineDataSource() to render trendline and
    // spline range series based on nonEmptyHighValues and nonEmptyLowValues.
    for (int i = 0; i < dataCount; i++) {
      num high = highValues[i];
      num low = lowValues[i];
      if (low > high) {
        final num temp = high;
        high = low;
        low = temp;
        highValues[i] = high;
        lowValues[i] = low;
      }
    }

    if (emptyPointSettings.mode == EmptyPointMode.gap ||
        emptyPointSettings.mode == EmptyPointMode.drop) {
      final List<num> highValuesCopy = <num>[...highValues];
      final List<num> lowValuesCopy = <num>[...lowValues];
      nonEmptyHighValues = highValuesCopy;
      nonEmptyLowValues = lowValuesCopy;
      for (int i = 0; i < dataCount; i++) {
        if (i == 0 && highValues[i].isNaN) {
          nonEmptyHighValues[i] = 0;
        } else if (i > 0 && highValues[i].isNaN) {
          nonEmptyHighValues[i] = nonEmptyHighValues[i - 1];
        }

        if (i == 0 && lowValues[i].isNaN) {
          nonEmptyLowValues[i] = 0;
        } else if (i > 0 && lowValues[i].isNaN) {
          nonEmptyLowValues[i] = nonEmptyLowValues[i - 1];
        }
      }
    } else {
      nonEmptyHighValues = highValues;
      nonEmptyLowValues = lowValues;
    }
  }

  @nonVirtual
  void _applyDropOrGapEmptyPointModes() {
    if (emptyPointSettings.mode == EmptyPointMode.gap ||
        emptyPointSettings.mode == EmptyPointMode.drop) {
      for (int i = 0; i < dataCount; i++) {
        if (highValues[i].isNaN || lowValues[i].isNaN) {
          highValues[i] = double.nan;
          lowValues[i] = double.nan;
        }
      }
    }
  }

  @override
  void _applyZeroEmptyPointMode(List<List<num>> yLists) {
    if (yLists.isNotEmpty) {
      for (int i = 0; i < dataCount; i++) {
        final List<num> highValues = yLists[0];
        final List<num> lowValues = yLists[1];
        final num highValue = highValues[i];
        final num lowValue = lowValues[i];
        if (highValue.isNaN || lowValue.isNaN) {
          highValues[i] = 0;
          lowValues[i] = 0;
        }
      }
    }
  }

  @override
  void _populateTrendlineDataSource() {
    trendlineContainer?.populateDataSource(xValues,
        seriesHighValues: nonEmptyHighValues,
        seriesLowValues: nonEmptyLowValues);
  }

  @override
  num trackballYValue(int index) => highValues[index];

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    if (yLists == null) {
      yLists = <List<num>>[highValues, lowValues];
      positions = <ChartDataPointType>[
        ChartDataPointType.high,
        ChartDataPointType.low
      ];
    } else {
      yLists.add(highValues);
      yLists.add(lowValues);
      positions!.add(ChartDataPointType.high);
      positions.add(ChartDataPointType.low);
    }

    super.populateChartPoints(positions: positions, yLists: yLists);
  }

  @override
  void performLayout() {
    super.performLayout();

    if (markerContainer != null) {
      markerContainer!
        ..renderer = this
        ..xRawValues = xRawValues
        ..xValues = xValues
        ..yLists = <List<num>>[highValues, lowValues]
        ..animation = markerAnimation
        ..layout(constraints);
    }

    if (dataLabelContainer != null) {
      dataLabelContainer!
        ..renderer = this
        ..xRawValues = xRawValues
        ..xValues = xValues
        ..yLists = <List<num>>[highValues, lowValues]
        ..sortedIndexes = sortedIndexes
        ..animation = dataLabelAnimation
        ..layout(constraints);
    }
  }

  @override
  Offset dataLabelPosition(ChartElementParentData current,
      ChartDataLabelAlignment alignment, Size size) {
    switch (current.position) {
      case ChartDataPointType.y:
      case ChartDataPointType.high:
        switch (alignment) {
          case ChartDataLabelAlignment.auto:
          case ChartDataLabelAlignment.outer:
          case ChartDataLabelAlignment.top:
            return super.dataLabelPosition(
                current, ChartDataLabelAlignment.outer, size);

          case ChartDataLabelAlignment.bottom:
            return super.dataLabelPosition(
                current, ChartDataLabelAlignment.bottom, size);

          case ChartDataLabelAlignment.middle:
            return super.dataLabelPosition(
                current, ChartDataLabelAlignment.middle, size);
        }

      case ChartDataPointType.low:
        switch (alignment) {
          case ChartDataLabelAlignment.auto:
          case ChartDataLabelAlignment.outer:
          case ChartDataLabelAlignment.bottom:
            return super.dataLabelPosition(
                current, ChartDataLabelAlignment.bottom, size);

          case ChartDataLabelAlignment.top:
            return super
                .dataLabelPosition(current, ChartDataLabelAlignment.top, size);

          case ChartDataLabelAlignment.middle:
            return super.dataLabelPosition(
                current, ChartDataLabelAlignment.middle, size);
        }

      case ChartDataPointType.open:
      case ChartDataPointType.close:
      case ChartDataPointType.volume:
      case ChartDataPointType.median:
      case ChartDataPointType.mean:
      case ChartDataPointType.outliers:
      case ChartDataPointType.bubbleSize:
      case ChartDataPointType.cumulative:
        break;
    }

    return Offset.zero;
  }

  @override
  void dispose() {
    _chaoticHighValues.clear();
    _chaoticLowValues.clear();
    _resetYLists();
    super.dispose();
  }
}

/// Represents the financial series base.
abstract class FinancialSeriesBase<T, D> extends CartesianSeries<T, D> {
  /// Creates an instance of financial series base.
  const FinancialSeriesBase({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    this.lowValueMapper,
    this.highValueMapper,
    this.openValueMapper,
    this.closeValueMapper,
    this.volumeValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    super.dashArray,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    this.width = 0.7,
    this.spacing = 0,
    super.markerSettings,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.gradient,
    super.enableTooltip = true,
    super.animationDuration,
    super.borderWidth = 2,
    super.selectionBehavior,
    super.initialSelectedDataIndexes,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    this.enableSolidCandles = false,
    this.bearColor = Colors.red,
    this.bullColor = Colors.green,
    super.opacity,
    super.animationDelay,
    this.showIndicationForSameValues = false,
    super.trendlines,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
  });

  /// Specifies the volume value mapper.
  final ChartValueMapper<T, num>? volumeValueMapper;

  /// Specifies the open value mapper.
  final ChartValueMapper<T, num>? openValueMapper;

  /// Specifies the close value mapper.
  final ChartValueMapper<T, num>? closeValueMapper;

  /// Specifies the high value mapper.
  final ChartValueMapper<T, num>? highValueMapper;

  /// Specifies the low value mapper.
  final ChartValueMapper<T, num>? lowValueMapper;

  /// Specifies the bear color.
  final Color bearColor;

  /// Specifies the bull color.
  final Color bullColor;

  /// Specifies whether the solid candles.
  final bool enableSolidCandles;

  /// Spacing between the columns. The value ranges from 0 to 1.
  /// 1 represents 100% and 0 represents 0% of the available space.
  ///
  /// Spacing also affects the width of the column. For example, setting 20%
  /// spacing and 100% width renders the column with 80% of total width.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HiloSeries<SalesData, num>>[
  ///       HiloSeries<SalesData, num>(
  ///         spacing: 0.5,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  /// If it is set to true, a small vertical line will be rendered. Else nothing
  /// will be rendered for that specific data point and left as a blank area.
  ///
  /// This is applicable for the following series types:
  /// * HiLo (High low)
  /// * OHLC (Open high low close)
  /// * Candle
  ///
  /// Defaults to `false`.
  final bool showIndicationForSameValues;

  final double width;

  @override
  List<ChartDataPointType> get positions => <ChartDataPointType>[
        ChartDataPointType.high,
        ChartDataPointType.low,
        ChartDataPointType.open,
        ChartDataPointType.close,
      ];

  @override
  FinancialSeriesRendererBase<T, D> createRenderObject(BuildContext context) {
    final FinancialSeriesRendererBase<T, D> renderer =
        super.createRenderObject(context) as FinancialSeriesRendererBase<T, D>;
    renderer
      ..volumeValueMapper = volumeValueMapper
      ..openValueMapper = openValueMapper
      ..closeValueMapper = closeValueMapper
      ..highValueMapper = highValueMapper
      ..lowValueMapper = lowValueMapper
      ..bearColor = bearColor
      ..bullColor = bullColor
      ..enableSolidCandles = enableSolidCandles
      ..spacing = spacing
      ..showIndicationForSameValues = showIndicationForSameValues
      ..width = width;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, FinancialSeriesRendererBase<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..volumeValueMapper = volumeValueMapper
      ..openValueMapper = openValueMapper
      ..closeValueMapper = closeValueMapper
      ..highValueMapper = highValueMapper
      ..lowValueMapper = lowValueMapper
      ..bearColor = bearColor
      ..bullColor = bullColor
      ..enableSolidCandles = enableSolidCandles
      ..spacing = spacing
      ..showIndicationForSameValues = showIndicationForSameValues
      ..width = width;
  }
}

/// Creates series renderer for column series.
abstract class FinancialSeriesRendererBase<T, D>
    extends CartesianSeriesRenderer<T, D>
    with
        SbsSeriesMixin<T, D>,
        ClusterSeriesMixin,
        CartesianRealTimeUpdateMixin<T, D> {
  /// Calling the default constructor of ColumnSeriesRenderer class.
  FinancialSeriesRendererBase();

  final List<num> _chaoticLowValues = <num>[];
  final List<num> _chaoticHighValues = <num>[];
  final List<num> _chaoticOpenValues = <num>[];
  final List<num> _chaoticCloseValues = <num>[];
  final List<num> _chaoticVolumeValues = <num>[];

  final List<num> lowValues = <num>[];
  final List<num> highValues = <num>[];
  final List<num> openValues = <num>[];
  final List<num> closeValues = <num>[];
  final List<num> volumeValues = <num>[];

  ChartValueMapper<T, num>? get volumeValueMapper => _volumeValueMapper;
  ChartValueMapper<T, num>? _volumeValueMapper;
  set volumeValueMapper(ChartValueMapper<T, num>? value) {
    if (_volumeValueMapper != value) {
      _volumeValueMapper = value;
    }
  }

  ChartValueMapper<T, num>? get openValueMapper => _openValueMapper;
  ChartValueMapper<T, num>? _openValueMapper;
  set openValueMapper(ChartValueMapper<T, num>? value) {
    if (_openValueMapper != value) {
      _openValueMapper = value;
    }
  }

  ChartValueMapper<T, num>? get closeValueMapper => _closeValueMapper;
  ChartValueMapper<T, num>? _closeValueMapper;
  set closeValueMapper(ChartValueMapper<T, num>? value) {
    if (_closeValueMapper != value) {
      _closeValueMapper = value;
    }
  }

  ChartValueMapper<T, num>? get highValueMapper => _highValueMapper;
  ChartValueMapper<T, num>? _highValueMapper;
  set highValueMapper(ChartValueMapper<T, num>? value) {
    if (_highValueMapper != value) {
      _highValueMapper = value;
    }
  }

  ChartValueMapper<T, num>? get lowValueMapper => _lowValueMapper;
  ChartValueMapper<T, num>? _lowValueMapper;
  set lowValueMapper(ChartValueMapper<T, num>? value) {
    if (_lowValueMapper != value) {
      _lowValueMapper = value;
    }
  }

  Color get bearColor => _bearColor;
  Color _bearColor = Colors.red;
  set bearColor(Color value) {
    if (_bearColor != value) {
      _bearColor = value;
    }
  }

  Color get bullColor => _bullColor;
  Color _bullColor = Colors.green;
  set bullColor(Color value) {
    if (_bullColor != value) {
      _bullColor = value;
    }
  }

  bool get enableSolidCandles => _enableSolidCandles;
  bool _enableSolidCandles = false;
  set enableSolidCandles(bool value) {
    if (_enableSolidCandles != value) {
      _enableSolidCandles = value;
    }
  }

  bool get showIndicationForSameValues => _showIndicationForSameValues;
  bool _showIndicationForSameValues = false;
  set showIndicationForSameValues(bool value) {
    if (_showIndicationForSameValues != value) {
      _showIndicationForSameValues = value;
    }
  }

  void _resetYLists() {
    highValues.clear();
    lowValues.clear();
    openValues.clear();
    closeValues.clear();
    volumeValues.clear();
  }

  @override
  void _resetDataSourceHolders() {
    _chaoticHighValues.clear();
    _chaoticLowValues.clear();
    _chaoticOpenValues.clear();
    _chaoticCloseValues.clear();
    _chaoticVolumeValues.clear();
    _resetYLists();
    super._resetDataSourceHolders();
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (highValueMapper != null &&
        lowValueMapper != null &&
        openValueMapper != null &&
        closeValueMapper != null) {
      final List<ChartValueMapper<T, num>> mappers = <ChartValueMapper<T, num>>[
        highValueMapper!,
        lowValueMapper!,
        openValueMapper!,
        closeValueMapper!,
        if (volumeValueMapper != null) volumeValueMapper!,
      ];
      final List<List<num>> finalYLists = <List<num>>[
        highValues,
        lowValues,
        openValues,
        closeValues,
        if (volumeValueMapper != null) volumeValues,
      ];

      if (sortingOrder == SortingOrder.none) {
        super.populateDataSource(
            mappers, finalYLists, <List<num>>[], fPaths, chaoticFLists, fLists);
      } else {
        super.populateDataSource(
          mappers,
          <List<num>>[
            _chaoticHighValues,
            _chaoticLowValues,
            _chaoticOpenValues,
            _chaoticCloseValues,
            if (volumeValueMapper != null) _chaoticVolumeValues,
          ],
          finalYLists,
          fPaths,
          chaoticFLists,
          fLists,
        );
      }
    }

    for (int i = 0; i < dataCount; i++) {
      num high = highValues[i];
      num low = lowValues[i];
      if (low > high) {
        final num temp = high;
        high = low;
        low = temp;
        highValues[i] = high;
        lowValues[i] = low;
      }
    }

    populateChartPoints();
  }

  @override
  DoubleRange _calculateYRange({List<List<num>>? yLists}) {
    if (yLists == null) {
      yLists = <List<num>>[highValues, lowValues, openValues, closeValues];
    } else {
      yLists.add(highValues);
      yLists.add(lowValues);
      yLists.add(openValues);
      yLists.add(closeValues);
    }
    return super._calculateYRange(yLists: yLists);
  }

  @override
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (highValueMapper != null &&
        lowValueMapper != null &&
        openValueMapper != null &&
        closeValueMapper != null) {
      final List<ChartValueMapper<T, num>> mappers = <ChartValueMapper<T, num>>[
        highValueMapper!,
        lowValueMapper!,
        openValueMapper!,
        closeValueMapper!,
        if (volumeValueMapper != null) volumeValueMapper!,
      ];
      final List<List<num>> finalYLists = <List<num>>[
        highValues,
        lowValues,
        openValues,
        closeValues,
        if (volumeValueMapper != null) volumeValues,
      ];

      if (sortingOrder == SortingOrder.none) {
        super.updateDataPoints(removedIndexes, addedIndexes, replacedIndexes,
            mappers, finalYLists, <List<num>>[], fPaths, chaoticFLists, fLists);
      } else {
        _resetYLists();
        super.updateDataPoints(
            removedIndexes,
            addedIndexes,
            replacedIndexes,
            mappers,
            <List<num>>[
              _chaoticHighValues,
              _chaoticLowValues,
              _chaoticOpenValues,
              _chaoticCloseValues,
              if (volumeValueMapper != null) _chaoticVolumeValues,
            ],
            finalYLists,
            fPaths,
            chaoticFLists,
            fLists);
      }
    }

    for (int i = 0; i < dataCount; i++) {
      num high = highValues[i];
      num low = lowValues[i];
      if (low > high) {
        final num temp = high;
        high = low;
        low = temp;
        highValues[i] = high;
        lowValues[i] = low;
      }
    }
  }

  @override
  void _applyEmptyPointModeIfNeeded(List<List<num>> yLists) {
    if (emptyPointIndexes.isNotEmpty) {
      emptyPointIndexes.sort();
      switch (emptyPointSettings.mode) {
        case EmptyPointMode.gap:
        case EmptyPointMode.drop:
        case EmptyPointMode.zero:
          break;

        case EmptyPointMode.average:
          _applyAverageEmptyPointMode(yLists);
          break;
      }
    }
  }

  @override
  void _populateTrendlineDataSource() {
    trendlineContainer?.populateDataSource(xValues,
        seriesHighValues: highValues, seriesLowValues: lowValues);
  }

  @override
  num trackballYValue(int index) => highValues[index];

  @override
  double legendIconBorderWidth() {
    return 2;
  }

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    if (yLists == null) {
      yLists = <List<num>>[highValues, lowValues, openValues, closeValues];
      positions = <ChartDataPointType>[
        ChartDataPointType.high,
        ChartDataPointType.low,
        ChartDataPointType.open,
        ChartDataPointType.close,
      ];
    } else {
      yLists.add(highValues);
      yLists.add(lowValues);
      yLists.add(openValues);
      yLists.add(closeValues);
      positions!.add(ChartDataPointType.high);
      positions.add(ChartDataPointType.low);
      positions.add(ChartDataPointType.open);
      positions.add(ChartDataPointType.close);
    }

    super.populateChartPoints(positions: positions, yLists: yLists);
  }

  @override
  void performLayout() {
    super.performLayout();

    if (dataLabelContainer != null) {
      dataLabelContainer!
        ..renderer = this
        ..xRawValues = xRawValues
        ..xValues = xValues
        ..yLists = <List<num>>[highValues, lowValues, openValues, closeValues]
        ..sortedIndexes = sortedIndexes
        ..animation = dataLabelAnimation
        ..layout(constraints);
    }
  }

  @override
  ChartDataLabelAlignment effectiveDataLabelAlignment(
      ChartDataLabelAlignment alignment,
      ChartDataPointType position,
      ChartElementParentData? previous,
      ChartElementParentData current,
      ChartElementParentData? next) {
    final int index = current.dataPointIndex;
    if (position == ChartDataPointType.open) {
      final num open = openValues[index];
      final num close = closeValues[index];
      return open <= close
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else if (position == ChartDataPointType.close) {
      final num open = openValues[index];
      final num close = closeValues[index];
      return close <= open
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    }

    return alignment == ChartDataLabelAlignment.auto
        ? ChartDataLabelAlignment.outer
        : alignment;
  }

  @override
  Offset _calculateDataLabelOpenPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.middle:
        return _calculateOpenAndClosePosition(
            x, y, ChartDataLabelAlignment.outer, size, ChartDataPointType.open);

      case ChartDataLabelAlignment.bottom:
        return _calculateOpenAndClosePosition(
            x, y, ChartDataLabelAlignment.top, size, ChartDataPointType.open);
    }
  }

  @protected
  Offset _calculateOpenAndClosePosition(
      num x,
      num y,
      ChartDataLabelAlignment alignment,
      Size size,
      ChartDataPointType position) {
    return _calculateYPosition(x, y, alignment, size);
  }

  @override
  Offset _calculateDataLabelClosePosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.middle:
        return _calculateOpenAndClosePosition(x, y,
            ChartDataLabelAlignment.outer, size, ChartDataPointType.close);

      case ChartDataLabelAlignment.bottom:
        return _calculateOpenAndClosePosition(
            x, y, ChartDataLabelAlignment.top, size, ChartDataPointType.close);
    }
  }

  @override
  void dispose() {
    _chaoticHighValues.clear();
    _chaoticLowValues.clear();
    _chaoticOpenValues.clear();
    _chaoticCloseValues.clear();
    _chaoticVolumeValues.clear();
    _resetYLists();
    super.dispose();
  }
}

/// This class holds the property of circular series.
///
/// To render the Circular chart, create an instance of [PieSeries] or
/// [DoughnutSeries] or [RadialBarSeries], and add it to the
/// series collection property of [SfCircularChart]. You can use the radius
/// property to change the diameter of the circular chart for the plot area.
/// Also, explode the circular chart segment by enabling the explode property.
///
/// Provide the options of stroke width, stroke color, opacity, and
/// point color mapper to customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=VJxPp7-2nGk}
abstract class CircularSeries<T, D> extends ChartSeries<T, D> {
  /// Creating an argument constructor of CircularSeries class.
  const CircularSeries({
    super.key,
    super.xValueMapper,
    super.dataLabelMapper,
    super.name,
    super.dataSource,
    super.pointColorMapper,
    super.legendItemText,
    super.sortFieldValueMapper,
    super.enableTooltip = true,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.animationDuration,
    super.initialSelectedDataIndexes,
    this.borderColor = Colors.transparent,
    super.borderWidth,
    super.selectionBehavior,
    super.legendIconType,
    super.opacity,
    super.animationDelay,
    super.sortingOrder,
    this.onCreateRenderer,
    this.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    this.yValueMapper,
    this.pointShaderMapper,
    this.pointRadiusMapper,
    this.startAngle = 0,
    this.endAngle = 360,
    this.radius = '80%',
    this.innerRadius = '50%',
    this.groupTo,
    this.groupMode,
    this.pointRenderMode,
    this.gap = '1%',
    this.cornerStyle = CornerStyle.bothFlat,
    this.onCreateShader,
  });

  /// Maps the field name, which will be considered as y-values.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///              ),
  ///           ],
  ///        )
  ///   );
  /// }
  /// class ChartData {
  ///   ChartData(this.xVal, this.yVal);
  ///   final String xVal;
  ///   final int yVal;
  /// }
  /// ```
  final ChartValueMapper<T, num>? yValueMapper;

  /// Returns the shaders to fill each data point.
  ///
  /// The data points of pie, doughnut and radial bar charts can be filled with [gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html)
  /// (linear, radial and sweep gradient) and [image shaders](https://api.flutter.dev/flutter/dart-ui/ImageShader-class.html).
  ///
  /// A shader specified in a data source cell will be applied to that specific
  /// data point. Also, a data point may have a gradient
  /// and another data point may have an image shader.
  ///
  /// The user can also get the data, index, color and rect values of the
  /// specific data point from [ChartShaderMapper] and
  /// can use this method, for creating shaders.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// import 'dart:ui' as ui;
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10,
  ///                     ui.Gradient.radial(Offset(112.4, 140.0), 90, [
  ///                            Colors.pink,
  ///                            Colors.red,
  ///                          ], [
  ///                            0.25,
  ///                          0.5,
  ///                          ]),),
  ///                   ChartData('China', 11,
  ///                     ui.Gradient.sweep(Offset(112.4, 140.0),[
  ///                            Colors.pink,
  ///                            Colors.red,
  ///                          ], [
  ///                            0.25,
  ///                          0.5,
  ///                          ]),),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///                pointShaderMapper:
  ///                  (data, index, color, rect) => data.pointShader,
  ///              ),
  ///           ],
  ///        )
  ///   );
  /// }
  /// class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.pointShader]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final Shader pointShader;
  ///}
  ///```
  final ChartShaderMapper? pointShaderMapper;

  /// Maps the field name, which will be considered for calculating the radius
  /// of all the data points.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10, '50%'),
  ///                   ChartData('China', 11, '55%'),
  ///                   ChartData('Russia', 9, '60%'),
  ///                   ChartData('Germany', 10, '65%'),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///                pointRadiusMapper: (ChartData data, _) => data.radius,
  ///              ),
  ///           ],
  ///        )
  ///    );
  /// }
  /// class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.radius]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final String? radius;
  /// }
  /// ```
  final ChartValueMapper<T, String>? pointRadiusMapper;

  /// Starting angle of the series.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  startAngle: 270,
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final int startAngle;

  /// Ending angle of the series.
  ///
  /// Defaults to `360`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  endAngle: 270,
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final int endAngle;

  /// Radius of the series.
  ///
  /// The value ranges from 0% to 100%.
  ///
  /// Defaults to `80%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  radius: '10%',
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final String radius;

  /// Inner radius of the series.
  ///
  /// The value ranges from 0% to 100%.
  ///
  /// Defaults to `50%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <DoughnutSeries<ChartData, String>>[
  ///                DoughnutSeries<ChartData, String>(
  ///                  innerRadius: '20%',
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final String innerRadius;

  /// Groups the data points of the series based on their index or values.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  groupTo: 4,
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final double? groupTo;

  /// Slice can also be grouped based on the data points value or
  /// based on index.
  ///
  /// Defaults to `CircularChartGroupMode.point`.
  ///
  /// Also refer [CircularChartGroupMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  groupMode: CircularChartGroupMode.value,
  ///                ),
  ///            ],
  ///        )
  ///   );
  /// }
  /// ```
  final CircularChartGroupMode? groupMode;

  /// Defines the painting mode of the data points.
  ///
  /// The data points in pie and doughnut chart can be filled either with solid
  /// colors or with sweep gradient
  /// by using this property.
  ///
  /// * If `PointRenderMode.segment` is specified, the data points are filled
  /// with solid colors from palette
  /// or with the colors mentioned in `pointColorMapping` property.
  /// * If `PointRenderMode.gradient` is specified, a sweep gradient is formed
  /// with the solid colors and fills
  /// the data points.
  ///
  /// _Note:_ This property is applicable only if the `onCreateShader` or
  /// `pointShaderMapper` is null and
  /// not applicable for radial bar series.
  ///
  /// Also refer [PointRenderMode].
  ///
  /// Defaults to `pointRenderMode.segment`.
  final PointRenderMode? pointRenderMode;

  /// Specifies the gap between the radial bars in percentage.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  gap: '10%',
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final String gap;

  /// Specifies the radial bar’s corner type.
  ///
  /// _Note:_ This is applicable only for radial bar series type.
  ///
  /// Defaults to `CornerStyle.bothFlat`.
  ///
  /// Also refer [CornerStyle].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  cornerStyle: CornerStyle.bothCurve,
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final CornerStyle cornerStyle;

  /// Border color of the series.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCircularChart(
  ///     series: <PieSeries<SalesData, String>>[
  ///       PieSeries<SalesData, String>(
  ///         borderColor: Colors.red,
  ///         borderWidth: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color borderColor;

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
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<SalesData, num>>[
  ///                PieSeries<SalesData, num>(
  ///                  onCreateRenderer: (ChartSeries<SalesData, num> series) {
  ///                    return CustomPieSeriesRenderer(
  ///                       series as PieSeries<SalesData,num>);
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// class CustomPieSeriesRenderer extends PieSeriesRenderer<SalesData, num> {
  ///     CustomPieSeriesRenderer(this.series);
  ///     final PieSeries<SalesData, num> series;
  //      custom implementation here...
  /// }
  /// ```
  final ChartSeriesRendererFactory<T, D>? onCreateRenderer;

  /// Triggers when the series renderer is created.
  ///
  /// Using this callback, able to get the [ChartSeriesController] instance,
  /// which is used to access the public methods in the series.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    CircularSeriesController _circularSeriesController;
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <CircularSeries<SalesData, num>>[
  ///                PieSeries<SalesData, num>(
  ///                 onRendererCreated: (CircularSeriesController controller) {
  ///                    _circularSeriesController = controller;
  ///                  },
  ///               ),
  ///           ],
  ///        )
  ///    );
  /// }
  /// ```
  final CircularSeriesRendererCreatedCallback<T, D>? onRendererCreated;

  final CircularShaderCallback? onCreateShader;

  @override
  Widget? childForSlot(SeriesSlot slot) {
    switch (slot) {
      case SeriesSlot.dataLabel:
        return dataLabelSettings.isVisible
            ? CircularDataLabelContainer<T, D>(
                series: this,
                dataSource: dataSource!,
                mapper: dataLabelMapper,
                builder: dataLabelSettings.builder,
                settings: dataLabelSettings)
            : null;

      case SeriesSlot.marker:
        return null;

      case SeriesSlot.trendline:
        return null;
    }
  }

  @override
  CircularSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final CircularSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as CircularSeriesRenderer<T, D>;
    renderer
      ..yValueMapper = yValueMapper
      ..pointShaderMapper = pointShaderMapper
      ..pointRadiusMapper = pointRadiusMapper
      ..startAngle = startAngle
      ..endAngle = endAngle
      ..radius = radius
      ..innerRadius = innerRadius
      ..groupMode = groupMode
      ..groupTo = groupTo
      ..pointRenderMode = pointRenderMode
      ..gap = gap
      ..cornerStyle = cornerStyle
      ..initialSelectedDataIndexes = initialSelectedDataIndexes
      ..onCreateRenderer = onCreateRenderer
      ..onCreateShader = onCreateShader
      ..onRendererCreated = onRendererCreated
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, CircularSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..yValueMapper = yValueMapper
      ..pointShaderMapper = pointShaderMapper
      ..pointRadiusMapper = pointRadiusMapper
      ..startAngle = startAngle
      ..endAngle = endAngle
      ..radius = radius
      ..innerRadius = innerRadius
      ..groupMode = groupMode
      ..groupTo = groupTo
      ..pointRenderMode = pointRenderMode
      ..gap = gap
      ..cornerStyle = cornerStyle
      ..initialSelectedDataIndexes = initialSelectedDataIndexes
      ..onCreateRenderer = onCreateRenderer
      ..onCreateShader = onCreateShader
      ..onRendererCreated = onRendererCreated
      ..borderColor = borderColor;
  }
}

/// We can redraw the series by updating or creating new points by using this
/// controller. If we need to access the redrawing methods
/// in this before we must get the ChartSeriesController
/// onRendererCreated event.
class CircularSeriesController<T, D> {
  /// Creating an argument constructor of CircularSeriesController class.
  CircularSeriesController(this.seriesRenderer);

  /// Used to access the series properties.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: PieSeries<SalesData, num>(
  ///                    onRendererCreated:
  ///                      (CircularSeriesController controller) {
  ///                       _chartSeriesController = controller;
  ///                       // prints series yAxisName
  ///                      print(_chartSeriesController.seriesRenderer
  ///                         .seriesRendererDetails.series.yAxisName);
  ///                    },
  ///                ),
  ///        )
  ///     );
  ///}
  ///```
  late final CircularSeriesRenderer<T, D> seriesRenderer;

  /// Used to process only the newly added, updated and removed data points in a
  /// series, instead of processing all the data points.
  ///
  /// To re-render the chart with modified data points, setState() will be
  /// called. This will render the process and render the chart from scratch.
  /// Thus, the app’s performance will be degraded on continuous update.
  /// To overcome this problem, [updateDataSource] method can be called by
  ///  passing updated data points indexes.
  /// Chart will process only that point and skip various steps like
  /// bounds calculation,
  /// old data points processing, etc. Thus, this will improve
  /// the app’s performance.
  ///
  /// The following are the arguments of this method.
  /// * addedDataIndexes – `List<int>` type – Indexes of newly added data points
  /// in the existing series.
  /// * removedDataIndexes – `List<int>` type – Indexes of removed data points
  /// in the existing series.
  /// * updatedDataIndexes – `List<int>` type – Indexes of updated data points
  /// in the existing series.
  /// * addedDataIndex – `int` type – Index of newly added data point
  /// in the existing series.
  /// * removedDataIndex – `int` type – Index of removed data point
  /// in the existing series.
  /// * updatedDataIndex – `int` type – Index of updated data point
  /// in the existing series.
  ///
  /// Returns `void`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    CircularSeriesController seriesController;
  ///    return Column(
  ///      children: <Widget>[
  ///      Container(
  ///        child: SfCircularChart(
  ///            series: <CircularSeries<SalesData, num>>[
  ///                PieSeries<SalesData, num>(
  ///                   dataSource: chartData,
  ///                    onRendererCreated:
  ///                     (CircularSeriesController controller) {
  ///                       seriesController = controller;
  ///                    },
  ///                ),
  ///              ],
  ///        )
  ///   ),
  ///   Container(
  ///      child: RaisedButton(
  ///           onPressed: () {
  ///           chartData.removeAt(0);
  ///           chartData.add(ChartData(3,23));
  ///           seriesController.updateDataSource(
  ///               addedDataIndexes: <int>[chartData.length -1],
  ///               removedDataIndexes: <int>[0],
  ///           );
  ///      })
  ///   )]
  ///  );
  /// }
  ///```
  void updateDataSource({
    List<int>? addedDataIndexes,
    List<int>? removedDataIndexes,
    List<int>? updatedDataIndexes,
    int addedDataIndex = -1,
    int removedDataIndex = -1,
    int updatedDataIndex = -1,
  }) {
    final RealTimeUpdateMixin<T, D> renderer = seriesRenderer;

    List<int>? effectiveRemovedIndexes;
    List<int>? effectiveAddedIndexes;
    List<int>? effectiveReplacedIndexes;

    if (removedDataIndexes != null) {
      effectiveRemovedIndexes = List<int>.from(removedDataIndexes);
    }

    if (addedDataIndexes != null) {
      effectiveAddedIndexes = List<int>.from(addedDataIndexes);
    }

    if (updatedDataIndexes != null) {
      effectiveReplacedIndexes = List<int>.from(updatedDataIndexes);
    }

    if (removedDataIndex != -1) {
      effectiveRemovedIndexes ??= <int>[];
      effectiveRemovedIndexes.add(removedDataIndex);
    }

    if (addedDataIndex != -1) {
      effectiveAddedIndexes ??= <int>[];
      effectiveAddedIndexes.add(addedDataIndex);
    }

    if (updatedDataIndex != -1) {
      effectiveReplacedIndexes ??= <int>[];
      effectiveReplacedIndexes.add(updatedDataIndex);
    }

    renderer.updateDataPoints(
      effectiveRemovedIndexes,
      effectiveAddedIndexes,
      effectiveReplacedIndexes,
    );
  }

  /// Converts chart data point value to logical pixel value.
  ///
  /// The [pointToPixel] method takes chart data point value as input and
  /// returns logical pixel value.
  ///
  /// _Note_: It returns the data point's center location value.
  ///
  ///```dart
  /// late CircularSeriesController seriesController;
  /// SfCircularChart(
  ///    onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
  ///     ChartPoint<double> chartPoint =
  ///        seriesController.pixelToPoint(args.position);
  ///     Offset value = seriesController.pointToPixel(chartPoint);
  ///     ChartPoint<double> chartPoint1 = seriesController.pixelToPoint(value);
  ///   },
  ///   series: <PieSeries<SalesData, String>>[
  ///     PieSeries<SalesData, String>(
  ///       onRendererCreated: (CircularSeriesController controller) {
  ///         seriesController = controller;
  ///       }
  ///     )
  ///   ]
  /// )
  /// ```

  /// Converts logical pixel value to the data point value.
  ///
  /// The [pixelToPoint] method takes logical pixel value as input and
  /// returns a chart data point.
  ///
  ///```dart
  /// late CircularSeriesController seriesController;
  /// SfCircularChart(
  ///    onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
  ///     ChartPoint<double> chartPoint =
  ///       seriesController.pixelToPoint(args.position);
  ///     Offset value = seriesController.pointToPixel(chartPoint);
  ///   },
  ///   series: <PieSeries<SalesData, String>>[
  ///     PieSeries<SalesData, String>(
  ///       onRendererCreated: (CircularSeriesController controller) {
  ///         seriesController = controller;
  ///       }
  ///     )
  ///   ]
  /// )
  /// ```

  ChartPoint pixelToPoint(Offset position) {
    int pointIndex = -1;
    for (int i = 0; i < seriesRenderer.segments.length; i++) {
      final ChartSegment segment = seriesRenderer.segments[i];
      if (segment.contains(position)) {
        pointIndex = i;
      }
    }
    final dynamic x = seriesRenderer.xValues[pointIndex];
    final num y = seriesRenderer.yValues[pointIndex];
    return ChartPoint<D>(x: x, y: y);
  }
}

/// Creates a series renderer for circular series.
abstract class CircularSeriesRenderer<T, D> extends ChartSeriesRenderer<T, D>
    with SegmentAnimationMixin<T, D>, RealTimeUpdateMixin<T, D> {
  final List<num> yValues = <num>[];
  final List<num> _chaoticYValues = <num>[];
  final List<String> pointRadii = <String>[];
  final List<String> _chaoticPointRadii = <String>[];

  final List<D?> dataLabelValues = <D?>[];
  final List<D?> _chaoticDataLabelValues = <D?>[];

  List<D?> circularXValues = <D?>[];
  List<num> circularYValues = <num>[];
  List<D?> groupingDataLabelValues = <D?>[];

  ChartValueMapper<T, num>? yValueMapper;

  ChartShaderMapper? pointShaderMapper;

  ChartValueMapper<T, String>? pointRadiusMapper;

  CircularSeriesRendererCreatedCallback<T, D>? onRendererCreated;

  CircularSeriesController<T, D> get controller => _controller;
  late final CircularSeriesController<T, D> _controller =
      CircularSeriesController<T, D>(this);

  int get startAngle => _startAngle;
  int _startAngle = 0;
  set startAngle(int value) {
    if (_startAngle != value) {
      _startAngle = value;
      markNeedsLayout();
    }
  }

  int get endAngle => _endAngle;
  int _endAngle = 360;
  set endAngle(int value) {
    if (_endAngle != value) {
      _endAngle = value;
      markNeedsLayout();
    }
  }

  String get radius => _radius;
  String _radius = '80%';
  set radius(String value) {
    if (_radius != value) {
      _radius = value;
      markNeedsLayout();
    }
  }

  String get innerRadius => _innerRadius;
  String _innerRadius = '50%';
  set innerRadius(String value) {
    if (_innerRadius != value) {
      _innerRadius = value;
      markNeedsLayout();
    }
  }

  double? get groupTo => _groupTo;
  double? _groupTo;
  set groupTo(double? value) {
    if (_groupTo != value) {
      _groupTo = value;
      markNeedsLayout();
      markNeedsLegendUpdate();
    }
  }

  CircularChartGroupMode? get groupMode => _groupMode;
  CircularChartGroupMode? _groupMode;
  set groupMode(CircularChartGroupMode? value) {
    if (_groupMode != value) {
      _groupMode = value;
      markNeedsLayout();
      markNeedsLegendUpdate();
    }
  }

  PointRenderMode? get pointRenderMode => _pointRenderMode;
  PointRenderMode? _pointRenderMode;
  set pointRenderMode(PointRenderMode? value) {
    if (_pointRenderMode != value) {
      _pointRenderMode = value;
      markNeedsSegmentsPaint();
    }
  }

  String get gap => _gap;
  String _gap = '1%';
  set gap(String value) {
    if (_gap != value) {
      _gap = value;
      markNeedsLayout();
    }
  }

  CornerStyle get cornerStyle => _cornerStyle;
  CornerStyle _cornerStyle = CornerStyle.bothFlat;
  set cornerStyle(CornerStyle value) {
    if (_cornerStyle != value) {
      _cornerStyle = value;
    }
  }

  Color get borderColor => _borderColor;
  Color _borderColor = Colors.transparent;
  set borderColor(Color value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsSegmentsPaint();
    }
  }

  String get centerX => _centerX;
  String _centerX = '50%';
  set centerX(String value) {
    if (_centerX != value) {
      _centerX = value;
      markNeedsLayout();
    }
  }

  String get centerY => _centerY;
  String _centerY = '50%';
  set centerY(String value) {
    if (_centerY != value) {
      _centerY = value;
      markNeedsLayout();
    }
  }

  double sumOfY = 0.0;
  int totalAngle = 0;
  late double pointStartAngle;
  late double currentRadius;
  late double currentInnerRadius;
  late Offset center;
  late double ringSize;
  double? segmentGap;
  int firstVisibleIndex = 0;

  ChartSeriesRendererFactory<T, D>? onCreateRenderer;

  CircularShaderCallback? get onCreateShader => _onCreateShader;
  CircularShaderCallback? _onCreateShader;
  set onCreateShader(CircularShaderCallback? value) {
    if (_onCreateShader != value) {
      _onCreateShader = value;
      markNeedsLegendUpdate();
      markNeedsSegmentsPaint();
      dataLabelContainer?.refresh();
    }
  }

  // TODO(Preethika): Marked as public to access from pie series.
  ChartShaderDetails createShaderDetails() {
    final Rect innerRect =
        Rect.fromCircle(center: center, radius: currentInnerRadius);
    final Rect outerRect =
        Rect.fromCircle(center: center, radius: currentRadius);
    return ChartShaderDetails(outerRect, innerRect, 'series');
  }

  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (dataLabelContainer != null) dataLabelContainer!,
    ];
  }

  @override
  void attach(PipelineOwner owner) {
    onRendererCreated?.call(controller);
    super.attach(owner);
  }

  void _resetYLists() {
    yValues.clear();
    circularXValues.clear();
    circularYValues.clear();
    groupingDataLabelValues.clear();
  }

  @override
  void _resetDataSourceHolders() {
    _chaoticYValues.clear();
    pointRadii.clear();
    _chaoticDataLabelValues.clear();
    dataLabelValues.clear();
    _resetYLists();
    super._resetDataSourceHolders();
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (yPaths == null) {
      yPaths = <ChartValueMapper<T, num>>[];
      chaoticYLists = <List<num>>[];
      yLists = <List<num>>[];
    }

    if (yValueMapper != null) {
      yPaths.add(yValueMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticYLists?.add(yValues);
      } else {
        chaoticYLists?.add(_chaoticYValues);
        yLists?.add(yValues);
      }
    }

    if (fPaths == null) {
      fPaths = <ChartValueMapper<T, Object>>[];
      chaoticFLists = <List<Object?>>[];
      fLists = <List<Object?>>[];
    }

    _addPointRadiusMapper(fPaths, chaoticFLists, fLists);
    _addDataLabelMapper(fPaths, chaoticFLists, fLists);

    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
    _calculateGroupingValues();
    markNeedsLegendUpdate();
    populateChartPoints();
  }

  void _addPointRadiusMapper(List<ChartValueMapper<T, Object>>? fPaths,
      List<List<Object?>>? chaoticFLists, List<List<Object?>>? fLists) {
    if (fPaths != null && pointRadiusMapper != null) {
      fPaths.add(pointRadiusMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticFLists?.add(pointRadii);
      } else {
        pointRadii.clear();
        chaoticFLists?.add(_chaoticPointRadii);
        fLists?.add(pointRadii);
      }
    }
  }

  void _addDataLabelMapper(List<ChartValueMapper<T, Object>>? fPaths,
      List<List<Object?>>? chaoticFLists, List<List<Object?>>? fLists) {
    if (fPaths != null && dataLabelMapper != null) {
      fPaths.add(dataLabelMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticFLists?.add(dataLabelValues);
      } else {
        dataLabelValues.clear();
        chaoticFLists?.add(_chaoticDataLabelValues);
        fLists?.add(dataLabelValues);
      }
    }
  }

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    if (yLists == null) {
      yLists = <List<num>>[yValues];
      positions = <ChartDataPointType>[ChartDataPointType.y];
    } else {
      yLists.add(yValues);
      positions!.add(ChartDataPointType.y);
    }

    super.populateChartPoints(positions: positions, yLists: yLists);
  }

  @override
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (yPaths == null) {
      yPaths = <ChartValueMapper<T, num>>[];
      chaoticYLists = <List<num>>[];
      yLists = <List<num>>[];
    }

    if (yValueMapper != null) {
      yPaths.add(yValueMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticYLists?.add(yValues);
      } else {
        _resetYLists();
        chaoticYLists?.add(_chaoticYValues);
        yLists?.add(yValues);
      }
    }

    if (fPaths == null) {
      fPaths = <ChartValueMapper<T, Object>>[];
      chaoticFLists = <List<Object?>>[];
      fLists = <List<Object?>>[];
    }

    _addPointRadiusMapper(fPaths, chaoticFLists, fLists);
    _addDataLabelMapper(fPaths, chaoticFLists, fLists);

    super.updateDataPoints(removedIndexes, addedIndexes, replacedIndexes,
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
    _calculateGroupingValues();
  }

  @override
  void performLayout() {
    // Need to recalculate the radius values based on plot area size,
    // and its required to update the segment values in layout.
    // So assigned true here to update the segment values.
    canUpdateOrCreateSegments = true;
    _calculateCircularValues();
    super.performLayout();

    if (dataLabelContainer != null) {
      dataLabelContainer!
        ..renderer = this
        ..xRawValues = circularXValues
        ..xValues = xValues
        ..yLists = <List<num>>[circularYValues]
        ..sortedIndexes = sortedIndexes
        ..animation = dataLabelAnimation
        ..layout(constraints);
    }
  }

  @override
  void onLoadingAnimationUpdate() {
    super.onLoadingAnimationUpdate();
    transformValues();
  }

  @override
  void onRealTimeAnimationUpdate() {
    super.onRealTimeAnimationUpdate();
    transformValues();
  }

  void _calculateGroupingValues() {
    if (groupTo == null || groupMode == null) {
      circularXValues = xRawValues;
      circularYValues = yValues;
      groupingDataLabelValues = dataLabelValues;
      return;
    }

    final List<D?> groupingXValues = <D?>[];
    final List<num> groupingYValues = <num>[];
    final List<D?> groupingLabelValues = <D?>[];
    double sumOfGroup = 0;

    for (int i = 0; i < dataCount; i++) {
      final num yValue = yValues[i];
      if (groupTo != null &&
          ((groupMode == CircularChartGroupMode.point && i >= groupTo!) ||
              (groupMode == CircularChartGroupMode.value &&
                  yValue <= groupTo!))) {
        sumOfGroup += yValue.abs();
      } else {
        groupingXValues.add(xRawValues[i]);
        groupingYValues.add(yValue);
        if (dataLabelValues.isNotEmpty) {
          groupingLabelValues.add(dataLabelValues[i]);
        }
      }
    }

    if (sumOfGroup > 0) {
      groupingXValues.add('Others' as D?);
      groupingYValues.add(sumOfGroup);
      if (dataLabelValues.isNotEmpty) {
        groupingLabelValues.add('Others' as D?);
      }

      _dataCount = groupingXValues.length;
    }
    circularXValues = groupingXValues;
    circularYValues = groupingYValues;
    groupingDataLabelValues = groupingLabelValues;
  }

  void _calculateCircularValues() {
    sumOfY = 0;
    int length = 0;
    firstVisibleIndex = -1;

    for (int i = 0; i < dataCount; i++) {
      bool isVisible = true;
      if (_segments.isNotEmpty && i < _segments.length) {
        isVisible = _segments[i].isVisible;
      }
      firstVisibleIndex =
          firstVisibleIndex == -1 && isVisible ? i : firstVisibleIndex;
      final num yValue = isVisible ? circularYValues[i] : 0;
      length += isVisible ? 1 : 0;
      if (!yValue.isNaN) {
        sumOfY += yValue.abs();
      }
    }

    final int startDegree = _calculateAngle(startAngle);
    int endDegree = _calculateAngle(endAngle);
    endDegree = startDegree == endDegree ? startDegree + 360 : endDegree;
    totalAngle = startDegree > endDegree
        ? (startDegree - 360).abs() + endDegree
        : (startDegree - endDegree).abs();

    pointStartAngle = startDegree.toDouble();
    currentRadius = percentToValue(radius, (min(size.width, size.height)) / 2)!;
    currentInnerRadius = percentToValue(innerRadius, currentRadius)!;
    center = Offset(percentToValue(centerX, size.width)!,
        percentToValue(centerY, size.height)!);

    ringSize = (currentRadius - currentInnerRadius) / length;
    segmentGap = percentToValue(gap, currentRadius - currentInnerRadius);
    firstVisibleIndex = firstVisibleIndex == -1 ? 0 : firstVisibleIndex;
  }

  @override
  @nonVirtual
  Color effectiveColor(int segmentIndex) {
    Color? pointColor;
    if (pointColorMapper != null) {
      pointColor = pointColors[segmentIndex];
    }
    return pointColor ?? palette[segmentIndex % palette.length];
  }

  @override
  List<LegendItem>? buildLegendItems(int index) {
    final List<LegendItem> legendItems = <LegendItem>[];
    final int segmentsCount = segments.length;
    // TODO(Lavanya): Ignore legend item for gap and drop mode.
    for (int i = 0; i < dataCount; i++) {
      final ChartLegendItem legendItem = ChartLegendItem(
        text: circularXValues[i].toString(),
        iconType: toLegendShapeMarkerType(legendIconType, this),
        iconColor: effectiveColor(i),
        shader: _legendIconShaders(i),
        iconBorderWidth: legendIconBorderWidth(),
        series: this,
        seriesIndex: index,
        pointIndex: i,
        imageProvider: legendIconType == LegendIconType.image
            ? parent?.legend?.image
            : null,
        isToggled: i < segmentsCount && !segmentAt(i).isVisible,
        onTap: handleLegendItemTapped,
        onRender: _handleLegendItemCreated,
      );
      legendItems.add(legendItem);
    }
    return legendItems;
  }

  @override
  void handleLegendItemTapped(LegendItem item, bool isToggled) {
    super.handleLegendItemTapped(item, isToggled);

    final ChartLegendItem legendItem = item as ChartLegendItem;
    if (legendItem.pointIndex < segments.length) {
      segmentAt(legendItem.pointIndex).isVisible = !isToggled;
    }

    legendItem.onToggled?.call();
    animationType = AnimationType.realtime;
    canUpdateOrCreateSegments = true;
    markNeedsLayout();
  }

  Shader? _legendIconShaders(int pointIndex) {
    if (parent != null && parent!.legend != null) {
      final Rect legendIconBounds = Rect.fromLTWH(
          0.0, 0.0, parent!.legend!.iconWidth, parent!.legend!.iconHeight);
      if (pointShaderMapper != null) {
        return pointShaderMapper!(dataSource![pointIndex], pointIndex,
            palette[pointIndex % palette.length], legendIconBounds);
      } else if (onCreateShader != null) {
        final ChartShaderDetails details =
            ChartShaderDetails(legendIconBounds, legendIconBounds, 'legend');
        return onCreateShader?.call(details);
      }
    }
    return null;
  }

  @nonVirtual
  int _calculateAngle(int angle) {
    return (angle.abs() > 360 ? angle % 360 : angle) - 90;
  }

  @nonVirtual
  void updateSegmentGradient(ChartSegment segment) {
    if (!segment.isEmpty) {
      if (pointShaderMapper != null) {
        final Shader shader = pointShaderMapper!(
            dataSource![segment.currentSegmentIndex],
            segment.currentSegmentIndex,
            palette[segment.currentSegmentIndex % palette.length],
            Rect.fromCircle(center: center, radius: currentRadius));
        segment.fillPaint.shader = shader;
      } else if (onCreateShader != null) {
        final ChartShaderDetails details = createShaderDetails();
        segment.fillPaint.shader = onCreateShader!(details);
      } else if (pointRenderMode == PointRenderMode.gradient) {
        final List<Color> colors = List<Color>.generate(
            segments.length, (int i) => palette[i % palette.length]);
        final List<double> stops = <double>[];
        num initialStops = 0;
        for (int i = 0; i < segments.length; i++) {
          final double segmentRatio = circularYValues[i] / sumOfY;
          if (stops.isEmpty) {
            initialStops = segmentRatio / 4;
            stops.add(segmentRatio - initialStops);
          } else {
            if (stops.length == 1) {
              stops.add((segmentRatio + stops.last) + initialStops / 1.5);
            } else {
              stops.add(segmentRatio + stops.last);
            }
          }
        }
        final SweepGradient sweep = SweepGradient(
            startAngle: degreeToRadian(startAngle),
            endAngle: degreeToRadian(endAngle),
            colors: colors,
            stops: stops,
            transform: GradientRotation(degreeToRadian(-90)));
        segment.fillPaint.shader = sweep.createShader(
            createShaderDetails().outerRect,
            textDirection: TextDirection.ltr);
      }
    }
  }

  Offset dataLabelPosition(CircularDataLabelBoxParentData current, Size size) {
    final num angle = dataLabelSettings.angle;
    final int pointIndex = current.dataPointIndex;
    Offset labelLocation;
    const int labelPadding = 2;
    TextStyle dataLabelStyle = parent!.themeData!.textTheme.bodySmall!
      ..merge(chartThemeData!.dataLabelTextStyle)
      ..merge(dataLabelSettings.textStyle);
    final CircularChartPoint point = current.point!;
    if (point.isExplode) {
      point.center = calculateExplodingCenter(point.midAngle!,
          point.outerRadius!.toDouble(), point.center!, point.explodeOffset);
    }
    if (point.isVisible && (point.y != 0 || dataLabelSettings.showZeroValue)) {
      dataLabelStyle = dataLabelStyle.copyWith(
          color: dataLabelStyle.color ??
              saturatedTextColor(
                  findThemeColor(this, point, dataLabelSettings)));

      if (dataLabelSettings.labelPosition == ChartDataLabelPosition.inside) {
        labelLocation = calculateOffset(point.midAngle!,
            (point.innerRadius! + point.outerRadius!) / 2, point.center!);
        labelLocation = Offset(
            labelLocation.dx -
                (size.width / 2) +
                (angle == 0 ? 0 : size.width / 2),
            labelLocation.dy -
                (size.height / 2) +
                (angle == 0 ? 0 : size.height / 2));
        point.labelRect = Rect.fromLTWH(
            labelLocation.dx - labelPadding,
            labelLocation.dy - labelPadding,
            size.width + (2 * labelPadding),
            size.height + (2 * labelPadding));
        bool isDataLabelCollide =
            findingCollision(point.labelRect, renderDataLabelRegions);
        if (dataLabelSettings.labelIntersectAction ==
                LabelIntersectAction.hide ||
            dataLabelSettings.overflowMode == OverflowMode.hide) {
          point.isVisible = !isDataLabelCollide;
        }

        if (dataLabelSettings.builder == null) {
          // TODO(Lavanya): Get text from DataLabelBoxParentData;
          String label = point.text!;
          point.overflowTrimmedText = point.overflowTrimmedText ?? label;

          if (dataLabelSettings.overflowMode == OverflowMode.shift) {
            final String labelText = segmentOverflowTrimmedText(
                this,
                point.text!,
                size,
                point,
                point.labelRect,
                center,
                labelLocation,
                dataLabelSettings.overflowMode,
                dataLabelStyle);
            if (labelText.contains('...') || labelText.isEmpty) {
              isDataLabelCollide = true;
              point.renderPosition = ChartDataLabelPosition.outside;
            }
            point.text = isDataLabelCollide ? point.text : labelText;
          } else if (dataLabelSettings.overflowMode == OverflowMode.trim &&
              !point.text!.contains('...')) {
            if (!isDataLabelCollide) {
              point.text = segmentOverflowTrimmedText(
                  this,
                  point.text!,
                  size,
                  point,
                  point.labelRect,
                  center,
                  labelLocation,
                  dataLabelSettings.overflowMode,
                  dataLabelStyle);
              label = point.text!;
              final Size trimmedTextSize = measureText(label, dataLabelStyle);
              labelLocation = calculateOffset(point.midAngle!,
                  (point.innerRadius! + point.outerRadius!) / 2, point.center!);
              labelLocation = Offset(
                  labelLocation.dx -
                      (trimmedTextSize.width / 2) +
                      (angle == 0 ? 0 : trimmedTextSize.width / 2),
                  labelLocation.dy -
                      (trimmedTextSize.height / 2) +
                      (angle == 0 ? 0 : trimmedTextSize.height / 2));
              point.labelLocation = labelLocation;
              point.labelRect = Rect.fromLTWH(
                  labelLocation.dx - labelPadding,
                  labelLocation.dy - labelPadding,
                  trimmedTextSize.width + (2 * labelPadding),
                  trimmedTextSize.height + (2 * labelPadding));
            } else {
              point.isVisible = false;
            }
          }
        }

        if (dataLabelSettings.labelIntersectAction ==
                LabelIntersectAction.shift &&
            isDataLabelCollide &&
            dataLabelSettings.overflowMode != OverflowMode.trim) {
          point.saturationRegionOutside = true;
          point.renderPosition = ChartDataLabelPosition.outside;
          renderOutsideDataLabel(point, size, pointIndex, this, index,
              dataLabelStyle, renderDataLabelRegions);
        } else if (((dataLabelSettings.labelIntersectAction ==
                        LabelIntersectAction.shift &&
                    dataLabelSettings.overflowMode == OverflowMode.none) &&
                isDataLabelCollide &&
                dataLabelSettings.overflowMode != OverflowMode.trim) ||
            (isDataLabelCollide &&
                dataLabelSettings.overflowMode == OverflowMode.shift)) {
          point.saturationRegionOutside = true;
          point.renderPosition = ChartDataLabelPosition.outside;
          renderOutsideDataLabel(point, size, pointIndex, this, index,
              dataLabelStyle, renderDataLabelRegions);
        } else if (!isDataLabelCollide ||
            (dataLabelSettings.labelIntersectAction ==
                    LabelIntersectAction.none &&
                dataLabelSettings.overflowMode == OverflowMode.none)) {
          point.renderPosition = ChartDataLabelPosition.inside;
          // TODO(Lavanya): Apply saturation color with
          //DataLabelRender callback.

          if (!isDataLabelCollide &&
              (dataLabelSettings.labelIntersectAction ==
                      LabelIntersectAction.shift &&
                  dataLabelSettings.overflowMode != OverflowMode.hide)) {
            renderDataLabelRegions.add(point.labelRect);
            point.labelLocation = labelLocation;
          } else if (!isDataLabelCollide &&
              (dataLabelSettings.labelIntersectAction ==
                      LabelIntersectAction.hide ||
                  dataLabelSettings.overflowMode == OverflowMode.hide)) {
            if (point.renderPosition == ChartDataLabelPosition.inside &&
                (dataLabelSettings.overflowMode == OverflowMode.hide)) {
              point.text = segmentOverflowTrimmedText(
                  this,
                  point.text!,
                  size,
                  point,
                  point.labelRect,
                  center,
                  labelLocation,
                  dataLabelSettings.overflowMode,
                  dataLabelStyle);
              // label = point.text!;
            }

            point.labelLocation = labelLocation;
            // TODO(Lavanya): drawLabel method add renderDataLabelRegions.
            if (dataLabelSettings.labelIntersectAction !=
                LabelIntersectAction.shift) {
              renderDataLabelRegions.add(point.labelRect);
            }
          } else {
            point.labelLocation = labelLocation;
            // TODO(Lavanya): drawLabel method add renderDataLabelRegions.
            if (dataLabelSettings.labelIntersectAction !=
                LabelIntersectAction.shift) {
              renderDataLabelRegions.add(point.labelRect);
            }
          }
        }
      } else {
        point.renderPosition = ChartDataLabelPosition.outside;
        dataLabelStyle = dataLabelStyle.copyWith(
            color: dataLabelStyle.color ??
                saturatedTextColor(
                    findThemeColor(this, point, dataLabelSettings)));
        renderOutsideDataLabel(point, size, pointIndex, this, index,
            dataLabelStyle, renderDataLabelRegions);
      }
    } else {
      point.labelRect = Rect.zero;
      point.isVisible = false;
    }

    return point.labelLocation;
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    super.onPaint(context, offset);

    paintDataLabels(context, offset);
  }

  @protected
  void paintDataLabels(PaintingContext context, Offset offset) {
    if (dataLabelContainer != null) {
      context.paintChild(dataLabelContainer!, offset);
    }
  }

  void drawDataLabelWithBackground(
    CircularChartDataLabelPositioned dataLabelPositioned,
    int index,
    Canvas canvas,
    String dataLabel,
    Offset offset,
    int angle,
    TextStyle style,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final SfChartThemeData chartThemeData = parent!.chartThemeData!;
    final ThemeData themeData = parent!.themeData!;
    final ChartSegment segment = segments[index];
    Color surfaceColor = dataLabelSurfaceColor(fillPaint.color, index,
        dataLabelSettings.labelPosition, chartThemeData, themeData, segment);
    TextStyle effectiveTextStyle = saturatedTextStyle(surfaceColor, style);
    final CircularChartPoint point = dataLabelPositioned.point!;
    if (!point.isVisible || !segments[index].isVisible || point.text == '') {
      return;
    }

    if (point.connectorPath != null) {
      // TODO(Lavanya): Recheck here.
      drawConnectorLine(point.connectorPath!, canvas, index);
    }

    if (point.saturationRegionOutside &&
        dataLabelSettings.labelPosition == ChartDataLabelPosition.inside &&
        dataLabelSettings.color == null &&
        !dataLabelSettings.useSeriesColor) {
      if (style.color == Colors.transparent) {
        surfaceColor = dataLabelSurfaceColor(fillPaint.color, index,
            ChartDataLabelPosition.outside, chartThemeData, themeData, segment);
        effectiveTextStyle = saturatedTextStyle(surfaceColor, style);
      }
    }

    // TODO(Lavanya): Handle data label animation.
    final Rect labelRect = point.labelRect;
    canvas.save();
    canvas.translate(labelRect.center.dx, labelRect.center.dy);
    canvas.rotate((angle * pi) / 180);
    canvas.translate(-labelRect.center.dx, -labelRect.center.dy);
    if (dataLabelSettings.borderWidth > 0 &&
        strokePaint.color != Colors.transparent) {
      _drawLabelRect(
          strokePaint,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabelSettings.borderRadius,
          canvas);
    }

    if (fillPaint.color != Colors.transparent) {
      _drawLabelRect(
          fillPaint,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabelSettings.borderRadius,
          canvas);
    }
    canvas.restore();

    drawDataLabel(
        canvas, dataLabel, offset, effectiveTextStyle, dataLabelSettings.angle);
  }

  void drawConnectorLine(Path connectorPath, Canvas canvas, int index) {
    final ConnectorLineSettings line = dataLabelSettings.connectorLineSettings;
    canvas.drawPath(
        connectorPath,
        Paint()
          ..color = line.width <= 0
              ? Colors.transparent
              : line.color ?? segments[index].fillPaint.color
          ..strokeWidth = line.width
          ..style = PaintingStyle.stroke);
  }

  void _drawLabelRect(
          Paint paint, Rect labelRect, double borderRadius, Canvas canvas) =>
      canvas.drawRRect(
          RRect.fromRectAndRadius(labelRect, Radius.circular(borderRadius)),
          paint);

  void drawDataLabel(
      Canvas canvas, String text, Offset point, TextStyle style, int angle,
      [bool? isRtl]) {
    final int maxLines = getMaxLinesContent(text);
    final TextSpan span = TextSpan(text: text, style: style);
    final TextPainter tp = TextPainter(
        text: span,
        textDirection: (isRtl ?? false) ? TextDirection.rtl : TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: maxLines);
    tp.layout();
    canvas.save();
    canvas.translate(point.dx + tp.width / 2, point.dy + tp.height / 2);
    Offset labelOffset = Offset.zero;
    canvas.rotate(degreeToRadian(angle));
    labelOffset = Offset(-tp.width / 2, -tp.height / 2);
    tp.paint(canvas, labelOffset);
    canvas.restore();
  }

  @override
  int viewportIndex(int index, [List<int>? visibleIndexes]) {
    return index;
  }

  @override
  void dispose() {
    renderDataLabelRegions.clear();
    _resetDataSourceHolders();
    super.dispose();
  }
}

abstract class BoxAndWhiskerSeriesRendererBase<T, D>
    extends CartesianSeriesRenderer<T, D>
    with
        SbsSeriesMixin<T, D>,
        ClusterSeriesMixin,
        CartesianRealTimeUpdateMixin<T, D> {
  final List<List<num>> _chaoticYValues = <List<num>>[];
  List<List<num>> yValues = <List<num>>[];

  ChartValueMapper<T, List<num?>>? yValueMapper;

  @override
  void _resetDataSourceHolders() {
    _chaoticYValues.clear();
    yValues.clear();
    super._resetDataSourceHolders();
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    _resetDataSourceHolders();
    if (dataSource == null ||
        dataSource!.isEmpty ||
        xValueMapper == null ||
        yValueMapper == null) {
      return;
    }

    if (fPaths == null) {
      fPaths = <ChartValueMapper<T, Object>>[];
      chaoticFLists = <List<Object?>>[];
      fLists = <List<Object?>>[];
    }
    _addPointColorMapper(fPaths, chaoticFLists, fLists);
    _addSortValueMapper(fPaths, chaoticFLists, fLists);

    final int length = dataSource!.length;
    final int fPathLength = fPaths.length;

    num previousX = double.negativeInfinity;
    num xMinimum = double.infinity;
    num xMaximum = double.negativeInfinity;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;
    final Function(int, D) preferredXValue = _preferredXValue();
    final Function(D?, num) addXValue = _addXValueIntoRawAndChaoticXLists;

    for (int i = 0; i < length; i++) {
      final T current = dataSource![i];
      final D? rawX = xValueMapper!(current, i);
      if (rawX == null) {
        _xNullPointIndexes.add(i);
        continue;
      }

      final num currentX = preferredXValue(i, rawX);
      addXValue(rawX, currentX);
      xMinimum = min(xMinimum, currentX);
      xMaximum = max(xMaximum, currentX);
      if (_hasLinearDataSource) {
        _hasLinearDataSource = currentX >= previousX;
      }

      final List<num?>? yData = yValueMapper!(current, i);
      if (yData == null) {
        _chaoticYValues.add(<num>[]);
      } else {
        num minY = double.infinity;
        num maxY = double.negativeInfinity;
        final List<num> nonNullYValues = <num>[];
        final int yLength = yData.length;
        for (int j = 0; j < yLength; j++) {
          final num? yVal = yData[j];
          if (yVal != null && !yVal.isNaN) {
            nonNullYValues.add(yVal);
            minY = min(minY, yVal);
            maxY = max(maxY, yVal);
          }
        }
        nonNullYValues.sort();
        _chaoticYValues.add(nonNullYValues);
        yMinimum = min(yMinimum, minY);
        yMaximum = max(yMaximum, maxY);
      }

      for (int j = 0; j < fPathLength; j++) {
        final ChartValueMapper<T, Object> fPath = fPaths[j];
        final Object? fValue = fPath(current, i);
        chaoticFLists![j].add(fValue);
      }

      previousX = currentX;
    }

    xMin = xMinimum;
    xMax = xMaximum;
    yMin = yMinimum;
    yMax = yMaximum;
    _dataCount = _chaoticXValues.length;
    _canFindLinearVisibleIndexes = _hasLinearDataSource;
    _doSortingIfNeeded(chaoticYLists, yLists, chaoticFLists, fLists);
    super._calculateSbsInfo();
    populateChartPoints();
    _updateXValuesForCategoryTypeAxes();
  }

  @override
  void _doSortingIfNeeded(
      List<List<num>>? chaoticYLists,
      List<List<num>>? yLists,
      List<List<Object?>>? chaoticFLists,
      List<List<Object?>>? fLists) {
    if (sortingOrder != SortingOrder.none && _chaoticYValues.isNotEmpty) {
      if (_chaoticRawSortValues.isEmpty) {
        if (_chaoticRawXValues.isNotEmpty) {
          _chaoticRawSortValues.addAll(_chaoticRawXValues);
        } else {
          _chaoticRawSortValues.addAll(_chaoticXValues);
        }
      }

      switch (sortingOrder) {
        case SortingOrder.ascending:
          _sortBoxValues(chaoticFLists, fLists);
          break;

        case SortingOrder.descending:
          _sortBoxValues(chaoticFLists, fLists, ascending: false);
          break;

        case SortingOrder.none:
          break;
      }
    } else {
      xValues.clear();
      xValues.addAll(_chaoticXValues);
      xRawValues.clear();
      xRawValues.addAll(_chaoticRawXValues);
      yValues.clear();
      yValues.addAll(_chaoticYValues);
    }
  }

  void _sortBoxValues(
      List<List<Object?>>? chaoticFLists, List<List<Object?>>? fLists,
      {bool ascending = true}) {
    _computeSortedIndexes(ascending);
    if (sortedIndexes.isNotEmpty) {
      final void Function(int index, num xValue) copyX =
          _chaoticRawXValues.isNotEmpty ? _copyXAndRawXValue : _copyXValue;
      final int fLength = fLists!.length;
      final int length = sortedIndexes.length;

      for (int i = 0; i < length; i++) {
        final int sortedIndex = sortedIndexes[i];
        final num xValue = _chaoticXValues[sortedIndex];
        copyX(sortedIndex, xValue);
        yValues.add(_chaoticYValues[sortedIndex]);

        for (int k = 0; k < fLength; k++) {
          final List<Object?> fValues = fLists[k];
          final List<Object?> chaoticFValues = chaoticFLists![k];
          fValues.add(chaoticFValues[sortedIndex]);
        }

        // During sorting, determine data is linear or non-linear for
        // calculating visibleIndexes for proper axis range & segment rendering.
        if (_canFindLinearVisibleIndexes) {
          _canFindLinearVisibleIndexes = isValueLinear(i, xValue, xValues);
        }
      }
    }
  }

  @override
  DoubleRange _calculateYRange({List<List<num>>? yLists}) {
    num minimum = double.infinity;
    num maximum = double.negativeInfinity;
    for (final List<num> yList in _chaoticYValues) {
      for (final num yValue in yList) {
        minimum = min(yMin, yValue);
        maximum = max(yMax, yValue);
      }
    }
    return DoubleRange(minimum, maximum);
  }

  @override
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (dataSource == null ||
        dataSource!.isEmpty ||
        xValueMapper == null ||
        yValueMapper == null) {
      return;
    }

    if (fPaths == null) {
      fPaths = <ChartValueMapper<T, Object>>[];
      chaoticFLists = <List<Object?>>[];
      fLists = <List<Object?>>[];
    }
    _addPointColorMapper(fPaths, chaoticFLists, fLists);
    _addSortValueMapper(fPaths, chaoticFLists, fLists);

    if (removedIndexes != null) {
      _removeDataPoints(removedIndexes, yPaths, chaoticYLists, yLists, fPaths,
          chaoticFLists, fLists);
    }

    if (addedIndexes != null) {
      _addDataPoints(addedIndexes, yPaths, chaoticYLists, yLists, fPaths,
          chaoticFLists, fLists);
    }

    if (replacedIndexes != null) {
      _replaceDataPoints(replacedIndexes, yPaths, chaoticYLists, yLists, fPaths,
          chaoticFLists, fLists);
    }

    // During sorting, the x, y, and feature path values are recalculated.
    // Therefore, it is necessary to clear the old values and update these lists
    // with the newly recalculated values.
    if (sortingOrder != SortingOrder.none) {
      xValues.clear();
      xRawValues.clear();
      yValues.clear();
    }

    _applyEmptyPointModeIfNeeded(_chaoticYValues);
    _doSortingIfNeeded(_chaoticYValues, yLists, chaoticFLists, fLists);
    final DoubleRange xRange = _findMinMaxXRange(xValues);
    final DoubleRange yRange = _findMinMaxYRange(_chaoticYValues);
    _updateAxisRange(
        xRange.minimum, xRange.maximum, yRange.minimum, yRange.maximum);
    computeNonEmptyYValues();
    _populateTrendlineDataSource();
    _updateXValuesForCategoryTypeAxes();

    canUpdateOrCreateSegments = true;
    markNeedsLayout();
  }

  @override
  void _removeDataPoints(
    List<int> indexes,
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ) {
    final int fPathLength = fPaths?.length ?? 0;
    for (final int index in indexes) {
      _removeXValueAt(index);
      _removeRawSortValueAt(index);
      _chaoticYValues.removeAt(index);

      for (int k = 0; k < fPathLength; k++) {
        chaoticFLists![k].removeAt(index);
      }
    }

    _dataCount = _chaoticXValues.length;
    // Collecting previous and next index to update them.
    final List<int> mutableIndexes = _findMutableIndexes(indexes);
    _replaceDataPoints(mutableIndexes, yPaths, chaoticYLists, yLists, fPaths,
        chaoticFLists, fLists);
  }

  @override
  void _addDataPoints(
    List<int> indexes,
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ) {
    final int fPathLength = fPaths?.length ?? 0;
    final Function(int, D) preferredXValue = _preferredXValue();
    final Function(int, D?, num) insertXValue =
        _insertXValueIntoRawAndChaoticXLists;
    final Function(int, D?) insertRawSortValue =
        _insertRawXValueIntoChaoticRawSortValue;

    num xMinimum = double.infinity;
    num xMaximum = double.negativeInfinity;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;

    for (final int index in indexes) {
      final T current = dataSource![index];
      final D? rawX = xValueMapper!(current, index);
      if (rawX == null) {
        _xNullPointIndexes.add(index);
        continue;
      }

      final num currentX = preferredXValue(index, rawX);
      insertXValue(index, rawX, currentX);
      insertRawSortValue(index, rawX);
      xMinimum = min(xMinimum, currentX);
      xMaximum = max(xMaximum, currentX);
      if (_hasLinearDataSource) {
        _hasLinearDataSource = isValueLinear(index, currentX, _chaoticXValues);
      }

      final List<num?>? yData = yValueMapper!(current, index);
      if (yData == null) {
        _chaoticYValues.add(<num>[]);
      } else {
        num minY = double.infinity;
        num maxY = double.negativeInfinity;
        final List<num> nonNullYValues = <num>[];
        final int yLength = yData.length;
        for (int j = 0; j < yLength; j++) {
          final num? yVal = yData[j];
          if (yVal != null && !yVal.isNaN) {
            nonNullYValues.add(yVal);
            minY = min(minY, yVal);
            maxY = max(maxY, yVal);
          }
        }
        nonNullYValues.sort();
        _chaoticYValues.insert(index, nonNullYValues);
        yMinimum = min(yMinimum, minY);
        yMaximum = max(yMaximum, maxY);
      }

      for (int j = 0; j < fPathLength; j++) {
        final Object? fValue = fPaths![j](current, j);
        chaoticFLists![j].insert(index, fValue);
      }
    }

    _dataCount = _chaoticXValues.length;
    _canFindLinearVisibleIndexes = _hasLinearDataSource;
  }

  @override
  void _replaceDataPoints(
    List<int> indexes,
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ) {
    final Function(int, D) preferredXValue = _preferredXValue();
    final Function(int, D?, num) replaceXValue =
        _updateXValueIntoRawAndChaoticXLists;

    final int fPathLength = fPaths?.length ?? 0;

    for (final int index in indexes) {
      if (index < 0 || index >= dataSource!.length) {
        continue;
      }

      final T current = dataSource![index];
      final D? rawX = xValueMapper!(current, index);
      if (_xNullPointIndexes.contains(index)) {
        _xNullPointIndexes.remove(index);
      }

      if (rawX == null) {
        _xNullPointIndexes.add(index);
        continue;
      }

      final num currentX = preferredXValue(index, rawX);
      replaceXValue(index, rawX, currentX);

      final List<num?>? yData = yValueMapper!(current, index);
      if (yData == null) {
        _chaoticYValues.add(<num>[]);
      } else {
        num minY = double.infinity;
        num maxY = double.negativeInfinity;
        final List<num> nonNullYValues = <num>[];
        final int yLength = yData.length;
        for (int j = 0; j < yLength; j++) {
          final num? yVal = yData[j];
          if (yVal != null && !yVal.isNaN) {
            nonNullYValues.add(yVal);
            minY = min(minY, yVal);
            maxY = max(maxY, yVal);
          }
        }
        nonNullYValues.sort();
        _chaoticYValues[index] = nonNullYValues;
      }

      for (int j = 0; j < fPathLength; j++) {
        chaoticFLists![j][index] = fPaths![j](current, j);
      }
    }
  }

  @override
  Offset _calculateMedianPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.top, size);

      case ChartDataLabelAlignment.middle:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.middle, size);

      case ChartDataLabelAlignment.bottom:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.bottom, size);
    }
  }

  @override
  Offset _calculateDataLabelOpenPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.middle:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.outer, size);

      case ChartDataLabelAlignment.bottom:
        return _calculateYPosition(x, y, ChartDataLabelAlignment.bottom, size);
    }
  }

  @override
  void dispose() {
    _chaoticYValues.clear();
    yValues.clear();
    super.dispose();
  }
}

abstract class HistogramSeriesRendererBase<T, D>
    extends XyDataSeriesRenderer<T, D>
    with SbsSeriesMixin<T, D>, ClusterSeriesMixin, SegmentAnimationMixin<T, D> {
  double? get binInterval => _binInterval;
  double? _binInterval;
  set binInterval(double? value) {
    if (_binInterval != value) {
      _binInterval = value;
      markNeedsLayout();
    }
  }

  bool get showNormalDistributionCurve => _showNormalDistributionCurve;
  bool _showNormalDistributionCurve = false;
  set showNormalDistributionCurve(bool value) {
    if (_showNormalDistributionCurve != value) {
      _showNormalDistributionCurve = value;
      markNeedsLayout();
    }
  }

  Color get curveColor => _curveColor;
  Color _curveColor = Colors.blue;
  set curveColor(Color value) {
    if (_curveColor != value) {
      _curveColor = value;
      markNeedsSegmentsPaint();
    }
  }

  double get curveWidth => _curveWidth;
  double _curveWidth = 2.0;
  set curveWidth(double value) {
    if (_curveWidth != value) {
      _curveWidth = value;
      markNeedsSegmentsPaint();
    }
  }

  List<double>? get curveDashArray => _curveDashArray;
  List<double>? _curveDashArray;
  set curveDashArray(List<double>? value) {
    if (_curveDashArray != value) {
      _curveDashArray = value;
      markNeedsLayout();
    }
  }

  Color get trackBorderColor => _trackBorderColor;
  Color _trackBorderColor = Colors.transparent;
  set trackBorderColor(Color value) {
    if (_trackBorderColor != value) {
      _trackBorderColor = value;
      markNeedsSegmentsPaint();
    }
  }

  Color get trackColor => _trackColor;
  Color _trackColor = Colors.grey;
  set trackColor(Color value) {
    if (_trackColor != value) {
      _trackColor = value;
      markNeedsSegmentsPaint();
    }
  }

  double get trackBorderWidth => _trackBorderWidth;
  double _trackBorderWidth = 1.0;
  set trackBorderWidth(double value) {
    if (_trackBorderWidth != value) {
      _trackBorderWidth = value;
      markNeedsSegmentsPaint();
    }
  }

  double get trackPadding => _trackPadding;
  double _trackPadding = 0.0;
  set trackPadding(double value) {
    if (_trackPadding != value) {
      _trackPadding = value;
      markNeedsLayout();
    }
  }

  bool get isTrackVisible => _isTrackVisible;
  bool _isTrackVisible = false;
  set isTrackVisible(bool value) {
    if (_isTrackVisible != value) {
      _isTrackVisible = value;
      markNeedsLayout();
    }
  }

  BorderRadius get borderRadius => _borderRadius;
  BorderRadius _borderRadius = BorderRadius.zero;
  set borderRadius(BorderRadius value) {
    if (_borderRadius != value) {
      _borderRadius = value;
      markNeedsLayout();
    }
  }

  Color get borderColor => _borderColor;
  Color _borderColor = Colors.transparent;
  set borderColor(Color value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsSegmentsPaint();
    }
  }

  /// It holds the actual Histogram [X] and [Y] values.
  final List<num> _histogramXValues = <num>[];
  final List<num> _histogramYValues = <num>[];

  /// It holds the raw Y value from the [super.yValueMapper].
  final List<num> _yRawValues = <num>[];

  /// It holds actual [_histogramXValues] count.
  int _histoXLength = 0;
  num _deviation = 0.0;
  num _mean = 0.0;
  num binWidth = 0.0;

  final Path _distributionPath = Path();

  void _resetDataHolders() {
    _histoXLength = 0;
    _yRawValues.clear();
    _histogramXValues.clear();
    _histogramYValues.clear();
    _distributionPath.reset();
  }

  @override
  bool _canPopulateDataPoints(
      List<ChartValueMapper<T, num>>? yPaths, List<List<num>>? yLists) {
    return dataSource != null &&
        dataSource!.isNotEmpty &&
        yPaths != null &&
        yPaths.isNotEmpty &&
        yLists != null &&
        yLists.isNotEmpty;
  }

  void _populateDataSource() {
    _resetDataHolders();
    if (dataSource == null ||
        dataSource!.isEmpty ||
        super.yValueMapper == null) {
      return;
    }

    final int length = dataSource!.length;
    for (int i = 0; i < length; i++) {
      final T current = dataSource![i];
      final num? yValue = super.yValueMapper!(current, i);
      if (yValue == null || yValue.isNaN) {
        _yRawValues.add(0);
      } else {
        _yRawValues.add(yValue);
      }
    }

    // Calculate the actual Histogram [X] and [Y] values.
    _calculateStandardDeviation();
    _histoXLength = _histogramXValues.length;
  }

  // Overrided the populateDataSource and used the _histogramXValues length only.
  // Bacause the dataSource count and _histogramXValues count different.
  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    _populateDataSource();

    if (yPaths == null) {
      yPaths = <ChartValueMapper<T, num>>[];
      chaoticYLists = <List<num>>[];
      yLists = <List<num>>[];
    }

    if (yValueMapper != null) {
      yPaths.add(yValueMapper!);
      if (sortingOrder == SortingOrder.none) {
        chaoticYLists?.add(yValues);
      } else {
        chaoticYLists?.add(_chaoticYValues);
        yLists?.add(yValues);
      }
    }

    _resetDataSourceHolders();
    if (!_canPopulateDataPoints(yPaths, chaoticYLists)) {
      return;
    }

    if (fPaths == null) {
      fPaths = <ChartValueMapper<T, Object>>[];
      chaoticFLists = <List<Object?>>[];
      fLists = <List<Object?>>[];
    }
    _addPointColorMapper(fPaths, chaoticFLists, fLists);
    _addSortValueMapper(fPaths, chaoticFLists, fLists);

    final int length = dataSource!.length;
    final int yPathLength = yPaths.length;
    final int fPathLength = fPaths.length;

    num xMinimum = double.infinity;
    num xMaximum = double.negativeInfinity;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;
    final Function(int, D) preferredXValue = _preferredXValue();
    final Function(D?, num) addXValue = _addXValueIntoRawAndChaoticXLists;

    for (int i = 0; i < _histoXLength; i++) {
      final D rawX = _histogramXValues[i] as D;
      final num currentX = preferredXValue(i, rawX);
      addXValue(rawX, currentX);
      xMinimum = min(xMinimum, currentX);
      xMaximum = max(xMaximum, currentX);

      for (int j = 0; j < yPathLength; j++) {
        final num yValue = _histogramYValues[i];
        chaoticYLists![j].add(yValue);
        yMinimum = min(yMinimum, yValue);
        yMaximum = max(yMaximum, yValue);
      }

      final int curIndex = i >= length ? length - 1 : i;
      final T current = dataSource![curIndex];
      for (int j = 0; j < fPathLength; j++) {
        final ChartValueMapper<T, Object> fPath = fPaths[j];
        final Object? fValue = fPath(current, i);
        chaoticFLists![j].add(fValue);
      }
    }

    xMin = xMinimum;
    xMax = xMaximum;
    yMin = yMinimum;
    yMax = yMaximum;
    _dataCount = _chaoticXValues.length;
    _canFindLinearVisibleIndexes = true;

    _copyXAndRawXValues();
    computeNonEmptyYValues();
    _populateTrendlineDataSource();
    if (dataCount < 1) {
      return;
    }

    super._calculateSbsInfo();
  }

  void _copyXAndRawXValues() {
    xValues.clear();
    xValues.addAll(_chaoticXValues);
    xRawValues.clear();
    xRawValues.addAll(_chaoticRawXValues);
  }

  @override
  void computeNonEmptyYValues() {
    nonEmptyYValues.clear();
    nonEmptyYValues.addAll(yValues);
  }

  void _calculateStandardDeviation() {
    if (_yRawValues.isEmpty) {
      return;
    }

    num sumOfY = 0;
    num sumValue = 0;
    _mean = 0;
    final num yLength = _yRawValues.length;
    for (int i = 0; i < yLength; i++) {
      final num yValue = _yRawValues[i];
      sumOfY += yValue;
      _mean = sumOfY / yLength;
    }

    for (int i = 0; i < yLength; i++) {
      final num yValue = _yRawValues[i];
      sumValue += (yValue - _mean) * (yValue - _mean);
    }

    _deviation = sqrt(sumValue / (yLength - 1));
    num minValue = _yRawValues.reduce(min);
    binWidth = binInterval ?? (3.5 * _deviation) / pow(yLength, 1 / 3);

    for (int i = 0; i < yLength;) {
      final num count = _yRawValues
          .where((num y) => y >= minValue && y < (minValue + binWidth))
          .length;
      if (count >= 0) {
        _histogramYValues.add(count);
        final num x = minValue + binWidth / 2;
        _histogramXValues.add(x);
        minValue += binWidth;
        i += count as int;
      }
    }
  }

  @override
  num trackballYValue(int index) => _histogramYValues[index];

  @override
  void onLoadingAnimationUpdate() {
    super.onLoadingAnimationUpdate();
    transformValues();
  }

  @override
  void transformValues() {
    super.transformValues();
    _createNormalDistributionPath();
  }

  void _createNormalDistributionPath() {
    if (!showNormalDistributionCurve ||
        xAxis == null ||
        yAxis == null ||
        segments.isEmpty ||
        xAxis!.visibleRange == null ||
        yAxis!.visibleRange == null) {
      return;
    }

    _distributionPath.reset();
    final int dataCount = _yRawValues.length;
    // TODO(Natrayansf): Add comment.
    const num pointsCount = 500;
    final num minimum = xAxis!.visibleRange!.minimum;
    final num maximum = xAxis!.visibleRange!.maximum;
    final num delta = (maximum - minimum) / (pointsCount - 1);

    for (int i = 0; i < pointsCount; i++) {
      final num xValue = minimum + i * delta;
      final num yValue =
          exp(-pow(xValue - _mean, 2) / (2 * pow(_deviation, 2))) /
              (_deviation * sqrt(2 * pi));
      final num dx = yValue * binWidth * dataCount;
      final double x = pointToPixelX(xValue, dx);
      final double y = pointToPixelY(xValue, dx);
      i == 0 ? _distributionPath.moveTo(x, y) : _distributionPath.lineTo(x, y);
    }
  }

  @override
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    // For Histogram series, it is not possible to add, remove, or replace
    // a data point based on the indexes, because the xValues and yValues are
    // calculated based on the entire range of data. Therefore, we need to
    // re-calculate the histogram x and y values dynamically.
    // To achieve this, we directly call the markNeedsUpdate() method.
    canUpdateOrCreateSegments = true;
    markNeedsUpdate();
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    paintSegments(context, offset);
    if (showNormalDistributionCurve) {
      context.canvas.save();
      final Rect clip = clipRect(paintBounds, segmentAnimationFactor,
          isInversed: xAxis!.isInversed, isTransposed: isTransposed);
      context.canvas.clipRect(clip);
      final Paint strokePaint = Paint()
        ..color = curveColor
        ..strokeWidth = curveWidth
        ..style = PaintingStyle.stroke;
      curveDashArray == null
          ? context.canvas.drawPath(_distributionPath, strokePaint)
          : drawDashes(context.canvas, curveDashArray, strokePaint,
              path: _distributionPath);
    }
    context.canvas.restore();
    paintMarkers(context, offset);
    paintDataLabels(context, offset);
    paintTrendline(context, offset);
  }

  @override
  void dispose() {
    _resetDataHolders();
    super.dispose();
  }
}
