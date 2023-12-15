import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:timezone/timezone.dart';

import '../common/calendar_view_helper.dart';
import '../common/date_time_engine.dart';
import '../common/enums.dart';
import '../sfcalendar.dart';
import 'appointment.dart';
import 'calendar_datasource.dart';
import 'recurrence_helper.dart';

// ignore: avoid_classes_with_only_static_members
/// Holds the static helper methods used for appointment rendering in calendar.
class AppointmentHelper {
  /// Return the date with start time value for the date value.
  static DateTime convertToStartTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Return the date with end time value for the date value.
  static DateTime convertToEndTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Return the start date of the month specified in date.
  static DateTime getMonthStartDate(DateTime date) {
    return DateTime(date.year, date.month);
  }

  /// Return the end date of the month specified in date.
  static DateTime getMonthEndDate(DateTime date) {
    return DateTimeHelper.getDateTimeValue(addDays(getNextMonthDate(date), -1));
  }

  /// Return the difference duration between two date time values without
  /// daylight savings.
  static Duration getDifference(DateTime startDate, DateTime endDate) {
    final Duration duration = endDate.difference(startDate);
    if (startDate.timeZoneOffset == endDate.timeZoneOffset) {
      return duration;
    }

    return duration + (endDate.timeZoneOffset - startDate.timeZoneOffset);
  }

  /// Return the date time value by adding the days in date.
  static DateTime addDaysWithTime(
      DateTime date, int days, int hour, int minute, int second) {
    final DateTime newDate =
        DateTimeHelper.getDateTimeValue(addDays(date, days));
    return DateTime(
        newDate.year, newDate.month, newDate.day, hour, minute, second);
  }

  /// Check whether the data source has calendar appointment type or not.
  static bool isCalendarAppointment(CalendarDataSource dataSource) {
    if (dataSource.appointments == null ||
        dataSource.appointments!.isEmpty ||
        dataSource.appointments![0] is CalendarAppointment) {
      return true;
    }

    return false;
  }

  static bool _isSpanned(CalendarAppointment appointment) {
    return !(appointment.actualEndTime.day == appointment.actualStartTime.day &&
            appointment.actualEndTime.month ==
                appointment.actualStartTime.month &&
            appointment.actualEndTime.year ==
                appointment.actualStartTime.year) &&
        getDifference(appointment.actualStartTime, appointment.actualEndTime)
                .inDays >
            0;
  }

  /// Check and returns whether the span icon can be added for the spanning
  /// appointment.
  static bool canAddSpanIcon(List<DateTime> visibleDates,
      CalendarAppointment appointment, CalendarView view,
      {DateTime? visibleStartDate,
      DateTime? visibleEndDate,
      bool? showTrailingLeadingDates}) {
    final DateTime viewStartDate = convertToStartTime(visibleDates[0]);
    final DateTime viewEndDate =
        convertToEndTime(visibleDates[visibleDates.length - 1]);
    final DateTime appStartTime = appointment.exactStartTime;
    final DateTime appEndTime = appointment.exactEndTime;

    if (appStartTime.isBefore(viewStartDate) ||
        appEndTime.isAfter(viewEndDate)) {
      return true;
    }

    switch (view) {
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
      case CalendarView.schedule:
        break;
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          return getDifference(appStartTime, appEndTime).inDays <= 0 &&
              appStartTime.day != appEndTime.day &&
              appEndTime.hour != 0;
        }
      case CalendarView.month:
        {
          if (showTrailingLeadingDates != null &&
              !showTrailingLeadingDates &&
              (appStartTime.isBefore(visibleStartDate!) ||
                  appEndTime.isAfter(visibleEndDate!))) {
            return true;
          }

          if (appStartTime.isAfter(viewStartDate)) {
            final int appointmentStartWeek =
                getDifference(viewStartDate, appStartTime).inDays ~/
                    DateTime.daysPerWeek;
            final int appointmentEndWeek =
                getDifference(viewStartDate, appEndTime).inDays ~/
                    DateTime.daysPerWeek;
            return appointmentStartWeek != appointmentEndWeek;
          }
        }
    }

    return false;
  }

  /// Returns recurrence icon details for appointment view.
  static TextSpan getRecurrenceIcon(
      Color color, double textSize, bool isRecurrenceAppointment) {
    final IconData recurrenceIconData =
        isRecurrenceAppointment ? Icons.autorenew : Icons.sync_disabled;
    return TextSpan(
        text: String.fromCharCode(recurrenceIconData.codePoint),
        style: TextStyle(
          color: color,
          fontSize: textSize,
          fontFamily: recurrenceIconData.fontFamily,
        ));
  }

  /// Calculate and returns the centered y position for the span icon in the
  /// spanning appointment UI.
  static double getYPositionForSpanIcon(
      TextSpan icon, TextPainter textPainter, RRect rect) {
    /// There is a space around the font, hence to get the start position we
    /// must calculate the icon start position, apart from the space, and the
    /// value 1.5 used since the space on top and bottom of icon is not even,
    /// hence to rectify this tha value 1.5 used, and tested with multiple
    /// device.
    final int iconStartPosition = (textPainter.height -
            (icon.style!.fontSize! * textPainter.textScaleFactor)) ~/
        1.5;
    return rect.top -
        ((textPainter.height - rect.height) / 2) -
        iconStartPosition;
  }

  /// Returns the appointment text which will be displayed on spanning
  /// appointments on day, timeline day, schedule and month agenda view.
  /// The text will display the current date, and total dates of the spanning
  /// appointment
  static String getSpanAppointmentText(CalendarAppointment appointment,
      DateTime date, SfLocalizations localization) {
    final DateTime exactStartTime =
        convertToStartTime(appointment.exactStartTime);
    final String totalDays = (getDifference(
                    exactStartTime, convertToEndTime(appointment.exactEndTime))
                .inDays +
            1)
        .toString();
    final String currentDate =
        (getDifference(exactStartTime, convertToEndTime(date)).inDays + 1)
            .toString();

    return '${appointment.subject} (${localization.daySpanCountLabel} $currentDate / $totalDays)';
  }

  /// Returns recurrence icon details for appointment view.
  static TextSpan getSpanIcon(Color color, double textSize, bool isForward) {
    /// Text size multiplied by two, to align the icon, since the icon itself
    /// covered by some space in the top and bottom side, hence size multiplied.
    return TextSpan(
        text: isForward ? '\u00BB' : '\u00AB',
        style: TextStyle(
          color: color,
          fontSize: textSize * 2,
          fontFamily: 'Roboto',
        ));
  }

  /// Check and returns whether the forward icon can be added for the spanning
  /// appointment.
  static bool canAddForwardSpanIcon(DateTime appStartTime, DateTime appEndTime,
      DateTime viewStartDate, DateTime viewEndDate) {
    return isSameOrAfterDate(viewStartDate, appStartTime) &&
        appEndTime.isAfter(viewEndDate);
  }

  /// Check and returns whether the backward icon can be added for the spanning
  /// appointment.
  static bool canAddBackwardSpanIcon(DateTime appStartTime, DateTime appEndTime,
      DateTime viewStartDate, DateTime viewEndDate) {
    return appStartTime.isBefore(viewStartDate) &&
        isSameOrBeforeDate(viewEndDate, appEndTime);
  }

  /// Returns the specific date appointment collection by filtering the
  /// appointments from passed visible appointment collection.
  static List<CalendarAppointment> getSpecificDateVisibleAppointment(
      DateTime? date, List<CalendarAppointment>? visibleAppointments) {
    final List<CalendarAppointment> appointmentCollection =
        <CalendarAppointment>[];
    if (date == null || visibleAppointments == null) {
      return appointmentCollection;
    }

    final DateTime startDate = convertToStartTime(date);
    final DateTime endDate = convertToEndTime(date);

    for (int j = 0; j < visibleAppointments.length; j++) {
      final CalendarAppointment appointment = visibleAppointments[j];
      if (isAppointmentWithinVisibleDateRange(
          appointment, startDate, endDate)) {
        appointmentCollection.add(appointment);
      }
    }

    return appointmentCollection;
  }

  /// Return appointment collection based on the date.
  static List<CalendarAppointment> getSelectedDateAppointments(
      List<CalendarAppointment>? appointments,
      String? timeZone,
      DateTime? date) {
    final List<CalendarAppointment> appointmentCollection =
        <CalendarAppointment>[];
    if (appointments == null || appointments.isEmpty || date == null) {
      return appointmentCollection;
    }

    final DateTime startDate = convertToStartTime(date);
    final DateTime endDate = convertToEndTime(date);
    final int count = appointments.length;

    for (int j = 0; j < count; j++) {
      final CalendarAppointment appointment = appointments[j];
      appointment.actualStartTime = convertTimeToAppointmentTimeZone(
          appointment.startTime, appointment.startTimeZone, timeZone);
      appointment.actualEndTime = convertTimeToAppointmentTimeZone(
          appointment.endTime, appointment.endTimeZone, timeZone);
      appointment.exactStartTime = appointment.actualStartTime;
      appointment.exactEndTime = appointment.actualEndTime;

      if (appointment.recurrenceRule == null ||
          appointment.recurrenceRule == '') {
        if (isAppointmentWithinVisibleDateRange(
            appointment, startDate, endDate)) {
          appointmentCollection.add(appointment);
        }

        continue;
      }

      _getRecurrenceAppointments(
          appointment, appointmentCollection, startDate, endDate, timeZone);
    }

    return appointmentCollection;
  }

  /// Return calendar appointment text style.
  static TextStyle getAppointmentTextStyle(
      TextStyle appointmentTextStyle, CalendarView view, ThemeData themeData) {
    if (appointmentTextStyle.fontSize != -1) {
      return themeData.textTheme.bodyMedium!.merge(appointmentTextStyle);
    }

    return themeData.textTheme.bodyMedium!
        .merge(appointmentTextStyle.copyWith(fontSize: 12));
  }

  static CalendarAppointment _copy(CalendarAppointment appointment) {
    final CalendarAppointment copyAppointment = CalendarAppointment(
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        isAllDay: appointment.isAllDay,
        subject: appointment.subject,
        color: appointment.color,
        startTimeZone: appointment.startTimeZone,
        endTimeZone: appointment.endTimeZone,
        recurrenceRule: appointment.recurrenceRule,
        recurrenceExceptionDates: appointment.recurrenceExceptionDates,
        notes: appointment.notes,
        location: appointment.location,
        isSpanned: appointment.isSpanned,
        resourceIds: CalendarViewHelper.cloneList(appointment.resourceIds),
        recurrenceId: appointment.recurrenceId,
        id: appointment.id);
    copyAppointment.actualStartTime = appointment.actualStartTime;
    copyAppointment.actualEndTime = appointment.actualEndTime;
    copyAppointment.data = appointment.data;
    copyAppointment.exactStartTime = appointment.exactStartTime;
    copyAppointment.exactEndTime = appointment.exactEndTime;
    return copyAppointment;
  }

  /// Check the appointment in between the visible date range.
  static bool isAppointmentWithinVisibleDateRange(
      CalendarAppointment appointment,
      DateTime visibleStart,
      DateTime visibleEnd) {
    return isDateRangeWithinVisibleDateRange(appointment.actualStartTime,
        appointment.actualEndTime, visibleStart, visibleEnd);
  }

  /// Check the date range in between the visible date range.
  static bool isDateRangeWithinVisibleDateRange(DateTime startDate,
      DateTime endDate, DateTime visibleStart, DateTime visibleEnd) {
    if (startDate.isAfter(visibleStart)) {
      if (startDate.isBefore(visibleEnd)) {
        return true;
      }
    } else if (startDate.day == visibleStart.day &&
        startDate.month == visibleStart.month &&
        startDate.year == visibleStart.year) {
      return true;
    } else if (isSameOrAfterDate(visibleStart, endDate)) {
      return true;
    }

    return false;
  }

  static bool _isAppointmentInVisibleDateRange(CalendarAppointment appointment,
      DateTime visibleStart, DateTime visibleEnd) {
    final DateTime appStartTime = appointment.actualStartTime;
    final DateTime appEndTime = appointment.actualEndTime;
    if ((appStartTime.isAfter(visibleStart) ||
            (appStartTime.day == visibleStart.day &&
                appStartTime.month == visibleStart.month &&
                appStartTime.year == visibleStart.year)) &&
        (appStartTime.isBefore(visibleEnd) ||
            (appStartTime.day == visibleEnd.day &&
                appStartTime.month == visibleEnd.month &&
                appStartTime.year == visibleEnd.year)) &&
        (appEndTime.isAfter(visibleStart) ||
            (appEndTime.day == visibleStart.day &&
                appEndTime.month == visibleStart.month &&
                appEndTime.year == visibleStart.year)) &&
        (appEndTime.isBefore(visibleEnd) ||
            (appEndTime.day == visibleEnd.day &&
                appEndTime.month == visibleEnd.month &&
                appEndTime.year == visibleEnd.year))) {
      return true;
    }

    return false;
  }

  /// Check and returns whether the appointment's start or end date falls within
  /// the visible dates passed to the method.
  static bool _isAppointmentDateWithinVisibleDateRange(
      DateTime appointmentDate, DateTime visibleStart, DateTime visibleEnd) {
    if (appointmentDate.isAfter(visibleStart)) {
      if (appointmentDate.isBefore(visibleEnd)) {
        return true;
      }
    } else if (isSameDate(appointmentDate, visibleStart)) {
      return true;
    } else if (isSameDate(appointmentDate, visibleEnd)) {
      return true;
    }

    return false;
  }

  static Location _timeZoneInfoToOlsonTimeZone(String windowsTimeZoneId) {
    final Map<String, String> olsonWindowsTimes = <String, String>{};
    olsonWindowsTimes['AUS Central Standard Time'] = 'Australia/Darwin';
    olsonWindowsTimes['AUS Eastern Standard Time'] = 'Australia/Sydney';
    olsonWindowsTimes['Afghanistan Standard Time'] = 'Asia/Kabul';
    olsonWindowsTimes['Alaskan Standard Time'] = 'America/Anchorage';
    olsonWindowsTimes['Arab Standard Time'] = 'Asia/Riyadh';
    olsonWindowsTimes['Arabian Standard Time'] = 'Indian/Reunion';
    olsonWindowsTimes['Arabic Standard Time'] = 'Asia/Baghdad';
    olsonWindowsTimes['Argentina Standard Time'] =
        'America/Argentina/Buenos_Aires';
    olsonWindowsTimes['Atlantic Standard Time'] = 'America/Halifax';
    olsonWindowsTimes['Azerbaijan Standard Time'] = 'Asia/Baku';
    olsonWindowsTimes['Azores Standard Time'] = 'Atlantic/Azores';
    olsonWindowsTimes['Bahia Standard Time'] = 'America/Bahia';
    olsonWindowsTimes['Bangladesh Standard Time'] = 'Asia/Dhaka';
    olsonWindowsTimes['Belarus Standard Time'] = 'Europe/Minsk';
    olsonWindowsTimes['Canada Central Standard Time'] = 'America/Regina';
    olsonWindowsTimes['Cape Verde Standard Time'] = 'Atlantic/Cape_Verde';
    olsonWindowsTimes['Caucasus Standard Time'] = 'Asia/Yerevan';
    olsonWindowsTimes['Cen. Australia Standard Time'] = 'Australia/Adelaide';
    olsonWindowsTimes['Central America Standard Time'] = 'America/Guatemala';
    olsonWindowsTimes['Central Asia Standard Time'] = 'Asia/Almaty';
    olsonWindowsTimes['Central Brazilian Standard Time'] = 'America/Cuiaba';
    olsonWindowsTimes['Central Europe Standard Time'] = 'Europe/Budapest';
    olsonWindowsTimes['Central European Standard Time'] = 'Europe/Warsaw';
    olsonWindowsTimes['Central Pacific Standard Time'] = 'Pacific/Guadalcanal';
    olsonWindowsTimes['Central Standard Time'] = 'America/Chicago';
    olsonWindowsTimes['China Standard Time'] = 'Asia/Shanghai';
    olsonWindowsTimes['Dateline Standard Time'] = 'Etc/GMT+12';
    olsonWindowsTimes['E. Africa Standard Time'] = 'Africa/Nairobi';
    olsonWindowsTimes['E. Australia Standard Time'] = 'Australia/Brisbane';
    olsonWindowsTimes['E. South America Standard Time'] = 'America/Sao_Paulo';
    olsonWindowsTimes['Eastern Standard Time'] = 'America/New_York';
    olsonWindowsTimes['Egypt Standard Time'] = 'Africa/Cairo';
    olsonWindowsTimes['Ekaterinburg Standard Time'] = 'Asia/Yekaterinburg';
    olsonWindowsTimes['FLE Standard Time'] = 'Europe/Kiev';
    olsonWindowsTimes['Fiji Standard Time'] = 'Pacific/Fiji';
    olsonWindowsTimes['GMT Standard Time'] = 'Europe/London';
    olsonWindowsTimes['GTB Standard Time'] = 'Europe/Bucharest';
    olsonWindowsTimes['Georgian Standard Time'] = 'Asia/Tbilisi';
    olsonWindowsTimes['Greenland Standard Time'] = 'America/Godthab';
    olsonWindowsTimes['Greenwich Standard Time'] = 'Atlantic/Reykjavik';
    olsonWindowsTimes['Hawaiian Standard Time'] = 'Pacific/Honolulu';
    olsonWindowsTimes['India Standard Time'] = 'Asia/Kolkata';
    olsonWindowsTimes['Iran Standard Time'] = 'Asia/Tehran';
    olsonWindowsTimes['Israel Standard Time'] = 'Asia/Jerusalem';
    olsonWindowsTimes['Jordan Standard Time'] = 'Asia/Amman';
    olsonWindowsTimes['Kaliningrad Standard Time'] = 'Europe/Kaliningrad';
    olsonWindowsTimes['Korea Standard Time'] = 'Asia/Seoul';
    olsonWindowsTimes['Libya Standard Time'] = 'Africa/Tripoli';
    olsonWindowsTimes['Line Islands Standard Time'] = 'Pacific/Kiritimati';
    olsonWindowsTimes['Magadan Standard Time'] = 'Asia/Magadan';
    olsonWindowsTimes['Mauritius Standard Time'] = 'Indian/Mauritius';
    olsonWindowsTimes['Middle East Standard Time'] = 'Asia/Beirut';
    olsonWindowsTimes['Montevideo Standard Time'] = 'America/Montevideo';
    olsonWindowsTimes['Morocco Standard Time'] = 'Africa/Casablanca';
    olsonWindowsTimes['Mountain Standard Time'] = 'America/Denver';
    olsonWindowsTimes['Mountain Standard Time (Mexico)'] = 'America/Chihuahua';
    olsonWindowsTimes['Myanmar Standard Time'] = 'Asia/Rangoon';
    olsonWindowsTimes['N. Central Asia Standard Time'] = 'Asia/Novosibirsk';
    olsonWindowsTimes['Namibia Standard Time'] = 'Africa/Windhoek';
    olsonWindowsTimes['Nepal Standard Time'] = 'Asia/Kathmandu';
    olsonWindowsTimes['New Zealand Standard Time'] = 'Pacific/Auckland';
    olsonWindowsTimes['Newfoundland Standard Time'] = 'America/St_Johns';
    olsonWindowsTimes['North Asia East Standard Time'] = 'Asia/Irkutsk';
    olsonWindowsTimes['North Asia Standard Time'] = 'Asia/Krasnoyarsk';
    olsonWindowsTimes['Pacific SA Standard Time'] = 'America/Santiago';
    olsonWindowsTimes['Pacific Standard Time'] = 'America/Los_Angeles';
    olsonWindowsTimes['Pacific Standard Time (Mexico)'] =
        'America/Santa_Isabel';
    olsonWindowsTimes['Pakistan Standard Time'] = 'Asia/Karachi';
    olsonWindowsTimes['Paraguay Standard Time'] = 'America/Asuncion';
    olsonWindowsTimes['Romance Standard Time'] = 'Europe/Paris';
    olsonWindowsTimes['Russia Time Zone 10'] = 'Asia/Srednekolymsk';
    olsonWindowsTimes['Russia Time Zone 11'] = 'Asia/Kamchatka';
    olsonWindowsTimes['Russia Time Zone 3'] = 'Europe/Samara';
    olsonWindowsTimes['Russian Standard Time'] = 'Europe/Moscow';
    olsonWindowsTimes['SA Eastern Standard Time'] = 'America/Cayenne';
    olsonWindowsTimes['SA Pacific Standard Time'] = 'America/Bogota';
    olsonWindowsTimes['SA Western Standard Time'] = 'America/La_Paz';
    olsonWindowsTimes['SE Asia Standard Time'] = 'Asia/Bangkok';
    olsonWindowsTimes['Samoa Standard Time'] = 'Pacific/Apia';
    olsonWindowsTimes['Singapore Standard Time'] = 'Asia/Singapore';
    olsonWindowsTimes['South Africa Standard Time'] = 'Africa/Johannesburg';
    olsonWindowsTimes['Sri Lanka Standard Time'] = 'Asia/Colombo';
    olsonWindowsTimes['Syria Standard Time'] = 'Asia/Damascus';
    olsonWindowsTimes['Taipei Standard Time'] = 'Asia/Taipei';
    olsonWindowsTimes['Tasmania Standard Time'] = 'Australia/Hobart';
    olsonWindowsTimes['Tokyo Standard Time'] = 'Asia/Tokyo';
    olsonWindowsTimes['Tonga Standard Time'] = 'Pacific/Tongatapu';
    olsonWindowsTimes['Turkey Standard Time'] = 'Europe/Istanbul';
    olsonWindowsTimes['US Eastern Standard Time'] =
        'America/Indiana/Indianapolis';
    olsonWindowsTimes['US Mountain Standard Time'] = 'America/Phoenix';
    olsonWindowsTimes['UTC'] = 'America/Danmarkshavn';
    olsonWindowsTimes['UTC+12'] = 'Pacific/Tarawa';
    olsonWindowsTimes['UTC-02'] = 'America/Noronha';
    olsonWindowsTimes['UTC-11'] = 'Pacific/Midway';
    olsonWindowsTimes['Ulaanbaatar Standard Time'] = 'Asia/Ulaanbaatar';
    olsonWindowsTimes['Venezuela Standard Time'] = 'America/Caracas';
    olsonWindowsTimes['Vladivostok Standard Time'] = 'Asia/Vladivostok';
    olsonWindowsTimes['W. Australia Standard Time'] = 'Australia/Perth';
    olsonWindowsTimes['W. Central Africa Standard Time'] = 'Africa/Lagos';
    olsonWindowsTimes['W. Europe Standard Time'] = 'Europe/Berlin';
    olsonWindowsTimes['West Asia Standard Time'] = 'Asia/Tashkent';
    olsonWindowsTimes['West Pacific Standard Time'] = 'Pacific/Port_Moresby';
    olsonWindowsTimes['Yakutsk Standard Time'] = 'Asia/Yakutsk';

    final String? timeZone = olsonWindowsTimes[windowsTimeZoneId];
    if (timeZone != null) {
      return getLocation(timeZone);
    }

    return getLocation(windowsTimeZoneId);
  }

  /// Resets the appointment views used on appointment layout rendering.
  static void resetAppointmentView(
      List<AppointmentView> appointmentCollection) {
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView obj = appointmentCollection[i];
      obj.canReuse = true;
      obj.appointment = null;
      obj.position = -1;
      obj.startIndex = -1;
      obj.endIndex = -1;
      obj.maxPositions = -1;
      obj.appointmentRect = null;
    }
  }

  /// Returns the position from time passed, based on the time interval height.
  static double timeToPosition(
      SfCalendar calendar, DateTime date, double timeIntervalHeight) {
    final double singleIntervalHeightForAnHour = (60 /
            CalendarViewHelper.getTimeInterval(calendar.timeSlotViewSettings)) *
        timeIntervalHeight;

    final double startHour = calendar.timeSlotViewSettings.startHour;
    return ((date.hour + (date.minute / 60) + (date.second / 3600)) *
            singleIntervalHeightForAnHour) -
        (startHour * singleIntervalHeightForAnHour);
  }

  /// Returns the appointment height from the duration passed.
  static double getAppointmentHeightFromDuration(Duration? minimumDuration,
      SfCalendar calendar, double timeIntervalHeight) {
    if (minimumDuration == null || minimumDuration.inMinutes <= 0) {
      return 0;
    }

    final double hourHeight = (60 /
            CalendarViewHelper.getTimeInterval(calendar.timeSlotViewSettings)) *
        timeIntervalHeight;
    return minimumDuration.inMinutes * (hourHeight / 60);
  }

  static bool _isIntersectingAppointmentInDayView(
      SfCalendar calendar,
      CalendarView view,
      CalendarAppointment currentApp,
      AppointmentView appView,
      CalendarAppointment appointment,
      int timeIntervalMinutes) {
    if (currentApp == appointment) {
      return false;
    }

    final DateTime currentAppointmentStartTime = currentApp.actualStartTime;
    DateTime currentAppointmentEndTime = currentApp.actualEndTime;
    final DateTime appointmentStartTime = appointment.actualStartTime;
    DateTime appointmentEndTime = appointment.actualEndTime;
    final bool isTimelineMonth = view == CalendarView.timelineMonth;
    int minimumAppointmentMinutes =
        calendar.timeSlotViewSettings.minimumAppointmentDuration != null
            ? calendar
                .timeSlotViewSettings.minimumAppointmentDuration!.inMinutes
            : 0;
    minimumAppointmentMinutes = minimumAppointmentMinutes > timeIntervalMinutes
        ? timeIntervalMinutes
        : minimumAppointmentMinutes;
    if (minimumAppointmentMinutes > 0 && !isTimelineMonth) {
      final int timeIntervalMinutes =
          calendar.timeSlotViewSettings.timeInterval.inMinutes;
      minimumAppointmentMinutes =
          minimumAppointmentMinutes > timeIntervalMinutes
              ? timeIntervalMinutes
              : minimumAppointmentMinutes;
      if (getDifference(currentAppointmentStartTime, currentAppointmentEndTime)
              .inMinutes <
          minimumAppointmentMinutes) {
        currentAppointmentEndTime = currentAppointmentStartTime
            .add(Duration(minutes: minimumAppointmentMinutes));
      }

      if (getDifference(appointmentStartTime, appointmentEndTime).inMinutes <
          minimumAppointmentMinutes) {
        appointmentEndTime = appointmentStartTime
            .add(Duration(minutes: minimumAppointmentMinutes));
      }
    }

    if (currentAppointmentStartTime.isBefore(appointmentEndTime) &&
        currentAppointmentStartTime.isAfter(appointmentStartTime)) {
      return true;
    }

    if (currentAppointmentEndTime.isAfter(appointmentStartTime) &&
        currentAppointmentEndTime.isBefore(appointmentEndTime)) {
      return true;
    }

    if (currentAppointmentEndTime.isAfter(appointmentEndTime) &&
        currentAppointmentStartTime.isBefore(appointmentStartTime)) {
      return true;
    }

    /// For timeline month view, the intercepting appointments must be
    /// calculated based on the date instead of the time, hence added this
    /// condition and returned that it's a intercept appointment or not.
    if (isTimelineMonth) {
      return isSameDate(
              currentApp.actualStartTime, appointment.actualStartTime) ||
          isSameDate(currentApp.actualEndTime, appointment.actualEndTime);
    }

    if (CalendarViewHelper.isSameTimeSlot(
            currentAppointmentStartTime, appointmentStartTime) ||
        CalendarViewHelper.isSameTimeSlot(
            currentAppointmentEndTime, appointmentEndTime)) {
      return true;
    }

    return false;
  }

  static bool _iterateAppointment(
      CalendarAppointment app, bool isTimeline, bool isAllDay) {
    if (isAllDay) {
      if (!isTimeline && app.isAllDay) {
        app.actualEndTime = convertToEndTime(app.actualEndTime);
        app.actualStartTime = convertToStartTime(app.actualStartTime);
        return true;
      } else if (!isTimeline && _isSpanned(app)) {
        return true;
      }

      return false;
    }

    if ((app.isAllDay || _isSpanned(app)) && !isTimeline) {
      return false;
    }

    if (isTimeline && app.isAllDay) {
      app.actualEndTime = convertToEndTime(app.actualEndTime);
      app.actualStartTime = convertToStartTime(app.actualStartTime);
    }

    return true;
  }

  static int _orderAppointmentsDescending(bool value, bool value1) {
    int boolValue1 = -1;
    int boolValue2 = -1;
    if (value) {
      boolValue1 = 1;
    }

    if (value1) {
      boolValue2 = 1;
    }

    return boolValue1.compareTo(boolValue2);
  }

  /// Compare both boolean values used on appointment sorting.
  static int orderAppointmentsAscending(bool value, bool value1) {
    int boolValue1 = 1;
    int boolValue2 = 1;
    if (value) {
      boolValue1 = -1;
    }

    if (value1) {
      boolValue2 = -1;
    }

    return boolValue1.compareTo(boolValue2);
  }

  static AppointmentView _getAppointmentView(CalendarAppointment appointment,
      List<AppointmentView> appointmentCollection, int? resourceIndex) {
    AppointmentView? appointmentRenderer;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView view = appointmentCollection[i];
      if (view.appointment == null) {
        appointmentRenderer = view;
        break;
      }
    }

    if (appointmentRenderer == null) {
      appointmentRenderer = AppointmentView();
      appointmentRenderer.appointment = appointment;
      appointmentRenderer.canReuse = false;
      appointmentRenderer.resourceIndex = resourceIndex ?? -1;
      appointmentCollection.add(appointmentRenderer);
    }

    appointmentRenderer.appointment = appointment;
    appointmentRenderer.canReuse = false;
    appointmentRenderer.resourceIndex = resourceIndex ?? -1;
    return appointmentRenderer;
  }

  /// Update the appointment view collection position and its max position
  /// details.
  static void setAppointmentPositionAndMaxPosition(
      List<AppointmentView> appointmentCollection,
      SfCalendar calendar,
      CalendarView view,
      List<CalendarAppointment> visibleAppointments,
      bool isAllDay,
      [int? resourceIndex]) {
    final bool isTimeline = CalendarViewHelper.isTimelineView(view);
    final List<CalendarAppointment> normalAppointments = visibleAppointments
        .where((CalendarAppointment app) =>
            _iterateAppointment(app, isTimeline, isAllDay))
        .toList();
    normalAppointments.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            app1.actualStartTime.compareTo(app2.actualStartTime));
    if (!isTimeline) {
      normalAppointments.sort(
          (CalendarAppointment app1, CalendarAppointment app2) =>
              _orderAppointmentsDescending(app1.isSpanned, app2.isSpanned));
      normalAppointments.sort(
          (CalendarAppointment app1, CalendarAppointment app2) =>
              _orderAppointmentsDescending(app1.isAllDay, app2.isAllDay));
    } else {
      normalAppointments.sort(
          (CalendarAppointment app1, CalendarAppointment app2) =>
              orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));
      normalAppointments.sort(
          (CalendarAppointment app1, CalendarAppointment app2) =>
              orderAppointmentsAscending(app1.isSpanned, app2.isSpanned));
    }

    final Map<int, List<AppointmentView>> dict = <int, List<AppointmentView>>{};
    final List<AppointmentView> processedViews = <AppointmentView>[];
    int maxColsCount = 1;

    final int timeIntervalMinutes =
        CalendarViewHelper.getTimeInterval(calendar.timeSlotViewSettings);
    for (int count = 0; count < normalAppointments.length; count++) {
      final CalendarAppointment currentAppointment = normalAppointments[count];
      if ((view == CalendarView.workWeek ||
              view == CalendarView.timelineWorkWeek) &&
          calendar.timeSlotViewSettings.nonWorkingDays
              .contains(currentAppointment.actualStartTime.weekday) &&
          calendar.timeSlotViewSettings.nonWorkingDays
              .contains(currentAppointment.actualEndTime.weekday)) {
        continue;
      }

      List<AppointmentView>? intersectingApps;
      final AppointmentView currentAppView = _getAppointmentView(
          currentAppointment, appointmentCollection, resourceIndex);

      for (int position = 0; position < maxColsCount; position++) {
        bool isIntersecting = false;
        for (int j = 0; j < processedViews.length; j++) {
          final AppointmentView previousApp = processedViews[j];
          if (previousApp.position != position) {
            continue;
          }

          if (_isIntersectingAppointmentInDayView(
              calendar,
              view,
              currentAppointment,
              previousApp,
              previousApp.appointment!,
              timeIntervalMinutes)) {
            isIntersecting = true;

            if (intersectingApps == null) {
              final List<int> keyList = dict.keys.toList();
              for (int keyCount = 0; keyCount < keyList.length; keyCount++) {
                final int key = keyList[keyCount];
                if (dict[key]!.contains(previousApp)) {
                  intersectingApps = dict[key];
                  break;
                }
              }

              if (intersectingApps == null) {
                intersectingApps = <AppointmentView>[];
                dict[dict.keys.length] = intersectingApps;
              }

              break;
            }
          }
        }

        if (!isIntersecting && currentAppView.position == -1) {
          currentAppView.position = position;
        }
      }

      processedViews.add(currentAppView);
      if (currentAppView.position == -1) {
        int position = 0;
        if (intersectingApps == null) {
          intersectingApps = <AppointmentView>[];
          dict[dict.keys.length] = intersectingApps;
        } else if (intersectingApps.isNotEmpty) {
          position = intersectingApps
              .reduce((AppointmentView currentAppview,
                      AppointmentView nextAppview) =>
                  currentAppview.maxPositions > nextAppview.maxPositions
                      ? currentAppview
                      : nextAppview)
              .maxPositions;
        }

        intersectingApps.add(currentAppView);
        for (int i = 0; i < intersectingApps.length; i++) {
          intersectingApps[i].maxPositions = position + 1;
        }

        currentAppView.position = position;
        if (maxColsCount <= position) {
          maxColsCount = position + 1;
        }
      } else {
        int maxPosition = 1;
        if (intersectingApps == null) {
          intersectingApps = <AppointmentView>[];
          dict[dict.keys.length] = intersectingApps;
        } else if (intersectingApps.isNotEmpty) {
          maxPosition = intersectingApps
              .reduce((AppointmentView currentAppview,
                      AppointmentView nextAppview) =>
                  currentAppview.maxPositions > nextAppview.maxPositions
                      ? currentAppview
                      : nextAppview)
              .maxPositions;

          if (currentAppView.position == maxPosition) {
            maxPosition++;
          }
        }

        intersectingApps.add(currentAppView);
        for (int i = 0; i < intersectingApps.length; i++) {
          intersectingApps[i].maxPositions = maxPosition;
        }

        if (maxColsCount <= maxPosition) {
          maxColsCount = maxPosition + 1;
        }
      }

      intersectingApps = null;
    }

    dict.clear();
  }

  /// Convert the date time from appointment timezone value to calender timezone
  /// value. If calendar timezone value as null or empty then it convert
  /// it to local timezone value.
  static DateTime convertTimeToAppointmentTimeZone(
      DateTime date, String? appTimeZoneId, String? calendarTimeZoneId) {
    if (((appTimeZoneId == null || appTimeZoneId == '') &&
            (calendarTimeZoneId == null || calendarTimeZoneId == '')) ||
        calendarTimeZoneId == appTimeZoneId) {
      return date;
    }

    DateTime convertedDate = date;
    if (appTimeZoneId != null && appTimeZoneId != '') {
      //// Convert the date to appointment time zone
      if (appTimeZoneId == 'Dateline Standard Time') {
        convertedDate = date.toUtc().subtract(const Duration(hours: 12));
        //// Above mentioned converted date hold the date value which is equal to original date, but the time zone value changed.
        //// E.g., Nov 3- 9.00 AM IST equal to Nov 2- 10.30 PM EST
        //// So convert the Appointment time zone date to current time zone date.
        convertedDate = DateTime(
            date.year - (convertedDate.year - date.year),
            date.month - (convertedDate.month - date.month),
            date.day - (convertedDate.day - date.day),
            date.hour - (convertedDate.hour - date.hour),
            date.minute - (convertedDate.minute - date.minute),
            date.second);
      } else {
        /// Create the specified date on appointment time zone.
        /// Eg., Appointment Time zone as Eastern time zone(-5.00) and it
        /// date is Nov 1 10AM, create the date using location.
        final DateTime timeZoneDate = TZDateTime(
            _timeZoneInfoToOlsonTimeZone(appTimeZoneId),
            date.year,
            date.month,
            date.day,
            date.hour,
            date.minute,
            date.second);

        final Duration offset = DateTime.now().timeZoneOffset;

        /// Convert the appointment time zone date to local date.
        ///  Eg., Nov 1 10AM(EST) UTC value as Nov 1 3(UTC) add local
        ///  time zone offset(IST +5.30) return Nov 1 8PM.
        final DateTime localTimeZoneDate = timeZoneDate.toUtc().add(offset);

        /// Resulted date as Nov 1 8PM but its time zone as EST so create the
        /// local time date based on resulted date.
        /// We does not use from method in TZDateTime because we does not
        /// know the local time zone location.
        convertedDate = DateTime(
            localTimeZoneDate.year,
            localTimeZoneDate.month,
            localTimeZoneDate.day,
            localTimeZoneDate.hour,
            localTimeZoneDate.minute,
            localTimeZoneDate.second);
      }
    }

    if (calendarTimeZoneId != null && calendarTimeZoneId != '') {
      DateTime actualConvertedDate;
      //// Convert the converted date with calendar time zone
      if (calendarTimeZoneId == 'Dateline Standard Time') {
        actualConvertedDate =
            convertedDate.toUtc().subtract(const Duration(hours: 12));
        //// Above mentioned actual converted date hold the date value which is equal to converted date, but the time zone value changed.
        //// So convert the schedule time zone date to current time zone date for rendering the appointment.
        return DateTime(
            convertedDate.year +
                (actualConvertedDate.year - convertedDate.year),
            convertedDate.month +
                (actualConvertedDate.month - convertedDate.month),
            convertedDate.day + (actualConvertedDate.day - convertedDate.day),
            convertedDate.hour +
                (actualConvertedDate.hour - convertedDate.hour),
            convertedDate.minute +
                (actualConvertedDate.minute - convertedDate.minute),
            convertedDate.second);
      } else {
        final Location location =
            _timeZoneInfoToOlsonTimeZone(calendarTimeZoneId);

        /// Convert the local time to calendar time zone.
        actualConvertedDate = TZDateTime.from(convertedDate, location);

        /// Return the calendar time zone value with local time zone.
        return DateTime(
            actualConvertedDate.year,
            actualConvertedDate.month,
            actualConvertedDate.day,
            actualConvertedDate.hour,
            actualConvertedDate.minute,
            actualConvertedDate.second);
      }
    }

    return convertedDate;
  }

  /// Return the visible appointment collection based on visible start and
  /// end date.
  static List<CalendarAppointment> getVisibleAppointments(
      DateTime visibleStartDate,
      DateTime visibleEndDate,
      List<CalendarAppointment> appointments,
      String? calendarTimeZone,
      bool isTimelineView,
      {bool canCreateNewAppointment = true}) {
    final List<CalendarAppointment> appointmentColl = <CalendarAppointment>[];
    final DateTime startDate = convertToStartTime(visibleStartDate);
    final DateTime endDate = convertToEndTime(visibleEndDate);
    final int count = appointments.length;

    for (int j = 0; j < count; j++) {
      final CalendarAppointment calendarAppointment = appointments[j];
      calendarAppointment.actualStartTime = convertTimeToAppointmentTimeZone(
          calendarAppointment.startTime,
          calendarAppointment.startTimeZone,
          calendarTimeZone);
      calendarAppointment.actualEndTime = convertTimeToAppointmentTimeZone(
          calendarAppointment.endTime,
          calendarAppointment.endTimeZone,
          calendarTimeZone);

      final List<CalendarAppointment> tempAppointments =
          <CalendarAppointment>[];

      /// Stored the actual start time to exact start time to use the value,
      /// since, we split the span appointment into multiple instances and
      /// change the actual start and end time based on the rendering, hence
      /// to get the actual start and end time of the appointment we have
      /// stored the value in the exact start and end time.
      calendarAppointment.exactStartTime = calendarAppointment.actualStartTime;
      calendarAppointment.exactEndTime = calendarAppointment.actualEndTime;
      if (calendarAppointment.recurrenceRule != null &&
          calendarAppointment.recurrenceRule != '') {
        _getRecurrenceAppointments(calendarAppointment, tempAppointments,
            startDate, endDate, calendarTimeZone);
      } else {
        tempAppointments.add(calendarAppointment);
      }

      final int appointmentLength = tempAppointments.length;
      for (int i = 0; i < appointmentLength; i++) {
        final CalendarAppointment appointment = tempAppointments[i];
        if (isAppointmentWithinVisibleDateRange(
            appointment, startDate, endDate)) {
          /// can create new appointment boolean is used to skip the new
          /// appointment creation while the appointment start and end date as
          /// different and appointment duration is not more than 24 hours.
          ///
          /// The bool value assigned to false when calendar view as schedule.
          if (canCreateNewAppointment &&
              !(appointment.exactStartTime.day ==
                      appointment.exactEndTime.day &&
                  appointment.exactStartTime.year ==
                      appointment.exactEndTime.year &&
                  appointment.exactStartTime.month ==
                      appointment.exactEndTime.month) &&
              appointment.exactStartTime.isBefore(appointment.exactEndTime) &&
              getDifference(
                          appointment.exactStartTime, appointment.exactEndTime)
                      .inDays ==
                  0 &&
              (appointment.exactEndTime.hour != 0 ||
                  appointment.exactEndTime.minute != 0) &&
              !appointment.isAllDay &&
              !isTimelineView) {
            for (int i = 0; i < 2; i++) {
              final CalendarAppointment spannedAppointment = _copy(appointment);
              if (i == 0) {
                spannedAppointment.actualEndTime = DateTime(
                    appointment.exactStartTime.year,
                    appointment.exactStartTime.month,
                    appointment.exactStartTime.day,
                    23,
                    59,
                    59);
              } else {
                spannedAppointment.actualStartTime = DateTime(
                    appointment.exactEndTime.year,
                    appointment.exactEndTime.month,
                    appointment.exactEndTime.day);
              }

              spannedAppointment.startTime = spannedAppointment.isAllDay
                  ? appointment.actualStartTime
                  : convertTimeToAppointmentTimeZone(
                      appointment.actualStartTime,
                      calendarTimeZone,
                      appointment.startTimeZone);
              spannedAppointment.endTime = spannedAppointment.isAllDay
                  ? appointment.actualEndTime
                  : convertTimeToAppointmentTimeZone(appointment.actualEndTime,
                      calendarTimeZone, appointment.endTimeZone);

              // Adding Spanned Appointment only when the Appointment range
              // within the VisibleDate
              if (isAppointmentWithinVisibleDateRange(
                  spannedAppointment, startDate, endDate)) {
                appointmentColl.add(spannedAppointment);
              }
            }
          } else if (!(appointment.exactStartTime.day ==
                      appointment.exactEndTime.day &&
                  appointment.exactStartTime.year ==
                      appointment.exactEndTime.year &&
                  appointment.exactStartTime.month ==
                      appointment.exactEndTime.month) &&
              appointment.exactStartTime.isBefore(appointment.exactEndTime) &&
              isTimelineView) {
            //// Check the spanned appointment with in current visible dates. example visible date 21 to 27 and
            //// the appointment start and end date as 23 and 25.
            if (_isAppointmentInVisibleDateRange(
                appointment, startDate, endDate)) {
              appointment.isSpanned = _isSpanned(appointment);
              appointmentColl.add(appointment);
            } else if (_isAppointmentDateWithinVisibleDateRange(
                appointment.actualStartTime, startDate, endDate)) {
              //// Check the spanned appointment start date with in current visible dates.
              //// example visible date 21 to 27 and the appointment start and end date as 23 and 28.
              for (int i = 0; i < 2; i++) {
                final CalendarAppointment spannedAppointment =
                    _copy(appointment);
                if (i == 0) {
                  spannedAppointment.actualEndTime = DateTime(
                      endDate.year, endDate.month, endDate.day, 23, 59, 59);
                } else {
                  spannedAppointment.actualStartTime =
                      DateTime(endDate.year, endDate.month, endDate.day);
                }

                spannedAppointment.startTime = spannedAppointment.isAllDay
                    ? appointment.actualStartTime
                    : convertTimeToAppointmentTimeZone(
                        appointment.actualStartTime,
                        calendarTimeZone,
                        appointment.startTimeZone);
                spannedAppointment.endTime = spannedAppointment.isAllDay
                    ? appointment.actualEndTime
                    : convertTimeToAppointmentTimeZone(
                        appointment.actualEndTime,
                        calendarTimeZone,
                        appointment.endTimeZone);

                // Adding Spanned Appointment only when the Appointment range
                // within the VisibleDate
                if (_isAppointmentInVisibleDateRange(
                    spannedAppointment, startDate, endDate)) {
                  spannedAppointment.isSpanned = _isSpanned(spannedAppointment);
                  appointmentColl.add(spannedAppointment);
                }
              }
            } else if (_isAppointmentDateWithinVisibleDateRange(
                appointment.actualEndTime, startDate, endDate)) {
              //// Check the spanned appointment end date with in current visible dates. example visible date 21 to 27 and
              //// the appointment start and end date as 18 and 24.
              for (int i = 0; i < 2; i++) {
                final CalendarAppointment spannedAppointment =
                    _copy(appointment);
                if (i == 0) {
                  spannedAppointment.actualStartTime =
                      appointment.actualStartTime;
                  final DateTime date =
                      DateTimeHelper.getDateTimeValue(addDays(startDate, -1));
                  spannedAppointment.actualEndTime =
                      DateTime(date.year, date.month, date.day, 23, 59, 59);
                } else {
                  spannedAppointment.actualStartTime =
                      DateTime(startDate.year, startDate.month, startDate.day);
                }

                spannedAppointment.startTime = spannedAppointment.isAllDay
                    ? appointment.actualStartTime
                    : convertTimeToAppointmentTimeZone(
                        appointment.actualStartTime,
                        calendarTimeZone,
                        appointment.startTimeZone);
                spannedAppointment.endTime = spannedAppointment.isAllDay
                    ? appointment.actualEndTime
                    : convertTimeToAppointmentTimeZone(
                        appointment.actualEndTime,
                        calendarTimeZone,
                        appointment.endTimeZone);

                // Adding Spanned Appointment only when the Appointment range
                // within the VisibleDate
                if (_isAppointmentInVisibleDateRange(
                    spannedAppointment, startDate, endDate)) {
                  spannedAppointment.isSpanned = _isSpanned(spannedAppointment);
                  appointmentColl.add(spannedAppointment);
                }
              }
            } else if (!_isAppointmentDateWithinVisibleDateRange(
                    appointment.actualEndTime, startDate, endDate) &&
                !_isAppointmentDateWithinVisibleDateRange(
                    appointment.actualStartTime, startDate, endDate)) {
              //// Check the spanned appointment start and end date not in current visible dates. example visible date 21 to 27 and
              //// the appointment start and end date as 18 and 28.
              for (int i = 0; i < 3; i++) {
                final CalendarAppointment spannedAppointment =
                    _copy(appointment);
                if (i == 0) {
                  final DateTime date =
                      DateTimeHelper.getDateTimeValue(addDays(startDate, -1));
                  spannedAppointment.actualEndTime =
                      DateTime(date.year, date.month, date.day, 23, 59, 59);
                } else if (i == 1) {
                  spannedAppointment.actualStartTime =
                      DateTime(startDate.year, startDate.month, startDate.day);
                  spannedAppointment.actualEndTime = DateTime(
                      endDate.year, endDate.month, endDate.day, 23, 59, 59);
                } else {
                  final DateTime date =
                      DateTimeHelper.getDateTimeValue(addDays(endDate, 1));
                  spannedAppointment.actualStartTime =
                      DateTime(date.year, date.month, date.day);
                }

                spannedAppointment.startTime = spannedAppointment.isAllDay
                    ? appointment.actualStartTime
                    : convertTimeToAppointmentTimeZone(
                        appointment.actualStartTime,
                        calendarTimeZone,
                        appointment.startTimeZone);
                spannedAppointment.endTime = spannedAppointment.isAllDay
                    ? appointment.actualEndTime
                    : convertTimeToAppointmentTimeZone(
                        appointment.actualEndTime,
                        calendarTimeZone,
                        appointment.endTimeZone);

                // Adding Spanned Appointment only when the Appointment range
                // within the VisibleDate
                if (_isAppointmentInVisibleDateRange(
                    spannedAppointment, startDate, endDate)) {
                  spannedAppointment.isSpanned = _isSpanned(spannedAppointment);
                  appointmentColl.add(spannedAppointment);
                }
              }
            } else {
              appointment.isSpanned = _isSpanned(appointment);
              appointmentColl.add(appointment);
            }
          } else {
            appointmentColl.add(appointment);
          }
        }
      }
    }

    return appointmentColl;
  }

  static CalendarAppointment _cloneRecurrenceAppointment(
      CalendarAppointment appointment,
      DateTime recursiveDate,
      String? calendarTimeZone) {
    final CalendarAppointment occurrenceAppointment = _copy(appointment);
    occurrenceAppointment.actualStartTime = recursiveDate;
    occurrenceAppointment.startTime = occurrenceAppointment.isAllDay
        ? occurrenceAppointment.actualStartTime
        : convertTimeToAppointmentTimeZone(
            occurrenceAppointment.actualStartTime,
            calendarTimeZone,
            occurrenceAppointment.startTimeZone);

    final int minutes =
        getDifference(appointment.actualStartTime, appointment.actualEndTime)
            .inMinutes;
    occurrenceAppointment.actualEndTime = DateTimeHelper.getDateTimeValue(
        addDuration(
            occurrenceAppointment.actualStartTime, Duration(minutes: minutes)));
    occurrenceAppointment.endTime = occurrenceAppointment.isAllDay
        ? occurrenceAppointment.actualEndTime
        : convertTimeToAppointmentTimeZone(occurrenceAppointment.actualEndTime,
            calendarTimeZone, occurrenceAppointment.endTimeZone);
    occurrenceAppointment.isSpanned = _isSpanned(occurrenceAppointment) &&
        getDifference(occurrenceAppointment.startTime,
                    occurrenceAppointment.endTime)
                .inDays >
            0;
    occurrenceAppointment.exactStartTime =
        occurrenceAppointment.actualStartTime;
    occurrenceAppointment.exactEndTime = occurrenceAppointment.actualEndTime;

    return occurrenceAppointment;
  }

  /// Generate the calendar appointment collection from custom appointment
  /// collection.
  static List<CalendarAppointment> generateCalendarAppointments(
      CalendarDataSource? calendarData, String? calendarTimeZone,
      [List<dynamic>? appointments]) {
    final List<CalendarAppointment> calendarAppointmentCollection =
        <CalendarAppointment>[];
    if (calendarData == null) {
      return calendarAppointmentCollection;
    }

    final List<dynamic>? dataSource = appointments ?? calendarData.appointments;
    if (dataSource == null) {
      return calendarAppointmentCollection;
    }

    if (dataSource.isNotEmpty && dataSource[0] is CalendarAppointment) {
      for (int i = 0; i < dataSource.length; i++) {
        final dynamic dataSourceItem = dataSource[i];
        late final CalendarAppointment item;
        if (dataSourceItem is CalendarAppointment) {
          item = dataSourceItem;
        }
        final DateTime appStartTime = item.startTime;
        final DateTime appEndTime = item.endTime;
        item.data = item;
        item.actualStartTime = !item.isAllDay
            ? convertTimeToAppointmentTimeZone(
                item.startTime, item.startTimeZone, calendarTimeZone)
            : item.startTime;
        item.actualEndTime = !item.isAllDay
            ? convertTimeToAppointmentTimeZone(
                item.endTime, item.endTimeZone, calendarTimeZone)
            : item.endTime;
        _updateTimeForInvalidEndTime(item, calendarTimeZone);
        calendarAppointmentCollection.add(item);

        item.isSpanned = _isSpanned(item) &&
            getDifference(appStartTime, appEndTime).inDays > 0;
      }
    } else {
      for (int i = 0; i < dataSource.length; i++) {
        final dynamic item = dataSource[i];
        final CalendarAppointment app =
            _createAppointment(item, calendarData, calendarTimeZone);

        final DateTime appStartTime = app.startTime;
        final DateTime appEndTime = app.endTime;
        app.isSpanned = _isSpanned(app) &&
            getDifference(appStartTime, appEndTime).inDays > 0;
        calendarAppointmentCollection.add(app);
      }
    }

    return calendarAppointmentCollection;
  }

  static CalendarAppointment _createAppointment(Object appointmentObject,
      CalendarDataSource calendarData, String? calendarTimeZone) {
    CalendarAppointment app;
    if (appointmentObject is Appointment) {
      app = CalendarAppointment(
          startTime: appointmentObject.startTime,
          endTime: appointmentObject.endTime,
          subject: appointmentObject.subject,
          isAllDay: appointmentObject.isAllDay,
          color: appointmentObject.color,
          notes: appointmentObject.notes,
          location: appointmentObject.location,
          startTimeZone: appointmentObject.startTimeZone,
          endTimeZone: appointmentObject.endTimeZone,
          recurrenceRule: appointmentObject.recurrenceRule,
          recurrenceExceptionDates: appointmentObject.recurrenceExceptionDates,
          resourceIds: appointmentObject.resourceIds,
          recurrenceId: appointmentObject.recurrenceId,
          id: appointmentObject.id);
    } else {
      final int index = calendarData.appointments!.indexOf(appointmentObject);
      app = CalendarAppointment(
          startTime: calendarData.getStartTime(index),
          endTime: calendarData.getEndTime(index),
          subject: calendarData.getSubject(index),
          isAllDay: calendarData.isAllDay(index),
          color: calendarData.getColor(index),
          notes: calendarData.getNotes(index),
          location: calendarData.getLocation(index),
          startTimeZone: calendarData.getStartTimeZone(index),
          endTimeZone: calendarData.getEndTimeZone(index),
          recurrenceRule: calendarData.getRecurrenceRule(index),
          recurrenceExceptionDates:
              calendarData.getRecurrenceExceptionDates(index),
          resourceIds: calendarData.getResourceIds(index),
          recurrenceId: calendarData.getRecurrenceId(index),
          id: calendarData.getId(index));
    }

    app.data = appointmentObject;
    app.actualStartTime = !app.isAllDay
        ? convertTimeToAppointmentTimeZone(
            app.startTime, app.startTimeZone, calendarTimeZone)
        : app.startTime;
    app.actualEndTime = !app.isAllDay
        ? convertTimeToAppointmentTimeZone(
            app.endTime, app.endTimeZone, calendarTimeZone)
        : app.endTime;
    _updateTimeForInvalidEndTime(app, calendarTimeZone);
    return app;
  }

  static void _updateTimeForInvalidEndTime(
      CalendarAppointment appointment, String? scheduleTimeZone) {
    if (appointment.actualEndTime.isBefore(appointment.actualStartTime) &&
        !appointment.isAllDay) {
      appointment.endTime = convertTimeToAppointmentTimeZone(
          addDuration(appointment.actualStartTime, const Duration(minutes: 30)),
          scheduleTimeZone,
          appointment.endTimeZone);
      appointment.actualEndTime = !appointment.isAllDay
          ? convertTimeToAppointmentTimeZone(
              appointment.endTime, appointment.endTimeZone, scheduleTimeZone)
          : appointment.endTime;
    }
  }

  static void _getRecurrenceAppointments(
      CalendarAppointment appointment,
      List<CalendarAppointment> appointments,
      DateTime visibleStartDate,
      DateTime visibleEndDate,
      String? scheduleTimeZone) {
    final DateTime appStartTime = appointment.actualStartTime;
    if (appStartTime.isAfter(visibleEndDate)) {
      return;
    }

    final String recurrenceRule = appointment.recurrenceRule ?? '';
    String rule = recurrenceRule;
    if (!rule.contains('COUNT') && !rule.contains('UNTIL')) {
      final DateFormat formatter = DateFormat('yyyyMMdd');
      final String newSubString = ';UNTIL=${formatter.format(visibleEndDate)}';
      rule = rule + newSubString;
    }

    final List<DateTime> recursiveDates =
        RecurrenceHelper.getRecurrenceDateTimeCollection(
            rule, appointment.actualStartTime,
            recurrenceDuration: getDifference(
                appointment.exactStartTime, appointment.exactEndTime),
            specificStartDate: visibleStartDate,
            specificEndDate: visibleEndDate);

    List<DateTime> recDates = <DateTime>[];
    if (recursiveDates.isNotEmpty) {
      String countRule = recurrenceRule;

      /// To check whether the appointment is pattern or not, we need to get
      /// the first appointment of the rrule, hence added count as 1 in rrule,
      /// if the count is not given in the rrule, we didn't change
      /// the appointment's rrule we used a separate property internally
      /// for our purpose.
      if (!countRule.contains('COUNT')) {
        countRule = '$countRule;COUNT=1';
      }

      recDates = RecurrenceHelper.getRecurrenceDateTimeCollection(
          countRule, appointment.actualStartTime,
          specificStartDate: appointment.startTime);
    }

    for (int j = 0; j < recursiveDates.length; j++) {
      final DateTime recursiveDate = recursiveDates[j];
      if (appointment.recurrenceExceptionDates != null) {
        bool isDateContains = false;
        for (int i = 0; i < appointment.recurrenceExceptionDates!.length; i++) {
          final DateTime date = convertTimeToAppointmentTimeZone(
              appointment.recurrenceExceptionDates![i], '', scheduleTimeZone);
          if (date.year == recursiveDate.year &&
              date.month == recursiveDate.month &&
              date.day == recursiveDate.day) {
            isDateContains = true;
            break;
          }
        }
        if (isDateContains) {
          continue;
        }
      }

      final CalendarAppointment occurrenceAppointment =
          _cloneRecurrenceAppointment(
              appointment, recursiveDate, scheduleTimeZone);

      /// Here we used isOccurrenceAppointment keyword to identify the
      /// occurrence appointment When we clone the pattern appointment for
      /// occurrence appointment we have append the string in the notes and
      /// here we identify based on the string and removed the appended string.
      occurrenceAppointment.notes = recDates.isNotEmpty &&
              isSameDate(occurrenceAppointment.startTime, recDates[0])
          ? appointment.notes
          : appointment.notes == null
              ? 'isOccurrenceAppointment'
              : '${appointment.notes!}isOccurrenceAppointment';
      appointments.add(occurrenceAppointment);
    }
  }
}
