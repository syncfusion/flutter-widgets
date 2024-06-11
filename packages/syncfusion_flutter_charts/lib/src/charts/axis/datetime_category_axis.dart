import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:syncfusion_flutter_core/core.dart';

import '../common/callbacks.dart';
import '../series/chart_series.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'axis.dart';
import 'multi_level_labels.dart';
import 'plot_band.dart';

/// An axis which is used to plot date-time values. It is similar to
/// [DateTimeAxis] except that it excludes missing dates.
///
/// This is a unique type of axis used mainly with financial series. Like
/// [CategoryAxis], all the data points are plotted with equal spaces by
/// removing space for missing dates. Intervals and ranges for the axis are
/// calculated similar to [DateTimeAxis]. There will be no visual gaps between
/// points even when the difference between two points is more than a year.
///
/// A simple use case of this axis type is when the user wishes to visualize
/// the working hours on an employee for a month by excluding the weekends.
///
/// Provides options for label placement, interval, date format for customizing
/// the appearance.
class DateTimeCategoryAxis extends ChartAxis {
  /// Creating an argument constructor of [DateTimeCategoryAxis] class.
  const DateTimeCategoryAxis({
    super.key,
    super.name,
    super.isVisible = true,
    super.title,
    super.axisLine,
    super.rangePadding,
    super.edgeLabelPlacement,
    super.labelPosition,
    super.tickPosition,
    super.labelRotation,
    super.labelIntersectAction,
    super.labelAlignment,
    super.isInversed,
    super.opposedPosition,
    super.maximumLabels,
    super.majorTickLines,
    super.majorGridLines,
    super.labelStyle,
    super.plotOffset,
    super.initialZoomFactor,
    super.initialZoomPosition,
    super.interactiveTooltip,
    this.minimum,
    this.maximum,
    super.interval,
    this.initialVisibleMinimum,
    this.initialVisibleMaximum,
    super.crossesAt,
    super.associatedAxisName,
    super.placeLabelsNearAxisLine,
    super.plotBands,
    super.desiredIntervals,
    super.rangeController,
    super.maximumLabelWidth,
    super.labelsExtent,
    this.labelPlacement = LabelPlacement.betweenTicks,
    this.dateFormat,
    this.intervalType = DateTimeIntervalType.auto,
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

  /// Formats the date-time category axis labels.
  ///
  /// The axis label can be formatted with various built-in [date formats](https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html).
  ///
  /// By default, date format will be applied to the axis labels based on the
  /// interval between the data points.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(dateFormat: DateFormat.y()),
  ///        )
  ///    );
  /// }
  /// ```
  final DateFormat? dateFormat;

  /// Position of the date-time category axis labels.
  ///
  /// The labels can be placed either between the ticks or at the major ticks.
  ///
  /// Defaults to `LabelPlacement.betweenTicks`.
  ///
  /// Also refer [LabelPlacement].
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis:
  ///             DateTimeCategoryAxis(labelPlacement: LabelPlacement.onTicks),
  ///        )
  ///    );
  /// }
  /// ```
  final LabelPlacement labelPlacement;

  /// Customizes the date-time category axis interval.
  ///
  /// Intervals can be set to days, hours, minutes, months, seconds, years, and
  /// auto. If it is set to auto, the interval type will be decided based on
  /// the data.
  ///
  /// Defaults to `DateTimeIntervalType.auto`.
  ///
  /// Also refer [DateTimeIntervalType].
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis:
  ///           DateTimeCategoryAxis(intervalType: DateTimeIntervalType.years),
  ///        )
  ///    );
  /// }
  /// ```
  final DateTimeIntervalType intervalType;

  /// Minimum value of the axis.
  ///
  /// The axis will start from this date and data points below this value will
  /// not be rendered.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(minimum: DateTime(2000)),
  ///        )
  ///    );
  /// }
  /// ```
  final DateTime? minimum;

  /// Maximum value of the axis.
  ///
  /// The axis will end at this date and data points above this value will
  /// not be rendered.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(maximum: DateTime(2019)),
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
  ///           primaryYAxis: DateTimeCategoryAxis(initialVisibleMinimum: DateTime(2019)),
  ///        )
  ///    );
  /// }
  /// ```
  ///
  /// Use the [onRendererCreated] callback, as shown in the code below, to update the visible
  /// minimum value dynamically.
  ///
  /// ```dart
  /// DateTimeCategoryAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(
  ///             initialVisibleMinimum: DateTime(2019),
  ///             onRendererCreated: (DateTimeCategoryAxisController controller) {
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
  ///           primaryYAxis: DateTimeCategoryAxis(initialVisibleMaximum: DateTime(2020)),
  ///        ));
  /// }
  /// ```
  ///
  /// Use the [onRendererCreated] callback, as shown in the code below, to update the visible
  /// maximum value dynamically
  ///
  /// ```dart
  /// DateTimeCategoryAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(
  ///             initialVisibleMaximum: DateTime(2020),
  ///             onRendererCreated: (DateTimeCategoryAxisController controller) {
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
  /// [autoScrollingDeltaType] is set to `DateTimeIntervalType.days`, the data
  /// points with 5 days of values will be displayed.
  ///
  /// The value can be set to years, months, days, hours, minutes, seconds
  /// and auto.
  ///
  /// Defaults to `DateTimeIntervalType.auto` and the delta will be calculated
  /// automatically based on the data.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis:
  ///             DateTimeCategoryAxis(
  ///                autoScrollingDeltaType: DateTimeIntervalType.months),
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
  ///       primaryXAxis: DateTimeCategoryAxis(
  ///         multiLevelLabels: <DateTimeCategoricalMultiLevelLabel>[
  ///           DateTimeCategoricalMultiLevelLabel(
  ///              start: DateTime(2010, 1, 1),
  ///             end: DateTime(2010, 2, 1),
  ///             text: 'First'
  ///           ),
  ///           DateTimeCategoricalMultiLevelLabel(
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
  final List<DateTimeCategoricalMultiLevelLabel>? multiLevelLabels;

  final Function(DateTimeCategoryAxisController)? onRendererCreated;

  @override
  RenderDateTimeCategoryAxis createRenderer() {
    return RenderDateTimeCategoryAxis();
  }

  @override
  RenderDateTimeCategoryAxis createRenderObject(BuildContext context) {
    final RenderDateTimeCategoryAxis renderer =
        super.createRenderObject(context) as RenderDateTimeCategoryAxis;
    renderer
      ..labelPlacement = labelPlacement
      ..dateFormat = dateFormat
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
      BuildContext context, RenderDateTimeCategoryAxis renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..labelPlacement = labelPlacement
      ..dateFormat = dateFormat
      ..intervalType = intervalType
      ..minimum = minimum
      ..maximum = maximum
      ..autoScrollingDeltaType = autoScrollingDeltaType
      ..multiLevelLabels = multiLevelLabels;
  }
}

class RenderDateTimeCategoryAxis extends RenderChartAxis {
  final List<int> labels = <int>[];
  final List<AxisMultilevelLabel> _multilevelLabels = <AxisMultilevelLabel>[];

  DateTimeIntervalType get visibleIntervalType => _visibleIntervalType;
  DateTimeIntervalType _visibleIntervalType = DateTimeIntervalType.auto;

  @override
  DateTimeCategoryAxisController get controller => _controller;
  late final DateTimeCategoryAxisController _controller =
      DateTimeCategoryAxisController(this);

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
      markNeedsLayout();
    }
  }

  List<DateTimeCategoricalMultiLevelLabel>? get multiLevelLabels =>
      _multiLevelLabels;
  List<DateTimeCategoricalMultiLevelLabel>? _multiLevelLabels;
  set multiLevelLabels(List<DateTimeCategoricalMultiLevelLabel>? value) {
    if (_multiLevelLabels != value) {
      _multiLevelLabels = value;
      markNeedsLayout();
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

  Function(DateTimeCategoryAxisController)? get onRendererCreated =>
      _onRendererCreated;
  Function(DateTimeCategoryAxisController)? _onRendererCreated;
  set onRendererCreated(Function(DateTimeCategoryAxisController)? value) {
    if (_onRendererCreated != value) {
      _onRendererCreated = value;
    }
  }

  @override
  num actualValue(Object value) {
    if (value is num) {
      return super.actualValue(value);
    }

    assert(value.runtimeType == DateTime);
    return super.actualValue(effectiveValue(value as DateTime)!);
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
    assert(rangeController != null);
    dynamic start = rangeController!.start;
    dynamic end = rangeController!.end;
    if (rangeController!.start is! DateTime) {
      start = DateTime.fromMillisecondsSinceEpoch(
          labels[(rangeController!.start as num).toInt()]);
    }
    if (rangeController!.end is! DateTime) {
      end = DateTime.fromMillisecondsSinceEpoch(
          labels[(rangeController!.end as num).toInt()]);
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
  DoubleRange calculateActualRange() {
    if (minimum != null && maximum != null) {
      return DoubleRange(
          effectiveValue(minimum)!, effectiveValue(maximum, needMin: false)!);
    }

    final DoubleRange range = super.calculateActualRange();
    if (minimum != null) {
      range.minimum = effectiveValue(minimum)!;
    } else if (maximum != null) {
      range.maximum = effectiveValue(maximum, needMin: false)!;
    }

    if (range.minimum == range.maximum &&
        labelPlacement == LabelPlacement.onTicks) {
      range.maximum += 1;
    }

    return range.copyWith();
  }

  @override
  DoubleRange updateAutoScrollingDelta(
      int scrollingDelta, DoubleRange actualRange, DoubleRange visibleRange) {
    if (initialVisibleMaximum != null || initialVisibleMinimum != null) {
      return visibleRange;
    }
    return super
        .updateAutoScrollingDelta(scrollingDelta, actualRange, visibleRange);
  }

  @override
  DoubleRange defaultRange() => DoubleRange.zero();

  @override
  num calculateActualInterval(DoubleRange range, Size availableSize) {
    return calculateNiceInterval(range.delta, availableSize);
  }

  @override
  num calculateNiceInterval(num delta, Size availableSize) {
    if (intervalType == DateTimeIntervalType.auto) {
      if (labels.isNotEmpty) {
        _calculateIntervalAndType(labels.first, labels.last, availableSize);
      } else {
        _visibleIntervalType = DateTimeIntervalType.days;
      }

      return interval ??
          max(1, super.calculateNiceInterval(delta, availableSize));
    }

    _visibleIntervalType = intervalType;
    return interval ??
        max(1, super.calculateNiceInterval(delta, availableSize));
  }

  num _calculateIntervalAndType(num minimum, num maximum, Size availableSize) {
    const int perDay = 24 * 60 * 60 * 1000;
    const num hours = 24, minutes = 60, seconds = 60, milliseconds = 1000;
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(minimum.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(maximum.toInt());
    final num totalDays =
        ((endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch) /
                perDay)
            .abs();

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
  DoubleRange applyRangePadding(
      DoubleRange range, num interval, Size availableSize) {
    if (labelPlacement == LabelPlacement.betweenTicks) {
      range.minimum -= 0.5;
      range.maximum += 0.5;
    }

    if (range.minimum == range.maximum) {
      return _handleEqualRange(range);
    }

    if (minimum == null || maximum == null) {
      range = super.applyRangePadding(range, interval, availableSize);

      if (minimum != null) {
        range.minimum = effectiveValue(minimum)!;
        if (labelPlacement == LabelPlacement.onTicks) {
          range.minimum -= 0.5;
        }
      }
      if (maximum != null) {
        range.maximum = effectiveValue(maximum, needMin: false)!;
        if (labelPlacement == LabelPlacement.onTicks) {
          range.maximum += 0.5;
        }
      }
    }

    if (range.minimum == range.maximum) {
      return _handleEqualRange(range);
    }

    return range.copyWith();
  }

  DoubleRange _handleEqualRange(DoubleRange range) {
    if (labelPlacement == LabelPlacement.onTicks) {
      return DoubleRange(range.minimum, range.maximum + 1);
    } else if (labelPlacement == LabelPlacement.betweenTicks) {
      return DoubleRange(range.minimum - 0.5, range.maximum + 0.5);
    }

    return range;
  }

  @override
  void addNormalRange(DoubleRange range, num interval, Size availableSize) {
    if (labelPlacement == LabelPlacement.onTicks) {
      range.minimum -= 0.5;
      range.maximum += 0.5;
      if (range.minimum == 0) {
        updateNormalRangePadding(range, availableSize);
      }
    } else {
      super.addNormalRange(range, interval, availableSize);
    }
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
    num niceInterval = visibleInterval;
    final List<String> split = niceInterval.toString().split('.');
    niceInterval = split.length >= 2
        ? split[1].length == 1 && split[1] == '0'
            ? niceInterval.floor()
            : niceInterval.ceil()
        : niceInterval;
    final num visibleMinimum = visibleRange!.minimum;
    final num visibleMaximum = visibleRange!.maximum;
    num current = visibleMinimum.ceil();
    num previous = current;
    final DateFormat niceDateTimeFormat = dateFormat ??
        dateTimeCategoryAxisLabelFormat(this, current, previous.toInt());
    while (current <= visibleMaximum) {
      if (current < visibleMinimum ||
          !effectiveVisibleRange!.contains(current)) {
        current += niceInterval;
        continue;
      }

      String text = '';
      final int currentValue = current.round();
      if (currentValue <= -1 ||
          labels.isNotEmpty && currentValue >= labels.length) {
        current += niceInterval;
        continue;
      } else if (labels.isNotEmpty) {
        text = niceDateTimeFormat
            .format(DateTime.fromMillisecondsSinceEpoch(labels[currentValue]));
      } else {
        current += niceInterval;
        continue;
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

      String textAfterTrimming = callbackText;
      Size textSize =
          measureText(callbackText, callbackTextStyle, labelRotation);
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
      current += niceInterval;
    }

    super.generateVisibleLabels();
  }

  @override
  void calculateTickPositions(
    LabelPlacement placement, {
    List<double>? source,
    bool canCalculateMinorTick = false,
    bool canCalculateMajorTick = true,
  }) {
    int length = visibleLabels.length;
    if (length == 0) {
      return;
    }

    bool isBetweenTicks = placement == LabelPlacement.betweenTicks;
    if (!isBetweenTicks && !canCalculateMajorTick) {
      isBetweenTicks = !isBetweenTicks;
    }

    final num tickBetweenLabel = isBetweenTicks ? 0.5 : 0;
    length += isBetweenTicks ? 1 : 0;
    final int lastIndex = length - 1;
    for (int i = 0; i < length; i++) {
      num current;
      if (isBetweenTicks) {
        if (i < lastIndex) {
          current = visibleLabels[i].value - tickBetweenLabel;
        } else {
          final num gap = interval != null ? interval! : 1;
          current = visibleLabels[i - 1].value + gap - tickBetweenLabel;
        }
      } else {
        current = visibleLabels[i].value;
      }

      source!.add(pointToPixel(current));
    }
  }

  @override
  void generatePlotBands() {
    if (plotBands.isNotEmpty &&
        associatedAxis != null &&
        associatedAxis!.visibleRange != null) {
      visiblePlotBands ??= <AxisPlotBand>[];
      final int length = plotBands.length;
      final Rect Function(PlotBand plotBand, num start, num end) bounds =
          isVertical ? verticalPlotBandBounds : horizontalPlotBandBounds;

      for (int i = 0; i < length; i++) {
        final PlotBand plotBand = plotBands[i];
        if (plotBand.isVisible) {
          final dynamic actualStart = plotBand.start;
          final dynamic actualEnd = plotBand.end;
          final num min = actualStart != null
              ? actualValue(actualStart is num
                  ? indexToDateTime(actualStart as int)
                  : actualStart)
              : visibleRange!.minimum;
          num max = actualEnd != null
              ? actualValue(actualEnd is num
                  ? indexToDateTime(actualEnd as int)
                  : actualEnd)
              : visibleRange!.maximum;

          num extent;
          if (plotBand.isRepeatable) {
            extent = plotBand.repeatEvery;
            final dynamic actualRepeatUntil = plotBand.repeatUntil;
            if (actualRepeatUntil != null) {
              max = actualValue(actualRepeatUntil is num
                  ? indexToDateTime(actualRepeatUntil as int)
                  : actualRepeatUntil);
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

  // Convert index to DateTime, if the plot band start/end value is index.
  @nonVirtual
  DateTime indexToDateTime(int index) {
    if (labels.isNotEmpty) {
      final int length = labels.length;
      if (index >= 0 && index <= length) {
        return DateTime.fromMillisecondsSinceEpoch(labels[index]);
      } else if (index > length) {
        return DateTime.fromMillisecondsSinceEpoch(labels.last);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(labels.first);
      }
    }
    return DateTime.fromMillisecondsSinceEpoch(index);
  }

  @override
  void generateMultiLevelLabels() {
    _multilevelLabels.clear();
    visibleMultilevelLabels.clear();

    final int length = multiLevelLabels?.length ?? 0;
    if (length == 0) {
      return;
    }

    for (int index = 0; index < length; index++) {
      final DateTimeCategoricalMultiLevelLabel label = multiLevelLabels![index];
      _multilevelLabels.add(AxisMultilevelLabel(
          label.text,
          label.level,
          effectiveValue(label.start)!,
          effectiveValue(label.end, needMin: false)!));
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
    final bool isBetweenTicks = labelPlacement == LabelPlacement.betweenTicks;
    final num betweenTicksInterval = isBetweenTicks ? 0.5 : 0;

    for (final AxisMultilevelLabel label in visibleMultilevelLabels) {
      final num startValue = label.start - betweenTicksInterval;
      final num endValue = label.end + betweenTicksInterval;
      final double start = pointToPixel(startValue);
      final double end = pointToPixel(endValue);
      final double extent = (end - start - textPadding).abs();

      String renderText = label.renderText;
      final TextStyle style = label.style;
      if (label.actualTextSize.width > extent) {
        renderText = trimmedText(renderText, style, extent, 0, isRtl: isRtl);
      }

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

  int? effectiveValue(DateTime? rangeDate, {bool needMin = true}) {
    if (rangeDate == null) {
      return null;
    }

    int index = 0;
    final int rangeDateMs = rangeDate.millisecondsSinceEpoch;
    for (final int label in labels) {
      if (needMin) {
        if (label > rangeDateMs) {
          if (!(labels.first == label)) {
            index++;
          }
          break;
        } else if (label < rangeDateMs) {
          index = labels.indexOf(label);
        } else {
          index = labels.indexOf(label);
          break;
        }
      } else {
        if (label <= rangeDateMs) {
          index = labels.indexOf(label);
        }
        if (label >= rangeDateMs) {
          break;
        }
      }
    }
    return index;
  }

  // During sorting, always keep xValues as linear data.
  void updateXValues() {
    labels.clear();
    for (final AxisDependent dependent in dependents) {
      if (dependent is CartesianSeriesRenderer &&
          dependent.controller.isVisible) {
        final List xRawValues = dependent.xRawValues;
        final int length = xRawValues.length;
        if (length > 0) {
          const int minValue = 0;
          int maxValue = 0;
          for (int i = 0; i < length; i++) {
            final int rawX = (xRawValues[i] as DateTime).millisecondsSinceEpoch;
            if (!labels.contains(rawX)) {
              labels.add(rawX);
            }

            final int index = labels.indexOf(rawX);
            dependent.xValues[i] = index;
            maxValue = max(maxValue, index);
          }
          dependent.xMin = minValue;
          dependent.xMax = maxValue;
        }
      }
    }
  }

  @override
  void dispose() {
    _multilevelLabels.clear();
    controller.dispose();
    super.dispose();
  }
}
