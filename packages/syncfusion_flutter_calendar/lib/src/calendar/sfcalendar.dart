import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:timezone/timezone.dart';

import 'appointment_engine/appointment.dart';
import 'appointment_engine/appointment_helper.dart';
import 'appointment_engine/calendar_datasource.dart';
import 'appointment_engine/recurrence_helper.dart';
import 'appointment_engine/recurrence_properties.dart';
import 'appointment_layout/agenda_view_layout.dart';
import 'common/calendar_controller.dart';
import 'common/calendar_view_helper.dart';
import 'common/date_time_engine.dart';
import 'common/enums.dart';
import 'common/event_args.dart';
import 'resource_view/calendar_resource.dart';
import 'resource_view/resource_view.dart';
import 'settings/drag_and_drop_settings.dart';
import 'settings/header_style.dart';
import 'settings/month_view_settings.dart';
import 'settings/resource_view_settings.dart';
import 'settings/schedule_view_settings.dart';
import 'settings/time_region.dart';
import 'settings/time_slot_view_settings.dart';
import 'settings/view_header_style.dart';
import 'settings/week_number_style.dart';
import 'views/calendar_view.dart';

/// Specifies the unconfirmed ripple animation duration used on custom splash.
/// The duration was unconfirmed because the ripple animation duration changed
/// based on its radius value.
const Duration _kUnconfirmedRippleSplashDuration = Duration(seconds: 1);

/// Specifies the fade animation duration used on custom splash.
const Duration _kSplashFadeDuration = Duration(milliseconds: 500);

typedef _CalendarHeaderCallback = void Function(double width);

/// A material design calendar.
///
/// Used to scheduling and managing events.
///
/// The [SfCalendar] has built-in configurable views that provide basic
/// functionalities for scheduling and representing [Appointment]'s or events
/// efficiently. It supports [minDate] and [maxDate] to restrict the date
/// selection.
///
/// By default it displays [CalendarView.day] view with current date visible.
///
/// To navigate to different views set [CalendarController.view] property in
/// [controller] with a desired [CalendarView].
///
/// Available view types is followed by:
/// * [CalendarView.day]
/// * [CalendarView.week]
/// * [CalendarView.workWeek]
/// * [CalendarView.month]
/// * [CalendarView.timelineDay]
/// * [CalendarView.timelineWeek]
/// * [CalendarView.timelineWorkWeek]
/// * [CalendarView.timelineMonth]
/// * [CalendarView.schedule]
///
/// ![different views in calendar](https://help.syncfusion.com/flutter/calendar/images/overview/multiple_calenda_views.png)
///
/// To restrict the date navigation and selection interaction use [minDate],
/// [maxDate], the dates beyond this will be restricted.
///
/// Set the [Appointment]'s or custom events collection to [dataSource] property
/// by using the [CalendarDataSource].
///
/// When the visible view changes the widget calls the [onViewChanged] callback
/// with the current view visible dates.
///
/// When an any of [CalendarElement] tapped the widget calls the [onTap]
/// callback with selected date, appointments and selected calendar element
/// details.
///
/// _Note:_ The calendar widget allows to customize its appearance using
/// [SfCalendarThemeData] available from [SfCalendarTheme] widget or the
/// [SfTheme.calendarTheme] widget.
/// It can also be customized using the properties available in
/// [CalendarHeaderStyle][ViewHeaderStyle][MonthViewSettings]
/// [TimeSlotViewSettings][MonthCellStyle], [AgendaStyle].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=3OROjbAQS8Y}
///
/// See also:
/// * [SfCalendarThemeData], to set consistent look for calendar elements.
/// * [CalendarHeaderStyle], to customize the header view of the calendar.
/// * [ViewHeaderStyle], to customize the view header view of the calendar.
/// * [MonthViewSettings], to customize the month view of the calendar.
/// * [TimeSlotViewSettings], to customize the timeslot views of the calendar.
/// * [ResourceViewSettings], to customize the resource view of the calendar.
/// * [ScheduleViewSettings], to customize the schedule view of the calendar.
/// * [MonthCellStyle], to customize the month cells of the calendar.
/// * [AgendaStyle], to customize the month agenda view of the calendar.
/// * [showDatePickerButton], to show date picker for quickly navigating to a
/// different date.
/// * [allowedViews], to show list of calendar views on header view for quick
/// navigation.
/// * [SfDateRangePicker], material widget, which used to select date, dates,
/// range, and ranges of dates.
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
///  }
/// }
///
///  DataSource _getCalendarDataSource() {
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
///          endTimeZone: '',
///        ));
///
///    return DataSource(appointments);
///  }
///  ```
@immutable
class SfCalendar extends StatefulWidget {
  /// Creates a [SfCalendar] widget, which used to scheduling and managing
  /// events.
  ///
  /// By default it displays [CalendarView.day] view with current date visible.
  ///
  /// To navigate to different views set [view] property with a desired
  /// [CalendarView].
  ///
  /// Use [DataSource] property to set the appointments to the scheduler.
  SfCalendar({
    Key? key,
    this.view = CalendarView.day,
    this.firstDayOfWeek = 7,
    this.headerHeight = 40,
    this.viewHeaderHeight = -1,
    this.todayHighlightColor,
    this.todayTextStyle,
    this.cellBorderColor,
    this.backgroundColor,
    this.dataSource,
    this.timeZone,
    this.selectionDecoration,
    this.onViewChanged,
    this.onTap,
    this.onLongPress,
    this.onSelectionChanged,
    this.controller,
    this.appointmentTimeTextFormat,
    this.blackoutDates,
    this.scheduleViewMonthHeaderBuilder,
    this.monthCellBuilder,
    this.appointmentBuilder,
    this.timeRegionBuilder,
    this.headerDateFormat,
    this.headerStyle = const CalendarHeaderStyle(),
    this.viewHeaderStyle = const ViewHeaderStyle(),
    this.timeSlotViewSettings = const TimeSlotViewSettings(),
    this.resourceViewSettings = const ResourceViewSettings(),
    this.monthViewSettings = const MonthViewSettings(),
    DateTime? initialDisplayDate,
    this.initialSelectedDate,
    this.scheduleViewSettings = const ScheduleViewSettings(),
    DateTime? minDate,
    DateTime? maxDate,
    this.appointmentTextStyle = const TextStyle(
        color: Colors.white, fontSize: -1, fontWeight: FontWeight.w500),
    this.showNavigationArrow = false,
    this.showDatePickerButton = false,
    this.showTodayButton = false,
    this.allowViewNavigation = false,
    this.showCurrentTimeIndicator = true,
    this.cellEndPadding = -1,
    this.viewNavigationMode = ViewNavigationMode.snap,
    this.allowedViews,
    this.specialRegions,
    this.loadMoreWidgetBuilder,
    this.blackoutDatesTextStyle,
    this.showWeekNumber = false,
    this.weekNumberStyle = const WeekNumberStyle(),
    this.resourceViewHeaderBuilder,
    this.allowAppointmentResize = false,
    this.onAppointmentResizeStart,
    this.onAppointmentResizeUpdate,
    this.onAppointmentResizeEnd,
    this.allowDragAndDrop = false,
    this.dragAndDropSettings = const DragAndDropSettings(),
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
  })  : assert(firstDayOfWeek >= 1 && firstDayOfWeek <= 7),
        assert(headerHeight >= 0),
        assert(viewHeaderHeight >= -1),
        assert(minDate == null || maxDate == null || minDate.isBefore(maxDate)),
        assert(minDate == null || maxDate == null || maxDate.isAfter(minDate)),
        assert(cellEndPadding >= -1),
        initialDisplayDate = initialDisplayDate ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 08, 45),
        minDate = minDate ?? DateTime(01),
        maxDate = maxDate ?? DateTime(9999, 12, 31),
        super(key: key);

  /// A builder that sets the widget to display on the calendar widget when
  /// the appointments are being loaded.
  ///
  /// This callback will be called when a view or resource collection changed,
  /// and when calendar reaches start or end scroll position in schedule view.
  /// With this builder, you can set widget and then initiate the process of
  /// loading more appointments by calling ‘loadMoreAppointments’ callback
  /// which is passed as a parameter to this builder. The ‘loadMoreAppointments’
  /// will in turn call the [CalendarDataSource.handleLoadMore' method, where
  /// you have to load the appointments.
  ///
  /// The widget returned from this builder will be rendered based on calendar
  /// widget width and height.
  ///
  /// _Note:_ This callback will be called after the onViewChanged callback.
  /// The widget returned from this builder will be removed from [SfCalendar]
  /// when [CalendarDataSource.notifyListeners] is called.
  ///
  /// See also:
  /// * [CalendarDataSource.handleLoadMore], to handle the appointment loading,
  /// when the indicator is displaying.
  /// * [CalendarDataSource.notifyListeners], to add, remove or reset the
  /// appointment collection.
  /// * Knowledge base: [How to load appointments on demand](https://www.syncfusion.com/kb/12658/how-to-load-appointments-on-demand-in-flutter-calendar)
  ///
  /// ``` dart
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfCalendar(
  ///            controller: _controller,
  ///            dataSource: _dataSource(),
  ///            loadMoreWidgetBuilder: (BuildContext context,
  ///                   LoadMoreCallback loadMoreAppointments) {
  ///              return FutureBuilder<void>(
  ///                initialData: 'loading',
  ///                future: loadMoreAppointments(),
  ///                builder: (context, snapShot) {
  ///                    return Container(
  ///                        height: _controller.view == CalendarView.schedule
  ///                           ? 50
  ///                           : double.infinity,
  ///                        width: double.infinity,
  ///                        color: Colors.white38,
  ///                        alignment: Alignment.center,
  ///                        child: CircularProgressIndicator(
  ///                            valueColor:
  ///                               AlwaysStoppedAnimation(Colors.deepPurple)));
  ///                },
  ///              );
  ///            },
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final LoadMoreWidgetBuilder? loadMoreWidgetBuilder;

  /// The list of [CalendarView]s that should be displayed in the header for
  /// quick navigation.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [SfCalendar.onViewChanged], the callback to notify that the view
  /// changed, this also contains the visible dates collection.
  /// * [view], to specify the view to be rendered on initially in calendar.
  /// * [CalendarController.view], to change the calendar view dynamically.
  /// * Knowledge base: [How to do date navigates easily](https://www.syncfusion.com/kb/12019/how-to-do-date-navigations-easily-with-flutter-calendar)
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        allowedViews: [ CalendarView.day,
  ///                        CalendarView.week,
  ///                        CalendarView.month,
  ///                        CalendarView.schedule
  ///                     ],
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final List<CalendarView>? allowedViews;

  /// Determines whether view switching is allowed among [CalendarView]s on
  /// interaction.
  ///
  /// Defaults to 'false'.
  ///
  /// See also:
  /// * [showDatePickerButton], to show date picker for quickly navigating to a
  /// different date.
  /// * [allowedViews] to show list of calendar views on header view for quick
  /// navigation.
  /// * Knowledge base: [How to switch between views](https://www.syncfusion.com/kb/10944/how-to-switch-between-views-of-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///      view: CalendarView.month,
  ///      allowViewNavigation: true,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool allowViewNavigation;

  /// Displays the date picker when the [SfCalendar] header date is tapped.
  ///
  /// The date picker will be used for quick date navigation in [SfCalendar].
  ///
  /// Defaults to `false`.
  ///
  /// see also:
  /// * [allowedViews] to show list of calendar views on header view for quick
  /// navigation.
  /// * [SfDateRangePicker], material widget which displays on the header of
  /// calendar, when the header date tapped.
  /// * [How to add indicator in month cells of date range picker](https://www.syncfusion.com/kb/12119/how-to-add-the-indicator-in-the-month-cells-of-the-date-range-picker-sfdaterangepicker-when)
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///      view: CalendarView.day,
  ///      showDatePickerButton: true,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool showDatePickerButton;

  /// Displays the today button on the header view of [SfCalendar].
  ///
  /// If the property set as true then the header view will show the today
  /// button which is used to navigate the today view.
  ///
  /// Defaults to `false`.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///      view: CalendarView.day,
  ///      showTodayButton: true,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool showTodayButton;

  /// Displays an indicator that shows the current time in the time slot views
  /// of [SfCalendar]. By default, the indicator color matches the
  /// [todayHighlightColor].
  ///
  /// Defaults to `true`.
  ///
  /// see also:
  /// * [todayHighlightColor], to customize the color of the indicator.
  ///
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        showCurrentTimeIndicator: true),
  ///    );
  ///  }
  ///
  /// ```
  final bool showCurrentTimeIndicator;

  /// Defines the view for the [SfCalendar].
  ///
  /// Defaults to `CalendarView.day`.
  ///
  /// See also:
  /// * [CalendarView], to know about available calendar views.
  /// * [SfCalendar.onViewChanged], the callback to notify that the view
  /// changed, this also contains the visible dates collection.
  /// * [CalendarController.view], to change the calendar view dynamically.
  /// * [showDatePickerButton], to show date picker for quickly navigating to a
  /// different date.
  /// * [allowedViews] to show list of calendar views on header view for quick
  /// navigation.
  /// * Knowledge base: [How to switch between views](https://www.syncfusion.com/kb/10944/how-to-switch-between-views-of-the-flutter-calendar)
  ///
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final CalendarView view;

  /// The minimum date as much as the [SfCalendar] will navigate.
  ///
  /// The [SfCalendar] widget will navigate as minimum as to the given date,
  /// and the dates before that date will be disabled for interaction and
  /// navigation to those dates were restricted.
  ///
  /// Defaults to `1st  January of 0001`.
  ///
  /// _Note:_ If the [initialDisplayDate] property set with the date prior to
  /// this date, the [SfCalendar] will take this date as a display date and
  /// render dates based on the date set to this property.
  ///
  /// See also:
  /// * [initialDisplayDate], the date which displayed initially on calendar.
  /// * [maxDate], which is the maximum available date for the calendar.
  /// * [CalendarController.displayDate], which move to the desired date
  /// dynamically.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        minDate: new DateTime(2019, 12, 14, 9, 0, 0),
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final DateTime minDate;

  /// The maximum date as much as the [SfCalendar]  will navigate.
  ///
  /// The [SfCalendar] widget will navigate as maximum as to the given date,
  /// and the dates after that date will be disabled for interaction and
  /// navigation to those dates were restricted.
  ///
  /// Defaults to `31st December of 9999`.
  ///
  /// _Note:_ If the [initialDisplayDate] property set with the date after to
  /// this date, the [SfCalendar] will take this date as a display date and
  /// render dates based on the date set to this property.
  ///
  /// See also:
  /// * [initialDisplayDate], the date which displayed initially on calendar.
  /// * [minDate], which is the least available date for the calendar.
  /// * [CalendarController.displayDate], which move to the desired date
  /// dynamically.
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        maxDate: new DateTime(2020, 01, 15, 9, 0, 0),
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final DateTime maxDate;

  /// A builder that builds a widget, replaces the month cell in the
  /// calendar month view.
  ///
  /// See also:
  /// * [MonthViewSettings.appointmentDisplayMode], to customize the appointment
  /// display mode in the month cell.
  /// * [appointmentBuilder], to build custom widget for appointments in
  /// calendar.
  /// * Knowledge base: [How to customize month cells](https://www.syncfusion.com/kb/12016/how-to-customize-the-month-cells-of-the-flutter-calendar)
  /// * Knowledge base: [How to customize month cell with appointment count](https://www.syncfusion.com/kb/12306/how-to-customize-the-month-cell-with-appointment-count-in-the-flutter-calendar)
  ///
  /// ```dart
  ///@override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///        body: Container(
  ///            child: SfCalendar(
  ///      view: CalendarView.month,
  ///      monthCellBuilder:
  ///           (BuildContext buildContext, MonthCellDetails details) {
  ///        return Container(
  ///          color: Colors.red,
  ///          child: Text(
  ///            details.date.day.toString(),
  ///          ),
  ///        );
  ///      },
  ///    )));
  ///  }
  ///  ```
  final MonthCellBuilder? monthCellBuilder;

  /// A builder that builds a widget, replaces the appointment view in a day,
  /// week, workweek, month, schedule and timeline day, week, workweek,
  /// month views.
  ///
  /// _Note:_ In month view, this builder callback will be used to build
  /// appointment views for appointments displayed in both month cell and
  /// agenda views when the MonthViewSettings.appointmentDisplayMode is
  /// set to appointment.
  ///
  /// See also:
  /// * [CalendarDataSource], to set and handle the appointments in the calendar
  /// * [Appointment], to know more about the appointment and it's properties in
  /// calendar.
  /// * [appointmentTextStyle], to customize the appointment text, when the
  /// builder not added.
  /// * Knowledge base: [How to customize appointment using builder](https://www.syncfusion.com/kb/12191/how-to-customize-the-appointments-using-custom-builder-in-the-flutter-calendar)
  ///
  /// ```dart
  /// CalendarController _controller = CalendarController();
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfCalendar(
  ///          view: CalendarView.day,
  ///          controller: _controller,
  ///          appointmentBuilder: (BuildContext context,
  ///              CalendarAppointmentDetails calendarAppointmentDetails) {
  ///            if (calendarAppointmentDetails.isMoreAppointmentRegion) {
  ///              return Container(
  ///                width: calendarAppointmentDetails.bounds.width,
  ///                height: calendarAppointmentDetails.bounds.height,
  ///                child: Text('+More'),
  ///              );
  ///            } else if (_controller.view == CalendarView.month) {
  ///              final Appointment appointment =
  ///                  calendarAppointmentDetails.appointments.first;
  ///              return Container(
  ///                  decoration: BoxDecoration(
  ///                      color: appointment.color,
  ///                      shape: BoxShape.rectangle,
  ///                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
  ///                      gradient: LinearGradient(
  ///                          colors: [Colors.red, Colors.cyan],
  ///                          begin: Alignment.centerRight,
  ///                          end: Alignment.centerLeft)),
  ///                  alignment: Alignment.center,
  ///                  child: appointment.isAllDay
  ///                      ? Text('${appointment.subject}',
  ///                          textAlign: TextAlign.left,
  ///                          style: TextStyle(
  ///                          color: Colors.white, fontSize: 10))
  ///                      : Column(
  ///                          mainAxisAlignment: MainAxisAlignment.center,
  ///                          children: [
  ///                            Text('${appointment.subject}',
  ///                                textAlign: TextAlign.left,
  ///                                style: TextStyle(
  ///                                    color: Colors.white, fontSize: 10)),
  ///                            Text(
  ///                                '${DateFormat('hh:mm a').
  ///                                   format(appointment.startTime)} - ' +
  ///                                    '${DateFormat('hh:mm a').
  ///                                       format(appointment.endTime)}',
  ///                                textAlign: TextAlign.left,
  ///                                style: TextStyle(
  ///                                    color: Colors.white, fontSize: 10))
  ///                          ],
  ///                        ));
  ///            } else {
  ///              final Appointment appointment =
  ///                  calendarAppointmentDetails.appointments.first;
  ///              return Container(
  ///                width: calendarAppointmentDetails.bounds.width,
  ///                height: calendarAppointmentDetails.bounds.height,
  ///                child: Text(appointment.subject),
  ///              );
  ///            }
  ///          },
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///  ```
  final CalendarAppointmentBuilder? appointmentBuilder;

  /// A builder that builds a widget that replaces the time region view in day,
  /// week, workweek, and timeline day, week, workweek views.
  ///
  /// See also:
  /// * [specialRegions], to set the special time regions in the calendar.
  /// * [TimeRegion], to now the details about the special time regions and it's
  /// properties in calendar.
  /// * Knowledge base: [How to customize special regions with builder](https://www.syncfusion.com/kb/12192/how-to-customize-the-special-time-region-using-custom-builder-in-the-flutter-calendar)
  ///
  ///
  /// ```dart
  ///
  /// List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    DateTime date = DateTime.now();
  ///    date = DateTime(date.year, date.month, date.day, 12, 0, 0);
  ///    regions.add(TimeRegion(
  ///        startTime: date,
  ///        endTime: date.add(Duration(hours: 2)),
  ///        enablePointerInteraction: false,
  ///        color: Colors.grey.withOpacity(0.2),
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///        home: Scaffold(
  ///      body: SfCalendar(
  ///        view: CalendarView.day,
  ///        specialRegions: _getTimeRegions(),
  ///        timeRegionBuilder:
  ///            (BuildContext context, TimeRegionDetails timeRegionDetails) {
  ///          return Container(
  ///            margin: EdgeInsets.all(1),
  ///            alignment: Alignment.center,
  ///            child: Text(
  ///              timeRegionDetails.region.text!,
  ///              style: TextStyle(color: Colors.black),
  ///            ),
  ///            decoration: BoxDecoration(
  ///                shape: BoxShape.rectangle,
  ///                borderRadius: BorderRadius.all(Radius.circular(4.0)),
  ///                gradient: LinearGradient(
  ///                    colors: [timeRegionDetails.region.color!, Colors.cyan],
  ///                    begin: Alignment.centerRight,
  ///                    end: Alignment.centerLeft)),
  ///          );
  ///        },
  ///      ),
  ///    ));
  ///  }
  ///  ```
  final TimeRegionBuilder? timeRegionBuilder;

  /// Date format of the header date text of [SfCalendar]
  ///
  /// The provided format must match any one of our supported skeletons.
  /// If it does not match, the provided string will be used as-is.
  /// The supported sets of skeletons are as follows.
  ///
  ///      ICU Name                   Skeleton
  ///      --------                   --------
  ///      DAY                          d
  ///      ABBR_WEEKDAY                 E
  ///      WEEKDAY                      EEEE
  ///      ABBR_STANDALONE_MONTH        LLL
  ///      STANDALONE_MONTH             LLLL
  ///      NUM_MONTH                    M
  ///      NUM_MONTH_DAY                Md
  ///      NUM_MONTH_WEEKDAY_DAY        MEd
  ///      ABBR_MONTH                   MMM
  ///      ABBR_MONTH_DAY               MMMd
  ///      ABBR_MONTH_WEEKDAY_DAY       MMMEd
  ///      MONTH                        MMMM
  ///      MONTH_DAY                    MMMMd
  ///      MONTH_WEEKDAY_DAY            MMMMEEEEd
  ///      ABBR_QUARTER                 QQQ
  ///      QUARTER                      QQQQ
  ///      YEAR                         y
  ///      YEAR_NUM_MONTH               yM
  ///      YEAR_NUM_MONTH_DAY           yMd
  ///      YEAR_NUM_MONTH_WEEKDAY_DAY   yMEd
  ///      YEAR_ABBR_MONTH              yMMM
  ///      YEAR_ABBR_MONTH_DAY          yMMMd
  ///      YEAR_ABBR_MONTH_WEEKDAY_DAY  yMMMEd
  ///      YEAR_MONTH                   yMMMM
  ///      YEAR_MONTH_DAY               yMMMMd
  ///      YEAR_MONTH_WEEKDAY_DAY       yMMMMEEEEd
  ///      YEAR_ABBR_QUARTER            yQQQ
  ///      YEAR_QUARTER                 yQQQQ
  ///      HOUR24                       H
  ///      HOUR24_MINUTE                Hm
  ///      HOUR24_MINUTE_SECOND         Hms
  ///      HOUR                         j
  ///      HOUR_MINUTE                  jm
  ///      HOUR_MINUTE_SECOND           jms
  ///      HOUR_MINUTE_GENERIC_TZ       jmv
  ///      HOUR_MINUTE_TZ               jmz
  ///      HOUR_GENERIC_TZ              jv
  ///      HOUR_TZ                      jz
  ///      MINUTE                       m
  ///      MINUTE_SECOND                ms
  ///      SECOND                       s
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [onViewChanged], to get the current visible dates collection
  /// * [headerHeight], to customize the size of the header view in calendar.
  /// * [DateFormat], to know about the different available formats.
  /// * Knowledge base: [How to change the month header format](https://www.syncfusion.com/kb/12550/how-to-change-the-month-header-format-in-the-flutter-calendar)
  ///
  ///
  /// ``` dart
  /// @override
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///            headerDateFormat: 'MMM,yyy',
  ///      ),
  ///     ),
  ///    );
  ///  }
  /// ```
  final String? headerDateFormat;

  /// A builder that builds a widget, replace the schedule month header
  /// widget in calendar schedule view.
  ///
  /// See also:
  /// * [scheduleViewSettings], to customize the schedule view of calendar.
  /// * Knowledge base: [Customize the schedule view month header using builder](https://www.syncfusion.com/kb/12064/how-to-customize-the-schedule-view-month-header-using-builder-in-the-flutter-calendar)
  ///
  /// ```dart
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///        body: Container(
  ///            child: SfCalendar(
  ///      view: CalendarView.schedule,
  ///      scheduleViewMonthHeaderBuilder: (BuildContext buildContext,
  ///               ScheduleViewMonthHeaderDetails details) {
  ///        return Container(
  ///          color: Colors.red,
  ///          child: Text(
  ///            details.date.month.toString() + ' ,' +
  ///               details.date.year.toString(),
  ///          ),
  ///        );
  ///      },
  ///    )));
  ///  }
  ///  ```
  final ScheduleViewMonthHeaderBuilder? scheduleViewMonthHeaderBuilder;

  /// The first day of the week in the [SfCalendar].
  ///
  /// Allows to change the first day of week in all possible views in calendar,
  /// every view's week will start from the date set to this property.
  ///
  /// Defaults to `7` which indicates `DateTime.sunday`.
  ///
  /// See also:
  /// * [showWeekNumber], to display the week number of the year.
  /// * Knowledge base: [How to change the first day of week](https://www.syncfusion.com/kb/12222/how-to-change-the-first-day-of-week-in-the-flutter-calendar)
  ///
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        firstDayOfWeek: 3,
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final int firstDayOfWeek;

  /// Defines the time format for appointment view text in [SfCalendar]
  /// month agenda view and schedule view.
  ///
  /// The specified time format applicable when calendar view is
  /// [CalendarView.schedule] or [CalendarView.month].
  ///
  /// The time formats specified in the below link are supported
  /// Ref: https://api.flutter.dev/flutter/intl/DateFormat-class.html
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [DateFormat], to know more about the available formats.
  /// * Knowledge base: [How to format appointment time](https://www.syncfusion.com/kb/11989/how-to-format-the-appointment-time-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        monthViewSettings: MonthViewSettings(
  ///            showAgenda: true,
  ///            navigationDirection: MonthNavigationDirection.horizontal),
  ///        appointmentTimeTextFormat: 'hh:mm a',
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final String? appointmentTimeTextFormat;

  /// The color which fills the border of every calendar cells in [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [SfCalendarTheme], to handle theming with calendar for giving consistent
  /// look.
  /// * [backgroundColor], which fills the background of the calendar.
  /// * Knowledge base: [How to customize the cell border](https://www.syncfusion.com/kb/12118/how-to-customize-the-cell-border-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        cellBorderColor: Colors.grey,
  ///      ),
  ///    );
  ///  }
  ///
  ///```
  final Color? cellBorderColor;

  /// The settings have properties which allow to customize the schedule view of
  /// the [SfCalendar].
  ///
  /// Allows to customize the [ScheduleViewSettings.monthHeaderSettings],
  /// [ScheduleViewSettings.weekHeaderSettings],
  /// [ScheduleViewSettings.dayHeaderSettings],
  /// [ScheduleViewSettings.appointmentTextStyle],
  /// [ScheduleViewSettings.appointmentItemHeight] and
  /// [ScheduleViewSettings.hideEmptyScheduleWeek] in schedule view of calendar.
  ///
  /// See also:
  /// * [scheduleViewMonthHeaderBuilder], to customize the schedule view month
  /// header with a custom widget.
  /// * [ScheduleViewSettings], to know about the available customization
  ///  options for schedule view.
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
  final ScheduleViewSettings scheduleViewSettings;

  /// Sets the style for customizing the [SfCalendar] header view.
  ///
  /// Allows to customize the [CalendarHeaderStyle.textStyle],
  /// [CalendarHeaderStyle.textAlign] and
  /// [CalendarHeaderStyle.backgroundColor] in header view of calendar.
  ///
  /// ![header with different style in calendar](https://help.syncfusion.com/flutter/calendar/images/headers/header-style.png)
  ///
  /// See also:
  /// * [CalendarHeaderStyle], to know about the available customization options
  /// for header view.
  /// * [headerHeight], to customize the size of the header view in calendar.
  /// * [headerDateFormat], to format the date string in the header view of
  /// calendar.
  /// * Knowledge base: [How to style a header](https://www.syncfusion.com/kb/12144/how-to-style-a-header-in-the-flutter-calendar)
  /// * Knowledge base: [How to add custom header and view header](https://www.syncfusion.com/kb/10997/how-to-add-custom-header-and-view-header-in-the-flutter-calendar)
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
  final CalendarHeaderStyle headerStyle;

  /// Sets the style to customize [SfCalendar] view header.
  ///
  /// Allows to customize the [ViewHeaderStyle.backgroundColor],
  /// [ViewHeaderStyle.dayTextStyle] and [ViewHeaderStyle.dateTextStyle] in view
  /// header of calendar.
  ///
  /// ![view header with different style in calendar](https://help.syncfusion.com/flutter/calendar/images/headers/viewheader-style.png)
  ///
  /// See also:
  /// * [ViewHeaderStyle], to know about the available customization options for
  /// view header view in calendar.
  /// * [viewHeaderHeight], to customize the size of the view header view in
  /// calendar.
  /// * Knowledge base: [How to format day and date of view header](https://www.syncfusion.com/kb/12339/how-to-format-the-view-header-day-and-date-in-the-flutter-calendar)
  /// * Knowledge base: [How to add custom header and view header](https://www.syncfusion.com/kb/10997/how-to-add-custom-header-and-view-header-in-the-flutter-calendar)
  /// * Knowledge base: [How to highlight tapped date in view header](https://www.syncfusion.com/kb/12469/how-to-highlight-the-tapped-view-header-in-the-flutter-calendar)
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
  final ViewHeaderStyle viewHeaderStyle;

  /// The height for header view to layout within this in calendar.
  ///
  /// Defaults to `40`.
  ///
  /// ![header height as 100 in calendar](https://help.syncfusion.com/flutter/calendar/images/headers/header-height.png)
  ///
  /// See also:
  /// * [headerStyle] to know about the available customization options
  /// for header view.
  /// * [headerDateFormat], to format the date string in the header view of
  /// calendar.
  /// * Knowledge base: [How to style a header](https://www.syncfusion.com/kb/12144/how-to-style-a-header-in-the-flutter-calendar)
  /// * Knowledge base: [How to add custom header and view header](https://www.syncfusion.com/kb/10997/how-to-add-custom-header-and-view-header-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        headerHeight: 100,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double headerHeight;

  /// Adds padding at the right end of a cell to interact when the calendar
  /// cells have appointments.
  ///
  /// defaults to '-1'.
  ///
  /// _Note:_ This is not applicable for month agenda and schedule view
  /// appointments.
  ///
  /// See also:
  /// * [onTap], to get the tapped elements, date and other details, when an
  /// element tapped in calendar.
  /// * [onLongPress], to get the tapped elements, date and other details when
  /// an element long tapped in calendar.
  /// * [dataSource], to set and handle appointments with calendar.
  /// * Knowledge base: [How to interact with calendar cell when appointments loaded](https://www.syncfusion.com/kb/12218/how-to-interact-with-event-calendar-cell-when-appointments-loaded-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        cellEndPadding: 5,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double cellEndPadding;

  /// The text style for the text in the [Appointment] view in [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// _Note:_ This style doesn't apply for the appointment's in the agenda view
  /// of month view, for agenda view appointments styling can be achieved by
  /// using the [MonthViewSettings.agendaStyle.appointmentTextStyle].
  ///
  /// See also:
  /// * [AgendaStyle], to customize the agenda view of month view in calendar.
  /// * [dataSource], to set and handle the appointments for calendar.
  /// * [appointmentBuilder], to set an custom widget for the appointment UI.
  /// * [Appointment], to know more about the appointment and it's properties in
  /// calendar.
  /// * [appointmentTimeTextFormat], to customize the time text format in the
  /// appointment view of calendar.
  /// * Knowledge base: [How to style appointments](https://www.syncfusion.com/kb/12162/how-to-style-the-appointment-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        appointmentTextStyle: TextStyle(
  ///                fontSize: 12,
  ///                fontWeight: FontWeight.w500,
  ///                color: Colors.blue,
  ///                fontStyle: FontStyle.italic)
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final TextStyle appointmentTextStyle;

  /// The height of the view header to the layout within this in [SfCalendar].
  ///
  /// Defaults to `-1`.
  ///
  /// ![view header height as 100 in calendar](https://help.syncfusion.com/flutter/calendar/images/headers/viewheader-height.png)
  ///
  /// See also:
  /// * [viewHeaderStyle], to know about the available customization options for
  /// view header view in calendar.
  /// * Knowledge base: [How to format day and date of view header](https://www.syncfusion.com/kb/12339/how-to-format-the-view-header-day-and-date-in-the-flutter-calendar)
  /// * Knowledge base: [How to add custom header and view header](https://www.syncfusion.com/kb/10997/how-to-add-custom-header-and-view-header-in-the-flutter-calendar)
  /// * Knowledge base: [How to highlight tapped date in view header](https://www.syncfusion.com/kb/12469/how-to-highlight-the-tapped-view-header-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        viewHeaderHeight: 100,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double viewHeaderHeight;

  /// Color that highlights the today cell in [SfCalendar].
  ///
  /// Allows to change the color that highlights the today cell in month view,
  /// and view header of day/week/workweek, timeline view and highlights the date
  /// in month agenda view in [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [showCurrentTimeIndicator], to display an indicator in the current time
  /// of the day in calendar.
  /// * [todayTextStyle], to customize the today text in calendar.
  /// * [SfCalendarTheme], to handle theming with calendar for giving consistent
  /// look.
  /// * Knowledge base: [How to customize the current day color](https://www.syncfusion.com/kb/12336/how-to-customize-the-current-day-color-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        todayHighlightColor: Colors.red,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? todayHighlightColor;

  /// The text style for the today text in [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// _Note:_ The [todayHighlightColor] will be set to the day text in the
  /// view headers, agenda and schedule view of [SfCalendar].
  ///
  /// The font size property will be applied from the text style properties of
  /// view headers, agenda view and schedule views of [SfCalendar].
  ///
  /// Eg: For today in view header, the font size will be applied from the
  /// [viewHeaderStyle.dayTextStyle] property.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [todayHighlightColor], to customize the highlighting color of the today
  /// cell in calendar.
  /// * [ViewHeaderStyle], to know about the available customization options for
  /// view header view in calendar.
  /// * [ScheduleViewSettings], to know about the available customization
  /// options for schedule view in calendar.
  /// * [MonthViewSettings], to know about the available customization options
  /// for month vie win calendar.
  /// * To know more about the view header customization refer here [https://help.syncfusion.com/flutter/calendar/headers#view-header]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                     fontSize: 17,
  ///                    color: Colors.red),
  ///       )
  ///    );
  ///  }
  /// ```
  final TextStyle? todayTextStyle;

  /// The background color to fill the background of the [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [cellBorderColor], will fill the cell border of the calendar.
  /// * [SfCalendarTheme], to handle theming with calendar for giving consistent
  /// look.
  /// * Knowledge base: [How to add an image as background](https://www.syncfusion.com/kb/12243/how-to-add-an-image-as-background-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        backgroundColor: Colors.transparent,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? backgroundColor;

  /// Displays the navigation arrows on the header view of [SfCalendar].
  ///
  /// If this property set as [true] the header view of [SfCalendar] will
  /// display the navigation arrows which used to navigate to the previous/next
  /// views through the navigation icon buttons.
  ///
  /// defaults to `false`.
  ///
  /// _Note:_ Header view does not show arrow when calendar view as
  /// [CalendarView.schedule]
  ///
  /// See also:
  /// * [CalendarController.forward], to navigate to next view of calendar
  /// programmatically with animation.
  /// * [CalendarController.backward], to navigate to previous view of calendar
  /// programmatically with animation.
  /// * Knowledge base: [How to navigate to the previous or next view using navigation arrows](https://www.syncfusion.com/kb/12247/how-to-navigate-to-the-previous-or-next-views-using-navigation-arrows-in-the-flutter)
  ///
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        showNavigationArrow: true,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool showNavigationArrow;

  /// Specifies the view navigation for [SfCalendar] to show dates for the next
  /// or previous views.
  ///
  /// Defaults to ViewNavigationMode.snap.
  ///
  /// Not applicable when the [view] set as [CalendarView.schedule].
  /// It will not impact scrolling timeslot views, [controller.forward],
  /// [controller.backward] and [showNavigationArrow].
  ///
  /// See also:
  /// * [minDate], to restrict the navigation and interaction to the dates
  /// before to this date in calendar.
  /// * [maxDate], to restrict the navigation and interaction to the dates after
  /// to this date in calendar.
  /// * [showNavigationArrow], to enable the navigation arrow, which enables to
  /// navigate to the next/previous view of calendar programmatically.
  /// * Knowledge base: [How to restrict view navigation](https://www.syncfusion.com/kb/12554/how-to-restrict-the-view-navigation-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        viewNavigationMode: ViewNavigationMode.snap,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final ViewNavigationMode viewNavigationMode;

  /// The settings have properties which allow to customize the time slot views
  /// of the [SfCalendar].
  ///
  /// Allows to customize the [TimeSlotViewSettings.startHour],
  /// [TimeSlotViewSettings.endHour], [TimeSlotViewSettings.nonWorkingDays],
  /// [TimeSlotViewSettings.timeInterval],
  /// [TimeSlotViewSettings.timeIntervalHeight],
  /// [TimeSlotViewSettings.timeIntervalWidth],
  /// [TimeSlotViewSettings.timeFormat], [TimeSlotViewSettings.dateFormat],
  /// [TimeSlotViewSettings.dayFormat], and [TimeSlotViewSettings.timeRulerSize]
  /// in time slot views of calendar.
  ///
  /// See also:
  /// * [monthViewSettings], to know more about the customization options for
  /// the month view of calendar.
  /// * [TimeSlotViewSettings], to know more about the customization options for
  /// the month view of calendar.
  /// * [scheduleViewSettings], to know more about the customization options for
  /// the schedule view of calendar.
  /// * [specialRegions], which allows to customize particular time region in
  /// the time slot views of calendar.
  /// * Knowledge base: [How to customize time label](https://www.syncfusion.com/kb/11008/how-to-customize-the-time-label-in-the-flutter-calendar)
  /// * Knowledge base: [How to change the time interval width and height](https://www.syncfusion.com/kb/12322/how-to-change-the-time-interval-width-and-height-in-the-flutter-event-calendar-sfcalendar)
  /// * Knowledge base: [How to set the arbitrary height to an appointment](https://www.syncfusion.com/kb/12279/how-to-set-the-arbitrary-height-to-appointments-in-the-flutter-calendar)
  /// * Knowledge base: [How to auto fit the calendar to screen height](https://www.syncfusion.com/kb/12231/how-to-autofit-the-calendar-to-screen-height-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the timeline appointment height](https://www.syncfusion.com/kb/12147/how-to-customize-the-timeline-appointment-height-in-the-flutter-calendar)
  /// * Knowledge base: [How to change working days and hours](https://www.syncfusion.com/kb/12146/how-to-change-the-working-days-and-hours-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
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
  ///
  /// ```
  final TimeSlotViewSettings timeSlotViewSettings;

  /// The resource settings allows to customize the resource view of timeline
  /// views.
  ///
  /// See also:
  /// * [CalendarResource], the object which contains the data for the resource
  /// in calendar.
  /// * [dataSource.resources], the collection of resource to be displayed in
  /// the timeline views of [SfCalendar].
  /// * [ResourceViewSettings], which contains options to customize the
  /// resource view of calendar.
  /// * [resourceViewHeaderBuilder], to set custom widget for the resource
  /// header in the calendar.
  /// * Knowledge base: [How to customize the resource view](https://www.syncfusion.com/kb/12351/how-to-customize-the-resource-view-in-the-flutter-calendar)
  ///
  /// ```dart
  ///@override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineMonth,
  ///        dataSource: _getCalendarDataSource(),
  ///        resourceViewSettings: ResourceViewSettings(
  ///            visibleResourceCount: 4,
  ///            size: 150,
  ///            displayNameTextStyle: TextStyle(
  ///                fontStyle: FontStyle.italic,
  ///                fontSize: 15,
  ///                fontWeight: FontWeight.w400)),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  ///class DataSource extends CalendarDataSource {
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
  ///  resources.add(
  ///      CalendarResource(displayName: 'John', id: '0001',
  ///                             color: Colors.red));
  ///
  ///  return DataSource(appointments, resources);
  ///}
  ///
  /// ```
  final ResourceViewSettings resourceViewSettings;

  /// The settings have properties which allow to customize the month view of
  /// the [SfCalendar].
  ///
  /// Allows to customize the [MonthViewSettings.dayFormat],
  /// [MonthViewSettings.numberOfWeeksInView],
  /// [MonthViewSettings.appointmentDisplayMode],
  /// [MonthViewSettings.showAgenda],
  /// [MonthViewSettings.appointmentDisplayCount], and
  /// [MonthViewSettings.navigationDirection] in month view of calendar.
  ///
  /// See also:
  /// * [monthCellBuilder], to customize the month cell with custom widget in
  /// calendar.
  /// * [MonthViewSettings], to know more about the customization of month view
  /// in calendar.
  /// * [blackoutDates], which allows to restrict the interaction for a
  /// particular date in month views of calendar.
  /// * [blackoutDatesTextStyle], which used to customize the blackout dates
  /// text style in the month view of calendar.
  /// * Knowledge base: [How to customize agenda view height based on widget height](https://www.syncfusion.com/kb/11013/how-to-customize-agenda-view-height-based-on-the-flutter-calendar-widget-height)
  /// * Knowledge base: [How to customize agenda item height](https://www.syncfusion.com/kb/11015/how-to-customize-the-agenda-item-height-in-the-flutter-calendar)
  /// * Knowledge base: [How to show appointment in agenda view using programmatic date selection](https://www.syncfusion.com/kb/11525/how-to-show-the-appointment-in-agenda-view-using-the-programmatic-date-selection-in-the)
  /// * Knowledge base: [How to customize the blackout dates](https://www.syncfusion.com/kb/11987/how-to-customize-the-blackout-dates-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the leading and trailing dates](https://www.syncfusion.com/kb/11988/how-to-customize-the-leading-and-trailing-dates-of-the-month-cells-in-the-flutter-calendar)
  /// * Knowledge base: [How to style the month cell](https://www.syncfusion.com/kb/12090/how-to-style-the-month-cell-in-the-flutter-calendar)
  /// * Knowledge base: [How to change the number of weeks](https://www.syncfusion.com/kb/12157/how-to-change-the-number-of-weeks-in-the-flutter-calendar)
  /// * Knowledge base: [How to customize the agenda view appointment](https://www.syncfusion.com/kb/12271/how-to-customize-the-agenda-view-appointment-using-the-style-properties-in-flutter-calendar)
  ///
  /// ```dart
  ///
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
  ///
  /// ```
  final MonthViewSettings monthViewSettings;

  /// Represents a list of dates, which are not eligible for
  /// selection in [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// By default, specified dates are marked with a strike-through.
  /// Styling of the blackout dates can be handled using the
  /// [blackoutDatesTextStyle] property in [SfCalendar].
  ///
  /// See also:
  /// *[blackoutDatesTextStyle], to customize the blackout dates text in
  /// calendar.
  /// * Knowledge base: (How to update blackout dates using onViewChanged)[https://www.syncfusion.com/kb/12368/how-to-update-blackout-dates-using-onviewchanged-callback-in-the-flutter-calendar]
  /// * Knowledge base: (How to add active dates)[https://www.syncfusion.com/kb/12073/how-to-add-active-dates-in-the-flutter-calendar]
  /// * Knowledge base: (How to customize the blackout dates )[https://www.syncfusion.com/kb/12003/how-to-customize-the-blackout-dates-in-the-flutter-event-calendar-sfcalendar]
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfCalendar(
  ///         view: CalendarView.month,
  ///         blackoutDates: <DateTime>[
  ///           DateTime.now().add(Duration(days: 2)),
  ///           DateTime.now().add(Duration(days: 3)),
  ///           DateTime.now().add(Duration(days: 6)),
  ///           DateTime.now().add(Duration(days: 7))
  ///          ]
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final List<DateTime>? blackoutDates;

  /// Specifies the text style for the blackout dates text in [SfCalendar],
  /// that can’t be selected.
  /// The specified text style overrides existing date text styles(
  /// [MonthCellStyle.trailingDatesTextStyle],
  /// [MonthCellStyle.leadingDatesTextStyle] and [MonthCellStyle.textStyle])
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [blackoutDates], which will add blackout dates to the calendar.
  /// * [SfCalendarTheme], to handle theming with calendar for giving consistent
  /// look.
  /// * Knowledge base: (How to update blackout dates using onViewChanged)[https://www.syncfusion.com/kb/12368/how-to-update-blackout-dates-using-onviewchanged-callback-in-the-flutter-calendar]
  /// * Knowledge base: (How to add active dates)[https://www.syncfusion.com/kb/12073/how-to-add-active-dates-in-the-flutter-calendar]
  /// * Knowledge base: (How to customize the blackout dates )[https://www.syncfusion.com/kb/12003/how-to-customize-the-blackout-dates-in-the-flutter-event-calendar-sfcalendar]
  ///
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///          blackoutDatesTextStyle: TextStyle(
  ///             fontStyle: FontStyle.italic,
  ///              fontWeight: FontWeight.w500,
  ///              fontSize: 18,
  ///              color: Colors.black54
  ///          )
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? blackoutDatesTextStyle;

  /// The decoration for the selection cells in [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [initialSelectedDate], to select date when calendar displays initially
  /// * [CalendarController.selectedDate], to select date programmatically in
  /// calendar in the runtime.
  /// * [SfCalendarTheme], to handle theming with calendar for giving consistent
  /// look.
  /// * Knowledge base: [How to customize the selection using decoration](https://www.syncfusion.com/kb/12245/how-to-customize-the-selection-using-decoration-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.month,
  ///        selectionDecoration: BoxDecoration(
  ///           color: Colors.transparent,
  ///             border:
  ///               Border.all(color: const Color.fromARGB(255, 68, 140, 255),
  ///                     width: 2),
  ///             borderRadius: const BorderRadius.all(Radius.circular(4)),
  ///             shape: BoxShape.rectangle,
  ///         ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Decoration? selectionDecoration;

  /// The initial date to show on the [SfCalendar].
  ///
  /// The [SfCalendar] will display the dates based on the date set to this
  /// property.
  ///
  /// Defaults to `DateTime(DateTime.now().year, DateTime.now().month,
  /// DateTime.now().day, 08, 45, 0)`.
  ///
  /// See also:
  /// * [CalendarController.displayDate], to change the display date of calendar
  /// programmatically on run time.
  /// * [CalendarController.forward], to navigate to next view of calendar
  /// programmatically.
  /// * [CalendarController.backward], to navigate to previous view of calendar
  /// Programmatically.
  /// * [onViewChanged], the callback which will notify that the current visible
  /// dates were changed in calendar.
  /// * [initialSelectedDate], to selected date programmatically on calendar
  /// initially.
  /// * Knowledge base: [How to programmatically navigate to adjacent dates](https://www.syncfusion.com/kb/12654/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-calendar)
  /// * Knowledge base: [How to programmatically navigate to a date](https://www.syncfusion.com/kb/12139/how-to-programmatically-navigate-to-the-date-in-the-flutter-event-calendar-sfcalendar)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        initialDisplayDate: DateTime(2020, 02, 05, 10, 0, 0),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateTime initialDisplayDate;

  /// The time zone for [SfCalendar] to function.
  ///
  /// If the [Appointment.startTimeZone] and [Appointment.endTimeZone] set as
  /// [null] the appointments will be displayed in UTC time based on the
  /// time zone set to this property.
  ///
  /// If the [Appointment.startTimeZone] and [Appointment.endTimeZone] set as
  /// not [null] the appointments will be displayed based by calculating the
  /// appointment's startTimeZone and endTimeZone based on the time zone set to
  /// this property.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [Appointment.startTimeZone], to handle time zone for appointment's start
  /// time.
  /// * [Appointment.endTimeZone], to handle time zone for appointment's end
  /// time.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  ///
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        timeZone: 'Atlantic Standard Time',
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final String? timeZone;

  /// The date to initially select on the [SfCalendar].
  ///
  /// The [SfCalendar] will select the date that set to this property.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [CalendarController.selectedDate], to selected date programmatically on
  /// calendar in the runtime.
  /// * [selectionDecoration], to add decoration for the selected cell in
  /// calendar.
  /// * [initialDisplayDate], to navigate to the given date on calendar
  /// initially.
  /// * [CalendarController.displayDate], to navigate to the given date on
  /// calendar programmatically in runtime.
  /// * [onSelectionChanged], the callback which notifies when the selected cell
  /// changed on calendar.
  /// * Knowledge base: [How to get the selected dates using selection changed callback](https://www.syncfusion.com/kb/12551/how-to-get-the-selected-dates-using-selection-changed-callback-in-the-flutter-calendar)
  /// * Knowledge base: [How to programmatically select the dates](https://www.syncfusion.com/kb/12115/how-to-programmatically-select-the-dates-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        initialSelectedDate: DateTime(2019, 12, 12, 11, 0, 0),
  ///      ),
  ///   );
  ///  }
  ///
  /// ```
  final DateTime? initialSelectedDate;

  /// Called when the current visible date changes in [SfCalendar].
  ///
  /// Called in the following scenarios when the visible dates were changed
  /// 1. When calendar loaded the visible dates initially.
  /// 2. When calendar view swiped to previous/next view.
  /// 3. When calendar view changed, i.e: Month to day, etc..,
  /// 4. When navigated to a specific date programmatically by using the
  /// [controller.displayDate].
  /// 5. When navigated programmatically using [controller.forward] and
  /// [controller.backward].
  ///
  /// The visible dates collection visible on view when the view changes
  /// available
  /// in the [ViewChangedDetails].
  ///
  /// See also:
  /// * [ViewChangedDetails], which contains the visible dates collection of the
  /// current visible view.
  /// * [initialDisplayDate], to display calendar on a desired date in initial.
  /// * [CalendarController.displayDate], to change the display date of calendar
  /// programmatically on run time.
  /// * [CalendarController.forward], to navigate to next view of calendar
  /// programmatically.
  /// * [CalendarController.backward], to navigate to previous view of calendar
  /// Programmatically.
  /// * Knowledge base: [How to update blackout dates using onViewChanged](https://www.syncfusion.com/kb/12368/how-to-update-blackout-dates-using-onviewchanged-callback-in-the-flutter-calendar)
  /// * Knowledge base: [How to clear the appointments in the month agenda view using onViewChange](https://www.syncfusion.com/kb/12089/how-to-clear-the-appointments-in-month-agenda-view-using-onviewchange-callback-in-the)
  /// * Knowledge base: [How to add a special region dynamically using onTap, onViewChanged](https://www.syncfusion.com/kb/11729/how-to-add-a-special-region-dynamically-using-ontap-onviewchanged-callbacks-of-the-flutter)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        onViewChanged: (ViewChangedDetails details){
  ///          List<DateTime> dates = details.visibleDates;
  ///        },
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final ViewChangedCallback? onViewChanged;

  /// Called whenever the [SfCalendar] elements tapped on view.
  ///
  /// The tapped date, appointments, and element details when the tap action
  /// performed on element available in the [CalendarTapDetails].
  ///
  /// see also:
  /// * [CalendarTapDetails], which contains the details of the tapped element
  /// in the calendar.
  /// * [CalendarElement], to know about the different available elements in the
  /// calendar.
  /// * [initialSelectedDate], to selected the date programmatically on calendar
  /// initially.
  /// * [CalendarController.selectedDate], to selected date programmatically on
  /// calendar in the runtime.
  /// * [selectionDecoration], to add decoration for the selected cell in
  /// calendar.
  /// * [onSelectionChanged], the callback which notifies when the selected cell
  /// changed on calendar.
  /// * Knowledge base: [How to get appointment details for the onTap](https://www.syncfusion.com/kb/10999/how-to-get-appointment-details-from-the-ontap-event-of-the-flutter-calendar)
  /// * Knowledge base: [How to add a special region dynamically using onTap, onViewChanged](https://www.syncfusion.com/kb/11729/how-to-add-a-special-region-dynamically-using-ontap-onviewchanged-callbacks-of-the-flutter)
  /// * Knowledge base: [How to interact with event calendar with appointments loaded](https://www.syncfusion.com/kb/12218/how-to-interact-with-event-calendar-cell-when-appointments-loaded-in-the-flutter-calendar)
  /// * Knowledge base: [How to add the appointments using the onTap](https://www.syncfusion.com/kb/12300/how-to-add-the-appointments-using-the-ontap-callback-in-the-flutter-calendar)
  /// * Knowledge base: [How to design and configure your appointment editor](https://www.syncfusion.com/kb/11204/how-to-design-and-configure-your-appointment-editor-in-flutter-calendar)
  ///
  /// ```dart
  ///
  ///return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        onTap: (CalendarTapDetails details){
  ///          DateTime date = details.date!;
  ///          dynamic appointments = details.appointments;
  ///          CalendarElement view = details.targetElement;
  ///        },
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final CalendarTapCallback? onTap;

  /// Called whenever the [SfCalendar] elements long pressed on view.
  ///
  /// The long-pressed date, appointments, and element details when the
  /// long-press action
  /// performed on element available in the [CalendarLongPressDetails].
  ///
  /// see also:
  /// * [CalendarLongPressDetails], which contains the details of the long
  /// pressed element in the calendar.
  /// * [CalendarElement], to know about the different available elements in the
  /// calendar.
  /// * [selectionDecoration], to add decoration for the selected cell in
  /// calendar.
  /// * [onSelectionChanged], the callback which notifies when the selected cell
  /// changed on calendar.
  /// * Knowledge base: [How to handle the long press action](https://www.syncfusion.com/kb/12121/how-to-handle-the-long-press-action-on-date-selection-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
  ///return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        onLongPress: (CalendarLongPressDetails details){
  ///          DateTime date = details.date!;
  ///          dynamic appointments = details.appointments;
  ///          CalendarElement view = details.targetElement;
  ///        },
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final CalendarLongPressCallback? onLongPress;

  /// Called whenever a [SfCalendar] cell is selected.
  ///
  /// The callback details argument contains the selected date and
  /// its resource details.
  ///
  /// see also:
  /// * [CalendarSelectionDetails], which contains the details of the selected
  /// element in the calendar.
  /// * [CalendarElement], to know about the different available elements in the
  /// calendar.
  /// * [initialSelectedDate], to selected the date programmatically on calendar
  /// initially.
  /// * [CalendarController.selectedDate], to selected date programmatically on
  /// calendar in the runtime.
  /// * [selectionDecoration], to add decoration for the selected cell in
  /// calendar.
  /// * [onTap], the callback which notifies when the calendar elements tapped
  /// on view.
  /// * Knowledge base: [How to get the selected dates using the selection changed](https://www.syncfusion.com/kb/12551/how-to-get-the-selected-dates-using-selection-changed-callback-in-the-flutter-calendar)
  ///
  /// ```dart
  ///
  ///return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineDay,
  ///        onSelectionChanged: (CalendarSelectionDetails details){
  ///          DateTime date = details.date!;
  ///          CalendarResource resource = details.resource!;
  ///        },
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final CalendarSelectionChangedCallback? onSelectionChanged;

  /// Used to set the [Appointment] or custom event collection through the
  /// [CalendarDataSource] class.
  ///
  /// If it is not [null] the collection of appointments set to the
  /// [CalendarDataSource.appointments] property will be set to [SfCalendar] and
  /// rendered on view.
  ///
  /// Defaults to null.
  ///
  /// see also:
  /// * [CalendarDataSource], to add and handle the appointments and resource on
  /// the calendar.
  /// * [Appointment], the object which holds the details of the appointment.
  /// * [CalendarResource], the object which holds the details of the resource
  /// in the calendar.
  /// * [loadMoreWidgetBuilder], allows to build an widget which will display
  /// when appointments loaded on demand in the calendar.
  /// * [resourceViewHeaderBuilder], to set custom widget for the resource view
  /// in the calendar.
  /// * [resourceViewSettings], to customize the resource view in the calendar.
  /// * [appointmentBuilder], to set custom widget for the appointment view in
  /// the calendar.
  /// * [appointmentTextStyle], to customize the text style for the appointments
  /// in calendar.
  /// * [appointmentTimeTextFormat], to customize the time format for the
  /// appointment view in calendar.
  /// * Knowledge base: [How to perform the crud operations using firestore database](https://www.syncfusion.com/kb/12661/how-to-perform-the-crud-operations-in-flutter-calendar-using-firestore-database)
  /// * Knowledge base: [How to load appointments on demand](https://www.syncfusion.com/kb/12658/how-to-load-appointments-on-demand-in-flutter-calendar)
  /// * Knowledge base: [How to load google calendar events in iOS](https://www.syncfusion.com/kb/12647/how-to-load-the-google-calendar-events-to-the-flutter-calendar-sfcalendar-in-ios)
  /// * Knowledge base: [How to get the appointments between the given start and end date](https://www.syncfusion.com/kb/12549/how-to-get-the-appointments-between-the-given-start-and-end-date-in-the-flutter-calendar)
  /// * Knowledge base: [How to get the current month appointments](https://www.syncfusion.com/kb/12477/how-to-get-the-current-month-appointments-in-the-flutter-calendar)
  /// * Knowledge base: [How to load data from offline sqlite database](https://www.syncfusion.com/kb/12399/how-to-load-data-from-offline-sqlite-database-to-flutter-calendar)
  /// * Knowledge base: [How to create time table](https://www.syncfusion.com/kb/12392/how-to-create-time-table-using-flutter-event-calendar)
  /// * Knowledge base: [How to add google calendar events](https://www.syncfusion.com/kb/12116/how-to-add-google-calendar-events-to-the-flutter-event-calendar-sfcalendar)
  /// * Knowledge base: [How to add a custom appointments of business objects](https://www.syncfusion.com/kb/11529/how-to-add-a-custom-appointments-or-objects-in-the-flutter-calendar)
  /// * Knowledge base: [How to delete an appointment](https://www.syncfusion.com/kb/11522/how-to-delete-an-appointment-in-the-flutter-calendar)
  ///
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        dataSource: _getCalendarDataSource(),
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            timeTextStyle: TextStyle(
  ///                fontSize: 12,
  ///                fontWeight: FontWeight.w500,
  ///                color: Colors.blue,
  ///                fontStyle: FontStyle.italic)
  ///        ),
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
  /// ```
  final CalendarDataSource? dataSource;

  /// Defines the collection of special [TimeRegion] for [SfCalendar].
  ///
  /// It is used to highlight time slots on day, week, work week
  /// and timeline views based on [TimeRegion] start and end time.
  ///
  /// It also used to restrict interaction on time slots.
  ///
  /// See also:
  /// * [timeRegionBuilder], to set custom widget for the time regions in the
  /// calendar
  /// * [TimeRegion], to now the details about the special time regions and it's
  /// properties in calendar.
  /// * Knowledge base: [How to customize special regions with builder](https://www.syncfusion.com/kb/12192/how-to-customize-the-special-time-region-using-custom-builder-in-the-flutter-calendar)
  /// * Knowledge base: [How to create time table](https://www.syncfusion.com/kb/12392/how-to-create-time-table-using-flutter-event-calendar)
  /// * Knowledge base: [How to add a special region dynamically using onTap and onViewChanged](https://www.syncfusion.com/kb/11729/how-to-add-a-special-region-dynamically-using-ontap-onviewchanged-callbacks-of-the-flutter)
  /// * Knowledge base: [How to use multiple recurrence rule in special region](https://www.syncfusion.com/kb/11730/how-to-use-multiple-recurrence-rule-rrule-in-special-region-using-flutter-calendar)
  /// * Knowledge base: [How to highlight the weekends](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
  /// * Knowledge base: [How to highlight the lunch hours](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        color: Colors.grey.withOpacity(0.2),
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final List<TimeRegion>? specialRegions;

  /// Used to display the week number of the year in all calendar views except
  /// schedule view of the SfCalendar.
  ///
  /// In the month view, it is displayed at the left side as a separate column.
  /// whereas in the week and work week view it is displayed beside the view
  /// header panel, and for day and timeline views it is displayed next to the
  /// header text in the header panel of the calendar.
  ///
  /// Defaults to false
  ///
  /// see also:
  /// * [weekNumberStyle], to customize the week number view in the calendar.
  /// * [firstDayOfWeek], to change the first day of the week in the calendar.
  ///
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///       view: CalendarView.month,
  ///       showWeekNumber: true,
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final bool showWeekNumber;

  /// Defines the text style for the text in the week number panel of the
  /// SfCalendar.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// Defaults to false
  ///
  /// see also:
  /// * [showWeekNumber], to display the week number view on the calendar views.
  /// * [WeekNumberStyle], to know more about the available customization
  /// options for week number view in calendar.
  /// * [SfCalendarTheme], to handle theming with calendar for giving consistent
  /// look.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///   body: SfCalendar(
  ///     view: CalendarView.month,
  ///     showWeekNumber: true,
  ///     weekNumberStyle: WeekNumberStyle(
  ///         backgroundColor: Colors.blue,
  ///         textStyle: TextStyle(color: Colors.grey, fontSize: 20),
  ///   ),
  ///  );
  /// }
  ///
  /// ```
  final WeekNumberStyle weekNumberStyle;

  /// Defines the builder that builds a widget and replaces the header
  /// view of resource in SfCalendar.
  ///
  /// Defaults to null.
  ///
  /// see also:
  /// * [resourceViewSettings], to customize the resource view in the calendar
  /// * [CalendarResource], the object which holds the data of the resource in
  /// calendar.
  /// * [dataSource.resources], the collection of resource to be displayed in
  /// the timeline views of [SfCalendar].
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///     home: Scaffold(
  ///       appBar: AppBar(
  ///         title: Text('Calendar'),
  ///       ),
  ///       body: SfCalendar(
  ///           view: CalendarView.timelineMonth,
  ///           resourceViewHeaderBuilder:
  ///               (BuildContext context, ResourceViewHeaderDetails details) {
  ///             if (details.resource.image != null) {
  ///               return Column(
  ///                 mainAxisAlignment: MainAxisAlignment.center,
  ///                 crossAxisAlignment: CrossAxisAlignment.center,
  ///                 mainAxisSize: MainAxisSize.max,
  ///                 children: [
  ///                   CircleAvatar(backgroundColor: details.resource.image),
  ///                   Text(details.resource.displayName)
  ///                 ],
  ///               );
  ///             } else {
  ///               return Container(
  ///                 color: details.resource.color,
  ///                 child: Text(
  ///                     details.resource.displayName
  ///                 ),
  ///               );
  ///             }
  ///           }),
  ///     ),
  ///   );
  /// }
  /// ```
  final ResourceViewHeaderBuilder? resourceViewHeaderBuilder;

  /// Allows to drag and drop the appointment, to reschedule this into
  /// new date time.
  ///
  /// Defaults to false.
  ///
  /// See also:
  /// * [allowAppointmentResize], which allows to resize the appointment to
  /// reschedule.
  /// * [dragAndDropSettings], which allows to customize the drag and
  /// drop environment.
  ///
  /// _Note:_ This doesn't applicable when the [view] set as
  /// [CalendarView.schedule]. This doesn't applicable when the [view] set as
  /// [CalendarView.month] and [CalendarView.timelineMonth] in mobile layout.
  ///
  /// This method must be implemented to get the data with business object type
  /// when drag and drop or appointment resizing enabled.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///       view: CalendarView.month,
  ///       showWeekNumber: true,
  ///       allowDragAndDrop: true,
  ///       dragAndDropSettings: DragAndDropSettings(
  ///         allowNavigation: true,
  ///         allowScroll: true,
  ///         autoNavigateDelay: Duration(seconds: 1),
  ///         indicatorTimeFormat: 'HH:mm a',
  ///         showTimeIndicator: true,
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final bool allowDragAndDrop;

  /// Allows to customize the drag and drop environment.
  ///
  /// See also:
  /// * [monthViewSettings], which allows to customize the month view of
  /// the calendar.
  /// * [timeSlotViewSettings], which allows to customize the timeslot view
  /// of the calendar.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///       view: CalendarView.month,
  ///       showWeekNumber: true,
  ///       allowDragAndDrop: true,
  ///       dragAndDropSettings: DragAndDropSettings(
  ///         allowNavigation: true,
  ///         allowScroll: true,
  ///         autoNavigateDelay: Duration(seconds: 1),
  ///         indicatorTimeFormat: 'HH:mm a',
  ///         showTimeIndicator: true,
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final DragAndDropSettings dragAndDropSettings;

  /// Called whenever the appointment starts to drag in the  [SfCalendar].
  ///
  /// The callback arguments contains the dragging appointment and associated
  /// resource details.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///         view: CalendarView.month,
  ///         showWeekNumber: true,
  ///         allowDragAndDrop: true,
  ///         dragAndDropSettings: DragAndDropSettings(
  ///           allowNavigation: true,
  ///           allowScroll: true,
  ///           autoNavigateDelay: Duration(seconds: 1),
  ///           indicatorTimeFormat: 'HH:mm a',
  ///           showTimeIndicator: true,
  ///         ),
  ///         onDragStart: (AppointmentDragStartDetails details) {
  ///           dynamic appointment = details.appointment!;
  ///           CalendarResource? resource = details.resource;
  ///         }),
  ///   );
  /// }
  /// ```
  final AppointmentDragStartCallback? onDragStart;

  /// Called whenever the appointment is dragging in the [SfCalendar].
  ///
  /// The callback arguments contains the dragging appointment, dragging time,
  /// dragging offset, source resource and target resource details.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///         view: CalendarView.month,
  ///         showWeekNumber: true,
  ///         allowDragAndDrop: true,
  ///         dragAndDropSettings: DragAndDropSettings(
  ///           allowNavigation: true,
  ///           allowScroll: true,
  ///           autoNavigateDelay: Duration(seconds: 1),
  ///           indicatorTimeFormat: 'HH:mm a',
  ///           showTimeIndicator: true,
  ///         ),
  ///         onDragUpdate: (AppointmentDragUpdateDetails details) {
  ///           dynamic appointment = details.appointment!;
  ///           CalendarResource? sourceResource = details.sourceResource;
  ///           CalendarResource? targetResource = details.targetResource;
  ///           Offset? draggingPosition = details.draggingPosition;
  ///           DateTime? draggingTime = details.draggingTime;
  ///         }),
  ///   );
  /// }
  /// ```
  final AppointmentDragUpdateCallback? onDragUpdate;

  /// Called when the dragging appointment is dropped in the [SfCalendar].
  ///
  /// The callback arguments contains the dropped appointment, dropping time,
  /// source and target resource details.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///         view: CalendarView.month,
  ///         showWeekNumber: true,
  ///         allowDragAndDrop: true,
  ///         dragAndDropSettings: DragAndDropSettings(
  ///           allowNavigation: true,
  ///           allowScroll: true,
  ///           autoNavigateDelay: Duration(seconds: 1),
  ///           indicatorTimeFormat: 'HH:mm a',
  ///           showTimeIndicator: true,
  ///         ),
  ///         onDragEnd: (AppointmentDragEndDetails details) {
  ///           dynamic appointment = details.appointment!;
  ///           CalendarResource? sourceResource = details.sourceResource;
  ///           CalendarResource? targetResource = details.targetResource;
  ///           DateTime? draggingTime = details.droppingTime;
  ///         }),
  ///   );
  /// }
  /// ```
  final AppointmentDragEndCallback? onDragEnd;

  /// An object that used for programmatic date navigation and date selection
  /// in [SfCalendar].
  ///
  /// A [CalendarController] served for several purposes. It can be used
  /// to selected dates programmatically on [SfCalendar] by using the
  /// [controller.selectedDate]. It can be used to navigate to specific date
  /// by using the [controller.displayDate] property.
  ///
  /// ## Listening to property changes:
  /// The [CalendarController] is a listenable. It notifies it's listeners
  /// whenever any of attached [SfCalendar]`s selected date, display date
  /// changed (i.e: selecting a different date, swiping to next/previous
  /// view] in in [SfCalendar].
  ///
  /// ## Navigates to different view:
  /// In [SfCalendar] the visible view can be navigated programmatically by
  /// using the [controller.forward] and [controller.backward] method.
  ///
  /// ## Programmatic selection:
  /// In [SfCalendar] selecting dates programmatically can be achieved by
  /// using the [controller.selectedDate] which allows to select date on
  /// [SfCalendar] on initial load and in run time.
  ///
  /// The [CalendarController] can be listened by adding a listener to the
  /// controller, the listener will listen and notify whenever the selected
  /// date, display date changed in the [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [CalendarController], to know more about the controller and it's usage
  /// with the calendar.
  /// * [initialSelectedDate], to select dates initially on the calendar.
  /// * [initialDisplayDate], the date which shown when the calendar displayed
  /// initially.
  /// * [onViewChanged], the callback which notifies when the current view
  /// visible date changed on calendar.
  /// * [onSelectionChanged], the callback which notifies when the selected cell
  /// changed on the calendar.
  /// * Knowledge base: [How to programmatically navigate to adjacent days](https://www.syncfusion.com/kb/12654/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-calendar)
  /// * Knowledge base: [How to do programmatic navigation](https://www.syncfusion.com/kb/12141/how-to-do-programmatic-navigation-using-flutter-calendar)
  /// * Knowledge base: [How to programmatically select the dates](https://www.syncfusion.com/kb/12115/how-to-programmatically-select-the-dates-in-the-flutter-calendar)
  /// * Knowledge base: [How to move to a specific time while switching view](https://www.syncfusion.com/kb/10943/how-to-move-to-a-specific-time-while-switching-from-month-to-day-view-in-the-flutter)
  ///
  ///
  /// This example demonstrates how to use the [CalendarController] for
  /// [SfCalendar].
  ///
  /// ```dart
  ///
  /// class MyAppState extends State<MyApp>{
  ///
  ///  CalendarController _calendarController;
  ///  @override
  ///  initState(){
  ///    _calendarController = CalendarController();
  ///    _calendarController.selectedDate = DateTime(2022, 02, 05);
  ///    _calendarController.displayDate = DateTime(2022, 02, 05);
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///          controller: _calendarController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  final CalendarController? controller;

  /// Allows to reschedule the appointment by resizing the appointment.
  ///
  /// Defaults to `false`.
  ///
  /// _Note:_ The appointment resizing is not applicable for mobile platform.
  ///
  /// This method must be implemented to get the data with business
  /// object type when drag and drop or appointment resizing enabled.
  ///
  /// See also:
  /// 	• [allowDragAndDrop], which allows to reschedule a appointment by drag
  /// and drop to different date time.
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///         allowAppointmentResize: true,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool allowAppointmentResize;

  /// Called whenever the appointment starts to resizing in [SfCalendar].
  ///
  /// The resizing appointment and resource details when the appointment starts
  /// to resize available in the [AppointmentResizeStartDetails].
  ///
  /// See also:
  /// * [AppointmentResizeStartDetails], which contains the details of the
  /// resizing appointment in the calendar.
  /// * [onAppointmentResizeUpdate], callback to notifies when the appointment
  /// resizing.
  /// * [onAppointmentResizeEnd], callback to notify when the appointment
  /// resizing ends.
  ///
  /// ```dart
  ///
  /// return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        onAppointmentResizeStart: (AppointmentResizeStartDetails details){
  ///          dynamic appointment = details.appointment!;
  ///          CalendarResource? resource = details.resource;
  ///        },
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final AppointmentResizeStartCallback? onAppointmentResizeStart;

  /// Called whenever the appointment resizing in [SfCalendar].
  ///
  /// The resizing appointment, position, time and resource details when the
  /// appointment resizing available in the [AppointmentResizeUpdateDetails].
  ///
  /// See also:
  /// * [AppointmentResizeUpdateDetails], which contains the details of the
  /// resizing appointment details in the calendar.
  /// * [onAppointmentResizeStart], callback to notifies when the appointment
  /// start resizing.
  /// * [onAppointmentResizeEnd], callback to notify when the appointment
  /// resizing ends.
  ///
  /// ```dart
  ///
  /// return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        onAppointmentResizeUpdate: (AppointmentResizeUpdateDetails
  ///                                                               details){
  ///          dynamic appointment = details.appointment!;
  ///          CalendarResource? resource = details.resource;
  ///          DateTime time = details.resizingTime!;
  ///          Offset position = details.resizingOffset!;
  ///        },
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final AppointmentResizeUpdateCallback? onAppointmentResizeUpdate;

  /// Called whenever the appointment resizing end in the [SfCalendar].
  ///
  /// The resizing appointment, start time, end time and resource details when
  /// the appointment resizing ends available in the
  /// [AppointmentResizeEndDetails].
  ///
  /// See also:
  /// * [AppointmentResizeEndDetails], which contains the details of the
  /// resized appointment details in the calendar.
  /// * [onAppointmentResizeStart], callback to notifies when the appointment
  /// start resizing.
  /// * [onAppointmentResizeUpdate], callback to notifies when the appointment
  /// resizing.
  ///
  /// ```dart
  ///
  /// return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        onAppointmentResizeEnd: (AppointmentResizeEndDetails details){
  ///          dynamic appointment = details.appointment!;
  ///          CalendarResource? resource = details.resource;
  ///          DateTime time = details.startTime!;
  ///          DateTime endTime = details.endTime!;
  ///        },
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final AppointmentResizeEndCallback? onAppointmentResizeEnd;

  /// Returns the date time collection at which the recurrence appointment will
  /// recur
  ///
  /// Using this method the recurrence appointments occurrence date time
  /// collection can be obtained.
  ///
  /// * rRule - required - the recurrence rule of the appointment
  /// * recurrenceStartDate - required - the start date in which the recurrence
  /// starts.
  /// * specificStartDate - optional - the specific start date, used to get the
  /// date collection for a specific interval of dates.
  /// * specificEndDate - optional - the specific end date, used to get the date
  /// collection for a specific interval of dates.
  ///
  ///
  /// return `List<DateTime>`
  ///
  /// See also:
  /// * [Appointment.recurrenceRule], to set the recurrence rule for the
  /// [Appointment], which will recur based on the given rule.
  /// * [TimeRegion.recurrenceRule], to set the recurrence rule for the
  /// [TimeRegion], which will recur based on the given rule.
  /// * Knowledge base: [How to get the recurrence date collection](https://www.syncfusion.com/kb/12344/how-to-get-the-recurrence-date-collection-in-the-flutter-calendar)
  ///
  ///```dart
  ///
  /// DateTime dateTime = DateTime(2020, 03, 15);
  /// List<DateTime> dateCollection =
  ///                   SfCalendar.getRecurrenceDateTimeCollection(
  ///                             'FREQ=DAILY;INTERVAL=1;COUNT=3', dateTime);
  ///
  /// ```
  static List<DateTime> getRecurrenceDateTimeCollection(
      String rRule, DateTime recurrenceStartDate,
      {DateTime? specificStartDate, DateTime? specificEndDate}) {
    assert(specificStartDate == null ||
        specificEndDate == null ||
        CalendarViewHelper.isSameOrBeforeDateTime(
            specificEndDate, specificStartDate));
    assert(specificStartDate == null ||
        specificEndDate == null ||
        CalendarViewHelper.isSameOrAfterDateTime(
            specificStartDate, specificEndDate));
    return RecurrenceHelper.getRecurrenceDateTimeCollection(
        rRule, recurrenceStartDate,
        specificStartDate: specificStartDate, specificEndDate: specificEndDate);
  }

  /// Returns the recurrence properties based on the given recurrence rule and
  /// the recurrence start date.
  ///
  /// Used to get the recurrence properties from the given recurrence rule.
  ///
  /// * rRule - optional - recurrence rule for the properties required
  /// * recStartDate - optional - start date of the recurrence rule for which
  /// the properties required.
  ///
  /// returns `RecurrenceProperties`.
  ///
  /// See also:
  /// * [RecurrenceProperties], to know more about the available recurrence
  /// properties which helps to create the recurrence rule.
  /// * [generateRRule], to generate recurrence rule based on the
  /// [RecurrenceProperties].
  /// * Knowledge base: [How to get the recurrence properties from rrule](https://www.syncfusion.com/kb/12370/how-to-get-the-recurrence-properties-from-rrule-in-the-flutter-calendar)
  ///
  ///
  /// ```dart
  ///
  /// DateTime dateTime = DateTime(2020, 03, 15);
  /// RecurrenceProperties recurrenceProperties =
  ///    SfCalendar.parseRRule('FREQ=DAILY;INTERVAL=1;COUNT=1', dateTime);
  ///
  /// ```
  static RecurrenceProperties parseRRule(String rRule, DateTime recStartDate) {
    return RecurrenceHelper.parseRRule(rRule, recStartDate);
  }

  /// Generates the recurrence rule based on the given recurrence properties and
  /// the start date and end date of the recurrence appointment.
  ///
  /// Used to generate recurrence rule based on the recurrence properties.
  ///
  /// * recurrenceProperties - required - the recurrence properties to generate
  /// the recurrence rule.
  /// * appStartTime - required - the recurrence appointment start time.
  /// * appEndTime - required - the recurrence appointment end time.
  ///
  /// returns `String`.
  ///
  /// See also:
  /// * [RecurrenceProperties], to know more about the available recurrence
  /// properties which helps to create the recurrence rule.
  /// * [parseRRule], to generate the recurrence properties based on the
  /// recurrence rule.
  /// * [Appointment.recurrenceRule], to set the recurrence rule for the
  /// [Appointment], which will recur based on the given rule.
  /// * [TimeRegion.recurrenceRule], to set the recurrence rule for the
  /// [TimeRegion], which will recur based on the given rule.
  ///
  /// ```dart
  ///
  /// RecurrenceProperties recurrenceProperties =
  /// RecurrenceProperties(startDate: DateTime.now());
  ///recurrenceProperties.recurrenceType = RecurrenceType.daily;
  ///recurrenceProperties.recurrenceRange = RecurrenceRange.count;
  ///recurrenceProperties.interval = 2;
  ///recurrenceProperties.recurrenceCount = 10;
  ///
  ///Appointment appointment = Appointment(
  ///    startTime: DateTime(2019, 12, 16, 10),
  ///    endTime: DateTime(2019, 12, 16, 12),
  ///    subject: 'Meeting',
  ///    color: Colors.blue,
  ///    recurrenceRule: SfCalendar.generateRRule(recurrenceProperties,
  ///        DateTime(2019, 12, 16, 10), DateTime(2019, 12, 16, 12)));
  ///
  /// ```
  static String generateRRule(RecurrenceProperties recurrenceProperties,
      DateTime appStartTime, DateTime appEndTime) {
    assert(CalendarViewHelper.isSameOrBeforeDateTime(appEndTime, appStartTime));
    assert(CalendarViewHelper.isSameOrAfterDateTime(appStartTime, appEndTime));

    return RecurrenceHelper.generateRRule(
        recurrenceProperties, appStartTime, appEndTime);
  }

  @override
  // ignore: library_private_types_in_public_api
  _SfCalendarState createState() => _SfCalendarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(headerStyle.toDiagnosticsNode(name: 'headerStyle'));
    properties.add(viewHeaderStyle.toDiagnosticsNode(name: 'viewHeaderStyle'));
    properties.add(
        timeSlotViewSettings.toDiagnosticsNode(name: 'timeSlotViewSettings'));
    properties.add(
        resourceViewSettings.toDiagnosticsNode(name: 'resourceViewSettings'));
    properties
        .add(monthViewSettings.toDiagnosticsNode(name: 'monthViewSettings'));
    properties.add(
        scheduleViewSettings.toDiagnosticsNode(name: 'scheduleViewSettings'));
    if (dataSource != null) {
      properties.add(dataSource!.toDiagnosticsNode(name: 'dataSource'));
    }
    properties
        .add(DiagnosticsProperty<CalendarController>('controller', controller));
    properties.add(DiagnosticsProperty<TextStyle>(
        'appointmentTextStyle', appointmentTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'blackoutDatesTextStyle', blackoutDatesTextStyle));
    properties
        .add(DiagnosticsProperty<TextStyle>('todayTextStyle', todayTextStyle));
    properties.add(EnumProperty<CalendarView>('view', view));
    properties.add(
        DiagnosticsProperty<bool>('allowViewNavigation', allowViewNavigation));
    properties.add(
        DiagnosticsProperty<bool>('showNavigationArrow', showNavigationArrow));
    properties.add(DiagnosticsProperty<ViewNavigationMode>(
        'viewNavigationMode', viewNavigationMode));
    properties.add(DiagnosticsProperty<bool>(
        'showDatePickerButton', showDatePickerButton));
    properties
        .add(DiagnosticsProperty<bool>('showTodayButton', showTodayButton));
    properties.add(DiagnosticsProperty<bool>(
        'showCurrentTimeIndicator', showCurrentTimeIndicator));
    properties.add(IntProperty('firstDayOfWeek', firstDayOfWeek));
    properties.add(DoubleProperty('headerHeight', headerHeight));
    properties.add(DoubleProperty('viewHeaderHeight', viewHeaderHeight));
    properties.add(DoubleProperty('cellEndPadding', cellEndPadding));
    properties.add(
        StringProperty('appointmentTimeTextFormat', appointmentTimeTextFormat));
    properties.add(DiagnosticsProperty<DateTime>(
        'initialDisplayDate', initialDisplayDate));
    properties.add(DiagnosticsProperty<DateTime>(
        'initialSelectedDate', initialSelectedDate));
    properties.add(DiagnosticsProperty<DateTime>('minDate', minDate));
    properties.add(DiagnosticsProperty<DateTime>('maxDate', maxDate));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('todayHighlightColor', todayHighlightColor));
    properties.add(ColorProperty('cellBorderColor', cellBorderColor));
    properties.add(DiagnosticsProperty<ViewChangedCallback>(
        'onViewChanged', onViewChanged));
    properties.add(DiagnosticsProperty<CalendarTapCallback>('onTap', onTap));
    properties.add(DiagnosticsProperty<CalendarLongPressCallback>(
        'onLongPress', onLongPress));
    properties.add(DiagnosticsProperty<CalendarSelectionChangedCallback>(
        'onSelectionChanged', onSelectionChanged));
    properties.add(DiagnosticsProperty<ScheduleViewMonthHeaderBuilder>(
        'scheduleViewMonthHeaderBuilder', scheduleViewMonthHeaderBuilder));
    properties.add(DiagnosticsProperty<MonthCellBuilder>(
        'monthCellBuilder', monthCellBuilder));
    properties.add(DiagnosticsProperty<CalendarAppointmentBuilder>(
        'appointmentBuilder', appointmentBuilder));
    properties.add(DiagnosticsProperty<TimeRegionBuilder>(
        'timeRegionBuilder', timeRegionBuilder));
    properties.add(DiagnosticsProperty<LoadMoreWidgetBuilder>(
        'loadMoreWidgetBuilder', loadMoreWidgetBuilder));
    properties.add(StringProperty('headerDateFormat', headerDateFormat));
    properties.add(DiagnosticsProperty<Decoration>(
        'selectionDecoration', selectionDecoration));
    properties.add(StringProperty('timeZone', timeZone));
    properties.add(IterableDiagnostics<DateTime>(blackoutDates)
        .toDiagnosticsNode(name: 'blackoutDates'));
    properties.add(IterableDiagnostics<CalendarView>(allowedViews)
        .toDiagnosticsNode(name: 'allowedViews'));
    properties.add(IterableDiagnostics<TimeRegion>(specialRegions)
        .toDiagnosticsNode(name: 'specialRegions'));
    properties.add(DiagnosticsProperty<ResourceViewHeaderBuilder>(
        'resourceViewHeaderBuilder', resourceViewHeaderBuilder));
    properties
        .add(DiagnosticsProperty<bool>('allowDragAndDrop', allowDragAndDrop));
    properties.add(
        dragAndDropSettings.toDiagnosticsNode(name: 'dragAndDropSettings'));
    properties.add(DiagnosticsProperty<AppointmentDragStartCallback>(
        'onDragStart', onDragStart));
    properties.add(DiagnosticsProperty<AppointmentDragUpdateCallback>(
        'onDragUpdate', onDragUpdate));
    properties.add(DiagnosticsProperty<AppointmentDragEndCallback>(
        'onDragEnd', onDragEnd));
  }
}

class _SfCalendarState extends State<SfCalendar>
    with SingleTickerProviderStateMixin {
  late List<DateTime> _currentViewVisibleDates;
  late DateTime _currentDate;
  DateTime? _selectedDate;
  List<CalendarAppointment> _visibleAppointments = <CalendarAppointment>[];
  List<AppointmentView> _allDayAppointmentViewCollection = <AppointmentView>[];
  double _allDayPanelHeight = 0;

  /// Used to get the scrolled position to update the header value.
  ScrollController? _agendaScrollController, _resourcePanelScrollController;

  late ValueNotifier<DateTime?> _agendaSelectedDate,
      _timelineMonthWeekNumberNotifier;
  ValueNotifier<DateTime?> _headerUpdateNotifier =
      ValueNotifier<DateTime?>(null);
  late String _locale;
  late SfLocalizations _localizations;
  late double _minWidth, _minHeight, _textScaleFactor;
  late SfCalendarThemeData _calendarTheme;

  /// Holds the framework theme data values and the value assigned on build
  /// method.
  late ThemeData _themeData;
  late ValueNotifier<Offset?> _headerHoverNotifier, _resourceHoverNotifier;
  late ValueNotifier<ScheduleViewHoveringDetails?> _agendaDateNotifier,
      _agendaViewNotifier;

  /// Notifier to repaint the resource view if the image doesn't loaded on
  /// initial load.
  late ValueNotifier<bool> _resourceImageNotifier;

  /// Used to assign the forward list as center of scroll view.
  final Key _scheduleViewKey = UniqueKey();

  /// Used to create the new scroll view for schedule calendar view.
  late Key _scrollKey;

  /// Used to create the custom scroll view that holds calendar views.
  final GlobalKey _customScrollViewKey = GlobalKey();

  /// Used to store the visible dates before the display date
  late List<DateTime> _previousDates;

  /// Used to store the visible dates after the display date
  late List<DateTime> _nextDates;

  /// Used to store the height of each views generated by next dates.
  late Map<int, _ScheduleViewDetails> _forwardWidgetHeights;

  /// Used to store the height of each views generated by previous dates.
  late Map<int, _ScheduleViewDetails> _backwardWidgetHeights;

  /// Used to store the max and min visible date.
  DateTime? _minDate, _maxDate;

  /// Used to store the agenda date view width and the value used on agenda
  /// view generation, tap and long press callbacks and mouse hovering.
  late double _agendaDateViewWidth;

  //// Used to notify the time zone data base loaded or not.
  //// Example, initially appointment added on visible date changed callback then
  //// data source changed listener perform operation but the time zone data base
  //// not initialized, so it makes error.
  late bool _timeZoneLoaded = false;
  List<CalendarAppointment> _appointments = <CalendarAppointment>[];
  late CalendarController _controller;

  /// Used to identify the schedule web view size changed and reformat the
  /// schedule view when the UI changed to mobile UI from web UI or web UI
  /// to mobile UI.
  double? _actualWidth;

  /// Collection used to store the blackout dates and check the collection
  /// manipulations(add, remove).
  List<DateTime>? _blackoutDates;

  late bool _isRTL;
  late CalendarView _view;
  late bool _showHeader;
  late double _calendarViewWidth;
  late ValueNotifier<bool> _viewChangeNotifier;

  /// Used for hold the schedule display date value used for show nothing
  /// planned text on schedule view.
  late DateTime _scheduleDisplayDate;

  /// Used to check the current platform as mobile platform(android or iOS)
  late bool _isMobilePlatform;

  /// Used to check the desktop platform needs mobile platform UI.
  late bool _useMobilePlatformUI;

  /// Fade animation controller to controls fade animation
  AnimationController? _fadeInController;

  /// Fade animation animated on view changing and web view navigation.
  Animation<double>? _fadeIn;

  /// Opacity of widget handles by fade animation.
  final ValueNotifier<double> _opacity = ValueNotifier<double>(1);

  /// Used to identify whether the load more function triggered or not.
  bool _isLoadMoreLoaded = false;

  /// Used to check whether the load more widget needed or not. In schedule
  /// calendar view it denotes the bottom end load more widget.
  bool _isNeedLoadMore = false;

  /// Used to check whether the top end load more needed or not in schedule
  /// calendar view.
  bool _isScheduleStartLoadMore = false;

  /// Holds the schedule view loading min date value. It is used only load more
  /// enabled. This value updated before load more triggered and this value
  /// set to [_minDate] when the load more completed.
  DateTime? _scheduleMinDate;

  /// Holds the schedule view loading max date value. It is used only load more
  /// enabled. This value updated before load more triggered and this value
  /// set to [_maxDate] when the load more completed.
  DateTime? _scheduleMaxDate;

  /// Focus node to maintain the focus for schedule view, when view changed
  final FocusNode _focusNode = FocusNode();

  /// Collection used to store the resource collection and check the collection
  /// manipulations(add, remove, reset).
  List<CalendarResource>? _resourceCollection;

  /// The image painter collection to paint the resource images in view.
  final Map<Object, DecorationImagePainter> _imagePainterCollection =
      <Object, DecorationImagePainter>{};

  /// Used to indicate whether the time slot views(day, week, work week,
  /// timeline views) needs scrolling or not when display date changed.
  /// This value maintain the time slot view scrolling when calendar view
  /// changed and view navigation(forward and backward).
  bool _canScrollTimeSlotView = true;

  @override
  void initState() {
    _timeZoneLoaded = false;
    _showHeader = false;
    _calendarViewWidth = 0;
    initializeDateFormatting();
    _loadDataBase().then((bool value) => _getAppointment());
    _agendaDateNotifier = ValueNotifier<ScheduleViewHoveringDetails?>(null);
    _agendaViewNotifier = ValueNotifier<ScheduleViewHoveringDetails?>(null);
    _resourceImageNotifier = ValueNotifier<bool>(false);
    _headerHoverNotifier = ValueNotifier<Offset?>(null)
      ..addListener(_updateViewHeaderHover);
    _resourceHoverNotifier = ValueNotifier<Offset?>(null)
      ..addListener(_updateViewHeaderHover);
    _controller = widget.controller ?? CalendarController();
    _controller.getCalendarDetailsAtOffset = _getCalendarDetails;
    _controller.selectedDate ??= widget.initialSelectedDate;
    _selectedDate = _controller.selectedDate;
    _agendaSelectedDate = ValueNotifier<DateTime?>(_selectedDate);
    _agendaSelectedDate.addListener(_agendaSelectedDateListener);
    _currentDate = DateTimeHelper.getDateTimeValue(getValidDate(widget.minDate,
        widget.maxDate, _controller.displayDate ?? widget.initialDisplayDate));
    _controller.displayDate = _currentDate;
    _scheduleDisplayDate = _controller.displayDate!;
    _controller.view ??= widget.view;
    _view = _controller.view!;
    _timelineMonthWeekNumberNotifier =
        ValueNotifier<DateTime?>(_controller.displayDate);
    if (_selectedDate != null) {
      _updateSelectionChangedCallback();
    }
    _updateCurrentVisibleDates();
    widget.dataSource?.addListener(_dataSourceChangedListener);
    _resourceCollection =
        CalendarViewHelper.cloneList(widget.dataSource?.resources);
    if (_view == CalendarView.month && widget.monthViewSettings.showAgenda) {
      _agendaScrollController = ScrollController();
    }

    if (CalendarViewHelper.isResourceEnabled(widget.dataSource, _view)) {
      _resourcePanelScrollController = ScrollController();
    }

    _controller.addPropertyChangedListener(_calendarValueChangedListener);
    if (_view == CalendarView.schedule &&
        CalendarViewHelper.shouldRaiseViewChangedCallback(
            widget.onViewChanged)) {
      CalendarViewHelper.raiseViewChangedCallback(
          widget, <DateTime>[_controller.displayDate!]);
    }

    _initScheduleViewProperties();
    _blackoutDates = CalendarViewHelper.cloneList(widget.blackoutDates);
    _viewChangeNotifier = ValueNotifier<bool>(false)
      ..addListener(_updateViewChangePopup);

    _isLoadMoreLoaded = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _textScaleFactor = MediaQuery.of(context).textScaleFactor;
    // default width value will be device width when the widget placed inside a
    // infinity width widget
    _minWidth = MediaQuery.of(context).size.width;
    // default height for the widget when the widget placed inside a infinity
    // height widget
    _minHeight = 300;
    //// localeOf(context) returns the locale from material app when SfCalendar locale value as null
    _locale = Localizations.localeOf(context).toString();
    _localizations = SfLocalizations.of(context);

    _calendarViewWidth = 0;
    _showHeader = false;
    _viewChangeNotifier.removeListener(_updateViewChangePopup);
    _viewChangeNotifier = ValueNotifier<bool>(false)
      ..addListener(_updateViewChangePopup);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfCalendar oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller
          ?.removePropertyChangedListener(_calendarValueChangedListener);
      _controller.removePropertyChangedListener(_calendarValueChangedListener);
      _controller = widget.controller ?? CalendarController();
      if (widget.controller != null) {
        _controller.selectedDate = widget.controller!.selectedDate;
        _controller.displayDate =
            widget.controller!.displayDate ?? _currentDate;
        _scheduleDisplayDate =
            widget.controller!.displayDate ?? _scheduleDisplayDate;
        _controller.view = widget.controller!.view ?? _view;
      } else {
        _controller.selectedDate = widget.initialSelectedDate;
        _currentDate = DateTimeHelper.getDateTimeValue(getValidDate(
            widget.minDate, widget.maxDate, widget.initialDisplayDate));
        _controller.displayDate = _currentDate;
        _controller.view = widget.view;
      }
      _controller.getCalendarDetailsAtOffset = _getCalendarDetails;
      _selectedDate = _controller.selectedDate;
      _view = _controller.view!;
      _controller.addPropertyChangedListener(_calendarValueChangedListener);
    }

    if (oldWidget.controller == widget.controller &&
        widget.controller != null) {
      if (oldWidget.controller!.selectedDate !=
          widget.controller!.selectedDate) {
        _selectedDate = _controller.selectedDate;
        _agendaSelectedDate.value = _controller.selectedDate;
      } else if (oldWidget.controller!.view != widget.controller!.view ||
          _view != widget.controller!.view) {
        final CalendarView oldView = _view;
        _view = _controller.view ?? widget.view;
        _currentDate = DateTimeHelper.getDateTimeValue(getValidDate(
            widget.minDate, widget.maxDate, _updateCurrentDate(oldView)));
        _canScrollTimeSlotView = false;
        _controller.displayDate = _currentDate;
        _canScrollTimeSlotView = true;
        if (_view == CalendarView.schedule) {
          if (CalendarViewHelper.shouldRaiseViewChangedCallback(
              widget.onViewChanged)) {
            CalendarViewHelper.raiseViewChangedCallback(
                widget, <DateTime>[_controller.displayDate!]);
          }

          _agendaScrollController?.removeListener(_handleScheduleViewScrolled);
          _initScheduleViewProperties();
        }
      }
    }

    if (oldWidget.scheduleViewSettings.hideEmptyScheduleWeek !=
        widget.scheduleViewSettings.hideEmptyScheduleWeek) {
      _previousDates.clear();
      _nextDates.clear();
      _backwardWidgetHeights.clear();
      _forwardWidgetHeights.clear();
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        _handleScheduleViewScrolled();
      });
    }

    if (oldWidget.controller == widget.controller &&
        widget.controller != null &&
        oldWidget.controller!.displayDate != widget.controller!.displayDate) {
      if (_controller.displayDate != null) {
        _currentDate = DateTimeHelper.getDateTimeValue(getValidDate(
            widget.minDate, widget.maxDate, _controller.displayDate));
      }

      _controller.displayDate = _currentDate;
      _scheduleDisplayDate = _currentDate;
    }

    if ((widget.loadMoreWidgetBuilder == null &&
            oldWidget.loadMoreWidgetBuilder != null) ||
        (widget.loadMoreWidgetBuilder != null &&
            oldWidget.loadMoreWidgetBuilder == null)) {
      _scrollKey = UniqueKey();
      _nextDates = <DateTime>[];
      _previousDates = <DateTime>[];
      if (_view == CalendarView.schedule) {
        _headerUpdateNotifier = ValueNotifier<DateTime>(_scheduleDisplayDate);
      } else if (widget.loadMoreWidgetBuilder != null && !_isNeedLoadMore) {
        _isNeedLoadMore = true;
      }
      _forwardWidgetHeights = <int, _ScheduleViewDetails>{};
      _backwardWidgetHeights = <int, _ScheduleViewDetails>{};
      _agendaScrollController = ScrollController()
        ..addListener(_handleScheduleViewScrolled);
      _scheduleMaxDate = null;
      _scheduleMinDate = null;
      _minDate = null;
      _maxDate = null;
    }

    if (!CalendarViewHelper.isDateCollectionEqual(
        widget.blackoutDates, _blackoutDates)) {
      _blackoutDates = CalendarViewHelper.cloneList(widget.blackoutDates);
    }

    if (_agendaSelectedDate.value != _selectedDate) {
      _agendaSelectedDate.value = _selectedDate;
    }

    if (oldWidget.timeZone != widget.timeZone) {
      _updateVisibleAppointments();
    }

    if (widget.monthViewSettings.numberOfWeeksInView !=
        oldWidget.monthViewSettings.numberOfWeeksInView) {
      _currentDate = DateTimeHelper.getDateTimeValue(getValidDate(
          widget.minDate, widget.maxDate, _updateCurrentDate(_view)));
      _controller.displayDate = _currentDate;
      if (_view == CalendarView.schedule) {
        if (CalendarViewHelper.shouldRaiseViewChangedCallback(
            widget.onViewChanged)) {
          CalendarViewHelper.raiseViewChangedCallback(
              widget, <DateTime>[_controller.displayDate!]);
        }

        _agendaScrollController?.removeListener(_handleScheduleViewScrolled);
        _initScheduleViewProperties();
      }
    }

    if (CalendarViewHelper.isResourceEnabled(widget.dataSource, _view)) {
      _resourcePanelScrollController ??= ScrollController();
    }

    if (_view == CalendarView.month &&
        widget.monthViewSettings.showTrailingAndLeadingDates !=
            oldWidget.monthViewSettings.showTrailingAndLeadingDates) {
      _visibleAppointments = <CalendarAppointment>[];
      _updateVisibleAppointments();
    }

    if (oldWidget.dataSource != widget.dataSource) {
      _getAppointment();
      oldWidget.dataSource?.removeListener(_dataSourceChangedListener);
      widget.dataSource?.addListener(_dataSourceChangedListener);

      if (CalendarViewHelper.isResourceEnabled(widget.dataSource, _view)) {
        _resourcePanelScrollController ??= ScrollController();
      }

      _removeScheduleViewAppointmentDates();
      _loadScheduleViewAppointmentDates(_appointments);
    }

    if (!CalendarViewHelper.isCollectionEqual(
        widget.dataSource?.resources, _resourceCollection)) {
      _resourceCollection =
          CalendarViewHelper.cloneList(widget.dataSource?.resources);
    }

    if (oldWidget.minDate != widget.minDate ||
        oldWidget.maxDate != widget.maxDate) {
      _currentDate = DateTimeHelper.getDateTimeValue(
          getValidDate(widget.minDate, widget.maxDate, _currentDate));
      if (_view == CalendarView.schedule) {
        _minDate = null;
        _maxDate = null;
        if (widget.loadMoreWidgetBuilder != null &&
            _scheduleMinDate != null &&
            _scheduleMaxDate != null) {
          _scheduleMinDate = DateTimeHelper.getDateTimeValue(
              getValidDate(widget.minDate, widget.maxDate, _scheduleMinDate));
          _scheduleMaxDate = DateTimeHelper.getDateTimeValue(
              getValidDate(widget.minDate, widget.maxDate, _scheduleMaxDate));
        }
      }
    }

    if (_view == CalendarView.month &&
        widget.monthViewSettings.showAgenda &&
        _agendaScrollController == null) {
      _agendaScrollController = ScrollController();
    }

    _showHeader = false;
    _calendarViewWidth = 0;
    _viewChangeNotifier.removeListener(_updateViewChangePopup);
    _viewChangeNotifier = ValueNotifier<bool>(false)
      ..addListener(_updateViewChangePopup);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double height;
    _isRTL = CalendarViewHelper.isRTLLayout(context);
    _themeData = Theme.of(context);
    _calendarTheme =
        _getThemeDataValue(SfCalendarTheme.of(context), _themeData);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      _minWidth = constraints.maxWidth == double.infinity
          ? _minWidth
          : constraints.maxWidth;
      _minHeight = constraints.maxHeight == double.infinity
          ? _minHeight
          : constraints.maxHeight;

      _isMobilePlatform =
          CalendarViewHelper.isMobileLayout(Theme.of(context).platform);
      _useMobilePlatformUI =
          CalendarViewHelper.isMobileLayoutUI(_minWidth, _isMobilePlatform);

      _fadeInController ??= AnimationController(
          duration: Duration(milliseconds: _isMobilePlatform ? 500 : 600),
          vsync: this)
        ..addListener(_updateFadeAnimation);
      _fadeIn ??= Tween<double>(
        begin: 0.1,
        end: 1,
      ).animate(CurvedAnimation(
        parent: _fadeInController!,
        curve: Curves.easeIn,
      ));

      /// Check the schedule view changes from mobile view to web view or
      /// web view to mobile view.
      if (_view == CalendarView.schedule &&
          _actualWidth != null &&
          _useMobilePlatformUI !=
              CalendarViewHelper.isMobileLayoutUI(
                  _actualWidth!, _isMobilePlatform) &&
          _nextDates.isNotEmpty) {
        _agendaScrollController?.removeListener(_handleScheduleViewScrolled);
        _initScheduleViewProperties();
      }

      _actualWidth = _minWidth;
      height = _minHeight;

      _agendaDateViewWidth = _minWidth * 0.15;

      /// Restrict the maximum agenda date view width to 60 on web view.
      if (_agendaDateViewWidth > 60 && !_isMobilePlatform) {
        _agendaDateViewWidth = 60;
      }

      height -= widget.headerHeight;
      final double agendaHeight =
          _view == CalendarView.month && widget.monthViewSettings.showAgenda
              ? _getMonthAgendaHeight()
              : 0;

      return GestureDetector(
        child: Container(
          width: _minWidth,
          height: _minHeight,
          color: widget.backgroundColor ?? _calendarTheme.backgroundColor,
          child: _view == CalendarView.schedule
              ? widget.loadMoreWidgetBuilder == null
                  ? addAgenda(height, _isRTL)
                  : addAgendaWithLoadMore(height, _isRTL)
              : _addChildren(agendaHeight, height, _minWidth, _isRTL),
        ),
        onTap: () {
          _removeDatePicker();
        },
      );
    });
  }

  /// Get the calendar details by using the [getCalendarDetailsAtOffset] in
  /// SfCalendar.
  CalendarDetails? _getCalendarDetails(Offset position) {
    if (position.dy < widget.headerHeight) {
      /// Return calendar details while the [getCalendarDetailsAtOffset]
      /// position placed on header.
      return CalendarDetails(
          null, _getTappedHeaderDate(), CalendarElement.header, null);
    } else if (position.dy > _minHeight &&
        (position.dx < 0 || position.dx > _minWidth)) {
      // Return null value when the position placed on
      // out of the calendar.
      return null;
    }

    final Offset updatedPosition =
        Offset(position.dx, position.dy - widget.headerHeight);

    switch (_controller.view!) {
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          return (_customScrollViewKey.currentWidget!
                  as CustomCalendarScrollView)
              .getCalendarDetails(updatedPosition);
        }
      case CalendarView.month:
        {
          if (widget.monthViewSettings.showAgenda) {
            final double agendaHeight = _getMonthAgendaHeight();
            if (position.dy > _minHeight - agendaHeight) {
              DateTime? currentSelectedDate;
              if (_selectedDate != null) {
                currentSelectedDate = isDateWithInDateRange(
                            widget.minDate, widget.maxDate, _selectedDate) &&
                        !CalendarViewHelper.isDateInDateCollection(
                            _blackoutDates, _selectedDate!)
                    ? _selectedDate
                    : null;
              }

              if (currentSelectedDate == null) {
                return const CalendarDetails(
                    null, null, CalendarElement.agenda, null);
              }

              final List<dynamic> selectedAppointments =
                  _getSelectedAppointments(
                      Offset(position.dx,
                          position.dy - (_minHeight - agendaHeight)),
                      currentSelectedDate);

              /// Return calendar details while the [getCalendarDetailsAtOffset]
              /// position placed on agenda in month view.
              return CalendarDetails(
                  selectedAppointments,
                  currentSelectedDate,
                  selectedAppointments.isNotEmpty
                      ? CalendarElement.appointment
                      : CalendarElement.agenda,
                  null);
            }
          }

          return (_customScrollViewKey.currentWidget!
                  as CustomCalendarScrollView)
              .getCalendarDetails(updatedPosition);
        }
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
        {
          final bool isResourceEnabled =
              CalendarViewHelper.isResourceEnabled(widget.dataSource, _view);
          final double resourceViewSize =
              isResourceEnabled ? widget.resourceViewSettings.size : 0;
          if ((!_isRTL && updatedPosition.dx < resourceViewSize) ||
              (_isRTL && updatedPosition.dx > _minWidth - resourceViewSize)) {
            final double viewHeaderHeight =
                CalendarViewHelper.getViewHeaderHeight(
                    widget.viewHeaderHeight, _view);
            final double timeLabelSize = CalendarViewHelper.getTimeLabelWidth(
                widget.timeSlotViewSettings.timeRulerSize, _view);
            final double top = viewHeaderHeight + timeLabelSize;
            // Return null value when the position placed on empty space
            // on view header above the resource view.
            if (updatedPosition.dy < top) {
              return null;
            }
            final double resourceItemHeight =
                CalendarViewHelper.getResourceItemHeight(
                    resourceViewSize,
                    _minHeight - top,
                    widget.resourceViewSettings,
                    _resourceCollection!.length);

            final CalendarResource resource = _getTappedResource(
                updatedPosition.dy - top, resourceItemHeight);
            final List<dynamic> resourceAppointments =
                _getSelectedResourceAppointments(resource);

            /// Return calendar details while the [getCalendarDetailsAtOffset]
            /// position placed on resource header in timeline views.
            return CalendarDetails(resourceAppointments, null,
                CalendarElement.resourceHeader, resource);
          }

          return (_customScrollViewKey.currentWidget!
                  as CustomCalendarScrollView)
              .getCalendarDetails(Offset(
                  _isRTL
                      ? updatedPosition.dx
                      : updatedPosition.dx - resourceViewSize,
                  updatedPosition.dy));
        }
      case CalendarView.schedule:
        return _getScheduleViewDetails(updatedPosition);
    }
  }

  //// Get the calendar details for schedule view in SfCalendar.
  CalendarDetails? _getScheduleViewDetails(Offset position) {
    /// Assign display date and today date,
    /// schedule display date always hold the minimum date compared to
    /// display date and today date.
    /// schedule current date always hold the maximum date compared to
    /// display date and today date
    DateTime scheduleDisplayDate = _scheduleDisplayDate;
    DateTime scheduleCurrentDate = DateTime.now();
    if (scheduleDisplayDate.isAfter(scheduleCurrentDate)) {
      final DateTime tempDate = scheduleDisplayDate;
      scheduleDisplayDate = scheduleCurrentDate;
      scheduleCurrentDate = tempDate;
    }

    final double yPosition =
        _agendaScrollController!.position.pixels + position.dy;
    double viewStartPosition = 0;
    int index = -1;
    if (yPosition >= 0) {
      for (int i = 0; i < _forwardWidgetHeights.length; i++) {
        if (viewStartPosition <= yPosition &&
            yPosition < _forwardWidgetHeights[i]!._height) {
          index = i;
          break;
        }

        viewStartPosition = _forwardWidgetHeights[i]!._height;
      }

      if (index == -1) {
        index = _forwardWidgetHeights.length - 1;
        viewStartPosition = _forwardWidgetHeights[index]!._height;
      }
    } else {
      for (int i = 0; i < _backwardWidgetHeights.length; i++) {
        if (viewStartPosition > yPosition &&
            yPosition >= -_backwardWidgetHeights[i]!._height) {
          index = i;
          viewStartPosition = -_backwardWidgetHeights[i]!._height;
          break;
        }

        viewStartPosition = -_backwardWidgetHeights[i]!._height;
      }

      if (index == -1) {
        index = _backwardWidgetHeights.length - 1;
        viewStartPosition = -_backwardWidgetHeights[index]!._height;
      }
    }

    final DateTime startDate =
        yPosition >= 0 ? _nextDates[index] : _previousDates[index];

    /// Set previous date form it date collection if index is first index of
    /// next dates collection then get the start date from previous dates.
    /// If the index as last index of previous dates collection then calculate
    /// by subtract the 7 days to get previous date.
    final DateTime prevDate = yPosition >= 0 && index == 0
        ? _previousDates.isEmpty
            ? DateTimeHelper.getDateTimeValue(
                addDays(startDate, -DateTime.daysPerWeek))
            : _previousDates[0]
        : (yPosition >= 0 && index > 0
            ? _nextDates[index - 1]
            : index >= _previousDates.length - 1
                ? DateTimeHelper.getDateTimeValue(
                    addDays(startDate, -DateTime.daysPerWeek))
                : _previousDates[index + 1]);
    final DateTime prevEndDate =
        DateTimeHelper.getDateTimeValue(addDays(prevDate, 6));
    final DateTime endDate =
        DateTimeHelper.getDateTimeValue(addDays(startDate, 6));

    /// Get the visible week appointment and split the appointments based on
    /// date.
    final List<CalendarAppointment> appointmentCollection =
        AppointmentHelper.getVisibleAppointments(
            isSameOrAfterDate(_minDate, startDate) ? startDate : _minDate!,
            isSameOrBeforeDate(_maxDate, endDate) ? endDate : _maxDate!,
            _appointments,
            widget.timeZone,
            false,
            canCreateNewAppointment: false);
    appointmentCollection.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            app1.actualStartTime.compareTo(app2.actualStartTime));

    /// Get the collection of appointment collection listed by date.
    final Map<DateTime, List<CalendarAppointment>> dateAppointments =
        _getAppointmentCollectionOnDateBasis(
            appointmentCollection, startDate, endDate);
    final List<DateTime> dateAppointmentKeys = dateAppointments.keys.toList();
    const double padding = 5;

    /// Check the current week view show display date or current date view.
    bool isNeedDisplayDateHighlight =
        isDateWithInDateRange(startDate, endDate, scheduleDisplayDate);
    bool isNeedCurrentDateHighlight =
        isDateWithInDateRange(startDate, endDate, scheduleCurrentDate) &&
            !isSameDate(scheduleDisplayDate, scheduleCurrentDate);

    /// Check the schedule display date have appointments if display date
    /// in between the week
    if (isNeedDisplayDateHighlight) {
      for (int i = 0; i < dateAppointmentKeys.length; i++) {
        if (!isSameDate(scheduleDisplayDate, dateAppointmentKeys[i])) {
          continue;
        }

        isNeedDisplayDateHighlight = false;
        break;
      }
    }

    /// Check the schedule current date have appointments if current date
    /// in between the week
    if (isNeedCurrentDateHighlight) {
      for (int i = 0; i < dateAppointmentKeys.length; i++) {
        if (!isSameDate(scheduleCurrentDate, dateAppointmentKeys[i])) {
          continue;
        }

        isNeedCurrentDateHighlight = false;
        break;
      }
    }

    /// calculate the day label(eg., May 25) width based on schedule setting.
    final double viewPadding = _getAgendaViewDayLabelWidth(
        widget.scheduleViewSettings, _useMobilePlatformUI);

    final double viewTopPadding = _useMobilePlatformUI ? padding : 0;

    /// It is used to current view top position inside the collection of views.
    double topPosition = viewStartPosition;

    /// Check the week date needs month header at first or before of appointment
    /// view.
    final bool isNeedMonthBuilder = _useMobilePlatformUI &&
        (prevEndDate.month != startDate.month ||
            prevEndDate.year != startDate.year);

    final double appointmentViewHeight =
        CalendarViewHelper.getScheduleAppointmentHeight(
            null, widget.scheduleViewSettings);
    final double allDayAppointmentHeight =
        CalendarViewHelper.getScheduleAllDayAppointmentHeight(
            null, widget.scheduleViewSettings);

    /// Calculate the divider height and color when it is web view.
    final double dividerHeight = _useMobilePlatformUI ? 0 : 1;

    /// Web view does not have month label.
    if (_useMobilePlatformUI) {
      if (isNeedMonthBuilder) {
        /// Add the height of month label to total height of view.
        double currentViewHeight =
            widget.scheduleViewSettings.monthHeaderSettings.height;

        /// Add the week label padding value to top position and total height.
        /// padding only added between the month and week header.
        currentViewHeight += viewTopPadding;
        if (topPosition <= yPosition &&
            topPosition + currentViewHeight > yPosition) {
          /// Return calendar details while the [getCalendarDetailsAtOffset]
          /// position placed on header in schedule view.
          return CalendarDetails(
              null,
              DateTime(startDate.year, startDate.month),
              CalendarElement.header,
              null);
        }

        topPosition += currentViewHeight;
      }

      /// Add the height of week label to update the top position of next view.
      final double weekHeaderHeight =
          widget.scheduleViewSettings.weekHeaderSettings.height;
      if (topPosition <= yPosition &&
          topPosition + weekHeaderHeight > yPosition) {
        /// Return calendar details while the [getCalendarDetailsAtOffset]
        /// position placed on view header in schedule view.
        return CalendarDetails(
            null,
            DateTime(startDate.year, startDate.month, startDate.day),
            CalendarElement.viewHeader,
            null);
      }

      topPosition += weekHeaderHeight;
    }

    /// Calculate the day label(May, 25) height based on appointment height and
    /// assign the label maximum height as 60.
    double appointmentViewHeaderHeight = appointmentViewHeight + (2 * padding);
    if (_useMobilePlatformUI) {
      appointmentViewHeaderHeight =
          appointmentViewHeaderHeight > 60 ? 60 : appointmentViewHeaderHeight;
    }

    /// Check the week date needs month header at in between the appointment
    /// views.
    bool isNeedInBetweenMonthBuilder = _useMobilePlatformUI &&
        (startDate.month !=
            (isSameOrBeforeDate(_maxDate, endDate) ? endDate : _maxDate!)
                .month);

    /// Check the end date month have appointments or not.
    bool isNextMonthHasNoAppointment = false;
    if (isNeedInBetweenMonthBuilder) {
      final DateTime? lastAppointmentDate = dateAppointmentKeys.isNotEmpty
          ? dateAppointmentKeys[dateAppointmentKeys.length - 1]
          : null;
      final DateTime? nextWeekDate = index == -1
          ? _nextDates[0]
          : (index < 0
              ? _previousDates[-index - 2]
              : index >= _nextDates.length - 1
                  ? null
                  : _nextDates[index + 1]);

      /// Check the following scenarios for rendering month label at last when
      /// the week holds different month dates
      /// 1. If the week does not have an appointments.
      /// 2. If the week have appointments but next month dates does not have
      /// an appointments
      /// 3. If the week have appointments but next month dates does not have
      /// an appointments but [hideEmptyScheduleWeek] enabled so the next view
      /// date month as different with current week end date week.
      isNextMonthHasNoAppointment = lastAppointmentDate == null ||
          (lastAppointmentDate.month != endDate.month &&
              nextWeekDate != null &&
              nextWeekDate.month == endDate.month &&
              nextWeekDate.year == endDate.year);

      isNeedInBetweenMonthBuilder = isNextMonthHasNoAppointment ||
          lastAppointmentDate.month != startDate.month;
    }

    /// display date highlight added boolean variable used to identify the
    /// display date view added or not.
    bool isDisplayDateHighlightAdded = !isNeedDisplayDateHighlight;

    /// current date highlight added boolean variable used to identify the
    /// current date view added or not.
    bool isCurrentDateHighlightAdded = !isNeedCurrentDateHighlight;

    CalendarDetails triggerDisplayDateDetails(DateTime date) {
      if ((!_isRTL && viewPadding >= position.dx) ||
          (_isRTL && _minWidth - viewPadding < position.dx)) {
        /// Return calendar details while the [getCalendarDetailsAtOffset]
        /// position placed on view header in schedule view.
        return CalendarDetails(null, date, CalendarElement.viewHeader, null);
      } else {
        /// Return calendar details while the [getCalendarDetailsAtOffset]
        /// position placed on calendar cell in schedule view.
        return CalendarDetails(null, date, CalendarElement.calendarCell, null);
      }
    }

    bool isMonthHeaderAddedOnView = false;

    /// Generate views on week days that have appointments.
    for (int i = 0; i < dateAppointmentKeys.length; i++) {
      final DateTime currentDate = dateAppointmentKeys[i];
      final List<CalendarAppointment> currentAppointments =
          dateAppointments[currentDate]!;
      final int eventsCount = currentAppointments.length;
      int allDayEventCount = 0;

      /// Web view does not differentiate all day and normal appointment.
      if (_useMobilePlatformUI) {
        allDayEventCount = _getAllDayCount(currentAppointments);
      }

      /// Check the display date view not added in widget and appointment
      /// date is after of display date then add the display date view.
      /// Checking the current date month and display date month is required
      /// Eg., if week (Feb 28 - Mar 6), Feb 28 does not have appointments
      /// and Feb 28 is display date and Mar 1 have appointments then the view
      /// order is month header(march), display date(feb 28), So check whether
      /// current date(Mar 1) month not equal then add the display date view
      /// before month header.
      if (!isDisplayDateHighlightAdded &&
          currentDate.isAfter(scheduleDisplayDate) &&
          currentDate.month != scheduleDisplayDate.month) {
        isDisplayDateHighlightAdded = true;

        /// Add intersect value with appointment height and divider height
        /// because display date view height as single appointment view height
        final double displayDateHeight =
            appointmentViewHeaderHeight + dividerHeight;
        if (topPosition <= yPosition &&
            topPosition + displayDateHeight > yPosition) {
          return triggerDisplayDateDetails(scheduleDisplayDate);
        }

        topPosition += displayDateHeight;
      }

      /// Check the current date view not added in widget and appointment
      /// date is after of current date then add the current date view.
      /// Checking the current date month and today date month is required
      /// Eg., if week (Feb 28 - Mar 6), Feb 28 does not have appointments
      /// and Feb 28 is today date and Mar 1 have appointments then the view
      /// order is month header(march), today date(feb 28), So check whether
      /// current date(Mar 1) month not equal then add the today date view
      /// before month header.
      if (!isCurrentDateHighlightAdded &&
          currentDate.isAfter(scheduleCurrentDate) &&
          currentDate.month != scheduleCurrentDate.month) {
        isCurrentDateHighlightAdded = true;

        /// Add intersect value with appointment height and divider height
        /// because display date view height as single appointment view height
        final double todayHeight = appointmentViewHeaderHeight + dividerHeight;
        if (topPosition <= yPosition && topPosition + todayHeight > yPosition) {
          return triggerDisplayDateDetails(scheduleCurrentDate);
        }

        topPosition += todayHeight;
      }

      /// Check if the view intersection point not set and the current week date
      /// month differ from the week start date then assign the intersection
      /// point.
      if (!isMonthHeaderAddedOnView &&
          _useMobilePlatformUI &&
          (startDate.month != currentDate.month ||
              startDate.year != currentDate.year)) {
        final double monthHeaderHeight =
            widget.scheduleViewSettings.monthHeaderSettings.height +
                viewTopPadding;
        if (topPosition <= yPosition &&
            topPosition + monthHeaderHeight > yPosition) {
          /// Return calendar details while the [getCalendarDetailsAtOffset]
          /// position placed on header in schedule view.
          return CalendarDetails(
              null,
              DateTime(currentDate.year, currentDate.month),
              CalendarElement.header,
              null);
        }

        topPosition += monthHeaderHeight;
        isMonthHeaderAddedOnView = true;
      }

      /// Check the display date view not added in widget and appointment
      /// date is after of display date then add the display date view.
      if (!isDisplayDateHighlightAdded &&
          currentDate.isAfter(scheduleDisplayDate)) {
        isDisplayDateHighlightAdded = true;

        /// Add intersect value with appointment height and divider height
        /// because display date view height as single appointment view height
        final double displayDateHeight =
            appointmentViewHeaderHeight + dividerHeight;
        if (topPosition <= yPosition &&
            topPosition + displayDateHeight > yPosition) {
          return triggerDisplayDateDetails(scheduleDisplayDate);
        }

        topPosition += displayDateHeight;
      }

      /// Check the current date view not added in widget and appointment
      /// date is after of current date then add the current date view.
      if (!isCurrentDateHighlightAdded &&
          currentDate.isAfter(scheduleCurrentDate)) {
        isCurrentDateHighlightAdded = true;

        /// Add intersect value with appointment height and divider height
        /// because display date view height as single appointment view height
        final double currentDateHeight =
            appointmentViewHeaderHeight + dividerHeight;
        if (topPosition <= yPosition &&
            topPosition + currentDateHeight > yPosition) {
          return triggerDisplayDateDetails(scheduleCurrentDate);
        }

        topPosition += currentDateHeight;
      }

      final double totalPadding = (eventsCount + 1) * padding;
      final double panelHeight = totalPadding +
          ((eventsCount - allDayEventCount) * appointmentViewHeight) +
          (allDayEventCount * allDayAppointmentHeight);
      double appointmentViewPadding = 0;
      if (panelHeight < appointmentViewHeaderHeight) {
        appointmentViewPadding = appointmentViewHeaderHeight - panelHeight;
      }

      if (topPosition <= yPosition &&
          yPosition <
              topPosition +
                  panelHeight +
                  appointmentViewPadding +
                  dividerHeight) {
        currentAppointments.sort(
            (CalendarAppointment app1, CalendarAppointment app2) =>
                app1.actualStartTime.compareTo(app2.actualStartTime));
        currentAppointments.sort(
            (CalendarAppointment app1, CalendarAppointment app2) =>
                AppointmentHelper.orderAppointmentsAscending(
                    app1.isAllDay, app2.isAllDay));
        currentAppointments.sort(
            (CalendarAppointment app1, CalendarAppointment app2) =>
                AppointmentHelper.orderAppointmentsAscending(
                    app1.isSpanned, app2.isSpanned));

        if ((!_isRTL && viewPadding >= position.dx) ||
            (_isRTL && _minWidth - viewPadding < position.dx)) {
          final List<CalendarAppointment> currentAppointments =
              <CalendarAppointment>[];
          for (int i = 0; i < currentAppointments.length; i++) {
            final CalendarAppointment appointment = currentAppointments[i];
            currentAppointments.add(appointment);
          }

          /// Return calendar details while the [getCalendarDetailsAtOffset]
          /// position placed on view header in schedule view.
          return CalendarDetails(
              widget.dataSource != null &&
                      !AppointmentHelper.isCalendarAppointment(
                          widget.dataSource!)
                  ? CalendarViewHelper.getCustomAppointments(
                      currentAppointments, widget.dataSource)
                  : currentAppointments,
              DateTime(currentDate.year, currentDate.month, currentDate.day),
              CalendarElement.viewHeader,
              null);
        } else {
          /// Calculate the touch position appointment from its collection.
          double currentYPosition = topPosition + padding;
          for (int k = 0; k < currentAppointments.length; k++) {
            final CalendarAppointment appointment = currentAppointments[k];
            final double currentAppointmentHeight =
                (_useMobilePlatformUI && _isAllDayAppointmentView(appointment)
                        ? allDayAppointmentHeight
                        : appointmentViewHeight) +
                    padding;
            if (currentYPosition <= yPosition &&
                currentYPosition + currentAppointmentHeight > yPosition) {
              final List<CalendarAppointment> selectedAppointment =
                  <CalendarAppointment>[appointment];

              /// Return calendar details while the [getCalendarDetailsAtOffset]
              /// position placed on appointment in schedule view.
              return CalendarDetails(
                  widget.dataSource != null &&
                          !AppointmentHelper.isCalendarAppointment(
                              widget.dataSource!)
                      ? CalendarViewHelper.getCustomAppointments(
                          selectedAppointment, widget.dataSource)
                      : selectedAppointment,
                  DateTime(
                      currentDate.year, currentDate.month, currentDate.day),
                  CalendarElement.appointment,
                  null);
            }

            currentYPosition += currentAppointmentHeight;
          }
        }
      }

      topPosition += panelHeight + appointmentViewPadding + dividerHeight;
    }

    /// Check the display date view not added when it month value not equal to
    /// end date month value.
    if (!isDisplayDateHighlightAdded &&
        endDate.month != scheduleDisplayDate.month) {
      /// Add the top height value with display date view height because the
      /// month header added after the display date view added and its
      /// intersect point calculated based on top height.
      final double displayDateHeight =
          appointmentViewHeaderHeight + dividerHeight;
      if (topPosition <= yPosition &&
          topPosition + displayDateHeight > yPosition) {
        return triggerDisplayDateDetails(scheduleDisplayDate);
      }

      topPosition += displayDateHeight;
      isDisplayDateHighlightAdded = true;
    }

    /// Check the current date view not added when it month value not equal to
    /// end date month value.
    if (!isCurrentDateHighlightAdded &&
        endDate.month != scheduleCurrentDate.month) {
      /// Add the top height value with current date view height because the
      /// month header added after the current date view added and its
      /// intersect point calculated based on top height.
      final double currentDateHeight =
          appointmentViewHeaderHeight + dividerHeight;
      if (topPosition <= yPosition &&
          topPosition + currentDateHeight > yPosition) {
        return triggerDisplayDateDetails(scheduleCurrentDate);
      }

      topPosition += currentDateHeight;
      isCurrentDateHighlightAdded = true;
    }

    /// Web view does not have month label.
    /// Add Month label at end of the view when the week start and end date
    /// month different and week does not have appointments or week have
    /// appointments but end date month dates does not have an appointment
    if (_useMobilePlatformUI &&
        isNeedInBetweenMonthBuilder &&
        isNextMonthHasNoAppointment &&
        isSameOrBeforeDate(_maxDate, endDate)) {
      /// Calculate and assign the intersection point because the current
      /// view holds next month label. if scrolling reaches this position
      /// then we update the header date so add the location to intersecting
      /// point.
      final double monthHeaderHeight =
          widget.scheduleViewSettings.monthHeaderSettings.height +
              viewTopPadding;
      if (topPosition <= yPosition &&
          topPosition + monthHeaderHeight > yPosition) {
        /// Return calendar details while the [getCalendarDetailsAtOffset]
        /// position placed on header in schedule view.
        return CalendarDetails(null, DateTime(endDate.year, endDate.month),
            CalendarElement.header, null);
      }
      topPosition += monthHeaderHeight;
    }

    /// Add the display date view at end of week view when
    /// it does not added to widget.
    if (!isDisplayDateHighlightAdded) {
      final double displayDateHeight =
          appointmentViewHeaderHeight + dividerHeight;
      if (topPosition <= yPosition &&
          topPosition + displayDateHeight > yPosition) {
        return triggerDisplayDateDetails(scheduleDisplayDate);
      }

      topPosition += displayDateHeight;
      isDisplayDateHighlightAdded = true;
    }

    /// Add the current date view at end of week view
    /// when it does not added to widget.
    if (!isCurrentDateHighlightAdded) {
      final double currentDateHeight =
          appointmentViewHeaderHeight + dividerHeight;
      if (topPosition <= yPosition &&
          topPosition + currentDateHeight > yPosition) {
        return triggerDisplayDateDetails(scheduleCurrentDate);
      }

      topPosition += currentDateHeight;
      isCurrentDateHighlightAdded = true;
    }

    return null;
  }

  @override
  void dispose() {
    if (_agendaScrollController != null) {
      _agendaScrollController!.removeListener(_handleScheduleViewScrolled);
      _agendaScrollController!.dispose();
      _agendaScrollController = null;
    }

    if (_resourcePanelScrollController != null) {
      _resourcePanelScrollController!.dispose();
      _resourcePanelScrollController = null;
    }

    _headerHoverNotifier.removeListener(_updateViewHeaderHover);
    _agendaDateNotifier.removeListener(_agendaSelectedDateListener);
    _resourceHoverNotifier.removeListener(_updateViewHeaderHover);

    _disposeResourceImagePainter();

    if (widget.dataSource != null) {
      widget.dataSource!.removeListener(_dataSourceChangedListener);
    }

    if (_fadeInController != null) {
      _fadeInController!.removeListener(_updateFadeAnimation);
      _fadeInController!.dispose();
      _fadeInController = null;
    }

    if (_fadeIn != null) {
      _fadeIn = null;
    }

    _controller.removePropertyChangedListener(_calendarValueChangedListener);
    _viewChangeNotifier.removeListener(_updateViewChangePopup);
    _viewChangeNotifier.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  SfCalendarThemeData _getThemeDataValue(
      SfCalendarThemeData calendarThemeData, ThemeData themeData) {
    final ColorScheme colorScheme = themeData.colorScheme;
    return calendarThemeData.copyWith(
        brightness: calendarThemeData.brightness ?? colorScheme.brightness,
        backgroundColor:
            calendarThemeData.backgroundColor ?? Colors.transparent,
        headerBackgroundColor:
            calendarThemeData.headerBackgroundColor ?? Colors.transparent,
        agendaBackgroundColor:
            calendarThemeData.agendaBackgroundColor ?? Colors.transparent,
        activeDatesBackgroundColor:
            calendarThemeData.activeDatesBackgroundColor ?? Colors.transparent,
        todayBackgroundColor:
            calendarThemeData.todayBackgroundColor ?? Colors.transparent,
        trailingDatesBackgroundColor:
            calendarThemeData.trailingDatesBackgroundColor ??
                Colors.transparent,
        leadingDatesBackgroundColor:
            calendarThemeData.leadingDatesBackgroundColor ?? Colors.transparent,
        viewHeaderBackgroundColor:
            calendarThemeData.viewHeaderBackgroundColor ?? Colors.transparent,
        allDayPanelColor:
            calendarThemeData.allDayPanelColor ?? Colors.transparent,
        // ignore: lines_longer_than_80_chars
        weekNumberBackgroundColor:
            calendarThemeData.weekNumberBackgroundColor ??
                colorScheme.onSurface.withOpacity(0.04),
        cellBorderColor: calendarThemeData.cellBorderColor ??
            colorScheme.onSurface.withOpacity(0.16),
        todayHighlightColor:
            calendarThemeData.todayHighlightColor ?? colorScheme.primary,
        selectionBorderColor:
            calendarThemeData.selectionBorderColor ?? colorScheme.primary,
        blackoutDatesTextStyle: calendarThemeData.blackoutDatesTextStyle == null
            ? widget.blackoutDatesTextStyle
            : calendarThemeData.blackoutDatesTextStyle
                ?.merge(widget.blackoutDatesTextStyle),
        trailingDatesTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.54),
              fontSize: 13,
            )
            .merge(calendarThemeData.trailingDatesTextStyle)
            .merge(
                widget.monthViewSettings.monthCellStyle.trailingDatesTextStyle),
        leadingDatesTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.54),
              fontSize: 13,
            )
            .merge(calendarThemeData.leadingDatesTextStyle)
            .merge(
                widget.monthViewSettings.monthCellStyle.leadingDatesTextStyle),
        todayTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onPrimary,
              fontSize: 13,
            )
            .merge(calendarThemeData.todayTextStyle)
            .merge(widget.todayTextStyle),
        headerTextStyle: themeData.textTheme.bodyLarge!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 18,
              fontWeight: FontWeight.w400,
            )
            // ignore: lines_longer_than_80_chars
            .merge(calendarThemeData.headerTextStyle)
            .merge(widget.headerStyle.textStyle),
        activeDatesTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 13,
            )
            // ignore: lines_longer_than_80_chars
            .merge(calendarThemeData.activeDatesTextStyle)
            .merge(widget.monthViewSettings.monthCellStyle.textStyle),
        timeTextStyle: themeData.textTheme.bodySmall!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.54),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            )
            // ignore: lines_longer_than_80_chars
            .merge(calendarThemeData.timeTextStyle)
            .merge(widget.timeSlotViewSettings.timeTextStyle),
        viewHeaderDateTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 15,
            )
            // ignore: lines_longer_than_80_chars
            .merge(calendarThemeData.viewHeaderDateTextStyle)
            .merge(widget.viewHeaderStyle.dateTextStyle),
        viewHeaderDayTextStyle: themeData.textTheme.bodySmall!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 11,
            )
            // ignore: lines_longer_than_80_chars
            .merge(calendarThemeData.viewHeaderDayTextStyle)
            .merge(widget.viewHeaderStyle.dayTextStyle),
        displayNameTextStyle: themeData.textTheme.bodySmall!
            .copyWith(
              color: colorScheme.onSurface,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            )
            // ignore: lines_longer_than_80_chars
            .merge(calendarThemeData.displayNameTextStyle)
            .merge(widget.resourceViewSettings.displayNameTextStyle),
        weekNumberTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 13,
            )
            // ignore: lines_longer_than_80_chars
            .merge(calendarThemeData.weekNumberTextStyle)
            .merge(widget.weekNumberStyle.textStyle),
        timeIndicatorTextStyle: themeData.textTheme.bodySmall!
            .copyWith(
              color: colorScheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            )
            // ignore: lines_longer_than_80_chars
            .merge(calendarThemeData.timeIndicatorTextStyle)
            .merge(widget.dragAndDropSettings.timeIndicatorStyle));
  }

  void _updateFadeAnimation() {
    if (!mounted) {
      return;
    }

    _opacity.value = _fadeIn!.value;
  }

  /// loads the time zone data base to handle the time zone for calendar
  Future<bool> _loadDataBase() async {
    final ByteData byteData =
        await rootBundle.load('packages/timezone/data/latest_all.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
    _timeZoneLoaded = true;
    return true;
  }

  /// Generates the calendar appointments from the given data source, and
  /// time zone details
  void _getAppointment() {
    _appointments = AppointmentHelper.generateCalendarAppointments(
        widget.dataSource, widget.timeZone);
    _updateVisibleAppointments();
  }

  /// Updates the visible appointments for the calendar
  // ignore: avoid_void_async
  void _updateVisibleAppointments() async {
    if (!_timeZoneLoaded) {
      return;
    }
    if (_view != CalendarView.schedule) {
      final int visibleDatesCount = _currentViewVisibleDates.length;
      DateTime viewStartDate = _currentViewVisibleDates[0];
      DateTime viewEndDate = _currentViewVisibleDates[visibleDatesCount - 1];
      if (_view == CalendarView.month &&
          !CalendarViewHelper.isLeadingAndTrailingDatesVisible(
              widget.monthViewSettings.numberOfWeeksInView,
              widget.monthViewSettings.showTrailingAndLeadingDates)) {
        final DateTime currentMonthDate =
            _currentViewVisibleDates[visibleDatesCount ~/ 2];
        viewStartDate = AppointmentHelper.getMonthStartDate(currentMonthDate);
        viewEndDate = AppointmentHelper.getMonthEndDate(currentMonthDate);
      }

      final List<CalendarAppointment> tempVisibleAppointment =
          // ignore: await_only_futures
          await AppointmentHelper.getVisibleAppointments(
              viewStartDate,
              viewEndDate,
              _appointments,
              widget.timeZone,
              _view == CalendarView.month ||
                  CalendarViewHelper.isTimelineView(_view));
      if (CalendarViewHelper.isCollectionEqual(
          _visibleAppointments, tempVisibleAppointment)) {
        if (mounted) {
          setState(() {
            // Updates the calendar widget because it trigger to change the
            // header view text.
          });
        }

        return;
      }

      _visibleAppointments = tempVisibleAppointment;

      /// Update all day appointment related implementation in calendar,
      /// because time label view needs the top position.
      _updateAllDayAppointment();
    }

    //// mounted property in state return false when the state disposed,
    //// restrict the async method set state after the state disposed.
    if (mounted) {
      setState(() {
        /* Updates the visible appointment collection */
      });
    }
  }

  void _updateViewHeaderHover() {
    if (!mounted) {
      return;
    }

    setState(() {
      /*Updates the mouse hovering position for view header
    view */
    });
  }

  void _initScheduleViewProperties() {
    _scrollKey = UniqueKey();
    _nextDates = <DateTime>[];
    _previousDates = <DateTime>[];
    _headerUpdateNotifier = ValueNotifier<DateTime>(_scheduleDisplayDate);
    _forwardWidgetHeights = <int, _ScheduleViewDetails>{};
    _backwardWidgetHeights = <int, _ScheduleViewDetails>{};

    _agendaScrollController = ScrollController();

    /// Add listener for scroll view to handle the scroll view scroll position
    /// changes.
    _agendaScrollController!.addListener(_handleScheduleViewScrolled);
    _scheduleMaxDate = null;
    _scheduleMinDate = null;
    _minDate = null;
    _maxDate = null;
  }

  /// Handle the scroll view scroll changes to update header date value.
  void _handleScheduleViewScrolled() {
    _removeDatePicker();

    if (_view != CalendarView.schedule) {
      return;
    }

    double widgetPosition = 0;
    final double scrolledPosition = _agendaScrollController!.position.pixels;

    /// Scrolled position greater than zero then it moves to forward views.
    if (scrolledPosition >= 0) {
      for (int i = 0; i < _forwardWidgetHeights.length; i++) {
        final _ScheduleViewDetails? details =
            _forwardWidgetHeights.containsKey(i)
                ? _forwardWidgetHeights[i]
                : null;
        final double widgetHeight = details == null ? 0 : details._height;
        final double interSectionPoint =
            details == null ? -1 : details._intersectPoint;

        /// Check the scrolled position in between the view position
        if (scrolledPosition >= widgetPosition &&
            scrolledPosition < widgetHeight) {
          DateTime date = _nextDates[i];

          /// Check the view have intersection point, because intersection point
          /// tells the view does not have similar month dates. If it reaches
          /// the intersection point then it moves to another month date so
          /// update the header view date with latest date.
          if (interSectionPoint != -1 &&
              scrolledPosition >= interSectionPoint) {
            date = DateTimeHelper.getDateTimeValue(addDays(date, 6));
          }

          final DateTime currentViewDate = DateTimeHelper.getDateTimeValue(
              getValidDate(widget.minDate, widget.maxDate, date));
          _currentDate = currentViewDate;
          if (currentViewDate.month != _headerUpdateNotifier.value!.month ||
              currentViewDate.year != _headerUpdateNotifier.value!.year) {
            _controller.displayDate = currentViewDate;
            _headerUpdateNotifier.value = currentViewDate;
          }

          break;
        }

        widgetPosition = widgetHeight;
      }
    } else {
      /// Scrolled position less than zero then it moves to backward views.
      for (int i = 0; i < _backwardWidgetHeights.length; i++) {
        final _ScheduleViewDetails? details =
            _backwardWidgetHeights.containsKey(i)
                ? _backwardWidgetHeights[i]
                : null;
        final double widgetHeight = details == null ? 0 : details._height;
        final double interSectionPoint =
            details == null ? -1 : details._intersectPoint;

        /// Check the scrolled position in between the view position
        if (-scrolledPosition > widgetPosition &&
            -scrolledPosition <= widgetHeight) {
          DateTime date = _previousDates[i];

          /// Check the view have intersection point, because intersection point
          /// tells the view does not have similar month dates. If it reaches
          /// the intersection point then it moves to another month date so
          /// update the header view date with latest date.
          if (interSectionPoint != -1 &&
              -scrolledPosition <= interSectionPoint) {
            date = DateTimeHelper.getDateTimeValue(addDays(date, 6));
          }

          final DateTime currentViewDate = DateTimeHelper.getDateTimeValue(
              getValidDate(widget.minDate, widget.maxDate, date));
          _currentDate = currentViewDate;
          if (currentViewDate.month != _headerUpdateNotifier.value!.month ||
              currentViewDate.year != _headerUpdateNotifier.value!.year) {
            _controller.displayDate = currentViewDate;
            _headerUpdateNotifier.value = currentViewDate;
          }

          break;
        }

        widgetPosition = widgetHeight;
      }
    }

    if (_agendaScrollController!.hasClients &&
        _agendaScrollController!.position.atEdge &&
        (_agendaScrollController!.position.minScrollExtent != 0 ||
            _agendaScrollController!.position.maxScrollExtent != 0) &&
        widget.loadMoreWidgetBuilder != null &&
        !_isNeedLoadMore &&
        !_isScheduleStartLoadMore) {
      if (_agendaScrollController!.position.pixels ==
          _agendaScrollController!.position.minScrollExtent) {
        DateTime date = AppointmentHelper.getMonthStartDate(
            DateTime(_scheduleMinDate!.year, _scheduleMinDate!.month - 1));

        if (!isSameOrAfterDate(widget.minDate, date)) {
          date = widget.minDate;
        }

        if (!isSameDate(_scheduleMinDate, date)) {
          setState(() {
            _isScheduleStartLoadMore = true;
            _scheduleMinDate = date;
          });
        }
      } else {
        DateTime date = AppointmentHelper.getMonthEndDate(
            DateTime(_scheduleMaxDate!.year, _scheduleMaxDate!.month + 1));

        if (!isSameOrBeforeDate(widget.maxDate, date)) {
          date = widget.maxDate;
        }

        if (!isSameDate(_scheduleMaxDate, date)) {
          setState(() {
            _isNeedLoadMore = true;
            _scheduleMaxDate = date;
          });
        }
      }
    }
  }

  /// Method that raise the selection changed callback
  /// when selected date changed programmatically.
  void _updateSelectionChangedCallback() {
    if (!CalendarViewHelper.shouldRaiseCalendarSelectionChangedCallback(
        widget.onSelectionChanged)) {
      return;
    }
    final bool isResourceEnabled =
        CalendarViewHelper.isResourceEnabled(widget.dataSource, _view);
    CalendarViewHelper.raiseCalendarSelectionChangedCallback(
        widget,
        _controller.selectedDate,
        isResourceEnabled ? widget.dataSource!.resources![0] : null);
  }

  void _calendarValueChangedListener(String property) {
    _removeDatePicker();
    if (property == 'selectedDate') {
      if (CalendarViewHelper.isSameTimeSlot(
          _selectedDate, _controller.selectedDate)) {
        return;
      }
      _updateSelectionChangedCallback();
      setState(() {
        _selectedDate = _controller.selectedDate;
      });
    } else if (property == 'displayDate') {
      _updateDisplayDate();
    } else if (property == 'calendarView') {
      if (_view == _controller.view) {
        return;
      }

      setState(() {
        final CalendarView oldView = _view;
        _view = _controller.view!;
        _currentDate = DateTimeHelper.getDateTimeValue(getValidDate(
            widget.minDate, widget.maxDate, _updateCurrentDate(oldView)));
        if (!isSameDate(_currentDate, _controller.displayDate)) {
          _canScrollTimeSlotView = false;
          _controller.displayDate = _currentDate;
          _canScrollTimeSlotView = true;
        }

        _fadeInController!.reset();
        _fadeInController!.forward();
        _agendaScrollController = ScrollController();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          final Widget? currentWidget = _customScrollViewKey.currentWidget;

          /// When view switched from schedule view to other views we need to
          /// switch the focus to the custom scrolling panel.
          if (currentWidget is CustomCalendarScrollView) {
            currentWidget.updateFocus();
          }
        });
        if (_view == CalendarView.schedule) {
          _scheduleDisplayDate = _controller.displayDate!;
          if (CalendarViewHelper.shouldRaiseViewChangedCallback(
              widget.onViewChanged)) {
            CalendarViewHelper.raiseViewChangedCallback(
                widget, <DateTime>[_controller.displayDate!]);
          }

          _agendaScrollController?.removeListener(_handleScheduleViewScrolled);
          _initScheduleViewProperties();
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (!_focusNode.hasFocus) {
              _focusNode.requestFocus();
            }
          });
        } else if (CalendarViewHelper.isResourceEnabled(
            widget.dataSource, _view)) {
          _resourcePanelScrollController ??= ScrollController();
        }
      });
    }
  }

  void _updateDisplayDate() {
    if (!isSameOrAfterDate(widget.minDate, _controller.displayDate)) {
      _controller.displayDate = widget.minDate;
      return;
    }

    if (!isSameOrBeforeDate(widget.maxDate, _controller.displayDate)) {
      _controller.displayDate = widget.maxDate;
      return;
    }

    switch (_view) {
      case CalendarView.schedule:
        {
          if (isSameDate(_currentDate, _controller.displayDate)) {
            _currentDate = _controller.displayDate!;
            return;
          }

          _fadeInController!.reset();
          _fadeInController!.forward();
          setState(() {
            _currentDate = _controller.displayDate!;
            _scheduleDisplayDate = _currentDate;
            _updateCurrentVisibleDates();
            _agendaScrollController
                ?.removeListener(_handleScheduleViewScrolled);
            _agendaScrollController!.dispose();
            _initScheduleViewProperties();
          });
          break;
        }
      case CalendarView.month:
        {
          if (isSameDate(_currentDate, _controller.displayDate) ||
              (isDateWithInDateRange(
                      _currentViewVisibleDates[0],
                      _currentViewVisibleDates[
                          _currentViewVisibleDates.length - 1],
                      _controller.displayDate) &&
                  (widget.monthViewSettings.numberOfWeeksInView != 6 ||
                      (widget.monthViewSettings.numberOfWeeksInView == 6 &&
                          _controller.displayDate!.month ==
                              _currentViewVisibleDates[
                                      _currentViewVisibleDates.length ~/ 2]
                                  .month)))) {
            _currentDate = _controller.displayDate!;
            return;
          }

          _fadeInController!.reset();
          _fadeInController!.forward();
          setState(() {
            _currentDate = _controller.displayDate!;
            _updateCurrentVisibleDates();
          });
          break;
        }
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
      case CalendarView.timelineMonth:
        {
          if (isSameDate(_currentDate, _controller.displayDate) ||
              isDateWithInDateRange(
                  _currentViewVisibleDates[0],
                  _currentViewVisibleDates[_currentViewVisibleDates.length - 1],
                  _controller.displayDate)) {
            if (_canScrollTimeSlotView &&
                _customScrollViewKey.currentWidget != null) {
              // ignore: avoid_as
              (_customScrollViewKey.currentWidget! as CustomCalendarScrollView)
                  .updateScrollPosition();
            }
            _currentDate = _controller.displayDate!;
            return;
          }

          _fadeInController!.reset();
          _fadeInController!.forward();
          setState(() {
            _currentDate = _controller.displayDate!;
            _updateCurrentVisibleDates();
          });
          break;
        }
    }
  }

  void _updateCurrentVisibleDates() {
    final List<int>? nonWorkingDays = (_view == CalendarView.workWeek ||
            _view == CalendarView.timelineWorkWeek)
        ? widget.timeSlotViewSettings.nonWorkingDays
        : null;
    final int visibleDatesCount = DateTimeHelper.getViewDatesCount(
        _view,
        widget.monthViewSettings.numberOfWeeksInView,
        widget.timeSlotViewSettings.numberOfDaysInView,
        nonWorkingDays);

    _currentViewVisibleDates = getVisibleDates(_currentDate, nonWorkingDays,
            widget.firstDayOfWeek, visibleDatesCount)
        .cast();

    if (_view == CalendarView.timelineMonth) {
      _currentViewVisibleDates =
          DateTimeHelper.getCurrentMonthDates(_currentViewVisibleDates);
      if (widget.showWeekNumber) {
        _timelineMonthWeekNumberNotifier.value = _currentViewVisibleDates[0];
      }
    }
  }

  //// Perform action while data source changed based on data source action.
  void _dataSourceChangedListener(
      CalendarDataSourceAction type, List<dynamic> data) {
    if (!_timeZoneLoaded || !mounted) {
      return;
    }

    final List<CalendarAppointment> visibleAppointmentCollection =
        <CalendarAppointment>[];
    //// Clone the visible appointments because if we add visible appointment directly then
    //// calendar view visible appointment also updated so it does not perform to paint, So
    //// clone the visible appointment and added newly added appointment and set the value.
    for (int i = 0; i < _visibleAppointments.length; i++) {
      visibleAppointmentCollection.add(_visibleAppointments[i]);
    }

    if (_isNeedLoadMore || _isScheduleStartLoadMore) {
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        setState(() {
          _isNeedLoadMore = false;
          _isScheduleStartLoadMore = false;
        });
      });
    }

    switch (type) {
      case CalendarDataSourceAction.reset:
        {
          _getAppointment();
          _removeScheduleViewAppointmentDates();
          _loadScheduleViewAppointmentDates(_appointments);
        }
        break;
      case CalendarDataSourceAction.add:
        {
          final List<CalendarAppointment> collection =
              AppointmentHelper.generateCalendarAppointments(
                  widget.dataSource, widget.timeZone, data);
          _loadScheduleViewAppointmentDates(collection);

          if (_view != CalendarView.schedule) {
            final int visibleDatesCount = _currentViewVisibleDates.length;
            DateTime viewStartDate = _currentViewVisibleDates[0];
            DateTime viewEndDate =
                _currentViewVisibleDates[visibleDatesCount - 1];
            if (_view == CalendarView.month &&
                !CalendarViewHelper.isLeadingAndTrailingDatesVisible(
                    widget.monthViewSettings.numberOfWeeksInView,
                    widget.monthViewSettings.showTrailingAndLeadingDates)) {
              final DateTime currentMonthDate =
                  _currentViewVisibleDates[visibleDatesCount ~/ 2];
              viewStartDate =
                  AppointmentHelper.getMonthStartDate(currentMonthDate);
              viewEndDate = AppointmentHelper.getMonthEndDate(currentMonthDate);
            }

            visibleAppointmentCollection.addAll(
                AppointmentHelper.getVisibleAppointments(
                    viewStartDate,
                    viewEndDate,
                    collection,
                    widget.timeZone,
                    _view == CalendarView.month ||
                        CalendarViewHelper.isTimelineView(_view)));
          }

          for (int i = 0; i < collection.length; i++) {
            _appointments.add(collection[i]);
          }

          _updateVisibleAppointmentCollection(visibleAppointmentCollection);
        }
        break;
      case CalendarDataSourceAction.remove:
        {
          for (int i = 0; i < data.length; i++) {
            final dynamic appointment = data[i];
            for (int j = 0; j < _appointments.length; j++) {
              if (_appointments[j].data == appointment) {
                _appointments.removeAt(j);
                j--;
              }
            }
          }

          _removeScheduleViewAppointmentDates();

          for (int i = 0; i < data.length; i++) {
            final dynamic appointment = data[i];
            for (int j = 0; j < visibleAppointmentCollection.length; j++) {
              if (visibleAppointmentCollection[j].data == appointment) {
                visibleAppointmentCollection.removeAt(j);
                j--;
              }
            }
          }
          _updateVisibleAppointmentCollection(visibleAppointmentCollection);
        }
        break;
      case CalendarDataSourceAction.addResource:
      case CalendarDataSourceAction.removeResource:
      case CalendarDataSourceAction.resetResource:
        {
          if (data is! List<CalendarResource>) {
            return;
          }

          final List<CalendarResource> resourceCollection = data;
          if (resourceCollection.isNotEmpty) {
            _disposeResourceImagePainter();
            setState(() {
              _resourceCollection =
                  CalendarViewHelper.cloneList(widget.dataSource?.resources);
              /* To render the modified resource collection  */
              if (CalendarViewHelper.isTimelineView(_view)) {
                _isNeedLoadMore = true;
              }
            });
          }
        }
        break;
    }
  }

  /// Load the newly added appointments dates for schedule view when
  /// hideEmptyScheduleWeek is used.
  /// This method will call when reset, add, use new data source collection
  /// operations, and Add appointments to the week that do not exist in the
  /// schedule view.
  void _loadScheduleViewAppointmentDates(List<CalendarAppointment> collection) {
    /// Return when the calendar view is other than the schedule view or
    /// hideEmptyScheduleWeek is disabled in mobile view.
    if (_view != CalendarView.schedule ||
        _nextDates.isEmpty ||
        (!widget.scheduleViewSettings.hideEmptyScheduleWeek &&
            _useMobilePlatformUI)) {
      return;
    }

    /// Calculate and add newly appointments dates into previous or next dates
    /// collection when hideEmptyScheduleWeek enabled in mobileUI and web UI and
    /// hideEmptyScheduleWeek disabled in web UI with schedule view.
    final DateTime startDate =
        _previousDates.isEmpty ? _nextDates[0] : _previousDates[0];
    final DateTime endDate = addDuration(_nextDates[_nextDates.length - 1],
        const Duration(days: DateTime.daysPerWeek - 1)) as DateTime;
    for (int i = 0; i < collection.length; i++) {
      /// recursiveDates list used to store the newly added appointments dates
      List<DateTime> recursiveDates = <DateTime>[];
      final CalendarAppointment appointment = collection[i];
      final List<DateTime> recursiveExceptionDates = <DateTime>[];
      final Duration difference = AppointmentHelper.getDifference(
          appointment.actualStartTime, appointment.actualEndTime);
      if (appointment.recurrenceRule != null &&
          appointment.recurrenceRule!.isNotEmpty) {
        /// Calculate the occurrence dates collection.
        recursiveDates = RecurrenceHelper.getRecurrenceDateTimeCollection(
            appointment.recurrenceRule!, appointment.actualStartTime,
            recurrenceDuration: difference,
            specificStartDate: startDate,
            specificEndDate: endDate);
        if (appointment.recurrenceExceptionDates != null) {
          for (int i = 0;
              i < appointment.recurrenceExceptionDates!.length;
              i++) {
            recursiveExceptionDates.add(
                AppointmentHelper.convertTimeToAppointmentTimeZone(
                    appointment.recurrenceExceptionDates![i],
                    '',
                    widget.timeZone));
          }
        }
      } else {
        if (!isDateWithInDateRange(
                startDate, endDate, appointment.actualStartTime) &&
            !isDateWithInDateRange(
                startDate, endDate, appointment.actualEndTime)) {
          continue;
        }

        recursiveDates = <DateTime>[appointment.actualStartTime];
      }

      for (int j = 0; j < recursiveDates.length; j++) {
        final DateTime appointmentDate = recursiveDates[j];
        bool isExceptionDate = false;
        for (int k = 0; k < recursiveExceptionDates.length; k++) {
          if (isSameDate(appointmentDate, recursiveExceptionDates[k])) {
            isExceptionDate = true;
            break;
          }
        }

        if (isExceptionDate) {
          continue;
        }

        DateTime appEndDate =
            addDuration(appointmentDate, difference) as DateTime;
        appEndDate =
            DateTime(appEndDate.year, appEndDate.month, appEndDate.day);
        DateTime appDate = DateTime(
            appointmentDate.year, appointmentDate.month, appointmentDate.day);

        /// Calculate start date of the week.
        int value = -(appDate.weekday % DateTime.daysPerWeek) +
            widget.firstDayOfWeek -
            DateTime.daysPerWeek;
        if (value.abs() >= DateTime.daysPerWeek) {
          value += DateTime.daysPerWeek;
        }
        appDate = addDuration(appDate, Duration(days: value)) as DateTime;

        value = -(appEndDate.weekday % DateTime.daysPerWeek) +
            widget.firstDayOfWeek -
            DateTime.daysPerWeek;
        if (value.abs() >= DateTime.daysPerWeek) {
          value += DateTime.daysPerWeek;
        }

        appEndDate = addDuration(appEndDate, Duration(days: value)) as DateTime;

        void addNewAppointmentWeekDate(DateTime date) {
          /// Add newly added appointment dates into previous and next date
          /// collection based on the DateTime range. And it will ignore
          /// the dates which is same as previous date or next date.
          if (date.isBefore(_nextDates[0])) {
            if (_previousDates.isEmpty || !_previousDates.contains(date)) {
              _previousDates.add(date);
            }
          } else if (!_nextDates.contains(date) && date.isBefore(endDate)) {
            _nextDates.add(date);
          }
        }

        DateTime appCurrentDate = appDate;
        while (appCurrentDate.isBefore(appEndDate) ||
            isSameDate(appCurrentDate, appEndDate)) {
          addNewAppointmentWeekDate(appCurrentDate);
          appCurrentDate = addDuration(
                  appCurrentDate, const Duration(days: DateTime.daysPerWeek))
              as DateTime;
        }
      }
    }

    //// Previous dates collection holds the date collection on reverse order.
    _previousDates.sort((DateTime date1, DateTime date2) {
      return date2.compareTo(date1);
    });
    _nextDates.sort();
  }

  void _removeScheduleViewAppointmentDates() {
    if (_view != CalendarView.schedule ||
        (!widget.scheduleViewSettings.hideEmptyScheduleWeek &&
            _useMobilePlatformUI)) {
      return;
    }

    for (int i = 0; i < _previousDates.length; i++) {
      final DateTime weekStartDate = _previousDates[i];

      final DateTime weekEndDate =
          DateTimeHelper.getDateTimeValue(addDays(weekStartDate, 6));

      /// Remove the week date when it does not have appointments
      /// when [hideEmptyAgendaDays] as enabled.
      if (!_isAppointmentBetweenDates(
              _appointments, weekStartDate, weekEndDate, widget.timeZone) &&
          !isDateWithInDateRange(weekStartDate, weekEndDate, DateTime.now()) &&
          !isDateWithInDateRange(
              weekStartDate, weekEndDate, _scheduleDisplayDate)) {
        _previousDates.remove(weekStartDate);
        i--;
      }
    }

    for (int i = 0; i < _nextDates.length; i++) {
      final DateTime weekStartDate = _nextDates[i];

      final DateTime weekEndDate =
          DateTimeHelper.getDateTimeValue(addDays(weekStartDate, 6));

      /// Remove the week date when it does not have appointments
      /// when [hideEmptyAgendaDays] as enabled.
      if (!_isAppointmentBetweenDates(
              _appointments, weekStartDate, weekEndDate, widget.timeZone) &&
          !isDateWithInDateRange(weekStartDate, weekEndDate, DateTime.now()) &&
          !isDateWithInDateRange(
              weekStartDate, weekEndDate, _scheduleDisplayDate)) {
        _nextDates.remove(weekStartDate);
        i--;
      }
    }
  }

  void _disposeResourceImagePainter() {
    if (_imagePainterCollection.isNotEmpty) {
      final List<Object> keys = _imagePainterCollection.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        _imagePainterCollection[keys[i]]!.dispose();
      }

      _imagePainterCollection.clear();
    }
  }

  /// Updates the visible appointments collection based on passed collection,
  /// the collection modified based on the data source's add and remove action.
  void _updateVisibleAppointmentCollection(
      List<CalendarAppointment> visibleAppointmentCollection) {
    if (_view == CalendarView.schedule) {
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        setState(() {
          /// Update the view when the appointment collection changed.
        });
      });
      return;
    }

    if (CalendarViewHelper.isCollectionEqual(
        _visibleAppointments, visibleAppointmentCollection)) {
      return;
    }

    _visibleAppointments = visibleAppointmentCollection;

    /// Update all day appointment related implementation in calendar,
    /// because time label view needs the top position.
    _updateAllDayAppointment();
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        /// Update the UI.
      });
    });
  }

  void _agendaSelectedDateListener() {
    if (_view != CalendarView.month || !widget.monthViewSettings.showAgenda) {
      return;
    }

    setState(() {
      /* Updates the selected date to the agenda view, to update the view */
    });
  }

  DateTime _updateCurrentDate(CalendarView view) {
    // condition added to updated the current visible date while switching the
    // calendar views
    // if any date selected in the current view then, while switching the view
    // the view move based the selected date
    // if no date selected and the current view has the today date, then
    // switching the view will move based on the today date
    // if no date selected and today date doesn't falls in current view, then
    // switching the view will move based the first day of current view
    if (view == CalendarView.schedule) {
      return _controller.displayDate ?? _currentDate;
    }

    final DateTime visibleStartDate = _currentViewVisibleDates[0];
    final DateTime visibleEndDate =
        _currentViewVisibleDates[_currentViewVisibleDates.length - 1];
    final bool isMonthView =
        view == CalendarView.month || view == CalendarView.timelineMonth;
    if (_selectedDate != null &&
        isDateWithInDateRange(
            visibleStartDate, visibleEndDate, _selectedDate)) {
      if (isMonthView) {
        return DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _controller.displayDate!.hour,
            _controller.displayDate!.minute,
            _controller.displayDate!.second);
      } else {
        return _selectedDate!;
      }
    } else if (isDateWithInDateRange(
        visibleStartDate, visibleEndDate, DateTime.now())) {
      final DateTime date = DateTime.now();
      return DateTime(
          date.year,
          date.month,
          date.day,
          _controller.displayDate!.hour,
          _controller.displayDate!.minute,
          _controller.displayDate!.second);
    } else {
      if (isMonthView) {
        if (widget.monthViewSettings.numberOfWeeksInView > 0 &&
            widget.monthViewSettings.numberOfWeeksInView < 6) {
          return visibleStartDate;
        }
        return DateTime(
            _currentDate.year,
            _currentDate.month,
            1,
            _controller.displayDate!.hour,
            _controller.displayDate!.minute,
            _controller.displayDate!.second);
      } else {
        final DateTime date = visibleStartDate;
        return DateTime(
            date.year,
            date.month,
            date.day,
            _controller.displayDate!.hour,
            _controller.displayDate!.minute,
            _controller.displayDate!.second);
      }
    }
  }

  void _updateAppointmentView(List<CalendarAppointment> allDayAppointments) {
    for (int i = 0; i < allDayAppointments.length; i++) {
      AppointmentView appointmentView;
      if (_allDayAppointmentViewCollection.length > i) {
        appointmentView = _allDayAppointmentViewCollection[i];
      } else {
        appointmentView = AppointmentView();
        _allDayAppointmentViewCollection.add(appointmentView);
      }

      appointmentView.appointment = allDayAppointments[i];
      appointmentView.canReuse = false;
    }
  }

  void _updateAppointmentViewPosition() {
    for (final AppointmentView appointmentView
        in _allDayAppointmentViewCollection) {
      if (appointmentView.appointment == null) {
        continue;
      }

      final int startIndex = DateTimeHelper.getIndex(_currentViewVisibleDates,
          appointmentView.appointment!.actualStartTime);
      final int endIndex = DateTimeHelper.getIndex(_currentViewVisibleDates,
              appointmentView.appointment!.actualEndTime) +
          1;
      if (startIndex == -1 && endIndex == 0) {
        appointmentView.appointment = null;
        continue;
      }

      appointmentView.startIndex = startIndex;
      appointmentView.endIndex = endIndex;
    }
  }

  void _updateAppointmentPositionAndMaxPosition(
      List<List<AppointmentView>> allDayAppointmentView) {
    for (int i = 0; i < allDayAppointmentView.length; i++) {
      final List<AppointmentView> intersectingAppointments =
          allDayAppointmentView[i];
      for (int j = 0; j < intersectingAppointments.length; j++) {
        final AppointmentView currentView = intersectingAppointments[j];
        if (currentView.position == -1) {
          currentView.position = 0;
          for (int k = 0; k < j; k++) {
            final AppointmentView? intersectView = _getAppointmentOnPosition(
                currentView, intersectingAppointments);
            if (intersectView != null) {
              currentView.position++;
            } else {
              break;
            }
          }
        }
      }

      if (intersectingAppointments.isNotEmpty) {
        final int maxPosition = intersectingAppointments
                .reduce((AppointmentView currentAppView,
                        AppointmentView nextAppView) =>
                    currentAppView.position > nextAppView.position
                        ? currentAppView
                        : nextAppView)
                .position +
            1;

        for (int j = 0; j < intersectingAppointments.length; j++) {
          final AppointmentView appointmentView = intersectingAppointments[j];
          if (appointmentView.maxPositions != -1) {
            continue;
          }
          appointmentView.maxPositions = maxPosition;
        }
      }
    }
  }

  AppointmentView? _getAppointmentOnPosition(
      AppointmentView? currentView, List<AppointmentView>? views) {
    if (currentView == null ||
        currentView.appointment == null ||
        views == null ||
        views.isEmpty) {
      return null;
    }

    for (final AppointmentView view in views) {
      if (view.position == currentView.position && view != currentView) {
        return view;
      }
    }

    return null;
  }

  void _updateIntersectAppointmentViewCollection(
      List<List<AppointmentView>> allDayAppointmentView) {
    for (int i = 0; i < _currentViewVisibleDates.length; i++) {
      final List<AppointmentView> intersectingAppointments =
          <AppointmentView>[];
      for (int j = 0; j < _allDayAppointmentViewCollection.length; j++) {
        final AppointmentView currentView = _allDayAppointmentViewCollection[j];
        if (currentView.appointment == null) {
          continue;
        }

        if (currentView.startIndex <= i && currentView.endIndex >= i + 1) {
          intersectingAppointments.add(currentView);
        }
      }

      allDayAppointmentView.add(intersectingAppointments);
    }
  }

  void _updateAllDayAppointment() {
    if (CalendarViewHelper.isTimelineView(_view) &&
        _view == CalendarView.month) {
      return;
    }

    _allDayPanelHeight = 0;

    //// Remove the existing appointment related details.
    AppointmentHelper.resetAppointmentView(_allDayAppointmentViewCollection);

    if (_visibleAppointments.isEmpty) {
      return;
    }

    //// Calculate the visible all day appointment collection.
    final List<CalendarAppointment> allDayAppointments =
        <CalendarAppointment>[];
    for (final CalendarAppointment appointment in _visibleAppointments) {
      if (appointment.isAllDay ||
          AppointmentHelper.getDifference(
                      appointment.actualStartTime, appointment.actualEndTime)
                  .inDays >
              0) {
        allDayAppointments.add(appointment);
      }
    }

    //// Update the appointment view collection with visible appointments.
    _updateAppointmentView(allDayAppointments);

    //// Calculate the appointment view position.
    _updateAppointmentViewPosition();

    //// Sort the appointment view based on appointment view width.
    _allDayAppointmentViewCollection
        .sort((AppointmentView app1, AppointmentView app2) {
      if (app1.appointment != null && app2.appointment != null) {
        return AppointmentHelper.getDifference(
                    app2.appointment!.startTime, app2.appointment!.endTime) >
                AppointmentHelper.getDifference(
                    app1.appointment!.startTime, app1.appointment!.endTime)
            ? 1
            : 0;
      }

      return 0;
    });

    //// Sort the appointment view based on appointment view start position.
    _allDayAppointmentViewCollection
        .sort((AppointmentView app1, AppointmentView app2) {
      if (app1.appointment != null && app2.appointment != null) {
        return app1.startIndex.compareTo(app2.startIndex);
      }

      return 0;
    });

    final List<List<AppointmentView>> allDayAppointmentView =
        <List<AppointmentView>>[];

    //// Calculate the intersecting appointment view collection.
    _updateIntersectAppointmentViewCollection(allDayAppointmentView);

    //// Calculate the appointment view position and max position.
    _updateAppointmentPositionAndMaxPosition(allDayAppointmentView);
    _updateAllDayPanelHeight();
  }

  void _updateAllDayPanelHeight() {
    int maxPosition = 0;
    if (_allDayAppointmentViewCollection.isNotEmpty) {
      maxPosition = _allDayAppointmentViewCollection
          .reduce(
              (AppointmentView currentAppView, AppointmentView nextAppView) =>
                  currentAppView.maxPositions > nextAppView.maxPositions
                      ? currentAppView
                      : nextAppView)
          .maxPositions;
    }

    if (maxPosition == -1) {
      maxPosition = 0;
    }

    _allDayPanelHeight = maxPosition * kAllDayAppointmentHeight;
  }

  double _getMonthAgendaHeight() {
    return widget.monthViewSettings.agendaViewHeight == -1
        ? _minHeight / 3
        : widget.monthViewSettings.agendaViewHeight;
  }

  void _updateMouseHoveringForHeader(Offset localPosition) {
    if (_agendaDateNotifier.value != null) {
      _agendaDateNotifier.value = null;
    }

    if (_agendaViewNotifier.value != null) {
      _agendaViewNotifier.value = null;
    }

    if (_resourceHoverNotifier.value != null) {
      _resourceHoverNotifier.value = null;
    }

    _headerHoverNotifier.value = Offset(localPosition.dx, localPosition.dy);
  }

  void _updateMouseHoverPosition(
      Offset globalPosition,
      bool isScheduleDisplayDate,
      bool isRTL,
      DateTime? currentDate,
      double? startPosition,
      [double padding = 0,
      bool isResourceEnabled = false]) {
    if (_isMobilePlatform) {
      return;
    }

    // ignore: avoid_as
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);
    if (localPosition.dy < widget.headerHeight) {
      _updateMouseHoveringForHeader(localPosition);
    } else {
      if (isResourceEnabled &&
          ((isRTL &&
                  localPosition.dx >
                      (_minWidth - widget.resourceViewSettings.size)) ||
              (!isRTL &&
                  localPosition.dx < widget.resourceViewSettings.size)) &&
          localPosition.dy > startPosition! &&
          (CalendarViewHelper.shouldRaiseCalendarTapCallback(widget.onTap) ||
              CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
                  widget.onLongPress))) {
        if (_headerHoverNotifier.value != null) {
          _headerHoverNotifier.value = null;
        }

        if (_agendaViewNotifier.value != null) {
          _agendaViewNotifier.value = null;
        }

        if (_agendaDateNotifier.value != null) {
          _agendaDateNotifier.value = null;
        }

        if (_resourceHoverNotifier.value != null) {
          _resourceHoverNotifier.value = null;
        }

        final double yPosition =
            (_resourcePanelScrollController!.offset + localPosition.dy) -
                startPosition;

        _resourceHoverNotifier.value = Offset(localPosition.dx, yPosition);
      }

      if (_view != CalendarView.month && _view != CalendarView.schedule) {
        return;
      }

      double yPosition = localPosition.dy;
      double xPosition = localPosition.dx;
      double dateViewWidth = _getAgendaViewDayLabelWidth(
          widget.scheduleViewSettings, _useMobilePlatformUI);
      if (_view == CalendarView.month) {
        currentDate = _selectedDate;
        final double agendaHeight = _getMonthAgendaHeight();
        yPosition -= _minHeight - agendaHeight;
        dateViewWidth = _agendaDateViewWidth;
        if (_selectedDate == null) {
          dateViewWidth = 0;
        }

        if (dateViewWidth > 60 && !_isMobilePlatform) {
          dateViewWidth = 60;
        }
      } else {
        yPosition = (_agendaScrollController!.offset + localPosition.dy) -
            startPosition! -
            widget.headerHeight;
      }

      if ((isRTL && localPosition.dx > (_minWidth - dateViewWidth)) ||
          (!isRTL && localPosition.dx < dateViewWidth)) {
        if (_headerHoverNotifier.value != null) {
          _headerHoverNotifier.value = null;
        }

        if (_agendaViewNotifier.value != null) {
          _agendaViewNotifier.value = null;
        }

        if (_resourceHoverNotifier.value != null) {
          _resourceHoverNotifier.value = null;
        }

        if (widget.onTap == null &&
            widget.onLongPress == null &&
            !widget.allowViewNavigation) {
          _agendaDateNotifier.value = null;
          return;
        }

        xPosition = isRTL ? _minWidth - xPosition : xPosition;
        _agendaDateNotifier.value = ScheduleViewHoveringDetails(
            currentDate!, Offset(xPosition, yPosition));
      } else {
        /// padding value used to specify the view top padding on agenda view.
        /// padding value is assigned when the agenda view has top padding
        /// eg., if the agenda view holds one all day appointment in
        /// schedule view then it have top padding because the agenda view
        /// minimum panel height as appointment height specified in setting.
        if (_view == CalendarView.month) {
          yPosition += _agendaScrollController!.offset;
          xPosition -= isRTL ? 0 : dateViewWidth;
        }
        yPosition -= padding;
        if (_headerHoverNotifier.value != null) {
          _headerHoverNotifier.value = null;
        }

        if (_agendaDateNotifier.value != null) {
          _agendaDateNotifier.value = null;
        }

        if (_resourceHoverNotifier.value != null) {
          _resourceHoverNotifier.value = null;
        }
        if (isScheduleDisplayDate &&
            widget.onTap == null &&
            widget.onLongPress == null) {
          _agendaViewNotifier.value = null;
          return;
        }
        _agendaViewNotifier.value = ScheduleViewHoveringDetails(
            currentDate!, Offset(xPosition, yPosition));
      }
    }
  }

  void _pointerEnterEvent(
      PointerEnterEvent event, bool isScheduleDisplayDate, bool isRTL,
      [DateTime? currentDate,
      double? startPosition,
      double padding = 0,
      bool resourceEnabled = false]) {
    _updateMouseHoverPosition(event.position, isScheduleDisplayDate, isRTL,
        currentDate, startPosition, padding, resourceEnabled);
  }

  void _pointerHoverEvent(
      PointerHoverEvent event, bool isScheduleDisplayDate, bool isRTL,
      [DateTime? currentDate,
      double? startPosition,
      double padding = 0,
      bool resourceEnabled = false]) {
    _updateMouseHoverPosition(event.position, isScheduleDisplayDate, isRTL,
        currentDate, startPosition, padding, resourceEnabled);
  }

  void _pointerExitEvent(PointerExitEvent event) {
    _headerHoverNotifier.value = null;
    _agendaDateNotifier.value = null;
    _agendaViewNotifier.value = null;
    _resourceHoverNotifier.value = null;
  }

  /// Calculate the maximum appointment date based on appointment collection
  /// and schedule view settings.
  DateTime _getMaxAppointmentDate(
      List<CalendarAppointment> appointments,
      String? timeZone,
      DateTime maxDate,
      DateTime displayDate,
      ScheduleViewSettings scheduleViewSettings,
      bool useMobilePlatformUI) {
    /// return default max date when [hideEmptyAgendaDays] as false
    if (!scheduleViewSettings.hideEmptyScheduleWeek && useMobilePlatformUI) {
      return maxDate;
    }

    DateTime currentMaxDate = displayDate;
    if (appointments.isEmpty) {
      return currentMaxDate;
    }

    /// Calculate the max appointment date based on appointments when
    /// web view enabled or [hideEmptyAgendaDays] property as enabled.
    for (int j = 0; j < appointments.length; j++) {
      final CalendarAppointment appointment = appointments[j];
      appointment.actualEndTime =
          AppointmentHelper.convertTimeToAppointmentTimeZone(
              appointment.endTime, appointment.endTimeZone, timeZone);

      if (appointment.recurrenceRule == null ||
          appointment.recurrenceRule == '') {
        if (appointment.actualEndTime.isAfter(currentMaxDate)) {
          currentMaxDate = appointment.actualEndTime;
        }

        continue;
      }

      /// Return specified ma date when recurrence rule does not have
      /// count and until string.
      if (!appointment.recurrenceRule!.contains('COUNT') &&
          !appointment.recurrenceRule!.contains('UNTIL')) {
        currentMaxDate = maxDate;
        return currentMaxDate;
      }

      if (appointment.recurrenceRule!.contains('UNTIL')) {
        final List<String> ruleSeparator = <String>['=', ';', ','];
        final List<String> rRule = RecurrenceHelper.splitRule(
            appointment.recurrenceRule!, ruleSeparator);
        final String untilValue = rRule[rRule.indexOf('UNTIL') + 1];
        DateTime recurrenceEndDate =
            RecurrenceHelper.getUntilEndDate(untilValue);
        recurrenceEndDate = DateTime(recurrenceEndDate.year,
            recurrenceEndDate.month, recurrenceEndDate.day, 23, 59, 59);
        if (recurrenceEndDate.isAfter(currentMaxDate)) {
          currentMaxDate = recurrenceEndDate;
          continue;
        }
      }

      final List<DateTime> recursiveDates =
          RecurrenceHelper.getRecurrenceDateTimeCollection(
        appointment.recurrenceRule!,
        appointment.actualStartTime,
      );

      if (recursiveDates.isEmpty) {
        continue;
      }

      if (appointment.recurrenceExceptionDates == null ||
          appointment.recurrenceExceptionDates!.isEmpty) {
        final DateTime date = recursiveDates[recursiveDates.length - 1];
        if (date.isAfter(currentMaxDate)) {
          currentMaxDate = date;
          continue;
        }
      }

      final Duration duration = AppointmentHelper.getDifference(
          appointment.actualStartTime, appointment.actualEndTime);
      for (int k = recursiveDates.length - 1; k >= 0; k--) {
        final DateTime recurrenceDate = recursiveDates[k];
        bool isExceptionDate = false;
        if (appointment.recurrenceExceptionDates != null) {
          for (int i = 0;
              i < appointment.recurrenceExceptionDates!.length;
              i++) {
            final DateTime exceptionDate =
                appointment.recurrenceExceptionDates![i];
            if (isSameDate(recurrenceDate, exceptionDate)) {
              isExceptionDate = true;
            }
          }
        }

        if (!isExceptionDate) {
          final DateTime recurrenceEndDate = DateTimeHelper.getDateTimeValue(
              addDuration(recurrenceDate, duration));
          if (recurrenceEndDate.isAfter(currentMaxDate)) {
            currentMaxDate = recurrenceEndDate;
            break;
          }
        }
      }
    }

    return currentMaxDate;
  }

  /// Calculate the minimum appointment date based on appointment collection
  /// and schedule view settings.
  DateTime _getMinAppointmentDate(
      List<CalendarAppointment> appointments,
      String? timeZone,
      DateTime minDate,
      DateTime displayDate,
      ScheduleViewSettings scheduleViewSettings,
      bool useMobilePlatformUI) {
    /// return default min date when hideEmptyAgendaDays as false
    if (!scheduleViewSettings.hideEmptyScheduleWeek && useMobilePlatformUI) {
      return minDate;
    }

    DateTime currentMinDate = displayDate;
    if (appointments.isEmpty) {
      return currentMinDate;
    }

    /// Calculate the min appointment date based on appointments when
    /// web view enabled or [hideEmptyAgendaDays] property as enabled.
    for (int j = 0; j < appointments.length; j++) {
      final CalendarAppointment appointment = appointments[j];
      appointment.actualStartTime =
          AppointmentHelper.convertTimeToAppointmentTimeZone(
              appointment.startTime, appointment.startTimeZone, timeZone);

      if (appointment.actualStartTime.isBefore(currentMinDate)) {
        currentMinDate = appointment.actualStartTime;
      }

      continue;
    }

    return currentMinDate;
  }

  /// Check any appointment in appointments collection in between
  /// the start and end date.
  bool _isAppointmentBetweenDates(List<CalendarAppointment> appointments,
      DateTime startDate, DateTime endDate, String? timeZone) {
    startDate = AppointmentHelper.convertToStartTime(startDate);
    endDate = AppointmentHelper.convertToEndTime(endDate);
    if (appointments.isEmpty) {
      return false;
    }

    for (int j = 0; j < appointments.length; j++) {
      final CalendarAppointment appointment = appointments[j];
      appointment.actualStartTime =
          AppointmentHelper.convertTimeToAppointmentTimeZone(
              appointment.startTime, appointment.startTimeZone, timeZone);
      appointment.actualEndTime =
          AppointmentHelper.convertTimeToAppointmentTimeZone(
              appointment.endTime, appointment.endTimeZone, timeZone);

      if (appointment.recurrenceRule == null ||
          appointment.recurrenceRule == '') {
        if (AppointmentHelper.isAppointmentWithinVisibleDateRange(
            appointment, startDate, endDate)) {
          return true;
        }

        continue;
      }

      if (appointment.startTime.isAfter(endDate)) {
        continue;
      }

      String rule = appointment.recurrenceRule!;
      if (!rule.contains('COUNT') && !rule.contains('UNTIL')) {
        final DateFormat formatter = DateFormat('yyyyMMdd');
        final String newSubString = ';UNTIL=${formatter.format(endDate)}';
        rule = rule + newSubString;
      }

      final List<String> ruleSeparator = <String>['=', ';', ','];
      final List<String> rRule =
          RecurrenceHelper.splitRule(rule, ruleSeparator);
      if (rRule.contains('UNTIL')) {
        final String untilValue = rRule[rRule.indexOf('UNTIL') + 1];
        DateTime recurrenceEndDate =
            RecurrenceHelper.getUntilEndDate(untilValue);
        recurrenceEndDate = DateTime(recurrenceEndDate.year,
            recurrenceEndDate.month, recurrenceEndDate.day, 23, 59, 59);
        if (recurrenceEndDate.isBefore(startDate)) {
          continue;
        }
      }

      final List<DateTime> recursiveDates =
          RecurrenceHelper.getRecurrenceDateTimeCollection(
              rule, appointment.actualStartTime,
              recurrenceDuration: AppointmentHelper.getDifference(
                  appointment.actualStartTime, appointment.actualEndTime),
              specificStartDate: startDate,
              specificEndDate: endDate);

      if (recursiveDates.isEmpty) {
        continue;
      }

      if (appointment.recurrenceExceptionDates == null ||
          appointment.recurrenceExceptionDates!.isEmpty) {
        return true;
      }

      for (int i = 0; i < appointment.recurrenceExceptionDates!.length; i++) {
        final DateTime exceptionDate = appointment.recurrenceExceptionDates![i];
        for (int k = 0; k < recursiveDates.length; k++) {
          final DateTime recurrenceDate = recursiveDates[k];
          if (!isSameDate(recurrenceDate, exceptionDate)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  /// This method is used to check the appointment needs all day appointment
  /// view or not in agenda view, because the all day appointment view shown
  /// as half of the normal appointment view in agenda view.
  /// Agenda view used on month and schedule calendar view.
  bool _isAllDayAppointmentView(CalendarAppointment appointment) {
    return appointment.isAllDay ||
        appointment.isSpanned ||
        appointment.actualStartTime.day != appointment.actualEndTime.day;
  }

  /// Return the all day appointment count from appointment collection.
  int _getAllDayCount(List<CalendarAppointment> appointmentCollection) {
    int allDayCount = 0;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final CalendarAppointment appointment = appointmentCollection[i];
      if (_isAllDayAppointmentView(appointment)) {
        allDayCount += 1;
      }
    }

    return allDayCount;
  }

  /// Return the collection of appointment collection listed by
  /// start date of the appointment.
  Map<DateTime, List<CalendarAppointment>> _getAppointmentCollectionOnDateBasis(
      List<CalendarAppointment> appointmentCollection,
      DateTime startDate,
      DateTime endDate) {
    final Map<DateTime, List<CalendarAppointment>> dateAppointments =
        <DateTime, List<CalendarAppointment>>{};
    while (startDate.isBefore(endDate) || isSameDate(endDate, startDate)) {
      final List<CalendarAppointment> appointmentList = <CalendarAppointment>[];
      for (int i = 0; i < appointmentCollection.length; i++) {
        final CalendarAppointment appointment = appointmentCollection[i];
        if (!isDateWithInDateRange(appointment.actualStartTime,
            appointment.actualEndTime, startDate)) {
          continue;
        }

        appointmentList.add(appointment);
      }

      if (appointmentList.isNotEmpty) {
        dateAppointments[startDate] = appointmentList;
      }

      startDate = DateTimeHelper.getDateTimeValue(addDays(startDate, 1));
    }

    return dateAppointments;
  }

  /// Return the widget to scroll view based on index.
  Widget? _getItem(BuildContext context, int index, bool isRTL) {
    /// Assign display date and today date,
    /// schedule display date always hold the minimum date compared to
    /// display date and today date.
    /// schedule current date always hold the maximum date compared to
    /// display date and today date
    DateTime scheduleDisplayDate = _scheduleDisplayDate;
    DateTime scheduleCurrentDate = DateTime.now();
    if (scheduleDisplayDate.isAfter(scheduleCurrentDate)) {
      final DateTime tempDate = scheduleDisplayDate;
      scheduleDisplayDate = scheduleCurrentDate;
      scheduleCurrentDate = tempDate;
    }

    final bool isLoadMore = widget.loadMoreWidgetBuilder != null;

    if (isLoadMore) {
      _minDate ??= _scheduleMinDate;
      _maxDate ??= _scheduleMaxDate;
    } else {
      /// Get the minimum date of schedule view when it value as null
      /// It return min date user assigned when the [hideEmptyScheduleWeek]
      /// in [ScheduleViewSettings] disabled else it return min
      /// start date of the appointment collection.
      _minDate ??= _getMinAppointmentDate(
          _appointments,
          widget.timeZone,
          widget.minDate,
          scheduleDisplayDate,
          widget.scheduleViewSettings,
          _useMobilePlatformUI);

      /// Assign minimum date value to schedule display date when the minimum
      /// date is after of schedule display date
      _minDate = _minDate!.isAfter(scheduleDisplayDate)
          ? scheduleDisplayDate
          : _minDate;
      _minDate = _minDate!.isBefore(widget.minDate) ? widget.minDate : _minDate;

      final DateTime viewMinDate = DateTimeHelper.getDateTimeValue(
          addDays(_minDate, -(_minDate!.weekday % DateTime.daysPerWeek)));

      /// Get the maximum date of schedule view when it value as null
      /// It return max date user assigned when the [hideEmptyScheduleWeek]
      /// in [ScheduleViewSettings] disabled else it return max
      /// end date of the appointment collection.
      _maxDate ??= _getMaxAppointmentDate(
          _appointments,
          widget.timeZone,
          widget.maxDate,
          scheduleCurrentDate,
          widget.scheduleViewSettings,
          _useMobilePlatformUI);

      /// Assign maximum date value to schedule current date when the maximum
      /// date is before of schedule current date
      _maxDate = _maxDate!.isBefore(scheduleCurrentDate)
          ? scheduleCurrentDate
          : _maxDate;
      _maxDate = _maxDate!.isAfter(widget.maxDate) ? widget.maxDate : _maxDate;

      final bool hideEmptyAgendaDays =
          widget.scheduleViewSettings.hideEmptyScheduleWeek ||
              !_useMobilePlatformUI;

      if (index >= 0) {
        /// Add next 100 dates to next dates collection when index
        /// reaches next dates collection end.
        if (_nextDates.isNotEmpty && index > _nextDates.length - 20) {
          DateTime date = _nextDates[_nextDates.length - 1];
          int count = 0;

          /// Using while for calculate dates, if [hideEmptyAgendaDays] is
          /// enabled, then hide the week when it does not have appointments.
          while (count < 20) {
            for (int i = 1; i <= 100; i++) {
              final DateTime updateDate = DateTimeHelper.getDateTimeValue(
                  addDays(date, i * DateTime.daysPerWeek));

              /// Skip the weeks after the max date.
              if (!isSameOrBeforeDate(_maxDate, updateDate)) {
                count = 20;
                break;
              }

              final DateTime weekEndDate =
                  DateTimeHelper.getDateTimeValue(addDays(updateDate, 6));

              /// Skip the week date when it does not have appointments
              /// when [hideEmptyAgendaDays] as enabled and display date and
              /// current date not in between the week.
              if (!hideEmptyAgendaDays ||
                  _isAppointmentBetweenDates(_appointments, updateDate,
                      weekEndDate, widget.timeZone) ||
                  isDateWithInDateRange(
                      updateDate, weekEndDate, scheduleDisplayDate) ||
                  isDateWithInDateRange(
                      updateDate, weekEndDate, scheduleCurrentDate)) {
                _nextDates.add(updateDate);
                count++;
              }
            }

            date = DateTimeHelper.getDateTimeValue(addDays(date, 700));
          }
        }
      }

      if (index <= 0) {
        /// Add previous 100 dates to previous dates collection when index
        /// reaches previous dates collection end.
        if (_previousDates.isNotEmpty && -index > _previousDates.length - 20) {
          DateTime date = _previousDates[_previousDates.length - 1];
          int count = 0;

          /// Using while for calculate dates, if [hideEmptyAgendaDays] is
          /// enabled, then hide the week when it does not have appointments.
          while (count < 20) {
            for (int i = 1; i <= 100; i++) {
              final DateTime updatedDate = DateTimeHelper.getDateTimeValue(
                  addDays(date, -i * DateTime.daysPerWeek));

              /// Skip the weeks before the min date.
              if (!isSameOrAfterDate(viewMinDate, updatedDate)) {
                count = 20;
                break;
              }

              final DateTime weekEndDate =
                  DateTimeHelper.getDateTimeValue(addDays(updatedDate, 6));

              /// Skip the week date when it does not have appointments
              /// when [hideEmptyAgendaDays] as enabled and display date and
              /// current date not in between the week.
              if (!hideEmptyAgendaDays ||
                  _isAppointmentBetweenDates(_appointments, updatedDate,
                      weekEndDate, widget.timeZone) ||
                  isDateWithInDateRange(
                      updatedDate, weekEndDate, scheduleDisplayDate) ||
                  isDateWithInDateRange(
                      updatedDate, weekEndDate, scheduleCurrentDate)) {
                _previousDates.add(updatedDate);
                count++;
              }
            }

            date = DateTimeHelper.getDateTimeValue(addDays(date, -700));
          }
        }
      }
    }

    final int currentIndex = index;

    /// Return null when the index reached the date collection end.
    if (index >= 0
        ? _nextDates.length <= index
        : _previousDates.length <= -index - 1) {
      return null;
    }

    final DateTime startDate =
        index >= 0 ? _nextDates[index] : _previousDates[-index - 1];

    /// Set previous date form it date collection if index is first index of
    /// next dates collection then get the start date from previous dates.
    /// If the index as last index of previous dates collection then calculate
    /// by subtract the 7 days to get previous date.
    final DateTime prevDate = index == 0
        ? _previousDates.isEmpty
            ? DateTimeHelper.getDateTimeValue(
                addDays(startDate, -DateTime.daysPerWeek))
            : _previousDates[0]
        : (index > 0
            ? _nextDates[index - 1]
            : -index > _previousDates.length - 1
                ? DateTimeHelper.getDateTimeValue(
                    addDays(startDate, -DateTime.daysPerWeek))
                : _previousDates[-index]);
    final DateTime prevEndDate =
        DateTimeHelper.getDateTimeValue(addDays(prevDate, 6));
    final DateTime endDate =
        DateTimeHelper.getDateTimeValue(addDays(startDate, 6));

    bool initialMonthHeader = false;
    if (((index == 0 && _previousDates.isEmpty) ||
            (index < 0 && -index > _previousDates.length - 1)) &&
        startDate.month == _minDate!.month) {
      initialMonthHeader = true;
    }

    /// Get the visible week appointment and split the appointments based on
    /// date.
    final List<CalendarAppointment> appointmentCollection =
        AppointmentHelper.getVisibleAppointments(
            isSameOrAfterDate(_minDate, startDate) ? startDate : _minDate!,
            isSameOrBeforeDate(_maxDate, endDate) ? endDate : _maxDate!,
            _appointments,
            widget.timeZone,
            false,
            canCreateNewAppointment: false);
    appointmentCollection.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            app1.actualStartTime.compareTo(app2.actualStartTime));

    /// Get the collection of appointment collection listed by date.
    final Map<DateTime, List<CalendarAppointment>> dateAppointments =
        _getAppointmentCollectionOnDateBasis(
            appointmentCollection, startDate, endDate);
    final List<DateTime> dateAppointmentKeys = dateAppointments.keys.toList();
    const double padding = 5;

    /// Check the current week view show display date or current date view.
    bool isNeedDisplayDateHighlight =
        isDateWithInDateRange(startDate, endDate, scheduleDisplayDate);
    bool isNeedCurrentDateHighlight =
        isDateWithInDateRange(startDate, endDate, scheduleCurrentDate) &&
            !isSameDate(scheduleDisplayDate, scheduleCurrentDate);

    /// Check the schedule display date have appointments if display date
    /// in between the week
    if (isNeedDisplayDateHighlight) {
      for (int i = 0; i < dateAppointmentKeys.length; i++) {
        if (!isSameDate(scheduleDisplayDate, dateAppointmentKeys[i])) {
          continue;
        }

        isNeedDisplayDateHighlight = false;
        break;
      }
    }

    /// Check the schedule current date have appointments if current date
    /// in between the week
    if (isNeedCurrentDateHighlight) {
      for (int i = 0; i < dateAppointmentKeys.length; i++) {
        if (!isSameDate(scheduleCurrentDate, dateAppointmentKeys[i])) {
          continue;
        }

        isNeedCurrentDateHighlight = false;
        break;
      }
    }

    /// calculate the day label(eg., May 25) width based on schedule setting.
    final double viewPadding = _getAgendaViewDayLabelWidth(
        widget.scheduleViewSettings, _useMobilePlatformUI);

    final double viewTopPadding = _useMobilePlatformUI ? padding : 0;

    /// calculate the total height using height variable
    /// web view does not have week label.
    double height = _useMobilePlatformUI
        ? widget.scheduleViewSettings.weekHeaderSettings.height
        : 0;

    /// It is used to current view top position inside the collection of views.
    double topHeight = 0;

    /// Check the week date needs month header at first or before of appointment
    /// view.

    bool isNeedMonthBuilder = _useMobilePlatformUI &&
        (prevEndDate.month != startDate.month ||
            prevEndDate.year != startDate.year ||
            initialMonthHeader);

    /// Check the start date have month header and the current week have
    /// different month dates(like Feb 27 - Mar 5). This scenario raised when
    /// enabled hide schedule empty week property.
    if (isNeedMonthBuilder &&
        widget.scheduleViewSettings.hideEmptyScheduleWeek &&
        startDate.month != endDate.month) {
      /// Check the below condition(start date month have any views like
      /// current date view, display date view or appointment view) to
      /// remove the month header.
      /// 1. Check the start date month have display date view.
      /// 2. Check the start date month have today date view.
      /// 3. Check the start date month have appointment view.
      final DateTime? firstAppointmentDate =
          dateAppointmentKeys.isNotEmpty ? dateAppointmentKeys[0] : null;
      if ((startDate.month != scheduleDisplayDate.month ||
              startDate.year != scheduleDisplayDate.year) &&
          (startDate.month != scheduleCurrentDate.month ||
              startDate.year != scheduleCurrentDate.year) &&
          (firstAppointmentDate == null ||
              (startDate.month != firstAppointmentDate.month ||
                  startDate.year != firstAppointmentDate.year))) {
        isNeedMonthBuilder = false;
      }
    }

    /// Web view does not have month label.
    height += isNeedMonthBuilder
        ? widget.scheduleViewSettings.monthHeaderSettings.height
        : 0;
    final double appointmentViewHeight =
        CalendarViewHelper.getScheduleAppointmentHeight(
            null, widget.scheduleViewSettings);
    final double allDayAppointmentHeight =
        CalendarViewHelper.getScheduleAllDayAppointmentHeight(
            null, widget.scheduleViewSettings);

    /// Calculate the divider height and color when it is web view.
    final double dividerHeight = _useMobilePlatformUI ? 0 : 1;
    Color dividerColor =
        widget.cellBorderColor ?? _calendarTheme.cellBorderColor!;
    dividerColor = dividerColor.withOpacity(dividerColor.opacity * 0.5);
    int numberOfEvents = 0;

    double appointmentHeight = 0;

    /// Calculate the total height of appointment views of week.
    for (int i = 0; i < dateAppointmentKeys.length; i++) {
      final List<CalendarAppointment> currentDateAppointment =
          dateAppointments[dateAppointmentKeys[i]]!;
      final int eventsCount = currentDateAppointment.length;
      int allDayEventCount = 0;

      /// Web view does not differentiate all day and normal appointment.
      if (_useMobilePlatformUI) {
        allDayEventCount = _getAllDayCount(currentDateAppointment);
      }

      double panelHeight =
          ((eventsCount - allDayEventCount) * appointmentViewHeight) +
              (allDayEventCount * allDayAppointmentHeight);
      panelHeight = panelHeight > appointmentViewHeight
          ? panelHeight
          : appointmentViewHeight;
      appointmentHeight += panelHeight + dividerHeight;
      numberOfEvents += eventsCount;
    }

    /// Add the padding height to the appointment height
    /// Each of the appointment view have top padding in agenda view and
    /// end agenda view have end padding, so count as (numberOfEvents + 1).
    /// value 1 as padding between the  agenda view and end appointment view.
    /// each of the agenda view in the week have padding add the existing
    /// value with date appointment keys length.
    appointmentHeight +=
        (numberOfEvents + dateAppointmentKeys.length) * padding;

    /// Add appointment height and week view end padding to height.
    height += appointmentHeight + (_useMobilePlatformUI ? padding : 0);

    /// Create the generated view details to store the view height
    /// and its intersection point.
    final _ScheduleViewDetails scheduleViewDetails = _ScheduleViewDetails();
    scheduleViewDetails._intersectPoint = -1;
    double previousHeight = 0;

    /// Get the previous view end position used to find the next view end
    /// position.
    if (currentIndex >= 0) {
      previousHeight = currentIndex == 0
          ? 0
          : _forwardWidgetHeights[currentIndex - 1]!._height;
    } else {
      previousHeight = currentIndex == -1
          ? 0
          : _backwardWidgetHeights[-currentIndex - 2]!._height;
    }

    final List<Widget> widgets = <Widget>[];

    /// Web view does not have month label.
    if (_useMobilePlatformUI) {
      if (isNeedMonthBuilder) {
        /// Add the height of month label to total height of view.
        topHeight += widget.scheduleViewSettings.monthHeaderSettings.height;
        widgets.add(_getMonthOrWeekHeader(startDate, endDate, isRTL, true));

        /// Add the week label padding value to top position and total height.
        topHeight += viewTopPadding;
        height += viewTopPadding;
      }

      widgets.add(_getMonthOrWeekHeader(startDate, endDate, isRTL, false,
          viewPadding: viewPadding, isNeedTopPadding: isNeedMonthBuilder));

      /// Add the height of week label to update the top position of next view.
      topHeight += widget.scheduleViewSettings.weekHeaderSettings.height;
    }

    /// Calculate the day label(May, 25) height based on appointment height and
    /// assign the label maximum height as 60.
    double appointmentViewHeaderHeight = appointmentViewHeight + (2 * padding);
    if (_useMobilePlatformUI) {
      appointmentViewHeaderHeight =
          appointmentViewHeaderHeight > 60 ? 60 : appointmentViewHeaderHeight;
    }
    double interSectPoint = topHeight;

    /// Check the week date needs month header at in between the appointment
    /// views.
    bool isNeedInBetweenMonthBuilder = _useMobilePlatformUI &&
        (startDate.month !=
            (isSameOrBeforeDate(_maxDate, endDate) ? endDate : _maxDate!)
                .month);

    /// Check the end date month have appointments or not.
    bool isNextMonthHasNoAppointment = false;
    if (isNeedInBetweenMonthBuilder) {
      final DateTime? lastAppointmentDate = dateAppointmentKeys.isNotEmpty
          ? dateAppointmentKeys[dateAppointmentKeys.length - 1]
          : null;
      final DateTime? nextWeekDate = index == -1
          ? _nextDates[0]
          : (index < 0
              ? _previousDates[-index - 2]
              : index >= _nextDates.length - 1
                  ? null
                  : _nextDates[index + 1]);

      /// Check the following scenarios for rendering month label at last when
      /// the week holds different month dates
      /// 1. If the week does not have an appointments.
      /// 2. If the week have appointments but next month dates does not have
      /// an appointments
      /// 3. If the week have appointments but next month dates does not have
      /// an appointments but [hideEmptyScheduleWeek] enabled so the next view
      /// date month as different with current week end date week.
      isNextMonthHasNoAppointment = lastAppointmentDate == null ||
          (lastAppointmentDate.month != endDate.month &&
              nextWeekDate != null &&
              nextWeekDate.month == endDate.month &&
              nextWeekDate.year == endDate.year);

      isNeedInBetweenMonthBuilder = isNextMonthHasNoAppointment ||
          lastAppointmentDate.month != startDate.month;
    }

    /// Add the in between month label height to total height when
    /// next month dates have appointments(!isNextMonthHasNoAppointment) or
    /// next month dates does not have appointments and is before max date.
    if (isNeedInBetweenMonthBuilder &&
        (!isNextMonthHasNoAppointment ||
            isSameOrBeforeDate(
                _maxDate, DateTime(endDate.year, endDate.month)))) {
      /// Add the height of month label to total height of view and
      /// Add the month header top padding value to height when in between
      /// week needs month header
      height += widget.scheduleViewSettings.monthHeaderSettings.height +
          viewTopPadding;
    }

    /// Add appointment height to height when the view have display date view.
    if (isNeedDisplayDateHighlight) {
      height += _useMobilePlatformUI
          ? appointmentViewHeaderHeight
          : appointmentViewHeaderHeight + dividerHeight;
    }

    /// Add appointment height to height when the view have current date view.
    if (isNeedCurrentDateHighlight) {
      height += _useMobilePlatformUI
          ? appointmentViewHeaderHeight
          : appointmentViewHeaderHeight + dividerHeight;
    }

    /// display date highlight added boolean variable used to identify the
    /// display date view added or not.
    bool isDisplayDateHighlightAdded = !isNeedDisplayDateHighlight;

    /// current date highlight added boolean variable used to identify the
    /// current date view added or not.
    bool isCurrentDateHighlightAdded = !isNeedCurrentDateHighlight;

    /// Generate views on week days that have appointments.
    for (int i = 0; i < dateAppointmentKeys.length; i++) {
      final DateTime currentDate = dateAppointmentKeys[i];
      final List<CalendarAppointment> currentAppointments =
          dateAppointments[currentDate]!;
      final int eventsCount = currentAppointments.length;
      int allDayEventCount = 0;

      /// Web view does not differentiate all day and normal appointment.
      if (_useMobilePlatformUI) {
        allDayEventCount = _getAllDayCount(currentAppointments);
      }

      void addMonthHeaderView() {
        /// Assign the intersection point based on previous view end position.
        scheduleViewDetails._intersectPoint = currentIndex >= 0
            ? previousHeight + interSectPoint + viewTopPadding
            : previousHeight + height - interSectPoint - viewTopPadding;

        /// Web view does not have month label;
        if (_useMobilePlatformUI) {
          interSectPoint +=
              widget.scheduleViewSettings.monthHeaderSettings.height +
                  viewTopPadding;
          widgets.add(_getMonthOrWeekHeader(currentDate, null, isRTL, true,
              isNeedTopPadding: true));
        }
      }

      void addDisplayOrCurrentDateView({bool isDisplayDate = true}) {
        final double highlightViewStartPosition = currentIndex >= 0
            ? previousHeight + interSectPoint
            : -(previousHeight + height - interSectPoint);
        widgets.add(_getDisplayDateView(
            isRTL,
            isDisplayDate ? scheduleDisplayDate : scheduleCurrentDate,
            highlightViewStartPosition,
            viewPadding,
            appointmentViewHeaderHeight,
            padding));

        /// Add divider at end of each of the week days in web view.
        if (!_useMobilePlatformUI) {
          widgets.add(Divider(
            height: dividerHeight,
            thickness: 1,
            color: dividerColor,
          ));
        }

        /// Add intersect value with appointment height and divider height
        /// because display date view height as single appointment view height
        interSectPoint += appointmentViewHeaderHeight + dividerHeight;
        topHeight += appointmentViewHeaderHeight + dividerHeight;
        if (isDisplayDate) {
          isDisplayDateHighlightAdded = true;
        } else {
          isCurrentDateHighlightAdded = true;
        }
      }

      /// Check the display date view not added in widget and appointment
      /// date is after of display date then add the display date view.
      /// Checking the current date month and display date month is required
      /// Eg., if week (Feb 28 - Mar 6), Feb 28 does not have appointments
      /// and Feb 28 is display date and Mar 1 have appointments then the view
      /// order is month header(march), display date(feb 28), So check whether
      /// current date(Mar 1) month not equal then add the display date view
      /// before month header.
      if (!isDisplayDateHighlightAdded &&
          currentDate.isAfter(scheduleDisplayDate) &&
          currentDate.month != scheduleDisplayDate.month) {
        addDisplayOrCurrentDateView();
      }

      /// Check the current date view not added in widget and appointment
      /// date is after of current date then add the current date view.
      /// Checking the current date month and today date month is required
      /// Eg., if week (Feb 28 - Mar 6), Feb 28 does not have appointments
      /// and Feb 28 is today date and Mar 1 have appointments then the view
      /// order is month header(march), today date(feb 28), So check whether
      /// current date(Mar 1) month not equal then add the today date view
      /// before month header.
      if (!isCurrentDateHighlightAdded &&
          currentDate.isAfter(scheduleCurrentDate) &&
          currentDate.month != scheduleCurrentDate.month) {
        addDisplayOrCurrentDateView(isDisplayDate: false);
      }

      /// Check if the view intersection point not set and the current week date
      /// month differ from the week start date then assign the intersection
      /// point.
      if (scheduleViewDetails._intersectPoint == -1 &&
          (startDate.month != currentDate.month ||
              startDate.year != currentDate.year)) {
        addMonthHeaderView();
      }

      /// Check the display date view not added in widget and appointment
      /// date is after of display date then add the display date view.
      if (!isDisplayDateHighlightAdded &&
          currentDate.isAfter(scheduleDisplayDate)) {
        addDisplayOrCurrentDateView();
      }

      /// Check the current date view not added in widget and appointment
      /// date is after of current date then add the current date view.
      if (!isCurrentDateHighlightAdded &&
          currentDate.isAfter(scheduleCurrentDate)) {
        addDisplayOrCurrentDateView(isDisplayDate: false);
      }

      final double totalPadding = (eventsCount + 1) * padding;
      final double panelHeight = totalPadding +
          ((eventsCount - allDayEventCount) * appointmentViewHeight) +
          (allDayEventCount * allDayAppointmentHeight);
      double appointmentViewTopPadding = 0;
      double appointmentViewPadding = 0;
      if (panelHeight < appointmentViewHeaderHeight) {
        appointmentViewPadding = appointmentViewHeaderHeight - panelHeight;
        appointmentViewTopPadding = appointmentViewPadding / 2;
      }

      final double viewStartPosition = currentIndex >= 0
          ? previousHeight + interSectPoint
          : -(previousHeight + height - interSectPoint);

      interSectPoint += appointmentViewPadding;
      currentAppointments.sort(
          (CalendarAppointment app1, CalendarAppointment app2) =>
              app1.actualStartTime.compareTo(app2.actualStartTime));
      currentAppointments.sort(
          (CalendarAppointment app1, CalendarAppointment app2) =>
              AppointmentHelper.orderAppointmentsAscending(
                  app1.isAllDay, app2.isAllDay));
      currentAppointments.sort(
          (CalendarAppointment app1, CalendarAppointment app2) =>
              AppointmentHelper.orderAppointmentsAscending(
                  app1.isSpanned, app2.isSpanned));

      /// Add appointment view to the current views collection.
      widgets.add(MouseRegion(
          onEnter: (PointerEnterEvent event) {
            _pointerEnterEvent(event, false, isRTL, currentDate,
                viewStartPosition, appointmentViewTopPadding);
          },
          onExit: _pointerExitEvent,
          onHover: (PointerHoverEvent event) {
            _pointerHoverEvent(event, false, isRTL, currentDate,
                viewStartPosition, appointmentViewTopPadding);
          },
          child: GestureDetector(
            child: _ScheduleAppointmentView(
                header: CustomPaint(
                    painter: _AgendaDateTimePainter(
                        currentDate,
                        null,
                        widget.scheduleViewSettings,
                        widget.todayHighlightColor ??
                            _calendarTheme.todayHighlightColor,
                        widget.todayTextStyle,
                        _locale,
                        _calendarTheme,
                        _themeData,
                        _agendaDateNotifier,
                        _minWidth,
                        isRTL,
                        _textScaleFactor,
                        _isMobilePlatform),
                    size: Size(viewPadding, appointmentViewHeaderHeight)),
                content: Container(
                  padding: EdgeInsets.fromLTRB(
                      isRTL ? 0 : viewPadding,
                      appointmentViewTopPadding,
                      isRTL ? viewPadding : 0,
                      appointmentViewTopPadding),
                  child: AgendaViewLayout(
                      null,
                      widget.scheduleViewSettings,
                      currentDate,
                      currentAppointments,
                      isRTL,
                      _locale,
                      _localizations,
                      _calendarTheme,
                      _themeData,
                      _agendaViewNotifier,
                      widget.appointmentTimeTextFormat,
                      viewPadding,
                      _textScaleFactor,
                      _isMobilePlatform,
                      widget.appointmentBuilder,
                      _minWidth - viewPadding,
                      panelHeight,
                      widget.monthViewSettings.agendaStyle.placeholderTextStyle,
                      widget),
                )),
            onTapUp: (TapUpDetails details) {
              _removeDatePicker();
              if (widget.allowViewNavigation &&
                  ((!_isRTL && details.localPosition.dx < viewPadding) ||
                      (_isRTL &&
                          details.localPosition.dx >
                              _minWidth - viewPadding))) {
                _controller.view = CalendarView.day;
                _controller.displayDate = currentDate;
              }

              if (!CalendarViewHelper.shouldRaiseCalendarTapCallback(
                  widget.onTap)) {
                return;
              }

              _raiseCallbackForScheduleView(currentDate, details.localPosition,
                  currentAppointments, viewPadding, padding, true);
            },
            onLongPressStart: (LongPressStartDetails details) {
              _removeDatePicker();
              if (widget.allowViewNavigation &&
                  ((!_isRTL && details.localPosition.dx < viewPadding) ||
                      (_isRTL &&
                          details.localPosition.dx >
                              _minWidth - viewPadding))) {
                _controller.view = CalendarView.day;
                _controller.displayDate = currentDate;
              }

              if (!CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
                  widget.onLongPress)) {
                return;
              }

              _raiseCallbackForScheduleView(currentDate, details.localPosition,
                  currentAppointments, viewPadding, padding, false);
            },
          )));

      interSectPoint += panelHeight + dividerHeight;

      /// Add divider at end of each of the week days in web view.
      if (!_useMobilePlatformUI) {
        widgets.add(Divider(
          height: dividerHeight,
          thickness: 1,
          color: dividerColor,
        ));
      }
    }

    /// Check the display date view not added when it month value not equal to
    /// end date month value.
    if (!isDisplayDateHighlightAdded &&
        endDate.month != scheduleDisplayDate.month) {
      final double highlightViewStartPosition = currentIndex >= 0
          ? previousHeight + topHeight + appointmentHeight
          : previousHeight + height - topHeight - appointmentHeight;
      widgets.add(_getDisplayDateView(
          isRTL,
          scheduleDisplayDate,
          highlightViewStartPosition,
          viewPadding,
          appointmentViewHeaderHeight,
          padding));

      /// Add divider at end of each of the week days in web view.
      if (!_useMobilePlatformUI) {
        widgets.add(Divider(
          height: dividerHeight,
          thickness: 1,
          color: dividerColor,
        ));
      }

      /// Add the top height value with display date view height because the
      /// month header added after the display date view added and its
      /// intersect point calculated based on top height.
      topHeight += appointmentViewHeaderHeight + dividerHeight;
      isDisplayDateHighlightAdded = true;
    }

    /// Check the current date view not added when it month value not equal to
    /// end date month value.
    if (!isCurrentDateHighlightAdded &&
        endDate.month != scheduleCurrentDate.month) {
      final double highlightViewStartPosition = currentIndex >= 0
          ? previousHeight + topHeight + appointmentHeight
          : previousHeight + height - topHeight - appointmentHeight;
      widgets.add(_getDisplayDateView(
          isRTL,
          scheduleCurrentDate,
          highlightViewStartPosition,
          viewPadding,
          appointmentViewHeaderHeight,
          padding));

      /// Add divider at end of each of the week days in web view.
      if (!_useMobilePlatformUI) {
        widgets.add(Divider(
          height: dividerHeight,
          thickness: 1,
          color: dividerColor,
        ));
      }

      /// Add the top height value with current date view height because the
      /// month header added after the current date view added and its
      /// intersect point calculated based on top height.
      topHeight += appointmentViewHeaderHeight + dividerHeight;
      isCurrentDateHighlightAdded = true;
    }

    /// Web view does not have month label.
    /// Add Month label at end of the view when the week start and end date
    /// month different and week does not have appointments or week have
    /// appointments but end date month dates does not have an appointment
    if (_useMobilePlatformUI &&
        isNeedInBetweenMonthBuilder &&
        isNextMonthHasNoAppointment &&
        isSameOrBeforeDate(_maxDate, DateTime(endDate.year, endDate.month))) {
      /// Calculate and assign the intersection point because the current
      /// view holds next month label. if scrolling reaches this position
      /// then we update the header date so add the location to intersecting
      /// point.
      scheduleViewDetails._intersectPoint = currentIndex >= 0
          ? previousHeight + topHeight + appointmentHeight + viewTopPadding
          : previousHeight +
              height -
              topHeight -
              appointmentHeight -
              viewTopPadding;
      topHeight += widget.scheduleViewSettings.monthHeaderSettings.height +
          viewTopPadding;
      widgets.add(_getMonthOrWeekHeader(endDate, endDate, isRTL, true,
          isNeedTopPadding: true));
    }

    /// Add the display date view at end of week view when
    /// it does not added to widget.
    if (!isDisplayDateHighlightAdded) {
      final double highlightViewStartPosition = currentIndex >= 0
          ? previousHeight + topHeight + appointmentHeight
          : previousHeight + height - topHeight - appointmentHeight;
      widgets.add(_getDisplayDateView(
          isRTL,
          scheduleDisplayDate,
          highlightViewStartPosition,
          viewPadding,
          appointmentViewHeaderHeight,
          padding));

      /// Add divider at end of each of the week days in web view.
      if (!_useMobilePlatformUI) {
        widgets.add(Divider(
          height: dividerHeight,
          thickness: 1,
          color: dividerColor,
        ));
      }
      isDisplayDateHighlightAdded = true;
    }

    /// Add the current date view at end of week view
    /// when it does not added to widget.
    if (!isCurrentDateHighlightAdded) {
      final double highlightViewStartPosition = currentIndex >= 0
          ? previousHeight + topHeight + appointmentHeight
          : previousHeight + height - topHeight - appointmentHeight;
      widgets.add(_getDisplayDateView(
          isRTL,
          scheduleCurrentDate,
          highlightViewStartPosition,
          viewPadding,
          appointmentViewHeaderHeight,
          padding));

      /// Add divider at end of each of the week days in web view.
      if (!_useMobilePlatformUI) {
        widgets.add(Divider(
          height: dividerHeight,
          thickness: 1,
          color: dividerColor,
        ));
      }
      isCurrentDateHighlightAdded = true;
    }

    /// Update the current view end position based previous view
    /// end position and current view height.
    scheduleViewDetails._height = previousHeight + height;
    if (currentIndex >= 0) {
      _forwardWidgetHeights[currentIndex] = scheduleViewDetails;
    } else {
      _backwardWidgetHeights[-currentIndex - 1] = scheduleViewDetails;
    }

    return SizedBox(height: height, child: Column(children: widgets));
  }

  Widget _getMonthOrWeekHeader(
      DateTime startDate, DateTime? endDate, bool isRTL, bool isMonthLabel,
      {double viewPadding = 0, bool isNeedTopPadding = false}) {
    const double padding = 5;
    Widget? headerWidget;
    if (isMonthLabel && widget.scheduleViewMonthHeaderBuilder != null) {
      final ScheduleViewMonthHeaderDetails details =
          ScheduleViewMonthHeaderDetails(
              DateTime(startDate.year, startDate.month),
              Rect.fromLTWH(0, 0, _minWidth,
                  widget.scheduleViewSettings.monthHeaderSettings.height));
      headerWidget = widget.scheduleViewMonthHeaderBuilder!(context, details);
    }

    return GestureDetector(
        child: Container(
            padding: isMonthLabel
                ? EdgeInsets.fromLTRB(0, isNeedTopPadding ? padding : 0, 0, 0)
                : EdgeInsets.fromLTRB(isRTL ? 0 : viewPadding,
                    isNeedTopPadding ? padding : 0, isRTL ? viewPadding : 0, 0),
            child: RepaintBoundary(
                child: headerWidget != null
                    ? SizedBox(
                        width: _minWidth,
                        height: widget
                            .scheduleViewSettings.monthHeaderSettings.height,
                        child: headerWidget,
                      )
                    : CustomPaint(
                        painter: _ScheduleLabelPainter(
                            startDate,
                            endDate,
                            widget.scheduleViewSettings,
                            isMonthLabel,
                            isRTL,
                            _locale,
                            _useMobilePlatformUI,
                            _agendaViewNotifier,
                            _calendarTheme,
                            _themeData,
                            _localizations,
                            _textScaleFactor),
                        size: isMonthLabel
                            ? Size(
                                _minWidth,
                                widget.scheduleViewSettings.monthHeaderSettings
                                    .height)
                            : Size(
                                _minWidth - viewPadding - (2 * padding),
                                widget.scheduleViewSettings.weekHeaderSettings
                                    .height),
                      ))),
        onTapUp: (TapUpDetails details) {
          _removeDatePicker();
          if (!CalendarViewHelper.shouldRaiseCalendarTapCallback(
              widget.onTap)) {
            return;
          }

          CalendarViewHelper.raiseCalendarTapCallback(
              widget,
              DateTime(startDate.year, startDate.month, startDate.day),
              null,
              isMonthLabel
                  ? CalendarElement.header
                  : CalendarElement.viewHeader,
              null);
        },
        onLongPressStart: (LongPressStartDetails details) {
          _removeDatePicker();
          if (!CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
              widget.onLongPress)) {
            return;
          }

          CalendarViewHelper.raiseCalendarLongPressCallback(
              widget,
              DateTime(startDate.year, startDate.month, startDate.day),
              null,
              isMonthLabel
                  ? CalendarElement.header
                  : CalendarElement.viewHeader,
              null);
        });
  }

  Widget _getDisplayDateView(
      bool isRTL,
      DateTime currentDisplayDate,
      double highlightViewStartPosition,
      double viewHeaderWidth,
      double displayDateHighlightHeight,
      double padding) {
    return MouseRegion(
        onEnter: (PointerEnterEvent event) {
          _pointerEnterEvent(event, true, isRTL, currentDisplayDate,
              highlightViewStartPosition);
        },
        onExit: _pointerExitEvent,
        onHover: (PointerHoverEvent event) {
          _pointerHoverEvent(event, true, isRTL, currentDisplayDate,
              highlightViewStartPosition);
        },
        child: GestureDetector(
          child: _ScheduleAppointmentView(
              header: CustomPaint(
                  painter: _AgendaDateTimePainter(
                      currentDisplayDate,
                      null,
                      widget.scheduleViewSettings,
                      widget.todayHighlightColor ??
                          _calendarTheme.todayHighlightColor,
                      widget.todayTextStyle,
                      _locale,
                      _calendarTheme,
                      _themeData,
                      _agendaDateNotifier,
                      _minWidth,
                      isRTL,
                      _textScaleFactor,
                      _isMobilePlatform),
                  size: Size(viewHeaderWidth, displayDateHighlightHeight)),
              content: Container(
                padding: EdgeInsets.fromLTRB(isRTL ? 0 : viewHeaderWidth, 0,
                    isRTL ? viewHeaderWidth : 0, 0),
                child: CustomPaint(
                    painter: _ScheduleLabelPainter(
                        currentDisplayDate,
                        null,
                        widget.scheduleViewSettings,
                        false,
                        isRTL,
                        _locale,
                        _useMobilePlatformUI,
                        _agendaViewNotifier,
                        _calendarTheme,
                        _themeData,
                        _localizations,
                        _textScaleFactor,
                        isDisplayDate: true),
                    size: Size(_minWidth - viewHeaderWidth,
                        displayDateHighlightHeight)),
              )),
          onTapUp: (TapUpDetails details) {
            _removeDatePicker();
            if (widget.allowViewNavigation &&
                ((!_isRTL && details.localPosition.dx < viewHeaderWidth) ||
                    (_isRTL &&
                        details.localPosition.dx >
                            _minWidth - viewHeaderWidth))) {
              _controller.view = CalendarView.day;
              _controller.displayDate = currentDisplayDate;
            }

            if (!CalendarViewHelper.shouldRaiseCalendarTapCallback(
                widget.onTap)) {
              return;
            }

            _raiseCallbackForScheduleView(
                currentDisplayDate,
                details.localPosition,
                <CalendarAppointment>[],
                viewHeaderWidth,
                padding,
                true,
                isDisplayDate: true);
          },
          onLongPressStart: (LongPressStartDetails details) {
            _removeDatePicker();
            if (widget.allowViewNavigation &&
                ((!_isRTL && details.localPosition.dx < viewHeaderWidth) ||
                    (_isRTL &&
                        details.localPosition.dx >
                            _minWidth - viewHeaderWidth))) {
              _controller.view = CalendarView.day;
              _controller.displayDate = currentDisplayDate;
            }

            if (!CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
                widget.onLongPress)) {
              return;
            }

            _raiseCallbackForScheduleView(
                currentDisplayDate,
                details.localPosition,
                <CalendarAppointment>[],
                viewHeaderWidth,
                padding,
                false,
                isDisplayDate: true);
          },
        ));
  }

  void _raiseCallbackForScheduleView(
      DateTime currentDate,
      Offset offset,
      List<CalendarAppointment> appointments,
      double viewHeaderWidth,
      double padding,
      bool isTapCallback,
      {bool isDisplayDate = false}) {
    /// Check the touch position on day label
    if ((!_isRTL && viewHeaderWidth >= offset.dx) ||
        (_isRTL && _minWidth - viewHeaderWidth < offset.dx)) {
      final List<CalendarAppointment> currentAppointments =
          <CalendarAppointment>[];
      for (int i = 0; i < appointments.length; i++) {
        final CalendarAppointment appointment = appointments[i];
        currentAppointments.add(appointment);
      }

      if (isTapCallback) {
        CalendarViewHelper.raiseCalendarTapCallback(
            widget,
            DateTime(currentDate.year, currentDate.month, currentDate.day),
            widget.dataSource != null &&
                    !AppointmentHelper.isCalendarAppointment(widget.dataSource!)
                ? CalendarViewHelper.getCustomAppointments(
                    currentAppointments, widget.dataSource)
                : currentAppointments,
            CalendarElement.viewHeader,
            null);
      } else {
        CalendarViewHelper.raiseCalendarLongPressCallback(
            widget,
            DateTime(currentDate.year, currentDate.month, currentDate.day),
            widget.dataSource != null &&
                    !AppointmentHelper.isCalendarAppointment(widget.dataSource!)
                ? CalendarViewHelper.getCustomAppointments(
                    currentAppointments, widget.dataSource)
                : currentAppointments,
            CalendarElement.viewHeader,
            null);
      }
    } else {
      /// Calculate the touch position appointment from its collection.
      double currentYPosition = padding;
      final double itemHeight = CalendarViewHelper.getScheduleAppointmentHeight(
          null, widget.scheduleViewSettings);
      final double allDayItemHeight =
          CalendarViewHelper.getScheduleAllDayAppointmentHeight(
              null, widget.scheduleViewSettings);
      if (isDisplayDate) {
        if (isTapCallback) {
          CalendarViewHelper.raiseCalendarTapCallback(
              widget,
              DateTime(currentDate.year, currentDate.month, currentDate.day),
              null,
              CalendarElement.calendarCell,
              null);
        } else {
          CalendarViewHelper.raiseCalendarLongPressCallback(
              widget,
              DateTime(currentDate.year, currentDate.month, currentDate.day),
              null,
              CalendarElement.calendarCell,
              null);
        }

        return;
      }

      for (int k = 0; k < appointments.length; k++) {
        final CalendarAppointment appointment = appointments[k];
        final double currentAppointmentHeight =
            (_useMobilePlatformUI && _isAllDayAppointmentView(appointment)
                    ? allDayItemHeight
                    : itemHeight) +
                padding;
        if (currentYPosition <= offset.dy &&
            currentYPosition + currentAppointmentHeight > offset.dy) {
          final List<CalendarAppointment> selectedAppointment =
              <CalendarAppointment>[appointment];
          if (isTapCallback) {
            CalendarViewHelper.raiseCalendarTapCallback(
                widget,
                DateTime(currentDate.year, currentDate.month, currentDate.day),
                widget.dataSource != null &&
                        !AppointmentHelper.isCalendarAppointment(
                            widget.dataSource!)
                    ? CalendarViewHelper.getCustomAppointments(
                        selectedAppointment, widget.dataSource)
                    : selectedAppointment,
                CalendarElement.appointment,
                null);
          } else {
            CalendarViewHelper.raiseCalendarLongPressCallback(
                widget,
                DateTime(currentDate.year, currentDate.month, currentDate.day),
                widget.dataSource != null &&
                        !AppointmentHelper.isCalendarAppointment(
                            widget.dataSource!)
                    ? CalendarViewHelper.getCustomAppointments(
                        selectedAppointment, widget.dataSource)
                    : selectedAppointment,
                CalendarElement.appointment,
                null);
          }
          break;
        }

        currentYPosition += currentAppointmentHeight;
      }
    }
  }

  Widget addAgenda(double height, bool isRTL) {
    final bool hideEmptyAgendaDays =
        widget.scheduleViewSettings.hideEmptyScheduleWeek ||
            !_useMobilePlatformUI;

    /// return empty view when [hideEmptyAgendaDays] enabled and
    /// the appointments as empty.
    if (!_timeZoneLoaded) {
      return Container();
    }

    final DateTime scheduleDisplayDate = DateTimeHelper.getDateTimeValue(
        getValidDate(widget.minDate, widget.maxDate, _scheduleDisplayDate));
    final DateTime scheduleCurrentDate = DateTime.now();
    final DateTime currentMaxDate =
        scheduleDisplayDate.isAfter(scheduleCurrentDate)
            ? scheduleDisplayDate
            : scheduleCurrentDate;
    final DateTime currentMinDate =
        scheduleDisplayDate.isBefore(scheduleCurrentDate)
            ? scheduleDisplayDate
            : scheduleCurrentDate;

    /// Get the minimum date of schedule view when it value as null
    /// It return min date user assigned when the [hideEmptyAgendaDays]
    /// in [ScheduleViewSettings] disabled else it return min
    /// start date of the appointment collection.
    _minDate = _getMinAppointmentDate(
        _appointments,
        widget.timeZone,
        widget.minDate,
        currentMinDate,
        widget.scheduleViewSettings,
        _useMobilePlatformUI);

    /// Assign minimum date value to current minimum date when the minimum
    /// date is before of current minimum date
    _minDate = _minDate!.isAfter(currentMinDate) ? currentMinDate : _minDate;
    _minDate = _minDate!.isBefore(widget.minDate) ? widget.minDate : _minDate;

    final DateTime viewMinDate = DateTimeHelper.getDateTimeValue(
        addDays(_minDate, -(_minDate!.weekday % DateTime.daysPerWeek)));

    /// Get the maximum date of schedule view when it value as null
    /// It return max date user assigned when the [hideEmptyAgendaDays]
    /// in [ScheduleViewSettings] disabled else it return max
    /// end date of the appointment collection.
    _maxDate = _getMaxAppointmentDate(
        _appointments,
        widget.timeZone,
        widget.maxDate,
        currentMaxDate,
        widget.scheduleViewSettings,
        _useMobilePlatformUI);

    /// Assign maximum date value to current maximum date when the maximum
    /// date is before of current maximum date
    _maxDate = _maxDate!.isBefore(currentMaxDate) ? currentMaxDate : _maxDate;
    _maxDate = _maxDate!.isAfter(widget.maxDate) ? widget.maxDate : _maxDate;

    final double appointmentViewHeight =
        CalendarViewHelper.getScheduleAppointmentHeight(
            null, widget.scheduleViewSettings);
    final double allDayAppointmentHeight =
        CalendarViewHelper.getScheduleAllDayAppointmentHeight(
            null, widget.scheduleViewSettings);

    /// Get the view first date based on specified
    /// display date  and first day of week.
    int value = -(scheduleDisplayDate.weekday % DateTime.daysPerWeek) +
        widget.firstDayOfWeek -
        DateTime.daysPerWeek;
    if (value.abs() >= DateTime.daysPerWeek) {
      value += DateTime.daysPerWeek;
    }

    if (_previousDates.isEmpty) {
      /// Calculate the start date from display date if next view dates
      /// collection as empty.
      DateTime date = _nextDates.isNotEmpty
          ? _nextDates[0]
          : DateTimeHelper.getDateTimeValue(
              addDays(scheduleDisplayDate, value));
      int count = 0;

      /// Using while for calculate dates because if [hideEmptyAgendaDays] as
      /// enabled, then it hides the weeks when it does not have appointments.
      while (count < 50) {
        for (int i = 1; i <= 100; i++) {
          final DateTime updatedDate = DateTimeHelper.getDateTimeValue(
              addDays(date, -i * DateTime.daysPerWeek));

          /// Skip week dates before min date
          if (!isSameOrAfterDate(viewMinDate, updatedDate)) {
            count = 50;
            break;
          }

          final DateTime weekEndDate =
              DateTimeHelper.getDateTimeValue(addDays(updatedDate, 6));

          /// Skip the week date when it does not have appointments
          /// when [hideEmptyAgendaDays] as enabled.
          if (hideEmptyAgendaDays &&
              !_isAppointmentBetweenDates(
                  _appointments, updatedDate, weekEndDate, widget.timeZone) &&
              !isDateWithInDateRange(
                  updatedDate, weekEndDate, scheduleDisplayDate) &&
              !isDateWithInDateRange(
                  updatedDate, weekEndDate, scheduleCurrentDate)) {
            continue;
          }

          bool isEqualDate = false;

          /// Check the date placed in next dates collection, when
          /// previous dates collection is empty.
          /// Eg., if [hideEmptyAgendaDays] property enabled but after the
          /// display date does not have a appointment then the previous
          /// dates collection initial dates added to next dates.
          if (_previousDates.isEmpty) {
            for (int i = 0; i < _nextDates.length; i++) {
              final DateTime date = _nextDates[i];
              if (isSameDate(date, updatedDate)) {
                isEqualDate = true;
                break;
              }
            }
          }

          if (isEqualDate) {
            continue;
          }

          _previousDates.add(updatedDate);
          count++;
        }

        date = DateTimeHelper.getDateTimeValue(addDays(date, -700));
      }
    }

    if (_nextDates.isEmpty) {
      /// Calculate the start date from display date
      DateTime date =
          DateTimeHelper.getDateTimeValue(addDays(scheduleDisplayDate, value));
      int count = 0;

      /// Using while for calculate dates because if [hideEmptyAgendaDays] as
      /// enabled, then it hides the weeks when it does not have appointments.
      while (count < 50) {
        for (int i = 0; i < 100; i++) {
          final DateTime updatedDate = DateTimeHelper.getDateTimeValue(
              addDays(date, i * DateTime.daysPerWeek));

          /// Skip week date after max date
          if (!isSameOrBeforeDate(_maxDate, updatedDate)) {
            count = 50;
            break;
          }

          final DateTime weekEndDate =
              DateTimeHelper.getDateTimeValue(addDays(updatedDate, 6));

          /// Skip the week date when it does not have appointments
          /// when [hideEmptyAgendaDays] as enabled.
          if (hideEmptyAgendaDays &&
              !_isAppointmentBetweenDates(
                  _appointments, updatedDate, weekEndDate, widget.timeZone) &&
              !isDateWithInDateRange(
                  updatedDate, weekEndDate, scheduleDisplayDate) &&
              !isDateWithInDateRange(
                  updatedDate, weekEndDate, scheduleCurrentDate)) {
            continue;
          }

          _nextDates.add(updatedDate);
          count++;
        }

        date = DateTimeHelper.getDateTimeValue(addDays(date, 700));
      }
    }

    /// Calculate the next views dates when [hideEmptyAgendaDays] property
    /// enabled but after the display date does not have a appointment to the
    /// viewport then the previous dates collection initial dates added to next
    /// dates.
    if (_nextDates.length < 10 && _previousDates.isNotEmpty) {
      double totalHeight = 0;

      /// This boolean variable is used to check whether the previous dates
      /// collection dates added to next dates collection or not.
      bool isNewDatesAdded = false;

      /// Add the previous view dates start date to next dates collection and
      /// remove the date from previous dates collection when next dates as
      /// empty.
      if (_nextDates.isEmpty) {
        isNewDatesAdded = true;
        _nextDates.add(_previousDates[0]);
        _previousDates.removeAt(0);
      }

      /// Calculate the next dates collection appointments height to check
      /// the appointments fill the view port or not, if not then add another
      /// previous view dates and calculate the same until the next view dates
      /// appointment fills the view port.
      DateTime viewStartDate = _nextDates[0];
      DateTime viewEndDate = DateTimeHelper.getDateTimeValue(
          addDays(_nextDates[_nextDates.length - 1], 6));
      List<CalendarAppointment> appointmentCollection =
          AppointmentHelper.getVisibleAppointments(
              viewStartDate,
              isSameOrBeforeDate(_maxDate, viewEndDate)
                  ? viewEndDate
                  : _maxDate!,
              _appointments,
              widget.timeZone,
              false);

      const double padding = 5;
      Map<DateTime, List<CalendarAppointment>> dateAppointments =
          _getAppointmentCollectionOnDateBasis(
              appointmentCollection, viewStartDate, viewEndDate);
      List<DateTime> dateAppointmentKeys = dateAppointments.keys.toList();

      double labelHeight = 0;
      if (_useMobilePlatformUI) {
        DateTime previousDate =
            DateTimeHelper.getDateTimeValue(addDays(viewStartDate, -1));
        for (int i = 0; i < _nextDates.length; i++) {
          final DateTime nextDate = _nextDates[i];
          if (previousDate.month != nextDate.month) {
            labelHeight +=
                widget.scheduleViewSettings.monthHeaderSettings.height +
                    padding;
          }

          previousDate = nextDate;
          labelHeight += widget.scheduleViewSettings.weekHeaderSettings.height;
        }
      }

      int allDayCount = 0;
      int numberOfEvents = 0;
      for (int i = 0; i < dateAppointmentKeys.length; i++) {
        final List<CalendarAppointment> currentDateAppointment =
            dateAppointments[dateAppointmentKeys[i]]!;
        if (_useMobilePlatformUI) {
          allDayCount += _getAllDayCount(currentDateAppointment);
        }

        numberOfEvents += currentDateAppointment.length;
      }

      /// Check the next dates collection appointments height fills the view
      /// port or not, if not then add another previous view dates and calculate
      /// the same until the next view dates appointments fills the view port.
      while (totalHeight < height &&
          (_previousDates.isNotEmpty || totalHeight == 0)) {
        /// Initially appointment height as 0 and check the existing dates
        /// appointment fills the view port or not. if not then add
        /// another previous view dates
        if (totalHeight != 0) {
          final DateTime currentDate = _previousDates[0];
          _nextDates.insert(0, currentDate);
          _previousDates.removeAt(0);
          isNewDatesAdded = true;

          viewStartDate = currentDate;
          viewEndDate =
              DateTimeHelper.getDateTimeValue(addDays(currentDate, 6));

          /// Calculate the newly added date appointment height and add
          /// the height to existing appointments height.
          appointmentCollection = AppointmentHelper.getVisibleAppointments(
              viewStartDate,
              isSameOrBeforeDate(_maxDate, viewEndDate)
                  ? viewEndDate
                  : _maxDate!,
              _appointments,
              widget.timeZone,
              false);

          if (_useMobilePlatformUI) {
            final DateTime nextDate = _nextDates[1];
            if (nextDate.month != viewStartDate.month) {
              labelHeight +=
                  widget.scheduleViewSettings.monthHeaderSettings.height +
                      padding;
            }

            labelHeight +=
                widget.scheduleViewSettings.weekHeaderSettings.height;
          }

          dateAppointments = _getAppointmentCollectionOnDateBasis(
              appointmentCollection, viewStartDate, viewEndDate);
          dateAppointmentKeys = dateAppointments.keys.toList();
          for (int i = 0; i < dateAppointmentKeys.length; i++) {
            final List<CalendarAppointment> currentDateAppointment =
                dateAppointments[dateAppointmentKeys[i]]!;
            if (_useMobilePlatformUI) {
              allDayCount += _getAllDayCount(currentDateAppointment);
            }

            numberOfEvents += currentDateAppointment.length;
          }
        }

        totalHeight = ((numberOfEvents + 1) * padding) +
            ((numberOfEvents - allDayCount) * appointmentViewHeight) +
            (allDayCount * allDayAppointmentHeight) +
            labelHeight;
      }

      /// Update the header date because the next dates insert the previous view
      /// dates at initial position.
      if (_nextDates.isNotEmpty && isNewDatesAdded) {
        _headerUpdateNotifier.value = DateTimeHelper.getDateTimeValue(
            getValidDate(widget.minDate, widget.maxDate, _nextDates[0]));
      }
    }

    /// The below codes used to scroll the view to current display date.
    /// If display date as May 29, 2020 then its week day as friday but first
    /// day of week as sunday then May 23, 2020 as shown, calculate the
    /// in between space between the May 23 to May 28 and assign the value to
    /// scroll controller initial scroll position
    if (_nextDates.isNotEmpty &&
        _agendaScrollController!.initialScrollOffset == 0 &&
        !_agendaScrollController!.hasClients) {
      final DateTime viewStartDate = _nextDates[0];
      final DateTime viewEndDate =
          DateTimeHelper.getDateTimeValue(addDays(viewStartDate, 6));
      if (viewStartDate.isBefore(scheduleDisplayDate) &&
          !isSameDate(viewStartDate, scheduleDisplayDate) &&
          isSameOrBeforeDate(viewEndDate, scheduleDisplayDate)) {
        final DateTime viewEndDate =
            DateTimeHelper.getDateTimeValue(addDays(scheduleDisplayDate, -1));

        final double initialScrollPosition = _getInitialScrollPosition(
            viewStartDate,
            viewEndDate,
            scheduleCurrentDate,
            appointmentViewHeight,
            allDayAppointmentHeight);
        if (initialScrollPosition != 0) {
          _agendaScrollController?.removeListener(_handleScheduleViewScrolled);
          _agendaScrollController =
              ScrollController(initialScrollOffset: initialScrollPosition)
                ..addListener(_handleScheduleViewScrolled);
        }
      } else if (viewStartDate.isBefore(scheduleDisplayDate)) {
        DateTime visibleStartDate = viewStartDate;
        double initialScrollPosition = 0;
        while (visibleStartDate.isBefore(scheduleDisplayDate) &&
            !isSameDate(visibleStartDate, scheduleDisplayDate)) {
          final DateTime viewEndDate =
              DateTimeHelper.getDateTimeValue(addDays(visibleStartDate, 6));
          final DateTime appStartDate =
              isSameOrAfterDate(_minDate, visibleStartDate)
                  ? visibleStartDate
                  : _minDate!;
          DateTime appEndDate = isSameOrBeforeDate(_maxDate, viewEndDate)
              ? viewEndDate
              : _maxDate!;
          if (appEndDate.isAfter(scheduleDisplayDate) ||
              isSameDate(appEndDate, scheduleDisplayDate)) {
            appEndDate = DateTimeHelper.getDateTimeValue(
                addDays(scheduleDisplayDate, -1));
          }

          initialScrollPosition += _getInitialScrollPosition(
              appStartDate,
              appEndDate,
              scheduleCurrentDate,
              appointmentViewHeight,
              allDayAppointmentHeight);
          visibleStartDate = DateTimeHelper.getDateTimeValue(
              addDays(visibleStartDate, DateTime.daysPerWeek));
        }

        if (initialScrollPosition != 0) {
          _agendaScrollController?.removeListener(_handleScheduleViewScrolled);
          _agendaScrollController =
              ScrollController(initialScrollOffset: initialScrollPosition)
                ..addListener(_handleScheduleViewScrolled);
        }
      }
    }

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _onKeyDown,
      child: Stack(children: <Widget>[
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          height: widget.headerHeight,
          child: GestureDetector(
            child: Container(
                color: widget.headerStyle.backgroundColor ??
                    _calendarTheme.headerBackgroundColor,
                child: _CalendarHeaderView(
                    _currentViewVisibleDates,
                    widget.headerStyle,
                    null,
                    _view,
                    widget.monthViewSettings.numberOfWeeksInView,
                    _calendarTheme,
                    isRTL,
                    _locale,
                    widget.showNavigationArrow,
                    _controller,
                    widget.maxDate,
                    widget.minDate,
                    _minWidth,
                    widget.headerHeight,
                    widget.timeSlotViewSettings.nonWorkingDays,
                    widget.monthViewSettings.navigationDirection,
                    widget.showDatePickerButton,
                    widget.showTodayButton,
                    _showHeader,
                    widget.allowedViews,
                    widget.allowViewNavigation,
                    _localizations,
                    _removeDatePicker,
                    _headerUpdateNotifier,
                    _viewChangeNotifier,
                    _handleOnTapForHeader,
                    _handleOnLongPressForHeader,
                    widget.todayHighlightColor,
                    _textScaleFactor,
                    _isMobilePlatform,
                    widget.headerDateFormat,
                    true,
                    widget.todayTextStyle,
                    widget.showWeekNumber,
                    widget.weekNumberStyle,
                    _timelineMonthWeekNumberNotifier,
                    widget.cellBorderColor,
                    widget.timeSlotViewSettings.numberOfDaysInView)),
          ),
        ),
        Positioned(
            top: widget.headerHeight,
            left: 0,
            right: 0,
            height: height,
            child: _OpacityWidget(
                opacity: _opacity,
                child: CustomScrollView(
                  key: _scrollKey,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _agendaScrollController,
                  center: _scheduleViewKey,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        if (_previousDates.length <= index) {
                          return null;
                        }

                        /// Send negative index value to differentiate the
                        /// backward view from forward view.
                        return _getItem(context, -(index + 1), isRTL);
                      }),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        if (_nextDates.length <= index) {
                          return null;
                        }

                        return _getItem(context, index, isRTL);
                      }),
                      key: _scheduleViewKey,
                    ),
                  ],
                ))),
        _addDatePicker(widget.headerHeight, isRTL),
        _getCalendarViewPopup(),
      ]),
    );
  }

  double _getInitialScrollPosition(
      DateTime viewStartDate,
      DateTime viewEndDate,
      DateTime scheduleCurrentDate,
      double appointmentViewHeight,
      double allDayAppointmentHeight) {
    double initialScrolledPosition = 0;

    /// Calculate the appointment between the week start date and
    /// previous date of display date to calculate the scrolling position.
    final List<CalendarAppointment> appointmentCollection =
        AppointmentHelper.getVisibleAppointments(
            viewStartDate, viewEndDate, _appointments, widget.timeZone, false);

    const double padding = 5;

    /// Calculate the today date view height when today date
    /// in between the week.
    double todayNewEventHeight = 0;
    if (viewStartDate.isBefore(scheduleCurrentDate) &&
        !isSameDate(viewStartDate, scheduleCurrentDate) &&
        isSameOrBeforeDate(viewEndDate, scheduleCurrentDate)) {
      todayNewEventHeight = appointmentViewHeight + (2 * padding);
    }

    /// Skip the scrolling when the previous week dates of display date
    /// does not have a appointment.
    if (appointmentCollection.isNotEmpty) {
      final Map<DateTime, List<CalendarAppointment>> dateAppointments =
          _getAppointmentCollectionOnDateBasis(
              appointmentCollection, viewStartDate, viewEndDate);
      final List<DateTime> dateAppointmentKeys = dateAppointments.keys.toList();
      double totalAppointmentHeight = 0;
      for (int i = 0; i < dateAppointmentKeys.length; i++) {
        final DateTime currentDate = dateAppointmentKeys[i];
        final List<CalendarAppointment> currentDateAppointment =
            dateAppointments[currentDate]!;
        final int eventsCount = currentDateAppointment.length;
        int allDayEventCount = 0;

        /// Web view does not differentiate all day and normal appointment.
        if (_useMobilePlatformUI) {
          allDayEventCount = _getAllDayCount(currentDateAppointment);
        }

        double panelHeight =
            ((eventsCount - allDayEventCount) * appointmentViewHeight) +
                (allDayEventCount * allDayAppointmentHeight);
        panelHeight = panelHeight > appointmentViewHeight
            ? panelHeight
            : appointmentViewHeight;

        /// event count + 1 denotes the appointment padding and end padding.
        totalAppointmentHeight += panelHeight + ((eventsCount + 1) * padding);

        /// Set the today date view height to 0 when
        /// today date have appointments.
        if (todayNewEventHeight != 0 &&
            isSameDate(currentDate, scheduleCurrentDate)) {
          todayNewEventHeight = 0;
        }
      }

      initialScrolledPosition = todayNewEventHeight +
          totalAppointmentHeight +

          /// Add the divider height when it render on web.
          (!_useMobilePlatformUI ? dateAppointmentKeys.length : 0) +
          (!_useMobilePlatformUI
              ? 0
              : widget.scheduleViewSettings.weekHeaderSettings.height) +
          (viewStartDate.month == _scheduleDisplayDate.month &&
                  viewStartDate.day != 1
              ? 0
              : (!_useMobilePlatformUI
                  ? 0
                  : widget.scheduleViewSettings.monthHeaderSettings.height +
                      padding));
    } else if ((viewStartDate.month != _scheduleDisplayDate.month &&
            _useMobilePlatformUI) ||
        todayNewEventHeight != 0) {
      initialScrolledPosition = (!_useMobilePlatformUI
              ? 0
              : widget.scheduleViewSettings.weekHeaderSettings.height +
                  padding) +
          todayNewEventHeight;
    }

    return initialScrolledPosition;
  }

  Widget addAgendaWithLoadMore(double height, bool isRTL) {
    final bool hideEmptyAgendaDays =
        widget.scheduleViewSettings.hideEmptyScheduleWeek ||
            !_useMobilePlatformUI;

    /// return empty view when [hideEmptyAgendaDays] enabled and
    /// the appointments as empty.
    if (!_timeZoneLoaded) {
      return Container();
    }

    final DateTime scheduleDisplayDate = DateTimeHelper.getDateTimeValue(
        getValidDate(widget.minDate, widget.maxDate, _scheduleDisplayDate));
    final DateTime scheduleCurrentDate = DateTime.now();

    _scheduleMinDate ??= scheduleDisplayDate;
    _scheduleMaxDate ??= scheduleDisplayDate;
    _minDate ??= _scheduleMinDate;
    _maxDate ??= _scheduleMaxDate;
    if (!_isNeedLoadMore && !_isScheduleStartLoadMore) {
      _minDate = _scheduleMinDate;
      _maxDate = _scheduleMaxDate;
    }

    final DateTime viewMinDate = DateTimeHelper.getDateTimeValue(
        addDays(_minDate, -(_minDate!.weekday % DateTime.daysPerWeek)));

    final double appointmentViewHeight =
        CalendarViewHelper.getScheduleAppointmentHeight(
            null, widget.scheduleViewSettings);
    final double allDayAppointmentHeight =
        CalendarViewHelper.getScheduleAllDayAppointmentHeight(
            null, widget.scheduleViewSettings);

    /// Get the view first date based on specified
    /// display date  and first day of week.
    int value = -(scheduleDisplayDate.weekday % DateTime.daysPerWeek) +
        widget.firstDayOfWeek -
        DateTime.daysPerWeek;
    if (value.abs() >= DateTime.daysPerWeek) {
      value += DateTime.daysPerWeek;
    }

    if (_previousDates.isEmpty ||
        !isSameDate(_previousDates[_previousDates.length - 1], viewMinDate)) {
      /// Calculate the start date from display date if next view dates
      /// collection as empty.
      DateTime date = _previousDates.isNotEmpty
          ? _previousDates[_previousDates.length - 1]
          : (_nextDates.isNotEmpty
              ? _nextDates[0]
              : DateTimeHelper.getDateTimeValue(
                  addDays(scheduleDisplayDate, value)));
      int count = 0;

      /// Using while for calculate dates because if [hideEmptyAgendaDays] as
      /// enabled, then it hides the weeks when it does not have appointments.
      while (count < 50) {
        for (int i = 1; i <= 100; i++) {
          final DateTime updatedDate = DateTimeHelper.getDateTimeValue(
              addDays(date, -i * DateTime.daysPerWeek));

          /// Skip week dates before min date
          if (!isSameOrAfterDate(viewMinDate, updatedDate)) {
            count = 50;
            break;
          }

          final DateTime weekEndDate =
              DateTimeHelper.getDateTimeValue(addDays(updatedDate, 6));

          /// Skip the week date when it does not have appointments
          /// when [hideEmptyAgendaDays] as enabled.
          if (hideEmptyAgendaDays &&
              !_isAppointmentBetweenDates(
                  _appointments, updatedDate, weekEndDate, widget.timeZone) &&
              !isDateWithInDateRange(
                  updatedDate, weekEndDate, scheduleDisplayDate) &&
              !isDateWithInDateRange(
                  updatedDate, weekEndDate, scheduleCurrentDate)) {
            continue;
          }

          bool isEqualDate = false;

          /// Check the date placed in next dates collection, when
          /// previous dates collection is empty.
          /// Eg., if [hideEmptyAgendaDays] property enabled but after the
          /// display date does not have a appointment then the previous
          /// dates collection initial dates added to next dates.
          if (_previousDates.isEmpty) {
            for (int i = 0; i < _nextDates.length; i++) {
              final DateTime date = _nextDates[i];
              if (isSameDate(date, updatedDate)) {
                isEqualDate = true;
                break;
              }
            }
          }

          if (isEqualDate) {
            continue;
          }

          _previousDates.add(updatedDate);
          count++;
        }

        date = DateTimeHelper.getDateTimeValue(addDays(date, -700));
      }
    }

    final DateTime viewMaxDate = DateTimeHelper.getDateTimeValue(addDays(
        _maxDate,
        (DateTime.daysPerWeek - _maxDate!.weekday) % DateTime.daysPerWeek));
    if (_nextDates.isEmpty ||
        !isSameDate(_nextDates[_nextDates.length - 1], viewMaxDate)) {
      /// Calculate the start date from display date
      DateTime date = _nextDates.isEmpty
          ? DateTimeHelper.getDateTimeValue(addDays(scheduleDisplayDate, value))
          : DateTimeHelper.getDateTimeValue(
              addDays(_nextDates[_nextDates.length - 1], DateTime.daysPerWeek));
      int count = 0;

      /// Using while for calculate dates because if [hideEmptyAgendaDays] as
      /// enabled, then it hides the weeks when it does not have appointments.
      while (count < 50) {
        for (int i = 0; i < 100; i++) {
          final DateTime updatedDate = DateTimeHelper.getDateTimeValue(
              addDays(date, i * DateTime.daysPerWeek));

          /// Skip week date after max date
          if (!isSameOrBeforeDate(_maxDate, updatedDate)) {
            count = 50;
            break;
          }

          final DateTime weekEndDate =
              DateTimeHelper.getDateTimeValue(addDays(updatedDate, 6));

          /// Skip the week date when it does not have appointments
          /// when [hideEmptyAgendaDays] as enabled.
          if (hideEmptyAgendaDays &&
              !_isAppointmentBetweenDates(
                  _appointments, updatedDate, weekEndDate, widget.timeZone) &&
              !isDateWithInDateRange(
                  updatedDate, weekEndDate, scheduleDisplayDate) &&
              !isDateWithInDateRange(
                  updatedDate, weekEndDate, scheduleCurrentDate)) {
            continue;
          }

          _nextDates.add(updatedDate);
          count++;
        }

        date = DateTimeHelper.getDateTimeValue(addDays(date, 700));
      }
    }

    /// Calculate the next views dates when [hideEmptyAgendaDays] property
    /// enabled but after the display date does not have a appointment to the
    /// viewport then the previous dates collection initial dates added to next
    /// dates.
    if (_nextDates.length < 10 && _previousDates.isNotEmpty) {
      double totalHeight = 0;

      /// This boolean variable is used to check whether the previous dates
      /// collection dates added to next dates collection or not.
      bool isNewDatesAdded = false;

      /// Add the previous view dates start date to next dates collection and
      /// remove the date from previous dates collection when next dates as
      /// empty.
      if (_nextDates.isEmpty) {
        isNewDatesAdded = true;
        _nextDates.add(_previousDates[0]);
        _previousDates.removeAt(0);
      }

      /// Calculate the next dates collection appointments height to check
      /// the appointments fill the view port or not, if not then add another
      /// previous view dates and calculate the same until the next view dates
      /// appointment fills the view port.
      DateTime viewStartDate = _nextDates[0];
      DateTime viewEndDate = DateTimeHelper.getDateTimeValue(
          addDays(_nextDates[_nextDates.length - 1], 6));
      List<CalendarAppointment> appointmentCollection =
          AppointmentHelper.getVisibleAppointments(
              viewStartDate,
              isSameOrBeforeDate(_maxDate, viewEndDate)
                  ? viewEndDate
                  : _maxDate!,
              _appointments,
              widget.timeZone,
              false);

      const double padding = 5;
      Map<DateTime, List<CalendarAppointment>> dateAppointments =
          _getAppointmentCollectionOnDateBasis(
              appointmentCollection, viewStartDate, viewEndDate);
      List<DateTime> dateAppointmentKeys = dateAppointments.keys.toList();

      double labelHeight = 0;
      if (_useMobilePlatformUI) {
        DateTime previousDate =
            DateTimeHelper.getDateTimeValue(addDays(viewStartDate, -1));
        for (int i = 0; i < _nextDates.length; i++) {
          final DateTime nextDate = _nextDates[i];
          if (previousDate.month != nextDate.month) {
            labelHeight +=
                widget.scheduleViewSettings.monthHeaderSettings.height +
                    padding;
          }

          previousDate = nextDate;
          labelHeight += widget.scheduleViewSettings.weekHeaderSettings.height;
        }
      }

      int allDayCount = 0;
      int numberOfEvents = 0;
      for (int i = 0; i < dateAppointmentKeys.length; i++) {
        final List<CalendarAppointment> currentDateAppointment =
            dateAppointments[dateAppointmentKeys[i]]!;
        if (_useMobilePlatformUI) {
          allDayCount += _getAllDayCount(currentDateAppointment);
        }

        numberOfEvents += currentDateAppointment.length;
      }

      /// Check the next dates collection appointments height fills the view
      /// port or not, if not then add another previous view dates and calculate
      /// the same until the next view dates appointments fills the view port.
      while (totalHeight < height &&
          (_previousDates.isNotEmpty || totalHeight == 0)) {
        /// Initially appointment height as 0 and check the existing dates
        /// appointment fills the view port or not. if not then add
        /// another previous view dates
        if (totalHeight != 0) {
          final DateTime currentDate = _previousDates[0];
          _nextDates.insert(0, currentDate);
          _previousDates.removeAt(0);
          isNewDatesAdded = true;

          viewStartDate = currentDate;
          viewEndDate =
              DateTimeHelper.getDateTimeValue(addDays(currentDate, 6));

          /// Calculate the newly added date appointment height and add
          /// the height to existing appointments height.
          appointmentCollection = AppointmentHelper.getVisibleAppointments(
              viewStartDate,
              isSameOrBeforeDate(_maxDate, viewEndDate)
                  ? viewEndDate
                  : _maxDate!,
              _appointments,
              widget.timeZone,
              false);

          if (_useMobilePlatformUI) {
            final DateTime nextDate = _nextDates[1];
            if (nextDate.month != viewStartDate.month) {
              labelHeight +=
                  widget.scheduleViewSettings.monthHeaderSettings.height +
                      padding;
            }

            labelHeight +=
                widget.scheduleViewSettings.weekHeaderSettings.height;
          }

          dateAppointments = _getAppointmentCollectionOnDateBasis(
              appointmentCollection, viewStartDate, viewEndDate);
          dateAppointmentKeys = dateAppointments.keys.toList();
          for (int i = 0; i < dateAppointmentKeys.length; i++) {
            final List<CalendarAppointment> currentDateAppointment =
                dateAppointments[dateAppointmentKeys[i]]!;
            if (_useMobilePlatformUI) {
              allDayCount += _getAllDayCount(currentDateAppointment);
            }

            numberOfEvents += currentDateAppointment.length;
          }
        }

        totalHeight = ((numberOfEvents + 1) * padding) +
            ((numberOfEvents - allDayCount) * appointmentViewHeight) +
            (allDayCount * allDayAppointmentHeight) +
            labelHeight;
      }

      /// Update the header date because the next dates insert the previous view
      /// dates at initial position.
      if (_nextDates.isNotEmpty && isNewDatesAdded) {
        final DateTime date = _nextDates[0];
        _headerUpdateNotifier.value = DateTimeHelper.getDateTimeValue(
            getValidDate(_minDate, _maxDate, date));
      }
    }

    /// Check whether the schedule view initially loading because initially
    /// schedule display date and schedule loaded min date values are equal.
    final bool isMinDisplayDate =
        isSameDate(_scheduleMinDate, scheduleDisplayDate);

    /// Check whether the schedule view initially loading because initially
    /// schedule display date and schedule loaded max date values are equal.
    final bool isMaxDisplayDate =
        isSameDate(_scheduleMaxDate, scheduleDisplayDate);
    final bool isInitialLoadMore = isMinDisplayDate &&
        isMaxDisplayDate &&
        widget.loadMoreWidgetBuilder != null;
    DateTime visibleMinDate =
        AppointmentHelper.getMonthStartDate(scheduleDisplayDate);
    DateTime visibleMaxDate =
        AppointmentHelper.getMonthEndDate(scheduleDisplayDate);

    if (!isSameOrBeforeDate(widget.maxDate, visibleMaxDate)) {
      visibleMaxDate = widget.maxDate;
    }

    if (!isSameOrAfterDate(widget.minDate, visibleMinDate)) {
      visibleMinDate = widget.minDate;
    }

    /// The below codes used to scroll the view to current display date.
    /// If display date as May 29, 2020 then its week day as friday but first
    /// day of week as sunday then May 23, 2020 as shown, calculate the
    /// in between space between the May 23 to May 28 and assign the value to
    /// scroll controller initial scroll position
    if (_nextDates.isNotEmpty &&
        _agendaScrollController!.initialScrollOffset == 0 &&
        !isInitialLoadMore &&
        !_isNeedLoadMore &&
        !_isScheduleStartLoadMore &&
        isSameDate(visibleMaxDate, _scheduleMaxDate) &&
        isSameDate(visibleMinDate, _scheduleMinDate)) {
      DateTime viewStartDate = _nextDates[0];
      const double padding = 5;
      final double appointmentViewHeight =
          CalendarViewHelper.getScheduleAppointmentHeight(
              null, widget.scheduleViewSettings);
      final double allDayAppointmentHeight =
          CalendarViewHelper.getScheduleAllDayAppointmentHeight(
              null, widget.scheduleViewSettings);

      /// Calculate the day label(May, 25) height based on appointment height
      /// and assign the label maximum height as 60.
      double appointmentViewHeaderHeight =
          appointmentViewHeight + (2 * padding);
      if (_useMobilePlatformUI) {
        appointmentViewHeaderHeight =
            appointmentViewHeaderHeight > 60 ? 60 : appointmentViewHeaderHeight;
      }

      /// Calculate the divider height and color when it is web view.
      final double dividerHeight = _useMobilePlatformUI ? 0 : 1;

      /// Holds the height of 'No Events' label view.
      final double displayEventHeight = _useMobilePlatformUI
          ? appointmentViewHeaderHeight
          : appointmentViewHeaderHeight + dividerHeight;

      /// Holds the heights of each weeks in month on initial loading.
      /// Eg., holds Feb 1, 2021 to Feb 28, 2021 month weeks height.
      final List<double> heights = <double>[];

      /// holds the total height of the month on initial loading.
      /// /// Eg., holds Feb 1, 2021 to Feb 28, 2021 month total height.
      double totalHeight = 0;

      /// While used to calculate the height of current month weeks on initial
      /// loading.
      while (isSameOrBeforeDate(_maxDate, viewStartDate)) {
        final DateTime viewEndDate = DateTimeHelper.getDateTimeValue(
            addDays(viewStartDate, DateTime.daysPerWeek - 1));
        final DateTime appStartDate = isSameOrAfterDate(_minDate, viewStartDate)
            ? viewStartDate
            : _minDate!;
        final DateTime appEndDate =
            isSameOrBeforeDate(_maxDate, viewEndDate) ? viewEndDate : _maxDate!;

        /// Today date view height.
        double todayNewEventHeight = isDateWithInDateRange(
                viewStartDate, viewEndDate, scheduleCurrentDate)
            ? displayEventHeight
            : 0;

        /// Display date view height.
        double displayNewEventHeight = isDateWithInDateRange(
                viewStartDate, viewEndDate, scheduleDisplayDate)
            ? displayEventHeight
            : 0;

        /// Current week appointments heights.
        final List<CalendarAppointment> appointmentCollection =
            AppointmentHelper.getVisibleAppointments(
                appStartDate, appEndDate, _appointments, widget.timeZone, false,
                canCreateNewAppointment: false);

        /// Check the week date needs month header or not.
        final bool isNeedMonthBuilder = _useMobilePlatformUI &&
            ((viewStartDate.month != appEndDate.month ||
                    viewStartDate.year != appEndDate.year) ||
                viewStartDate.day == 1);

        /// Web view does not have month label.
        double currentWeekHeight = isNeedMonthBuilder
            ? widget.scheduleViewSettings.monthHeaderSettings.height
            : 0;

        /// Add the week header height to the current view height.
        /// web view does not have week label.
        currentWeekHeight += _useMobilePlatformUI
            ? widget.scheduleViewSettings.weekHeaderSettings.height
            : 0;

        if (appointmentCollection.isNotEmpty) {
          /// Get the collection of appointment collection listed by date.
          final Map<DateTime, List<CalendarAppointment>> dateAppointments =
              _getAppointmentCollectionOnDateBasis(
                  appointmentCollection, appStartDate, appEndDate);
          final List<DateTime> dateAppointmentKeys =
              dateAppointments.keys.toList();

          int numberOfEvents = 0;

          double appointmentHeight = 0;

          /// Calculate the total height of appointment views of week.
          for (int i = 0; i < dateAppointmentKeys.length; i++) {
            final DateTime currentDateKey = dateAppointmentKeys[i];
            final List<CalendarAppointment> currentDateAppointment =
                dateAppointments[currentDateKey]!;

            /// Assign today no event label height as 0 when today date have
            /// appointments.
            if (todayNewEventHeight != 0 &&
                isSameDate(scheduleCurrentDate, currentDateKey)) {
              todayNewEventHeight = 0;
            }

            /// Assign display date no event label height as 0 when display
            /// date have appointments.
            if (displayNewEventHeight != 0 &&
                isSameDate(scheduleDisplayDate, currentDateKey)) {
              displayNewEventHeight = 0;
            }

            final int eventsCount = currentDateAppointment.length;
            int allDayEventCount = 0;

            /// Web view does not differentiate all day and normal appointment.
            if (_useMobilePlatformUI) {
              allDayEventCount = _getAllDayCount(currentDateAppointment);
            }

            double panelHeight =
                ((eventsCount - allDayEventCount) * appointmentViewHeight) +
                    (allDayEventCount * allDayAppointmentHeight);
            panelHeight = panelHeight > appointmentViewHeight
                ? panelHeight
                : appointmentViewHeight;
            appointmentHeight += panelHeight + dividerHeight;
            numberOfEvents += eventsCount;
          }

          /// Add the padding height to the appointment height
          /// Each of the appointment view have top padding in agenda view and
          /// end agenda view have end padding, so count as
          /// (numberOfEvents + 1).
          /// value 1 as padding between the  agenda view and end appointment
          /// view. each of the agenda view in the week have padding add the
          /// existing value with date appointment keys length.
          appointmentHeight +=
              (numberOfEvents + dateAppointmentKeys.length) * padding;

          /// Add appointment height and week view end padding to height.
          currentWeekHeight +=
              appointmentHeight + (_useMobilePlatformUI ? padding : 0);
        }

        currentWeekHeight += todayNewEventHeight;
        currentWeekHeight += displayNewEventHeight;
        totalHeight += currentWeekHeight;
        heights.add(currentWeekHeight);
        viewStartDate = DateTimeHelper.getDateTimeValue(
            addDays(viewStartDate, DateTime.daysPerWeek));
      }

      /// Get the current display date week index from next dates collection.
      int rangeIndex = -1;
      for (int i = 0; i < _nextDates.length; i++) {
        final DateTime visibleStartDate = _nextDates[i];
        final DateTime visibleEndDate = DateTimeHelper.getDateTimeValue(
            addDays(visibleStartDate, DateTime.daysPerWeek));
        if (!isDateWithInDateRange(
            visibleStartDate, visibleEndDate, scheduleDisplayDate)) {
          continue;
        }

        rangeIndex = i;
      }

      double initialScrolledPosition = 0;
      for (int i = 0; i < rangeIndex; i++) {
        /// Add display date's previous weeks height to the initial
        /// scroll position.
        initialScrolledPosition += heights[i];
      }

      viewStartDate = _nextDates[rangeIndex];

      /// Calculate the scroll position with current display date week.
      while (viewStartDate.isBefore(scheduleDisplayDate) &&
          !isSameDate(viewStartDate, scheduleDisplayDate)) {
        final DateTime viewEndDate =
            DateTimeHelper.getDateTimeValue(addDays(viewStartDate, 6));
        final DateTime appStartDate = isSameOrAfterDate(_minDate, viewStartDate)
            ? viewStartDate
            : _minDate!;
        DateTime appEndDate =
            isSameOrBeforeDate(_maxDate, viewEndDate) ? viewEndDate : _maxDate!;
        if (appEndDate.isAfter(scheduleDisplayDate) ||
            isSameDate(appEndDate, scheduleDisplayDate)) {
          appEndDate =
              DateTimeHelper.getDateTimeValue(addDays(scheduleDisplayDate, -1));
        }

        /// Today date view height.
        double todayNewEventHeight =
            !isSameDate(scheduleCurrentDate, scheduleDisplayDate) &&
                    isDateWithInDateRange(
                        appStartDate, appEndDate, scheduleCurrentDate)
                ? displayEventHeight
                : 0;
        final List<CalendarAppointment> appointmentCollection =
            AppointmentHelper.getVisibleAppointments(
                appStartDate, appEndDate, _appointments, widget.timeZone, false,
                canCreateNewAppointment: false);

        /// Check the week date needs month header or not.
        final bool isNeedMonthBuilder = _useMobilePlatformUI &&
            ((viewStartDate.month != appEndDate.month ||
                    viewStartDate.year != appEndDate.year) ||
                viewStartDate.day == 1);

        if (appointmentCollection.isNotEmpty) {
          /// Get the collection of appointment collection listed by date.
          final Map<DateTime, List<CalendarAppointment>> dateAppointments =
              _getAppointmentCollectionOnDateBasis(
                  appointmentCollection, appStartDate, appEndDate);
          final List<DateTime> dateAppointmentKeys =
              dateAppointments.keys.toList();

          /// calculate the scroll position by adding week header height.
          /// web view does not have week label.
          initialScrolledPosition += _useMobilePlatformUI
              ? widget.scheduleViewSettings.weekHeaderSettings.height
              : 0;

          /// Web view does not have month label.
          initialScrolledPosition += isNeedMonthBuilder
              ? widget.scheduleViewSettings.monthHeaderSettings.height + padding
              : 0;

          int numberOfEvents = 0;

          double appointmentHeight = 0;

          /// Calculate the total height of appointment views of week.
          for (int i = 0; i < dateAppointmentKeys.length; i++) {
            final DateTime currentDateKey = dateAppointmentKeys[i];
            final List<CalendarAppointment> currentDateAppointment =
                dateAppointments[currentDateKey]!;
            if (isSameDate(scheduleCurrentDate, currentDateKey)) {
              todayNewEventHeight = 0;
            }

            final int eventsCount = currentDateAppointment.length;
            int allDayEventCount = 0;

            /// Web view does not differentiate all day and normal appointment.
            if (_useMobilePlatformUI) {
              allDayEventCount = _getAllDayCount(currentDateAppointment);
            }

            double panelHeight =
                ((eventsCount - allDayEventCount) * appointmentViewHeight) +
                    (allDayEventCount * allDayAppointmentHeight);
            panelHeight = panelHeight > appointmentViewHeight
                ? panelHeight
                : appointmentViewHeight;
            appointmentHeight += panelHeight + dividerHeight;
            numberOfEvents += eventsCount;
          }

          /// Add the padding height to the appointment height
          /// Each of the appointment view have top padding in agenda view and
          /// end agenda view have end padding, so count as
          /// (numberOfEvents + 1).
          /// value 1 as padding between the  agenda view and end appointment
          /// view. each of the agenda view in the week have padding add the
          /// existing value with date appointment keys length.
          appointmentHeight +=
              (numberOfEvents + dateAppointmentKeys.length) * padding;

          /// Add appointment height and today new event view height to
          /// scroll position.
          initialScrolledPosition += appointmentHeight + todayNewEventHeight;
        } else if (isNeedMonthBuilder || todayNewEventHeight != 0) {
          initialScrolledPosition += (!_useMobilePlatformUI
                  ? 0
                  : widget.scheduleViewSettings.weekHeaderSettings.height +
                      padding) +
              todayNewEventHeight;
        }

        viewStartDate = DateTimeHelper.getDateTimeValue(
            addDays(viewStartDate, DateTime.daysPerWeek));
      }

      if (initialScrolledPosition != 0) {
        final double belowSpace = totalHeight - initialScrolledPosition;

        /// Check the content height after the scroll position, if it lesser
        /// than view port height then reduce the scroll position.
        if (belowSpace < height) {
          initialScrolledPosition -= height - belowSpace;
          initialScrolledPosition =
              initialScrolledPosition > 0 ? initialScrolledPosition : 0;
        }

        _agendaScrollController?.removeListener(_handleScheduleViewScrolled);
        _agendaScrollController =
            ScrollController(initialScrollOffset: initialScrolledPosition)
              ..addListener(_handleScheduleViewScrolled);
        _scrollKey = UniqueKey();
      }
    }

    if (isInitialLoadMore) {
      _isNeedLoadMore = true;
      _scheduleMaxDate = AppointmentHelper.getMonthEndDate(_scheduleMaxDate!);
      _scheduleMinDate = AppointmentHelper.getMonthStartDate(_scheduleMinDate!);

      if (!isSameOrBeforeDate(widget.maxDate, _scheduleMaxDate)) {
        _scheduleMaxDate = widget.maxDate;
      }

      if (!isSameOrAfterDate(widget.minDate, _scheduleMinDate)) {
        _scheduleMinDate = widget.minDate;
      }
    }

    final List<Widget> children = <Widget>[
      Positioned(
        top: 0,
        right: 0,
        left: 0,
        height: widget.headerHeight,
        child: GestureDetector(
          child: Container(
              color: widget.headerStyle.backgroundColor ??
                  _calendarTheme.headerBackgroundColor,
              child: _CalendarHeaderView(
                  _currentViewVisibleDates,
                  widget.headerStyle,
                  null,
                  _view,
                  widget.monthViewSettings.numberOfWeeksInView,
                  _calendarTheme,
                  isRTL,
                  _locale,
                  widget.showNavigationArrow,
                  _controller,
                  widget.maxDate,
                  widget.minDate,
                  _minWidth,
                  widget.headerHeight,
                  widget.timeSlotViewSettings.nonWorkingDays,
                  widget.monthViewSettings.navigationDirection,
                  widget.showDatePickerButton,
                  widget.showTodayButton,
                  _showHeader,
                  widget.allowedViews,
                  widget.allowViewNavigation,
                  _localizations,
                  _removeDatePicker,
                  _headerUpdateNotifier,
                  _viewChangeNotifier,
                  _handleOnTapForHeader,
                  _handleOnLongPressForHeader,
                  widget.todayHighlightColor,
                  _textScaleFactor,
                  _isMobilePlatform,
                  widget.headerDateFormat,
                  !_isScheduleStartLoadMore && !_isNeedLoadMore,
                  widget.todayTextStyle,
                  widget.showWeekNumber,
                  widget.weekNumberStyle,
                  _timelineMonthWeekNumberNotifier,
                  widget.cellBorderColor,
                  widget.timeSlotViewSettings.numberOfDaysInView)),
        ),
      ),
      Positioned(
          top: widget.headerHeight,
          left: 0,
          right: 0,
          height: height,
          child: _OpacityWidget(
              opacity: _opacity,
              child: NotificationListener<OverscrollNotification>(
                  onNotification: (OverscrollNotification notification) {
                    if (_isNeedLoadMore ||
                        _isScheduleStartLoadMore ||
                        widget.loadMoreWidgetBuilder == null) {
                      return true;
                    }

                    if (notification.overscroll < 0 &&
                        _agendaScrollController!.position.pixels <=
                            _agendaScrollController!.position.minScrollExtent) {
                      DateTime date = AppointmentHelper.getMonthStartDate(
                          DateTime(_scheduleMinDate!.year,
                              _scheduleMinDate!.month - 1));

                      if (!isSameOrAfterDate(widget.minDate, date)) {
                        date = widget.minDate;
                      }

                      if (isSameDate(_scheduleMinDate, date)) {
                        return true;
                      }

                      setState(() {
                        _isScheduleStartLoadMore = true;
                        _scheduleMinDate = date;
                      });
                    } else if (_agendaScrollController!.position.pixels >=
                        _agendaScrollController!.position.maxScrollExtent) {
                      DateTime date = AppointmentHelper.getMonthEndDate(
                          DateTime(_scheduleMaxDate!.year,
                              _scheduleMaxDate!.month + 1));

                      if (!isSameOrBeforeDate(widget.maxDate, date)) {
                        date = widget.maxDate;
                      }

                      if (isSameDate(_scheduleMaxDate, date)) {
                        return true;
                      }

                      setState(() {
                        _isNeedLoadMore = true;
                        _scheduleMaxDate = date;
                      });
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    key: _scrollKey,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics(
                            parent: RangeMaintainingScrollPhysics())),
                    controller: _agendaScrollController,
                    center: _scheduleViewKey,
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          if (_previousDates.length <= index) {
                            return null;
                          }

                          /// Send negative index value to differentiate the
                          /// backward view from forward view.
                          return _getItem(context, -(index + 1), isRTL);
                        }),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          if (_nextDates.length <= index) {
                            return null;
                          }

                          return _getItem(context, index, isRTL);
                        }),
                        key: _scheduleViewKey,
                      ),
                    ],
                  )))),
      _addDatePicker(widget.headerHeight, isRTL),
      _getCalendarViewPopup(),
    ];

    if ((_isNeedLoadMore || _isScheduleStartLoadMore) &&
        widget.loadMoreWidgetBuilder != null) {
      final Alignment loadMoreAlignment = _agendaScrollController!.hasClients &&
              _agendaScrollController!.position.pixels <=
                  _agendaScrollController!.position.minScrollExtent &&
              _isScheduleStartLoadMore
          ? Alignment.topCenter
          : Alignment.bottomCenter;
      final DateTime visibleStartDate = _isNeedLoadMore
          ? AppointmentHelper.getMonthStartDate(_scheduleMaxDate!)
          : _scheduleMinDate!;
      final DateTime visibleEndDate = _isNeedLoadMore
          ? _scheduleMaxDate!
          : AppointmentHelper.getMonthEndDate(_scheduleMinDate!);
      children.add(Positioned(
          top: widget.headerHeight,
          left: 0,
          right: 0,
          height: height,
          child: Container(
              alignment: loadMoreAlignment,
              color: Colors.transparent,
              child: widget.loadMoreWidgetBuilder!(context, () async {
                await loadMoreAppointments(visibleStartDate, visibleEndDate);
              }))));
    }

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _onKeyDown,
      child: Stack(children: children),
    );
  }

  /// Method to handle keyboard navigation for schedule view in calendar.
  void _onKeyDown(RawKeyEvent event) {
    if (event.runtimeType != RawKeyDownEvent) {
      return;
    }

    CalendarViewHelper.handleViewSwitchKeyBoardEvent(
        event, _controller, widget.allowedViews);
  }

  Future<void> loadMoreAppointments(
      DateTime visibleStartDate, DateTime visibleEndDate) async {
    if (_isLoadMoreLoaded) {
      return;
    }

    _isLoadMoreLoaded = true;
    // ignore: invalid_use_of_protected_member
    await widget.dataSource!.handleLoadMore(visibleStartDate, visibleEndDate);
    _isLoadMoreLoaded = false;
  }

  void _updateViewChangePopup() {
    if (!mounted) {
      return;
    }

    if (widget.showDatePickerButton && _showHeader) {
      _showHeader = false;
    }

    setState(() {});
  }

  Widget _getCalendarViewPopup() {
    if (widget.allowedViews == null ||
        widget.allowedViews!.isEmpty ||
        !_viewChangeNotifier.value) {
      return Container();
    }

    const double calendarViewTextHeight = 40;
    final List<Widget> children = <Widget>[];
    double width = 0;
    final Color headerTextColor =
        _calendarTheme.headerTextStyle!.color ?? Colors.black87;
    final TextStyle style = TextStyle(color: headerTextColor, fontSize: 12);
    int selectedIndex = -1;
    final Color? todayColor = CalendarViewHelper.getTodayHighlightTextColor(
        widget.todayHighlightColor ?? _calendarTheme.todayHighlightColor,
        widget.todayTextStyle,
        _calendarTheme);

    final Map<CalendarView, String> calendarViews =
        _getCalendarViewsText(_localizations);

    final Alignment alignment =
        _isRTL ? Alignment.centerRight : Alignment.centerLeft;
    final int allowedViewLength = widget.allowedViews!.length;

    /// Generate the calendar view pop up content views.
    for (int i = 0; i < allowedViewLength; i++) {
      final CalendarView view = widget.allowedViews![i];
      final String text = calendarViews[view]!;
      final double textWidth = _getTextWidgetWidth(
              text, calendarViewTextHeight, _minWidth, context,
              style: style)
          .width;
      width = width < textWidth ? textWidth : width;
      final bool isSelected = view == _view;
      if (isSelected) {
        selectedIndex = i;
      }

      children.add(InkWell(
        onTap: () {
          _viewChangeNotifier.value = false;
          _controller.view = view;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          height: calendarViewTextHeight,
          alignment: alignment,
          child: Text(
            text,
            style: isSelected ? style.copyWith(color: todayColor) : style,
            maxLines: 1,
          ),
        ),
      ));
    }

    /// Restrict the pop up height with max height(200)
    final double totalHeight = allowedViewLength * calendarViewTextHeight;
    final double height = totalHeight > 200 ? 200 : totalHeight;

    double arrowWidth = 0;
    double iconWidth = _minWidth / 8;
    iconWidth = iconWidth > 40 ? 40 : iconWidth;
    const double padding = 5;

    /// Navigation arrow enabled when [showNavigationArrow] in [SfCalendar] is
    /// enabled and calendar view as not schedule, because schedule view does
    /// not have a support for navigation arrow.
    final bool navigationArrowEnabled =
        widget.showNavigationArrow && _view != CalendarView.schedule;

    /// Assign arrow width as icon width when the navigation arrow enabled.
    if (navigationArrowEnabled) {
      arrowWidth = iconWidth;
    }

    final double headerIconTextWidth =
        _calendarTheme.headerTextStyle!.fontSize ?? 14;
    final double totalArrowWidth = 2 * arrowWidth;
    final bool isCenterAlignment = !_isMobilePlatform &&
        (widget.headerStyle.textAlign == TextAlign.center ||
            widget.headerStyle.textAlign == TextAlign.justify);

    /// Calculate the calendar view button width that placed on header view
    final double calendarViewWidth = _useMobilePlatformUI
        ? iconWidth
        : _getTextWidgetWidth(calendarViews[_view]!, widget.headerHeight,
                    _minWidth - totalArrowWidth, context,
                    style: style)
                .width +
            padding +
            headerIconTextWidth;
    double dividerWidth = 0;
    double todayWidth = 0;

    /// Today button shown only the date picker enabled.
    if (widget.showTodayButton) {
      todayWidth = _useMobilePlatformUI
          ? iconWidth
          : _getTextWidgetWidth(_localizations.todayLabel, widget.headerHeight,
                      _minWidth - totalArrowWidth, context,
                      style: style)
                  .width +
              padding;

      /// Divider shown when the view holds calendar views and today button.
      dividerWidth = _useMobilePlatformUI ? 0 : 5;
    }
    double headerWidth = _minWidth -
        totalArrowWidth -
        calendarViewWidth -
        todayWidth -
        dividerWidth;
    if (isCenterAlignment) {
      headerWidth = headerWidth > 200 ? 200 : headerWidth;
    }

    /// 20 as container left and right padding for the view.
    width += 20;
    double left = 0;

    /// Specifies the popup animation start position.
    Alignment popupAlignment;
    if (_isMobilePlatform) {
      /// icon width specifies the today button width and calendar view width.
      left = _isRTL
          ? totalArrowWidth
          : headerWidth + todayWidth + iconWidth - width;
      popupAlignment = _isRTL ? Alignment.topLeft : Alignment.topRight;
      if (widget.headerStyle.textAlign == TextAlign.right ||
          widget.headerStyle.textAlign == TextAlign.end) {
        popupAlignment = _isRTL ? Alignment.topRight : Alignment.topLeft;
        left = _isRTL
            ? headerWidth + iconWidth + todayWidth - width
            : totalArrowWidth;
      } else if (widget.headerStyle.textAlign == TextAlign.center ||
          widget.headerStyle.textAlign == TextAlign.justify) {
        popupAlignment = _isRTL ? Alignment.topLeft : Alignment.topRight;
        left = _isRTL
            ? arrowWidth
            : headerWidth + arrowWidth + todayWidth + iconWidth - width;
      }
    } else {
      left = _isRTL
          ? calendarViewWidth - width
          : headerWidth + totalArrowWidth + todayWidth + dividerWidth - 1;
      popupAlignment = _isRTL ? Alignment.topLeft : Alignment.topRight;
      if (widget.headerStyle.textAlign == TextAlign.right ||
          widget.headerStyle.textAlign == TextAlign.end) {
        popupAlignment = _isRTL ? Alignment.topRight : Alignment.topLeft;
        left = _isRTL
            ? headerWidth + totalArrowWidth + todayWidth + dividerWidth - 1
            : calendarViewWidth - width;
      } else if (widget.headerStyle.textAlign == TextAlign.center ||
          widget.headerStyle.textAlign == TextAlign.justify) {
        popupAlignment = _isRTL ? Alignment.topRight : Alignment.topLeft;

        /// Calculate the left padding by calculate the total icon and header.
        /// Calculate the menu icon position by adding the left padding, left
        /// arrow and header label.
        final double leftStartPosition = (_minWidth -
                totalArrowWidth -
                calendarViewWidth -
                dividerWidth -
                todayWidth -
                headerWidth) /
            2;
        left = _isRTL
            ? leftStartPosition + calendarViewWidth - width
            : leftStartPosition +
                totalArrowWidth +
                headerWidth +
                todayWidth +
                dividerWidth;
      }
    }

    if (left < 2) {
      left = 2;
    } else if (left + width + 2 > _minWidth) {
      left = _minWidth - width - 2;
    }

    double scrollPosition = 0;
    if (selectedIndex != -1) {
      scrollPosition = selectedIndex * calendarViewTextHeight;
      final double maxScrollPosition =
          allowedViewLength * calendarViewTextHeight;
      scrollPosition = (maxScrollPosition - scrollPosition) > height
          ? scrollPosition
          : maxScrollPosition - height;
    }

    final bool showScrollbar = totalHeight > height;
    final ScrollController calendarViewPopupScrollController =
        ScrollController(initialScrollOffset: scrollPosition);
    return Positioned(
        top: widget.headerHeight,
        left: left,
        height: height,
        width: width,
        child: _PopupWidget(
            alignment: popupAlignment,
            child: Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: _calendarTheme.brightness == Brightness.dark
                      ? Colors.grey[850]
                      : Colors.white,
                  boxShadow: kElevationToShadow[6],
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: Scrollbar(
                      thumbVisibility: showScrollbar,
                      controller: calendarViewPopupScrollController,
                      child: ListView(
                          padding: EdgeInsets.zero,
                          controller: calendarViewPopupScrollController,
                          children: children)),
                ))));
  }

  /// Adds the resource panel on the left side of the view, if the resource
  /// collection is not null.
  Widget _addResourcePanel(bool isResourceEnabled, double resourceViewSize,
      double height, bool isRTL) {
    if (!isResourceEnabled) {
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Container(),
      );
    }

    final double viewHeaderHeight =
        CalendarViewHelper.getViewHeaderHeight(widget.viewHeaderHeight, _view);
    final double timeLabelSize = CalendarViewHelper.getTimeLabelWidth(
        widget.timeSlotViewSettings.timeRulerSize, _view);
    final double top = viewHeaderHeight + timeLabelSize;
    final double resourceItemHeight = CalendarViewHelper.getResourceItemHeight(
        resourceViewSize,
        height - top,
        widget.resourceViewSettings,
        _resourceCollection!.length);
    final double panelHeight = resourceItemHeight * _resourceCollection!.length;

    final Widget verticalDivider = VerticalDivider(
      width: 0.5,
      thickness: 0.5,
      color: widget.cellBorderColor ?? _calendarTheme.cellBorderColor,
    );

    return Positioned(
        left: isRTL ? _minWidth - resourceViewSize : 0,
        width: resourceViewSize,
        top: 0,
        bottom: 0,
        child: Stack(children: <Widget>[
          Positioned(
            left: _isRTL ? 0.5 : resourceViewSize - 0.5,
            width: 0.5,
            top: _controller.view == CalendarView.timelineMonth
                ? widget.headerHeight
                : widget.headerHeight + viewHeaderHeight,
            height: _controller.view == CalendarView.timelineMonth
                ? viewHeaderHeight
                : timeLabelSize,
            child: verticalDivider,
          ),
          Positioned(
              left: 0,
              width: resourceViewSize,
              top: widget.headerHeight + top,
              bottom: 0,
              child: MouseRegion(
                  onEnter: (PointerEnterEvent event) {
                    _pointerEnterEvent(event, false, isRTL, null,
                        top + widget.headerHeight, 0, isResourceEnabled);
                  },
                  onExit: _pointerExitEvent,
                  onHover: (PointerHoverEvent event) {
                    _pointerHoverEvent(event, false, isRTL, null,
                        top + widget.headerHeight, 0, isResourceEnabled);
                  },
                  child: GestureDetector(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          controller: _resourcePanelScrollController,
                          children: <Widget>[
                            ResourceViewWidget(
                                _resourceCollection,
                                widget.resourceViewSettings,
                                resourceItemHeight,
                                widget.cellBorderColor,
                                _calendarTheme,
                                _themeData,
                                _resourceImageNotifier,
                                isRTL,
                                _textScaleFactor,
                                _resourceHoverNotifier.value,
                                _imagePainterCollection,
                                resourceViewSize,
                                panelHeight,
                                widget.resourceViewHeaderBuilder),
                          ]),
                    ),
                    onTapUp: (TapUpDetails details) {
                      _handleOnTapForResourcePanel(details, resourceItemHeight);
                    },
                    onLongPressStart: (LongPressStartDetails details) {
                      _handleOnLongPressForResourcePanel(
                          details, resourceItemHeight);
                    },
                  )))
        ]));
  }

  /// Handles and raises the [widget.onLongPress] callback, when the resource
  /// panel is long pressed in [SfCalendar].
  void _handleOnLongPressForResourcePanel(
      LongPressStartDetails details, double resourceItemHeight) {
    if (!CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
        widget.onLongPress)) {
      return;
    }

    final CalendarResource tappedResource =
        _getTappedResource(details.localPosition.dy, resourceItemHeight);
    final List<dynamic> resourceAppointments =
        _getSelectedResourceAppointments(tappedResource);
    CalendarViewHelper.raiseCalendarLongPressCallback(widget, null,
        resourceAppointments, CalendarElement.resourceHeader, tappedResource);
  }

  /// Handles and raises the [widget.onTap] callback, when the resource panel
  /// is tapped in [SfCalendar].
  void _handleOnTapForResourcePanel(
      TapUpDetails details, double resourceItemHeight) {
    if (!CalendarViewHelper.shouldRaiseCalendarTapCallback(widget.onTap)) {
      return;
    }

    final CalendarResource tappedResource =
        _getTappedResource(details.localPosition.dy, resourceItemHeight);
    final List<dynamic> resourceAppointments =
        _getSelectedResourceAppointments(tappedResource);
    CalendarViewHelper.raiseCalendarTapCallback(widget, null,
        resourceAppointments, CalendarElement.resourceHeader, tappedResource);
  }

  /// Filter and returns the appointment collection for the given resource from
  /// the visible appointments collection.
  List<dynamic> _getSelectedResourceAppointments(CalendarResource resource) {
    final List<dynamic> selectedResourceAppointments = <dynamic>[];
    if (_visibleAppointments.isEmpty) {
      return selectedResourceAppointments;
    }

    for (int i = 0; i < _visibleAppointments.length; i++) {
      final CalendarAppointment app = _visibleAppointments[i];
      if (app.resourceIds != null &&
          app.resourceIds!.isNotEmpty &&
          app.resourceIds!.contains(resource.id)) {
        selectedResourceAppointments.add(
            CalendarViewHelper.getAppointmentDetail(app, widget.dataSource));
      }
    }

    return selectedResourceAppointments;
  }

  /// Returns the tapped resource details, based on the tapped position.
  CalendarResource _getTappedResource(
      double tappedPosition, double resourceItemHeight) {
    final int index =
        (_resourcePanelScrollController!.offset + tappedPosition) ~/
            resourceItemHeight;
    return _resourceCollection![index];
  }

  /// Adds the custom scroll view which used to produce the infinity scroll.
  Widget _addCustomScrollView(
      double top,
      double resourceViewSize,
      bool isRTL,
      bool isResourceEnabled,
      double width,
      double height,
      double agendaHeight) {
    return Positioned(
      top: top,
      left: isResourceEnabled && !isRTL ? resourceViewSize : 0,
      right: isResourceEnabled && isRTL ? resourceViewSize : 0,
      height: height - agendaHeight,
      child: _OpacityWidget(
          opacity: _opacity,
          child: CustomCalendarScrollView(
            widget,
            _view,
            width - resourceViewSize,
            height - agendaHeight,
            _agendaSelectedDate,
            isRTL,
            _locale,
            _calendarTheme,
            _themeData,
            _timeZoneLoaded ? widget.specialRegions : null,
            _blackoutDates,
            _controller,
            _removeDatePicker,
            _resourcePanelScrollController,
            _resourceCollection,
            _textScaleFactor,
            _isMobilePlatform,
            _fadeInController,
            widget.minDate,
            widget.maxDate,
            _localizations,
            _timelineMonthWeekNumberNotifier,
            _updateCalendarState,
            _getCalendarStateDetails,
            key: _customScrollViewKey,
          )),
    );
  }

  Widget _addChildren(
      double agendaHeight, double height, double width, bool isRTL) {
    final bool isResourceEnabled =
        CalendarViewHelper.isResourceEnabled(widget.dataSource, _view);
    final double resourceViewSize =
        isResourceEnabled ? widget.resourceViewSettings.size : 0;
    final DateTime currentViewDate = _currentViewVisibleDates[
        (_currentViewVisibleDates.length / 2).truncate()];

    final List<Widget> children = <Widget>[
      Positioned(
        top: 0,
        right: 0,
        left: 0,
        height: widget.headerHeight,
        child: Container(
            color: widget.headerStyle.backgroundColor ??
                _calendarTheme.headerBackgroundColor,
            child: _CalendarHeaderView(
                _currentViewVisibleDates,
                widget.headerStyle,
                currentViewDate,
                _view,
                widget.monthViewSettings.numberOfWeeksInView,
                _calendarTheme,
                isRTL,
                _locale,
                widget.showNavigationArrow,
                _controller,
                widget.maxDate,
                widget.minDate,
                width,
                widget.headerHeight,
                widget.timeSlotViewSettings.nonWorkingDays,
                widget.monthViewSettings.navigationDirection,
                widget.showDatePickerButton,
                widget.showTodayButton,
                _showHeader,
                widget.allowedViews,
                widget.allowViewNavigation,
                _localizations,
                _removeDatePicker,
                _headerUpdateNotifier,
                _viewChangeNotifier,
                _handleOnTapForHeader,
                _handleOnLongPressForHeader,
                widget.todayHighlightColor,
                _textScaleFactor,
                _isMobilePlatform,
                widget.headerDateFormat,
                !_isNeedLoadMore,
                widget.todayTextStyle,
                widget.showWeekNumber,
                widget.weekNumberStyle,
                _timelineMonthWeekNumberNotifier,
                widget.cellBorderColor,
                widget.timeSlotViewSettings.numberOfDaysInView)),
      ),
      _addResourcePanel(isResourceEnabled, resourceViewSize, height, isRTL),
      _addCustomScrollView(widget.headerHeight, resourceViewSize, isRTL,
          isResourceEnabled, width, height, agendaHeight),
      _addAgendaView(agendaHeight, widget.headerHeight + height - agendaHeight,
          width, isRTL),
      _addDatePicker(widget.headerHeight, isRTL),
      _getCalendarViewPopup(),
    ];
    if (_isNeedLoadMore && widget.loadMoreWidgetBuilder != null) {
      children.add(Container(
          color: Colors.transparent,
          child: widget.loadMoreWidgetBuilder!(context, () async {
            await loadMoreAppointments(_currentViewVisibleDates[0],
                _currentViewVisibleDates[_currentViewVisibleDates.length - 1]);
          })));
    }
    return Stack(children: children);
  }

  void _removeDatePicker() {
    if (widget.showDatePickerButton && _showHeader) {
      setState(() {
        _showHeader = false;
      });
    }

    _viewChangeNotifier.value = false;
  }

  void _updateDatePicker() {
    _viewChangeNotifier.value = false;
    if (!widget.showDatePickerButton) {
      return;
    }

    setState(() {
      _showHeader = !_showHeader;
    });
  }

  Widget _addDatePicker(double top, bool isRTL) {
    if (!widget.showDatePickerButton || !_showHeader) {
      return const SizedBox(width: 0, height: 0);
    }

    double maxHeight = _minHeight * 0.6;
    double maxWidth = _minWidth * 0.5;

    double pickerWidth = 0;
    double pickerHeight = 0;

    final TextStyle datePickerStyle = _calendarTheme.activeDatesTextStyle!;
    final Color? todayColor =
        widget.todayHighlightColor ?? _calendarTheme.todayHighlightColor;
    final Color? todayTextColor = CalendarViewHelper.getTodayHighlightTextColor(
        todayColor, widget.todayTextStyle, _calendarTheme);
    double left = 0;
    if (_isMobilePlatform) {
      pickerWidth = _minWidth;
      pickerHeight = _minHeight * 0.5;
    } else {
      const double padding = 5;
      double arrowWidth = 0;
      double iconWidth = _minWidth / 8;
      iconWidth = iconWidth > 40 ? 40 : iconWidth;

      /// Navigation arrow enabled when [showNavigationArrow] in [SfCalendar] is
      /// enabled and calendar view as not schedule, because schedule view does
      /// not have a support for navigation arrow.
      final bool navigationArrowEnabled =
          widget.showNavigationArrow && _view != CalendarView.schedule;

      /// Assign arrow width as icon width when the navigation arrow enabled.
      if (navigationArrowEnabled) {
        arrowWidth = iconWidth;
      }

      final double totalArrowWidth = 2 * arrowWidth;
      final double totalWidth = _minWidth - totalArrowWidth;
      final double totalHeight = _minHeight - widget.headerHeight;
      maxHeight = maxHeight < 250
          ? (totalHeight < 250 ? totalHeight - 10 : 250)
          : maxHeight;
      maxWidth = maxWidth < 250
          ? (totalWidth < 250 ? totalWidth - 10 : 250)
          : maxWidth;
      double containerSize = maxHeight > maxWidth ? maxWidth : maxHeight;
      if (containerSize > 300) {
        containerSize = 300;
      }

      pickerWidth = containerSize;
      pickerHeight = containerSize;
      left =
          isRTL ? _minWidth - containerSize - totalArrowWidth : totalArrowWidth;
      if (widget.headerStyle.textAlign == TextAlign.right ||
          widget.headerStyle.textAlign == TextAlign.end) {
        left = isRTL ? padding : _minWidth - containerSize - totalArrowWidth;
      } else if (widget.headerStyle.textAlign == TextAlign.center ||
          widget.headerStyle.textAlign == TextAlign.justify) {
        final double calendarViewWidth = _calendarViewWidth;

        double headerViewWidth =
            _minWidth - calendarViewWidth - totalArrowWidth;
        if (headerViewWidth == _minWidth) {
          left = (_minWidth - containerSize) / 2;
        } else {
          headerViewWidth = headerViewWidth > 200 ? 200 : headerViewWidth;
          final double leftPadding = (_minWidth -
                  headerViewWidth -
                  calendarViewWidth -
                  totalArrowWidth) /
              2;
          double headerPadding = (headerViewWidth - containerSize) / 2;
          headerPadding = headerPadding > 0 ? headerPadding : 0;
          left = _isRTL
              ? leftPadding +
                  arrowWidth +
                  calendarViewWidth +
                  headerViewWidth -
                  containerSize
              : leftPadding + arrowWidth + headerPadding;
        }
      }
    }

    return Positioned(
        top: top,
        left: left,
        width: pickerWidth,
        height: pickerHeight,
        child: _PopupWidget(
            child: Container(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(5),
                decoration: _isMobilePlatform
                    ? BoxDecoration(
                        color: _calendarTheme.brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.white,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              offset: Offset(0.0, 3.0),
                              blurRadius: 2.0,
                              color: Color(0x24000000)),
                        ],
                      )
                    : BoxDecoration(
                        color: _calendarTheme.brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.white,
                        boxShadow: kElevationToShadow[6],
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                child: SfDateRangePicker(
                  showNavigationArrow: true,
                  initialSelectedDate: _currentDate,
                  initialDisplayDate: _currentDate,
                  todayHighlightColor: todayColor,
                  minDate: widget.minDate,
                  maxDate: widget.maxDate,
                  selectionColor: todayTextColor,
                  //// For disabling the picker dates based on the calendar non working days.
                  selectableDayPredicate: _view != CalendarView.workWeek &&
                          _view != CalendarView.timelineWorkWeek
                      ? null
                      : (DateTime dateTime) {
                          for (int i = 0;
                              i <
                                  widget.timeSlotViewSettings.nonWorkingDays
                                      .length;
                              i++) {
                            if (dateTime.weekday ==
                                widget.timeSlotViewSettings.nonWorkingDays[i]) {
                              return false;
                            }
                          }
                          return true;
                        },
                  headerStyle: DateRangePickerHeaderStyle(
                    textAlign:
                        _isMobilePlatform ? TextAlign.center : TextAlign.left,
                  ),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    viewHeaderHeight: pickerHeight / 8,
                    firstDayOfWeek: widget.firstDayOfWeek,
                  ),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: datePickerStyle,
                      todayTextStyle:
                          datePickerStyle.copyWith(color: todayTextColor)),
                  yearCellStyle: DateRangePickerYearCellStyle(
                    textStyle: datePickerStyle,
                    todayTextStyle:
                        datePickerStyle.copyWith(color: todayTextColor),
                    leadingDatesTextStyle: _calendarTheme.leadingDatesTextStyle,
                  ),
                  view: _view == CalendarView.month ||
                          _view == CalendarView.timelineMonth
                      ? DateRangePickerView.year
                      : DateRangePickerView.month,
                  onViewChanged: (DateRangePickerViewChangedArgs details) {
                    if ((_view != CalendarView.month &&
                            _view != CalendarView.timelineMonth) ||
                        details.view != DateRangePickerView.month) {
                      return;
                    }

                    if (isSameDate(_currentDate, _controller.displayDate) ||
                        isDateWithInDateRange(
                            _currentViewVisibleDates[0],
                            _currentViewVisibleDates[
                                _currentViewVisibleDates.length - 1],
                            _controller.displayDate)) {
                      _removeDatePicker();
                    }

                    _showHeader = false;
                    final DateTime selectedDate =
                        details.visibleDateRange.startDate!;
                    _controller.displayDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        _controller.displayDate!.hour,
                        _controller.displayDate!.minute,
                        _controller.displayDate!.second);
                  },
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs details) {
                    if (isSameDate(_currentDate, _controller.displayDate) ||
                        isDateWithInDateRange(
                            _currentViewVisibleDates[0],
                            _currentViewVisibleDates[
                                _currentViewVisibleDates.length - 1],
                            _controller.displayDate)) {
                      _removeDatePicker();
                    }

                    _showHeader = false;
                    _controller.displayDate = DateTime(
                        details.value.year,
                        details.value.month,
                        details.value.day,
                        _controller.displayDate!.hour,
                        _controller.displayDate!.minute,
                        _controller.displayDate!.second);
                  },
                ))));
  }

  void _getCalendarStateDetails(UpdateCalendarStateDetails details) {
    details.currentDate = _currentDate;
    details.currentViewVisibleDates = _currentViewVisibleDates;
    details.selectedDate = _selectedDate;
    details.allDayPanelHeight = _allDayPanelHeight;
    details.allDayAppointmentViewCollection = _allDayAppointmentViewCollection;
    details.visibleAppointments = _visibleAppointments;
    details.appointments = _appointments;
  }

  void _updateCalendarState(UpdateCalendarStateDetails details) {
    if (details.currentDate != null &&
        !isSameDate(details.currentDate, _currentDate)) {
      _currentDate = DateTimeHelper.getDateTimeValue(
          getValidDate(widget.minDate, widget.maxDate, details.currentDate));
      _canScrollTimeSlotView = false;
      _controller.displayDate = _currentDate;
      _canScrollTimeSlotView = true;
      details.currentDate = _currentDate;
    }

    if (_currentViewVisibleDates != details.currentViewVisibleDates) {
      _currentViewVisibleDates = details.currentViewVisibleDates;
      _allDayAppointmentViewCollection = <AppointmentView>[];
      _visibleAppointments = <CalendarAppointment>[];
      _allDayPanelHeight = 0;
      _isNeedLoadMore = widget.loadMoreWidgetBuilder != null;
      _updateVisibleAppointments();
      if (CalendarViewHelper.shouldRaiseViewChangedCallback(
          widget.onViewChanged)) {
        final bool showTrailingLeadingDates =
            CalendarViewHelper.isLeadingAndTrailingDatesVisible(
                widget.monthViewSettings.numberOfWeeksInView,
                widget.monthViewSettings.showTrailingAndLeadingDates);
        List<DateTime> visibleDates = _currentViewVisibleDates;
        if (!showTrailingLeadingDates) {
          visibleDates = DateTimeHelper.getCurrentMonthDates(visibleDates);
        }

        CalendarViewHelper.raiseViewChangedCallback(widget, visibleDates);
      }
    }

    if (!CalendarViewHelper.isSameTimeSlot(
        details.selectedDate, _selectedDate)) {
      _selectedDate = details.selectedDate;
      _controller.selectedDate = details.selectedDate;
    }
  }

  //// Handles the on tap callback for  header
  void _handleOnTapForHeader(double width) {
    _calendarViewWidth = width;
    _updateDatePicker();
    if (!CalendarViewHelper.shouldRaiseCalendarTapCallback(widget.onTap)) {
      return;
    }

    CalendarViewHelper.raiseCalendarTapCallback(
        widget, _getTappedHeaderDate(), null, CalendarElement.header, null);
  }

  //// Handles the on long press callback for  header
  void _handleOnLongPressForHeader(double width) {
    _calendarViewWidth = width;
    _updateDatePicker();
    if (!CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
        widget.onLongPress)) {
      return;
    }

    CalendarViewHelper.raiseCalendarLongPressCallback(
        widget, _getTappedHeaderDate(), null, CalendarElement.header, null);
  }

  DateTime _getTappedHeaderDate() {
    if (_view == CalendarView.month) {
      return DateTime(_currentDate.year, _currentDate.month);
    } else {
      final DateTime date = _currentViewVisibleDates[0];
      return DateTime(date.year, date.month, date.day);
    }
  }

  //// Handles the onTap callback for agenda view.
  void _handleTapForAgenda(TapUpDetails details, DateTime? selectedDate) {
    _removeDatePicker();
    if (widget.allowViewNavigation &&
        ((!_isRTL && details.localPosition.dx < _agendaDateViewWidth) ||
            (_isRTL &&
                details.localPosition.dx > _minWidth - _agendaDateViewWidth))) {
      _controller.view = CalendarView.day;
      _controller.displayDate = selectedDate;
    }

    if (!CalendarViewHelper.shouldRaiseCalendarTapCallback(widget.onTap)) {
      return;
    }

    final List<dynamic> selectedAppointments =
        _getSelectedAppointments(details.localPosition, selectedDate);

    CalendarViewHelper.raiseCalendarTapCallback(
        widget,
        selectedDate,
        selectedAppointments,
        selectedAppointments.isNotEmpty
            ? CalendarElement.appointment
            : CalendarElement.agenda,
        null);
  }

  //// Handles the onLongPress callback for agenda view.
  void _handleLongPressForAgenda(
      LongPressStartDetails details, DateTime? selectedDate) {
    _removeDatePicker();
    if (widget.allowViewNavigation &&
        ((!_isRTL && details.localPosition.dx < _agendaDateViewWidth) ||
            (_isRTL &&
                details.localPosition.dx > _minWidth - _agendaDateViewWidth))) {
      _controller.view = CalendarView.day;
      _controller.displayDate = selectedDate;
    }

    if (!CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
        widget.onLongPress)) {
      return;
    }

    final List<dynamic> selectedAppointments =
        _getSelectedAppointments(details.localPosition, selectedDate);

    CalendarViewHelper.raiseCalendarLongPressCallback(
        widget,
        selectedDate,
        selectedAppointments,
        selectedAppointments.isNotEmpty
            ? CalendarElement.appointment
            : CalendarElement.agenda,
        null);
  }

  List<dynamic> _getSelectedAppointments(
      Offset localPosition, DateTime? selectedDate) {
    /// Return empty collection while tap the agenda view with no selected date.
    if (selectedDate == null) {
      return <dynamic>[];
    }

    /// Return empty collection while tap the agenda date view.
    if ((!_isRTL && localPosition.dx < _agendaDateViewWidth) ||
        (_isRTL && localPosition.dx > _minWidth - _agendaDateViewWidth)) {
      return <dynamic>[];
    }

    List<CalendarAppointment> agendaAppointments =
        AppointmentHelper.getSelectedDateAppointments(
            _appointments, widget.timeZone, selectedDate);

    /// Return empty collection while tap the agenda view does
    /// not have appointments.
    if (agendaAppointments.isEmpty) {
      return <dynamic>[];
    }

    agendaAppointments.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            app1.actualStartTime.compareTo(app2.actualStartTime));
    agendaAppointments.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            AppointmentHelper.orderAppointmentsAscending(
                app1.isAllDay, app2.isAllDay));
    agendaAppointments.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            AppointmentHelper.orderAppointmentsAscending(
                app1.isSpanned, app2.isSpanned));

    int index = -1;
    //// Agenda appointment view top padding as 5.
    const double padding = 5;
    double xPosition = 0;
    final double tappedYPosition =
        _agendaScrollController!.offset + localPosition.dy;
    final double actualAppointmentHeight =
        CalendarViewHelper.getScheduleAppointmentHeight(
            widget.monthViewSettings, null);
    final double allDayAppointmentHeight =
        CalendarViewHelper.getScheduleAllDayAppointmentHeight(
            widget.monthViewSettings, null);
    for (int i = 0; i < agendaAppointments.length; i++) {
      final CalendarAppointment appointment = agendaAppointments[i];
      final double appointmentHeight = _isAllDayAppointmentView(appointment)
          ? allDayAppointmentHeight
          : actualAppointmentHeight;
      if (tappedYPosition >= xPosition &&
          tappedYPosition < xPosition + appointmentHeight + padding) {
        index = i;
        break;
      }

      xPosition += appointmentHeight + padding;
    }

    /// Return empty collection while tap the agenda view and the tapped
    /// position does not have appointment.
    if (index > agendaAppointments.length || index == -1) {
      return <dynamic>[];
    }

    agendaAppointments = <CalendarAppointment>[agendaAppointments[index]];
    if (widget.dataSource != null &&
        !AppointmentHelper.isCalendarAppointment(widget.dataSource!)) {
      return CalendarViewHelper.getCustomAppointments(
          agendaAppointments, widget.dataSource);
    }

    return agendaAppointments;
  }

  // Returns the agenda view  as a child for the calendar.
  Widget _addAgendaView(
      double height, double startPosition, double width, bool isRTL) {
    if (_view != CalendarView.month || !widget.monthViewSettings.showAgenda) {
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Container(),
      );
    }

    /// Show no selected date in agenda view when selected date is
    /// disabled or black out date.
    DateTime? currentSelectedDate;
    if (_selectedDate != null) {
      currentSelectedDate = isDateWithInDateRange(
                  widget.minDate, widget.maxDate, _selectedDate) &&
              !CalendarViewHelper.isDateInDateCollection(
                  _blackoutDates, _selectedDate!)
          ? _selectedDate
          : null;
    }

    if (currentSelectedDate == null) {
      return Positioned(
          top: startPosition,
          right: 0,
          left: 0,
          height: height,
          child: _OpacityWidget(
              opacity: _opacity,
              child: Container(
                  color: widget.monthViewSettings.agendaStyle.backgroundColor ??
                      _calendarTheme.agendaBackgroundColor,
                  child: GestureDetector(
                    child: AgendaViewLayout(
                        widget.monthViewSettings,
                        null,
                        currentSelectedDate,
                        null,
                        isRTL,
                        _locale,
                        _localizations,
                        _calendarTheme,
                        _themeData,
                        _agendaViewNotifier,
                        widget.appointmentTimeTextFormat,
                        0,
                        _textScaleFactor,
                        _isMobilePlatform,
                        widget.appointmentBuilder,
                        width,
                        height,
                        widget
                            .monthViewSettings.agendaStyle.placeholderTextStyle,
                        widget),
                    onTapUp: (TapUpDetails details) {
                      _handleTapForAgenda(details, null);
                    },
                    onLongPressStart: (LongPressStartDetails details) {
                      _handleLongPressForAgenda(details, null);
                    },
                  ))));
    }

    final List<CalendarAppointment> agendaAppointments =
        AppointmentHelper.getSelectedDateAppointments(
            _appointments, widget.timeZone, currentSelectedDate);
    agendaAppointments.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            app1.actualStartTime.compareTo(app2.actualStartTime));
    agendaAppointments.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            AppointmentHelper.orderAppointmentsAscending(
                app1.isAllDay, app2.isAllDay));
    agendaAppointments.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            AppointmentHelper.orderAppointmentsAscending(
                app1.isSpanned, app2.isSpanned));

    /// Each appointment have top padding and it used to show the space
    /// between two appointment views
    const double topPadding = 5;

    /// Last appointment view have bottom padding and it show the space
    /// between the last appointment and agenda view.
    const double bottomPadding = 5;
    final double appointmentHeight =
        CalendarViewHelper.getScheduleAppointmentHeight(
            widget.monthViewSettings, null);
    final double allDayAppointmentHeight =
        CalendarViewHelper.getScheduleAllDayAppointmentHeight(
            widget.monthViewSettings, null);
    double painterHeight = height;
    if (agendaAppointments.isNotEmpty) {
      final int count = _getAllDayCount(agendaAppointments);
      painterHeight = ((count * (allDayAppointmentHeight + topPadding)) +
              ((agendaAppointments.length - count) *
                  (appointmentHeight + topPadding))) +
          bottomPadding;
    }

    return Positioned(
        top: startPosition,
        right: 0,
        left: 0,
        height: height,
        child: _OpacityWidget(
            opacity: _opacity,
            child: Container(
                color: widget.monthViewSettings.agendaStyle.backgroundColor ??
                    _calendarTheme.agendaBackgroundColor,
                child: MouseRegion(
                    onEnter: (PointerEnterEvent event) {
                      _pointerEnterEvent(event, false, isRTL);
                    },
                    onExit: _pointerExitEvent,
                    onHover: (PointerHoverEvent event) {
                      _pointerHoverEvent(event, false, isRTL);
                    },
                    child: GestureDetector(
                      child: Stack(children: <Widget>[
                        CustomPaint(
                          painter: _AgendaDateTimePainter(
                              currentSelectedDate,
                              widget.monthViewSettings,
                              null,
                              widget.todayHighlightColor ??
                                  _calendarTheme.todayHighlightColor,
                              widget.todayTextStyle,
                              _locale,
                              _calendarTheme,
                              _themeData,
                              _agendaDateNotifier,
                              _minWidth,
                              isRTL,
                              _textScaleFactor,
                              _isMobilePlatform),
                          size: Size(_agendaDateViewWidth, height),
                        ),
                        Positioned(
                          top: 0,
                          left: isRTL ? 0 : _agendaDateViewWidth,
                          right: isRTL ? _agendaDateViewWidth : 0,
                          bottom: 0,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            controller: _agendaScrollController,
                            children: <Widget>[
                              AgendaViewLayout(
                                  widget.monthViewSettings,
                                  null,
                                  currentSelectedDate,
                                  agendaAppointments,
                                  isRTL,
                                  _locale,
                                  _localizations,
                                  _calendarTheme,
                                  _themeData,
                                  _agendaViewNotifier,
                                  widget.appointmentTimeTextFormat,
                                  _agendaDateViewWidth,
                                  _textScaleFactor,
                                  _isMobilePlatform,
                                  widget.appointmentBuilder,
                                  width - _agendaDateViewWidth,
                                  painterHeight,
                                  widget.monthViewSettings.agendaStyle
                                      .placeholderTextStyle,
                                  widget),
                            ],
                          ),
                        ),
                      ]),
                      onTapUp: (TapUpDetails details) {
                        _handleTapForAgenda(details, _selectedDate);
                      },
                      onLongPressStart: (LongPressStartDetails details) {
                        _handleLongPressForAgenda(details, _selectedDate);
                      },
                    )))));
  }
}

class _OpacityWidget extends StatefulWidget {
  const _OpacityWidget({required this.child, required this.opacity});

  final Widget child;

  final ValueNotifier<double> opacity;

  @override
  State<StatefulWidget> createState() => _OpacityWidgetState();
}

class _OpacityWidgetState extends State<_OpacityWidget> {
  @override
  void initState() {
    widget.opacity.addListener(_update);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _OpacityWidget oldWidget) {
    if (widget.opacity != oldWidget.opacity) {
      oldWidget.opacity.removeListener(_update);
      widget.opacity.addListener(_update);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _update() {
    setState(() {
      /// Update the opacity widget with new opacity property value.
    });
  }

  @override
  void dispose() {
    widget.opacity.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: widget.opacity.value, child: widget.child);
  }
}

/// Widget used to show the pop up animation to the child.
class _PopupWidget extends StatefulWidget {
  const _PopupWidget(
      {required this.child, this.alignment = Alignment.topCenter});

  /// Widget that animated like popup.
  final Widget child;

  /// Alignment defines the popup animation start position.
  final Alignment alignment;

  @override
  State<StatefulWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<_PopupWidget>
    with SingleTickerProviderStateMixin {
  /// Controller used to handle the animation.
  late AnimationController _animationController;

  /// Popup animation used to show the child like popup.
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Reset the existing animation.
    _animationController.reset();

    /// Start the animation.
    _animationController.forward();
    return ScaleTransition(
        alignment: widget.alignment,
        scale: _animation,
        child: FadeTransition(opacity: _animation, child: widget.child));
  }
}

@immutable
class _CalendarHeaderView extends StatefulWidget {
  const _CalendarHeaderView(
      this.visibleDates,
      this.headerStyle,
      this.currentDate,
      this.view,
      this.numberOfWeeksInView,
      this.calendarTheme,
      this.isRTL,
      this.locale,
      this.showNavigationArrow,
      this.controller,
      this.maxDate,
      this.minDate,
      this.width,
      this.height,
      this.nonWorkingDays,
      this.navigationDirection,
      this.showDatePickerButton,
      this.showTodayButton,
      this.isPickerShown,
      this.allowedViews,
      this.allowViewNavigation,
      this.localizations,
      this.removePicker,
      this.valueChangeNotifier,
      this.viewChangeNotifier,
      this.headerTapCallback,
      this.headerLongPressCallback,
      this.todayHighlightColor,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.headerDateFormat,
      this.enableInteraction,
      this.todayTextStyle,
      this.showWeekNumber,
      this.weekNumberStyle,
      this.timelineMonthWeekNumberNotifier,
      this.cellBorderColor,
      this.numberOfDaysInView);

  final List<DateTime> visibleDates;
  final TextStyle? todayTextStyle;
  final CalendarHeaderStyle headerStyle;
  final WeekNumberStyle weekNumberStyle;
  final SfCalendarThemeData calendarTheme;
  final DateTime? currentDate;
  final CalendarView view;
  final int numberOfWeeksInView;
  final bool isRTL;
  final String locale;
  final bool showNavigationArrow;
  final CalendarController controller;
  final DateTime maxDate;
  final DateTime minDate;
  final double width;
  final double height;
  final List<int> nonWorkingDays;
  final List<CalendarView>? allowedViews;
  final bool allowViewNavigation;
  final MonthNavigationDirection navigationDirection;
  final VoidCallback removePicker;
  final _CalendarHeaderCallback headerTapCallback;
  final _CalendarHeaderCallback headerLongPressCallback;
  final bool showDatePickerButton;
  final bool showTodayButton;
  final SfLocalizations localizations;
  final ValueNotifier<DateTime?> valueChangeNotifier;
  final ValueNotifier<bool> viewChangeNotifier;
  final bool isPickerShown;
  final double textScaleFactor;
  final Color? todayHighlightColor;
  final bool isMobilePlatform;
  final String? headerDateFormat;
  final bool enableInteraction;
  final bool showWeekNumber;
  final ValueNotifier<DateTime?> timelineMonthWeekNumberNotifier;
  final Color? cellBorderColor;
  final int numberOfDaysInView;

  @override
  _CalendarHeaderViewState createState() => _CalendarHeaderViewState();
}

class _CalendarHeaderViewState extends State<_CalendarHeaderView> {
  late Map<CalendarView, String> _calendarViews;

  @override
  void initState() {
    widget.valueChangeNotifier.addListener(_updateHeaderChanged);
    widget.timelineMonthWeekNumberNotifier
        .addListener(_updateWeekNumberChangedForTimelineMonth);
    _calendarViews = _getCalendarViewsText(widget.localizations);
    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarHeaderView oldWidget) {
    if (widget.valueChangeNotifier != oldWidget.valueChangeNotifier) {
      oldWidget.valueChangeNotifier.removeListener(_updateHeaderChanged);
      widget.valueChangeNotifier.addListener(_updateHeaderChanged);
    }

    if (widget.timelineMonthWeekNumberNotifier !=
        oldWidget.timelineMonthWeekNumberNotifier) {
      oldWidget.timelineMonthWeekNumberNotifier
          .removeListener(_updateWeekNumberChangedForTimelineMonth);
      widget.timelineMonthWeekNumberNotifier
          .addListener(_updateWeekNumberChangedForTimelineMonth);
    }

    _calendarViews = _getCalendarViewsText(widget.localizations);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final bool useMobilePlatformUI = CalendarViewHelper.isMobileLayoutUI(
        widget.width, widget.isMobilePlatform);
    double arrowWidth = 0;
    double headerWidth = widget.width;

    /// Navigation arrow enabled when [showNavigationArrow] in [SfCalendar] is
    /// enabled and calendar view as not schedule, because schedule view does
    /// not have a support for navigation arrow.
    final bool navigationArrowEnabled =
        widget.showNavigationArrow && widget.view != CalendarView.schedule;
    double iconWidth = widget.width / 8;
    iconWidth = iconWidth > 40 ? 40 : iconWidth;
    double calendarViewWidth = 0;

    /// Assign arrow width as icon width when the navigation arrow enabled.
    if (navigationArrowEnabled) {
      arrowWidth = iconWidth;
    }

    final String headerString = _getHeaderText();
    final String weekNumberString = _getWeekNumberString();
    final double totalArrowWidth = arrowWidth * 2;

    /// Show calendar views on header when it is not empty.
    final bool isNeedViewSwitchOption =
        widget.allowedViews != null && widget.allowedViews!.isNotEmpty;
    double todayIconWidth = 0;
    double dividerWidth = 0;
    double weekNumberPanelWidth = 0, weekNumberPanelHeight = 0;
    double weekNumberTextWidth = 0;
    final List<Widget> children = <Widget>[];
    final Color headerTextColor =
        widget.calendarTheme.headerTextStyle!.color ?? Colors.black87;
    final Color headerBackgroundColor = widget.headerStyle.backgroundColor ??
        widget.calendarTheme.headerBackgroundColor!;
    final Color arrowColor =
        headerTextColor.withOpacity(headerTextColor.opacity * 0.6);
    Color prevArrowColor = arrowColor;
    Color nextArrowColor = arrowColor;
    final TextStyle style = TextStyle(color: arrowColor);
    const double defaultCalendarViewTextSize = 12;
    Widget calendarViewIcon = const SizedBox(width: 0, height: 0);
    const double padding = 5;
    final double headerIconTextWidth =
        widget.calendarTheme.headerTextStyle!.fontSize ?? 14;
    final String todayText = widget.localizations.todayLabel;

    double maxHeaderHeight = 0;
    const double allowedViewsPadding = 10;

    /// Today icon shown when the date picker enabled on calendar.
    if (widget.showTodayButton) {
      todayIconWidth = iconWidth;
      if (!useMobilePlatformUI) {
        /// 5 as padding for around today text view.
        final Size todayButtonSize = _getTextWidgetWidth(
            todayText, widget.height, widget.width - totalArrowWidth, context,
            style: const TextStyle(fontSize: defaultCalendarViewTextSize));
        maxHeaderHeight = todayButtonSize.height + allowedViewsPadding;
        todayIconWidth = todayButtonSize.width + allowedViewsPadding;
      }
    }

    double headerTextWidth = 0;
    final bool isTimelineView = CalendarViewHelper.isTimelineView(widget.view);
    final TextStyle weekNumberTextStyle =
        widget.calendarTheme.weekNumberTextStyle!;

    final Color? weekNumberBackgroundColor =
        widget.weekNumberStyle.backgroundColor ??
            widget.calendarTheme.weekNumberBackgroundColor;

    final bool weekNumberEnabled = widget.showWeekNumber &&
        (widget.view == CalendarView.day || isTimelineView);
    if (!widget.isMobilePlatform ||
        (widget.isMobilePlatform && weekNumberEnabled)) {
      final Size headerTextSize = _getTextWidgetWidth(
          headerString,
          widget.height,
          widget.width - totalArrowWidth - todayIconWidth - padding,
          context,
          style: widget.calendarTheme.headerTextStyle);

      headerTextWidth = headerTextSize.width +
          padding +
          (widget.showDatePickerButton ? headerIconTextWidth : 0);
      maxHeaderHeight = maxHeaderHeight > headerTextSize.height
          ? maxHeaderHeight
          : headerTextSize.height;
    }

    if (weekNumberEnabled) {
      final Size weekNumberPanelSize = _getTextWidgetWidth(
          '${widget.localizations.weeknumberLabel}$weekNumberString ',
          widget.height,
          widget.width,
          context,
          style: weekNumberTextStyle);
      weekNumberTextWidth = weekNumberPanelSize.width + padding;
      weekNumberPanelWidth = weekNumberTextWidth;
      weekNumberPanelHeight = weekNumberPanelSize.height;
    }

    final Color? highlightColor = CalendarViewHelper.getTodayHighlightTextColor(
        widget.todayHighlightColor ?? widget.calendarTheme.todayHighlightColor,
        widget.todayTextStyle,
        widget.calendarTheme);

    if (isNeedViewSwitchOption) {
      calendarViewWidth = iconWidth;
      if (useMobilePlatformUI) {
        maxHeaderHeight =
            maxHeaderHeight != 0 && maxHeaderHeight <= widget.height
                ? maxHeaderHeight
                : widget.height;

        /// Render allowed views icon on mobile view.
        calendarViewIcon = _getCalendarViewWidget(
            headerBackgroundColor,
            useMobilePlatformUI,
            false,
            calendarViewWidth,
            maxHeaderHeight,
            style,
            arrowColor,
            headerTextColor,
            widget.view,
            // ignore: avoid_bool_literals_in_conditional_expressions
            widget.isMobilePlatform ? false : widget.viewChangeNotifier.value,
            highlightColor,
            defaultCalendarViewTextSize,
            semanticLabel: 'CalendarView');
      } else {
        /// Assign divider width when today icon text shown.
        dividerWidth = widget.showTodayButton ? 10 : 0;

        final double totalWidth = widget.width -
            totalArrowWidth -
            dividerWidth -
            todayIconWidth -
            headerTextWidth -
            weekNumberPanelWidth;

        final Map<CalendarView, double> calendarViewsWidth =
            <CalendarView, double>{};
        double allowedViewsWidth = 0;
        final int allowedViewsLength = widget.allowedViews!.length;

        double maxCalendarViewHeight = 0;

        /// Calculate the allowed views horizontal width.
        for (int i = 0; i < allowedViewsLength; i++) {
          final CalendarView currentView = widget.allowedViews![i];
          final Size calendarViewSize = _getTextWidgetWidth(
              _calendarViews[currentView]!, widget.height, totalWidth, context,
              style: const TextStyle(fontSize: defaultCalendarViewTextSize));
          final double currentViewTextWidth =
              calendarViewSize.width + allowedViewsPadding;
          maxCalendarViewHeight =
              maxCalendarViewHeight > calendarViewSize.height
                  ? maxCalendarViewHeight
                  : calendarViewSize.height + allowedViewsPadding;
          calendarViewsWidth[currentView] = currentViewTextWidth;
          allowedViewsWidth += currentViewTextWidth;
        }

        /// Check the header view width enough for hold allowed views then
        /// render the allowed views as children.
        if (allowedViewsWidth < totalWidth) {
          calendarViewWidth = allowedViewsWidth;
          maxHeaderHeight = maxCalendarViewHeight > maxHeaderHeight
              ? maxCalendarViewHeight
              : maxHeaderHeight;
          maxHeaderHeight =
              maxHeaderHeight > widget.height ? widget.height : maxHeaderHeight;
          for (int i = 0; i < allowedViewsLength; i++) {
            final CalendarView currentView = widget.allowedViews![i];
            children.add(_getCalendarViewWidget(
                headerBackgroundColor,
                useMobilePlatformUI,
                false,
                calendarViewsWidth[currentView]!,
                maxHeaderHeight,
                style,
                arrowColor,
                headerTextColor,
                currentView,
                widget.view == currentView,
                highlightColor,
                defaultCalendarViewTextSize));
          }
        } else {
          /// Render allowed views drop down when header view does not have a
          /// space to hold the allowed views.
          final Size calendarViewSize = _getTextWidgetWidth(
              _calendarViews[widget.view]!,
              widget.height,
              widget.width - totalArrowWidth,
              context,
              style: const TextStyle(fontSize: defaultCalendarViewTextSize));
          maxCalendarViewHeight = calendarViewSize.height + allowedViewsPadding;
          maxHeaderHeight = maxCalendarViewHeight > maxHeaderHeight
              ? maxCalendarViewHeight
              : maxHeaderHeight;
          maxHeaderHeight =
              maxHeaderHeight > widget.height ? widget.height : maxHeaderHeight;
          calendarViewWidth = calendarViewSize.width +
              allowedViewsPadding +
              headerIconTextWidth;
          children.add(_getCalendarViewWidget(
              headerBackgroundColor,
              useMobilePlatformUI,
              true,
              calendarViewWidth,
              maxHeaderHeight,
              style,
              arrowColor,
              headerTextColor,
              widget.view,
              widget.viewChangeNotifier.value,
              highlightColor,
              defaultCalendarViewTextSize,
              semanticLabel: 'CalendarView'));
        }
      }
    }

    final double headerHeight =
        maxHeaderHeight != 0 && maxHeaderHeight <= widget.height
            ? maxHeaderHeight
            : widget.height;

    if (weekNumberEnabled) {
      /// Header will render based on its text width while week number enabled.
      /// because the week number panel occupies the empty space to align the
      /// today button and calendar view button on right side end.
      headerWidth = headerTextWidth;
      final double remainingWidth = widget.width -
          calendarViewWidth -
          todayIconWidth -
          dividerWidth -
          totalArrowWidth -
          weekNumberPanelWidth -
          headerWidth;
      if (remainingWidth < 0) {
        /// Clip the header text while the calendar view button, today button,
        /// arrows and week number does not have space to render.
        headerWidth += remainingWidth;
      } else {
        /// Assign the week number panel width is available space other than
        /// header text width, calendar view button width, today button,
        /// arrows width to align the today button and calendar view button
        /// on right side end.
        weekNumberPanelWidth += remainingWidth;
      }
    } else {
      /// Assign the header panel width is available space other than
      /// calendar view button width, today button, arrows width to align the
      /// today button and calendar view button on right side end.
      headerWidth = widget.width -
          calendarViewWidth -
          todayIconWidth -
          dividerWidth -
          totalArrowWidth;
    }

    final List<DateTime> dates = widget.visibleDates;
    if (!DateTimeHelper.canMoveToNextView(
        widget.view,
        widget.numberOfWeeksInView,
        widget.minDate,
        widget.maxDate,
        dates,
        widget.nonWorkingDays)) {
      nextArrowColor = nextArrowColor.withOpacity(nextArrowColor.opacity * 0.5);
    }

    if (!DateTimeHelper.canMoveToPreviousView(
        widget.view,
        widget.numberOfWeeksInView,
        widget.minDate,
        widget.maxDate,
        dates,
        widget.nonWorkingDays)) {
      prevArrowColor = prevArrowColor.withOpacity(prevArrowColor.opacity * 0.5);
    }

    MainAxisAlignment getAlignmentFromTextAlign() {
      if (widget.headerStyle.textAlign == TextAlign.left ||
          widget.headerStyle.textAlign == TextAlign.start) {
        return MainAxisAlignment.start;
      } else if (widget.headerStyle.textAlign == TextAlign.right ||
          widget.headerStyle.textAlign == TextAlign.end) {
        return MainAxisAlignment.end;
      }

      return MainAxisAlignment.center;
    }

    double arrowSize =
        headerHeight == widget.height ? headerHeight * 0.6 : headerHeight * 0.8;
    arrowSize = arrowSize > 25 ? 25 : arrowSize;
    arrowSize = arrowSize * widget.textScaleFactor;
    final bool isCenterAlignment = !widget.isMobilePlatform &&
        (navigationArrowEnabled || isNeedViewSwitchOption) &&
        (widget.headerStyle.textAlign == TextAlign.center ||
            widget.headerStyle.textAlign == TextAlign.justify);

    Alignment getHeaderAlignment() {
      if (widget.headerStyle.textAlign == TextAlign.left ||
          widget.headerStyle.textAlign == TextAlign.start) {
        return widget.isRTL ? Alignment.centerRight : Alignment.centerLeft;
      } else if (widget.headerStyle.textAlign == TextAlign.right ||
          widget.headerStyle.textAlign == TextAlign.end) {
        return widget.isRTL ? Alignment.centerLeft : Alignment.centerRight;
      }

      return Alignment.center;
    }

    final Color? splashColor =
        !widget.showDatePickerButton || !widget.enableInteraction
            ? Colors.transparent
            : null;
    final TextStyle headerTextStyle = widget.calendarTheme.headerTextStyle!;
    final Widget headerText = widget.isMobilePlatform
        ? Container(
            alignment: Alignment.center,
            color: headerBackgroundColor,
            width: isCenterAlignment && headerWidth > 200 ? 200 : headerWidth,
            height: headerHeight,
            padding: const EdgeInsets.all(2),
            child: Material(
                color: headerBackgroundColor,
                child: InkWell(
                  //// set splash color as transparent when header does not have
                  // date piker.
                  splashColor: splashColor,
                  highlightColor: splashColor,
                  hoverColor: splashColor,
                  splashFactory: _CustomSplashFactory(),
                  onTap: () {
                    if (!widget.enableInteraction) {
                      return;
                    }
                    widget.headerTapCallback(
                        calendarViewWidth + dividerWidth + todayIconWidth);
                  },
                  onLongPress: () {
                    if (!widget.enableInteraction) {
                      return;
                    }
                    widget.headerLongPressCallback(
                        calendarViewWidth + dividerWidth + todayIconWidth);
                  },
                  child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      width: isCenterAlignment && headerWidth > 200
                          ? 200
                          : headerWidth,
                      height: headerHeight,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                          mainAxisAlignment: getAlignmentFromTextAlign(),
                          children: widget.showDatePickerButton
                              ? <Widget>[
                                  Flexible(
                                      child: Text(headerString,
                                          style: headerTextStyle,
                                          maxLines: 1,
                                          semanticsLabel:
                                              // ignore: lines_longer_than_80_chars
                                              '$headerString ${widget.isPickerShown ? 'hide date picker' : 'show date picker'}',
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                          textDirection: CalendarViewHelper
                                              .getTextDirectionBasedOnLocale(
                                                  widget.locale))),
                                  Icon(
                                    widget.isPickerShown
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    color: arrowColor,
                                    size: headerTextStyle.fontSize ?? 14,
                                  ),
                                ]
                              : <Widget>[
                                  Flexible(
                                      child: Text(headerString,
                                          style: headerTextStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                          textDirection: CalendarViewHelper
                                              .getTextDirectionBasedOnLocale(
                                                  widget.locale)))
                                ])),
                )),
          )
        : Container(
            alignment: getHeaderAlignment(),
            color: headerBackgroundColor,
            width: isCenterAlignment && headerWidth > 200 ? 200 : headerWidth,
            height: headerHeight,
            padding: const EdgeInsets.all(2),
            child: Material(
                color: headerBackgroundColor,
                child: InkWell(
                  //// set splash color as transparent when header does not have
                  // date piker.
                  splashColor: splashColor,
                  highlightColor: splashColor,
                  splashFactory: _CustomSplashFactory(),
                  onTap: () {
                    if (!widget.enableInteraction) {
                      return;
                    }
                    widget.headerTapCallback(
                        calendarViewWidth + dividerWidth + todayIconWidth);
                  },
                  onLongPress: () {
                    if (!widget.enableInteraction) {
                      return;
                    }
                    widget.headerLongPressCallback(
                        calendarViewWidth + dividerWidth + todayIconWidth);
                  },
                  child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color:
                            widget.showDatePickerButton && widget.isPickerShown
                                ? Colors.grey.withOpacity(0.3)
                                : headerBackgroundColor,
                      ),

                      /// Padding value is from parent container padding
                      /// value const EdgeInsets.all(2).
                      width: (isCenterAlignment && headerTextWidth > 200
                              ? 200
                              : headerTextWidth) -
                          padding,
                      height: headerHeight,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.showDatePickerButton
                            ? <Widget>[
                                Flexible(
                                    child: Text(headerString,
                                        style: headerTextStyle,
                                        maxLines: 1,
                                        semanticsLabel:
                                            // ignore: lines_longer_than_80_chars
                                            '$headerString ${widget.isPickerShown ? 'hide date picker' : 'show date picker'}',
                                        overflow: TextOverflow.clip,
                                        softWrap: false,
                                        textDirection: CalendarViewHelper
                                            .getTextDirectionBasedOnLocale(
                                                widget.locale))),
                                Icon(
                                  widget.isPickerShown
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: arrowColor,
                                  size: headerTextStyle.fontSize ?? 14,
                                ),
                              ]
                            : <Widget>[
                                Flexible(
                                    child: Text(headerString,
                                        style: headerTextStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        softWrap: false,
                                        textDirection: CalendarViewHelper
                                            .getTextDirectionBasedOnLocale(
                                                widget.locale))),
                              ],
                      )),
                )),
          );

    final Widget weekNumberWidget = weekNumberEnabled
        ? Container(
            width:
                isCenterAlignment ? weekNumberTextWidth : weekNumberPanelWidth,
            height: weekNumberPanelHeight,
            alignment: getHeaderAlignment(),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(padding)),
                    color: weekNumberBackgroundColor),
                alignment: Alignment.center,
                width: weekNumberTextWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        child: Text(
                      widget.localizations.weeknumberLabel,
                      textAlign: TextAlign.center,
                      textScaleFactor: widget.textScaleFactor,
                      style: weekNumberTextStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
                    Flexible(
                        child: Text(
                      ' $weekNumberString',
                      textAlign: TextAlign.center,
                      style: weekNumberTextStyle,
                      textScaleFactor: widget.textScaleFactor,
                      maxLines: 1,
                    ))
                  ],
                )),
          )
        : Container();

    final Color? leftArrowSplashColor =
        prevArrowColor != arrowColor || !widget.enableInteraction
            ? Colors.transparent
            : null;
    final Container leftArrow = navigationArrowEnabled
        ? Container(
            alignment: Alignment.center,
            color: headerBackgroundColor,
            width: arrowWidth,
            height: headerHeight,
            padding: const EdgeInsets.all(2),
            child: Material(
                color: headerBackgroundColor,
                child: InkWell(
                  //// set splash color as transparent when arrow reaches min date(disabled)
                  splashColor: leftArrowSplashColor,
                  highlightColor: leftArrowSplashColor,
                  hoverColor: leftArrowSplashColor,
                  splashFactory: _CustomSplashFactory(),
                  onTap: _backward,
                  child: Semantics(
                    label: 'Backward',
                    child: Container(
                        width: arrowWidth,
                        height: headerHeight,
                        alignment: Alignment.center,
                        clipBehavior: Clip.antiAlias,
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: Icon(
                          widget.navigationDirection ==
                                  MonthNavigationDirection.horizontal
                              ? Icons.chevron_left
                              : Icons.keyboard_arrow_up,
                          color: prevArrowColor,
                          size: arrowSize,
                        )),
                  ),
                )),
          )
        : Container();

    final Color? rightArrowSplashColor =
        nextArrowColor != arrowColor || !widget.enableInteraction
            ? Colors.transparent
            : null;
    final Container rightArrow = navigationArrowEnabled
        ? Container(
            alignment: Alignment.center,
            color: headerBackgroundColor,
            width: arrowWidth,
            height: headerHeight,
            padding: const EdgeInsets.all(2),
            child: Material(
                color: headerBackgroundColor,
                child: InkWell(
                  //// set splash color as transparent when arrow reaches max date(disabled)
                  splashColor: rightArrowSplashColor,
                  highlightColor: rightArrowSplashColor,
                  hoverColor: rightArrowSplashColor,
                  splashFactory: _CustomSplashFactory(),
                  onTap: _forward,
                  child: Semantics(
                    label: 'Forward',
                    child: Container(
                        width: arrowWidth,
                        height: headerHeight,
                        alignment: Alignment.center,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Icon(
                          widget.navigationDirection ==
                                  MonthNavigationDirection.horizontal
                              ? Icons.chevron_right
                              : Icons.keyboard_arrow_down,
                          color: nextArrowColor,
                          size: arrowSize,
                        )),
                  ),
                )),
          )
        : Container();

    final Color? todaySplashColor =
        !widget.enableInteraction ? Colors.transparent : null;
    final Widget todayIcon = widget.showTodayButton
        ? Container(
            alignment: Alignment.center,
            color: headerBackgroundColor,
            width: todayIconWidth,
            height: headerHeight,
            padding: EdgeInsets.all(useMobilePlatformUI ? 2 : 4),
            child: Material(
                color: headerBackgroundColor,
                child: InkWell(
                  splashColor: todaySplashColor,
                  highlightColor: todaySplashColor,
                  hoverColor: todaySplashColor,
                  splashFactory: _CustomSplashFactory(),
                  onTap: () {
                    if (!widget.enableInteraction) {
                      return;
                    }

                    widget.removePicker();
                    widget.controller.displayDate = DateTime.now();
                  },
                  child: Semantics(
                    label: todayText,
                    child: useMobilePlatformUI
                        ? Container(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            clipBehavior: Clip.antiAlias,
                            width: todayIconWidth,
                            height: headerHeight,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.today,
                              color: style.color,
                              size: style.fontSize,
                            ))
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: widget.cellBorderColor ??
                                      widget.calendarTheme.cellBorderColor!),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            width: todayIconWidth,
                            alignment: Alignment.center,
                            child: Text(
                              todayText,
                              style: TextStyle(
                                  color: headerTextColor,
                                  fontSize: defaultCalendarViewTextSize),
                              maxLines: 1,
                              textDirection: TextDirection.ltr,
                            )),
                  ),
                )),
          )
        : Container();

    final Widget dividerWidget =
        widget.showTodayButton && isNeedViewSwitchOption && !useMobilePlatformUI
            ? Container(
                alignment: Alignment.center,
                color: headerBackgroundColor,
                width: dividerWidth,
                height: headerHeight,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const VerticalDivider(
                  color: Colors.grey,
                  thickness: 0.5,
                ))
            : const SizedBox(
                width: 0,
                height: 0,
              );

    List<Widget> rowChildren = <Widget>[];

    if (widget.headerStyle.textAlign == TextAlign.left ||
        widget.headerStyle.textAlign == TextAlign.start) {
      if (widget.isMobilePlatform) {
        rowChildren = <Widget>[
          headerText,
          weekNumberWidget,
          todayIcon,
          calendarViewIcon,
          leftArrow,
          rightArrow,
        ];
      } else {
        rowChildren = <Widget>[
          leftArrow,
          rightArrow,
          headerText,
          weekNumberWidget,
          todayIcon,
          dividerWidget,
        ];
        useMobilePlatformUI
            ? rowChildren.add(calendarViewIcon)
            : rowChildren.addAll(children);
      }

      return Row(
          mainAxisAlignment: MainAxisAlignment.center, children: rowChildren);
    } else if (widget.headerStyle.textAlign == TextAlign.right ||
        widget.headerStyle.textAlign == TextAlign.end) {
      if (widget.isMobilePlatform) {
        rowChildren = <Widget>[
          leftArrow,
          rightArrow,
          calendarViewIcon,
          todayIcon,
          weekNumberWidget,
          headerText,
        ];
      } else {
        useMobilePlatformUI
            ? rowChildren.add(calendarViewIcon)
            : rowChildren.addAll(children);

        rowChildren.add(dividerWidget);
        rowChildren.add(todayIcon);
        rowChildren.add(weekNumberWidget);
        rowChildren.add(headerText);
        rowChildren.add(leftArrow);
        rowChildren.add(rightArrow);
      }

      return Row(
          mainAxisAlignment: MainAxisAlignment.center, children: rowChildren);
    } else {
      if (widget.isMobilePlatform) {
        rowChildren = <Widget>[
          leftArrow,
          headerText,
          weekNumberWidget,
          todayIcon,
          dividerWidget,
          calendarViewIcon,
          rightArrow,
        ];
      } else {
        rowChildren = <Widget>[
          leftArrow,
          headerText,
          weekNumberWidget,
          rightArrow,
          todayIcon,
          dividerWidget,
        ];
        useMobilePlatformUI
            ? rowChildren.add(calendarViewIcon)
            : rowChildren.addAll(children);
      }

      return Row(
          mainAxisAlignment: MainAxisAlignment.center, children: rowChildren);
    }
  }

  @override
  void dispose() {
    widget.valueChangeNotifier.removeListener(_updateHeaderChanged);
    widget.valueChangeNotifier
        .removeListener(_updateWeekNumberChangedForTimelineMonth);
    super.dispose();
  }

  void _updateHeaderChanged() {
    setState(() {});
  }

  void _updateWeekNumberChangedForTimelineMonth() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  void _backward() {
    if (!widget.enableInteraction) {
      return;
    }
    widget.removePicker();
    widget.controller.backward!();
  }

  void _forward() {
    if (!widget.enableInteraction) {
      return;
    }
    widget.removePicker();
    widget.controller.forward!();
  }

  Widget _getCalendarViewWidget(
      Color headerBackgroundColor,
      bool useMobilePlatformUI,
      bool isNeedIcon,
      double width,
      double height,
      TextStyle style,
      Color arrowColor,
      Color headerTextColor,
      CalendarView view,
      bool isHighlighted,
      Color? highlightColor,
      double defaultCalendarViewTextSize,
      {String? semanticLabel}) {
    final String text = _calendarViews[view]!;

    final Color? calendarViewSplashColor =
        !widget.enableInteraction ? Colors.transparent : null;
    final Color? allowedViewsColor = isHighlighted
        ? highlightColor
        : widget.cellBorderColor ?? widget.calendarTheme.cellBorderColor;
    return Container(
      alignment: Alignment.center,
      color: headerBackgroundColor,
      width: width,
      height: height,
      padding: EdgeInsets.all(useMobilePlatformUI ? 2 : 4),
      child: Material(
        color: isHighlighted && (isNeedIcon || useMobilePlatformUI)
            ? Colors.grey.withOpacity(0.3)
            : headerBackgroundColor,
        child: InkWell(
            splashColor: calendarViewSplashColor,
            highlightColor: calendarViewSplashColor,
            hoverColor: calendarViewSplashColor,
            splashFactory: _CustomSplashFactory(),
            onTap: () {
              if (!widget.enableInteraction) {
                return;
              }
              if (isNeedIcon || useMobilePlatformUI) {
                widget.viewChangeNotifier.value =
                    !widget.viewChangeNotifier.value;
              } else {
                widget.controller.view = view;
              }
            },
            child: Semantics(
                label: semanticLabel ?? text,
                child: useMobilePlatformUI
                    ? Container(
                        width: width,
                        height: height,
                        alignment: Alignment.center,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Icon(
                          Icons.more_vert,
                          color: style.color,
                          size: style.fontSize,
                        ))
                    : (isNeedIcon
                        ? Container(
                            width: width,
                            height: height,
                            alignment: Alignment.center,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                border: Border.all(color: highlightColor!),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  text,
                                  style: TextStyle(
                                      color: highlightColor,
                                      fontSize: defaultCalendarViewTextSize),
                                  maxLines: 1,
                                  textDirection: TextDirection.ltr,
                                ),
                                Icon(
                                  widget.viewChangeNotifier.value
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: arrowColor,
                                  size: widget.calendarTheme.headerTextStyle!
                                          .fontSize ??
                                      14,
                                )
                              ],
                            ))
                        : Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: allowedViewsColor!),
                                borderRadius: BorderRadius.circular(5.0)),
                            width: width,
                            height: height,
                            alignment: Alignment.center,
                            child: Text(text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: isHighlighted
                                        ? highlightColor
                                        : headerTextColor,
                                    fontSize: defaultCalendarViewTextSize),
                                maxLines: 1,
                                textDirection: TextDirection.ltr),
                          )))),
      ),
    );
  }

  String _getWeekNumberString() {
    switch (widget.view) {
      case CalendarView.day:
      case CalendarView.timelineDay:
        {
          return DateTimeHelper.getWeekNumberOfYear(widget.visibleDates[0])
              .toString();
        }
      case CalendarView.week:
      case CalendarView.workWeek:
      case CalendarView.month:
      case CalendarView.schedule:
        return '';
      case CalendarView.timelineWeek:
        for (int i = 0; i < widget.visibleDates.length; i++) {
          final DateTime date = widget.visibleDates[i];
          if (date.weekday == DateTime.monday) {
            return DateTimeHelper.getWeekNumberOfYear(date).toString();
          }
        }
        break;
      case CalendarView.timelineWorkWeek:
        for (int i = 0; i < widget.visibleDates.length; i++) {
          final DateTime date = widget.visibleDates[i];
          if (date.weekday == DateTime.monday) {
            return DateTimeHelper.getWeekNumberOfYear(date).toString();
          } else if (widget.nonWorkingDays.contains(DateTime.monday)) {
            final int midDate = widget.visibleDates.length ~/ 2;
            return DateTimeHelper.getWeekNumberOfYear(
                    widget.visibleDates[midDate])
                .toString();
          }
        }
        break;
      case CalendarView.timelineMonth:
        {
          return DateTimeHelper.getWeekNumberOfYear(
                  widget.timelineMonthWeekNumberNotifier.value!)
              .toString();
        }
    }
    return DateTimeHelper.getWeekNumberOfYear(widget.visibleDates[0])
        .toString();
  }

  String _getHeaderText() {
    String monthFormat = 'MMMM';
    final String? headerDateFormat =
        widget.headerDateFormat != null && widget.headerDateFormat!.isNotEmpty
            ? widget.headerDateFormat
            : null;
    final List<String> headerFormatString = headerDateFormat == null
        ? <String>[]
        : CalendarViewHelper.getListFromString(headerDateFormat);
    final int visibleDatesCount = DateTimeHelper.getViewDatesCount(
        widget.view,
        widget.numberOfDaysInView,
        widget.numberOfDaysInView,
        widget.nonWorkingDays);
    switch (widget.view) {
      case CalendarView.schedule:
        {
          if (headerDateFormat != null) {
            return CalendarViewHelper.getLocalizedString(
                widget.valueChangeNotifier.value!,
                headerFormatString,
                widget.locale);
          }
          // ignore: lines_longer_than_80_chars
          return '${DateFormat(monthFormat, widget.locale).format(widget.valueChangeNotifier.value!)} ${widget.valueChangeNotifier.value!.year}';
        }
      case CalendarView.month:
      case CalendarView.timelineMonth:
        {
          final DateTime startDate = widget.visibleDates[0];
          final DateTime endDate =
              widget.visibleDates[widget.visibleDates.length - 1];
          if (widget.numberOfWeeksInView != 6 &&
              startDate.month != endDate.month) {
            if (headerDateFormat != null) {
              // ignore: lines_longer_than_80_chars
              return '${CalendarViewHelper.getLocalizedString(startDate, headerFormatString, widget.locale)} - ${CalendarViewHelper.getLocalizedString(endDate, headerFormatString, widget.locale)}';
            }
            monthFormat = 'MMM';
            // ignore: lines_longer_than_80_chars
            return '${DateFormat(monthFormat, widget.locale).format(startDate)} ${startDate.year} - ${DateFormat(monthFormat, widget.locale).format(endDate)} ${endDate.year}';
          }

          if (headerDateFormat != null) {
            // ignore: lines_longer_than_80_chars
            return CalendarViewHelper.getLocalizedString(
                widget.currentDate!, headerFormatString, widget.locale);
          }
          // ignore: lines_longer_than_80_chars
          return '${DateFormat(monthFormat, widget.locale).format(widget.currentDate!)} ${widget.currentDate!.year}';
        }
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          final DateTime headerDate = widget.visibleDates[0];
          if (headerDateFormat != null) {
            // ignore: lines_longer_than_80_chars
            return CalendarViewHelper.getLocalizedString(
                headerDate, headerFormatString, widget.locale);
          }
          // ignore: lines_longer_than_80_chars
          return '${DateFormat(monthFormat, widget.locale).format(headerDate)} ${headerDate.year}';
        }
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
        {
          final DateTime startDate = widget.visibleDates[0];
          final DateTime endDate =
              widget.visibleDates[widget.visibleDates.length - 1];
          if (visibleDatesCount == 1) {
            if (headerDateFormat != null) {
              // ignore: lines_longer_than_80_chars
              CalendarViewHelper.getLocalizedString(
                  startDate, headerFormatString, widget.locale);
            }
            // ignore: lines_longer_than_80_chars
            return '${DateFormat(monthFormat, widget.locale).format(startDate)} ${startDate.year}';
          } else {
            if (headerDateFormat != null) {
              // ignore: lines_longer_than_80_chars
              return '${CalendarViewHelper.getLocalizedString(startDate, headerFormatString, widget.locale)} - ${CalendarViewHelper.getLocalizedString(endDate, headerFormatString, widget.locale)}';
            }

            monthFormat = 'MMM';
            String startText =
                DateFormat(monthFormat, widget.locale).format(startDate);
            startText = '${startDate.day} $startText - ';
            final String endText =
                // ignore: lines_longer_than_80_chars
                '${endDate.day} ${DateFormat(monthFormat, widget.locale).format(endDate)} ${endDate.year}';
            return startText + endText;
          }
        }
    }
  }
}

/// It is used to generate the week and month label of schedule calendar view.
class _ScheduleLabelPainter extends CustomPainter {
  _ScheduleLabelPainter(
      this.startDate,
      this.endDate,
      this.scheduleViewSettings,
      this.isMonthLabel,
      this.isRTL,
      this.locale,
      this.useMobilePlatformUI,
      this.agendaViewNotifier,
      this.calendarTheme,
      this.themeData,
      this._localizations,
      this.textScaleFactor,
      {this.isDisplayDate = false})
      : super(repaint: isDisplayDate ? agendaViewNotifier : null);

  final DateTime startDate;
  final DateTime? endDate;
  final bool isMonthLabel;
  final bool isRTL;
  final String locale;
  final ScheduleViewSettings scheduleViewSettings;
  final SfLocalizations _localizations;
  final bool useMobilePlatformUI;
  final ValueNotifier<ScheduleViewHoveringDetails?> agendaViewNotifier;
  final SfCalendarThemeData calendarTheme;
  final ThemeData themeData;
  final bool isDisplayDate;
  final double textScaleFactor;
  final TextPainter _textPainter = TextPainter();
  final Paint _backgroundPainter = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    /// Draw the week label.
    if (!isMonthLabel) {
      if (isDisplayDate) {
        _addDisplayDateLabel(canvas, size);
      } else {
        _addWeekLabel(canvas, size);
      }
    } else {
      /// Draw the month label
      _addMonthLabel(canvas, size);
    }
  }

  void _addDisplayDateLabel(Canvas canvas, Size size) {
    /// Add the localized add new appointment text for display date view.
    final TextSpan span = TextSpan(
      text: _localizations.noEventsCalendarLabel,
      style: themeData.textTheme.bodyMedium!.merge(
          scheduleViewSettings.weekHeaderSettings.weekTextStyle ??
              scheduleViewSettings.placeholderTextStyle),
    );

    double xPosition = 10;
    _updateTextPainter(span);

    _textPainter.layout(
        maxWidth: size.width - xPosition > 0 ? size.width - xPosition : 0);
    if (isRTL) {
      xPosition = size.width - _textPainter.width - xPosition;
    }

    /// Draw display date view text
    _textPainter.paint(
        canvas, Offset(xPosition, (size.height - _textPainter.height) / 2));

    /// Add hovering effect on display date view.
    if (isDisplayDate &&
        agendaViewNotifier.value != null &&
        isSameDate(agendaViewNotifier.value!.hoveringDate, startDate)) {
      const double padding = 5;
      if (useMobilePlatformUI) {
        final Rect rect = Rect.fromLTWH(
            0, padding, size.width - 2, size.height - (2 * padding));
        _backgroundPainter.color =
            calendarTheme.selectionBorderColor!.withOpacity(0.4);
        _backgroundPainter.style = PaintingStyle.stroke;
        _backgroundPainter.strokeWidth = 2;
        canvas.drawRect(rect, _backgroundPainter);
        _backgroundPainter.style = PaintingStyle.fill;
      } else {
        const double viewPadding = 2;
        final Rect rect = Rect.fromLTWH(
            0,
            padding + viewPadding,
            size.width - (isRTL ? viewPadding : padding),
            size.height - (2 * (viewPadding + padding)));
        _backgroundPainter.color = Colors.grey.withOpacity(0.1);
        canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(4)),
            _backgroundPainter);
      }
    }
  }

  void _addWeekLabel(Canvas canvas, Size size) {
    double xPosition = 0;
    const double yPosition = 0;
    final String startDateFormat =
        scheduleViewSettings.weekHeaderSettings.startDateFormat ?? 'MMM dd';
    String? endDateFormat =
        scheduleViewSettings.weekHeaderSettings.endDateFormat;
    if (startDate.month == endDate!.month && endDateFormat == null) {
      endDateFormat = 'dd';
    }

    endDateFormat ??= 'MMM dd';
    final List<String> startDateStringFormats =
        CalendarViewHelper.getListFromString(startDateFormat);
    final List<String> endDateStringFormats =
        CalendarViewHelper.getListFromString(endDateFormat);
    final String firstDate = CalendarViewHelper.getLocalizedString(
        startDate, startDateStringFormats, locale);
    final String lastDate = CalendarViewHelper.getLocalizedString(
        endDate!, endDateStringFormats, locale);
    final TextSpan span = TextSpan(
      text: '$firstDate - $lastDate',
      style: themeData.textTheme.bodyMedium!
          .copyWith(color: Colors.grey, fontSize: 15)
          .merge(scheduleViewSettings.weekHeaderSettings.weekTextStyle),
    );
    _backgroundPainter.color =
        scheduleViewSettings.weekHeaderSettings.backgroundColor;

    /// Draw week label background.
    canvas.drawRect(
        Rect.fromLTWH(0, yPosition, size.width,
            scheduleViewSettings.weekHeaderSettings.height),
        _backgroundPainter);
    _updateTextPainter(span);

    _textPainter.layout(maxWidth: size.width - 10 > 0 ? size.width - 10 : 0);

    if (scheduleViewSettings.weekHeaderSettings.textAlign == TextAlign.right ||
        scheduleViewSettings.weekHeaderSettings.textAlign == TextAlign.end) {
      xPosition = size.width - _textPainter.width;
    } else if (scheduleViewSettings.weekHeaderSettings.textAlign ==
        TextAlign.center) {
      xPosition = size.width / 2 - _textPainter.width / 2;
    }

    if (isRTL) {
      xPosition = size.width - _textPainter.width - xPosition;
      if (scheduleViewSettings.weekHeaderSettings.textAlign == TextAlign.left ||
          scheduleViewSettings.weekHeaderSettings.textAlign == TextAlign.end) {
        xPosition = 0;
      } else if (scheduleViewSettings.weekHeaderSettings.textAlign ==
          TextAlign.center) {
        xPosition = size.width / 2 - _textPainter.width / 2;
      }
    }

    /// Draw week label text
    _textPainter.paint(
        canvas,
        Offset(
            xPosition,
            yPosition +
                (scheduleViewSettings.weekHeaderSettings.height / 2 -
                    _textPainter.height / 2)));
  }

  void _addMonthLabel(Canvas canvas, Size size) {
    double xPosition = 0;
    const double yPosition = 0;
    final String monthFormat =
        scheduleViewSettings.monthHeaderSettings.monthFormat;
    final List<String> monthStringFormats =
        CalendarViewHelper.getListFromString(monthFormat);
    final String dateString = CalendarViewHelper.getLocalizedString(
        startDate, monthStringFormats, locale);
    final TextSpan span = TextSpan(
      text: dateString,
      style: themeData.textTheme.bodyLarge!
          .copyWith(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400)
          .merge(scheduleViewSettings.monthHeaderSettings.monthTextStyle),
    );
    _backgroundPainter.shader = null;
    _backgroundPainter.color =
        scheduleViewSettings.monthHeaderSettings.backgroundColor;
    final Rect rect = Rect.fromLTWH(0, yPosition, size.width,
        scheduleViewSettings.monthHeaderSettings.height);

    /// Draw month label background.
    canvas.drawRect(rect, _backgroundPainter);
    _updateTextPainter(span);

    _textPainter.layout(maxWidth: size.width - 10 > 0 ? size.width - 10 : 0);

    final double viewPadding = size.width * 0.15;
    xPosition = viewPadding;
    if (scheduleViewSettings.monthHeaderSettings.textAlign == TextAlign.right ||
        scheduleViewSettings.monthHeaderSettings.textAlign == TextAlign.end) {
      xPosition = size.width - _textPainter.width;
    } else if (scheduleViewSettings.monthHeaderSettings.textAlign ==
        TextAlign.center) {
      xPosition = size.width / 2 - _textPainter.width / 2;
    }

    if (isRTL) {
      xPosition = size.width - _textPainter.width - xPosition;
      if (scheduleViewSettings.monthHeaderSettings.textAlign ==
              TextAlign.left ||
          scheduleViewSettings.monthHeaderSettings.textAlign == TextAlign.end) {
        xPosition = 0;
      } else if (scheduleViewSettings.monthHeaderSettings.textAlign ==
          TextAlign.center) {
        xPosition = size.width / 2 - _textPainter.width / 2;
      }
    }

    /// Draw month label text.
    _textPainter.paint(canvas, Offset(xPosition, _textPainter.height));
  }

  void _updateTextPainter(TextSpan span) {
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaleFactor = textScaleFactor;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    double cellHeight;
    const double top = 0;
    const double left = 0;
    cellHeight = 0;
    String accessibilityText;
    if (!isMonthLabel) {
      if (!isDisplayDate) {
        cellHeight = scheduleViewSettings.weekHeaderSettings.height;
        accessibilityText =
            // ignore: lines_longer_than_80_chars
            '${DateFormat('MMMM dd', locale).format(startDate)}to${DateFormat('MMMM dd', locale).format(endDate!)}';
      } else {
        cellHeight = size.height;
        accessibilityText = _localizations.noEventsCalendarLabel;
      }
    } else {
      cellHeight = scheduleViewSettings.monthHeaderSettings.height;
      accessibilityText = DateFormat('MMMM yyyy', locale).format(startDate);
    }

    semanticsBuilder.add(CustomPainterSemantics(
      rect: Rect.fromLTWH(left, top, size.width, cellHeight),
      properties: SemanticsProperties(
        label: accessibilityText,
        textDirection: TextDirection.ltr,
      ),
    ));

    return semanticsBuilder;
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilder(size);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return true;
  }
}

/// Used to implement the sticky header in schedule calendar view
/// based on its header and content widget.
class _ScheduleAppointmentView extends Stack {
  _ScheduleAppointmentView({
    required Widget content,
    required Widget header,
    AlignmentDirectional? alignment,
    Key? key,
  }) : super(
          key: key,
          children: <Widget>[
            RepaintBoundary(child: content),
            RepaintBoundary(child: header)
          ],
          alignment: alignment ?? AlignmentDirectional.topStart,
        );

  @override
  RenderStack createRenderObject(BuildContext context) =>
      _AppointmentViewHeaderRenderObject(
        scrollableState: Scrollable.of(context),
        alignment: alignment,
        textDirection: textDirection ?? Directionality.of(context),
        fit: fit,
      );

  @override
  @mustCallSuper
  void updateRenderObject(BuildContext context, RenderStack renderObject) {
    super.updateRenderObject(context, renderObject);

    if (renderObject is _AppointmentViewHeaderRenderObject) {
      renderObject.scrollableState = Scrollable.of(context);
    }
  }
}

/// Render object of the schedule calendar view item.
class _AppointmentViewHeaderRenderObject extends RenderStack {
  _AppointmentViewHeaderRenderObject({
    ScrollableState? scrollableState,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
  })  : _scrollableState = scrollableState,
        super(
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
        );

  /// Used to update the child position when it scroll changed.
  ScrollableState? _scrollableState;

  /// Current view port.
  RenderAbstractViewport get _stackViewPort => RenderAbstractViewport.of(this);

  ScrollableState? get scrollableState => _scrollableState;

  set scrollableState(ScrollableState? newScrollable) {
    final ScrollableState? oldScrollable = _scrollableState;
    _scrollableState = newScrollable;

    markNeedsPaint();
    if (attached) {
      oldScrollable!.position.removeListener(markNeedsPaint);
      newScrollable!.position.addListener(markNeedsPaint);
    }
  }

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    scrollableState!.position.addListener(markNeedsPaint);
  }

  /// attach will called when the render object removed from view.
  @override
  void detach() {
    scrollableState!.position.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset paintOffset) {
    /// Update the child position.
    updateHeaderOffset();
    paintStack(context, paintOffset);
  }

  void updateHeaderOffset() {
    /// Content widget height
    final double contentSize = firstChild!.size.height;
    final RenderBox headerView = lastChild!;

    /// Header view height
    final double headerSize = headerView.size.height;

    /// Current view position on scroll view.
    final double viewPosition =
        _stackViewPort.getOffsetToReveal(this, 0).offset;

    /// Calculate the current view offset by view position on scroll view,
    /// scrolled position and scroll view view port.
    final double currentViewOffset =
        viewPosition - _scrollableState!.position.pixels - _scrollableHeight;

    /// Check current header offset exits content size, if exist then place the
    /// header at content size.
    final double offset = _getCurrentOffset(currentViewOffset, contentSize);
    final StackParentData headerParentData =
        // ignore: avoid_as
        headerView.parentData! as StackParentData;
    final double headerYOffset =
        _getHeaderOffset(contentSize, offset, headerSize);

    /// Update the header start y position.
    if (headerYOffset != headerParentData.offset.dy) {
      headerParentData.offset =
          Offset(headerParentData.offset.dx, headerYOffset);
    }
  }

  /// Return the view port height.
  double get _scrollableHeight {
    final Object viewPort = _stackViewPort;
    double viewPortHeight = 0;

    if (viewPort is RenderBox) {
      viewPortHeight = viewPort.size.height;
    }

    double anchor = 0;
    if (viewPort is RenderViewport) {
      anchor = viewPort.anchor;
    }

    return -viewPortHeight * anchor;
  }

  /// Check current header offset exits content size, if exist then place the
  /// header at content size.
  double _getCurrentOffset(double currentOffset, double contentSize) {
    final double currentHeaderPosition =
        -currentOffset > contentSize ? contentSize : -currentOffset;
    return currentHeaderPosition > 0 ? currentHeaderPosition : 0;
  }

  /// Return current offset value from header size and content size.
  double _getHeaderOffset(
    double contentSize,
    double offset,
    double headerSize,
  ) {
    return headerSize + offset < contentSize
        ? offset
        : contentSize - headerSize;
  }
}

/// Used to create the custom splash factory that shows the splash for inkwell
/// interaction.
class _CustomSplashFactory extends InteractiveInkFeatureFactory {
  /// Called when the inkwell pressed and it return custom splash.
  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return _CustomSplash(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      borderRadius: borderRadius,
      rectCallback: rectCallback,
      onRemoved: onRemoved,
    );
  }
}

/// Custom ink splash used to animate the inkwell on intercation.
class _CustomSplash extends InteractiveInkFeature {
  /// Begin a splash, centered at position relative to [referenceBox].
  ///
  /// The [controller] argument is typically obtained via
  /// `Material.of(context)`.
  ///
  /// If `containedInkWell` is true, then the splash will be sized to fit
  /// the well rectangle, then clipped to it when drawn. The well
  /// rectangle is the box returned by `rectCallback`, if provided, or
  /// otherwise is the bounds of the [referenceBox].
  ///
  /// If `containedInkWell` is false, then `rectCallback` should be null.
  /// The ink splash is clipped only to the edges of the [Material].
  /// This is the default.
  ///
  /// When the splash is removed, `onRemoved` will be called.
  _CustomSplash({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    VoidCallback? onRemoved,
  })  : _position = position,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _targetRadius = _getTargetRadius(
            referenceBox, containedInkWell, rectCallback, position),
        _clipCallback =
            _getClipCallback(referenceBox, containedInkWell, rectCallback),
        _repositionToReferenceBox = !containedInkWell,
        super(
            controller: controller,
            referenceBox: referenceBox,
            color: color,
            onRemoved: onRemoved) {
    _radiusController = AnimationController(
        duration: _kUnconfirmedRippleSplashDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _radius = _radiusController.drive(Tween<double>(
      begin: 0.0,
      end: _targetRadius,
    ));
    _alphaController = AnimationController(
        duration: _kSplashFadeDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _alpha = _alphaController!.drive(IntTween(
      begin: color.alpha,
      end: 0,
    ));

    controller.addInkFeature(this);
  }

  /// Position holds the input touch point.
  final Offset _position;

  /// Specifies the border radius used on the inkwell
  final BorderRadius _borderRadius;

  /// Radius of ink circle to be drawn on canvas based on its position.
  final double _targetRadius;

  /// clipCallback is the callback used to obtain the rect used for clipping
  /// the ink effect. If it is null, no clipping is performed on the ink circle.
  final RectCallback? _clipCallback;

  /// Specifies the reference box repositioned or not. Its value depends on
  /// contained inkwell property.
  final bool _repositionToReferenceBox;

  /// Animation used to show a ripple.
  late Animation<double> _radius;

  /// Controller used to handle the ripple animation.
  late AnimationController _radiusController;

  /// Animation used to handle a opacity.
  late Animation<int> _alpha;

  /// Controller used to handle the opacity animation.
  late AnimationController? _alphaController;

  @override
  void confirm() {
    /// Calculate the ripple animation duration from its radius value and start
    /// the animation.
    Duration duration = Duration(milliseconds: (_targetRadius * 10).floor());
    duration = duration > _kUnconfirmedRippleSplashDuration
        ? _kUnconfirmedRippleSplashDuration
        : duration;
    _radiusController
      ..duration = duration
      ..forward();
    _alphaController!.forward();
  }

  @override
  void cancel() {
    _alphaController?.forward();
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    /// Dispose inkwell animation when the animation completed.
    if (status == AnimationStatus.completed) {
      dispose();
    }
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _alphaController!.dispose();
    _alphaController = null;
    super.dispose();
  }

  ///Draws an ink splash or ink ripple on the canvas.
  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final Paint paint = Paint()..color = color.withAlpha(_alpha.value);
    Offset? center = _position;

    /// If the reference box needs to reposition then its 'rectCallback' value
    /// is null, so calculate the position based on reference box.
    if (_repositionToReferenceBox) {
      center = Offset.lerp(center, referenceBox.size.center(Offset.zero),
          _radiusController.value);
    }

    /// Get the offset needs to translate, if it not specified then it
    /// returns null value.
    final Offset? originOffset = MatrixUtils.getAsTranslation(transform);
    canvas.save();

    /// Translate the canvas based on offset value.
    if (originOffset == null) {
      canvas.transform(transform.storage);
    } else {
      canvas.translate(originOffset.dx, originOffset.dy);
    }

    if (_clipCallback != null) {
      /// Clip and draw the rect with fade animation value on canvas.
      final Rect rect = _clipCallback!();
      if (_borderRadius != BorderRadius.zero) {
        final RRect roundedRect = RRect.fromRectAndCorners(
          rect,
          topLeft: _borderRadius.topLeft,
          topRight: _borderRadius.topRight,
          bottomLeft: _borderRadius.bottomLeft,
          bottomRight: _borderRadius.bottomRight,
        );
        canvas.clipRRect(roundedRect);
        canvas.drawRRect(roundedRect, paint);
      } else {
        canvas.clipRect(rect);
        canvas.drawRect(rect, paint);
      }
    }

    /// Draw the ripple on canvas.
    canvas.drawCircle(center!, _radius.value, paint);
    canvas.restore();
  }
}

class _AgendaDateTimePainter extends CustomPainter {
  _AgendaDateTimePainter(
      this.selectedDate,
      this.monthViewSettings,
      this.scheduleViewSettings,
      this.todayHighlightColor,
      this.todayTextStyle,
      this.locale,
      this.calendarTheme,
      this.themeData,
      this.agendaDateNotifier,
      this.viewWidth,
      this.isRTL,
      this.textScaleFactor,
      this.isMobilePlatform)
      : super(repaint: agendaDateNotifier);

  final DateTime? selectedDate;
  final MonthViewSettings? monthViewSettings;
  final ScheduleViewSettings? scheduleViewSettings;
  final Color? todayHighlightColor;
  final TextStyle? todayTextStyle;
  final String locale;
  final ValueNotifier<ScheduleViewHoveringDetails?> agendaDateNotifier;
  final SfCalendarThemeData calendarTheme;
  final ThemeData themeData;
  final double viewWidth;
  final bool isRTL;
  final double textScaleFactor;
  final bool isMobilePlatform;
  final Paint _linePainter = Paint();
  final TextPainter _textPainter = TextPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _linePainter.isAntiAlias = true;
    const double padding = 5;
    if (selectedDate == null) {
      return;
    }

    final bool useMobilePlatformUI =
        CalendarViewHelper.isMobileLayoutUI(viewWidth, isMobilePlatform);
    final bool isToday = isSameDate(selectedDate, DateTime.now());
    TextStyle? dateTextStyle, dayTextStyle;

    /// Holds the default agenda day text style from framework text theme.
    final TextStyle agendaDayThemeTextStyle =
        themeData.textTheme.bodySmall!.copyWith(
      color: themeData.colorScheme.onSurface.withOpacity(0.54),
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );

    /// Holds the default agenda date text style from framework text theme.
    final TextStyle agendaDateThemeTextStyle =
        themeData.textTheme.bodyMedium!.copyWith(
      color: themeData.colorScheme.onSurface,
      fontSize: 18,
    );
    if (monthViewSettings != null) {
      dayTextStyle = agendaDayThemeTextStyle
          .merge(calendarTheme.agendaDayTextStyle)
          .merge(monthViewSettings!.agendaStyle.dayTextStyle);
      dateTextStyle = agendaDateThemeTextStyle
          .merge(calendarTheme.agendaDateTextStyle)
          .merge(monthViewSettings!.agendaStyle.dateTextStyle);
    } else {
      if (useMobilePlatformUI) {
        dayTextStyle = agendaDayThemeTextStyle
            .merge(calendarTheme.agendaDayTextStyle)
            .merge(scheduleViewSettings!.dayHeaderSettings.dayTextStyle);
        dateTextStyle = agendaDateThemeTextStyle
            .merge(calendarTheme.agendaDateTextStyle)
            .merge(scheduleViewSettings!.dayHeaderSettings.dateTextStyle);
      } else {
        dayTextStyle = agendaDayThemeTextStyle.merge(
            scheduleViewSettings!.dayHeaderSettings.dayTextStyle ??
                TextStyle(
                    color: calendarTheme.agendaDayTextStyle != null
                        ? calendarTheme.agendaDayTextStyle!.color
                        : null,
                    fontSize: 9,
                    fontWeight: FontWeight.w500));
        dateTextStyle = agendaDateThemeTextStyle.merge(
            scheduleViewSettings!.dayHeaderSettings.dateTextStyle ??
                TextStyle(
                    color: calendarTheme.agendaDateTextStyle != null
                        ? calendarTheme.agendaDateTextStyle!.color
                        : null,
                    fontSize: 18,
                    fontWeight: FontWeight.normal));
      }
    }

    if (isToday) {
      final Color? todayTextStyleColor = calendarTheme.todayTextStyle!.color;
      final Color? todayTextColor =
          CalendarViewHelper.getTodayHighlightTextColor(
              todayHighlightColor, todayTextStyle, calendarTheme);
      dayTextStyle = todayTextStyle != null
          ? calendarTheme.todayTextStyle!
              .copyWith(fontSize: dayTextStyle.fontSize, color: todayTextColor)
          : dayTextStyle.copyWith(color: todayTextColor);
      dateTextStyle = todayTextStyle != null
          ? calendarTheme.todayTextStyle!.copyWith(
              fontSize: dateTextStyle.fontSize, color: todayTextStyleColor)
          : dateTextStyle.copyWith(color: todayTextStyleColor);
    }

    /// Draw day label other than web schedule view.
    if (scheduleViewSettings == null || useMobilePlatformUI) {
      _addDayLabelForMobile(canvas, size, padding, dayTextStyle, dateTextStyle,
          isToday, isMobilePlatform);
    } else {
      _addDayLabelForWeb(
          canvas, size, padding, dayTextStyle, dateTextStyle, isToday);
    }
  }

  void _updateTextPainter(TextSpan span) {
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.parent;
    _textPainter.textScaleFactor = textScaleFactor;
  }

  void _addDayLabelForMobile(
      Canvas canvas,
      Size size,
      double padding,
      TextStyle dayTextStyle,
      TextStyle dateTextStyle,
      bool isToday,
      bool isMobile) {
    //// Draw Weekday
    final String dayTextFormat = scheduleViewSettings != null
        ? scheduleViewSettings!.dayHeaderSettings.dayFormat
        : 'EEE';
    TextSpan span = TextSpan(
        text: DateFormat(dayTextFormat, locale)
            .format(selectedDate!)
            .toUpperCase(),
        style: dayTextStyle);
    _updateTextPainter(span);

    _textPainter.layout(maxWidth: size.width);
    _textPainter.paint(
        canvas,
        Offset(
            padding + ((size.width - (2 * padding) - _textPainter.width) / 2),
            padding));

    final double weekDayHeight = padding + _textPainter.height;
    //// Draw Date
    span = TextSpan(text: selectedDate!.day.toString(), style: dateTextStyle);
    _updateTextPainter(span);

    _textPainter.layout(maxWidth: size.width);

    /// The padding value provides the space between the date and day text.
    const int inBetweenPadding = 2;
    final double xPosition =
        padding + ((size.width - (2 * padding) - _textPainter.width) / 2);
    double yPosition = weekDayHeight;
    if (isToday) {
      yPosition = weekDayHeight + padding + inBetweenPadding;
      _linePainter.color = todayHighlightColor!;
      _drawTodayCircle(canvas, xPosition, yPosition, padding);
    }

    /// padding added between date and day labels in web, to avoid the
    /// hovering effect overlapping issue.
    if (!isMobile && !isToday) {
      yPosition = weekDayHeight + padding + inBetweenPadding;
    }
    if (agendaDateNotifier.value != null &&
        isSameDate(agendaDateNotifier.value!.hoveringDate, selectedDate)) {
      if (xPosition < agendaDateNotifier.value!.hoveringOffset.dx &&
          xPosition + _textPainter.width >
              agendaDateNotifier.value!.hoveringOffset.dx &&
          yPosition < agendaDateNotifier.value!.hoveringOffset.dy &&
          yPosition + _textPainter.height >
              agendaDateNotifier.value!.hoveringOffset.dy) {
        _linePainter.color = isToday
            ? Colors.black.withOpacity(0.1)
            : (calendarTheme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87)
                .withOpacity(0.04);
        _drawTodayCircle(canvas, xPosition, yPosition, padding);
      }
    }

    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  void _addDayLabelForWeb(Canvas canvas, Size size, double padding,
      TextStyle dayTextStyle, TextStyle dateTextStyle, bool isToday) {
    /// Draw day label on web schedule view.
    final String dateText = selectedDate!.day.toString();

    /// Calculate the date text maximum width value.
    const String maxWidthDateText = '30';
    final String dayText = DateFormat(
            isRTL
                ? '${scheduleViewSettings!.dayHeaderSettings.dayFormat}, MMM'
                : 'MMM, ${scheduleViewSettings!.dayHeaderSettings.dayFormat}',
            locale)
        .format(selectedDate!)
        .toUpperCase();

    //// Draw Weekday
    TextSpan span = TextSpan(text: maxWidthDateText, style: dateTextStyle);
    _updateTextPainter(span);
    _textPainter.layout(maxWidth: size.width);

    /// Calculate the start padding value for web schedule view date time label.
    double startXPosition = size.width / 5;
    startXPosition = isRTL ? size.width - startXPosition : startXPosition;
    final double dateHeight = size.height;
    final double yPosition = (dateHeight - _textPainter.height) / 2;
    final double painterWidth = _textPainter.width;
    span = TextSpan(text: dateText, style: dateTextStyle);
    _textPainter.text = span;
    _textPainter.layout(maxWidth: size.width);
    double dateTextPadding = (painterWidth - _textPainter.width) / 2;
    if (dateTextPadding < 0) {
      dateTextPadding = 0;
    }

    final double dateTextStartPosition = startXPosition + dateTextPadding;
    if (isToday) {
      _linePainter.color = todayHighlightColor!;
      _drawTodayCircle(canvas, dateTextStartPosition, yPosition, padding);
    }

    if (agendaDateNotifier.value != null &&
        isSameDate(agendaDateNotifier.value!.hoveringDate, selectedDate)) {
      if (dateTextStartPosition <
              (isRTL
                  ? size.width - agendaDateNotifier.value!.hoveringOffset.dx
                  : agendaDateNotifier.value!.hoveringOffset.dx) &&
          (dateTextStartPosition + _textPainter.width) >
              (isRTL
                  ? size.width - agendaDateNotifier.value!.hoveringOffset.dx
                  : agendaDateNotifier.value!.hoveringOffset.dx) &&
          yPosition < agendaDateNotifier.value!.hoveringOffset.dy &&
          (yPosition + _textPainter.height) >
              agendaDateNotifier.value!.hoveringOffset.dy) {
        _linePainter.color = isToday
            ? Colors.black.withOpacity(0.1)
            : (calendarTheme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87)
                .withOpacity(0.04);
        _drawTodayCircle(canvas, dateTextStartPosition, yPosition, padding);
      }
    }

    _textPainter.paint(canvas, Offset(dateTextStartPosition, yPosition));

    //// Draw Date
    span = TextSpan(text: dayText, style: dayTextStyle);
    _textPainter.text = span;
    if (isRTL) {
      _textPainter.layout(maxWidth: startXPosition);
      startXPosition -= _textPainter.width + (3 * padding);
      if (startXPosition > 0) {
        _textPainter.paint(canvas,
            Offset(startXPosition, (dateHeight - _textPainter.height) / 2));
      }
    } else {
      startXPosition += painterWidth + (3 * padding);
      if (startXPosition > size.width) {
        return;
      }
      _textPainter.layout(maxWidth: size.width - startXPosition);
      _textPainter.paint(canvas,
          Offset(startXPosition, (dateHeight - _textPainter.height) / 2));
    }
  }

  void _drawTodayCircle(
      Canvas canvas, double xPosition, double yPosition, double padding) {
    canvas.drawCircle(
        Offset(xPosition + (_textPainter.width / 2),
            yPosition + (_textPainter.height / 2)),
        _textPainter.width > _textPainter.height
            ? (_textPainter.width / 2) + padding
            : (_textPainter.height / 2) + padding,
        _linePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilder(size);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return true;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    if (selectedDate == null) {
      return semanticsBuilder;
    } else if (selectedDate != null) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: SemanticsProperties(
          label: DateFormat('EEEEE').format(selectedDate!) +
              DateFormat('dd MMMM yyyy').format(selectedDate!),
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    return semanticsBuilder;
  }
}

/// Used to store the height and intersection point of scroll view item.
/// intersection point used to identify the view does not have same month dates.
class _ScheduleViewDetails {
  late double _height;
  late double _intersectPoint;
}

/// Returns the maximum radius value calculated based on input touch position.
double _getTargetRadius(RenderBox referenceBox, bool containedInkWell,
    RectCallback? rectCallback, Offset position) {
  /// If `containedInkWell` is false, then `rectCallback` should be null.
  if (!containedInkWell) {
    return Material.defaultSplashRadius;
  }

  final Size size =
      rectCallback != null ? rectCallback().size : referenceBox.size;
  final double d1 = (position - size.topLeft(Offset.zero)).distance;
  final double d2 = (position - size.topRight(Offset.zero)).distance;
  final double d3 = (position - size.bottomLeft(Offset.zero)).distance;
  final double d4 = (position - size.bottomRight(Offset.zero)).distance;
  return math.max(math.max(d1, d2), math.max(d3, d4)).ceilToDouble();
}

/// Return the rect callback value based on its argument value.
RectCallback? _getClipCallback(
    RenderBox referenceBox, bool containedInkWell, RectCallback? rectCallback) {
  if (rectCallback != null) {
    /// If `containedInkWell` is false, then `rectCallback` should be null.
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell) {
    return () => Offset.zero & referenceBox.size;
  }
  return null;
}

Size _getTextWidgetWidth(
    String text, double height, double width, BuildContext context,
    {TextStyle? style}) {
  /// Create new text with it style.
  final Widget richTextWidget = Text(
    text,
    style: style,
    maxLines: 1,
    softWrap: false,
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.left,
  ).build(context);

  RenderParagraph? renderObject;
  if (richTextWidget is! RichText) {
    assert(richTextWidget is RichText);
  } else {
    /// Create and layout the render object based on allocated width and height.
    renderObject = richTextWidget.createRenderObject(context);
  }
  renderObject!.layout(BoxConstraints(
    minWidth: width,
    maxWidth: width,
    minHeight: height,
    maxHeight: height,
  ));

  /// Get the size of text by using render object.
  final List<TextBox> textBox = renderObject.getBoxesForSelection(
      TextSelection(baseOffset: 0, extentOffset: text.length));
  double textWidth = 0;
  double textHeight = 0;
  for (final TextBox box in textBox) {
    textWidth += box.right - box.left;
    final double currentBoxHeight = box.bottom - box.top;
    textHeight = textHeight > currentBoxHeight ? textHeight : currentBoxHeight;
  }

  /// 10 padding added for text box(left and right side both as 5).
  return Size(textWidth + 10, textHeight + 10);
}

Map<CalendarView, String> _getCalendarViewsText(SfLocalizations localizations) {
  final Map<CalendarView, String> calendarViews = <CalendarView, String>{};
  calendarViews[CalendarView.day] = localizations.allowedViewDayLabel;
  calendarViews[CalendarView.week] = localizations.allowedViewWeekLabel;
  calendarViews[CalendarView.workWeek] = localizations.allowedViewWorkWeekLabel;
  calendarViews[CalendarView.timelineDay] =
      localizations.allowedViewTimelineDayLabel;
  calendarViews[CalendarView.timelineWeek] =
      localizations.allowedViewTimelineWeekLabel;
  calendarViews[CalendarView.timelineMonth] =
      localizations.allowedViewTimelineMonthLabel;
  calendarViews[CalendarView.timelineWorkWeek] =
      localizations.allowedViewTimelineWorkWeekLabel;
  calendarViews[CalendarView.month] = localizations.allowedViewMonthLabel;
  calendarViews[CalendarView.schedule] = localizations.allowedViewScheduleLabel;
  return calendarViews;
}

/// Return day label width based on schedule view setting.
double _getAgendaViewDayLabelWidth(
    ScheduleViewSettings scheduleViewSettings, bool useMobilePlatformUI) {
  if (scheduleViewSettings.dayHeaderSettings.width == -1) {
    return useMobilePlatformUI ? 50 : 150;
  }

  return scheduleViewSettings.dayHeaderSettings.width;
}
