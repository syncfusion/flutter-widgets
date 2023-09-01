import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import '../../common/event_args.dart';
import '../../common/utils/typedef.dart'
    show MultiLevelLabelFormatterCallback, ChartLabelFormatterCallback;
import '../axis/axis.dart';
import '../axis/multi_level_labels.dart';
import '../axis/plotband.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/interactive_tooltip.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// This class has the properties of the category axis.
///
/// Category axis displays text labels instead of numbers. When the string values are bound to x values, then the x-axis
/// must be initialized with CategoryAxis.
///
/// Provides the options for Label placement, arrange by index and interval used to customize the appearance.
@immutable
class CategoryAxis extends ChartAxis {
  /// Creating an argument constructor of CategoryAxis class.
  CategoryAxis(
      {String? name,
      bool? isVisible,
      AxisTitle? title,
      AxisLine? axisLine,
      this.arrangeByIndex = false,
      ChartRangePadding? rangePadding,
      this.labelPlacement = LabelPlacement.betweenTicks,
      EdgeLabelPlacement? edgeLabelPlacement,
      ChartDataLabelPosition? labelPosition,
      TickPosition? tickPosition,
      int? labelRotation,
      AxisLabelIntersectAction? labelIntersectAction,
      LabelAlignment? labelAlignment,
      bool? isInversed,
      bool? opposedPosition,
      int? minorTicksPerInterval,
      int? maximumLabels,
      MajorTickLines? majorTickLines,
      MinorTickLines? minorTickLines,
      MajorGridLines? majorGridLines,
      MinorGridLines? minorGridLines,
      TextStyle? labelStyle,
      double? plotOffset,
      double? zoomFactor,
      double? zoomPosition,
      InteractiveTooltip? interactiveTooltip,
      this.minimum,
      this.maximum,
      double? interval,
      this.visibleMinimum,
      this.visibleMaximum,
      dynamic crossesAt,
      String? associatedAxisName,
      bool? placeLabelsNearAxisLine,
      List<PlotBand>? plotBands,
      int? desiredIntervals,
      RangeController? rangeController,
      double? maximumLabelWidth,
      double? labelsExtent,
      int? autoScrollingDelta,
      double? borderWidth,
      Color? borderColor,
      AxisBorderType? axisBorderType,
      MultiLevelLabelFormatterCallback? multiLevelLabelFormatter,
      MultiLevelLabelStyle? multiLevelLabelStyle,
      List<CategoricalMultiLevelLabel>? multiLevelLabels,
      AutoScrollingMode? autoScrollingMode,
      ChartLabelFormatterCallback? axisLabelFormatter})
      : super(
            name: name,
            isVisible: isVisible,
            isInversed: isInversed,
            plotOffset: plotOffset,
            rangePadding: rangePadding,
            opposedPosition: opposedPosition,
            edgeLabelPlacement: edgeLabelPlacement,
            labelRotation: labelRotation,
            labelPosition: labelPosition,
            tickPosition: tickPosition,
            labelIntersectAction: labelIntersectAction,
            minorTicksPerInterval: minorTicksPerInterval,
            maximumLabels: maximumLabels,
            labelAlignment: labelAlignment,
            labelStyle: labelStyle,
            title: title,
            axisLine: axisLine,
            majorTickLines: majorTickLines,
            minorTickLines: minorTickLines,
            majorGridLines: majorGridLines,
            minorGridLines: minorGridLines,
            zoomFactor: zoomFactor,
            zoomPosition: zoomPosition,
            interactiveTooltip: interactiveTooltip,
            interval: interval,
            crossesAt: crossesAt,
            associatedAxisName: associatedAxisName,
            placeLabelsNearAxisLine: placeLabelsNearAxisLine,
            plotBands: plotBands,
            desiredIntervals: desiredIntervals,
            rangeController: rangeController,
            maximumLabelWidth: maximumLabelWidth,
            labelsExtent: labelsExtent,
            autoScrollingDelta: autoScrollingDelta,
            axisBorderType: axisBorderType,
            borderColor: borderColor,
            borderWidth: borderWidth,
            multiLevelLabelStyle: multiLevelLabelStyle,
            multiLevelLabels: multiLevelLabels,
            multiLevelLabelFormatter: multiLevelLabelFormatter,
            autoScrollingMode: autoScrollingMode,
            axisLabelFormatter: axisLabelFormatter);

  /// Position of the category axis labels.
  ///
  /// The labels can be placed either
  /// between the ticks or at the major ticks.
  ///
  /// Defaults to `LabelPlacement.betweenTicks`.
  ///
  /// Also refer [LabelPlacement].
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(labelPlacement: LabelPlacement.onTicks),
  ///        )
  ///    );
  ///}
  ///```
  final LabelPlacement labelPlacement;

  /// Plots the data points based on the index value.
  ///
  /// By default, data points will be
  /// grouped and plotted based on the x-value. They can also be grouped by the data
  /// point index value.
  ///
  /// Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(arrangeByIndex: true),
  ///        )
  ///    );
  ///}
  ///```
  final bool arrangeByIndex;

  /// The minimum value of the axis.
  ///
  /// The axis will start from this value.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(minimum: 0),
  ///        )
  ///    );
  ///}
  ///```
  final double? minimum;

  /// The maximum value of the axis.
  ///
  /// The axis will end at this value.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(maximum: 10),
  ///        )
  ///    );
  ///}
  ///```
  final double? maximum;

  /// The minimum visible value of the axis. The axis is rendered from this value
  /// initially.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(visibleMinimum: 0),
  ///        )
  ///    );
  ///}
  ///```
  final double? visibleMinimum;

  /// The maximum visible value of the axis.
  ///
  /// The axis is rendered to this value initially.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(visibleMaximum: 20),
  ///        ));
  ///}
  ///```
  final double? visibleMaximum;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CategoryAxis &&
        other.name == name &&
        other.isVisible == isVisible &&
        other.title == title &&
        other.axisLine == axisLine &&
        other.arrangeByIndex == arrangeByIndex &&
        other.rangePadding == rangePadding &&
        other.labelPlacement == labelPlacement &&
        other.edgeLabelPlacement == edgeLabelPlacement &&
        other.labelPosition == labelPosition &&
        other.tickPosition == tickPosition &&
        other.labelRotation == labelRotation &&
        other.labelIntersectAction == labelIntersectAction &&
        other.labelAlignment == labelAlignment &&
        other.isInversed == isInversed &&
        other.opposedPosition == opposedPosition &&
        other.minorTicksPerInterval == minorTicksPerInterval &&
        other.maximumLabels == maximumLabels &&
        other.majorTickLines == majorTickLines &&
        other.minorTickLines == minorTickLines &&
        other.majorGridLines == majorGridLines &&
        other.minorGridLines == minorGridLines &&
        other.labelStyle == labelStyle &&
        other.plotOffset == plotOffset &&
        other.zoomFactor == zoomFactor &&
        other.zoomPosition == zoomPosition &&
        other.interactiveTooltip == interactiveTooltip &&
        other.minimum == minimum &&
        other.maximum == maximum &&
        other.interval == interval &&
        other.visibleMinimum == visibleMinimum &&
        other.visibleMaximum == visibleMaximum &&
        other.crossesAt == crossesAt &&
        other.associatedAxisName == associatedAxisName &&
        other.placeLabelsNearAxisLine == placeLabelsNearAxisLine &&
        other.plotBands == plotBands &&
        other.desiredIntervals == desiredIntervals &&
        other.rangeController == rangeController &&
        other.maximumLabelWidth == maximumLabelWidth &&
        other.labelsExtent == labelsExtent &&
        other.autoScrollingDelta == autoScrollingDelta &&
        other.axisBorderType == axisBorderType &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.multiLevelLabelStyle == multiLevelLabelStyle &&
        other.multiLevelLabels == multiLevelLabels &&
        other.multiLevelLabelFormatter == multiLevelLabelFormatter &&
        other.autoScrollingMode == autoScrollingMode &&
        other.axisLabelFormatter == axisLabelFormatter;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      name,
      isVisible,
      title,
      axisLine,
      arrangeByIndex,
      rangePadding,
      labelPlacement,
      edgeLabelPlacement,
      labelPosition,
      tickPosition,
      labelRotation,
      labelIntersectAction,
      labelAlignment,
      isInversed,
      opposedPosition,
      minorTicksPerInterval,
      maximumLabels,
      majorTickLines,
      minorTickLines,
      majorGridLines,
      minorGridLines,
      labelStyle,
      plotOffset,
      zoomFactor,
      zoomPosition,
      interactiveTooltip,
      minimum,
      maximum,
      interval,
      visibleMinimum,
      visibleMaximum,
      crossesAt,
      associatedAxisName,
      placeLabelsNearAxisLine,
      plotBands,
      desiredIntervals,
      rangeController,
      maximumLabelWidth,
      labelsExtent,
      autoScrollingDelta,
      axisBorderType,
      borderColor,
      borderWidth,
      multiLevelLabelStyle,
      multiLevelLabels,
      multiLevelLabelFormatter,
      autoScrollingMode,
      axisLabelFormatter
    ];
    return Object.hashAll(values);
  }
}

/// Creates an axis renderer for Category axis
class CategoryAxisRenderer extends ChartAxisRenderer {
  /// Creating an argument constructor of CategoryAxisRenderer class.
  CategoryAxisRenderer(
      CategoryAxis categoryAxis, CartesianStateProperties stateProperties) {
    _axisDetails = CategoryAxisDetails(categoryAxis, this, stateProperties);
    AxisHelper.setAxisRendererDetails(this, _axisDetails);
  }

  late CategoryAxisDetails _axisDetails;

  /// Calculates the visible range for an axis in chart.
  @override
  void calculateVisibleRange(Size availableSize) {
    _axisDetails.setOldRangeFromRangeController();
    _axisDetails.visibleRange =
        _axisDetails.stateProperties.rangeChangeBySlider &&
                _axisDetails.rangeMinimum != null &&
                _axisDetails.rangeMaximum != null
            ? VisibleRange(_axisDetails.rangeMinimum, _axisDetails.rangeMaximum)
            : VisibleRange(_axisDetails.actualRange!.minimum,
                _axisDetails.actualRange!.maximum);
    _axisDetails.visibleRange!.delta = _axisDetails.actualRange!.delta;
    _axisDetails.visibleRange!.interval = _axisDetails.actualRange!.interval;
    bool canAutoScroll = false;
    if (_axisDetails._categoryAxis.autoScrollingDelta != null &&
        _axisDetails._categoryAxis.autoScrollingDelta! > 0 &&
        !_axisDetails.stateProperties.isRedrawByZoomPan) {
      canAutoScroll = true;
      _axisDetails.updateAutoScrollingDelta(
          _axisDetails._categoryAxis.autoScrollingDelta!, this);
    }
    if ((!canAutoScroll ||
            (_axisDetails.stateProperties.zoomedState ?? false)) &&
        !(_axisDetails.stateProperties.rangeChangeBySlider &&
            !_axisDetails.stateProperties.canSetRangeController)) {
      _axisDetails.setZoomFactorAndPosition(
          this, _axisDetails.stateProperties.zoomedAxisRendererStates);
    }
    if (_axisDetails.zoomFactor < 1 ||
        _axisDetails.zoomPosition > 0 ||
        (_axisDetails.axis.rangeController != null &&
            !_axisDetails.stateProperties.renderingDetails.initialRender!)) {
      _axisDetails.stateProperties.zoomProgress = true;
      _axisDetails.calculateZoomRange(this, availableSize);
      if (_axisDetails.axis.rangeController != null &&
          _axisDetails.stateProperties.isRedrawByZoomPan &&
          _axisDetails.stateProperties.canSetRangeController &&
          _axisDetails.stateProperties.zoomProgress) {
        _axisDetails.stateProperties.rangeChangedByChart = true;
        _axisDetails.setRangeControllerValues(this);
      }
    }
    _axisDetails.setZoomValuesFromRangeController();
  }

  /// Applies range padding
  @override
  void applyRangePadding(VisibleRange range, num? interval) {
    ActualRangeChangedArgs rangeChangedArgs;
    if (_axisDetails._categoryAxis.labelPlacement ==
        LabelPlacement.betweenTicks) {
      range.minimum -= 0.5;
      range.maximum += 0.5;
      range.delta = range.maximum - range.minimum;
    }

    if (!(_axisDetails._categoryAxis.minimum != null &&
        _axisDetails._categoryAxis.maximum != null)) {
      ///Calculating range padding
      _axisDetails.applyRangePaddings(
          this, _axisDetails.stateProperties, range, interval!);
    }

    calculateVisibleRange(
        Size(_axisDetails.rect.width, _axisDetails.rect.height));

    /// Setting range as visible zoomRange
    if ((_axisDetails._categoryAxis.visibleMinimum != null ||
            _axisDetails._categoryAxis.visibleMaximum != null) &&
        (_axisDetails._categoryAxis.visibleMinimum !=
            _axisDetails._categoryAxis.visibleMaximum) &&
        (!_axisDetails.stateProperties.isRedrawByZoomPan)) {
      _axisDetails.stateProperties.isRedrawByZoomPan = false;
      _axisDetails.visibleRange!.minimum = _axisDetails.visibleMinimum ??
          _axisDetails._categoryAxis.visibleMinimum ??
          _axisDetails.actualRange!.minimum;
      _axisDetails.visibleRange!.maximum = _axisDetails.visibleMaximum ??
          _axisDetails._categoryAxis.visibleMaximum ??
          _axisDetails.actualRange!.maximum;
      if (_axisDetails._categoryAxis.labelPlacement ==
          LabelPlacement.betweenTicks) {
        _axisDetails.visibleRange!.minimum =
            _axisDetails._categoryAxis.visibleMinimum != null
                ? (_axisDetails.visibleMinimum ??
                        _axisDetails._categoryAxis.visibleMinimum!) -
                    0.5
                : _axisDetails.visibleRange!.minimum;
        _axisDetails.visibleRange!.maximum =
            _axisDetails._categoryAxis.visibleMaximum != null
                ? (_axisDetails.visibleMaximum ??
                        _axisDetails._categoryAxis.visibleMaximum!) +
                    0.5
                : _axisDetails.visibleRange!.maximum;
      }
      _axisDetails.visibleRange!.delta = _axisDetails.visibleRange!.maximum -
          _axisDetails.visibleRange!.minimum;
      _axisDetails.visibleRange!.interval = interval == null
          ? calculateInterval(_axisDetails.visibleRange!, _axisDetails.axisSize)
          : _axisDetails.visibleRange!.interval;
      _axisDetails.zoomFactor =
          _axisDetails.visibleRange!.delta / (range.delta);
      _axisDetails.zoomPosition = (_axisDetails.visibleRange!.minimum -
              _axisDetails.actualRange!.minimum) /
          range.delta;
    }
    if (_axisDetails.chart.onActualRangeChanged != null) {
      rangeChangedArgs = ActualRangeChangedArgs(
          _axisDetails.name!,
          _axisDetails._categoryAxis,
          range.minimum,
          range.maximum,
          range.interval,
          _axisDetails.orientation!);
      rangeChangedArgs.visibleMin = _axisDetails.visibleRange!.minimum;
      rangeChangedArgs.visibleMax = _axisDetails.visibleRange!.maximum;
      rangeChangedArgs.visibleInterval = _axisDetails.visibleRange!.interval;
      _axisDetails.chart.onActualRangeChanged!(rangeChangedArgs);
      _axisDetails.visibleRange!.minimum = rangeChangedArgs.visibleMin;
      _axisDetails.visibleRange!.maximum = rangeChangedArgs.visibleMax;
      _axisDetails.visibleRange!.delta = _axisDetails.visibleRange!.maximum -
          _axisDetails.visibleRange!.minimum;
      _axisDetails.visibleRange!.interval = rangeChangedArgs.visibleInterval;
      _axisDetails.zoomFactor =
          _axisDetails.visibleRange!.delta / (range.delta);
      _axisDetails.zoomPosition = (_axisDetails.visibleRange!.minimum -
              _axisDetails.actualRange!.minimum) /
          range.delta;
    }
  }

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    num tempInterval = _axisDetails.visibleRange!.minimum.ceil();
    int position;
    String labelText;
    _axisDetails.visibleLabels = <AxisLabel>[];
    for (;
        tempInterval <= _axisDetails.visibleRange!.maximum;
        tempInterval += _axisDetails.visibleRange!.interval) {
      if (withInRange(tempInterval, _axisDetails)) {
        position = tempInterval.round();
        if (position <= -1 ||
            (_axisDetails.labels.isNotEmpty &&
                position >= _axisDetails.labels.length)) {
          continue;
        } else if (_axisDetails.labels.isNotEmpty &&
            // ignore: unnecessary_null_comparison
            _axisDetails.labels[position] != null) {
          labelText = _axisDetails.labels[position];
        } else {
          continue;
        }
        _axisDetails.triggerLabelRenderEvent(labelText, tempInterval);
      }
    }

    /// Get the maximum label of width and height in axis.
    _axisDetails.calculateMaximumLabelSize(this, _axisDetails.stateProperties);
    if (_axisDetails._categoryAxis.multiLevelLabels != null &&
        _axisDetails._categoryAxis.multiLevelLabels!.isNotEmpty) {
      generateMultiLevelLabels(_axisDetails);
      calculateMultiLevelLabelBounds(_axisDetails);
    }
  }

  /// Finds the interval of an axis.
  @override
  num calculateInterval(VisibleRange range, Size availableSize) => math
      .max(
          1,
          (_axisDetails.actualRange!.delta /
                  _axisDetails.calculateDesiredIntervalCount(
                      Size(_axisDetails.rect.width, _axisDetails.rect.height),
                      this))
              .floor())
      .toInt();
}

/// Represents the cartegory axis details class
class CategoryAxisDetails extends ChartAxisRendererDetails {
  /// Creates an instance an in
  CategoryAxisDetails(this._categoryAxis, ChartAxisRenderer axisRenderer,
      CartesianStateProperties stateProperties)
      : super(_categoryAxis, stateProperties, axisRenderer) {
    labels = <String>[];
  }

  /// Specifies the list of labels
  late List<String> labels;

  /// Represents the rect value
  late Rect rect;
  final CategoryAxis _categoryAxis;

  /// Method to find the axis minimum and maximum value
  void findAxisMinMaxValues(SeriesRendererDetails seriesRendererDetails,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool? isXVisibleRange, bool? isYVisibleRange]) {
    if (_categoryAxis.arrangeByIndex) {
      // ignore: unnecessary_null_comparison
      pointIndex < labels.length && labels[pointIndex] != null
          ? labels[pointIndex] += ', ${point.x}'
          : labels.add(point.x.toString());
      point.xValue = pointIndex;
    } else {
      if (!labels.contains(point.x.toString())) {
        labels.add(point.x.toString());
      }
      point.xValue = labels.indexOf(point.x.toString());
    }
    point.yValue = point.y;
    setCategoryMinMaxValues(axisRenderer, isXVisibleRange!, isYVisibleRange!,
        point, pointIndex, dataLength, seriesRendererDetails);
  }

  /// Listener for range controller
  void _controlListener() {
    stateProperties.canSetRangeController = false;
    if (_categoryAxis.rangeController != null &&
        !stateProperties.rangeChangedByChart) {
      updateRangeControllerValues(this);
      stateProperties.rangeChangeBySlider = true;
      stateProperties.redrawByRangeChange();
    }
  }

  /// Calculate the range and interval
  void calculateRangeAndInterval(CartesianStateProperties stateProperties,
      [String? type]) {
    chart = stateProperties.chart;
    if (axis.rangeController != null) {
      stateProperties.rangeChangeBySlider = true;
      axis.rangeController!.addListener(_controlListener);
    }
    final Rect containerRect =
        stateProperties.renderingDetails.chartContainerRect;
    rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    axisSize = Size(rect.width, rect.height);
    axisRenderer.calculateRange(axisRenderer);
    _calculateActualRange();
    if (actualRange != null) {
      axisRenderer.applyRangePadding(actualRange!, actualRange!.interval);
      if (type == null && type != 'AxisCross' && _categoryAxis.isVisible) {
        axisRenderer.generateVisibleLabels();
      }
    }
  }

  /// Calculate the required values of the actual range for the category axis
  void _calculateActualRange() {
    if (min == null && max == null) {
      if ((stateProperties.zoomedState ?? false) ||
          stateProperties.zoomProgress) {
        min ??= 0;
        max ??= 5;
      } else {
        min ??= 0;
        max ??= 0;
      }
    }
    if (min != null && max != null) {
      actualRange = VisibleRange(
          _categoryAxis.minimum ?? min, _categoryAxis.maximum ?? max);
      CartesianSeriesRenderer seriesRenderer;
      for (int i = 0; i < seriesRenderers.length; i++) {
        seriesRenderer = seriesRenderers[i];
        final SeriesRendererDetails seriesRendererDetails =
            SeriesHelper.getSeriesRendererDetails(seriesRenderer);
        if (((_categoryAxis.minimum != null || _categoryAxis.maximum != null) ||
                (stateProperties.zoomedState ?? false) ||
                stateProperties.zoomProgress) &&
            (actualRange!.maximum >
                    seriesRendererDetails.dataPoints.length - 1) ==
                true) {
          for (int i = labels.length; i < actualRange!.maximum + 1; i++) {
            labels.add(i.toString());
          }
        }
      }
      actualRange = VisibleRange(
          _categoryAxis.minimum ?? min, _categoryAxis.maximum ?? max);

      ///Below condition is for checking the min, max value is equal
      if ((actualRange!.minimum == actualRange!.maximum) &&
          (_categoryAxis.labelPlacement == LabelPlacement.onTicks)) {
        actualRange!.maximum += 1;
      }
      actualRange!.delta = actualRange!.maximum - actualRange!.minimum;
      actualRange!.interval = _categoryAxis.interval ??
          axisRenderer.calculateInterval(
              actualRange!, Size(rect.width, rect.height));
      actualRange!.delta = actualRange!.maximum - actualRange!.minimum;
    }
  }
}
