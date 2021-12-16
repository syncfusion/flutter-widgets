import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/src/chart/common/cartesian_state_properties.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../chart/chart_behavior/selection_behavior.dart';
import '../../chart/chart_segment/chart_segment.dart';
import '../../chart/chart_series/series.dart';
import '../../chart/chart_series/series_renderer_properties.dart';
import '../../chart/user_interaction/selection_renderer.dart';
import '../../chart/utils/helper.dart';
import '../../circular_chart/renderer/common.dart';

///Provides options for the selection of series or data points.
///
///By using this class, The color and width of the selected and unselected series or data points can be customized.
class SelectionBehavior {
  /// Creating an argument constructor of SelectionBehaviorclass.
  SelectionBehavior(
      {bool? enable,
      this.selectedColor,
      this.selectedBorderColor,
      this.selectedBorderWidth,
      this.unselectedColor,
      this.unselectedBorderColor,
      this.unselectedBorderWidth,
      double? selectedOpacity,
      double? unselectedOpacity,
      this.selectionController,
      bool? toggleSelection})
      : enable = enable ?? false,
        selectedOpacity = selectedOpacity ?? 1.0,
        unselectedOpacity = unselectedOpacity ?? 0.5,
        toggleSelection = toggleSelection ?? true;

  ///Enables or disables the selection.
  ///
  ///By enabling this, each data point or series in the chart can be selected.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    enable: true
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool enable;

  ///Color of the selected data points or series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    selectedColor: Colors.red
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color? selectedColor;

  ///Border color of the selected data points or series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    selectedBorderColor: Colors.red,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color? selectedBorderColor;

  ///Border width of the selected data points or series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    selectedColor: Colors.red,
  ///                    selectedBorderWidth: 2
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double? selectedBorderWidth;

  ///Color of the unselected data points or series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    unselectedColor: Colors.grey,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color? unselectedColor;

  ///Border color of the unselected data points or series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    unselectedBorderColor: Colors.grey,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color? unselectedBorderColor;

  ///Border width of the unselected data points or series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    unselectedBorderWidth: 2
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double? unselectedBorderWidth;

  ///Opacity of the selected series or data point.
  ///
  ///Default to `1.0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    selectedOpacity: 0.5,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double selectedOpacity;

  ///Opacity of the unselected series or data point.
  ///
  ///Defaults to `0.5`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    unselectedOpacity: 0.4,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///``
  final double unselectedOpacity;

  /// Controller used to set the maximum and minimum values for the chart.By providing the selection controller, the maximum and
  ///The minimum range of selected series or points can be customized
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionBehavior: SelectionBehavior(
  ///                selectionController:  controller,
  ///               ),
  ///        ));
  ///}
  ///```
  final RangeController? selectionController;

  ///Decides whether to deselect the selected item or not.
  ///
  ///Provides an option to decide, whether to deselect the selected data point/series
  /// or remain selected, when interacted with it again.
  ///
  ///If set to true, deselection will be performed else the point will not get deselected.
  /// This works even while calling public methods, in various selection modes, with
  /// multi-selection, and also on dynamic changes.
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    enable: true,
  ///                    toggleSelection: false,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool toggleSelection;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SelectionBehavior &&
        other.enable == enable &&
        other.selectedColor == selectedColor &&
        other.selectedBorderColor == selectedBorderColor &&
        other.selectedBorderWidth == selectedBorderWidth &&
        other.unselectedColor == unselectedColor &&
        other.unselectedBorderColor == unselectedBorderColor &&
        other.unselectedBorderWidth == unselectedBorderWidth &&
        other.selectedOpacity == selectedOpacity &&
        other.unselectedOpacity == unselectedOpacity &&
        other.selectionController == selectionController;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      enable,
      selectedColor,
      selectedBorderColor,
      selectedBorderWidth,
      unselectedColor,
      unselectedBorderColor,
      unselectedBorderWidth,
      selectedOpacity,
      unselectedOpacity,
      selectionController
    ];
    return hashList(values);
  }

  /// Specifies the value of selection behavior renderer
  SelectionBehaviorRenderer? _selectionBehaviorRenderer;

  ////Selects or deselects the specified data point in the series.
  ///
  ///The following are the arguments to be passed.
  ///* `pointIndex` - index of the data point that needs to be selected.
  ///* `seriesIndex` - index of the series in which the data point is selected.
  ///
  ///Where the `pointIndex` is a required argument and `seriesIndex` is an optional argument. By default, 0 will
  /// be considered as the series index. Thus it will take effect on the first series if no value is specified.
  ///
  ///For Circular, Pyramid and Funnel charts, seriesIndex should always be 0, as it has only one series.
  ///
  ///If the specified data point is already selected, it will be deselected, else it will be selected.
  /// Selection type and multi-selection functionality is also applicable for this, but it is based on
  /// the API values specified in [ChartSelectionBehavior].
  ///
  ///_Note:_ Even though, the [enable] property in [ChartSelectionBehavior] is set to false, this method
  /// will work.
  /// ```dart
  /// Widget build(BuildContext context) {
  /// selection = SelectionBehavior(enable: true);
  /// chart = SfCartesianChart(series:getChartData);
  ///   return Scaffold(
  ///      child: Column(
  ///        children: <Widget>[
  ///       FlatButton(
  ///            child: Text('Select'),
  ///            onPressed: select),
  ///          Container(child: chart)
  ///        ]));
  ///}
  ///  void select() {
  ///     selection.selectionIndex(1, 0);
  ///}
  ///```dart

  void selectDataPoints(int pointIndex, [int seriesIndex = 0]) {
    if (_selectionBehaviorRenderer != null) {
      final dynamic seriesRenderer = _selectionBehaviorRenderer!
          ._selectionDetails
          .stateProperties
          .chartSeries
          .visibleSeriesRenderers[seriesIndex];
      assert(
          seriesRenderer is CartesianSeriesRenderer == false ||
              getVisibleDataPointIndex(pointIndex,
                      SeriesHelper.getSeriesRendererDetails(seriesRenderer)) !=
                  null,
          'Provided point index is not in the visible range. Provide point index which is in the visible range.');
      _selectionBehaviorRenderer = seriesRenderer is CartesianSeriesRenderer
          ? SeriesHelper.getSeriesRendererDetails(seriesRenderer)
              .selectionBehaviorRenderer
          : _selectionBehaviorRenderer;
      _selectionBehaviorRenderer!._selectionDetails.selectionRenderer
          ?.selectDataPoints(pointIndex, seriesIndex);
    }
  }

  /// provides the list of selected point indices for given series.
  List<int> getSelectedDataPoints(CartesianSeries<dynamic, dynamic> _series) {
    List<ChartSegment> selectedItems = <ChartSegment>[];
    final dynamic seriesRenderer = _selectionBehaviorRenderer!._selectionDetails
        .stateProperties.chartSeries.visibleSeriesRenderers[0];
    SelectionBehaviorRenderer _selectionRenderer;
    if (seriesRenderer is CartesianSeriesRenderer) {
      _selectionRenderer = SeriesHelper.getSeriesRendererDetails(seriesRenderer)
          .selectionBehaviorRenderer!;
    } else {
      _selectionRenderer = seriesRenderer.selectionBehaviorRenderer;
    }

    final List<int> selectedPoints = <int>[];
    selectedItems = _selectionRenderer
        ._selectionDetails.selectionRenderer!.selectedSegments;
    for (int i = 0; i < selectedItems.length; i++) {
      selectedPoints.add(selectedItems[i].currentSegmentIndex!);
    }
    return selectedPoints;
  }
}

/// Selection renderer class for mutable fields and methods
class SelectionBehaviorRenderer with ChartSelectionBehavior {
  /// Creates an argument constructor for SelectionSettings renderer class
  SelectionBehaviorRenderer(SelectionBehavior selectionBehavior, dynamic chart,
      dynamic stateProperties) {
    _selectionDetails =
        SelectionDetails(selectionBehavior, chart, stateProperties, this);
  }

  /// Holds the selection details instance for the chart
  late SelectionDetails _selectionDetails;

  /// Specifies the index of the data point that needs to be selected initially while
  /// rendering a chart.
  /// ignore: unused_element
  void _selectedDataPointIndex(
          CartesianSeriesRenderer seriesRenderer, List<int> selectedData) =>
      _selectionDetails.selectionRenderer
          ?.selectedDataPointIndex(seriesRenderer, selectedData);

  /// Gets the selected item color of a Cartesian series.
  @override
  Paint getSelectedItemFill(Paint paint, int seriesIndex, int pointIndex,
          List<ChartSegment> selectedSegments) =>
      paint;

  /// Gets the unselected item color of a Cartesian series.
  @override
  Paint getUnselectedItemFill(Paint paint, int seriesIndex, int pointIndex,
          List<ChartSegment> unselectedSegments) =>
      paint;

  /// Gets the selected item border color of a Cartesian series.
  @override
  Paint getSelectedItemBorder(Paint paint, int seriesIndex, int pointIndex,
          List<ChartSegment> selectedSegments) =>
      paint;

  /// Gets the unselected item border color of a Cartesian series.
  @override
  Paint getUnselectedItemBorder(Paint paint, int seriesIndex, int pointIndex,
          List<ChartSegment> unselectedSegments) =>
      paint;

  /// Gets the selected item color of a circular series.
  @override
  Color getCircularSelectedItemFill(Color color, int seriesIndex,
          int pointIndex, List<Region> selectedRegions) =>
      color;

  /// Gets the unselected item color of a circular series.
  @override
  Color getCircularUnSelectedItemFill(Color color, int seriesIndex,
          int pointIndex, List<Region> unselectedRegions) =>
      color;

  /// Gets the selected item border color of a circular series.
  @override
  Color getCircularSelectedItemBorder(Color color, int seriesIndex,
          int pointIndex, List<Region> selectedRegions) =>
      color;

  /// Gets the unselected item border color of a circular series.
  @override
  Color getCircularUnSelectedItemBorder(Color color, int seriesIndex,
          int pointIndex, List<Region> unselectedRegions) =>
      color;

  /// Performs the double-tap action on the chart.
  @override
  void onDoubleTap(double xPos, double yPos) =>
      _selectionDetails.selectionRenderer?.performSelection(Offset(xPos, yPos));

  /// Performs the long press action on the chart.
  @override
  void onLongPress(double xPos, double yPos) =>
      _selectionDetails.selectionRenderer?.performSelection(Offset(xPos, yPos));

  /// Performs the touch-down action on the chart.
  @override
  void onTouchDown(double xPos, double yPos) =>
      _selectionDetails.selectionRenderer?.performSelection(Offset(xPos, yPos));
}

/// Holds the properties of the selection behavior renderer
class SelectionDetails {
  /// Argument constructor for SelectionDetails class
  SelectionDetails(this.selectionBehavior, this.chart, this.stateProperties,
      this.selectionBehaviorRenderer);

  /// Specifies the chart instance
  final dynamic chart;

  /// Holds the state properties value
  final dynamic stateProperties;

  /// Holds the value of selection behavior
  // ignore: deprecated_member_use_from_same_package
  final dynamic selectionBehavior;

  /// Holds the selection renderer value
  SelectionRenderer? selectionRenderer;

  /// Holds the selection behavior renderer instance
  final SelectionBehaviorRenderer selectionBehaviorRenderer;

  /// Method to select the range
  void selectRange() {
    bool isSelect = false;
    final SeriesRendererDetails seriesRendererDetails =
        selectionRenderer!.seriesRendererDetails;
    final CartesianStateProperties stateProperties =
        selectionRenderer!.stateProperties;
    if (selectionBehavior.enable == true &&
        selectionBehavior.selectionController != null) {
      selectionBehavior.selectionController.addListener(() {
        stateProperties.isRangeSelectionSlider = true;
        selectionRenderer!.selectedSegments.clear();
        selectionRenderer!.unselectedSegments?.clear();
        final dynamic start = selectionBehavior.selectionController.start;
        final dynamic end = selectionBehavior.selectionController.end;
        for (int i = 0; i < seriesRendererDetails.dataPoints.length; i++) {
          final num xValue = seriesRendererDetails.dataPoints[i].xValue;
          isSelect = start is DateTime
              ? (xValue >= start.millisecondsSinceEpoch &&
                  xValue <= end.millisecondsSinceEpoch)
              : (xValue >= start && xValue <= end);

          isSelect
              ? selectionRenderer!.selectedSegments
                  .add(seriesRendererDetails.segments[i])
              : selectionRenderer!.unselectedSegments
                  ?.add(seriesRendererDetails.segments[i]);
        }
        selectionRenderer!
            .selectedSegmentsColors(selectionRenderer!.selectedSegments);
        selectionRenderer!
            .unselectedSegmentsColors(selectionRenderer!.unselectedSegments!);

        for (final CartesianSeriesRenderer _seriesRenderer
            in stateProperties.chartSeries.visibleSeriesRenderers) {
          ValueNotifier<int>(
              SeriesHelper.getSeriesRendererDetails(_seriesRenderer)
                  .repaintNotifier
                  .value++);
        }
      });
    }
    if (stateProperties.renderingDetails.initialRender! == true) {
      stateProperties.isRangeSelectionSlider = false;
    }
    selectionRenderer!.stateProperties = stateProperties;
  }
}

// ignore: avoid_classes_with_only_static_members
/// Helper class to get the selection details instance from its renderer.
class SelectionHelper {
  /// Returns the selection details instance from its renderer
  static SelectionDetails getRenderingDetails(
      SelectionBehaviorRenderer renderer) {
    return renderer._selectionDetails;
  }

  /// Method to set the selection behavior renderer
  static void setSelectionBehaviorRenderer(SelectionBehavior selectionBehavior,
      SelectionBehaviorRenderer selectionBehaviorRenderer) {
    selectionBehavior._selectionBehaviorRenderer = selectionBehaviorRenderer;
  }
}
