import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:syncfusion_flutter_core/core.dart';

import '../../common/event_args.dart';
import '../../common/utils/typedef.dart'
    show MultiLevelLabelFormatterCallback, ChartLabelFormatterCallback;
import '../axis/axis.dart';
import '../axis/multi_level_labels.dart';
import '../axis/plotband.dart';
import '../base/chart_base.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart' show updateErrorBarAxisRange;
import '../common/interactive_tooltip.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Logarithmic axis uses logarithmic scale and displays numbers as axis labels.
///
/// Provides options to customize the range of log axis, use the [minimum], [maximum], and [interval] properties.
/// By default, the range will be calculated automatically based on the provided data.
///
/// _Note:_ This is only applicable for [SfCartesianChart].
@immutable
class LogarithmicAxis extends ChartAxis {
  /// Creating an argument constructor of LogarithmicAxis class.
  LogarithmicAxis(
      {String? name,
      bool? isVisible,
      bool? anchorRangeToVisiblePoints,
      AxisTitle? title,
      AxisLine? axisLine,
      AxisLabelIntersectAction? labelIntersectAction,
      int? labelRotation,
      ChartDataLabelPosition? labelPosition,
      TickPosition? tickPosition,
      bool? isInversed,
      bool? opposedPosition,
      int? minorTicksPerInterval,
      int? maximumLabels,
      MajorTickLines? majorTickLines,
      MinorTickLines? minorTickLines,
      MajorGridLines? majorGridLines,
      MinorGridLines? minorGridLines,
      EdgeLabelPlacement? edgeLabelPlacement,
      TextStyle? labelStyle,
      double? plotOffset,
      double? zoomFactor,
      double? zoomPosition,
      bool? enableAutoIntervalOnZooming,
      InteractiveTooltip? interactiveTooltip,
      this.minimum,
      this.maximum,
      double? interval,
      this.logBase = 10,
      this.labelFormat,
      this.numberFormat,
      this.visibleMinimum,
      this.visibleMaximum,
      LabelAlignment? labelAlignment,
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
      MultiLevelLabelStyle? multiLevelLabelStyle,
      MultiLevelLabelFormatterCallback? multiLevelLabelFormatter,
      List<LogarithmicMultiLevelLabel>? multiLevelLabels,
      AutoScrollingMode? autoScrollingMode,
      ChartLabelFormatterCallback? axisLabelFormatter})
      : super(
            name: name,
            isVisible: isVisible,
            anchorRangeToVisiblePoints: anchorRangeToVisiblePoints,
            isInversed: isInversed,
            opposedPosition: opposedPosition,
            labelRotation: labelRotation,
            labelIntersectAction: labelIntersectAction,
            labelPosition: labelPosition,
            tickPosition: tickPosition,
            minorTicksPerInterval: minorTicksPerInterval,
            maximumLabels: maximumLabels,
            labelStyle: labelStyle,
            title: title,
            axisLine: axisLine,
            edgeLabelPlacement: edgeLabelPlacement,
            labelAlignment: labelAlignment,
            majorTickLines: majorTickLines,
            minorTickLines: minorTickLines,
            majorGridLines: majorGridLines,
            minorGridLines: minorGridLines,
            plotOffset: plotOffset,
            zoomFactor: zoomFactor,
            zoomPosition: zoomPosition,
            enableAutoIntervalOnZooming: enableAutoIntervalOnZooming,
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
            multiLevelLabelFormatter: multiLevelLabelFormatter,
            multiLevelLabels: multiLevelLabels,
            autoScrollingMode: autoScrollingMode,
            axisLabelFormatter: axisLabelFormatter);

  /// Formats the numeric axis labels.
  ///
  /// The labels can be customized by adding desired text as prefix or suffix.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogaithmicAxis(labelFormat: '{value}M'),
  ///        )
  ///    );
  ///}
  ///```
  final String? labelFormat;

  /// Formats the logarithmic axis labels with globalized label formats.
  ///
  /// Provides the ability to format a number in a locale-specific way.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(numberFormat: NumberFormat.currencyCompact()),
  ///        )
  ///    );
  ///}
  ///```
  final NumberFormat? numberFormat;

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
  ///           primaryYAxis: LogarithmicAxis(minimum: 0),
  ///        )
  ///    );
  ///}
  ///```
  final double? minimum;

  /// The maximum value of the axis.
  /// The axis will end at this value.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(maximum: 10),
  ///        )
  ///    );
  ///}
  ///```
  final double? maximum;

  /// The base value for logarithmic axis.
  /// The axislabel will render this base value.i.e 10,100,1000 and so on.
  ///
  /// Defaults to `10`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(logBase: 10),
  ///        )
  ///    );
  ///}
  ///```
  final double logBase;

  /// The minimum visible value of the axis.
  ///
  /// The axis will be rendered from this value initially.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(visibleMinimum: 0),
  ///        )
  ///    );
  ///}
  ///```
  final double? visibleMinimum;

  /// The minimum visible value of the axis.
  ///
  /// The axis will be rendered from this value initially.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(visibleMaximum: 200),
  ///        )
  ///    );
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

    return other is LogarithmicAxis &&
        other.name == name &&
        other.isVisible == isVisible &&
        other.title == title &&
        other.axisLine == axisLine &&
        other.numberFormat == numberFormat &&
        other.labelFormat == labelFormat &&
        other.rangePadding == rangePadding &&
        other.logBase == logBase &&
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
      numberFormat,
      labelFormat,
      rangePadding,
      logBase,
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

/// Creates an axis renderer for Logarithmic axis
class LogarithmicAxisRenderer extends ChartAxisRenderer {
  /// Creating an argument constructor of LogarithmicAxisRenderer class.
  LogarithmicAxisRenderer(LogarithmicAxis logarithmicAxis,
      CartesianStateProperties stateProperties) {
    _axisDetails =
        LogarithmicAxisDetails(logarithmicAxis, stateProperties, this);
    AxisHelper.setAxisRendererDetails(this, _axisDetails);
  }

  late LogarithmicAxisDetails _axisDetails;

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
    if (_axisDetails.logarithmicAxis.autoScrollingDelta != null &&
        _axisDetails.logarithmicAxis.autoScrollingDelta! > 0 &&
        !_axisDetails.stateProperties.isRedrawByZoomPan) {
      canAutoScroll = true;
      _axisDetails.updateAutoScrollingDelta(
          _axisDetails.logarithmicAxis.autoScrollingDelta!, this);
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
                !_axisDetails
                    .stateProperties.renderingDetails.initialRender!) &&
            !(_axisDetails.stateProperties.rangeChangeBySlider ||
                !_axisDetails.stateProperties.canSetRangeController)) {
      _axisDetails.stateProperties.zoomProgress = true;
      _axisDetails.calculateZoomRange(this, availableSize);
      _axisDetails.visibleRange!.delta = _axisDetails.visibleRange!.maximum -
          _axisDetails.visibleRange!.minimum;
      _axisDetails.visibleRange!.interval =
          _axisDetails.axis.enableAutoIntervalOnZooming &&
                  _axisDetails.stateProperties.zoomProgress
              ? (_axisDetails.axisRenderer as LogarithmicAxisRenderer)
                  .calculateLogNiceInterval(_axisDetails.visibleRange!.delta)
              : _axisDetails.visibleRange!.interval;
      _axisDetails.visibleRange!.interval =
          _axisDetails.visibleRange!.interval.floor() == 0
              ? 1
              : _axisDetails.visibleRange!.interval.floor();
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

  /// Applies range padding to auto, normal, additional, round, and none types.
  @override
  void applyRangePadding(VisibleRange range, num interval) {}

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    num tempInterval = _axisDetails.visibleRange!.minimum;
    String labelText;
    _axisDetails.visibleLabels = <AxisLabel>[];
    for (;
        tempInterval <= _axisDetails.visibleRange!.maximum;
        tempInterval += _axisDetails.visibleRange!.interval) {
      labelText =
          pow(_axisDetails.logarithmicAxis.logBase, tempInterval).toString();

      labelText = double.parse(labelText) < 1
          ? labelText
          : double.parse(labelText).floor().toString();

      if (_axisDetails.logarithmicAxis.numberFormat != null) {
        labelText = _axisDetails.logarithmicAxis.numberFormat!
            .format(pow(_axisDetails.logarithmicAxis.logBase, tempInterval));
      }

      if (_axisDetails.logarithmicAxis.labelFormat != null &&
          _axisDetails.logarithmicAxis.labelFormat != '') {
        labelText = _axisDetails.logarithmicAxis.labelFormat!
            .replaceAll(RegExp('{value}'), labelText);
      }
      _axisDetails.triggerLabelRenderEvent(labelText, tempInterval);
    }

    /// Get the maximum label of width and height in axis.
    _axisDetails.calculateMaximumLabelSize(this, _axisDetails.stateProperties);
    if (_axisDetails.logarithmicAxis.multiLevelLabels != null &&
        _axisDetails.logarithmicAxis.multiLevelLabels!.isNotEmpty) {
      generateMultiLevelLabels(_axisDetails);
      calculateMultiLevelLabelBounds(_axisDetails);
    }
  }

  /// Finds the interval of an axis.
  @override
  num? calculateInterval(VisibleRange range, Size availableSize) => null;

  /// To get the axis interval for logarithmic axis
  num calculateLogNiceInterval(num delta) {
    final List<num> intervalDivisions = <num>[10, 5, 2, 1];
    final num actualDesiredIntervalCount =
        _axisDetails.calculateDesiredIntervalCount(
            _axisDetails.axisSize, _axisDetails.axisRenderer);
    num niceInterval = delta;
    final num minInterval =
        math.pow(10, calculateLogBaseValue(niceInterval, 10).floor());
    for (int i = 0; i < intervalDivisions.length; i++) {
      final num interval = intervalDivisions[i];
      final num currentInterval = minInterval * interval;
      if (actualDesiredIntervalCount < (delta / currentInterval)) {
        break;
      }
      niceInterval = currentInterval;
    }
    return niceInterval;
  }
}

/// This class holds the details of LogarithmicAxis
class LogarithmicAxisDetails extends ChartAxisRendererDetails {
  ///Argument constructor for LogarthmicAxisDetails class
  LogarithmicAxisDetails(this.logarithmicAxis,
      CartesianStateProperties stateProperties, ChartAxisRenderer axisRenderer)
      : super(logarithmicAxis, stateProperties, axisRenderer);

  /// Specifies the value of logarithmic axis
  final LogarithmicAxis logarithmicAxis;

  /// Find the series min and max values of an series
  void findAxisMinMaxValues(SeriesRendererDetails seriesRendererDetails,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool? isXVisibleRange, bool? isYVisibleRange]) {
    final String seriesType = seriesRendererDetails.seriesType;
    point.xValue = point.x;
    point.yValue = point.y;
    seriesRendererDetails.minimumX ??= point.xValue;
    seriesRendererDetails.maximumX ??= point.xValue;
    if (!seriesType.contains('range') &&
        (!seriesType.contains('hilo')) &&
        (!seriesType.contains('candle'))) {
      seriesRendererDetails.minimumY ??= point.yValue;
      seriesRendererDetails.maximumY ??= point.yValue;
    }
    lowMin ??= point.low;
    lowMax ??= point.low;
    highMin ??= point.high;
    highMax ??= point.high;
    if (point.xValue != null) {
      seriesRendererDetails.minimumX =
          math.min(seriesRendererDetails.minimumX!, point.xValue as num);
      seriesRendererDetails.maximumX =
          math.max(seriesRendererDetails.maximumX!, point.xValue as num);
    }
    if (point.yValue != null &&
        (!seriesType.contains('range') &&
            !seriesType.contains('hilo') &&
            !seriesType.contains('candle'))) {
      seriesRendererDetails.minimumY =
          math.min(seriesRendererDetails.minimumY!, point.yValue as num);
      seriesRendererDetails.maximumY =
          math.max(seriesRendererDetails.maximumY!, point.yValue as num);
    }
    if (point.high != null) {
      highMin = math.min(highMin!, point.high);
      highMax = math.max(highMax!, point.high);
    }
    if (point.low != null) {
      lowMin = math.min(lowMin!, point.low);
      lowMax = math.max(lowMax!, point.low);
    }
    if (seriesType == 'errorbar') {
      updateErrorBarAxisRange(seriesRendererDetails, point);
    }
    if (pointIndex >= dataLength - 1) {
      if (seriesType.contains('range') ||
          seriesType.contains('hilo') ||
          seriesType.contains('candle')) {
        lowMin ??= 0;
        lowMax ??= 5;
        highMin ??= 0;
        highMax ??= 5;
        seriesRendererDetails.minimumY =
            math.min(lowMin!.toDouble(), highMin!.toDouble());
        seriesRendererDetails.maximumY =
            math.max(lowMax!.toDouble(), highMax!.toDouble());
      }
      seriesRendererDetails.minimumX ??= 0;
      seriesRendererDetails.minimumY ??= 0;
      seriesRendererDetails.maximumX ??= 5;
      seriesRendererDetails.maximumY ??= 5;
    }
  }

  /// Listener for range controller
  void _controlListener() {
    stateProperties.canSetRangeController = false;
    if (axis.rangeController != null && !stateProperties.rangeChangedByChart) {
      updateRangeControllerValues(this);
      stateProperties.rangeChangeBySlider = true;
      stateProperties.redrawByRangeChange();
    }
  }

  /// Calculate the range and interval
  void calculateRangeAndInterval(CartesianStateProperties stateProperties,
      [String? type]) {
    chart = stateProperties.chart;
    if (logarithmicAxis.rangeController != null) {
      stateProperties.rangeChangeBySlider = true;
      logarithmicAxis.rangeController!.addListener(_controlListener);
    }
    final Rect containerRect =
        stateProperties.renderingDetails.chartContainerRect;
    final Rect rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    axisSize = Size(rect.width, rect.height);
    axisRenderer.calculateRange(axisRenderer);
    _calculateActualRange();
    axisRenderer.calculateVisibleRange(axisSize);

    /// Setting range as visible zoomRange
    if ((logarithmicAxis.visibleMinimum != null ||
            logarithmicAxis.visibleMaximum != null) &&
        (logarithmicAxis.visibleMinimum != logarithmicAxis.visibleMaximum) &&
        (!stateProperties.isRedrawByZoomPan)) {
      stateProperties.isRedrawByZoomPan = false;
      visibleRange!.minimum = logarithmicAxis.visibleMinimum != null
          ? (math.log(logarithmicAxis.visibleMinimum!) / (math.log(10))).round()
          : actualRange!.minimum;
      visibleRange!.maximum = logarithmicAxis.visibleMaximum != null
          ? (math.log(logarithmicAxis.visibleMaximum!) / (math.log(10))).round()
          : actualRange!.maximum;
      visibleRange!.delta = visibleRange!.maximum - visibleRange!.minimum;
      zoomFactor = visibleRange!.delta / (actualRange!.delta);
      zoomPosition =
          (visibleRange!.minimum - actualRange!.minimum) / actualRange!.delta;
    }

    ActualRangeChangedArgs rangeChangedArgs;
    if (chart.onActualRangeChanged != null) {
      final VisibleRange range = actualRange!;
      rangeChangedArgs = ActualRangeChangedArgs(name!, logarithmicAxis,
          range.minimum, range.maximum, range.interval, orientation!);
      rangeChangedArgs.visibleMin = visibleRange!.minimum;
      rangeChangedArgs.visibleMax = visibleRange!.maximum;
      rangeChangedArgs.visibleInterval = visibleRange!.interval;
      chart.onActualRangeChanged!(rangeChangedArgs);
      visibleRange!.minimum = rangeChangedArgs.visibleMin;
      visibleRange!.maximum = rangeChangedArgs.visibleMax;
      visibleRange!.delta = visibleRange!.maximum - visibleRange!.minimum;
      visibleRange!.interval = rangeChangedArgs.visibleInterval;
      zoomFactor = visibleRange!.delta / range.delta;
      zoomPosition =
          (visibleRange!.minimum - actualRange!.minimum) / range.delta;
    }
    if (type == null && type != 'AxisCross' && logarithmicAxis.isVisible) {
      axisRenderer.generateVisibleLabels();
    }
  }

  /// Calculate the required values of the actual range for logarithmic axis
  void _calculateActualRange() {
    num logStart, logEnd;
    this.min ??= 0;
    this.max ??= 5;
    this.min = logarithmicAxis.minimum ?? this.min;
    this.max = logarithmicAxis.maximum ?? this.max;
    actualRange = VisibleRange(this.min, this.max);
    if (axis.anchorRangeToVisiblePoints &&
        needCalculateYRange(logarithmicAxis.minimum, logarithmicAxis.maximum,
            stateProperties, orientation!)) {
      final VisibleRange range = calculateYRangeOnZoomX(actualRange!, this);
      this.min = range.minimum;
      this.max = range.maximum;
    }
    this.min = this.min! < 0 ? 0 : this.min;
    logStart = calculateLogBaseValue(this.min!, logarithmicAxis.logBase);
    logStart = logStart.isFinite ? logStart : this.min!;
    logEnd = calculateLogBaseValue(this.max!, logarithmicAxis.logBase);
    logEnd = logEnd.isFinite ? logEnd : this.max!;
    this.min = (logStart / 1).floor();
    this.max = (logEnd / 1).ceil();
    if (this.min == this.max) {
      this.max = this.max! + 1;
    }
    actualRange = VisibleRange(this.min, this.max);
    actualRange!.delta = actualRange!.maximum - actualRange!.minimum;
    actualRange!.interval = logarithmicAxis.interval ??
        (axisRenderer as LogarithmicAxisRenderer)
            .calculateLogNiceInterval(actualRange!.delta);
  }
}
