import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'date_picker_manager.dart';
import 'hijri_date_picker_manager.dart';

// ignore: avoid_classes_with_only_static_members
/// Holds the static helper methods of the date picker.
class DateRangePickerHelper {
  /// Return the index value based on RTL.
  static int getRtlIndex(int count, int index) {
    return count - index - 1;
  }

  /// Calculate the visible dates count based on picker view
  static int getViewDatesCount(
      DateRangePickerView pickerView, int numberOfWeeks, bool isHijri) {
    if (pickerView == DateRangePickerView.month) {
      if (isHijri) {
        /// 6 used to render the  default number of weeks, since, Hijri type
        /// doesn't support number of weeks in view.
        return DateTime.daysPerWeek * 6;
      } else {
        return DateTime.daysPerWeek * numberOfWeeks;
      }
    }

    return 0;
  }

  /// Checks both the ranges are equal or not.
  static bool isRangeEquals(dynamic range1, dynamic range2) {
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

  /// Checks both the range collections are equal or not.
  static bool isDateRangesEquals(
      List<dynamic>? rangeCollection1, List<dynamic>? rangeCollection2) {
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
        (rangeCollection1?.length != rangeCollection2?.length)) {
      return false;
    }

    for (int i = 0; i < rangeCollection1!.length; i++) {
      if (!isRangeEquals(rangeCollection1[i], rangeCollection2![i])) {
        return false;
      }
    }

    return true;
  }

  /// Calculate the next view visible start date based on picker view.
  static dynamic getNextViewStartDate(DateRangePickerView pickerView,
      int numberOfWeeksInView, dynamic date, bool isRtl, bool isHijri) {
    if (isRtl) {
      return getPreviousViewStartDate(
          pickerView, numberOfWeeksInView, date, false, isHijri);
    }

    switch (pickerView) {
      case DateRangePickerView.month:
        {
          return isHijri || numberOfWeeksInView == 6
              ? getNextMonthDate(date)
              : addDays(date, numberOfWeeksInView * DateTime.daysPerWeek);
        }
      case DateRangePickerView.year:
        {
          return getNextYearDate(date, 1, isHijri);
        }
      case DateRangePickerView.decade:
        {
          return getNextYearDate(date, 10, isHijri);
        }
      case DateRangePickerView.century:
        {
          return getNextYearDate(date, 100, isHijri);
        }
    }
  }

  /// Calculate the previous view visible start date based on calendar view.
  static dynamic getPreviousViewStartDate(DateRangePickerView pickerView,
      int numberOfWeeksInView, dynamic date, bool isRtl, bool isHijri) {
    if (isRtl) {
      return getNextViewStartDate(
          pickerView, numberOfWeeksInView, date, false, isHijri);
    }

    switch (pickerView) {
      case DateRangePickerView.month:
        {
          return isHijri || numberOfWeeksInView == 6
              ? getPreviousMonthDate(date)
              : addDays(date, -numberOfWeeksInView * DateTime.daysPerWeek);
        }
      case DateRangePickerView.year:
        {
          return getPreviousYearDate(date, 1, isHijri);
        }
      case DateRangePickerView.decade:
        {
          return getPreviousYearDate(date, 10, isHijri);
        }
      case DateRangePickerView.century:
        {
          return getPreviousYearDate(date, 100, isHijri);
        }
    }
  }

  /// Return the next view date of year view based on it offset value.
  /// offset value as 1 for year view, 10 for decade view and 100 for
  /// century view.
  static dynamic getNextYearDate(dynamic date, int offset, bool isHijri) {
    return getDate(((date.year ~/ offset) * offset) + offset, 1, 1, isHijri);
  }

  /// Return the previous view date of year view based on it offset value.
  /// offset value as 1 for year view, 10 for decade view and 100 for
  /// century view.
  static dynamic getPreviousYearDate(dynamic date, int offset, bool isHijri) {
    return getDate(((date.year ~/ offset) * offset) - offset, 1, 1, isHijri);
  }

  /// Return the month start date.
  static dynamic getMonthStartDate(dynamic date, bool isHijri) {
    return getDate(date.year, date.month, 1, isHijri);
  }

  /// Return the month end date.
  static dynamic getMonthEndDate(dynamic date) {
    return addDays(getNextMonthDate(date), -1);
  }

  /// Return the index of the date in collection.
  static int isDateIndexInCollection(List<dynamic>? dates, dynamic date) {
    if (dates == null || date == null) {
      return -1;
    }

    for (int i = 0; i < dates.length; i++) {
      final dynamic visibleDate = dates[i];
      if (isSameDate(visibleDate, date)) {
        return i;
      }
    }

    return -1;
  }

  /// Checks both the date collection are equal or not.
  static bool isDateCollectionEquals(
      List<dynamic>? datesCollection1, List<dynamic>? datesCollection2) {
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
        (datesCollection1?.length != datesCollection2?.length)) {
      return false;
    }

    for (int i = 0; i < datesCollection1!.length; i++) {
      if (!isSameDate(datesCollection1[i], datesCollection2![i])) {
        return false;
      }
    }

    return true;
  }

  /// Check the date as enable date or disable date based on min date, max date
  /// and enable past dates values.
  static bool isEnabledDate(dynamic startDate, dynamic endDate,
      bool enablePastDates, dynamic date, bool isHijri) {
    return isDateWithInDateRange(startDate, endDate, date) &&
        (enablePastDates ||
            (!enablePastDates &&
                isDateWithInDateRange(getToday(isHijri), endDate, date)));
  }

  /// Return the first date of the month, year and decade based on view.
  /// Note: This method not applicable for month view.
  static dynamic getFirstDate(
      dynamic date, bool isHijri, DateRangePickerView pickerView) {
    if (pickerView == DateRangePickerView.month) {
      return date;
    }

    if (pickerView == DateRangePickerView.year) {
      return DateRangePickerHelper.getDate(date.year, date.month, 1, isHijri);
    } else if (pickerView == DateRangePickerView.decade) {
      return DateRangePickerHelper.getDate(date.year, 1, 1, isHijri);
    } else if (pickerView == DateRangePickerView.century) {
      return DateRangePickerHelper.getDate(
          (date.year ~/ 10) * 10, 1, 1, isHijri);
    }

    return date;
  }

  /// Check the date as enable date or disable date based on range start,
  /// end date and extendable range selection direction.
  /// is in between enabled used to enable the in between dates on selected
  /// range while draw the cell.
  static bool isDisableDirectionDate(
      dynamic range,
      dynamic currentDate,
      ExtendableRangeSelectionDirection extendableRangeSelectionDirection,
      DateRangePickerView view,
      bool isHijri,
      {bool isInBetweenEnabled = false}) {
    if (range == null) {
      return false;
    }

    if (range.startDate == null) {
      return false;
    }

    final dynamic startDate = getFirstDate(range.startDate, isHijri, view);
    final dynamic endDate = range.endDate != null
        ? getFirstDate(range.endDate, isHijri, view)
        : startDate;
    final dynamic currentDateValue = getFirstDate(currentDate, isHijri, view);
    switch (extendableRangeSelectionDirection) {
      case ExtendableRangeSelectionDirection.none:
        return !isSameCellDates(startDate, endDate, view) &&
            (!isInBetweenEnabled ||
                (isInBetweenEnabled &&
                    ((startDate.isAfter(currentDateValue) == true &&
                            !isSameCellDates(
                                startDate, currentDateValue, view)) ||
                        (endDate.isBefore(currentDateValue) == true &&
                            !isSameCellDates(
                                endDate, currentDateValue, view)))));
      case ExtendableRangeSelectionDirection.forward:
        return startDate.isAfter(currentDateValue) == true &&
            !isSameCellDates(startDate, currentDateValue, view);
      case ExtendableRangeSelectionDirection.backward:
        return endDate.isBefore(currentDateValue) == true &&
            !isSameCellDates(endDate, currentDateValue, view);
      case ExtendableRangeSelectionDirection.both:
        return false;
    }
  }

  /// Check the date as current month date.
  static bool isDateAsCurrentMonthDate(dynamic visibleDate, int rowCount,
      bool showLeadingAndTrialingDates, dynamic date, bool isHijri) {
    if ((rowCount == 6 && !showLeadingAndTrialingDates || isHijri) &&
        date.month != visibleDate.month) {
      return false;
    }

    return true;
  }

  /// Return the updated left and top value based cell width and height and
  /// total width and height.
  static Map<String, double> getTopAndLeftValues(bool isRtl, double left,
      double top, double cellWidth, double cellHeight, double width) {
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

  /// Check the date placed in dates collection based on visible dates.
  static bool isDateWithInVisibleDates(
      List<dynamic> visibleDates, List<dynamic>? dates, dynamic date) {
    if (dates == null || dates.isEmpty) {
      return false;
    }

    final dynamic visibleStartDate = visibleDates[0];
    final dynamic visibleEndDate = visibleDates[visibleDates.length - 1];
    for (final dynamic currentDate in dates) {
      if (!isDateWithInDateRange(
          visibleStartDate, visibleEndDate, currentDate)) {
        continue;
      }

      if (isSameDate(currentDate, date)) {
        return true;
      }
    }

    return false;
  }

  /// Check the date week day placed in week end day collection.
  static bool isWeekend(List<int>? weekendIndex, dynamic date) {
    if (weekendIndex == null || weekendIndex.isEmpty) {
      return false;
    }

    return weekendIndex.contains(date.weekday);
  }

  /// Check the left side view have valid dates based on widget direction.
  static bool canMoveToPreviousViewRtl(
      DateRangePickerView view,
      int numberOfWeeksInView,
      dynamic minDate,
      dynamic maxDate,
      List<dynamic> visibleDates,
      bool isRtl,
      bool enableMultiView,
      bool isHijri) {
    if (isRtl) {
      return canMoveToNextView(view, numberOfWeeksInView, maxDate, visibleDates,
          enableMultiView, isHijri);
    } else {
      return canMoveToPreviousView(view, numberOfWeeksInView, minDate,
          visibleDates, enableMultiView, isHijri);
    }
  }

  /// Check the right side view have valid dates based on widget direction.
  static bool canMoveToNextViewRtl(
      DateRangePickerView view,
      int numberOfWeeksInView,
      dynamic minDate,
      dynamic maxDate,
      List<dynamic> visibleDates,
      bool isRtl,
      bool enableMultiView,
      bool isHijri) {
    if (isRtl) {
      return canMoveToPreviousView(view, numberOfWeeksInView, minDate,
          visibleDates, enableMultiView, isHijri);
    } else {
      return canMoveToNextView(view, numberOfWeeksInView, maxDate, visibleDates,
          enableMultiView, isHijri);
    }
  }

  /// Check the previous view have enabled dates or not.
  static bool canMoveToPreviousView(
      DateRangePickerView view,
      int numberOfWeeksInView,
      dynamic minDate,
      List<dynamic> visibleDates,
      bool enableMultiView,
      bool isHijri) {
    switch (view) {
      case DateRangePickerView.month:
        {
          if (numberOfWeeksInView != 6 && !isHijri) {
            DateTime prevViewDate =
                DateRangePickerHelper.getDateTimeValue(visibleDates[0]);
            prevViewDate = DateRangePickerHelper.getDateTimeValue(
                addDays(prevViewDate, -1));
            if (!isSameOrAfterDate(minDate, prevViewDate)) {
              return false;
            }
          } else {
            final dynamic currentDate =
                visibleDates[visibleDates.length ~/ (enableMultiView ? 4 : 2)];
            final dynamic previousDate = getPreviousMonthDate(currentDate);
            if ((previousDate.month < minDate.month == true &&
                    previousDate.year == minDate.year) ||
                previousDate.year < minDate.year == true) {
              return false;
            }
          }
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          final int currentYear =
              visibleDates[visibleDates.length ~/ (enableMultiView ? 4 : 2)]
                  .year as int;
          final int minYear = minDate.year as int;

          final int offset = getOffset(view);
          if (((currentYear ~/ offset) * offset) - offset <
              ((minYear ~/ offset) * offset)) {
            return false;
          }
        }
    }

    return true;
  }

  /// Return the year view offset based on picker view(year, decade, century).
  static int getOffset(dynamic view) {
    final DateRangePickerView pickerView = getPickerView(view);
    switch (pickerView) {
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

  /// Get the visible dates based on the date value and visible dates count.
  // ignore: always_specify_types
  static List getVisibleYearDates(
      dynamic date, DateRangePickerView view, bool isHijri) {
    // ignore: always_specify_types
    List datesCollection;
    if (isHijri) {
      datesCollection = <HijriDateTime>[];
    } else {
      datesCollection = <DateTime>[];
    }

    dynamic currentDate;
    const int daysCount = 12;
    switch (view) {
      case DateRangePickerView.month:
        break;
      case DateRangePickerView.year:
        {
          for (int i = 1; i <= daysCount; i++) {
            currentDate = getDate(date.year, i, 1, isHijri);
            datesCollection.add(currentDate);
          }
        }
        break;
      case DateRangePickerView.decade:
        {
          final int year = ((date.year as int) ~/ 10) * 10;

          for (int i = 0; i < daysCount; i++) {
            currentDate = getDate(year + i, 1, 1, isHijri);
            datesCollection.add(currentDate);
          }
        }
        break;
      case DateRangePickerView.century:
        {
          final int year = ((date.year as int) ~/ 100) * 100;
          for (int i = 0; i < daysCount; i++) {
            currentDate = getDate(year + (i * 10), 1, 1, isHijri);

            datesCollection.add(currentDate);
          }
        }
    }

    return datesCollection;
  }

  /// Check the next view have enabled dates or not.
  static bool canMoveToNextView(
      DateRangePickerView view,
      int numberOfWeeksInView,
      dynamic maxDate,
      List<dynamic> visibleDates,
      bool enableMultiView,
      bool isHijri) {
    switch (view) {
      case DateRangePickerView.month:
        {
          if (!isHijri && numberOfWeeksInView != 6) {
            DateTime nextViewDate = DateRangePickerHelper.getDateTimeValue(
                visibleDates[visibleDates.length - 1]);
            nextViewDate = DateRangePickerHelper.getDateTimeValue(
                addDays(nextViewDate, 1));
            if (!isSameOrBeforeDate(maxDate, nextViewDate)) {
              return false;
            }
          } else {
            final dynamic currentDate =
                visibleDates[visibleDates.length ~/ (enableMultiView ? 4 : 2)];
            final dynamic nextDate = getNextMonthDate(currentDate);
            if ((nextDate.month > maxDate.month == true &&
                    nextDate.year == maxDate.year) ||
                nextDate.year > maxDate.year == true) {
              return false;
            }
          }
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          final int currentYear =
              visibleDates[visibleDates.length ~/ (enableMultiView ? 4 : 2)]
                  .year as int;
          final int maxYear = maxDate.year as int;
          final int offset = getOffset(view);
          if (((currentYear ~/ offset) * offset) + offset >
              ((maxYear ~/ offset) * offset)) {
            return false;
          }
        }
    }
    return true;
  }

  /// Return the copy of the list.
  static List<dynamic>? cloneList(List<dynamic>? value) {
    if (value == null) {
      return value;
    }

    return value.sublist(0);
  }

  /// Determine the current platform is mobile platform(android or iOS).
  static bool isMobileLayout(TargetPlatform platform) {
    if (kIsWeb) {
      return false;
    }

    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  }

  /// Returns the corresponding hijri month date, for the date passed with the
  /// given month format and localization.
  static String getHijriMonthText(
      dynamic date, SfLocalizations localizations, String format) {
    if (date.month == 1) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortMuharramLabel;
      }
      return localizations.muharramLabel;
    } else if (date.month == 2) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortSafarLabel;
      }
      return localizations.safarLabel;
    } else if (date.month == 3) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortRabi1Label;
      }
      return localizations.rabi1Label;
    } else if (date.month == 4) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortRabi2Label;
      }
      return localizations.rabi2Label;
    } else if (date.month == 5) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortJumada1Label;
      }
      return localizations.jumada1Label;
    } else if (date.month == 6) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortJumada2Label;
      }
      return localizations.jumada2Label;
    } else if (date.month == 7) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortRajabLabel;
      }
      return localizations.rajabLabel;
    } else if (date.month == 8) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortShaabanLabel;
      }

      return localizations.shaabanLabel;
    } else if (date.month == 9) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortRamadanLabel;
      }

      return localizations.ramadanLabel;
    } else if (date.month == 10) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortShawwalLabel;
      }
      return localizations.shawwalLabel;
    } else if (date.month == 11) {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortDhualqiLabel;
      }
      return localizations.dhualqiLabel;
    } else {
      if (format == 'M' || format == 'MM') {
        return date.month.toString();
      } else if (format == 'MMM') {
        return localizations.shortDhualhiLabel;
      }
      return localizations.dhualhiLabel;
    }
  }

  /// Returns teh [DateRangePickerView] value based on the given value.
  static DateRangePickerView getPickerView(dynamic view) {
    if (view is DateRangePickerView) {
      return view;
    }

    switch (view) {
      case HijriDatePickerView.month:
        {
          return DateRangePickerView.month;
        }
      case HijriDatePickerView.year:
        {
          return DateRangePickerView.year;
        }
      case HijriDatePickerView.decade:
        {
          return DateRangePickerView.decade;
        }
    }

    return DateRangePickerView.month;
  }

  /// Returns teh [HijriDatePickerView] value based on the given value.
  static HijriDatePickerView getHijriPickerView(dynamic view) {
    if (view is HijriDatePickerView) {
      return view;
    }

    switch (view) {
      case DateRangePickerView.month:
        {
          return HijriDatePickerView.month;
        }
      case DateRangePickerView.year:
        {
          return HijriDatePickerView.year;
        }
      case DateRangePickerView.decade:
        {
          return HijriDatePickerView.decade;
        }
      case DateRangePickerView.century:
        {
          return HijriDatePickerView.decade;
        }
    }

    return HijriDatePickerView.month;
  }

  /// Returns the number of weeks in view for the picker.
  static int getNumberOfWeeksInView(dynamic monthViewSettings, bool isHijri) {
    if (isHijri) {
      return 6;
    }

    return monthViewSettings.numberOfWeeksInView as int;
  }

  /// Determines whether the leading and trailing dates can be shown or not.
  static bool canShowLeadingAndTrailingDates(
      dynamic monthViewSettings, bool isHijri) {
    if (isHijri) {
      return false;
    }

    return monthViewSettings.showTrailingAndLeadingDates == true;
  }

  /// Returns the today date value.
  static dynamic getToday(bool isHijri) {
    if (isHijri) {
      return HijriDateTime.now();
    }

    return DateTime.now();
  }

  /// Returns the required date with the given parameter values.
  static dynamic getDate(int year, int month, int day, bool isHijri) {
    if (isHijri) {
      return HijriDateTime(year, month, day);
    }

    return DateTime(year, month, day);
  }

  /// Check both the dates are placed on same year, decade, century cell.
  /// Eg., In year view, 20-01-2020 and 21-01-2020 dates are not equal but
  /// both the dates are placed in same year cell.
  /// Note: This method not applicable for month view.
  static bool isSameCellDates(dynamic date, dynamic currentDate, dynamic view) {
    if (date == null || currentDate == null) {
      return false;
    }

    final DateRangePickerView pickerView = getPickerView(view);
    if (pickerView == DateRangePickerView.month) {
      return isSameDate(date, currentDate);
    }

    if (pickerView == DateRangePickerView.year) {
      return date.month == currentDate.month && date.year == currentDate.year;
    } else if (pickerView == DateRangePickerView.decade) {
      return date.year == currentDate.year;
    } else if (pickerView == DateRangePickerView.century) {
      return date.year ~/ 10 == currentDate.year ~/ 10;
    }

    return false;
  }

  /// Check the year cell index date as leading date or not.
  /// Eg., Decade view holds 12 cells(2020 - 2031) and it have leading decade
  /// view dates(2030 and 2031). The below method used to identify the date
  /// as leading date or not.
  /// Note: This method not applicable for month view.
  static bool isLeadingCellDate(
      int index, int viewStartIndex, List<dynamic> visibleDates, dynamic view) {
    final DateRangePickerView pickerView = getPickerView(view);
    if (pickerView == DateRangePickerView.month ||
        pickerView == DateRangePickerView.year) {
      return false;
    }

    final dynamic currentDate = visibleDates[index];
    final dynamic viewStartDate = visibleDates[viewStartIndex];

    if (pickerView == DateRangePickerView.decade) {
      return currentDate.year ~/ 10 != viewStartDate.year ~/ 10;
    } else if (pickerView == DateRangePickerView.century) {
      return currentDate.year ~/ 100 != viewStartDate.year ~/ 100;
    }

    return false;
  }

  /// Check the date is enabled or not based on min and max date value.
  /// If picker max date as 20-12-2020 and selected date value as 21-12-2020
  /// then the year view need to highlight selection because year view only
  /// consider the month value(max month as 12).
  /// Note: This method not applicable for month view.
  static bool isBetweenMinMaxDateCell(dynamic date, dynamic minDate,
      dynamic maxDate, bool enablePastDates, dynamic view, bool isHijri) {
    if (date == null || minDate == null || maxDate == null) {
      return true;
    }

    final DateRangePickerView pickerView = getPickerView(view);
    if (pickerView == DateRangePickerView.month) {
      return false;
    }

    final dynamic today = getToday(isHijri);
    if (pickerView == DateRangePickerView.year) {
      return ((date.month >= minDate.month == true &&
                  date.year == minDate.year) ||
              date.year > minDate.year == true) &&
          ((date.month <= maxDate.month == true && date.year == maxDate.year) ||
              date.year < maxDate.year == true) &&
          (enablePastDates ||
              (!enablePastDates &&
                  ((date.month >= today.month == true &&
                          date.year == today.year) ||
                      date.year > today.year == true)));
    } else if (pickerView == DateRangePickerView.decade) {
      return date.year >= minDate.year == true &&
          date.year <= maxDate.year == true &&
          (enablePastDates ||
              (!enablePastDates && date.year >= today.year == true));
    } else if (pickerView == DateRangePickerView.century) {
      final int currentYear = (date.year as int) ~/ 10;
      return currentYear >= (minDate.year ~/ 10) &&
          currentYear <= (maxDate.year ~/ 10) &&
          (enablePastDates ||
              (!enablePastDates && currentYear >= today.year ~/ 10));
    }

    return false;
  }

  /// Return the last date of the month, year and decade based on view.
  /// Eg., If picker view is year and the date value as 20-01-2020 then
  /// it return the last date of the month(31-01-2020).
  /// Note: This method not applicable for month view.
  static dynamic getLastDate(dynamic date, dynamic view, bool isHijri) {
    final DateRangePickerView pickerView = getPickerView(view);
    if (pickerView == DateRangePickerView.month) {
      return date;
    }

    if (pickerView == DateRangePickerView.year) {
      final dynamic currentDate =
          getDate(date.year, date.month + 1, 1, isHijri);
      return addDays(currentDate, -1);
    } else if (pickerView == DateRangePickerView.decade) {
      final dynamic currentDate = getDate(date.year + 1, 1, 1, isHijri);
      return addDays(currentDate, -1);
    } else if (pickerView == DateRangePickerView.century) {
      final dynamic currentDate =
          getDate(((date.year ~/ 10) * 10) + 10, 1, 1, isHijri);
      return addDays(currentDate, -1);
    }

    return date;
  }

  /// Return index of the date value in dates collection.
  /// Return -1 when the date does not exist in dates collection.
  static int getDateCellIndex(List<dynamic> dates, dynamic date, dynamic view,
      {int viewStartIndex = -1, int viewEndIndex = -1}) {
    if (date == null) {
      return -1;
    }

    final DateRangePickerView pickerView = getPickerView(view);
    viewStartIndex = viewStartIndex == -1 ? 0 : viewStartIndex;
    viewEndIndex = viewEndIndex == -1 ? dates.length - 1 : viewEndIndex;
    for (int i = viewStartIndex; i <= viewEndIndex; i++) {
      final dynamic currentDate = dates[i];
      if (isSameCellDates(date, currentDate, pickerView)) {
        return i;
      }
    }

    return -1;
  }

  /// Converts the given dynamic data into date time data.
  static DateTime getDateTimeValue(dynamic date) {
    late final DateTime dateTimeData;
    if (date is DateTime) {
      dateTimeData = date;
    }

    return dateTimeData;
  }

  /// Check the showWeekNumber is true or not and returns the position.
  static double getWeekNumberPanelWidth(
      bool showWeekNumber, double width, bool isMobilePlatform) {
    return showWeekNumber
        ? (width / (DateTime.daysPerWeek + 1)) / (isMobilePlatform ? 1.3 : 4)
        : 0;
  }

  /// Returns week number for the given date.
  static int getWeekNumberOfYear(dynamic date, bool isHijri) {
    final dynamic yearEndDate = isHijri
        ? HijriDateTime(date.year - 1, 12, 31)
        : DateTime(date.year - 1, 12, 31);
    final int dayOfYear = date.difference(yearEndDate).inDays as int;
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

  /// Draws the dashed line between given x positions.
  static void drawDashedLine(double xPosition, double yPosition,
      double endXPosition, Canvas canvas, Paint painter) {
    const double dashWidth = 4, dashSpace = 5;
    while (xPosition < endXPosition) {
      canvas.drawLine(Offset(xPosition, yPosition),
          Offset(xPosition + dashWidth, yPosition), painter);
      xPosition += dashWidth + dashSpace;
    }
  }

  /// Returns the dashed path for teh given path
  static Path getDashedPath(Path sourcePath, bool isStartRange, bool isEndRange,
      bool isRectSelection) {
    final Path dashedPath = Path();
    final List<double> array = <double>[6, 5];
    final List<PathMetric> sourceMetrics = sourcePath.computeMetrics().toList();
    final Rect sourceRect = sourcePath.getBounds();
    final double restrictXPosition = isRectSelection
        ? isStartRange
            ? sourceRect.right
            : sourceRect.left
        : -1;
    for (int i = 0; i < sourceMetrics.length; i++) {
      final PathMetric metric = sourceMetrics[i];
      double distance = 0;
      bool canDrawPath = true;
      int j = 0;
      while (distance < metric.length) {
        final double length = array[j];
        if (canDrawPath) {
          final Path extractedPath =
              metric.extractPath(distance, distance + length);
          final Rect extractedRect = extractedPath.getBounds();
          if ((isStartRange && extractedRect.right != restrictXPosition) ||
              (isEndRange && extractedRect.left != restrictXPosition)) {
            dashedPath.addPath(extractedPath, Offset.zero);
          }
        }
        distance += length;
        canDrawPath = !canDrawPath;
        if (j + 1 >= array.length) {
          j = 0;
        } else {
          j = j + 1;
        }
      }
    }

    return dashedPath;
  }
}

/// Holds the hovering data details
class HoveringDetails {
  /// Create instance of hovering details.
  HoveringDetails(this.hoveringRange, this.offset);

  /// Holds the current hovering range for extendable range selection
  final dynamic hoveringRange;

  /// Current hovering offset.
  final Offset? offset;
}

/// args to update the required properties from picker state to it's children's
class PickerStateArgs {
  /// Holds the current view display date.
  dynamic currentDate;

  /// Holds the current view visible dates.
  List<dynamic> currentViewVisibleDates = <dynamic>[];

  /// Holds the current selected date.
  dynamic selectedDate;

  /// Holds the current selected dates.
  List<dynamic>? selectedDates;

  /// Holds the current selected range.
  dynamic selectedRange;

  /// Holds the current selected ranges.
  List<dynamic>? selectedRanges;

  /// Holds the current picker view.
  DateRangePickerView view = DateRangePickerView.month;

  /// clone this picker state args with new instance
  PickerStateArgs clone() {
    return PickerStateArgs()
      ..currentViewVisibleDates = currentViewVisibleDates
      ..currentDate = currentDate
      ..view = view
      ..selectedDate = selectedDate
      ..selectedDates = selectedDates
      ..selectedRange = selectedRange
      ..selectedRanges = selectedRanges;
  }
}
