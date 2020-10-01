part of datepicker;

//// Calculate the visible dates count based on picker view
int _getViewDatesCount(DateRangePickerView pickerView, int numberOfWeeks) {
  if (pickerView == null) {
    return 0;
  }

  if (pickerView == DateRangePickerView.month) {
    return _kNumberOfDaysInWeek * numberOfWeeks;
  }

  return 0;
}

bool _isRangeEquals(PickerDateRange range1, PickerDateRange range2) {
  if ((range1 == null && range2 != null) ||
      (range2 == null && range1 != null)) {
    return false;
  }

  if (range1 == range2 ||
      (isSameDate(range1.startDate, range2.startDate) &&
          isSameDate(range1.endDate, range2.endDate))) {
    return true;
  }

  return false;
}

bool _isDateRangesEquals(List<PickerDateRange> rangeCollection1,
    List<PickerDateRange> rangeCollection2) {
  if (rangeCollection1 == rangeCollection2) {
    return true;
  }

  if ((rangeCollection1 == null &&
          rangeCollection2 != null &&
          rangeCollection2.isEmpty) ||
      (rangeCollection2 == null &&
          rangeCollection1 != null &&
          rangeCollection1.isEmpty)) {
    return true;
  }

  if ((rangeCollection1 == null && rangeCollection2 != null) ||
      (rangeCollection2 == null && rangeCollection1 != null) ||
      (rangeCollection1.length != rangeCollection2.length)) {
    return false;
  }

  for (int i = 0; i < rangeCollection1.length; i++) {
    if (!_isRangeEquals(rangeCollection1[i], rangeCollection2[i])) {
      return false;
    }
  }

  return true;
}

//// Calculate the next view visible start date based on picker view.
DateTime _getNextViewStartDate(DateRangePickerView pickerView,
    int numberOfWeeksInView, DateTime date, bool isRtl) {
  if (pickerView == null) {
    return date;
  }

  if (isRtl != null && isRtl) {
    return _getPreviousViewStartDate(
        pickerView, numberOfWeeksInView, date, false);
  }

  switch (pickerView) {
    case DateRangePickerView.month:
      {
        return numberOfWeeksInView == 6
            ? getNextMonthDate(date)
            : addDuration(date,
                Duration(days: numberOfWeeksInView * _kNumberOfDaysInWeek));
      }
    case DateRangePickerView.year:
      {
        return _getNextYearDate(date, 1);
      }
    case DateRangePickerView.decade:
      {
        return _getNextYearDate(date, 10);
      }
    case DateRangePickerView.century:
      {
        return _getNextYearDate(date, 100);
      }
  }

  return date;
}

//// Calculate the previous view visible start date based on calendar view.
DateTime _getPreviousViewStartDate(DateRangePickerView pickerView,
    int numberOfWeeksInView, DateTime date, bool isRtl) {
  if (pickerView == null) {
    return date;
  }

  if (isRtl != null && isRtl) {
    return _getNextViewStartDate(pickerView, numberOfWeeksInView, date, false);
  }

  switch (pickerView) {
    case DateRangePickerView.month:
      {
        return numberOfWeeksInView == 6
            ? getPreviousMonthDate(date)
            : addDuration(date,
                Duration(days: -numberOfWeeksInView * _kNumberOfDaysInWeek));
      }
    case DateRangePickerView.year:
      {
        return _getPreviousYearDate(date, 1);
      }
    case DateRangePickerView.decade:
      {
        return _getPreviousYearDate(date, 10);
      }
    case DateRangePickerView.century:
      {
        return _getPreviousYearDate(date, 100);
      }
  }

  return date;
}

DateTime _getNextYearDate(DateTime date, int offset) {
  return DateTime(((date.year ~/ offset) * offset) + offset, 1, 1);
}

DateTime _getPreviousYearDate(DateTime date, int offset) {
  return DateTime(((date.year ~/ offset) * offset) - offset, 1, 1);
}

DateTime _getMonthStartDate(DateTime date) {
  return DateTime(date.year, date.month, 1);
}

DateTime _getMonthEndDate(DateTime date) {
  return subtractDuration(getNextMonthDate(date), const Duration(days: 1));
}

int _isDateIndexInCollection(List<DateTime> dates, DateTime date) {
  if (dates == null || date == null) {
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

bool _isDateCollectionEquals(
    List<DateTime> datesCollection1, List<DateTime> datesCollection2) {
  if (datesCollection1 == datesCollection2) {
    return true;
  }

  if ((datesCollection1 == null &&
          datesCollection2 != null &&
          datesCollection2.isEmpty) ||
      (datesCollection2 == null &&
          datesCollection1 != null &&
          datesCollection1.isEmpty)) {
    return false;
  }

  if ((datesCollection1 == null && datesCollection2 != null) ||
      (datesCollection2 == null && datesCollection1 != null) ||
      (datesCollection1.length != datesCollection2.length)) {
    return false;
  }

  for (int i = 0; i < datesCollection1.length; i++) {
    if (!isSameDate(datesCollection1[i], datesCollection2[i])) {
      return false;
    }
  }

  return true;
}

bool _isEnabledDate(
    DateTime startDate, DateTime endDate, bool enablePastDates, DateTime date) {
  return isDateWithInDateRange(startDate, endDate, date) &&
      (enablePastDates ||
          (!enablePastDates &&
              isDateWithInDateRange(DateTime.now(), endDate, date)));
}

bool _isDateAsCurrentMonthDate(DateTime visibleDate, int rowCount,
    bool showLeadingAndTrialingDates, DateTime date) {
  if (rowCount == 6 &&
      !showLeadingAndTrialingDates &&
      date.month != visibleDate.month) {
    return false;
  }

  return true;
}

Map<String, double> _getTopAndLeftValues(bool isRtl, double left, double top,
    double cellWidth, double cellHeight, double width) {
  final Map<String, double> topAndLeft = <String, double>{
    'left': left,
    'top': top
  };
  if (isRtl) {
    if (left.round() == cellWidth.round()) {
      left = 0;
    } else {
      left -= cellWidth;
    }
    if (left < 0) {
      left = width - cellWidth;
      top += cellHeight;
    }
  } else {
    left += cellWidth;
    if (left + 1 >= width) {
      top += cellHeight;
      left = 0;
    }
  }
  topAndLeft['left'] = left;
  topAndLeft['top'] = top;

  return topAndLeft;
}

bool _isDateWithInVisibleDates(
    List<DateTime> visibleDates, List<DateTime> dates, DateTime date) {
  if (dates == null || dates.isEmpty) {
    return false;
  }

  final DateTime visibleStartDate = visibleDates[0];
  final DateTime visibleEndDate = visibleDates[visibleDates.length - 1];
  for (final DateTime currentDate in dates) {
    if (!isDateWithInDateRange(visibleStartDate, visibleEndDate, currentDate)) {
      continue;
    }

    if (isSameDate(currentDate, date)) {
      return true;
    }
  }

  return false;
}

bool _isWeekend(List<int> weekendIndex, DateTime date) {
  if (weekendIndex == null || weekendIndex.isEmpty) {
    return false;
  }

  return weekendIndex.contains(date.weekday);
}

bool _canMoveToPreviousViewRtl(
    DateRangePickerView view,
    int numberOfWeeksInView,
    DateTime minDate,
    DateTime maxDate,
    List<DateTime> visibleDates,
    bool isRtl,
    bool enableMultiView) {
  if (isRtl) {
    return _canMoveToNextView(
        view, numberOfWeeksInView, maxDate, visibleDates, enableMultiView);
  } else {
    return _canMoveToPreviousView(
        view, numberOfWeeksInView, minDate, visibleDates, enableMultiView);
  }
}

bool _canMoveToNextViewRtl(
    DateRangePickerView view,
    int numberOfWeeksInView,
    DateTime minDate,
    DateTime maxDate,
    List<DateTime> visibleDates,
    bool isRtl,
    bool enableMultiView) {
  if (isRtl) {
    return _canMoveToPreviousView(
        view, numberOfWeeksInView, minDate, visibleDates, enableMultiView);
  } else {
    return _canMoveToNextView(
        view, numberOfWeeksInView, maxDate, visibleDates, enableMultiView);
  }
}

bool _canMoveToPreviousView(DateRangePickerView view, int numberOfWeeksInView,
    DateTime minDate, List<DateTime> visibleDates, bool enableMultiView) {
  switch (view) {
    case DateRangePickerView.month:
      {
        if (numberOfWeeksInView != 6) {
          DateTime prevViewDate = visibleDates[0];
          prevViewDate =
              subtractDuration(prevViewDate, const Duration(days: 1));
          if (!isSameOrAfterDate(minDate, prevViewDate)) {
            return false;
          }
        } else {
          final DateTime currentDate = visibleDates[visibleDates.length ~/
              (enableMultiView != null && enableMultiView ? 4 : 2)];
          final DateTime previousDate = getPreviousMonthDate(currentDate);
          if ((previousDate.month < minDate.month &&
                  previousDate.year == minDate.year) ||
              previousDate.year < minDate.year) {
            return false;
          }
        }
      }
      break;
    case DateRangePickerView.year:
    case DateRangePickerView.decade:
    case DateRangePickerView.century:
      {
        final int currentYear = visibleDates[visibleDates.length ~/
                (enableMultiView != null && enableMultiView ? 4 : 2)]
            .year;
        final int offset = _getOffset(view);
        if (((currentYear ~/ offset) * offset) - offset <
            ((minDate.year ~/ offset) * offset)) {
          return false;
        }
      }
  }

  return true;
}

int _getOffset(DateRangePickerView view) {
  switch (view) {
    case DateRangePickerView.month:
      break;
    case DateRangePickerView.year:
      return 1;
    case DateRangePickerView.decade:
      return 10;
    case DateRangePickerView.century:
      return 100;
  }
  return 0;
}

//// Get the visible dates based on the date value and visible dates count.
List<DateTime> _getVisibleYearDates(DateTime date, DateRangePickerView view) {
  final List<DateTime> datesCollection = <DateTime>[];
  DateTime currentDate;
  const int daysCount = 12;
  switch (view) {
    case DateRangePickerView.month:
      break;
    case DateRangePickerView.year:
      {
        for (int i = 1; i <= daysCount; i++) {
          currentDate = DateTime(date.year, i, 1);
          datesCollection.add(currentDate);
        }
      }
      break;
    case DateRangePickerView.decade:
      {
        final int year = (date.year ~/ 10) * 10;
        for (int i = 0; i < daysCount; i++) {
          currentDate = DateTime(year + i, 1, 1);
          datesCollection.add(currentDate);
        }
      }
      break;
    case DateRangePickerView.century:
      {
        final int year = (date.year ~/ 100) * 100;
        for (int i = 0; i < daysCount; i++) {
          currentDate = DateTime(year + (i * 10), 1, 1);
          datesCollection.add(currentDate);
        }
      }
  }

  return datesCollection;
}

bool _canMoveToNextView(DateRangePickerView view, int numberOfWeeksInView,
    DateTime maxDate, List<DateTime> visibleDates, bool enableMultiView) {
  switch (view) {
    case DateRangePickerView.month:
      {
        if (numberOfWeeksInView != 6) {
          DateTime nextViewDate = visibleDates[visibleDates.length - 1];
          nextViewDate = addDuration(nextViewDate, const Duration(days: 1));
          if (!isSameOrBeforeDate(maxDate, nextViewDate)) {
            return false;
          }
        } else {
          final DateTime currentDate = visibleDates[visibleDates.length ~/
              (enableMultiView != null && enableMultiView ? 4 : 2)];
          final DateTime nextDate = getNextMonthDate(currentDate);
          if ((nextDate.month > maxDate.month &&
                  nextDate.year == maxDate.year) ||
              nextDate.year > maxDate.year) {
            return false;
          }
        }
      }
      break;
    case DateRangePickerView.year:
    case DateRangePickerView.decade:
    case DateRangePickerView.century:
      {
        final int currentYear = visibleDates[visibleDates.length ~/
                (enableMultiView != null && enableMultiView ? 4 : 2)]
            .year;
        final int offset = _getOffset(view);

        if (((currentYear ~/ offset) * offset) + offset >
            ((maxDate.year ~/ offset) * offset)) {
          return false;
        }
      }
  }
  return true;
}
