/// A direction in which the [SfCalendar] month view navigates.
enum MonthNavigationDirection {
  /// - MonthNavigationDirection.vertical, Navigates in top and bottom direction
  vertical,

  /// - MonthNavigationDirection.horizontal, Navigates in left and top direction
  horizontal
}

/// Available views for [SfCalendar].
enum CalendarView {
  /// - CalendarView.day, displays the day view.
  day,

  /// - CalendarView.week, displays the week view.
  week,

  /// - CalendarView.workWeek, displays the workweek view.
  workWeek,

  /// - CalendarView.month, displays the month view.
  month,

  /// - CalendarView.timelineDay, displays the timeline day view.
  timelineDay,

  /// - CalendarView.timelineWeek, displays the timeline week view.
  timelineWeek,

  /// - CalendarView.timelineWorkWeek, displays the timeline work week view.
  timelineWorkWeek,

  /// CalendarView.timelineMonth, refers to the timeline month view in
  /// [SfCalendar].
  ///
  /// In timeline month view, current month dates are rendered as columns along
  /// a horizontal axis with each column representing a day in a month.

  /// See also:
  /// [TimeSlotViewSettings]
  /// For more about time slot views [refer here](https://help.syncfusion.com/flutter/calendar/timeslot-views)
  timelineMonth,

  /// - CalendarView.schedule, displays the schedule view.
  schedule
}

/// Available appointment display mode for [SfCalendar] month cell.
enum MonthAppointmentDisplayMode {
  /// - MonthAppointmentDisplayMode.indicator, displays the appointment as dot
  /// indicator.
  indicator,

  /// - MonthAppointmentDisplayMode.appointment, displays the appointment as
  /// appointment view.
  appointment,

  /// - MonthAppointmentDisplayMode.none, doesn't display appointment on view.
  none
}

/// Available recurrence types for [Appointment] in [SfCalendar]
enum RecurrenceType {
  /// - RecurrenceType.daily, indicates the appointment occurrence repeated in
  /// every day.
  daily,

  /// - RecurrenceType.weekly, indicates the appointment occurrence repeated in
  /// every week.
  weekly,

  /// - RecurrenceType.monthly, indicates the appointment occurrence repeated in
  /// every month.
  monthly,

  /// - RecurrenceType.yearly, indicates the appointment occurrence repeated in
  /// every year.
  yearly,
}

/// The available options to recur the [Appointment] in [SfCalendar]
enum RecurrenceRange {
  /// - RecurrenceRange.endDate, indicates the appointment occurrence repeated
  /// until the end date.
  endDate,

  /// - RecurrenceRange.noEndDate, indicates the appointment occurrence repeated
  /// until the last date of the calendar.
  noEndDate,

  /// - RecurrenceRange.count, indicates the appointment occurrence repeated
  /// with specified count times.
  count
}

/// The week days occurrence of [Appointment].
enum WeekDays {
  /// - WeekDays.sunday, indicates the appointment occurred in sunday.
  sunday,

  /// - WeekDays.monday, indicates the appointment occurred in monday.
  monday,

  /// - WeekDays.tuesday, indicates the appointment occurred in tuesday.
  tuesday,

  /// - WeekDays.wednesday, indicates the appointment occurred in wednesday.
  wednesday,

  /// - WeekDays.thursday, indicates the appointment occurred in thursday.
  thursday,

  /// - WeekDays.friday, indicates the appointment occurred in friday.
  friday,

  /// - WeekDays.saturday, indicates the appointment occurred in saturday.
  saturday
}

/// The available calendar elements for the [CalendarTapDetails] in [SfCalendar]
enum CalendarElement {
  /// - CalendarElement.header, Indicates that the calendar header view tapped.
  header,

  /// - CalendarElement.viewHeader, indicates that the calendar view header view
  /// tapped.
  viewHeader,

  /// - CalendarElement.header, Indicates that the calendar cell tapped.
  calendarCell,

  /// - CalendarElement.header, Indicates that the [Appointment] tapped.
  appointment,

  /// - CalendarElement.agenda, Indicates that the agenda view tapped.
  agenda,

  /// - CalendarElement.allDayPanel, Indicates that the region in the all-day
  /// area. It is added besides the view header in day view, and below view
  /// header in the week and work week views. For week and work week views this
  /// all-day panel will be added if the view must contain at least one
  /// appointment.
  ///
  /// _Note:_ The all day panel doesn't available in the [CalendarView.month],
  /// [CalendarView.timelineDay], [CalendarView.timelineWeek] and
  /// [CalendarView.timelineWorkWeekView].
  allDayPanel,

  /// - CalendarElement.moreAppointmentIndicator, Used to Indicate that the
  /// three dots are in the more appointment region of the month cell.
  /// More appointment indicators are applied to the month cell when
  /// its appointment display mode as appointment and the month cell
  /// appointment count is greater than the maximum appointment display count.

  /// _Note:_ This element applies to the month calendar view with the
  /// appointment display mode as the appointment and the platform
  /// on the web page.
  moreAppointmentRegion,

  /// - CalendarElement.resourceHeader, Indicates that the region in the
  /// resource panel, the view is on left side of timeline views, to display the
  /// assigned resources in view.
  ///
  /// _Note: _This element applies to the timeline views with resource assigned
  /// to the calendar data source.
  resourceHeader
}

/// Action performed in data source
enum CalendarDataSourceAction {
  /// - CalendarDataSourceAction.add, add action to be performed, the
  /// appointment will be added to the collection.
  ///
  /// _Note:_ This is applicable only for appointment collection add.
  add,

  /// - CalendarDataSourceAction.remove, remove action to be performed, the
  /// appointment will be removed  from the collection.
  ///
  /// _Note:_ This is applicable only for appointment collection remove.
  remove,

  /// - CalendarDataSourceAction.reset, reset action to be performed, the
  /// appointment collection will be resets.
  ///
  /// _Note:_ This is applicable only for appointment collection reset.
  reset,

  /// - CalendarDataSourceAction.addResource, add action to be performed and the
  /// resource will be added to the [SfCalendar].
  ///
  /// _Note:_ This is applicable only when adding the resource to the resource
  /// collection.
  addResource,

  /// - CalendarDataSourceAction.removeResource, remove action to be performed
  /// and the resource will be removed from the [SfCalendar].
  ///
  /// _Note:_ This is applicable only when removing the resource from the
  /// resource collection .
  removeResource,

  /// - CalendarDataSourceAction.resetResource, reset action to be performed and
  /// the resource collection will be reset.
  ///
  /// _Note:_ This is applicable only when the resource collection reset.
  resetResource
}

/// Available view navigation modes for [SfCalendar].
enum ViewNavigationMode {
  /// - ViewNavigationMode.snap, Allows to switching to previous/next views
  /// through swipe interaction in SfCalendar.
  snap,

  /// - ViewNavigationMode.none, Restrict the next or previous view dates
  /// to be shown by swipe interaction in SfCalendar.
  ///
  /// It will not impact scrolling timeslot views,
  /// [controller.forward], [controller.backward]
  /// and [showNavigationArrow].
  none
}
