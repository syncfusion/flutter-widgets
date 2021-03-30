import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';

import '../common/enums.dart' show RecurrenceType, RecurrenceRange, WeekDays;
import 'appointment_helper.dart';
import 'recurrence_properties.dart';

/// Holds the static helper methods used for handling recurrence in calendar.
class RecurrenceHelper {
  /// Check the recurrence appointment in between the visible date range.
  static bool _isRecurrenceInBetweenSpecificRange(DateTime appointmentDate,
      Duration duration, DateTime visibleStartDate, DateTime visibleEndTime) {
    final DateTime appointmentEndDate = addDuration(appointmentDate, duration);

    /// ignore: lines_longer_than_80_chars
    return isDateWithInDateRange(visibleStartDate, visibleEndTime, appointmentDate) ||
        isDateWithInDateRange(
            visibleStartDate, visibleEndTime, appointmentEndDate) ||
        isDateWithInDateRange(
            appointmentDate, appointmentEndDate, visibleStartDate);
  }

  /// Returns the date time collection of recurring appointment.
  static List<DateTime> getRecurrenceDateTimeCollection(
      String rRule, DateTime recurrenceStartDate,
      {Duration? recurrenceDuration,
      DateTime? specificStartDate,
      DateTime? specificEndDate}) {
    if (specificEndDate != null) {
      specificEndDate = DateTime(specificEndDate.year, specificEndDate.month,
          specificEndDate.day, 23, 59, 59);
    }

    recurrenceDuration ??= const Duration();
    final List<DateTime> recDateCollection = <DateTime>[];
    final bool isSpecificDateRange =
        specificStartDate != null && specificEndDate != null;
    final List<String> ruleSeparator = <String>['=', ';', ','];
    const String weeklySeparator = ';';

    final List<String> ruleArray = splitRule(rRule, ruleSeparator);
    int weeklyByDayPos = -1;
    int recCount = 0;
    final List<String> values = _findKeyIndex(ruleArray);
    final String recurCount = values[0];
    final String daily = values[1];
    final String weekly = values[2];
    final String monthly = values[3];
    final String yearly = values[4];
    final String bySetPosCount = values[6];
    final String interval = values[7];
    final String intervalCount = values[8];
    final String untilValue = values[10];
    final String byDay = values[12];
    final String byDayValue = values[13];
    final String byMonthDay = values[14];
    final String byMonthDayCount = values[15];
    final String byMonthCount = values[17];
    final List<String> weeklyRule = rRule.split(weeklySeparator);
    final List<String> weeklyRules = _findWeeklyRule(weeklyRule);
    if (weeklyRules.isNotEmpty) {
      weeklyByDayPos = int.parse(weeklyRules[1]);
    }

    if (ruleArray.isNotEmpty && rRule.isNotEmpty) {
      final int recurrenceStartHour = recurrenceStartDate.hour;
      final int recurrenceStartMinute = recurrenceStartDate.minute;
      final int recurrenceStartSecond = recurrenceStartDate.second;
      DateTime addDate = recurrenceStartDate;
      if (recurCount.isNotEmpty) {
        recCount = int.parse(recurCount);
      }

      DateTime? endDate;
      if (rRule.contains('UNTIL')) {
        endDate = DateTime.parse(untilValue);
        endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 0);
        if (isSpecificDateRange) {
          endDate =
              (endDate.isAfter(specificEndDate) || endDate == specificEndDate)
                  ? specificEndDate
                  : endDate;
        }
      }

      /// NoEndDate specified rule returns empty collection issue fix.
      if (isSpecificDateRange && !rRule.contains('COUNT') && endDate == null) {
        endDate = specificEndDate;
      }

      if (daily == 'DAILY') {
        if (!rRule.contains('BYDAY')) {
          final int dailyDayGap =
              !rRule.contains('INTERVAL') ? 1 : int.parse(intervalCount);
          int tempCount = 0;
          while (tempCount < recCount ||
              (endDate != null &&
                  (addDate.isBefore(endDate) ||
                      isSameDate(addDate, endDate)))) {
            if (isSpecificDateRange) {
              if (_isRecurrenceInBetweenSpecificRange(addDate,
                  recurrenceDuration, specificStartDate, specificEndDate)) {
                recDateCollection.add(addDate);
              }
            } else {
              recDateCollection.add(addDate);
            }

            addDate = AppointmentHelper.addDaysWithTime(
                addDate,
                dailyDayGap,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
            tempCount++;
          }
        } else {
          while (recDateCollection.length < recCount ||
              (endDate != null &&
                  (addDate.isBefore(endDate) || addDate == endDate))) {
            if (addDate.weekday != DateTime.sunday &&
                addDate.weekday != DateTime.saturday) {
              if (isSpecificDateRange) {
                if (_isRecurrenceInBetweenSpecificRange(addDate,
                    recurrenceDuration, specificStartDate, specificEndDate)) {
                  recDateCollection.add(addDate);
                }
              } else {
                recDateCollection.add(addDate);
              }
            }

            addDate = AppointmentHelper.addDaysWithTime(
                addDate,
                1,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
          }
        }
      } else if (weekly == 'WEEKLY') {
        int tempCount = 0;
        final int weeklyWeekGap = ruleArray.length > 4 && interval == 'INTERVAL'
            ? int.parse(intervalCount)
            : 1;
        assert(weeklyByDayPos != -1, 'Invalid weekly recurrence rule');
        final bool isWeeklySelected = weeklyRule[weeklyByDayPos].length > 6;

        /// Below code modified for fixing issue while setting rule as
        /// "FREQ=WEEKLY;COUNT=10;BYDAY=MO" along with specified start and end
        /// dates.
        while ((tempCount < recCount && isWeeklySelected) ||
            (endDate != null &&
                (addDate.isBefore(endDate) || addDate == endDate))) {
          if (isSpecificDateRange) {
            if (_isRecurrenceInBetweenSpecificRange(addDate, recurrenceDuration,
                specificStartDate, specificEndDate)) {
              _setWeeklyRecurrenceDate(
                  addDate, weeklyRule, weeklyByDayPos, recDateCollection);
            }

            if (addDate.isAfter(specificEndDate)) {
              break;
            }
          } else {
            _setWeeklyRecurrenceDate(
                addDate, weeklyRule, weeklyByDayPos, recDateCollection);
          }

          if (_isRecurrenceDate(addDate, weeklyRule, weeklyByDayPos)) {
            tempCount++;
          }

          addDate = addDate.weekday == DateTime.saturday
              ? AppointmentHelper.addDaysWithTime(
                  addDate,
                  ((weeklyWeekGap - 1) * DateTime.daysPerWeek) + 1,
                  recurrenceStartHour,
                  recurrenceStartMinute,
                  recurrenceStartSecond)
              : AppointmentHelper.addDaysWithTime(
                  addDate,
                  1,
                  recurrenceStartHour,
                  recurrenceStartMinute,
                  recurrenceStartSecond);
        }
      } else if (monthly == 'MONTHLY') {
        final int monthlyMonthGap =
            ruleArray.length > 4 && interval == 'INTERVAL'
                ? int.parse(intervalCount)
                : 1;
        if (byMonthDay == 'BYMONTHDAY') {
          final int monthDate = int.parse(byMonthDayCount);
          final int currDate = int.parse(recurrenceStartDate.day.toString());
          final DateTime temp = DateTime(
              addDate.year,
              addDate.month,
              monthDate,
              recurrenceStartHour,
              recurrenceStartMinute,
              recurrenceStartSecond);

          /// Check the month date greater than recurrence start date and the
          /// month have the date value.
          /// Eg., Recurrence start date as Feb 28 and recurrence month day as
          /// 30 then check the 30 greater than 28 and feb have 30 date.
          if (monthDate >= currDate && temp.day == monthDate) {
            addDate = temp;
          } else {
            /// Check the month date less than recurrence start date or the
            /// month does not have the date
            /// Eg., Recurrence start date as Feb 28 and recurrence month day as
            /// 30 and feb 30 does not exist so move the recurrence to next
            /// month and check next month have date 30 if exists then start the
            /// recurrence from mar 30.
            addDate = DateTime(
                addDate.year,
                addDate.month + 1,
                1,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
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
              if (_isRecurrenceInBetweenSpecificRange(addDate,
                  recurrenceDuration, specificStartDate, specificEndDate)) {
                recDateCollection.add(addDate);
              }

              if (addDate.isAfter(specificEndDate)) {
                break;
              }
            } else {
              recDateCollection.add(addDate);
            }

            monthValue += monthlyMonthGap;
            addDate = DateTime(
                yearValue,
                monthValue,
                monthDate,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);

            tempCount++;
          }
        } else if (byDay == 'BYDAY') {
          int tempRecDateCollectionCount = 0;
          while (recDateCollection.length < recCount ||
              (endDate != null &&
                  (addDate.isBefore(endDate) || addDate == endDate))) {
            final DateTime monthStart = DateTime(
                addDate.year,
                addDate.month,
                1,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
            final DateTime weekStartDate = AppointmentHelper.addDaysWithTime(
                monthStart,
                -monthStart.weekday,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
            final int monthStartWeekday = monthStart.weekday;
            final int nthWeekDay = _getWeekDay(byDayValue);
            int nthWeek;
            if (monthStartWeekday <= nthWeekDay) {
              nthWeek = int.parse(bySetPosCount) - 1;
            } else {
              nthWeek = int.parse(bySetPosCount);
            }

            final int bySetPosValue = int.parse(bySetPosCount);
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

            if (addDate.isBefore(recurrenceStartDate)) {
              addDate = DateTime(
                  addDate.year,
                  addDate.month + 1,
                  addDate.day,
                  recurrenceStartHour,
                  recurrenceStartMinute,
                  recurrenceStartSecond);
              continue;
            }

            if (isSpecificDateRange) {
              if (_isRecurrenceInBetweenSpecificRange(addDate,
                      recurrenceDuration, specificStartDate, specificEndDate) &&
                  (tempRecDateCollectionCount < recCount ||
                      rRule.contains('UNTIL'))) {
                recDateCollection.add(addDate);
              }

              if (addDate.isAfter(specificEndDate)) {
                break;
              }
            } else {
              recDateCollection.add(addDate);
            }

            addDate = DateTime(
                addDate.year,
                addDate.month + monthlyMonthGap,
                addDate.day - (addDate.day - 1),
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);

            tempRecDateCollectionCount++;
          }
        }
      } else if (yearly == 'YEARLY') {
        final int yearlyYearGap = ruleArray.length > 4 && interval == 'INTERVAL'
            ? int.parse(intervalCount)
            : 1;
        if (byMonthDay == 'BYMONTHDAY') {
          final int monthIndex = int.parse(byMonthCount);
          final int dayIndex = int.parse(byMonthDayCount);
          if (monthIndex > 0 && monthIndex <= 12) {
            final int bound =
                addDays(DateTime(addDate.year, addDate.month + 1, 1), -1).day;
            if (bound >= dayIndex) {
              final DateTime specificDate = DateTime(
                  addDate.year,
                  monthIndex,
                  dayIndex,
                  recurrenceStartHour,
                  recurrenceStartMinute,
                  recurrenceStartSecond);
              if (specificDate.isBefore(addDate)) {
                addDate = specificDate;
                addDate = DateTime(
                    addDate.year + 1,
                    addDate.month,
                    addDate.day,
                    recurrenceStartHour,
                    recurrenceStartMinute,
                    recurrenceStartSecond);
                if (isSpecificDateRange) {
                  if (_isRecurrenceInBetweenSpecificRange(addDate,
                      recurrenceDuration, specificStartDate, specificEndDate)) {
                    recDateCollection.add(addDate);
                  }
                } else {
                  recDateCollection.add(addDate);
                }
              } else {
                addDate = specificDate;
              }

              int tempCount = 0;
              while (tempCount < recCount ||
                  (endDate != null &&
                      (addDate.isBefore(endDate) || addDate == endDate))) {
                if (!recDateCollection.contains(addDate)) {
                  if (isSpecificDateRange) {
                    if (_isRecurrenceInBetweenSpecificRange(
                        addDate,
                        recurrenceDuration,
                        specificStartDate,
                        specificEndDate)) {
                      recDateCollection.add(addDate);
                    }

                    if (addDate.isAfter(specificEndDate)) {
                      break;
                    }
                  } else {
                    recDateCollection.add(addDate);
                  }
                }

                addDate = DateTime(
                    addDate.year + yearlyYearGap,
                    addDate.month,
                    addDate.day,
                    recurrenceStartHour,
                    recurrenceStartMinute,
                    recurrenceStartSecond);
                tempCount++;
              }
            }
          }
        } else if (byDay == 'BYDAY') {
          final int monthIndex = int.parse(byMonthCount);
          DateTime monthStart = DateTime(
              addDate.year,
              monthIndex,
              1,
              recurrenceStartHour,
              recurrenceStartMinute,
              recurrenceStartSecond);
          DateTime weekStartDate = AppointmentHelper.addDaysWithTime(
              monthStart,
              -monthStart.weekday,
              recurrenceStartHour,
              recurrenceStartMinute,
              recurrenceStartSecond);
          int monthStartWeekday = monthStart.weekday;
          int nthWeekDay = _getWeekDay(byDayValue);
          int nthWeek;
          if (monthStartWeekday <= nthWeekDay) {
            nthWeek = int.parse(bySetPosCount) - 1;
          } else {
            nthWeek = int.parse(bySetPosCount);
          }

          final int bySetPosValue = int.parse(bySetPosCount);
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

          if ((monthStart.month != addDate.month &&
                  monthStart.isBefore(addDate)) ||
              (monthStart.month == addDate.month &&
                  (monthStart.isBefore(addDate) ||
                      monthStart.isBefore(recurrenceStartDate)))) {
            addDate = DateTime(
                addDate.year + 1,
                addDate.month,
                addDate.day,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
            monthStart = DateTime(
                addDate.year,
                monthIndex,
                1,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
            weekStartDate = AppointmentHelper.addDaysWithTime(
                monthStart,
                -monthStart.weekday,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
            monthStartWeekday = monthStart.weekday;
            nthWeekDay = _getWeekDay(byDayValue);
            if (monthStartWeekday <= nthWeekDay) {
              nthWeek = int.parse(bySetPosCount) - 1;
            } else {
              nthWeek = int.parse(bySetPosCount);
            }

            final int bySetPosValue = int.parse(bySetPosCount);
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

            addDate = monthStart;

            if (!recDateCollection.contains(addDate)) {
              if (isSpecificDateRange) {
                if (_isRecurrenceInBetweenSpecificRange(addDate,
                    recurrenceDuration, specificStartDate, specificEndDate)) {
                  recDateCollection.add(addDate);
                }
              } else {
                recDateCollection.add(addDate);
              }
            }
          } else {
            addDate = monthStart;
          }

          int tempCount = 0;
          while (tempCount < recCount ||
              (endDate != null &&
                  (addDate.isBefore(endDate) || addDate == endDate))) {
            if (!recDateCollection.contains(addDate)) {
              if (isSpecificDateRange) {
                if (_isRecurrenceInBetweenSpecificRange(addDate,
                    recurrenceDuration, specificStartDate, specificEndDate)) {
                  recDateCollection.add(addDate);
                }

                if (addDate.isAfter(specificEndDate)) {
                  break;
                }
              } else {
                recDateCollection.add(addDate);
              }
            }

            addDate = DateTime(
                addDate.year + yearlyYearGap,
                addDate.month,
                addDate.day,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);

            monthStart = DateTime(
                addDate.year,
                monthIndex,
                1,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);

            weekStartDate = AppointmentHelper.addDaysWithTime(
                monthStart,
                -monthStart.weekday,
                recurrenceStartHour,
                recurrenceStartMinute,
                recurrenceStartSecond);
            monthStartWeekday = monthStart.weekday;
            nthWeekDay = _getWeekDay(byDayValue);
            if (monthStartWeekday <= nthWeekDay) {
              nthWeek = int.parse(bySetPosCount) - 1;
            } else {
              nthWeek = int.parse(bySetPosCount);
            }

            final int bySetPosValue = int.parse(bySetPosCount);
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

            if (monthStart.month != addDate.month &&
                monthStart.isBefore(addDate)) {
              addDate = monthStart;
              addDate = DateTime(
                  addDate.year + 1,
                  addDate.month,
                  addDate.day,
                  recurrenceStartHour,
                  recurrenceStartMinute,
                  recurrenceStartSecond);
              if (!recDateCollection.contains(addDate)) {
                if (isSpecificDateRange) {
                  if (_isRecurrenceInBetweenSpecificRange(addDate,
                      recurrenceDuration, specificStartDate, specificEndDate)) {
                    recDateCollection.add(addDate);
                  }

                  if (addDate.isAfter(specificEndDate)) {
                    break;
                  }
                } else {
                  recDateCollection.add(addDate);
                }
              }
            } else {
              addDate = monthStart;
            }

            tempCount++;
          }
        }
      }
    }

    return recDateCollection;
  }

  /// Returns the recurrence properties based on the given recurrence rule and
  /// the recurrence start date.
  static RecurrenceProperties parseRRule(String rRule, DateTime recStartDate) {
    final DateTime recurrenceStartDate = recStartDate;
    final RecurrenceProperties recProp =
        RecurrenceProperties(startDate: recStartDate);
    final List<String> ruleSeparator = <String>['=', ';', ','];
    const String weeklySeparator = ';';
    final List<String> ruleArray = splitRule(rRule, ruleSeparator);
    final List<String> weeklyRule = rRule.split(weeklySeparator);
    int weeklyByDayPos = -1;
    int recCount = 0;
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
    if (weeklyRules.isNotEmpty) {
      weeklyByDayPos = int.parse(weeklyRules[1]);
    }

    if (ruleArray.isNotEmpty && rRule.isNotEmpty) {
      DateTime addDate = recurrenceStartDate;
      if (recurCount.isNotEmpty) {
        recCount = int.parse(recurCount);
      }

      if (!rRule.contains('COUNT') && !rRule.contains('UNTIL')) {
        recProp.recurrenceRange = RecurrenceRange.noEndDate;
      } else if (rRule.contains('COUNT')) {
        recProp.recurrenceRange = RecurrenceRange.count;
        recProp.recurrenceCount = recCount;
      } else if (rRule.contains('UNTIL')) {
        recProp.recurrenceRange = RecurrenceRange.endDate;
        DateTime endDate = DateTime.parse(untilValue);
        endDate =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        recProp.endDate = endDate;
      }

      recProp.interval =
          intervalCount.isNotEmpty ? int.parse(intervalCount) : 1;
      if (daily == 'DAILY') {
        recProp.recurrenceType = RecurrenceType.daily;

        if (rRule.contains('BYDAY')) {
          recProp.weekDays = <WeekDays>[
            WeekDays.monday,
            WeekDays.tuesday,
            WeekDays.wednesday,
            WeekDays.thursday,
            WeekDays.friday
          ];
        }
      } else if (weekly == 'WEEKLY') {
        recProp.recurrenceType = RecurrenceType.weekly;
        int i = 0;

        while (i < DateTime.daysPerWeek && weeklyByDayPos != -1) {
          switch (addDate.weekday) {
            case DateTime.sunday:
              {
                if (weeklyRule[weeklyByDayPos].contains('SU')) {
                  recProp.weekDays.add(WeekDays.sunday);
                }

                break;
              }

            case DateTime.monday:
              {
                if (weeklyRule[weeklyByDayPos].contains('MO')) {
                  recProp.weekDays.add(WeekDays.monday);
                }

                break;
              }

            case DateTime.tuesday:
              {
                if (weeklyRule[weeklyByDayPos].contains('TU')) {
                  recProp.weekDays.add(WeekDays.tuesday);
                }

                break;
              }

            case DateTime.wednesday:
              {
                if (weeklyRule[weeklyByDayPos].contains('WE')) {
                  recProp.weekDays.add(WeekDays.wednesday);
                }

                break;
              }

            case DateTime.thursday:
              {
                if (weeklyRule[weeklyByDayPos].contains('TH')) {
                  recProp.weekDays.add(WeekDays.thursday);
                }

                break;
              }

            case DateTime.friday:
              {
                if (weeklyRule[weeklyByDayPos].contains('FR')) {
                  recProp.weekDays.add(WeekDays.friday);
                }

                break;
              }

            case DateTime.saturday:
              {
                if (weeklyRule[weeklyByDayPos].contains('SA')) {
                  recProp.weekDays.add(WeekDays.saturday);
                }

                break;
              }
          }

          addDate = addDate.weekday == 6
              ? addDays(
                  addDate, ((recProp.interval - 1) * DateTime.daysPerWeek) + 1)
              : addDays(addDate, 1);
          i = i + 1;
        }
      } else if (monthly == 'MONTHLY') {
        recProp.recurrenceType = RecurrenceType.monthly;
        if (byMonthDay == 'BYMONTHDAY') {
          recProp.week = 0;
          recProp.dayOfMonth =
              byMonthDayCount.isNotEmpty ? int.parse(byMonthDayCount) : 1;
        } else if (byDay == 'BYDAY') {
          recProp.week =
              bySetPosCount.isNotEmpty ? int.parse(bySetPosCount) : 0;
          recProp.dayOfWeek =
              byDayValue.isNotEmpty ? _getWeekDay(byDayValue) : 1;
        }
      } else if (yearly == 'YEARLY') {
        recProp.recurrenceType = RecurrenceType.yearly;
        if (byMonthDay == 'BYMONTHDAY') {
          recProp.month = byMonthCount.isNotEmpty ? int.parse(byMonthCount) : 1;
          recProp.dayOfMonth =
              byMonthDayCount.isNotEmpty ? int.parse(byMonthDayCount) : 1;
        } else if (byDay == 'BYDAY') {
          recProp.month = byMonthCount.isNotEmpty ? int.parse(byMonthCount) : 1;
          recProp.week =
              bySetPosCount.isNotEmpty ? int.parse(bySetPosCount) : 0;
          recProp.dayOfWeek =
              byDayValue.isNotEmpty ? _getWeekDay(byDayValue) : 1;
        }
      }
    }

    return recProp;
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

      if (recurrenceProperties.weekDays.contains(WeekDays.monday) &&
          recurrenceProperties.weekDays.contains(WeekDays.tuesday) &&
          recurrenceProperties.weekDays.contains(WeekDays.wednesday) &&
          recurrenceProperties.weekDays.contains(WeekDays.thursday) &&
          recurrenceProperties.weekDays.contains(WeekDays.friday)) {
        if (diffTimeSpan.inHours > 24) {
          isValidRecurrence = false;
        }

        rRule = rRule + ';BYDAY=MO,TU,WE,TH,FR';
      } else {
        if (diffTimeSpan.inHours >= recurrenceProperties.interval * 24) {
          isValidRecurrence = false;
        }

        if (recurrenceProperties.interval > 0) {
          rRule =
              rRule + ';INTERVAL=' + recurrenceProperties.interval.toString();
        }
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = rRule + ';COUNT=' + recCount.toString();
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        final DateFormat format = DateFormat('yyyyMMdd');
        rRule = rRule + ';UNTIL=' + format.format(endDate!);
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
      rRule = rRule + ';BYDAY=';
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
            final Duration tempTimeSpan = addDate.difference(prevDate);
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
                        ? byDay + ',' + dayKey
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
                ? byDay + ',' + dayKey
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
        rRule = rRule + ';INTERVAL=' + recurrenceProperties.interval.toString();
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = rRule + ';COUNT=' + recCount.toString();
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        final DateFormat format = DateFormat('yyyyMMdd');
        rRule = rRule + ';UNTIL=' + format.format(endDate!);
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
        rRule =
            rRule + ';BYMONTHDAY=' + recurrenceProperties.dayOfMonth.toString();
      } else {
        final DateTime firstDate =
            addDays(DateTime.now(), -(DateTime.now().weekday - 1));
        final List<String> dayNames =
            List<int>.generate(DateTime.daysPerWeek, (int index) => index)
                .map((int value) => DateFormat(DateFormat.ABBR_WEEKDAY)
                    .format(addDays(firstDate, value)))
                .toList();
        final String byDayString = dayNames[recurrenceProperties.dayOfWeek - 1];

        /// AbbreviatedDayNames will return three digit char, as per the
        /// standard we need to return only first two char for RRule so here
        /// have removed the last char.
        rRule = rRule +
            ';BYDAY=' +
            byDayString.substring(0, byDayString.length - 1).toUpperCase() +
            ';BYSETPOS=' +
            recurrenceProperties.week.toString();
      }

      if (recurrenceProperties.interval > 0) {
        rRule = rRule + ';INTERVAL=' + recurrenceProperties.interval.toString();
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = rRule + ';COUNT=' + recCount.toString();
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        final DateFormat format = DateFormat('yyyyMMdd');
        rRule = rRule + ';UNTIL=' + format.format(endDate!);
      }

      if (DateTime(
                  startDate.year,
                  startDate.month + recurrenceProperties.interval,
                  startDate.day,
                  startDate.hour,
                  startDate.minute,
                  startDate.second)
              .difference(startDate) <
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
        rRule = rRule +
            ';BYMONTHDAY=' +
            recurrenceProperties.dayOfMonth.toString() +
            ';BYMONTH=' +
            recurrenceProperties.month.toString();
      } else {
        final DateTime firstDate =
            addDays(DateTime.now(), -(DateTime.now().weekday - 1));
        final List<String> dayNames =
            List<int>.generate(DateTime.daysPerWeek, (int index) => index)
                .map((int value) => DateFormat(DateFormat.ABBR_WEEKDAY)
                    .format(addDays(firstDate, value)))
                .toList();
        final String byDayString = dayNames[recurrenceProperties.dayOfWeek - 1];

        /// AbbreviatedDayNames will return three digit char, as per the
        /// standard we need to return only first two char for RRule so here
        /// have removed the last char.
        rRule = rRule +
            ';BYDAY=' +
            byDayString.substring(0, byDayString.length - 1).toUpperCase() +
            ';BYMONTH=' +
            recurrenceProperties.month.toString() +
            ';BYSETPOS=' +
            recurrenceProperties.week.toString();
      }

      if (recurrenceProperties.interval > 0) {
        rRule = rRule + ';INTERVAL=' + recurrenceProperties.interval.toString();
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = rRule + ';COUNT=' + recCount.toString();
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        final DateFormat format = DateFormat('yyyyMMdd');
        rRule = rRule + ';UNTIL=' + format.format(endDate!);
      }

      if (DateTime(
                  startDate.year + recurrenceProperties.interval,
                  startDate.month,
                  startDate.day,
                  startDate.hour,
                  startDate.minute,
                  startDate.second)
              .difference(startDate) <
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
    final Duration diffTimeSpan = appEndTime.difference(appStartTime);
    int recCount = 0;
    final DateTime prevDate = DateTime.utc(1);
    final bool isValidRecurrence = true;

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
    final DateTime firstDate =
        addDays(DateTime.now(), -(DateTime.now().weekday - 1));
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

  static bool _isRecurrenceDate(
      DateTime addDate, List<String> weeklyRule, int weeklyByDayPos) {
    bool isRecurrenceDate = false;
    switch (addDate.weekday) {
      case DateTime.sunday:
        {
          if (weeklyRule[weeklyByDayPos].contains('SU')) {
            isRecurrenceDate = true;
          }

          break;
        }

      case DateTime.monday:
        {
          if (weeklyRule[weeklyByDayPos].contains('MO')) {
            isRecurrenceDate = true;
          }

          break;
        }

      case DateTime.tuesday:
        {
          if (weeklyRule[weeklyByDayPos].contains('TU')) {
            isRecurrenceDate = true;
          }

          break;
        }

      case DateTime.wednesday:
        {
          if (weeklyRule[weeklyByDayPos].contains('WE')) {
            isRecurrenceDate = true;
          }

          break;
        }

      case DateTime.thursday:
        {
          if (weeklyRule[weeklyByDayPos].contains('TH')) {
            isRecurrenceDate = true;
          }

          break;
        }

      case DateTime.friday:
        {
          if (weeklyRule[weeklyByDayPos].contains('FR')) {
            isRecurrenceDate = true;
          }

          break;
        }

      case DateTime.saturday:
        {
          if (weeklyRule[weeklyByDayPos].contains('SA')) {
            isRecurrenceDate = true;
          }

          break;
        }
    }

    return isRecurrenceDate;
  }

  static void _setWeeklyRecurrenceDate(
      DateTime addDate,
      List<String> weeklyRule,
      int weeklyByDayPos,
      List<DateTime> recDateCollection) {
    switch (addDate.weekday) {
      case DateTime.sunday:
        {
          if (weeklyRule[weeklyByDayPos].contains('SU')) {
            recDateCollection.add(addDate);
          }

          break;
        }

      case DateTime.monday:
        {
          if (weeklyRule[weeklyByDayPos].contains('MO')) {
            recDateCollection.add(addDate);
          }

          break;
        }

      case DateTime.tuesday:
        {
          if (weeklyRule[weeklyByDayPos].contains('TU')) {
            recDateCollection.add(addDate);
          }

          break;
        }

      case DateTime.wednesday:
        {
          if (weeklyRule[weeklyByDayPos].contains('WE')) {
            recDateCollection.add(addDate);
          }

          break;
        }

      case DateTime.thursday:
        {
          if (weeklyRule[weeklyByDayPos].contains('TH')) {
            recDateCollection.add(addDate);
          }

          break;
        }

      case DateTime.friday:
        {
          if (weeklyRule[weeklyByDayPos].contains('FR')) {
            recDateCollection.add(addDate);
          }

          break;
        }

      case DateTime.saturday:
        {
          if (weeklyRule[weeklyByDayPos].contains('SA')) {
            recDateCollection.add(addDate);
          }

          break;
        }
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
          .subtract(Duration(days: DateTime.daysPerWeek));
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
    final int currentDateWeek = currentDate.weekday;
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
        day = ',' + day;
      }

      weeklyDayString = weeklyDayString + day;
    }

    return weeklyDayString;
  }
}
