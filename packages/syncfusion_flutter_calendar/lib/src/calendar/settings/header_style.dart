import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Sets the style for customizing the [SfCalendar] header view.
///
/// Allows to customize the [textStyle], [textAlign] and [backgroundColor]
/// in header view of calendar.
///
/// ![header with different style in calendar](https://help.syncfusion.com/flutter/calendar/images/headers/header-style.png)
///
/// ```dart
///Widget build(BuildContext context) {
///  return Container(
///  child: SfCalendar(
///      view: CalendarView.week,
///      headerStyle: CalendarHeaderStyle(
///          textStyle: TextStyle(color: Colors.red, fontSize: 20),
///          textAlign: TextAlign.center,
///          backgroundColor: Colors.blue),
///    ),
///  );
///}
/// ```
@immutable
class CalendarHeaderStyle with Diagnosticable {
  /// Creates a header style for calendar.
  ///
  /// The properties allows to customize the header view of [SfCalendar].
  const CalendarHeaderStyle(
      {this.textAlign = TextAlign.start, this.backgroundColor, this.textStyle});

  /// The text style for the text in the [SfCalendar] header view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///  return Container(
  ///  child: SfCalendar(
  ///      view: CalendarView.week,
  ///      headerStyle: CalendarHeaderStyle(
  ///          textStyle: TextStyle(color: Colors.red, fontSize: 20),
  ///          textAlign: TextAlign.center,
  ///          backgroundColor: Colors.blue),
  ///    ),
  ///  );
  ///}
  /// ```
  final TextStyle? textStyle;

  /// How the text should  be aligned horizontally in [SfCalendar] header view.
  ///
  /// Defaults to `TextAlign.start`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///  return Container(
  ///  child: SfCalendar(
  ///      view: CalendarView.week,
  ///      headerStyle: CalendarHeaderStyle(
  ///          textStyle: TextStyle(color: Colors.red, fontSize: 20),
  ///          textAlign: TextAlign.center,
  ///          backgroundColor: Colors.blue),
  ///    ),
  ///  );
  ///}
  /// ```
  final TextAlign textAlign;

  /// The color which fills the [SfCalendar] header view background.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///  return Container(
  ///  child: SfCalendar(
  ///      view: CalendarView.week,
  ///      headerStyle: CalendarHeaderStyle(
  ///          textStyle: TextStyle(color: Colors.red, fontSize: 20),
  ///          textAlign: TextAlign.center,
  ///          backgroundColor: Colors.blue),
  ///    ),
  ///  );
  ///}
  /// ```
  final Color? backgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CalendarHeaderStyle otherStyle = other;
    return otherStyle.textStyle == textStyle &&
        otherStyle.textAlign == textAlign &&
        otherStyle.backgroundColor == backgroundColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
  }

  @override
  int get hashCode {
    return hashValues(textStyle, textAlign, backgroundColor);
  }
}
