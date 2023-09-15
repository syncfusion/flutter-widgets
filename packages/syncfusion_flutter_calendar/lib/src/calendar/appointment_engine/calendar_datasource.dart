import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show IterableDiagnostics;

import '../../../calendar.dart';
import '../common/calendar_view_helper.dart';
import 'appointment_helper.dart';

/// An object that maintains the data source for [SfCalendar].
///
/// Allows to map the custom appointments to the [Appointment] and set the
/// appointments collection to the [SfCalendar] to render the appointments
/// on view.
///
/// Allows to add and remove an [Appointment] from the collection and also
/// allows to reset the appointment collection for [SfCalendar].
///
/// _Note:_ This method must be implemented to get the data with business
/// object type when drag and drop or appointment resizing enabled.
///
/// See also:
/// * [Appointment], the object which holds the details of the appointment.
/// * [CalendarResource], the object which holds the details of the resource
/// in the calendar.
/// * [SfCalendar.loadMoreWidgetBuilder], allows to build an widget which will
/// display when appointments loaded on demand in the calendar.
/// * [SfCalendar.resourceViewHeaderBuilder], to set custom widget for the
/// resource view in the calendar.
/// * [resourceViewSettings], to customize the resource view in the calendar.
/// * [SfCalendar.appointmentBuilder], to set custom widget for the appointment
/// view in the calendar.
/// * [SfCalendar.appointmentTextStyle], to customize the text style for the
/// appointments in calendar.
/// * [SfCalendar.appointmentTimeTextFormat], to customize the time format for
/// the appointment view in calendar.
/// * Knowledge base: [How to perform the crud operations using firestore database](https://www.syncfusion.com/kb/12661/how-to-perform-the-crud-operations-in-flutter-calendar-using-firestore-database)
/// * Knowledge base: [How to load appointments on demand](https://www.syncfusion.com/kb/12658/how-to-load-appointments-on-demand-in-flutter-calendar)
/// * Knowledge base: [How to load google calendar events in iOS](https://www.syncfusion.com/kb/12647/how-to-load-the-google-calendar-events-to-the-flutter-calendar-sfcalendar-in-ios)
/// * Knowledge base: [How to get the appointments between the given start and end date](https://www.syncfusion.com/kb/12549/how-to-get-the-appointments-between-the-given-start-and-end-date-in-the-flutter-calendar)
/// * Knowledge base: [How to get the current month appointments](https://www.syncfusion.com/kb/12477/how-to-get-the-current-month-appointments-in-the-flutter-calendar)
/// * Knowledge base: [How to load data from offline sqlite database](https://www.syncfusion.com/kb/12399/how-to-load-data-from-offline-sqlite-database-to-flutter-calendar)
/// * Knowledge base: [How to create time table](https://www.syncfusion.com/kb/12392/how-to-create-time-table-using-flutter-event-calendar)
/// * Knowledge base: [How to add google calendar events](https://www.syncfusion.com/kb/12116/how-to-add-google-calendar-events-to-the-flutter-event-calendar-sfcalendar)
/// * Knowledge base: [How to add a custom appointments of business objects](https://www.syncfusion.com/kb/11529/how-to-add-a-custom-appointments-or-objects-in-the-flutter-calendar)
/// * Knowledge base: [How to add additional attributes in events](https://www.syncfusion.com/kb/12209/how-to-add-additional-attributes-in-events-in-the-flutter-calendar)
/// * Knowledge base: [How to work with the firebase database and flutter calendar for appointments](https://www.syncfusion.com/kb/12067/how-to-work-with-the-firebase-database-and-the-flutter-calendar-for-appointments)
/// * Knowledge base: [How to integrate [SfCalendar] with [SfDateRangePicker]](https://www.syncfusion.com/kb/12047/how-to-integrate-event-calendar-sfcalendar-with-date-picker-sfdaterangepicker-in-flutter)
/// * Knowledge base: [How to handle appointments for multiple resources](https://www.syncfusion.com/kb/11812/how-to-handle-appointments-for-multiple-resources-in-the-flutter-calendar)
/// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
/// * Knowledge base: [How to design and configure your appointment editor](https://www.syncfusion.com/kb/11204/how-to-design-and-configure-your-appointment-editor-in-flutter-calendar)
/// * Knowledge base: [How to load offline json data](https://www.syncfusion.com/kb/11466/how-to-load-the-json-data-offline-for-the-flutter-calendar-appointments)
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
/// class MeetingDataSource extends CalendarDataSource {
///  MeetingDataSource(List<_Meeting> source) {
///    appointments = source;
///  }
///
///  @override
///  DateTime getStartTime(int index) {
///    return appointments![index].from;
///  }
///
///  @override
///  DateTime getEndTime(int index) {
///    return appointments![index].to;
///  }
///
///  @override
///  Color getColor(int index) {
///    return appointments![index].background;
///  }
///
///  @override
///  String getEndTimeZone(int index) {
///    return appointments![index].toZone;
///  }
///
///  @override
///  List<DateTime> getRecurrenceExceptionDates(int index) {
///    return appointments![index].exceptionDates;
///  }
///
///  @override
///  String getRecurrenceRule(int index) {
///    return appointments![index].recurrenceRule;
///  }
///
///  @override
///  String getStartTimeZone(int index) {
///    return appointments![index].fromZone;
///  }
///
///  @override
///  String getSubject(int index) {
///    return appointments![index].title;
///  }
///
///  @override
///  bool isAllDay(int index) {
///    return appointments![index].isAllDay;
///  }
/// }
///
///class _Meeting {
///  _Meeting(
///      {required this.from,
///      required this.to,
///      this.title='',
///      this.isAllDay=false,
///      required this.background,
///      this.fromZone='',
///      this.toZone='',
///      this.exceptionDates,
///      this.recurrenceRule=''});
///  DateTime from;
///  DateTime to;
///  String title;
///  bool isAllDay;
///  Color background;
///  String fromZone;
///  String toZone;
///  String recurrenceRule;
///  List<DateTime>? exceptionDates;
/// }
///
/// final DateTime date = DateTime.now();
///  MeetingDataSource _getCalendarDataSource() {
///    List<_Meeting> appointments = <_Meeting>[];
///    appointments.add(_Meeting(
///     from: date,
///     to: date.add(const Duration(hours: 1)),
///     title: 'General Meeting',
///     isAllDay: false,
///     background: Colors.red,
///     fromZone: '',
///     toZone: '',
///     recurrenceRule: '',
///     exceptionDates: null
///  ));
///
///    return MeetingDataSource(appointments);
///  }
///  ```
@optionalTypeArgs
abstract class CalendarDataSource<T extends Object?>
    extends CalendarDataSourceChangeNotifier {
  /// Tha collection of appointments to be rendered on [SfCalendar].
  ///
  /// Defaults to `null`.
  ///
  /// See also:
  /// * [Appointment], the object to hold the data for the event in the
  /// calendar.
  /// * [resources], to set and handle the resource collection to the
  /// [SfCalendar].
  /// * [SfCalendar.appointmentBuilder], to set custom widget for the
  /// appointment view in the calendar
  /// * [SfCalendar.loadMoreWidgetBuilder], the widget which will be displayed
  /// when the appointments loading on the view in calendar.
  /// * [SfCalendar.appointmentTextStyle], to customize the appointment text,
  /// when the builder not added.
  /// * [SfCalendar.appointmentTimeTextFormat], to customize the time text
  /// format in the appointment view of calendar.
  /// * [handleLoadMore], method to load the appointment when the view changed
  /// in calendar, and on [CalendarView.schedule] when the view reached it's
  /// start or end position.
  /// * Knowledge base: [How to perform the crud operations using firestore database](https://www.syncfusion.com/kb/12661/how-to-perform-the-crud-operations-in-flutter-calendar-using-firestore-database)
  /// * Knowledge base: [How to load appointments on demand](https://www.syncfusion.com/kb/12658/how-to-load-appointments-on-demand-in-flutter-calendar)
  /// * Knowledge base: [How to create time table](https://www.syncfusion.com/kb/12392/how-to-create-time-table-using-flutter-event-calendar)
  /// * Knowledge base: [How to add a custom appointments of business objects](https://www.syncfusion.com/kb/11529/how-to-add-a-custom-appointments-or-objects-in-the-flutter-calendar)
  /// * Knowledge base: [How to add additional attributes in events](https://www.syncfusion.com/kb/12209/how-to-add-additional-attributes-in-events-in-the-flutter-calendar)
  /// * Knowledge base: [How to work with the firebase database and flutter calendar for appointments](https://www.syncfusion.com/kb/12067/how-to-work-with-the-firebase-database-and-the-flutter-calendar-for-appointments)
  /// * Knowledge base: [How to integrate [SfCalendar] with [SfDateRangePicker]](https://www.syncfusion.com/kb/12047/how-to-integrate-event-calendar-sfcalendar-with-date-picker-sfdaterangepicker-in-flutter)
  /// * Knowledge base: [How to handle appointments for multiple resources](https://www.syncfusion.com/kb/11812/how-to-handle-appointments-for-multiple-resources-in-the-flutter-calendar)
  /// * Knowledge base: [How to view schedule](https://www.syncfusion.com/kb/11803/how-to-view-schedule-in-the-flutter-calendar)
  /// * Knowledge base: [How to design and configure your appointment editor](https://www.syncfusion.com/kb/11204/how-to-design-and-configure-your-appointment-editor-in-flutter-calendar)
  /// * Knowledge base: [How to load offline json data](https://www.syncfusion.com/kb/11466/how-to-load-the-json-data-offline-for-the-flutter-calendar-appointments)
  /// * Knowledge base: [How to delete an appointment](https://www.syncfusion.com/kb/11522/how-to-delete-an-appointment-in-the-flutter-calendar)
  ///
  /// ```dat
  ///
  /// class _AppointmentDataSource extends CalendarDataSource {
  ///  _AppointmentDataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///```
  List<dynamic>? appointments;

  /// Returns the appointments in the specified date range.
  ///
  /// startDate - required - The starting date from which
  /// to obtain the appointments.
  ///
  /// endDate - optional - The end date till which
  /// to obtain the visible appointments.
  ///
  /// See also:
  /// * [Appointment], the object to hold the data for the event in the
  /// calendar.
  /// * [getPatternAppointment], which allows to get the pattern appointment of
  /// the given occurrence appointment in calendar.
  /// * [getOccurrenceAppointment],  which allows to get the occurrence
  /// appointment of the pattern appointment in the calendar.
  /// * Knowledge base: [How to get the appointments between the given start and end date](https://www.syncfusion.com/kb/12549/how-to-get-the-appointments-between-the-given-start-and-end-date-in-the-flutter-calendar)
  /// * Knowledge base: [How to get the current month appointments](https://www.syncfusion.com/kb/12477/how-to-get-the-current-month-appointments-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
  /// class MyAppState extends State<MyApp> {
  ///
  ///   CalendarController _calendarController = CalendarController();
  ///   late _AppointmentDataSource _dataSource;
  ///
  ///   @override
  ///   initState() {
  ///   _dataSource = _getCalendarDataSource();
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       home: Scaffold(
  ///         body: SfCalendar(
  ///           view: CalendarView.month,
  ///           controller: _calendarController,
  ///           dataSource: _dataSource,
  ///           onViewChanged: (ViewChangedDetails details) {
  ///             List<DateTime> dates = details.visibleDates;
  ///             String calendarTimeZone = '';
  ///             List<Object> appointment = _dataSource.getVisibleAppointments(
  ///                 dates[0], calendarTimeZone,
  ///                 dates[(details.visibleDates.length) - 1]);
  ///           },
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  ///
  /// _AppointmentDataSource _getCalendarDataSource() {
  ///   List<Appointment> appointments = <Appointment>[];
  ///   appointments.add(Appointment(
  ///     startTime: DateTime(2020, 11, 27, 9),
  ///     endTime: DateTime(2020, 11, 27, 9).add(Duration(hours: 2)),
  ///     subject: 'Meeting',
  ///     color: Colors.cyanAccent,
  ///     startTimeZone: '',
  ///     endTimeZone: '',
  ///     recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=5',
  ///   ));
  ///   appointments.add(Appointment(
  ///       startTime: DateTime(2020, 11, 28, 5),
  ///       endTime: DateTime(2020, 11, 30, 7),
  ///       subject: 'Discussion',
  ///       color: Colors.orangeAccent,
  ///       startTimeZone: '',
  ///       endTimeZone: '',
  ///       isAllDay: true
  ///   ));
  ///   return _AppointmentDataSource(appointments);
  /// }
  ///
  /// class _AppointmentDataSource extends CalendarDataSource {
  ///   _AppointmentDataSource(List<Appointment> source) {
  ///     appointments = source;
  ///   }
  /// }
  /// ```
  List<Appointment> getVisibleAppointments(
      DateTime startDate, String calendarTimeZone,
      [DateTime? endDate]) {
    endDate ??= startDate;

    /// Converts the given appointment type to calendar appointment, to handle
    /// the internal operations like timezone converting.
    /// Calendar appointment is an internal class to handle the appointment
    /// rendering on view.
    List<CalendarAppointment> calendarAppointments =
        AppointmentHelper.generateCalendarAppointments(this, calendarTimeZone);

    calendarAppointments = AppointmentHelper.getVisibleAppointments(
        startDate, endDate, calendarAppointments, calendarTimeZone, false,
        canCreateNewAppointment: false);

    final List<Appointment> visibleAppointments = <Appointment>[];

    for (int i = 0; i < calendarAppointments.length; i++) {
      visibleAppointments
          .add(calendarAppointments[i].convertToCalendarAppointment());
    }

    return visibleAppointments;
  }

  /// Returns the occurrence appointment for the
  /// given pattern appointment at the specified date.
  ///
  /// If there is no appointment occurring on
  /// the date specified, null is returned.
  ///
  /// patternAppointment - required - The pattern appointment is
  /// the start appointment in a recurrence series from which the occurrence
  /// appointments are cloned with pattern appointment characteristics.
  ///
  /// date - required - The date on which the
  /// occurrence appointment is requested.
  ///
  /// See also:
  /// * [Appointment], the object to hold the data for the event in the
  /// calendar.
  /// * [getVisibleAppointments], which allows to get the appointment
  /// collection between the given date range.
  /// * [getPatternAppointment], which allows to get the pattern appointment of
  /// the given occurrence appointment in calendar.
  /// * [SfCalendar.getRecurrenceDateTimeCollection], which used to get the
  /// recurrence date time collection for the given recurrence rule.
  ///
  /// ```dart
  ///
  /// class MyAppState extends State<MyApp>{
  ///   late CalendarController _calendarController;
  ///   late _AppointmentDataSource _dataSource;
  ///   late Appointment recurrenceApp;
  ///
  ///   @override
  ///   initState(){
  ///     _calendarController = CalendarController();
  ///     _dataSource = _getCalendarDataSource();
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       home: Scaffold(
  ///         body: SfCalendar(
  ///           view: CalendarView.month,
  ///           controller: _calendarController,
  ///           dataSource: _dataSource,
  ///           initialDisplayDate: DateTime(2020,11,27,9),
  ///           onTap: (CalendarTapDetails details) {
  ///             final DateTime? date = details.date;
  ///            final Appointment? occurrenceAppointment =
  ///             _dataSource.getOccurrenceAppointment(
  ///                                                 recurrenceApp, date!, '');
  ///           },
  ///         ),
  ///      ),
  ///     );
  ///   }
  ///   _AppointmentDataSource _getCalendarDataSource() {
  ///     final List<Appointment> appointments = <Appointment>[];
  ///    recurrenceApp = Appointment(
  ///       startTime: DateTime(2020,11,27,9),
  ///       endTime: DateTime(2020,11,27,9).add(const Duration(hours: 2)),
  ///       subject: 'Meeting',
  ///       color: Colors.cyanAccent,
  ///       startTimeZone: '',
  ///       endTimeZone: '',
  ///      recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=5',
  ///     );
  ///     appointments.add(recurrenceApp);
  ///     appointments.add(Appointment(
  ///         startTime: DateTime(2020,11,28,5),
  ///         endTime: DateTime(2020,11,30,7),
  ///         subject: 'Discussion',
  ///         color: Colors.orangeAccent,
  ///         startTimeZone: '',
  ///         endTimeZone: '',
  ///         isAllDay: true
  ///     ));
  ///     return _AppointmentDataSource(appointments);
  ///   }
  /// }
  /// class _AppointmentDataSource extends CalendarDataSource {
  ///   _AppointmentDataSource(List<Appointment> source){
  ///     appointments = source;
  ///   }
  /// }
  ///
  /// ```
  Appointment? getOccurrenceAppointment(
      Object? patternAppointment, DateTime date, String calendarTimeZone) {
    if (patternAppointment == null) {
      return null;
    }

    final List<dynamic> patternAppointmentColl = <dynamic>[patternAppointment];
    final List<CalendarAppointment> patternAppointments =
        AppointmentHelper.generateCalendarAppointments(
            this, calendarTimeZone, patternAppointmentColl);
    final CalendarAppointment patternCalendarAppointment =
        patternAppointments[0];

    if (patternCalendarAppointment.recurrenceRule == null ||
        patternCalendarAppointment.recurrenceRule!.isEmpty) {
      return null;
    } else if (CalendarViewHelper.isDateInDateCollection(
        patternCalendarAppointment.recurrenceExceptionDates, date)) {
      final List<CalendarAppointment> dataSourceAppointments =
          AppointmentHelper.generateCalendarAppointments(
              this, calendarTimeZone);
      for (int i = 0; i < dataSourceAppointments.length; i++) {
        final CalendarAppointment dataSourceAppointment =
            dataSourceAppointments[i];
        if (patternCalendarAppointment.id ==
                dataSourceAppointment.recurrenceId &&
            (isSameDate(dataSourceAppointment.startTime, date))) {
          return dataSourceAppointment.convertToCalendarAppointment();
        }
      }
    } else {
      final List<CalendarAppointment> occurrenceAppointments =
          AppointmentHelper.getVisibleAppointments(
              date, date, patternAppointments, calendarTimeZone, false,
              canCreateNewAppointment: false);

      if (occurrenceAppointments.isEmpty) {
        return null;
      }

      return occurrenceAppointments[0].convertToCalendarAppointment();
    }
    return null;
  }

  /// Returns the Pattern appointment for the provided occurrence appointment.
  ///
  /// occurrenceAppointment - required - The occurrence appointment for which
  /// the Pattern appointment is obtained.
  ///
  /// * [Appointment], the object to hold the data for the event in the
  /// calendar.
  /// * [getVisibleAppointments], which allows to get the appointment
  /// collection between the given date range.
  /// * [getOccurrenceAppointment], which allows to get the occurrence
  /// appointment of the given pattern appointment in calendar.
  /// * [SfCalendar.getRecurrenceDateTimeCollection], which used to get the
  /// recurrence date time collection for the given recurrence rule.
  ///
  /// ```dart
  ///
  /// class MyAppState extends State<MyApp>{
  ///   late CalendarController _calendarController;
  ///   late _AppointmentDataSource _dataSource;
  ///   late Appointment recurrenceApp;
  ///   @override
  ///   initState(){
  ///     _calendarController = CalendarController();
  ///     _dataSource = _getCalendarDataSource();
  ///     super.initState();
  ///   }
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       home: Scaffold(
  ///         body: SfCalendar(
  ///           view: CalendarView.month,
  ///           controller: _calendarController,
  ///           dataSource: _dataSource,
  ///           initialDisplayDate: DateTime(2020,11,27,9),
  ///           onTap: (CalendarTapDetails details) {
  ///             if(details.appointments!.isNotEmpty &&
  ///                                             details.appointments != null){
  ///               final dynamic occurrenceAppointment =
  ///                                                 details.appointments![0];
  ///               final Appointment? patternAppointment =
  ///               _dataSource.getPatternAppointment(
  ///                                occurrenceAppointment, '') as Appointment?;
  ///             }
  ///           },
  ///         ),
  ///       ),
  ///     );
  ///   }
  ///   _AppointmentDataSource _getCalendarDataSource() {
  ///     List<Appointment> appointments = <Appointment>[];
  ///     recurrenceApp = Appointment(
  ///       startTime: DateTime(2020,11,27,9),
  ///       endTime: DateTime(2020,11,27,9).add(Duration(hours: 2)),
  ///       subject: 'Meeting',
  ///       color: Colors.cyanAccent,
  ///       startTimeZone: '',
  ///       endTimeZone: '',
  ///       recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=5',
  ///     );
  ///     appointments.add(recurrenceApp);
  ///     appointments.add(Appointment(
  ///         startTime: DateTime(2020,11,28,5),
  ///         endTime: DateTime(2020,11,30,7),
  ///         subject: 'Discussion',
  ///         color: Colors.orangeAccent,
  ///         startTimeZone: '',
  ///         endTimeZone: '',
  ///         isAllDay: true
  ///     ));
  ///     return _AppointmentDataSource(appointments);
  ///   }
  /// }
  /// class _AppointmentDataSource extends CalendarDataSource {
  ///   _AppointmentDataSource(List<Appointment> source){
  ///     appointments = source;
  ///   }
  /// }
  ///
  /// ```
  Object? getPatternAppointment(
      Object? occurrenceAppointment, String calendarTimeZone) {
    if (occurrenceAppointment == null) {
      return null;
    }
    final List<dynamic> occurrenceAppointmentColl = <dynamic>[
      occurrenceAppointment
    ];
    final List<CalendarAppointment> occurrenceAppointments =
        AppointmentHelper.generateCalendarAppointments(
            this, calendarTimeZone, occurrenceAppointmentColl);
    final CalendarAppointment occurrenceCalendarAppointment =
        occurrenceAppointments[0];
    if ((occurrenceCalendarAppointment.recurrenceRule == null ||
            occurrenceCalendarAppointment.recurrenceRule!.isEmpty) &&
        occurrenceCalendarAppointment.recurrenceId == null) {
      return null;
    }
    final List<CalendarAppointment> dataSourceAppointments =
        AppointmentHelper.generateCalendarAppointments(
            this, calendarTimeZone, appointments);

    for (int i = 0; i < dataSourceAppointments.length; i++) {
      final CalendarAppointment dataSourceAppointment =
          dataSourceAppointments[i];
      if ((dataSourceAppointment.id ==
              occurrenceCalendarAppointment.recurrenceId) ||
          (occurrenceCalendarAppointment.recurrenceId == null &&
              dataSourceAppointment.id == occurrenceCalendarAppointment.id)) {
        return dataSourceAppointment.data;
      }
    }
    return null;
  }

  /// The collection of resource to be displayed in the timeline views of
  /// [SfCalendar].
  ///
  /// Defaults to `null`.
  ///
  /// See also:
  /// * [CalendarResource], the object to hold the data for the resource in the
  /// calendar.
  /// * [appointments], to set and handle the resource collection to the
  /// [SfCalendar].
  /// * [TimeRegion], the object to hold the data for the special time region in
  /// the calendar.
  /// * [SfCalendar.resourceViewHeaderBuilder], to set custom widget for the
  /// resource view in the calendar.
  /// * [resourceViewSettings], to customize the resource view in the calendar.
  /// * Knowledge base: [How to add resources](https://www.syncfusion.com/kb/12070/how-to-add-resources-in-the-flutter-calendar)
  /// * Knowledge base: [How to handle appointments for multiple resources](https://www.syncfusion.com/kb/11812/how-to-handle-appointments-for-multiple-resources-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the resource view](https://www.syncfusion.com/kb/12351/how-to-customize-the-resource-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to add appointment for the selected resources using appointment editor](https://www.syncfusion.com/kb/12109/how-to-add-appointment-for-the-selected-resources-using-appointment-editor-in-the-flutter)
  ///
  /// ```dart
  ///
  /// class AppointmentDataSource extends CalendarDataSourceResource {
  ///    AppointmentDataSource(List<Appointment> appointments,
  ///                                 List<CalendarResource> resources) {
  ///    resources = resources;
  ///    appointments = appointments;
  ///  }
  /// }
  ///
  /// ```
  List<CalendarResource>? resources;

  /// Maps the custom appointments start time to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s start time property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// It is mandatory to override this method to set custom appointments
  /// collection to the [appointments].
  ///
  /// See also:
  /// * [Appointment.startTime], the date time value in which the appointment
  /// will start.
  /// * [isAllDay], which used to map the custom appointment's
  /// [Appointment.isAllDay] property to the [Appointment].
  /// * [getEndTime], which used to map the custom appointment's
  /// [Appointment.endTime] property to the [Appointment].
  /// * [getStartTimeZone], which used to map the custom appointment's
  /// [Appointment.startTimeZone] property to the [Appointment].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments![index].from;
  ///  }
  /// ```
  DateTime getStartTime(int index) => DateTime.now();

  /// Maps the custom appointments end time to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s end time property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// It is mandatory to override this method to set custom appointments
  /// collection to the [appointments].
  ///
  /// See also:
  /// * [Appointment.endTime], the date time value in which the appointment
  /// will end.
  /// * [isAllDay], which used to map the custom appointment's
  /// [Appointment.isAllDay] property to the [Appointment].
  /// * [getStartTime], which used to map the custom appointment
  /// [Appointment.startTime] property to the [Appointment].
  /// * [getEndTimeZone], which used to map the custom appointment's
  /// [Appointment.endTimeZone] property to the [Appointment].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ```dart
  ///  @override
  ///  DateTime getEndTime(int index) {
  ///    return appointments![index].to;
  ///  }
  /// ```
  DateTime getEndTime(int index) => DateTime.now();

  /// Maps the custom appointments subject to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s subject property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.subject], which holds the subject of the appointment which
  /// will be displayed on the event UI.
  /// * [SfCalendar.appointmentTextStyle], to customize the appointment text,
  /// when the builder not added.
  /// * Knowledge base: [How to style appointments](https://www.syncfusion.com/kb/12162/how-to-style-the-appointment-in-the-flutter-calendar)
  ///
  /// ```dart
  ///  @override
  ///  DateTime getSubject(int index) {
  ///    return appointments![index].title;
  ///  }
  /// ```
  String getSubject(int index) => '';

  /// Maps the custom appointments isAllDay to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s isAllDay property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.isAllDay], which defines whether the event is a day long or
  ///  not.
  /// * [getStartTime], which used to map the custom appointment
  /// [Appointment.startTime] property to the [Appointment].
  /// * [getEndTime], which used to map the custom appointment
  /// [Appointment.endTime] property to the [Appointment].
  /// * [getStartTimeZone], which used to map the custom appointment's
  /// [Appointment.startTimeZone] property to the [Appointment].
  /// * [getEndTimeZone], which used to map the custom appointment's
  /// [Appointment.endTimeZone] property to the [Appointment].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ```dart
  ///  @override
  ///  DateTime isAllDay(int index) {
  ///    return appointments![index].isAllDay;
  ///  }
  /// ```
  bool isAllDay(int index) => false;

  /// Maps the custom appointments color to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s color property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.color], which fills the background of the appointment view
  /// in the [SfCalendar].
  /// * [SfCalendar.appointmentTextStyle], to customize the appointment text,
  /// when the builder not added.
  /// * [SfCalendar.appointmentBuilder], to set custom widget for the
  /// appointment view in the calendar
  /// * Knowledge base: [How to style appointments](https://www.syncfusion.com/kb/12162/how-to-style-the-appointment-in-the-flutter-calendar)
  ///
  /// ```dart
  ///  @override
  ///  DateTime getColor(int index) {
  ///    return appointments![index].background;
  ///  }
  /// ```
  Color getColor(int index) => Colors.lightBlue;

  /// Maps the custom appointments notes to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s notes property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.notes], which stored some note of the appointment in the
  /// calendar.
  /// * [getLocation], which maps the custom appointment's
  /// [Appointment.location] property to the [Appointment]
  ///
  ///
  /// ```dart
  ///  @override
  ///  DateTime getNotes(int index) {
  ///    return appointments![index].notes;
  ///  }
  /// ```
  String? getNotes(int index) => null;

  /// Maps the custom appointments location to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s location property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.location], which used to store the location data of the
  /// event in the calendar.
  /// * [getNotes], which maps the custom appointment's [Appointment.notes]
  /// property to the [Appointment]
  ///
  /// ```dart
  ///  @override
  ///  DateTime getLocation(int index) {
  ///    return appointments![index].place;
  ///  }
  /// ```
  String? getLocation(int index) => null;

  /// Maps the custom appointments start time zone to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s start time zone property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.startTimeZone], which sets the time zone for the start time
  /// of the appointment.
  /// * [getEndTime], which used to map the custom appointment's
  /// [Appointment.endTime] property to the [Appointment].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTimeZone(int index) {
  ///    return appointments![index].fromZone;
  ///  }
  /// ```
  String? getStartTimeZone(int index) => null;

  /// Maps the custom appointments end time zone to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s end time zone property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.endTimeZone], which sets the time zone for the end time
  /// of the appointment.
  /// * [getStartTime], which used to map the custom appointment's
  /// [Appointment.startTime] property to the [Appointment].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ```dart
  ///  @override
  ///  DateTime getEndTimeZone(int index) {
  ///    return appointments![index].toZone;
  ///  }
  /// ```
  String? getEndTimeZone(int index) => null;

  /// Maps the custom appointments recurrence rule to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s recurrence rule property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.recurrenceRule], which used to recur the appointment based
  /// on the given rule.
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
  /// ```dart
  ///  @override
  ///  DateTime getRecurrenceRule(int index) {
  ///    return appointments![index].recurrenceRule;
  ///  }
  /// ```
  String? getRecurrenceRule(int index) => null;

  /// Maps the custom appointments recurrenceExceptionDates to the [Appointment]
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s recurrenceExceptionDates property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.recurrenceExceptionDates], which used to exclude some dates
  /// from the recurrence series of the appointment.
  /// * [getRecurrenceRule],which used to map the custom appointment's
  /// [Appointment.recurrenceRule] property of the [Appointment].
  /// * [RecurrenceProperties], which used to create the recurrence rule based
  /// on the values set to these properties.
  /// * [SfCalendar.generateRRule], which used to generate recurrence rule
  /// based on the [RecurrenceProperties] values.
  /// * Knowledge base: [How to exclude the dates from the recurrence appointments](https://www.syncfusion.com/kb/12161/how-to-exclude-the-dates-from-recurrence-appointments-in-the-flutter-calendar)
  ///
  /// ```dart
  ///  @override
  ///  DateTime getRecurrenceExceptionDates(int index) {
  ///    return appointments![index].exceptionDates;
  ///  }
  /// ```
  List<DateTime>? getRecurrenceExceptionDates(int index) => null;

  /// Maps the custom appointment resource ids to the [Appointment] resource
  /// ids.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.resourceIds], the ids of the [CalendarResource] that shares
  /// this [Appointment].
  /// * [CalendarResource], object which contains the resource data.
  /// * [ResourceViewSettings], the settings have properties which allow to
  /// customize the resource view of the [SfCalendar].
  /// * [CalendarResource.id], the unique id for the [CalendarResource] view of
  /// [SfCalendar].
  /// * [resources], which used to set and handle the resources collection to
  /// the calendar.
  /// * Knowledge base: [How to add appointment for the selected resource using appointment editor](https://www.syncfusion.com/kb/12109/how-to-add-appointment-for-the-selected-resources-using-appointment-editor-in-the-flutter)
  /// * Knowledge base: [How to add resources](https://www.syncfusion.com/kb/12070/how-to-add-resources-in-the-flutter-calendar)
  /// * Knowledge base: [How to handle appointments for muliple resources](https://www.syncfusion.com/kb/11812/how-to-handle-appointments-for-multiple-resources-in-the-flutter-calendar)
  ///
  /// ```dart
  ///  @override
  ///  DateTime getResourceIds(int index) {
  ///    return appointments![index].resourceIds;
  ///  }
  /// ```
  List<Object>? getResourceIds(int index) => null;

  /// Maps the custom appointments recurrence id to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s recurrenceId property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.recurrenceId], which used to handle the changed or
  /// exception occurrence appointments in calendar.
  /// * [getId], which used to map the custom appointment's [Appointment.id]
  /// property of the [Appointment].
  ///
  /// ```dart
  ///  @override
  ///  DateTime getRecurrenceId(int index) {
  ///    return appointments[index].recurrenceId;
  ///  }
  /// ```
  Object? getRecurrenceId(int index) => null;

  /// Maps the custom appointments id to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s id property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also:
  /// * [Appointment.id], which holds an unique identification number for the
  /// appointment in the calendar.
  /// * [getRecurrenceRule], which used to map the custom appointment's
  /// [Appointment.recurrenceRule] property to the [Appointment].
  ///
  /// ```dart
  ///  @override
  ///  DateTime getId(int index) {
  ///    return appointments[index].id;
  ///  }
  /// ```
  Object? getId(int index) => null;

  /// Converts the [Appointment] data to the custom business object data.
  ///
  /// Note_:_ When business object used to set data for [SfCalendar], this
  /// method must be implemented to get the data with business object type when
  /// drag and drop and appointment resizing enabled.
  ///
  /// ```dart
  ///
  ///class _DataSource extends CalendarDataSource<_Meeting> {
  ///   _DataSource(List<_Meeting> source) {
  ///     appointments = source;
  ///   }
  ///
  ///   @override
  ///   DateTime getStartTime(int index) {
  ///     return appointments![index].from as DateTime;
  ///   }
  ///
  ///   @override
  ///   DateTime getEndTime(int index) {
  ///     return appointments![index].to as DateTime;
  ///   }
  ///
  ///   @override
  ///   String getSubject(int index) {
  ///     return appointments![index].content as String;
  ///   }
  ///
  ///   @override
  ///   Color getColor(int index) {
  ///     return appointments![index].background as Color;
  ///   }
  ///
  ///   @override
  ///   _Meeting convertAppointmentToObject(
  ///       _Meeting customData, Appointment appointment) {
  ///     return _Meeting(
  ///         from: appointment.startTime,
  ///         to: appointment.endTime,
  ///         content: appointment.subject,
  ///         background: appointment.color,
  ///         isAllDay: appointment.isAllDay);
  ///   }
  /// }
  ///
  /// ```
  T? convertAppointmentToObject(T customData, Appointment appointment) => null;

  /// Called when loadMoreAppointments function is called from the
  /// loadMoreWidgetBuilder.
  /// Call the [notifyListeners] to notify the calendar for data source changes.
  ///
  /// See also:
  /// * [SfCalendar.loadMoreWidgetBuilder], which used to set custom widget,
  /// which will be displayed when the appointment is loading on view.
  /// * [notifyListeners], to add, remove or reset the appointment and resource
  ///  collection.
  /// * Knowledge base: [How to load appointments on demand](https://www.syncfusion.com/kb/12658/how-to-load-appointments-on-demand-in-flutter-calendar)
  ///
  /// ```dart
  ///  @override
  ///  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
  ///  await Future.delayed(Duration(seconds: 5));
  ///    List<Appointment> newColl = <Appointment>[];
  ///    for (DateTime date = startDate;
  ///        date.isBefore(endDate);
  ///        date = date.add(Duration(days: 1))) {
  ///      newColl.add(Appointment(
  ///        startTime: date,
  ///        endTime: date.add(Duration(hours: 2)),
  ///        subject: 'Meeting',
  ///        color: Colors.red,
  ///      ));
  ///    }
  ///
  ///    appointments!.addAll(newColl);
  ///    notifyListeners(CalendarDataSourceAction.add, newColl);
  ///  }
  /// ```
  @protected
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {}

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableDiagnostics<dynamic>(appointments)
        .toDiagnosticsNode(name: 'appointments'));
    properties.add(IterableDiagnostics<CalendarResource>(resources)
        .toDiagnosticsNode(name: 'resources'));
  }
}

/// Signature for callback that reports that a appointment collection set to the
/// [CalendarDataSource] modified.
///
/// See also:
/// [CalendarDataSourceAction], the actions which can be performed using the
/// calendar.
typedef CalendarDataSourceCallback = void Function(
    CalendarDataSourceAction, List<dynamic>);

/// Notifier used to notify the action performed in the [CalendarDataSource]
class CalendarDataSourceChangeNotifier with Diagnosticable {
  List<CalendarDataSourceCallback>? _listeners;

  /// Calls the listener every time the collection in the [CalendarDataSource]
  /// changed
  ///
  /// Listeners can be removed with [removeListener]
  void addListener(CalendarDataSourceCallback listener) {
    _listeners ??= <CalendarDataSourceCallback>[];
    _listeners!.add(listener);
  }

  /// remove the listener used for notify the data source changes.
  ///
  /// Stop calling the listener every time the the collection in
  /// [CalendarDataSource] changed.
  ///
  /// If `listener` is not currently registered as a listener, this method does
  /// nothing.
  ///
  /// Listeners can be added with [addListener].
  void removeListener(CalendarDataSourceCallback listener) {
    if (_listeners == null) {
      return;
    }

    _listeners!.remove(listener);
  }

  /// Call all the registered listeners.
  ///
  /// Call this method whenever the object changes, to notify any clients the
  /// object may have. Listeners that are added during this iteration will not
  /// be visited. Listeners that are removed during this iteration will not be
  /// visited after they are removed.
  ///
  /// Exceptions thrown by listeners will be caught and reported using
  /// [FlutterError.reportError].
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// Surprising behavior can result when reentrantly removing a listener (i.e.
  /// in response to a notification) that has been registered multiple times.
  /// See the discussion at [removeListener].
  void notifyListeners(CalendarDataSourceAction type, List<dynamic> data) {
    if (_listeners == null) {
      return;
    }

    for (final CalendarDataSourceCallback listener in _listeners!) {
      listener(type, data);
    }
  }

  /// Discards any resources used by the object. After this is called, the
  /// object is not in a usable state and should be discarded (calls to
  /// [addListener] and [removeListener] will throw after the object is
  /// disposed).
  ///
  /// This method should only be called by the object's owner.
  @mustCallSuper
  void dispose() {
    _listeners = null;
  }
}
