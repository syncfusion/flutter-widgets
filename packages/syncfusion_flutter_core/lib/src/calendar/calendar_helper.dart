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
dynamic addDuration(dynamic date, Duration duration) {
  dynamic currentDate = date.add(duration);
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
dynamic subtractDuration(dynamic date, Duration duration) {
  dynamic currentDate = date.subtract(duration);
  if (date.timeZoneOffset != currentDate.timeZoneOffset) {
    currentDate =
        currentDate.add(date.timeZoneOffset - currentDate.timeZoneOffset);
  }

  return currentDate;
}

/// Returns the previous month start date for the given date.
dynamic getPreviousMonthDate(dynamic date) {
  if (date is HijriDateTime) {
    return date.month == 1
        ? HijriDateTime(date.year - 1, 12, 01)
        : HijriDateTime(date.year, date.month - 1, 1);
  }
  return date.month == 1
      ? DateTime(date.year - 1, 12, 1)
      : DateTime(date.year, date.month - 1, 1);
}

/// Returns the next month start date for the given date..
dynamic getNextMonthDate(dynamic date) {
  if (date is HijriDateTime) {
    return date.month == 12
        ? HijriDateTime(date.year + 1, 01, 01)
        : HijriDateTime(date.year, date.month + 1, 1);
  }
  return date.month == 12
      ? DateTime(date.year + 1, 1, 1)
      : DateTime(date.year, date.month + 1, 1);
}

/// Return the given date if the date in between first and last date
/// else return first date/last date when the date before of first date or after
/// last date
dynamic getValidDate(dynamic minDate, dynamic maxDate, dynamic date) {
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
bool isSameDate(dynamic date1, dynamic date2) {
  if (date2 == date1) {
    return true;
  }

  if (date1 == null || date2 == null) {
    return false;
  }

  if (date1 is HijriDateTime && date2 is HijriDateTime) {
    return date1.month == date2.month &&
        date1.year == date2.year &&
        date1.day == date2.day &&
        date1._date == date2._date;
  }

  return date1.month == date2.month &&
      date1.year == date2.year &&
      date1.day == date2.day;
}

/// Check the date in between first and last date
bool isDateWithInDateRange(dynamic startDate, dynamic endDate, dynamic date) {
  if (startDate == null || endDate == null || date == null) {
    return false;
  }

  if (startDate.isAfter(endDate)) {
    final dynamic temp = startDate;
    startDate = endDate;
    endDate = temp;
  }

  if (isSameOrBeforeDate(endDate, date) && isSameOrAfterDate(startDate, date)) {
    return true;
  }

  return false;
}

/// Check the date before/same of last date
bool isSameOrBeforeDate(dynamic lastDate, dynamic date) {
  return isSameDate(lastDate, date) || lastDate.isAfter(date);
}

/// Check the date after/same of first date
bool isSameOrAfterDate(dynamic firstDate, dynamic date) {
  return isSameDate(firstDate, date) || firstDate.isBefore(date);
}

/// Get the visible dates based on the date value and visible dates count.
List getVisibleDates(dynamic date, List<int>? nonWorkingDays,
    int firstDayOfWeek, int visibleDatesCount) {
  List datesCollection;
  if (date is HijriDateTime) {
    datesCollection = <HijriDateTime>[];
  } else {
    datesCollection = <DateTime>[];
  }

  final dynamic currentDate =
      getFirstDayOfWeekDate(visibleDatesCount, date, firstDayOfWeek);

  for (int i = 0; i < visibleDatesCount; i++) {
    final dynamic visibleDate = addDays(currentDate, i);
    if (nonWorkingDays != null &&
        nonWorkingDays.contains(visibleDate.weekday)) {
      continue;
    }

    datesCollection.add(visibleDate);
  }

  return datesCollection;
}

/// Return date value without hour and minutes consideration.
dynamic addDays(dynamic date, int days) {
  if (date is HijriDateTime) {
    return date.add(Duration(days: days));
  }

  return DateTime(date.year, date.month, date.day + days);
}

/// Calculate first day of week date value based original date with first day of
/// week value.
dynamic getFirstDayOfWeekDate(
    int visibleDatesCount, dynamic date, int firstDayOfWeek) {
  if (visibleDatesCount % 7 != 0) {
    return date;
  }

  const int numberOfWeekDays = 7;
  dynamic currentDate = date;
  if (visibleDatesCount == 42) {
    if (currentDate is HijriDateTime) {
      currentDate = HijriDateTime(currentDate.year, currentDate.month, 1);
    } else {
      currentDate = DateTime(currentDate.year, currentDate.month, 1);
    }
  }

  int value = -currentDate.weekday + firstDayOfWeek - numberOfWeekDays;
  if (value.abs() >= numberOfWeekDays) {
    value += numberOfWeekDays;
  }

  currentDate = addDays(currentDate, value);
  return currentDate;
}
