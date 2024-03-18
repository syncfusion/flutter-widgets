import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Sets the style to customize the week number text of [SfCalendar].
///
/// Allows to customize the [backgroundColor], [textStyle] in
/// week number of calendar.
///
/// ```dart
///
///Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.month,
///        showWeekNumber: true,
///        weekNumberStyle: WeekNumberStyle(
///            backgroundColor: Colors.blue,
///            textStyle: TextStyle(color: Colors.grey, fontSize: 20),
///      ),
///    );
///  }
///
/// ```
@immutable
class WeekNumberStyle with Diagnosticable {
  /// Creates a week number style for calendar.
  ///
  /// The properties allows to customize the week number [SfCalendar].
  const WeekNumberStyle({this.backgroundColor, this.textStyle});

  /// The color that fills the background of the week number panel.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar
  ///
  /// See also:
  /// * [textStyle], which used to apply style for the text in the week number
  /// view in calendar.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        showWeekNumber: true,
  ///        weekNumberStyle: WeekNumberStyle(
  ///            backgroundColor: Colors.blue,
  ///            textStyle: TextStyle(color: Colors.grey, fontSize: 20),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color? backgroundColor;

  /// The text style to customize week number text of the SfCalendar.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [backgroundColor], which used to fill the background of the weeknumber
  /// panel in the calendar.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        showWeekNumber: true,
  ///        weekNumberStyle: WeekNumberStyle(
  ///            backgroundColor: Colors.blue,
  ///            textStyle: TextStyle(color: Colors.grey, fontSize: 20),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle? textStyle;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final WeekNumberStyle otherStyle;
    if (other is WeekNumberStyle) {
      otherStyle = other;
    }
    return otherStyle.backgroundColor == backgroundColor &&
        otherStyle.textStyle == textStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<TextStyle>('dayTextStyle', textStyle));
  }

  @override
  int get hashCode {
    return Object.hash(
      backgroundColor,
      textStyle,
    );
  }
}
