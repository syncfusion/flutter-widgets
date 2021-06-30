import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show IterableDiagnostics;

import '../common/calendar_view_helper.dart';
import '../common/enums.dart';

/// Recurrence properties allows to create recurrence rule for an [Appointment].
///
/// An object contains properties that hold data for the creation of
/// [Appointment.recurrenceRule] for [Appointment] using the
/// [SfCalendar.generateRRule] method.
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
///    recurrence.recurrenceRange = RecurrenceRange.count;
///    recurrence.recurrenceCount = 10;
///    appointments.add(
///        Appointment(
///          startTime: DateTime.now(),
///          endTime: DateTime.now().add(
///              Duration(hours: 2)),
///          isAllDay: true,
///          subject: 'Meeting',
///          color: Colors.blue,
///          startTimeZone: '',
///          endTimeZone: '',
///          recurrenceRule: SfCalendar.generateRRule(recurrence,
///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
///        ));
///
///   return DataSource(appointments);
/// }
///  ```
class RecurrenceProperties with Diagnosticable {
  /// Creates an recurrence properties .
  ///
  /// An object contains properties that hold data for the creation of
  /// [Appointment.recurrenceRule] for [Appointment] using the
  /// [SfCalendar.generateRRule] method.
  RecurrenceProperties(
      {this.recurrenceType = RecurrenceType.daily,
      this.recurrenceCount = 0,
      required this.startDate,
      this.endDate,
      this.interval = 1,
      this.recurrenceRange = RecurrenceRange.noEndDate,
      List<WeekDays>? weekDays,
      this.week = 0,
      this.dayOfMonth = 1,
      this.dayOfWeek = 1,
      this.month = 1})
      : weekDays = weekDays ?? <WeekDays>[],
        assert(recurrenceCount >= 0),
        assert(endDate == null ||
            CalendarViewHelper.isSameOrBeforeDateTime(endDate, startDate)),
        assert(endDate == null ||
            CalendarViewHelper.isSameOrAfterDateTime(startDate, endDate)),
        assert(interval >= 1),
        assert(week >= -2 && week <= 5),
        assert(dayOfMonth >= 1 && dayOfMonth <= 31),
        assert(dayOfWeek >= 1 && dayOfWeek <= 7),
        assert(month >= 1 && month <= 12);

  /// Defines the recurrence type of an [Appointment].
  ///
  /// Defaults to `RecurrenceType.daily`.
  ///
  /// Also refer: [RecurrenceType].
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
  ///    recurrence.recurrenceRange = RecurrenceRange.count;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  RecurrenceType recurrenceType;

  /// Defines the recurrence count of an [Appointment].
  ///
  /// When the [recurrence Range] is set to [Recurrences Range.count],
  /// the [Appointment] will recur to specific count based on the value set
  /// for this property.
  ///
  /// Defaults to `1`.
  ///
  /// _Note:_ It is applicable only when the [recurrenceRange] set as
  /// [RecurrenceRange.count].
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
  ///    recurrence.recurrenceRange = RecurrenceRange.count;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  int recurrenceCount;

  /// Defines the start date for the [Appointment] to recur.
  ///
  /// The [Appointment] starts to recur from the date set to this property.
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
  ///    recurrence.startDate = DateTime.now().add(Duration(days: 1));
  ///    recurrence.interval = 2;
  ///    recurrence.recurrenceRange = RecurrenceRange.count;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  DateTime startDate;

  /// Defines the end date for the [Appointment] to end it's recurrence.
  ///
  /// The [Appointment] ends to recur on the date set to this property, when the
  /// [recurrenceRange] set as [RecurrenceRange.endDate].
  ///
  /// _Note:_ it is applicable only when the [recurrenceRange] set as
  /// [RecurrenceRange.endDate].
  ///
  /// Defaults to the next date of current date.
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
  ///    recurrence.endDate = DateTime.now().add(Duration(days: 10));
  ///    recurrence.recurrenceRange = RecurrenceRange.endDate;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  DateTime? endDate;

  /// Defines the recurrence interval between the [Appointment].
  ///
  /// The [Appointment] will take place at a specific time interval based on
  /// the value that is set for this property.
  ///
  /// Defaults to `1`.
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
  ///    recurrence.endDate = DateTime.now().add(Duration(days: 10));
  ///    recurrence.recurrenceRange = RecurrenceRange.endDate;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  int interval;

  /// Defines the range for an [Appointment] ro recur.
  ///
  /// Defaults to `RecurrenceRange.noEndDate`.
  ///
  /// Also refer: [RecurrenceRange].
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
  ///    recurrence.endDate = DateTime.now().add(Duration(days: 10));
  ///    recurrence.recurrenceRange = RecurrenceRange.endDate;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  RecurrenceRange recurrenceRange;

  /// Defines the weekdays for an [Appointment] to recur.
  ///
  /// The [Appointment] will recur on the [WeekDays] set to this property,
  /// when the [recurrenceType] set as [RecurrenceType.weekly].
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
  ///    List<WeekDays> days = <WeekDays>[];
  ///    days.add(WeekDays.monday);
  ///    days.add(WeekDays.wednesday);
  ///    days.add(WeekDays.friday);
  ///    days.add(WeekDays.saturday);
  ///    recurrence.weekDays = days;
  ///    recurrence.recurrenceType = RecurrenceType.weekly;
  ///    recurrence.endDate = DateTime.now().add(Duration(days: 10));
  ///    recurrence.recurrenceRange = RecurrenceRange.endDate;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  List<WeekDays> weekDays;

  /// Defines the week for an [Appointment] to recur.
  ///
  /// The [Appointment] will recur on the [Week] set to this property,
  /// when the [recurrenceType] set as [RecurrenceType.year].
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
  ///    recurrence.week = 4;
  ///    recurrence.recurrenceType = RecurrenceType.monthly;
  ///    recurrence.interval = 1;
  ///    recurrence.recurrenceRange = RecurrenceRange.noEndDate;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  int week;

  /// Defines the day in a month for an [Appointment] to recur.
  ///
  /// The [Appointment] will recur on the day set to this property on specific
  /// month, when the [recurrenceType] set as [RecurrenceType.year].
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
  ///    recurrence.recurrenceType = RecurrenceType.monthly;
  ///    recurrence.dayOfMonth = 15;
  ///    recurrence.interval = 1;
  ///    recurrence.recurrenceRange = RecurrenceRange.noEndDate;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  int dayOfMonth;

  /// Defines the day in a week for an [Appointment] to recur.
  ///
  /// The [Appointment] will recur on the day set to this property on specific
  /// week, when the [recurrenceType] set as [RecurrenceType.year] or
  /// [RecurrenceType.month].
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
  ///    recurrence.dayOfWeek = 7;
  ///    recurrence.week = 4;
  ///    recurrence.recurrenceType = RecurrenceType.monthly;
  ///    recurrence.interval = 1;
  ///   recurrence.recurrenceRange = RecurrenceRange.noEndDate;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  int dayOfWeek;

  /// Defines the month of the appointment when recurrence type as year.
  ///
  /// Defines the month for an [Appointment] to recur.
  ///
  /// The [Appointment] will recur on the month set to this property on specific
  /// year, when the [recurrenceType] set as [RecurrenceType.year].
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
  ///    recurrence.recurrenceType = RecurrenceType.yearly;
  ///    recurrence.dayOfMonth = 15;
  ///    recurrence.month = 12;
  ///    recurrence.interval = 1;
  ///   recurrence.recurrenceRange = RecurrenceRange.noEndDate;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.generateRRule(recurrence,
  ///              DateTime.now(), DateTime.now().add(Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  int month;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final RecurrenceProperties recurrenceProperties;
    if (other is RecurrenceProperties) {
      recurrenceProperties = other;
    }
    return recurrenceProperties.recurrenceType == recurrenceType &&
        recurrenceProperties.recurrenceCount == recurrenceCount &&
        recurrenceProperties.startDate == startDate &&
        recurrenceProperties.endDate == endDate &&
        recurrenceProperties.interval == interval &&
        recurrenceProperties.recurrenceRange == recurrenceRange &&
        recurrenceProperties.weekDays == weekDays &&
        recurrenceProperties.week == week &&
        recurrenceProperties.dayOfMonth == dayOfMonth &&
        recurrenceProperties.dayOfWeek == dayOfWeek &&
        recurrenceProperties.month == month;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return hashValues(
        recurrenceType,
        recurrenceCount,
        startDate,
        endDate,
        interval,
        recurrenceRange,
        hashList(weekDays),
        week,
        dayOfMonth,
        dayOfWeek,
        month);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('recurrenceCount', recurrenceCount));
    properties.add(IntProperty('interval', interval));
    properties.add(IntProperty('week', week));
    properties.add(IntProperty('dayOfMonth', dayOfMonth));
    properties.add(IntProperty('dayOfWeek', dayOfWeek));
    properties.add(IntProperty('month', month));
    properties.add(DiagnosticsProperty<DateTime>('startTime', startDate));
    properties.add(DiagnosticsProperty<DateTime>('endTime', endDate));
    properties
        .add(EnumProperty<RecurrenceType>('recurrenceType', recurrenceType));
    properties
        .add(EnumProperty<RecurrenceRange>('recurrenceRange', recurrenceRange));
    properties.add(IterableDiagnostics<WeekDays>(weekDays)
        .toDiagnosticsNode(name: 'weekDays'));
  }
}
