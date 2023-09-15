import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs

/// Signature for formatting or changing the whole numeric or date label text.
typedef LabelFormatterCallback = String Function(

    /// actualValue will be either [DateTime] or [double]
    /// based on given [values].
    dynamic actualValue,

    /// If the actual value is [double], it is formatted by [numberFormat] and
    /// if the actual value is [DateTime], it is formatted by [dateFormat].
    String formattedText);

/// Signature for formatting or changing the whole tooltip label text.
typedef TooltipTextFormatterCallback = String Function(

    /// actualValue will be either [DateTime] or [double]
    /// based on given [values].
    dynamic actualValue,

    /// If the actual value is [double], it is formatted by [numberFormat] and
    /// if the actual value is [DateTime], it is formatted by [dateFormat].
    String formattedText);

/// The value will be either [double] or [DateTime] based on the `values`.
typedef SfSliderSemanticFormatterCallback = String Function(dynamic value);

typedef RangeSliderSemanticFormatterCallback = String Function(
    dynamic value, SfThumb thumb);

typedef RangeSelectorSemanticFormatterCallback = String Function(
    dynamic value, SfThumb thumb);

/// Option to place the labels either between the major ticks
/// or on the major ticks.
enum LabelPlacement {
  /// onTicks places the labels on the major ticks.
  onTicks,

  /// betweenTicks places the labels between the major ticks.
  betweenTicks
}

/// Placement of edge labels in the axis.
enum EdgeLabelPlacement {
  /// - EdgeLabelPlacement.auto, places the edge labels in its own position.
  auto,

  /// - EdgeLabelPlacement.inside, shift the edge labels inside the plot area
  /// bounds.
  inside
}

/// The type of date interval. It can be years to seconds.
enum DateIntervalType {
  /// Date interval is year.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01, 00) and
  /// `max` is DateTime(2005, 12, 31, 24) and `interval` is 1 and
  /// `dateIntervalType` is [years] then range slider
  /// will render labels for 2000, 2001, 2002, 2003, 2004, 2005 respectively.
  years,

  /// Date interval is month.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01, 00) and
  /// `max` is DateTime(2000, 12, 31, 24) and `interval` is 3 and
  /// `dateIntervalType` is [months] then range slider will render labels
  /// for `Jan 01, 2000`, `Apr 01, 2000`, `Jul 01, 2000`, `Oct 01, 2000`
  /// and `Jan 01, 2001` respectively.
  months,

  /// Date interval is day.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01, 00) and
  /// `max` is DateTime(2000, 01, 25, 24) and `interval` is 5 and
  /// `dateIntervalType` is [days] then range slider will render labels
  /// for `Jan 01, 2000`, `Jan 06, 2000`, `Jan 11, 2000`, `Jan 16, 2000`,
  /// `Jan 21, 2001` and `Jan 26, 2001` respectively.
  days,

  /// Date interval is hour.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01, 09) and
  /// `max` is DateTime(2000, 01, 01, 17) and `interval` is 4 and
  /// `dateIntervalType` is [hours] then range slider will render labels for
  /// `Jan 01, 2000 09:00`, `Jan 01, 2000 13:00`, and `Jan 01, 2000 17:00`
  /// respectively.
  hours,

  /// Date interval is minute.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01, 09) and
  /// `max` is DateTime(2000, 01, 01, 10) and `interval` is 15 and
  /// `dateIntervalType` is [minutes] then range slider will render labels for
  /// `Jan 01, 2000 09:00`, `Jan 01, 2000 09:15`, `Jan 01, 2000 09:30`,
  /// `Jan 01, 2000 09:45` and `Jan 01, 2000 10:00` respectively.
  minutes,

  /// Date interval is second.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01, 09, 00) and
  /// `max` is DateTime(2000, 01, 01, 09, 01) and `interval` is 20 and
  /// `dateIntervalType` is [seconds] then range slider will render labels for
  /// `Jan 01, 2000 09:00:00`, `Jan 01, 2000 09:00:20`, `Jan 01, 2000 09:00:40`,
  /// and `Jan 01, 2000 09:01:00` respectively.
  seconds
}

/// Represents the [SfRangeSlider] or [SfRangeSelector] thumbs.
enum SfThumb {
  /// start represents the [SfRangeValues.start] thumb.
  start,

  /// end represents the [SfRangeValues.end] thumb.
  end,

  /// both represents the [SfRangeValues.start] and [SfRangeValues.end] thumb.
  both,

  /// represents none of the thumb.
  none
}

/// Represents the dragging behavior of the [SfRangeSelector] thumbs.
enum SliderDragMode {
  /// When [SliderDragMode] is set to [SliderDragMode.onThumb],
  /// individual thumb can be moved by dragging it.
  onThumb,

  /// When [SliderDragMode] is set to [SliderDragMode.betweenThumbs],
  /// both the thumbs can be moved at the same time by dragging in the area
  /// between start and end thumbs. The range between the start and end thumb
  /// will always be the same. Hence, it is not possible to move the
  /// individual thumb.
  betweenThumbs,

  /// When [SliderDragMode] is set to [SliderDragMode.both], individual thumb
  /// can be moved by dragging it, and also both the thumbs can be moved
  /// at the same time by dragging in the area between start and end thumbs.
  both
}

enum SliderTooltipPosition { left, right }

/// Represents the current selected values of [SfRangeSlider]
/// and [SfRangeSelector].
@immutable
class SfRangeValues extends DiagnosticableTree {
  /// Represents the current selected values of [SfRangeSlider]
  /// and [SfRangeSelector].
  const SfRangeValues(this.start, this.end);

  /// Represents the [SfRangeValues.start] thumb.
  final dynamic start;

  /// Represents the [SfRangeValues.end] thumb.
  final dynamic end;

  SfRangeValues copyWith({dynamic start, dynamic end}) {
    if (start != null &&
        start.runtimeType == num &&
        this.end.runtimeType == DateTime) {
      // ignore: avoid_as
      final double value = start as double;
      return SfRangeValues(
          DateTime.fromMillisecondsSinceEpoch(value.toInt()), end ?? this.end);
    } else if (end != null &&
        end.runtimeType == num &&
        this.start.runtimeType == DateTime) {
      // ignore: avoid_as
      final double value = end as double;
      return SfRangeValues(start ?? this.start,
          DateTime.fromMillisecondsSinceEpoch(value.toInt()));
    }

    return SfRangeValues(start ?? this.start, end ?? this.end);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('start', start));
    properties.add(DiagnosticsProperty<dynamic>('end', end));
  }
}

/// The class which is used to set step duration for date discrete support.
///
/// See also:
///
/// * `interval`, for setting the interval.
class SliderStepDuration extends DiagnosticableTree {
  /// The discrete position is calculated by adding the arguments
  /// given in the [SliderStepDuration] object.
  /// By default, all arguments values are zero.
  const SliderStepDuration(
      {this.years = 0,
      this.months = 0,
      this.days = 0,
      this.hours = 0,
      this.minutes = 0,
      this.seconds = 0});

  /// Moves the thumbs based on years.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01) and
  /// `max` is DateTime(2006, 01, 01) and `SliderDuration(years: 2)` then the
  /// thumb will get moved at DateTime(2000, 01, 01), DateTime(2002, 07, 01),
  /// DateTime(2004, 01, 01), and DateTime(2006, 07, 01).
  final int years;

  /// Moves the thumbs based on months.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01) and
  /// `max` is DateTime(2000, 10, 01) and `SliderDuration(months: 3)` then the
  /// thumb will get moved at DateTime(2000, 01, 01), DateTime(2000, 04, 01),
  /// DateTime(2000, 07, 01), and DateTime(2000, 10, 01).
  final int months;

  /// Moves the thumbs based on days.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01) and
  /// `max` is DateTime(2000, 01, 20) and `SliderDuration(days: 5)` then the
  /// thumb will get moved at DateTime(2000, 01, 01), DateTime(2000, 01, 06),
  /// DateTime(2000, 01, 11), DateTime(2000, 01, 16), and
  /// DateTime(2000, 01, 20).
  final int days;

  /// Moves the thumbs based on hours.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01, 05) and
  /// `max` is DateTime(2006, 01, 01, 20) and `SliderDuration(hours: 5)` then
  /// the thumb will get moved at DateTime(2000, 01, 01, 05),
  /// DateTime(2000, 01, 01, 11), DateTime(2000, 01, 01, 16),
  /// and DateTime(2000, 01, 01, 20).
  final int hours;

  /// Moves the thumbs based on minutes.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01, 05, 10) and
  /// `max` is DateTime(2006, 01, 01, 05, 40) and `SliderDuration(minutes: 10)`
  /// then the thumb will get moved at DateTime(2000, 01, 01, 05, 10),
  /// DateTime(2000, 01, 01, 05, 20), DateTime(2000, 01, 01, 05, 30),
  /// and DateTime(2000, 01, 01, 05, 40).
  final int minutes;

  /// Moves the thumbs based on seconds.
  ///
  /// For example, if `min` is DateTime(2000, 01, 01, 05, 10, 00) and
  /// `max` is DateTime(2006, 01, 01, 05, 12, 00) and
  /// `SliderDuration(seconds: 30)` then the thumb will get moved at
  /// DateTime(2006, 01, 01, 05, 10, 00), DateTime(2006, 01, 01, 05, 10, 30)),
  /// DateTime(2006, 01, 01, 05, 11, 00), DateTime(2006, 01, 01, 05, 11, 30),
  /// and DateTime(2006, 01, 01, 05, 12, 00).
  final int seconds;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(IntProperty('years', years));
    properties.add(IntProperty('months', months));
    properties.add(IntProperty('days', days));
    properties.add(IntProperty('hours', hours));
    properties.add(IntProperty('minutes', minutes));
    properties.add(IntProperty('seconds', seconds));
  }
}
