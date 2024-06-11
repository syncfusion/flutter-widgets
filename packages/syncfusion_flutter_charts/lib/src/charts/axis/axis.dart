import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../base.dart';
import '../common/callbacks.dart';
import '../common/core_tooltip.dart';
import '../common/interactive_tooltip.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'category_axis.dart';
import 'datetime_category_axis.dart';
import 'logarithmic_axis.dart';
import 'multi_level_labels.dart';
import 'plot_band.dart';

typedef _AlignLabel = double Function(double position, AxisLabel label);

/// This class holds the properties of [ChartAxis].
///
/// Charts typically have two axes that are used to measure and
/// categorize data: a vertical (Y) axis, and a horizontal (X) axis.
/// Vertical(Y) axis always uses a numerical scale. Horizontal(X) axis
/// supports Category, Numeric, Date-time, Logarithmic.
///
/// Provides the options for plotOffset, series visible, axis title,
/// label padding, and alignment to customize the appearance.
abstract class ChartAxis extends LeafRenderObjectWidget {
  /// Creating an argument constructor of [ChartAxis] class.
  const ChartAxis({
    Key? key,
    this.name,
    this.plotOffset = 0,
    this.isVisible = true,
    this.anchorRangeToVisiblePoints = true,
    this.title = const AxisTitle(),
    this.axisLine = const AxisLine(),
    this.rangePadding = ChartRangePadding.auto,
    this.labelRotation = 0,
    this.labelPosition = ChartDataLabelPosition.outside,
    this.labelAlignment = LabelAlignment.center,
    this.tickPosition = TickPosition.outside,
    this.majorTickLines = const MajorTickLines(),
    this.minorTickLines = const MinorTickLines(),
    this.labelStyle,
    this.labelIntersectAction = AxisLabelIntersectAction.hide,
    this.desiredIntervals,
    this.majorGridLines = const MajorGridLines(),
    this.minorGridLines = const MinorGridLines(),
    this.maximumLabels = 3,
    this.minorTicksPerInterval = 0,
    this.isInversed = false,
    this.opposedPosition = false,
    this.edgeLabelPlacement = EdgeLabelPlacement.none,
    this.enableAutoIntervalOnZooming = true,
    this.initialZoomFactor = 1,
    this.initialZoomPosition = 0,
    this.interactiveTooltip = const InteractiveTooltip(),
    this.interval,
    this.crossesAt,
    this.associatedAxisName,
    this.placeLabelsNearAxisLine = true,
    this.plotBands = const <PlotBand>[],
    this.rangeController,
    this.maximumLabelWidth,
    this.labelsExtent,
    this.autoScrollingDelta,
    this.autoScrollingMode = AutoScrollingMode.end,
    this.borderWidth = 0.0,
    this.borderColor,
    this.axisBorderType = AxisBorderType.rectangle,
    this.multiLevelLabelStyle = const MultiLevelLabelStyle(),
    this.multiLevelLabelFormatter,
    this.axisLabelFormatter,
  }) : super(key: key);

  /// Toggles the visibility of the axis.
  ///
  /// Visibility of all the elements in the axis
  /// such as title, labels, major tick lines, and major grid lines
  /// will be toggled together.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(isVisible: false),
  ///         )
  ///     );
  /// }
  /// ```
  final bool isVisible;

  /// Determines the value axis range, based on the visible data points or based
  /// on the overall data points available in chart.
  ///
  /// By default, value axis range will be calculated automatically based on the
  /// visible data points on dynamic changes. The visible data points are
  /// changed on performing interactions like pinch
  /// zooming, selection zooming, panning and also on specifying
  /// `visibleMinimum` and `visibleMaximum` values.
  ///
  /// To toggle this functionality, this property can be used. i.e. on setting
  /// false to this property, value axis range will be calculated based on all
  /// the data points in chart irrespective of visible points.
  ///
  /// _Note:_ This is applicable only to the value axis and not for other axis.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryYAxis: NumericAxis(anchorRangeToVisiblePoints: false),
  ///         )
  ///     );
  /// }
  /// ```
  final bool anchorRangeToVisiblePoints;

  /// Customizes the appearance of the axis line. The axis line is
  /// visible by default.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(axisLine: AxisLine(width: 10)),
  ///         )
  ///     );
  /// }
  /// ```
  final AxisLine axisLine;

  /// Customizes the appearance of the major tick lines.
  ///
  /// Major ticks are small lines used to indicate the intervals in an axis.
  /// Major tick lines are visible by default.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis:
  ///              NumericAxis(majorTickLines: const MajorTickLines(width: 2)),
  ///         )
  ///     );
  /// }
  /// ```
  final MajorTickLines majorTickLines;

  /// Customizes the appearance of the minor tick lines.
  ///
  /// Minor ticks are small lines
  /// used to indicate the minor intervals between a major interval.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis:
  ///              NumericAxis(minorTickLines: MinorTickLines(width: 2)),
  ///         )
  ///     );
  /// }
  /// ```
  final MinorTickLines minorTickLines;

  /// Customizes the appearance of the major grid lines.
  ///
  /// Major grids are the lines
  /// drawn on the plot area at all the major intervals in an axis.
  /// Major grid lines are visible by default.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis:
  ///              NumericAxis(majorGridLines: MajorGridLines(width: 2)),
  ///         )
  ///     );
  /// }
  /// ```
  final MajorGridLines majorGridLines;

  /// Customizes the appearance of the minor grid lines.
  ///
  /// Minor grids are the lines drawn
  /// on the plot area at all the minor intervals between the major intervals.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis:
  ///              NumericAxis(minorGridLines: MinorGridLines(width: 2)),
  ///         )
  ///     );
  /// }
  /// ```
  final MinorGridLines minorGridLines;

  /// Customizes the appearance of the axis labels.
  ///
  /// Labels are the axis values
  /// placed at each interval. Axis labels are visible by default.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis:
  ///              NumericAxis(labelStyle: TextStyle(color: Colors.black)),
  ///         )
  ///     );
  /// }
  /// ```
  final TextStyle? labelStyle;

  /// Customizes the appearance of the axis title.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(title: AxisTitle( text: 'Year')),
  ///         )
  ///     );
  /// }
  /// ```
  final AxisTitle title;

  /// Padding for minimum and maximum values in an axis.
  ///
  /// Various types of range padding
  /// such as round, none, normal, and additional can be applied.
  ///
  /// Defaults to `ChartRangePadding.auto`.
  ///
  /// Also refer [ChartRangePadding].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis:
  ///              NumericAxis(rangePadding:  ChartRangePadding.round),
  ///         )
  ///     );
  /// }
  /// ```
  final ChartRangePadding rangePadding;

  /// The number of intervals in an axis.
  ///
  /// By default, the number of intervals is calculated based on the minimum
  /// and maximum values and the axis width and height.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(desiredIntervals: 2),
  ///         )
  ///     );
  /// }
  /// ```
  final int? desiredIntervals;

  /// The maximum number of labels to be displayed in an axis in
  /// 100 logical pixels.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(maximumLabels: 4),
  ///         )
  ///     );
  /// }
  /// ```
  final int maximumLabels;

  /// Interval of the minor ticks.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(minorTicksPerInterval: 2),
  ///         )
  ///      );
  /// }
  /// ```
  final int minorTicksPerInterval;

  /// Angle for axis labels.
  /// The axis labels can be rotated to any angle.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(labelRotation: 90),
  ///         )
  ///     );
  /// }
  /// ```
  final int labelRotation;

  /// Axis labels intersecting action.
  ///
  /// Various actions such as hide, trim, wrap, rotate
  /// 90 degree, rotate 45 degree, and placing the labels in multiple rows can
  /// be handled when the axis labels collide with each other.
  ///
  /// Defaults to `AxisLabelIntersectAction.hide`.
  ///
  /// Also refer [AxisLabelIntersectAction].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis:
  ///  NumericAxis(labelIntersectAction: AxisLabelIntersectAction.multipleRows),
  ///        )
  ///    );
  /// }
  /// ```
  final AxisLabelIntersectAction labelIntersectAction;

  /// Opposes the axis position.
  ///
  /// An axis can be placed at the opposite side of its default position.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(opposedPosition: true),
  ///         )
  ///     );
  /// }
  /// ```
  final bool opposedPosition;

  /// Inverts the axis.
  ///
  /// Axis is rendered from the minimum value to maximum value by
  /// default, and it can be inverted to render the axis from the maximum value
  /// to minimum value.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(isInversed: true),
  ///         )
  ///      );
  /// }
  /// ```
  final bool isInversed;

  /// Position of the labels.
  ///
  /// Axis labels can be placed either inside or
  /// outside the plot area.
  ///
  /// Defaults to `ChartDataLabelPosition.outside`.
  ///
  /// Also refer [ChartDataLabelPosition].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis:
  ///              NumericAxis(labelPosition: ChartDataLabelPosition.inside),
  ///         )
  ///     );
  /// }
  /// ```
  final ChartDataLabelPosition labelPosition;

  /// Alignment of the labels.
  ///
  /// Axis labels can be placed either to the start,
  /// end or center of the grid lines.
  ///
  /// Defaults to `LabelAlignment.start`.
  ///
  /// Also refer [LabelAlignment].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(labelAlignment: LabelAlignment.start),
  ///         )
  ///     );
  /// }
  /// ```
  final LabelAlignment labelAlignment;

  /// Position of the tick lines.
  ///
  /// Tick lines can be placed either inside or
  /// outside the plot area.
  ///
  /// Defaults to `TickPosition.outside`.
  ///
  /// Also refer [TickPosition].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(tickPosition: TickPosition.inside),
  ///         )
  ///     );
  /// }
  /// ```
  final TickPosition tickPosition;

  /// Position of the edge labels.
  ///
  /// The edge labels in an axis can be hidden or shifted
  /// inside the axis bounds.
  ///
  /// Defaults to `EdgeLabelPlacement.none`.
  ///
  /// Also refer [EdgeLabelPlacement].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis:
  ///              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
  ///         )
  ///     );
  /// }
  /// ```
  final EdgeLabelPlacement edgeLabelPlacement;

  /// Axis interval value.
  ///
  /// Using this, the axis labels can be displayed after
  /// certain interval value. By default, interval will be
  /// calculated based on the minimum and maximum values of the provided data.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(interval: 1),
  ///         )
  ///     );
  /// }
  /// ```
  final double? interval;

  /// Padding for plot area. The axis is rendered in chart with padding.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(plotOffset: 60),
  ///         )
  ///     );
  /// }
  /// ```
  final double plotOffset;

  /// Name of an axis.
  ///
  /// A unique name further used for linking the series to this
  /// appropriate axis.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(name: 'primaryXAxis'),
  ///         )
  ///      );
  /// }
  /// ```
  final String? name;

  /// Defines the percentage of the visible range from the total range of axis values.
  /// It applies only during load time and the value will not be updated when zooming or panning.
  ///
  /// Scale the axis based on this value, and it ranges
  /// from 0 to 1.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(initialZoomFactor: 0.5),
  ///         )
  ///     );
  /// }
  /// ```
  ///
  /// Use the onRendererCreated callback, as shown in the code below, to update the zoom
  /// factor value dynamically.
  ///
  /// ```dart
  /// NumericAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             initialZoomFactor: 0.5,
  ///             onRendererCreated: (NumericAxisController controller) {
  ///               axisController = controller;
  ///             },
  ///           ),
  ///           series: <CartesianSeries<SalesData, num>>[
  ///             LineSeries<SalesData, num>(
  ///               dataSource: data,
  ///               xValueMapper: (_SalesData sales, _) => sales.year,
  ///               yValueMapper: (_SalesData sales, _) => sales.sales,
  ///             ),
  ///           ],
  ///         ),
  ///         TextButton(
  ///           onPressed: () {
  ///             if (axisController != null) {
  ///              axisController!.zoomFactor = 0.3;
  ///            }
  ///           },
  ///           child: const Text('Update ZoomFactor'),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final double initialZoomFactor;

  /// Defines the zoom position for the actual range of the axis.
  /// It applies only during load time and the value will not be updated when zooming or panning.
  ///
  /// The value ranges from 0 to 1.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(initialZoomPosition: 0.6),
  ///         )
  ///     );
  /// }
  /// ```
  ///
  /// Use the onRendererCreated callback, as shown in the code below, to update the zoom
  /// position value dynamically.
  ///
  /// ```dart
  /// NumericAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             initialZoomPosition: 0.6,
  ///             onRendererCreated: (NumericAxisController controller) {
  ///               axisController = controller;
  ///             },
  ///           ),
  ///           series: <CartesianSeries<SalesData, num>>[
  ///             LineSeries<SalesData, num>(
  ///               dataSource: data,
  ///               xValueMapper: (_SalesData sales, _) => sales.year,
  ///               yValueMapper: (_SalesData sales, _) => sales.sales,
  ///             ),
  ///           ],
  ///         ),
  ///         TextButton(
  ///           onPressed: () {
  ///             if (axisController != null) {
  ///              axisController!.zoomPosition = 0.2;
  ///            }
  ///           },
  ///           child: const Text('Update ZoomPosition'),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final double initialZoomPosition;

  /// Enables or disables the automatic interval while zooming.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(enableAutoIntervalOnZooming: true),
  ///         )
  ///     );
  /// }
  /// ```
  final bool enableAutoIntervalOnZooming;

  /// Customizes the crosshair and selection zooming tooltip. Tooltip displays
  /// the current axis value based on the crosshair position/selectionZoomRect
  /// position at an axis.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis:
  ///         NumericAxis(interactiveTooltip: InteractiveTooltip(enable: true)),
  ///         )
  ///     );
  /// }
  /// ```
  final InteractiveTooltip interactiveTooltip;

  /// Customization to place the axis crossing on another axis based
  /// on the value.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(crossesAt:10),
  ///         )
  ///     );
  /// }
  /// ```
  final dynamic crossesAt;

  /// Axis line crossed on mentioned axis name,
  /// and applicable for plot band also.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                associatedAxisName: 'primaryXAxis',
  ///                plotBands: <PlotBand>[
  ///                    PlotBand(
  ///                       start: 2,
  ///                       end: 5,
  ///                       associatedAxisStart: 2,
  ///                       ),
  ///                   ],
  ///              ),
  ///         )
  ///     );
  /// }
  /// ```
  final String? associatedAxisName;

  /// Consider to place the axis label respect to near axis line.
  ///
  /// Defaults to `true`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis:
  ///              NumericAxis(placeLabelsNearAxisLine: false, crossesAt:10),
  ///         )
  ///     );
  /// }
  /// ```
  final bool placeLabelsNearAxisLine;

  /// Render the plot band in axis.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///              plotBands:
  ///  <PlotBand>[PlotBand(start:20, end:30, color:Colors.red, text:'Flutter')]
  ///                ),
  ///         )
  ///     );
  /// }
  /// ```
  final List<PlotBand> plotBands;

  /// The `rangeController` property is used to set the maximum and minimum
  /// values for the chart in the viewport. In the minimum and maximum
  /// properties of the axis, you can specify the minimum and maximum values
  /// with respect to the entire data source. In the visibleMinimum and
  /// visibleMaximum properties, you can specify the values to be viewed in the
  /// viewed port i.e. range controller's start and end values respectively.
  ///
  /// Here you need to specify the `minimum`, `maximum`, `visibleMinimum`,
  /// and `visibleMaximum` properties to the axis and the axis values will be
  /// visible with respect to visibleMinimum and visibleMaximum properties.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   RangeController rangeController = RangeController(
  ///     start: DateTime(2020, 2, 1),
  ///     end: DateTime(2020, 2, 30),
  ///   );
  ///   SfCartesianChart sliderChart = SfCartesianChart(
  ///     margin: const EdgeInsets.all(0),
  ///     primaryXAxis:
  ///         DateTimeAxis(isVisible: false),
  ///     primaryYAxis: NumericAxis(isVisible: false),
  ///     plotAreaBorderWidth: 0,
  ///     series: <SplineAreaSeries<ChartSampleData, DateTime>>[
  ///       SplineAreaSeries<ChartSampleData, DateTime>(
  ///         //  Add required properties.
  ///       )
  ///     ],
  ///   );
  ///   return Scaffold(
  ///     body: Column(
  ///       children: <Widget>[
  ///         Expanded(
  ///           child: SfCartesianChart(
  ///             primaryXAxis: DateTimeAxis(
  ///                 maximum: DateTime(2020, 1, 1),
  ///                 minimum: DateTime(2020, 3, 30),
  ///                 // set maximum value from the range controller
  ///                 visibleMaximum: rangeController.end,
  ///                 // set minimum value from the range controller
  ///                 visibleMinimum: rangeController.start,
  ///                 rangeController: rangeController),
  ///             primaryYAxis: NumericAxis(),
  ///             series: <SplineSeries<ChartSampleData, DateTime>>[
  ///               SplineSeries<ChartSampleData, DateTime>(
  ///                 dataSource: splineSeriesData,
  ///                 xValueMapper: (ChartSampleData sales, _) =>
  ///                     sales.x as DateTime,
  ///                 yValueMapper: (ChartSampleData sales, _) => sales.y,
  ///                 //  Add required properties.
  ///               )
  ///             ],
  ///           ),
  ///         ),
  ///         Expanded(
  ///             child: SfRangeSelectorTheme(
  ///           data: SfRangeSelectorThemeData(),
  ///           child: SfRangeSelector(
  ///             min: min,
  ///             max: max,
  ///             controller: rangeController,
  ///             showTicks: true,
  ///             showLabels: true,
  ///             dragMode: SliderDragMode.both,
  ///             onChanged: (SfRangeValues value) {
  ///               // set the start value to rangeController from this callback
  ///               rangeController.start = value.start;
  ///               // set the end value to rangeController from this callback
  ///               rangeController.end = value.end;
  ///               setState(() {});
  ///             },
  ///             child: Container(
  ///               child: sliderChart,
  ///             ),
  ///           ),
  ///         )),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final RangeController? rangeController;

  /// Specifies maximum text width for axis labels.
  ///
  /// If an axis label exceeds the specified width, it will get trimmed and
  /// ellipse(...) will be added at the end of the trimmed text. By default,
  // the labels will not be trimmed.
  ///
  /// Complete label text will be shown in a tooltip when tapping/clicking over
  /// the trimmed axis labels.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: CategoryAxis(maximumLabelWidth: 80),
  ///            series: [
  ///              BarSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                  ChartData(x: 'Goldin Finance 117', y: 597),
  ///                  ChartData(x: 'Ping An Finance Center', y: 599),
  ///                  ChartData(x: 'Makkah Clock Royal Tower', y: 601),
  ///                  ChartData(x: 'Shanghai Tower', y: 632),
  ///                  ChartData(x: 'Burj Khalifa', y: 828)
  ///                ],
  ///                xValueMapper: (ChartData sales, _) => sales.x,
  ///                yValueMapper: (ChartData sales, _) => sales.y
  ///              )
  ///            ],
  ///        )
  ///     );
  /// }
  /// ```
  final double? maximumLabelWidth;

  /// Specifies the fixed width for the axis labels. This width represents the
  /// space between axis line and axis title.
  ///
  /// If an axis label exceeds the specified value, as like [maximumLabelWidth]
  /// feature, axis label will get trimmed and ellipse(...) will be added at
  /// the end of the trimmed text.
  ///
  /// Additionally, if an axis label width is within the specified value, white
  /// space will be added at the beginning for remaining width. This is done to
  /// maintain uniform bounds and to eliminate axis label flickering
  /// on zooming/panning.
  ///
  /// Complete label text will be shown in a tooltip when tapping/clicking over
  /// the trimmed axis labels.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: CategoryAxis(labelsExtent: 70),
  ///            series: [
  ///              BarSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                  ChartData(x: 'Goldin Finance 117', y: 597),
  ///                  ChartData(x: 'Ping An Finance Center', y: 599),
  ///                  ChartData(x: 'Makkah Clock Royal Tower', y: 601),
  ///                  ChartData(x: 'Shanghai Tower', y: 632),
  ///                  ChartData(x: 'Burj Khalifa', y: 828)
  ///                ],
  ///                xValueMapper: (ChartData sales, _) => sales.x,
  ///                yValueMapper: (ChartData sales, _) => sales.y
  ///              )
  ///            ],
  ///        )
  ///     );
  /// }
  /// ```
  final double? labelsExtent;

  /// The number of data points to be visible always in the chart.
  ///
  /// For example, if there are 10 data points and `autoScrollingDelta` value
  /// is 5 and [autoScrollingMode] is `AutoScrollingMode.end`, the last 5 data
  /// points will be displayed in the chart and remaining data points can be
  /// viewed by panning the chart from left to right direction. If the
  /// [autoScrollingMode] is `AutoScrollingMode.start`, first 5 points will be
  /// displayed and remaining data points can be viewed by panning the chart
  /// from right to left direction.
  ///
  /// If the data points are less than the specified `autoScrollingDelta` value,
  /// all those data points will be displayed.
  ///
  /// If the axis contains both initialVisibleMinimum or initialVisibleMaximum
  /// and autoScrollingDelta, the autoScrollingDelta will be restricted.
  /// Because both properties tends to define visible the number of data points
  /// in the chart and so initialVisibleMinimum and initialVisibleMaximum
  /// takes priority over autoScrollingDelta.
  ///
  /// It always shows the recently added data points and scrolling will be reset
  /// to the start or end of the range, based on [autoScrollingMode] property's
  /// value, whenever a new point is added dynamically.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///              autoScrollingDelta: 3,
  ///                ),
  ///         )
  ///     );
  /// }
  /// ```
  final int? autoScrollingDelta;

  /// Determines whether the axis should be scrolled from the start position or
  /// end position.
  ///
  /// For example, if there are 10 data points and [autoScrollingDelta] value is
  /// 5 and `AutoScrollingMode.end` is specified to this property, last 5 points
  /// will be displayed in the chart. If `AutoScrollingMode.start`
  /// is set to this property, first 5 points will be displayed.
  ///
  /// Defaults to `AutoScrollingMode.end`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///              autoScrollingMode: AutoScrollingMode.start,
  ///                ),
  ///         )
  ///     );
  /// }
  /// ```
  final AutoScrollingMode autoScrollingMode;

  /// Border color of the axis label.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         borderColor: Colors.black,
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final Color? borderColor;

  /// Border width of the axis label.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         borderWidth: 2,
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// Border type of the axis label.
  ///
  /// Defaults to `AxisBorderType.rectangle`.
  ///
  /// Also refer [AxisBorderType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         axisBorderType: AxisBorderType.withoutTopAndBottom,
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final AxisBorderType axisBorderType;

  /// Customize the multi-level label’s border color, width, type, and
  /// text style such as color, font size, etc.
  ///
  /// When the multi-level label’s width exceeds its respective segment,
  /// then the label will get trimmed and on tapping / hovering over the
  /// trimmed label, a tooltip will be shown.
  ///
  /// Also refer [multiLevelLabelFormatter].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCartesianChart(
  ///        primaryXAxis: NumericAxis(
  ///          multiLevelLabelStyle: MultiLevelLabelStyle(
  ///            borderWidth: 1,
  ///            borderColor: Colors.black,
  ///            borderType: MultiLevelBorderType.rectangle,
  ///            textStyle: TextStyle(
  ///              fontSize: 10,
  ///              color: Colors.black,
  ///            )
  ///          )
  ///        )
  ///      )
  ///    );
  ///  }
  /// ```
  final MultiLevelLabelStyle multiLevelLabelStyle;

  /// Called while rendering each multi-level label.
  ///
  /// Provides label text, the actual level of the label, index, and
  /// text styles such as color, font size, etc using
  /// `MultiLevelLabelRenderDetails` class.
  ///
  /// You can customize the text and text style using `ChartAxisLabel` class
  /// and can return it.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         multiLevelLabelFormatter: (MultiLevelLabelRenderDetails details) {
  ///           if (details.index == 1) {
  ///             return ChartAxisLabel('Text', details.textStyle);
  ///           } else {
  ///             return ChartAxisLabel(details.text, details.textStyle);
  ///           }
  ///         },
  ///         multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 2,
  ///             text: 'First'
  ///           ),
  ///           NumericMultiLevelLabel(
  ///             start: 2,
  ///             end: 4,
  ///             text: 'Second'
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final MultiLevelLabelFormatterCallback? multiLevelLabelFormatter;

  /// Called while rendering each axis label in the chart.
  ///
  /// Provides label text, axis name, orientation of the axis, trimmed text and
  /// text styles such as color, font size, and font weight to the user using
  /// the `AxisLabelRenderDetails` class.
  ///
  /// You can customize the text and text style using the `ChartAxisLabel` class
  /// and can return it.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: CategoryAxis(
  ///                axisLabelFormatter:
  ///                  (AxisLabelRenderDetails details) => axis(details),
  ///             ),
  ///         )
  ///      );
  /// }
  ///
  /// ChartAxisLabel axis(AxisLabelRenderDetails details) {
  ///    return ChartAxisLabel('axis Label', details.textStyle);
  /// }
  /// ```
  final ChartLabelFormatterCallback? axisLabelFormatter;

  @protected
  @factory
  RenderChartAxis createRenderer();

  @mustCallSuper
  @override
  RenderChartAxis createRenderObject(BuildContext context) {
    return createRenderer()
      ..widget = this
      ..isVisible = isVisible
      ..anchorRangeToVisiblePoints = anchorRangeToVisiblePoints
      ..axisLine = axisLine
      ..majorTickLines = majorTickLines
      ..minorTickLines = minorTickLines
      ..majorGridLines = majorGridLines
      ..minorGridLines = minorGridLines
      ..labelStyle = labelStyle
      ..title = title
      ..rangePadding = rangePadding
      ..desiredIntervals = desiredIntervals
      ..maximumLabels = maximumLabels
      ..minorTicksPerInterval = minorTicksPerInterval
      ..labelRotation = labelRotation
      ..labelIntersectAction = labelIntersectAction
      ..opposedPosition = opposedPosition
      ..isInversed = isInversed
      ..labelPosition = labelPosition
      ..labelAlignment = labelAlignment
      ..tickPosition = tickPosition
      ..edgeLabelPlacement = edgeLabelPlacement
      ..interval = interval
      ..plotOffset = plotOffset
      ..name = name
      ..initialZoomFactor = initialZoomFactor
      ..initialZoomPosition = initialZoomPosition
      ..enableAutoIntervalOnZooming = enableAutoIntervalOnZooming
      ..interactiveTooltip = interactiveTooltip
      ..crossesAt = crossesAt
      ..associatedAxisName = associatedAxisName
      ..placeLabelsNearAxisLine = placeLabelsNearAxisLine
      ..plotBands = plotBands
      ..rangeController = rangeController
      ..maximumLabelWidth = maximumLabelWidth
      ..labelsExtent = labelsExtent
      ..autoScrollingDelta = autoScrollingDelta
      ..autoScrollingMode = autoScrollingMode
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..axisBorderType = axisBorderType
      ..multiLevelLabelStyle = multiLevelLabelStyle
      ..multiLevelLabelFormatter = multiLevelLabelFormatter
      ..axisLabelFormatter = axisLabelFormatter
      ..textDirection = Directionality.of(context);
  }

  @mustCallSuper
  @override
  void updateRenderObject(BuildContext context, RenderChartAxis renderObject) {
    renderObject
      ..widget = this
      ..isVisible = isVisible
      ..anchorRangeToVisiblePoints = anchorRangeToVisiblePoints
      ..axisLine = axisLine
      ..majorTickLines = majorTickLines
      ..minorTickLines = minorTickLines
      ..majorGridLines = majorGridLines
      ..minorGridLines = minorGridLines
      ..labelStyle = labelStyle
      ..title = title
      ..rangePadding = rangePadding
      ..desiredIntervals = desiredIntervals
      ..maximumLabels = maximumLabels
      ..minorTicksPerInterval = minorTicksPerInterval
      ..labelRotation = labelRotation
      ..labelIntersectAction = labelIntersectAction
      ..opposedPosition = opposedPosition
      ..isInversed = isInversed
      ..labelPosition = labelPosition
      ..labelAlignment = labelAlignment
      ..tickPosition = tickPosition
      ..edgeLabelPlacement = edgeLabelPlacement
      ..interval = interval
      ..plotOffset = plotOffset
      ..name = name
      ..enableAutoIntervalOnZooming = enableAutoIntervalOnZooming
      ..interactiveTooltip = interactiveTooltip
      ..crossesAt = crossesAt
      ..associatedAxisName = associatedAxisName
      ..placeLabelsNearAxisLine = placeLabelsNearAxisLine
      ..plotBands = plotBands
      ..rangeController = rangeController
      ..maximumLabelWidth = maximumLabelWidth
      ..labelsExtent = labelsExtent
      ..autoScrollingDelta = autoScrollingDelta
      ..autoScrollingMode = autoScrollingMode
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..axisBorderType = axisBorderType
      ..multiLevelLabelStyle = multiLevelLabelStyle
      ..multiLevelLabelFormatter = multiLevelLabelFormatter
      ..axisLabelFormatter = axisLabelFormatter
      ..textDirection = Directionality.of(context);
  }
}

enum AxisRender { gridLines, underPlotBand, normal, overPlotBand }

abstract class RenderChartAxis extends RenderBox with ChartAreaUpdateMixin {
  final List<AxisDependent> dependents = <AxisDependent>[];
  final List<double> majorTickPositions = <double>[];
  final List<double> minorTickPositions = <double>[];
  final List<double> borderPositions = <double>[];

  late ChartAxis widget;
  // [plotOffset] is excluded from [size].
  late Size _renderSize;
  AxisRender renderType = AxisRender.normal;
  late _AxisRenderer? _renderer = _VerticalAxisRenderer(this);
  List<AxisPlotBand>? visiblePlotBands;
  AnimationController? _animationController;
  CurvedAnimation? _animation;
  AxisLabelIntersectAction effectiveLabelIntersectAction =
      AxisLabelIntersectAction.hide;

  int sbsSeriesCount = 0;
  // Added this property to ensure whether the zooming is progress
  // for update the auto scrolling.
  bool zoomingInProgress = false;
  bool _needsRangeUpdate = true;
  bool _isLayoutPhase = false;
  bool _hasCollidingLabels = false;
  bool _dependentIsStacked100 = false;

  num get visibleInterval => _visibleInterval;
  num _visibleInterval = 1;
  num get actualInterval => _actualInterval;
  num _actualInterval = 1;

  List<AxisLabel> get visibleLabels => _visibleLabels;
  final List<AxisLabel> _visibleLabels = <AxisLabel>[];

  List<AxisMultilevelLabel> get visibleMultilevelLabels =>
      _visibleMultilevelLabels;
  final List<AxisMultilevelLabel> _visibleMultilevelLabels =
      <AxisMultilevelLabel>[];

  ChartAxisController get controller;

  @override
  RenderCartesianAxes? get parent => super.parent as RenderCartesianAxes?;

  bool get canAnimate => parent?.enableAxisAnimation ?? false;

  @protected
  bool hasTrimmedAxisLabel = false;

  DoubleRange? get actualRange => _actualRange;
  DoubleRange? _actualRange;

  DoubleRange? get visibleRange => _visibleRange;
  DoubleRange? _visibleRange;

  DoubleRange? get effectiveVisibleRange =>
      _effectiveVisibleRange ?? _visibleRange;
  DoubleRange? _effectiveVisibleRange;
  DoubleRangeTween? _visibleRangeTween;

  RenderChartAxis? get associatedAxis => _associatedAxis;
  RenderChartAxis? _associatedAxis;
  set associatedAxis(RenderChartAxis? value) {
    if (_associatedAxis != value) {
      _associatedAxis = value;
    }
  }

  SfChartThemeData? get chartThemeData => _chartThemeData;
  SfChartThemeData? _chartThemeData;
  set chartThemeData(SfChartThemeData? value) {
    if (_chartThemeData != value) {
      _chartThemeData = value;
    }
  }

  String? get name => _name;
  String? _name;
  set name(String? value) {
    if (_name != value) {
      _name = value;
    }
  }

  bool get isXAxis => _isXAxis;
  bool _isXAxis = false;
  set isXAxis(bool value) {
    _isXAxis = value;
    _invalidateOrientation();
  }

  bool get isVertical => _isVertical;
  bool _isVertical = true;
  set isVertical(bool value) {
    _isVertical = value;
    if (value) {
      effectiveLabelIntersectAction = AxisLabelIntersectAction.hide;
      if (_renderer is! _VerticalAxisRenderer) {
        _renderer = _VerticalAxisRenderer(this);
      }
    } else {
      effectiveLabelIntersectAction = labelIntersectAction;
      if (_renderer is! _HorizontalAxisRenderer) {
        _renderer = _HorizontalAxisRenderer(this);
      }
    }

    markNeedsLayout();
  }

  bool get isTransposed => _isTransposed;
  bool _isTransposed = false;
  set isTransposed(bool value) {
    if (_isTransposed != value) {
      _isTransposed = value;
      _invalidateOrientation();
      markNeedsLayout();
    }
  }

  bool get isVisible => _isVisible;
  bool _isVisible = true;
  set isVisible(bool value) {
    _isVisible = value;
    markNeedsLayout();
  }

  bool get anchorRangeToVisiblePoints => _anchorRangeToVisiblePoints;
  bool _anchorRangeToVisiblePoints = true;
  set anchorRangeToVisiblePoints(bool value) {
    if (_anchorRangeToVisiblePoints != value) {
      _anchorRangeToVisiblePoints = value;
      markNeedsRangeUpdate();
    }
  }

  bool get enableAutoIntervalOnZooming => _enableAutoIntervalOnZooming;
  bool _enableAutoIntervalOnZooming = true;
  set enableAutoIntervalOnZooming(bool value) {
    if (_enableAutoIntervalOnZooming != value) {
      _enableAutoIntervalOnZooming = value;
      markNeedsLayout();
    }
  }

  AxisLine get axisLine => _axisLine;
  AxisLine _axisLine = const AxisLine();
  set axisLine(AxisLine value) {
    if (_axisLine != value) {
      _axisLine = value;
      markNeedsLayout();
    }
  }

  MajorTickLines get majorTickLines => _majorTickLines;
  MajorTickLines _majorTickLines = const MajorTickLines();
  set majorTickLines(MajorTickLines value) {
    if (_majorTickLines != value) {
      _majorTickLines = value;
      markNeedsLayout();
    }
  }

  MinorTickLines get minorTickLines => _minorTickLines;
  MinorTickLines _minorTickLines = const MinorTickLines();
  set minorTickLines(MinorTickLines value) {
    if (_minorTickLines != value) {
      _minorTickLines = value;
      markNeedsLayout();
    }
  }

  MajorGridLines get majorGridLines => _majorGridLines;
  MajorGridLines _majorGridLines = const MajorGridLines();
  set majorGridLines(MajorGridLines value) {
    if (_majorGridLines != value) {
      _majorGridLines = value;
      markNeedsLayout();
    }
  }

  MinorGridLines get minorGridLines => _minorGridLines;
  MinorGridLines _minorGridLines = const MinorGridLines();
  set minorGridLines(MinorGridLines value) {
    if (_minorGridLines != value) {
      _minorGridLines = value;
      markNeedsLayout();
    }
  }

  TextStyle? get labelStyle => _labelStyle;
  TextStyle? _labelStyle;
  set labelStyle(TextStyle? value) {
    if (_labelStyle != value) {
      _labelStyle = value;
      markNeedsLayout();
    }
  }

  AxisTitle get title => _title;
  AxisTitle _title = const AxisTitle();
  set title(AxisTitle value) {
    if (_title != value) {
      _title = value;
      markNeedsLayout();
    }
  }

  ChartRangePadding get rangePadding => _rangePadding;
  ChartRangePadding _rangePadding = ChartRangePadding.auto;
  set rangePadding(ChartRangePadding value) {
    if (_rangePadding != value) {
      _rangePadding = value;
      markNeedsLayout();
    }
  }

  int? get desiredIntervals => _desiredIntervals;
  int? _desiredIntervals;
  set desiredIntervals(int? value) {
    if (_desiredIntervals != value) {
      _desiredIntervals = value;
      markNeedsLayout();
    }
  }

  int get maximumLabels => _maximumLabels;
  int _maximumLabels = 3;
  set maximumLabels(int value) {
    if (_maximumLabels != value) {
      _maximumLabels = value;
      markNeedsLayout();
    }
  }

  int get minorTicksPerInterval => _minorTicksPerInterval;
  int _minorTicksPerInterval = 0;
  set minorTicksPerInterval(int value) {
    if (_minorTicksPerInterval != value) {
      _minorTicksPerInterval = value;
      markNeedsLayout();
    }
  }

  int get labelRotation => _labelRotation;
  int _labelRotation = 0;
  set labelRotation(int value) {
    if (_labelRotation != value) {
      _labelRotation = value % 360;
      markNeedsLayout();
    }
  }

  AxisLabelIntersectAction get labelIntersectAction => _labelIntersectAction;
  AxisLabelIntersectAction _labelIntersectAction =
      AxisLabelIntersectAction.hide;
  set labelIntersectAction(AxisLabelIntersectAction value) {
    if (_labelIntersectAction != value) {
      _labelIntersectAction = value;
      if (isVertical) {
        effectiveLabelIntersectAction = AxisLabelIntersectAction.hide;
      } else {
        effectiveLabelIntersectAction = labelIntersectAction;
      }
      markNeedsLayout();
    }
  }

  bool get opposedPosition => _opposedPosition;
  bool _opposedPosition = false;
  set opposedPosition(bool value) {
    if (_opposedPosition != value) {
      _opposedPosition = value;
      _invertElementsOrder = value;
      markNeedsLayout();
    }
  }

  bool get invertElementsOrder => _invertElementsOrder;
  bool _invertElementsOrder = false;
  set invertElementsOrder(bool value) {
    if (_invertElementsOrder != value) {
      _invertElementsOrder = value;
      generateMultiLevelLabels();
      updateMultiLevelLabels();
      // Called [preferredSize] to reupdate the label and tick positioning.
      _renderer!._preferredSize(size);
    }
  }

  bool get isInversed => _isInversed;
  bool _isInversed = false;
  set isInversed(bool value) {
    if (_isInversed != value) {
      _isInversed = value;
      markNeedsLayout();
    }
  }

  ChartDataLabelPosition get labelPosition => _labelPosition;
  ChartDataLabelPosition _labelPosition = ChartDataLabelPosition.outside;
  set labelPosition(ChartDataLabelPosition value) {
    if (_labelPosition != value) {
      _labelPosition = value;
      markNeedsLayout();
    }
  }

  LabelAlignment get labelAlignment => _labelAlignment;
  LabelAlignment _labelAlignment = LabelAlignment.center;
  set labelAlignment(LabelAlignment value) {
    if (_labelAlignment != value) {
      _labelAlignment = value;
      markNeedsLayout();
    }
  }

  TickPosition get tickPosition => _tickPosition;
  TickPosition _tickPosition = TickPosition.outside;
  set tickPosition(TickPosition value) {
    if (_tickPosition != value) {
      _tickPosition = value;
      markNeedsLayout();
    }
  }

  EdgeLabelPlacement get edgeLabelPlacement => _edgeLabelPlacement;
  EdgeLabelPlacement _edgeLabelPlacement = EdgeLabelPlacement.none;
  set edgeLabelPlacement(EdgeLabelPlacement value) {
    if (_edgeLabelPlacement != value) {
      _edgeLabelPlacement = value;
      markNeedsLayout();
    }
  }

  double? get interval => _interval;
  double? _interval;
  set interval(double? value) {
    if (_interval != value) {
      assert(value == null || value > 0, 'Interval must be greater than 0');
      _interval = value;
      markNeedsRangeUpdate();
    }
  }

  double get plotOffset => _plotOffset;
  double _plotOffset = 0.0;
  set plotOffset(double value) {
    if (_plotOffset != value) {
      _plotOffset = value;
      markNeedsRangeUpdate();
    }
  }

  double get initialZoomFactor => _initialZoomFactor;
  double _initialZoomFactor = 1;
  set initialZoomFactor(double value) {
    if (_initialZoomFactor != value) {
      _initialZoomFactor = value;
      assert(initialZoomFactor >= 0 && initialZoomFactor <= 1,
          'The initialZoomFactor of the axis should be between 0 and 1');
      controller.zoomFactor = clampDouble(value, 0.0, 1.0);
      markNeedsRangeUpdate();
    }
  }

  double get initialZoomPosition => _initialZoomPosition;
  double _initialZoomPosition = 0.0;
  set initialZoomPosition(double value) {
    if (_initialZoomPosition != value) {
      _initialZoomPosition = value;
      _needsRangeUpdate = true;
      assert(initialZoomPosition >= 0 && initialZoomPosition <= 1,
          'The initialZoomPosition of the axis should be between 0 and 1');
      controller.zoomPosition = clampDouble(value, 0.0, 1.0);
      markNeedsRangeUpdate();
    }
  }

  InteractiveTooltip get interactiveTooltip => _interactiveTooltip;
  InteractiveTooltip _interactiveTooltip = const InteractiveTooltip();
  set interactiveTooltip(InteractiveTooltip value) {
    if (_interactiveTooltip != value) {
      _interactiveTooltip = value;
      markNeedsLayout();
    }
  }

  dynamic get crossesAt => _crossesAt;
  dynamic _crossesAt;
  set crossesAt(dynamic value) {
    if (_crossesAt != value) {
      _crossesAt = value;
      markNeedsLayout();
    }
  }

  String? get associatedAxisName => _associatedAxisName;
  String? _associatedAxisName;
  set associatedAxisName(String? value) {
    if (_associatedAxisName != value) {
      _associatedAxisName = value;
      markNeedsLayout();
    }
  }

  bool get placeLabelsNearAxisLine => _placeLabelsNearAxisLine;
  bool _placeLabelsNearAxisLine = false;
  set placeLabelsNearAxisLine(bool value) {
    if (_placeLabelsNearAxisLine != value) {
      _placeLabelsNearAxisLine = value;
      markNeedsLayout();
    }
  }

  List<PlotBand> get plotBands => _plotBands;
  List<PlotBand> _plotBands = <PlotBand>[];
  set plotBands(List<PlotBand> value) {
    if (_plotBands != value) {
      _plotBands = value;
      markNeedsLayout();
    }
  }

  LabelPlacement get labelPlacement => _labelPlacement;
  LabelPlacement _labelPlacement = LabelPlacement.onTicks;
  set labelPlacement(LabelPlacement value) {
    if (_labelPlacement != value) {
      _labelPlacement = value;
      markNeedsRangeUpdate();
    }
  }

  RangeController? get rangeController => _rangeController;
  RangeController? _rangeController;
  set rangeController(RangeController? value) {
    if (_rangeController != value) {
      _rangeController = value;
      markNeedsRangeUpdate();
    }
  }

  double? get maximumLabelWidth => _maximumLabelWidth;
  double? _maximumLabelWidth;
  set maximumLabelWidth(double? value) {
    if (_maximumLabelWidth != value) {
      _maximumLabelWidth = value;
      assert(maximumLabelWidth != null && maximumLabelWidth! >= 0,
          'maximumLabelWidth must not be negative');
      markNeedsLayout();
    }
  }

  double? get labelsExtent => _labelsExtent;
  double? _labelsExtent;
  set labelsExtent(double? value) {
    if (_labelsExtent != value) {
      _labelsExtent = value;
      assert(labelsExtent == null || labelsExtent! >= 0,
          'labelsExtent must not be negative');
      markNeedsLayout();
    }
  }

  int? get autoScrollingDelta => _autoScrollingDelta;
  int? _autoScrollingDelta;
  set autoScrollingDelta(int? value) {
    if (_autoScrollingDelta != value) {
      _autoScrollingDelta = value;
      markNeedsLayout();
    }
  }

  AutoScrollingMode get autoScrollingMode => _autoScrollingMode;
  AutoScrollingMode _autoScrollingMode = AutoScrollingMode.end;
  set autoScrollingMode(AutoScrollingMode value) {
    if (_autoScrollingMode != value) {
      _autoScrollingMode = value;
      markNeedsLayout();
    }
  }

  Color? get borderColor => _borderColor;
  Color? _borderColor;
  set borderColor(Color? value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsPaint();
    }
  }

  double get borderWidth => _borderWidth;
  double _borderWidth = 0.0;
  set borderWidth(double value) {
    if (_borderWidth != value) {
      _borderWidth = value;
      markNeedsPaint();
    }
  }

  AxisBorderType get axisBorderType => _axisBorderType;
  AxisBorderType _axisBorderType = AxisBorderType.rectangle;
  set axisBorderType(AxisBorderType value) {
    if (_axisBorderType != value) {
      _axisBorderType = value;
      markNeedsLayout();
    }
  }

  MultiLevelLabelStyle get multiLevelLabelStyle => _multiLevelLabelStyle;
  MultiLevelLabelStyle _multiLevelLabelStyle = const MultiLevelLabelStyle();
  set multiLevelLabelStyle(MultiLevelLabelStyle value) {
    if (_multiLevelLabelStyle != value) {
      _multiLevelLabelStyle = value;
      markNeedsLayout();
    }
  }

  MultiLevelLabelFormatterCallback? get multiLevelLabelFormatter =>
      _multiLevelLabelFormatter;
  MultiLevelLabelFormatterCallback? _multiLevelLabelFormatter;
  set multiLevelLabelFormatter(MultiLevelLabelFormatterCallback? value) {
    if (_multiLevelLabelFormatter != value) {
      _multiLevelLabelFormatter = value;
      markNeedsLayout();
    }
  }

  ChartLabelFormatterCallback? get axisLabelFormatter => _axisLabelFormatter;
  ChartLabelFormatterCallback? _axisLabelFormatter;
  set axisLabelFormatter(ChartLabelFormatterCallback? value) {
    if (_axisLabelFormatter != value) {
      _axisLabelFormatter = value;
      markNeedsLayout();
    }
  }

  TextDirection get textDirection => _textDirection;
  late TextDirection _textDirection;
  set textDirection(TextDirection value) {
    _textDirection = value;
    markNeedsLayout();
  }

  double get innerSize => _renderer?.innerSize ?? 0.0;

  double get outerSize => _renderer?.outerSize ?? 0.0;

  void markNeedsRangeUpdate() {
    if (hasSize) {
      _needsRangeUpdate = true;
      if (!_isLayoutPhase) {
        markNeedsUpdate();
      }
    }
  }

  void addDependent(AxisDependent dependent, {bool isXAxis = true}) {
    if (!dependents.contains(dependent)) {
      dependents.add(dependent);
      _needsRangeUpdate = true;
    }

    if (dependent is Stacking100SeriesMixin) {
      _dependentIsStacked100 = true;
    }

    if (this.isXAxis != isXAxis) {
      _needsRangeUpdate = true;
    }

    this.isXAxis = isXAxis;
  }

  void removeDependent(AxisDependent dependent) {
    if (dependents.contains(dependent)) {
      dependents.remove(dependent);
      _needsRangeUpdate = true;
    }
  }

  void _invalidateOrientation() {
    if (isXAxis) {
      isVertical = isTransposed;
    } else {
      isVertical = !isTransposed;
    }
  }

  @override
  void performUpdate() {
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    _animationController = AnimationController(
      vsync: parent!.vsync,
      duration: const Duration(milliseconds: 1000),
      value: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: const Interval(0.1, 0.9, curve: Curves.decelerate),
    );
    _animationController!.addStatusListener(_onAnimationStatusChanged);
    _animation!.addListener(markNeedsRangeUpdate);
    controller
        ._addZoomFactorAndPositionListener(_onZoomFactorAndPositionChanged);
    super.attach(owner);
  }

  void _onZoomFactorAndPositionChanged() {
    associatedAxis?._needsRangeUpdate = true;
    markNeedsRangeUpdate();
  }

  @override
  void detach() {
    _animationController?.removeStatusListener(_onAnimationStatusChanged);
    _animation?.removeListener(markNeedsRangeUpdate);
    controller
        ._removeZoomFactorAndPositionListener(_onZoomFactorAndPositionChanged);
    super.detach();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_visibleRangeTween != null) {
        _visibleRange = _visibleRangeTween!.end;
        _visibleRangeTween = null;
      }
      _effectiveVisibleRange = null;
      controller._handleAnimationCompleted();
    }
  }

  @override
  void performLayout() {
    _isLayoutPhase = true;
    final Size availableSize = constraints.biggest;
    if (_needsRangeUpdate) {
      _calculateRangeAndInterval(availableSize);
    }

    visibleLabels.clear();
    visibleMultilevelLabels.clear();
    majorTickPositions.clear();
    minorTickPositions.clear();

    _renderSize = availableSize;

    if (visibleRange != null) {
      generateVisibleLabels();
      generateMultiLevelLabels();
    }

    Size newSize = Size.zero;
    if (isVisible) {
      assert(_renderer != null);
      newSize = _renderer!._preferredSize(availableSize);
    } else {
      newSize = isVertical
          ? Size(0, availableSize.height)
          : Size(availableSize.width, 0);
    }
    final Size constraintsSize = constraints.biggest;
    size = Size(min(newSize.width, constraintsSize.width),
        min(newSize.height, constraintsSize.height));

    if (isVertical) {
      _renderSize = Size(size.width, size.height - 2 * plotOffset);
    } else {
      _renderSize = Size(size.width - 2 * plotOffset, size.height);
    }

    if (visibleRange != null) {
      if (plotOffset > 0) {
        _calculateLabelPositions();
        _calculateBorderPositions();
      }
      updateMultiLevelLabels();
      calculateTickPositions(
        labelPlacement,
        source: majorTickPositions,
        canCalculateMinorTick: minorTicksPerInterval > 0,
      );
    }
    _needsRangeUpdate = false;
    zoomingInProgress = false;
  }

  @override
  void performPostLayout() {
    super.performPostLayout();
    _isLayoutPhase = false;
    if (visibleRange != null) {
      visiblePlotBands?.clear();
      generatePlotBands();
    }
  }

  void calculateVisibleRangeAndInvokeAnimation() {
    if (parent == null ||
        !parent!.enableAxisAnimation ||
        !hasSize ||
        _animation == null) {
      return;
    }

    Size availableSize = size;
    if (plotOffset > 0) {
      if (isVertical) {
        availableSize =
            Size(availableSize.width, availableSize.height - 2 * plotOffset);
      } else {
        availableSize =
            Size(availableSize.width - 2 * plotOffset, availableSize.height);
      }
    }
    DoubleRange newActualRange = calculateActualRange();
    final num newActualInterval =
        calculateActualInterval(newActualRange, availableSize);
    newActualRange =
        applyRangePadding(newActualRange, newActualInterval, availableSize);
    late DoubleRange newVisibleRange;
    // TODO(VijayakumarM): Need to handle anchorRangeToVisiblePoints in series?
    if (!anchorRangeToVisiblePoints &&
        isXAxis &&
        parent!.behaviorArea?.zoomPanBehavior?.zoomMode == ZoomMode.x) {
      newVisibleRange = newActualRange;
    } else {
      newVisibleRange = calculateVisibleRange(newActualRange);
      if (autoScrollingDelta != null &&
          autoScrollingDelta! > 0 &&
          !zoomingInProgress) {
        final DoubleRange autoScrollRange = updateAutoScrollingDelta(
            autoScrollingDelta!, newActualRange, newVisibleRange);
        if ((autoScrollingMode == AutoScrollingMode.end &&
                newActualRange.minimum < autoScrollRange.minimum) ||
            (autoScrollingMode == AutoScrollingMode.start &&
                newActualRange.maximum > autoScrollRange.maximum)) {
          newVisibleRange = autoScrollRange;
        }
      }
    }

    if (newVisibleRange != _visibleRange) {
      _effectiveVisibleRange = newVisibleRange;
      _visibleRangeTween =
          DoubleRangeTween(begin: _visibleRange, end: newVisibleRange);
      _animationController?.forward(from: 0.0);
    }
  }

  void _calculateRangeAndInterval(Size availableSize) {
    if (plotOffset > 0) {
      if (isVertical) {
        availableSize =
            Size(availableSize.width, availableSize.height - 2 * plotOffset);
      } else {
        availableSize =
            Size(availableSize.width - 2 * plotOffset, availableSize.height);
      }
    }

    DoubleRange newActualRange = calculateActualRange();
    final num newActualInterval =
        calculateActualInterval(newActualRange, availableSize);
    _actualInterval = newActualInterval;
    newActualRange =
        applyRangePadding(newActualRange, newActualInterval, availableSize);
    controller._updateActualRange(newActualRange);
    late DoubleRange newVisibleRange;
    num newVisibleInterval = _actualInterval;
    if (_visibleRangeTween == null) {
      final bool canKeepActualRange = !anchorRangeToVisiblePoints;
      if (canKeepActualRange &&
          !isXAxis &&
          parent?.behaviorArea?.zoomPanBehavior?.zoomMode == ZoomMode.x) {
        newVisibleRange = newActualRange.copyWith();
      } else {
        newVisibleRange = calculateVisibleRange(newActualRange.copyWith());
        if (autoScrollingDelta != null &&
            autoScrollingDelta! > 0 &&
            !zoomingInProgress) {
          final DoubleRange autoScrollRange = updateAutoScrollingDelta(
              autoScrollingDelta!, newActualRange, newVisibleRange);
          if ((autoScrollingMode == AutoScrollingMode.end &&
                  newActualRange.minimum < autoScrollRange.minimum) ||
              (autoScrollingMode == AutoScrollingMode.start &&
                  newActualRange.maximum > autoScrollRange.maximum)) {
            newVisibleRange = autoScrollRange;
          }
        }
        newVisibleInterval =
            calculateVisibleInterval(newVisibleRange, availableSize);
      }
    } else {
      final bool canKeepActualRange = !anchorRangeToVisiblePoints;
      if (canKeepActualRange &&
          !isXAxis &&
          parent?.behaviorArea?.zoomPanBehavior?.zoomMode == ZoomMode.x) {
        newVisibleRange = newActualRange.copyWith();
      } else {
        newVisibleRange = _visibleRangeTween!.evaluate(_animation!)!;
        newVisibleInterval =
            calculateVisibleInterval(newVisibleRange, availableSize);
      }
    }

    // Handled range controller when performing panning.
    if (rangeController != null) {
      updateRangeControllerValues(newVisibleRange);
    }

    if (parent != null &&
        parent!.onActualRangeChanged != null &&
        (newActualRange != actualRange || newVisibleRange != visibleRange)) {
      final ActualRangeChangedArgs args = ActualRangeChangedArgs(
        name,
        widget,
        newActualRange.minimum,
        newActualRange.maximum,
        newActualInterval,
        isVertical ? AxisOrientation.vertical : AxisOrientation.horizontal,
      );
      args
        ..visibleMin = newVisibleRange.minimum
        ..visibleMax = newVisibleRange.maximum
        ..visibleInterval = newVisibleInterval;
      parent!.onActualRangeChanged!(args);
      if (newVisibleRange.minimum != args.visibleMin ||
          newVisibleRange.maximum != args.visibleMax) {
        newVisibleRange.minimum = args.visibleMin;
        newVisibleRange.maximum = args.visibleMax;
        final num actualRangeDelta = newActualRange.delta;
        controller.zoomFactor = newVisibleRange.delta / actualRangeDelta;
        controller.zoomPosition =
            (newVisibleRange.minimum - newActualRange.minimum) /
                actualRangeDelta;
      }
      newVisibleInterval = args.visibleInterval;
    }
    _actualRange = newActualRange;
    controller._actualRange = newActualRange;
    _actualInterval = newActualInterval;
    _visibleRange = newVisibleRange;
    _visibleInterval = newVisibleInterval;

    if (attached) {
      invokeLayoutCallback((Object? constraints) {
        for (final AxisDependent dependent in dependents) {
          dependent.didRangeChange(this);
        }
      });
    }
  }

  @protected
  DoubleRange updateAutoScrollingDelta(
      int scrollingDelta, DoubleRange actualRange, DoubleRange visibleRange) {
    switch (autoScrollingMode) {
      case AutoScrollingMode.start:
        final DoubleRange autoScrollRange = DoubleRange(
            actualRange.minimum, actualRange.minimum + scrollingDelta);
        controller.zoomFactor = autoScrollRange.delta / actualRange.delta;
        controller.zoomPosition = 0;
        return autoScrollRange;

      case AutoScrollingMode.end:
        final DoubleRange autoScrollRange = DoubleRange(
            actualRange.maximum - scrollingDelta, actualRange.maximum);
        controller.zoomFactor = autoScrollRange.delta / actualRange.delta;
        controller.zoomPosition = 1 - controller.zoomFactor;
        return autoScrollRange;
    }
  }

  void updateRangeControllerValues(DoubleRange newVisibleRange) {
    if (rangeController!.start != newVisibleRange.minimum) {
      rangeController!.start = newVisibleRange.minimum;
    }
    if (rangeController!.end != newVisibleRange.maximum) {
      rangeController!.end = newVisibleRange.maximum;
    }
  }

  @protected
  DoubleRange calculateActualRange() {
    if (dependents.isEmpty) {
      return defaultRange();
    }

    num minimum = double.infinity;
    num maximum = double.negativeInfinity;

    for (final AxisDependent dependent in dependents) {
      if (dependent.includeRange) {
        final DoubleRange current = dependent.range(this);
        if (current.minimum.isFinite) {
          minimum = min(minimum, current.minimum);
        }
        if (current.maximum.isFinite) {
          maximum = max(maximum, current.maximum);
        }
      }
    }

    if (minimum == maximum && minimum < 0 && maximum < 0) {
      maximum = 0.0;
    }

    if (minimum == maximum && minimum > 0 && maximum > 0) {
      minimum = 0.0;
    }

    if (minimum.isInfinite && maximum.isInfinite) {
      final DoubleRange range = defaultRange();
      minimum = range.minimum;
      maximum = range.maximum;
    }

    return DoubleRange(minimum, maximum);
  }

  DoubleRange defaultRange();

  @protected
  num calculateActualInterval(DoubleRange range, Size availableSize) {
    return interval ?? calculateNiceInterval(range.delta, availableSize);
  }

  @protected
  DoubleRange applyRangePadding(
      DoubleRange range, num interval, Size availableSize) {
    final ChartRangePadding padding = effectiveRangePadding();
    if (padding == ChartRangePadding.additional) {
      _addAdditionalRange(range, interval);
    } else if (padding == ChartRangePadding.round) {
      _roundRange(range, interval);
    } else if (padding == ChartRangePadding.normal) {
      addNormalRange(range, interval, availableSize);
    }

    return range;
  }

  @protected
  ChartRangePadding effectiveRangePadding() {
    ChartRangePadding padding = ChartRangePadding.auto;
    if (rangePadding == ChartRangePadding.auto) {
      if (isVertical) {
        padding = !isTransposed
            ? (_dependentIsStacked100
                ? ChartRangePadding.round
                : ChartRangePadding.normal)
            : ChartRangePadding.none;
      } else {
        padding = isTransposed
            ? (_dependentIsStacked100
                ? ChartRangePadding.round
                : ChartRangePadding.normal)
            : ChartRangePadding.none;
      }
    } else {
      padding = rangePadding;
    }
    return padding;
  }

  void _roundRange(DoubleRange range, num interval) {
    range.minimum = ((range.minimum / interval).floor()) * interval;
    range.maximum = ((range.maximum / interval).ceil()) * interval;
  }

  void _addAdditionalRange(DoubleRange range, num interval) {
    final num minimum = ((range.minimum / interval).floor()) * interval;
    final num maximum = ((range.maximum / interval).ceil()) * interval;
    range.minimum = minimum - interval;
    range.maximum = maximum + interval;
  }

  @protected
  void addNormalRange(DoubleRange range, num interval, Size availableSize) {
    num minimum;
    num remaining;
    num start = range.minimum;
    if (range.minimum < 0) {
      final num end = range.maximum;
      if (start.isNegative && end.isNegative) {
        minimum = start > ((5.0 / 6.0) * end) ? 0 : start - (end - start) / 2;
      } else {
        start = 0.0;
        minimum = range.minimum + (range.minimum / 20);
      }

      remaining = interval + _remainder(minimum, interval);
      if ((0.365 * interval) >= remaining) {
        minimum -= interval;
      }

      if (_remainder(minimum, interval) < 0) {
        minimum = (minimum - interval) - _remainder(minimum, interval);
      }
    } else {
      minimum = range.minimum < ((5.0 / 6.0) * range.maximum)
          ? 0
          : (range.minimum - (range.maximum - range.minimum) / 2);
      if (minimum % interval > 0) {
        minimum -= minimum % interval;
      }
    }
    num maximum = (range.maximum > 0)
        ? (range.maximum + (range.maximum - start) / 20)
        : (range.maximum - (range.maximum - start) / 20);
    remaining = interval - (maximum % interval);
    if ((0.365 * interval) >= remaining) {
      maximum += interval;
    }
    if (maximum % interval > 0) {
      maximum = range.maximum > 0
          ? (maximum + interval) - (maximum % interval)
          : (maximum + interval) + (maximum % interval);
    }
    range.minimum = minimum;
    range.maximum = maximum;
    if (minimum == 0) {
      updateNormalRangePadding(range, availableSize);
    }
  }

  num _remainder(num minimum, num interval) {
    if (minimum.isNegative) {
      final num min =
          num.tryParse(minimum.toString().replaceAll(RegExp('-'), ''))!;
      return num.tryParse('-${min % interval}')!;
    } else {
      return minimum % interval;
    }
  }

  void updateNormalRangePadding(DoubleRange range, Size size) {
    _actualInterval = calculateActualInterval(range, size);
    range.maximum = (range.maximum / _actualInterval).ceil() * _actualInterval;
  }

  DoubleRange calculateVisibleRange(DoubleRange range) {
    if (controller.zoomFactor < 1) {
      final DoubleRange baseRange = range;
      num start =
          baseRange.minimum + (controller.zoomPosition * baseRange.delta);
      num end = start + (controller.zoomFactor * baseRange.delta);

      if (start < baseRange.minimum) {
        end = end + (baseRange.minimum - start);
        start = baseRange.minimum;
      }

      if (end > baseRange.maximum) {
        start = start - (end - baseRange.maximum);
        end = baseRange.maximum;
      }

      return DoubleRange(start, end);
    }

    return range;
  }

  @protected
  num calculateVisibleInterval(DoubleRange visibleRange, Size availableSize) {
    if (controller.zoomFactor < 1 || controller.zoomPosition > 0) {
      return enableAutoIntervalOnZooming
          ? calculateNiceInterval(visibleRange.delta, availableSize)
          : _actualInterval;
    }

    return _actualInterval;
  }

  @protected
  num calculateNiceInterval(num delta, Size availableSize) {
    final num intervalsCount = desiredIntervalsCount(availableSize);
    num niceInterval = desiredNiceInterval(delta, intervalsCount);
    assert(niceInterval != double.infinity);
    if (desiredIntervals != null) {
      return niceInterval;
    }

    final List<num> divisions = <num>[10, 5, 2, 1];
    final num minimumInterval =
        niceInterval == 0 ? 0 : pow(10, (log(niceInterval) / log(10)).floor());
    for (int i = 0; i < divisions.length; i++) {
      final num interval = divisions[i];
      final num currentInterval = minimumInterval * interval;
      if (intervalsCount < (delta / currentInterval)) {
        break;
      }
      niceInterval = currentInterval;
    }

    return niceInterval;
  }

  @protected
  num desiredNiceInterval(num delta, num intervalsCount) {
    return delta / intervalsCount;
  }

  @nonVirtual
  num desiredIntervalsCount(Size availableSize) {
    if (desiredIntervals == null) {
      final num size = isVertical ? availableSize.height : availableSize.width;
      num intervalsCount = (isVertical ? 1 : 0.533) * maximumLabels;
      intervalsCount = max(size * (intervalsCount / 100), 1);
      return intervalsCount;
    }
    return desiredIntervals!;
  }

  @protected
  @mustCallSuper
  void generateVisibleLabels() {
    _calculateLabelPositions();
    _calculateBorderPositions();
  }

  void _calculateBorderPositions() {
    borderPositions.clear();

    final Color labelBorderColor =
        (borderColor ?? chartThemeData!.axisLineColor)!;
    if (borderWidth > 0 && labelBorderColor != Colors.transparent) {
      switch (labelPlacement) {
        case LabelPlacement.onTicks:
          calculateTickPositions(LabelPlacement.betweenTicks,
              source: borderPositions, canCalculateMajorTick: false);
          break;

        case LabelPlacement.betweenTicks:
          calculateTickPositions(LabelPlacement.onTicks,
              source: borderPositions, canCalculateMajorTick: false);
          break;
      }
    }
  }

  @protected
  void generateMultiLevelLabels() {}

  @protected
  void updateMultiLevelLabels() {}

  void _calculateLabelPositions() {
    if (visibleLabels.isEmpty) {
      return;
    }

    final int length = visibleLabels.length;
    _AlignLabel betweenLabelsAlign;
    switch (labelAlignment) {
      case LabelAlignment.start:
        betweenLabelsAlign = !isInversed ? _startAlignment : _endAlignment;
        break;

      case LabelAlignment.end:
        betweenLabelsAlign = !isInversed ? _endAlignment : _startAlignment;
        break;

      case LabelAlignment.center:
        betweenLabelsAlign = _centerAlignment;
        break;
    }

    _AlignLabel startLabelAlign = betweenLabelsAlign;
    _AlignLabel endLabelAlign = betweenLabelsAlign;
    if (edgeLabelPlacement == EdgeLabelPlacement.shift) {
      if (isVertical) {
        if (isInversed) {
          startLabelAlign = _edgeLabelStartAlignment;
          endLabelAlign = _edgeLabelEndAlignment;
        } else {
          startLabelAlign = _edgeLabelEndAlignment;
          endLabelAlign = _edgeLabelStartAlignment;
        }
      } else {
        if (isInversed) {
          startLabelAlign = _edgeLabelEndAlignment;
          endLabelAlign = _edgeLabelStartAlignment;
        } else {
          startLabelAlign = _edgeLabelStartAlignment;
          endLabelAlign = _edgeLabelEndAlignment;
        }
      }
    }

    if (effectiveLabelIntersectAction != AxisLabelIntersectAction.none) {
      _hasCollidingLabels = _isCollidingLabels(
          length, startLabelAlign, betweenLabelsAlign, endLabelAlign);
      if (_hasCollidingLabels) {
        _arrangeLabels(
            length, startLabelAlign, betweenLabelsAlign, endLabelAlign);
      }
    } else {
      _hasCollidingLabels = false;
      _arrangeLabels(
          length, startLabelAlign, betweenLabelsAlign, endLabelAlign);
    }
  }

  bool _isCollidingLabels(
    int labelsLength,
    _AlignLabel startLabelAlign,
    _AlignLabel betweenLabelsAlign,
    _AlignLabel endLabelAlign,
  ) {
    if (labelsLength == 1) {
      final AxisLabel current = visibleLabels[0];
      current.position =
          betweenLabelsAlign(pointToPixel(current.value), current);
      return false;
    }

    if (labelsLength < 2) {
      return false;
    }

    late int startIndex;
    late int endIndex;
    AxisLabel source;
    AxisLabel current = visibleLabels[0];

    if (edgeLabelPlacement == EdgeLabelPlacement.hide) {
      current.isVisible = false;
      // Start is [2] because the [0] is hidden and source is [1].
      startIndex = 2;
      // End is [labelsLength - 2].
      // Because the last label [labelsLength - 1] is hidden.
      endIndex = labelsLength - 2;
      // Taken [1] label as source because edge label [0] is hidden.
      source = visibleLabels[1];
      source.position = betweenLabelsAlign(pointToPixel(source.value), source);
    } else {
      // Start is [1] because the [0] is source.
      startIndex = 1;
      endIndex = labelsLength - 1;
      source = current;
      source.position = startLabelAlign(pointToPixel(source.value), source);
    }

    bool hasCollidingLabels = false;
    for (int i = startIndex; i < endIndex; i++) {
      current = visibleLabels[i];
      current.position =
          betweenLabelsAlign(pointToPixel(current.value), current);
      hasCollidingLabels = _isIntersect(current, source);
      if (hasCollidingLabels) {
        return true;
      }

      source = current;
    }

    // If edgeLabelPlacement is [hide], endIndex is [length - 2].
    // If edgeLabelPlacement is [none] or [shift], endIndex is [length - 1].
    current = visibleLabels[endIndex];
    if (edgeLabelPlacement == EdgeLabelPlacement.hide) {
      // Now need to hide the [length - 1] last label.
      visibleLabels[labelsLength - 1].isVisible = false;
      // Need to find the endIndex [length - 2] position. Because, the for loop
      // only run till the previous index of endIndex.
      current.position =
          betweenLabelsAlign(pointToPixel(current.value), current);
    } else {
      // Need to find the endIndex [length - 1] position. Because, the for loop
      // only run till the previous index of endIndex.
      current.position = endLabelAlign(pointToPixel(current.value), current);
    }
    return _isIntersect(current, source);
  }

  void _arrangeLabels(
    int length,
    _AlignLabel startLabelAlign,
    _AlignLabel betweenLabelsAlign,
    _AlignLabel endLabelAlign,
  ) {
    late int startIndex;
    late int endIndex;
    final double extent = _renderSize.width / length;
    final double edgeLabelsExtent = extent / 2;
    // The previous label which is not intersecting with the current label.
    AxisLabel source;
    AxisLabel current = visibleLabels[0];
    final AxisLabel Function(AxisLabel, AxisLabel, double, _AlignLabel)
        applyLabelIntersectAction = _applyLabelIntersectAction();

    if (edgeLabelPlacement == EdgeLabelPlacement.hide) {
      // Start edge label [0] visibility is collapsed.
      current.isVisible = false;
      // Start is [2] because the [0] is hidden and source is [1].
      startIndex = 2;
      // End is [length - 2] because the last label [length - 1] is hidden.
      endIndex = length - 2;
      // Taken [1] label as current because edge label [0] is hidden.
      current = visibleLabels[1];
      // [1] index will overlaps with the [2] label. So taken the [2] as source.
      source = visibleLabels[startIndex];
      source.position = betweenLabelsAlign(pointToPixel(source.value), source);
      current.position =
          betweenLabelsAlign(pointToPixel(current.value), current);
      if (effectiveLabelIntersectAction != AxisLabelIntersectAction.hide &&
          effectiveLabelIntersectAction !=
              AxisLabelIntersectAction.multipleRows) {
        source = applyLabelIntersectAction(
            current, source, extent, betweenLabelsAlign);
      } else {
        source = current;
      }
    } else {
      // Start is [1] because the [0] is source.
      startIndex = 1;
      endIndex = length - 1;
      // [0] index will overlaps with the [1] label. So taken the [1] as source.
      source = visibleLabels[startIndex];
      current.position = startLabelAlign(pointToPixel(current.value), current);
      source.position = betweenLabelsAlign(pointToPixel(source.value), source);
      if (effectiveLabelIntersectAction != AxisLabelIntersectAction.hide &&
          effectiveLabelIntersectAction !=
              AxisLabelIntersectAction.multipleRows) {
        source = applyLabelIntersectAction(
            current, source, edgeLabelsExtent, startLabelAlign);
      } else {
        source = current;
      }
    }

    for (int i = startIndex; i < endIndex; i++) {
      current = visibleLabels[i];
      current.position =
          betweenLabelsAlign(pointToPixel(current.value), current);
      source = applyLabelIntersectAction(
          current, source, extent, betweenLabelsAlign);
    }

    if (edgeLabelPlacement == EdgeLabelPlacement.hide) {
      current = visibleLabels[endIndex];
      current.position = endLabelAlign(pointToPixel(current.value), current);
      applyLabelIntersectAction(
          current, source, edgeLabelsExtent, endLabelAlign);
      visibleLabels[length - 1].isVisible = false;
    } else {
      current = visibleLabels[endIndex];
      current.position = endLabelAlign(pointToPixel(current.value), current);
      applyLabelIntersectAction(
          current, source, edgeLabelsExtent, endLabelAlign);
    }
  }

  AxisLabel Function(
          AxisLabel source, AxisLabel target, double extent, _AlignLabel align)
      _applyLabelIntersectAction() {
    switch (effectiveLabelIntersectAction) {
      case AxisLabelIntersectAction.none:
        return _applyNoneIntersectAction;

      case AxisLabelIntersectAction.hide:
        return _applyHideIntersectAction;

      case AxisLabelIntersectAction.wrap:
        return _applyWrapIntersectAction;

      case AxisLabelIntersectAction.trim:
        return _applyTrimIntersectAction;

      case AxisLabelIntersectAction.multipleRows:
        return _applyMultipleRowsIntersectAction;

      case AxisLabelIntersectAction.rotate45:
        return _applyRotate45IntersectAction;

      case AxisLabelIntersectAction.rotate90:
        return _applyRotate90IntersectAction;
    }
  }

  AxisLabel _applyNoneIntersectAction(
      AxisLabel current, AxisLabel source, double extent, _AlignLabel align) {
    return current;
  }

  AxisLabel _applyHideIntersectAction(
      AxisLabel current, AxisLabel source, double extent, _AlignLabel align) {
    current.isVisible = !_isIntersect(current, source);
    return current.isVisible ? current : source;
  }

  AxisLabel _applyWrapIntersectAction(
      AxisLabel current, AxisLabel source, double extent, _AlignLabel align) {
    final List<String> words = current.renderText.split(RegExp(r'\s+'));
    final int wrapLength = words.length;
    final TextStyle textStyle = current.labelStyle;
    final List<String> wrapLabels = <String>[];
    double textWidth = 0.0;
    double textHeight = 0.0;
    bool isTrimmed = false;
    for (int i = 0; i < wrapLength; i++) {
      final String text = words[i];
      Size textSize = measureText(text, textStyle, labelRotation);
      String trimText = text;
      if (textSize.width > extent) {
        trimText = trimmedText(text, textStyle, extent, labelRotation);
      }
      if (text != trimText) {
        isTrimmed = true;
        hasTrimmedAxisLabel = true;
      }
      textSize = measureText(trimText, textStyle, labelRotation);
      textWidth = max(textWidth, textSize.width);
      textHeight += textSize.height;
      wrapLabels.add(trimText);
    }

    final String finalText = wrapLabels.join('\n');
    current
      ..renderText = finalText
      ..trimmedText = isTrimmed ? finalText : current.trimmedText
      ..labelSize = Size(textWidth, textHeight)
      ..position = align(pointToPixel(current.value), current);
    words.clear();
    return current;
  }

  AxisLabel _applyTrimIntersectAction(
      AxisLabel current, AxisLabel source, double extent, _AlignLabel align) {
    final TextStyle textStyle = current.labelStyle;
    if (current.labelSize.width > extent) {
      current.renderText =
          trimmedText(current.renderText, textStyle, extent, labelRotation);
      if (current.renderText != current.text) {
        current.trimmedText = current.renderText;
        hasTrimmedAxisLabel = true;
      }
    }
    current
      ..labelSize = measureText(current.renderText, textStyle, labelRotation)
      ..position = align(pointToPixel(current.value), current);
    return current;
  }

  AxisLabel _applyMultipleRowsIntersectAction(
      AxisLabel current, AxisLabel source, double extent, _AlignLabel align) {
    if (_isIntersect(current, source)) {
      current.renderText = '\n${current.renderText}';
      current
        ..labelSize =
            measureText(current.renderText, current.labelStyle, labelRotation)
        ..position = align(pointToPixel(current.value), current);
      return source;
    }
    return current;
  }

  AxisLabel _applyRotate90IntersectAction(
      AxisLabel current, AxisLabel source, double extent, _AlignLabel align) {
    current
      ..labelSize =
          measureText(current.renderText, current.labelStyle, angle90Degree)
      ..position = align(pointToPixel(current.value), current);
    return current;
  }

  AxisLabel _applyRotate45IntersectAction(
      AxisLabel current, AxisLabel source, double extent, _AlignLabel align) {
    current
      ..labelSize =
          measureText(current.renderText, current.labelStyle, angle45Degree)
      ..position = align(pointToPixel(current.value), current);
    return current;
  }

  bool _isIntersect(AxisLabel current, AxisLabel source) {
    return isVertical
        ? _isVerticalLabelIntersect(current, source)
        : _isHorizontalLabelIntersect(current, source);
  }

  bool _isHorizontalLabelIntersect(AxisLabel current, AxisLabel source) {
    if (current.position != null && source.position != null) {
      return !isInversed
          ? current.position! < source.position! + source.labelSize.width
          : current.position! + current.labelSize.width > source.position!;
    }
    return false;
  }

  bool _isVerticalLabelIntersect(AxisLabel current, AxisLabel source) {
    if (current.position != null && source.position != null) {
      return !isInversed
          ? current.position! + current.labelSize.height > source.position!
          : current.position! < source.position! + source.labelSize.height;
    }
    return false;
  }

  double _edgeLabelStartAlignment(double position, AxisLabel label) {
    switch (edgeLabelPlacement) {
      case EdgeLabelPlacement.none:
      case EdgeLabelPlacement.hide:
        return position;

      case EdgeLabelPlacement.shift:
        position = _centerAlignment(position, label);
        return position < 0 ? 0.0 : position;
    }
  }

  double _edgeLabelEndAlignment(double position, AxisLabel label) {
    switch (edgeLabelPlacement) {
      case EdgeLabelPlacement.none:
      case EdgeLabelPlacement.hide:
        return isVertical
            ? position - label.labelSize.height
            : position - label.labelSize.width;

      case EdgeLabelPlacement.shift:
        position = _centerAlignment(position, label);
        if (isVertical) {
          final double labelSize = label.labelSize.height;
          if (position + labelSize > _renderSize.height) {
            return _renderSize.height - labelSize;
          }
        } else {
          final double labelSize = label.labelSize.width;
          if (position + labelSize > _renderSize.width) {
            return _renderSize.width - labelSize;
          }
        }
    }
    return position;
  }

  double _startAlignment(double position, AxisLabel label) {
    switch (edgeLabelPlacement) {
      case EdgeLabelPlacement.none:
      case EdgeLabelPlacement.hide:
        return position;

      case EdgeLabelPlacement.shift:
        final double shiftSize =
            isVertical ? label.labelSize.height / 2 : label.labelSize.width / 2;
        return position - shiftSize < 0 ? 0.0 : position;
    }
  }

  double _endAlignment(double position, AxisLabel label) {
    switch (edgeLabelPlacement) {
      case EdgeLabelPlacement.none:
      case EdgeLabelPlacement.hide:
        return isVertical
            ? position - label.labelSize.height
            : position - label.labelSize.width;

      case EdgeLabelPlacement.shift:
        if (isVertical) {
          final double shiftSize = label.labelSize.height;
          return position + shiftSize > _renderSize.height
              ? _renderSize.height - shiftSize
              : position - shiftSize;
        } else {
          final double shiftSize = label.labelSize.width;
          return position + shiftSize > _renderSize.width
              ? _renderSize.width - shiftSize
              : position - shiftSize;
        }
    }
  }

  double _centerAlignment(double position, AxisLabel label) {
    return isVertical
        ? position - label.labelSize.height / 2
        : position - label.labelSize.width / 2;
  }

  @protected
  void calculateTickPositions(
    LabelPlacement placement, {
    List<double>? source,
    bool canCalculateMinorTick = false,
    bool canCalculateMajorTick = true,
  }) {
    int length = visibleLabels.length;
    if (length == 0 || effectiveVisibleRange == null) {
      return;
    }

    final bool isBetweenTicks = placement == LabelPlacement.betweenTicks;
    final num tickBetweenLabel = isBetweenTicks ? visibleInterval / 2 : 0;
    length += isBetweenTicks ? 1 : 0;
    final int lastIndex = length - 1;
    for (int i = 0; i < length; i++) {
      final double? position = visibleLabels[i].position;
      if (position == null || position.isNaN) {
        continue;
      }
      num current;
      if (isBetweenTicks) {
        if (i < lastIndex) {
          current = visibleLabels[i].value - tickBetweenLabel;
        } else {
          current =
              (visibleLabels[i - 1].value + visibleInterval) - tickBetweenLabel;
        }
      } else {
        current = visibleLabels[i].value;
      }

      source!.add(pointToPixel(current));

      if (canCalculateMinorTick) {
        final num start = current;
        final num end = start + visibleInterval;
        final double minorTickInterval =
            visibleInterval / (minorTicksPerInterval + 1);
        for (int j = 1; j <= minorTicksPerInterval; j++) {
          final double tickValue = start + minorTickInterval * j;
          if (tickValue < end && tickValue < visibleRange!.maximum) {
            minorTickPositions.add(pointToPixel(tickValue));
          }
        }
      }
    }
  }

  @protected
  void generatePlotBands() {
    if (plotBands.isNotEmpty &&
        associatedAxis != null &&
        associatedAxis!.visibleRange != null) {
      if (visiblePlotBands != null) {
        visiblePlotBands!.clear();
      } else {
        visiblePlotBands = <AxisPlotBand>[];
      }
      final int length = plotBands.length;
      final Rect Function(PlotBand plotBand, num start, num end) bounds =
          isVertical ? verticalPlotBandBounds : horizontalPlotBandBounds;
      for (int i = 0; i < length; i++) {
        final PlotBand plotBand = plotBands[i];
        if (plotBand.isVisible) {
          final num min = plotBand.start != null
              ? actualValue(plotBand.start)
              : visibleRange!.minimum;
          num max = plotBand.end != null
              ? actualValue(plotBand.end)
              : visibleRange!.maximum;

          num extent;
          if (plotBand.isRepeatable) {
            extent = plotBand.repeatEvery;
            if (plotBand.repeatUntil != null) {
              max = actualValue(plotBand.repeatUntil);
              if (max > actualRange!.maximum) {
                max = actualRange!.maximum;
              }
            } else {
              max = actualRange!.maximum;
            }
          } else {
            extent = max - min;
          }

          num current = min;
          if (plotBand.isRepeatable) {
            while (current < max) {
              current =
                  formPlotBandFrame(plotBand, current, extent, max, bounds);
            }
          } else {
            formPlotBandFrame(plotBand, current, extent, max, bounds);
          }
        }
      }
    }
  }

  num formPlotBandFrame(PlotBand plotBand, num current, num extent, num max,
      Rect Function(PlotBand plotBand, num start, num end) bounds) {
    num end = plotBandExtent(plotBand, current,
        plotBand.isRepeatable ? plotBand.size ?? extent : extent);
    if (end > max) {
      end = max;
    }
    if (visibleRange!.lies(current, end)) {
      final Rect frame = bounds(plotBand, current, end);
      addPlotBand(frame, plotBand);
    }
    current = plotBand.size != null
        ? plotBandExtent(plotBand, current,
            plotBand.isRepeatable ? plotBand.repeatEvery : end)
        : end;
    return current;
  }

  @nonVirtual
  void addPlotBand(Rect frame, PlotBand plotBand) {
    final TextStyle textStyle =
        chartThemeData!.plotBandLabelTextStyle!.merge(plotBand.textStyle);
    final Rect bounds = parent!.paintBounds;
    final AxisPlotBand plotBandDetails = AxisPlotBand(
      bounds: frame,
      opacity: plotBand.opacity,
      color: plotBand.color,
      gradient: plotBand.gradient,
      borderColor: plotBand.borderColor,
      borderWidth: plotBand.borderWidth,
      dashArray: plotBand.dashArray,
      text: plotBand.text ?? '',
      textAngle: plotBand.textAngle ?? (isVertical ? 0 : 270),
      textStyle: textStyle,
      xAlign: plotBand.horizontalTextAlignment,
      yAlign: plotBand.verticalTextAlignment,
      translateX: paddingFromSize(plotBand.horizontalTextPadding, bounds.width),
      translateY: paddingFromSize(plotBand.verticalTextPadding, bounds.height),
      shouldRenderAboveSeries: plotBand.shouldRenderAboveSeries,
    );
    visiblePlotBands!.add(plotBandDetails);
  }

  @protected
  num plotBandExtent(PlotBand plotBand, num current, num size) {
    return current + size;
  }

  Rect horizontalPlotBandBounds(PlotBand plotBand, num start, num end) {
    final double left = pointToPixel(start);
    late double top;
    final double right = pointToPixel(end);
    late double bottom;

    if (plotBand.associatedAxisStart != null) {
      if (associatedAxis is RenderDateTimeCategoryAxis) {
        final dynamic associateStart = plotBand.associatedAxisStart;
        top = associatedAxis!.pointToPixel(associatedAxis!.actualValue(
            associateStart is num
                ? (associatedAxis! as RenderDateTimeCategoryAxis)
                    .indexToDateTime(associateStart as int)
                : associateStart));
      } else if (associatedAxis is RenderCategoryAxis) {
        final dynamic associateStart = plotBand.associatedAxisStart;
        top = associatedAxis!.pointToPixel(associatedAxis!.actualValue(
            associateStart is String
                ? (associatedAxis! as RenderCategoryAxis)
                    .labels
                    .indexOf(associateStart)
                : associateStart));
      } else {
        top = associatedAxis!.pointToPixel(
            associatedAxis!.actualValue(plotBand.associatedAxisStart!));
      }
    } else {
      if (associatedAxis is RenderLogarithmicAxis) {
        top = associatedAxis!.pointToPixel(
            (associatedAxis! as RenderLogarithmicAxis)
                .toPow(associatedAxis!.visibleRange!.minimum));
      } else {
        top =
            associatedAxis!.pointToPixel(associatedAxis!.visibleRange!.minimum);
      }
    }

    if (plotBand.associatedAxisEnd != null) {
      if (associatedAxis is RenderDateTimeCategoryAxis) {
        final dynamic associateEnd = plotBand.associatedAxisEnd;
        bottom = associatedAxis!.pointToPixel(associatedAxis!.actualValue(
            associateEnd is num
                ? (associatedAxis! as RenderDateTimeCategoryAxis)
                    .indexToDateTime(associateEnd as int)
                : associateEnd));
      } else if (associatedAxis is RenderCategoryAxis) {
        final dynamic associateEnd = plotBand.associatedAxisEnd;
        final num index = associateEnd is String
            ? (associatedAxis! as RenderCategoryAxis)
                .labels
                .indexOf(associateEnd)
            : associateEnd;
        bottom = associatedAxis!.pointToPixel(associatedAxis!.actualValue(
            index != -1 ? index : associatedAxis!.actualRange!.maximum));
      } else {
        bottom = associatedAxis!.pointToPixel(
            associatedAxis!.actualValue(plotBand.associatedAxisEnd!));
      }
    } else {
      if (associatedAxis is RenderLogarithmicAxis) {
        bottom = associatedAxis!.pointToPixel(
            (associatedAxis! as RenderLogarithmicAxis)
                .toPow(associatedAxis!.visibleRange!.maximum));
      } else {
        bottom =
            associatedAxis!.pointToPixel(associatedAxis!.visibleRange!.maximum);
      }
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Rect verticalPlotBandBounds(PlotBand plotBand, num start, num end) {
    late double left;
    final double top = pointToPixel(start);
    late double right;
    final double bottom = pointToPixel(end);

    if (plotBand.associatedAxisStart != null) {
      if (associatedAxis is RenderDateTimeCategoryAxis) {
        final dynamic associateStart = plotBand.associatedAxisStart;
        left = associatedAxis!.pointToPixel(associatedAxis!.actualValue(
            associateStart is num
                ? (associatedAxis! as RenderDateTimeCategoryAxis)
                    .indexToDateTime(associateStart as int)
                : associateStart));
      } else if (associatedAxis is RenderCategoryAxis) {
        final dynamic associateStart = plotBand.associatedAxisStart;
        left = associatedAxis!.pointToPixel(associatedAxis!.actualValue(
            associateStart is String
                ? (associatedAxis! as RenderCategoryAxis)
                    .labels
                    .indexOf(associateStart)
                : associateStart));
      } else {
        left = associatedAxis!.pointToPixel(
            associatedAxis!.actualValue(plotBand.associatedAxisStart!));
      }
    } else {
      if (associatedAxis is RenderLogarithmicAxis) {
        left = associatedAxis!.pointToPixel(
            (associatedAxis! as RenderLogarithmicAxis)
                .toPow(associatedAxis!.visibleRange!.minimum));
      } else {
        left =
            associatedAxis!.pointToPixel(associatedAxis!.visibleRange!.minimum);
      }
    }

    if (plotBand.associatedAxisEnd != null) {
      if (associatedAxis is RenderDateTimeCategoryAxis) {
        final dynamic associateEnd = plotBand.associatedAxisEnd;
        right = associatedAxis!.pointToPixel(associatedAxis!.actualValue(
            associateEnd is num
                ? (associatedAxis! as RenderDateTimeCategoryAxis)
                    .indexToDateTime(associateEnd as int)
                : associateEnd));
      } else if (associatedAxis is RenderCategoryAxis) {
        final dynamic associateEnd = plotBand.associatedAxisEnd;
        final num index = associateEnd is String
            ? (associatedAxis! as RenderCategoryAxis)
                .labels
                .indexOf(associateEnd)
            : associateEnd;
        right = associatedAxis!.pointToPixel(associatedAxis!.actualValue(
            index != -1 ? index : associatedAxis!.actualRange!.maximum));
      } else {
        right = associatedAxis!.pointToPixel(
            associatedAxis!.actualValue(plotBand.associatedAxisEnd!));
      }
    } else {
      if (associatedAxis is RenderLogarithmicAxis) {
        right = associatedAxis!.pointToPixel(
            (associatedAxis! as RenderLogarithmicAxis)
                .toPow(associatedAxis!.visibleRange!.maximum));
      } else {
        right =
            associatedAxis!.pointToPixel(associatedAxis!.visibleRange!.maximum);
      }
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  num actualValue(Object value) {
    final num cross = value as num;
    final num minimum = actualRange!.minimum;
    final num maximum = actualRange!.maximum;
    if (cross < minimum) {
      return minimum;
    }
    if (cross > maximum) {
      return maximum;
    }
    return cross;
  }

  double pointToPixel(num dataPoint, {DoubleRange? range}) {
    if (dataPoint.isNaN) {
      return double.nan;
    }

    final num coefficient = _valueToCoefficient(dataPoint, range: range);
    if (isVertical) {
      return plotOffset + _renderSize.height * (1 - coefficient);
    } else {
      return plotOffset + _renderSize.width * coefficient;
    }
  }

  double pixelToPoint(Rect rect, double x, double y) {
    rect = Rect.fromLTWH(
      rect.left + (!isVertical ? plotOffset : 0),
      rect.top + (isVertical ? plotOffset : 0),
      rect.width - (!isVertical ? 2 * plotOffset : 0),
      rect.height - (isVertical ? 2 * plotOffset : 0),
    );
    if (visibleRange != null) {
      return isVertical
          ? _coefficientToValue(1 - ((y - rect.top) / rect.height))
          : _coefficientToValue((x - rect.left) / rect.width);
    }
    return double.nan;
  }

  double _coefficientToValue(double coefficient) {
    return visibleRange!.minimum +
        (visibleRange!.delta * (isInversed ? 1 - coefficient : coefficient));
  }

  num _valueToCoefficient(num value, {DoubleRange? range}) {
    range ??= visibleRange;
    if (range != null) {
      final double result = (value - range.minimum) / range.delta;
      return isInversed ? 1 - result : result;
    }

    return 0;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return hasTrimmedAxisLabel || parent!.onAxisLabelTapped != null;
  }

  void handleTapUp(TapUpDetails details) {
    if (parent != null &&
        parent!.parentData != null &&
        parent!.behaviorArea != null &&
        (parent!.onAxisLabelTapped != null || hasTrimmedAxisLabel)) {
      final Offset localPosition = globalToLocal(details.globalPosition);
      for (final AxisLabel label in visibleLabels) {
        if (label.region != null && label.region!.contains(localPosition)) {
          if (parent!.onAxisLabelTapped != null) {
            final AxisLabelTapArgs args = AxisLabelTapArgs(widget, name)
              ..text = label.text
              ..value = label.value;
            parent!.onAxisLabelTapped!(args);
          }
          if (hasTrimmedAxisLabel && label.trimmedText != null) {
            final BoxParentData parentData =
                parent!.parentData! as BoxParentData;
            final Rect parentBounds = parentData.offset & parent!.size;
            parent!.behaviorArea!.showTooltip(TooltipInfo(
              primaryPosition: localToGlobal(label.region!.topCenter),
              secondaryPosition: localToGlobal(label.region!.bottomCenter),
              text: label.text,
              surfaceBounds: Rect.fromPoints(
                parent!.localToGlobal(parentBounds.topLeft),
                parent!.localToGlobal(parentBounds.bottomRight),
              ),
            ));
          }
          break;
        }
      }
    }
  }

  void handlePointerHover(PointerHoverEvent details) {
    if (hasTrimmedAxisLabel &&
        parent != null &&
        parent!.parentData != null &&
        parent!.behaviorArea != null) {
      final Offset localPosition = globalToLocal(details.position);
      for (final AxisLabel label in visibleLabels) {
        if (label.trimmedText != null &&
            label.region != null &&
            label.region!.contains(localPosition)) {
          final BoxParentData parentData = parent!.parentData! as BoxParentData;
          final Rect parentBounds = parentData.offset & parent!.size;
          parent!.behaviorArea!.showTooltip(TooltipInfo(
            primaryPosition: localToGlobal(label.region!.topCenter),
            secondaryPosition: localToGlobal(label.region!.bottomCenter),
            text: label.text,
            surfaceBounds: Rect.fromPoints(
              parent!.localToGlobal(parentBounds.topLeft),
              parent!.localToGlobal(parentBounds.bottomRight),
            ),
          ));
          break;
        }
      }
    }
  }

  @override
  @nonVirtual
  void paint(PaintingContext context, Offset offset) {
    if (!_isVisible) {
      renderType = AxisRender.normal;
      return;
    }

    assert(_renderer != null);
    if (_renderer == null) {
      renderType = AxisRender.normal;
      return;
    }

    switch (renderType) {
      case AxisRender.gridLines:
        _renderer!._paintGridLines(context, offset);
        break;
      case AxisRender.underPlotBand:
        _renderer!._paintUnderPlotBands(context, offset);
        break;
      case AxisRender.normal:
        onPaint(context, offset);
        break;
      case AxisRender.overPlotBand:
        _renderer!._paintOverPlotBands(context, offset);
        break;
    }
    renderType = AxisRender.normal;
  }

  @protected
  void onPaint(PaintingContext context, Offset offset) {
    assert(_renderer != null);
    _renderer?._onPaint(context, offset);
  }

  @override
  void dispose() {
    dependents.clear();
    visibleLabels.clear();
    majorTickPositions.clear();
    minorTickPositions.clear();
    borderPositions.clear();
    visibleMultilevelLabels.clear();

    _animationController?.removeStatusListener(_onAnimationStatusChanged);
    if (_animation != null) {
      _animation!.removeListener(markNeedsRangeUpdate);
      _animation!.dispose();
    }
    _animationController?.dispose();
    super.dispose();
  }
}

class DoubleRangeTween extends Tween<DoubleRange?> {
  DoubleRangeTween({
    super.begin,
    super.end,
  });

  @override
  DoubleRange? transform(double t) {
    return DoubleRange.lerp(begin, end, t);
  }
}

class DoubleRange {
  DoubleRange(num min, num max) {
    if (max > min) {
      minimum = min;
      maximum = max;
    } else {
      minimum = max;
      maximum = min;
    }
  }

  DoubleRange.zero() {
    minimum = 0;
    maximum = 0;
  }

  num delta = 1;

  num get minimum => _minimum;
  num _minimum = 0;
  set minimum(num value) {
    if (_minimum != value) {
      _minimum = value;
      if (value > _maximum) {
        delta = value - _maximum;
      } else {
        delta = _maximum - value;
      }
    }
  }

  num get maximum => _maximum;
  num _maximum = 1;
  set maximum(num value) {
    if (_maximum != value) {
      _maximum = value;
      if (value > _minimum) {
        delta = value - _minimum;
      } else {
        delta = _minimum - value;
      }
    }
  }

  bool get isEmpty => _minimum == 0.0 && _maximum == 0.0;

  DoubleRange operator +(DoubleRange other) {
    return DoubleRange(
        min(_minimum, other.minimum), max(_maximum, other.maximum));
  }

  DoubleRange copyWith({num? minimum, num? maximum}) {
    return DoubleRange(minimum ?? _minimum, maximum ?? _maximum);
  }

  bool lies(num start, num end) {
    return end >= minimum && start <= maximum;
  }

  bool contains(num value) {
    return value >= minimum && value <= maximum;
  }

  static DoubleRange? lerp(DoubleRange? a, DoubleRange? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    if (a == null) {
      return DoubleRange(b!.minimum, b.maximum);
    }
    if (b == null) {
      return DoubleRange(a.minimum, a.maximum);
    }

    return DoubleRange(
      lerpDouble(a.minimum, b.minimum, t)!,
      lerpDouble(a.maximum, b.maximum, t)!,
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DoubleRange &&
        other.minimum == minimum &&
        other.maximum == maximum;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(minimum, maximum);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'DoubleRange')}($minimum, $maximum)';
  }
}

mixin AxisDependent {
  final DoubleRange xRange = DoubleRange(0, 1);
  final DoubleRange yRange = DoubleRange(0, 1);

  bool includeRange = true;

  num get xMin => xRange.minimum;
  set xMin(num value) {
    if (xRange.minimum != value) {
      xRange.minimum = value;
      xAxis?._needsRangeUpdate = true;
    }
  }

  num get xMax => xRange.maximum;
  set xMax(num value) {
    if (xRange.maximum != value) {
      xRange.maximum = value;
      xAxis?._needsRangeUpdate = true;
    }
  }

  num get yMin => yRange.minimum;
  set yMin(num value) {
    if (yRange.minimum != value) {
      yRange.minimum = value;
      yAxis?._needsRangeUpdate = true;
    }
  }

  num get yMax => yRange.maximum;
  set yMax(num value) {
    if (yRange.maximum != value) {
      yRange.maximum = value;
      yAxis?._needsRangeUpdate = true;
    }
  }

  String? get xAxisName => _xAxisName;
  String? _xAxisName;
  set xAxisName(String? value) {
    if (_xAxisName != value) {
      _xAxisName = value;
    }
  }

  String? get yAxisName => _yAxisName;
  String? _yAxisName;
  set yAxisName(String? value) {
    if (_yAxisName != value) {
      _yAxisName = value;
    }
  }

  RenderChartAxis? get xAxis => _xAxis;
  RenderChartAxis? _xAxis;
  set xAxis(RenderChartAxis? value) {
    assert(value != null);
    if (_xAxis != value) {
      _xAxis?.removeDependent(this);
      _xAxis = value;
      _xAxis?.addDependent(this);
    }
  }

  RenderChartAxis? get yAxis => _yAxis;
  RenderChartAxis? _yAxis;
  set yAxis(RenderChartAxis? value) {
    assert(value != null);
    if (_yAxis != value) {
      _yAxis?.removeDependent(this);
      _yAxis = value;
      _yAxis?.addDependent(this, isXAxis: false);
    }
  }

  bool get isTransposed => _isTransposed;
  bool _isTransposed = false;
  set isTransposed(bool value) {
    if (_isTransposed != value) {
      _isTransposed = value;
    }
  }

  DoubleRange range(RenderChartAxis axis) {
    if (axis == xAxis) {
      return xRange;
    } else {
      return yRange;
    }
  }

  void didRangeChange(RenderChartAxis axis);
}

abstract class _GridLineRenderer {
  _GridLineRenderer(this.axis);

  final RenderChartAxis axis;

  @nonVirtual
  void onPaint(PaintingContext context, Offset offset) {
    final Offset plotAreaGlobalOffset =
        axis.parent!.localToGlobal(axis.parent!.plotAreaOffset);
    final Offset plotAreaOffset = axis.globalToLocal(plotAreaGlobalOffset);
    context.canvas.save();
    context.canvas.clipRect(axis.parent!.plotAreaBounds);
    _drawMajorGridLines(context, plotAreaOffset + offset);
    _drawMinorGridLines(context, plotAreaOffset + offset);
    context.canvas.restore();
  }

  @protected
  void _drawMajorGridLines(PaintingContext context, Offset offset);

  @protected
  void _drawMinorGridLines(PaintingContext context, Offset offset);
}

class _HorizontalGridLineRenderer extends _GridLineRenderer {
  _HorizontalGridLineRenderer(RenderChartAxis axis) : super(axis);

  @override
  void _drawMajorGridLines(PaintingContext context, Offset offset) {
    final MajorGridLines majorGridLines = axis.majorGridLines;
    final Color color =
        (majorGridLines.color ?? axis.chartThemeData!.majorGridLineColor)!;
    _drawGridLines(context, offset, axis.majorTickPositions, color,
        majorGridLines.width, majorGridLines.dashArray);
  }

  @override
  void _drawMinorGridLines(PaintingContext context, Offset offset) {
    final MinorGridLines minorGridLines = axis.minorGridLines;
    final Color color =
        (minorGridLines.color ?? axis.chartThemeData!.minorGridLineColor)!;
    _drawGridLines(context, offset, axis.minorTickPositions, color,
        minorGridLines.width, minorGridLines.dashArray);
  }

  void _drawGridLines(
    PaintingContext context,
    Offset offset,
    List<double> positions,
    Color color,
    double width,
    List<double>? dashArray,
  ) {
    if (axis.associatedAxis != null &&
        color != Colors.transparent &&
        width > 0) {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..color = color
        ..strokeWidth = width
        ..style = PaintingStyle.stroke;

      final RenderChartAxis associatedAxis = axis.associatedAxis!;
      num minimum = associatedAxis.visibleRange!.minimum;
      num maximum = associatedAxis.visibleRange!.maximum;

      if (associatedAxis is RenderLogarithmicAxis) {
        minimum = associatedAxis.toPow(minimum);
        maximum = associatedAxis.toPow(maximum);
      }

      final double plotOffset = associatedAxis.plotOffset;
      double y1 = associatedAxis.pointToPixel(minimum);
      double y2 = associatedAxis.pointToPixel(maximum);
      if (associatedAxis.isInversed) {
        y1 = y1 - plotOffset;
        y2 = y2 + plotOffset;
      } else {
        y1 = y1 + plotOffset;
        y2 = y2 - plotOffset;
      }
      for (final double position in positions) {
        final Offset start = offset.translate(position, y1);
        final Offset end = Offset(start.dx, offset.dy + y2);
        drawDashes(context.canvas, dashArray, paint, start: start, end: end);
      }
    }
  }
}

class _VerticalGridLineRenderer extends _GridLineRenderer {
  _VerticalGridLineRenderer(RenderChartAxis axis) : super(axis);

  @override
  void _drawMajorGridLines(PaintingContext context, Offset offset) {
    final MajorGridLines majorGridLines = axis.majorGridLines;
    final Color color =
        (majorGridLines.color ?? axis.chartThemeData!.majorGridLineColor)!;
    _drawGridLines(context, offset, axis.majorTickPositions, color,
        majorGridLines.width, majorGridLines.dashArray);
  }

  @override
  void _drawMinorGridLines(PaintingContext context, Offset offset) {
    final MinorGridLines minorGridLines = axis.minorGridLines;
    final Color color =
        (minorGridLines.color ?? axis.chartThemeData!.minorGridLineColor)!;
    _drawGridLines(context, offset, axis.minorTickPositions, color,
        minorGridLines.width, minorGridLines.dashArray);
  }

  void _drawGridLines(
    PaintingContext context,
    Offset offset,
    List<double> positions,
    Color color,
    double width,
    List<double>? dashArray,
  ) {
    if (axis.associatedAxis != null &&
        color != Colors.transparent &&
        width > 0) {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..color = color
        ..strokeWidth = width
        ..style = PaintingStyle.stroke;

      final RenderChartAxis associatedAxis = axis.associatedAxis!;
      num minimum = associatedAxis.visibleRange!.minimum;
      num maximum = associatedAxis.visibleRange!.maximum;

      if (associatedAxis is RenderLogarithmicAxis) {
        minimum = associatedAxis.toPow(minimum);
        maximum = associatedAxis.toPow(maximum);
      }

      final double plotOffset = associatedAxis.plotOffset;
      double x1 = associatedAxis.pointToPixel(minimum);
      double x2 = associatedAxis.pointToPixel(maximum);
      if (associatedAxis.isInversed) {
        x1 = x1 + plotOffset;
        x2 = x2 - plotOffset;
      } else {
        x1 = x1 - plotOffset;
        x2 = x2 + plotOffset;
      }
      for (final double position in positions) {
        final Offset start = offset.translate(x1, position);
        final Offset end = Offset(offset.dx + x2, start.dy);
        drawDashes(context.canvas, dashArray, paint, start: start, end: end);
      }
    }
  }
}

class AxisPlotBand {
  AxisPlotBand({
    required this.bounds,
    required this.opacity,
    required this.color,
    required this.gradient,
    required this.borderColor,
    required this.borderWidth,
    required this.dashArray,
    required this.text,
    required this.textAngle,
    required this.textStyle,
    required this.xAlign,
    required this.yAlign,
    required this.translateX,
    required this.translateY,
    required this.shouldRenderAboveSeries,
  });

  final Rect bounds;
  final double opacity;
  final Color color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final List<double>? dashArray;
  final String text;
  final int textAngle;
  final TextStyle textStyle;
  final TextAnchor xAlign;
  final TextAnchor yAlign;
  final double translateX;
  final double translateY;
  final bool shouldRenderAboveSeries;
}

abstract class _PlotBandRenderer {
  _PlotBandRenderer(this.axis);

  final RenderChartAxis axis;
  final TextPainter _textPainter = TextPainter();

  @nonVirtual
  void _paintPlotBandsOnSeries(PaintingContext context, Offset offset) {
    _drawPlotBand(context, offset, shouldRenderAboveSeries: true);
  }

  @nonVirtual
  void _paintPlotBandsUnderSeries(PaintingContext context, Offset offset) {
    _drawPlotBand(context, offset);
  }

  void _drawPlotBand(PaintingContext context, Offset offset,
      {bool shouldRenderAboveSeries = false}) {
    if (axis.visiblePlotBands == null || axis.visiblePlotBands!.isEmpty) {
      return;
    }

    final Offset plotAreaGlobalOffset =
        axis.parent!.localToGlobal(axis.parent!.plotAreaOffset);
    final Offset plotAreaOffset = axis.globalToLocal(plotAreaGlobalOffset);
    offset += plotAreaOffset;
    context.canvas.save();
    context.canvas.clipRect(axis.parent!.plotAreaBounds);
    for (final AxisPlotBand plotBand in axis.visiblePlotBands!) {
      if (shouldRenderAboveSeries == plotBand.shouldRenderAboveSeries) {
        final Rect bounds = plotBand.bounds.translate(offset.dx, offset.dy);
        final Paint paint = Paint();
        if (plotBand.gradient != null) {
          paint.shader = plotBand.gradient!.createShader(bounds);
        } else {
          if (plotBand.opacity < 1.0) {
            paint.color = plotBand.color.withOpacity(plotBand.opacity);
          } else {
            paint.color = plotBand.color;
          }
        }

        if (paint.color != Colors.transparent && bounds.width != 0.0) {
          context.canvas.drawRect(bounds, paint);
        }

        if (plotBand.borderWidth > 0 &&
            plotBand.borderColor != Colors.transparent) {
          paint
            ..color = plotBand.opacity < 1.0
                ? plotBand.borderColor.withOpacity(plotBand.opacity)
                : plotBand.borderColor
            ..strokeWidth = plotBand.borderWidth
            ..style = PaintingStyle.stroke;
          final Path path = Path()
            ..moveTo(bounds.left, bounds.top)
            ..lineTo(bounds.left + bounds.width, bounds.top)
            ..lineTo(bounds.left + bounds.width, bounds.top + bounds.height)
            ..lineTo(bounds.left, bounds.top + bounds.height)
            ..close();
          drawDashes(context.canvas, plotBand.dashArray, paint, path: path);
        }
        _drawText(context, bounds, plotBand);
      }
    }
    context.canvas.restore();
  }

  @protected
  void _drawText(PaintingContext context, Rect bounds, AxisPlotBand plotBand);

  Offset _textPosition(AxisPlotBand plotBand, Rect bounds, Size textSize) {
    late double x, y;
    switch (plotBand.xAlign) {
      case TextAnchor.start:
        x = bounds.left + plotBand.translateX;
        break;
      case TextAnchor.middle:
        x = bounds.center.dx - textSize.width / 2 + plotBand.translateX;
        break;
      case TextAnchor.end:
        x = bounds.right - textSize.width + plotBand.translateX;
        break;
    }

    if (bounds.top > bounds.bottom) {
      // Top value is always greater than the bottom value. So vertical
      // alignment is working oppositely, hence swapped the value.
      bounds =
          Rect.fromLTRB(bounds.left, bounds.bottom, bounds.right, bounds.top);
    }

    switch (plotBand.yAlign) {
      case TextAnchor.start:
        y = bounds.top - plotBand.translateY;
        break;
      case TextAnchor.middle:
        y = bounds.center.dy - textSize.height / 2 - plotBand.translateY;
        break;
      case TextAnchor.end:
        y = bounds.bottom - textSize.height - plotBand.translateY;
        break;
    }

    return Offset(x, y);
  }
}

class _HorizontalPlotBandRenderer extends _PlotBandRenderer {
  _HorizontalPlotBandRenderer(RenderChartAxis axis) : super(axis);

  @override
  void _drawText(PaintingContext context, Rect bounds, AxisPlotBand plotBand) {
    if (plotBand.text.isNotEmpty) {
      TextStyle style = plotBand.textStyle;
      if (plotBand.opacity < 1.0) {
        style =
            style.copyWith(color: style.color?.withOpacity(plotBand.opacity));
      }
      final TextSpan span = TextSpan(text: plotBand.text, style: style);
      _textPainter
        ..text = span
        ..textAlign = TextAlign.center
        ..textDirection = TextDirection.ltr
        ..layout();
      final Offset position =
          _textPosition(plotBand, bounds, _textPainter.size);
      if (plotBand.textAngle == 0) {
        _textPainter.paint(context.canvas, position);
      } else {
        final double halfWidth = _textPainter.width / 2;
        final double halfHeight = _textPainter.height / 2;
        context.canvas
          ..save()
          ..translate(position.dx + halfWidth, position.dy + halfHeight)
          ..rotate(degreeToRadian(plotBand.textAngle));
        _textPainter.paint(context.canvas, Offset(-halfWidth, -halfHeight));
        context.canvas.restore();
      }
    }
  }
}

class _VerticalPlotBandRenderer extends _PlotBandRenderer {
  _VerticalPlotBandRenderer(RenderChartAxis axis) : super(axis);

  @override
  void _drawText(PaintingContext context, Rect bounds, AxisPlotBand plotBand) {
    if (plotBand.text.isNotEmpty) {
      TextStyle style = plotBand.textStyle;
      if (plotBand.opacity < 1.0) {
        style =
            style.copyWith(color: style.color?.withOpacity(plotBand.opacity));
      }
      final TextSpan span = TextSpan(text: plotBand.text, style: style);
      _textPainter
        ..text = span
        ..textAlign = TextAlign.center
        ..textDirection = TextDirection.ltr
        ..layout();
      final Offset position =
          _textPosition(plotBand, bounds, _textPainter.size);
      if (plotBand.textAngle == 0) {
        _textPainter.paint(context.canvas, position);
      } else {
        final double halfWidth = _textPainter.width / 2;
        final double halfHeight = _textPainter.height / 2;
        context.canvas
          ..save()
          ..translate(position.dx + halfWidth, position.dy + halfHeight)
          ..rotate(degreeToRadian(plotBand.textAngle));
        _textPainter.paint(context.canvas, Offset(-halfWidth, -halfHeight));
        context.canvas.restore();
      }
    }
  }
}

abstract class _AxisRenderer {
  _AxisRenderer({required this.axis});

  final RenderChartAxis axis;
  late _GridLineRenderer _gridLineRenderer;
  _PlotBandRenderer? _plotBandRenderer;

  final TextPainter _textPainter = TextPainter();
  final Map<int, double> _multilevelLabelSizes = <int, double>{};

  late Offset _axisLineOffset;
  late Offset _majorTickOffset;
  late Offset _minorTickOffset;
  late Offset _labelOffset;
  late Offset _borderOffset;
  late Offset _multilevelLabelOffset;
  late Offset _titleOffset;
  late _MultilevelLabelBorderShape _multilevelLabelBorderShape;

  double _maxLabelSize = 0.0;
  double _axisBorderSize = 0.0;

  double get innerSize => _innerSize;
  double _innerSize = 0.0;

  double get outerSize => _outerSize;
  double _outerSize = 0.0;

  Size _preferredSize(Size availableSize) {
    _axisBorderSize = 0.0;
    _maxLabelSize = 0.0;
    _innerSize = 0.0;
    _outerSize = 0.0;

    double majorTickSize = 0.0;
    double minorTickSize = 0.0;
    double minorTickAdj = 0.0;
    double majorTickAdj = 0.0;
    double maxTickSize = 0.0;
    double maxLabelSize = 0.0;
    double multilevelLabelSize = 0.0;
    double effectiveMultilevelBorderSize = 0.0;
    double borderSize = 0.0;
    double effectiveBorderSize = 0.0;
    double titleSize = 0.0;

    final MajorTickLines majorTickLines = axis.majorTickLines;
    if (majorTickLines.width > 0 && majorTickLines.size > 0) {
      majorTickSize = majorTickLines.size;
    }

    final MinorTickLines minorTickLines = axis.minorTickLines;
    if (minorTickLines.width > 0 && minorTickLines.size > 0) {
      minorTickSize = minorTickLines.size;
      if (majorTickSize >= minorTickSize) {
        minorTickAdj = majorTickSize - minorTickSize;
      } else {
        majorTickAdj = minorTickSize - majorTickSize;
      }
    }

    maxTickSize = max(majorTickSize, minorTickSize);
    maxLabelSize = _labelsMaxSize();
    _maxLabelSize = maxLabelSize;
    multilevelLabelSize = _multilevelLabelsTotalSize();
    borderSize = axis.borderWidth / 2;
    titleSize = 0.0;
    if (axis.title.text != null && axis.title.text!.isNotEmpty) {
      final TextStyle textStyle =
          axis.chartThemeData!.axisTitleTextStyle!.merge(axis.title.textStyle);
      titleSize = measureText(axis.title.text!, textStyle).height;
    }

    double innerTickSize = 0.0;
    double innerMajorTickSize = 0.0;
    double innerMinorTickSize = 0.0;
    double outerTickSize = 0.0;
    double innerLabelSize = 0.0;
    double outerLabelSize = 0.0;
    double innerMultilevelLabelSize = 0.0;
    double outerMultilevelLabelSize = 0.0;

    if (axis.tickPosition == TickPosition.outside) {
      outerTickSize = maxTickSize;
    } else {
      innerTickSize = maxTickSize;
      innerMajorTickSize = majorTickSize;
      innerMinorTickSize = minorTickSize;
    }

    if (axis.labelPosition == ChartDataLabelPosition.outside) {
      outerLabelSize = maxLabelSize;
      outerMultilevelLabelSize = multilevelLabelSize;
    } else {
      innerLabelSize = maxLabelSize;
      innerMultilevelLabelSize = multilevelLabelSize;
    }

    double outerLabelGap = axis.isVertical ? 5.0 : 3.0;
    double innerLabelGap = outerLabelGap;
    double outerBorderGap = 3.0;
    double innerBorderGap = outerBorderGap;
    double outerMultilevelLabelGap = 3.0;
    double innerMultilevelLabelGap = 3.0;
    double titleGap = 5.0;

    if (maxLabelSize <= 0) {
      outerLabelGap = 0.0;
      outerLabelGap = 0.0;
    }

    final MultiLevelBorderType borderType =
        axis.multiLevelLabelStyle.borderType;
    if (multilevelLabelSize > 0) {
      if (borderType == MultiLevelBorderType.rectangle ||
          borderType == MultiLevelBorderType.withoutTopAndBottom) {
        effectiveMultilevelBorderSize =
            axis.multiLevelLabelStyle.borderWidth / 2;
        if (borderSize > 0) {
          outerMultilevelLabelGap = 0.0;
          innerMultilevelLabelGap = 0.0;
        }
      }
    } else {
      outerMultilevelLabelGap = 0.0;
      innerMultilevelLabelGap = 0.0;
    }

    if (borderSize <= 0) {
      outerBorderGap = 0.0;
      innerBorderGap = 0.0;
    } else {
      if (effectiveMultilevelBorderSize == 0.0) {
        effectiveBorderSize = borderSize;
      }
    }

    if (axis.labelPosition == ChartDataLabelPosition.outside) {
      innerLabelGap = 3.0;
      innerBorderGap = 0.0;
      innerMultilevelLabelGap = 0.0;
    } else {
      outerLabelGap = 0.0;
      outerBorderGap = 0.0;
      outerMultilevelLabelGap = 0.0;
    }
    if (titleSize <= 0) {
      titleGap = 0.0;
    }

    double axisLinePadding = 0.0;
    double majorTickPadding = 0.0;
    double minorTickPadding = 0.0;
    double labelPadding = 0.0;
    double borderPadding = 0.0;
    double multilevelLabelPadding = 0.0;
    double titlePadding = 0.0;

    double outerSize = 0.0;

    // Normal order
    // Axis line -> Tick -> Label -> Border -> Multilevel label -> Title
    // ------------------------------------------------------------------
    // Inverted order
    // Title -> Multilevel label -> Border -> Label -> Tick -> Axis line
    final bool normalOrder = !axis.invertElementsOrder;
    if (normalOrder) {
      axisLinePadding = 0.0;
      majorTickPadding = 0.0;
      minorTickPadding = 0.0;
      labelPadding = outerTickSize + outerLabelGap;
      multilevelLabelPadding = labelPadding +
          outerLabelSize +
          outerBorderGap +
          effectiveBorderSize +
          outerMultilevelLabelGap +
          effectiveMultilevelBorderSize;
      titlePadding = multilevelLabelPadding +
          outerMultilevelLabelSize +
          effectiveMultilevelBorderSize +
          titleGap;
      _axisBorderSize = multilevelLabelPadding - outerMultilevelLabelGap;
      outerSize = titlePadding + titleSize;
    } else {
      titlePadding = 0.0;
      multilevelLabelPadding =
          titleSize + titleGap + effectiveMultilevelBorderSize;
      borderPadding = multilevelLabelPadding +
          outerMultilevelLabelSize +
          // effectiveMultilevelBorderSize +
          outerMultilevelLabelGap +
          effectiveBorderSize;
      labelPadding = borderPadding + outerBorderGap;
      minorTickPadding =
          labelPadding + outerLabelSize + outerLabelGap + minorTickAdj;
      majorTickPadding =
          labelPadding + outerLabelSize + outerLabelGap + majorTickAdj;
      axisLinePadding =
          labelPadding + outerLabelSize + outerLabelGap + outerTickSize;
      _axisBorderSize = effectiveBorderSize +
          effectiveMultilevelBorderSize +
          outerBorderGap +
          outerLabelSize +
          outerLabelGap +
          outerTickSize;
      outerSize = axisLinePadding;
    }

    if (axis.tickPosition == TickPosition.inside) {
      if (normalOrder) {
        majorTickPadding = -innerMajorTickSize;
        minorTickPadding = -innerMinorTickSize;
      } else {
        majorTickPadding = outerSize;
        minorTickPadding = outerSize;
      }
    }

    if (axis.labelPosition == ChartDataLabelPosition.inside) {
      if (normalOrder) {
        labelPadding = innerTickSize + innerLabelGap + innerLabelSize;
        borderPadding = labelPadding + innerBorderGap;
        multilevelLabelPadding =
            borderPadding + innerMultilevelLabelGap + innerMultilevelLabelSize;
        _axisBorderSize =
            innerTickSize + innerLabelGap + innerLabelSize + innerBorderGap;
        labelPadding *= -1;
        borderPadding *= -1;
        multilevelLabelPadding *= -1;
      } else {
        labelPadding = outerSize + innerTickSize + innerLabelGap;
        borderPadding = outerSize;
        multilevelLabelPadding = labelPadding +
            innerLabelSize +
            innerBorderGap +
            innerMultilevelLabelGap;
        _axisBorderSize =
            innerTickSize + innerLabelGap + innerLabelSize + innerBorderGap;
      }
    }

    if (maxLabelSize <= 0) {
      _axisBorderSize = 0.0;
    }

    if (axis.isVertical) {
      _axisLineOffset = Offset(axisLinePadding, 0.0);
      _majorTickOffset = Offset(majorTickPadding, 0.0);
      _minorTickOffset = Offset(minorTickPadding, 0.0);
      _labelOffset = Offset(labelPadding, 0.0);
      _borderOffset = Offset(borderPadding, 0.0);
      _multilevelLabelOffset = Offset(multilevelLabelPadding, 0.0);
      _titleOffset = Offset(titlePadding, 0.0);
      return Size(outerSize, availableSize.height);
    } else {
      _axisLineOffset = Offset(0.0, axisLinePadding);
      _majorTickOffset = Offset(0.0, majorTickPadding);
      _minorTickOffset = Offset(0.0, minorTickPadding);
      _labelOffset = Offset(0.0, labelPadding);
      _borderOffset = Offset(0.0, borderPadding);
      _multilevelLabelOffset = Offset(0.0, multilevelLabelPadding);
      _titleOffset = Offset(0.0, titlePadding);
      return Size(availableSize.width, outerSize);
    }
  }

  double _labelsMaxSize();

  double _multilevelLabelsTotalSize();

  @nonVirtual
  void _paintGridLines(PaintingContext context, Offset offset) {
    _gridLineRenderer.onPaint(context, offset);
  }

  @nonVirtual
  void _paintOverPlotBands(PaintingContext context, Offset offset) {
    _plotBandRenderer?._paintPlotBandsOnSeries(context, offset);
  }

  @nonVirtual
  void _paintUnderPlotBands(PaintingContext context, Offset offset) {
    _plotBandRenderer?._paintPlotBandsUnderSeries(context, offset);
  }

  @nonVirtual
  void _onPaint(PaintingContext context, Offset offset) {
    _drawAxisLine(context, offset + _axisLineOffset);
    _drawTicks(context, offset);
    _drawLabels(context, offset, _labelOffset);
    _drawBorders(context, offset + _borderOffset);
    _drawMultilevelLabels(context, offset + _multilevelLabelOffset);
    _drawTitle(context, offset + _titleOffset);
  }

  @protected
  void _drawAxisLine(PaintingContext context, Offset offset);

  @protected
  @nonVirtual
  void _drawTicks(PaintingContext context, Offset offset) {
    if (axis.parentData == null) {
      return;
    }
    final Rect clipRect = axis.tickPosition == TickPosition.inside
        ? axis.parent!.plotAreaBounds
        : (axis.parentData! as CartesianAxesParentData).offset & axis.size;
    final Rect extendedClipRect = clipRect
        .inflate(max(axis.majorTickLines.size, axis.minorTickLines.size) / 2);
    context.canvas.save();
    context.canvas.clipRect(extendedClipRect);
    _drawMajorTicks(context, offset + _majorTickOffset);
    _drawMinorTicks(context, offset + _minorTickOffset);
    context.canvas.restore();
  }

  @protected
  void _drawMajorTicks(PaintingContext context, Offset offset);

  @protected
  void _drawMinorTicks(PaintingContext context, Offset offset);

  @protected
  void _drawLabels(PaintingContext context, Offset offset, Offset labelOffset);

  @protected
  void _drawBorders(PaintingContext context, Offset offset);

  @protected
  void _drawMultilevelLabels(PaintingContext context, Offset offset);

  @protected
  void _drawTitle(PaintingContext context, Offset offset);
}

class _HorizontalAxisRenderer extends _AxisRenderer {
  _HorizontalAxisRenderer(RenderChartAxis axis) : super(axis: axis) {
    _gridLineRenderer = _HorizontalGridLineRenderer(axis);
    _plotBandRenderer = _HorizontalPlotBandRenderer(axis);
    _multilevelLabelBorderShape = _HorizontalMultilevelLabelBorderShape();
  }

  @override
  double _labelsMaxSize() {
    double maxHeight = 0.0;
    final int length = axis.visibleLabels.length;
    for (int i = 0; i < length; i++) {
      final AxisLabel label = axis.visibleLabels[i];
      maxHeight = max(maxHeight, label.labelSize.height);
    }

    return maxHeight;
  }

  @override
  double _multilevelLabelsTotalSize() {
    _multilevelLabelSizes.clear();
    double maxHeight = double.negativeInfinity;
    for (final AxisMultilevelLabel label in axis.visibleMultilevelLabels) {
      double height = label.actualTextSize.height;
      if (axis.multiLevelLabelStyle.borderType ==
          MultiLevelBorderType.curlyBrace) {
        height += 2 * textPaddingOfCurlyBrace;
      } else {
        height += 2 * textPadding;
      }

      _multilevelLabelSizes.update(
        label.level,
        (double value) => maxHeight = max(maxHeight, height),
        ifAbsent: () {
          maxHeight = double.negativeInfinity;
          return maxHeight = max(maxHeight, height);
        },
      );
    }

    return _multilevelLabelSizes.isEmpty
        ? 0
        : _multilevelLabelSizes.values.reduce((double a, double b) => a + b);
  }

  @override
  void _drawAxisLine(PaintingContext context, Offset offset) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = (axis.axisLine.color ?? axis.chartThemeData!.axisLineColor)!
      ..strokeWidth = axis.axisLine.width
      ..style = PaintingStyle.stroke;
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      drawDashes(
        context.canvas,
        axis.axisLine.dashArray,
        paint,
        start: offset,
        end: Offset(offset.dx + axis.size.width, offset.dy),
      );
    }
  }

  @override
  void _drawMajorTicks(PaintingContext context, Offset offset) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = (axis.majorTickLines.color ??
          axis.chartThemeData!.majorTickLineColor)!
      ..strokeWidth = axis.majorTickLines.width
      ..style = PaintingStyle.stroke;
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      for (final double position in axis.majorTickPositions) {
        final Offset start = offset.translate(position, 0.0);
        final Offset end = start.translate(0.0, axis.majorTickLines.size);
        context.canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  void _drawMinorTicks(PaintingContext context, Offset offset) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = (axis.minorTickLines.color ??
          axis.chartThemeData!.minorTickLineColor)!
      ..strokeWidth = axis.minorTickLines.width
      ..style = PaintingStyle.stroke;
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      for (final double position in axis.minorTickPositions) {
        final Offset start = offset.translate(position, 0.0);
        final Offset end = start.translate(0.0, axis.minorTickLines.size);
        context.canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  void _drawLabels(PaintingContext context, Offset offset, Offset labelOffset) {
    if (axis.visibleLabels.isEmpty) {
      return;
    }

    final AxisLabelIntersectAction action = axis.effectiveLabelIntersectAction;
    int rotationAngle = axis.labelRotation;
    if (axis._hasCollidingLabels) {
      if (action == AxisLabelIntersectAction.rotate90) {
        rotationAngle = angle90Degree;
      } else if (action == AxisLabelIntersectAction.rotate45) {
        rotationAngle = angle45Degree;
      }
    }

    final bool isOutSide = axis.labelPosition == ChartDataLabelPosition.outside;
    final List<AxisLabel> axisLabels = axis.visibleLabels;
    for (final AxisLabel label in axisLabels) {
      if (!label.isVisible || label.position == null || label.position!.isNaN) {
        continue;
      }

      double dy = labelOffset.dy;
      if ((axis.invertElementsOrder && isOutSide) ||
          (!axis.invertElementsOrder && !isOutSide)) {
        dy += _maxLabelSize - label.labelSize.height;
      }

      Offset position = Offset(labelOffset.dx + label.position!, dy);
      label.region = Rect.fromLTWH(position.dx, position.dy,
          label.labelSize.width, label.labelSize.height);
      position += offset;
      _drawLabel(context, position, label, rotationAngle);
    }
  }

  void _drawLabel(PaintingContext context, Offset position, AxisLabel label,
      int rotationAngle) {
    final TextSpan span =
        TextSpan(text: label.renderText, style: label.labelStyle);
    _textPainter
      ..text = span
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr;
    _textPainter.layout();
    if (rotationAngle == 0) {
      _textPainter.paint(context.canvas, position);
    } else {
      context.canvas
        ..save()
        ..translate(position.dx + label.labelSize.width / 2,
            position.dy + label.labelSize.height / 2)
        ..rotate(degreeToRadian(rotationAngle));
      _textPainter.paint(context.canvas,
          Offset(-_textPainter.size.width / 2, -_textPainter.size.height / 2));
      context.canvas.restore();
    }
  }

  @override
  void _drawBorders(PaintingContext context, Offset offset) {
    if (_axisBorderSize <= 0) {
      return;
    }

    final Color effectiveBorderColor =
        (axis.borderColor ?? axis.chartThemeData!.axisLineColor)!;
    if (effectiveBorderColor != Colors.transparent &&
        axis.borderWidth > 0 &&
        axis.borderPositions.isNotEmpty) {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..color = effectiveBorderColor
        ..strokeWidth = axis.borderWidth
        ..style = PaintingStyle.stroke;
      final double axisLeft = axis.paintBounds.left;
      final double axisRight = axis.paintBounds.right;
      final List<double> positions = axis.borderPositions;
      for (final double position in positions) {
        if (axisLeft <= position && axisRight >= position) {
          final Offset start = offset.translate(position, 0.0);
          final Offset end = start.translate(0.0, _axisBorderSize);
          context.canvas.drawLine(start, end, paint);
        }
      }

      if (axis.axisBorderType == AxisBorderType.rectangle) {
        Offset start = offset;
        Offset end = start.translate(axis.size.width, 0.0);
        context.canvas.drawLine(start, end, paint);

        start = start.translate(0.0, _axisBorderSize);
        end = end.translate(0.0, _axisBorderSize);
        context.canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  void _drawMultilevelLabels(PaintingContext context, Offset offset) {
    final List<AxisMultilevelLabel> labels = axis.visibleMultilevelLabels;
    final int length = labels.length;
    if (length > 0) {
      final MultiLevelBorderType borderType =
          axis.multiLevelLabelStyle.borderType;
      final Paint paint = Paint()
        ..color = (axis.multiLevelLabelStyle.borderColor ??
            axis.chartThemeData!.axisLineColor)!
        ..strokeWidth = axis.multiLevelLabelStyle.borderWidth != 0
            ? axis.multiLevelLabelStyle.borderWidth
            : axis.axisLine.width
        ..style = PaintingStyle.stroke;

      double top = offset.dy;
      int level = _multilevelLabelSizes.keys.first;
      double height = _multilevelLabelSizes[level]!;
      for (final AxisMultilevelLabel label in labels) {
        if (level != label.level) {
          top += height;
          level = label.level;
          height = _multilevelLabelSizes[level]!;
        }

        final TextSpan span = TextSpan(
            text: label.trimmedText,
            style: label.style.copyWith(
                color:
                    label.style.color ?? axis.chartThemeData!.axisLabelColor));
        _textPainter
          ..text = span
          ..textAlign = TextAlign.center
          ..textDirection = TextDirection.ltr
          ..layout();
        final Rect bounds = Rect.fromLTWH(offset.dx + label.region.left,
            top + label.region.top, label.region.width, height);
        _multilevelLabelBorderShape.onPaint(
            context, borderType, bounds, _textPainter, paint, axis);
      }
    }
  }

  @override
  void _drawTitle(PaintingContext context, Offset offset) {
    final TextStyle textStyle =
        axis.chartThemeData!.axisTitleTextStyle!.merge(axis.title.textStyle);
    final TextSpan span = TextSpan(
      text: axis.title.text,
      style: textStyle,
    );
    _textPainter
      ..text = span
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr;
    _textPainter.layout();

    late double x;
    switch (axis.title.alignment) {
      case ChartAlignment.near:
        x = offset.dx;
        break;
      case ChartAlignment.center:
        x = offset.dx + axis.size.width / 2 - _textPainter.size.width / 2;
        break;
      case ChartAlignment.far:
        x = offset.dx + axis.size.width - _textPainter.size.width;
        break;
    }

    _textPainter.paint(context.canvas, Offset(x, offset.dy));
  }
}

class _VerticalAxisRenderer extends _AxisRenderer {
  _VerticalAxisRenderer(RenderChartAxis axis) : super(axis: axis) {
    _gridLineRenderer = _VerticalGridLineRenderer(axis);
    _plotBandRenderer = _VerticalPlotBandRenderer(axis);
    _multilevelLabelBorderShape = _VerticalMultilevelLabelBorderShape();
  }

  @override
  double _labelsMaxSize() {
    double maxTextWidth = 0.0;
    final int length = axis.visibleLabels.length;
    for (int i = 0; i < length; i++) {
      final AxisLabel label = axis.visibleLabels[i];
      if (label.renderText.isEmpty) {
        continue;
      }

      maxTextWidth = max(maxTextWidth, label.labelSize.width);
    }

    return maxTextWidth;
  }

  @override
  double _multilevelLabelsTotalSize() {
    _multilevelLabelSizes.clear();
    double maxSize = double.negativeInfinity;
    for (final AxisMultilevelLabel label in axis.visibleMultilevelLabels) {
      double width = label.actualTextSize.width;
      if (axis.multiLevelLabelStyle.borderType ==
          MultiLevelBorderType.curlyBrace) {
        width += 2 * textPaddingOfCurlyBrace;
      } else {
        width += 2 * textPadding;
      }

      _multilevelLabelSizes.update(
        label.level,
        (double value) => maxSize = max(maxSize, width),
        ifAbsent: () {
          maxSize = double.negativeInfinity;
          return maxSize = max(maxSize, width);
        },
      );
    }

    return _multilevelLabelSizes.isEmpty
        ? 0
        : _multilevelLabelSizes.values.reduce((double a, double b) => a + b);
  }

  @override
  void _drawAxisLine(PaintingContext context, Offset offset) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = (axis.axisLine.color ?? axis.chartThemeData!.axisLineColor)!
      ..strokeWidth = axis.axisLine.width
      ..style = PaintingStyle.stroke;
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      drawDashes(
        context.canvas,
        axis.axisLine.dashArray,
        paint,
        start: offset,
        end: Offset(offset.dx, offset.dy + axis.size.height),
      );
    }
  }

  @override
  void _drawMajorTicks(PaintingContext context, Offset offset) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = (axis.majorTickLines.color ??
          axis.chartThemeData!.majorTickLineColor)!
      ..strokeWidth = axis.majorTickLines.width
      ..style = PaintingStyle.stroke;
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      for (final double position in axis.majorTickPositions) {
        final Offset start = offset.translate(0.0, position);
        final Offset end = start.translate(axis.majorTickLines.size, 0.0);
        context.canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  void _drawMinorTicks(PaintingContext context, Offset offset) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = (axis.minorTickLines.color ??
          axis.chartThemeData!.minorTickLineColor)!
      ..strokeWidth = axis.minorTickLines.width
      ..style = PaintingStyle.stroke;
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      for (final double position in axis.minorTickPositions) {
        final Offset start = offset.translate(0.0, position);
        final Offset end = start.translate(axis.minorTickLines.size, 0.0);
        context.canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  void _drawLabels(PaintingContext context, Offset offset, Offset labelOffset) {
    if (axis.visibleLabels.isEmpty) {
      return;
    }

    final AxisLabelIntersectAction action = axis.effectiveLabelIntersectAction;
    int rotationAngle = axis.labelRotation;
    if (axis._hasCollidingLabels) {
      if (action == AxisLabelIntersectAction.rotate90) {
        rotationAngle = angle90Degree;
      } else if (action == AxisLabelIntersectAction.rotate45) {
        rotationAngle = angle45Degree;
      }
    }

    final bool isOutSide = axis.labelPosition == ChartDataLabelPosition.outside;
    final List<AxisLabel> axisLabels = axis.visibleLabels;
    for (final AxisLabel label in axisLabels) {
      if (!label.isVisible || label.position == null || label.position!.isNaN) {
        continue;
      }

      double dx = labelOffset.dx;
      if ((axis.invertElementsOrder && isOutSide) ||
          (!axis.invertElementsOrder && !isOutSide)) {
        dx += _maxLabelSize - label.labelSize.width;
      }

      Offset position = Offset(dx, labelOffset.dy + label.position!);
      label.region = Rect.fromLTWH(position.dx, position.dy,
          label.labelSize.width, label.labelSize.height);
      position += offset;
      _drawLabel(context, position, label, rotationAngle);
    }
  }

  void _drawLabel(PaintingContext context, Offset position, AxisLabel label,
      int rotationAngle) {
    final TextSpan span =
        TextSpan(text: label.renderText, style: label.labelStyle);
    _textPainter
      ..text = span
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..layout();
    if (rotationAngle == 0) {
      _textPainter.paint(context.canvas, position);
    } else {
      context.canvas
        ..save()
        ..translate(position.dx + label.labelSize.width / 2,
            position.dy + label.labelSize.height / 2)
        ..rotate(degreeToRadian(rotationAngle));
      _textPainter.paint(context.canvas,
          Offset(-_textPainter.size.width / 2, -_textPainter.size.height / 2));
      context.canvas.restore();
    }
  }

  @override
  void _drawBorders(PaintingContext context, Offset offset) {
    if (_axisBorderSize <= 0) {
      return;
    }

    final Color effectiveBorderColor =
        (axis.borderColor ?? axis.chartThemeData!.axisLineColor)!;
    if (effectiveBorderColor != Colors.transparent &&
        axis.borderWidth > 0 &&
        axis.borderPositions.isNotEmpty) {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..color = effectiveBorderColor
        ..strokeWidth = axis.borderWidth
        ..style = PaintingStyle.stroke;
      final double axisTop = axis.paintBounds.top;
      final double axisBottom = axis.paintBounds.bottom;
      final List<double> positions = axis.borderPositions;
      for (final double position in positions) {
        if (axisTop <= position && axisBottom >= position) {
          final Offset start = offset.translate(0.0, position);
          final Offset end = start.translate(_axisBorderSize, 0.0);
          context.canvas.drawLine(start, end, paint);
        }
      }

      if (axis.axisBorderType == AxisBorderType.rectangle) {
        Offset start = offset;
        Offset end = start.translate(0.0, axis.size.height);
        context.canvas.drawLine(start, end, paint);

        start = start.translate(_axisBorderSize, 0.0);
        end = start.translate(0.0, axis.size.height);
        context.canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  void _drawMultilevelLabels(PaintingContext context, Offset offset) {
    final List<AxisMultilevelLabel> labels = axis.visibleMultilevelLabels;
    final int length = labels.length;
    if (length > 0) {
      final MultiLevelBorderType borderType =
          axis.multiLevelLabelStyle.borderType;
      final Paint paint = Paint()
        ..color = (axis.multiLevelLabelStyle.borderColor ??
            axis.chartThemeData!.axisLineColor)!
        ..strokeWidth = axis.multiLevelLabelStyle.borderWidth != 0
            ? axis.multiLevelLabelStyle.borderWidth
            : axis.axisLine.width
        ..style = PaintingStyle.stroke;

      double left = offset.dx;
      int level = _multilevelLabelSizes.keys.first;
      double width = _multilevelLabelSizes[level]!;
      for (final AxisMultilevelLabel label in labels) {
        if (level != label.level) {
          left += width;
          level = label.level;
          width = _multilevelLabelSizes[level]!;
        }

        final TextSpan span = TextSpan(
            text: label.trimmedText,
            style: label.style.copyWith(
                color:
                    label.style.color ?? axis.chartThemeData!.axisLabelColor));
        _textPainter
          ..text = span
          ..textAlign = TextAlign.center
          ..textDirection = TextDirection.ltr
          ..layout();
        final Rect bounds = Rect.fromLTWH(left + label.region.left,
            offset.dy + label.region.top, width, label.region.height);
        _multilevelLabelBorderShape.onPaint(
            context, borderType, bounds, _textPainter, paint, axis);
      }
    }
  }

  @override
  void _drawTitle(PaintingContext context, Offset offset) {
    final int rotationAngle = axis.invertElementsOrder ? 270 : 90;
    final TextStyle textStyle =
        axis.chartThemeData!.axisTitleTextStyle!.merge(axis.title.textStyle);
    final TextSpan span = TextSpan(text: axis.title.text, style: textStyle);
    _textPainter
      ..text = span
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr;
    _textPainter.layout();

    double x = offset.dx;
    if (!axis.invertElementsOrder) {
      x += _textPainter.height;
    }

    late double y;
    switch (axis.title.alignment) {
      case ChartAlignment.near:
        y = offset.dy + axis.size.height;
        if (!axis.invertElementsOrder) {
          y -= _textPainter.width;
        }
        break;
      case ChartAlignment.center:
        y = offset.dy +
            axis.size.height / 2 +
            (_textPainter.width / 2 * (axis.invertElementsOrder ? 1 : -1));
        break;
      case ChartAlignment.far:
        y = offset.dy;
        if (axis.invertElementsOrder) {
          y += _textPainter.width;
        }
        break;
    }

    context.canvas
      ..save()
      ..translate(x, y)
      ..rotate(degreeToRadian(rotationAngle));
    _textPainter.paint(context.canvas, Offset.zero);
    context.canvas.restore();
  }
}

abstract class _MultilevelLabelBorderShape {
  final double _curveBraceCurveSize = 10.0;

  double preferredSize(MultiLevelBorderType type) {
    switch (type) {
      case MultiLevelBorderType.rectangle:
      case MultiLevelBorderType.withoutTopAndBottom:
      case MultiLevelBorderType.squareBrace:
        return 0.0;

      case MultiLevelBorderType.curlyBrace:
        return 2 * _curveBraceCurveSize;
    }
  }

  void onPaint(
    PaintingContext context,
    MultiLevelBorderType type,
    Rect bounds,
    TextPainter labelPainter,
    Paint borderPaint,
    RenderChartAxis axis,
  ) {
    if (axis.parentData == null) {
      return;
    }
    final Rect clipRect = axis.labelPosition == ChartDataLabelPosition.inside
        ? axis.parent!.plotAreaBounds
        : (axis.parentData! as CartesianAxesParentData).offset & axis.size;
    final Rect extendedClipRect = clipRect.inflate(borderPaint.strokeWidth / 2);
    context.canvas.save();
    context.canvas.clipRect(extendedClipRect);
    final bool invertElementsOrder =
        axis.labelPosition == ChartDataLabelPosition.inside
            ? !axis.invertElementsOrder
            : axis.invertElementsOrder;
    switch (type) {
      case MultiLevelBorderType.rectangle:
        _drawRectangleBorder(context, bounds, labelPainter, borderPaint);
        break;
      case MultiLevelBorderType.withoutTopAndBottom:
        _drawBorderWithoutTopAndBottom(
            context, bounds, labelPainter, borderPaint);
        break;
      case MultiLevelBorderType.squareBrace:
        _drawSquareBraceBorder(
            context, bounds, labelPainter, borderPaint, invertElementsOrder);
        break;
      case MultiLevelBorderType.curlyBrace:
        _drawCurlyBraceBorder(
            context, bounds, labelPainter, borderPaint, invertElementsOrder);
        break;
    }
    context.canvas.restore();
  }

  void _drawRectangleBorder(PaintingContext context, Rect bounds,
      TextPainter labelPainter, Paint paint) {
    context.canvas.drawRect(bounds, paint);
    _drawLabelAtRectangleBorderCenter(context, labelPainter, bounds);
  }

  void _drawLabelAtRectangleBorderCenter(
      PaintingContext context, TextPainter labelPainter, Rect bounds) {
    labelPainter.paint(
        context.canvas,
        bounds.center.translate(
            -labelPainter.size.width / 2, -labelPainter.size.height / 2));
  }

  @protected
  void _drawBorderWithoutTopAndBottom(PaintingContext context, Rect bounds,
      TextPainter labelPainter, Paint paint);

  @protected
  void _drawSquareBraceBorder(PaintingContext context, Rect bounds,
      TextPainter labelPainter, Paint paint, bool isOpposed);

  @protected
  void _drawCurlyBraceBorder(PaintingContext context, Rect bounds,
      TextPainter labelPainter, Paint paint, bool isOpposed);
}

class _HorizontalMultilevelLabelBorderShape
    extends _MultilevelLabelBorderShape {
  @override
  void _drawBorderWithoutTopAndBottom(PaintingContext context, Rect bounds,
      TextPainter labelPainter, Paint paint) {
    context.canvas
      ..drawLine(bounds.topLeft, bounds.bottomLeft, paint)
      ..drawLine(bounds.topRight, bounds.bottomRight, paint);
    _drawLabelAtRectangleBorderCenter(context, labelPainter, bounds);
  }

  @override
  void _drawSquareBraceBorder(
    PaintingContext context,
    Rect bounds,
    TextPainter labelPainter,
    Paint paint,
    bool isOpposed,
  ) {
    final Offset labelOffset = bounds.center
        .translate(-labelPainter.size.width / 2, -labelPainter.size.height / 2);
    Offset labelStart =
        labelOffset.translate(0.0, labelPainter.size.height / 2);
    Offset labelEnd = labelStart.translate(labelPainter.size.width, 0.0);

    Offset topLeft = bounds.topLeft;
    Offset topRight = bounds.topRight;
    // Handling axis inversed.
    if (topLeft.dx > topRight.dx) {
      final Offset temp = labelEnd;
      labelEnd = labelStart;
      labelStart = temp;
    }

    if (isOpposed) {
      topLeft = bounds.bottomLeft;
      topRight = bounds.bottomRight;
    }

    final Offset centerLeft = bounds.centerLeft;
    final Offset centerRight = bounds.centerRight;
    context.canvas
      ..drawLine(topLeft, centerLeft, paint)
      ..drawLine(centerLeft, labelStart, paint)
      ..drawLine(labelEnd, centerRight, paint)
      ..drawLine(centerRight, topRight, paint);
    _drawLabelAtRectangleBorderCenter(context, labelPainter, bounds);
  }

  @override
  void _drawCurlyBraceBorder(
    PaintingContext context,
    Rect bounds,
    TextPainter labelPainter,
    Paint paint,
    bool isOpposed,
  ) {
    if (isOpposed) {
      _drawOpposedCurlyBraceBorder(bounds, context, labelPainter, paint);
    } else {
      _drawNormalCurlyBraceBorder(bounds, context, labelPainter, paint);
    }
  }

  void _drawNormalCurlyBraceBorder(Rect bounds, PaintingContext context,
      TextPainter labelPainter, Paint paint) {
    final Path path = Path();
    double left = bounds.left;
    double right = bounds.right;
    if (left > right) {
      final double temp = left;
      left = right;
      right = temp;
    }

    final Rect startCurveRegion = Rect.fromLTWH(
        left, bounds.top, _curveBraceCurveSize, _curveBraceCurveSize);
    final Rect centerStartCurveRegion = Rect.fromLTWH(
        bounds.center.dx - _curveBraceCurveSize,
        startCurveRegion.bottom,
        _curveBraceCurveSize,
        _curveBraceCurveSize);

    path
      ..moveTo(startCurveRegion.left, startCurveRegion.top)
      ..quadraticBezierTo(
          startCurveRegion.bottomLeft.dx,
          startCurveRegion.bottomLeft.dy,
          startCurveRegion.bottomRight.dx,
          startCurveRegion.bottomRight.dy)
      ..lineTo(centerStartCurveRegion.left, centerStartCurveRegion.top)
      ..quadraticBezierTo(
          centerStartCurveRegion.topRight.dx,
          centerStartCurveRegion.topRight.dy,
          centerStartCurveRegion.bottomRight.dx,
          centerStartCurveRegion.bottomRight.dy);

    final Rect centerEndCurveRegion = Rect.fromLTWH(bounds.center.dx,
        centerStartCurveRegion.top, _curveBraceCurveSize, _curveBraceCurveSize);
    final Rect endCurveRegion = Rect.fromLTWH(right - _curveBraceCurveSize,
        startCurveRegion.top, _curveBraceCurveSize, _curveBraceCurveSize);

    path
      ..quadraticBezierTo(
          centerEndCurveRegion.topLeft.dx,
          centerEndCurveRegion.topLeft.dy,
          centerEndCurveRegion.topRight.dx,
          centerEndCurveRegion.topRight.dy)
      ..lineTo(endCurveRegion.left, endCurveRegion.bottom)
      ..quadraticBezierTo(
          endCurveRegion.bottomRight.dx,
          endCurveRegion.bottomRight.dy,
          endCurveRegion.topRight.dx,
          endCurveRegion.topRight.dy);
    context.canvas.drawPath(path, paint);
    // TODO(VijayakumarM): Add label padding.
    labelPainter.paint(
        context.canvas,
        Offset(bounds.center.dx - labelPainter.size.width / 2,
            bounds.top + 2 * _curveBraceCurveSize));
  }

  void _drawOpposedCurlyBraceBorder(Rect bounds, PaintingContext context,
      TextPainter labelPainter, Paint paint) {
    final Path path = Path();
    double left = bounds.left;
    double right = bounds.right;
    if (left > right) {
      final double temp = left;
      left = right;
      right = temp;
    }

    final Rect startCurveRegion = Rect.fromLTWH(
        left,
        bounds.bottom - _curveBraceCurveSize,
        _curveBraceCurveSize,
        _curveBraceCurveSize);
    final Rect centerStartCurveRegion = Rect.fromLTWH(
        bounds.center.dx - _curveBraceCurveSize,
        startCurveRegion.top - _curveBraceCurveSize,
        _curveBraceCurveSize,
        _curveBraceCurveSize);

    path
      ..moveTo(startCurveRegion.left, startCurveRegion.bottom)
      ..quadraticBezierTo(
          startCurveRegion.topLeft.dx,
          startCurveRegion.topLeft.dy,
          startCurveRegion.topRight.dx,
          startCurveRegion.topRight.dy)
      ..lineTo(centerStartCurveRegion.left, centerStartCurveRegion.bottom)
      ..quadraticBezierTo(
          centerStartCurveRegion.bottomRight.dx,
          centerStartCurveRegion.bottomRight.dy,
          centerStartCurveRegion.topRight.dx,
          centerStartCurveRegion.topRight.dy);

    final Rect centerEndCurveRegion = Rect.fromLTWH(bounds.center.dx,
        centerStartCurveRegion.top, _curveBraceCurveSize, _curveBraceCurveSize);
    final Rect endCurveRegion = Rect.fromLTWH(right - _curveBraceCurveSize,
        startCurveRegion.top, _curveBraceCurveSize, _curveBraceCurveSize);

    path
      ..quadraticBezierTo(
          centerEndCurveRegion.bottomLeft.dx,
          centerEndCurveRegion.bottomLeft.dy,
          centerEndCurveRegion.bottomRight.dx,
          centerEndCurveRegion.bottomRight.dy)
      ..lineTo(endCurveRegion.left, endCurveRegion.top)
      ..quadraticBezierTo(
          endCurveRegion.topRight.dx,
          endCurveRegion.topRight.dy,
          endCurveRegion.bottomRight.dx,
          endCurveRegion.bottomRight.dy);
    context.canvas.drawPath(path, paint);
    // TODO(VijayakumarM): Add label padding.
    labelPainter.paint(context.canvas,
        Offset(bounds.center.dx - labelPainter.size.width / 2, bounds.top));
  }
}

class _VerticalMultilevelLabelBorderShape extends _MultilevelLabelBorderShape {
  @override
  void _drawBorderWithoutTopAndBottom(PaintingContext context, Rect bounds,
      TextPainter labelPainter, Paint paint) {
    context.canvas
      ..drawLine(bounds.topLeft, bounds.topRight, paint)
      ..drawLine(bounds.bottomLeft, bounds.bottomRight, paint);
    _drawLabelAtRectangleBorderCenter(context, labelPainter, bounds);
  }

  @override
  void _drawSquareBraceBorder(
    PaintingContext context,
    Rect bounds,
    TextPainter labelPainter,
    Paint paint,
    bool isOpposed,
  ) {
    Offset topLeft = bounds.topLeft;
    Offset bottomLeft = bounds.bottomLeft;

    final Offset labelOffset = bounds.center
        .translate(-labelPainter.size.width / 2, -labelPainter.size.height / 2);
    final double halfLabelWidth = labelPainter.size.width / 2;
    Offset labelStart =
        labelOffset.translate(halfLabelWidth, labelPainter.size.height);
    Offset labelEnd = labelOffset.translate(halfLabelWidth, 0.0);

    // Handling axis inversed.
    if (topLeft.dy < bottomLeft.dy) {
      final Offset temp = labelEnd;
      labelEnd = labelStart;
      labelStart = temp;
    }

    if (isOpposed) {
      topLeft = bounds.topRight;
      bottomLeft = bounds.bottomRight;
    }

    final Offset topCenter = bounds.topCenter;
    final Offset bottomCenter = bounds.bottomCenter;
    context.canvas
      ..drawLine(topLeft, topCenter, paint)
      ..drawLine(topCenter, labelStart, paint)
      ..drawLine(labelEnd, bottomCenter, paint)
      ..drawLine(bottomCenter, bottomLeft, paint);
    _drawLabelAtRectangleBorderCenter(context, labelPainter, bounds);
  }

  @override
  void _drawCurlyBraceBorder(
    PaintingContext context,
    Rect bounds,
    TextPainter labelPainter,
    Paint paint,
    bool isOpposed,
  ) {
    if (isOpposed) {
      _drawOpposedCurlyBraceBorder(bounds, context, labelPainter, paint);
    } else {
      _drawNormalCurlyBraceBorder(bounds, context, labelPainter, paint);
    }
  }

  void _drawNormalCurlyBraceBorder(Rect bounds, PaintingContext context,
      TextPainter labelPainter, Paint paint) {
    final Path path = Path();
    double top = bounds.top;
    double bottom = bounds.bottom;
    // Handling axis inversed.
    if (top > bottom) {
      final double temp = top;
      top = bottom;
      bottom = temp;
    }

    final Rect startCurveRegion = Rect.fromLTWH(
        bounds.left, top, _curveBraceCurveSize, _curveBraceCurveSize);
    final Rect centerStartCurveRegion = Rect.fromLTWH(
        startCurveRegion.left + _curveBraceCurveSize,
        bounds.center.dy - _curveBraceCurveSize,
        _curveBraceCurveSize,
        _curveBraceCurveSize);

    path
      ..moveTo(startCurveRegion.left, startCurveRegion.top)
      ..quadraticBezierTo(
          startCurveRegion.topRight.dx,
          startCurveRegion.topRight.dy,
          startCurveRegion.bottomRight.dx,
          startCurveRegion.bottomRight.dy)
      ..lineTo(centerStartCurveRegion.left, centerStartCurveRegion.top)
      ..quadraticBezierTo(
          centerStartCurveRegion.bottomLeft.dx,
          centerStartCurveRegion.bottomLeft.dy,
          centerStartCurveRegion.bottomRight.dx,
          centerStartCurveRegion.bottomRight.dy);

    final Rect centerEndCurveRegion = Rect.fromLTWH(centerStartCurveRegion.left,
        bounds.center.dy, _curveBraceCurveSize, _curveBraceCurveSize);
    final Rect endCurveRegion = Rect.fromLTWH(
        startCurveRegion.left,
        bottom - _curveBraceCurveSize,
        _curveBraceCurveSize,
        _curveBraceCurveSize);

    path
      ..quadraticBezierTo(
          centerEndCurveRegion.topLeft.dx,
          centerEndCurveRegion.topLeft.dy,
          centerEndCurveRegion.bottomLeft.dx,
          centerEndCurveRegion.bottomLeft.dy)
      ..lineTo(endCurveRegion.right, endCurveRegion.top)
      ..quadraticBezierTo(
          endCurveRegion.bottomRight.dx,
          endCurveRegion.bottomRight.dy,
          endCurveRegion.bottomLeft.dx,
          endCurveRegion.bottomLeft.dy);
    context.canvas.drawPath(path, paint);
    // TODO(VijayakumarM): Add label padding.
    labelPainter.paint(
        context.canvas,
        Offset(bounds.left + 2 * _curveBraceCurveSize,
            bounds.center.dy - labelPainter.size.height / 2));
  }

  void _drawOpposedCurlyBraceBorder(Rect bounds, PaintingContext context,
      TextPainter labelPainter, Paint paint) {
    final Path path = Path();
    double top = bounds.top;
    double bottom = bounds.bottom;
    // Handling axis inversed.
    if (top > bottom) {
      final double temp = top;
      top = bottom;
      bottom = temp;
    }

    final Rect startCurveRegion = Rect.fromLTWH(
        bounds.right - _curveBraceCurveSize,
        top,
        _curveBraceCurveSize,
        _curveBraceCurveSize);
    final Rect centerStartCurveRegion = Rect.fromLTWH(
        startCurveRegion.left - _curveBraceCurveSize,
        bounds.center.dy - _curveBraceCurveSize,
        _curveBraceCurveSize,
        _curveBraceCurveSize);

    path
      ..moveTo(startCurveRegion.right, startCurveRegion.top)
      ..quadraticBezierTo(
          startCurveRegion.topLeft.dx,
          startCurveRegion.topLeft.dy,
          startCurveRegion.bottomLeft.dx,
          startCurveRegion.bottomLeft.dy)
      ..lineTo(centerStartCurveRegion.right, centerStartCurveRegion.top)
      ..quadraticBezierTo(
          centerStartCurveRegion.bottomRight.dx,
          centerStartCurveRegion.bottomRight.dy,
          centerStartCurveRegion.bottomLeft.dx,
          centerStartCurveRegion.bottomLeft.dy);

    final Rect centerEndCurveRegion = Rect.fromLTWH(centerStartCurveRegion.left,
        bounds.center.dy, _curveBraceCurveSize, _curveBraceCurveSize);
    final Rect endCurveRegion = Rect.fromLTWH(
        startCurveRegion.left,
        bottom - _curveBraceCurveSize,
        _curveBraceCurveSize,
        _curveBraceCurveSize);

    path
      ..quadraticBezierTo(
          centerEndCurveRegion.topRight.dx,
          centerEndCurveRegion.topRight.dy,
          centerEndCurveRegion.bottomRight.dx,
          centerEndCurveRegion.bottomRight.dy)
      ..lineTo(endCurveRegion.left, endCurveRegion.top)
      ..quadraticBezierTo(
          endCurveRegion.bottomLeft.dx,
          endCurveRegion.bottomLeft.dy,
          endCurveRegion.bottomRight.dx,
          endCurveRegion.bottomRight.dy);
    context.canvas.drawPath(path, paint);
    // TODO(VijayakumarM): Add label padding.
    labelPainter.paint(context.canvas,
        Offset(bounds.left, bounds.center.dy - labelPainter.size.height / 2));
  }
}

/// Holds the axis label information.
///
/// Axis Label used by the user-specified or
/// by default to make the label for both x and y-axis.
///
/// Provides  options for label style, label size, text,
/// and value to customize the appearance.
class AxisLabel {
  /// Creating an argument constructor of [AxisLabel] class.
  AxisLabel(
    this.labelStyle,
    this.labelSize,
    this.text,
    this.value,
    this.trimmedText,
    this.renderText,
  );

  /// Specifies the label text style.
  ///
  /// The [TextStyle] is used to customize the chart title text style.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               primaryXAxis: CategoryAxis(
  ///                      labelStyle: TextStyle(color: Colors.black),
  ///                  )
  ///         );
  /// }
  /// ```
  TextStyle labelStyle;

  /// Hold the size of the label.
  Size labelSize;

  /// Contains the text of the label.
  String text;

  /// Contains the trimmed text of the label.
  String? trimmedText;

  /// Contains the label text to be rendered.
  String renderText = '';

  /// Holds the value of the visible range of the axis.
  late num value;

  /// Specifies the label position.
  double? position;

  /// Specifies the label visibility.
  bool isVisible = true;

  /// Specifies the label region.
  Rect? region;
}

/// This class Renders the major tick lines for axis.
///
/// To render major grid lines, create an instance of [MajorTickLines],
/// and assign it to the majorTickLines property of [ChartAxis].
/// The Major tick lines can be drawn for each axis on the plot area.
///
/// Provides options for [size], [width], and [color] to customize
/// the appearance.
class MajorTickLines {
  /// Creating an argument constructor of [MajorTickLines] class.
  const MajorTickLines({
    this.size = 5,
    this.width = 1,
    this.color,
  });

  /// Size of the major tick lines.
  ///
  /// Defaults to `8`.
  ///
  /// Size representation of the major ticks.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///                  majorTickLines: const MajorTickLines(
  ///                    size: 6
  ///                  )
  ///                 ),
  ///         )
  ///     );
  /// }
  /// ```
  final double size;

  /// Width of the major tick lines.
  ///
  /// Defaults to `1`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 majorTickLines: const MajorTickLines(
  ///                   width: 2
  ///                 )
  ///                ),
  ///        )
  ///    );
  /// }
  /// ```
  final double width;

  /// Colors of the major tick lines.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 majorTickLines: const MajorTickLines(
  ///                   color: Colors.black
  ///                 )
  ///                ),
  ///        )
  ///    );
  /// }
  /// ```
  final Color? color;
}

/// This class has the properties of minor tick lines.
///
/// To render minor grid lines, create an instance of [MinorTickLines],
/// and assign it to the minorTickLines property of [ChartAxis].
/// The Minor tick lines can be drawn for each axis on the plot area.
///
/// Provides the color option to change the [color] of the
/// tick line for the customization.
@immutable
class MinorTickLines {
  /// Creating an argument constructor of MinorTickLines class.
  const MinorTickLines({
    this.size = 3,
    this.width = 0.7,
    this.color,
  });

  /// Height of the minor tick lines.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///            minorTicksPerInterval: 5,
  ///            minorTickLines: MinorTickLines(
  ///            size: 5,
  ///           )
  ///         )
  ///        )
  ///   );
  /// }
  /// ```
  final double size;

  /// Width of the minor tick lines.
  ///
  /// Defaults to `0.7`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///            minorTicksPerInterval: 5,
  ///            minorTickLines: MinorTickLines(
  ///            width: 0.5,
  ///           )
  ///         )
  ///        )
  ///     );
  /// }
  /// ```
  final double width;

  /// Color of the minor tick lines.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///            minorTicksPerInterval: 5,
  ///            minorTickLines: MinorTickLines(
  ///            color:Colors.red,
  ///           )
  ///         )
  ///        )
  ///     );
  /// }
  /// ```
  final Color? color;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MinorTickLines &&
        other.size == size &&
        other.width == width &&
        other.color == color;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[size, width, color];
    return Object.hashAll(values);
  }
}

/// Customizes the major grid lines.
///
/// This class Renders the major grid lines for the axis.
///
/// To render major grid lines, create an instance of [MajorGridLines],
/// and assign it to the major gridLines property of [ChartAxis].
/// Major grid lines can be drawn for each axis on the plot area.
///
/// Provides options for [color], [width], and [dashArray]
/// to customize the appearance.
@immutable
class MajorGridLines {
  /// Creating an argument constructor of MajorGridLines class.
  const MajorGridLines({
    this.width = 0.7,
    this.color,
    this.dashArray,
  });

  /// Any number of values can be provided in the list. Odd value is considered
  /// as rendering size and even value is considered as a gap.
  ///
  /// Defaults to `[0,0]`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///                  majorGridLines: MajorGridLines(
  ///                    dashArray: [1,2]
  ///                  )
  ///                 ),
  ///         )
  ///      );
  /// }
  /// ```
  final List<double>? dashArray;

  /// Width of the major grid lines.
  ///
  /// Defaults to  `0.7`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///                  majorGridLines: MajorGridLines(
  ///                    width:2
  ///                  )
  ///                 ),
  ///         )
  ///      );
  /// }
  /// ```
  final double width;

  /// Color of the major grid lines.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///                  majorGridLines: MajorGridLines(
  ///                    color:Colors.red
  ///                  )
  ///                 ),
  ///         )
  ///      );
  /// }
  /// ```
  final Color? color;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MajorGridLines &&
        other.dashArray == dashArray &&
        other.width == width &&
        other.color == color;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[dashArray, width, color];
    return Object.hashAll(values);
  }
}

/// Customizes the minor grid lines.
///
/// To render minor grid lines, create an instance of [MinorGridLines],
/// and assign it to the property of [ChartAxis].
/// The Minor grid lines can be drawn for each axis on the plot area.
///
/// Provides the options of [width], [color], and [dashArray] values
/// to customize the appearance.
class MinorGridLines {
  /// Creating an argument constructor of MinorGridLines class.
  const MinorGridLines({
    this.width = 0.5,
    this.color,
    this.dashArray,
  });

  /// Any number of values can be provided in the list. Odd value is considered
  /// as rendering size and even value is considered as a gap.
  ///
  /// Defaults to `[0,0]`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///             minorTicksPerInterval: 5,
  ///             minorGridLines: MinorGridLines(
  ///             dashArray: <double>[10, 20],
  ///           )
  ///          )
  ///         )
  ///      );
  /// }
  /// ```
  final List<double>? dashArray;

  /// Width of the minor grid lines.
  ///
  /// Defaults to `0.5`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///             minorTicksPerInterval: 5,
  ///             minorGridLines: MinorGridLines(
  ///             width: 0.7,
  ///          )
  ///          )
  ///         )
  ///      );
  /// }
  /// ```
  final double width;

  /// Color of the minor grid lines.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///             minorTicksPerInterval: 5,
  ///             minorGridLines: MinorGridLines(
  ///             color: Colors.red,
  ///          ),
  ///          )
  ///         ));
  /// }
  /// ```
  final Color? color;
}

/// This class consists of axis line properties.
///
/// It has the public properties to customize the axis line by increasing or
/// decreasing the width of the axis line and render the axis line with dashes
/// by defining the [dashArray] value.
///
/// Provides options for color, dash array, and width to customize the
/// appearance of the axis line.
class AxisLine {
  /// Creating an argument constructor of AxisLine class.
  const AxisLine({
    this.color,
    this.dashArray,
    this.width = 1,
  });

  /// Width of the axis line.
  ///
  /// Defaults to `1`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///                  axisLine:AxisLine(
  ///                    width: 2
  ///                  )
  ///                 ),
  ///         )
  ///     );
  /// }
  /// ```
  final double width;

  /// Color of the axis line. Color will be applied based on the brightness
  /// property of the app.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///                  axisLine:AxisLine(
  ///                    color:Colors.blue,
  ///                  )
  ///                 ),
  ///         ));
  /// }
  /// ```
  final Color? color;

  /// Dashes of the axis line. Any number of values can be provided in the list.
  /// Odd value is considered as rendering size and even value is
  /// considered as gap.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///                  axisLine:AxisLine(
  ///                    dashArray: <double>[5,5],
  ///                  )
  ///                 ),
  ///         )
  ///      );
  /// }
  /// ```
  final List<double>? dashArray;
}

/// This class holds the property of the axis title.
///
/// It has public properties to customize the text and font of the axis title.
/// Axis does not display title by default.
/// Use of the property will customize the title.
///
/// Provides text, text style, and text alignment options for
/// customization of appearance.
class AxisTitle {
  /// Creating an argument constructor of AxisTitle class.
  const AxisTitle({
    this.text,
    this.textStyle,
    this.alignment = ChartAlignment.center,
  });

  /// Text to be displayed as axis title.
  ///
  /// Defaults to `‘’`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///                  title: AxisTitle(
  ///                    text: 'Axis Title',
  ///                  )
  ///                 ),
  ///         )
  ///      );
  /// }
  /// ```
  final String? text;

  /// Customizes the appearance of text in axis title.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///                  title: AxisTitle(
  ///                    text: 'Axis Title',
  ///                    textStyle: TextStyle(
  ///                      color: Colors.blue,
  ///                      fontStyle: FontStyle.italic,
  ///                      fontWeight: FontWeight.w600,
  ///                      fontFamily: 'Roboto'
  ///                    )
  ///                  )
  ///                 ),
  ///         )
  ///    );
  /// }
  /// ```
  final TextStyle? textStyle;

  /// Aligns the axis title.
  ///
  /// It is applicable for both vertical and horizontal axes.
  ///
  /// * `ChartAlignment.near`, moves the axis title to the beginning of the axis
  ///
  /// * `ChartAlignment.far`, moves the axis title to the end of the axis
  ///
  /// * `ChartAlignment.center`, moves the axis title to the center
  /// position of the axis.
  ///
  /// Defaults to `ChartAlignment.center`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             primaryXAxis: NumericAxis(
  ///                  title: AxisTitle(
  ///                    text: 'Axis Title',
  ///                    alignment: ChartAlignment.far,
  ///                  )
  ///                 ),
  ///         )
  ///     );
  /// }
  /// ```
  final ChartAlignment alignment;
}

abstract class ChartAxisController {
  ChartAxisController(this.axis);

  final RenderChartAxis axis;
  final List<VoidCallback> _zoomListeners = <VoidCallback>[];

  Tween<double>? _zoomFactorTween;
  Tween<double>? _zoomPositionTween;
  DoubleRange? _actualRange;
  bool _isVisibleMinChanged = false;
  bool _isVisibleMaxChanged = false;

  VoidCallback? get _onUpdateInitialZoomFactorAndPosition;

  double get previousZoomFactor => _previousZoomFactor;
  double _previousZoomFactor = 1.0;

  double get previousZoomPosition => _previousZoomPosition;
  double _previousZoomPosition = 0.0;

  double get zoomFactor => _zoomFactorTween != null && axis._animation != null
      ? _zoomFactorTween!.evaluate(axis._animation!)
      : _zoomFactor;
  double _zoomFactor = 1.0;
  set zoomFactor(double value) {
    _zoomFactor = value;
    if (_onUpdateInitialZoomFactorAndPosition != null ||
        (!_isVisibleMinChanged && !_isVisibleMaxChanged)) {
      _updateZoomFactorTween(_zoomFactor, _zoomFactor);
    }
    _notifyZoomFactorAndPositionListener();
  }

  double get zoomPosition =>
      _zoomPositionTween != null && axis._animation != null
          ? _zoomPositionTween!.evaluate(axis._animation!)
          : _zoomPosition;
  double _zoomPosition = 0.0;
  set zoomPosition(double value) {
    _zoomPosition = value;
    if (_onUpdateInitialZoomFactorAndPosition != null ||
        (!_isVisibleMinChanged && !_isVisibleMaxChanged)) {
      _updateZoomPositionTween(_zoomPosition, _zoomPosition);
    }
    _notifyZoomFactorAndPositionListener();
  }

  void _updateActualRange(DoubleRange range) {
    _actualRange = range;
    _onUpdateInitialZoomFactorAndPosition?.call();
    _isVisibleMinChanged = false;
    _isVisibleMaxChanged = false;
  }

  void _updateZoomFactorAndPosition(num? min, num? max) {
    if (_actualRange == null) {
      return;
    }

    final num actualMin = _actualRange!.minimum;
    final num actualMax = _actualRange!.maximum;
    final num visibleMin = min ?? actualMin;
    final num visibleMax = max ?? actualMax;
    zoomFactor = (visibleMax - visibleMin) / _actualRange!.delta;
    zoomPosition = (visibleMin - actualMin) / _actualRange!.delta;

    if (_onUpdateInitialZoomFactorAndPosition != null) {
      return;
    }

    final DoubleRange? visibleRange = axis.visibleRange;
    final num currentVisibleMin = visibleRange?.minimum ?? actualMin;
    final num currentVisibleMax = visibleRange?.maximum ?? actualMax;
    _previousZoomFactor =
        (currentVisibleMax - currentVisibleMin) / _actualRange!.delta;
    _previousZoomPosition =
        (currentVisibleMin - actualMin) / _actualRange!.delta;

    _updateZoomFactorTween(_previousZoomFactor, _zoomFactor);
    _updateZoomPositionTween(_previousZoomPosition, _zoomPosition);

    if (axis.rangeController != null) {
      // We have set false for this properties in startAnimation method,
      // but rangeController returned here before calling startAnimation method.
      // So, handled here.
      _isVisibleMaxChanged = false;
      _isVisibleMinChanged = false;
      return;
    }

    _startAnimation();
  }

  void _updateZoomFactorTween(double? start, double? end) {
    if (_zoomFactorTween != null) {
      _zoomFactorTween!.begin = start;
      _zoomFactorTween!.end = end;
    } else {
      _zoomFactorTween = Tween<double>(begin: start, end: end);
    }
  }

  void _updateZoomPositionTween(double? start, double? end) {
    if (_zoomPositionTween != null) {
      _zoomPositionTween!.begin = start;
      _zoomPositionTween!.end = end;
    } else {
      _zoomPositionTween = Tween<double>(begin: start, end: end);
    }
  }

  void _startAnimation() {
    if (axis.zoomingInProgress) {
      return;
    }

    if (_isVisibleMinChanged) {
      axis._animationController?.forward(from: 0.0);
      _isVisibleMinChanged = false;
    }

    if (_isVisibleMaxChanged) {
      axis._animationController?.forward(from: 0.0);
      _isVisibleMaxChanged = false;
    }
  }

  void _handleAnimationCompleted() {
    if (_zoomFactorTween != null && _zoomFactorTween!.end != null) {
      _zoomFactor = _zoomFactorTween!.end!;
    }
    if (_zoomPositionTween != null && _zoomPositionTween!.end != null) {
      _zoomPosition = _zoomPositionTween!.end!;
    }
  }

  void _addZoomFactorAndPositionListener(VoidCallback listener) {
    _zoomListeners.add(listener);
  }

  void _removeZoomFactorAndPositionListener(VoidCallback listener) {
    _zoomListeners.remove(listener);
  }

  @protected
  void _notifyZoomFactorAndPositionListener() {
    for (final VoidCallback listener in _zoomListeners) {
      listener();
    }
  }

  void dispose() {
    _zoomListeners.clear();
  }
}

class CategoryAxisController extends ChartAxisController {
  CategoryAxisController(super.axis);

  @override
  VoidCallback? get _onUpdateInitialZoomFactorAndPosition =>
      _updateInitialZoomFactorAndPosition;
  late VoidCallback? _updateInitialZoomFactorAndPosition =
      _applyInitialZoomFactorAndPosition;

  double? get visibleMinimum => _visibleMin();
  double? _visibleMinimum;
  set visibleMinimum(double? value) {
    if (visibleMinimum != value) {
      _visibleMinimum = value;
      _updateMinMaxIfNeeded();
      _isVisibleMinChanged = true;
      _updateZoomFactorAndPosition(_visibleMinimum, _visibleMaximum);
    }
  }

  double? get visibleMaximum => _visibleMax();
  double? _visibleMaximum;
  set visibleMaximum(double? value) {
    if (visibleMaximum != value) {
      _visibleMaximum = value;
      _updateMinMaxIfNeeded();
      _isVisibleMaxChanged = true;
      _updateZoomFactorAndPosition(_visibleMinimum, _visibleMaximum);
    }
  }

  void _updateMinMaxIfNeeded() {
    if (_visibleMinimum != null &&
        _visibleMaximum != null &&
        _visibleMinimum == _visibleMaximum) {
      if (axis.labelPlacement == LabelPlacement.onTicks) {
        _visibleMaximum = _visibleMaximum! + 1;
      } else {
        _visibleMinimum = _visibleMinimum! - 0.5;
        _visibleMaximum = _visibleMaximum! + 0.5;
      }
    }
  }

  void _applyInitialZoomFactorAndPosition() {
    if (zoomFactor == 1.0 && zoomPosition == 0.0) {
      _updateZoomFactorAndPosition(_visibleMinimum, _visibleMaximum);
    }
    _visibleMinimum = null;
    _visibleMaximum = null;
    _updateInitialZoomFactorAndPosition = null;
  }

  double? _visibleMin() {
    if (_actualRange == null || axis.visibleRange == null) {
      return _visibleMinimum;
    }
    return axis.visibleRange!.minimum.toDouble();
  }

  double? _visibleMax() {
    if (_actualRange == null || axis.visibleRange == null) {
      return _visibleMaximum;
    }
    return axis.visibleRange!.maximum.toDouble();
  }
}

class DateTimeAxisController extends ChartAxisController {
  DateTimeAxisController(super.axis);

  @override
  VoidCallback? get _onUpdateInitialZoomFactorAndPosition =>
      _updateInitialZoomFactorAndPosition;
  late VoidCallback? _updateInitialZoomFactorAndPosition =
      _applyInitialZoomFactorAndPosition;

  double? _visibleMinimumInMs;
  double? _visibleMaximumInMs;

  DateTime? get visibleMinimum => _visibleMin();
  DateTime? _visibleMinimum;
  set visibleMinimum(DateTime? value) {
    if (visibleMinimum != value) {
      _visibleMinimum = value;
      _updateMinMaxIfNeeded();
      _isVisibleMinChanged = true;
      _updateZoomFactorAndPosition(_visibleMinimumInMs, _visibleMaximumInMs);
    }
  }

  DateTime? get visibleMaximum => _visibleMax();
  DateTime? _visibleMaximum;
  set visibleMaximum(DateTime? value) {
    if (visibleMaximum != value) {
      _visibleMaximum = value;
      _updateMinMaxIfNeeded();
      _isVisibleMaxChanged = true;
      _updateZoomFactorAndPosition(_visibleMinimumInMs, _visibleMaximumInMs);
    }
  }

  void _updateMinMaxIfNeeded() {
    _visibleMinimumInMs = null;
    if (_visibleMinimum != null) {
      _visibleMinimumInMs = _visibleMinimum!.millisecondsSinceEpoch.toDouble();
    }

    _visibleMaximumInMs = null;
    if (_visibleMaximum != null) {
      _visibleMaximumInMs = _visibleMaximum!.millisecondsSinceEpoch.toDouble();
    }

    if (_visibleMinimumInMs == _visibleMaximumInMs) {
      _visibleMinimumInMs = _visibleMinimumInMs! - defaultTimeStamp;
      _visibleMaximumInMs = _visibleMaximumInMs! + defaultTimeStamp;
    }
  }

  void _applyInitialZoomFactorAndPosition() {
    if (zoomFactor == 1.0 && zoomPosition == 0.0) {
      _updateZoomFactorAndPosition(_visibleMinimumInMs, _visibleMaximumInMs);
    }
    _visibleMinimum = null;
    _visibleMaximum = null;
    _updateInitialZoomFactorAndPosition = null;
  }

  DateTime? _visibleMin() {
    if (_actualRange == null || axis.visibleRange == null) {
      return _visibleMinimum;
    }
    return DateTime.fromMillisecondsSinceEpoch(
        axis.visibleRange!.minimum.toInt());
  }

  DateTime? _visibleMax() {
    if (_actualRange == null || axis.visibleRange == null) {
      return _visibleMaximum;
    }
    return DateTime.fromMillisecondsSinceEpoch(
        axis.visibleRange!.maximum.toInt());
  }
}

class DateTimeCategoryAxisController extends ChartAxisController {
  DateTimeCategoryAxisController(this._dateAxis) : super(_dateAxis);

  final RenderDateTimeCategoryAxis _dateAxis;

  num? _visibleMinimumIndex;
  num? _visibleMaximumIndex;

  @override
  VoidCallback? get _onUpdateInitialZoomFactorAndPosition =>
      _updateInitialZoomFactorAndPosition;
  late VoidCallback? _updateInitialZoomFactorAndPosition =
      _applyInitialZoomFactorAndPosition;

  DateTime? get visibleMinimum => _visibleMin();
  DateTime? _visibleMinimum;
  set visibleMinimum(DateTime? value) {
    if (visibleMinimum != value) {
      _visibleMinimum = value;
      if (_dateAxis.labels.isNotEmpty) {
        _updateMinMaxIfNeeded();
        _isVisibleMinChanged = true;
        _updateZoomFactorAndPosition(
            _visibleMinimumIndex, _visibleMaximumIndex);
      }
    }
  }

  DateTime? get visibleMaximum => _visibleMax();
  DateTime? _visibleMaximum;
  set visibleMaximum(DateTime? value) {
    if (visibleMaximum != value) {
      _visibleMaximum = value;
      if (_dateAxis.labels.isNotEmpty) {
        _updateMinMaxIfNeeded();
        _isVisibleMaxChanged = true;
        _updateZoomFactorAndPosition(
            _visibleMinimumIndex, _visibleMaximumIndex);
      }
    }
  }

  @override
  void _updateActualRange(DoubleRange range) {
    if (_actualRange != null) {
      return;
    }
    _actualRange = range;
    if (_visibleMinimumIndex == null &&
        _visibleMaximumIndex == null &&
        _dateAxis.labels.isNotEmpty) {
      _visibleMinimumIndex = _dateAxis.effectiveValue(_visibleMinimum);
      _visibleMaximumIndex =
          _dateAxis.effectiveValue(_visibleMaximum, needMin: false);
      if (axis.labelPlacement == LabelPlacement.betweenTicks) {
        if (_visibleMinimumIndex != null) {
          _visibleMinimumIndex = _visibleMinimumIndex! - 0.5;
        }
        if (_visibleMaximumIndex != null) {
          _visibleMaximumIndex = _visibleMaximumIndex! - 0.5;
        }
      }
      _updateMinMaxIfNeeded();
      if (_visibleMaximumIndex != null && _visibleMinimumIndex != null) {
        _updateZoomFactorAndPosition(
            _visibleMinimumIndex, _visibleMaximumIndex);
      }
    }
    _onUpdateInitialZoomFactorAndPosition?.call();
  }

  void _updateMinMaxIfNeeded() {
    _visibleMinimumIndex = null;
    if (_visibleMinimum != null) {
      _visibleMinimumIndex = _dateAxis.effectiveValue(_visibleMinimum);
      if (axis.labelPlacement == LabelPlacement.betweenTicks) {
        _visibleMinimumIndex = _visibleMinimumIndex! - 0.5;
      }
    }

    _visibleMaximumIndex = null;
    if (_visibleMaximum != null) {
      _visibleMaximumIndex =
          _dateAxis.effectiveValue(_visibleMaximum, needMin: false);
      if (axis.labelPlacement == LabelPlacement.betweenTicks) {
        _visibleMaximumIndex = _visibleMaximumIndex! + 0.5;
      }
    }

    if (_visibleMinimumIndex != null &&
        _visibleMaximumIndex != null &&
        _visibleMinimumIndex == _visibleMaximumIndex) {
      if (axis.labelPlacement == LabelPlacement.onTicks) {
        _visibleMaximumIndex = _visibleMaximumIndex! + 1;
      } else {
        _visibleMinimumIndex = _visibleMinimumIndex! - 0.5;
        _visibleMaximumIndex = _visibleMaximumIndex! + 0.5;
      }
    }
  }

  void _applyInitialZoomFactorAndPosition() {
    if (zoomFactor == 1.0 && zoomPosition == 0.0) {
      _updateZoomFactorAndPosition(_visibleMinimumIndex, _visibleMaximumIndex);
    }
    _visibleMinimum = null;
    _visibleMaximum = null;
    _updateInitialZoomFactorAndPosition = null;
  }

  DateTime? _visibleMin() {
    if (_actualRange == null || axis.visibleRange == null) {
      return _visibleMinimum;
    }
    return DateTime.fromMillisecondsSinceEpoch(
        axis.visibleRange!.minimum.toInt());
  }

  DateTime? _visibleMax() {
    if (_actualRange == null || axis.visibleRange == null) {
      return _visibleMaximum;
    }
    return DateTime.fromMillisecondsSinceEpoch(
        axis.visibleRange!.maximum.toInt());
  }
}

class LogarithmicAxisController extends ChartAxisController {
  LogarithmicAxisController(this._logAxis) : super(_logAxis);

  final RenderLogarithmicAxis _logAxis;

  @override
  VoidCallback? get _onUpdateInitialZoomFactorAndPosition =>
      _updateInitialZoomFactorAndPosition;
  late VoidCallback? _updateInitialZoomFactorAndPosition =
      _applyInitialZoomFactorAndPosition;

  num? _logVisibleMin;
  num? _logVisibleMax;

  double? get visibleMinimum => _visibleMin();
  double? _visibleMinimum;
  set visibleMinimum(double? value) {
    if (visibleMinimum != value) {
      _visibleMinimum = value;
      _updateMinMaxIfNeeded();
      _isVisibleMinChanged = true;
      _updateZoomFactorAndPosition(_logVisibleMin, _logVisibleMax);
    }
  }

  double? get visibleMaximum => _visibleMax();
  double? _visibleMaximum;
  set visibleMaximum(double? value) {
    if (visibleMaximum != value) {
      _visibleMaximum = value;
      _updateMinMaxIfNeeded();
      _isVisibleMaxChanged = true;
      _updateZoomFactorAndPosition(_logVisibleMin, _logVisibleMax);
    }
  }

  void _updateMinMaxIfNeeded() {
    if (_visibleMinimum != null) {
      _logVisibleMin = _logAxis.toLog(_visibleMinimum!).floor();
    }
    if (_visibleMaximum != null) {
      _logVisibleMax = _logAxis.toLog(_visibleMaximum!).ceil();
    }
    if (_logVisibleMax != null && _logVisibleMin == _logVisibleMax) {
      _logVisibleMax = _logVisibleMax! + 1;
    }
  }

  void _applyInitialZoomFactorAndPosition() {
    if (zoomFactor == 1.0 && zoomPosition == 0.0) {
      _updateZoomFactorAndPosition(_logVisibleMin, _logVisibleMax);
    }
    _visibleMinimum = null;
    _visibleMaximum = null;
    _updateInitialZoomFactorAndPosition = null;
  }

  double? _visibleMin() {
    if (_actualRange == null || axis.visibleRange == null) {
      return _visibleMinimum;
    }
    return _logAxis.toPow(axis.visibleRange!.minimum).toDouble();
  }

  double? _visibleMax() {
    if (_actualRange == null || axis.visibleRange == null) {
      return _visibleMaximum;
    }
    return _logAxis.toPow(axis.visibleRange!.maximum).toDouble();
  }
}

class NumericAxisController extends ChartAxisController {
  NumericAxisController(super.axis);

  @override
  VoidCallback? get _onUpdateInitialZoomFactorAndPosition =>
      _updateInitialZoomFactorAndPosition;
  late VoidCallback? _updateInitialZoomFactorAndPosition =
      _applyInitialZoomFactorAndPosition;

  double? get visibleMinimum => _visibleMin();
  double? _visibleMinimum;
  set visibleMinimum(double? value) {
    if (visibleMinimum != value) {
      _visibleMinimum = value;
      _updateMinMaxIfNeeded();
      _isVisibleMinChanged = true;
      _updateZoomFactorAndPosition(_visibleMinimum, _visibleMaximum);
    }
  }

  double? get visibleMaximum => _visibleMax();
  double? _visibleMaximum;
  set visibleMaximum(double? value) {
    if (visibleMaximum != value) {
      _visibleMaximum = value;
      _updateMinMaxIfNeeded();
      _isVisibleMaxChanged = true;
      _updateZoomFactorAndPosition(_visibleMinimum, _visibleMaximum);
    }
  }

  void _updateMinMaxIfNeeded() {
    if (_visibleMaximum != null && _visibleMinimum == _visibleMaximum) {
      _visibleMaximum = _visibleMaximum! + 1;
    }
  }

  void _applyInitialZoomFactorAndPosition() {
    if (zoomFactor == 1.0 && zoomPosition == 0.0) {
      _updateZoomFactorAndPosition(_visibleMinimum, _visibleMaximum);
    }
    _visibleMinimum = null;
    _visibleMaximum = null;
    _updateInitialZoomFactorAndPosition = null;
  }

  double? _visibleMin() {
    if (_actualRange == null || axis.visibleRange == null) {
      return _visibleMinimum;
    }
    return axis.visibleRange?.minimum.toDouble();
  }

  double? _visibleMax() {
    if (_actualRange == null || axis.visibleRange == null) {
      return _visibleMaximum;
    }
    return axis.visibleRange?.maximum.toDouble();
  }
}
