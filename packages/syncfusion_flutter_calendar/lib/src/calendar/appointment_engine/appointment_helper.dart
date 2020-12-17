part of calendar;

DateTime _convertToStartTime(DateTime date) {
  return DateTime(date.year, date.month, date.day, 0, 0, 0);
}

DateTime _convertToEndTime(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59);
}

/// This method is used to check the appointment needs all day appointment
/// view or not in agenda view, because the all day appointment view shown
/// as half of the normal appointment view in agenda view.
/// Agenda view used on month and schedule calendar view.
bool _isAllDayAppointmentView(Appointment appointment) {
  return appointment.isAllDay ||
      appointment._isSpanned ||
      appointment._actualStartTime.day != appointment._actualEndTime.day;
}

//// Check whether the data source has calendar appointment type or not.
bool _isCalendarAppointment(CalendarDataSource dataSource) {
  if (dataSource.appointments == null ||
      dataSource.appointments.isEmpty ||
      dataSource.appointments[0] is Appointment) {
    return true;
  }

  return false;
}

/// Calculate the maximum appointment date based on appointment collection
/// and schedule view settings.
DateTime _getMaxAppointmentDate(
    List<Appointment> appointments,
    String timeZone,
    DateTime maxDate,
    DateTime displayDate,
    ScheduleViewSettings scheduleViewSettings,
    bool useMobilePlatformUI) {
  /// return default max date when [hideEmptyAgendaDays] as false
  if (!scheduleViewSettings.hideEmptyScheduleWeek && useMobilePlatformUI) {
    return maxDate;
  }

  DateTime currentMaxDate = displayDate;
  if (appointments == null || appointments.isEmpty) {
    return currentMaxDate;
  }

  /// Calculate the max appointment date based on appointments when
  /// web view enabled or [hideEmptyAgendaDays] property as enabled.
  for (int j = 0; j < appointments.length; j++) {
    final Appointment appointment = appointments[j];
    appointment._actualEndTime = _convertTimeToAppointmentTimeZone(
        appointment.endTime, appointment.endTimeZone, timeZone);

    if (appointment.recurrenceRule == null ||
        appointment.recurrenceRule == '') {
      if (appointment._actualEndTime.isAfter(currentMaxDate)) {
        currentMaxDate = appointment._actualEndTime;
      }

      continue;
    }

    /// Return specified ma date when recurrence rule does not have
    /// count and until string.
    if (!appointment.recurrenceRule.contains('COUNT') &&
        !appointment.recurrenceRule.contains('UNTIL')) {
      currentMaxDate = maxDate;
      return currentMaxDate;
    }

    if (appointment.recurrenceRule.contains('UNTIL')) {
      final List<String> ruleSeparator = <String>['=', ';', ','];
      final List<String> rRule =
          _splitRule(appointment.recurrenceRule, ruleSeparator);
      final String untilValue = rRule[rRule.indexOf('UNTIL') + 1];
      DateTime recurrenceEndDate = DateTime.parse(untilValue);
      recurrenceEndDate = DateTime(recurrenceEndDate.year,
          recurrenceEndDate.month, recurrenceEndDate.day, 23, 59, 59);
      if (recurrenceEndDate.isAfter(currentMaxDate)) {
        currentMaxDate = recurrenceEndDate;
        continue;
      }
    }

    final List<DateTime> recursiveDates = _getRecurrenceDateTimeCollection(
      appointment.recurrenceRule,
      appointment._actualStartTime,
    );

    if (recursiveDates.isEmpty) {
      continue;
    }

    if (appointment.recurrenceExceptionDates == null ||
        appointment.recurrenceExceptionDates.isEmpty) {
      final DateTime date = recursiveDates[recursiveDates.length - 1];
      if (date.isAfter(currentMaxDate)) {
        currentMaxDate = date;
        continue;
      }
    }

    for (int k = recursiveDates.length - 1; k >= 0; k--) {
      final DateTime recurrenceDate = recursiveDates[k];
      bool isExceptionDate = false;
      if (appointment.recurrenceExceptionDates != null) {
        for (int i = 0; i < appointment.recurrenceExceptionDates.length; i++) {
          final DateTime exceptionDate =
              appointment.recurrenceExceptionDates[i];
          if (isSameDate(recurrenceDate, exceptionDate)) {
            isExceptionDate = true;
          }
        }
      }

      if (!isExceptionDate) {
        final DateTime recurrenceEndDate = addDuration(
            recurrenceDate,
            appointment._actualEndTime
                .difference(appointment._actualStartTime));
        if (recurrenceEndDate.isAfter(currentMaxDate)) {
          currentMaxDate = recurrenceEndDate;
          break;
        }
      }
    }
  }

  return currentMaxDate;
}

/// Calculate the minimum appointment date based on appointment collection
/// and schedule view settings.
DateTime _getMinAppointmentDate(
    List<Appointment> appointments,
    String timeZone,
    DateTime minDate,
    DateTime displayDate,
    ScheduleViewSettings scheduleViewSettings,
    bool useMobilePlatformUI) {
  /// return default min date when [hideEmptyAgendaDays] as false
  if (!scheduleViewSettings.hideEmptyScheduleWeek && useMobilePlatformUI) {
    return minDate;
  }

  DateTime currentMinDate = displayDate;
  if (appointments == null || appointments.isEmpty) {
    return currentMinDate;
  }

  /// Calculate the min appointment date based on appointments when
  /// web view enabled or [hideEmptyAgendaDays] property as enabled.
  for (int j = 0; j < appointments.length; j++) {
    final Appointment appointment = appointments[j];
    appointment._actualStartTime = _convertTimeToAppointmentTimeZone(
        appointment.startTime, appointment.startTimeZone, timeZone);

    if (appointment._actualStartTime.isBefore(currentMinDate)) {
      currentMinDate = appointment._actualStartTime;
    }

    continue;
  }

  return currentMinDate;
}

/// Check any appointment in appointments collection in between
/// the start and end date.
bool _isAppointmentBetweenDates(List<Appointment> appointments,
    DateTime startDate, DateTime endDate, String timeZone) {
  startDate = _convertToStartTime(startDate);
  endDate = _convertToEndTime(endDate);
  if (appointments == null || appointments.isEmpty) {
    return false;
  }

  for (int j = 0; j < appointments.length; j++) {
    final Appointment appointment = appointments[j];
    appointment._actualStartTime = _convertTimeToAppointmentTimeZone(
        appointment.startTime, appointment.startTimeZone, timeZone);
    appointment._actualEndTime = _convertTimeToAppointmentTimeZone(
        appointment.endTime, appointment.endTimeZone, timeZone);

    if (appointment.recurrenceRule == null ||
        appointment.recurrenceRule == '') {
      if (_isAppointmentWithinVisibleDateRange(
          appointment, startDate, endDate)) {
        return true;
      }

      continue;
    }

    if (appointment.startTime.isAfter(endDate)) {
      continue;
    }

    String rule = appointment.recurrenceRule;
    if (!rule.contains('COUNT') && !rule.contains('UNTIL')) {
      final DateFormat formatter = DateFormat('yyyyMMdd');
      final String newSubString = ';UNTIL=' + formatter.format(endDate);
      rule = rule + newSubString;
    }

    final List<String> ruleSeparator = <String>['=', ';', ','];
    final List<String> rRule = _splitRule(rule, ruleSeparator);
    if (rRule.contains('UNTIL')) {
      final String untilValue = rRule[rRule.indexOf('UNTIL') + 1];
      DateTime recurrenceEndDate = DateTime.parse(untilValue);
      recurrenceEndDate = DateTime(recurrenceEndDate.year,
          recurrenceEndDate.month, recurrenceEndDate.day, 23, 59, 59);
      if (recurrenceEndDate.isBefore(startDate)) {
        continue;
      }
    }

    final List<DateTime> recursiveDates = _getRecurrenceDateTimeCollection(
        rule, appointment._actualStartTime,
        recurrenceDuration:
            appointment._actualEndTime.difference(appointment._actualStartTime),
        specificStartDate: startDate,
        specificEndDate: endDate);

    if (recursiveDates.isEmpty) {
      continue;
    }

    if (appointment.recurrenceExceptionDates == null ||
        appointment.recurrenceExceptionDates.isEmpty) {
      return true;
    }

    for (int i = 0; i < appointment.recurrenceExceptionDates.length; i++) {
      final DateTime exceptionDate = appointment.recurrenceExceptionDates[i];
      for (int k = 0; k < recursiveDates.length; k++) {
        final DateTime recurrenceDate = recursiveDates[k];
        if (!isSameDate(recurrenceDate, exceptionDate)) {
          return true;
        }
      }
    }
  }

  return false;
}

bool _isSpanned(Appointment appointment) {
  return !(appointment._actualEndTime.day == appointment._actualStartTime.day &&
          appointment._actualEndTime.month ==
              appointment._actualStartTime.month &&
          appointment._actualEndTime.year ==
              appointment._actualStartTime.year) &&
      appointment._actualEndTime
              .difference(appointment._actualStartTime)
              .inDays >
          0;
}

/// Check and returns whether the span icon can be added for the spanning
/// appointment.
bool _canAddSpanIcon(
    List<DateTime> visibleDates, Appointment appointment, CalendarView view,
    {DateTime visibleStartDate,
    DateTime visibleEndDate,
    bool showTrailingLeadingDates}) {
  final DateTime viewStartDate = _convertToStartTime(visibleDates[0]);
  final DateTime viewEndDate =
      _convertToEndTime(visibleDates[visibleDates.length - 1]);
  final DateTime appStartTime = appointment._exactStartTime;
  final DateTime appEndTime = appointment._exactEndTime;
  if (viewStartDate == null ||
      viewEndDate == null ||
      appStartTime == null ||
      appEndTime == null) {
    return false;
  }

  if (appStartTime.isBefore(viewStartDate) || appEndTime.isAfter(viewEndDate)) {
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
        return appEndTime.difference(appStartTime).inDays <= 0 &&
            appStartTime.day != appEndTime.day;
      }
    case CalendarView.month:
      {
        if (showTrailingLeadingDates != null &&
            !showTrailingLeadingDates &&
            (appStartTime.isBefore(visibleStartDate) ||
                appEndTime.isAfter(visibleEndDate))) {
          return true;
        }

        if (appStartTime.isAfter(viewStartDate)) {
          final int appointmentStartWeek =
              appStartTime.difference(viewStartDate).inDays ~/
                  _kNumberOfDaysInWeek;
          final int appointmentEndWeek =
              appEndTime.difference(viewStartDate).inDays ~/
                  _kNumberOfDaysInWeek;
          return appointmentStartWeek != appointmentEndWeek;
        }
      }
  }

  return false;
}

TextSpan _getRecurrenceIcon(Color color, double textSize) {
  final IconData recurrenceIconData = Icons.autorenew;
  return TextSpan(
      text: String.fromCharCode(recurrenceIconData.codePoint),
      style: TextStyle(
        color: color,
        fontSize: textSize,
        fontFamily: recurrenceIconData.fontFamily,
      ));
}

/// Calculate and returns the centered y yposition for the span icon in the
/// spanning appointment UI.
double _getYPositionForSpanIcon(
    TextSpan icon, TextPainter textPainter, RRect rect) {
  /// There is a space around the font, hence to get the start position we
  /// must calculate the icon start position, apart from the space, and the
  /// value 1.5 used since the space on top and bottom of icon is not even,
  /// hence to rectify this tha value 1.5 used, and tested with multiple
  /// device.
  final int iconStartPosition = (textPainter.height -
          (icon.style.fontSize * textPainter.textScaleFactor)) ~/
      1.5;
  return rect.top -
      ((textPainter.height - rect.height) / 2) -
      iconStartPosition;
}

/// Returns the appointment text which will be displayed on spanning
/// appointments on day, timeline day, schedule and month agenda view.
/// The text will display the current date, and total dates of the spanning
/// appointment
String _getSpanAppointmentText(Appointment appointment, DateTime date) {
  final String totalDays = (_convertToEndTime(appointment._exactEndTime)
              .difference(_convertToStartTime(appointment._exactStartTime))
              .inDays +
          1)
      .toString();
  final String currentDate = (_convertToEndTime(date)
              .difference(_convertToStartTime(appointment._exactStartTime))
              .inDays +
          1)
      .toString();

  return appointment.subject + ' (Day ' + currentDate + ' / ' + totalDays + ')';
}

TextSpan _getSpanIcon(Color color, double textSize, bool isForward) {
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
bool _canAddForwardSpanIcon(DateTime appStartTime, DateTime appEndTime,
    DateTime viewStartDate, DateTime viewEndDate) {
  return appStartTime.isAfter(viewStartDate) && appEndTime.isAfter(viewEndDate);
}

/// Check and returns whether the backward icon can be added for the spanning
/// appointment.
bool _canAddBackwardSpanIcon(DateTime appStartTime, DateTime appEndTime,
    DateTime viewStartDate, DateTime viewEndDate) {
  return appStartTime.isBefore(viewStartDate) &&
      appEndTime.isBefore(viewEndDate);
}

List<Appointment> _getSelectedDateAppointments(
    List<Appointment> appointments, String timeZone, DateTime date) {
  final List<Appointment> appointmentCollection = <Appointment>[];
  if (appointments == null || appointments.isEmpty || date == null) {
    return <Appointment>[];
  }

  final DateTime startDate = _convertToStartTime(date);
  final DateTime endDate = _convertToEndTime(date);
  int count = 0;
  if (appointments != null) {
    count = appointments.length;
  }

  for (int j = 0; j < count; j++) {
    final Appointment appointment = appointments[j];
    appointment._actualStartTime = _convertTimeToAppointmentTimeZone(
        appointment.startTime, appointment.startTimeZone, timeZone);
    appointment._actualEndTime = _convertTimeToAppointmentTimeZone(
        appointment.endTime, appointment.endTimeZone, timeZone);
    appointment._exactStartTime = appointment._actualStartTime;
    appointment._exactEndTime = appointment._actualEndTime;

    if (appointment.recurrenceRule == null ||
        appointment.recurrenceRule == '') {
      if (_isAppointmentWithinVisibleDateRange(
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

Appointment _copy(Appointment appointment) {
  final Appointment copyAppointment = Appointment();
  copyAppointment.startTime = appointment.startTime;
  copyAppointment.endTime = appointment.endTime;
  copyAppointment.isAllDay = appointment.isAllDay;
  copyAppointment.subject = appointment.subject;
  copyAppointment.color = appointment.color;
  copyAppointment._actualStartTime = appointment._actualStartTime;
  copyAppointment._actualEndTime = appointment._actualEndTime;
  copyAppointment.startTimeZone = appointment.startTimeZone;
  copyAppointment.endTimeZone = appointment.endTimeZone;
  copyAppointment.recurrenceRule = appointment.recurrenceRule;
  copyAppointment.recurrenceExceptionDates =
      appointment.recurrenceExceptionDates;
  copyAppointment.notes = appointment.notes;
  copyAppointment.location = appointment.location;
  copyAppointment._isSpanned = appointment._isSpanned;
  copyAppointment._data = appointment._data;
  copyAppointment._exactStartTime = appointment._exactStartTime;
  copyAppointment._exactEndTime = appointment._exactEndTime;
  copyAppointment.resourceIds = appointment.resourceIds;
  return copyAppointment;
}

/// Returns the specific date appointment collection by filtering the
/// appointments from passed visible appointment collection.
List<Appointment> _getSpecificDateVisibleAppointment(
    SfCalendar calendar, DateTime date, List<Appointment> visibleAppointments) {
  final List<Appointment> appointmentCollection = <Appointment>[];
  if (date == null || visibleAppointments == null) {
    return appointmentCollection;
  }

  final DateTime startDate = _convertToStartTime(date);
  final DateTime endDate = _convertToEndTime(date);

  for (int j = 0; j < visibleAppointments.length; j++) {
    final Appointment appointment = visibleAppointments[j];
    if (_isAppointmentWithinVisibleDateRange(appointment, startDate, endDate)) {
      appointmentCollection.add(appointment);
    }
  }

  return appointmentCollection;
}

/// Check the appointment in between the visible date range.
bool _isAppointmentWithinVisibleDateRange(
    Appointment appointment, DateTime visibleStart, DateTime visibleEnd) {
  return _isDateRangeWithinVisibleDateRange(appointment._actualStartTime,
      appointment._actualEndTime, visibleStart, visibleEnd);
}

/// Check the date range in between the visible date range.
bool _isDateRangeWithinVisibleDateRange(DateTime startDate, DateTime endDate,
    DateTime visibleStart, DateTime visibleEnd) {
  if (startDate == null ||
      endDate == null ||
      visibleStart == null ||
      visibleEnd == null) {
    return false;
  }

  if (startDate.isAfter(visibleStart)) {
    if (startDate.isBefore(visibleEnd)) {
      return true;
    }
  } else if (startDate.day == visibleStart.day &&
      startDate.month == visibleStart.month &&
      startDate.year == visibleStart.year) {
    return true;
  } else if (endDate.isAfter(visibleStart)) {
    return true;
  }

  return false;
}

bool _isAppointmentInVisibleDateRange(
    Appointment appointment, DateTime visibleStart, DateTime visibleEnd) {
  final DateTime appStartTime = appointment._actualStartTime;
  final DateTime appEndTime = appointment._actualEndTime;
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
bool _isAppointmentDateWithinVisibleDateRange(
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

Location _timeZoneInfoToOlsonTimeZone(String windowsTimeZoneId) {
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
  olsonWindowsTimes['Pacific Standard Time (Mexico)'] = 'America/Santa_Isabel';
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

  if (olsonWindowsTimes.containsKey(windowsTimeZoneId)) {
    final String timeZone = olsonWindowsTimes[windowsTimeZoneId];
    return getLocation(timeZone);
  } else {
    return getLocation(windowsTimeZoneId);
  }
}

bool _isDateTimeEqual(DateTime date1, DateTime date2) {
  if (date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day &&
      date1.hour == date2.hour &&
      date1.minute == date2.minute) {
    return true;
  }

  return false;
}

void _resetAppointmentView(List<_AppointmentView> _appointmentCollection) {
  for (int i = 0; i < _appointmentCollection.length; i++) {
    final _AppointmentView obj = _appointmentCollection[i];
    obj.canReuse = true;
    obj.appointment = null;
    obj.position = -1;
    obj.startIndex = -1;
    obj.endIndex = -1;
    obj.maxPositions = -1;
    obj.appointmentRect = null;
  }
}

/// Returns the position for the time passed, based on the timeinterval height.
double _timeToPosition(
    SfCalendar calendar, DateTime date, double timeIntervalHeight) {
  final double singleIntervalHeightForAnHour =
      ((60 / _getTimeInterval(calendar.timeSlotViewSettings)) *
              timeIntervalHeight)
          .toDouble();
  final int hour = date.hour;
  final int minute = date.minute;
  final int seconds = date.second;
  double startHour = 0;
  if (calendar.timeSlotViewSettings != null) {
    startHour = calendar.timeSlotViewSettings.startHour;
  }

  return ((hour + (minute / 60).toDouble() + (seconds / 3600).toDouble()) *
          singleIntervalHeightForAnHour) -
      (startHour * singleIntervalHeightForAnHour).toDouble();
}

/// Returns the appointment height from the duration passed.
double _getAppointmentHeightFromDuration(
    Duration minimumDuration, SfCalendar calendar, double timeIntervalHeight) {
  if (minimumDuration == null || minimumDuration.inMinutes <= 0) {
    return 0;
  }

  final double hourHeight =
      ((60 / _getTimeInterval(calendar.timeSlotViewSettings)) *
              timeIntervalHeight)
          .toDouble();
  return minimumDuration.inMinutes * (hourHeight / 60);
}

/// Returns the minimum height for the appointment view passed, to render the
/// appointment view within this height.
double _getAppointmentMinHeight(
    SfCalendar calendar, _AppointmentView appView, double timeIntervalHeight) {
  double minHeight;

  // Appointment Default Bottom Position without considering MinHeight
  final double defaultAppHeight = _timeToPosition(
          calendar, appView.appointment._actualEndTime, timeIntervalHeight) -
      _timeToPosition(
          calendar, appView.appointment._actualStartTime, timeIntervalHeight);

  minHeight = _getAppointmentHeightFromDuration(
      calendar.timeSlotViewSettings.minimumAppointmentDuration,
      calendar,
      timeIntervalHeight);

  // Appointment Default Bottom Position - Default value as double.NaN
  if (minHeight == 0) {
    return defaultAppHeight;
  } else if ((minHeight < defaultAppHeight) ||
      (timeIntervalHeight < defaultAppHeight)) {
    // Appointment Minimum Height is smaller than default Appointment Height
    // Appointment default Height is greater than TimeIntervalHeight
    return defaultAppHeight;
  } else if (minHeight > timeIntervalHeight) {
    // Appointment Minimum Height is greater than Interval Height
    return timeIntervalHeight;
  } else {
    // Appointment with proper MinHeight and within Interval
    return minHeight; //appView.Appointment.MinHeight;
  }
}

bool _isIntersectingAppointmentInDayView(
    SfCalendar calendar,
    CalendarView view,
    Appointment currentApp,
    _AppointmentView appView,
    Appointment appointment,
    bool isAllDay,
    double timeIntervalHeight) {
  if (currentApp == appointment) {
    return false;
  }

  if (currentApp._actualStartTime.isBefore(appointment._actualEndTime) &&
      currentApp._actualStartTime.isAfter(appointment._actualStartTime)) {
    return true;
  }

  if (currentApp._actualEndTime.isAfter(appointment._actualStartTime) &&
      currentApp._actualEndTime.isBefore(appointment._actualEndTime)) {
    return true;
  }

  if (currentApp._actualEndTime.isAfter(appointment._actualEndTime) &&
      currentApp._actualStartTime.isBefore(appointment._actualStartTime)) {
    return true;
  }

  if (_isDateTimeEqual(
          currentApp._actualStartTime, appointment._actualStartTime) ||
      _isDateTimeEqual(currentApp._actualEndTime, appointment._actualEndTime)) {
    return true;
  }

  if (isAllDay) {
    return false;
  }

  /// For timeline month view, the intercepting appointments muse be calculated
  /// based on the date instead of the time, hence added this condition and
  /// returned that it's a intercept appointment or not.
  if (view == CalendarView.timelineMonth) {
    return isSameDate(
            currentApp._actualStartTime, appointment._actualStartTime) ||
        isSameDate(currentApp._actualEndTime, appointment._actualEndTime);
  }

  // Intersecting appointments by comparing appointments MinHeight instead of
  // Start and EndTime
  if (calendar.timeSlotViewSettings.minimumAppointmentDuration != null &&
      calendar.timeSlotViewSettings.minimumAppointmentDuration.inMinutes > 0 &&
      view != CalendarView.timelineMonth) {
    // Comparing appointments rendered in different dates
    if (!isSameDate(
        currentApp._actualStartTime, appointment._actualStartTime)) {
      return false;
    }

    // Comparing appointments rendered in the same date
    final double appTopPos = _timeToPosition(
        calendar, appointment._actualStartTime, timeIntervalHeight);
    final double currentAppTopPos = _timeToPosition(
        calendar, currentApp._actualStartTime, timeIntervalHeight);
    final double appHeight =
        _getAppointmentMinHeight(calendar, appView, timeIntervalHeight);
    // Height difference between previous and current appointment from top
    // position
    final double heightDiff = currentAppTopPos - appTopPos;
    if (appTopPos != currentAppTopPos && appHeight > heightDiff) {
      return true;
    }
  }

  return false;
}

_AppointmentView _getAppointmentOnPosition(
    _AppointmentView currentView, List<_AppointmentView> views) {
  if (currentView == null ||
      currentView.appointment == null ||
      views == null ||
      views.isEmpty) {
    return null;
  }

  for (final _AppointmentView view in views) {
    if (view.position == currentView.position && view != currentView) {
      return view;
    }
  }

  return null;
}

bool _iterateAppointment(Appointment app, CalendarView view, bool isAllDay) {
  final bool isTimeline = _isTimelineView(view);
  if (isAllDay) {
    if (!isTimeline && app.isAllDay) {
      app._actualEndTime = _convertToEndTime(app._actualEndTime);
      app._actualStartTime = _convertToStartTime(app._actualStartTime);
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
    app._actualEndTime = _convertToEndTime(app._actualEndTime);
    app._actualStartTime = _convertToStartTime(app._actualStartTime);
  }

  return true;
}

int _orderAppointmentsDescending(bool value, bool value1) {
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

int _orderAppointmentsAscending(bool value, bool value1) {
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

void _setAppointmentPositionAndMaxPosition(
    List<_AppointmentView> appointmentCollection,
    SfCalendar calendar,
    CalendarView view,
    List<Appointment> visibleAppointments,
    bool isAllDay,
    double timeIntervalHeight,
    [int resourceIndex]) {
  if (visibleAppointments == null) {
    return;
  }

  final List<Appointment> normalAppointments = visibleAppointments
      .where((Appointment app) => _iterateAppointment(app, view, isAllDay))
      .toList();
  normalAppointments.sort((Appointment app1, Appointment app2) =>
      app1._actualStartTime.compareTo(app2._actualStartTime));
  if (!_isTimelineView(view)) {
    normalAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsDescending(app1._isSpanned, app2._isSpanned));
    normalAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsDescending(app1.isAllDay, app2.isAllDay));
  } else {
    normalAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));
    normalAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1._isSpanned, app2._isSpanned));
  }

  final Map<int, List<_AppointmentView>> dict = <int, List<_AppointmentView>>{};
  final List<_AppointmentView> processedViews = <_AppointmentView>[];
  int maxColsCount = 1;

  for (int count = 0; count < normalAppointments.length; count++) {
    final Appointment currentAppointment = normalAppointments[count];
    //Where this condition was not needed to iOS, because we have get the
    // appointment for specific date. In Android we pass the visible date range.
    if ((view == CalendarView.workWeek ||
            view == CalendarView.timelineWorkWeek) &&
        calendar.timeSlotViewSettings.nonWorkingDays
            .contains(currentAppointment._actualStartTime.weekday) &&
        calendar.timeSlotViewSettings.nonWorkingDays
            .contains(currentAppointment._actualEndTime.weekday)) {
      continue;
    }

    List<_AppointmentView> intersectingApps;
    final _AppointmentView currentAppView = _getAppointmentView(
        currentAppointment, appointmentCollection, resourceIndex);

    for (int position = 0; position < maxColsCount; position++) {
      bool isIntersecting = false;
      for (int j = 0; j < processedViews.length; j++) {
        final _AppointmentView previousApp = processedViews[j];

        if (previousApp.position != position) {
          continue;
        }

        if (_isIntersectingAppointmentInDayView(
            calendar,
            view,
            currentAppointment,
            previousApp,
            previousApp.appointment,
            isAllDay,
            timeIntervalHeight)) {
          isIntersecting = true;

          if (intersectingApps == null) {
            final List<int> keyList = dict.keys.toList();
            for (int keyCount = 0; keyCount < keyList.length; keyCount++) {
              final int key = keyList[keyCount];
              if (dict[key].contains(previousApp)) {
                intersectingApps = dict[key];
                break;
              }
            }

            if (intersectingApps == null) {
              intersectingApps = <_AppointmentView>[];
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
        intersectingApps = <_AppointmentView>[];
        dict[dict.keys.length] = intersectingApps;
      } else if (intersectingApps.isNotEmpty) {
        position = intersectingApps
            .reduce((_AppointmentView currentAppview,
                    _AppointmentView nextAppview) =>
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
        intersectingApps = <_AppointmentView>[];
        dict[dict.keys.length] = intersectingApps;
      } else if (intersectingApps.isNotEmpty) {
        maxPosition = intersectingApps
            .reduce((_AppointmentView currentAppview,
                    _AppointmentView nextAppview) =>
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

DateTime _convertTimeToAppointmentTimeZone(
    DateTime date, String appTimeZoneId, String calendarTimeZoneId) {
  if (((appTimeZoneId == null || appTimeZoneId == '') &&
          (calendarTimeZoneId == null || calendarTimeZoneId == '')) ||
      calendarTimeZoneId == appTimeZoneId) {
    return date;
  }

  DateTime convertedDate = date;
  if (appTimeZoneId != null && appTimeZoneId != '') {
    //// Convert the date to appointment time zone
    if (appTimeZoneId == 'Dateline Standard Time') {
      convertedDate = subtractDuration(date.toUtc(), const Duration(hours: 12));
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
      /// Eg., Appointment Time zone as Eastern time zone(-5.00) and it date is
      /// Nov 1 10AM, create the date using location.
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
      final DateTime localTimeZoneDate =
          addDuration(timeZoneDate.toUtc(), offset);

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
    convertedDate ??= date;

    DateTime actualConvertedDate;
    //// Convert the converted date with calendar time zone
    if (calendarTimeZoneId == 'Dateline Standard Time') {
      actualConvertedDate =
          subtractDuration(convertedDate.toUtc(), const Duration(hours: 12));
      //// Above mentioned actual converted date hold the date value which is equal to converted date, but the time zone value changed.
      //// So convert the schedule time zone date to current time zone date for rendering the appointment.
      return DateTime(
          convertedDate.year + (actualConvertedDate.year - convertedDate.year),
          convertedDate.month +
              (actualConvertedDate.month - convertedDate.month),
          convertedDate.day + (actualConvertedDate.day - convertedDate.day),
          convertedDate.hour + (actualConvertedDate.hour - convertedDate.hour),
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

/// Return the time regions in between the visible date range.
List<TimeRegion> _getVisibleRegions(
    DateTime visibleStartDate,
    DateTime visibleEndDate,
    List<TimeRegion> regions,
    String calendarTimeZone) {
  final List<TimeRegion> regionCollection = <TimeRegion>[];
  if (visibleStartDate == null || visibleEndDate == null || regions == null) {
    return regionCollection;
  }

  final DateTime startDate = _convertToStartTime(visibleStartDate);
  final DateTime endDate = _convertToEndTime(visibleEndDate);
  for (int j = 0; j < regions.length; j++) {
    final TimeRegion region = regions[j];
    region._actualStartTime = _convertTimeToAppointmentTimeZone(
        region.startTime, region.timeZone, calendarTimeZone);
    region._actualEndTime = _convertTimeToAppointmentTimeZone(
        region.endTime, region.timeZone, calendarTimeZone);

    if (region.recurrenceRule == null || region.recurrenceRule == '') {
      if (_isDateRangeWithinVisibleDateRange(
          region._actualStartTime, region._actualEndTime, startDate, endDate)) {
        regionCollection.add(region);
      }

      continue;
    }

    _getRecurrenceRegions(
        region, regionCollection, startDate, endDate, calendarTimeZone);
  }

  return regionCollection;
}

List<Appointment> _getVisibleAppointments(
    DateTime visibleStartDate,
    DateTime visibleEndDate,
    List<Appointment> appointments,
    String calendarTimeZone,
    bool isTimelineView,
    {bool canCreateNewAppointment = true}) {
  final List<Appointment> appointmentColl = <Appointment>[];
  if (visibleStartDate == null ||
      visibleEndDate == null ||
      appointments == null) {
    return appointmentColl;
  }

  final DateTime startDate = _convertToStartTime(visibleStartDate);
  final DateTime endDate = _convertToEndTime(visibleEndDate);
  int count = 0;
  if (appointments != null) {
    count = appointments.length;
  }

  for (int j = 0; j < count; j++) {
    final Appointment appointment = appointments[j];
    appointment._actualStartTime = _convertTimeToAppointmentTimeZone(
        appointment.startTime, appointment.startTimeZone, calendarTimeZone);
    appointment._actualEndTime = _convertTimeToAppointmentTimeZone(
        appointment.endTime, appointment.endTimeZone, calendarTimeZone);

    if (appointment.recurrenceRule == null ||
        appointment.recurrenceRule == '') {
      if (_isAppointmentWithinVisibleDateRange(
          appointment, startDate, endDate)) {
        /// Stored the  actual start time, to exact start time to use the value,
        /// since, we split the span appointment into multiple instances and
        /// change the actual start and end time based on the rendering, hence
        /// to get the actual start and end time of the appointment we have
        /// stored the value in the exact start and end time.
        appointment._exactStartTime = appointment._actualStartTime;
        appointment._exactEndTime = appointment._actualEndTime;

        /// can create new appointment boolean is used to skip the new
        /// appointment creation while the appointment start and end date as
        /// different and appointment duration is not more than 24 hours.
        ///
        /// The boolean value assigned to false when calendar view as schedule.
        if (canCreateNewAppointment &&
            !(appointment._exactStartTime.day ==
                    appointment._exactEndTime.day &&
                appointment._exactStartTime.year ==
                    appointment._exactEndTime.year &&
                appointment._exactStartTime.month ==
                    appointment._exactEndTime.month) &&
            appointment._exactStartTime.isBefore(appointment._exactEndTime) &&
            (appointment._exactEndTime.difference(appointment._exactStartTime))
                    .inDays ==
                0 &&
            !appointment.isAllDay &&
            !isTimelineView) {
          for (int i = 0; i < 2; i++) {
            final Appointment spannedAppointment = _copy(appointment);
            if (i == 0) {
              spannedAppointment._actualEndTime = DateTime(
                  appointment._exactStartTime.year,
                  appointment._exactStartTime.month,
                  appointment._exactStartTime.day,
                  23,
                  59,
                  59);
            } else {
              spannedAppointment._actualStartTime = DateTime(
                  appointment._exactEndTime.year,
                  appointment._exactEndTime.month,
                  appointment._exactEndTime.day,
                  0,
                  0,
                  0);
            }

            spannedAppointment.startTime = spannedAppointment.isAllDay
                ? appointment._actualStartTime
                : _convertTimeToAppointmentTimeZone(
                    appointment._actualStartTime,
                    appointment.startTimeZone,
                    calendarTimeZone);
            spannedAppointment.endTime = spannedAppointment.isAllDay
                ? appointment._actualEndTime
                : _convertTimeToAppointmentTimeZone(appointment._actualEndTime,
                    appointment.endTimeZone, calendarTimeZone);

            // Adding Spanned Appointment only when the Appointment range
            // within the VisibleDate
            if (_isAppointmentWithinVisibleDateRange(
                spannedAppointment, startDate, endDate)) {
              appointmentColl.add(spannedAppointment);
            }
          }
        } else if (!(appointment._exactStartTime.day ==
                    appointment._exactEndTime.day &&
                appointment._exactStartTime.year ==
                    appointment._exactEndTime.year &&
                appointment._exactStartTime.month ==
                    appointment._exactEndTime.month) &&
            appointment._exactStartTime.isBefore(appointment._exactEndTime) &&
            isTimelineView) {
          //// Check the spanned appointment with in current visible dates. example visible date 21 to 27 and
          //// the appointment start and end date as 23 and 25.
          if (_isAppointmentInVisibleDateRange(
              appointment, startDate, endDate)) {
            appointment._isSpanned = _isSpanned(appointment);
            appointmentColl.add(appointment);
          } else if (_isAppointmentDateWithinVisibleDateRange(
              appointment._actualStartTime, startDate, endDate)) {
            //// Check the spanned appointment start date with in current visible dates.
            //// example visible date 21 to 27 and the appointment start and end date as 23 and 28.
            for (int i = 0; i < 2; i++) {
              final Appointment spannedAppointment = _copy(appointment);
              if (i == 0) {
                spannedAppointment._actualEndTime = DateTime(
                    endDate.year, endDate.month, endDate.day, 23, 59, 59);
              } else {
                spannedAppointment._actualStartTime =
                    DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
              }

              spannedAppointment.startTime = spannedAppointment.isAllDay
                  ? appointment._actualStartTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualStartTime,
                      appointment.startTimeZone,
                      calendarTimeZone);
              spannedAppointment.endTime = spannedAppointment.isAllDay
                  ? appointment._actualEndTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualEndTime,
                      appointment.endTimeZone,
                      calendarTimeZone);

              // Adding Spanned Appointment only when the Appointment range
              // within the VisibleDate
              if (_isAppointmentInVisibleDateRange(
                  spannedAppointment, startDate, endDate)) {
                spannedAppointment._isSpanned = _isSpanned(spannedAppointment);
                appointmentColl.add(spannedAppointment);
              }
            }
          } else if (_isAppointmentDateWithinVisibleDateRange(
              appointment._actualEndTime, startDate, endDate)) {
            //// Check the spanned appointment end date with in current visible dates. example visible date 21 to 27 and
            //// the appointment start and end date as 18 and 24.
            for (int i = 0; i < 2; i++) {
              final Appointment spannedAppointment = _copy(appointment);
              if (i == 0) {
                spannedAppointment._actualStartTime =
                    appointment._actualStartTime;
                final DateTime date =
                    addDuration(startDate, const Duration(days: -1));
                spannedAppointment._actualEndTime =
                    DateTime(date.year, date.month, date.day, 23, 59, 59);
              } else {
                spannedAppointment._actualStartTime = DateTime(
                    startDate.year, startDate.month, startDate.day, 0, 0, 0);
              }

              spannedAppointment.startTime = spannedAppointment.isAllDay
                  ? appointment._actualStartTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualStartTime,
                      appointment.startTimeZone,
                      calendarTimeZone);
              spannedAppointment.endTime = spannedAppointment.isAllDay
                  ? appointment._actualEndTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualEndTime,
                      appointment.endTimeZone,
                      calendarTimeZone);

              // Adding Spanned Appointment only when the Appointment range
              // within the VisibleDate
              if (_isAppointmentInVisibleDateRange(
                  spannedAppointment, startDate, endDate)) {
                spannedAppointment._isSpanned = _isSpanned(spannedAppointment);
                appointmentColl.add(spannedAppointment);
              }
            }
          } else if (!_isAppointmentDateWithinVisibleDateRange(
                  appointment._actualEndTime, startDate, endDate) &&
              !_isAppointmentDateWithinVisibleDateRange(
                  appointment._actualStartTime, startDate, endDate)) {
            //// Check the spanned appointment start and end date not in current visible dates. example visible date 21 to 27 and
            //// the appointment start and end date as 18 and 28.
            for (int i = 0; i < 3; i++) {
              final Appointment spannedAppointment = _copy(appointment);
              if (i == 0) {
                final DateTime date =
                    addDuration(startDate, const Duration(days: -1));
                spannedAppointment._actualEndTime =
                    DateTime(date.year, date.month, date.day, 23, 59, 59);
              } else if (i == 1) {
                spannedAppointment._actualStartTime = DateTime(
                    startDate.year, startDate.month, startDate.day, 0, 0, 0);
                spannedAppointment._actualEndTime = DateTime(
                    endDate.year, endDate.month, endDate.day, 23, 59, 59);
              } else {
                final DateTime date =
                    addDuration(endDate, const Duration(days: 1));
                spannedAppointment._actualStartTime =
                    DateTime(date.year, date.month, date.day, 0, 0, 0);
              }

              spannedAppointment.startTime = spannedAppointment.isAllDay
                  ? appointment._actualStartTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualStartTime,
                      appointment.startTimeZone,
                      calendarTimeZone);
              spannedAppointment.endTime = spannedAppointment.isAllDay
                  ? appointment._actualEndTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualEndTime,
                      appointment.endTimeZone,
                      calendarTimeZone);

              // Adding Spanned Appointment only when the Appointment range
              // within the VisibleDate
              if (_isAppointmentInVisibleDateRange(
                  spannedAppointment, startDate, endDate)) {
                spannedAppointment._isSpanned = _isSpanned(spannedAppointment);
                appointmentColl.add(spannedAppointment);
              }
            }
          } else {
            appointment._isSpanned = _isSpanned(appointment);
            appointmentColl.add(appointment);
          }
        } else {
          appointmentColl.add(appointment);
        }
      }

      continue;
    }

    _getRecurrenceAppointments(
        appointment, appointmentColl, startDate, endDate, calendarTimeZone);
  }

  return appointmentColl;
}

Appointment _cloneRecurrenceAppointment(Appointment appointment,
    int recurrenceIndex, DateTime recursiveDate, String calendarTimeZone) {
  final Appointment occurrenceAppointment = _copy(appointment);
  occurrenceAppointment._actualStartTime = recursiveDate;
  occurrenceAppointment.startTime = occurrenceAppointment.isAllDay
      ? occurrenceAppointment._actualStartTime
      : _convertTimeToAppointmentTimeZone(
          occurrenceAppointment._actualStartTime,
          occurrenceAppointment.startTimeZone,
          calendarTimeZone);

  final int minutes = appointment._actualEndTime
      .difference(appointment._actualStartTime)
      .inMinutes;
  occurrenceAppointment._actualEndTime = addDuration(
      occurrenceAppointment._actualStartTime, Duration(minutes: minutes));
  occurrenceAppointment.endTime = occurrenceAppointment.isAllDay
      ? occurrenceAppointment._actualEndTime
      : _convertTimeToAppointmentTimeZone(occurrenceAppointment._actualEndTime,
          occurrenceAppointment.endTimeZone, calendarTimeZone);
  occurrenceAppointment._isSpanned = _isSpanned(occurrenceAppointment) &&
      (occurrenceAppointment.endTime
              .difference(occurrenceAppointment.startTime)
              .inDays >
          0);
  occurrenceAppointment._exactStartTime =
      occurrenceAppointment._actualStartTime;
  occurrenceAppointment._exactEndTime = occurrenceAppointment._actualEndTime;

  return occurrenceAppointment;
}

List<Appointment> _generateCalendarAppointments(
    CalendarDataSource calendarData, SfCalendar calendar,
    [List<dynamic> appointments]) {
  if (calendarData == null) {
    return null;
  }

  final List<dynamic> dataSource = appointments ?? calendarData.appointments;
  if (dataSource == null) {
    return null;
  }

  final List<Appointment> calendarAppointmentCollection = <Appointment>[];
  if (dataSource.isNotEmpty && dataSource[0] is Appointment) {
    for (int i = 0; i < dataSource.length; i++) {
      final Appointment item = dataSource[i];
      final DateTime appStartTime = item.startTime;
      final DateTime appEndTime = item.endTime;
      item._data = item;
      item._actualStartTime = !item.isAllDay
          ? _convertTimeToAppointmentTimeZone(
              item.startTime, item.startTimeZone, calendar.timeZone)
          : item.startTime;
      item._actualEndTime = !item.isAllDay
          ? _convertTimeToAppointmentTimeZone(
              item.endTime, item.endTimeZone, calendar.timeZone)
          : item.endTime;
      _updateTimeForInvalidEndTime(item, calendar.timeZone);
      calendarAppointmentCollection.add(item);

      item._isSpanned =
          _isSpanned(item) && (appEndTime.difference(appStartTime).inDays > 0);
    }
  } else {
    for (int i = 0; i < dataSource.length; i++) {
      final dynamic item = dataSource[i];
      final Appointment app = _createAppointment(item, calendar);

      final DateTime appStartTime = app.startTime;
      final DateTime appEndTime = app.endTime;
      app._isSpanned =
          _isSpanned(app) && (appEndTime.difference(appStartTime).inDays > 0);
      calendarAppointmentCollection.add(app);
    }
  }

  return calendarAppointmentCollection;
}

Appointment _createAppointment(Object appointmentObject, SfCalendar calendar) {
  final Appointment app = Appointment();
  final int index = calendar.dataSource.appointments.indexOf(appointmentObject);
  app.startTime = calendar.dataSource.getStartTime(index);
  app.endTime = calendar.dataSource.getEndTime(index);
  app.subject = calendar.dataSource.getSubject(index);
  app.isAllDay = calendar.dataSource.isAllDay(index);
  app.color = calendar.dataSource.getColor(index);
  app.notes = calendar.dataSource.getNotes(index);
  app.location = calendar.dataSource.getLocation(index);
  app.startTimeZone = calendar.dataSource.getStartTimeZone(index);
  app.endTimeZone = calendar.dataSource.getEndTimeZone(index);
  app.recurrenceRule = calendar.dataSource.getRecurrenceRule(index);
  app.recurrenceExceptionDates =
      calendar.dataSource.getRecurrenceExceptionDates(index);
  app.resourceIds = calendar.dataSource.getResourceIds(index);
  app._data = appointmentObject;
  app._actualStartTime = !app.isAllDay
      ? _convertTimeToAppointmentTimeZone(
          app.startTime, app.startTimeZone, calendar.timeZone)
      : app.startTime;
  app._actualEndTime = !app.isAllDay
      ? _convertTimeToAppointmentTimeZone(
          app.endTime, app.endTimeZone, calendar.timeZone)
      : app.endTime;
  _updateTimeForInvalidEndTime(app, calendar.timeZone);
  return app;
}

void _updateTimeForInvalidEndTime(
    Appointment appointment, String scheduleTimeZone) {
  if (appointment._actualEndTime.isBefore(appointment._actualStartTime) &&
      !appointment.isAllDay) {
    appointment.endTime = _convertTimeToAppointmentTimeZone(
        addDuration(appointment._actualStartTime, const Duration(minutes: 30)),
        appointment.endTimeZone,
        scheduleTimeZone);
    appointment._actualEndTime = !appointment.isAllDay
        ? _convertTimeToAppointmentTimeZone(
            appointment.endTime, appointment.endTimeZone, scheduleTimeZone)
        : appointment.endTime;
  }
}

void _getRecurrenceAppointments(
    Appointment appointment,
    List<Appointment> appointments,
    DateTime visibleStartDate,
    DateTime visibleEndDate,
    String scheduleTimeZone) {
  final DateTime appStartTime = appointment._actualStartTime;
  int recurrenceIndex = 0;
  if (appStartTime.isAfter(visibleEndDate)) {
    return;
  }

  String rule = appointment.recurrenceRule;
  if (!rule.contains('COUNT') && !rule.contains('UNTIL')) {
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final String newSubString = ';UNTIL=' + formatter.format(visibleEndDate);
    rule = rule + newSubString;
  }

  List<DateTime> recursiveDates;
  DateTime endDate;
  final List<String> ruleSeparator = <String>['=', ';', ','];
  final List<String> rRule =
      _splitRule(appointment.recurrenceRule, ruleSeparator);
  if (appointment.recurrenceRule.contains('UNTIL')) {
    final String untilValue = rRule[rRule.indexOf('UNTIL') + 1];
    endDate = DateTime.parse(untilValue);
    endDate = addDuration(endDate,
        appointment._actualEndTime.difference(appointment._actualStartTime));
    endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
  } else if (appointment.recurrenceRule.contains('COUNT')) {
    recursiveDates = _getRecurrenceDateTimeCollection(
        appointment.recurrenceRule, appointment._actualStartTime);
    endDate = recursiveDates.last;
    endDate = addDuration(endDate,
        appointment._actualEndTime.difference(appointment._actualStartTime));
    endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
  }

  if ((appointment.recurrenceRule.contains('UNTIL') ||
          appointment.recurrenceRule.contains('COUNT')) &&
      !(appStartTime.isBefore(visibleEndDate) &&
          visibleStartDate.isBefore(endDate))) {
    return;
  }

  recursiveDates = _getRecurrenceDateTimeCollection(
      rule, appointment._actualStartTime,
      recurrenceDuration:
          appointment._actualEndTime.difference(appointment._actualStartTime),
      specificStartDate: visibleStartDate,
      specificEndDate: visibleEndDate);

  for (int j = 0; j < recursiveDates.length; j++) {
    final DateTime recursiveDate = recursiveDates[j];
    if (appointment.recurrenceExceptionDates != null) {
      bool isDateContains = false;
      for (int i = 0; i < appointment.recurrenceExceptionDates.length; i++) {
        final DateTime date = _convertTimeToAppointmentTimeZone(
            appointment.recurrenceExceptionDates[i], '', scheduleTimeZone);
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

    final Appointment occurrenceAppointment = _cloneRecurrenceAppointment(
        appointment, recurrenceIndex, recursiveDate, scheduleTimeZone);
    recurrenceIndex++;
    appointments.add(occurrenceAppointment);
  }
}

/// Get the recurrence time regions in between the visible date range.
void _getRecurrenceRegions(
    TimeRegion region,
    List<TimeRegion> regions,
    DateTime visibleStartDate,
    DateTime visibleEndDate,
    String calendarTimeZone) {
  final DateTime regionStartDate = region._actualStartTime;
  if (regionStartDate.isAfter(visibleEndDate)) {
    return;
  }

  String rule = region.recurrenceRule;
  if (!rule.contains('COUNT') && !rule.contains('UNTIL')) {
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final String newSubString = ';UNTIL=' + formatter.format(visibleEndDate);
    rule = rule + newSubString;
  }

  List<DateTime> recursiveDates;
  DateTime endDate;
  final List<String> ruleSeparator = <String>['=', ';', ','];
  final List<String> rRule = _splitRule(region.recurrenceRule, ruleSeparator);
  if (region.recurrenceRule.contains('UNTIL')) {
    final String untilValue = rRule[rRule.indexOf('UNTIL') + 1];
    endDate = DateTime.parse(untilValue);
    endDate = addDuration(
        endDate, region._actualEndTime.difference(region._actualStartTime));
    endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
  } else if (region.recurrenceRule.contains('COUNT')) {
    recursiveDates = _getRecurrenceDateTimeCollection(
        region.recurrenceRule, region._actualStartTime);
    endDate = recursiveDates.last;
    endDate = addDuration(
        endDate, region._actualEndTime.difference(region._actualStartTime));
    endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
  }

  if ((region.recurrenceRule.contains('UNTIL') ||
          region.recurrenceRule.contains('COUNT')) &&
      !(regionStartDate.isBefore(visibleEndDate) &&
          visibleStartDate.isBefore(endDate))) {
    return;
  }

  recursiveDates = _getRecurrenceDateTimeCollection(
      rule, region._actualStartTime,
      recurrenceDuration:
          region._actualEndTime.difference(region._actualStartTime),
      specificStartDate: visibleStartDate,
      specificEndDate: visibleEndDate);

  for (int j = 0; j < recursiveDates.length; j++) {
    final DateTime recursiveDate = recursiveDates[j];
    if (region.recurrenceExceptionDates != null) {
      bool isDateContains = false;
      for (int i = 0; i < region.recurrenceExceptionDates.length; i++) {
        final DateTime date = _convertTimeToAppointmentTimeZone(
            region.recurrenceExceptionDates[i], '', calendarTimeZone);
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

    final TimeRegion occurrenceRegion =
        _cloneRecurrenceRegion(region, recursiveDate, calendarTimeZone);
    regions.add(occurrenceRegion);
  }
}

/// Returns the  timeline appointment height based on the settings value.
double _getTimelineAppointmentHeight(
    TimeSlotViewSettings settings, CalendarView view) {
  if (settings.timelineAppointmentHeight != -1) {
    return settings.timelineAppointmentHeight;
  }

  if (view == CalendarView.timelineMonth) {
    return 20;
  }

  return 60;
}

/// Used to clone the time region with new values.
TimeRegion _cloneRecurrenceRegion(
    TimeRegion region, DateTime recursiveDate, String calendarTimeZone) {
  final int minutes =
      region._actualEndTime.difference(region._actualStartTime).inMinutes;
  final DateTime actualEndTime =
      addDuration(recursiveDate, Duration(minutes: minutes));
  final DateTime startDate = _convertTimeToAppointmentTimeZone(
      recursiveDate, region.timeZone, calendarTimeZone);

  final DateTime endDate = _convertTimeToAppointmentTimeZone(
      actualEndTime, region.timeZone, calendarTimeZone);

  final TimeRegion occurrenceRegion =
      region.copyWith(startTime: startDate, endTime: endDate);
  occurrenceRegion._actualStartTime = recursiveDate;
  occurrenceRegion._actualEndTime = actualEndTime;
  return occurrenceRegion;
}

/// Returns the index of the passed id's resource from the passed resource
/// collection.
int _getResourceIndex(List<CalendarResource> resourceCollection, Object id) {
  if (resourceCollection == null || resourceCollection.isEmpty) {
    return -1;
  }

  return resourceCollection.indexWhere((resource) => resource.id == id);
}
