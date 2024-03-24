import 'package:flutter/material.dart';
import '../../../calendar.dart';

/// The dates that visible on the view changes in [SfCalendar].
///
/// Details for [ViewChangedCallback], such as [visibleDates].
///
/// See also:
/// * [SfCalendar.onViewChanged], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
/// * [ViewChangedCallback], signature when the current visible dates changed
/// in calendar.
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
/// * [SfCalendar.onTap], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
/// * [CalendarTapCallback], signature when any of the calendar elements
/// tapped.
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
/// * [SfCalendar.onLongPress], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
/// * [CalendarLongPressCallback], signature when any of the calendar elements
/// long pressed.
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
/// * [SfCalendar.onSelectionChanged], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
/// * [CalendarSelectionChangedCallback], signature when any of the selected
/// cell changed in calendar.
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
/// [CalendarTapDetails], to pass the tapped details information.
/// [CalendarLongPressDetails], to pass the long pressed details information.
/// [CalendarTapCallback], signature when any calendar element tapped.
/// [CalendarLongPressCallback], signature when any calendar element is long
/// pressed.
@immutable
class CalendarTouchDetails {
  /// Creates details for [CalendarTapCallback] and [CalendarLongPressCallback].
  const CalendarTouchDetails(
      this.appointments, this.date, this.targetElement, this.resource);

  /// The collection of appointments that return from the date.
  final List<dynamic>? appointments;

  /// The date that return from the view.
  final DateTime? date;

  /// The element that return from the view.
  final CalendarElement targetElement;

  /// The resource associated with the calendar cell in timeline views.
  final CalendarResource? resource;
}

/// The appointment that starts resizing on view in [SfCalendar]
///
/// Details for [AppointmentResizeStartCallback], such as [appointment], and
/// [resource]
///
/// See also:
/// * [SfCalendar.onAppointmentResizeStart], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
/// * [AppointmentResizeStartCallback], signature when appointment starts
/// resizing in calendar.
class AppointmentResizeStartDetails {
  /// Creates details for [AppointmentResizeStartCallback].
  const AppointmentResizeStartDetails(this.appointment, this.resource);

  /// The appointment that starts resizing on view in [SfCalendar].
  final dynamic appointment;

  /// The resource associated with the resizing appointment in timeline views.
  final CalendarResource? resource;
}

/// The appointment that resizing on view in [SfCalendar]
///
/// Details for [AppointmentResizeUpdateCallback], such as [appointment],
/// [resizingTime], [resizingOffset] and [resource].
///
/// See also:
/// * [SfCalendar.onAppointmentResizeUpdate], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
/// * [AppointmentResizeUpdateCallback], signature when appointment resizing in
/// calendar.
class AppointmentResizeUpdateDetails {
  /// Creates details for [AppointmentResizeUpdateCallback].
  const AppointmentResizeUpdateDetails(
      this.appointment, this.resource, this.resizingTime, this.resizingOffset);

  /// The appointment that resizing on view in [SfCalendar].
  final dynamic appointment;

  /// The resource associated with the resizing appointment in timeline views.
  final CalendarResource? resource;

  /// The current resizing time value of the appointment.
  final DateTime? resizingTime;

  /// The current resize position of the appointment.
  final Offset? resizingOffset;
}

/// The appointment that resizing ends on view in [SfCalendar]
///
/// Details for [AppointmentResizeEndCallback], such as [appointment],
/// [startTime], [endTime] and [resource].
///
/// See also:
/// * [SfCalendar.onAppointmentResizeEnd], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
/// * [AppointmentResizeEndCallback], signature when appointment resizing ends
/// in calendar.
class AppointmentResizeEndDetails {
  /// Creates details for [AppointmentResizeUpdateCallback].
  const AppointmentResizeEndDetails(
      this.appointment, this.resource, this.startTime, this.endTime);

  /// The appointment that resized on view in [SfCalendar].
  final dynamic appointment;

  /// The resource associated with the rescheduled appointment in timeline
  /// views.
  final CalendarResource? resource;

  /// The updated start time of the reschedule appointment.
  final DateTime? startTime;

  /// The updated end time of the reschedule appointment.
  final DateTime? endTime;
}

/// The appointment that starts dragging on view in [SfCalendar]
///
/// Details for [AppointmentDragStartCallback], such as [appointment], and
/// [resource]
///
/// See also:
/// * [SfCalendar.onDragStart], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
/// * [AppointmentDragStartCallback], signature when appointment starts
/// dragging in calendar.
@immutable
class AppointmentDragStartDetails {
  /// Creates details for [AppointmentDragStartCallback].
  const AppointmentDragStartDetails(this.appointment, this.resource);

  /// The dragging appointment details.
  final Object? appointment;

  /// The resource of the dragging appointment.
  final CalendarResource? resource;
}

/// The appointment that dragging on view in [SfCalendar]
///
/// Details for [AppointmentDragUpdateCallback], such as [appointment],
/// [sourceResource], [targetResource], [draggingPosition] and [draggingTime].
///
/// See also:
/// * [SfCalendar.onDragUpdate], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
/// * [AppointmentDragUpdateCallback], signature when appointment dragging in
/// calendar.
@immutable
class AppointmentDragUpdateDetails {
  /// Creates details for [AppointmentDragUpdateCallback].
  const AppointmentDragUpdateDetails(this.appointment, this.sourceResource,
      this.targetResource, this.draggingPosition, this.draggingTime);

  /// The dragging appointment.
  final Object? appointment;

  /// The source resource of the dragging appointment.
  final CalendarResource? sourceResource;

  /// The resource in which the appointment dragging.
  final CalendarResource? targetResource;

  /// The current dragging position.
  final Offset? draggingPosition;

  /// The current dragging time of the appointment.
  final DateTime? draggingTime;
}

/// The appointment that dragging ends on view in [SfCalendar]
///
/// Details for [AppointmentDragEndCallback], such as [appointment],
/// [sourceResource], [targetResource] and [droppingTime].
///
/// See also:
/// * [SfCalendar.onDragEnd], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
/// * [AppointmentDragEndCallback], signature when appointment dragging ends
/// in calendar.
class AppointmentDragEndDetails {
  /// Creates details for [AppointmentDragEndCallback].
  const AppointmentDragEndDetails(this.appointment, this.sourceResource,
      this.targetResource, this.droppingTime);

  /// The dropping appointment.
  final Object? appointment;

  /// The source resource of the dropping appointment.
  final CalendarResource? sourceResource;

  /// The dropping resource of the appointment.
  final CalendarResource? targetResource;

  /// The dropping time.
  final DateTime? droppingTime;
}

/// Details for [CalendarDetailsCallback], such as [appointments], [date], and
/// [targetElement] and [resource].
@immutable
class CalendarDetails extends CalendarTouchDetails {
  /// creates details for [CalendarDetailsCallback].
  const CalendarDetails(List<dynamic>? appointments, DateTime? date,
      CalendarElement element, CalendarResource? resource)
      : super(appointments, date, element, resource);
}

/// Signature for a function that creates a widget based on month
/// header details.
///
/// See also:
/// * [SfCalendar.scheduleViewMonthHeaderBuilder], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef ScheduleViewMonthHeaderBuilder = Widget Function(
    BuildContext context, ScheduleViewMonthHeaderDetails details);

/// Signature for a function that creates a widget based on month cell details.
///
/// See also:
/// * [SfCalendar.monthCellBuilder], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef MonthCellBuilder = Widget Function(
    BuildContext context, MonthCellDetails details);

/// Signature for a function that creates a widget based on appointment details.
///
/// See also:
/// * [SfCalendar.appointmentBuilder], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef CalendarAppointmentBuilder = Widget Function(BuildContext context,
    CalendarAppointmentDetails calendarAppointmentDetails);

/// Signature for a function that creates a widget based on time region details.
///
/// See also:
/// * [SfCalendar.timeRegionBuilder], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef TimeRegionBuilder = Widget Function(
    BuildContext context, TimeRegionDetails timeRegionDetails);

/// Signature for the function that create the widget based on load
/// more details.
///
/// See also:
/// * [SfCalendar.loadMoreWidgetBuilder], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef LoadMoreWidgetBuilder = Widget Function(
    BuildContext context, LoadMoreCallback loadMoreAppointments);

/// Signature for the function that have no arguments and return no data, but
/// that return a [Future] to indicate when their work is complete.
///
/// See also:
/// * [SfCalendar.loadMoreWidgetBuilder], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef LoadMoreCallback = Future<void> Function();

/// Signature for a function that creates a widget based on resource
/// header details.
///
/// See also:
/// * [SfCalendar.resourceViewHeaderBuilder], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef ResourceViewHeaderBuilder = Widget Function(
    BuildContext context, ResourceViewHeaderDetails details);

/// Contains the details that needed on month cell builder.
///
/// Details for the [MonthCellBuilder], such as [date], [appointments],
/// [visibleDates] and [bounds].
///
/// See also:
/// * [SfCalendar.monthCellBuilder], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
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
///
/// See also:
/// * [SfCalendar.scheduleViewMonthHeaderBuilder], which receives the
/// information.
/// * [SfCalendar], which passes the information to one of its receiver.
class ScheduleViewMonthHeaderDetails {
  /// Default constructor to store the details needed in builder
  const ScheduleViewMonthHeaderDetails(this.date, this.bounds);

  /// The date value associated with the schedule view month header widget.
  final DateTime date;

  /// The position and size of the widget.
  final Rect bounds;
}

/// Contains the details that needed on appointment view builder.
///
/// See also:
/// * [SfCalendar.appointmentBuilder], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
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
  final Iterable<dynamic> appointments;

  /// Determines whether the widget replaces the more appointment region.
  /// It is applicable on the day, week, workweek views all day panel and
  /// month cell appointment.
  final bool isMoreAppointmentRegion;
}

/// Contains the details that needed on special region view builder.
///
/// See also:
/// * [SfCalendar.timeRegionBuilder], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
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

/// Contains the details that needed on resource view header builder.
///
/// See also:
/// * [SfCalendar.resourceViewHeaderBuilder], which receives the information.
/// * [SfCalendar], which passes the information to one of its receiver.
class ResourceViewHeaderDetails {
  /// Default constructor to store the details needed in resource view
  /// header builder.
  ResourceViewHeaderDetails(this.resource, this.bounds);

  /// The resource details such as display name, color, id and image associated
  /// with the resource header widget.
  final CalendarResource resource;

  /// The position and size of the widget.
  final Rect bounds;
}

/// Signature for callback that reports that a current view or current visible
/// dates changes.
///
/// The visible dates collection visible on view when the view changes available
/// in the [ViewChangedDetails].
///
/// Used by [SfCalendar.onViewChanged].
///
/// See also:
/// * [SfCalendar.onViewChanged], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef ViewChangedCallback = void Function(
    ViewChangedDetails viewChangedDetails);

/// Signature for callback that reports that a calendar element tapped on view.
///
/// The tapped date, appointments, and element details when the tap action
///  performed on element available in the [CalendarTapDetails].
///
/// Used by[SfCalendar.onTap].
///
/// See also:
/// * [SfCalendar.onTap], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef CalendarTapCallback = void Function(
    CalendarTapDetails calendarTapDetails);

/// Signature for callback that reports that a calendar element long pressed
/// on view.
///
/// The tapped date, appointments, and element details when the  long press
///  action performed on element available in the [CalendarLongPressDetails].
///
/// Used by[SfCalendar.onLongPress].
///
/// See also:
/// * [SfCalendar.onLongPress], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
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
///
/// See also:
/// * [SfCalendar.onSelectionChanged], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef CalendarSelectionChangedCallback = void Function(
    CalendarSelectionDetails calendarSelectionDetails);

/// Signature for callback that reports that a appointment starts resizing in
/// [SfCalendar].
///
/// The resizing appointment and resource details when the appointment starts
/// to resize available in the [AppointmentResizeStartDetails].
///
/// Used by[SfCalendar.onAppointmentResizeStart].
///
/// See also:
/// * [SfCalendar.onAppointmentResizeStart], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef AppointmentResizeStartCallback = void Function(
    AppointmentResizeStartDetails appointmentResizeStartDetails);

/// Signature for callback that reports that a appointment resizing in
/// [SfCalendar].
///
/// The resizing appointment, position, time and resource details when the
/// appointment resizing available in the [AppointmentResizeUpdateDetails].
///
/// Used by[SfCalendar.onAppointmentResizeUpdate].
///
/// See also:
/// * [SfCalendar.onAppointmentResizeUpdate], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef AppointmentResizeUpdateCallback = void Function(
    AppointmentResizeUpdateDetails appointmentResizeUpdateDetails);

/// Signature for callback that reports that a appointment resizing completed in
/// [SfCalendar].
///
/// The resizing appointment, start time, end time and resource details when
/// the appointment resizing ends available in the
/// [AppointmentResizeEndDetails].
///
/// Used by[SfCalendar.onAppointmentResizeEnd].
///
/// See also:
/// * [SfCalendar.onAppointmentResizeEnd], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef AppointmentResizeEndCallback = void Function(
    AppointmentResizeEndDetails appointmentResizeEndDetails);

/// Signature for callback that reports that a appointment starts dragging in
/// [SfCalendar].
///
/// The dragging appointment and resource details when the appointment starts
/// to drag available in the [AppointmentDragStartDetails].
///
/// Used by[SfCalendar.onDragStart].
///
/// See also:
/// * [SfCalendar.onDragStart], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef AppointmentDragStartCallback = void Function(
    AppointmentDragStartDetails appointmentDragStartDetails);

/// Signature for callback that reports that a appointment dragging in
/// [SfCalendar].
///
/// The dragging appointment, position, time, sourceResource and tergetResource
/// details when the appointment resizing available
/// in the [AppointmentDragUpdateDetails].
///
/// Used by[SfCalendar.onDragUpdate].
///
/// See also:
/// * [SfCalendar.onDragUpdate], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef AppointmentDragUpdateCallback = void Function(
    AppointmentDragUpdateDetails appointmentDragUpdateDetails);

/// Signature for callback that reports that a appointment dragging completed in
/// [SfCalendar].
///
/// The dragging appointment, sourceResource, targetResource and droppingTime
/// when the appointment dragging ends available in the
/// [AppointmentDragEndDetails].
///
/// Used by[SfCalendar.onDragEnd].
///
/// See also:
/// * [SfCalendar.onDragEnd], which matches this signature.
/// * [SfCalendar], which uses this signature in one of it's callback.
typedef AppointmentDragEndCallback = void Function(
    AppointmentDragEndDetails appointmentDragEndDetails);
