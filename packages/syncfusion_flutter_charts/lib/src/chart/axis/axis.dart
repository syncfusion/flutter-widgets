import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../common/event_args.dart';
import '../../common/rendering_details.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/helper.dart';
import '../../common/utils/typedef.dart'
    show MultiLevelLabelFormatterCallback, ChartLabelFormatterCallback;
import '../axis/axis_renderer.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/multi_level_labels.dart';
import '../axis/numeric_axis.dart';
import '../axis/plotband.dart';
import '../base/chart_base.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/interactive_tooltip.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// This class holds the properties of ChartAxis.
///
/// Charts typically have two axes that are used to measure and categorize data: a vertical (Y) axis, and a horizontal (X) axis.
/// Vertical(Y) axis always uses a numerical scale. Horizontal(X) axis supports Category, Numeric, Date-time, Logarithmic.
///
/// Provides the options for plotOffset, series visible, axis title, label padding, and alignment to customize the appearance.
///
///
abstract class ChartAxis {
  /// Creating an argument constructor of ChartAxis class.
  ChartAxis(
      {this.name,
      double? plotOffset,
      bool? isVisible,
      bool? anchorRangeToVisiblePoints,
      AxisTitle? title,
      AxisLine? axisLine,
      ChartRangePadding? rangePadding,
      int? labelRotation,
      ChartDataLabelPosition? labelPosition,
      LabelAlignment? labelAlignment,
      TickPosition? tickPosition,
      MajorTickLines? majorTickLines,
      MinorTickLines? minorTickLines,
      this.labelStyle,
      AxisLabelIntersectAction? labelIntersectAction,
      this.desiredIntervals,
      MajorGridLines? majorGridLines,
      MinorGridLines? minorGridLines,
      int? maximumLabels,
      int? minorTicksPerInterval,
      bool? isInversed,
      bool? opposedPosition,
      EdgeLabelPlacement? edgeLabelPlacement,
      bool? enableAutoIntervalOnZooming,
      double? zoomFactor,
      double? zoomPosition,
      InteractiveTooltip? interactiveTooltip,
      this.interval,
      this.crossesAt,
      this.associatedAxisName,
      bool? placeLabelsNearAxisLine,
      List<PlotBand>? plotBands,
      this.rangeController,
      this.maximumLabelWidth,
      this.labelsExtent,
      this.autoScrollingDelta,
      AutoScrollingMode? autoScrollingMode,
      double? borderWidth,
      Color? borderColor,
      AxisBorderType? axisBorderType,
      MultiLevelLabelStyle? multiLevelLabelStyle,
      this.multiLevelLabelFormatter,
      this.multiLevelLabels,
      this.axisLabelFormatter})
      : isVisible = isVisible ?? true,
        anchorRangeToVisiblePoints = anchorRangeToVisiblePoints ?? true,
        interactiveTooltip = interactiveTooltip ?? const InteractiveTooltip(),
        isInversed = isInversed ?? false,
        plotOffset = plotOffset ?? 0,
        placeLabelsNearAxisLine = placeLabelsNearAxisLine ?? true,
        opposedPosition = opposedPosition ?? false,
        rangePadding = rangePadding ?? ChartRangePadding.auto,
        labelRotation = labelRotation ?? 0,
        labelPosition = labelPosition ?? ChartDataLabelPosition.outside,
        labelAlignment = labelAlignment ?? LabelAlignment.center,
        tickPosition = tickPosition ?? TickPosition.outside,
        labelIntersectAction =
            labelIntersectAction ?? AxisLabelIntersectAction.hide,
        minorTicksPerInterval = minorTicksPerInterval ?? 0,
        maximumLabels = maximumLabels ?? 3,
        title = title ?? AxisTitle(),
        axisLine = axisLine ?? const AxisLine(),
        majorTickLines = majorTickLines ?? const MajorTickLines(),
        minorTickLines = minorTickLines ?? const MinorTickLines(),
        majorGridLines = majorGridLines ?? const MajorGridLines(),
        minorGridLines = minorGridLines ?? const MinorGridLines(),
        edgeLabelPlacement = edgeLabelPlacement ?? EdgeLabelPlacement.none,
        zoomFactor = zoomFactor ?? 1,
        zoomPosition = zoomPosition ?? 0,
        enableAutoIntervalOnZooming = enableAutoIntervalOnZooming ?? true,
        plotBands = plotBands ?? <PlotBand>[],
        autoScrollingMode = autoScrollingMode ?? AutoScrollingMode.end,
        axisBorderType = axisBorderType ?? AxisBorderType.rectangle,
        borderColor = borderColor ?? Colors.transparent,
        borderWidth = borderWidth ?? 0.0,
        multiLevelLabelStyle =
            multiLevelLabelStyle ?? const MultiLevelLabelStyle();

  /// Toggles the visibility of the axis.
  ///
  /// Visibility of all the elements in the axis
  /// such as title, labels, major tick lines, and major grid lines will be toggled together.
  ///
  /// Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(isVisible: false),
  ///        )
  ///    );
  ///}
  ///```
  final bool isVisible;

  /// Determines the value axis range, based on the visible data points or based
  /// on the overall data points available in chart.
  ///
  /// By default, value axis range will be calculated automatically based on the visible data points on
  /// dynamic changes. The visible data points are changed on performing interactions like pinch
  /// zooming, selection zooming, panning and also on specifying `visibleMinimum` and `visibleMaximum` values.
  ///
  /// To toggle this functionality, this property can be used. i.e. on setting false to this property,
  /// value axis range will be calculated based on all the data points in chart irrespective of
  /// visible points.
  ///
  /// _Note:_ This is applicable only to the value axis and not for other axis.
  ///
  /// Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: NumericAxis(anchorRangeToVisiblePoints: false),
  ///        )
  ///    );
  ///}
  ///```
  final bool anchorRangeToVisiblePoints;

  /// Customizes the appearance of the axis line. The axis line is visible by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(axisLine: AxisLine(width: 10)),
  ///        )
  ///    );
  ///}
  ///```
  final AxisLine axisLine;

  /// Customizes the appearance of the major tick lines.
  ///
  /// Major ticks are small lines
  /// used to indicate the intervals in an axis. Major tick lines are visible by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(majorTickLines: const MajorTickLines(width: 2)),
  ///        )
  ///    );
  ///}
  ///```
  final MajorTickLines majorTickLines;

  /// Customizes the appearance of the minor tick lines.
  ///
  /// Minor ticks are small lines
  /// used to indicate the minor intervals between a major interval.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(minorTickLines: MinorTickLines(width: 2)),
  ///        )
  ///    );
  ///}
  ///```
  final MinorTickLines minorTickLines;

  /// Customizes the appearance of the major grid lines.
  ///
  /// Major grids are the lines
  /// drawn on the plot area at all the major intervals in an axis. Major grid lines
  /// are visible by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 2)),
  ///        )
  ///    );
  ///}
  ///```
  final MajorGridLines majorGridLines;

  /// Customizes the appearance of the minor grid lines.
  ///
  /// Minor grids are the lines drawn
  /// on the plot area at all the minor intervals between the major intervals.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(minorGridLines: MinorGridLines(width: 0)),
  ///        )
  ///    );
  ///}
  ///```
  final MinorGridLines minorGridLines;

  /// Customizes the appearance of the axis labels.
  ///
  /// Labels are the axis values
  /// placed at each interval. Axis labels are visible by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.black)),
  ///        )
  ///    );
  ///}
  ///```
  /// This property is used to show or hide the axis labels.
  final TextStyle? labelStyle;

  /// Customizes the appearance of the axis title.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(title: AxisTitle( text: 'Year')),
  ///        )
  ///    );
  ///}
  ///```
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
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(rangePadding:  ChartRangePadding.round),
  ///        )
  ///    );
  ///}
  ///```
  final ChartRangePadding rangePadding;

  /// The number of intervals in an axis.
  ///
  /// By default, the number of intervals is
  /// calculated based on the minimum and maximum values and the axis width and height.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(desiredIntervals: 2),
  ///        )
  ///    );
  ///}
  ///```
  final int? desiredIntervals;

  /// The maximum number of labels to be displayed in an axis in 100 logical pixels.
  ///
  /// Defaults to `3`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(maximumLabels: 4),
  ///        )
  ///    );
  ///}
  ///```
  final int maximumLabels;

  /// Interval of the minor ticks.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(minorTicksPerInterval: 2),
  ///        )
  ///     );
  ///}
  ///```
  final int minorTicksPerInterval;

  /// Angle for axis labels.
  /// The axis labels can be rotated to any angle.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(labelRotation: 90),
  ///        )
  ///    );
  ///}
  ///```
  final int labelRotation;

  /// Axis labels intersecting action.
  ///
  /// Various actions such as hide, trim, wrap, rotate
  /// 90 degree, rotate 45 degree, and placing the labels in multiple rows can be
  /// handled when the axis labels collide with each other.
  ///
  /// Defaults to `AxisLabelIntersectAction.hide`.
  ///
  /// Also refer [AxisLabelIntersectAction].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(labelIntersectAction: AxisLabelIntersectAction.multipleRows),
  ///        )
  ///    );
  ///}
  ///```
  final AxisLabelIntersectAction labelIntersectAction;

  /// Opposes the axis position.
  ///
  /// An axis can be placed at the opposite side of its default position.
  ///
  /// Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(opposedPosition: true),
  ///        )
  ///    );
  ///}
  ///```
  final bool opposedPosition;

  /// Inverts the axis.
  ///
  /// Axis is rendered from the minimum value to maximum value by
  /// default, and it can be inverted to render the axis from the maximum value
  /// to minimum value.
  ///
  /// Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(isInversed: true),
  ///        )
  ///     );
  ///}
  ///```
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
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(labelPosition: ChartDataLabelPosition.inside),
  ///        )
  ///    );
  ///}
  ///```
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
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(labelAlignment: LabelAlignment.start),
  ///        )
  ///    );
  ///}
  ///```
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
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(tickPosition: TickPosition.inside),
  ///        )
  ///    );
  ///}
  ///```
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
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
  ///        )
  ///    );
  ///}
  ///```
  final EdgeLabelPlacement edgeLabelPlacement;

  /// Axis interval value.
  ///
  /// Using this, the axis labels can be displayed after
  /// certain interval value. By default, interval will be
  /// calculated based on the minimum and maximum values of the provided data.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(interval: 1),
  ///        )
  ///    );
  ///}
  ///```
  final double? interval;

  /// Padding for plot area. The axis is rendered in chart with padding.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(plotOffset: 60),
  ///        )
  ///    );
  ///}
  ///```
  final double plotOffset;

  /// Name of an axis.
  ///
  /// A unique name further used for linking the series to this
  /// appropriate axis.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(name: 'primaryXAxis'),
  ///        )
  ///     );
  ///}
  ///```
  final String? name;

  /// Zoom factor of an axis.
  ///
  /// Scale the axis based on this value, and it ranges
  /// from 0 to 1.
  ///
  /// Defaults to `1`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(zoomFactor: 0.5),
  ///        )
  ///    );
  ///}
  ///```
  final double zoomFactor;

  /// Position of the zoomed axis. The value ranges from 0 to 1.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(zoomPosition: 0.6),
  ///        )
  ///    );
  ///}
  ///```
  final double zoomPosition;

  /// Enables or disables the automatic interval while zooming.
  ///
  /// Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(enableAutoIntervalOnZooming: true),
  ///        )
  ///    );
  ///}
  ///```
  final bool enableAutoIntervalOnZooming;

  /// Customizes the crosshair and selection zooming tooltip. Tooltip displays the current
  /// axis value based on the crosshair position/selectionZoomRect position at an axis.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(interactiveTooltip: InteractiveTooltip(enable: true)),
  ///        )
  ///    );
  ///}
  ///```
  final InteractiveTooltip interactiveTooltip;

  /// Customization to place the axis crossing on another axis based on the value.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(crossesAt:10),
  ///        )
  ///    );
  ///}
  ///```
  final dynamic crossesAt;

  /// Axis line crossed on mentioned axis name, and applicable for plot band also.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///               associatedAxisName: 'primaryXAxis',
  ///               plotBands: <PlotBand>[
  ///                   PlotBand(
  ///                      start: 2,
  ///                      end: 5,
  ///                      associatedAxisStart: 2,
  ///                      ),
  ///                  ],
  ///             ),
  ///        )
  ///    );
  ///}
  ///```
  final String? associatedAxisName;

  /// Consider to place the axis label respect to near axis line.
  ///
  /// Defaults to `true`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(placeLabelsNearAxisLine: false, crossesAt:10),
  ///        )
  ///    );
  ///}
  ///```
  final bool placeLabelsNearAxisLine;

  /// Render the plot band in axis.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands:<PlotBand>[plotBands(start:20, end:30, color:Colors.red, text:'Flutter')]
  ///               ),
  ///        )
  ///    );
  ///}
  ///```
  final List<PlotBand> plotBands;

  /// The `rangeController` property is used to set the maximum and minimum values for the chart in the viewport.
  /// In the minimum and maximum properties of the axis, you can specify the minimum and maximum values with respect to the entire data source.
  /// In the visibleMinimum and visibleMaximum properties, you can specify the values to be viewed in the viewed port i.e. range controller's start and end values respectively.
  ///
  /// Here you need to specify the `minimum`, `maximum`, `visibleMinimum`, and `visibleMaximum` properties to the axis and the axis values will be visible with respect to
  /// visibleMinimum and visibleMaximum properties.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///  RangeController rangeController = RangeController(
  ///    start: DateTime(2020, 2, 1),
  ///    end: DateTime(2020, 2, 30),
  ///  );
  ///  SfCartesianChart sliderChart = SfCartesianChart(
  ///    margin: const EdgeInsets.all(0),
  ///    primaryXAxis:
  ///        DateTimeAxis(isVisible: false),
  ///    primaryYAxis: NumericAxis(isVisible: false),
  ///    plotAreaBorderWidth: 0,
  ///    series: <SplineAreaSeries<ChartSampleData, DateTime>>[
  ///      SplineAreaSeries<ChartSampleData, DateTime>(
  ///        //  Add required properties.
  ///      )
  ///    ],
  ///  );
  ///  return Scaffold(
  ///    body: Column(
  ///      children: <Widget>[
  ///        Expanded(
  ///          child: SfCartesianChart(
  ///            primaryXAxis: DateTimeAxis(
  ///                maximum: DateTime(2020, 1, 1),
  ///                minimum: DateTime(2020, 3, 30),
  ///                // set maximum value from the range controller
  ///                visibleMaximum: rangeController.end,
  ///                // set minimum value from the range controller
  ///                visibleMinimum: rangeController.start,
  ///                rangeController: rangeController),
  ///            primaryYAxis: NumericAxis(),
  ///            series: <SplineSeries<ChartSampleData, DateTime>>[
  ///              SplineSeries<ChartSampleData, DateTime>(
  ///                dataSource: splineSeriesData,
  ///                xValueMapper: (ChartSampleData sales, _) =>
  ///                    sales.x as DateTime,
  ///                yValueMapper: (ChartSampleData sales, _) => sales.y,
  ///                //  Add required properties.
  ///              )
  ///            ],
  ///          ),
  ///        ),
  ///        Expanded(
  ///            child: SfRangeSelectorTheme(
  ///          data: SfRangeSelectorThemeData(),
  ///          child: SfRangeSelector(
  ///            min: min,
  ///            max: max,
  ///            controller: rangeController,
  ///            showTicks: true,
  ///            showLabels: true,
  ///            dragMode: SliderDragMode.both,
  ///            onChanged: (SfRangeValues value) {
  ///              // set the start value to rangeController from this callback
  ///              rangeController.start = value.start;
  ///              // set the end value to rangeController from this callback
  ///              rangeController.end = value.end;
  ///              setState(() {});
  ///            },
  ///            child: Container(
  ///              child: sliderChart,
  ///            ),
  ///          ),
  ///        )),
  ///      ],
  ///    ),
  ///  );
  ///}
  ///```
  final RangeController? rangeController;

  /// Specifies maximum text width for axis labels.
  ///
  /// If an axis label exceeds the specified width, it will get trimmed and ellipse(...) will be
  /// added at the end of the trimmed text. By default, the labels will not be trimmed.
  ///
  /// Complete label text will be shown in a tooltip when tapping/clicking over the trimmed axis labels.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(maximumLabelWidth: 80),
  ///           series: [
  ///             BarSeries<ChartData, String>(
  ///               dataSource: <ChartData>[
  ///                 ChartData(x: 'Goldin Finance 117', y: 597),
  ///                 ChartData(x: 'Ping An Finance Center', y: 599),
  ///                 ChartData(x: 'Makkah Clock Royal Tower', y: 601),
  ///                 ChartData(x: 'Shanghai Tower', y: 632),
  ///                 ChartData(x: 'Burj Khalifa', y: 828)
  ///               ],
  ///               xValueMapper: (ChartData sales, _) => sales.x,
  ///               yValueMapper: (ChartData sales, _) => sales.y
  ///             )
  ///           ],
  ///       )
  ///    );
  ///}
  ///```
  final double? maximumLabelWidth;

  /// Specifies the fixed width for the axis labels. This width represents the space between axis line and
  /// axis title.
  ///
  /// If an axis label exceeds the specified value, as like [maximumLabelWidth] feature, axis label
  /// will get trimmed and ellipse(...) will be added at the end of the trimmed text.
  ///
  /// Additionally, if an axis label width is within the specified value, white space will be added
  /// at the beginning for remaining width. This is done to maintain uniform bounds and to eliminate
  /// axis label flickering on zooming/panning.
  ///
  /// Complete label text will be shown in a tooltip when tapping/clicking over the trimmed axis labels.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(labelsExtent: 70),
  ///           series: [
  ///             BarSeries<ChartData, String>(
  ///               dataSource: <ChartData>[
  ///                 ChartData(x: 'Goldin Finance 117', y: 597),
  ///                 ChartData(x: 'Ping An Finance Center', y: 599),
  ///                 ChartData(x: 'Makkah Clock Royal Tower', y: 601),
  ///                 ChartData(x: 'Shanghai Tower', y: 632),
  ///                 ChartData(x: 'Burj Khalifa', y: 828)
  ///               ],
  ///               xValueMapper: (ChartData sales, _) => sales.x,
  ///               yValueMapper: (ChartData sales, _) => sales.y
  ///             )
  ///           ],
  ///       )
  ///    );
  ///}
  ///```
  final double? labelsExtent;

  /// The number of data points to be visible always in the chart.
  ///
  /// For example, if there are 10 data points and `autoScrollingDelta` value is 5 and [autoScrollingMode]
  /// is `AutoScrollingMode.end`, the last 5 data points will be displayed in the chart and remaining
  /// data points can be viewed by panning the chart from left to right direction. If the [autoScrollingMode]
  /// is `AutoScrollingMode.start`, first 5 points will be displayed and remaining data points can be
  /// viewed by panning the chart from right to left direction.
  ///
  /// If the data points are less than the specified `autoScrollingDelta` value, all those data points will
  /// be displayed.
  ///
  /// It always shows the recently added data points and scrolling will be reset to the start or end of
  /// the range, based on [autoScrollingMode] property's value, whenever a new point is added dynamically.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             autoScrollingDelta: 3,
  ///               ),
  ///        )
  ///    );
  ///}
  ///```
  final int? autoScrollingDelta;

  /// Determines whether the axis should be scrolled from the start position or end position.
  ///
  /// For example, if there are 10 data points and [autoScrollingDelta] value is 5 and `AutoScrollingMode.end`
  /// is specified to this property, last 5 points will be displayed in the chart. If `AutoScrollingMode.start`
  /// is set to this property, first 5 points will be displayed.
  ///
  /// Defaults to `AutoScrollingMode.end`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             autoScrollingMode: AutoScrollingMode.start,
  ///               ),
  ///        )
  ///    );
  ///}
  ///```
  final AutoScrollingMode autoScrollingMode;

  /// Border color of the axis label.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         borderColor: Colors.black,
  ///       )
  ///     )
  ///   );
  /// }
  ///```
  final Color? borderColor;

  /// Border width of the axis label.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         borderWidth: 2,
  ///       )
  ///     )
  ///   );
  /// }
  ///```
  final double borderWidth;

  /// Border type of the axis label.
  ///
  /// Defaults to `AxisBorderType.rectangle`.
  ///
  /// Also refer [AxisBorderType].
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         axisBorderType: AxisBorderType.withoutTopAndBottom,
  ///       )
  ///     )
  ///   );
  /// }
  ///```
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
  ///```dart
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
  ///```
  final MultiLevelLabelStyle multiLevelLabelStyle;

  /// Provides the option to group the axis labels. You can customize the start,
  /// end value of a multi-level label, text, and level of the multi-level labels.
  ///
  /// The `start` and `end` values for the category axis need to be string type,
  /// in the case of date-time or date-time category axes need to be date-time
  /// and in the case of numeric or logarithmic axes needs to be double.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
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
  ///```
  // ignore: always_specify_types, strict_raw_type
  final List<ChartMultiLevelLabel>? multiLevelLabels;

  /// Called while rendering each multi-level label.
  ///
  /// Provides label text, the actual level of the label, index, and
  /// text styles such as color, font size, etc using `MultiLevelLabelRenderDetails` class.
  ///
  /// You can customize the text and text style using `ChartAxisLabel` class
  /// and can return it.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
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
  ///```
  final MultiLevelLabelFormatterCallback? multiLevelLabelFormatter;

  /// Called while rendering each axis label in the chart.
  ///
  /// Provides label text, axis name, orientation of the axis, trimmed text and text styles such as color,
  /// font size, and font weight to the user using the `AxisLabelRenderDetails` class.
  ///
  /// You can customize the text and text style using the `ChartAxisLabel` class and can return it.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primarXAxis: CategoryAxis(
  ///               axisLabelFormatter: (AxisLabelRenderDetails details) => axis(details),
  ///            ),
  ///        )
  ///     );
  ///}
  ///
  ///ChartAxisLabel axis(AxisLabelRenderDetails details) {
  ///   return ChartAxisLabel('axis Label', details.textStyle);
  ///}
  ///```
  final ChartLabelFormatterCallback? axisLabelFormatter;
}

/// Holds the axis label information.
///
/// Axis Label used by the user-specified or by default to make the label for both x and y-axis.
///
/// Provides  options for label style, label size, text, and value to customize the appearance.
///
class AxisLabel {
  /// Creating an argument constructor of AxisLabel class.
  AxisLabel(this.labelStyle, this.labelSize, this.text, this.value,
      this.trimmedText, this.renderText);

  /// Specifies the label text style.
  ///
  /// The [TextStyle] is used to customize the chart title text style.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               primaryXAxis: CategoryAxis(
  ///                      labelStyle: TextStyle(color: Colors.black),
  ///                  )
  ///         );
  ///}
  ///```
  TextStyle labelStyle;

  /// Hold the size of the label.
  Size labelSize;

  /// Contains the text of the label.
  String text;

  /// Contains the trimmed text of the label.
  String? trimmedText;

  /// Contains the label text to be rendered.
  String? renderText;

  /// Holds the value of the visible range of the axis.
  num value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is AxisLabel &&
        other.labelStyle == labelStyle &&
        other.labelSize == labelSize &&
        other.text == text &&
        other.trimmedText == trimmedText &&
        other.renderText == renderText &&
        other.value == value;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      labelStyle,
      labelSize,
      text,
      trimmedText,
      renderText,
      value
    ];
    return Object.hashAll(values);
  }

  List<String>? _labelCollection;

  int _index = 1;

  /// Stores the location of an label.
  Rect? _labelRegion;

  bool _needRender = true;
}

/// This class Renders the major tick lines for axis.
///
/// To render major grid lines, create an instance of [MajorTickLines], and assign it to the majorTickLines property of [ChartAxis].
/// The Major tick lines can be drawn for each axis on the plot area.
///
/// Provides options for [size], [width], and [color] to customize the appearance.
///
class MajorTickLines {
  /// Creating an argument constructor of MajorTickLines class.
  const MajorTickLines({this.size = 5, this.width = 1, this.color});

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
  ///
  final double size;

  /// Width of the major tick lines.
  ///
  /// Defaults to `1`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 majorTickLines: const MajorTickLines(
  ///                   width: 2
  ///                 )
  ///                ),
  ///        )
  ///    );
  ///}
  ///```
  final double width;

  /// Colors of the major tick lines.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 majorTickLines: const MajorTickLines(
  ///                   color: Colors.black
  ///                 )
  ///                ),
  ///        )
  ///    );
  ///}
  ///```
  final Color? color;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MajorTickLines &&
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

/// This class has the properties of minor tick lines.
///
/// To render minor grid lines, create an instance of [MinorTickLines], and assign it to the minorTickLines property of [ChartAxis].
/// The Minor tick lines can be drawn for each axis on the plot area.
///
/// Provides the color option to change the [color] of the tick line for the customization.
///
@immutable
class MinorTickLines {
  /// Creating an argument constructor of MinorTickLines class.
  const MinorTickLines({this.size = 3, this.width = 0.7, this.color});

  /// Height of the minor tick lines.
  ///
  /// Defaults to `3`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
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
  ///}
  ///```
  final double size;

  /// Width of the minor tick lines.
  ///
  /// Defaults to `0.7`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
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
  ///}
  ///```
  final double width;

  /// Color of the minor tick lines.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
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
  ///}
  ///```
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
/// To render major grid lines, create an instance of [MajorGridLines], and assign it to the major gridLines property of [ChartAxis].
/// Major grid lines can be drawn for each axis on the plot area.
///
/// Provides options for [color], [width], and [dashArray] to customize the appearance.
///
@immutable
class MajorGridLines {
  /// Creating an argument constructor of MajorGridLines class.
  const MajorGridLines({this.width = 0.7, this.color, this.dashArray});

  /// Any number of values can be provided in the list. Odd value is considered as
  /// rendering size and even value is considered as a gap.
  ///
  /// Defaults to `[0,0]`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 majorGridLines: MajorGridLines(
  ///                   dashArray: [1,2]
  ///                 )
  ///                ),
  ///        )
  ///     );
  ///}
  ///```
  final List<double>? dashArray;

  /// Width of the major grid lines.
  ///
  /// Defaults to  `0.7`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 majorGridLines: MajorGridLines(
  ///                   width:2
  ///                 )
  ///                ),
  ///        )
  ///     );
  ///}
  ///```
  final double width;

  /// Color of the major grid lines.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 majorGridLines: MajorGridLines(
  ///                   color:Colors.red
  ///                 )
  ///                ),
  ///        )
  ///     );
  ///}
  ///```
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
/// To render minor grid lines, create an instance of [MinorGridLines], and assign it to the property of [ChartAxis].
/// The Minor grid lines can be drawn for each axis on the plot area.
///
/// Provides the options of [width], [color], and [dashArray] values to customize the appearance.
///
class MinorGridLines {
  /// Creating an argument constructor of MinorGridLines class.
  const MinorGridLines({this.width = 0.5, this.color, this.dashArray});

  /// Any number of values can be provided in the list. Odd value is considered
  /// as rendering size and even value is considered as a gap.
  ///
  /// Defaults to `[0,0]`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///            minorTicksPerInterval: 5,
  ///            minorGridLines: MinorGridLines(
  ///            dashArray: <double>[10, 20],
  ///          )
  ///         )
  ///        )
  ///     );
  ///}
  ///```
  final List<double>? dashArray;

  /// Width of the minor grid lines.
  ///
  /// Defaults to `0.5`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///            minorTicksPerInterval: 5,
  ///            minorGridLines: MinorGridLines(
  ///            width: 0.7,
  ///         )
  ///         )
  ///        )
  ///     );
  ///}
  ///```
  final double width;

  /// Color of the minor grid lines.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///            minorTicksPerInterval: 5,
  ///            minorGridLines: MinorGridLines(
  ///            color: Colors.red,
  ///         ),
  ///         )
  ///        ));
  ///}
  ///```
  final Color? color;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MinorGridLines &&
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

/// This class holds the property of the axis title.
///
/// It has public properties to customize the text and font of the axis title. Axis does not display title by default.
/// Use of the property will customize the title.
///
/// Provides text, text style, and text alignment options for customization of appearance.
///
class AxisTitle {
  /// Creating an argument constructor of AxisTitle class.
  AxisTitle(
      {this.text, this.textStyle, this.alignment = ChartAlignment.center});

  /// Text to be displayed as axis title.
  ///
  /// Defaults to `‘’`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 title: AxisTitle(
  ///                   text: 'Axis Title',
  ///                 )
  ///                ),
  ///        )
  ///     );
  ///}
  ///```
  final String? text;

  /// Customizes the appearance of text in axis title.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 title: AxisTitle(
  ///                   text: 'Axis Title',
  ///                   textStyle: TextStyle(
  ///                     color: Colors.blue,
  ///                     fontStyle: FontStyle.italic,
  ///                     fontWeight: FontWeight.w600,
  ///                     fontFamily: 'Roboto'
  ///                   )
  ///                 )
  ///                ),
  ///        )
  ///   );
  ///}
  ///```
  final TextStyle? textStyle;

  /// Aligns the axis title.
  ///
  /// It is applicable for both vertical and horizontal axes.
  ///
  /// * `ChartAlignment.near`, moves the axis title to the beginning of the axis
  ///
  /// * `ChartAlignment.far`, moves the axis title to the end of the axis
  ///
  /// * `ChartAlignment.center`, moves the axis title to the center position of the axis.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 title: AxisTitle(
  ///                   text: 'Axis Title',
  ///                   alignment: ChartAlignment.far,
  ///                 )
  ///                ),
  ///        )
  ///    );
  ///}
  ///```
  final ChartAlignment alignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is AxisTitle &&
        other.text == text &&
        other.textStyle == textStyle &&
        other.alignment == alignment;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[text, textStyle, alignment];
    return Object.hashAll(values);
  }
}

/// This class consists of axis line properties.
///
/// It has the public properties to customize the axis line by increasing or decreasing the width of the axis line and
/// render the axis line with dashes by defining the [dashArray] value.
///
/// Provides options for color, dash array, and width to customize the appearance of the axis line.
///
class AxisLine {
  /// Creating an argument constructor of AxisLine class.
  const AxisLine({this.color, this.dashArray, this.width = 1});

  /// Width of the axis line.
  ///
  /// Defaults to `1`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 axisLine:AxisLine(
  ///                   width: 2
  ///                 )
  ///                ),
  ///        )
  ///    );
  ///}
  ///```
  final double width;

  /// Color of the axis line. Color will be applied based on the brightness property of the app.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 axisLine:AxisLine(
  ///                   color:Colors.blue,
  ///                 )
  ///                ),
  ///        ));
  ///}
  ///```
  final Color? color;

  /// Dashes of the axis line. Any number of values can be provided in the list. Odd value is
  /// considered as rendering size and even value is considered as gap.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: NumericAxis(
  ///                 axisLine:AxisLine(
  ///                   dashArray: <double>[5,5],
  ///                 )
  ///                ),
  ///        )
  ///     );
  ///}
  ///```
  final List<double>? dashArray;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is AxisLine &&
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

/// calculate visible range based on min, max values
class VisibleRange {
  /// Creates an instance for visible range
  VisibleRange(dynamic min, dynamic max) {
    if ((min < max) == true) {
      minimum = min;
      maximum = max;
    } else {
      minimum = max;
      maximum = min;
    }
  }

  /// specifies minimum range
  dynamic minimum;

  /// Specifies maximum range
  dynamic maximum;

  /// Specifies range interval
  dynamic interval;

  /// Specifies delta value for min-max
  late num delta;
}

/// Creates an axis renderer for chart axis.
abstract class ChartAxisRenderer with CustomizeAxisElements {
  /// Creating an argument constructor of ChartAxisRenderer class.
  ChartAxisRenderer();

  late ChartAxisRendererDetails _axisRendererDetails;

  @override
  Color? getAxisLineColor(ChartAxis axis) => axis.axisLine.color;
  @override
  double getAxisLineWidth(ChartAxis axis) => axis.axisLine.width;

  @override
  Color? getAxisMajorTickColor(ChartAxis axis, int majorTickIndex) =>
      axis.majorTickLines.color;

  @override
  double getAxisMajorTickWidth(ChartAxis axis, int majorTickIndex) =>
      axis.majorTickLines.width;

  @override
  Color? getAxisMinorTickColor(
          ChartAxis axis, int majorTickIndex, int minorTickIndex) =>
      axis.minorTickLines.color;

  @override
  double getAxisMinorTickWidth(
          ChartAxis axis, int majorTickIndex, int minorTickIndex) =>
      axis.minorTickLines.width;

  @override
  Color? getAxisMajorGridColor(ChartAxis axis, int majorGridIndex) =>
      axis.majorGridLines.color;

  @override
  double getAxisMajorGridWidth(ChartAxis axis, int majorGridIndex) =>
      axis.majorGridLines.width;

  @override
  Color? getAxisMinorGridColor(
          ChartAxis axis, int majorGridIndex, int minorGridIndex) =>
      axis.minorGridLines.color;
  @override
  double getAxisMinorGridWidth(
          ChartAxis axis, int majorGridIndex, int minorGridIndex) =>
      axis.minorGridLines.width;

  @override
  String getAxisLabel(ChartAxis axis, String text, int labelIndex) => text;

  @override
  TextStyle getAxisLabelStyle(ChartAxis axis, String text, int labelIndex) =>
      axis.labelStyle!;

  /// It returns the axis label angle
  @override
  int getAxisLabelAngle(
          ChartAxisRenderer axisRenderer, String text, int labelIndex) =>
      axisRenderer._axisRendererDetails
          .getAxisLabelAngle(axisRenderer, text, labelIndex);

  /// To draw the horizontal axis line
  @override
  void drawHorizontalAxesLine(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart) {
    axisRenderer._axisRendererDetails
        .drawHorizontalAxesLine(canvas, axisRenderer, chart);
  }

  /// To draw the vertical axis line
  @override
  void drawVerticalAxesLine(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart) {
    axisRenderer._axisRendererDetails
        .drawVerticalAxesLine(canvas, axisRenderer, chart);
  }

  /// To draw the horizontal axes tick lines
  @override
  void drawHorizontalAxesTickLines(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart,
      [String? renderType,
      double? animationFactor,
      ChartAxisRenderer? oldAxisRenderer,
      bool? needAnimate]) {
    axisRenderer._axisRendererDetails.drawHorizontalAxesTickLines(
        canvas,
        axisRenderer,
        chart,
        renderType,
        animationFactor,
        oldAxisRenderer,
        needAnimate);
  }

  /// To draw the major grid lines of horizontal axes
  @override
  void drawHorizontalAxesMajorGridLines(
      Canvas canvas,
      Offset point,
      ChartAxisRenderer axisRenderer,
      MajorGridLines grids,
      int index,
      SfCartesianChart chart) {
    axisRenderer._axisRendererDetails.drawHorizontalAxesMajorGridLines(
        canvas, point, axisRenderer, grids, index, chart);
  }

  /// To draw the minor grid lines of horizontal axes
  @override
  void drawHorizontalAxesMinorLines(
      Canvas canvas,
      ChartAxisRenderer axisRenderer,
      double tempInterval,
      Rect rect,
      num nextValue,
      int index,
      SfCartesianChart chart,
      [String? renderType]) {
    axisRenderer._axisRendererDetails.drawHorizontalAxesMinorLines(canvas,
        axisRenderer, tempInterval, rect, nextValue, index, chart, renderType);
  }

  /// To draw tick lines of vertical axes
  @override
  void drawVerticalAxesTickLines(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart,
      [String? renderType,
      double? animationFactor,
      ChartAxisRenderer? oldAxisRenderer,
      bool? needAnimate]) {
    axisRenderer._axisRendererDetails._drawVerticalAxesTickLines(
        canvas,
        axisRenderer,
        chart,
        renderType,
        animationFactor,
        oldAxisRenderer,
        needAnimate);
  }

  /// To draw the major grid lines of vertical axes
  @override
  void drawVerticalAxesMajorGridLines(
      Canvas canvas,
      Offset point,
      ChartAxisRenderer axisRenderer,
      MajorGridLines grids,
      int index,
      SfCartesianChart chart) {
    axisRenderer._axisRendererDetails._drawVerticalAxesMajorGridLines(
        canvas, point, axisRenderer, grids, index, chart);
  }

  /// To draw the minor grid lines of vertical axes
  @override
  void drawVerticalAxesMinorTickLines(
      Canvas canvas,
      ChartAxisRenderer axisRenderer,
      num tempInterval,
      Rect rect,
      int index,
      SfCartesianChart chart,
      [String? renderType]) {
    axisRenderer._axisRendererDetails._drawVerticalAxesMinorTickLines(
        canvas, axisRenderer, tempInterval, rect, index, chart, renderType);
  }

  /// To draw the axis labels of horizontal axes
  @override
  void drawHorizontalAxesLabels(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart,
      [String? renderType,
      double? animationFactor,
      ChartAxisRenderer? oldAxisRenderer,
      bool? needAnimate]) {
    axisRenderer._axisRendererDetails._drawHorizontalAxesLabels(
        canvas,
        axisRenderer,
        chart,
        renderType,
        animationFactor,
        oldAxisRenderer,
        needAnimate);
  }

  /// To draw the axis labels of vertical axes
  @override
  void drawVerticalAxesLabels(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart,
      [String? renderType,
      double? animationFactor,
      ChartAxisRenderer? oldAxisRenderer,
      bool? needAnimate]) {
    axisRenderer._axisRendererDetails._drawVerticalAxesLabels(
        canvas,
        axisRenderer,
        chart,
        renderType,
        animationFactor,
        oldAxisRenderer,
        needAnimate);
  }

  /// To draw the axis title of horizontal axes
  @override
  void drawHorizontalAxesTitle(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart) {
    axisRenderer._axisRendererDetails
        ._drawHorizontalAxesTitle(canvas, axisRenderer, chart);
  }

  /// To draw the axis title of vertical axes
  @override
  void drawVerticalAxesTitle(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart) {
    axisRenderer._axisRendererDetails
        ._drawVerticalAxesTitle(canvas, axisRenderer, chart);
  }

  /// returns the calculated interval for axis
  num? calculateInterval(VisibleRange range, Size availableSize);

  /// to apply the range padding for the axis
  void applyRangePadding(VisibleRange range, num interval);

  /// calculates the visible range of the axis
  void calculateVisibleRange(Size availableSize);

  /// this method generates the visible labels for the specific axis
  void generateVisibleLabels();

  /// To calculate the range points
  void calculateRange(ChartAxisRenderer axisRenderer) {
    axisRenderer._axisRendererDetails._calculateRange(axisRenderer);
  }

  /// To dispose the objects.
  void dispose() {
    _axisRendererDetails.dispose();
  }
}

/// Represents the class that holds the chart axis rendering details
class ChartAxisRendererDetails {
  /// Creates an instance of chart axis renderer details
  ChartAxisRendererDetails(this.axis, this.stateProperties, this.axisRenderer) {
    visibleLabels = <AxisLabel>[];
    visibleAxisMultiLevelLabels = <AxisMultiLevelLabel>[];
    maximumLabelSize = Size.zero;
    multiLevelLabelTotalSize = Size.zero;
    seriesRenderers = <CartesianSeriesRenderer>[];
    name = axis.name;
    labelRotation = axis.labelRotation;
    zoomFactor = axis.zoomFactor;
    zoomPosition = axis.zoomPosition;
    chartThemeData = stateProperties.renderingDetails.chartTheme;
  }

  /// Represents the chart axis renderer
  late ChartAxisRenderer axisRenderer;

  /// Represents the chart axis value
  late ChartAxis axis;

  /// Specifies the old axis value
  ChartAxis? oldAxis;

  /// Specifies the chart theme.
  late SfChartThemeData chartThemeData;

  /// Specifies the value of state properties
  final CartesianStateProperties stateProperties;

  /// Specifies the rendering details value
  RenderingDetails get renderingDetails => stateProperties.renderingDetails;

  /// Specifies the cartesian chart
  late SfCartesianChart chart;

  /// Specifies whether the series is stack100
  bool isStack100 = false;

  /// Specifies the value of range minimum and range maximum
  dynamic rangeMinimum, rangeMaximum;

  /// Specifies the value of visible labels
  late List<AxisLabel> visibleLabels;

  /// Specifies the value of visible labels
  late List<AxisMultiLevelLabel> visibleAxisMultiLevelLabels;

  /// Stores each level's maximum size
  List<Size> multiLevelsMaximumSize = <Size>[];

  /// Holds the size of larger label
  Size maximumLabelSize = Size.zero;

  /// Holds the total size of the multilevel label
  Size multiLevelLabelTotalSize = Size.zero;

  /// Holds the end point value of the axis border
  double? axisBorderEnd;

  /// Holds the highest level value of multilevel labels
  int? highestLevel;

  /// Specifies axis orientations such as vertical, horizontal.
  AxisOrientation? orientation;

  /// Specifies the visible range based on min, max values.
  VisibleRange? visibleRange;

  /// Specifies the actual range based on min, max values.
  VisibleRange? actualRange;

  /// Specifies the minimum and maximum for multi level labels
  num? minimumMultiLevelLabelValue, maximumMultiLevelLabelValue;

  /// To express the multi level label is enabled or not
  bool isMultiLevelLabelEnabled = false;

  /// Holds the chart series
  late List<CartesianSeriesRenderer> seriesRenderers;

  /// Specifies the value of bounds
  // ignore: prefer_final_fields
  Rect bounds = Rect.zero;

  /// Specifies whether the ticks are placed inside
  bool? isInsideTickPosition;

  /// Specifies the total size value
  late double totalSize;

  /// Specifies the p
  double? previousZoomFactor, previousZoomPosition;

  /// Internal variables
  String? name;

  /// Holds the value of label rotation
  late int labelRotation;

  /// Holds the value of zoom factor and zoom position
  late double zoomFactor, zoomPosition;

  /// Checking the axis label collision
  bool isCollide = false;

  /// Holds the value of minimum, maximum, lowest and highest minimum and maximum value
  num? min, max, lowMin, lowMax, highMin, highMax;

  /// Holds the value of axis size
  late Size axisSize;

  /// Holds the value of cross axis renderer
  late ChartAxisRenderer crossAxisRenderer;

  /// Specifies the cross value
  num? crossValue;

  /// Specifies the cross range
  VisibleRange? crossRange;

  /// Holds the label offset value
  double? labelOffset;

  /// Holds the axis title offset value
  double? titleOffset;

  /// Holds the axis title height
  double? titleHeight;

  /// Specifies the x-axis start and x-axis end
  Offset? xAxisStart, xAxisEnd;

  /// Specifies the value of visible minimum and visible maximum
  num? visibleMinimum, visibleMaximum;

  /// Specifies the scrolling delta value
  int? scrollingDelta;

  /// Returns the axis label angle
  int getAxisLabelAngle(
      ChartAxisRenderer axisRenderer, String text, int labelIndex) {
    final int labelAngle =
        (axis.labelIntersectAction == AxisLabelIntersectAction.rotate45 &&
                isCollide)
            ? -45
            : (axis.labelIntersectAction == AxisLabelIntersectAction.rotate90 &&
                    isCollide)
                ? -90
                : labelRotation;

    return labelAngle;
  }

  /// Method to draw the horizontal axes line
  void drawHorizontalAxesLine(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart) {
    final Rect rect = Rect.fromLTWH(bounds.left - axis.plotOffset, bounds.top,
        bounds.width + 2 * axis.plotOffset, bounds.height);

    final CustomPaintStyle paintStyle = CustomPaintStyle(
        axisRenderer.getAxisLineWidth(axis),
        axisRenderer.getAxisLineColor(axis) ??
            renderingDetails.chartTheme.axisLineColor,
        PaintingStyle.stroke);
    drawDashedPath(canvas, paintStyle, Offset(rect.left, rect.top),
        Offset(rect.left + rect.width, rect.top), axis.axisLine.dashArray);
    xAxisStart = Offset(rect.left, rect.top);
    xAxisEnd = Offset(rect.left + rect.width, rect.top);
  }

  /// Method to draw the vertical axes line
  void drawVerticalAxesLine(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart) {
    final Rect rect = Rect.fromLTWH(bounds.left, bounds.top - axis.plotOffset,
        bounds.width, bounds.height + 2 * axis.plotOffset);
    final CustomPaintStyle paintStyle = CustomPaintStyle(
        axisRenderer.getAxisLineWidth(axis),
        axisRenderer.getAxisLineColor(axis) ??
            renderingDetails.chartTheme.axisLineColor,
        PaintingStyle.stroke);
    drawDashedPath(canvas, paintStyle, Offset(rect.left, rect.top),
        Offset(rect.left, rect.top + rect.height), axis.axisLine.dashArray);
  }

  /// Method to draw the horizontal axes tick lines
  void drawHorizontalAxesTickLines(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart,
      [String? renderType,
      double? animationFactor,
      ChartAxisRenderer? oldAxisRenderer,
      bool? needAnimate]) {
    final dynamic chartAxis = axis;
    double betweenTickPositionValue = 0.0;
    late double tempInterval, pointX, pointY;
    int length = visibleLabels.length;
    if (length > 0) {
      final MajorTickLines ticks = axis.majorTickLines;
      final bool isBetweenTicks =
          (axis is CategoryAxis || axis is DateTimeCategoryAxis) &&
              chartAxis.labelPlacement == LabelPlacement.betweenTicks;
      final num tickBetweenLabel = isBetweenTicks ? 0.5 : 0;
      length += isBetweenTicks ? 1 : 0;
      for (int i = 0; i < length; i++) {
        tempInterval = (isBetweenTicks
                ? i < length - 1
                    ? visibleLabels[i].value - tickBetweenLabel
                    : (visibleLabels[i - 1].value + visibleRange!.interval) -
                        tickBetweenLabel
                : visibleLabels[i].value)
            .toDouble();
        pointX = ((valueToCoefficient(tempInterval, this) * bounds.width) +
                bounds.left)
            .roundToDouble();
        pointY = bounds.top;
        if (needAnimate!) {
          final double? oldLocation =
              _getPrevLocation(axisRenderer, oldAxisRenderer!, tempInterval);
          pointX = oldLocation != null
              ? (oldLocation - (oldLocation - pointX) * animationFactor!)
              : pointX;
        }
        if (bounds.left.roundToDouble() <= pointX &&
            bounds.right.roundToDouble() >= pointX) {
          if ((axis.majorGridLines.width > 0) == true &&
              renderType == 'outside' &&
              ((axis.plotOffset > 0) == true ||
                  (i != 0 &&
                      (isBetweenTicks ? i != length - 1 : i != length)) ||
                  (bounds.left <= pointX &&
                      bounds.right >= pointX &&
                      !stateProperties.requireInvertedAxis))) {
            axisRenderer.drawHorizontalAxesMajorGridLines(
                canvas,
                Offset(pointX, pointY),
                axisRenderer,
                axis.majorGridLines,
                i,
                chart);
          }
          if ((axis.minorGridLines.width > 0) == true ||
              (axis.minorTickLines.width > 0) == true) {
            num? nextValue = isBetweenTicks
                ? (tempInterval + visibleRange!.interval)
                : i == length - 1
                    ? visibleRange!.maximum
                    : visibleLabels[i + 1].value;
            if (nextValue != null) {
              nextValue =
                  ((valueToCoefficient(nextValue, this) * bounds.width) +
                          bounds.left)
                      .roundToDouble();
              axisRenderer.drawHorizontalAxesMinorLines(canvas, axisRenderer,
                  pointX, bounds, nextValue, i, chart, renderType);
            }
          }
        }
        if (axis.majorTickLines.width > 0 == true &&
            (bounds.left <= pointX && bounds.right.roundToDouble() >= pointX) &&
            renderType == axis.tickPosition.toString().split('.')[1]) {
          drawDashedPath(
              canvas,
              CustomPaintStyle(
                  axisRenderer.getAxisMajorTickWidth(axis, i),
                  axisRenderer.getAxisMajorTickColor(axis, i) ??
                      renderingDetails.chartTheme.majorTickLineColor,
                  PaintingStyle.stroke),
              Offset(pointX, pointY),
              Offset(
                  pointX,
                  axis.opposedPosition == false
                      ? (isInsideTickPosition!
                          ? pointY - ticks.size
                          : pointY + ticks.size)
                      : (isInsideTickPosition!
                          ? pointY + ticks.size
                          : pointY - ticks.size)));
        }
        if ((axis.borderWidth > 0 || isMultiLevelLabelEnabled) && i == 0) {
          setAxisBorderEndPoint(this, pointY);
        }
        if (axis.borderWidth > 0) {
          if (i == 0 && !isBetweenTicks && visibleLabels.length > 1) {
            final num nextPoint =
                (valueToCoefficient(visibleLabels[i + 1].value, this) *
                        bounds.width) +
                    bounds.left;
            betweenTickPositionValue = (nextPoint.toDouble() - pointX) / 2;
          }
          renderHorizontalAxisBorder(this, canvas, pointX, pointY,
              isBetweenTicks, betweenTickPositionValue, i);
        }
      }
    }
  }

  /// To change chart based on range controller
  void updateRangeControllerValues(ChartAxisRendererDetails axisRenderer) {
    stateProperties.zoomProgress = false;
    stateProperties.isRedrawByZoomPan = false;
    if (axisRenderer is DateTimeAxisRenderer ||
        axisRenderer is DateTimeCategoryAxisRenderer) {
      axisRenderer.rangeMinimum =
          axis.rangeController!.start.millisecondsSinceEpoch;
      axisRenderer.rangeMaximum =
          axis.rangeController!.end.millisecondsSinceEpoch;
    } else {
      axisRenderer.rangeMinimum = axis.rangeController!.start;
      axisRenderer.rangeMaximum = axis.rangeController!.end;
    }
  }

  /// Auto scrolling feature
  void updateAutoScrollingDelta(
      int scrollingDelta, ChartAxisRenderer axisRenderer) {
    this.scrollingDelta = scrollingDelta;
    switch (axis.autoScrollingMode) {
      case AutoScrollingMode.start:
        final VisibleRange autoScrollRange = VisibleRange(
            visibleRange!.minimum, visibleRange!.minimum + scrollingDelta);
        autoScrollRange.delta =
            autoScrollRange.maximum - autoScrollRange.minimum;
        zoomFactor = autoScrollRange.delta / actualRange!.delta;
        zoomPosition = 0;
        break;
      case AutoScrollingMode.end:
        final VisibleRange autoScrollRange = VisibleRange(
            visibleRange!.maximum - scrollingDelta, visibleRange!.maximum);
        autoScrollRange.delta =
            autoScrollRange.maximum - autoScrollRange.minimum;
        zoomFactor = autoScrollRange.delta / actualRange!.delta;
        zoomPosition = 1 - zoomFactor;
        break;
    }
  }

  /// Method to draw the horizontal axes major grid lines
  void drawHorizontalAxesMajorGridLines(
      Canvas canvas,
      Offset point,
      ChartAxisRenderer axisRenderer,
      MajorGridLines grids,
      int index,
      SfCartesianChart chart) {
    final CustomPaintStyle paintStyle = CustomPaintStyle(
        axisRenderer.getAxisMajorGridWidth(axis, index),
        axisRenderer.getAxisMajorGridColor(axis, index) ??
            renderingDetails.chartTheme.majorGridLineColor,
        PaintingStyle.stroke);
    drawDashedPath(
        canvas,
        paintStyle,
        Offset(point.dx, stateProperties.chartAxis.axisClipRect.top),
        Offset(
            point.dx,
            stateProperties.chartAxis.axisClipRect.top +
                stateProperties.chartAxis.axisClipRect.height),
        grids.dashArray);
  }

  /// Method to draw the horizontal axes minor lines
  void drawHorizontalAxesMinorLines(
      Canvas canvas,
      ChartAxisRenderer axisRenderer,
      double tempInterval,
      Rect rect,
      num nextValue,
      int index,
      SfCartesianChart chart,
      [String? renderType]) {
    double position = tempInterval;
    final MinorTickLines ticks = axis.minorTickLines;
    final num interval =
        (tempInterval - nextValue).abs() / (axis.minorTicksPerInterval + 1);
    for (int i = 0; i < axis.minorTicksPerInterval; i++) {
      position =
          axis.isInversed ? (position - interval) : (position + interval);
      final double pointY = rect.top;
      if (axis.minorGridLines.width > 0 &&
          renderType == 'outside' &&
          (bounds.left <= position && bounds.right >= position)) {
        drawDashedPath(
            canvas,
            CustomPaintStyle(
                axisRenderer.getAxisMinorGridWidth(axis, index, i),
                axisRenderer.getAxisMinorGridColor(axis, index, i) ??
                    renderingDetails.chartTheme.minorGridLineColor,
                PaintingStyle.stroke),
            Offset(position, stateProperties.chartAxis.axisClipRect.top),
            Offset(
                position,
                stateProperties.chartAxis.axisClipRect.top +
                    stateProperties.chartAxis.axisClipRect.height),
            axis.minorGridLines.dashArray);
      }

      if (axis.minorTickLines.width > 0 &&
          bounds.left <= position &&
          bounds.right >= position &&
          renderType == axis.tickPosition.toString().split('.')[1]) {
        drawDashedPath(
            canvas,
            CustomPaintStyle(
                axisRenderer.getAxisMinorTickWidth(axis, index, i),
                axisRenderer.getAxisMinorTickColor(axis, index, i) ??
                    renderingDetails.chartTheme.minorTickLineColor,
                PaintingStyle.stroke),
            Offset(position, pointY),
            Offset(
                position,
                !axis.opposedPosition
                    ? (isInsideTickPosition!
                        ? pointY - ticks.size
                        : pointY + ticks.size)
                    : (isInsideTickPosition!
                        ? pointY + ticks.size
                        : pointY - ticks.size)),
            axis.minorGridLines.dashArray);
      }
    }
  }

  /// To find the height of the current label
  double _findMultiRows(int length, num currentX, AxisLabel currentLabel,
      ChartAxisRenderer axisRenderer, SfCartesianChart chart) {
    AxisLabel label;
    num pointX;
    final List<int> labelIndex = <int>[];
    bool isMultiRows;
    for (int i = length - 1; i >= 0; i--) {
      label = visibleLabels[i];
      pointX = (valueToCoefficient(label.value, this) *
              stateProperties.chartAxis.axisClipRect.width) +
          stateProperties.chartAxis.axisClipRect.left;
      isMultiRows = !axis.isInversed
          ? currentX < (pointX + label.labelSize.width / 2)
          : currentX + currentLabel.labelSize.width >
              (pointX - label.labelSize.width / 2);
      if (isMultiRows) {
        labelIndex.add(label._index);
        currentLabel._index = (currentLabel._index > label._index)
            ? currentLabel._index
            : label._index + 1;
      } else {
        currentLabel._index = labelIndex.contains(label._index)
            ? currentLabel._index
            : label._index;
      }
    }
    return currentLabel.labelSize.height * currentLabel._index;
  }

  /// To get the label collection
  List<String> _gettingLabelCollection(
      String currentLabel,
      num labelsExtent,
      ChartAxisRenderer axisRenderer,
      AxisLabelIntersectAction labelIntersectAction) {
    late List<String> textCollection = <String>[];
    if (labelIntersectAction == AxisLabelIntersectAction.wrap) {
      textCollection = currentLabel.split(RegExp(' '));
    } else {
      textCollection.add(currentLabel);
    }
    final List<String> labelCollection = <String>[];
    String text;
    final TextStyle labelStyle =
        axisRenderer._axisRendererDetails.chartThemeData.axisLabelTextStyle!;
    for (int i = 0; i < textCollection.length; i++) {
      text = textCollection[i];
      (measureText(text, labelStyle, labelRotation).width < labelsExtent)
          ? labelCollection.add(text)
          : labelCollection.add(getTrimmedText(text, labelsExtent, labelStyle,
              axisRenderer: axisRenderer,
              isRtl: axisRenderer._axisRendererDetails.stateProperties
                  .renderingDetails.isRtl));
    }
    return labelCollection;
  }

  /// Below method is for changing range while zooming
  void calculateZoomRange(ChartAxisRenderer axisRenderer, Size axisSize) {
    ChartAxisRenderer? oldAxisRenderer;
    assert(axis.zoomFactor >= 0 && axis.zoomFactor <= 1,
        'The zoom factor of the axis should be between 0 and 1.');
    assert(axis.zoomPosition >= 0 && axis.zoomPosition <= 1,
        'The zoom position of the axis should be between 0 and 1.');

    /// Restrict zoom factor and zoom position values between 0 to 1
    zoomFactor = zoomFactor > 1
        ? 1
        : zoomFactor < 0
            ? 0
            : zoomFactor;
    zoomPosition = zoomPosition > 1
        ? 1
        : zoomPosition < 0
            ? 0
            : zoomPosition;
    if (stateProperties.oldAxisRenderers.isNotEmpty) {
      oldAxisRenderer =
          getOldAxisRenderer(axisRenderer, stateProperties.oldAxisRenderers);
    }
    if (oldAxisRenderer != null) {
      zoomFactor = oldAxisRenderer._axisRendererDetails.axis.zoomFactor !=
              axis.zoomFactor
          ? axis.zoomFactor
          : zoomFactor;
      zoomPosition = oldAxisRenderer._axisRendererDetails.axis.zoomPosition !=
              axis.zoomPosition
          ? axis.zoomPosition
          : zoomPosition;
      if (axis.autoScrollingDelta ==
          oldAxisRenderer._axisRendererDetails.axis.autoScrollingDelta) {
        scrollingDelta = oldAxisRenderer._axisRendererDetails.scrollingDelta;
      }
    }

    final VisibleRange baseRange = visibleRange!;
    num start, end;
    start = visibleRange!.minimum + zoomPosition * visibleRange!.delta;
    end = start + zoomFactor * visibleRange!.delta;

    if (start < baseRange.minimum) {
      end = end + (baseRange.minimum - start);
      start = baseRange.minimum;
    }
    if (end > baseRange.maximum) {
      start = start - (end - baseRange.maximum);
      end = baseRange.maximum;
    }
    visibleRange!.minimum = start;
    visibleRange!.maximum = end;
    visibleRange!.delta = end - start;
  }

  /// To set the zoom factor and position of axis through dynamic update or from
  void setZoomFactorAndPosition(ChartAxisRenderer axisRenderer,
      List<ChartAxisRenderer> axisRendererStates) {
    bool didUpdateAxis;
    if (oldAxis != null &&
        (oldAxis!.zoomPosition != axis.zoomPosition ||
            oldAxis!.zoomFactor != axis.zoomFactor)) {
      zoomFactor = axis.zoomFactor;
      zoomPosition = axis.zoomPosition;
      didUpdateAxis = true;
    } else {
      didUpdateAxis = false;
    }
    for (final ChartAxisRenderer zoomedAxisRenderer
        in stateProperties.zoomedAxisRendererStates) {
      if (zoomedAxisRenderer._axisRendererDetails.name == name) {
        if (didUpdateAxis) {
          zoomedAxisRenderer._axisRendererDetails.zoomFactor = zoomFactor;
          zoomedAxisRenderer._axisRendererDetails.zoomPosition = zoomPosition;
        } else {
          if (axis.autoScrollingDelta == null ||
              scrollingDelta !=
                  zoomedAxisRenderer._axisRendererDetails.visibleRange!.delta) {
            zoomFactor = zoomedAxisRenderer._axisRendererDetails.zoomFactor;
            zoomPosition = zoomedAxisRenderer._axisRendererDetails.zoomPosition;
          }
        }
        break;
      }
    }
  }

  /// To provide chart changes to range controller
  void setRangeControllerValues(ChartAxisRenderer axisRenderer) {
    if (axisRenderer is DateTimeAxisRenderer ||
        axisRenderer is DateTimeCategoryAxisRenderer) {
      axis.rangeController!.start = DateTime.fromMillisecondsSinceEpoch(
          axisRenderer._axisRendererDetails.visibleRange!.minimum.toInt());
      axis.rangeController!.end = DateTime.fromMillisecondsSinceEpoch(
          axisRenderer._axisRendererDetails.visibleRange!.maximum.toInt());
    } else {
      axis.rangeController!.start =
          axisRenderer._axisRendererDetails.visibleRange!.minimum;
      axis.rangeController!.end =
          axisRenderer._axisRendererDetails.visibleRange!.maximum;
    }
  }

  /// Method to set zoom values from the range controller
  void setZoomValuesFromRangeController() {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    if (!(stateProperties.isRedrawByZoomPan ||
        stateProperties.canSetRangeController)) {
      if (stateProperties.rangeChangeBySlider &&
          !stateProperties.canSetRangeController &&
          rangeMinimum != null &&
          rangeMaximum != null) {
        visibleRange!.delta = visibleRange!.maximum - visibleRange!.minimum;
        if (this is! DateTimeCategoryAxisRenderer) {
          visibleRange!.interval = axisRenderer is LogarithmicAxisRenderer
              ? (axisDetails.axisRenderer as LogarithmicAxisRenderer)
                  .calculateLogNiceInterval(visibleRange!.delta)
              : axisRenderer.calculateInterval(visibleRange!, axisSize);
        }
        visibleRange!.interval =
            actualRange!.interval != null && actualRange!.interval % 1 != 0
                ? actualRange!.interval
                : visibleRange!.interval;
        zoomFactor = visibleRange!.delta / (actualRange!.delta);
        zoomPosition =
            (visibleRange!.minimum - actualRange!.minimum) / actualRange!.delta;
      }
    }
  }

  /// Method to set the old range from range controller
  void setOldRangeFromRangeController() {
    if (!stateProperties.renderingDetails.initialRender! &&
        axis.rangeController != null &&
        !stateProperties.canSetRangeController) {
      final ChartAxisRenderer? oldrenderer =
          getOldAxisRenderer(axisRenderer, stateProperties.oldAxisRenderers);
      if (oldrenderer != null) {
        final ChartAxisRendererDetails axisRendererDetails =
            oldrenderer._axisRendererDetails;
        visibleMinimum = rangeMinimum =
            axisRendererDetails.rangeMinimum is DateTime
                ? axisRendererDetails.rangeMinimum.millisecondsSinceEpoch
                : axisRendererDetails.rangeMinimum;
        visibleMaximum = rangeMaximum =
            axisRendererDetails.rangeMaximum is DateTime
                ? axisRendererDetails.rangeMaximum.millisecondsSinceEpoch
                : axisRendererDetails.rangeMaximum;
      }
    }
  }

  /// To get the previous location of an axis
  double? _getPrevLocation(ChartAxisRenderer axisRenderer,
      ChartAxisRenderer oldAxisRenderer, num value,
      [Size? textSize, num? angle]) {
    double? location;
    final Rect bounds = axisRenderer._axisRendererDetails.bounds;
    final ChartAxis axis = axisRenderer._axisRendererDetails.axis;
    textSize ??= Size.zero;
    if (oldAxisRenderer._axisRendererDetails.visibleRange!.minimum > value ==
        false) {
      location = axisRenderer._axisRendererDetails.orientation ==
              AxisOrientation.vertical
          ? (axis.isInversed
              ? ((bounds.top + bounds.height) -
                  ((bounds.top -
                          (bounds.top -
                                  (valueToCoefficient(value, oldAxisRenderer._axisRendererDetails) *
                                      bounds.height))
                              .roundToDouble())
                      .abs()))
              : (bounds.bottom -
                      (valueToCoefficient(
                              value, oldAxisRenderer._axisRendererDetails) *
                          bounds.height))
                  .roundToDouble())
          : (axis.isInversed
              ? ((valueToCoefficient(value, axisRenderer._axisRendererDetails) *
                          bounds.width) +
                      bounds.right)
                  .roundToDouble()
              : ((valueToCoefficient(value, oldAxisRenderer._axisRendererDetails) *
                          bounds.width) -
                      bounds.left)
                  .roundToDouble());
    } else if (oldAxisRenderer._axisRendererDetails.visibleRange!.maximum <
            value ==
        false) {
      location = axisRenderer._axisRendererDetails.orientation ==
              AxisOrientation.vertical
          ? (axis.isInversed
              ? (bounds.bottom -
                      (valueToCoefficient(
                              value, oldAxisRenderer._axisRendererDetails) *
                          bounds.height))
                  .roundToDouble()
              : ((bounds.top + bounds.height) -
                  ((bounds.top -
                          (bounds.top -
                                  (valueToCoefficient(value, oldAxisRenderer._axisRendererDetails) *
                                      bounds.height))
                              .roundToDouble())
                      .abs())))
          : (axis.isInversed
              ? ((valueToCoefficient(value, oldAxisRenderer._axisRendererDetails) *
                          bounds.width) -
                      bounds.left)
                  .roundToDouble()
              : ((valueToCoefficient(value, axisRenderer._axisRendererDetails) *
                          bounds.width) +
                      bounds.right)
                  .roundToDouble());
    } else {
      if (axisRenderer._axisRendererDetails.orientation ==
          AxisOrientation.vertical) {
        location =
            (valueToCoefficient(value, oldAxisRenderer._axisRendererDetails) *
                    oldAxisRenderer._axisRendererDetails.bounds.height) +
                oldAxisRenderer._axisRendererDetails.bounds.top;
        location = ((oldAxisRenderer._axisRendererDetails.bounds.top +
                    oldAxisRenderer._axisRendererDetails.bounds.height) -
                ((oldAxisRenderer._axisRendererDetails.bounds.top - location)
                    .abs())) -
            textSize.height / 2;
      } else {
        location =
            ((valueToCoefficient(value, oldAxisRenderer._axisRendererDetails) *
                        oldAxisRenderer._axisRendererDetails.bounds.width) +
                    oldAxisRenderer._axisRendererDetails.bounds.left)
                .roundToDouble();
        if (angle != null) {
          location -= angle == 0 ? textSize.width / 2 : 0;
        }
      }
    }
    return location;
  }

  /// Return the x point
  double _getPointX(
      ChartAxisRenderer axisRenderer, Size textSize, Rect axisBounds) {
    late double pointX;
    const num innerPadding = 5;
    final ChartAxisRendererDetails axisRendererDetails =
        axisRenderer._axisRendererDetails;
    final ChartAxis axis = axisRendererDetails.axis;
    if (axis.borderWidth > 0 || axisRendererDetails.isMultiLevelLabelEnabled) {
      pointX = getLabelOffsetX(axisRendererDetails, textSize);
    } else {
      if (axis.labelPosition == ChartDataLabelPosition.inside) {
        pointX = (!axis.opposedPosition)
            ? axisRendererDetails.labelOffset ??
                (axisBounds.left +
                    innerPadding +
                    (axisRendererDetails.isInsideTickPosition!
                        ? axis.majorTickLines.size
                        : 0))
            : axisRendererDetails.labelOffset != null
                ? axisRendererDetails.labelOffset! - textSize.width
                : (axisBounds.left -
                    axisRendererDetails.maximumLabelSize.width -
                    innerPadding -
                    (axisRendererDetails.isInsideTickPosition!
                        ? axis.majorTickLines.size
                        : 0));
      } else {
        pointX = ((!axis.opposedPosition)
                ? axisRendererDetails.labelOffset != null
                    ? axisRenderer._axisRendererDetails.labelOffset! -
                        textSize.width
                    : (axisBounds.left -
                        (axisRendererDetails.isInsideTickPosition!
                            ? 0
                            : axis.majorTickLines.size) -
                        textSize.width -
                        innerPadding)
                : (axisRendererDetails.labelOffset ??
                    (axisBounds.left +
                        (axisRendererDetails.isInsideTickPosition!
                            ? 0
                            : axis.majorTickLines.size) +
                        innerPadding)))
            .toDouble();
      }
    }
    return pointX;
  }

  /// Return the y point
  double _getPointY(
      ChartAxisRenderer axisRenderer, AxisLabel label, Rect axisBounds) {
    final ChartAxisRendererDetails axisRendererDetails =
        axisRenderer._axisRendererDetails;
    final ChartAxis axis = axisRendererDetails.axis;
    double pointY;
    const num innerPadding = 3;
    if (axis.borderWidth > 0 || axisRendererDetails.isMultiLevelLabelEnabled) {
      pointY = getLabelOffsetY(this, label._index);
    } else {
      if (axis.labelPosition == ChartDataLabelPosition.inside) {
        pointY = axis.opposedPosition == false
            ? axisRendererDetails.labelOffset != null
                ? axisRendererDetails.labelOffset! -
                    axisRendererDetails.maximumLabelSize.height
                : axisBounds.top -
                    innerPadding -
                    (label._index > 1
                        ? axisRendererDetails.maximumLabelSize.height / 2
                        : axisRendererDetails.maximumLabelSize.height) -
                    (axisRendererDetails.isInsideTickPosition!
                        ? axis.majorTickLines.size
                        : 0)
            : axisRendererDetails.labelOffset ??
                axisBounds.top +
                    (axisRendererDetails.isInsideTickPosition!
                        ? axis.majorTickLines.size
                        : 0) +
                    (label._index > 1
                        ? axisRendererDetails.maximumLabelSize.height / 2
                        : 0);
      } else {
        pointY = (axis.opposedPosition == false
                ? axisRendererDetails.labelOffset ??
                    (axisBounds.top +
                        ((axisRendererDetails.isInsideTickPosition!
                                ? 0
                                : axis.majorTickLines.size) +
                            innerPadding) +
                        (label._index > 1
                            ? axisRendererDetails.maximumLabelSize.height / 2
                            : 0))
                : axisRendererDetails.labelOffset != null
                    ? axisRendererDetails.labelOffset! -
                        axisRendererDetails.maximumLabelSize.height
                    : (axisBounds.top -
                        (((axisRendererDetails.isInsideTickPosition!
                                    ? 0
                                    : axis.majorTickLines.size) +
                                innerPadding) -
                            (label._index > 1
                                ? axisRendererDetails.maximumLabelSize.height /
                                    2
                                : 0)) -
                        axisRendererDetails.maximumLabelSize.height))
            .toDouble();
      }
    }
    return pointY;
  }

  /// To get shifted position for both axes
  double _getShiftedPosition(ChartAxisRenderer axisRenderer, Rect axisBounds,
      double pointX, double pointY, Size textSize, int i) {
    final ChartAxis axis = axisRenderer._axisRendererDetails.axis;
    if (axis.edgeLabelPlacement == EdgeLabelPlacement.shift) {
      if (axis.labelAlignment == LabelAlignment.center) {
        if (i == 0 &&
            ((pointX < axisBounds.left && !axis.isInversed) ||
                (pointX + textSize.width > axisBounds.right &&
                    axis.isInversed))) {
          pointX = axis.isInversed
              ? axisBounds.left + axisBounds.width - textSize.width
              : axisBounds.left;
        }

        if (i == axisRenderer._axisRendererDetails.visibleLabels.length - 1 &&
            ((((pointX + textSize.width) > axisBounds.right) &&
                    !axis.isInversed) ||
                (pointX < axisBounds.left && axis.isInversed))) {
          pointX = axis.isInversed
              ? axisBounds.left
              : axisBounds.left + axisBounds.width - textSize.width;
        }
      } else if ((axis.labelAlignment == LabelAlignment.end) &&
          (i == axisRenderer._axisRendererDetails.visibleLabels.length - 1 &&
              ((((pointX + textSize.width) > axisBounds.right) &&
                      !axis.isInversed) ||
                  (pointX < axisBounds.left && axis.isInversed)))) {
        pointX = axis.isInversed
            ? axisBounds.left
            : axisBounds.left +
                axisBounds.width -
                textSize.width -
                textSize.height / 2;
      } else if ((axis.labelAlignment == LabelAlignment.start) &&
          (i == 0 &&
              ((pointX < axisBounds.left && !axis.isInversed) ||
                  (pointX + textSize.width > axisBounds.right &&
                      axis.isInversed)))) {
        pointX = axis.isInversed
            ? axisBounds.left + axisBounds.width - textSize.width
            : axisBounds.left + textSize.height / 2;
      }
    }

    final Rect currentRegion = axis.labelRotation == 0 &&
            !(axis.labelIntersectAction == AxisLabelIntersectAction.rotate45 ||
                axis.labelIntersectAction == AxisLabelIntersectAction.rotate90)
        ? Rect.fromLTWH(pointX, pointY, textSize.width, textSize.height)
        : Rect.fromLTWH(pointX - textSize.width / 2,
            pointY - textSize.height / 2, textSize.width, textSize.height);
    final bool isIntersect = i > 0 &&
        i < axisRenderer._axisRendererDetails.visibleLabels.length - 1 &&
        axis.labelIntersectAction == AxisLabelIntersectAction.hide &&
        axis.labelRotation % 180 == 0 &&
        axisRenderer._axisRendererDetails.visibleLabels[i - 1]._labelRegion !=
            null &&
        (axisRenderer._axisRendererDetails.axis.isInversed == false
            ? currentRegion.left <
                axisRenderer._axisRendererDetails.visibleLabels[i - 1]
                    ._labelRegion!.right
            : currentRegion.right >
                axisRenderer._axisRendererDetails.visibleLabels[i - 1]
                    ._labelRegion!.left);
    axisRenderer._axisRendererDetails.visibleLabels[i]._labelRegion =
        !isIntersect ? currentRegion : null;
    return pointX;
  }

  void _drawVerticalAxesTickLines(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart,
      [String? renderType,
      double? animationFactor,
      ChartAxisRenderer? oldAxisRenderer,
      bool? needAnimate]) {
    final dynamic axis = axisRenderer._axisRendererDetails.axis;
    final Rect axisBounds = axisRenderer._axisRendererDetails.bounds;
    double betweenTicksPointValue = 0.0;
    final List<AxisLabel> visibleLabels =
        axisRenderer._axisRendererDetails.visibleLabels;
    double tempInterval, pointX, pointY;
    int length = visibleLabels.length;
    final bool isBetweenTicks =
        (axis is CategoryAxis || axis is DateTimeCategoryAxis) &&
            axis.labelPlacement == LabelPlacement.betweenTicks;
    final num tickBetweenLabel = isBetweenTicks ? 0.5 : 0;
    length += isBetweenTicks ? 1 : 0;
    for (int i = 0; i < length; i++) {
      tempInterval = (isBetweenTicks
              ? i < length - 1
                  ? visibleLabels[i].value - tickBetweenLabel
                  : (visibleLabels[i - 1].value +
                          axisRenderer
                              ._axisRendererDetails.visibleRange!.interval) -
                      tickBetweenLabel
              : visibleLabels[i].value)
          .toDouble();
      pointY =
          (valueToCoefficient(tempInterval, axisRenderer._axisRendererDetails) *
                  axisBounds.height) +
              axisBounds.top;
      pointY = (axisBounds.top + axisBounds.height) -
          (pointY - axisBounds.top).abs();
      pointX = axisBounds.left;

      if (needAnimate!) {
        final double? oldLocation =
            _getPrevLocation(axisRenderer, oldAxisRenderer!, tempInterval);
        pointY = oldLocation != null
            ? (oldLocation - (oldLocation - pointY) * animationFactor!)
            : pointY;
      }
      if (pointY >= axisBounds.top && pointY <= axisBounds.bottom) {
        if (axis.majorGridLines.width > 0 == true &&
            renderType == 'outside' &&
            (axis.plotOffset > 0 == true ||
                ((i == 0 || i == length - 1) &&
                    chart.plotAreaBorderWidth == 0) ||
                (((i == 0 && axis.opposedPosition == false) ||
                        (i == length - 1 && axis.opposedPosition == true)) &&
                    axis.axisLine.width == 0) ||
                (axisBounds.top < pointY - axis.majorGridLines.width &&
                    axisBounds.bottom > pointY + axis.majorGridLines.width))) {
          axisRenderer.drawVerticalAxesMajorGridLines(
              canvas,
              Offset(pointX, pointY),
              axisRenderer,
              axis.majorGridLines,
              i,
              chart);
        }
        if (axis.minorGridLines.width > 0 == true ||
            axis.minorTickLines.width > 0 == true) {
          axisRenderer.drawVerticalAxesMinorTickLines(canvas, axisRenderer,
              tempInterval, axisBounds, i, chart, renderType!);
        }
        if (axis.majorTickLines.width > 0 == true &&
            renderType == axis.tickPosition.toString().split('.')[1]) {
          drawDashedPath(
              canvas,
              CustomPaintStyle(
                  axisRenderer.getAxisMajorTickWidth(axis, i),
                  axisRenderer.getAxisMajorTickColor(axis, i) ??
                      renderingDetails.chartTheme.majorTickLineColor,
                  PaintingStyle.stroke),
              Offset(pointX, pointY),
              Offset(
                  axis.opposedPosition == false
                      ? (axisRenderer._axisRendererDetails.isInsideTickPosition!
                          ? pointX + axis.majorTickLines.size
                          : pointX - axis.majorTickLines.size)
                      : (axisRenderer._axisRendererDetails.isInsideTickPosition!
                          ? pointX - axis.majorTickLines.size
                          : pointX + axis.majorTickLines.size),
                  pointY));
        }
      }
      if ((axis.borderWidth > 0 == true || isMultiLevelLabelEnabled) &&
          i == 0) {
        setAxisBorderEndPoint(this, pointX);
      }
      if (axis.borderWidth > 0 == true) {
        if (i == 0 && !isBetweenTicks && visibleLabels.length > 1) {
          num nextPoint =
              (valueToCoefficient(visibleLabels[i + 1].value, this) *
                      bounds.height) +
                  bounds.top;
          nextPoint = (axisBounds.top + axisBounds.height) -
              (nextPoint - axisBounds.top).abs();
          betweenTicksPointValue = (nextPoint.toDouble() - pointY) / 2;
        }
        renderVerticalAxisBorder(this, canvas, pointX, pointY, isBetweenTicks,
            betweenTicksPointValue, i);
      }
    }
  }

  /// Method to draw the vertical axes major grid line
  void _drawVerticalAxesMajorGridLines(
      Canvas canvas,
      Offset point,
      ChartAxisRenderer axisRenderer,
      MajorGridLines grids,
      int index,
      SfCartesianChart chart) {
    final CustomPaintStyle paintStyle = CustomPaintStyle(
        axisRenderer.getAxisMajorGridWidth(
            axisRenderer._axisRendererDetails.axis, index),
        axisRenderer.getAxisMajorGridColor(
                axisRenderer._axisRendererDetails.axis, index) ??
            renderingDetails.chartTheme.majorGridLineColor,
        PaintingStyle.stroke);
    if (stateProperties.chartAxis.primaryXAxisRenderer!._axisRendererDetails
                .xAxisStart !=
            Offset(stateProperties.chartAxis.axisClipRect.left, point.dy) &&
        stateProperties.chartAxis.primaryXAxisRenderer!._axisRendererDetails
                .xAxisEnd !=
            Offset(
                stateProperties.chartAxis.axisClipRect.left +
                    stateProperties.chartAxis.axisClipRect.width,
                point.dy)) {
      drawDashedPath(
          canvas,
          paintStyle,
          Offset(stateProperties.chartAxis.axisClipRect.left, point.dy),
          Offset(
              stateProperties.chartAxis.axisClipRect.left +
                  stateProperties.chartAxis.axisClipRect.width,
              point.dy),
          grids.dashArray);
    }
  }

  void _drawVerticalAxesMinorTickLines(
      Canvas canvas,
      ChartAxisRenderer axisRenderer,
      num tempInterval,
      Rect rect,
      int index,
      SfCartesianChart chart,
      [String? renderType]) {
    num value = tempInterval;
    double position = 0;
    final VisibleRange range = visibleRange!;
    final bool rendering = axis.minorTicksPerInterval > 0 &&
        (axis.minorGridLines.width > 0 || axis.minorTickLines.width > 0);
    if (rendering) {
      for (int i = 0; i < axis.minorTicksPerInterval; i++) {
        value += range.interval / (axis.minorTicksPerInterval + 1);
        if ((value < range.maximum) && (value > range.minimum)) {
          position =
              valueToCoefficient(value, axisRenderer._axisRendererDetails) *
                  rect.height;
          position = (position + rect.top).floor().toDouble();
          if (axis.minorGridLines.width > 0 &&
              renderType == 'outside' &&
              rect.top <= position &&
              rect.bottom >= position) {
            drawDashedPath(
                canvas,
                CustomPaintStyle(
                    axisRenderer.getAxisMinorGridWidth(axis, index, i),
                    axisRenderer.getAxisMinorGridColor(axis, index, i) ??
                        renderingDetails.chartTheme.minorGridLineColor,
                    PaintingStyle.stroke),
                Offset(stateProperties.chartAxis.axisClipRect.left, position),
                Offset(
                    stateProperties.chartAxis.axisClipRect.left +
                        stateProperties.chartAxis.axisClipRect.width,
                    position),
                axis.minorGridLines.dashArray);
          }
          if (axis.minorTickLines.width > 0 &&
              renderType == axis.tickPosition.toString().split('.')[1]) {
            drawDashedPath(
                canvas,
                CustomPaintStyle(
                    axisRenderer.getAxisMinorTickWidth(axis, index, i),
                    axisRenderer.getAxisMinorTickColor(axis, index, i) ??
                        renderingDetails.chartTheme.minorTickLineColor,
                    PaintingStyle.stroke),
                Offset(rect.left, position),
                Offset(
                    !axis.opposedPosition
                        ? (isInsideTickPosition!
                            ? rect.left + axis.minorTickLines.size
                            : rect.left - axis.minorTickLines.size)
                        : (isInsideTickPosition!
                            ? rect.left - axis.minorTickLines.size
                            : rect.left + axis.minorTickLines.size),
                    position));
          }
        }
      }
    }
  }

  /// To draw the axis labels of horizontal axes
  void _drawHorizontalAxesLabels(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart,
      [String? renderType,
      double? animationFactor,
      ChartAxisRenderer? oldAxisRenderer,
      bool? needAnimate]) {
    if (renderType == axis.labelPosition.toString().split('.')[1]) {
      final Rect axisBounds = bounds;
      int angle;
      TextStyle textStyle;
      final bool isRtl = axisRenderer
          ._axisRendererDetails.stateProperties.renderingDetails.isRtl;
      late double tempInterval, pointX, pointY, previousLabelEnd;
      for (int i = 0; i < visibleLabels.length; i++) {
        final AxisLabel label = visibleLabels[i];
        final String labelText =
            axisRenderer.getAxisLabel(axis, label.renderText!, i);
        textStyle = label.labelStyle;
        textStyle = getTextStyle(
            textStyle: textStyle,
            fontColor:
                textStyle.color ?? renderingDetails.chartTheme.axisLabelColor);
        tempInterval = label.value.toDouble();
        angle = axisRenderer.getAxisLabelAngle(axisRenderer, labelText, i);

        /// For negative angle calculations
        if (angle.isNegative) {
          angle = angle + 360;
        }
        labelRotation = angle;
        final Size textSize = measureText(labelText, textStyle);
        final Size rotatedTextSize = measureText(labelText, textStyle, angle);
        pointX = ((valueToCoefficient(
                        tempInterval, axisRenderer._axisRendererDetails) *
                    axisBounds.width) +
                axisBounds.left)
            .roundToDouble();
        pointY = _getPointY(axisRenderer, label, axisBounds);
        pointY -= angle == 0 ? textSize.height / 2 : 0;
        pointY += rotatedTextSize.height / 2;
        pointX -= angle == 0 ? textSize.width / 2 : 0;

        ///  Edge label placement - shift for x-Axis
        pointX = _getShiftedPosition(
            axisRenderer, axisBounds, pointX, pointY, rotatedTextSize, i);
        if (axis.labelAlignment == LabelAlignment.end) {
          pointX = pointX + textSize.height / 2;
        } else if (axis.labelAlignment == LabelAlignment.start) {
          pointX = pointX - textSize.height / 2;
        }
        if (axis.edgeLabelPlacement == EdgeLabelPlacement.hide) {
          if (axis.labelAlignment == LabelAlignment.center) {
            if (i == 0 || (i == visibleLabels.length - 1)) {
              visibleLabels[i]._needRender = false;
              continue;
            }
          } else if ((axis.labelAlignment == LabelAlignment.end) &&
              (i == visibleLabels.length - 1 || (i == 0 && axis.isInversed))) {
            visibleLabels[i]._needRender = false;
            continue;
          } else if ((axis.labelAlignment == LabelAlignment.start) &&
              (i == 0 || (i == visibleLabels.length - 1 && axis.isInversed))) {
            visibleLabels[i]._needRender = false;
            continue;
          }
        }

        if (axis.labelIntersectAction == AxisLabelIntersectAction.hide &&
            axis.labelRotation % 180 == 0 &&
            i != 0 &&
            visibleLabels[i - 1]._needRender &&
            (!axis.isInversed
                ? pointX <= previousLabelEnd
                : (pointX + textSize.width) >= previousLabelEnd)) {
          continue;
        }

        previousLabelEnd = axis.isInversed ? pointX : pointX + textSize.width;

        if (needAnimate!) {
          final double? oldLocation = _getPrevLocation(
              axisRenderer, oldAxisRenderer!, tempInterval, textSize, angle);
          pointX = oldLocation != null
              ? (oldLocation - (oldLocation - pointX) * animationFactor!)
              : pointX;
        }
        final Offset point = Offset(pointX, pointY);
        if (axisBounds.left - textSize.width <= pointX &&
            axisBounds.right + textSize.width >= pointX) {
          drawText(canvas, labelText, point, textStyle, angle, isRtl);
        }
        if (label._labelCollection != null &&
            label._labelCollection!.isNotEmpty &&
            axis.labelIntersectAction == AxisLabelIntersectAction.wrap) {
          double? finalTextStartPoint;
          for (int j = 1; j < label._labelCollection!.length; j++) {
            final String wrapTxt = label._labelCollection![j];
            finalTextStartPoint =
                pointY + (j * measureText(wrapTxt, textStyle, angle).height);
            drawText(canvas, wrapTxt, Offset(pointX, finalTextStartPoint),
                textStyle, angle, isRtl);
            if (j == label._labelCollection!.length - 1) {
              label._labelRegion = Rect.fromLTWH(
                  pointX,
                  pointY,
                  label._labelRegion!.width,
                  finalTextStartPoint + (label.labelSize.height) - pointY);
            }
          }
        }
      }
    }
  }

  /// To draw the axis labels of vertical axes
  void _drawVerticalAxesLabels(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart,
      [String? renderType,
      double? animationFactor,
      ChartAxisRenderer? oldAxisRenderer,
      bool? needAnimate]) {
    if (axis.labelPosition.toString().split('.')[1] == renderType) {
      final Rect axisBounds = bounds;
      TextStyle textStyle;
      late double tempInterval, pointX, pointY, previousEnd;
      for (int i = 0; i < visibleLabels.length; i++) {
        final String labelText =
            axisRenderer.getAxisLabel(axis, visibleLabels[i].renderText!, i);
        final int angle =
            axisRenderer.getAxisLabelAngle(axisRenderer, labelText, i);
        assert(angle - angle.floor() == 0,
            'The angle value of the vertical axis must be the whole number.');
        textStyle = visibleLabels[i].labelStyle;
        textStyle = getTextStyle(
            textStyle: textStyle,
            fontColor:
                textStyle.color ?? renderingDetails.chartTheme.axisLabelColor);
        tempInterval = visibleLabels[i].value.toDouble();
        final Size textSize = measureText(labelText, textStyle, 0);
        pointY = (valueToCoefficient(
                    tempInterval, axisRenderer._axisRendererDetails) *
                axisBounds.height) +
            axisBounds.top;
        pointY = ((axisBounds.top + axisBounds.height) -
                ((axisBounds.top - pointY).abs())) -
            textSize.height / 2;
        pointX = _getPointX(axisRenderer, textSize, axisBounds);
        final ChartLocation location = getRotatedTextLocation(
            pointX, pointY, labelText, textStyle, angle, axis);
        if (axis.labelAlignment == LabelAlignment.center) {
          pointX = location.x;
          pointY = location.y;
        } else if (axis.labelAlignment == LabelAlignment.end) {
          pointX = location.x;
          pointY = location.y - textSize.height / 2;
        } else if (axis.labelAlignment == LabelAlignment.start) {
          pointX = location.x;
          pointY = location.y + textSize.height / 2;
        }
        if (axis.labelIntersectAction == AxisLabelIntersectAction.hide &&
            i != 0 &&
            (!axis.isInversed
                ? pointY + (textSize.height / 2) > previousEnd
                : pointY - (textSize.height / 2) < previousEnd)) {
          continue;
        }
        previousEnd = !axis.isInversed
            ? pointY - textSize.height / 2
            : pointY + textSize.height / 2;

        ///  Edge label placement for y-Axis
        if (axis.edgeLabelPlacement == EdgeLabelPlacement.shift) {
          if (axis.labelAlignment == LabelAlignment.center) {
            if (i == 0 && axisBounds.bottom <= pointY + textSize.height / 2) {
              pointY = axisBounds.top + axisBounds.height - textSize.height;
            } else if (i == visibleLabels.length - 1 &&
                axisBounds.top >= pointY + textSize.height / 2) {
              pointY = axisBounds.top;
            }
          } else if (axis.labelAlignment == LabelAlignment.start) {
            if (i == 0 && axisBounds.bottom <= pointY + textSize.height / 2) {
              pointY = axisBounds.top + axisBounds.height - textSize.height;
            }
          } else if (axis.labelAlignment == LabelAlignment.end) {
            if (i == visibleLabels.length - 1 &&
                axisBounds.top >= pointY + textSize.height / 2) {
              pointY = axisBounds.top + textSize.height / 2;
            }
          }
        } else if (axis.edgeLabelPlacement == EdgeLabelPlacement.hide) {
          if (axis.labelAlignment == LabelAlignment.center) {
            if (i == 0 || i == visibleLabels.length - 1) {
              continue;
            }
          } else if ((axis.labelAlignment == LabelAlignment.end) &&
              (i == visibleLabels.length - 1 || (i == 0 && axis.isInversed))) {
            continue;
          } else if ((axis.labelAlignment == LabelAlignment.start) &&
              (i == 0 || (i == visibleLabels.length - 1 && axis.isInversed))) {
            continue;
          }
        }
        final Size rotatedTextSize = measureText(labelText, textStyle, angle);
        visibleLabels[i]._labelRegion = axis.labelRotation == 0
            ? Rect.fromLTWH(pointX, pointY, textSize.width, textSize.height)
            : Rect.fromLTWH(
                pointX - rotatedTextSize.width / 2,
                pointY - rotatedTextSize.height / 2,
                rotatedTextSize.width,
                rotatedTextSize.height);

        if (needAnimate!) {
          final double? oldLocation = _getPrevLocation(
              axisRenderer, oldAxisRenderer!, tempInterval, textSize);
          pointY = oldLocation != null
              ? (oldLocation - (oldLocation - pointY) * animationFactor!)
              : pointY;
        }

        final Offset point = Offset(pointX, pointY);
        if (axisBounds.top - textSize.height <= pointY &&
            axisBounds.bottom + textSize.height >= pointY) {
          drawText(
              canvas,
              labelText,
              point,
              textStyle,
              labelRotation,
              axisRenderer
                  ._axisRendererDetails.stateProperties.renderingDetails.isRtl);
        }
      }
    }
  }

  /// To draw the axis title of horizontal axes
  void _drawHorizontalAxesTitle(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart) {
    final Rect axisBounds = bounds;
    Offset point;
    final String title = axis.title.text ?? '';
    const int labelRotation = 0, innerPadding = 8;
    final TextStyle titleStyle = chartThemeData.axisTitleTextStyle!;
    final Size textSize = measureText(title, titleStyle);
    double top = 0.0;
    final ChartAxisRendererDetails axisRendererDetails =
        axisRenderer._axisRendererDetails;
    if ((axis.borderWidth > 0 || isMultiLevelLabelEnabled) &&
        (visibleLabels.isNotEmpty)) {
      top = getHorizontalAxisTitleOffset(this, textSize);
    } else {
      if (axis.labelPosition == ChartDataLabelPosition.inside) {
        top = !axis.opposedPosition
            ? axisRendererDetails.titleOffset ??
                axisBounds.top +
                    (isInsideTickPosition! ? 0 : axis.majorTickLines.size) +
                    (!kIsWeb
                        ? innerPadding
                        : innerPadding + textSize.height / 2)
            : axisRendererDetails.titleOffset != null
                ? axisRendererDetails.titleOffset! - textSize.height
                : axisBounds.top -
                    (isInsideTickPosition! ? 0 : axis.majorTickLines.size) -
                    innerPadding -
                    textSize.height;
      } else {
        top = !axis.opposedPosition
            ? axisRendererDetails.titleOffset ??
                axisBounds.top +
                    (isInsideTickPosition! ? 0 : axis.majorTickLines.size) +
                    innerPadding +
                    (!kIsWeb
                        ? maximumLabelSize.height
                        : maximumLabelSize.height + textSize.height / 2)
            : axisRendererDetails.titleOffset != null
                ? axisRendererDetails.titleOffset! - textSize.height
                : axisBounds.top -
                    (isInsideTickPosition! ? 0 : axis.majorTickLines.size) -
                    innerPadding -
                    maximumLabelSize.height -
                    textSize.height;
      }
    }
    axis.title.alignment == ChartAlignment.near
        ? point = Offset(stateProperties.chartAxis.axisClipRect.left, top)
        : axis.title.alignment == ChartAlignment.far
            ? point = Offset(
                stateProperties.chartAxis.axisClipRect.right - textSize.width,
                top)
            : point = Offset(
                axisBounds.left +
                    ((axisBounds.width / 2) - (textSize.width / 2)),
                top);
    if (seriesRenderers.isNotEmpty || name == 'primaryXAxis') {
      drawText(canvas, title, point, titleStyle, labelRotation);
    }
  }

  /// To draw the axis title of vertical axes
  void _drawVerticalAxesTitle(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart) {
    final Rect axisBounds = bounds;
    Offset point;
    final String title = axis.title.text ?? '';
    final int labelRotation = axis.opposedPosition ? 90 : 270;
    const int innerPadding = 10;
    final TextStyle style = chartThemeData.axisTitleTextStyle!;
    final Size textSize = measureText(title, style);
    double left = 0.0;
    final ChartAxisRendererDetails axisRendererDetails =
        axisRenderer._axisRendererDetails;
    if (axis.borderWidth > 0 || isMultiLevelLabelEnabled) {
      left = getVerticalAxisTitleOffset(this, textSize);
    } else {
      if (axis.labelPosition == ChartDataLabelPosition.inside) {
        left = (!axis.opposedPosition)
            ? axisRendererDetails.titleOffset != null
                ? axisRendererDetails.titleOffset! - textSize.height / 2
                : axisBounds.left -
                    (isInsideTickPosition! ? 0 : axis.majorTickLines.size) -
                    innerPadding -
                    textSize.height
            : axisRendererDetails.titleOffset != null
                ? axisRendererDetails.titleOffset! + textSize.height / 2
                : axisBounds.left +
                    (isInsideTickPosition! ? 0 : axis.majorTickLines.size) +
                    innerPadding * 2;
      } else {
        left = (!axis.opposedPosition)
            ? axisRendererDetails.titleOffset != null
                ? axisRendererDetails.titleOffset! - textSize.height
                : (axisBounds.left -
                    (isInsideTickPosition! ? 0 : axis.majorTickLines.size) -
                    innerPadding -
                    maximumLabelSize.width -
                    textSize.height / 2)
            : axisRendererDetails.titleOffset != null
                ? axisRendererDetails.titleOffset! + textSize.height / 2
                : axisBounds.left +
                    (isInsideTickPosition! ? 0 : axis.majorTickLines.size) +
                    innerPadding +
                    maximumLabelSize.width +
                    textSize.height / 2;
      }
    }
    axis.title.alignment == ChartAlignment.near
        ? point = Offset(left,
            stateProperties.chartAxis.axisClipRect.bottom - textSize.width / 2)
        : axis.title.alignment == ChartAlignment.far
            ? point = Offset(left,
                stateProperties.chartAxis.axisClipRect.top + textSize.width / 2)
            : point = Offset(left, axisBounds.top + (axisBounds.height / 2));
    if (seriesRenderers.isNotEmpty || name == 'primaryYAxis') {
      drawText(canvas, title, point, style, labelRotation);
    }
  }

  /// Find the additional range
  void _findAdditionalRange(
      ChartAxisRenderer axisRenderer, num start, num end, num interval) {
    num minimum;
    num maximum;
    minimum = ((start / interval).floor()) * interval;
    maximum = ((end / interval).ceil()) * interval;
    if (axis.rangePadding == ChartRangePadding.additional) {
      minimum -= interval;
      maximum += interval;
    }

    /// Update the visible range to the axis.
    _updateActualRange(axisRenderer, minimum, maximum, interval);
  }

  /// Update visible range
  void _updateActualRange(
      ChartAxisRenderer axisRenderer, num minimum, num maximum, num interval) {
    final dynamic chartAxis = axis;
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    actualRange!.minimum = chartAxis.minimum == null
        ? minimum
        : (axisDetails is DateTimeCategoryAxisDetails
            ? (axisDetails.getEffectiveRange(chartAxis.minimum, true)! -
                (chartAxis.labelPlacement != LabelPlacement.onTicks ? 0 : 0.5))
            : chartAxis.minimum);
    actualRange!.maximum = chartAxis.maximum == null
        ? maximum
        : (axisDetails is DateTimeCategoryAxisDetails
            ? (axisDetails.getEffectiveRange(chartAxis.maximum, true)! +
                (chartAxis.labelPlacement != LabelPlacement.onTicks ? 0 : 0.5))
            : chartAxis.maximum);
    if (actualRange!.maximum == 0 &&
        actualRange!.minimum == actualRange!.maximum) {
      actualRange!.maximum += 1;
    }
    actualRange!.delta = actualRange!.maximum - actualRange!.minimum;
    actualRange!.interval = axis.interval ?? interval;
  }

  /// Find the normal range
  void _findNormalRange(
      ChartAxisRenderer axisRenderer, num start, num end, num interval) {
    final dynamic chartAxis = axis;
    num remaining, minimum, maximum;
    num startValue = start;
    if ((axis is CategoryAxis || axis is DateTimeCategoryAxis) &&
        chartAxis.labelPlacement == LabelPlacement.onTicks) {
      minimum = start - 0.5;
      maximum = end + 0.5;
    } else {
      if (start < 0) {
        if (start.isNegative && end.isNegative) {
          minimum = start > ((5.0 / 6.0) * end) ? 0 : start - (end - start) / 2;
        } else {
          startValue = 0;
          minimum = start + (start / 20);
        }
        remaining = interval + getValueByPercentage(minimum, interval);
        if ((0.365 * interval) >= remaining) {
          minimum -= interval;
        }
        if (getValueByPercentage(minimum, interval) < 0) {
          minimum =
              (minimum - interval) - getValueByPercentage(minimum, interval);
        }
      } else {
        minimum = start < ((5.0 / 6.0) * end) ? 0 : (start - (end - start) / 2);
        if (minimum % interval > 0) {
          minimum -= minimum % interval;
        }
      }
      maximum = (end > 0)
          ? (end + (end - startValue) / 20)
          : (end - (end - startValue) / 20);
      remaining = interval - (maximum % interval);
      if ((0.365 * interval) >= remaining) {
        maximum += interval;
      }
      if (maximum % interval > 0) {
        maximum = end > 0
            ? (maximum + interval) - (maximum % interval)
            : (maximum + interval) + (maximum % interval);
      }
    }
    if (minimum == 0) {
      interval = (axisRenderer is NumericAxisRenderer)
          ? calculateNumericNiceInterval(
              axisRenderer, maximum - minimum, axisSize)
          : axisRenderer.calculateInterval(
              VisibleRange(minimum, maximum), axisSize)!;
      maximum = (maximum / interval).ceil() * interval;
    }

    /// Update the visible range to the axis.
    _updateActualRange(axisRenderer, minimum, maximum, interval);
  }

  /// To trigger the render label event
  void triggerLabelRenderEvent(String labelText, num labelValue,
      [DateTimeIntervalType? currentDateTimeIntervalType,
      String? currentDateFormat]) {
    TextStyle fontStyle = chartThemeData.axisLabelTextStyle!.copyWith();
    final String actualText = labelText;
    String renderText = actualText;
    String? eventActualText;
    final AxisLabelRenderDetails axisLabelDetails = AxisLabelRenderDetails(
        labelValue,
        actualText,
        fontStyle,
        axis,
        currentDateTimeIntervalType,
        currentDateFormat);
    if (axis.axisLabelFormatter != null) {
      final ChartAxisLabel axisLabel =
          axis.axisLabelFormatter!(axisLabelDetails);
      fontStyle = fontStyle.merge(axisLabel.textStyle);
      renderText = axisLabel.text;
      eventActualText = axisLabel.text;
    }
    Size textSize = measureText(renderText, fontStyle, 0);
    if (axis.maximumLabelWidth != null || axis.labelsExtent != null) {
      if (axis.maximumLabelWidth != null) {
        assert(axis.maximumLabelWidth! >= 0,
            'maximumLabelWidth must not be negative');
      }
      if (axis.labelsExtent != null) {
        assert(axis.labelsExtent! >= 0, 'labelsExtent must not be negative');
      }
      if ((axis.maximumLabelWidth != null &&
              textSize.width > axis.maximumLabelWidth!) ||
          (axis.labelsExtent != null && textSize.width > axis.labelsExtent!)) {
        labelText = getTrimmedText(renderText,
            (axis.labelsExtent ?? axis.maximumLabelWidth)!, fontStyle,
            axisRenderer: axisRenderer,
            isRtl: axisRenderer
                ._axisRendererDetails.stateProperties.renderingDetails.isRtl);
      }
      textSize = measureText(labelText, fontStyle, 0);
    }
    final String? trimmedText =
        labelText.contains('...') || labelText.isEmpty ? labelText : null;
    renderText = trimmedText ?? renderText;
    final Size labelSize =
        measureText(renderText, fontStyle, axis.labelRotation);
    visibleLabels.add(AxisLabel(fontStyle, labelSize,
        eventActualText ?? actualText, labelValue, trimmedText, renderText));
  }

  /// Calculate the maximum label's size.
  void calculateMaximumLabelSize(ChartAxisRenderer axisRenderer,
      CartesianStateProperties stateProperties) {
    AxisLabelIntersectAction action;
    AxisLabel label;
    double maximumLabelHeight = 0.0,
        maximumLabelWidth = 0.0,
        labelMaximumWidth,
        pointX;
    action = axis.labelIntersectAction;
    labelMaximumWidth =
        stateProperties.chartAxis.axisClipRect.width / visibleLabels.length;
    if (orientation == AxisOrientation.horizontal &&
        axis.labelIntersectAction != AxisLabelIntersectAction.none &&
        visibleLabels.length > 1) {
      final Rect axisBounds = stateProperties.chartAxis.axisClipRect;
      AxisLabel label1;
      num pointX1;
      for (int i = 0; i < visibleLabels.length - 1; i++) {
        label = visibleLabels[i];
        pointX = (valueToCoefficient(
                    label.value, axisRenderer._axisRendererDetails) *
                axisBounds.width) +
            axisBounds.left;
        pointX -= label.labelSize.width / 2;
        pointX = (i == 0 &&
                axis.edgeLabelPlacement == EdgeLabelPlacement.shift &&
                ((pointX < axisBounds.left && !axis.isInversed) ||
                    (pointX + label.labelSize.width > axisBounds.right &&
                        axis.isInversed)))
            ? (axis.isInversed
                ? axisBounds.left + axisBounds.width - label.labelSize.width
                : axisBounds.left)
            : ((i == visibleLabels.length - 1 &&
                    axis.edgeLabelPlacement == EdgeLabelPlacement.shift &&
                    ((((pointX + label.labelSize.width) > axisBounds.right) &&
                            !axis.isInversed) ||
                        (pointX < axisBounds.left && axis.isInversed)))
                ? (axis.isInversed
                    ? axisBounds.left
                    : axisBounds.left +
                        axisBounds.width -
                        label.labelSize.width)
                : pointX);

        label1 = visibleLabels[i + 1];
        pointX1 = (valueToCoefficient(
                    label1.value, axisRenderer._axisRendererDetails) *
                stateProperties.chartAxis.axisClipRect.width) +
            stateProperties.chartAxis.axisClipRect.left;
        pointX1 -= label1.labelSize.width / 2;
        if ((((pointX + label.labelSize.width) > pointX1) &&
                !axis.isInversed) ||
            (((pointX - label.labelSize.width) < pointX1) && axis.isInversed)) {
          isCollide = true;
          break;
        }
      }
    }

    for (int i = 0; i < visibleLabels.length; i++) {
      label = visibleLabels[i];
      if (label.labelSize.width > maximumLabelWidth) {
        maximumLabelWidth = label.labelSize.width;
      }
      if (label.labelSize.height > maximumLabelHeight) {
        maximumLabelHeight = label.labelSize.height;
      }

      if (orientation == AxisOrientation.horizontal) {
        pointX = (valueToCoefficient(
                    label.value, axisRenderer._axisRendererDetails) *
                stateProperties.chartAxis.axisClipRect.width) +
            stateProperties.chartAxis.axisClipRect.left;
        pointX -= label.labelSize.width / 2;

        /// Based on below options, perform label intersection
        if (isCollide) {
          final List<double> list = _performLabelIntersectAction(
              label,
              action,
              maximumLabelWidth,
              maximumLabelHeight,
              labelMaximumWidth,
              pointX,
              i,
              axisRenderer,
              chart);
          maximumLabelWidth = list[0];
          maximumLabelHeight = list[1];
        }
      }
    }
    maximumLabelSize = Size(maximumLabelWidth, maximumLabelHeight);
  }

  /// Return the height and width values of labelIntersectAction
  List<double> _performLabelIntersectAction(
      AxisLabel label,
      AxisLabelIntersectAction action,
      double maximumLabelWidth,
      double maximumLabelHeight,
      double labelMaximumWidth,
      num pointX,
      int i,
      ChartAxisRenderer axisRenderer,
      SfCartesianChart chart) {
    double height;
    int angle = labelRotation;
    Size currentLabelSize;
    switch (action) {
      case AxisLabelIntersectAction.multipleRows:
        if (i > 0) {
          height = _findMultiRows(i, pointX, label, axisRenderer, chart);
          if (height > maximumLabelHeight) {
            maximumLabelHeight = height;
          }
        }
        break;
      case AxisLabelIntersectAction.rotate45:
      case AxisLabelIntersectAction.rotate90:
        angle = action == AxisLabelIntersectAction.rotate45 ? -45 : -90;
        labelRotation = angle;
        currentLabelSize = measureText(
            label.renderText!, chartThemeData.axisLabelTextStyle!, angle);
        if (currentLabelSize.height > maximumLabelHeight) {
          maximumLabelHeight = currentLabelSize.height;
        }
        if (currentLabelSize.width > maximumLabelWidth) {
          maximumLabelWidth = currentLabelSize.width;
        }
        break;
      case AxisLabelIntersectAction.wrap:
      case AxisLabelIntersectAction.trim:
        label._labelCollection = _gettingLabelCollection(
            label.renderText!, labelMaximumWidth, axisRenderer, action);
        if (label._labelCollection!.isNotEmpty) {
          label.renderText = label._labelCollection![0];
        }
        height = label.labelSize.height * label._labelCollection!.length;
        if (height > maximumLabelHeight) {
          maximumLabelHeight = height;
        }
        break;
      // ignore: no_default_cases
      default:
        break;
    }
    return <double>[maximumLabelWidth, maximumLabelHeight];
  }

  void _calculateRange(ChartAxisRenderer axisRenderer) {
    min = null;
    max = null;
    CartesianSeriesRenderer seriesRenderer;
    double paddingInterval = 0;
    ChartAxisRendererDetails xAxisDetails, yAxisDetails;
    num? minimumX, maximumX, minimumY, maximumY;
    String seriesType;
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    for (int i = 0; i < seriesRenderers.length; i++) {
      seriesRenderer = seriesRenderers[i];
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderer);
      minimumX = seriesRendererDetails.minimumX;
      maximumX = seriesRendererDetails.maximumX;
      minimumY = seriesRendererDetails.minimumY;
      maximumY = seriesRendererDetails.maximumY;
      seriesType = seriesRendererDetails.seriesType;
      if (seriesRendererDetails.visible! == true &&
          minimumX != null &&
          maximumX != null &&
          minimumY != null &&
          maximumY != null) {
        paddingInterval = 0;
        xAxisDetails = seriesRendererDetails.xAxisDetails!;
        yAxisDetails = seriesRendererDetails.yAxisDetails!;
        if (((xAxisDetails is DateTimeAxisDetails ||
                    xAxisDetails is NumericAxisDetails) &&
                xAxisDetails.axis.rangePadding == ChartRangePadding.auto) &&
            (seriesType.contains('column') ||
                (seriesType.contains('bar') &&
                    seriesType.contains('errorbar') == false) ||
                seriesType == 'histogram')) {
          seriesRendererDetails.minDelta = seriesRendererDetails.minDelta ??
              calculateMinPointsDelta(
                  xAxisDetails.axisRenderer, seriesRenderers, stateProperties);
          paddingInterval = seriesRendererDetails.minDelta! / 2;
        }
        if (((stateProperties.requireInvertedAxis
                    ? yAxisDetails
                    : xAxisDetails) ==
                axisDetails) &&
            orientation == AxisOrientation.horizontal) {
          stateProperties.requireInvertedAxis
              ? findMinMax(minimumY, maximumY)
              : findMinMax(
                  minimumX - paddingInterval, maximumX + paddingInterval);
        }

        if (((stateProperties.requireInvertedAxis
                    ? xAxisDetails
                    : yAxisDetails) ==
                axisDetails) &&
            orientation == AxisOrientation.vertical) {
          stateProperties.requireInvertedAxis
              ? findMinMax(
                  minimumX - paddingInterval, maximumX + paddingInterval)
              : findMinMax(minimumY, maximumY);
        }
      }
    }
  }

  /// Find min and max values
  void findMinMax(num minVal, num maxVal) {
    if (min == null || min! > minVal) {
      min = minVal;
    }
    if (max == null || max! < maxVal) {
      max = maxVal;
    }
  }

  /// Calculate the interval based min and max values in axis
  num calculateNumericNiceInterval(
      ChartAxisRenderer axisRenderer, num delta, Size size) {
    final List<num> intervalDivisions = <num>[10, 5, 2, 1];
    num niceInterval;

    /// Get the desired interval if desired interval not specified
    final num actualDesiredIntervalCount =
        calculateDesiredIntervalCount(size, axisRenderer);
    niceInterval = delta / actualDesiredIntervalCount;
    if (axisRenderer._axisRendererDetails.axis.desiredIntervals != null) {
      return niceInterval;
    }

    /// Get the minimum interval
    final num minimumInterval = niceInterval == 0
        ? 0
        : math.pow(10, calculateLogBaseValue(niceInterval, 10).floor());
    for (int i = 0; i < intervalDivisions.length; i++) {
      final num interval = intervalDivisions[i];
      final num currentInterval = minimumInterval * interval;
      if (actualDesiredIntervalCount < (delta / currentInterval)) {
        break;
      }
      niceInterval = currentInterval;
    }
    return niceInterval;
  }

  /// Calculate the axis interval for numeric axis
  num calculateDesiredIntervalCount(
      Size availableSize, ChartAxisRenderer axisRenderer) {
    final num size = axisRenderer._axisRendererDetails.orientation ==
            AxisOrientation.horizontal
        ? availableSize.width
        : availableSize.height;
    if (axisRenderer._axisRendererDetails.axis.desiredIntervals == null) {
      num desiredIntervalCount =
          (axisRenderer._axisRendererDetails.orientation ==
                      AxisOrientation.horizontal
                  ? 0.533
                  : 1) *
              axisRenderer._axisRendererDetails.axis.maximumLabels;
      desiredIntervalCount = math.max(size * (desiredIntervalCount / 100), 1);
      return desiredIntervalCount;
    } else {
      return axisRenderer._axisRendererDetails.axis.desiredIntervals!;
    }
  }

  /// Get the range padding of an axis
  ChartRangePadding calculateRangePadding(
      ChartAxisRenderer axisRenderer, SfCartesianChart chart) {
    final ChartAxis axis = axisRenderer._axisRendererDetails.axis;
    ChartRangePadding padding = ChartRangePadding.auto;
    if (axis.rangePadding != ChartRangePadding.auto) {
      padding = axis.rangePadding;
    } else if (axis.rangePadding == ChartRangePadding.auto &&
        axisRenderer._axisRendererDetails.orientation != null) {
      switch (axisRenderer._axisRendererDetails.orientation!) {
        case AxisOrientation.horizontal:
          padding = stateProperties.requireInvertedAxis
              ? (isStack100
                  ? ChartRangePadding.round
                  : ChartRangePadding.normal)
              : ChartRangePadding.none;
          break;
        case AxisOrientation.vertical:
          padding = !stateProperties.requireInvertedAxis
              ? (isStack100
                  ? ChartRangePadding.round
                  : ChartRangePadding.normal)
              : ChartRangePadding.none;
          break;
      }
    }
    return padding;
  }

  /// Applying range padding
  void applyRangePaddings(
      ChartAxisRenderer axisRenderer,
      CartesianStateProperties stateProperties,
      VisibleRange range,
      num interval) {
    final num start = range.minimum;
    final num end = range.maximum;
    final ChartRangePadding padding =
        calculateRangePadding(axisRenderer, chart);
    if (padding == ChartRangePadding.additional ||
        padding == ChartRangePadding.round) {
      /// Get the additional range
      _findAdditionalRange(axisRenderer, start, end, interval);
    } else if (padding == ChartRangePadding.normal) {
      /// Get the normal range
      _findNormalRange(axisRenderer, start, end, interval);
    } else {
      _updateActualRange(axisRenderer, start, end, interval);
    }
    range.delta = range.maximum - range.minimum;
  }

  /// Dispose the objects.
  void dispose() {
    visibleLabels.clear();
    seriesRenderers.clear();
  }
}

// ignore: avoid_classes_with_only_static_members
/// Represents the helper class used to get the private fields from the chart axis renderer
class AxisHelper {
  /// Methods to get the axis renderer details of axis renderer
  static ChartAxisRendererDetails getAxisRendererDetails(
      ChartAxisRenderer axisRenderer) {
    return axisRenderer._axisRendererDetails;
  }

  /// Method to get the axis label region value
  static Rect? getLabelRegion(AxisLabel label) {
    return label._labelRegion;
  }

  /// Methods to set the axis renderer details of axis renderer
  static void setAxisRendererDetails(
      ChartAxisRenderer renderer, ChartAxisRendererDetails rendererDetails) {
    renderer._axisRendererDetails = rendererDetails;
  }
}
