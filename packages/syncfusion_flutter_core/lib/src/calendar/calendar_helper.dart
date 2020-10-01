part of core;

/// Add the date value with duration without daylight saving value
///
/// eg., if local time zone as British Summer Time, and its
/// daylight saving enabled on 29 March, 2020 to 25 October, 2020.
/// add one day to the date(Oct 25, 2020) using add() method in [DateTime],
/// it return Oct 25, 2020 23.00.00 instead of Oct 26, 2020 because this method
/// consider location and daylight saving.
///
/// So check whether the current date time zone offset(+1) is equal to
/// previous date time zone offset(+2). if both are not equal then calculate
/// the difference (date.timeZoneOffset - currentDate.timeZoneOffset)
/// and add the offset difference(2-1) to current date.
DateTime addDuration(DateTime date, Duration duration) {
  DateTime currentDate = date.add(duration);
  if (date.timeZoneOffset != currentDate.timeZoneOffset) {
    currentDate =
        currentDate.add(date.timeZoneOffset - currentDate.timeZoneOffset);
  }

  return currentDate;
}

/// Subtract the date value with duration without daylight saving value
///
/// eg., if local time zone as British Summer Time, and its daylight saving
/// enabled on 29 March, 2020 to 25 October, 2020.
/// subtract one day to the date(Oct 26, 2020) using subtract() method in
/// [DateTime], it return Oct 25, 2020 1.00.00 instead of Oct 25, 2020 00.00.00
/// because this method consider location
/// and daylight saving.
///
/// So check whether the current date time zone offset(+2) is equal to
/// previous date time zone offset(+1). if both are not equal then calculate
/// the difference date.timeZoneOffset - currentDate.timeZoneOffset) and add
/// the offset difference(1-2) to current date.
DateTime subtractDuration(DateTime date, Duration duration) {
  DateTime currentDate = date.subtract(duration);
  if (date.timeZoneOffset != currentDate.timeZoneOffset) {
    currentDate =
        currentDate.add(date.timeZoneOffset - currentDate.timeZoneOffset);
  }

  return currentDate;
}

/// Returns the previous month start date for the given date.
DateTime getPreviousMonthDate(DateTime date) {
  return date.month == 1
      ? DateTime(date.year - 1, 12, 1)
      : DateTime(date.year, date.month - 1, 1);
}

/// Returns the next month start date for the given date..
DateTime getNextMonthDate(DateTime date) {
  return date.month == 12
      ? DateTime(date.year + 1, 1, 1)
      : DateTime(date.year, date.month + 1, 1);
}

/// Return the given date if the date in between first and last date
/// else return first date/last date when the date before of first date or after
/// last date
DateTime getValidDate(DateTime minDate, DateTime maxDate, DateTime date) {
  if (date.isAfter(minDate)) {
    if (date.isBefore(maxDate)) {
      return date;
    } else {
      return maxDate;
    }
  } else {
    return minDate;
  }
}

/// Check the dates are equal or not.
bool isSameDate(DateTime date1, DateTime date2) {
  if (date2 == date1) {
    return true;
  }

  if (date1 == null || date2 == null) {
    return false;
  }

  return date1.month == date2.month &&
      date1.year == date2.year &&
      date1.day == date2.day;
}

/// Check the date in between first and last date
bool isDateWithInDateRange(
    DateTime startDate, DateTime endDate, DateTime date) {
  if (startDate == null || endDate == null || date == null) {
    return false;
  }

  if (startDate.isAfter(endDate)) {
    final DateTime temp = startDate;
    startDate = endDate;
    endDate = temp;
  }

  if (isSameOrBeforeDate(endDate, date) && isSameOrAfterDate(startDate, date)) {
    return true;
  }

  return false;
}

/// Check the date before/same of last date
bool isSameOrBeforeDate(DateTime lastDate, DateTime date) {
  return isSameDate(lastDate, date) || lastDate.isAfter(date);
}

/// Check the date after/same of first date
bool isSameOrAfterDate(DateTime firstDate, DateTime date) {
  return isSameDate(firstDate, date) || firstDate.isBefore(date);
}

/// Get the visible dates based on the date value and visible dates count.
List<DateTime> getVisibleDates(DateTime date, List<int> nonWorkingDays,
    int firstDayOfWeek, int visibleDatesCount) {
  final List<DateTime> datesCollection = <DateTime>[];
  DateTime currentDate = date;
  if (firstDayOfWeek != null) {
    currentDate =
        getFirstDayOfWeekDate(visibleDatesCount, date, firstDayOfWeek);
  }

  for (int i = 0; i < visibleDatesCount; i++) {
    final DateTime visibleDate = addDuration(currentDate, Duration(days: i));
    if (nonWorkingDays != null &&
        nonWorkingDays.contains(visibleDate.weekday)) {
      continue;
    }

    datesCollection.add(visibleDate);
  }

  return datesCollection;
}

/// Calculate first day of week date value based original date with first day of
/// week value.
DateTime getFirstDayOfWeekDate(
    int visibleDatesCount, DateTime date, int firstDayOfWeek) {
  if (visibleDatesCount % 7 != 0) {
    return date;
  }

  const int numberOfWeekDays = 7;
  DateTime currentDate = date;
  if (visibleDatesCount == 42) {
    currentDate = DateTime(currentDate.year, currentDate.month, 1);
  }

  int value = -currentDate.weekday + firstDayOfWeek - numberOfWeekDays;
  if (value.abs() >= numberOfWeekDays) {
    value += numberOfWeekDays;
  }

  currentDate = addDuration(currentDate, Duration(days: value));
  return currentDate;
}
