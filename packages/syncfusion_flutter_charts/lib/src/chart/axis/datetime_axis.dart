import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
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

/// This class holds the properties of the DateTime axis.
///
/// The date-time axis uses a date-time scale and displays date-time values as axis labels in the specified format.
///
/// The range of the Date time can be customized by [minimum] and [maximum] properties, also change data label format by the [dateFormat].
///
/// Provides the options for range padding, interval, date format for customizing the appearance.
///
@immutable
class DateTimeAxis extends ChartAxis {
  /// Creating an argument constructor of DateTimeAxis class.
  DateTimeAxis(
      {String? name,
      bool? isVisible,
      AxisTitle? title,
      AxisLine? axisLine,
      ChartRangePadding? rangePadding,
      AxisLabelIntersectAction? labelIntersectAction,
      ChartDataLabelPosition? labelPosition,
      TickPosition? tickPosition,
      EdgeLabelPlacement? edgeLabelPlacement,
      double? zoomFactor,
      double? zoomPosition,
      bool? enableAutoIntervalOnZooming,
      int? labelRotation,
      bool? isInversed,
      bool? opposedPosition,
      int? minorTicksPerInterval,
      int? maximumLabels,
      double? plotOffset,
      MajorTickLines? majorTickLines,
      MinorTickLines? minorTickLines,
      MajorGridLines? majorGridLines,
      MinorGridLines? minorGridLines,
      TextStyle? labelStyle,
      this.dateFormat,
      this.intervalType = DateTimeIntervalType.auto,
      InteractiveTooltip? interactiveTooltip,
      this.labelFormat,
      this.minimum,
      this.maximum,
      LabelAlignment? labelAlignment,
      double? interval,
      this.visibleMinimum,
      this.visibleMaximum,
      dynamic crossesAt,
      String? associatedAxisName,
      bool? placeLabelsNearAxisLine,
      List<PlotBand>? plotBands,
      RangeController? rangeController,
      int? desiredIntervals,
      double? maximumLabelWidth,
      double? labelsExtent,
      this.autoScrollingDeltaType = DateTimeIntervalType.auto,
      int? autoScrollingDelta,
      double? borderWidth,
      Color? borderColor,
      AxisBorderType? axisBorderType,
      MultiLevelLabelStyle? multiLevelLabelStyle,
      MultiLevelLabelFormatterCallback? multiLevelLabelFormatter,
      List<DateTimeMultiLevelLabel>? multiLevelLabels,
      AutoScrollingMode? autoScrollingMode,
      ChartLabelFormatterCallback? axisLabelFormatter})
      : super(
            name: name,
            isVisible: isVisible,
            isInversed: isInversed,
            opposedPosition: opposedPosition,
            rangePadding: rangePadding,
            plotOffset: plotOffset,
            labelRotation: labelRotation,
            labelIntersectAction: labelIntersectAction,
            minorTicksPerInterval: minorTicksPerInterval,
            maximumLabels: maximumLabels,
            labelStyle: labelStyle,
            title: title,
            labelAlignment: labelAlignment,
            axisLine: axisLine,
            majorTickLines: majorTickLines,
            minorTickLines: minorTickLines,
            majorGridLines: majorGridLines,
            minorGridLines: minorGridLines,
            edgeLabelPlacement: edgeLabelPlacement,
            labelPosition: labelPosition,
            tickPosition: tickPosition,
            zoomFactor: zoomFactor,
            zoomPosition: zoomPosition,
            enableAutoIntervalOnZooming: enableAutoIntervalOnZooming,
            interactiveTooltip: interactiveTooltip,
            interval: interval,
            crossesAt: crossesAt,
            associatedAxisName: associatedAxisName,
            placeLabelsNearAxisLine: placeLabelsNearAxisLine,
            plotBands: plotBands,
            rangeController: rangeController,
            desiredIntervals: desiredIntervals,
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

  /// Formats the date-time axis labels. The default data-time axis label can be formatted
  /// with various built-in date formats.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(dateFormat: DateFormat.y()),
  ///        )
  ///    );
  ///}
  ///```
  final DateFormat? dateFormat;

  /// Formats the date time-axis labels. The labels can be customized by adding desired
  /// text to prefix or suffix.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(labelFormat: '{value}M'),
  ///        )
  ///    );
  ///}
  ///```
  final String? labelFormat;

  /// Customizes the date-time axis intervals. Intervals can be set to days, hours,
  /// milliseconds, minutes, months, seconds, years, and auto. If it is set to auto,
  /// interval type will be decided based on the data.
  ///
  /// Defaults to `DateTimeIntervalType.auto`.
  ///
  /// Also refer [DateTimeIntervalType].
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(intervalType: DateTimeIntervalType.years),
  ///        )
  ///    );
  ///}
  ///```
  final DateTimeIntervalType intervalType;

  /// Minimum value of the axis. The axis will start from this date.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(minimum: DateTime(2000)),
  ///        )
  ///    );
  ///}
  ///```
  final DateTime? minimum;

  /// Maximum value of the axis. The axis will end at this date.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(maximum: DateTime(2019)),
  ///        )
  ///    );
  ///}
  ///```
  final DateTime? maximum;

  /// The minimum visible value of the axis. The axis will be rendered from this date initially.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(visibleMinimum: DateTime(2000)),
  ///        )
  ///    );
  ///}
  ///```
  final DateTime? visibleMinimum;

  /// The maximum visible value of the axis. The axis will be rendered from this date initially.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///          primaryXAxis: DateTimeAxis(visibleMaximum: DateTime(2019)),
  ///        )
  ///    );
  ///}
  ///```
  final DateTime? visibleMaximum;

  /// Defines the type of delta value in the DateTime axis.
  ///
  /// For example, if the [autoScrollingDelta] value is 5 and [autoScrollingDeltaType] is set to
  /// `DateTimeIntervalType.days`, the data points with 5 days of values will be displayed.
  ///
  /// The value can be set to years, months, days, hours, minutes, seconds and auto.
  ///
  /// Defaults to `DateTimeIntervalType.auto` and the delta will be calculated automatically based on the data.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(autoScrollingDeltaType: DateTimeIntervalType.months),
  ///        )
  ///    );
  ///}
  ///```
  final DateTimeIntervalType autoScrollingDeltaType;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is DateTimeAxis &&
        other.name == name &&
        other.isVisible == isVisible &&
        other.title == title &&
        other.axisLine == axisLine &&
        other.rangePadding == rangePadding &&
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
        other.dateFormat == dateFormat &&
        other.intervalType == intervalType &&
        other.autoScrollingDelta == autoScrollingDelta &&
        other.enableAutoIntervalOnZooming == enableAutoIntervalOnZooming &&
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
      rangePadding,
      labelIntersectAction,
      labelPosition,
      tickPosition,
      edgeLabelPlacement,
      zoomFactor,
      zoomPosition,
      enableAutoIntervalOnZooming,
      labelRotation,
      isInversed,
      opposedPosition,
      minorTicksPerInterval,
      maximumLabels,
      plotOffset,
      majorTickLines,
      minorTickLines,
      majorGridLines,
      minorGridLines,
      labelStyle,
      dateFormat,
      intervalType,
      interactiveTooltip,
      labelFormat,
      minimum,
      maximum,
      labelAlignment,
      interval,
      visibleMinimum,
      visibleMaximum,
      crossesAt,
      associatedAxisName,
      placeLabelsNearAxisLine,
      plotBands,
      rangeController,
      desiredIntervals,
      maximumLabelWidth,
      labelsExtent,
      autoScrollingDeltaType,
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

/// Creates an axis renderer for Datetime axis
class DateTimeAxisRenderer extends ChartAxisRenderer {
  /// Creating an argument constructor of DateTimeAxisRenderer class.
  DateTimeAxisRenderer(
      DateTimeAxis dateTimeAxis, CartesianStateProperties stateProperties) {
    _axisDetails = DateTimeAxisDetails(dateTimeAxis, this, stateProperties);
    AxisHelper.setAxisRendererDetails(this, _axisDetails);
  }

  late DateTimeAxisDetails _axisDetails;

  /// Applies range padding to auto, normal, additional, round, and none types.
  @override
  void applyRangePadding(VisibleRange range, num? interval) {
    _axisDetails.min = range.minimum.toInt();
    _axisDetails.max = range.maximum.toInt();
    ActualRangeChangedArgs rangeChangedArgs;
    if (_axisDetails.dateTimeAxis.minimum == null &&
        _axisDetails.dateTimeAxis.maximum == null) {
      final ChartRangePadding rangePadding =
          _axisDetails.calculateRangePadding(this, _axisDetails.chart);
      final DateTime minimum =
          DateTime.fromMillisecondsSinceEpoch(_axisDetails.min!.toInt());
      final DateTime maximum =
          DateTime.fromMillisecondsSinceEpoch(_axisDetails.max!.toInt());
      if (rangePadding == ChartRangePadding.none) {
        _axisDetails.min = minimum.millisecondsSinceEpoch;
        _axisDetails.max = maximum.millisecondsSinceEpoch;
      } else if (rangePadding == ChartRangePadding.additional ||
          rangePadding == ChartRangePadding.round) {
        switch (_axisDetails.actualIntervalType) {
          case DateTimeIntervalType.years:
            _axisDetails._calculateYear(
                minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.months:
            _axisDetails._calculateMonth(
                minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.days:
            _axisDetails._calculateDay(
                minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.hours:
            _axisDetails._calculateHour(
                minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.minutes:
            _axisDetails._calculateMinute(
                minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.seconds:
            _axisDetails._calculateSecond(
                minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.milliseconds:
            _axisDetails._calculateMilliSecond(
                minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.auto:
            break;
        }
      }
    }
    range.minimum = _axisDetails.min;
    range.maximum = _axisDetails.max;
    range.delta = range.maximum - range.minimum;

    calculateVisibleRange(_axisDetails.axisSize);

    /// Setting range as visible zoomRange
    if ((_axisDetails.dateTimeAxis.visibleMinimum != null ||
            _axisDetails.dateTimeAxis.visibleMaximum != null) &&
        (_axisDetails.dateTimeAxis.visibleMinimum !=
            _axisDetails.dateTimeAxis.visibleMaximum) &&
        (!_axisDetails.stateProperties.isRedrawByZoomPan)) {
      _axisDetails.stateProperties.isRedrawByZoomPan = false;
      _axisDetails.visibleRange!.minimum = _axisDetails.visibleMinimum ??
          (_axisDetails.dateTimeAxis.visibleMinimum != null
              ? _axisDetails.dateTimeAxis.visibleMinimum!.millisecondsSinceEpoch
              : _axisDetails.actualRange!.minimum);
      _axisDetails.visibleRange!.maximum = _axisDetails.visibleMaximum ??
          (_axisDetails.dateTimeAxis.visibleMaximum != null
              ? _axisDetails.dateTimeAxis.visibleMaximum!.millisecondsSinceEpoch
              : _axisDetails.actualRange!.maximum);
      _axisDetails.visibleRange!.delta = _axisDetails.visibleRange!.maximum -
          _axisDetails.visibleRange!.minimum;
      _axisDetails.visibleRange!.interval =
          calculateInterval(_axisDetails.visibleRange!, _axisDetails.axisSize);
      _axisDetails.visibleRange!.interval =
          interval != null && interval % 1 != 0
              ? interval
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
          _axisDetails.dateTimeAxis,
          range.minimum,
          range.maximum,
          range.interval,
          _axisDetails.orientation!);
      rangeChangedArgs.visibleMin = _axisDetails.visibleRange!.minimum;
      rangeChangedArgs.visibleMax = _axisDetails.visibleRange!.maximum;
      rangeChangedArgs.visibleInterval = _axisDetails.visibleRange!.interval;
      _axisDetails.chart.onActualRangeChanged!(rangeChangedArgs);
      _axisDetails.visibleRange!.minimum =
          rangeChangedArgs.visibleMin is DateTime
              ? rangeChangedArgs.visibleMin.millisecondsSinceEpoch
              : rangeChangedArgs.visibleMin;
      _axisDetails.visibleRange!.maximum =
          rangeChangedArgs.visibleMax is DateTime
              ? rangeChangedArgs.visibleMax.millisecondsSinceEpoch
              : rangeChangedArgs.visibleMax;
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

  /// Calculates the visible range for an axis in chart.
  @override
  void calculateVisibleRange(Size availableSize) {
    calculateDateTimeVisibleRange(availableSize, this);
  }

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    _axisDetails.visibleLabels = <AxisLabel>[];
    num prevInterval;
    final List<AxisLabel> label = _axisDetails.visibleLabels;
    int interval = _axisDetails.visibleRange!.minimum;
    interval = _axisDetails._alignRangeStart(
        this, interval, _axisDetails.visibleRange!.interval);
    while (interval <= _axisDetails.visibleRange!.maximum) {
      if (withInRange(interval, _axisDetails)) {
        prevInterval = (label.isNotEmpty)
            ? _axisDetails
                .visibleLabels[_axisDetails.visibleLabels.length - 1].value
            : interval;
        final DateFormat format = _axisDetails.dateTimeAxis.dateFormat ??
            getDateTimeLabelFormat(this, interval, prevInterval.toInt());

        String labelText =
            format.format(DateTime.fromMillisecondsSinceEpoch(interval));
        if (_axisDetails.dateTimeAxis.labelFormat != null &&
            _axisDetails.dateTimeAxis.labelFormat != '') {
          labelText = _axisDetails.dateTimeAxis.labelFormat!
              .replaceAll(RegExp('{value}'), labelText);
        }

        _axisDetails.triggerLabelRenderEvent(labelText, interval,
            _axisDetails.actualIntervalType, format.pattern!);
      }
      interval = _axisDetails
          ._increaseDateTimeInterval(
              this, interval, _axisDetails.visibleRange!.interval)
          .millisecondsSinceEpoch;
    }

    /// Get the maximum label of width and height in axis.
    _axisDetails.calculateMaximumLabelSize(this, _axisDetails.stateProperties);
    if (_axisDetails.dateTimeAxis.multiLevelLabels != null &&
        _axisDetails.dateTimeAxis.multiLevelLabels!.isNotEmpty) {
      generateMultiLevelLabels(_axisDetails);
      calculateMultiLevelLabelBounds(_axisDetails);
    }
  }

  /// Finds the interval of an axis.
  @override
  num calculateInterval(VisibleRange range, Size availableSize) =>
      calculateDateTimeNiceInterval(this, _axisDetails.axisSize, range).floor();
}

/// Represents the date time axis details
class DateTimeAxisDetails extends ChartAxisRendererDetails {
  ///Argument constructor for DateTimeAxisDetails class
  DateTimeAxisDetails(this.dateTimeAxis, ChartAxisRenderer axisRenderer,
      CartesianStateProperties stateProperties)
      : super(dateTimeAxis, stateProperties, axisRenderer);

  /// Holds the value of actual interval type
  late DateTimeIntervalType actualIntervalType;

  /// Holds the value of date time interval
  late int dateTimeInterval;

  /// Specifies the value of date time axis
  final DateTimeAxis dateTimeAxis;

  /// To check the series has only one data point
  bool isSingleDataPoint = false;

  /// Find the series min and max values of an series
  void findAxisMinMaxValues(SeriesRendererDetails seriesRendererDetails,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool? isXVisibleRange, bool? isYVisibleRange]) {
    isSingleDataPoint = seriesRendererDetails.dataPoints.length == 1;
    if (point.x != null) {
      point.xValue = (point.x).millisecondsSinceEpoch;
    }
    final bool anchorRangeToVisiblePoints =
        seriesRendererDetails.yAxisDetails!.axis.anchorRangeToVisiblePoints;
    final String seriesType = seriesRendererDetails.seriesType;
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
        highMin = math.min(highMin ?? point.high, point.high);
        highMax = math.max(highMax ?? point.high, point.high);
      }
      if (point.low != null) {
        lowMin = math.min(lowMin ?? point.low, point.low);
        lowMax = math.max(lowMax ?? point.low, point.low);
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
        seriesRendererDetails.minimumY = math.min(
            (seriesRendererDetails.minimumY ?? point.yValue) as num,
            point.yValue as num);
        seriesRendererDetails.maximumY = math.max(
            seriesRendererDetails.maximumY ?? point.maxYValue, point.maxYValue);
      } else if (seriesType == 'errorbar') {
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
      seriesRendererDetails.minimumX ??= 2717008000;
      seriesRendererDetails.maximumX ??= 13085008000;
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

  /// Calculate axis range and interval
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
      if (type == null && type != 'AxisCross' && dateTimeAxis.isVisible) {
        axisRenderer.generateVisibleLabels();
      }
    }
  }

  /// Calculate the required values of the actual range for the date-time axis
  void _calculateActualRange() {
    ///When chart series is empty, Rendering default chart with below min, max
    min ??= 2717008000;
    max ??= 13085008000;
    //Default date-time value (January 1, 1970) converted into milliseconds
    const int defaultTimeStamp = 2592000000;
    actualRange = VisibleRange(
        dateTimeAxis.minimum != null
            ? dateTimeAxis.minimum!.millisecondsSinceEpoch
            : min,
        dateTimeAxis.maximum != null
            ? dateTimeAxis.maximum!.millisecondsSinceEpoch
            : max);
    if (actualRange!.minimum == actualRange!.maximum) {
      if (isSingleDataPoint &&
          dateTimeAxis.autoScrollingDelta != null &&
          dateTimeAxis.autoScrollingDelta! > 0) {
        final num minMilliSeconds = const Duration(days: 1).inMilliseconds;
        actualRange!.minimum = actualRange!.minimum - minMilliSeconds;
      } else {
        actualRange!.minimum = actualRange!.minimum - defaultTimeStamp;
        actualRange!.maximum = actualRange!.maximum + defaultTimeStamp;
      }
    }
    dateTimeInterval =
        calculateDateTimeNiceInterval(axisRenderer, axisSize, actualRange!)
            .floor();
    actualRange!.interval = dateTimeAxis.interval ?? dateTimeInterval;
    actualRange!.delta = actualRange!.maximum - actualRange!.minimum;
  }

  /// Returns the range start values based on actual interval type
  int _alignRangeStart(
      DateTimeAxisRenderer axisRenderer, int startDate, num interval) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(startDate);
    switch (axisRenderer._axisDetails.actualIntervalType) {
      case DateTimeIntervalType.years:
        final int year =
            ((dateTime.year / interval).floor() * interval).floor();
        dateTime = DateTime(year, dateTime.month, dateTime.day);
        break;
      case DateTimeIntervalType.months:
        final int month = ((dateTime.month / interval) * interval).floor();
        dateTime = DateTime(dateTime.year, month, dateTime.day);
        break;
      case DateTimeIntervalType.days:
        final int day = ((dateTime.day / interval) * interval).floor();
        dateTime = DateTime(dateTime.year, dateTime.month, day);
        break;
      case DateTimeIntervalType.hours:
        final int hour =
            ((dateTime.hour / interval).floor() * interval).floor();
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, hour);
        break;
      case DateTimeIntervalType.minutes:
        final int minute =
            ((dateTime.minute / interval).floor() * interval).floor();
        dateTime = DateTime(
            dateTime.year, dateTime.month, dateTime.day, dateTime.hour, minute);
        break;
      case DateTimeIntervalType.seconds:
        final int second =
            ((dateTime.second / interval).floor() * interval).floor();
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, second);
        break;
      case DateTimeIntervalType.milliseconds:
        final int millisecond =
            ((dateTime.millisecond / interval).floor() * interval).floor();
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second, millisecond);
        break;
      case DateTimeIntervalType.auto:
        break;
    }
    return dateTime.millisecondsSinceEpoch;
  }

  /// Increase the range interval based on actual interval type
  DateTime _increaseDateTimeInterval(
      DateTimeAxisRenderer axisRenderer, int value, num dateInterval) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    axisRenderer._axisDetails.visibleRange!.interval = dateInterval;
    final bool isIntervalDecimal = dateInterval % 1 == 0;
    final num interval = dateInterval;
    if (isIntervalDecimal) {
      final int interval = dateInterval.floor();
      switch (axisRenderer._axisDetails.actualIntervalType) {
        case DateTimeIntervalType.years:
          dateTime = DateTime(dateTime.year + interval, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);
          break;
        case DateTimeIntervalType.months:
          dateTime = DateTime(dateTime.year, dateTime.month + interval,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);
          break;
        case DateTimeIntervalType.days:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day + interval,
              dateTime.hour,
              dateTime.minute,
              dateTime.second);
          break;
        case DateTimeIntervalType.hours:
          dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
              dateTime.hour + interval, dateTime.minute, dateTime.second);
          break;
        case DateTimeIntervalType.minutes:
          dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
              dateTime.hour, dateTime.minute + interval, dateTime.second);
          break;
        case DateTimeIntervalType.seconds:
          dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
              dateTime.hour, dateTime.minute, dateTime.second + interval);
          break;
        case DateTimeIntervalType.milliseconds:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              dateTime.millisecond + interval);
          break;
        case DateTimeIntervalType.auto:
          break;
      }
    } else {
      switch (axisRenderer._axisDetails.actualIntervalType) {
        case DateTimeIntervalType.years:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month + (interval * 12).floor(),
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second);
          break;
        case DateTimeIntervalType.months:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day + (interval * 30).floor(),
              dateTime.hour,
              dateTime.minute,
              dateTime.second);
          break;
        case DateTimeIntervalType.days:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour + (interval * 24).floor(),
              dateTime.minute,
              dateTime.second);
          break;
        case DateTimeIntervalType.hours:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute + (interval * 60).floor(),
              dateTime.second);
          break;
        case DateTimeIntervalType.minutes:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second + (interval * 60).floor());
          break;
        case DateTimeIntervalType.seconds:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              (interval * 1000).floor());
          break;
        case DateTimeIntervalType.milliseconds:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              dateTime.millisecond + interval.floor());
          break;
        case DateTimeIntervalType.auto:
          break;
      }
    }
    return dateTime;
  }

  /// Calculate year
  void _calculateYear(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startYear = minimum.year;
    final int endYear = maximum.year;
    if (rangePadding == ChartRangePadding.additional) {
      min = DateTime(startYear - interval).millisecondsSinceEpoch;
      max = DateTime(endYear + interval).millisecondsSinceEpoch;
    } else {
      min = DateTime(startYear, 0, 0).millisecondsSinceEpoch;
      max = DateTime(endYear, 11, 30, 23, 59, 59).millisecondsSinceEpoch;
    }
  }

  /// Calculate month
  void _calculateMonth(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startMonth = minimum.month;
    final int endMonth = maximum.month;
    if (rangePadding == ChartRangePadding.round) {
      min = DateTime(minimum.year, startMonth, 0).millisecondsSinceEpoch;
      max = DateTime(maximum.year, endMonth,
              DateTime(maximum.year, maximum.month, 0).day, 23, 59, 59)
          .millisecondsSinceEpoch;
    } else {
      min = DateTime(minimum.year, startMonth + (-interval))
          .millisecondsSinceEpoch;
      max = DateTime(maximum.year, endMonth + interval, endMonth == 2 ? 28 : 30)
          .millisecondsSinceEpoch;
    }
  }

  /// Calculate day
  void _calculateDay(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startDay = minimum.day;
    final int endDay = maximum.day;
    if (rangePadding == ChartRangePadding.round) {
      min = DateTime(minimum.year, minimum.month, startDay)
          .millisecondsSinceEpoch;
      max = DateTime(maximum.year, maximum.month, endDay, 23, 59, 59)
          .millisecondsSinceEpoch;
    } else {
      min = DateTime(minimum.year, minimum.month, startDay + (-interval))
          .millisecondsSinceEpoch;
      max = DateTime(maximum.year, maximum.month, endDay + interval)
          .millisecondsSinceEpoch;
    }
  }

  /// Calculate hour
  void _calculateHour(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startHour = ((minimum.hour / interval) * interval).toInt();
    final int endHour = maximum.hour + (minimum.hour - startHour).toInt();
    if (rangePadding == ChartRangePadding.round) {
      min = DateTime(minimum.year, minimum.month, minimum.day, startHour)
          .millisecondsSinceEpoch;
      max =
          DateTime(maximum.year, maximum.month, maximum.day, startHour, 59, 59)
              .millisecondsSinceEpoch;
    } else {
      min = DateTime(
              minimum.year, minimum.month, minimum.day, startHour + (-interval))
          .millisecondsSinceEpoch;
      max =
          DateTime(maximum.year, maximum.month, maximum.day, endHour + interval)
              .millisecondsSinceEpoch;
    }
  }

  /// Calculate minute
  void _calculateMinute(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startMinute = ((minimum.minute / interval) * interval).toInt();
    final int endMinute =
        maximum.minute + (minimum.minute - startMinute).toInt();
    if (rangePadding == ChartRangePadding.round) {
      min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              startMinute)
          .millisecondsSinceEpoch;
      max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              endMinute, 59)
          .millisecondsSinceEpoch;
    } else {
      min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              startMinute + (-interval))
          .millisecondsSinceEpoch;
      max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              endMinute + interval)
          .millisecondsSinceEpoch;
    }
  }

  /// Calculate second
  void _calculateSecond(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startSecond = ((minimum.second / interval) * interval).toInt();
    final int endSecond =
        maximum.second + (minimum.second - startSecond).toInt();
    if (rangePadding == ChartRangePadding.round) {
      min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              minimum.minute, startSecond)
          .millisecondsSinceEpoch;
      max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              maximum.minute, endSecond)
          .millisecondsSinceEpoch;
    } else {
      min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              minimum.minute, startSecond + (-interval))
          .millisecondsSinceEpoch;
      max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              maximum.minute, endSecond + interval)
          .millisecondsSinceEpoch;
    }
  }

  /// Calculate millisecond
  void _calculateMilliSecond(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startMilliSecond =
        ((minimum.millisecond / interval) * interval).toInt();
    final int endMilliSecond =
        maximum.millisecond + (minimum.millisecond - startMilliSecond).toInt();
    if (rangePadding == ChartRangePadding.round) {
      min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              minimum.minute, minimum.second, startMilliSecond)
          .millisecondsSinceEpoch;
      max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              maximum.minute, maximum.second, endMilliSecond)
          .millisecondsSinceEpoch;
    } else {
      min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              minimum.minute, minimum.second, startMilliSecond + (-interval))
          .millisecondsSinceEpoch;
      max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              maximum.minute, maximum.second, endMilliSecond + interval)
          .millisecondsSinceEpoch;
    }
  }

  ///Auto Scrolling feature
  void updateScrollingDelta() {
    if (dateTimeAxis.autoScrollingDelta != null &&
        dateTimeAxis.autoScrollingDelta! > 0) {
      final DateTimeIntervalType intervalType =
          dateTimeAxis.autoScrollingDeltaType == DateTimeIntervalType.auto
              ? actualIntervalType
              : dateTimeAxis.autoScrollingDeltaType;
      int scrollingDelta;
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(visibleRange!.maximum);
      switch (intervalType) {
        case DateTimeIntervalType.years:
          dateTime = DateTime(
              dateTime.year - dateTimeAxis.autoScrollingDelta!,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              dateTime.millisecond,
              dateTime.microsecond);
          scrollingDelta =
              visibleRange!.maximum - dateTime.millisecondsSinceEpoch;
          break;
        case DateTimeIntervalType.months:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month - dateTimeAxis.autoScrollingDelta!,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              dateTime.millisecond,
              dateTime.microsecond);
          scrollingDelta =
              visibleRange!.maximum - dateTime.millisecondsSinceEpoch;
          break;
        case DateTimeIntervalType.days:
          scrollingDelta =
              Duration(days: dateTimeAxis.autoScrollingDelta!).inMilliseconds;
          break;
        case DateTimeIntervalType.hours:
          scrollingDelta =
              Duration(hours: dateTimeAxis.autoScrollingDelta!).inMilliseconds;
          break;
        case DateTimeIntervalType.minutes:
          scrollingDelta = Duration(minutes: dateTimeAxis.autoScrollingDelta!)
              .inMilliseconds;
          break;
        case DateTimeIntervalType.seconds:
          scrollingDelta = Duration(seconds: dateTimeAxis.autoScrollingDelta!)
              .inMilliseconds;
          break;
        case DateTimeIntervalType.milliseconds:
          scrollingDelta =
              Duration(milliseconds: dateTimeAxis.autoScrollingDelta!)
                  .inMilliseconds;
          break;
        case DateTimeIntervalType.auto:
          scrollingDelta = dateTimeAxis.autoScrollingDelta!;
          break;
      }
      super.updateAutoScrollingDelta(scrollingDelta, axisRenderer);
    }
  }
}
