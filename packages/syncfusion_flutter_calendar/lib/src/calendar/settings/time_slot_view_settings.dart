import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../calendar.dart';

/// The settings have properties which allow to customize the time slot views
/// of the [SfCalendar].
///
/// Allows to customize the [startHour], [endHour], [nonWorkingDays],
/// [timeInterval], [timeIntervalHeight], [timeFormat], [dateFormat],[dayFormat]
/// and [timeRulerSize] in time slot views of calendar.
///
/// See also:
/// * [MonthViewSettings], to know more about the customization options for
/// the month view of calendar.
/// * [ScheduleViewSettings], to know more about the customization options for
/// the schedule view of calendar.
/// * [TimeRegion], which used to customize an particular cell in the timeslot
/// views of calendar.
/// * Knowledge base: [How to customize time label](https://www.syncfusion.com/kb/11008/how-to-customize-the-time-label-in-the-flutter-calendar)
/// * Knowledge base: [How to change the time interval width and height](https://www.syncfusion.com/kb/12322/how-to-change-the-time-interval-width-and-height-in-the-flutter-event-calendar-sfcalendar)
/// * Knowledge base: [How to set the arbitrary height to an appointment](https://www.syncfusion.com/kb/12279/how-to-set-the-arbitrary-height-to-appointments-in-the-flutter-calendar)
/// * Knowledge base: [How to auto fit the calendar to screen height](https://www.syncfusion.com/kb/12231/how-to-autofit-the-calendar-to-screen-height-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the timeline appointment height](https://www.syncfusion.com/kb/12147/how-to-customize-the-timeline-appointment-height-in-the-flutter-calendar)
/// * Knowledge base: [How to change working days and hours](https://www.syncfusion.com/kb/12146/how-to-change-the-working-days-and-hours-in-the-flutter-calendar)
/// * Knowledge base: [How to format the view header day and date format](https://www.syncfusion.com/kb/12339/how-to-format-the-view-header-day-and-date-in-the-flutter-calendar)
/// * Knowledge base: [How to add custom fonts](https://www.syncfusion.com/kb/12101/how-to-add-custom-fonts-in-the-flutter-calendar)
/// * Knowledge base: [How to format the date and time in timeline views](https://www.syncfusion.com/kb/11997/how-to-format-the-date-and-time-in-timeline-views-in-the-flutter-calendar)
/// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11899/how-to-apply-theming-in-flutter-calendar)
/// * Knowledge base: [How to highlight working and non working hours](https://www.syncfusion.com/kb/11711/how-to-highlight-the-working-and-non-working-hours-in-the-flutter-calendar)
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.workWeek,
///        timeSlotViewSettings: TimeSlotViewSettings(
///            startHour: 10,
///            endHour: 20,
///            nonWorkingDays: <int>[
///              DateTime.saturday,
///              DateTime.sunday,
///              DateTime.friday
///            ],
///            timeInterval: Duration(minutes: 120),
///            timeIntervalHeight: 80,
///            timeFormat: 'h:mm',
///            dateFormat: 'd',
///            dayFormat: 'EEE',
///            timeRulerSize: 70),
///      ),
///    );
///  }
/// ```
@immutable
class TimeSlotViewSettings with Diagnosticable {
  /// Creates a timeslot view settings for calendar.
  ///
  /// The properties allows to customize the timeslot views of [SfCalendar].
  const TimeSlotViewSettings(
      {this.startHour = 0,
      this.endHour = 24,
      this.nonWorkingDays = const <int>[DateTime.saturday, DateTime.sunday],
      this.timeFormat = 'h a',
      this.timeInterval = const Duration(minutes: 60),
      this.timeIntervalHeight = 40,
      this.timeIntervalWidth = -2,
      this.timelineAppointmentHeight = -1,
      this.minimumAppointmentDuration,
      this.dateFormat = 'd',
      this.dayFormat = 'EE',
      this.timeRulerSize = -1,
      this.timeTextStyle,
      this.allDayPanelColor,
      this.numberOfDaysInView = -1})
      : assert(startHour >= 0 && startHour <= 24),
        assert(endHour >= 0 && endHour <= 24),
        assert(timeIntervalHeight >= -1),
        assert(timeIntervalWidth >= -2),
        assert(timelineAppointmentHeight >= -1),
        assert(timeRulerSize >= -1),
        assert(numberOfDaysInView >= -1);

  /// The start hour for the time slot views in [SfCalendar].
  ///
  /// Allows to change the start hour for the time slot views in calendar, every
  /// day in time slot view start from the hour set to this property.
  ///
  /// Defaults to `0`.
  ///
  /// See more:
  /// * [endHour], which is the end hour for the time slot views in calendar.
  /// * [TimeRegion], which allows to customize the particular time region in
  /// the timeslot views of calendar.
  /// * [nonWorkingDays], which restricts the rendering of mentioned week days,
  /// in the [CalendarView.workWeek] and [CalendarView.timelineWorkWeek] views
  /// of calendar.
  /// * Knowledge base: [How to change working days and hours](https://www.syncfusion.com/kb/12146/how-to-change-the-working-days-and-hours-in-the-flutter-calendar)
  /// * Knowledge base: [How to highlight working and non working hours](https://www.syncfusion.com/kb/11711/how-to-highlight-the-working-and-non-working-hours-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double startHour;

  /// The end hour for the time slot views in [SfCalendar].
  ///
  /// Allows to change the end hour for the time slot views in calendar, every
  /// day in time slot view end at the hour set to this property.
  ///
  /// Defaults to `24`.
  ///
  /// See more:
  /// * [startHour], which is the start hour for the time slot views in
  /// calendar.
  /// * [TimeRegion], which allows to customize the particular time region in
  /// the timeslot views of calendar.
  /// * [nonWorkingDays], which restricts the rendering of mentioned week days,
  /// in the [CalendarView.workWeek] and [CalendarView.timelineWorkWeek] views
  /// of calendar.
  /// * Knowledge base: [How to change working days and hours](https://www.syncfusion.com/kb/12146/how-to-change-the-working-days-and-hours-in-the-flutter-calendar)
  /// * Knowledge base: [How to highlight working and non working hours](https://www.syncfusion.com/kb/11711/how-to-highlight-the-working-and-non-working-hours-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double endHour;

  /// The non working days for the work week view and time slot work week
  /// view in [SfCalendar].
  ///
  /// Defaults to `<int>[DateTime.saturday, DateTime.sunday]`.
  ///
  /// _Note:_ This is only applicable only when the calendar view set as
  /// [CalendarView.workWeek] or [CalendarView.timelineWorkWeek] view.
  ///
  /// See also:
  /// * [startHour], which is the start hour for the timeslot views of the
  /// calendar.
  /// * [endHour], which is the end hour for the timeslot view of the calendar.
  /// * [TimeRegion], which is used to customize the specific time region in the
  /// timeslot views of the calendar.
  /// * Knowledge base: [How to change working days and hours](https://www.syncfusion.com/kb/12146/how-to-change-the-working-days-and-hours-in-the-flutter-calendar)
  /// * Knowledge base: [How to highlight working and non working hours](https://www.syncfusion.com/kb/11711/how-to-highlight-the-working-and-non-working-hours-in-the-flutter-calendar)
  /// * Knowledge base: [How to highlight the weekends](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final List<int> nonWorkingDays;

  /// The time interval between the time slots in time slot views of
  /// [SfCalendar].
  ///
  /// Defaults to `60 minutes`.
  ///
  /// _Note:_ If this property sets with minutes value, the [timeFormat] need to
  /// be modified to display the time labels with minutes.
  ///
  /// See also: [timeFormat].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Duration timeInterval;

  /// The height for each time slot to layout within this in time slot views of
  /// [SfCalendar].
  ///
  /// Defaults to `40`.
  ///
  /// _Note:_ Calendar time interval height can be adjusted based on screen
  /// height by changing the value of this property to -1. It will auto-fit to
  /// the screen height and width.
  ///
  /// This property applicable only for day, week and work week view of calendar
  ///
  /// See also:
  /// * [timeInterval], which is the duration of every single timeslot in the
  /// timeslot views of calendar.
  /// * [timeIntervalWidth], which is the width for every single timeslot in
  /// the timeline views of calendar.
  /// * [minimumAppointmentDuration], which is the minimum duration for the
  /// appointment, if the appointment duration is too small to display on view.
  /// * Knowledge base: [How to change the time interval width and height](https://www.syncfusion.com/kb/12322/how-to-change-the-time-interval-width-and-height-in-the-flutter-event-calendar-sfcalendar)
  /// * Knowledge base: [How to set the arbitrary height to an appointment](https://www.syncfusion.com/kb/12279/how-to-set-the-arbitrary-height-to-appointments-in-the-flutter-calendar)
  /// * Knowledge base: [How to auto fit the calendar to screen height](https://www.syncfusion.com/kb/12231/how-to-autofit-the-calendar-to-screen-height-in-the-flutter-calendar)
  /// * To know more about time slot views in calendar [refer here](https://help.syncfusion.com/flutter/calendar/timeslot-views)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double timeIntervalHeight;

  /// The width for each time slots in the timeline views of [SfCalendar].
  ///
  /// _Note:_ By setting the value of this property to -1, the calendar time
  /// slot width can be adjusted based on the screen width which will be
  /// auto-fit to the screen width.
  ///
  /// See also:
  /// * [timeInterval], which is the duration of every single timeslot in the
  /// timeslot views of calendar.
  /// * [timeIntervalHeight], which is the height for every single timeslot in
  /// the day,week and work week views of calendar.
  /// * [minimumAppointmentDuration], which is the minimum duration for the
  /// appointment, if the appointment duration is too small to display on view.
  /// * [timelineAppointmentHeight], which is the height  for appointment view
  /// in the timeline views of calendar.
  /// * Knowledge base: [How to change the time interval width and height](https://www.syncfusion.com/kb/12322/how-to-change-the-time-interval-width-and-height-in-the-flutter-event-calendar-sfcalendar)
  /// * Knowledge base: [How to set the arbitrary height to an appointment](https://www.syncfusion.com/kb/12279/how-to-set-the-arbitrary-height-to-appointments-in-the-flutter-calendar)
  /// * Knowledge base: [How to auto fit the calendar to screen height](https://www.syncfusion.com/kb/12231/how-to-autofit-the-calendar-to-screen-height-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the timeline appointment height](https://www.syncfusion.com/kb/12147/how-to-customize-the-timeline-appointment-height-in-the-flutter-calendar)
  /// * To know more about time slot views in calendar [refer here](https://help.syncfusion.com/flutter/calendar/timeslot-views)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalWidth: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double timeIntervalWidth;

  /// Formats for the time text in the time slot views of [SfCalendar].
  ///
  /// Defaults to `h a`.
  ///
  /// See also:
  /// * [timeTextStyle], which is the text style for the time text in the
  /// timeslot views of calendar.
  /// * [timeRulerSize], which is the size for the time ruler, which displays
  /// the time label in timeslot views of calendar.
  /// * [timeInterval], which is the duration of every single timeslot in the
  /// timeslot views of calendar.
  /// * [startHour], which is the start hour for the timeslot views of the
  /// calendar.
  /// * [endHour], which is the end hour for the timeslot view of the calendar.
  /// * [dayFormat], which is the format for the day text in view header view
  /// of the timeslot views in calendar.
  /// * [dateFormat], which is the format for the date text in the view header
  /// view of the timeslot views of calendar.
  /// * Knowledge base: [How to customize time label](https://www.syncfusion.com/kb/11008/how-to-customize-the-time-label-in-the-flutter-calendar)
  /// * Knowledge base: [How to change the time interval width and height](https://www.syncfusion.com/kb/12322/how-to-change-the-time-interval-width-and-height-in-the-flutter-event-calendar-sfcalendar)
  /// * Knowledge base: [How to format the view header day and date format](https://www.syncfusion.com/kb/12339/how-to-format-the-view-header-day-and-date-in-the-flutter-calendar)
  /// * Knowledge base: [How to format the date and time in timeline views](https://www.syncfusion.com/kb/11997/how-to-format-the-date-and-time-in-timeline-views-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final String timeFormat;

  /// The height for an appointment view to layout within this in timeline views
  /// of [SfCalendar].
  ///
  /// _Note:_ It is applicable only when the calendar view set as
  /// [CalendarView.timelineDay], [CalendarView.timelineWeek] and
  /// [CalendarView.timelineWorkWeek] view in [SfCalendar].
  ///
  /// See also:
  /// * [timeInterval], which is the duration of every single timeslot in the
  /// timeslot views of calendar.
  /// * [minimumAppointmentDuration], which is the minimum duration for the
  /// appointment, if the appointment duration is too small to display on view.
  /// * [timeIntervalWidth], which is the width for every single timeslot in
  /// the day,week and work week views of calendar.
  /// * Knowledge base: [How to change the time interval width and height](https://www.syncfusion.com/kb/12322/how-to-change-the-time-interval-width-and-height-in-the-flutter-event-calendar-sfcalendar)
  /// * Knowledge base: [How to set the arbitrary height to an appointment](https://www.syncfusion.com/kb/12279/how-to-set-the-arbitrary-height-to-appointments-in-the-flutter-calendar)
  /// * Knowledge base: [How to auto fit the calendar to screen height](https://www.syncfusion.com/kb/12231/how-to-autofit-the-calendar-to-screen-height-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the timeline appointment height](https://www.syncfusion.com/kb/12147/how-to-customize-the-timeline-appointment-height-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timelineAppointmentHeight: 50,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double timelineAppointmentHeight;

  /// Sets an arbitrary height for an appointment when it has minimum duration
  /// in time slot views of [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// _Note:_ The value set to this property will be applicable, only when an
  /// [Appointment] duration value lesser than this property.
  ///
  /// See also:
  /// * [timeInterval], which is the duration of every single timeslot in the
  /// timeslot views of calendar.
  /// * [timeIntervalWidth], which is the width for every single timeslot in
  /// the timeline views of calendar.
  /// * [timeIntervalHeight], which is the height for every single timeslot in
  /// the timeline views of calendar.
  /// * [timelineAppointmentHeight], which is the height  for appointment view
  /// in the timeline views of calendar.
  /// * Knowledge base: [How to change the time interval width and height](https://www.syncfusion.com/kb/12322/how-to-change-the-time-interval-width-and-height-in-the-flutter-event-calendar-sfcalendar)
  /// * Knowledge base: [How to set the arbitrary height to an appointment](https://www.syncfusion.com/kb/12279/how-to-set-the-arbitrary-height-to-appointments-in-the-flutter-calendar)
  /// * Knowledge base: [How to auto fit the calendar to screen height](https://www.syncfusion.com/kb/12231/how-to-autofit-the-calendar-to-screen-height-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 60),
  ///            minimumAppointmentDuration: Duration(minutes: 30),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Duration? minimumAppointmentDuration;

  /// Formats the date text in the view header view of [SfCalendar] time slot
  /// views.
  ///
  /// Defaults to `EE`.
  ///
  /// See also:
  /// * [timeTextStyle], which is the text style for the time text in the
  /// timeslot views of calendar.
  /// * [dayFormat], which is the format for the day text in view header view
  /// of the timeslot views in calendar.
  /// * [ViewHeaderStyle], which is used to customize the view header view of
  /// the calendar.
  /// * Knowledge base: [How to format the view header day and date format](https://www.syncfusion.com/kb/12339/how-to-format-the-view-header-day-and-date-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final String dateFormat;

  /// Formats the day text in the view header view of [SfCalendar] time slot
  /// views.
  ///
  /// Defaults to `d`.
  ///
  /// See also:
  /// * [timeTextStyle], which is the text style for the time text in the
  /// timeslot views of calendar.
  /// * [dateFormat], which is the format for the date text in view header view
  /// of the timeslot views in calendar.
  /// * [ViewHeaderStyle], which is used to customize the view header view of
  /// the calendar.
  /// * Knowledge base: [How to format the view header day and date format](https://www.syncfusion.com/kb/12339/how-to-format-the-view-header-day-and-date-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final String dayFormat;

  /// The width for the time ruler view to layout with in this in time slot
  /// views of [SfCalendar].
  ///
  /// Defaults to `-1`.
  ///
  /// See also:
  /// * [timeTextStyle], which is the text style for the time text in the
  /// timeslot views of calendar.
  /// * [timeFormat], which used to format the time text in the timeslot views
  /// of calendar.
  /// * [timeInterval], which is the duration of every single timeslot in the
  /// timeslot views of calendar.
  /// * Knowledge base: [How to customize time label](https://www.syncfusion.com/kb/11008/how-to-customize-the-time-label-in-the-flutter-calendar)
  /// * Knowledge base: [How to format the date and time in timeline views](https://www.syncfusion.com/kb/11997/how-to-format-the-date-and-time-in-timeline-views-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double timeRulerSize;

  /// The text style for the time text in the time slots views of [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [timeFormat], which is used to format the time text in the timeslotviews
  /// of the calendar.
  /// * [timeRulerSize], which is the size for the time ruler, which displays
  /// the time label in timeslot views of calendar.
  /// * [timeInterval], which is the duration of every single timeslot in the
  /// timeslot views of calendar.
  /// * Knowledge base: [How to customize time label](https://www.syncfusion.com/kb/11008/how-to-customize-the-time-label-in-the-flutter-calendar)
  /// * Knowledge base: [How to change the time interval width and height](https://www.syncfusion.com/kb/12322/how-to-change-the-time-interval-width-and-height-in-the-flutter-event-calendar-sfcalendar)
  /// * Knowledge base: [How to format the view header day and date format](https://www.syncfusion.com/kb/12339/how-to-format-the-view-header-day-and-date-in-the-flutter-calendar)
  /// * Knowledge base: [How to format the date and time in timeline views](https://www.syncfusion.com/kb/11997/how-to-format-the-date-and-time-in-timeline-views-in-the-flutter-calendar)
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            minimumAppointmentDuration: Duration(minutes: 30),
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70,
  ///            timeTextStyle: TextStyle(
  ///                fontSize: 15, fontStyle: FontStyle.italic,
  ///                     color: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle? timeTextStyle;

  /// The color which fills the [SfCalendar] all day panel background.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [backgroundColor], will fill the background of the calendar.
  /// *[CalendarHeaderStyle.backgroundColor], will fill the header background
  /// of the calendar.
  /// *[ViewHeaderStyle.backgroundColor], will fill the view header background
  /// of the calendar.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///           allDayPanelColor : Colors.green),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color? allDayPanelColor;

  /// The number of days count in week in the [SfCalendar].
  ///
  /// Allows to customize the days count is applicable when calendar view is
  /// [CalendarView.day], [CalendarView.week], [CalendarView.workWeek],
  /// [CalendarView.timelineDay], [CalendarView.timelineWeek]
  /// and [CalendarView.timelineWorkWeek] in calendar.
  ///
  /// Defaults to `-1`.
  ///
  /// The calendar supports customizing the day count only for valid values.
  /// It ranges from 1 to 7 and shows default behavior for invalid values.
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        numberOfDaysInView: 3,
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final int numberOfDaysInView;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final TimeSlotViewSettings otherStyle;
    if (other is TimeSlotViewSettings) {
      otherStyle = other;
    }
    return otherStyle.startHour == startHour &&
        otherStyle.endHour == endHour &&
        otherStyle.nonWorkingDays == nonWorkingDays &&
        otherStyle.timeInterval == timeInterval &&
        otherStyle.timeIntervalHeight == timeIntervalHeight &&
        otherStyle.timeIntervalWidth == timeIntervalWidth &&
        otherStyle.timeFormat == timeFormat &&
        otherStyle.timelineAppointmentHeight == timelineAppointmentHeight &&
        otherStyle.minimumAppointmentDuration == minimumAppointmentDuration &&
        otherStyle.dateFormat == dateFormat &&
        otherStyle.dayFormat == dayFormat &&
        otherStyle.timeRulerSize == timeRulerSize &&
        otherStyle.timeTextStyle == timeTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<TextStyle>('timeTextStyle', timeTextStyle));
    properties.add(DoubleProperty('startHour', startHour));
    properties.add(DoubleProperty('endHour', endHour));
    properties.add(IterableProperty<int>('nonWorkingDays', nonWorkingDays));
    properties.add(DiagnosticsProperty<Duration>('timeInterval', timeInterval));
    properties.add(DoubleProperty('timeIntervalHeight', timeIntervalHeight));
    properties.add(DoubleProperty('timeIntervalWidth', timeIntervalWidth));
    properties.add(
        DoubleProperty('timelineAppointmentHeight', timelineAppointmentHeight));
    properties.add(DiagnosticsProperty<Duration>(
        'minimumAppointmentDuration', minimumAppointmentDuration));
    properties.add(DoubleProperty('timeRulerSize', timeRulerSize));
    properties.add(StringProperty('timeFormat', timeFormat));
    properties.add(StringProperty('dateFormat', dateFormat));
    properties.add(StringProperty('dayFormat', dayFormat));
    properties.add(IntProperty('numberOfDaysInView', numberOfDaysInView));
  }

  @override
  int get hashCode {
    return Object.hash(
        startHour,
        endHour,
        Object.hashAll(nonWorkingDays),
        timeInterval,
        timeIntervalHeight,
        timeIntervalWidth,
        timeFormat,
        timelineAppointmentHeight,
        minimumAppointmentDuration,
        dateFormat,
        dayFormat,
        timeRulerSize,
        timeTextStyle);
  }
}
