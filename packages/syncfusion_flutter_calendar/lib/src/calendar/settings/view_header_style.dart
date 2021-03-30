import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Sets the style to customize [SfCalendar] view header.
///
/// Allows to customize the [backgroundColor], [dayTextStyle] and
/// [dateTextStyle] in view header of calendar.
///
/// ![view header with different style in calendar](https://help.syncfusion.com/flutter/calendar/images/headers/viewheader-style.png)
///
/// ```dart
///
///Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.week,
///        viewHeaderStyle: ViewHeaderStyle(
///            backgroundColor: Colors.blue,
///            dayTextStyle: TextStyle(color: Colors.grey, fontSize: 20),
///            dateTextStyle: TextStyle(color: Colors.grey, fontSize: 25)),
///      ),
///    );
///  }
///
/// ```
@immutable
class ViewHeaderStyle with Diagnosticable {
  /// Creates a view header style for calendar.
  ///
  /// The properties allows to customize the view header view of [SfCalendar].
  const ViewHeaderStyle(
      {this.backgroundColor, this.dateTextStyle, this.dayTextStyle});

  /// The color which fills the background of [SfCalendar] view header view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        viewHeaderStyle: ViewHeaderStyle(
  ///            backgroundColor: Colors.blue,
  ///            dayTextStyle: TextStyle(color: Colors.grey, fontSize: 20),
  ///            dateTextStyle: TextStyle(color: Colors.grey, fontSize: 25)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color? backgroundColor;

  /// The text style for the date text in the [SfCalendar] view header view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// _Note:_ This property doesn't applicable when the calendar view set as
  /// [CalendarView.month].
  ///
  /// The text color set to this doesn't apply for the today cell in view header
  /// of day/week/workweek view.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        viewHeaderStyle: ViewHeaderStyle(
  ///            backgroundColor: Colors.blue,
  ///            dayTextStyle: TextStyle(color: Colors.grey, fontSize: 20),
  ///            dateTextStyle: TextStyle(color: Colors.grey, fontSize: 25)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle? dateTextStyle;

  /// The text style for the day text in the [SfCalendar] view header view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        viewHeaderStyle: ViewHeaderStyle(
  ///            backgroundColor: Colors.blue,
  ///            dayTextStyle: TextStyle(color: Colors.grey, fontSize: 20),
  ///            dateTextStyle: TextStyle(color: Colors.grey, fontSize: 25)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle? dayTextStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ViewHeaderStyle otherStyle = other;
    return otherStyle.backgroundColor == backgroundColor &&
        otherStyle.dayTextStyle == dayTextStyle &&
        otherStyle.dateTextStyle == dateTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<TextStyle>('dayTextStyle', dayTextStyle));
    properties
        .add(DiagnosticsProperty<TextStyle>('dateTextStyle', dateTextStyle));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }

  @override
  int get hashCode {
    return hashValues(
      backgroundColor,
      dayTextStyle,
      dateTextStyle,
    );
  }
}
