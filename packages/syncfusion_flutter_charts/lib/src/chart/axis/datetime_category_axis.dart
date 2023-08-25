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
import '../common/interactive_tooltip.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// An axis which is used to plot date-time values. It is similar to DateTimeAxis except that it
/// excludes missing dates.
///
/// This is a unique type of axis used mainly with financial series. Like [CategoryAxis], all the data
/// points are plotted with equal spaces by removing space for missing dates. Intervals and ranges
/// for the axis are calculated similar to [DateTimeAxis]. There will be no visual gaps between points
/// even when the difference between two points is more than a year.
///
/// A simple use case of this axis type is when the user wishes to visualize the working hours on an
/// employee for a month by excluding the weekends.
///
/// Provides options for label placement, interval, date format for customizing the appearance.
@immutable
class DateTimeCategoryAxis extends ChartAxis {
  /// Creating an argument constructor of DateTimeCategoryAxis class.
  DateTimeCategoryAxis(
      {String? name,
      bool? isVisible,
      AxisTitle? title,
      AxisLine? axisLine,
      ChartRangePadding? rangePadding,
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
      this.labelPlacement = LabelPlacement.betweenTicks,
      this.dateFormat,
      this.intervalType = DateTimeIntervalType.auto,
      this.autoScrollingDeltaType = DateTimeIntervalType.auto,
      int? autoScrollingDelta,
      double? borderWidth,
      Color? borderColor,
      AxisBorderType? axisBorderType,
      MultiLevelLabelStyle? multiLevelLabelStyle,
      MultiLevelLabelFormatterCallback? multiLevelLabelFormatter,
      List<DateTimeCategoricalMultiLevelLabel>? multiLevelLabels,
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
            multiLevelLabelFormatter: multiLevelLabelFormatter,
            multiLevelLabels: multiLevelLabels,
            autoScrollingMode: autoScrollingMode,
            axisLabelFormatter: axisLabelFormatter);

  /// Formats the date-time category axis labels.
  ///
  /// The axis label can be formatted with various built-in [date formats](https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html).
  ///
  /// By default, date format will be applied to the axis labels based on the interval between the data points.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(dateFormat: DateFormat.y()),
  ///        )
  ///    );
  ///}
  ///```
  final DateFormat? dateFormat;

  /// Position of the date-time category axis labels.
  ///
  /// The labels can be placed either between the ticks or at the major ticks.
  ///
  /// Defaults to `LabelPlacement.betweenTicks`.
  ///
  ///Also refer [LabelPlacement].
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(labelPlacement: LabelPlacement.onTicks),
  ///        )
  ///    );
  ///}
  ///```
  final LabelPlacement labelPlacement;

  /// Customizes the date-time category axis interval.
  ///
  /// Intervals can be set to days, hours, minutes, months, seconds, years, and auto. If it is set to auto,
  /// the interval type will be decided based on the data.
  ///
  /// Defaults to `DateTimeIntervalType.auto`.
  ///
  ///Also refer [DateTimeIntervalType].
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(intervalType: DateTimeIntervalType.years),
  ///        )
  ///    );
  ///}
  ///```
  final DateTimeIntervalType intervalType;

  /// Minimum value of the axis.
  ///
  /// The axis will start from this date and data points below this value will not be rendered.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(minimum: DateTime(2000)),
  ///        )
  ///    );
  ///}
  ///```
  final DateTime? minimum;

  /// Maximum value of the axis.
  ///
  /// The axis will end at this date and data points above this value will not be rendered.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(maximum: DateTime(2019)),
  ///        )
  ///    );
  ///}
  ///```
  final DateTime? maximum;

  /// The minimum visible value of the axis.
  ///
  /// The axis will start from this date and data points below this value will not be rendered initially.
  /// Further those data points can be viewed by panning from left to right direction.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(visibleMinimum: DateTime(2000)),
  ///        )
  ///    );
  ///}
  ///```
  final DateTime? visibleMinimum;

  /// The maximum visible value of the axis.
  ///
  /// The axis will end at this date and data points above this value will not be rendered initially.
  /// Further those data points can be viewed by panning from right to left direction.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///          primaryXAxis: DateTimeCategoryAxis(visibleMaximum: DateTime(2019)),
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
  ///           primaryXAxis: DateTimeCategoryAxis(autoScrollingDeltaType: DateTimeIntervalType.months),
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

    return other is DateTimeCategoryAxis &&
        other.name == name &&
        other.isVisible == isVisible &&
        other.title == title &&
        other.axisLine == axisLine &&
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
        other.autoScrollingMode == autoScrollingMode &&
        other.intervalType == intervalType &&
        other.axisBorderType == axisBorderType &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.multiLevelLabelStyle == multiLevelLabelStyle &&
        other.multiLevelLabels == multiLevelLabels &&
        other.multiLevelLabelFormatter == multiLevelLabelFormatter &&
        other.dateFormat == dateFormat &&
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
      autoScrollingMode,
      intervalType,
      axisBorderType,
      borderColor,
      borderWidth,
      multiLevelLabelStyle,
      multiLevelLabels,
      multiLevelLabelFormatter,
      dateFormat,
      axisLabelFormatter
    ];
    return Object.hashAll(values);
  }
}

/// Creates an axis renderer for Category axis
class DateTimeCategoryAxisRenderer extends ChartAxisRenderer {
  /// Creating an argument constructor of CategoryAxisRenderer class.
  DateTimeCategoryAxisRenderer(DateTimeCategoryAxis dateTimeCategoryAxis,
      CartesianStateProperties stateProperties) {
    _axisDetails = DateTimeCategoryAxisDetails(
        dateTimeCategoryAxis, stateProperties, this);
    AxisHelper.setAxisRendererDetails(this, _axisDetails);
  }

  late DateTimeCategoryAxisDetails _axisDetails;

  /// Applies range padding to auto, normal, additional, round, and none types.
  @override
  void applyRangePadding(VisibleRange range, num? interval) {
    ActualRangeChangedArgs rangeChangedArgs;
    if (_axisDetails.dateTimeCategoryAxis.labelPlacement ==
        LabelPlacement.betweenTicks) {
      range.minimum -= 0.5;
      range.maximum += 0.5;
      range.delta = range.maximum - range.minimum;
    }

    if (_axisDetails.dateTimeCategoryAxis.isVisible &&
        !(_axisDetails.dateTimeCategoryAxis.minimum != null &&
            _axisDetails.dateTimeCategoryAxis.maximum != null)) {
      ///Calculating range padding
      _axisDetails.applyRangePaddings(
          this, _axisDetails.stateProperties, range, interval!);
    }

    calculateVisibleRange(
        Size(_axisDetails.rect.width, _axisDetails.rect.height));

    /// Setting range as visible zoomRange
    if ((_axisDetails.dateTimeCategoryAxis.visibleMinimum != null ||
            _axisDetails.dateTimeCategoryAxis.visibleMaximum != null) &&
        (_axisDetails.dateTimeCategoryAxis.visibleMinimum !=
            _axisDetails.dateTimeCategoryAxis.visibleMaximum) &&
        (!_axisDetails.stateProperties.isRedrawByZoomPan)) {
      _axisDetails.stateProperties.isRedrawByZoomPan = false;
      _axisDetails.visibleRange!.minimum = _axisDetails.visibleMinimum != null
          ? _axisDetails.getEffectiveRange(
              DateTime.fromMillisecondsSinceEpoch(
                  _axisDetails.visibleMinimum!.toInt()),
              true)
          : _axisDetails.getEffectiveRange(
                  _axisDetails.dateTimeCategoryAxis.visibleMinimum, true) ??
              _axisDetails.actualRange!.minimum;
      _axisDetails.visibleRange!.maximum = _axisDetails.visibleMaximum != null
          ? _axisDetails.getEffectiveRange(
              DateTime.fromMillisecondsSinceEpoch(
                  _axisDetails.visibleMaximum!.toInt()),
              false)
          : _axisDetails.getEffectiveRange(
                  _axisDetails.dateTimeCategoryAxis.visibleMaximum, false) ??
              _axisDetails.actualRange!.maximum;
      if (_axisDetails.dateTimeCategoryAxis.labelPlacement ==
          LabelPlacement.betweenTicks) {
        _axisDetails.visibleRange!.minimum = _axisDetails.visibleMinimum != null
            ? _axisDetails.getEffectiveRange(
                    DateTime.fromMillisecondsSinceEpoch(
                        _axisDetails.visibleMinimum!.toInt()),
                    true)! -
                0.5
            : (_axisDetails.dateTimeCategoryAxis.visibleMinimum != null
                ? _axisDetails.getEffectiveRange(
                        _axisDetails.dateTimeCategoryAxis.visibleMinimum,
                        true)! -
                    0.5
                : _axisDetails.visibleRange!.minimum);
        _axisDetails.visibleRange!.maximum = _axisDetails.visibleMaximum != null
            ? _axisDetails.getEffectiveRange(
                    DateTime.fromMillisecondsSinceEpoch(
                        _axisDetails.visibleMaximum!.toInt()),
                    false)! +
                0.5
            : (_axisDetails.dateTimeCategoryAxis.visibleMaximum != null
                ? _axisDetails.getEffectiveRange(
                        _axisDetails.dateTimeCategoryAxis.visibleMaximum,
                        false)! +
                    0.5
                : _axisDetails.visibleRange!.maximum);
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
          _axisDetails.dateTimeCategoryAxis,
          range.minimum,
          range.maximum,
          range.interval,
          _axisDetails.orientation!);
      rangeChangedArgs.visibleMin = _axisDetails.visibleRange!.minimum;
      rangeChangedArgs.visibleMax = _axisDetails.visibleRange!.maximum;
      rangeChangedArgs.visibleInterval = _axisDetails.visibleRange!.interval;
      _axisDetails.chart.onActualRangeChanged!(rangeChangedArgs);
      _axisDetails.visibleRange!.minimum = rangeChangedArgs.visibleMin
              is DateTime
          ? _axisDetails.getEffectiveRange(rangeChangedArgs.visibleMin, true)
          : rangeChangedArgs.visibleMin;
      _axisDetails.visibleRange!.maximum = rangeChangedArgs.visibleMax
              is DateTime
          ? _axisDetails.getEffectiveRange(rangeChangedArgs.visibleMax, false)
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
    num tempInterval = _axisDetails.visibleRange!.minimum.ceil();
    num interval = _axisDetails.visibleRange!.interval;
    interval = interval.toString().split('.').length >= 2
        ? interval.toString().split('.')[1].length == 1 &&
                interval.toString().split('.')[1] == '0'
            ? interval.floor()
            : interval.ceil()
        : interval;
    int position;
    num prevInterval;
    String labelText;
    final List<AxisLabel> label = _axisDetails.visibleLabels;
    prevInterval = (label.isNotEmpty)
        ? _axisDetails
            .visibleLabels[_axisDetails.visibleLabels.length - 1].value
        : tempInterval;
    _axisDetails.dateTimeFormat =
        _axisDetails.dateTimeCategoryAxis.dateFormat ??
            getDateTimeLabelFormat(
                this, tempInterval.toInt(), prevInterval.toInt());
    for (;
        tempInterval <= _axisDetails.visibleRange!.maximum;
        tempInterval += interval) {
      if (withInRange(tempInterval, _axisDetails)) {
        position = tempInterval.round();
        if (position <= -1 ||
            (_axisDetails.labels.isNotEmpty &&
                position >= _axisDetails.labels.length)) {
          continue;
        } else if (_axisDetails.labels.isNotEmpty &&
            // ignore: unnecessary_null_comparison
            _axisDetails.labels[position] != null) {
          labelText = _axisDetails.getFormattedLabel(
              _axisDetails.labels[position], _axisDetails.dateFormat);
          _axisDetails.labels[position] = labelText;
        } else {
          continue;
        }
        _axisDetails.triggerLabelRenderEvent(
            labelText,
            tempInterval,
            _axisDetails.actualIntervalType,
            _axisDetails.dateTimeFormat!.pattern);

        /// Here the loop is terminated to avoid the format exception
        /// while there is only one data point in data source.
        if (interval == 0) {
          break;
        }
      }
    }

    /// Get the maximum label of width and height in axis.
    _axisDetails.calculateMaximumLabelSize(this, _axisDetails.stateProperties);
    if (_axisDetails.dateTimeCategoryAxis.multiLevelLabels != null &&
        _axisDetails.dateTimeCategoryAxis.multiLevelLabels!.isNotEmpty) {
      generateMultiLevelLabels(_axisDetails);
      calculateMultiLevelLabelBounds(_axisDetails);
    }
  }

  /// Finds the interval of an axis.
  @override
  num calculateInterval(VisibleRange range, Size availableSize) {
    return _axisDetails.calculateNumericNiceInterval(
        this, range.delta, availableSize);
  }
}

/// This class holds the details of DateTimeCategoryAxis
class DateTimeCategoryAxisDetails extends ChartAxisRendererDetails {
  ///Argument constructor for DateTimeCategoryAxisDetails class
  DateTimeCategoryAxisDetails(this.dateTimeCategoryAxis,
      CartesianStateProperties stateProperties, ChartAxisRenderer axisRenderer)
      : super(dateTimeCategoryAxis, stateProperties, axisRenderer) {
    labels = <String>[];
  }

  /// Holds the list of labels
  late List<String> labels;

  /// Holds the value of rect
  late Rect rect;

  /// Specifies the date time category axis
  final DateTimeCategoryAxis dateTimeCategoryAxis;

  /// Specifies the actual interval type
  late DateTimeIntervalType actualIntervalType;

  /// Specifies the date time format
  DateFormat? dateTimeFormat;

  /// Gets the value of date time format
  DateFormat get dateFormat =>
      dateTimeFormat ?? getDateTimeLabelFormat(axisRenderer);

  /// Find the series min and max values of an series
  void findAxisMinMaxValues(SeriesRendererDetails seriesRendererDetails,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool? isXVisibleRange, bool? isYVisibleRange]) {
    final bool anchorRangeToVisiblePoints =
        seriesRendererDetails.yAxisDetails!.axis.anchorRangeToVisiblePoints;
    final String seriesType = seriesRendererDetails.seriesType;

    if (!labels.contains('${point.x.microsecondsSinceEpoch}')) {
      labels.add('${point.x.microsecondsSinceEpoch}');
    }
    point.xValue = labels.indexOf('${point.x.microsecondsSinceEpoch}');
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
    setCategoryMinMaxValues(axisRenderer, isXVisibleRange, isYVisibleRange,
        point, pointIndex, dataLength, seriesRendererDetails);
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
    rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    axisSize = Size(rect.width, rect.height);
    axisRenderer.calculateRange(axisRenderer);
    _calculateActualRange();
    if (actualRange != null) {
      axisRenderer.applyRangePadding(actualRange!, actualRange!.interval);
      if (type == null &&
          type != 'AxisCross' &&
          dateTimeCategoryAxis.isVisible) {
        axisRenderer.generateVisibleLabels();
      }
    }
  }

  /// Calculate the required values of the actual range for the date-time axis
  void _calculateActualRange() {
    ///When chart series is empty, Rendering default chart with below min, max
    min ??= 0;
    max ??= 5;
    actualRange = VisibleRange(
        dateTimeCategoryAxis.minimum != null
            ? getEffectiveRange(dateTimeCategoryAxis.minimum, true)
            : min,
        dateTimeCategoryAxis.maximum != null
            ? getEffectiveRange(dateTimeCategoryAxis.maximum, false)
            : max);

    ///Below condition is for checking the min, max value is equal
    if ((actualRange!.minimum == actualRange!.maximum) &&
        (dateTimeCategoryAxis.labelPlacement == LabelPlacement.onTicks)) {
      actualRange!.maximum += 1;
    }
    if (labels.isNotEmpty) {
      final List<DateTime> startAndEnd = _getStartAndEndDate(labels);
      calculateDateTimeNiceInterval(axisRenderer, axisSize, actualRange!,
              startAndEnd[0], startAndEnd[1])
          .floor();
    } else {
      actualIntervalType = DateTimeIntervalType.days;
    }
    actualRange!.delta = actualRange!.maximum - actualRange!.minimum;
    actualRange!.interval = dateTimeCategoryAxis.interval ??
        axisRenderer.calculateInterval(
            actualRange!, Size(rect.width, rect.height));
  }

  /// Method to get the formatted labels
  String getFormattedLabel(String label, DateFormat dateFormat) {
    return dateFormat
        .format(DateTime.fromMicrosecondsSinceEpoch(int.parse(label)));
  }

  List<DateTime> _getStartAndEndDate(List<String> labels) {
    List<String> values = <String>[];
    // To avoid the format exception issue during dynamic update of charts.
    for (final String label in labels) {
      if (label.contains(RegExp(r'^-?[0-9]+$')) &&
          // The value 2592000000 refers to the milliseconds value of January 1, 1970.
          (int.parse(label)) > 2592000000) {
        values.add(label);
      } else {
        values.add(dateFormat.parse(label).microsecondsSinceEpoch.toString());
      }
    }
    values = <String>[...values]..sort((String first, String second) {
        return int.parse(first) < int.parse(second) ? -1 : 1;
      });
    return <DateTime>[
      DateTime.fromMicrosecondsSinceEpoch(int.parse(values.first)),
      DateTime.fromMicrosecondsSinceEpoch(int.parse(values.last))
    ];
  }

  /// Method to get the effective range
  num? getEffectiveRange(DateTime? rangeDate, bool needMin) {
    num index = 0;
    if (rangeDate == null) {
      return null;
    }
    for (final String label in labels) {
      final int value = int.parse(label);
      if (needMin) {
        if (value > rangeDate.microsecondsSinceEpoch) {
          if (!(labels.first == label)) {
            index++;
          }
          break;
        } else if (value < rangeDate.microsecondsSinceEpoch) {
          index = labels.indexOf(label);
        } else {
          index = labels.indexOf(label);
          break;
        }
      } else {
        if (value <= rangeDate.microsecondsSinceEpoch) {
          index = labels.indexOf(label);
        }
        if (value >= rangeDate.microsecondsSinceEpoch) {
          break;
        }
      }
    }
    return index;
  }
}
