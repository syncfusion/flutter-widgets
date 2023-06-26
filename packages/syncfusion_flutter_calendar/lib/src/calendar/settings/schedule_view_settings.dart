import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The settings have properties which allow to customize the schedule view of
/// the [SfCalendar].
///
/// Allows to customize the [monthHeaderSettings], [weekHeaderSettings],
/// [dayHeaderSettings], [appointmentTextStyle], [appointmentItemHeight] and
///  [hideEmptyScheduleWeek] in schedule view of calendar.
///
/// See also:
/// * [SfCalendar.scheduleViewMonthHeaderBuilder], which used to set custom
/// widget for month header view of schedule view in calendar.
/// * [SfCalendar.scheduleViewSettings], to know about the available
/// customization options for schedule view.
/// * [MonthViewSettings], to know more about the customization options for
/// the month view of calendar.
/// * [TimeSlotViewSettings], which is used to customize the timeslot view of
/// calendar.
/// * Knowledge base: [How to customize appointment height in schedule view](https://www.syncfusion.com/kb/12226/how-to-customize-the-appointment-height-in-schedule-view-of-the-flutter-calendar)
/// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
/// * Knowledge base: [How to customize schedule view month header with builder](https://www.syncfusion.com/kb/12064/how-to-customize-the-schedule-view-month-header-using-builder-in-the-flutter-calendar)
/// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
///
/// ``` dart
///
/// @override
///  Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.schedule,
///        scheduleViewSettings: ScheduleViewSettings(
///            appointmentItemHeight: 60,
///            weekHeaderSettings: WeekHeaderSettings(
///              height: 40,
///              textAlign: TextAlign.center,
///            )),
///      ),
///    );
///  }
///
///  ```
@immutable
class ScheduleViewSettings with Diagnosticable {
  /// Creates a schedule view settings for calendar.
  ///
  /// The properties allows to customize the schedule view of [SfCalendar].
  const ScheduleViewSettings(
      {this.appointmentTextStyle,
      this.appointmentItemHeight = -1,
      this.hideEmptyScheduleWeek = false,
      this.monthHeaderSettings = const MonthHeaderSettings(),
      this.weekHeaderSettings = const WeekHeaderSettings(),
      this.dayHeaderSettings = const DayHeaderSettings(),
      this.placeholderTextStyle =
          const TextStyle(color: Colors.grey, fontSize: 15)})
      : assert(appointmentItemHeight >= -1);

  /// Sets the style to customize month label in [SfCalendar] schedule view.
  ///
  /// Allows to customize the [MonthHeaderSettings.monthFormat],
  /// [MonthHeaderSettings.height], [MonthHeaderSettings.textAlign],
  /// [MonthHeaderSettings.backgroundColor] and
  /// [MonthHeaderSettings.labelTextStyle] in month label style of schedule view
  /// in calendar.
  ///
  /// See also:
  /// * [weekHeaderSettings], which used to customize the week header view
  /// of the schedule view in calendar.
  /// * [dayHeaderSettings], which used to customize the day header view of the
  /// schedule view in calendar.
  /// * [SfCalendar.scheduleViewMonthHeaderBuilder], which used to set custom
  /// widget for month header view of schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize schedule view month header with builder](https://www.syncfusion.com/kb/12064/how-to-customize-the-schedule-view-month-header-using-builder-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  ///@override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            monthHeaderSettings: MonthHeaderSettings(
  ///                monthFormat: 'MMMM, yyyy',
  ///                height: 100,
  ///                textAlign: TextAlign.left,
  ///                backgroundColor: Colors.green,
  ///                monthTextStyle: TextStyle(
  ///                    color: Colors.red,
  ///                    fontSize: 25,
  ///                    fontWeight: FontWeight.w400))),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final MonthHeaderSettings monthHeaderSettings;

  /// Sets the style to customize week label in [SfCalendar] schedule view.
  ///
  /// Allows to customize the [WeekHeaderSettings.startDateFormat],
  /// [WeekHeaderSettings.endDateFormat], [WeekHeaderSettings.height],
  /// [WeekHeaderSettings.textAlign], [WeekHeaderSettings.backgroundColor] and
  /// [WeekHeaderSettings.labelTextStyle] in week label style of schedule view
  /// in calendar.
  ///
  /// See also:
  /// * [monthHeaderSettings], which used to customize the month header view
  /// of the schedule view in calendar.
  /// * [dayHeaderSettings], which used to customize the day header view of the
  /// schedule view in calendar.
  /// * [hideEmptyScheduleWeek], which used to hide the week header if the week
  /// doesn't have any appointment on it.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            weekHeaderSettings: WeekHeaderSettings(
  ///                startDateFormat: 'dd MMM ',
  ///                endDateFormat: 'dd MMM, yy',
  ///                height: 50,
  ///                textAlign: TextAlign.center,
  ///                backgroundColor: Colors.red,
  ///                weekTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontWeight: FontWeight.w400,
  ///                  fontSize: 15,
  ///                ))),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final WeekHeaderSettings weekHeaderSettings;

  /// Sets the style to customize day label in [SfCalendar] schedule view.
  ///
  /// Allows to customize the [DayHeaderSettings.dayFormat],
  /// [DayHeaderSettings.width], [DayHeaderSettings.backgroundColor],
  /// [DayHeaderSettings.dayTextStyle] and [DayHeaderSettings.dateTextStyle] in
  /// day label style of schedule view in calendar.
  ///
  /// See also:
  /// * [weekHeaderSettings], which used to customize the week header view
  /// of the schedule view in calendar.
  /// * [monthHeaderSettings], which used to customize the month header view of
  /// the schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            dayHeaderSettings: DayHeaderSettings(
  ///                dayFormat: 'EEEE',
  ///                width: 70,
  ///                dayTextStyle: TextStyle(
  ///                  fontSize: 10,
  ///                  fontWeight: FontWeight.w300,
  ///                  color: Colors.white,
  ///                ),
  ///                dateTextStyle: TextStyle(
  ///                  fontSize: 20,
  ///                  fontWeight: FontWeight.w300,
  ///                  color: Colors.white,
  ///                ))),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DayHeaderSettings dayHeaderSettings;

  /// The text style for the text in the [Appointment] view in [SfCalendar]
  /// schedule view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [appointmentItemHeight], which is the size for the appointment view in
  /// the schedule view of calendar.
  /// * [SfCalendar.appointmentBuilder], which used to set custom widget for
  /// appointment view in calendar
  /// * Knowledge base: [How to customize appointment height in schedule view](https://www.syncfusion.com/kb/12226/how-to-customize-the-appointment-height-in-schedule-view-of-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            appointmentTextStyle: TextStyle(
  ///                fontSize: 12, fontWeight: FontWeight.w500,
  ///                   color: Colors.red)),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? appointmentTextStyle;

  /// The text style for the text in the placeholder (no event
  /// text) of the [SfCalendar] schedule view.
  ///
  /// See also:
  /// * [MonthViewSettings], to customize the month view of the calendar.
  /// * [ScheduleViewSettings], to customize the schedule view of the calendar.
  /// * [AgendaStyle], to customize the month agenda view of the calendar.
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: const ScheduleViewSettings(
  ///            placeholderTextStyle: TextStyle(
  ///                color: Colors.white,
  ///                fontSize: 20,
  ///               backgroundColor: Colors.red)),
  ///      ),
  ///    );
  ///  }
  ///
  ///
  final TextStyle placeholderTextStyle;

  /// The height for each appointment view to layout within this in schedule
  /// view of [SfCalendar],.
  ///
  /// Defaults to `-1`.
  ///
  /// See also:
  /// * [appointmentTextStyle], which used to customize the text style for the
  /// text on the appointment view in calendar.
  /// * [SfCalendar.appointmentBuilder], which used to set custom widget for
  /// appointment view in calendar
  /// * Knowledge base: [How to customize appointment height in schedule view](https://www.syncfusion.com/kb/12226/how-to-customize-the-appointment-height-in-schedule-view-of-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///          appointmentItemHeight: 70,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double appointmentItemHeight;

  /// Hides the weeks that doesn’t contain appointment on it.
  ///
  /// Defaults to false.
  ///
  /// See more:
  /// * [weekHeaderSettings], which used to customize the week header view
  /// of the schedule view in calendar.
  /// * [appointmentItemHeight], which is the size for the appointment view in
  /// the schedule view of calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize schedule view month header with builder](https://www.syncfusion.com/kb/12064/how-to-customize-the-schedule-view-month-header-using-builder-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///          hideEmptyScheduleWeek: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool hideEmptyScheduleWeek;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final ScheduleViewSettings otherStyle;
    if (other is ScheduleViewSettings) {
      otherStyle = other;
    }
    return otherStyle.appointmentTextStyle == appointmentTextStyle &&
        otherStyle.appointmentItemHeight == appointmentItemHeight &&
        otherStyle.hideEmptyScheduleWeek == hideEmptyScheduleWeek &&
        otherStyle.monthHeaderSettings == monthHeaderSettings &&
        otherStyle.weekHeaderSettings == weekHeaderSettings &&
        otherStyle.dayHeaderSettings == dayHeaderSettings &&
        otherStyle.placeholderTextStyle == placeholderTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        monthHeaderSettings.toDiagnosticsNode(name: 'monthHeaderSettings'));
    properties
        .add(weekHeaderSettings.toDiagnosticsNode(name: 'weekHeaderSettings'));
    properties
        .add(dayHeaderSettings.toDiagnosticsNode(name: 'dayHeaderSettings'));
    properties.add(DiagnosticsProperty<TextStyle>(
        'appointmentTextStyle', appointmentTextStyle));
    properties
        .add(DoubleProperty('appointmentItemHeight', appointmentItemHeight));
    properties.add(DiagnosticsProperty<bool>(
        'hideEmptyScheduleWeek', hideEmptyScheduleWeek));
    properties.add(DiagnosticsProperty<TextStyle>(
        'placeholderTextStyle', placeholderTextStyle));
  }

  @override
  int get hashCode {
    return Object.hash(
        appointmentTextStyle,
        appointmentItemHeight,
        hideEmptyScheduleWeek,
        monthHeaderSettings,
        weekHeaderSettings,
        dayHeaderSettings,
        placeholderTextStyle);
  }
}

/// Sets the style to customize month label in [SfCalendar] schedule view.
///
/// Allows to customize the [monthFormat], [height], [textAlign],
/// [backgroundColor] and [monthTextStyle] in month label style of schedule view
/// in calendar.
///
/// See also:
/// * [WeekHeaderSettings], which used to customize the week header view
/// of the schedule view in calendar.
/// * [DayHeaderSettings], which used to customize the day header view of the
/// schedule view in calendar.
/// * [SfCalendar.scheduleViewMonthHeaderBuilder], which used to set custom
/// widget for month header view of schedule view in calendar.
/// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
/// * Knowledge base: [How to customize schedule view month header with builder](https://www.syncfusion.com/kb/12064/how-to-customize-the-schedule-view-month-header-using-builder-in-the-flutter-calendar)
/// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
///
/// ``` dart
///
///@override
///  Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.schedule,
///        scheduleViewSettings: ScheduleViewSettings(
///            monthHeaderSettings: MonthHeaderSettings(
///                monthFormat: 'MMMM, yyyy',
///                height: 100,
///                textAlign: TextAlign.left,
///                backgroundColor: Colors.green,
///                monthTextStyle: TextStyle(
///                    color: Colors.red,
///                    fontSize: 25,
///                    fontWeight: FontWeight.w400))),
///      ),
///    );
///  }
///
/// ```
@immutable
class MonthHeaderSettings with Diagnosticable {
  /// Creates a month header settings for schedule view in calendar.
  ///
  /// The properties allows to customize the month header in schedule view  of
  /// [SfCalendar].
  const MonthHeaderSettings(
      {this.monthFormat = 'MMMM yyyy',
      this.height = 150,
      this.textAlign = TextAlign.start,
      this.backgroundColor = const Color.fromRGBO(17, 178, 199, 1),
      this.monthTextStyle})
      : assert(height >= -1);

  /// Formats the month label text in the month label [SfCalendar]
  /// schedule view.
  ///
  /// Defaults to `MMMM yyyy`.
  ///
  /// See also:
  /// * [monthTextStyle], which used to customize the text style for the text
  /// in the month header view in calendar.
  /// * [textAlign], which aligns the month header text in the month header view
  /// of calendar.
  /// * [SfCalendar.scheduleViewMonthHeaderBuilder], which used to set custom
  /// widget for month header view of schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize schedule view month header with builder](https://www.syncfusion.com/kb/12064/how-to-customize-the-schedule-view-month-header-using-builder-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            monthHeaderSettings: MonthHeaderSettings(
  ///                 monthFormat: 'MMMM, yyyy')),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final String monthFormat;

  /// The height for month label to layout within this in [SfCalendar] schedule
  /// view.
  ///
  /// Defaults to `150`.
  ///
  /// See also:
  /// * [backgroundColor], which fills the background of the month header view
  /// of schedule view in calendar.
  /// * [SfCalendar.scheduleViewMonthHeaderBuilder], which used to set custom
  /// widget for month header view of schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize schedule view month header with builder](https://www.syncfusion.com/kb/12064/how-to-customize-the-schedule-view-month-header-using-builder-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            monthHeaderSettings: MonthHeaderSettings(height: 100)),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double height;

  /// How the text should  be aligned horizontally in [SfCalendar] month label
  /// of schedule view.
  ///
  /// Defaults to `TextAlign.center`.
  ///
  /// See also:
  /// * [monthTextStyle], which used to customize the text style for the text
  /// in the month header view in calendar.
  /// * [monthFormat], which formats the text on the month header view of
  /// schedule view in calendar.
  /// * [SfCalendar.scheduleViewMonthHeaderBuilder], which used to set custom
  /// widget for month header view of schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize schedule view month header with builder](https://www.syncfusion.com/kb/12064/how-to-customize-the-schedule-view-month-header-using-builder-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            monthHeaderSettings: MonthHeaderSettings(
  ///                   textAlign: TextAlign.start)),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextAlign textAlign;

  /// The background color to fill the background of the month label view in
  /// [SfCalendar] schedule view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [height], which is the size for the month header view of schedule view
  /// in calendar.
  /// * [SfCalendar.scheduleViewMonthHeaderBuilder], which used to set custom
  /// widget for month header view of schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize schedule view month header with builder](https://www.syncfusion.com/kb/12064/how-to-customize-the-schedule-view-month-header-using-builder-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            monthHeaderSettings:
  ///                MonthHeaderSettings(backgroundColor: Colors.red)),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color backgroundColor;

  /// The text style for the text in the month text of month label [SfCalendar]
  /// schedule view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [textAlign], which aligns the month header text in the month header view
  /// of calendar.
  /// * [monthFormat], which formats the text on the month header view of
  /// schedule view in calendar.
  /// * [SfCalendar.scheduleViewMonthHeaderBuilder], which used to set custom
  /// widget for month header view of schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize schedule view month header with builder](https://www.syncfusion.com/kb/12064/how-to-customize-the-schedule-view-month-header-using-builder-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            monthHeaderSettings: MonthHeaderSettings(
  ///                monthTextStyle: TextStyle(
  ///                    color: Colors.black,
  ///                    fontSize: 20,
  ///                    fontWeight: FontWeight.w400,))),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? monthTextStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final MonthHeaderSettings otherStyle;
    if (other is MonthHeaderSettings) {
      otherStyle = other;
    }
    return otherStyle.monthFormat == monthFormat &&
        otherStyle.height == height &&
        otherStyle.textAlign == textAlign &&
        otherStyle.backgroundColor == backgroundColor &&
        otherStyle.monthTextStyle == monthTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<TextStyle>('monthTextStyle', monthTextStyle));
    properties.add(DoubleProperty('height', height));
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(StringProperty('monthFormat', monthFormat));
  }

  @override
  int get hashCode {
    return Object.hash(
        monthFormat, height, textAlign, backgroundColor, monthTextStyle);
  }
}

/// Sets the style to customize week label in [SfCalendar] schedule view.
///
/// Allows to customize the [startDateFormat], [endDateFormat], [height],
/// [textAlign], [backgroundColor] and [weekTextStyle] in week label style of
/// schedule view in calendar.
///
/// See also:
/// * [MonthHeaderSettings], which used to customize the month header view
/// of the schedule view in calendar.
/// * [DayHeaderSettings], which used to customize the day header view of the
/// schedule view in calendar.
/// * [ScheduleViewSettings.hideEmptyScheduleWeek], which used to hide the week
/// header if the week doesn't have any appointment on it.
/// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
/// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
///
/// ``` dart
///
/// @override
///  Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.schedule,
///        scheduleViewSettings: ScheduleViewSettings(
///            weekHeaderSettings: WeekHeaderSettings(
///                startDateFormat: 'dd MMM ',
///                endDateFormat: 'dd MMM, yy',
///                height: 50,
///                textAlign: TextAlign.center,
///                backgroundColor: Colors.red,
///                weekTextStyle: TextStyle(
///                  color: Colors.white,
///                  fontWeight: FontWeight.w400,
///                  fontSize: 15,
///                ))),
///      ),
///    );
///  }
///
/// ```
@immutable
class WeekHeaderSettings with Diagnosticable {
  /// Creates a week header settings for schedule view in calendar.
  ///
  /// The properties allows to customize the week header in schedule view  of
  /// [SfCalendar].
  const WeekHeaderSettings(
      {this.startDateFormat,
      this.endDateFormat,
      this.height = 30,
      this.textAlign = TextAlign.start,
      this.backgroundColor = Colors.transparent,
      this.weekTextStyle})
      : assert(height >= -1);

  /// Formats the week start date text in the week label of [SfCalendar]
  /// schedule view.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [endDateFormat], which used to format the end date text in the week
  /// header view of schedule view in calendar.
  /// * [textAlign], which used to align the text on the week header view of
  /// schedule view in calendar.
  /// * [weekTextStyle], which used to customize the text style for the text in
  /// the week header view of schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            weekHeaderSettings: WeekHeaderSettings(
  ///              startDateFormat: 'MMM, dd'
  ///            )),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final String? startDateFormat;

  /// Formats the week end date text in the week label of [SfCalendar]
  /// schedule view.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [startDateFormat], which used to format the start date text in the week
  /// header view of schedule view in calendar.
  /// * [textAlign], which used to align the text on the week header view of
  /// schedule view in calendar.
  /// * [weekTextStyle], which used to customize the text style for the text in
  /// the week header view of schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            weekHeaderSettings: WeekHeaderSettings(
  ///              endDateFormat: 'dd, MMM, yyyy'
  ///            )),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final String? endDateFormat;

  /// The height for week label to layout within this in [SfCalendar] schedule
  /// view.
  ///
  /// Defaults to `30`.
  ///
  /// See also:
  /// * [backgroundColor], which used to fill the background of the week header
  /// view in the schedule  view of calendar.
  /// * [weekTextStyle], which used to customize the text style for the text in
  /// the week header view of schedule view in calendar.
  /// * [startDateFormat], which used to format the start date text in the week
  /// header view of schedule view in calendar.
  /// * [endDateFormat], which used to format the end date text in the week
  /// header view of schedule view in calendar.
  /// * [textAlign], which used to align the text on the week header view of
  /// schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            weekHeaderSettings: WeekHeaderSettings(
  ///          height: 50,
  ///        )),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double height;

  /// How the text should be aligned horizontally in [SfCalendar] week label of
  /// schedule view.
  ///
  /// Defaults to `TextAlign.start`.
  ///
  /// See also:
  /// * [backgroundColor], which used to fill the background of the week header
  /// view in the schedule  view of calendar.
  /// * [weekTextStyle], which used to customize the text style for the text in
  /// the week header view of schedule view in calendar.
  /// * [startDateFormat], which used to format the start date text in the week
  /// header view of schedule view in calendar.
  /// * [endDateFormat], which used to format the end date text in the week
  /// header view of schedule view in calendar.
  /// * [height], which is the size for the week header view in the schedule
  /// view of calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            weekHeaderSettings: WeekHeaderSettings(
  ///                   textAlign: TextAlign.center)),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextAlign textAlign;

  /// The background color to fill the background of the week label in
  /// [SfCalendar] schedule view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [height], which is the size for the week header view in the schedule
  /// view of calendar.
  /// * [weekTextStyle], which used to customize the text style for the text in
  /// the week header view of schedule view in calendar.
  /// * [startDateFormat], which used to format the start date text in the week
  /// header view of schedule view in calendar.
  /// * [endDateFormat], which used to format the end date text in the week
  /// header view of schedule view in calendar.
  /// * [textAlign], which used to align the text on the week header view of
  /// schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            weekHeaderSettings: WeekHeaderSettings(
  ///                 backgroundColor: Colors.red)),
  ///     ),
  ///    );
  ///  }
  ///
  /// ```
  final Color backgroundColor;

  /// The text style for the text in the week text of week label in [SfCalendar]
  /// schedule view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [backgroundColor], which used to fill the background of the week header
  /// view in the schedule  view of calendar.
  /// * [height], which is the size for the week header view in the schedule
  /// view of calendar.
  /// * [startDateFormat], which used to format the start date text in the week
  /// header view of schedule view in calendar.
  /// * [endDateFormat], which used to format the end date text in the week
  /// header view of schedule view in calendar.
  /// * [textAlign], which used to align the text on the week header view of
  /// schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            weekHeaderSettings: WeekHeaderSettings(
  ///                weekTextStyle: TextStyle(
  ///                     color: Colors.black, fontSize: 15))),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? weekTextStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final WeekHeaderSettings otherStyle;
    if (other is WeekHeaderSettings) {
      otherStyle = other;
    }
    return otherStyle.startDateFormat == startDateFormat &&
        otherStyle.height == height &&
        otherStyle.textAlign == textAlign &&
        otherStyle.backgroundColor == backgroundColor &&
        otherStyle.endDateFormat == endDateFormat &&
        otherStyle.weekTextStyle == weekTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<TextStyle>('weekTextStyle', weekTextStyle));
    properties.add(DoubleProperty('height', height));
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(StringProperty('startDateFormat', startDateFormat));
    properties.add(StringProperty('endDateFormat', endDateFormat));
  }

  @override
  int get hashCode {
    return Object.hash(startDateFormat, endDateFormat, height, textAlign,
        backgroundColor, weekTextStyle);
  }
}

/// Sets the style to customize day label in [SfCalendar] schedule view.
///
/// Allows to customize the [dayFormat], [width], [dayTextStyle]
/// and [dateTextStyle] in day label style of schedule view in calendar.
///
/// See also:
/// * [WeekHeaderSettings], which used to customize the week header view
/// of the schedule view in calendar.
/// * [MonthHeaderSettings], which used to customize the month header view of
/// the schedule view in calendar.
/// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
/// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
///
/// ``` dart
///
/// @override
///  Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.schedule,
///        scheduleViewSettings: ScheduleViewSettings(
///            dayHeaderSettings: DayHeaderSettings(
///                dayFormat: 'EEEE',
///                width: 70,
///                dayTextStyle: TextStyle(
///                  fontSize: 10,
///                  fontWeight: FontWeight.w300,
///                  color: Colors.white,
///                ),
///                dateTextStyle: TextStyle(
///                  fontSize: 20,
///                  fontWeight: FontWeight.w300,
///                  color: Colors.white,
///                ))),
///      ),
///    );
///  }
///
/// ```
@immutable
class DayHeaderSettings with Diagnosticable {
  /// Creates a day header settings for schedule view in calendar.
  ///
  /// The properties allows to customize the day header in schedule view  of
  /// [SfCalendar].
  const DayHeaderSettings(
      {this.dayFormat = 'EEE',
      this.width = -1,
      this.dayTextStyle,
      this.dateTextStyle})
      : assert(width >= -1);

  /// Formats the day text in the day label of [SfCalendar] schedule view.
  ///
  /// Defaults to `EEE`.
  ///
  /// See also:
  /// * [dayTextStyle], which used to customize the text style for the day text
  /// in the day header of schedule view in calendar.
  /// * [dateTextStyle], which used to customize the text style for the date
  /// text in the day header of schedule view in calendar
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            dayHeaderSettings: DayHeaderSettings(dayFormat: 'EEEE')),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final String dayFormat;

  /// The width for day label to layout within this in [SfCalendar] schedule
  /// view.
  ///
  /// Defaults to `50`.
  ///
  /// See also:
  /// * [dayTextStyle], which used to customize the text style for the day text
  /// in the day header of schedule view in calendar.
  /// * [dateTextStyle], which used to customize the text style for the date
  /// text in the day header of schedule view in calendar.
  /// * [dayFormat], which used to format the day text in the day header view
  /// of schedule view in calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings:
  ///            ScheduleViewSettings(
  ///                 dayHeaderSettings: DayHeaderSettings(width: 70)),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double width;

  /// The text style for the day text in the day label of [SfCalendar]
  /// schedule view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [dateTextStyle], which used to customize the text style for the date
  /// text in the day header of schedule view in calendar.
  /// * [dayFormat], which used to format the day text in the day header view
  /// of schedule view in calendar.
  /// * [width], which is the size for the week header view of schedule view of
  /// calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            dayHeaderSettings: DayHeaderSettings(
  ///          dayTextStyle: TextStyle(
  ///            fontSize: 10,
  ///            fontWeight: FontWeight.w300,
  ///            color: Colors.white,
  ///          ),
  ///        )),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? dayTextStyle;

  /// The text style for the date text in the day label of [SfCalendar] schedule
  /// view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [dayTextStyle], which used to customize the text style for the day text
  /// in the day header of schedule view in calendar.
  /// * [dayFormat], which used to format the day text in the day header view
  /// of schedule view in calendar.
  /// * [width], which is the size for the week header view of schedule view of
  /// calendar.
  /// * Knowledge base: [How to customize day, week, month header of schedule view](https://www.syncfusion.com/kb/12178/how-to-customize-the-day-week-month-header-of-schedule-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the schedule view](https://www.syncfusion.com/kb/11795/how-to-customize-the-schedule-view-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.schedule,
  ///        scheduleViewSettings: ScheduleViewSettings(
  ///            dayHeaderSettings: DayHeaderSettings(
  ///          dateTextStyle: TextStyle(
  ///            fontSize: 10,
  ///            fontWeight: FontWeight.w300,
  ///            color: Colors.white,
  ///          ),
  ///        )),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? dateTextStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final DayHeaderSettings otherStyle;
    if (other is DayHeaderSettings) {
      otherStyle = other;
    }
    return otherStyle.dayFormat == dayFormat &&
        otherStyle.width == width &&
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
    properties.add(DoubleProperty('width', width));
    properties.add(StringProperty('dayFormat', dayFormat));
  }

  @override
  int get hashCode {
    return Object.hash(dayFormat, width, dayTextStyle, dateTextStyle);
  }
}
