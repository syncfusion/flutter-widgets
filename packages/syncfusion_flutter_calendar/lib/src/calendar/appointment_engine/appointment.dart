import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show IterableDiagnostics;

import '../../../calendar.dart';

/// Appointment data for calendar.
///
/// An object that contains properties to hold the detailed information about
/// the data, which will be rendered in [SfCalendar].
///
/// _Note:_ The [startTime] and [endTime] properties must not be null to render
/// an appointment.
///
/// See also:
/// * [CalendarDataSource], to set and handle the appointment collection to the
/// calendar.
/// * [SfCalendar.appointmentBuilder], to set custom widget for the appointment
/// view in the calendar
/// * [SfCalendar.loadMoreWidgetBuilder], the widget which will be displayed
/// when the appointments loading on the view in calendar.
/// * [SfCalendar.appointmentTextStyle], to customize the appointment text, when
/// the builder not added.
/// * [SfCalendar.appointmentTimeTextFormat], to customize the time text format
/// in the appointment view of calendar.
/// * Knowledge base: [How to customize appointment using builder](https://www.syncfusion.com/kb/12191/how-to-customize-the-appointments-using-custom-builder-in-the-flutter-calendar)
/// * Knowledge base: [How to load appointments on demand](https://www.syncfusion.com/kb/12658/how-to-load-appointments-on-demand-in-flutter-calendar)
/// * Knowledge base: [How to style appointments](https://www.syncfusion.com/kb/12162/how-to-style-the-appointment-in-the-flutter-calendar)
/// * Knowledge base: [How to format appointment time](https://www.syncfusion.com/kb/11989/how-to-format-the-appointment-time-in-the-flutter-calendar)
/// * Knowledge base: [How to create time table](https://www.syncfusion.com/kb/12392/how-to-create-time-table-using-flutter-event-calendar)
/// * Knowledge base: [How to add a custom appointments of business objects](https://www.syncfusion.com/kb/11529/how-to-add-a-custom-appointments-or-objects-in-the-flutter-calendar)
/// * Knowledge base: [How to delete an appointment](https://www.syncfusion.com/kb/11522/how-to-delete-an-appointment-in-the-flutter-calendar)
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Container(
///      child: SfCalendar(
///        view: CalendarView.day,
///        dataSource: _getCalendarDataSource(),
///      ),
///    );
///  }
///
/// class DataSource extends CalendarDataSource {
///  DataSource(List<Appointment> source) {
///    appointments = source;
///  }
/// }
///
/// DataSource _getCalendarDataSource() {
///    List<Appointment> appointments = <Appointment>[];
///    appointments.add(
///        Appointment(
///          startTime: DateTime.now(),
///          endTime: DateTime.now().add(
///              Duration(hours: 2)),
///          isAllDay: true,
///          subject: 'Meeting',
///          color: Colors.blue,
///          startTimeZone: '',
///          endTimeZone: ''
///        ));
///
///   return DataSource(appointments);
/// }
///  ```
class Appointment with Diagnosticable {
  /// Creates an appointment data for [SfCalendar].
  ///
  /// An object that contains properties to hold the detailed information
  /// about the data, which will be rendered in [SfCalendar].
  Appointment({
    this.startTimeZone,
    this.endTimeZone,
    this.recurrenceRule,
    this.isAllDay = false,
    String? notes,
    this.location,
    this.resourceIds,
    this.recurrenceId,
    this.id,
    required this.startTime,
    required this.endTime,
    this.subject = '',
    this.color = Colors.lightBlue,
    this.recurrenceExceptionDates,
  })  : notes = notes != null && notes.contains('isOccurrenceAppointment')
            ? notes.replaceAll('isOccurrenceAppointment', '')
            : notes,
        _notes = notes {
    recurrenceRule = recurrenceId != null ? null : recurrenceRule;
    _appointmentType = _getAppointmentType();
    id = id ?? hashCode;
  }

  String? _notes;

  /// The start time for an [Appointment] in [SfCalendar].
  ///
  /// Defaults to `DateTime.now()`.
  ///
  /// See also:
  /// * [CalendarDataSource.getStartTime], which maps the custom business
  /// objects corresponding property to this property.
  /// * [isAllDay], which defines whether the event is all-day long or not
  /// * [endTime], the date time value in which the appointment will end
  /// * [startTimeZone], the timezone for the start time, the appointment will
  /// render by converting the start time based on the [startTimeZone], and
  /// [SfCalendar.timeZone].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  DateTime startTime;

  /// The end time for an [Appointment] in [SfCalendar].
  ///
  /// Defaults to `DateTime.now()`.
  ///
  /// _Note:_ If this property set with the time prior to the [startTime], then
  /// the [Appointment] will render with half hour time period from the
  /// [startTime].
  ///
  /// If the difference between [startTime] and [endTime] is greater than 24
  /// hour the appointment will be rendered on the all day panel of the time
  /// slot views in [SfCalendar].
  ///
  /// See also:
  /// * [CalendarDataSource.getEndTime], which maps the custom business
  /// objects corresponding property to this property.
  /// * [isAllDay], which defines whether the event is all-day long or not
  /// * [startTime], the date time value in which the appointment will start.
  /// * [endTimeZone], the timezone for the end time, the appointment will
  /// render by converting the end time based on the [endTimeZone], and
  /// [SfCalendar.timeZone].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  DateTime endTime;

  /// Displays the [Appointment] on the all day panel area of time slot views in
  /// [SfCalendar].
  ///
  /// An [Appointment] rendered between the given [startTime] and [endTime]
  /// in the time slots of the time slot view in [SfCalendar] by default.
  ///
  /// If it is set as [true] the appointment's [startTime] and [endTime] will be
  /// ignored and the appointment will be rendered on the all day panel area of
  /// the time slot views.
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [CalendarDataSource.isAllDay], which maps the custom business
  /// objects corresponding property to this property.
  /// * [startTime], the date time value in which the appointment will start.
  /// * [endTime], the date time value in which the appointment will end
  /// * [startTimeZone], the timezone for the start time, the appointment will
  /// render by converting the start time based on the [startTimeZone], and
  /// [SfCalendar.timeZone].
  /// * [endTimeZone], the timezone for the start time, the appointment will
  /// render by converting the end time based on the [endTimeZone], and
  /// [SfCalendar.timeZone].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  bool isAllDay;

  /// The subject for the [Appointment] in [SfCalendar].
  ///
  /// Defaults to ` ` represents empty string.
  ///
  /// See also:
  /// * [CalendarDataSource.getSubject], which maps the custom business
  /// objects corresponding property to this property.
  /// * [SfCalendar.appointmentTextStyle], to customize the appointment text,
  /// when the builder not added.
  /// * Knowledge base: [How to style appointments](https://www.syncfusion.com/kb/12162/how-to-style-the-appointment-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///   appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  String subject;

  /// The color that fills the background of the [Appointment] view in
  /// [SfCalendar].
  ///
  /// Defaults to `Colors.lightBlue`.
  ///
  /// See also:
  /// * [CalendarDataSource.getColor], which maps the custom business
  /// objects corresponding property to this property.
  /// * [SfCalendar.appointmentTextStyle], to customize the appointment text,
  /// when the builder not added.
  /// * [SfCalendar.appointmentBuilder], to set custom widget for the
  /// appointment view in the calendar
  /// * Knowledge base: [How to style appointments](https://www.syncfusion.com/kb/12162/how-to-style-the-appointment-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  Color color;

  /// The start time zone for an [Appointment] in [SfCalendar].
  ///
  /// If it is not [null] the appointment start time will be calculated based on
  /// the time zone set to this property and [SfCalendar.timeZone] property.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [CalendarDataSource.getStartTimeZone], which maps the custom business
  /// objects corresponding property to this property.
  /// * [startTime], the date time value in which the appointment will start.
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  String? startTimeZone;

  /// The end time zone for an [Appointment] in [SfCalendar].
  ///
  /// If it is not [null] the appointment end time will be calculated based on
  /// the time zone set to this property and [SfCalendar.timeZone] property.
  ///
  /// Defaults to null.
  ///
  /// Note:_ If the [startTimeZone] and [endTimeZone] set as different time
  /// zone's and it's value falls invalid, the appointment will render with half
  /// an hour duration from the start time of the appointment.
  ///
  /// See also:
  /// * [CalendarDataSource.getEndTimeZone], which maps the custom business
  /// objects corresponding property to this property.
  /// * [endTime], the date time value in which the appointment will end.
  /// * [endTimeZone], the timezone for the end time, the appointment will
  /// render by converting the end time based on the [endTimeZone], and
  /// [SfCalendar.timeZone].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  String? endTimeZone;

  /// Recurs the [Appointment] on [SfCalendar].
  ///
  /// An [Appointment] will render the one appointment view for the given
  /// [startTime] and [endTime] in [SfCalendar].
  ///
  /// If it is not [null] the appointment will be recurred multiple times based
  /// on the [RecurrenceProperties] set to this property.
  ///
  /// The recurrence rule can be generated using the [SfCalendar.rRuleGenerator]
  /// method in [Calendar].
  ///
  /// The recurrence rule can be directly set this property like
  /// 'FREQ=DAILY;INTERVAL=1;COUNT=3'.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [CalendarDataSource.getRecurrenceRule], which maps the custom business
  /// objects corresponding property to this property.
  /// * [RecurrenceProperties], which used to create the recurrence rule based
  /// on the values set to these properties.
  /// * [SfCalendar.generateRRule], which used to generate recurrence rule
  /// based on the [RecurrenceProperties] values.
  /// * [SfCalendar.getRecurrenceDateTimeCollection], to get the recurrence date
  /// time collection based on the given recurrence rule and start date.
  /// * Knowledge base: [How to use a negative value for bysetpos in rrule](https://www.syncfusion.com/kb/12552/how-to-use-a-negative-value-for-bysetpos-in-a-rrule-of-recurrence-appointment-in-the)
  /// * Knowledge base: [How to get the recurrence date collection](https://www.syncfusion.com/kb/12344/how-to-get-the-recurrence-date-collection-in-the-flutter-calendar)
  /// * Knowledge base: [How to add recurring appointments until specified date](https://www.syncfusion.com/kb/12158/how-to-add-recurring-appointments-until-the-specified-date-in-the-flutter-calendar)
  ///
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  /// }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    RecurrenceProperties recurrence =
  ///       RecurrenceProperties(startDate: DateTime.now());
  ///    recurrence.recurrenceType = RecurrenceType.daily;
  ///    recurrence.interval = 2;
  ///    recurrence.recurrenceRange = RecurrenceRange.count;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(Appointment(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 2)),
  ///        isAllDay: true,
  ///        subject: 'Meeting',
  ///        color: Colors.blue,
  ///        startTimeZone: '',
  ///        endTimeZone: '',
  ///        recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///            DateTime.now(), DateTime.now().add(Duration(hours: 2)))));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///
  ///  ```
  String? recurrenceRule;

  /// Delete the occurrence for an recurrence appointment.
  ///
  /// An [Appointment] with [recurrenceRule] will recur on all the possible
  /// dates given by the [recurrenceRule].
  ///
  /// If it is not [null] the recurrence appointment occurrence can be deleted
  /// and the appointment will not occur on the dates set to this property in
  /// [Calendar].
  ///
  /// Defaults to `<DateTime>[]`.
  ///
  /// See also:
  /// * [CalendarDataSource.getRecurrenceExceptionDates], which maps the custom
  /// business objects corresponding property to this property.
  /// * [recurrenceRule], which used to generate the recurrence appointment
  /// based on the rule set.
  /// * [RecurrenceProperties], which used to create the recurrence rule based
  /// on the values set to these properties.
  /// * [SfCalendar.generateRRule], which used to generate recurrence rule
  /// based on the [RecurrenceProperties] values.
  /// * Knowledge base: [How to exclude the dates from the recurrence appointments](https://www.syncfusion.com/kb/12161/how-to-exclude-the-dates-from-recurrence-appointments-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    RecurrenceProperties recurrence =
  ///      RecurrenceProperties(startDate: DateTime.now());
  ///    recurrence.recurrenceType = RecurrenceType.daily;
  ///    recurrence.interval = 2;
  ///    recurrence.recurrenceRange = RecurrenceRange.noEndDate;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(
  ///        Appointment(
  ///            startTime: DateTime.now(),
  ///            endTime: DateTime.now().add(
  ///                Duration(hours: 2)),
  ///            isAllDay: true,
  ///            subject: 'Meeting',
  ///            color: Colors.blue,
  ///            startTimeZone: '',
  ///            notes: '',
  ///            location: '',
  ///            endTimeZone: '',
  ///            recurrenceRule: SfCalendar.generateRRule(
  ///                recurrence, DateTime.now(), DateTime.now().add(
  ///                Duration(hours: 2))),
  ///            recurrenceExceptionDates: [
  ///              DateTime.now().add(Duration(days: 2))
  ///            ]
  ///        ));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///  ```
  List<DateTime>? recurrenceExceptionDates;

  /// Defines the notes for an [Appointment] in [SfCalendar].
  ///
  /// Allow to store additional information about the [Appointment] and can be
  /// obtained through the [Appointment] object.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [CalendarDataSource.getNotes], which maps the custom business objects
  /// corresponding property to this property.
  /// * [location], which used to store the location data of the appointment in
  /// the calendar.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    RecurrenceProperties recurrence =
  ///       RecurrenceProperties(startDate: DateTime.now());
  ///    recurrence.recurrenceType = RecurrenceType.daily;
  ///    recurrence.interval = 2;
  ///    recurrence.recurrenceRange = RecurrenceRange.noEndDate;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(
  ///        Appointment(
  ///            startTime: DateTime.now(),
  ///            endTime: DateTime.now().add(
  ///                Duration(hours: 2)),
  ///            isAllDay: true,
  ///            subject: 'Meeting',
  ///            color: Colors.blue,
  ///            startTimeZone: '',
  ///            notes: '',
  ///            location: '',
  ///            endTimeZone: '',
  ///            recurrenceRule: SfCalendar.generateRRule(
  ///                recurrence, DateTime.now(), DateTime.now().add(
  ///                Duration(hours: 2))),
  ///            recurrenceExceptionDates: [
  ///              DateTime.now().add(Duration(days: 2))
  ///            ]
  ///        ));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///  ```
  String? notes;

  /// Defines the location for an [Appointment] in [SfCalendar].
  ///
  /// Allow to store location information about the [Appointment] and can be
  /// obtained through the [Appointment] object.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [CalendarDataSource.getLocation], which maps the custom business objects
  /// corresponding property to this property.
  /// * [notes], which used to store some additional data or information about
  /// the  appointment in the calendar.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///   return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    RecurrenceProperties recurrence =
  ///       RecurrenceProperties(startDate: DateTime.now());
  ///    recurrence.recurrenceType = RecurrenceType.daily;
  ///    recurrence.interval = 2;
  ///    recurrence.recurrenceRange = RecurrenceRange.noEndDate;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(
  ///        Appointment(
  ///            startTime: DateTime.now(),
  ///            endTime: DateTime.now().add(
  ///                Duration(hours: 2)),
  ///            isAllDay: true,
  ///            subject: 'Meeting',
  ///            color: Colors.blue,
  ///            startTimeZone: '',
  ///            notes: '',
  ///            location: '',
  ///            endTimeZone: '',
  ///            recurrenceRule: SfCalendar.generateRRule(
  ///                recurrence, DateTime.now(), DateTime.now().add(
  ///                Duration(hours: 2))),
  ///            recurrenceExceptionDates: [
  ///              DateTime.now().add(Duration(days: 2))
  ///            ]
  ///        ));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///  ```
  String? location;

  /// The ids of the [CalendarResource] that shares this [Appointment].
  ///
  /// Based on this Id the appointments are grouped and arranged to each
  /// resource in calendar view.
  ///
  /// See also:
  /// * [CalendarDataSource.getResourceIds], which maps the custom business
  /// objects corresponding property to this property.
  /// * [CalendarResource], object which contains the resource data.
  /// * [ResourceViewSettings], the settings have properties which allow to
  /// customize the resource view of the [SfCalendar].
  /// * [CalendarResource.id], the unique id for the [CalendarResource] view of
  /// [SfCalendar].
  /// * [CalendarDataSource], which used to set the resources collection to the
  /// calendar.
  /// * Knowledge base: [How to add appointment for the selected resource using appointment editor](https://www.syncfusion.com/kb/12109/how-to-add-appointment-for-the-selected-resources-using-appointment-editor-in-the-flutter)
  /// * Knowledge base: [How to add resources](https://www.syncfusion.com/kb/12070/how-to-add-resources-in-the-flutter-calendar)
  /// * Knowledge base: [How to handle appointments for muliple resources](https://www.syncfusion.com/kb/11812/how-to-handle-appointments-for-multiple-resources-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineMonth,
  ///        dataSource: _getCalendarDataSource(),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source,
  ///             List<CalendarResource> resourceColl) {
  ///    appointments = source;
  ///    resources = resourceColl;
  ///  }
  ///}
  ///
  ///DataSource _getCalendarDataSource() {
  ///  List<Appointment> appointments = <Appointment>[];
  ///  List<CalendarResource> resources = <CalendarResource>[];
  ///  appointments.add(Appointment(
  ///      startTime: DateTime.now(),
  ///      endTime: DateTime.now().add(Duration(hours: 2)),
  ///      isAllDay: true,
  ///      subject: 'Meeting',
  ///      color: Colors.blue,
  ///      resourceIds: <Object>['0001'],
  ///      startTimeZone: '',
  ///      endTimeZone: ''));
  ///
  ///  resources.add(CalendarResource(
  ///    displayName: 'John',
  ///    id: '0001',
  ///    color: Colors.red
  ///  ));
  ///
  ///  return DataSource(appointments, resources);
  ///}
  ///
  /// ```
  List<Object>? resourceIds;

  /// Defines the recurrence id for an [Appointment] in [SfCalendar],
  /// The recurrence id is used to create an exception appointment
  /// in a recurrence series.
  ///
  /// Defaults to null.
  /// The [recurrenceId] of the exception appointment and the [id] of
  /// the pattern appointment should be same. The [recurrenceId] should be
  /// specified only for exception appointments. It is not required for
  /// occurrence, and normal appointments.
  ///
  /// _Note:_ The exception appointment should be a normal appointment and
  /// should not be created as recurring appointment, since its occurrence
  /// from recurrence pattern.
  ///
  /// Exception recurrence appointment should not have a RRule. If the exception
  /// appointment has RRule, it will not be considered.
  ///
  /// See also:
  /// * [CalendarDataSource.getRecurrenceId], which maps the custom business
  /// objects corresponding property to this property.
  /// * [id], which used to set unique identification number for the
  /// [Appointment] object.
  /// * [appointmentType], which used to identify the different appointment
  /// types.
  ///
  /// ```dart
  ///AppointmentDataSource _getDataSource() {
  ///  List<Appointment> appointments = <Appointment>[];
  ///  final DateTime exceptionDate = DateTime(2021, 04, 20);
  ///
  ///  final Appointment recurrenceAppointment = Appointment(
  ///    startTime: DateTime(2021, 04, 12, 10),
  ///    endTime: DateTime(2021, 04, 12, 12),
  ///    subject: 'Scrum meeting',
  ///    id: '01',
  ///    recurrenceRule: 'FREQ=DAILY;INTERVAL=1;COUNT=10',
  ///    recurrenceExceptionDates: <DateTime>[exceptionDate],
  ///  );
  ///  appointments.add(recurrenceAppointment);
  ///
  ///  final Appointment exceptionAppointment = Appointment(
  ///      startTime: exceptionDate.add(Duration(hours: 10)),
  ///      endTime: exceptionDate.add(Duration(hours: 12)),
  ///      subject: 'Meeting',
  ///      id: '02',
  ///      recurrenceId: recurrenceAppointment.id);
  ///
  ///  appointments.add(exceptionAppointment);
  ///
  ///  return AppointmentDataSource(appointments);
  /// }
  ///
  /// ```
  Object? recurrenceId;

  /// Defines the id for an [Appointment] in [SfCalendar].
  ///
  /// The unique identifier for the appointment. It must be mentioned to add
  /// an exception appointment to the recurrence series.
  ///
  /// Defaults to the hash code of the appointment.
  /// [id] can be set to all the appointment types where the internally
  /// created occurrence appointment will have the same [id] value as
  /// the pattern appointment.
  ///
  /// The exception appointment should have the different [id] value compared
  /// to the pattern appointment. But the [recurrenceId] of the exception
  /// appointment and the [id] value of the pattern appointment should be same.
  ///
  /// See also:
  /// * [CalendarDataSource.id], which maps the custom business objects
  /// corresponding property to this property.
  /// * [recurrenceId], which used to create an exception/changed occurrence
  /// appointment.
  /// * [appointmentType], which used to identify the different appointment
  /// types.
  ///
  /// ```dart
  ///
  /// AppointmentDataSource _getDataSource() {
  ///     List<Appointment> appointments = <Appointment>[];
  ///
  ///     appointments.add(Appointment(
  ///       startTime: DateTime(2021, 04, 12, 10),
  ///       endTime: DateTime(2021, 04, 12, 12),
  ///       subject: 'Scrum meeting',
  ///       id: '01',
  ///       recurrenceRule: 'FREQ=DAILY;INTERVAL=1;COUNT=10',
  ///     ));
  ///     appointments.add(Appointment(
  ///       startTime: DateTime(2021, 04, 12, 16),
  ///       endTime: DateTime(2021, 04, 12, 17),
  ///       subject: 'Meeting',
  ///       id: '02',
  ///     ));
  ///     appointments.add(Appointment(
  ///       startTime: DateTime(2021, 04, 13, 09),
  ///       endTime: DateTime(2021, 04, 13, 10),
  ///       subject: 'Discussion',
  ///     ));
  ///
  ///     return AppointmentDataSource(appointments);
  ///   }
  ///
  /// ```
  Object? id;

  AppointmentType _appointmentType = AppointmentType.normal;

  ///Specifies the appointment type, which is used to distinguish appointments
  /// based on their functionality.
  ///
  /// This is read-only.
  ///
  /// Defines the appointment type for the [Appointment].
  ///
  /// Also refer:
  /// [AppointmentType], to know more about the available appointment types in
  /// calendar.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        dataSource: dataSource,
  ///               onTap: (CalendarTapDetails details){
  ///                 for(int i=0; i<details.appointments.length; i++){
  ///                   AppointmentType appointmentTpe =
  ///                     details.appointments[i].appointmentType);
  ///               },
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  AppointmentType get appointmentType => _appointmentType;

  /// Here we used isOccurrenceAppointment keyword to identify the
  /// occurrence appointment When we clone the pattern appointment for
  /// occurrence appointment we have append the string in the notes and here we
  /// identify based on the string and removed the appended string.
  AppointmentType _getAppointmentType() {
    if (recurrenceId != null) {
      return AppointmentType.changedOccurrence;
    } else if (recurrenceRule != null && recurrenceRule!.isNotEmpty) {
      if (_notes != null && _notes!.contains('isOccurrenceAppointment')) {
        _notes = _notes!.replaceAll('isOccurrenceAppointment', '');
        return AppointmentType.occurrence;
      }

      return AppointmentType.pattern;
    }
    return AppointmentType.normal;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final Appointment otherStyle;
    if (other is Appointment) {
      otherStyle = other;
    }
    return otherStyle.startTime == startTime &&
        otherStyle.endTime == endTime &&
        otherStyle.startTimeZone == startTimeZone &&
        otherStyle.endTimeZone == endTimeZone &&
        otherStyle.isAllDay == isAllDay &&
        otherStyle.notes == notes &&
        otherStyle.location == location &&
        otherStyle.resourceIds == resourceIds &&
        otherStyle.subject == subject &&
        otherStyle.color == color &&
        otherStyle.recurrenceExceptionDates == recurrenceExceptionDates &&
        otherStyle.recurrenceId == recurrenceId &&
        otherStyle.id == id &&
        otherStyle.appointmentType == appointmentType;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return Object.hash(
      startTimeZone,
      endTimeZone,
      recurrenceRule,
      isAllDay,
      notes,
      location,

      /// Below condition is referred from text style class
      /// https://api.flutter.dev/flutter/painting/TextStyle/hashCode.html
      resourceIds == null ? null : Object.hashAll(resourceIds!),
      recurrenceId,
      id,
      appointmentType,
      startTime,
      endTime,
      subject,
      color,
      recurrenceExceptionDates == null
          ? null
          : Object.hashAll(recurrenceExceptionDates!),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('startTimeZone', startTimeZone));
    properties.add(StringProperty('endTimeZone', endTimeZone));
    properties.add(StringProperty('recurrenceRule', recurrenceRule));
    properties.add(StringProperty('notes', notes));
    properties.add(StringProperty('location', location));
    properties.add(StringProperty('subject', subject));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<Object>('recurrenceId', recurrenceId));
    properties.add(DiagnosticsProperty<Object>('id', id));
    properties
        .add(EnumProperty<AppointmentType>('appointmentType', appointmentType));
    properties.add(DiagnosticsProperty<DateTime>('startTime', startTime));
    properties.add(DiagnosticsProperty<DateTime>('endTime', endTime));
    properties.add(IterableDiagnostics<DateTime>(recurrenceExceptionDates)
        .toDiagnosticsNode(name: 'recurrenceExceptionDates'));
    properties.add(IterableDiagnostics<Object>(resourceIds)
        .toDiagnosticsNode(name: 'resourceIds'));
    properties.add(DiagnosticsProperty<bool>('isAllDay', isAllDay));
  }
}
