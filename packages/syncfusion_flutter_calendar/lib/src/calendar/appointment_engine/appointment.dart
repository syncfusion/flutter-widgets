import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show IterableDiagnostics;

import '../../../calendar.dart';
import '../common/enums.dart';

/// Appointment data for calendar.
///
/// An object that contains properties to hold the detailed information about
/// the data, which will be rendered in [SfCalendar].
///
/// _Note:_ The [startTime] and [endTime] properties must not be null to render
/// an appointment.
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
    this.notes,
    this.location,
    this.resourceIds,
    this.recurrenceId,
    this.id,
    required this.startTime,
    required this.endTime,
    this.subject = '',
    this.color = Colors.lightBlue,
    this.recurrenceExceptionDates,
  }) {
    recurrenceRule = recurrenceId != null ? null : recurrenceRule;
    _appointmentType = _getAppointmentType();
    id = id ?? hashCode;
  }

  /// The start time for an [Appointment] in [SfCalendar].
  ///
  /// Defaults to `DateTime.now()`.
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
  ///
  /// * [CalendarResource], the resource data for calendar.
  /// * [ResourceViewSettings], the settings have properties which allow to
  /// customize the resource view of the [SfCalendar].
  /// * [CalendarResource.id], the unique id for the [CalendarResource] view of
  /// [SfCalendar].
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
  /// ```dart
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
  /// This is read-only.
  /// Defines the appointment type for the [Appointment].
  ///
  /// Also refer: [AppointmentType].
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
      if (notes != null && notes!.contains('isOccurrenceAppointment')) {
        notes = notes!.replaceAll('isOccurrenceAppointment', '');
        return AppointmentType.occurrence;
      }

      return AppointmentType.pattern;
    }
    return AppointmentType.normal;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(dynamic other) {
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
    return hashValues(
      startTimeZone,
      endTimeZone,
      recurrenceRule,
      isAllDay,
      notes,
      location,
      hashList(resourceIds),
      recurrenceId,
      id,
      appointmentType,
      startTime,
      endTime,
      subject,
      color,
      hashList(recurrenceExceptionDates),
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
