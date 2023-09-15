import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:syncfusion_flutter_core/core.dart';

import '../../common/event_args.dart';
import '../../common/utils/typedef.dart'
    show MultiLevelLabelFormatterCallback, ChartLabelFormatterCallback;
import '../axis/axis.dart';
import '../axis/multi_level_labels.dart';
import '../axis/plotband.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart' show updateErrorBarAxisRange;
import '../common/interactive_tooltip.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// This class has the properties of the numeric axis.
///
/// Numeric axis uses a numerical scale and displays numbers as labels. By default, [NumericAxis] is set to both
/// horizontal axis and vertical axis.
///
/// Provides the options of [name], axis line, label rotation, label format, alignment and label position are
/// used to customize the appearance.
///
@immutable
class NumericAxis extends ChartAxis {
  /// Creating an argument constructor of NumericAxis class.
  NumericAxis(
      {String? name,
      bool? isVisible,
      bool? anchorRangeToVisiblePoints,
      AxisTitle? title,
      AxisLine? axisLine,
      ChartRangePadding? rangePadding,
      AxisLabelIntersectAction? labelIntersectAction,
      int? labelRotation,
      this.labelFormat,
      this.numberFormat,
      LabelAlignment? labelAlignment,
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
      this.visibleMinimum,
      this.visibleMaximum,
      dynamic crossesAt,
      String? associatedAxisName,
      bool? placeLabelsNearAxisLine,
      List<PlotBand>? plotBands,
      this.decimalPlaces = 3,
      int? desiredIntervals,
      RangeController? rangeController,
      double? maximumLabelWidth,
      double? labelsExtent,
      int? autoScrollingDelta,
      AutoScrollingMode? autoScrollingMode,
      double? borderWidth,
      Color? borderColor,
      AxisBorderType? axisBorderType,
      List<NumericMultiLevelLabel>? multiLevelLabels,
      MultiLevelLabelFormatterCallback? multiLevelLabelFormatter,
      MultiLevelLabelStyle? multiLevelLabelStyle,
      ChartLabelFormatterCallback? axisLabelFormatter})
      : super(
            name: name,
            isVisible: isVisible,
            anchorRangeToVisiblePoints: anchorRangeToVisiblePoints,
            isInversed: isInversed,
            opposedPosition: opposedPosition,
            rangePadding: rangePadding,
            labelRotation: labelRotation,
            labelIntersectAction: labelIntersectAction,
            labelPosition: labelPosition,
            tickPosition: tickPosition,
            minorTicksPerInterval: minorTicksPerInterval,
            maximumLabels: maximumLabels,
            labelStyle: labelStyle,
            title: title,
            labelAlignment: labelAlignment,
            axisLine: axisLine,
            edgeLabelPlacement: edgeLabelPlacement,
            majorTickLines: majorTickLines,
            minorTickLines: minorTickLines,
            majorGridLines: majorGridLines,
            minorGridLines: minorGridLines,
            plotOffset: plotOffset,
            enableAutoIntervalOnZooming: enableAutoIntervalOnZooming,
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
            multiLevelLabelFormatter: multiLevelLabelFormatter,
            multiLevelLabels: multiLevelLabels,
            multiLevelLabelStyle: multiLevelLabelStyle,
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
  ///           primaryXAxis: NumericAxis(labelFormat: '{value}M'),
  ///        )
  ///    );
  ///}
  ///```
  final String? labelFormat;

  /// Formats the numeric axis labels with globalized label formats.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(numberFormat: NumberFormat.currencyCompact()),
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
  ///           primaryXAxis: NumericAxis(minimum: 0),
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
  ///           primaryXAxis: NumericAxis(maximum: 200),
  ///        )
  ///    );
  ///}
  ///```
  final double? maximum;

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
  ///           primaryXAxis: NumericAxis(visibleMinimum: 0),
  ///        )
  ///    );
  ///}
  ///```
  final double? visibleMinimum;

  /// The maximum visible value of the axis.
  ///
  /// The axis will be rendered till this value initially.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(visibleMaximum: 200),
  ///        )
  ///    );
  ///}
  ///```
  final double? visibleMaximum;

  /// The rounding decimal value of the label.
  ///
  /// Defaults to `3`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(decimalPlaces: 3),
  ///        )
  ///    );
  ///}
  ///```
  final int decimalPlaces;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is NumericAxis &&
        other.name == name &&
        other.isVisible == isVisible &&
        other.title == title &&
        other.axisLine == axisLine &&
        other.numberFormat == numberFormat &&
        other.labelFormat == labelFormat &&
        other.rangePadding == rangePadding &&
        other.decimalPlaces == decimalPlaces &&
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
      decimalPlaces,
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

/// Creates an axis renderer for Numeric axis.
class NumericAxisRenderer extends ChartAxisRenderer {
  /// Creating an argument constructor of NumericAxisRenderer class.
  NumericAxisRenderer(
      NumericAxis numericAxis, CartesianStateProperties stateProperties) {
    _axisDetails = NumericAxisDetails(numericAxis, this, stateProperties);
    AxisHelper.setAxisRendererDetails(this, _axisDetails);
  }

  late NumericAxisDetails _axisDetails;

  /// Applies range padding to auto, normal, additional, round, and none types.
  @override
  void applyRangePadding(VisibleRange range, num? interval) {
    ActualRangeChangedArgs rangeChangedArgs;
    final NumericAxisDetails axisDetails =
        AxisHelper.getAxisRendererDetails(this) as NumericAxisDetails;
    if (!(axisDetails.numericAxis.minimum != null &&
        axisDetails.numericAxis.maximum != null)) {
      ///Calculating range padding
      axisDetails.applyRangePaddings(
          this, axisDetails.stateProperties, range, interval!);
    }

    calculateVisibleRange(axisDetails.axisSize);

    /// Setting range as visible zoomRange
    if ((axisDetails.numericAxis.visibleMinimum != null ||
            axisDetails.numericAxis.visibleMaximum != null) &&
        (axisDetails.numericAxis.visibleMinimum !=
            axisDetails.numericAxis.visibleMaximum) &&
        (!axisDetails.stateProperties.isRedrawByZoomPan)) {
      axisDetails.stateProperties.isRedrawByZoomPan = false;
      axisDetails.visibleRange!.minimum = axisDetails.visibleMinimum ??
          axisDetails.numericAxis.visibleMinimum ??
          axisDetails.actualRange!.minimum;
      axisDetails.visibleRange!.maximum = axisDetails.visibleMaximum ??
          axisDetails.numericAxis.visibleMaximum ??
          axisDetails.actualRange!.maximum;
      axisDetails.visibleRange!.delta =
          axisDetails.visibleRange!.maximum - axisDetails.visibleRange!.minimum;
      axisDetails.visibleRange!.interval = interval == null
          ? axisDetails.calculateNumericNiceInterval(
              this,
              axisDetails.visibleRange!.maximum -
                  axisDetails.visibleRange!.minimum,
              axisDetails.axisSize)
          : axisDetails.visibleRange!.interval;
      axisDetails.zoomFactor = axisDetails.visibleRange!.delta / range.delta;
      axisDetails.zoomPosition = (axisDetails.visibleRange!.minimum -
              axisDetails.actualRange!.minimum) /
          range.delta;
    }
    if (axisDetails.chart.onActualRangeChanged != null) {
      rangeChangedArgs = ActualRangeChangedArgs(
          axisDetails.name!,
          axisDetails.numericAxis,
          range.minimum,
          range.maximum,
          range.interval,
          axisDetails.orientation!);
      rangeChangedArgs.visibleMin = axisDetails.visibleRange!.minimum;
      rangeChangedArgs.visibleMax = axisDetails.visibleRange!.maximum;
      rangeChangedArgs.visibleInterval = axisDetails.visibleRange!.interval;
      axisDetails.chart.onActualRangeChanged!(rangeChangedArgs);
      axisDetails.visibleRange!.minimum = rangeChangedArgs.visibleMin;
      axisDetails.visibleRange!.maximum = rangeChangedArgs.visibleMax;
      axisDetails.visibleRange!.delta =
          axisDetails.visibleRange!.maximum - axisDetails.visibleRange!.minimum;
      axisDetails.visibleRange!.interval = rangeChangedArgs.visibleInterval;
      axisDetails.zoomFactor = axisDetails.visibleRange!.delta / range.delta;
      axisDetails.zoomPosition = (axisDetails.visibleRange!.minimum -
              axisDetails.actualRange!.minimum) /
          range.delta;
    }
  }

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(this);
    final VisibleRange? visibleRange = axisDetails.visibleRange;
    final NumericAxis numericAxis = axisDetails.axis as NumericAxis;
    num tempInterval = visibleRange!.minimum;
    String text;
    final num maximumVisibleRange = visibleRange.maximum;
    num interval = visibleRange.interval;
    interval = interval.toString().split('.').length >= 2
        ? interval.toString().split('.')[1].length == 1 &&
                interval.toString().split('.')[1] == '0'
            ? interval.floor()
            : interval
        : interval;
    axisDetails.visibleLabels = <AxisLabel>[];
    for (; tempInterval <= maximumVisibleRange; tempInterval += interval) {
      num minimumVisibleRange = tempInterval;
      if (minimumVisibleRange <= maximumVisibleRange &&
          minimumVisibleRange >= visibleRange.minimum) {
        final int fractionDigits =
            (minimumVisibleRange.toString().split('.').length >= 2)
                ? minimumVisibleRange.toString().split('.')[1].toString().length
                : 0;
        final int fractionDigitValue =
            fractionDigits > 20 ? 20 : fractionDigits;
        minimumVisibleRange = minimumVisibleRange.toString().contains('e')
            ? minimumVisibleRange
            : num.tryParse(
                minimumVisibleRange.toStringAsFixed(fractionDigitValue))!;
        if (minimumVisibleRange.toString().split('.').length > 1) {
          final String str = minimumVisibleRange.toString();
          final List<String>? list = str.split('.');
          minimumVisibleRange = double.parse(
              minimumVisibleRange.toStringAsFixed(numericAxis.decimalPlaces));
          if (list != null &&
              list.length > 1 &&
              (list[1] == '0' ||
                  list[1] == '00' ||
                  list[1] == '000' ||
                  list[1] == '0000' ||
                  list[1] == '00000' ||
                  minimumVisibleRange % 1 == 0)) {
            minimumVisibleRange = minimumVisibleRange.round();
          }
        }
        text = minimumVisibleRange.toString();
        if (numericAxis.numberFormat != null) {
          text = numericAxis.numberFormat!.format(minimumVisibleRange);
        }
        if (numericAxis.labelFormat != null && numericAxis.labelFormat != '') {
          text = numericAxis.labelFormat!.replaceAll(RegExp('{value}'), text);
        }
        text = axisDetails.stateProperties.chartAxis.primaryYAxisDetails
                        .isStack100 ==
                    true &&
                axisDetails.name ==
                    axisDetails
                        .stateProperties.chartAxis.primaryYAxisDetails.name
            ? '$text%'
            : text;
        axisDetails.triggerLabelRenderEvent(text, tempInterval);
      }
    }

    /// Get the maximum label of width and height in axis.
    axisDetails.calculateMaximumLabelSize(this, axisDetails.stateProperties);
    if (numericAxis.multiLevelLabels != null &&
        numericAxis.multiLevelLabels!.isNotEmpty) {
      generateMultiLevelLabels(_axisDetails);
      calculateMultiLevelLabelBounds(axisDetails);
    }
  }

  /// Calculates the visible range for an axis in chart.
  @override
  void calculateVisibleRange(Size availableSize) {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(this);
    final CartesianStateProperties stateProperties =
        axisDetails.stateProperties;
    axisDetails.setOldRangeFromRangeController();
    axisDetails.visibleRange = stateProperties.rangeChangeBySlider &&
            axisDetails.rangeMinimum != null &&
            axisDetails.rangeMaximum != null
        ? VisibleRange(axisDetails.rangeMinimum, axisDetails.rangeMaximum)
        : VisibleRange(
            axisDetails.actualRange!.minimum, axisDetails.actualRange!.maximum);
    axisDetails.visibleRange!.delta = axisDetails.actualRange!.delta;
    axisDetails.visibleRange!.interval = axisDetails.actualRange!.interval;
    bool canAutoScroll = false;
    if (axisDetails.axis.autoScrollingDelta != null &&
        axisDetails.axis.autoScrollingDelta! > 0 &&
        !stateProperties.isRedrawByZoomPan) {
      canAutoScroll = true;
      axisDetails.updateAutoScrollingDelta(
          axisDetails.axis.autoScrollingDelta!, this);
    }
    if ((!canAutoScroll || (stateProperties.zoomedState ?? false)) &&
        !(stateProperties.rangeChangeBySlider &&
            !stateProperties.canSetRangeController)) {
      axisDetails.setZoomFactorAndPosition(
          this, stateProperties.zoomedAxisRendererStates);
    }
    if (axisDetails.zoomFactor < 1 ||
        axisDetails.zoomPosition > 0 ||
        (axisDetails.axis.rangeController != null &&
                !stateProperties.renderingDetails.initialRender!) &&
            !(stateProperties.rangeChangeBySlider ||
                !stateProperties.canSetRangeController)) {
      stateProperties.zoomProgress = true;
      axisDetails.calculateZoomRange(this, availableSize);
      axisDetails.visibleRange!.interval = !canAutoScroll &&
              axisDetails.axis.enableAutoIntervalOnZooming &&
              stateProperties.zoomProgress
          ? calculateInterval(axisDetails.visibleRange!, axisDetails.axisSize)
          : axisDetails.visibleRange!.interval;
      if (axisDetails.axis.rangeController != null &&
          stateProperties.isRedrawByZoomPan &&
          stateProperties.canSetRangeController &&
          stateProperties.zoomProgress) {
        stateProperties.rangeChangedByChart = true;
        axisDetails.setRangeControllerValues(this);
      }
    }
    axisDetails.setZoomValuesFromRangeController();
  }

  /// Finds the interval of an axis.
  @override
  num calculateInterval(VisibleRange range, Size availableSize) {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(this);
    return axisDetails.calculateNumericNiceInterval(
        this, range.maximum - range.minimum, axisDetails.axisSize);
  }
}

/// This class holds the details of NumericAxis
class NumericAxisDetails extends ChartAxisRendererDetails {
  ///Argument constructor for NumericAxisDetails class
  NumericAxisDetails(this.numericAxis, ChartAxisRenderer axisRenderer,
      CartesianStateProperties stateProperties)
      : super(numericAxis, stateProperties, axisRenderer);

  /// Holds the value of axis padding
  // ignore:unused_field
  final int axisPadding = 5;

  /// Holds the value of inner padding
  // ignore:unused_field
  final int innerPadding = 5;

  @override
  late Size axisSize;

  /// Represents the value of numeric axis
  final NumericAxis numericAxis;

  /// Find the series min and max values of an series
  void findAxisMinMaxValues(SeriesRendererDetails seriesRendererDetails,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool? isXVisibleRange, bool? isYVisibleRange]) {
    final bool anchorRangeToVisiblePoints =
        seriesRendererDetails.yAxisDetails!.axis.anchorRangeToVisiblePoints;
    final String seriesType = seriesRendererDetails.seriesType;
    point.xValue = point.x;
    point.yValue = point.y;
    if (isYVisibleRange!) {
      seriesRendererDetails.minimumX ??= point.xValue;
      seriesRendererDetails.maximumX ??= point.xValue;
    }
    if ((isXVisibleRange! || !anchorRangeToVisiblePoints) &&
        !seriesType.contains('range') &&
        !seriesType.contains('hilo') &&
        !seriesType.contains('candle') &&
        seriesType != 'boxandwhisker' &&
        seriesType != 'waterfall') {
      seriesRendererDetails.minimumY ??= point.yValue;
      seriesRendererDetails.maximumY ??= point.yValue;
    }

    if (isYVisibleRange && point.xValue != null) {
      seriesRendererDetails.minimumX =
          math.min(seriesRendererDetails.minimumX!, point.xValue as num);
      seriesRendererDetails.maximumX =
          math.max(seriesRendererDetails.maximumX!, point.xValue as num);
    }
    if (isXVisibleRange || !anchorRangeToVisiblePoints) {
      if (point.yValue != null &&
          (!seriesType.contains('range') &&
              !seriesType.contains('hilo') &&
              !seriesType.contains('candle') &&
              seriesType != 'boxandwhisker' &&
              seriesType != 'waterfall')) {
        seriesRendererDetails.minimumY =
            math.min(seriesRendererDetails.minimumY!, point.yValue as num);
        seriesRendererDetails.maximumY =
            math.max(seriesRendererDetails.maximumY!, point.yValue as num);
      }
      if (point.high != null) {
        highMin = findMinValue(highMin ?? point.high, point.high);
        highMax = findMaxValue(highMax ?? point.high, point.high);
      }
      if (point.low != null) {
        lowMin = findMinValue(lowMin ?? point.low, point.low);
        lowMax = findMaxValue(lowMax ?? point.low, point.low);
      }
      if (point.maximum != null) {
        highMin = findMinValue(highMin ?? point.maximum!, point.maximum!);
        highMax = findMaxValue(highMax ?? point.maximum!, point.maximum!);
      }
      if (point.minimum != null) {
        lowMin = findMinValue(lowMin ?? point.minimum!, point.minimum!);
        lowMax = findMaxValue(lowMax ?? point.minimum!, point.minimum!);
      }
      if (seriesType == 'waterfall') {
        /// Empty point is not applicable for Waterfall series.
        point.yValue ??= 0;
        seriesRendererDetails.minimumY = findMinValue(
            seriesRendererDetails.minimumY ?? point.yValue, point.yValue);
        seriesRendererDetails.maximumY = findMaxValue(
            seriesRendererDetails.maximumY ?? point.maxYValue, point.maxYValue);
      }
      if (seriesType == 'errorbar') {
        updateErrorBarAxisRange(seriesRendererDetails, point);
      }
    }
    if (pointIndex >= dataLength - 1) {
      if (seriesType.contains('range') ||
          seriesType.contains('hilo') ||
          seriesType.contains('candle') ||
          seriesType == 'boxandwhisker') {
        lowMin ??= 0;
        lowMax ??= 5;
        highMin ??= 0;
        highMax ??= 5;
        seriesRendererDetails.minimumY = math.min(lowMin!, highMin!);
        seriesRendererDetails.maximumY = math.max(lowMax!, highMax!);
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
    if (axis.rangeController != null) {
      stateProperties.rangeChangeBySlider = true;
      axis.rangeController!.addListener(_controlListener);
    }
    final Rect containerRect =
        stateProperties.renderingDetails.chartContainerRect;
    final Rect rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    axisSize = Size(rect.width, rect.height);
    axisRenderer.calculateRange(axisRenderer);
    _calculateActualRange();
    if (actualRange != null) {
      axisRenderer.applyRangePadding(actualRange!, actualRange!.interval);
      if (type == null && type != 'AxisCross' && numericAxis.isVisible) {
        axisRenderer.generateVisibleLabels();
      }
    }
  }

  /// Calculate the required values of the actual range for numeric axis
  void _calculateActualRange() {
    min ??= 0;
    max ??= 5;

    /// Below condition is for checking whether the min and max are equal and
    /// also whether they are positive or negative in order
    /// to set the min and max as zero accordingly.
    if (min == max && min! < 0 && max! < 0) {
      max = 0;
    }
    if (min == max && min! > 0 && max! > 0) {
      min = 0;
    }

    actualRange =
        VisibleRange(numericAxis.minimum ?? min, numericAxis.maximum ?? max);
    if (axis.anchorRangeToVisiblePoints &&
        needCalculateYRange(numericAxis.minimum, numericAxis.maximum,
            stateProperties, orientation!)) {
      actualRange = calculateYRangeOnZoomX(actualRange!, this);
    }

    ///Below condition is for checking the min, max value is equal
    if (actualRange!.minimum == actualRange!.maximum) {
      actualRange!.maximum += 1;
    }

    ///Below condition is for checking the axis min value is greater than max value, then swapping min max values
    else if ((actualRange!.minimum > actualRange!.maximum) == true) {
      actualRange!.minimum = actualRange!.minimum + actualRange!.maximum;
      actualRange!.maximum = actualRange!.minimum - actualRange!.maximum;
      actualRange!.minimum = actualRange!.minimum - actualRange!.maximum;
    }
    actualRange!.delta = actualRange!.maximum - actualRange!.minimum;

    actualRange!.interval = numericAxis.interval ??
        calculateNumericNiceInterval(
            axisRenderer, actualRange!.delta, axisSize);
  }
}
