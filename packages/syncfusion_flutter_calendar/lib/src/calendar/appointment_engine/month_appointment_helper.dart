import 'package:syncfusion_flutter_core/core.dart';

import '../common/calendar_view_helper.dart';
import '../common/date_time_engine.dart';
import 'appointment_helper.dart';

// ignore: avoid_classes_with_only_static_members
/// Holds the static helper methods used for appointment rendering in calendar
/// month view.
class MonthAppointmentHelper {
  static void _createVisibleAppointments(
      List<AppointmentView> appointmentCollection,
      List<CalendarAppointment> visibleAppointments,
      List<DateTime> visibleDates,
      int startIndex,
      int endIndex) {
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView appointmentView = appointmentCollection[i];
      appointmentView.endIndex = -1;
      appointmentView.startIndex = -1;
      appointmentView.isSpanned = false;
      appointmentView.position = -1;
      appointmentView.maxPositions = 0;
      appointmentView.canReuse = true;
    }

    for (int i = 0; i < visibleAppointments.length; i++) {
      final CalendarAppointment appointment = visibleAppointments[i];
      if (!appointment.isSpanned &&
          appointment.actualStartTime.day == appointment.actualEndTime.day &&
          appointment.actualStartTime.month ==
              appointment.actualEndTime.month) {
        final AppointmentView appointmentView =
            _createAppointmentView(appointmentCollection);
        appointmentView.appointment = appointment;
        appointmentView.canReuse = false;
        appointmentView.startIndex =
            getDateIndex(appointment.actualStartTime, visibleDates);

        /// Check the index value before the view start index then assign the
        /// start index as visible start index
        /// eg., if show trailing and leading dates as disabled and recurrence
        /// appointment spanned from Aug 31 to Sep 2 then
        /// In Aug month view, visible start and end index as 6, 36 but
        /// appointment start and end index as 36, 38
        /// In Sep month view visible start and end index as 2, 31 but
        /// appointment start and end index as 1, 3
        if (appointmentView.startIndex == -1 ||
            appointmentView.startIndex < startIndex) {
          appointmentView.startIndex = startIndex;
        }

        appointmentView.endIndex =
            getDateIndex(appointment.actualEndTime, visibleDates);

        /// Check the index value after the view end index then assign the
        /// end index as visible end index
        /// eg., if show trailing and leading dates as disabled and recurrence
        /// appointment spanned from Aug 31 to Sep 2 then
        /// In Aug month view, visible start and end index as 6, 36 but
        /// appointment start and end index as 36, 38
        /// In Sep month view visible start and end index as 2, 31 but
        /// appointment start and end index as 1, 3
        if (appointmentView.endIndex == -1 ||
            appointmentView.endIndex > endIndex) {
          appointmentView.endIndex = endIndex;
        }

        if (!appointmentCollection.contains(appointmentView)) {
          appointmentCollection.add(appointmentView);
        }
      } else {
        final AppointmentView appointmentView =
            _createAppointmentView(appointmentCollection);
        appointmentView.appointment = appointment;
        appointmentView.canReuse = false;
        appointmentView.startIndex =
            getDateIndex(appointment.actualStartTime, visibleDates);

        /// Check the index value before the view start index then assign the
        /// start index as visible start index
        /// eg., if show trailing and leading dates as disabled and recurrence
        /// appointment spanned from Aug 31 to Sep 2 then
        /// In Aug month view, visible start and end index as 6, 36 but
        /// appointment start and end index as 36, 38
        /// In Sep month view visible start and end index as 2, 31 but
        /// appointment start and end index as 1, 3
        if (appointmentView.startIndex == -1 ||
            appointmentView.startIndex < startIndex) {
          appointmentView.startIndex = startIndex;
        }

        appointmentView.endIndex =
            getDateIndex(appointment.actualEndTime, visibleDates);

        /// Check the index value after the view end index then assign the
        /// end index as visible end index
        /// eg., if show trailing and leading dates as disabled and recurrence
        /// appointment spanned from Aug 31 to Sep 2 then
        /// In Aug month view, visible start and end index as 6, 36 but
        /// appointment start and end index as 36, 38
        /// In Sep month view visible start and end index as 2, 31 but
        /// appointment start and end index as 1, 3
        if (appointmentView.endIndex == -1 ||
            appointmentView.endIndex > endIndex) {
          appointmentView.endIndex = endIndex;
        }

        _createAppointmentInfoForSpannedAppointment(
            appointmentView, appointmentCollection);
      }
    }
  }

  static void _createAppointmentInfoForSpannedAppointment(
      AppointmentView appointmentView,
      List<AppointmentView> appointmentCollection) {
    if (appointmentView.startIndex ~/ DateTime.daysPerWeek !=
        appointmentView.endIndex ~/ DateTime.daysPerWeek) {
      final int endIndex = appointmentView.endIndex;
      appointmentView.endIndex =
          (((appointmentView.startIndex ~/ DateTime.daysPerWeek) + 1) *
                  DateTime.daysPerWeek) -
              1;
      appointmentView.isSpanned = true;
      if (!appointmentCollection.contains(appointmentView)) {
        appointmentCollection.add(appointmentView);
      }

      final AppointmentView appointmentView1 =
          _createAppointmentView(appointmentCollection);
      appointmentView1.appointment = appointmentView.appointment;
      appointmentView1.canReuse = false;
      appointmentView1.startIndex = appointmentView.endIndex + 1;
      appointmentView1.endIndex = endIndex;
      _createAppointmentInfoForSpannedAppointment(
          appointmentView1, appointmentCollection);
    } else {
      appointmentView.isSpanned = true;
      if (!appointmentCollection.contains(appointmentView)) {
        appointmentCollection.add(appointmentView);
      }
    }
  }

  static void _setAppointmentPosition(
      List<AppointmentView> appointmentViewCollection,
      AppointmentView appointmentView,
      int viewIndex) {
    for (int j = 0; j < appointmentViewCollection.length; j++) {
      //// Break when the collection reaches current appointment
      if (j >= viewIndex) {
        break;
      }

      final AppointmentView prevAppointmentView = appointmentViewCollection[j];
      if (!_isInterceptAppointments(appointmentView, prevAppointmentView)) {
        continue;
      }

      if (appointmentView.position == prevAppointmentView.position) {
        appointmentView.position = appointmentView.position + 1;
        appointmentView.maxPositions = appointmentView.position;
        prevAppointmentView.maxPositions = appointmentView.position;
        _setAppointmentPosition(
            appointmentViewCollection, appointmentView, viewIndex);
        break;
      }
    }
  }

  static bool _isInterceptAppointments(
      AppointmentView appointmentView1, AppointmentView appointmentView2) {
    if (appointmentView1.startIndex <= appointmentView2.startIndex &&
            appointmentView1.endIndex >= appointmentView2.startIndex ||
        appointmentView2.startIndex <= appointmentView1.startIndex &&
            appointmentView2.endIndex >= appointmentView1.startIndex) {
      return true;
    }

    if (appointmentView1.startIndex <= appointmentView2.endIndex &&
            appointmentView1.endIndex >= appointmentView2.endIndex ||
        appointmentView2.startIndex <= appointmentView1.endIndex &&
            appointmentView2.endIndex >= appointmentView1.endIndex) {
      return true;
    }

    return false;
  }

  /// Sort the appointment based on appointment start date, if both
  /// the appointments have same start date then the appointment sorted based on
  /// end date and its interval(difference between end time and start time).
  static int _orderAppointmentViewBySpanned(
      AppointmentView appointmentView1, AppointmentView appointmentView2) {
    if (appointmentView1.appointment == null ||
        appointmentView2.appointment == null) {
      return 0;
    }

    final CalendarAppointment appointment1 = appointmentView1.appointment!;
    final CalendarAppointment appointment2 = appointmentView2.appointment!;

    /// Calculate the both appointment start time based on isAllDay property.
    final DateTime startTime1 = appointment1.isAllDay
        ? AppointmentHelper.convertToStartTime(appointment1.exactStartTime)
        : appointment1.exactStartTime;
    final DateTime startTime2 = appointment2.isAllDay
        ? AppointmentHelper.convertToStartTime(appointment2.exactStartTime)
        : appointment2.exactStartTime;

    /// Check if both the appointments does not starts with same date then
    /// order the appointment based on its start time value.
    /// Eg., app1 start with Nov3 and app2 start with Nov4 then compare both
    /// the date value and it returns
    /// a negative value if app1 start time before of app2 start time,
    /// value 0 if app1 start time equal with app2 start time, and
    /// a positive value otherwise (app1 start time after of app2 start time).
    if (!isSameDate(startTime1, startTime2)) {
      return startTime1.compareTo(startTime2);
    }

    final DateTime endTime1 = appointment1.isAllDay
        ? AppointmentHelper.convertToEndTime(appointment1.exactEndTime)
        : appointment1.exactEndTime;
    final DateTime endTime2 = appointment2.isAllDay
        ? AppointmentHelper.convertToEndTime(appointment2.exactEndTime)
        : appointment2.exactEndTime;

    /// Check both the appointments have same start and end time then sort the
    /// appointments based on start time value.
    /// Eg., app1 start with Nov3 10AM and ends with 11AM and app2 starts with
    /// Nov3 9AM and ends with 11AM then swap the app2 before of app1.
    if (isSameDate(endTime1, endTime2)) {
      if (appointment1.isAllDay && appointment2.isAllDay) {
        return 0;
      } else if (appointment1.isAllDay && !appointment2.isAllDay) {
        return -1;
      } else if (appointment2.isAllDay && !appointment1.isAllDay) {
        return 1;
      }

      /// Check second appointment start time after the first appointment, then
      /// swap list index value
      return startTime1.compareTo(startTime2);
    }

    /// Check second appointment occupy more cells than first appointment, then
    /// swap list index value.
    /// Eg., app1 start with Nov3 10AM and ends with Nov5 11AM and app2 starts
    /// with Nov3 9AM and ends with Nov4 11AM then swap the app1 before of app2.
    return AppointmentHelper.getDifference(endTime2, startTime2)
        .inMinutes
        .abs()
        .compareTo(AppointmentHelper.getDifference(endTime1, startTime1)
            .inMinutes
            .abs());
  }

  static void _updateAppointmentPosition(
      List<AppointmentView> appointmentCollection,
      Map<int, List<AppointmentView>> indexAppointments) {
    appointmentCollection.sort(_orderAppointmentViewBySpanned);

    for (int j = 0; j < appointmentCollection.length; j++) {
      final AppointmentView appointmentView = appointmentCollection[j];
      if (appointmentView.canReuse || appointmentView.appointment == null) {
        continue;
      }

      appointmentView.position = 1;
      appointmentView.maxPositions = 1;
      _setAppointmentPosition(appointmentCollection, appointmentView, j);

      /// Add the appointment views to index appointment based on start and end
      /// index. It is used to get the visible index appointments.
      for (int i = appointmentView.startIndex;
          i <= appointmentView.endIndex;
          i++) {
        /// Check the index already have appointments, if exists then add the
        /// current appointment to that collection, else create the index and
        /// create new collection with current appointment.
        final List<AppointmentView>? existingAppointments =
            indexAppointments[i];
        if (existingAppointments != null) {
          existingAppointments.add(appointmentView);
          indexAppointments[i] = existingAppointments;
        } else {
          indexAppointments[i] = <AppointmentView>[appointmentView];
        }
      }
    }
  }

  /// Return the month cell dates index from visible dates.
  static int getDateIndex(DateTime date, List<DateTime> visibleDates) {
    final int count = visibleDates.length;
    DateTime dateTime = visibleDates[count - DateTime.daysPerWeek];
    int row = 0;
    for (int i = count - DateTime.daysPerWeek;
        i >= 0;
        i -= DateTime.daysPerWeek) {
      final DateTime currentDate = visibleDates[i];
      if (currentDate.isBefore(date) ||
          (currentDate.day == date.day &&
              currentDate.month == date.month &&
              currentDate.year == date.year)) {
        dateTime = currentDate;
        row = i ~/ DateTime.daysPerWeek;
        break;
      }
    }

    final DateTime endDateTime =
        DateTimeHelper.getDateTimeValue(addDays(dateTime, 6));
    int currentViewIndex = 0;
    while (
        dateTime.isBefore(endDateTime) || isSameDate(dateTime, endDateTime)) {
      if (isSameDate(dateTime, date)) {
        return (row * DateTime.daysPerWeek) + currentViewIndex;
      }

      currentViewIndex++;
      dateTime = DateTimeHelper.getDateTimeValue(addDays(dateTime, 1));
    }

    return -1;
  }

  static AppointmentView _createAppointmentView(
      List<AppointmentView> appointmentCollection) {
    AppointmentView? appointmentView;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView view = appointmentCollection[i];
      if (view.canReuse) {
        appointmentView = view;
        break;
      }
    }

    appointmentView ??= AppointmentView();
    appointmentView.endIndex = -1;
    appointmentView.startIndex = -1;
    appointmentView.position = -1;
    appointmentView.maxPositions = 0;
    appointmentView.isSpanned = false;
    appointmentView.appointment = null;
    appointmentView.canReuse = true;
    return appointmentView;
  }

  /// Update the appointment view details based on visible appointment and
  /// visible dates.
  static void updateAppointmentDetails(
      List<CalendarAppointment> visibleAppointments,
      List<AppointmentView> appointmentCollection,
      List<DateTime> visibleDates,
      Map<int, List<AppointmentView>> indexAppointments,
      int startIndex,
      int endIndex) {
    _createVisibleAppointments(appointmentCollection, visibleAppointments,
        visibleDates, startIndex, endIndex);
    if (visibleAppointments.isNotEmpty) {
      _updateAppointmentPosition(appointmentCollection, indexAppointments);
    }
  }
}
