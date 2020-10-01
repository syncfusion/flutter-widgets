part of sliders;

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

/// The value will be either [double] or [DateTime] based on the [values].
typedef SfSliderSemanticFormatterCallback = String Function(dynamic value);

typedef SfRangeSliderSemanticFormatterCallback = String Function(
    SfRangeValues values);

typedef SfRangeSelectorSemanticFormatterCallback = String Function(
    SfRangeValues values);

/// Option to place the labels either between the major ticks
/// or on the major ticks.
enum LabelPlacement {
  /// onTicks places the labels on the major ticks.
  onTicks,

  /// betweenTicks places the labels between the major ticks.
  betweenTicks
}

/// The type of date interval. It can be years to seconds.
enum DateIntervalType {
  /// Date interval is year.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 00) and
  /// [max] is DateTime(2005, 12, 31, 24) and [interval] is 1 and
  /// [dateIntervalType] is [years] then range slider
  /// will render labels for 2000, 2001, 2002, 2003, 2004, 2005 respectively.
  years,

  /// Date interval is month.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 00) and
  /// [max] is DateTime(2000, 12, 31, 24) and [interval] is 3 and
  /// [dateIntervalType] is [months] then range slider will render labels
  /// for [Jan 01, 2000], [Apr 01, 2000], [Jul 01, 2000], [Oct 01, 2000]
  /// and [Jan 01, 2001] respectively.
  months,

  /// Date interval is day.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 00) and
  /// [max] is DateTime(2000, 01, 25, 24) and [interval] is 5 and
  /// [dateIntervalType] is [days] then range slider will render labels
  /// for [Jan 01, 2000], [Jan 06, 2000], [Jan 11, 2000], [Jan 16, 2000],
  /// [Jan 21, 2001] and [Jan 26, 2001] respectively.
  days,

  /// Date interval is hour.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 09) and
  /// [max] is DateTime(2000, 01, 01, 17) and [interval] is 4 and
  /// [dateIntervalType] is [hours] then range slider will render labels for
  /// [Jan 01, 2000 09:00], [Jan 01, 2000 13:00], and [Jan 01, 2000 17:00]
  /// respectively.
  hours,

  /// Date interval is minute.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 09) and
  /// [max] is DateTime(2000, 01, 01, 10) and [interval] is 15 and
  /// [dateIntervalType] is [minutes] then range slider will render labels for
  /// [Jan 01, 2000 09:00], [Jan 01, 2000 09:15], [Jan 01, 2000 09:30],
  /// [Jan 01, 2000 09:45]and [Jan 01, 2000 10:00] respectively.
  minutes,

  /// Date interval is second.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 09, 00) and
  /// [max] is DateTime(2000, 01, 01, 09, 01) and [interval] is 20 and
  /// [dateIntervalType] is [seconds] then range slider will render labels for
  /// [Jan 01, 2000 09:00:00], [Jan 01, 2000 09:00:20], [Jan 01, 2000 09:00:40],
  /// and [Jan 01, 2000 09:01:00] respectively.
  seconds
}

/// Represents the [SfRangeSlider] or [SfRangeSelector] thumbs.
enum SfThumb {
  /// start represents the [SfRangeValues.start] thumb.
  start,

  /// end represents the [SfRangeValues.end] thumb.
  end
}

/// Represents the [SfRangeSlider] or [SfRangeSelector] child elements.
enum _ChildElements {
  /// Represents the icon for [SfRangeValues.start] thumb.
  startThumbIcon,

  /// Represents the icon for [SfRangeValues.start] thumb.
  endThumbIcon,

  /// Represents the content of [SfRangeSelector].
  child,
}

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

enum _PointerType {
  down,

  move,

  up
}

const double _minPreferredTouchWidth = 20;

/// Represents the current selected values of [SfRangeSlider]
/// and [SfRangeSelector].
@immutable
class SfRangeValues {
  /// Represents the current selected values of [SfRangeSlider]
  /// and [SfRangeSelector].
  const SfRangeValues(this.start, this.end);

  /// Represents the [SfRangeValues.start] thumb.
  final dynamic start;

  /// Represents the [SfRangeValues.end] thumb.
  final dynamic end;

  SfRangeValues _copyWith({dynamic start, dynamic end}) {
    // HACK: In web, 0.00 and 0 are considered as identical.
    // So, we had considered both double and int.
    if (start != null &&
        (start.runtimeType == double || start.runtimeType == int) &&
        this.end.runtimeType == DateTime) {
      final double value = start;
      return SfRangeValues(
          DateTime.fromMillisecondsSinceEpoch(value.toInt()), end ?? this.end);
    } else if (end != null &&
        (end.runtimeType == double || end.runtimeType == int) &&
        this.start.runtimeType == DateTime) {
      final double value = end;
      return SfRangeValues(start ?? this.start,
          DateTime.fromMillisecondsSinceEpoch(value.toInt()));
    }

    return SfRangeValues(start ?? this.start, end ?? this.end);
  }
}

/// The class which is used to set step duration for date discrete support.
///
/// See also:
///
/// * [interval], for setting the interval.
class SliderStepDuration {
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

  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
}

// Minimum tooltip radius
const double _minPaddleTopCircleRadius = 16;
// Difference between paddle top circle and neck radius
const double _neckDifference = 3.0;
// minimum bottom neck radius
const double _minBottomNeckRadius = 4.0;
// Thumb radius is greater than default thumb radius,
// increasing the bottom neck radius based on thumb radius.
const double _defaultThumbRadius = 10.0;
// To get the shape of the paddle,
// move the neck as quarters of paddle circle radius.
const double _moveNeckValue = 0.25;
const double _textPadding = 8.0;

const Offset _tooltipTextPadding = Offset(15, 15);
const double _tooltipTriangleHeight = 7;
const double _tooltipTriangleWidth = 12;
const double _minTooltipWidth = 47.0;
const double _minTooltipHeight = 37.0;
const double _cornerRadius = 4.0;

const double _defaultElevation = 1.0;
const double _tappedElevation = 6.0;
const Color _shadowColor = Colors.black;
