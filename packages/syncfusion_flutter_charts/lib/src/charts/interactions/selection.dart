import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../base.dart';
import '../series/chart_series.dart';
import 'behavior.dart';

/// Provides options for the selection of series or data points.
///
/// By using this class, The color and width of the selected and unselected
/// series or data points can be customized.
class SelectionBehavior extends ChartBehavior {
  /// Creating an argument constructor of [SelectionBehavior] class.
  SelectionBehavior({
    this.enable = false,
    this.selectedColor,
    this.selectedBorderColor,
    this.selectedBorderWidth,
    this.unselectedColor,
    this.unselectedBorderColor,
    this.unselectedBorderWidth,
    this.selectedOpacity = 1.0,
    this.unselectedOpacity = 0.5,
    this.selectionController,
    this.toggleSelection = true,
  });

  /// Enables or disables the selection.
  ///
  /// By enabling this, each data point or series in the chart can be selected.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: selectionBehavior
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool enable;

  /// Color of the selected data points or series.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true,
  ///     selectedColor: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: selectionBehavior
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? selectedColor;

  /// Border color of the selected data points or series.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true,
  ///     selectedBorderWidth: 4,
  ///     selectedBorderColor: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: selectionBehavior
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? selectedBorderColor;

  /// Border width of the selected data points or series.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true,
  ///     selectedBorderWidth: 4,
  ///     selectedBorderColor: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: selectionBehavior
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? selectedBorderWidth;

  /// Color of the unselected data points or series.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true,
  ///     unselectedColor: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: selectionBehavior
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? unselectedColor;

  /// Border color of the unselected data points or series.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true,
  ///     unselectedBorderWidth: 4,
  ///     unselectedBorderColor: Colors.grey
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: selectionBehavior
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? unselectedBorderColor;

  /// Border width of the unselected data points or series.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true,
  ///     unselectedBorderWidth: 4,
  ///     unselectedBorderColor: Colors.grey
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: selectionBehavior
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? unselectedBorderWidth;

  /// Opacity of the selected series or data point.
  ///
  /// Default to `1.0`.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true,
  ///     selectedOpacity: 0.5
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: selectionBehavior
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double selectedOpacity;

  /// Opacity of the unselected series or data point.
  ///
  /// Defaults to `0.5`.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true,
  ///     unselectedOpacity: 0.4
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: selectionBehavior
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double unselectedOpacity;

  /// Controller used to set the maximum and minimum values for the chart.
  /// By providing the selection controller, the maximum and
  /// The minimum range of selected series or points can be customized.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final RangeController rangeController= RangeController(
  ///     start: 1.0,
  ///     end: 4.0
  ///   )
  ///   return SfRangeSelector (
  ///     min: 1.0,
  ///     max: 4.0,
  ///     controller: rangeController,
  ///     child: SfCartesianChart(
  ///       series: <ColumnSeries<SalesData, num>>[
  ///         ColumnSeries<SalesData, num>(
  ///           dataSource: chartData,
  ///           xValueMapper: (SalesData sales, _) => sales.x,
  ///           yValueMapper: (SalesData sales, _) => sales.y,
  ///           selectionController: rangeController
  ///         ),
  ///       ],
  ///     )
  ///   );
  /// }
  /// final List<SalesData> chartData = <SalesData>[
  ///   SalesData(1, 23),
  ///   SalesData(2, 35),
  ///   SalesData(3, 19),
  ///   SalesData(4, 29),
  ///   SalesData(5, 50),
  ///   SalesData(6, 77)
  /// ];
  ///
  /// class SalesData {
  ///   SalesData(this.x, this.y);
  ///     final double x;
  ///     final double y;
  /// }
  /// ```
  final RangeController? selectionController;

  /// Decides whether to deselect the selected item or not.
  ///
  /// Provides an option to decide, whether to deselect the selected data point/series
  /// or remain selected, when interacted with it again.
  ///
  /// If set to true, deselection will be performed else the point will not get
  /// deselected. This works even while calling public methods, in various
  /// selection modes, with multi-selection, and also on dynamic changes.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true,
  ///     toggleSelection: false
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         selectionBehavior: selectionBehavior
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool toggleSelection;

  /// Selects or deselects the specified data point in the series.
  ///
  /// The following are the arguments to be passed.
  /// * `pointIndex` - index of the data point that needs to be selected.
  /// * `seriesIndex` - index of the series in which the data point is selected.
  ///
  /// Where the `pointIndex` is a required argument and `seriesIndex` is an
  /// optional argument. By default, 0 will be considered as the series index.
  /// Thus it will take effect on the first series if no value is specified.
  ///
  /// For circular, pyramid and funnel charts, series index should always be 0,
  /// as it has only one series.
  ///
  /// If the specified data point is already selected, it will be deselected,
  /// else it will be selected. Selection type and multi-selection functionality
  /// is also applicable for this, but it is based on
  /// the API values specified in [ChartSelectionBehavior].
  ///
  /// _Note:_ Even though, the [enable] property in [ChartSelectionBehavior] is
  /// set to false, this method will work.
  ///
  /// ```dart
  /// late SelectionBehavior selectionBehavior;
  ///
  /// void initState() {
  ///   selectionBehavior = SelectionBehavior(
  ///     enable: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return Column(
  ///     children: [
  ///       TextButton(
  ///         onPressed: () {
  ///           setState(() {
  ///             select();
  ///           });
  ///         },
  ///         child: Text('Select data points')
  ///       ),
  ///       SfCartesianChart(
  ///         series: <BarSeries<SalesData, num>>[
  ///           BarSeries<SalesData, num>(
  ///             selectionBehavior: selectionBehavior
  ///           )
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  ///
  /// void select() {
  ///   selectionBehavior.selectDataPoints(3);
  /// }
  /// ```
  void selectDataPoints(int pointIndex, [int seriesIndex = 0]) {
    RenderChartPlotArea? plotArea;
    if (parentBox is RenderChartPlotArea) {
      plotArea = parentBox as RenderChartPlotArea;
    } else if (parentBox is RenderBehaviorArea) {
      final RenderBehaviorArea behaviorArea = parentBox as RenderBehaviorArea;
      plotArea = behaviorArea.plotArea;
    }

    if (plotArea == null) {
      return;
    }

    ChartSeriesRenderer? seriesRenderer;
    RenderBox? child = plotArea.firstChild;
    while (child != null) {
      final ContainerParentDataMixin<RenderBox> childParentData =
          child.parentData! as ContainerParentDataMixin<RenderBox>;
      if (child is ChartSeriesRenderer && child.index == seriesIndex) {
        seriesRenderer = child;
        break;
      }
      child = childParentData.nextSibling;
    }

    if (seriesRenderer != null &&
        seriesRenderer.selectionBehavior != null &&
        seriesRenderer.selectionBehavior!.enable) {
      plotArea.selectionController.updateSelection(
        seriesRenderer,
        seriesIndex,
        pointIndex,
        seriesRenderer.selectionBehavior!.toggleSelection,
        selectionType: plotArea.selectionMode,
      );
    }
  }

  /// Provides the list of selected point indices for given series.
  List<int> getSelectedDataPoints(CartesianSeries series) {
    RenderChartPlotArea? plotArea;
    if (parentBox is RenderChartPlotArea) {
      plotArea = parentBox as RenderChartPlotArea;
    } else if (parentBox is RenderBehaviorArea) {
      final RenderBehaviorArea behaviorArea = parentBox as RenderBehaviorArea;
      plotArea = behaviorArea.plotArea;
    }

    if (plotArea == null) {
      return <int>[];
    }

    int seriesIndex = -1;
    RenderBox? child = plotArea.firstChild;
    while (child != null) {
      final ContainerParentDataMixin<RenderBox> childParentData =
          child.parentData! as ContainerParentDataMixin<RenderBox>;
      if (child is ChartSeriesRenderer && child.widget == series) {
        seriesIndex = child.index;
        break;
      }
      child = childParentData.nextSibling;
    }

    if (seriesIndex != -1) {
      final Map<int, List<int>> selectedDataPoints =
          plotArea.selectionController.selectedDataPoints;
      if (selectedDataPoints.containsKey(seriesIndex)) {
        return plotArea.selectionController.selectedDataPoints[seriesIndex]!;
      }
    }

    return <int>[];
  }

  SelectionBehavior copyWith({
    bool? enable,
    Color? selectedColor,
    Color? unselectedColor,
    Color? selectedBorderColor,
    Color? unselectedBorderColor,
    double? selectedBorderWidth,
    double? unselectedBorderWidth,
    double? selectedOpacity,
    double? unselectedOpacity,
    bool? toggleSelection,
  }) {
    return SelectionBehavior(
      enable: enable ?? this.enable,
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
      unselectedBorderColor:
          unselectedBorderColor ?? this.unselectedBorderColor,
      selectedBorderWidth: selectedBorderWidth ?? this.selectedBorderWidth,
      unselectedBorderWidth:
          unselectedBorderWidth ?? this.unselectedBorderWidth,
      selectedOpacity: selectedOpacity ?? this.selectedOpacity,
      unselectedOpacity: unselectedOpacity ?? this.unselectedOpacity,
      toggleSelection: toggleSelection ?? this.toggleSelection,
    );
  }
}
