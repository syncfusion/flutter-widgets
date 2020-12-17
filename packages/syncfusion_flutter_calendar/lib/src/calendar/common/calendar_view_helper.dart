part of calendar;

bool _isRTLLayout(BuildContext context) {
  final TextDirection direction = Directionality.of(context);
  return direction != null && direction == TextDirection.rtl;
}

/// Determine the current platform needs mobile platform UI.
/// The [_kMobileViewWidth] value is a breakpoint for mobile platform.
bool _isMobileLayoutUI(double width, bool isMobileLayout) {
  return isMobileLayout || width <= _kMobileViewWidth;
}

/// Determine the current platform is mobile platform(android or iOS).
bool _isMobileLayout(TargetPlatform platform) {
  if (kIsWeb) {
    return false;
  }

  return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
}

/// Check the list is empty or not.
bool _isEmptyList<T>(List<T> value) {
  if (value == null || value.isEmpty) {
    return true;
  }

  return false;
}

/// Check the date as current month date when the month leading and trailing
/// dates not shown and its row count as 6.
bool _isCurrentMonthDate(int weekRowCount, bool showLeadingTrailingDates,
    int currentMonth, DateTime date) {
  if (_isLeadingAndTrailingDatesVisible(
      weekRowCount, showLeadingTrailingDates)) {
    return true;
  }

  if (date.month == currentMonth) {
    return true;
  }

  return false;
}

Size _getTextWidgetWidth(
    String text, double height, double width, BuildContext context,
    {TextStyle style}) {
  /// Create new text with it style.
  final RichText richTextWidget = Text(
    text,
    style: style,
    maxLines: 1,
    softWrap: false,
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.left,
  ).build(context);

  /// Create and layout the render object based on allocated width and height.
  final renderObject = richTextWidget.createRenderObject(context);
  renderObject.layout(BoxConstraints(
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

/// Check the leading and trailing dates visible or not.
bool _isLeadingAndTrailingDatesVisible(
    int weekRowCount, bool showLeadingTrailingDates) {
  return weekRowCount != 6 || showLeadingTrailingDates;
}

/// Return the start date of the month specified in date.
DateTime _getMonthStartDate(DateTime date) {
  return DateTime(date.year, date.month, 1);
}

/// Return the end date of the month specified in date.
DateTime _getMonthEndDate(DateTime date) {
  return subtractDuration(getNextMonthDate(date), const Duration(days: 1));
}

/// Return day label width based on schedule view setting.
double _getAgendaViewDayLabelWidth(
    ScheduleViewSettings scheduleViewSettings, bool useMobilePlatformUI) {
  if (scheduleViewSettings == null ||
      scheduleViewSettings.dayHeaderSettings == null ||
      scheduleViewSettings.dayHeaderSettings.width == -1) {
    return useMobilePlatformUI ? 50 : 150;
  }

  return scheduleViewSettings.dayHeaderSettings.width;
}

/// Return date collection which falls between the visible date range.
List<DateTime> _getDatesWithInVisibleDateRange(
    List<DateTime> dates, List<DateTime> visibleDates) {
  final List<DateTime> visibleMonthDates = <DateTime>[];
  if (visibleDates == null || dates == null) {
    return visibleMonthDates;
  }

  final DateTime visibleStartDate = visibleDates[0];
  final DateTime visibleEndDate = visibleDates[visibleDates.length - 1];
  final int datesCount = dates.length;
  for (int i = 0; i < datesCount; i++) {
    final DateTime currentDate = dates[i];
    if (!isDateWithInDateRange(visibleStartDate, visibleEndDate, currentDate)) {
      continue;
    }

    visibleMonthDates.add(currentDate);
  }

  return visibleMonthDates;
}

/// Check both the dates collection dates are equal or not.
bool _isDateCollectionEqual(
    List<DateTime> originalDates, List<DateTime> copyDates) {
  if (originalDates == copyDates) {
    return true;
  }

  if (originalDates == null || copyDates == null) {
    return false;
  }

  final int datesCount = originalDates.length;
  if (datesCount != copyDates.length) {
    return false;
  }

  for (int i = 0; i < datesCount; i++) {
    if (!isSameDate(originalDates[i], copyDates[i])) {
      return false;
    }
  }

  return true;
}

/// Check both the collections are equal or not.
bool _isCollectionEqual<T>(List<T> collection1, List<T> collection2) {
  if (collection1 == collection2) {
    return true;
  }

  if (_isEmptyList(collection1) && _isEmptyList(collection2)) {
    return true;
  }

  if (collection1 == null || collection2 == null) {
    return false;
  }

  final int collectionCount = collection1.length;
  if (collectionCount != collection2.length) {
    return false;
  }

  for (int i = 0; i < collectionCount; i++) {
    if (collection1[i] != collection2[i]) {
      return false;
    }
  }

  return true;
}

/// Check both the resource collection resources are equal or not.
bool _isResourceCollectionEqual(List<CalendarResource> originalCollection,
    List<CalendarResource> copyCollection) {
  if (originalCollection == copyCollection) {
    return true;
  }

  if (originalCollection == null || copyCollection == null) {
    return false;
  }

  final int datesCount = originalCollection.length;
  if (datesCount != copyCollection.length) {
    return false;
  }

  for (int i = 0; i < datesCount; i++) {
    if (originalCollection[i] != copyCollection[i]) {
      return false;
    }
  }

  return true;
}

/// Check whether the date collection contains the date value or not.
bool _isDateInDateCollection(List<DateTime> dates, DateTime date) {
  if (dates == null || dates.isEmpty) {
    return false;
  }

  for (final DateTime currentDate in dates) {
    if (isSameDate(currentDate, date)) {
      return true;
    }
  }

  return false;
}

double _getScheduleAppointmentHeight(MonthViewSettings monthViewSettings,
    ScheduleViewSettings scheduleViewSettings) {
  return monthViewSettings != null
      ? (monthViewSettings.agendaItemHeight == -1
          ? 50
          : monthViewSettings.agendaItemHeight)
      : (scheduleViewSettings.appointmentItemHeight == -1
          ? 50
          : scheduleViewSettings.appointmentItemHeight);
}

double _getScheduleAllDayAppointmentHeight(MonthViewSettings monthViewSettings,
    ScheduleViewSettings scheduleViewSettings) {
  return monthViewSettings != null
      ? (monthViewSettings.agendaItemHeight == -1
          ? 25
          : monthViewSettings.agendaItemHeight)
      : (scheduleViewSettings.appointmentItemHeight == -1
          ? 25
          : scheduleViewSettings.appointmentItemHeight);
}

/// Return the copy of list passed.
List<T> _cloneList<T>(List<T> value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return value.sublist(0);
}

/// Returns the height for an resource item to render the resource within it in
/// the resource panel.
double _getResourceItemHeight(
    double resourceViewSize,
    double timelineViewHeight,
    ResourceViewSettings resourceViewSettings,
    int resourceCount) {
  /// The combined padding value between the circle and the display name text
  final double textPadding = resourceViewSettings.showAvatar ? 10 : 0;

  /// To calculate the resource item height based on visible resource count,
  /// added this condition calculated the resource item height based on
  /// visible resource count.
  if (resourceViewSettings.visibleResourceCount > 0) {
    return timelineViewHeight / resourceViewSettings.visibleResourceCount;
  }

  double itemHeight = timelineViewHeight + textPadding;

  /// Added this condition to check if the visible resource count is `-1`, we
  /// have calculated the resource item height based on the resource panel width
  /// and the view height, the smallest of this will set as the resource item
  /// height.
  if (timelineViewHeight > resourceViewSize &&
      resourceViewSettings.visibleResourceCount < 0) {
    itemHeight = resourceViewSize + textPadding;
  }

  /// Modified the resource height if the visible resource count is `-1` on this
  /// scenario if the resource count is less, to avoid the empty white space on
  /// the screen height, we calculated the resource item height to fill into the
  /// available screen height.
  return resourceCount * itemHeight < timelineViewHeight
      ? timelineViewHeight / resourceCount
      : itemHeight;
}

/// Check and returns whether the resource panel can be added or not in the
/// calendar.
bool _isResourceEnabled(CalendarDataSource dataSource, CalendarView view) {
  return _isTimelineView(view) &&
      dataSource != null &&
      dataSource.resources != null &&
      dataSource.resources.isNotEmpty;
}

String _getAppointmentText(Appointment appointment) {
  if (appointment.isAllDay) {
    return appointment.subject + 'All day';
  } else if (appointment._isSpanned ||
      appointment.endTime.difference(appointment.startTime).inDays > 0) {
    return appointment.subject +
        DateFormat('hh mm a dd/MMMM/yyyy')
            .format(appointment.startTime)
            .toString() +
        'to' +
        DateFormat('hh mm a dd/MMMM/yyyy')
            .format(appointment.endTime)
            .toString();
  } else {
    return appointment.subject +
        DateFormat('hh mm a').format(appointment.startTime).toString() +
        '-' +
        DateFormat('hh mm a dd/MMMM/yyyy')
            .format(appointment.endTime)
            .toString();
  }
}

/// Get the exact the time from the position and the date time includes minutes
/// value.
double _getTimeToPosition(Duration duration,
    TimeSlotViewSettings timeSlotViewSettings, double minuteHeight) {
  final Duration startDuration = Duration(
      hours: timeSlotViewSettings.startHour.toInt(),
      minutes: ((timeSlotViewSettings.startHour -
                  timeSlotViewSettings.startHour.toInt()) *
              60)
          .toInt());
  final Duration difference = duration - startDuration;
  if (difference.isNegative) {
    return 0;
  }

  return difference.inMinutes * minuteHeight;
}

/// Returns the time interval value based on the given start time, end time and
/// time interval value of time slot view settings, the time interval will be
/// auto adjust if the given time interval doesn't cover the given start and end
/// time values, i.e: if the startHour set as 10 and endHour set as 20 and the
/// timeInterval value given as 180 means we cannot divide the 10 hours into
/// 3  hours, hence the time interval will be auto adjusted to 200
/// based on the given properties.
int _getTimeInterval(TimeSlotViewSettings settings) {
  double defaultLinesCount = 24;
  double totalMinutes = 0;

  if (settings.startHour >= 0 &&
      settings.endHour >= settings.startHour &&
      settings.endHour <= 24) {
    defaultLinesCount = settings.endHour - settings.startHour;
  }

  totalMinutes = defaultLinesCount * 60;

  if (settings.timeInterval.inMinutes >= 0 &&
      settings.timeInterval.inMinutes <= totalMinutes &&
      totalMinutes.round() % settings.timeInterval.inMinutes.round() == 0) {
    return settings.timeInterval.inMinutes;
  } else if (settings.timeInterval.inMinutes >= 0 &&
      settings.timeInterval.inMinutes <= totalMinutes) {
    return _getNearestValue(settings.timeInterval.inMinutes, totalMinutes);
  } else {
    return 60;
  }
}

/// Returns the horizontal lines count for a single day in day/week/workweek and time line view
double _getHorizontalLinesCount(
    TimeSlotViewSettings settings, CalendarView view) {
  if (view == CalendarView.timelineMonth) {
    return 1;
  }

  double defaultLinesCount = 24;
  double totalMinutes = 0;
  final int timeInterval = _getTimeInterval(settings);

  if (settings.startHour >= 0 &&
      settings.endHour >= settings.startHour &&
      settings.endHour <= 24) {
    defaultLinesCount = settings.endHour - settings.startHour;
  }

  totalMinutes = defaultLinesCount * 60;

  return totalMinutes / timeInterval;
}

int _getNearestValue(int timeInterval, double totalMinutes) {
  timeInterval++;
  if (totalMinutes.round() % timeInterval.round() == 0) {
    return timeInterval;
  }

  return _getNearestValue(timeInterval, totalMinutes);
}

bool _isSameTimeSlot(DateTime date1, DateTime date2) {
  if (date1 == date2) {
    return true;
  }

  if (date1 == null || date2 == null) {
    return false;
  }

  return isSameDate(date1, date2) &&
      date1.hour == date2.hour &&
      date1.minute == date2.minute;
}

// returns the single view width from the time line view for time line
double _getSingleViewWidthForTimeLineView(_CalendarViewState viewState) {
  return (viewState._scrollController.position.maxScrollExtent +
          viewState._scrollController.position.viewportDimension) /
      viewState.widget.visibleDates.length;
}

double _getTimeLabelWidth(double timeLabelViewWidth, CalendarView view) {
  if (view == CalendarView.timelineMonth) {
    return 0;
  }
  if (timeLabelViewWidth != -1) {
    return timeLabelViewWidth;
  }

  switch (view) {
    case CalendarView.timelineDay:
    case CalendarView.timelineWeek:
    case CalendarView.timelineWorkWeek:
      return 30;
    case CalendarView.day:
    case CalendarView.week:
    case CalendarView.workWeek:
      return 50;
    case CalendarView.schedule:
    case CalendarView.month:
    case CalendarView.timelineMonth:
      return 0;
  }

  return 0;
}

double _getViewHeaderHeight(double viewHeaderHeight, CalendarView view) {
  if (viewHeaderHeight != -1) {
    return viewHeaderHeight;
  }

  switch (view) {
    case CalendarView.day:
    case CalendarView.week:
    case CalendarView.workWeek:
      return 60;
    case CalendarView.month:
      return 25;
    case CalendarView.timelineDay:
    case CalendarView.timelineWeek:
    case CalendarView.timelineWorkWeek:
    case CalendarView.timelineMonth:
      return 30;
    case CalendarView.schedule:
      return 0;
  }

  return viewHeaderHeight;
}

//// method to check whether the view changed callback can triggered or not.
bool _shouldRaiseViewChangedCallback(ViewChangedCallback onViewChanged) {
  return onViewChanged != null;
}

//// method to check whether the on tap callback can triggered or not.
bool _shouldRaiseCalendarTapCallback(CalendarTapCallback onTap) {
  return onTap != null;
}

//// method to check whether the long press callback can triggered or not.
bool _shouldRaiseCalendarLongPressCallback(
    CalendarLongPressCallback onLongPress) {
  return onLongPress != null;
}

// method that raise the calendar tapped callback with the given parameters
void _raiseCalendarTapCallback(SfCalendar calendar,
    {DateTime date,
    List<dynamic> appointments,
    CalendarElement element,
    CalendarResource resource}) {
  final CalendarTapDetails calendarTapDetails =
      CalendarTapDetails(appointments, date, element, resource);
  calendar.onTap(calendarTapDetails);
}

// method that raise the calendar long press callback with the given parameters
void _raiseCalendarLongPressCallback(SfCalendar calendar,
    {DateTime date,
    List<dynamic> appointments,
    CalendarElement element,
    CalendarResource resource}) {
  final CalendarLongPressDetails calendarLongPressDetails =
      CalendarLongPressDetails(appointments, date, element, resource);
  calendar.onLongPress(calendarLongPressDetails);
}

// method that raises the visible dates changed callback with the given
// parameters
void _raiseViewChangedCallback(SfCalendar calendar,
    {List<DateTime> visibleDates}) {
  final ViewChangedDetails viewChangedDetails =
      ViewChangedDetails(visibleDates);
  calendar.onViewChanged(viewChangedDetails);
}

bool _isAutoTimeIntervalHeight(SfCalendar calendar, CalendarView view) {
  if (_isTimelineView(view)) {
    return calendar.timeSlotViewSettings.timeIntervalWidth == -1;
  } else {
    return calendar.timeSlotViewSettings.timeIntervalHeight == -1;
  }
}

/// Returns the default time interval width for timeline views.
double _getTimeIntervalWidth(double timeIntervalHeight, CalendarView view,
    double width, bool isMobilePlatform) {
  if (timeIntervalHeight >= 0) {
    return timeIntervalHeight;
  }

  if (view == CalendarView.timelineMonth &&
      !_isMobileLayoutUI(width, isMobilePlatform)) {
    return 160;
  }

  return 60;
}

/// Returns the time interval width based on property value, also arrange the
/// time slots into the view port size.
double _getTimeIntervalHeight(
    SfCalendar calendar,
    CalendarView view,
    double width,
    double height,
    int visibleDatesCount,
    double allDayHeight,
    bool isMobilePlatform) {
  final bool isTimelineView = _isTimelineView(view);
  double timeIntervalHeight = isTimelineView
      ? _getTimeIntervalWidth(calendar.timeSlotViewSettings.timeIntervalWidth,
          view, width, isMobilePlatform)
      : calendar.timeSlotViewSettings.timeIntervalHeight;

  if (!_isAutoTimeIntervalHeight(calendar, view)) {
    return timeIntervalHeight;
  }

  double viewHeaderHeight =
      _getViewHeaderHeight(calendar.viewHeaderHeight, view);

  if (view == CalendarView.day) {
    allDayHeight = _kAllDayLayoutHeight;
    viewHeaderHeight = 0;
  } else {
    allDayHeight = allDayHeight > _kAllDayLayoutHeight
        ? _kAllDayLayoutHeight
        : allDayHeight;
  }

  switch (view) {
    case CalendarView.day:
    case CalendarView.week:
    case CalendarView.workWeek:
      timeIntervalHeight = (height - allDayHeight - viewHeaderHeight) /
          _getHorizontalLinesCount(calendar.timeSlotViewSettings, view);
      break;
    case CalendarView.timelineDay:
    case CalendarView.timelineWeek:
    case CalendarView.timelineWorkWeek:
    case CalendarView.timelineMonth:
      {
        final double _horizontalLinesCount =
            _getHorizontalLinesCount(calendar.timeSlotViewSettings, view);
        timeIntervalHeight =
            width / (_horizontalLinesCount * visibleDatesCount);
        if (!_isValidWidth(
            width, calendar, visibleDatesCount, _horizontalLinesCount)) {
          // we have used 40 as a default time interval height for timeline view
          // if the time interval height set for auto time interval height
          timeIntervalHeight = 40;
        }
      }
      break;
    case CalendarView.schedule:
    case CalendarView.month:
      return 0;
  }

  return timeIntervalHeight;
}

// checks whether the width can afford the line count or else creates a
// scrollable width
bool _isValidWidth(double screenWidth, SfCalendar calendar,
    int visibleDatesCount, double horizontalLinesCount) {
  const int offSetValue = 10;
  final double tempWidth =
      visibleDatesCount * offSetValue * horizontalLinesCount;

  if (tempWidth < screenWidth) {
    return true;
  }

  return false;
}

bool _isTimelineView(CalendarView view) {
  switch (view) {
    case CalendarView.timelineDay:
    case CalendarView.timelineWeek:
    case CalendarView.timelineWorkWeek:
    case CalendarView.timelineMonth:
      return true;
    case CalendarView.day:
    case CalendarView.week:
    case CalendarView.workWeek:
    case CalendarView.month:
    case CalendarView.schedule:
      return false;
  }

  return false;
}

// converts the given schedule appointment collection to their custom
// appointment collection
List<dynamic> _getCustomAppointments(List<Appointment> appointments) {
  final List<dynamic> customAppointments = <dynamic>[];
  if (appointments != null) {
    for (int i = 0; i < appointments.length; i++) {
      customAppointments.add(appointments[i]._data);
    }

    return customAppointments;
  }

  return null;
}
