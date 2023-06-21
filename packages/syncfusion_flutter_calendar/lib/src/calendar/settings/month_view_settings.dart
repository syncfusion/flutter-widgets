import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../calendar.dart';

/// The settings have properties which allow to customize the month view of
/// the [SfCalendar].
///
/// Allows to customize the [dayFormat], [numberOfWeeksInView],
/// [appointmentDisplayMode], [showAgenda], [appointmentDisplayCount]
/// [showTrailingAndLeadingDates] and [navigationDirection] in month view of
/// [SfCalendar].
///
/// See also:
/// * [TimeSlotViewSettings], which is used to customize the timeslot view of
/// calendar.
/// * [SfCalendar.monthCellBuilder], which used to set the custom widget for
/// month cell in calendar.
/// * [SfCalendar.monthViewSettings], to know more about the customization of
/// month view in calendar.
/// * [SfCalendar.blackoutDates], which allows to restrict the interaction for a
/// particular date in month views of calendar.
/// * [SfCalendar.blackoutDatesTextStyle], which used to customize the blackout
/// dates text style in the month view of calendar.
/// * Knowledge base: [How to customize agenda view height based on widget height](https://www.syncfusion.com/kb/11013/how-to-customize-agenda-view-height-based-on-the-flutter-calendar-widget-height)
/// * Knowledge base: [How to customize agenda item height](https://www.syncfusion.com/kb/11015/how-to-customize-the-agenda-item-height-in-the-flutter-calendar)
/// * Knowledge base: [How to show appointment in agenda view using programmatic date selection](https://www.syncfusion.com/kb/11525/how-to-show-the-appointment-in-agenda-view-using-the-programmatic-date-selection-in-the)
/// * Knowledge base: [How to customize the blackout dates](https://www.syncfusion.com/kb/11987/how-to-customize-the-blackout-dates-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
/// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
/// * Knowledge base: [How to change the number of weeks](https://www.syncfusion.com/kb/12157/how-to-change-the-number-of-weeks-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
/// * Knowledge base: [How to customize the month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the month cell based on the appointment using builder](https://www.syncfusion.com/kb/12210/how-to-customize-the-month-cell-based-on-the-appointment-using-builder-in-the-flutter)
/// * Knowledge base: [How to clear the appointment in month agenda view using onViewChanged callback](https://www.syncfusion.com/kb/12089/how-to-clear-the-appointments-in-month-agenda-view-using-onviewchange-callback-in-the)
///
/// ```dart
///
///Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.month,
///        monthViewSettings: MonthViewSettings(
///            dayFormat: 'EEE',
///            numberOfWeeksInView: 4,
///            appointmentDisplayCount: 2,
///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
///            showAgenda: false,
///            navigationDirection: MonthNavigationDirection.horizontal),
///      ),
///    );
///  }
///
/// ```
@immutable
class MonthViewSettings with Diagnosticable {
  /// Creates a Month view settings for calendar.
  ///
  /// The properties allows to customize the month view of [SfCalendar].
  const MonthViewSettings(
      {this.appointmentDisplayCount = 3,
      this.numberOfWeeksInView = 6,
      this.appointmentDisplayMode = MonthAppointmentDisplayMode.indicator,
      this.showAgenda = false,
      this.navigationDirection = MonthNavigationDirection.horizontal,
      this.dayFormat = 'EE',
      this.agendaItemHeight = -1,
      this.showTrailingAndLeadingDates = true,
      this.agendaViewHeight = -1,
      this.monthCellStyle = const MonthCellStyle(),
      this.agendaStyle = const AgendaStyle()})
      : assert(appointmentDisplayCount >= 0),
        assert(numberOfWeeksInView >= 1 && numberOfWeeksInView <= 6),
        assert(agendaItemHeight >= -1),
        assert(agendaViewHeight >= -1);

  /// Formats the text in the [SfCalendar] month view view header.
  ///
  /// Defaults to `EE`.
  ///
  /// See also:
  /// * [ViewHeaderStyle], which is used to customize the view header view of
  /// the calendar.
  /// * Knowledge base: [How to format the view header day and date format](https://www.syncfusion.com/kb/12339/how-to-format-the-view-header-day-and-date-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        dataSource: _getCalendarDataSource(),
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal,
  ///           monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///           normal, fontSize: 15, color: Colors.black),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
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
  ///  DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(Appointment(
  ///      startTime: DateTime.now(),
  ///      endTime: DateTime.now().add(Duration(hours: 2)),
  ///      isAllDay: true,
  ///      subject: 'Meeting',
  ///      color: Colors.blue,
  ///      startTimeZone: '',
  ///      endTimeZone: '',
  ///    ));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///
  final String dayFormat;

  /// The height for each appointment view to layout within this in month agenda
  /// view of [SfCalendar],.
  ///
  /// Defaults to `50`.
  ///
  /// ![month agenda item height as 70](https://help.syncfusion.com/flutter/calendar/images/monthview/agenda-item-height.png)
  ///
  /// See more:
  /// * [showAgenda], which allows to display agenda view as a part of
  /// month view in calendar.
  /// * [agendaViewHeight], which is the size for agenda view on month view of
  /// calendar.
  /// * [agendaStyle], which is used to customize the agenda view on month view
  /// of calendar.
  /// * [appointmentDisplayMode], which allows to customize the display mode
  /// of appointment view in month cells of calendar.
  /// * Knowledge base: [How to customize agenda view height based on widget height](https://www.syncfusion.com/kb/11013/how-to-customize-agenda-view-height-based-on-the-flutter-calendar-widget-height)
  /// * Knowledge base: [How to customize agenda item height](https://www.syncfusion.com/kb/11015/how-to-customize-the-agenda-item-height-in-the-flutter-calendar)
  /// * Knowledge base: [How to show appointment in agenda view using programmatic date selection](https://www.syncfusion.com/kb/11525/how-to-show-the-appointment-in-agenda-view-using-the-programmatic-date-selection-in-the)
  /// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
  /// * Knowledge base: [How to clear the appointment in month agenda view using onViewChanged callback](https://www.syncfusion.com/kb/12089/how-to-clear-the-appointments-in-month-agenda-view-using-onviewchange-callback-in-the)
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          agendaItemHeight: 50,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: false,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  /// ```
  final double agendaItemHeight;

  /// Makes the leading and trailing dates visible for the [SfCalendar]
  /// month view.
  ///
  /// Defaults to `true`.
  ///
  /// Note: Leading and trailing dates are not visible when the
  /// [showTrailingAndLeadingDates] value is false and the
  /// [showTrailingAndLeadingDates] only applies when the
  /// [numberOfWeeksInView] is 6.
  ///
  /// Styling of the trailing and leading dates can be handled using the
  /// [MonthCellStyle.leadingDatesTextStyle] and
  /// [MonthCellStyle.trailingDatesTextStyle] properties in [MonthCellStyle].
  ///
  /// See also:
  /// * [numberOfWeeksInView], which allows to customize the displaying week
  /// count in month view of calendar.
  /// * [monthCellStyle.leadingDatesBackgroundColor], which fills the background
  /// of the leading dates cell in month view of calendar.
  /// * [monthCellStyle.leadingDatesTextStyle], which is the style for the
  /// leading dates text in month view of calendar.
  /// * [monthCellStyle.trailingDatesBackgroundColor], which fills the
  /// background of the trailing dates cell in month view of calendar.
  /// * [monthCellStyle.trailingDatesTextStyle], which is the style for the
  /// trailing dates text in month view of calendar.
  /// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
  /// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
  /// * Knowledge base: [How to change the number of weeks](https://www.syncfusion.com/kb/12157/how-to-change-the-number-of-weeks-in-the-flutter-calendar)
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.month,
  ///      monthViewSettings: MonthViewSettings(
  ///          showTrailingAndLeadingDates: false,
  ///         ),
  ///      ),
  ///    );
  /// }
  /// ```
  final bool showTrailingAndLeadingDates;

  /// Sets the style to customize [SfCalendar] month cells.
  ///
  /// Allows to customize the [MonthCellStyle.textStyle],
  /// [MonthCellStyle.trailingDatesTextStyle],
  /// [MonthCellStyle.leadingDatesTextStyle], [MonthCellStyle.backgroundColor],
  /// [MonthCellStyle.todayBackgroundColor],
  /// [MonthCellStyle.leadingDatesBackgroundColor] and
  /// [MonthCellStyle.trailingDatesBackgroundColor] in month cells of month view
  /// in calendar.
  ///
  /// Defaults to null.
  ///
  /// See more:
  /// * [agendaStyle], which used to customize the agenda view on month view
  /// of calendar.
  /// * [appointmentDisplayMode], which is used to customize the appointment
  /// display mode in month cells of calendar.
  /// * [SfCalendar.monthCellBuilder], which used to set the custom widget for
  /// month cell in calendar.
  /// * [SfCalendar.blackoutDates], which allows to restrict the interaction for
  /// a particular date in month views of calendar.
  /// * [SfCalendar.blackoutDatesTextStyle], which used to customize the
  /// blackout dates text style in the month view of calendar.
  /// * [SfCalendarTheme], to handle theming with calendar for giving consistent
  /// look.
  /// * Knowledge base: [How to customize the blackout dates](https://www.syncfusion.com/kb/11987/how-to-customize-the-blackout-dates-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
  /// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell based on the appointment using builder](https://www.syncfusion.com/kb/12210/how-to-customize-the-month-cell-based-on-the-appointment-using-builder-in-the-flutter)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        dataSource: _getCalendarDataSource(),
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal,
  ///           monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///           normal, fontSize: 15, color: Colors.black),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
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
  ///  DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(Appointment(
  ///      startTime: DateTime.now(),
  ///      endTime: DateTime.now().add(Duration(hours: 2)),
  ///      isAllDay: true,
  ///      subject: 'Meeting',
  ///      color: Colors.blue,
  ///      startTimeZone: '',
  ///      endTimeZone: '',
  ///    ));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///
  final MonthCellStyle monthCellStyle;

  /// Sets the style to customize [SfCalendar] month agenda view.
  ///
  /// Allows to customize the [AgendaStyle.backgroundColor],
  /// [AgendaStyle.dayTextStyle], [AgendaStyle.dateTextStyle] and
  /// [AgendaStyle.appointmentTextStyle] in month agenda view of calendar.
  ///
  /// See also:
  /// * [monthCellStyle], which used to customize the month cell of month view
  /// in calendar.
  /// * [showAgenda], which allows to display agenda view as a part of
  /// month view in calendar.
  /// * [agendaViewHeight], which is the size for agenda view on month view of
  /// calendar.
  /// * [appointmentDisplayMode], which is used to customize the appointment
  /// display mode in month cells of calendar.
  /// * Knowledge base: [How to customize agenda view height based on widget height](https://www.syncfusion.com/kb/11013/how-to-customize-agenda-view-height-based-on-the-flutter-calendar-widget-height)
  /// * Knowledge base: [How to customize agenda item height](https://www.syncfusion.com/kb/11015/how-to-customize-the-agenda-item-height-in-the-flutter-calendar)
  /// * Knowledge base: [How to show appointment in agenda view using programmatic date selection](https://www.syncfusion.com/kb/11525/how-to-show-the-appointment-in-agenda-view-using-the-programmatic-date-selection-in-the)
  /// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
  /// * Knowledge base: [How to clear the appointment in month agenda view using onViewChanged callback](https://www.syncfusion.com/kb/12089/how-to-clear-the-appointments-in-month-agenda-view-using-onviewchange-callback-in-the)
  /// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: false,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  /// ```
  final AgendaStyle agendaStyle;

  /// The number of weeks to display in [ SfCalendar ]'s month view.
  ///
  /// Defaults to `6`.
  ///
  /// _Note:_ If this property is set to a value less than or equal to ' 4, '
  /// the trailing and lead dates style will not be updated.
  ///
  /// See also:
  /// * [showTrailingAndLeadingDates], which used to restrict the rendering of
  /// leading and trailing dates on month view of calendar.
  /// * [showAgenda], which allows to display agenda view as a part of
  /// month view in calendar.
  /// * [agendaViewHeight], which is the size for agenda view on month view of
  /// calendar.
  /// * Knowledge base: [How to change the number of weeks](https://www.syncfusion.com/kb/12157/how-to-change-the-number-of-weeks-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final int numberOfWeeksInView;

  /// The number of appointments to be displayed in month cell of [SfCalendar].
  ///
  /// Defaults to `3`.
  ///
  /// _Note:_ if the appointment count is less than the value set to this
  /// property in a particular day, then the month cell will display the
  /// appointments according to the number of appointments available on that
  /// day.
  ///
  /// Appointment indicator will be shown on the basis of date meetings, usable
  /// month cell size and indicator count. For eg, if the month cell size is
  /// less (available for only 4 dots) and the indicator count is 10, then 4
  /// indicators will be shown
  ///
  /// See also:
  /// * [appointmentDisplayMode], which allows to customize the display mode
  /// of appointment view in month cells of calendar.
  /// * [showAgenda], which allows to display agenda view as a part of
  /// month view in calendar.
  /// * [agendaViewHeight], which is the size for agenda view on month view of
  /// calendar.
  /// * [agendaItemHeight], which is the size for every single appointment view
  /// in agenda view of month view in calendar.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final int appointmentDisplayCount;

  /// Defines the appointment display mode for the month cell in [SfCalendar].
  ///
  /// Defaults to `MonthAppointmentDisplayMode.indicator`.
  ///
  /// See also:
  /// * [MonthAppointmentDisplayMode], to know more about the available display
  /// options for appointment view in month cell of calendar.
  /// * [appointmentDisplayCount], which allows to customize the number of
  /// appointment displaying on a month cell of month view in calendar.
  /// * [showAgenda], which allows to display agenda view as a part of
  /// month view in calendar.
  /// * [agendaViewHeight], which is the size for agenda view on month view of
  /// calendar.
  /// * [agendaItemHeight], which is the size for every single appointment view
  /// in agenda view of month view in calendar.
  /// * Knowledge base: [How to handle the appointment display mode](https://www.syncfusion.com/kb/12338/how-to-handle-the-appointment-display-mode-in-the-flutter-calendar)
  ///
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final MonthAppointmentDisplayMode appointmentDisplayMode;

  /// Makes [SfCalendar] agenda view visible on month view.
  ///
  /// The month view of [SfCalendar] will render agenda view along with month,
  /// to display the selected date's appointments.
  ///
  /// The [agendaHeight] property used to customize the height of the agenda
  /// view in month view.
  ///
  /// The [agendaItemHeight] property used to customize the height for each item
  /// in agenda view.
  ///
  /// Defaults to `false`.
  ///
  /// ![calendar month view with agenda](https://help.syncfusion.com/flutter/calendar/images/monthview/appointment-indicator-count.png)
  ///
  /// see also:
  /// * [agendaViewHeight], which is the size for agenda view on month view of
  /// calendar.
  /// * [agendaItemHeight], which is the size for every appointment in the
  /// agenda view of month view in calendar.
  /// * [agendaStyle], which is used to customize the agenda view on month view
  /// of calendar.
  /// * [appointmentDisplayMode], which allows to customize the display mode
  /// of appointment view in month cells of calendar.
  /// * Knowledge base: [How to customize agenda view height based on widget height](https://www.syncfusion.com/kb/11013/how-to-customize-agenda-view-height-based-on-the-flutter-calendar-widget-height)
  /// * Knowledge base: [How to customize agenda item height](https://www.syncfusion.com/kb/11015/how-to-customize-the-agenda-item-height-in-the-flutter-calendar)
  /// * Knowledge base: [How to show appointment in agenda view using programmatic date selection](https://www.syncfusion.com/kb/11525/how-to-show-the-appointment-in-agenda-view-using-the-programmatic-date-selection-in-the)
  /// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
  /// * Knowledge base: [How to clear the appointment in month agenda view using onViewChanged callback](https://www.syncfusion.com/kb/12089/how-to-clear-the-appointments-in-month-agenda-view-using-onviewchange-callback-in-the)
  /// * Knowledge base: [How to show a custom agenda view](https://www.syncfusion.com/kb/11016/how-to-show-a-custom-agenda-view-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: true,
  ///           navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final bool showAgenda;

  /// The height for agenda view to layout within this in [SfCalendar] month
  /// view.
  ///
  /// Defaults to `-1`.
  ///
  /// ![month agenda view height as 400](https://help.syncfusion.com/flutter/calendar/images/monthview/agendaview-height.png)
  ///
  /// See also:
  /// * [showAgenda], which allows to display agenda view as a part of
  /// month view in calendar.
  /// * [agendaItemHeight], which is the size for every appointment in the
  /// agenda view of month view in calendar.
  /// * [agendaStyle], which is used to customize the agenda view on month view
  /// of calendar.
  /// * [appointmentDisplayMode], which allows to customize the display mode
  /// of appointment view in month cells of calendar.
  /// * Knowledge base: [How to customize agenda view height based on widget height](https://www.syncfusion.com/kb/11013/how-to-customize-agenda-view-height-based-on-the-flutter-calendar-widget-height)
  /// * Knowledge base: [How to customize agenda item height](https://www.syncfusion.com/kb/11015/how-to-customize-the-agenda-item-height-in-the-flutter-calendar)
  /// * Knowledge base: [How to show appointment in agenda view using programmatic date selection](https://www.syncfusion.com/kb/11525/how-to-show-the-appointment-in-agenda-view-using-the-programmatic-date-selection-in-the)
  /// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
  /// * Knowledge base: [How to clear the appointment in month agenda view using onViewChanged callback](https://www.syncfusion.com/kb/12089/how-to-clear-the-appointments-in-month-agenda-view-using-onviewchange-callback-in-the)
  /// * Knowledge base: [How to show a custom agenda view](https://www.syncfusion.com/kb/11016/how-to-show-a-custom-agenda-view-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: true,
  ///           agendaViewHeight: 120,
  ///           navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double agendaViewHeight;

  /// The direction tht [SfCalendar] month view is navigating in.
  ///
  /// If it this property set as [MonthNavigationDirection.vertical] the
  /// [SfCalendar] month view will navigate to the previous/next views in the
  /// vertical direction instead of the horizontal direction.
  ///
  /// Defaults to `MonthNavigationDirection.horizontal`.
  ///
  /// See also:
  /// * [MonthNavigationDirection], to know more about the available navigation
  /// direction in month view of calendar.
  /// * [SfCalendar.viewNavigationMode], which allows to customize the view
  /// navigation mode for calendar.
  /// * [SfCalendar.showNavigationArrow], which allows to navigation to previous
  /// and next view of calendar programmatically.
  /// * Knowledge base: [How to restrict the view navigation](https://www.syncfusion.com/kb/12554/how-to-restrict-the-view-navigation-in-the-flutter-calendar)
  /// * Knowledge base: [How to navigate to the previous or next view using navigation arrows](https://www.syncfusion.com/kb/12247/how-to-navigate-to-the-previous-or-next-views-using-navigation-arrows-in-the-flutter)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final MonthNavigationDirection navigationDirection;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final MonthViewSettings otherSetting;
    if (other is MonthViewSettings) {
      otherSetting = other;
    }
    return otherSetting.dayFormat == dayFormat &&
        otherSetting.monthCellStyle == monthCellStyle &&
        otherSetting.agendaStyle == agendaStyle &&
        otherSetting.numberOfWeeksInView == numberOfWeeksInView &&
        otherSetting.appointmentDisplayCount == appointmentDisplayCount &&
        otherSetting.appointmentDisplayMode == appointmentDisplayMode &&
        otherSetting.agendaItemHeight == agendaItemHeight &&
        otherSetting.showAgenda == showAgenda &&
        otherSetting.agendaViewHeight == agendaViewHeight &&
        otherSetting.showTrailingAndLeadingDates ==
            showTrailingAndLeadingDates &&
        otherSetting.navigationDirection == navigationDirection;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(monthCellStyle.toDiagnosticsNode(name: 'monthCellStyle'));
    properties.add(agendaStyle.toDiagnosticsNode(name: 'agendaStyle'));
    properties.add(StringProperty('dayFormat', dayFormat));
    properties.add(IntProperty('numberOfWeeksInView', numberOfWeeksInView));
    properties
        .add(IntProperty('appointmentDisplayCount', appointmentDisplayCount));
    properties.add(EnumProperty<MonthAppointmentDisplayMode>(
        'appointmentDisplayMode', appointmentDisplayMode));
    properties.add(EnumProperty<MonthNavigationDirection>(
        'navigationDirection', navigationDirection));
    properties.add(DoubleProperty('agendaItemHeight', agendaItemHeight));
    properties.add(DoubleProperty('agendaViewHeight', agendaViewHeight));
    properties.add(DiagnosticsProperty<bool>('showAgenda', showAgenda));
    properties.add(DiagnosticsProperty<bool>(
        'showTrailingAndLeadingDates', showTrailingAndLeadingDates));
  }

  @override
  int get hashCode {
    return Object.hash(
      dayFormat,
      monthCellStyle,
      agendaStyle,
      numberOfWeeksInView,
      appointmentDisplayCount,
      appointmentDisplayMode,
      showAgenda,
      agendaViewHeight,
      agendaItemHeight,
      showTrailingAndLeadingDates,
      navigationDirection,
    );
  }
}

/// Sets the style to customize [SfCalendar] month agenda view.
///
/// Allows to customize the [backgroundColor], [dayTextStyle], [dateTextStyle]
/// and [appointmentTextStyle] in month agenda view of calendar.
///
/// See also:
/// * [MonthCellStyle], which used to customize the month cell of month view
/// in calendar.
/// * [MonthViewSettings.showAgenda], which allows to display agenda view as a
/// part of month view in calendar.
/// * [MonthViewSettings.agendaViewHeight], which is the size for agenda view on
///  month view of calendar.
/// * [MonthViewSettings.appointmentDisplayMode], which is used to customize the
///  appointment display mode in month cells of calendar.
/// * Knowledge base: [How to customize agenda view height based on widget height](https://www.syncfusion.com/kb/11013/how-to-customize-agenda-view-height-based-on-the-flutter-calendar-widget-height)
/// * Knowledge base: [How to customize agenda item height](https://www.syncfusion.com/kb/11015/how-to-customize-the-agenda-item-height-in-the-flutter-calendar)
/// * Knowledge base: [How to show appointment in agenda view using programmatic date selection](https://www.syncfusion.com/kb/11525/how-to-show-the-appointment-in-agenda-view-using-the-programmatic-date-selection-in-the)
/// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
/// * Knowledge base: [How to clear the appointment in month agenda view using onViewChanged callback](https://www.syncfusion.com/kb/12089/how-to-clear-the-appointments-in-month-agenda-view-using-onviewchange-callback-in-the)
/// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
///
/// ```dart
/// Widget build(BuildContext context) {
/// return Container(
///    child: SfCalendar(
///      view: CalendarView.month,
///      monthViewSettings: MonthViewSettings(
///          dayFormat: 'EEE',
///          numberOfWeeksInView: 4,
///          appointmentDisplayCount: 2,
///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
///          showAgenda: true,
///          navigationDirection: MonthNavigationDirection.horizontal,
///          agendaStyle: AgendaStyle(
///              backgroundColor: Colors.transparent,
///             appointmentTextStyle: TextStyle(
///                  color: Colors.white,
///                  fontSize: 13,
///                  fontStyle: FontStyle.italic
///              ),
///              dayTextStyle: TextStyle(color: Colors.red,
///                  fontSize: 13,
///                  fontStyle: FontStyle.italic),
///              dateTextStyle: TextStyle(color: Colors.red,
///                  fontSize: 25,
///                  fontWeight: FontWeight.bold,
///                  fontStyle: FontStyle.normal)
///         )),
///      ),
///    );
/// }
/// ```
@immutable
class AgendaStyle with Diagnosticable {
  /// Creates a agenda style for month view in calendar.
  ///
  /// The properties allows to customize the agenda view in month view  of
  /// [SfCalendar].
  const AgendaStyle(
      {this.appointmentTextStyle,
      this.dayTextStyle,
      this.dateTextStyle,
      this.backgroundColor,
      this.placeholderTextStyle =
          const TextStyle(color: Colors.grey, fontSize: 15)});

  /// The text style for the text in the [Appointment] view in [SfCalendar]
  /// month agenda view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [SfCalendar.appointmentBuilder], which used to set custom widget for
  /// appointment view in calendar
  /// * [dayTextStyle], which used to customize the day text in the agenda
  /// view of calendar.
  /// * [dateTextStyle], which used to customize the date text in the agenda
  /// view of calendar.
  /// * [backgroundColor], which fills the background of the agenda view in
  /// calendar.
  /// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
  ///
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: true,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  /// ```
  final TextStyle? appointmentTextStyle;

  /// The text style for the text in the placeholder (no event text and
  /// no selected date text) of the [SfCalendar] month agenda view.
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
  ///        view: CalendarView.month,
  ///        monthViewSettings: const MonthViewSettings(showAgenda: true,
  ///          agendaStyle: AgendaStyle(
  ///             placeholderTextStyle:TextStyle(
  ///                 color: Colors.white,
  ///                 fontSize: 20,
  ///                 backgroundColor:
  ///                 Colors.red),)),
  ///      ),
  ///    );
  ///  }
  ///
  ///
  final TextStyle placeholderTextStyle;

  /// The text style for the text in the day text of [SfCalendar] month agenda
  /// view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [appointmentTextStyle], which used to customize the text on the
  /// agenda view of calendar.
  /// * [dateTextStyle], which used to customize the date text in the
  /// agenda view of calendar.
  /// * [backgroundColor], which fills the background of the agenda view in
  /// calendar.
  /// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
  /// * Knowledge base: [How to show a custom agenda view](https://www.syncfusion.com/kb/11016/how-to-show-a-custom-agenda-view-in-the-flutter-calendar)
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: true,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  /// ```
  final TextStyle? dayTextStyle;

  /// The text style for the text in the date view of [SfCalendar] month agenda
  /// view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [appointmentTextStyle], which used to customize the text on the
  /// agenda view of calendar.
  /// * [dayTextStyle], which used to customize the day text in the
  /// agenda view of calendar.
  /// * [backgroundColor], which fills the background of the agenda view in
  /// calendar.
  /// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
  /// * Knowledge base: [How to show a custom agenda view](https://www.syncfusion.com/kb/11016/how-to-show-a-custom-agenda-view-in-the-flutter-calendar)
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: true,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  /// ```
  final TextStyle? dateTextStyle;

  /// The background color to fill the background of the [SfCalendar] month
  /// agenda view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [appointmentTextStyle], which used to customize the text on the
  /// agenda view of calendar.
  /// * [dateTextStyle], which used to customize the date text in the
  /// agenda view of calendar.
  /// * [dayTextStyle], which used to customize the day text in the
  /// agenda view of calendar.
  /// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
  /// * Knowledge base: [How to show a custom agenda view](https://www.syncfusion.com/kb/11016/how-to-show-a-custom-agenda-view-in-the-flutter-calendar)
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: true,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  ///```
  final Color? backgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final AgendaStyle otherStyle;
    if (other is AgendaStyle) {
      otherStyle = other;
    }
    return otherStyle.appointmentTextStyle == appointmentTextStyle &&
        otherStyle.dayTextStyle == dayTextStyle &&
        otherStyle.dateTextStyle == dateTextStyle &&
        otherStyle.backgroundColor == backgroundColor &&
        otherStyle.placeholderTextStyle == placeholderTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>(
        'appointmentTextStyle', appointmentTextStyle));
    properties
        .add(DiagnosticsProperty<TextStyle>('dateTextStyle', dateTextStyle));
    properties
        .add(DiagnosticsProperty<TextStyle>('dayTextStyle', dayTextStyle));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<TextStyle>(
        'placeholderTextStyle', placeholderTextStyle));
  }

  @override
  int get hashCode {
    return Object.hash(
      appointmentTextStyle,
      dayTextStyle,
      dateTextStyle,
      backgroundColor,
      placeholderTextStyle,
    );
  }
}

/// Sets the style to customize [SfCalendar] month cells.
///
/// Allows to customize the [textStyle], [trailingDatesTextStyle],
/// [leadingDatesTextStyle], [backgroundColor], [todayBackgroundColor],
/// [leadingDatesBackgroundColor] and [trailingDatesBackgroundColor] in month
/// cells of month view in calendar.
///
/// See more:
/// * [AgendaStyle], which used to customize the agenda view on month view
/// of calendar.
/// * [MonthViewSettings.appointmentDisplayMode], which is used to customize the
/// appointment display mode in month cells of calendar.
/// * [SfCalendar.monthCellBuilder], which used to set the custom widget for
/// month cell in calendar.
/// * [SfCalendar.blackoutDates], which allows to restrict the interaction for
/// a particular date in month views of calendar.
/// * [SfCalendar.blackoutDatesTextStyle], which used to customize the
/// blackout dates text style in the month view of calendar.
/// * [SfCalendarTheme], to handle theming with calendar for giving consistent
/// look.
/// * Knowledge base: [How to customize the blackout dates](https://www.syncfusion.com/kb/11987/how-to-customize-the-blackout-dates-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
/// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
/// * Knowledge base: [How to customize the month cell based on the appointment using builder](https://www.syncfusion.com/kb/12210/how-to-customize-the-month-cell-based-on-the-appointment-using-builder-in-the-flutter)
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.month,
///        dataSource: _getCalendarDataSource(),
///        monthViewSettings: MonthViewSettings(
///            dayFormat: 'EEE',
///            numberOfWeeksInView: 4,
///            appointmentDisplayCount: 2,
///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
///            showAgenda: false,
///            navigationDirection: MonthNavigationDirection.horizontal,
///            monthCellStyle
///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
///            normal, fontSize: 15, color: Colors.black),
///                trailingDatesTextStyle: TextStyle(
///                    fontStyle: FontStyle.normal,
///                    fontSize: 15,
///                    color: Colors.black),
///                leadingDatesTextStyle: TextStyle(
///                    fontStyle: FontStyle.normal,
///                    fontSize: 15,
///                    color: Colors.black),
///                backgroundColor: Colors.red,
///                todayBackgroundColor: Colors.blue,
///                leadingDatesBackgroundColor: Colors.grey,
///                trailingDatesBackgroundColor: Colors.grey)),
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
///  DataSource _getCalendarDataSource() {
///    List<Appointment> appointments = <Appointment>[];
///    appointments.add(Appointment(
///      startTime: DateTime.now(),
///      endTime: DateTime.now().add(Duration(hours: 2)),
///      isAllDay: true,
///      subject: 'Meeting',
///      color: Colors.blue,
///      startTimeZone: '',
///      endTimeZone: '',
///    ));
///
///    return DataSource(appointments);
///  }
///
@immutable
class MonthCellStyle with Diagnosticable {
  /// Creates a month cell style for month view in calendar.
  ///
  /// The properties allows to customize the month cell in month view  of
  /// [SfCalendar].
  const MonthCellStyle({
    this.backgroundColor,
    this.todayBackgroundColor,
    this.trailingDatesBackgroundColor,
    this.leadingDatesBackgroundColor,
    this.textStyle,
    @Deprecated('Moved the same [todayTextStyle] to SfCalendar class, '
        'use [todayTextStyle] property from SfCalendar class')
    // ignore: deprecated_member_use_from_same_package, deprecated_member_use
    this.todayTextStyle,
    this.trailingDatesTextStyle,
    this.leadingDatesTextStyle,
  });

  /// The text style for the text in the [SfCalendar] month cells.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [backgroundColor], which fills the background of the month cell in
  /// calendar.
  /// * [leadingDatesTextStyle], which used to customize the text style for
  /// the leading dates text in month cell of month view.
  /// * [trailingDatesTextStyle], which used to customize the text style for
  /// the trailing dates text in month cell of month view.
  /// * [SfCalendar.todayTextStyle], which used to customize the text style
  /// for the today text cell in the month view of calendar.
  /// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell based on the appointment using builder](https://www.syncfusion.com/kb/12210/how-to-customize-the-month-cell-based-on-the-appointment-using-builder-in-the-flutter)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal,
  ///           monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///           normal, fontSize: 15, color: Colors.black),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle? textStyle;

  /// The text style for the text in the today cell of [SfCalendar] month view.
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
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal,
  ///           monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///           normal, fontSize: 15, color: Colors.black),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  @Deprecated('Moved the same [todayTextStyle] to SfCalendar class, use '
      '[todayTextStyle] property from SfCalendar class')
  final TextStyle? todayTextStyle;

  /// The text style for the text in the trailing dates cell of [SfCalendar]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [textStyle], which used to customize the text style for the text in
  /// month cell of calendar.
  /// * [leadingDatesTextStyle], which used to customize the text style for
  /// the leading dates text in month cell of month view.
  /// * [SfCalendar.todayTextStyle], which used to customize the text style
  /// for the today text cell in the month view of calendar.
  /// * [trailingDatesBackgroundColor], which fills the background of the
  /// trailing dates cells of month view in calendar.
  /// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell based on the appointment using builder](https://www.syncfusion.com/kb/12210/how-to-customize-the-month-cell-based-on-the-appointment-using-builder-in-the-flutter)
  /// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal,
  ///           monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///           normal, fontSize: 15, color: Colors.black),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle? trailingDatesTextStyle;

  /// The text style for the text in the leading dates cell of [SfCalendar]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [textStyle], which used to customize the text style for the text in
  /// month cell of calendar.
  /// * [trailingDatesTextStyle], which used to customize the text style for
  /// the trailing dates text in month cell of month view.
  /// * [SfCalendar.todayTextStyle], which used to customize the text style
  /// for the today text cell in the month view of calendar.
  /// * [leadingDatesBackgroundColor], which fills the background of the
  /// leading dates cells of month view in calendar.
  /// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell based on the appointment using builder](https://www.syncfusion.com/kb/12210/how-to-customize-the-month-cell-based-on-the-appointment-using-builder-in-the-flutter)
  /// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal,
  ///           monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///           normal, fontSize: 15, color: Colors.black),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle? leadingDatesTextStyle;

  /// The background color to fill the background of the [SfCalendar]
  /// month cell.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [todayBackgroundColor], which used to fill the  background of the today
  /// date month cell in the calendar.
  /// * [trailingDatesBackgroundColor], which fills the background of the
  /// trailing dates cells of month view in calendar.
  /// * [leadingDatesBackgroundColor], which fills the background of the
  /// leading dates cells of month view in calendar.
  /// * [textStyle], which used to customize the text style of texts in month
  /// cell in month view of calendar.
  /// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell based on the appointment using builder](https://www.syncfusion.com/kb/12210/how-to-customize-the-month-cell-based-on-the-appointment-using-builder-in-the-flutter)
  /// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal,
  ///           monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///           normal, fontSize: 15, color: Colors.black),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color? backgroundColor;

  /// The background color to fill the background of the [SfCalendar] today
  /// month cell.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [backgroundColor], which used to fill the  background of the month cells
  /// in the calendar.
  /// * [trailingDatesBackgroundColor], which fills the background of the
  /// trailing dates cells of month view in calendar.
  /// * [leadingDatesBackgroundColor], which fills the background of the
  /// leading dates cells of month view in calendar.
  /// * [SfCalendar.todayTextStyle], which used to customize the text style of
  /// texts in today date month cell of calendar.
  /// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell based on the appointment using builder](https://www.syncfusion.com/kb/12210/how-to-customize-the-month-cell-based-on-the-appointment-using-builder-in-the-flutter)
  /// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal,
  ///           monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///           normal, fontSize: 15, color: Colors.black),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color? todayBackgroundColor;

  /// The background color to fill the background of the [SfCalendar] trailing
  /// dates month cell.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [backgroundColor], which used to fill the  background of the month cells
  /// in the calendar.
  /// * [todayBackgroundColor], which fills the background of the today date
  /// cell of month view in calendar.
  /// * [leadingDatesBackgroundColor], which fills the background of the
  /// leading dates cells of month view in calendar.
  /// * [trailingDatesTextStyle], which used to customize the text style of
  /// text in the trailing dates month cell of calendar.
  /// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell based on the appointment using builder](https://www.syncfusion.com/kb/12210/how-to-customize-the-month-cell-based-on-the-appointment-using-builder-in-the-flutter)
  /// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal,
  ///           monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///           normal, fontSize: 15, color: Colors.black),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color? trailingDatesBackgroundColor;

  /// The background color to fill the background of the [SfCalendar] leading
  /// dates month cell.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [backgroundColor], which used to fill the  background of the month cells
  /// in the calendar.
  /// * [todayBackgroundColor], which fills the background of the today date
  /// cell of month view in calendar.
  /// * [trailingDatesBackgroundColor], which fills the background of the
  /// trailing dates cells of month view in calendar.
  /// * [leadingDatesTextStyle], which used to customize the text style of
  /// text in the leading dates month cell of calendar.
  /// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the month cell based on the appointment using builder](https://www.syncfusion.com/kb/12210/how-to-customize-the-month-cell-based-on-the-appointment-using-builder-in-the-flutter)
  /// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///           dayFormat: 'EEE',
  ///           numberOfWeeksInView: 4,
  ///           appointmentDisplayCount: 2,
  ///           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///           showAgenda: false,
  ///           navigationDirection: MonthNavigationDirection.horizontal,
  ///           monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///           normal, fontSize: 15, color: Colors.black),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color? leadingDatesBackgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final MonthCellStyle otherStyle;
    if (other is MonthCellStyle) {
      otherStyle = other;
    }
    return otherStyle.textStyle == textStyle &&
        otherStyle.trailingDatesTextStyle == trailingDatesTextStyle &&
        otherStyle.leadingDatesTextStyle == leadingDatesTextStyle &&
        otherStyle.backgroundColor == backgroundColor &&
        otherStyle.todayBackgroundColor == todayBackgroundColor &&
        otherStyle.trailingDatesBackgroundColor ==
            trailingDatesBackgroundColor &&
        otherStyle.leadingDatesBackgroundColor == leadingDatesBackgroundColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'trailingDatesTextStyle', trailingDatesTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'leadingDatesTextStyle', leadingDatesTextStyle));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('todayBackgroundColor', todayBackgroundColor));
    properties.add(ColorProperty(
        'trailingDatesBackgroundColor', trailingDatesBackgroundColor));
    properties.add(ColorProperty(
        'leadingDatesBackgroundColor', leadingDatesBackgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
      textStyle,
      trailingDatesTextStyle,
      leadingDatesTextStyle,
      backgroundColor,
      todayBackgroundColor,
      trailingDatesBackgroundColor,
      leadingDatesBackgroundColor,
    );
  }
}
