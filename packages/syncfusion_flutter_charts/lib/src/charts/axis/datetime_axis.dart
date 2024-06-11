import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:syncfusion_flutter_core/core.dart';

import '../common/callbacks.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'axis.dart';
import 'multi_level_labels.dart';
import 'plot_band.dart';

// This class holds the properties of the DateTime axis.
///
/// The date-time axis uses a date-time scale and displays date-time values as
/// axis labels in the specified format.
///
/// The range of the Date time can be customized by [minimum] and [maximum]
/// properties, also change data label format by the [dateFormat].
///
/// Provides the options for range padding, interval, date format for
/// customizing the appearance.
class DateTimeAxis extends ChartAxis {
  /// Creating an argument constructor of [DateTimeAxis] class.
  const DateTimeAxis({
    super.key,
    super.name,
    super.isVisible = true,
    super.title,
    super.axisLine,
    super.rangePadding,
    super.labelIntersectAction,
    super.labelPosition,
    super.tickPosition,
    super.edgeLabelPlacement,
    super.initialZoomFactor,
    super.initialZoomPosition,
    super.enableAutoIntervalOnZooming,
    super.labelRotation,
    super.isInversed,
    super.opposedPosition,
    super.minorTicksPerInterval,
    super.maximumLabels,
    super.plotOffset,
    super.majorTickLines,
    super.minorTickLines,
    super.majorGridLines,
    super.minorGridLines,
    super.labelStyle,
    this.dateFormat,
    this.intervalType = DateTimeIntervalType.auto,
    super.interactiveTooltip,
    this.labelFormat,
    this.minimum,
    this.maximum,
    super.labelAlignment,
    super.interval,
    this.initialVisibleMinimum,
    this.initialVisibleMaximum,
    super.crossesAt,
    super.associatedAxisName,
    super.placeLabelsNearAxisLine,
    super.plotBands,
    super.rangeController,
    super.desiredIntervals,
    super.maximumLabelWidth,
    super.labelsExtent,
    this.autoScrollingDeltaType = DateTimeIntervalType.auto,
    super.autoScrollingDelta,
    super.borderWidth,
    super.borderColor,
    super.axisBorderType,
    super.multiLevelLabelStyle,
    super.multiLevelLabelFormatter,
    this.multiLevelLabels,
    super.autoScrollingMode,
    super.axisLabelFormatter,
    this.onRendererCreated,
  }) : assert(
            (initialVisibleMaximum == null && initialVisibleMinimum == null) ||
                autoScrollingDelta == null,
            'Both properties have the same behavior to display the visible data points, use any one of the properties');

  /// Formats the date-time axis labels. The default data-time axis label can be
  /// formatted with various built-in date formats.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(dateFormat: DateFormat.y()),
  ///        )
  ///    );
  /// }
  /// ```
  final DateFormat? dateFormat;

  /// Formats the date time-axis labels. The labels can be customized by adding
  /// desired text to prefix or suffix.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(labelFormat: '{value} AM'),
  ///        )
  ///    );
  /// }
  /// ```
  final String? labelFormat;

  /// Customizes the date-time axis intervals. Intervals can be set to days,
  /// hours, milliseconds, minutes, months, seconds, years, and auto. If it is
  /// set to auto, interval type will be decided based on the data.
  ///
  /// Defaults to `DateTimeIntervalType.auto`.
  ///
  /// Also refer [DateTimeIntervalType].
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis:
  ///             DateTimeAxis(intervalType: DateTimeIntervalType.years),
  ///        )
  ///    );
  /// }
  /// ```
  final DateTimeIntervalType intervalType;

  /// Minimum value of the axis. The axis will start from this date.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(minimum: DateTime(2000)),
  ///        )
  ///    );
  /// }
  /// ```
  final DateTime? minimum;

  /// Maximum value of the axis. The axis will end at this date.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(maximum: DateTime(2019)),
  ///        )
  ///    );
  /// }
  /// ```
  final DateTime? maximum;

  /// The minimum visible value of the axis. The axis is rendered from this value initially, and
  /// it applies only during load time. The value will not be updated when zooming or panning.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: DateTimeAxis(initialVisibleMinimum: DateTime(2019)),
  ///        )
  ///    );
  /// }
  /// ```
  ///
  /// Use the [onRendererCreated] callback, as shown in the code below, to update the visible
  /// minimum value dynamically.
  ///
  /// ```dart
  /// DateTimeAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(
  ///             initialVisibleMinimum: DateTime(2019),
  ///             onRendererCreated: (DateTimeAxisController controller) {
  ///               axisController = controller;
  ///             },
  ///           ),
  ///           series: <CartesianSeries<SalesData, DateTime>>[
  ///             LineSeries<SalesData, DateTime>(
  ///               dataSource: data,
  ///               xValueMapper: (SalesData sales, _) => sales.year,
  ///               yValueMapper: (SalesData sales, _) => sales.sales,
  ///             ),
  ///           ],
  ///         ),
  ///         TextButton(
  ///           onPressed: () {
  ///             if (axisController != null) {
  ///              axisController!.visibleMinimum = DateTime(2017);
  ///            }
  ///           },
  ///           child: const Text('Update Axis Range'),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final DateTime? initialVisibleMinimum;

  /// The maximum visible value of the axis. The axis is rendered from this value initially, and
  /// it applies only during load time. The value will not be updated when zooming or panning.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: DateTimeAxis(initialVisibleMaximum: DateTime(2020)),
  ///        ));
  /// }
  /// ```
  ///
  /// Use the [onRendererCreated] callback, as shown in the code below, to update the visible
  /// maximum value dynamically
  ///
  /// ```dart
  /// DateTimeAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(
  ///             initialVisibleMaximum: DateTime(2020),
  ///             onRendererCreated: (DateTimeAxisController controller) {
  ///               axisController = controller;
  ///             },
  ///           ),
  ///           series: <CartesianSeries<SalesData, DateTime>>[
  ///             LineSeries<SalesData, DateTime>(
  ///               dataSource: data,
  ///               xValueMapper: (SalesData sales, _) => sales.year,
  ///               yValueMapper: (SalesData sales, _) => sales.sales,
  ///             ),
  ///           ],
  ///         ),
  ///         TextButton(
  ///           onPressed: () {
  ///             if (axisController != null) {
  ///              axisController!.visibleMaximum = DateTime(2024);
  ///            }
  ///           },
  ///           child: const Text('Update Axis Range'),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final DateTime? initialVisibleMaximum;

  /// Defines the type of delta value in the DateTime axis.
  ///
  /// For example, if the [autoScrollingDelta] value is 5 and
  /// [autoScrollingDeltaType] is set to `DateTimeIntervalType.days`, the data
  // points with 5 days of values will be displayed.
  ///
  /// The value can be set to years, months, days, hours, minutes,
  /// seconds and auto.
  ///
  /// Defaults to `DateTimeIntervalType.auto` and the delta will be calculated
  /// automatically based on the data.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis:
  ///         DateTimeAxis(autoScrollingDeltaType: DateTimeIntervalType.months),
  ///        )
  ///    );
  /// }
  /// ```
  final DateTimeIntervalType autoScrollingDeltaType;

  /// Provides the option to group the axis labels. You can customize the start,
  /// end value of a multi-level label, text, and level of
  /// the multi-level labels.
  ///
  /// The `start` and `end` values for the category axis need to be string type,
  /// in the case of date-time or date-time category axes need to be date-time
  /// and in the case of numeric or logarithmic axes needs to be double.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: DateTimeAxis(
  ///         multiLevelLabels: <DateTimeMultiLevelLabel>[
  ///           DateTimeMultiLevelLabel(
  ///             start: DateTime(2010, 1, 1),
  ///             end: DateTime(2010, 2, 1),
  ///             text: 'First'
  ///           ),
  ///           DateTimeMultiLevelLabel(
  ///             start: DateTime(2011, 1, 1),
  ///             end: DateTime(2011, 2, 1),
  ///             text: 'Second'
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final List<DateTimeMultiLevelLabel>? multiLevelLabels;

  final Function(DateTimeAxisController)? onRendererCreated;

  @override
  RenderDateTimeAxis createRenderer() {
    return RenderDateTimeAxis();
  }

  @override
  RenderDateTimeAxis createRenderObject(BuildContext context) {
    final RenderDateTimeAxis renderer =
        super.createRenderObject(context) as RenderDateTimeAxis;
    renderer
      ..dateFormat = dateFormat
      ..labelFormat = labelFormat
      ..intervalType = intervalType
      ..minimum = minimum
      ..maximum = maximum
      ..initialVisibleMinimum = initialVisibleMinimum
      ..initialVisibleMaximum = initialVisibleMaximum
      ..autoScrollingDeltaType = autoScrollingDeltaType
      ..multiLevelLabels = multiLevelLabels
      ..onRendererCreated = onRendererCreated;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderDateTimeAxis renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..dateFormat = dateFormat
      ..labelFormat = labelFormat
      ..intervalType = intervalType
      ..minimum = minimum
      ..maximum = maximum
      ..autoScrollingDeltaType = autoScrollingDeltaType
      ..multiLevelLabels = multiLevelLabels;
  }
}

class RenderDateTimeAxis extends RenderChartAxis {
  final List<AxisMultilevelLabel> _multilevelLabels = <AxisMultilevelLabel>[];

  DateTimeIntervalType get visibleIntervalType => _visibleIntervalType;
  DateTimeIntervalType _visibleIntervalType = DateTimeIntervalType.auto;

  @override
  DateTimeAxisController get controller => _controller;
  late final DateTimeAxisController _controller = DateTimeAxisController(this);

  @override
  @nonVirtual
  bool get canAnimate =>
      super.canAnimate ||
      (initialVisibleMinimum != null && initialVisibleMaximum != null);

  DateFormat? get dateFormat => _dateFormat;
  DateFormat? _dateFormat;
  set dateFormat(DateFormat? value) {
    if (_dateFormat != value) {
      _dateFormat = value;
      markNeedsLayout();
    }
  }

  String? get labelFormat => _labelFormat;
  String? _labelFormat;
  set labelFormat(String? value) {
    if (_labelFormat != value) {
      _labelFormat = value;
      markNeedsLayout();
    }
  }

  DateTimeIntervalType get intervalType => _intervalType;
  DateTimeIntervalType _intervalType = DateTimeIntervalType.auto;
  set intervalType(DateTimeIntervalType value) {
    if (_intervalType != value) {
      _intervalType = value;
      markNeedsLayout();
    }
  }

  DateTime? get minimum => _minimum;
  DateTime? _minimum;
  set minimum(DateTime? value) {
    if (_minimum != value) {
      _minimum = value;
      markNeedsRangeUpdate();
    }
  }

  DateTime? get maximum => _maximum;
  DateTime? _maximum;
  set maximum(DateTime? value) {
    if (_maximum != value) {
      _maximum = value;
      markNeedsRangeUpdate();
    }
  }

  DateTime? get initialVisibleMinimum => _initialVisibleMinimum;
  DateTime? _initialVisibleMinimum;
  set initialVisibleMinimum(DateTime? value) {
    if (_initialVisibleMinimum == value) {
      return;
    }
    _initialVisibleMinimum = value;
    if (rangeController != null && rangeController!.start != null) {
      _updateVisibleMinMax(min: rangeController!.start);
    } else {
      _updateVisibleMinMax(min: initialVisibleMinimum);
    }
  }

  DateTime? get initialVisibleMaximum => _initialVisibleMaximum;
  DateTime? _initialVisibleMaximum;
  set initialVisibleMaximum(DateTime? value) {
    if (_initialVisibleMaximum == value) {
      return;
    }
    _initialVisibleMaximum = value;
    if (rangeController != null && rangeController!.end != null) {
      _updateVisibleMinMax(max: rangeController!.end);
    } else {
      _updateVisibleMinMax(max: initialVisibleMaximum);
    }
  }

  DateTimeIntervalType get autoScrollingDeltaType => _autoScrollingDeltaType;
  DateTimeIntervalType _autoScrollingDeltaType = DateTimeIntervalType.auto;
  set autoScrollingDeltaType(DateTimeIntervalType value) {
    if (_autoScrollingDeltaType != value) {
      _autoScrollingDeltaType = value;
    }
  }

  List<DateTimeMultiLevelLabel>? get multiLevelLabels => _multiLevelLabels;
  List<DateTimeMultiLevelLabel>? _multiLevelLabels;
  set multiLevelLabels(List<DateTimeMultiLevelLabel>? value) {
    if (_multiLevelLabels != value) {
      _multiLevelLabels = value;
    }
  }

  @override
  set rangeController(RangeController? value) {
    super.rangeController = value;
    if (value == null) {
      return;
    }
    assert(rangeController!.start is DateTime);
    assert(rangeController!.end is DateTime);
    _updateVisibleMinMax(min: value.start, max: value.end);
  }

  Function(DateTimeAxisController)? get onRendererCreated => _onRendererCreated;
  Function(DateTimeAxisController)? _onRendererCreated;
  set onRendererCreated(Function(DateTimeAxisController)? value) {
    if (_onRendererCreated != value) {
      _onRendererCreated = value;
    }
  }

  @override
  @nonVirtual
  num actualValue(Object value) {
    assert(value.runtimeType == DateTime);
    final DateTime date = value as DateTime;
    return super.actualValue(date.millisecondsSinceEpoch);
  }

  @override
  void attach(PipelineOwner owner) {
    onRendererCreated?.call(controller);
    rangeController?.addListener(_handleRangeControllerChange);
    super.attach(owner);
  }

  @override
  void detach() {
    rangeController?.removeListener(_handleRangeControllerChange);
    super.detach();
  }

  void _handleRangeControllerChange() {
    dynamic start = rangeController!.start;
    dynamic end = rangeController!.end;
    if (rangeController!.start is! DateTime) {
      start = DateTime.fromMillisecondsSinceEpoch(
          (rangeController!.start as num).toInt());
    }
    if (rangeController!.end is! DateTime) {
      end = DateTime.fromMillisecondsSinceEpoch(
          (rangeController!.end as num).toInt());
    }
    _updateVisibleMinMax(min: start, max: end);
  }

  void _updateVisibleMinMax({DateTime? min, DateTime? max}) {
    if (min != null) {
      controller.visibleMinimum = min;
    }
    if (max != null) {
      controller.visibleMaximum = max;
    }
  }

  @override
  void updateRangeControllerValues(DoubleRange newVisibleRange) {
    final DateTime start =
        DateTime.fromMillisecondsSinceEpoch(newVisibleRange.minimum.toInt());
    final DateTime end =
        DateTime.fromMillisecondsSinceEpoch(newVisibleRange.maximum.toInt());
    if (rangeController!.start != start) {
      rangeController!.start = start;
    }
    if (rangeController!.end != end) {
      rangeController!.end = end;
    }
  }

  @override
  DoubleRange calculateActualRange() {
    if (minimum != null && maximum != null) {
      if (minimum == maximum) {
        return DoubleRange(minimum!.millisecondsSinceEpoch - defaultTimeStamp,
            maximum!.millisecondsSinceEpoch + defaultTimeStamp);
      }
      return DoubleRange(
          minimum!.millisecondsSinceEpoch, maximum!.millisecondsSinceEpoch);
    }

    final DoubleRange range = super.calculateActualRange();
    if (minimum != null) {
      range.minimum = minimum!.millisecondsSinceEpoch;
    } else if (maximum != null) {
      range.maximum = maximum!.millisecondsSinceEpoch;
    }

    if (range.minimum == range.maximum) {
      range.minimum -= defaultTimeStamp;
      range.maximum += defaultTimeStamp;
    }

    return range.copyWith();
  }

  @override
  DoubleRange defaultRange() => DoubleRange(
        DateTime(1970, 2).millisecondsSinceEpoch,
        DateTime(1970, 6).millisecondsSinceEpoch,
      );

  @override
  num calculateActualInterval(DoubleRange range, Size availableSize) {
    return calculateNiceInterval(range.delta, availableSize);
  }

  @override
  num calculateNiceInterval(num delta, Size availableSize) {
    if (intervalType == DateTimeIntervalType.auto) {
      final num typeBasedInterval =
          _calculateIntervalAndType(delta, availableSize);
      return interval ?? typeBasedInterval;
    }

    _visibleIntervalType = intervalType;
    return interval ??
        super
            .calculateNiceInterval(_calculateTypeInterval(delta), availableSize)
            .ceil();
  }

  num _calculateTypeInterval(num delta) {
    const int perDay = 24 * 60 * 60 * 1000;
    const num hours = 24, minutes = 60, seconds = 60, milliseconds = 1000;
    final num totalDays = (delta / perDay).abs();
    switch (visibleIntervalType) {
      case DateTimeIntervalType.years:
        return totalDays / 365;

      case DateTimeIntervalType.months:
        return totalDays / 30;

      case DateTimeIntervalType.days:
        return totalDays;

      case DateTimeIntervalType.hours:
        return totalDays * hours;

      case DateTimeIntervalType.minutes:
        return totalDays * hours * minutes;

      case DateTimeIntervalType.seconds:
        return totalDays * hours * minutes * seconds;

      case DateTimeIntervalType.milliseconds:
        return totalDays * hours * minutes * seconds * milliseconds;

      case DateTimeIntervalType.auto:
        return 1;
    }
  }

  num _calculateIntervalAndType(num delta, Size availableSize) {
    const int perDay = 24 * 60 * 60 * 1000;
    const num hours = 24, minutes = 60, seconds = 60, milliseconds = 1000;
    final num totalDays = (delta / perDay).abs();

    // For years.
    num niceInterval =
        super.calculateNiceInterval(totalDays / 365, availableSize);
    if (niceInterval >= 1) {
      _visibleIntervalType = DateTimeIntervalType.years;
      return niceInterval.floor();
    }

    // For months.
    niceInterval = super.calculateNiceInterval(totalDays / 30, availableSize);
    if (niceInterval >= 1) {
      _visibleIntervalType = DateTimeIntervalType.months;
      return niceInterval.floor();
    }

    // For days.
    niceInterval = super.calculateNiceInterval(totalDays, availableSize);
    if (niceInterval >= 1) {
      _visibleIntervalType = DateTimeIntervalType.days;
      return niceInterval.floor();
    }

    // For hours.
    niceInterval =
        super.calculateNiceInterval(totalDays * hours, availableSize);
    if (niceInterval >= 1) {
      _visibleIntervalType = DateTimeIntervalType.hours;
      return niceInterval.floor();
    }

    // For minutes.
    niceInterval =
        super.calculateNiceInterval(totalDays * hours * minutes, availableSize);
    if (niceInterval >= 1) {
      _visibleIntervalType = DateTimeIntervalType.minutes;
      return niceInterval.floor();
    }

    // For seconds.
    niceInterval = super.calculateNiceInterval(
        totalDays * hours * minutes * seconds, availableSize);
    if (niceInterval >= 1) {
      _visibleIntervalType = DateTimeIntervalType.seconds;
      return niceInterval.floor();
    }

    // For milliseconds.
    niceInterval = super.calculateNiceInterval(
        totalDays * hours * minutes * seconds * milliseconds, availableSize);
    if (niceInterval >= 1) {
      _visibleIntervalType = DateTimeIntervalType.milliseconds;
      return niceInterval.floor();
    }

    return niceInterval.ceil();
  }

  @override
  DoubleRange updateAutoScrollingDelta(
      int scrollingDelta, DoubleRange actualRange, DoubleRange visibleRange) {
    if (initialVisibleMaximum != null || initialVisibleMinimum != null) {
      return visibleRange;
    }
    final DateTimeIntervalType intervalType =
        autoScrollingDeltaType == DateTimeIntervalType.auto
            ? _visibleIntervalType
            : autoScrollingDeltaType;
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(visibleRange.maximum.toInt());
    switch (intervalType) {
      case DateTimeIntervalType.years:
        dateTime = DateTime(
            dateTime.year - autoScrollingDelta!,
            dateTime.month,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
            dateTime.microsecond);
        scrollingDelta =
            visibleRange.maximum.toInt() - dateTime.millisecondsSinceEpoch;
        break;
      case DateTimeIntervalType.months:
        dateTime = DateTime(
            dateTime.year,
            dateTime.month - autoScrollingDelta!,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
            dateTime.microsecond);
        scrollingDelta =
            visibleRange.maximum.toInt() - dateTime.millisecondsSinceEpoch;
        break;
      case DateTimeIntervalType.days:
        scrollingDelta = Duration(days: autoScrollingDelta!).inMilliseconds;
        break;
      case DateTimeIntervalType.hours:
        scrollingDelta = Duration(hours: autoScrollingDelta!).inMilliseconds;
        break;
      case DateTimeIntervalType.minutes:
        scrollingDelta = Duration(minutes: autoScrollingDelta!).inMilliseconds;
        break;
      case DateTimeIntervalType.seconds:
        scrollingDelta = Duration(seconds: autoScrollingDelta!).inMilliseconds;
        break;
      case DateTimeIntervalType.milliseconds:
        scrollingDelta =
            Duration(milliseconds: autoScrollingDelta!).inMilliseconds;
        break;
      case DateTimeIntervalType.auto:
        scrollingDelta = autoScrollingDelta!;
        break;
    }
    return super
        .updateAutoScrollingDelta(scrollingDelta, actualRange, visibleRange);
  }

  @override
  DoubleRange applyRangePadding(
      DoubleRange range, num interval, Size availableSize) {
    if (minimum == null && maximum == null) {
      final ChartRangePadding padding = effectiveRangePadding();
      if (padding == ChartRangePadding.additional) {
        _addAdditionalRange(range, interval.toInt());
      } else if (padding == ChartRangePadding.round) {
        _roundRange(range, interval.toInt());
      }
    }

    return range;
  }

  void _addAdditionalRange(DoubleRange range, int interval) {
    switch (visibleIntervalType) {
      case DateTimeIntervalType.years:
        _addAdditionalYear(range, interval);
        break;

      case DateTimeIntervalType.months:
        _addAdditionalMonth(range, interval);
        break;

      case DateTimeIntervalType.days:
        _addAdditionalDays(range, interval);
        break;

      case DateTimeIntervalType.hours:
        _addAdditionalHours(range, interval);
        break;

      case DateTimeIntervalType.minutes:
        _addAdditionalMinutes(range, interval);
        break;

      case DateTimeIntervalType.seconds:
        _addAdditionalSeconds(range, interval);
        break;

      case DateTimeIntervalType.milliseconds:
        _addAdditionalMilliseconds(range, interval);
        break;

      case DateTimeIntervalType.auto:
        break;
    }
  }

  void _addAdditionalYear(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startYear = startDate.year;
    final int endYear = endDate.year;
    range.minimum = DateTime(startYear - interval).millisecondsSinceEpoch;
    range.maximum = DateTime(endYear + interval).millisecondsSinceEpoch;
  }

  void _addAdditionalMonth(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startMonth = startDate.month;
    final int endMonth = endDate.month;
    range.minimum =
        DateTime(startDate.year, startMonth - interval).millisecondsSinceEpoch;
    range.maximum =
        // TODO(Natrayan): Revisit the end month calculation.
        DateTime(endDate.year, endMonth + interval, endMonth == 2 ? 28 : 30)
            .millisecondsSinceEpoch;
  }

  void _addAdditionalDays(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startDay = startDate.day;
    final int endDay = endDate.day;
    range.minimum =
        DateTime(startDate.year, startDate.month, startDay - interval)
            .millisecondsSinceEpoch;
    range.maximum = DateTime(endDate.year, endDate.month, endDay + interval)
        .millisecondsSinceEpoch;
  }

  void _addAdditionalHours(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startHour = ((startDate.hour / interval) * interval).toInt();
    final int endHour = endDate.hour + (startDate.hour - startHour);
    range.minimum = DateTime(startDate.year, startDate.month, startDate.day,
            startHour - interval)
        .millisecondsSinceEpoch;
    range.maximum =
        DateTime(endDate.year, endDate.month, endDate.day, endHour + interval)
            .millisecondsSinceEpoch;
  }

  void _addAdditionalMinutes(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startMinute = ((startDate.minute / interval) * interval).toInt();
    final int endMinute = endDate.minute + (startDate.minute - startMinute);
    range.minimum = DateTime(startDate.year, startDate.month, startDate.day,
            startDate.hour, startMinute - interval)
        .millisecondsSinceEpoch;
    range.maximum = DateTime(endDate.year, endDate.month, endDate.day,
            endDate.hour, endMinute + interval)
        .millisecondsSinceEpoch;
  }

  void _addAdditionalSeconds(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startSecond = ((startDate.second / interval) * interval).toInt();
    final int endSecond = endDate.second + (startDate.second - startSecond);
    range.minimum = DateTime(startDate.year, startDate.month, startDate.day,
            startDate.hour, startDate.minute, startSecond - interval)
        .millisecondsSinceEpoch;
    range.maximum = DateTime(endDate.year, endDate.month, endDate.day,
            endDate.hour, endDate.minute, endSecond + interval)
        .millisecondsSinceEpoch;
  }

  void _addAdditionalMilliseconds(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startMilliSecond =
        ((startDate.millisecond / interval) * interval).toInt();
    final int endMilliSecond =
        endDate.millisecond + (startDate.millisecond - startMilliSecond);
    range.minimum = DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
            startDate.hour,
            startDate.minute,
            startDate.second,
            startMilliSecond - interval)
        .millisecondsSinceEpoch;
    range.maximum = DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            endDate.hour,
            endDate.minute,
            endDate.second,
            endMilliSecond + interval)
        .millisecondsSinceEpoch;
  }

  void _roundRange(DoubleRange range, int interval) {
    switch (visibleIntervalType) {
      case DateTimeIntervalType.years:
        _roundYears(range, interval);
        break;

      case DateTimeIntervalType.months:
        _roundMonths(range, interval);
        break;

      case DateTimeIntervalType.days:
        _roundDays(range, interval);
        break;

      case DateTimeIntervalType.hours:
        _roundHours(range, interval);
        break;

      case DateTimeIntervalType.minutes:
        _roundMinutes(range, interval);
        break;

      case DateTimeIntervalType.seconds:
        _roundSeconds(range, interval);
        break;

      case DateTimeIntervalType.milliseconds:
        _roundMilliseconds(range, interval);
        break;

      case DateTimeIntervalType.auto:
        break;
    }
  }

  void _roundYears(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startYear = startDate.year;
    final int endYear = endDate.year;
    range.minimum = DateTime(startYear, 0, 0).millisecondsSinceEpoch;
    range.maximum =
        DateTime(endYear, 11, 30, 23, 59, 59).millisecondsSinceEpoch;
  }

  void _roundMonths(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startMonth = startDate.month;
    final int endMonth = endDate.month;
    range.minimum =
        DateTime(startDate.year, startMonth, 0).millisecondsSinceEpoch;
    range.maximum = DateTime(endDate.year, endMonth,
            DateTime(endDate.year, endDate.month, 0).day, 23, 59, 59)
        .millisecondsSinceEpoch;
  }

  void _roundDays(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startDay = startDate.day;
    final int endDay = endDate.day;
    range.minimum = DateTime(startDate.year, startDate.month, startDay)
        .millisecondsSinceEpoch;
    range.maximum = DateTime(endDate.year, endDate.month, endDay, 23, 59, 59)
        .millisecondsSinceEpoch;
  }

  void _roundHours(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startHour = ((startDate.hour / interval) * interval).toInt();
    range.minimum =
        DateTime(startDate.year, startDate.month, startDate.day, startHour)
            .millisecondsSinceEpoch;
    range.maximum =
        DateTime(endDate.year, endDate.month, endDate.day, startHour, 59, 59)
            .millisecondsSinceEpoch;
  }

  void _roundMinutes(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startMinute = ((startDate.minute / interval) * interval).toInt();
    final int endMinute = endDate.minute + (startDate.minute - startMinute);
    range.minimum = DateTime(startDate.year, startDate.month, startDate.day,
            startDate.hour, startMinute)
        .millisecondsSinceEpoch;
    range.maximum = DateTime(endDate.year, endDate.month, endDate.day,
            endDate.hour, endMinute, 59)
        .millisecondsSinceEpoch;
  }

  void _roundSeconds(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startSecond = ((startDate.second / interval) * interval).toInt();
    final int endSecond = endDate.second + (startDate.second - startSecond);
    range.minimum = DateTime(startDate.year, startDate.month, startDate.day,
            startDate.hour, startDate.minute, startSecond)
        .millisecondsSinceEpoch;
    range.maximum = DateTime(startDate.year, startDate.month, startDate.day,
            startDate.hour, startDate.minute, endSecond)
        .millisecondsSinceEpoch;
  }

  void _roundMilliseconds(DoubleRange range, int interval) {
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
    final int startMilliSecond =
        ((startDate.millisecond / interval) * interval).toInt();
    final int endMilliSecond =
        endDate.millisecond + (startDate.millisecond - startMilliSecond);
    range.minimum = DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
            startDate.hour,
            startDate.minute,
            startDate.second,
            startMilliSecond)
        .millisecondsSinceEpoch;
    range.maximum = DateTime(endDate.year, endDate.month, endDate.day,
            endDate.hour, endDate.minute, endDate.second, endMilliSecond)
        .millisecondsSinceEpoch;
  }

  @override
  void generateVisibleLabels() {
    hasTrimmedAxisLabel = false;
    if (visibleRange == null || visibleInterval == 0) {
      return;
    }

    final double extent =
        labelsExtent ?? (maximumLabelWidth ?? double.maxFinite);
    final bool isRtl = textDirection == TextDirection.rtl;
    num current = visibleRange!.minimum;
    current = _niceStart(current);
    num previous = current;
    final num visibleMinimum = visibleRange!.minimum;
    final num visibleMaximum = visibleRange!.maximum;
    while (current <= visibleMaximum) {
      if (current < visibleMinimum ||
          !effectiveVisibleRange!.contains(current)) {
        current = _nextDate(current, visibleInterval, visibleIntervalType)
            .millisecondsSinceEpoch;
        continue;
      }

      final DateFormat niceDateFormat = dateFormat ??
          dateTimeAxisLabelFormat(this, current, previous.toInt());
      String text = niceDateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(current.toInt()));
      if (labelFormat != null && labelFormat != '') {
        text = labelFormat!.replaceAll(RegExp('{value}'), text);
      }

      String callbackText = text;
      TextStyle callbackTextStyle =
          chartThemeData!.axisLabelTextStyle!.merge(labelStyle);
      if (axisLabelFormatter != null) {
        final AxisLabelRenderDetails details = AxisLabelRenderDetails(current,
            callbackText, callbackTextStyle, this, visibleIntervalType, text);
        final ChartAxisLabel label = axisLabelFormatter!(details);
        callbackText = label.text;
        callbackTextStyle = callbackTextStyle.merge(label.textStyle);
      }

      Size textSize = measureText(callbackText, callbackTextStyle, 0);
      String textAfterTrimming = callbackText;
      if (extent.isFinite && textSize.width > extent) {
        textAfterTrimming = trimmedText(
          callbackText,
          callbackTextStyle,
          extent,
          labelRotation,
          isRtl: isRtl,
        );
      }

      textSize =
          measureText(textAfterTrimming, callbackTextStyle, labelRotation);
      final bool isTextTrimmed = callbackText != textAfterTrimming;
      final AxisLabel label = AxisLabel(
        callbackTextStyle,
        textSize,
        callbackText,
        current,
        isTextTrimmed ? textAfterTrimming : null,
        textAfterTrimming,
      );
      visibleLabels.add(label);
      previous = current;
      if (isTextTrimmed) {
        hasTrimmedAxisLabel = true;
      }
      current = _nextDate(current, visibleInterval, visibleIntervalType)
          .millisecondsSinceEpoch;
      if (previous == current) {
        return;
      }
    }

    super.generateVisibleLabels();
  }

  int _niceStart(num startDate) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(startDate.toInt());
    switch (visibleIntervalType) {
      case DateTimeIntervalType.years:
        final int year =
            ((date.year / visibleInterval).floor() * visibleInterval).floor();
        date = DateTime(year, date.month, date.day);
        break;

      case DateTimeIntervalType.months:
        final int month =
            ((date.month / visibleInterval) * visibleInterval).floor();
        date = DateTime(date.year, month, date.day);
        break;

      case DateTimeIntervalType.days:
        final int day =
            ((date.day / visibleInterval) * visibleInterval).floor();
        date = DateTime(date.year, date.month, day);
        break;

      case DateTimeIntervalType.hours:
        final int hour =
            ((date.hour / visibleInterval).floor() * visibleInterval).floor();
        date = DateTime(date.year, date.month, date.day, hour);
        break;

      case DateTimeIntervalType.minutes:
        final int minute =
            ((date.minute / visibleInterval).floor() * visibleInterval).floor();
        date = DateTime(date.year, date.month, date.day, date.hour, minute);
        break;

      case DateTimeIntervalType.seconds:
        final int second =
            ((date.second / visibleInterval).floor() * visibleInterval).floor();
        date = DateTime(
            date.year, date.month, date.day, date.hour, date.minute, second);
        break;

      case DateTimeIntervalType.milliseconds:
        final int millisecond =
            ((date.millisecond / visibleInterval).floor() * visibleInterval)
                .floor();
        date = DateTime(date.year, date.month, date.day, date.hour, date.minute,
            date.second, millisecond);
        break;

      case DateTimeIntervalType.auto:
        break;
    }

    return date.millisecondsSinceEpoch;
  }

  DateTime _nextDate(
      num current, num interval, DateTimeIntervalType intervalType) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(current.toInt());
    final bool hasDecimalInterval = interval % 1 == 0;
    if (hasDecimalInterval) {
      final int effectiveInterval = interval.floor();
      switch (intervalType) {
        case DateTimeIntervalType.years:
          return date = DateTime(date.year + effectiveInterval, date.month,
              date.day, date.hour, date.minute, date.second);

        case DateTimeIntervalType.months:
          return date = DateTime(date.year, date.month + effectiveInterval,
              date.day, date.hour, date.minute, date.second);

        case DateTimeIntervalType.days:
          return date.add(Duration(days: effectiveInterval));

        case DateTimeIntervalType.hours:
          return date.add(Duration(hours: effectiveInterval));

        case DateTimeIntervalType.minutes:
          return date.add(Duration(minutes: effectiveInterval));

        case DateTimeIntervalType.seconds:
          return date.add(Duration(seconds: effectiveInterval));

        case DateTimeIntervalType.milliseconds:
          return date.add(Duration(milliseconds: effectiveInterval));

        case DateTimeIntervalType.auto:
          break;
      }
    } else {
      switch (intervalType) {
        case DateTimeIntervalType.years:
          return date = DateTime(
              date.year,
              date.month + (interval * 12).floor(),
              date.day,
              date.hour,
              date.minute,
              date.second);

        case DateTimeIntervalType.months:
          return date.add(Duration(days: (interval * 30).floor()));

        case DateTimeIntervalType.days:
          return date.add(Duration(hours: (interval * 24).floor()));

        case DateTimeIntervalType.hours:
          return date.add(Duration(minutes: (interval * 60).floor()));

        case DateTimeIntervalType.minutes:
          return date.add(Duration(seconds: (interval * 60).floor()));

        case DateTimeIntervalType.seconds:
          return date.add(Duration(seconds: (interval * 1000).floor()));

        case DateTimeIntervalType.milliseconds:
          return date.add(Duration(milliseconds: interval.floor()));

        case DateTimeIntervalType.auto:
          break;
      }
    }
    return date;
  }

  @override
  void calculateTickPositions(
    LabelPlacement placement, {
    List<double>? source,
    bool canCalculateMinorTick = false,
    bool canCalculateMajorTick = true,
  }) {
    final int length = visibleLabels.length;
    if (length == 0) {
      return;
    }

    final bool isBetweenTicks = placement == LabelPlacement.betweenTicks;
    for (int i = 0; i < length; i++) {
      final bool hasNextLabel = length - 1 > i;
      num current = visibleLabels[i].value;
      if (isBetweenTicks) {
        final num nextValue =
            hasNextLabel ? visibleLabels[i + 1].value : visibleRange!.maximum;
        current = (current + nextValue) / 2;
      }

      source!.add(pointToPixel(current));

      if (canCalculateMinorTick) {
        final num start = current;
        final num end =
            hasNextLabel ? visibleLabels[i + 1].value : visibleRange!.maximum;
        final double minorTickInterval =
            (end - start) / (minorTicksPerInterval + 1);
        for (int j = 1; j <= minorTicksPerInterval; j++) {
          final double tickValue = start + minorTickInterval * j;
          if (tickValue < end && tickValue < visibleRange!.maximum) {
            minorTickPositions.add(pointToPixel(tickValue));
          }
        }
      }
    }
  }

  @override
  num plotBandExtent(PlotBand plotBand, num current, num size) {
    if (plotBand.isRepeatable) {
      DateTimeIntervalType sizeType = plotBand.sizeType;
      if (plotBand.sizeType == DateTimeIntervalType.auto) {
        sizeType = visibleIntervalType;
      }
      return _nextDate(current, size, sizeType).millisecondsSinceEpoch;
    } else {
      return super.plotBandExtent(plotBand, current, size);
    }
  }

  @override
  void generateMultiLevelLabels() {
    _multilevelLabels.clear();
    visibleMultilevelLabels.clear();

    // TODO(Natrayansf): Move actualMultilevelLabels to property setter.
    final int length = multiLevelLabels?.length ?? 0;
    if (length == 0) {
      return;
    }

    for (int i = 0; i < length; i++) {
      final DateTimeMultiLevelLabel label = multiLevelLabels![i];
      assert(label.start.millisecondsSinceEpoch <=
          label.end.millisecondsSinceEpoch);
      _multilevelLabels.add(AxisMultilevelLabel(
          label.text,
          label.level,
          label.start.millisecondsSinceEpoch,
          label.end.millisecondsSinceEpoch));
    }

    _multilevelLabels.sort((AxisMultilevelLabel a, AxisMultilevelLabel b) =>
        a.level.compareTo(b.level));

    final void Function(AxisMultilevelLabel label) add = invertElementsOrder
        ? (AxisMultilevelLabel label) =>
            visibleMultilevelLabels.insert(0, label)
        : (AxisMultilevelLabel label) => visibleMultilevelLabels.add(label);

    final int labelsLength = _multilevelLabels.length;
    final TextStyle textStyle = chartThemeData!.axisMultiLevelLabelTextStyle!
        .merge(multiLevelLabelStyle.textStyle);
    for (int i = 0; i < labelsLength; i++) {
      final AxisMultilevelLabel current = _multilevelLabels[i];
      if (isLies(current.start, current.end, visibleRange!)) {
        String desiredText = current.text;
        TextStyle desiredTextStyle = textStyle;
        if (multiLevelLabelFormatter != null) {
          final MultiLevelLabelRenderDetails details =
              MultiLevelLabelRenderDetails(
                  current.level, desiredText, desiredTextStyle, i, name);
          final ChartAxisLabel label = multiLevelLabelFormatter!(details);
          desiredText = label.text;
          desiredTextStyle = textStyle.merge(label.textStyle);
        }

        current
          ..actualTextSize = measureText(desiredText, desiredTextStyle, 0)
          ..renderText = desiredText
          ..style = desiredTextStyle;
        add(current);
      }
    }
  }

  @override
  void updateMultiLevelLabels() {
    late Rect Function(double start, double end, Size size) labelBounds;
    labelBounds = isVertical ? _verticalLabelBounds : _horizontalLabelBounds;

    final bool isRtl = textDirection == TextDirection.rtl;
    for (final AxisMultilevelLabel label in visibleMultilevelLabels) {
      final double start = pointToPixel(label.start);
      final double end = pointToPixel(label.end);
      final double extent = (end - start - textPadding).abs();

      String renderText = label.renderText;
      final TextStyle style = label.style;
      if (label.actualTextSize.width > extent) {
        renderText = trimmedText(renderText, style, extent, 0, isRtl: isRtl);
      }

      // TODO(Natrayansf): Set only when trimming is done.
      label.trimmedText = renderText;
      label
        ..transformStart = start
        ..transformEnd = end
        ..region = labelBounds(start, end, measureText(renderText, style, 0));
    }
  }

  Rect _horizontalLabelBounds(double start, double end, Size labelSize) {
    double height = labelSize.height;
    if (multiLevelLabelStyle.borderType == MultiLevelBorderType.curlyBrace) {
      height += 2 * textPaddingOfCurlyBrace;
    } else {
      height += 2 * textPadding;
    }

    return Rect.fromLTRB(start, 0, end, height);
  }

  Rect _verticalLabelBounds(double start, double end, Size labelSize) {
    double width = labelSize.width;
    if (multiLevelLabelStyle.borderType == MultiLevelBorderType.curlyBrace) {
      width += 2 * textPaddingOfCurlyBrace;
    } else {
      width += 2 * textPadding;
    }

    return Rect.fromLTRB(0, start, width, end);
  }

  @override
  void dispose() {
    _multilevelLabels.clear();
    controller.dispose();
    super.dispose();
  }
}
