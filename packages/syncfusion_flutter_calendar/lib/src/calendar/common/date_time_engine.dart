import 'package:syncfusion_flutter_core/core.dart';
import '../appointment_engine/appointment_helper.dart';
import 'enums.dart';

// ignore: avoid_classes_with_only_static_members
/// Holds the static helper methods used for date calculation in calendar.
class DateTimeHelper {
  /// Calculate the visible dates count based on calendar view
  static int getViewDatesCount(CalendarView calendarView, int numberOfWeeks,
      int daysCount, List<int>? nonWorkingDays) {
    switch (calendarView) {
      case CalendarView.month:
        return DateTime.daysPerWeek * numberOfWeeks;
      case CalendarView.week:
      case CalendarView.timelineWeek:
        return (daysCount >= 1 && daysCount <= 7)
            ? daysCount
            : DateTime.daysPerWeek;
      case CalendarView.workWeek:
      case CalendarView.timelineWorkWeek:
        return (daysCount >= 1 && daysCount <= 7)
            ? daysCount
            : DateTime.daysPerWeek - nonWorkingDays!.length;
      case CalendarView.timelineDay:
      case CalendarView.day:
        return (daysCount >= 1 && daysCount <= 7) ? daysCount : 1;
      case CalendarView.schedule:
        return 1;
      case CalendarView.timelineMonth:

        /// 6 represents the number of weeks in view, we have used this static,
        /// since timeline month doesn't support the number of weeks in view.
        return DateTime.daysPerWeek * 6;
    }
  }

  /// Returns the list of current month dates alone from the dates passed.
  static List<DateTime> getCurrentMonthDates(List<DateTime> visibleDates) {
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

  /// Calculate the next view visible start date based on calendar view.
  static DateTime getNextViewStartDate(
      CalendarView calendarView,
      int numberOfWeeksInView,
      DateTime date,
      int visibleDatesCount,
      List<int>? nonWorkingDays) {
    switch (calendarView) {
      case CalendarView.month:
        {
          return numberOfWeeksInView == 6
              ? DateTimeHelper.getDateTimeValue(getNextMonthDate(date))
              : DateTimeHelper.getDateTimeValue(
                  addDays(date, numberOfWeeksInView * DateTime.daysPerWeek));
        }
      case CalendarView.timelineMonth:
        return DateTimeHelper.getDateTimeValue(getNextMonthDate(date));
      case CalendarView.week:
      case CalendarView.timelineWeek:
        return DateTimeHelper.getDateTimeValue(
            addDays(date, visibleDatesCount));
      case CalendarView.workWeek:
      case CalendarView.timelineWorkWeek:
        {
          final int nonWorkingDaysCount =
              nonWorkingDays == null ? 0 : nonWorkingDays.length;
          if (visibleDatesCount + nonWorkingDaysCount == 7) {
            return DateTimeHelper.getDateTimeValue(
                addDays(date, visibleDatesCount + nonWorkingDaysCount));
          }

          for (int i = 0; i <= visibleDatesCount; i++) {
            final dynamic currentDate = addDays(date, i);
            if (nonWorkingDays != null &&
                nonWorkingDays.contains(currentDate.weekday)) {
              visibleDatesCount++;
            }
          }
          return DateTimeHelper.getDateTimeValue(
              addDays(date, visibleDatesCount));
        }
      case CalendarView.day:
      case CalendarView.timelineDay:
        return DateTimeHelper.getDateTimeValue(
            addDays(date, visibleDatesCount));
      case CalendarView.schedule:
        return DateTimeHelper.getDateTimeValue(addDays(date, 1));
    }
  }

  /// Calculate the previous view visible start date based on calendar view.
  static DateTime getPreviousViewStartDate(
      CalendarView calendarView,
      int numberOfWeeksInView,
      DateTime date,
      int visibleDatesCount,
      List<int>? nonWorkingDays) {
    switch (calendarView) {
      case CalendarView.month:
        {
          return numberOfWeeksInView == 6
              ? DateTimeHelper.getDateTimeValue(getPreviousMonthDate(date))
              : DateTimeHelper.getDateTimeValue(
                  addDays(date, -numberOfWeeksInView * DateTime.daysPerWeek));
        }
      case CalendarView.timelineMonth:
        return DateTimeHelper.getDateTimeValue(getPreviousMonthDate(date));
      case CalendarView.week:
      case CalendarView.timelineWeek:
        return DateTimeHelper.getDateTimeValue(
            addDays(date, -visibleDatesCount));
      case CalendarView.workWeek:
      case CalendarView.timelineWorkWeek:
        {
          final int nonWorkingDaysCount =
              nonWorkingDays == null ? 0 : nonWorkingDays.length;
          if (visibleDatesCount + nonWorkingDaysCount == 7) {
            return DateTimeHelper.getDateTimeValue(
                addDays(date, -visibleDatesCount - nonWorkingDaysCount));
          }
          for (int i = 1; i <= visibleDatesCount; i++) {
            final dynamic currentDate = addDays(date, -i);
            if (nonWorkingDays != null &&
                nonWorkingDays.contains(currentDate.weekday)) {
              visibleDatesCount++;
            }
          }
          return DateTimeHelper.getDateTimeValue(
              addDays(date, -visibleDatesCount));
        }
      case CalendarView.day:
      case CalendarView.timelineDay:
        return DateTimeHelper.getDateTimeValue(
            addDays(date, -visibleDatesCount));
      case CalendarView.schedule:
        return DateTimeHelper.getDateTimeValue(addDays(date, -1));
    }
  }

  static DateTime _getPreviousValidDate(
      DateTime prevViewDate, List<int> nonWorkingDays) {
    DateTime previousDate =
        DateTimeHelper.getDateTimeValue(addDays(prevViewDate, -1));
    while (nonWorkingDays.contains(previousDate.weekday)) {
      previousDate = DateTimeHelper.getDateTimeValue(addDays(previousDate, -1));
    }
    return previousDate;
  }

  static DateTime _getNextValidDate(
      DateTime nextDate, List<int> nonWorkingDays) {
    DateTime nextViewDate =
        DateTimeHelper.getDateTimeValue(addDays(nextDate, 1));
    while (nonWorkingDays.contains(nextViewDate.weekday)) {
      nextViewDate = DateTimeHelper.getDateTimeValue(addDays(nextViewDate, 1));
    }
    return nextViewDate;
  }

  /// Return index value of the date in dates collection.
  /// if the date in between the dates collection but dates collection does not
  /// have a date value then it return next date index.
  /// Eg., If the dates collection have Jan 4, Jan 5, Jan 7, Jan 8 and Jan 9,
  /// and the date value as Jan 6 then it return index as 2(Jan 7).
  static int getIndex(List<DateTime> dates, DateTime date) {
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
  static int getVisibleDateIndex(List<DateTime> dates, DateTime date) {
    final int count = dates.length;
    if (!isDateWithInDateRange(dates[0], dates[count - 1], date)) {
      return -1;
    }

    for (int i = 0; i < count; i++) {
      if (isSameDate(dates[i], date)) {
        return i;
      }
    }

    return -1;
  }

  /// Check the current calendar view is valid for move to previous view or not.
  static bool canMoveToPreviousView(
      CalendarView calendarView,
      int numberOfWeeksInView,
      DateTime minDate,
      DateTime maxDate,
      List<DateTime> visibleDates,
      List<int> nonWorkingDays,
      [bool isRTL = false]) {
    if (isRTL) {
      return canMoveToNextView(calendarView, numberOfWeeksInView, minDate,
          maxDate, visibleDates, nonWorkingDays);
    }

    switch (calendarView) {
      case CalendarView.month:
        {
          if (numberOfWeeksInView != 6) {
            final DateTime prevViewDate =
                DateTimeHelper.getDateTimeValue(addDays(visibleDates[0], -1));
            if (!isSameOrAfterDate(minDate, prevViewDate)) {
              return false;
            }
          } else {
            final DateTime currentDate = visibleDates[visibleDates.length ~/ 2];
            final DateTime previousDate = DateTimeHelper.getDateTimeValue(
                getPreviousMonthDate(currentDate));
            if ((previousDate.month < minDate.month &&
                    previousDate.year == minDate.year) ||
                previousDate.year < minDate.year) {
              return false;
            }
          }
        }
        break;
      case CalendarView.timelineMonth:
        {
          final DateTime prevViewDate =
              DateTimeHelper.getDateTimeValue(addDays(visibleDates[0], -1));
          if (!isSameOrAfterDate(minDate, prevViewDate)) {
            return false;
          }
        }
        break;
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
        {
          DateTime prevViewDate = visibleDates[0];
          prevViewDate =
              DateTimeHelper.getDateTimeValue(addDays(prevViewDate, -1));
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

  /// Check the current calendar view is valid for move to next view or not.
  static bool canMoveToNextView(
      CalendarView calendarView,
      int numberOfWeeksInView,
      DateTime minDate,
      DateTime maxDate,
      List<DateTime> visibleDates,
      List<int> nonWorkingDays,
      [bool isRTL = false]) {
    if (isRTL) {
      return canMoveToPreviousView(calendarView, numberOfWeeksInView, minDate,
          maxDate, visibleDates, nonWorkingDays);
    }

    switch (calendarView) {
      case CalendarView.month:
        {
          if (numberOfWeeksInView != 6) {
            final DateTime nextViewDate = DateTimeHelper.getDateTimeValue(
                addDays(visibleDates[visibleDates.length - 1], 1));
            if (!isSameOrBeforeDate(maxDate, nextViewDate)) {
              return false;
            }
          } else {
            final DateTime currentDate = visibleDates[visibleDates.length ~/ 2];
            final DateTime nextDate =
                DateTimeHelper.getDateTimeValue(getNextMonthDate(currentDate));
            if ((nextDate.month > maxDate.month &&
                    nextDate.year == maxDate.year) ||
                nextDate.year > maxDate.year) {
              return false;
            }
          }
        }
        break;
      case CalendarView.timelineMonth:
        {
          final DateTime nextViewDate = DateTimeHelper.getDateTimeValue(
              addDays(visibleDates[visibleDates.length - 1], 1));
          if (!isSameOrBeforeDate(maxDate, nextViewDate)) {
            return false;
          }
        }
        break;
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
        {
          final DateTime nextViewDate = DateTimeHelper.getDateTimeValue(
              addDays(visibleDates[visibleDates.length - 1], 1));
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

  /// Converts the given dynamic data into date time data.
  static DateTime getDateTimeValue(dynamic date) {
    late final DateTime dateTimeData;
    if (date is DateTime) {
      dateTimeData = date;
    }

    return dateTimeData;
  }

  /// Returns week number for the given date.
  static int getWeekNumberOfYear(DateTime date) {
    final DateTime yearEndDate = DateTime(date.year - 1, 12, 31);
    final int dayOfYear =
        AppointmentHelper.getDifference(yearEndDate, date).inDays;
    int weekNumber = (dayOfYear - date.weekday + 10) ~/ 7;
    if (weekNumber < 1) {
      weekNumber = getWeeksInYear(date.year - 1);
    } else if (weekNumber > getWeeksInYear(date.year)) {
      weekNumber = 1;
    }
    return weekNumber;
  }

  /// Get the weeks in year
  static int getWeeksInYear(int year) {
    int P(int y) => (y + (y ~/ 4) - (y ~/ 100) + (y ~/ 400)) % 7;
    if (P(year) == 4 || P(year - 1) == 3) {
      return 53;
    }
    return 52;
  }
}
