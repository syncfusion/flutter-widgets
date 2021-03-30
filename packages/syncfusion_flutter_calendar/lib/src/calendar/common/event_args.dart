import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../resource_view/calendar_resource.dart';
import '../settings/time_region.dart';
import 'enums.dart';

/// The dates that visible on the view changes in [SfCalendar].
///
/// Details for [ViewChangedCallback], such as [visibleDates].
@immutable
class ViewChangedDetails {
  /// Creates details for [ViewChangedCallback].
  const ViewChangedDetails(this.visibleDates);

  /// The date collection that visible on current view.
  final List<DateTime> visibleDates;
}

/// The element that tapped on view in [SfCalendar]
///
/// Details for [CalendarTapCallback], such as [appointments], [date], and
/// [targetElement].
///
/// See also:
/// [CalendarTapCallback]
@immutable
class CalendarTapDetails extends CalendarTouchDetails {
  /// Creates details for [CalendarTapCallback].
  const CalendarTapDetails(List<dynamic>? appointments, DateTime? date,
      CalendarElement element, CalendarResource? resource)
      : super(appointments, date, element, resource);
}

/// The element that long pressed on view in [SfCalendar]
///
/// Details for [CalendarLongPressCallback], such as [appointments], [date] and
/// [targetElement].
///
/// See also:
/// [CalendarLongPressCallback]
@immutable
class CalendarLongPressDetails extends CalendarTouchDetails {
  /// Creates details for [CalendarLongPressCallback]
  const CalendarLongPressDetails(List<dynamic>? appointments, DateTime? date,
      CalendarElement element, CalendarResource? resource)
      : super(appointments, date, element, resource);
}

/// The element that tapped on view in [SfCalendar]
///
/// Details for [CalendarSelectionChangedCallback],
/// such as [date], and [resource].
///
/// See also:
/// [CalendarSelectionChangedCallback]
@immutable
class CalendarSelectionDetails {
  /// Creates details for [CalendarSelectionChangedCallback].
  const CalendarSelectionDetails(this.date, this.resource);

  /// The date time value that represents selected calendar cell on
  /// timeslot and month views.
  final DateTime? date;

  /// The resource associated with the selected calendar cell in timeline views.
  final CalendarResource? resource;
}

/// The element that tapped or long pressed on view in [SfCalendar].
///
/// Base class for [CalendarTapDetails] and [CalendarLongPressDetails].
///
/// See also:
/// [CalendarTapDetails]
/// [CalendarLongPressDetails]
/// [CalendarTapCallback]
/// [CalendarLongPressCallback]
@immutable
class CalendarTouchDetails {
  /// Creates details for [CalendarTapCallback] and [CalendarLongPressCallback].
  const CalendarTouchDetails(
      this.appointments, this.date, this.targetElement, this.resource);

  /// The collection of appointments that tapped or falls inside the selected
  /// date.
  final List<dynamic>? appointments;

  /// The date cell that tapped on view.
  final DateTime? date;

  /// The element that tapped on view.
  final CalendarElement targetElement;

  /// The resource associated with the tapped calendar cell in timeline views.
  final CalendarResource? resource;
}

/// Signature for a function that creates a widget based on month
/// header details.
typedef ScheduleViewMonthHeaderBuilder = Widget Function(
    BuildContext context, ScheduleViewMonthHeaderDetails details);

/// Signature for a function that creates a widget based on month cell details.
typedef MonthCellBuilder = Widget Function(
    BuildContext context, MonthCellDetails details);

/// Signature for a function that creates a widget based on appointment details.
typedef CalendarAppointmentBuilder = Widget Function(BuildContext context,
    CalendarAppointmentDetails calendarAppointmentDetails);

/// Signature for a function that creates a widget based on time region details.
typedef TimeRegionBuilder = Widget Function(
    BuildContext context, TimeRegionDetails timeRegionDetails);

/// Signature for the function that create the widget based on load
/// more details.
typedef LoadMoreWidgetBuilder = Widget Function(
    BuildContext context, LoadMoreCallback loadMoreAppointments);

/// Signature for the function that have no arguments and return no data, but
/// that return a [Future] to indicate when their work is complete.
typedef LoadMoreCallback = Future<void> Function();

/// Contains the details that needed on month cell builder.
class MonthCellDetails {
  /// Default constructor to store the details needed in month cell builder
  const MonthCellDetails(
      this.date, this.appointments, this.visibleDates, this.bounds);

  /// The date value associated with the month cell widget.
  final DateTime date;

  /// The appointments associated with this date.
  final List<Object> appointments;

  /// The visible dates of the month view.
  final List<DateTime> visibleDates;

  /// The position and size of the widget.
  final Rect bounds;
}

/// Contains the details that needed on schedule view month header builder.
class ScheduleViewMonthHeaderDetails {
  /// Default constructor to store the details needed in builder
  const ScheduleViewMonthHeaderDetails(this.date, this.bounds);

  /// The date value associated with the schedule view month header widget.
  final DateTime date;

  /// The position and size of the widget.
  final Rect bounds;
}

/// Contains the details that needed on appointment view builder.
class CalendarAppointmentDetails {
  /// Default constructor to store the details needed in appointment builder.
  const CalendarAppointmentDetails(this.date, this.appointments, this.bounds,
      {this.isMoreAppointmentRegion = false});

  /// The date value associated with the appointment view widget.
  final DateTime date;

  /// The position and size of the widget.
  final Rect bounds;

  /// The appointment details associated with the appointment view widget.
  /// It holds more appointments when it is more appointment
  /// region [All day panel and Month cell more region].
  final Iterable appointments;

  /// Determines whether the widget replaces the more appointment region.
  /// It is applicable on the day, week, workweek views all day panel and
  /// month cell appointment.
  final bool isMoreAppointmentRegion;
}

/// Contains the details that needed on special region view builder.
class TimeRegionDetails {
  /// Default constructor to store the details needed in time region builder.
  TimeRegionDetails(this.region, this.date, this.bounds);

  /// Region detail associated with the time region view in day, week,
  /// workweek and timeline day, week, workweek views.
  final TimeRegion region;

  /// Date value associated with the time region.
  final DateTime date;

  /// Position and size of the time region view widget.
  final Rect bounds;
}

/// Signature for callback that reports that a current view or current visible
/// dates changes.
///
/// The visible dates collection visible on view when the view changes available
/// in the [ViewChangedDetails].
///
/// Used by [SfCalendar.onViewChanged].
typedef ViewChangedCallback = void Function(
    ViewChangedDetails viewChangedDetails);

/// Signature for callback that reports that a calendar element tapped on view.
///
/// The tapped date, appointments, and element details when the tap action
///  performed on element available in the [CalendarTapDetails].
///
/// Used by[SfCalendar.onTap].
typedef CalendarTapCallback = void Function(
    CalendarTapDetails calendarTapDetails);

/// Signature for callback that reports that a calendar element long pressed
/// on view.
///
/// The tapped date, appointments, and element details when the  long press
///  action performed on element available in the [CalendarLongPressDetails].
///
/// Used by[SfCalendar.onLongPress].
typedef CalendarLongPressCallback = void Function(
    CalendarLongPressDetails calendarLongPressDetails);

/// Signature for callback that reports that
/// a calendar view selection changed on view.
///
/// The selection changed date and resource details
/// when the selection changed action
/// performed on element available in the [CalendarSelectionDetails].
///
/// Used by[SfCalendar.onSelectionChanged].
typedef CalendarSelectionChangedCallback = void Function(
    CalendarSelectionDetails calendarSelectionDetails);
