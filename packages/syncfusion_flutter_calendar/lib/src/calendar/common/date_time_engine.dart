part of calendar;

//// Calculate the visible dates count based on calendar view
int _getViewDatesCount(CalendarView calendarView, int numberOfWeeks) {
  if (calendarView == null) {
    return 0;
  }

  switch (calendarView) {
    case CalendarView.month:
      return _kNumberOfDaysInWeek * numberOfWeeks;
    case CalendarView.week:
    case CalendarView.workWeek:
    case CalendarView.timelineWorkWeek:
    case CalendarView.timelineWeek:
      return _kNumberOfDaysInWeek;
    case CalendarView.timelineDay:
    case CalendarView.day:
    case CalendarView.schedule:
      return 1;
    case CalendarView.timelineMonth:

      /// 6 represents the number of weeks in view, we have used this static,
      /// since timeline month doesn't support the number of weeks in view.
      return _kNumberOfDaysInWeek * 6;
  }

  return 0;
}

/// Returns the list of current month dates alone from the dates passed.
List<DateTime> _getCurrentMonthDates(List<DateTime> visibleDates) {
  final int visibleDatesCount = visibleDates.length;
  final int currentMonth = visibleDates[visibleDatesCount ~/ 2].month;
  final List<DateTime> currentMonthDates = <DateTime>[];
  for (int i = 0; i < visibleDatesCount; i++) {
    final DateTime currentVisibleDate = visibleDates[i];
    if (currentVisibleDate.month != currentMonth) {
      continue;
    }

    currentMonthDates.add(currentVisibleDate);
  }

  return currentMonthDates;
}

//// Calculate the next view visible start date based on calendar view.
DateTime _getNextViewStartDate(
    CalendarView calendarView, int numberOfWeeksInView, DateTime date) {
  if (calendarView == null) {
    return date;
  }

  switch (calendarView) {
    case CalendarView.month:
    case CalendarView.timelineMonth:
      {
        /// The timeline month view renders the current month dates alone, hence
        /// it doesn't support the numberOfWeekInView.
        return numberOfWeeksInView == 6 ||
                calendarView == CalendarView.timelineMonth
            ? getNextMonthDate(date)
            : addDuration(date,
                Duration(days: numberOfWeeksInView * _kNumberOfDaysInWeek));
      }
    case CalendarView.week:
    case CalendarView.workWeek:
    case CalendarView.timelineWeek:
    case CalendarView.timelineWorkWeek:
      return addDuration(date, const Duration(days: _kNumberOfDaysInWeek));
    case CalendarView.day:
    case CalendarView.timelineDay:
    case CalendarView.schedule:
      return addDuration(date, const Duration(days: 1));
  }

  return date;
}

//// Calculate the previous view visible start date based on calendar view.
DateTime _getPreviousViewStartDate(
    CalendarView calendarView, int numberOfWeeksInView, DateTime date) {
  if (calendarView == null) {
    return date;
  }

  switch (calendarView) {
    case CalendarView.month:
    case CalendarView.timelineMonth:
      {
        return numberOfWeeksInView == 6 ||
                calendarView == CalendarView.timelineMonth
            ? getPreviousMonthDate(date)
            : addDuration(date,
                Duration(days: -numberOfWeeksInView * _kNumberOfDaysInWeek));
      }
    case CalendarView.timelineWeek:
    case CalendarView.timelineWorkWeek:
    case CalendarView.week:
    case CalendarView.workWeek:
      return addDuration(date, const Duration(days: -_kNumberOfDaysInWeek));
    case CalendarView.day:
    case CalendarView.timelineDay:
    case CalendarView.schedule:
      return addDuration(date, const Duration(days: -1));
  }

  return date;
}

DateTime _getPreviousValidDate(
    DateTime prevViewDate, List<int> nonWorkingDays) {
  DateTime previousDate =
      subtractDuration(prevViewDate, const Duration(days: 1));
  while (nonWorkingDays.contains(previousDate.weekday)) {
    previousDate = subtractDuration(previousDate, const Duration(days: 1));
  }
  return previousDate;
}

DateTime _getNextValidDate(DateTime nextDate, List<int> nonWorkingDays) {
  DateTime nextViewDate = addDuration(nextDate, const Duration(days: 1));
  while (nonWorkingDays.contains(nextViewDate.weekday)) {
    nextViewDate = addDuration(nextViewDate, const Duration(days: 1));
  }
  return nextViewDate;
}

int _getIndex(List<DateTime> dates, DateTime date) {
  if (date.isBefore(dates[0])) {
    return 0;
  }

  final int datesCount = dates.length;
  if (date.isAfter(dates[datesCount - 1])) {
    return datesCount - 1;
  }

  for (int i = 0; i < datesCount; i++) {
    final DateTime visibleDate = dates[i];
    if (isSameOrBeforeDate(visibleDate, date)) {
      return i;
    }
  }

  return -1;
}

/// Get the exact visible date index for date, if the date collection
/// does not contains the date value then it return -1 value.
int _getVisibleDateIndex(List<DateTime> dates, DateTime date) {
  if (!isDateWithInDateRange(dates[0], dates[dates.length - 1], date)) {
    return -1;
  }

  for (int i = 0; i < dates.length; i++) {
    final DateTime visibleDate = dates[i];
    if (isSameDate(visibleDate, date)) {
      return i;
    }
  }

  return -1;
}

bool _canMoveToPreviousView(CalendarView calendarView, int numberOfWeeksInView,
    DateTime minDate, DateTime maxDate, List<DateTime> visibleDates,
    [List<int> nonWorkingDays, bool isRTL = false]) {
  if (isRTL) {
    return _canMoveToNextView(calendarView, numberOfWeeksInView, minDate,
        maxDate, visibleDates, nonWorkingDays);
  }

  switch (calendarView) {
    case CalendarView.month:
    case CalendarView.timelineMonth:
      {
        if (numberOfWeeksInView != 6 ||
            calendarView == CalendarView.timelineMonth) {
          final DateTime prevViewDate =
              subtractDuration(visibleDates[0], const Duration(days: 1));
          if (!isSameOrAfterDate(minDate, prevViewDate)) {
            return false;
          }
        } else {
          final DateTime currentDate = visibleDates[visibleDates.length ~/ 2];
          final DateTime previousDate = getPreviousMonthDate(currentDate);
          if ((previousDate.month < minDate.month &&
                  previousDate.year == minDate.year) ||
              previousDate.year < minDate.year) {
            return false;
          }
        }
      }
      break;
    case CalendarView.day:
    case CalendarView.week:
    case CalendarView.timelineDay:
    case CalendarView.timelineWeek:
      {
        DateTime prevViewDate = visibleDates[0];
        prevViewDate = subtractDuration(prevViewDate, const Duration(days: 1));
        if (!isSameOrAfterDate(minDate, prevViewDate)) {
          return false;
        }
      }
      break;
    case CalendarView.timelineWorkWeek:
    case CalendarView.workWeek:
      {
        final DateTime previousDate =
            _getPreviousValidDate(visibleDates[0], nonWorkingDays);
        if (!isSameOrAfterDate(minDate, previousDate)) {
          return false;
        }
      }
      break;
    case CalendarView.schedule:
      return true;
  }

  return true;
}

bool _canMoveToNextView(CalendarView calendarView, int numberOfWeeksInView,
    DateTime minDate, DateTime maxDate, List<DateTime> visibleDates,
    [List<int> nonWorkingDays, bool isRTL = false]) {
  if (isRTL) {
    return _canMoveToPreviousView(calendarView, numberOfWeeksInView, minDate,
        maxDate, visibleDates, nonWorkingDays);
  }

  switch (calendarView) {
    case CalendarView.month:
    case CalendarView.timelineMonth:
      {
        if (numberOfWeeksInView != 6 ||
            calendarView == CalendarView.timelineMonth) {
          final DateTime nextViewDate = addDuration(
              visibleDates[visibleDates.length - 1], const Duration(days: 1));
          if (!isSameOrBeforeDate(maxDate, nextViewDate)) {
            return false;
          }
        } else {
          final DateTime currentDate = visibleDates[visibleDates.length ~/ 2];
          final DateTime nextDate = getNextMonthDate(currentDate);
          if ((nextDate.month > maxDate.month &&
                  nextDate.year == maxDate.year) ||
              nextDate.year > maxDate.year) {
            return false;
          }
        }
      }
      break;
    case CalendarView.day:
    case CalendarView.week:
    case CalendarView.timelineDay:
    case CalendarView.timelineWeek:
      {
        final DateTime nextViewDate = addDuration(
            visibleDates[visibleDates.length - 1], const Duration(days: 1));
        if (!isSameOrBeforeDate(maxDate, nextViewDate)) {
          return false;
        }
      }
      break;
    case CalendarView.workWeek:
    case CalendarView.timelineWorkWeek:
      {
        final DateTime nextDate = _getNextValidDate(
            visibleDates[visibleDates.length - 1], nonWorkingDays);
        if (!isSameOrBeforeDate(maxDate, nextDate)) {
          return false;
        }
      }
      break;
    case CalendarView.schedule:
      return true;
  }

  return true;
}
