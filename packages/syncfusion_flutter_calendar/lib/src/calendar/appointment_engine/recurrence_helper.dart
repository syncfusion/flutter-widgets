import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';

import '../common/date_time_engine.dart';
import '../common/enums.dart' show RecurrenceType, RecurrenceRange, WeekDays;
import 'appointment_helper.dart';
import 'recurrence_properties.dart';

// ignore: avoid_classes_with_only_static_members
/// Holds the static helper methods used for handling recurrence in calendar.
class RecurrenceHelper {
  /// Check the recurrence appointment in between the visible date range.
  static bool _isRecurrenceInBetweenSpecificRange(DateTime appointmentDate,
      Duration duration, DateTime visibleStartDate, DateTime visibleEndTime) {
    final DateTime appointmentEndDate =
        DateTimeHelper.getDateTimeValue(addDuration(appointmentDate, duration));

    /// ignore: lines_longer_than_80_chars
    return isDateWithInDateRange(visibleStartDate, visibleEndTime, appointmentDate) ||
        isDateWithInDateRange(
            visibleStartDate, visibleEndTime, appointmentEndDate) ||
        isDateWithInDateRange(
            appointmentDate, appointmentEndDate, visibleStartDate);
  }

  static List<DateTime> _getDailyRecurrenceDateTimeCollection(
      String rRule, DateTime recurrenceStartDate,
      {Duration? recurrenceDuration,
      DateTime? specificStartDate,
      DateTime? specificEndDate}) {
    final List<DateTime> recDateCollection = <DateTime>[];

    if (specificEndDate != null) {
      specificEndDate = DateTime(specificEndDate.year, specificEndDate.month,
          specificEndDate.day, 23, 59, 59);
    }

    recurrenceDuration ??= Duration.zero;
    final bool isSpecificDateRange =
        specificStartDate != null && specificEndDate != null;

    if (isSpecificDateRange && recurrenceStartDate.isAfter(specificEndDate)) {
      return recDateCollection;
    }

    final int recurrenceStartHour = recurrenceStartDate.hour;
    final int recurrenceStartMinute = recurrenceStartDate.minute;
    final int recurrenceStartSecond = recurrenceStartDate.second;

    const List<String> ruleSeparator = <String>['=', ';', ','];
    final List<String> ruleArray = splitRule(rRule, ruleSeparator);
    if (ruleArray.isEmpty) {
      return recDateCollection;
    }

    int recurrenceCount = 0;
    final List<String> values = _findKeyIndex(ruleArray);

    /// Assign only daily recurrence needed values.
    final String recurrenceCountString = values[0];
    final String intervalCountString = values[8];
    final String untilValueString = values[10];
    if (recurrenceCountString.isNotEmpty) {
      recurrenceCount = int.parse(recurrenceCountString);
    }

    final int dailyDayGap =
        rRule.contains('INTERVAL') ? int.parse(intervalCountString) : 1;
    DateTime? endDate;
    if (rRule.contains('UNTIL')) {
      /// Set the end date value from until date value.
      endDate = getUntilEndDate(untilValueString);
      if (isSpecificDateRange) {
        final DateTime startTime = DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);
        final DateTime endTime = startTime.add(recurrenceDuration);

        /// Check the visible start date after of recurrence end date, if
        /// true then recurrence the empty appointment collection.
        if (specificStartDate.isAfter(endTime) &&
            !isSameDate(specificStartDate, endTime)) {
          return recDateCollection;
        }
      }
    } else if (rRule.contains('COUNT')) {
      /// Set the end date value from recurrence start date with
      /// count and interval values.
      endDate = AppointmentHelper.addDaysWithTime(
          recurrenceStartDate,
          (recurrenceCount - 1) * dailyDayGap,
          recurrenceStartHour,
          recurrenceStartMinute,
          recurrenceStartSecond);

      /// Return empty collection when the recurrence end date after of visible
      /// start date.
      final DateTime recurrenceEndDate = endDate.add(recurrenceDuration);
      if (isSpecificDateRange &&
          specificStartDate.isAfter(recurrenceEndDate) &&
          !isSameDate(specificStartDate, recurrenceEndDate)) {
        return recDateCollection;
      }

      endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    }

    /// NoEndDate specified rule returns empty collection issue fix.
    if (isSpecificDateRange) {
      endDate = endDate == null || endDate.isAfter(specificEndDate)
          ? specificEndDate
          : endDate;
    }

    int recurrenceIncrementCount = 0;
    DateTime addDate = recurrenceStartDate;

    /// Calculate the initial start date when visible start date specified and
    /// recurrence start date is before of visible start date
    if (isSpecificDateRange &&
        recurrenceStartDate.isBefore(specificStartDate)) {
      final DateTime recurrenceInitialDate = DateTime(recurrenceStartDate.year,
          recurrenceStartDate.month, recurrenceStartDate.day);
      final DateTime visibleInitialDate = DateTime(specificStartDate.year,
          specificStartDate.month, specificStartDate.day);

      /// Total days difference between the visible start date and recurrence
      /// start date.
      final int difference = AppointmentHelper.getDifference(
              recurrenceInitialDate, visibleInitialDate)
          .inDays;
      final int dayDifference = difference % dailyDayGap;

      /// Valid recurrences in between the visible start date and recurrence
      /// start date.
      int incrementCount = difference ~/ dailyDayGap;

      /// If day difference is 0 then initial start date is visible start date
      /// and check the previous recurrence date have long recurrence duration.
      if (dayDifference == 0) {
        addDate = DateTime(
            specificStartDate.year,
            specificStartDate.month,
            specificStartDate.day,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);
      } else {
        /// If day difference is not 0 then initial start date is after the
        /// visible start date so calculate the recurrence from the date before
        /// the visible start date. check the previous recurrence date have
        /// long recurrence duration.
        addDate = AppointmentHelper.addDaysWithTime(
            visibleInitialDate,
            -dayDifference,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);
      }

      final DateTime recurrenceEndDate = addDate.add(recurrenceDuration);
      if (incrementCount > 0 && !isSameDate(addDate, recurrenceEndDate)) {
        final int durationDifference = recurrenceEndDate.hour > addDate.hour
            ? recurrenceDuration.inDays
            : recurrenceDuration.inDays + 1;
        final int intervalCount =
            ((durationDifference ~/ dailyDayGap) * dailyDayGap) +
                (durationDifference % dailyDayGap == 0 ? 0 : dailyDayGap);
        addDate = AppointmentHelper.addDaysWithTime(addDate, -intervalCount,
            recurrenceStartHour, recurrenceStartMinute, recurrenceStartSecond);
        incrementCount -= intervalCount ~/ dailyDayGap;
      }

      recurrenceIncrementCount = incrementCount;

      /// Reset to recurrence start date when the initial recurrence start date
      /// before the recurrence start date
      if (addDate.isBefore(recurrenceStartDate)) {
        addDate = recurrenceStartDate;
      }

      /// Reset the recurrence count to 0 when its value less than 0.
      if (recurrenceIncrementCount < 0) {
        recurrenceIncrementCount = 0;
      }
    }

    while (recurrenceIncrementCount < recurrenceCount ||
        (endDate != null &&
            (addDate.isBefore(endDate) || addDate == endDate))) {
      if (isSpecificDateRange) {
        if (_isRecurrenceInBetweenSpecificRange(
            addDate, recurrenceDuration, specificStartDate, specificEndDate)) {
          recDateCollection.add(addDate);
        }

        if (addDate.isAfter(specificEndDate)) {
          break;
        }
      } else {
        recDateCollection.add(addDate);
      }

      addDate = AppointmentHelper.addDaysWithTime(addDate, dailyDayGap,
          recurrenceStartHour, recurrenceStartMinute, recurrenceStartSecond);
      recurrenceIncrementCount++;
    }

    return recDateCollection;
  }

  static List<DateTime> _getWeeklyRecurrenceDateTimeCollection(
      String rRule, DateTime recurrenceStartDate,
      {Duration? recurrenceDuration,
      DateTime? specificStartDate,
      DateTime? specificEndDate}) {
    final List<DateTime> recDateCollection = <DateTime>[];

    if (specificEndDate != null) {
      specificEndDate = DateTime(specificEndDate.year, specificEndDate.month,
          specificEndDate.day, 23, 59, 59);
    }

    recurrenceDuration ??= Duration.zero;
    final bool isSpecificDateRange =
        specificStartDate != null && specificEndDate != null;

    if (isSpecificDateRange && recurrenceStartDate.isAfter(specificEndDate)) {
      return recDateCollection;
    }

    const List<String> ruleSeparator = <String>['=', ';', ','];
    const String weeklySeparator = ';';
    const List<String> weekDaysString = <String>[
      'SU',
      'MO',
      'TU',
      'WE',
      'TH',
      'FR',
      'SA'
    ];
    final List<String> ruleArray = splitRule(rRule, ruleSeparator);
    if (ruleArray.isEmpty) {
      return recDateCollection;
    }
    final List<String> values = _findKeyIndex(ruleArray);
    final String recurrenceCountString = values[0];
    final String intervalCountString = values[8];
    final String untilValueString = values[10];

    final List<String> weeklyRule = rRule.split(weeklySeparator);
    final List<String> weeklyByDayRules = _findWeeklyRule(weeklyRule);
    final int weeklyByDayPos =
        weeklyByDayRules.isNotEmpty ? int.parse(weeklyByDayRules[1]) : -1;

    final int recurrenceStartHour = recurrenceStartDate.hour;
    final int recurrenceStartMinute = recurrenceStartDate.minute;
    final int recurrenceStartSecond = recurrenceStartDate.second;
    final int recurrenceCount =
        recurrenceCountString.isNotEmpty ? int.parse(recurrenceCountString) : 0;

    int tempCount = 0;
    final int weeklyWeekGap = ruleArray.length > 4 && rRule.contains('INTERVAL')
        ? int.parse(intervalCountString)
        : 1;
    assert(weeklyByDayPos != -1, 'Invalid weekly recurrence rule');
    final List<int> weekDays = <int>[];
    final String ruleDaysString = weeklyRule[weeklyByDayPos];
    for (int i = 0; i < weekDaysString.length; i++) {
      if (!ruleDaysString.contains(weekDaysString[i])) {
        continue;
      }

      weekDays.add(i);
    }

    weekDays.sort();
    final int weekDaysCount = weekDays.length;
    assert(weekDaysCount != 0, 'Invalid weekly recurrence rule');

    final int weekDay = recurrenceStartDate.weekday % DateTime.daysPerWeek;
    DateTime? endDate;
    if (rRule.contains('UNTIL')) {
      /// Set the end date value from until date value.
      endDate = getUntilEndDate(untilValueString);
      if (isSpecificDateRange) {
        final DateTime startTime = DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);
        final DateTime endTime = startTime.add(recurrenceDuration);

        /// Check the visible start date after of recurrence end date, if
        /// true then recurrence the empty appointment collection.
        if (specificStartDate.isAfter(endTime) &&
            !isSameDate(specificStartDate, endTime)) {
          return recDateCollection;
        }
      }
    } else if (rRule.contains('COUNT')) {
      int tempRecurrenceCount = recurrenceCount;

      int initialWeekDay = weekDay;

      /// Remove the recurrence on current week.
      /// Eg., Week Mar 21 - 27 and recurrence start date is Mar 26 then remove
      /// recurrence placed on Mar 26, 27 and start with Mar 28.
      while (initialWeekDay < DateTime.daysPerWeek) {
        if (weekDays.contains(initialWeekDay)) {
          tempRecurrenceCount--;
        }

        initialWeekDay++;
      }

      /// Calculate the full weeks(sunday to saturday) occupies the recurrences.
      /// Eg., if recurrence count is 20 each week have 3 occurrence then
      /// full weeks count is 6.
      final int totalWeeks = tempRecurrenceCount ~/ weekDaysCount;

      /// Calculate the remaining and in between weeks occurrences.
      /// Eg., if recurrence count is 20 each week have 3 occurrence then
      /// remaining count is 2.
      int remainingCount = tempRecurrenceCount % weekDaysCount;

      /// Calculate the total days on full weeks.
      int totalDays = totalWeeks * DateTime.daysPerWeek * weeklyWeekGap;

      /// Add initial week days from recurrence start date to week end and
      /// add interval time after the initial week.
      totalDays += DateTime.daysPerWeek -
          weekDay +
          (DateTime.daysPerWeek * (weeklyWeekGap - 1));

      /// Calculate the next week occurrences and it failed when
      /// initial week have occurrences more than count value
      /// some times count value less than the by day specified count
      /// Eg., StartTime Apr 28, 2021(WE) by day WE, TH, SA and count is 2 then
      /// recurrence end date is Apr 29, 2021. In the above case remaining
      /// count value goes to negative.
      if (remainingCount != 0 && tempRecurrenceCount > 0) {
        /// Calculate the in between week days.
        int additionalDays = 0;
        while (additionalDays < DateTime.daysPerWeek && remainingCount != 0) {
          if (weekDays.contains(additionalDays % DateTime.daysPerWeek)) {
            remainingCount--;
          }

          additionalDays++;
        }

        /// Above loop add additional 1 day because condition failed after
        /// increment. so decrement the days count by 1.
        totalDays += additionalDays - 1;
      } else if (remainingCount != 0 && tempRecurrenceCount < 0) {
        /// some times count value less than the by day specified count
        /// Eg., StartTime Apr 28, 2021(WE) by day WE, TH, SA and count is 2
        /// then recurrence end date is Apr 29, 2021. In the above case
        /// remaining count value goes to negative.

        /// Calculate the in between week days.
        int additionalDays = weekDay;
        int currentRecurrenceCount = recurrenceCount;
        while (additionalDays < DateTime.daysPerWeek &&
            currentRecurrenceCount != 0) {
          if (weekDays.contains(additionalDays)) {
            currentRecurrenceCount--;
          }

          additionalDays++;
        }

        /// Above loop add additional 1 day because condition failed after
        /// increment. so decrement the days count by 1.
        totalDays = additionalDays - weekDay - 1;
        if (totalDays < 0) {
          totalDays = 0;
        }
      } else {
        /// Calculate the exact end date of the week.
        int additionalDays = 1;
        while (additionalDays <= DateTime.daysPerWeek) {
          /// Decrement the day and check the date week day is weekly recurrence
          /// specified week day. If true then break and additionalDays variable
          /// have the difference between the initial and indexed position.
          if (weekDays.contains((DateTime.daysPerWeek - additionalDays) % 7)) {
            break;
          }

          additionalDays++;
        }

        /// Subtract the total days by additionalDays and week interval because
        /// the recurrence placed on first week so the interval does not have a
        /// recurrences so remove the interval.
        /// Eg., If the interval is 2 then the 1st week have occurrences and
        /// 2nd week does not have occurrences.
        totalDays -=
            additionalDays + (DateTime.daysPerWeek * (weeklyWeekGap - 1));
      }

      endDate = AppointmentHelper.addDaysWithTime(
          recurrenceStartDate,
          totalDays,
          recurrenceStartHour,
          recurrenceStartMinute,
          recurrenceStartSecond);

      /// Return empty collection when the recurrence end date after of visible
      /// start date.
      final DateTime recurrenceEndDate = endDate.add(recurrenceDuration);
      if (isSpecificDateRange &&
          specificStartDate.isAfter(recurrenceEndDate) &&
          !isSameDate(specificStartDate, recurrenceEndDate)) {
        return recDateCollection;
      }

      endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    }

    /// NoEndDate specified rule returns empty collection issue fix.
    if (isSpecificDateRange) {
      endDate = endDate == null || endDate.isAfter(specificEndDate)
          ? specificEndDate
          : endDate;
    }

    DateTime addDate = recurrenceStartDate;
    if (isSpecificDateRange &&
        recurrenceStartDate.isBefore(specificStartDate)) {
      final DateTime startDate =
          DateTime(addDate.year, addDate.month, addDate.day);

      /// Calculate the total days between the recurrence start and visible
      /// start date.
      int daysDifference =
          AppointmentHelper.getDifference(startDate, specificStartDate).inDays;
      final DateTime recurrenceEndDate = addDate.add(recurrenceDuration);

      /// Calculate day difference between the recurrence start and end date.
      final int durationDifference = isSameDate(recurrenceEndDate, addDate)
          ? 0
          : recurrenceEndDate.hour > addDate.hour
              ? recurrenceDuration.inDays
              : recurrenceDuration.inDays + 1;

      /// Remove the duration day difference from total days difference because
      /// if the recurrence placed saturday, sunday and it duration is 2 days
      /// then saturday recurrence end with monday but the visible start date
      /// from sunday. When recurrence duration does not considered then the
      /// recurrence dates only have sunday date and it does not consider the
      /// saturday date.
      daysDifference -= durationDifference;
      daysDifference = daysDifference < 0 ? 0 : daysDifference;
      int tempRecurrenceCount = 0;
      int initialWeekDay = weekDay;

      int initialWeekDaysCount = 0;

      /// Remove the initial week recurrences and days because if the
      /// recurrence start date is tuesday then calculate the occurrences
      /// from tuesday to saturday and remove it from total days count.
      while (initialWeekDay < DateTime.daysPerWeek &&
          daysDifference > initialWeekDaysCount) {
        if (weekDays.contains(initialWeekDay)) {
          tempRecurrenceCount++;
        }

        initialWeekDay++;
        initialWeekDaysCount++;
      }

      final bool isOccurrenceInInitialWeek =
          initialWeekDaysCount + weekDay < DateTime.daysPerWeek;
      daysDifference -= isOccurrenceInInitialWeek ? 0 : initialWeekDaysCount;

      /// Calculate and remove the interval week after the initial week on
      /// total days difference.
      final int initialWeekGap = isOccurrenceInInitialWeek
          ? 0
          : DateTime.daysPerWeek * (weeklyWeekGap - 1);
      daysDifference -= initialWeekGap;

      /// Calculate the total valid weeks(sunday to saturday) in between the
      /// recurrence start and visible start date.
      final int totalWeeks =
          daysDifference ~/ (DateTime.daysPerWeek * weeklyWeekGap);
      tempRecurrenceCount += totalWeeks * weekDaysCount;

      /// Calculate the valid week start date near to visible start date
      /// by adding the valid weeks in between the recurrence start and visible
      /// start date(totalWeeks * DateTime.daysPerWeek * weeklyWeekGap) and
      /// recurrence start date week remaining days to week end
      /// (DateTime.daysPerWeek - weekDay) + initialWeekGap.
      addDate = AppointmentHelper.addDaysWithTime(
          addDate,
          (totalWeeks * DateTime.daysPerWeek * weeklyWeekGap) +
              (isOccurrenceInInitialWeek
                  ? daysDifference
                  : DateTime.daysPerWeek - weekDay) +
              initialWeekGap,
          recurrenceStartHour,
          recurrenceStartMinute,
          recurrenceStartSecond);

      tempCount = tempRecurrenceCount;
    }

    final bool isWeeklySelected = weeklyRule[weeklyByDayPos].length > 6;

    /// Below code modified for fixing issue while setting rule as
    /// "FREQ=WEEKLY;COUNT=10;BYDAY=MO" along with specified start and end
    /// dates.
    while ((tempCount < recurrenceCount && isWeeklySelected) ||
        (endDate != null &&
            (addDate.isBefore(endDate) || addDate == endDate))) {
      final bool isRecurrenceDate =
          weekDays.contains(addDate.weekday % DateTime.daysPerWeek);
      if (isSpecificDateRange) {
        if (_isRecurrenceInBetweenSpecificRange(addDate, recurrenceDuration,
                specificStartDate, specificEndDate) &&
            isRecurrenceDate) {
          recDateCollection.add(addDate);
        }

        if (addDate.isAfter(specificEndDate)) {
          break;
        }
      } else if (isRecurrenceDate) {
        recDateCollection.add(addDate);
      }

      if (isRecurrenceDate) {
        tempCount++;
      }

      addDate = addDate.weekday == DateTime.saturday
          ? AppointmentHelper.addDaysWithTime(
              addDate,
              ((weeklyWeekGap - 1) * DateTime.daysPerWeek) + 1,
              recurrenceStartHour,
              recurrenceStartMinute,
              recurrenceStartSecond)
          : AppointmentHelper.addDaysWithTime(addDate, 1, recurrenceStartHour,
              recurrenceStartMinute, recurrenceStartSecond);
    }

    return recDateCollection;
  }

  static List<DateTime> _getMonthlyRecurrenceDateTimeCollection(
      String rRule, DateTime recurrenceStartDate,
      {Duration? recurrenceDuration,
      DateTime? specificStartDate,
      DateTime? specificEndDate}) {
    final List<DateTime> recDateCollection = <DateTime>[];

    if (specificEndDate != null) {
      specificEndDate = DateTime(specificEndDate.year, specificEndDate.month,
          specificEndDate.day, 23, 59, 59);
    }

    recurrenceDuration ??= Duration.zero;
    final bool isSpecificDateRange =
        specificStartDate != null && specificEndDate != null;

    if (isSpecificDateRange && recurrenceStartDate.isAfter(specificEndDate)) {
      return recDateCollection;
    }

    final List<String> ruleSeparator = <String>['=', ';', ','];
    final List<String> ruleArray = splitRule(rRule, ruleSeparator);
    if (ruleArray.isEmpty) {
      return recDateCollection;
    }

    int recCount = 0;
    final List<String> values = _findKeyIndex(ruleArray);
    final String recurCount = values[0];
    final String bySetPosCount = values[6];
    final String intervalCount = values[8];
    final String untilValue = values[10];
    final String byDay = values[12];
    final String byDayValue = values[13];
    final String byMonthDay = values[14];
    final String byMonthDayCount = values[15];

    final int recurrenceStartHour = recurrenceStartDate.hour;
    final int recurrenceStartMinute = recurrenceStartDate.minute;
    final int recurrenceStartSecond = recurrenceStartDate.second;
    DateTime addDate = recurrenceStartDate;
    if (recurCount.isNotEmpty) {
      recCount = int.parse(recurCount);
    }

    final int monthlyMonthGap = ruleArray.length > 4 && intervalCount.isNotEmpty
        ? int.parse(intervalCount)
        : 1;
    DateTime? endDate;
    if (rRule.contains('UNTIL')) {
      endDate = getUntilEndDate(untilValue);

      if (isSpecificDateRange) {
        final DateTime startTime = DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);
        final DateTime endTime = startTime.add(recurrenceDuration);

        /// Check the visible start date after of recurrence end date, if
        /// true then recurrence the empty appointment collection.
        if (specificStartDate.isAfter(endTime) &&
            !isSameDate(specificStartDate, endTime)) {
          return recDateCollection;
        }
      }
    }

    /// NoEndDate specified rule returns empty collection issue fix.
    if (isSpecificDateRange && !rRule.contains('COUNT')) {
      endDate = endDate == null || endDate.isAfter(specificEndDate)
          ? specificEndDate
          : endDate;

      final int addedDateMonth = addDate.month;
      final int addedDateYear = addDate.year;
      final int viewStartDateMonth = specificStartDate.month;
      final int viewStartDateYear = specificStartDate.year;
      if (addedDateYear < viewStartDateYear ||
          (viewStartDateMonth >= addedDateMonth &&
              viewStartDateYear == addedDateYear)) {
        /// Calculate the total months between the recurrence start date and
        /// visible start date.
        final int totalMonths = (viewStartDateMonth - addedDateMonth) +
            ((viewStartDateYear - addedDateYear) * 12);

        /// Calculate the valid month count between the recurrence start date
        /// and visible start date.
        final int validMonths = totalMonths ~/ monthlyMonthGap;
        addDate = DateTime(
            addedDateYear, addedDateMonth + (validMonths * monthlyMonthGap));
        if (addDate.isBefore(recurrenceStartDate)) {
          addDate = recurrenceStartDate;
        }
      }
    }

    if (byMonthDay == 'BYMONTHDAY') {
      int monthDate = int.parse(byMonthDayCount);
      final int byMonthDay = monthDate;
      if (byMonthDay == -1) {
        monthDate = AppointmentHelper.getMonthEndDate(addDate).day;
      }
      final DateTime temp = DateTime(addDate.year, addDate.month, monthDate,
          recurrenceStartHour, recurrenceStartMinute, recurrenceStartSecond);

      /// Check the month date greater than recurrence start date and the
      /// month have the date value.
      /// Eg., Recurrence start date as Feb 28 and recurrence month day as
      /// 30 then check the 30 greater than 28 and feb have 30 date.
      if (temp.day == monthDate &&
          (temp.isAfter(recurrenceStartDate) ||
              isSameDate(temp, recurrenceStartDate))) {
        addDate = temp;
      } else {
        /// Check the month date less than recurrence start date or the
        /// month does not have the date
        /// Eg., Recurrence start date as Feb 28 and recurrence month day as
        /// 30 and feb 30 does not exist so move the recurrence to next
        /// month and check next month have date 30 if exists then start the
        /// recurrence from mar 30.
        addDate = DateTime(addDate.year, addDate.month + monthlyMonthGap, 1,
            recurrenceStartHour, recurrenceStartMinute, recurrenceStartSecond);
        final DateTime tempDate = DateTime(
            addDate.year,
            addDate.month,
            monthDate,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);
        if (tempDate.day == monthDate) {
          addDate = tempDate;
        }
      }

      final int yearValue = addDate.year;
      int monthValue = addDate.month;
      int tempCount = 0;
      while (tempCount < recCount ||
          (endDate != null &&
              (addDate.isBefore(endDate) || addDate == endDate))) {
        if (addDate.day != monthDate) {
          /// Check the month date day equal to updated date day value because
          /// if we create the date time for February 30 then the date return
          /// March 1 or 2 based on leap year.
          monthValue += monthlyMonthGap;
          addDate = DateTime(
              yearValue,
              monthValue,
              monthDate,
              recurrenceStartHour,
              recurrenceStartMinute,
              recurrenceStartSecond);
          continue;
        }

        if (isSpecificDateRange) {
          if (_isRecurrenceInBetweenSpecificRange(addDate, recurrenceDuration,
              specificStartDate, specificEndDate)) {
            recDateCollection.add(addDate);
          }

          if (addDate.isAfter(specificEndDate)) {
            break;
          }
        } else {
          recDateCollection.add(addDate);
        }

        monthValue += monthlyMonthGap;
        monthDate = byMonthDay == -1
            ? AppointmentHelper.getMonthEndDate(DateTime(yearValue, monthValue))
                .day
            : monthDate;
        addDate = DateTime(yearValue, monthValue, monthDate,
            recurrenceStartHour, recurrenceStartMinute, recurrenceStartSecond);

        tempCount++;
      }
    } else if (byDay == 'BYDAY') {
      int tempCount = 0;
      final int nthWeekDay = _getWeekDay(byDayValue) % DateTime.daysPerWeek;
      final int bySetPosValue = int.parse(bySetPosCount);

      void updateValidDate() {
        final DateTime monthStart = DateTime(addDate.year, addDate.month, 1,
            recurrenceStartHour, recurrenceStartMinute, recurrenceStartSecond);
        final int monthStartWeekday = monthStart.weekday % DateTime.daysPerWeek;
        final DateTime weekStartDate = AppointmentHelper.addDaysWithTime(
            monthStart,
            -monthStartWeekday,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);
        int nthWeek = bySetPosValue;
        if (monthStartWeekday <= nthWeekDay) {
          nthWeek = bySetPosValue - 1;
        }

        if (bySetPosValue.isNegative) {
          addDate = _getRecurrenceDateForNegativeValue(
              bySetPosValue, monthStart, nthWeekDay);
        } else {
          addDate = AppointmentHelper.addDaysWithTime(
              weekStartDate,
              (nthWeek * DateTime.daysPerWeek) + nthWeekDay,
              recurrenceStartHour,
              recurrenceStartMinute,
              recurrenceStartSecond);
        }
      }

      updateValidDate();
      if (addDate.isBefore(recurrenceStartDate)) {
        addDate = DateTime(addDate.year, addDate.month + monthlyMonthGap, 1,
            recurrenceStartHour, recurrenceStartMinute, recurrenceStartSecond);
        updateValidDate();
      }

      while (tempCount < recCount ||
          (endDate != null &&
              (addDate.isBefore(endDate) || addDate == endDate))) {
        if (isSpecificDateRange) {
          if (_isRecurrenceInBetweenSpecificRange(addDate, recurrenceDuration,
              specificStartDate, specificEndDate)) {
            recDateCollection.add(addDate);
          }

          if (addDate.isAfter(specificEndDate)) {
            break;
          }
        } else {
          recDateCollection.add(addDate);
        }

        addDate = DateTime(addDate.year, addDate.month + monthlyMonthGap, 1,
            recurrenceStartHour, recurrenceStartMinute, recurrenceStartSecond);
        updateValidDate();
        tempCount++;
      }
    }

    return recDateCollection;
  }

  static List<DateTime> _getYearlyRecurrenceDateTimeCollection(
      String rRule, DateTime recurrenceStartDate,
      {Duration? recurrenceDuration,
      DateTime? specificStartDate,
      DateTime? specificEndDate}) {
    final List<DateTime> recDateCollection = <DateTime>[];

    if (specificEndDate != null) {
      specificEndDate = DateTime(specificEndDate.year, specificEndDate.month,
          specificEndDate.day, 23, 59, 59);
    }

    recurrenceDuration ??= Duration.zero;
    final bool isSpecificDateRange =
        specificStartDate != null && specificEndDate != null;

    if (isSpecificDateRange && recurrenceStartDate.isAfter(specificEndDate)) {
      return recDateCollection;
    }

    final List<String> ruleSeparator = <String>['=', ';', ','];
    final List<String> ruleArray = splitRule(rRule, ruleSeparator);
    if (ruleArray.isEmpty) {
      return recDateCollection;
    }

    int recCount = 0;
    final List<String> values = _findKeyIndex(ruleArray);
    final String recurCount = values[0];
    final String bySetPosCount = values[6];
    final String intervalCount = values[8];
    final String untilValue = values[10];
    final String byDay = values[12];
    final String byDayValue = values[13];
    final String byMonthDay = values[14];
    final String byMonthDayCount = values[15];
    final String byMonthCount = values[17];

    final int recurrenceStartHour = recurrenceStartDate.hour;
    final int recurrenceStartMinute = recurrenceStartDate.minute;
    final int recurrenceStartSecond = recurrenceStartDate.second;
    DateTime addDate = recurrenceStartDate;
    if (recurCount.isNotEmpty) {
      recCount = int.parse(recurCount);
    }

    DateTime? endDate;
    if (rRule.contains('UNTIL')) {
      endDate = getUntilEndDate(untilValue);
      if (isSpecificDateRange) {
        final DateTime startTime = DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);
        final DateTime endTime = startTime.add(recurrenceDuration);

        /// Check the visible start date after of recurrence end date, if
        /// true then recurrence the empty appointment collection.
        if (specificStartDate.isAfter(endTime) &&
            !isSameDate(specificStartDate, endTime)) {
          return recDateCollection;
        }
      }
    }

    final int yearlyYearGap = ruleArray.length > 4 && intervalCount.isNotEmpty
        ? int.parse(intervalCount)
        : 1;

    /// NoEndDate specified rule returns empty collection issue fix.
    if (isSpecificDateRange && !rRule.contains('COUNT')) {
      endDate = endDate == null || endDate.isAfter(specificEndDate)
          ? specificEndDate
          : endDate;

      final int addedDateYear = addDate.year;
      final int viewStartDateYear = specificStartDate.year;
      if (addedDateYear < viewStartDateYear) {
        /// Calculate the valid year count between the recurrence start date
        /// and visible start date.
        final int inBetweenYears =
            (viewStartDateYear - addedDateYear) ~/ yearlyYearGap;
        addDate = DateTime(addedDateYear + (inBetweenYears * yearlyYearGap));
        if (addDate.isBefore(recurrenceStartDate)) {
          addDate = recurrenceStartDate;
        }
      }
    }

    if (byMonthDay == 'BYMONTHDAY') {
      final int monthIndex = int.parse(byMonthCount);
      int dayIndex = int.parse(byMonthDayCount);
      final int byMonthDay = dayIndex;
      if (byMonthDay == -1) {
        dayIndex = AppointmentHelper.getMonthEndDate(
                DateTime(addDate.year, monthIndex))
            .day;
      }
      if (monthIndex < 0 || monthIndex > 12) {
        return recDateCollection;
      }

      final int daysInMonth = DateTimeHelper.getDateTimeValue(
              addDays(DateTime(addDate.year, addDate.month + 1), -1))
          .day;
      if (daysInMonth < dayIndex) {
        return recDateCollection;
      }

      final DateTime specificDate = DateTime(addDate.year, monthIndex, dayIndex,
          recurrenceStartHour, recurrenceStartMinute, recurrenceStartSecond);
      if (specificDate.isBefore(recurrenceStartDate)) {
        addDate = DateTime(
            specificDate.year + yearlyYearGap,
            specificDate.month,
            specificDate.day,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);
      } else {
        addDate = specificDate;
      }

      int tempCount = 0;
      while (tempCount < recCount ||
          (endDate != null &&
              (addDate.isBefore(endDate) || addDate == endDate))) {
        if (isSpecificDateRange) {
          if (_isRecurrenceInBetweenSpecificRange(addDate, recurrenceDuration,
              specificStartDate, specificEndDate)) {
            recDateCollection.add(addDate);
          }

          if (addDate.isAfter(specificEndDate)) {
            break;
          }
        } else {
          recDateCollection.add(addDate);
        }

        dayIndex = byMonthDay == -1
            ? AppointmentHelper.getMonthEndDate(
                    DateTime(addDate.year + yearlyYearGap, monthIndex))
                .day
            : addDate.day;

        addDate = DateTime(
            addDate.year + yearlyYearGap,
            addDate.month,
            dayIndex,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);
        tempCount++;
      }
    } else if (byDay == 'BYDAY') {
      int tempCount = 0;
      final int monthIndex = int.parse(byMonthCount);
      final int bySetPosValue = int.parse(bySetPosCount);
      final int nthWeekDay = _getWeekDay(byDayValue) % DateTime.daysPerWeek;

      void updateValidNextDate() {
        while (true) {
          DateTime monthStart = DateTime(
              addDate.year,
              monthIndex,
              1,
              recurrenceStartHour,
              recurrenceStartMinute,
              recurrenceStartSecond);
          final int monthStartWeekday =
              monthStart.weekday % DateTime.daysPerWeek;
          final DateTime weekStartDate = AppointmentHelper.addDaysWithTime(
              monthStart,
              -monthStartWeekday,
              recurrenceStartHour,
              recurrenceStartMinute,
              recurrenceStartSecond);
          int nthWeek = bySetPosValue;
          if (monthStartWeekday <= nthWeekDay) {
            nthWeek = bySetPosValue - 1;
          }

          if (bySetPosValue.isNegative) {
            monthStart = _getRecurrenceDateForNegativeValue(
                bySetPosValue, monthStart, nthWeekDay);
          } else {
            monthStart = AppointmentHelper.addDaysWithTime(
                weekStartDate,
                (nthWeek * DateTime.daysPerWeek) + nthWeekDay,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
          }

          if (monthStart.month != monthIndex ||
              monthStart.isBefore(recurrenceStartDate)) {
            addDate = DateTime(
                monthStart.year + yearlyYearGap,
                monthStart.month,
                monthStart.day,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
            continue;
          }

          addDate = monthStart;
          break;
        }
      }

      updateValidNextDate();
      while (tempCount < recCount ||
          (endDate != null &&
              (addDate.isBefore(endDate) || addDate == endDate))) {
        if (isSpecificDateRange) {
          if (_isRecurrenceInBetweenSpecificRange(addDate, recurrenceDuration,
              specificStartDate, specificEndDate)) {
            recDateCollection.add(addDate);
          }

          if (addDate.isAfter(specificEndDate)) {
            break;
          }
        } else {
          recDateCollection.add(addDate);
        }

        addDate = DateTime(
            addDate.year + yearlyYearGap,
            addDate.month,
            addDate.day,
            recurrenceStartHour,
            recurrenceStartMinute,
            recurrenceStartSecond);

        tempCount++;
        updateValidNextDate();
      }
    }

    return recDateCollection;
  }

  /// Returns the date time collection of recurring appointment.
  static List<DateTime> getRecurrenceDateTimeCollection(
      String rRule, DateTime recurrenceStartDate,
      {Duration? recurrenceDuration,
      DateTime? specificStartDate,
      DateTime? specificEndDate}) {
    /// Return empty collection when recurrence rule is empty.
    if (rRule.isEmpty) {
      return <DateTime>[];
    }

    if (rRule.contains('DAILY')) {
      return _getDailyRecurrenceDateTimeCollection(rRule, recurrenceStartDate,
          recurrenceDuration: recurrenceDuration,
          specificStartDate: specificStartDate,
          specificEndDate: specificEndDate);
    } else if (rRule.contains('WEEKLY')) {
      return _getWeeklyRecurrenceDateTimeCollection(rRule, recurrenceStartDate,
          recurrenceDuration: recurrenceDuration,
          specificStartDate: specificStartDate,
          specificEndDate: specificEndDate);
    } else if (rRule.contains('MONTHLY')) {
      return _getMonthlyRecurrenceDateTimeCollection(rRule, recurrenceStartDate,
          recurrenceDuration: recurrenceDuration,
          specificStartDate: specificStartDate,
          specificEndDate: specificEndDate);
    } else if (rRule.contains('YEARLY')) {
      return _getYearlyRecurrenceDateTimeCollection(rRule, recurrenceStartDate,
          recurrenceDuration: recurrenceDuration,
          specificStartDate: specificStartDate,
          specificEndDate: specificEndDate);
    }

    return <DateTime>[];
  }

  /// Returns the recurrence properties based on the given recurrence rule and
  /// the recurrence start date.
  static RecurrenceProperties parseRRule(String rRule, DateTime recStartDate) {
    final RecurrenceProperties recProp =
        RecurrenceProperties(startDate: recStartDate);

    if (rRule.isEmpty) {
      return recProp;
    }

    final List<String> ruleSeparator = <String>['=', ';', ','];
    final List<String> ruleArray = splitRule(rRule, ruleSeparator);
    if (ruleArray.isEmpty) {
      return recProp;
    }

    const String weeklySeparator = ';';
    final List<String> weeklyRule = rRule.split(weeklySeparator);
    final List<String> resultList = _findKeyIndex(ruleArray);
    final String recurCount = resultList[0];
    final String daily = resultList[1];
    final String weekly = resultList[2];
    final String monthly = resultList[3];
    final String yearly = resultList[4];
    final String bySetPosCount = resultList[6];
    final String intervalCount = resultList[8];
    final String untilValue = resultList[10];
    final String byDay = resultList[12];
    final String byDayValue = resultList[13];
    final String byMonthDay = resultList[14];
    final String byMonthDayCount = resultList[15];
    final String byMonthCount = resultList[17];
    final List<String> weeklyRules = _findWeeklyRule(weeklyRule);
    final int weeklyByDayPos =
        weeklyRules.isNotEmpty ? int.parse(weeklyRules[1]) : -1;

    if (rRule.contains('COUNT')) {
      recProp.recurrenceRange = RecurrenceRange.count;
      recProp.recurrenceCount =
          recurCount.isNotEmpty ? int.parse(recurCount) : 0;
    } else if (rRule.contains('UNTIL')) {
      recProp.recurrenceRange = RecurrenceRange.endDate;
      recProp.endDate = getUntilEndDate(untilValue);
    } else {
      recProp.recurrenceRange = RecurrenceRange.noEndDate;
    }

    recProp.interval = intervalCount.isNotEmpty ? int.parse(intervalCount) : 1;
    if (daily == 'DAILY') {
      recProp.recurrenceType = RecurrenceType.daily;
    } else if (weekly == 'WEEKLY') {
      recProp.recurrenceType = RecurrenceType.weekly;

      if (weeklyByDayPos == -1) {
        return recProp;
      }

      final String weeklyByDayString = weeklyRule[weeklyByDayPos];
      if (weeklyByDayString.contains('SU')) {
        recProp.weekDays.add(WeekDays.sunday);
      }
      if (weeklyByDayString.contains('MO')) {
        recProp.weekDays.add(WeekDays.monday);
      }

      if (weeklyByDayString.contains('TU')) {
        recProp.weekDays.add(WeekDays.tuesday);
      }

      if (weeklyByDayString.contains('WE')) {
        recProp.weekDays.add(WeekDays.wednesday);
      }

      if (weeklyByDayString.contains('TH')) {
        recProp.weekDays.add(WeekDays.thursday);
      }

      if (weeklyByDayString.contains('FR')) {
        recProp.weekDays.add(WeekDays.friday);
      }

      if (weeklyByDayString.contains('SA')) {
        recProp.weekDays.add(WeekDays.saturday);
      }
    } else if (monthly == 'MONTHLY') {
      recProp.recurrenceType = RecurrenceType.monthly;
      if (byMonthDay == 'BYMONTHDAY') {
        recProp.week = 0;
        recProp.dayOfMonth =
            byMonthDayCount.isNotEmpty ? int.parse(byMonthDayCount) : 1;
      } else if (byDay == 'BYDAY') {
        recProp.week = bySetPosCount.isNotEmpty ? int.parse(bySetPosCount) : 0;
        recProp.dayOfWeek = byDayValue.isNotEmpty ? _getWeekDay(byDayValue) : 1;
      }
    } else if (yearly == 'YEARLY') {
      recProp.recurrenceType = RecurrenceType.yearly;
      if (byMonthDay == 'BYMONTHDAY') {
        recProp.month = byMonthCount.isNotEmpty ? int.parse(byMonthCount) : 1;
        recProp.dayOfMonth =
            byMonthDayCount.isNotEmpty ? int.parse(byMonthDayCount) : 1;
      } else if (byDay == 'BYDAY') {
        recProp.month = byMonthCount.isNotEmpty ? int.parse(byMonthCount) : 1;
        recProp.week = bySetPosCount.isNotEmpty ? int.parse(bySetPosCount) : 0;
        recProp.dayOfWeek = byDayValue.isNotEmpty ? _getWeekDay(byDayValue) : 1;
      }
    }

    return recProp;
  }

  /// Returns the until rule based on the end date value.
  static String _getUntilRRule(DateTime endDate, String rRule) {
    endDate = endDate.toUtc();
    final String dateString = DateFormat('yyyyMMdd').format(endDate);
    final String timeString = DateFormat('HHmmss').format(endDate);
    rRule = '$rRule;UNTIL=${'${dateString}T${timeString}Z'}';
    return rRule;
  }

  static String _getRRuleForDaily(
      int recCount,
      RecurrenceProperties recurrenceProperties,
      DateTime startDate,
      DateTime? endDate,
      bool isValidRecurrence,
      Duration diffTimeSpan) {
    String rRule = '';
    if ((recCount > 0 &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.count) ||
        recurrenceProperties.recurrenceRange == RecurrenceRange.noEndDate ||
        (recurrenceProperties.recurrenceRange == RecurrenceRange.endDate &&
            (startDate.isBefore(endDate!) || startDate == endDate))) {
      rRule = 'FREQ=DAILY';

      if (diffTimeSpan.inHours >= recurrenceProperties.interval * 24) {
        isValidRecurrence = false;
      }

      if (recurrenceProperties.interval > 0) {
        rRule = '$rRule;INTERVAL=${recurrenceProperties.interval}';
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = '$rRule;COUNT=$recCount';
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        rRule = RecurrenceHelper._getUntilRRule(endDate!, rRule);
      }
    }

    if (!isValidRecurrence) {
      rRule = '';
    }

    return rRule;
  }

  static String _getRRuleForWeekly(
      DateTime startDate,
      DateTime? endDate,
      int recCount,
      RecurrenceProperties recurrenceProperties,
      bool isValidRecurrence,
      Duration diffTimeSpan,
      DateTime prevDate) {
    String rRule = '';
    DateTime addDate = startDate;
    if ((recCount > 0 &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.count) ||
        recurrenceProperties.recurrenceRange == RecurrenceRange.noEndDate ||
        (recurrenceProperties.recurrenceRange == RecurrenceRange.endDate &&
            (startDate.isBefore(endDate!) || startDate == endDate))) {
      rRule = 'FREQ=WEEKLY';
      String byDay = '';
      int su = 0, mo = 0, tu = 0, we = 0, th = 0, fr = 0, sa = 0;
      String dayKey = '';
      int dayCount = 0;
      rRule = '$rRule;BYDAY=';
      int count = 0;
      int i = 0;
      while ((count < recCount &&
              isValidRecurrence &&
              recurrenceProperties.weekDays.isNotEmpty) ||
          (recurrenceProperties.recurrenceRange == RecurrenceRange.endDate &&
              (addDate.isBefore(endDate!) || isSameDate(addDate, endDate))) ||
          (recurrenceProperties.recurrenceRange == RecurrenceRange.noEndDate &&
              i < DateTime.daysPerWeek)) {
        switch (addDate.weekday) {
          case DateTime.sunday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.sunday)) {
                dayKey = 'SU,';
                dayCount = su;
              }

              break;
            }

          case DateTime.monday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.monday)) {
                dayKey = 'MO,';
                dayCount = mo;
              }

              break;
            }

          case DateTime.tuesday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.tuesday)) {
                dayKey = 'TU,';
                dayCount = tu;
              }

              break;
            }

          case DateTime.wednesday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.wednesday)) {
                dayKey = 'WE,';
                dayCount = we;
              }

              break;
            }

          case DateTime.thursday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.thursday)) {
                dayKey = 'TH,';
                dayCount = th;
              }

              break;
            }

          case DateTime.friday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.friday)) {
                dayKey = 'FR,';
                dayCount = fr;
              }

              break;
            }

          case DateTime.saturday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.saturday)) {
                dayKey = 'SA';
                dayCount = sa;
              }

              break;
            }
        }

        if (dayKey.isNotEmpty) {
          if (count != 0) {
            final Duration tempTimeSpan =
                AppointmentHelper.getDifference(prevDate, addDate);
            if (tempTimeSpan <= diffTimeSpan) {
              isValidRecurrence = false;
            } else {
              prevDate = addDate;
              if (dayCount == 1) {
                break;
              }

              if (addDate.weekday != DateTime.saturday) {
                byDay =
                    byDay.isNotEmpty && byDay.substring(byDay.length - 1) == 'A'
                        ? '$byDay,$dayKey'
                        : byDay + dayKey;
              } else {
                byDay = byDay + dayKey;
              }

              dayCount++;
            }
          } else {
            prevDate = addDate;
            count++;
            byDay = byDay.isNotEmpty && byDay.substring(byDay.length - 1) == 'A'
                ? '$byDay,$dayKey'
                : byDay + dayKey;
            dayCount++;
          }

          if (recurrenceProperties.recurrenceRange ==
              RecurrenceRange.noEndDate) {
            recCount++;
          }

          switch (addDate.weekday) {
            case DateTime.sunday:
              {
                su = dayCount;
                break;
              }

            case DateTime.monday:
              {
                mo = dayCount;
                break;
              }

            case DateTime.tuesday:
              {
                tu = dayCount;
                break;
              }

            case DateTime.wednesday:
              {
                we = dayCount;
                break;
              }

            case DateTime.thursday:
              {
                th = dayCount;
                break;
              }

            case DateTime.friday:
              {
                fr = dayCount;
                break;
              }

            case DateTime.saturday:
              {
                sa = dayCount;
                break;
              }
          }

          dayCount = 0;
          dayKey = '';
        }

        addDate = addDate.weekday == DateTime.saturday
            ? AppointmentHelper.addDaysWithTime(
                addDate,
                ((recurrenceProperties.interval - 1) * DateTime.daysPerWeek) +
                    1,
                startDate.hour,
                startDate.minute,
                startDate.second)
            : AppointmentHelper.addDaysWithTime(
                addDate, 1, startDate.hour, startDate.minute, startDate.second);
        i = i + 1;
      }

      byDay = _sortByDay(byDay);
      rRule = rRule + byDay;

      if (recurrenceProperties.interval > 0) {
        rRule = '$rRule;INTERVAL=${recurrenceProperties.interval}';
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = '$rRule;COUNT=$recCount';
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        rRule = RecurrenceHelper._getUntilRRule(endDate!, rRule);
      }
    }

    if (!isValidRecurrence) {
      rRule = '';
    }

    return rRule;
  }

  static String _getRRuleForMonthly(
    int recCount,
    RecurrenceProperties recurrenceProperties,
    DateTime startDate,
    DateTime? endDate,
    Duration diffTimeSpan,
    bool isValidRecurrence,
  ) {
    String rRule = '';
    if ((recCount > 0 &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.count) ||
        recurrenceProperties.recurrenceRange == RecurrenceRange.noEndDate ||
        (recurrenceProperties.recurrenceRange == RecurrenceRange.endDate &&
            (startDate.isBefore(endDate!) || startDate == endDate))) {
      rRule = 'FREQ=MONTHLY';

      if (recurrenceProperties.week == 0) {
        rRule = '$rRule;BYMONTHDAY=${recurrenceProperties.dayOfMonth}';
      } else {
        final DateTime firstDate = DateTimeHelper.getDateTimeValue(
            addDays(DateTime.now(), -(DateTime.now().weekday - 1)));
        final List<String> dayNames =
            List<int>.generate(DateTime.daysPerWeek, (int index) => index)
                .map((int value) => DateFormat(DateFormat.ABBR_WEEKDAY)
                    .format(addDays(firstDate, value)))
                .toList();
        final String byDayString = dayNames[recurrenceProperties.dayOfWeek - 1];

        /// AbbreviatedDayNames will return three digit char, as per the
        /// standard we need to return only first two char for RRule so here
        /// have removed the last char.
        rRule =
            // ignore: lines_longer_than_80_chars
            '$rRule;BYDAY=${byDayString.substring(0, byDayString.length - 1).toUpperCase()};BYSETPOS=${recurrenceProperties.week}';
      }

      if (recurrenceProperties.interval > 0) {
        rRule = '$rRule;INTERVAL=${recurrenceProperties.interval}';
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = '$rRule;COUNT=$recCount';
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        rRule = RecurrenceHelper._getUntilRRule(endDate!, rRule);
      }

      if (AppointmentHelper.getDifference(
              startDate,
              DateTime(
                  startDate.year,
                  startDate.month + recurrenceProperties.interval,
                  startDate.day,
                  startDate.hour,
                  startDate.minute,
                  startDate.second)) <
          diffTimeSpan) {
        isValidRecurrence = false;
      }
    }

    if (!isValidRecurrence) {
      rRule = '';
    }

    return rRule;
  }

  static String _getRRuleForYearly(
      int recCount,
      RecurrenceProperties recurrenceProperties,
      DateTime startDate,
      DateTime? endDate,
      Duration diffTimeSpan,
      bool isValidRecurrence) {
    String rRule = '';
    if ((recCount > 0 &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.count) ||
        recurrenceProperties.recurrenceRange == RecurrenceRange.noEndDate ||
        (recurrenceProperties.recurrenceRange == RecurrenceRange.endDate &&
            (startDate.isBefore(endDate!) || startDate == endDate))) {
      rRule = 'FREQ=YEARLY';

      if (recurrenceProperties.week == 0) {
        rRule =
            // ignore: lines_longer_than_80_chars
            '$rRule;BYMONTHDAY=${recurrenceProperties.dayOfMonth};BYMONTH=${recurrenceProperties.month}';
      } else {
        final DateTime firstDate = DateTimeHelper.getDateTimeValue(
            addDays(DateTime.now(), -(DateTime.now().weekday - 1)));
        final List<String> dayNames =
            List<int>.generate(DateTime.daysPerWeek, (int index) => index)
                .map((int value) => DateFormat(DateFormat.ABBR_WEEKDAY)
                    .format(addDays(firstDate, value)))
                .toList();
        final String byDayString = dayNames[recurrenceProperties.dayOfWeek - 1];

        /// AbbreviatedDayNames will return three digit char, as per the
        /// standard we need to return only first two char for RRule so here
        /// have removed the last char.
        rRule =
            // ignore: lines_longer_than_80_chars
            '$rRule;BYDAY=${byDayString.substring(0, byDayString.length - 1).toUpperCase()};BYMONTH=${recurrenceProperties.month};BYSETPOS=${recurrenceProperties.week}';
      }

      if (recurrenceProperties.interval > 0) {
        rRule = '$rRule;INTERVAL=${recurrenceProperties.interval}';
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = '$rRule;COUNT=$recCount';
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        rRule = RecurrenceHelper._getUntilRRule(endDate!, rRule);
      }

      if (AppointmentHelper.getDifference(
              startDate,
              DateTime(
                  startDate.year + recurrenceProperties.interval,
                  startDate.month,
                  startDate.day,
                  startDate.hour,
                  startDate.minute,
                  startDate.second)) <
          diffTimeSpan) {
        isValidRecurrence = false;
      }
    }

    if (!isValidRecurrence) {
      rRule = '';
    }

    return rRule;
  }

  /// Generates the recurrence rule based on the given recurrence properties and
  /// the start date and end date of the recurrence appointment.
  static String generateRRule(RecurrenceProperties recurrenceProperties,
      DateTime appStartTime, DateTime appEndTime) {
    final DateTime recPropStartDate = recurrenceProperties.startDate;
    final DateTime? recPropEndDate = recurrenceProperties.endDate;
    final DateTime startDate = appStartTime.isAfter(recPropStartDate)
        ? appStartTime
        : recPropStartDate;
    final DateTime? endDate = recPropEndDate;
    final Duration diffTimeSpan =
        AppointmentHelper.getDifference(appStartTime, appEndTime);
    int recCount = 0;
    final DateTime prevDate = DateTime.utc(1);
    const bool isValidRecurrence = true;

    recCount = recurrenceProperties.recurrenceCount;
    switch (recurrenceProperties.recurrenceType) {
      case RecurrenceType.daily:
        return _getRRuleForDaily(recCount, recurrenceProperties, startDate,
            endDate, isValidRecurrence, diffTimeSpan);
      case RecurrenceType.weekly:
        return _getRRuleForWeekly(startDate, endDate, recCount,
            recurrenceProperties, isValidRecurrence, diffTimeSpan, prevDate);
      case RecurrenceType.monthly:
        return _getRRuleForMonthly(recCount, recurrenceProperties, startDate,
            endDate, diffTimeSpan, isValidRecurrence);
      case RecurrenceType.yearly:
        return _getRRuleForYearly(recCount, recurrenceProperties, startDate,
            endDate, diffTimeSpan, isValidRecurrence);
    }
  }

  static List<String> _findKeyIndex(List<String> ruleArray) {
    int byMonthDayPosition = 0;
    int byDayPosition = 0;
    String recurCount = '';
    String daily = '';
    String weekly = '';
    String monthly = '';
    String yearly = '';
    String bySetPos = '';
    String bySetPosCount = '';
    String interval = '';
    String intervalCount = '';
    String count = '';
    String byDay = '';
    String byDayValue = '';
    String byMonthDay = '';
    String byMonthDayCount = '';
    String byMonth = '';
    String byMonthCount = '';
    const String weeklyByDay = '';
    String until = '';
    String untilValue = '';

    for (int i = 0; i < ruleArray.length; i++) {
      if (ruleArray[i] == 'COUNT') {
        count = ruleArray[i];
        recurCount = ruleArray[i + 1];
        continue;
      }

      if (ruleArray[i] == 'DAILY') {
        daily = ruleArray[i];
        continue;
      }

      if (ruleArray[i] == 'WEEKLY') {
        weekly = ruleArray[i];
        continue;
      }

      if (ruleArray[i] == 'INTERVAL') {
        interval = ruleArray[i];
        intervalCount = ruleArray[i + 1];
        continue;
      }

      if (ruleArray[i] == 'UNTIL') {
        until = ruleArray[i];
        untilValue = ruleArray[i + 1];
        continue;
      }

      if (ruleArray[i] == 'MONTHLY') {
        monthly = ruleArray[i];
        continue;
      }

      if (ruleArray[i] == 'YEARLY') {
        yearly = ruleArray[i];
        continue;
      }

      if (ruleArray[i] == 'BYSETPOS') {
        bySetPos = ruleArray[i];
        bySetPosCount = ruleArray[i + 1];
        continue;
      }

      if (ruleArray[i] == 'BYDAY') {
        byDayPosition = i;
        byDay = ruleArray[i];
        byDayValue = ruleArray[i + 1];
        continue;
      }

      if (ruleArray[i] == 'BYMONTH') {
        byMonth = ruleArray[i];
        byMonthCount = ruleArray[i + 1];
        continue;
      }

      if (ruleArray[i] == 'BYMONTHDAY') {
        byMonthDayPosition = i;
        byMonthDay = ruleArray[i];
        byMonthDayCount = ruleArray[i + 1];
        continue;
      }
    }

    return <String>[
      recurCount,
      daily,
      weekly,
      monthly,
      yearly,
      bySetPos,
      bySetPosCount,
      interval,
      intervalCount,
      until,
      untilValue,
      count,
      byDay,
      byDayValue,
      byMonthDay,
      byMonthDayCount,
      byMonth,
      byMonthCount,
      weeklyByDay,
      byMonthDayPosition.toString(),
      byDayPosition.toString()
    ];
  }

  static List<String> _findWeeklyRule(List<String> weeklyRule) {
    final List<String> result = <String>[];
    for (int i = 0; i < weeklyRule.length; i++) {
      if (weeklyRule[i].contains('BYDAY')) {
        result.add(weeklyRule[i]);
        result.add(i.toString());
        break;
      }
    }

    return result;
  }

  static int _getWeekDay(String weekDay) {
    int index = 1;
    final DateTime firstDate = DateTimeHelper.getDateTimeValue(
        addDays(DateTime.now(), -(DateTime.now().weekday - 1)));
    final List<String> dayNames =
        List<int>.generate(DateTime.daysPerWeek, (int index) => index)
            .map((int value) => DateFormat(DateFormat.ABBR_WEEKDAY)
                .format(addDays(firstDate, value)))
            .toList();
    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      final String dayName = dayNames[i];

      /// AbbreviatedDayNames will return three digit char, user may give 2
      /// digit char also as per the standard so here have checked the
      /// char count.
      if (dayName.toUpperCase() == weekDay ||
          weekDay.length == 2 &&
              dayName.substring(0, dayName.length - 1).toUpperCase() ==
                  weekDay) {
        index = i;
      }
    }

    return index + 1;
  }

  /// Split the recurrence rule based on patterns.
  static List<String> splitRule(String text, List<String> patterns) {
    final List<String> result = <String>[];
    int startIndex = 0;
    for (int i = 0; i < text.length; i++) {
      final String charValue = text[i];
      for (int j = 0; j < patterns.length; j++) {
        if (charValue == patterns[j]) {
          result.add(text.substring(startIndex, i));
          startIndex = i + 1;
        }
      }
    }

    if (startIndex != text.length) {
      result.add(text.substring(startIndex, text.length));
    }

    return result;
  }

  /// Returns the date time value of until end date based on given string.
  static DateTime getUntilEndDate(String untilString) {
    /// Checks the time value of T is provided in the until end date value.
    if (untilString.contains('T')) {
      /// Z specifies UTC timezone offset, Checks the time zone is provided in
      /// the until end date value.
      final DateTime endDate = untilString.contains('Z')
          ? DateTime.parse(untilString).toLocal()
          : DateTime.parse(untilString);
      return endDate;
    } else {
      DateTime endDate = DateTime.parse(untilString);
      endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      return endDate;
    }
  }

  /// Returns the recurrence start date for negative recurrence value.
  static DateTime _getRecurrenceDateForNegativeValue(
      int bySetPosCount, DateTime date, int weekDay) {
    DateTime? lastDate;
    if (bySetPosCount == -1) {
      lastDate = AppointmentHelper.getMonthEndDate(date);
    } else if (bySetPosCount == -2) {
      lastDate = AppointmentHelper.getMonthEndDate(date)
          .subtract(const Duration(days: DateTime.daysPerWeek));
    }

    if (lastDate == null) {
      assert(false, 'Invalid position count');
      return date;
    }

    return _getLastWeekDay(
        DateTime(lastDate.year, lastDate.month, lastDate.day, date.hour,
            date.minute, date.second),
        weekDay);
  }

  /// Returns the last week date for the given weekday.
  static DateTime _getLastWeekDay(DateTime date, int dayOfWeek) {
    final DateTime currentDate = date;
    final int currentDateWeek = currentDate.weekday % DateTime.daysPerWeek;
    int otherMonthCount = -currentDateWeek + (dayOfWeek - DateTime.daysPerWeek);
    if (otherMonthCount.abs() >= DateTime.daysPerWeek) {
      otherMonthCount += DateTime.daysPerWeek;
    }

    return currentDate.add(Duration(days: otherMonthCount));
  }

  static String _sortByDay(String byDay) {
    final List<String> sortedDays = <String>[
      'SU',
      'MO',
      'TU',
      'WE',
      'TH',
      'FR',
      'SA'
    ];
    String weeklyDayString = '';
    int count = 0;
    for (int i = 0; i < sortedDays.length; i++) {
      if (!byDay.contains(sortedDays[i])) {
        continue;
      }

      count++;
      String day = sortedDays[i];
      if (count > 1) {
        day = ',$day';
      }

      weeklyDayString = weeklyDayString + day;
    }

    return weeklyDayString;
  }
}
