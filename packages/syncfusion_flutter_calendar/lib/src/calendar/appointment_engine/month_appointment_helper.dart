part of calendar;

_AppointmentView _getAppointmentView(
    Appointment appointment, _AppointmentPainter appointmentPainter,
    [int resourceIndex]) {
  _AppointmentView appointmentRenderer;
  for (int i = 0; i < appointmentPainter._appointmentCollection.length; i++) {
    final _AppointmentView view = appointmentPainter._appointmentCollection[i];
    if (view.appointment == null) {
      appointmentRenderer = view;
      break;
    }
  }

  if (appointmentRenderer == null) {
    appointmentRenderer = _AppointmentView();
    appointmentRenderer.appointment = appointment;
    appointmentRenderer.canReuse = false;
    appointmentRenderer.resourceIndex = resourceIndex;
    appointmentPainter._appointmentCollection.add(appointmentRenderer);
  }

  appointmentRenderer.appointment = appointment;
  appointmentRenderer.canReuse = false;
  appointmentRenderer.resourceIndex = resourceIndex;
  return appointmentRenderer;
}

void _createVisibleAppointments(
    _AppointmentPainter appointmentPainter, int startIndex, int endIndex) {
  for (int i = 0; i < appointmentPainter._appointmentCollection.length; i++) {
    final _AppointmentView appointmentView =
        appointmentPainter._appointmentCollection[i];
    appointmentView.endIndex = -1;
    appointmentView.startIndex = -1;
    appointmentView.isSpanned = false;
    appointmentView.position = -1;
    appointmentView.maxPositions = 0;
    appointmentView.canReuse = true;
  }

  if (appointmentPainter.visibleAppointments == null) {
    return;
  }

  for (int i = 0; i < appointmentPainter.visibleAppointments.length; i++) {
    final Appointment appointment = appointmentPainter.visibleAppointments[i];
    if (!appointment._isSpanned &&
        appointment._actualStartTime.day == appointment._actualEndTime.day &&
        appointment._actualStartTime.month ==
            appointment._actualEndTime.month) {
      final _AppointmentView appointmentView =
          _createAppointmentView(appointmentPainter);
      appointmentView.appointment = appointment;
      appointmentView.canReuse = false;
      appointmentView.startIndex =
          _getDateIndex(appointment._actualStartTime, appointmentPainter);

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
          _getDateIndex(appointment._actualEndTime, appointmentPainter);

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

      if (!appointmentPainter._appointmentCollection
          .contains(appointmentView)) {
        appointmentPainter._appointmentCollection.add(appointmentView);
      }
    } else {
      final _AppointmentView appointmentView =
          _createAppointmentView(appointmentPainter);
      appointmentView.appointment = appointment;
      appointmentView.canReuse = false;
      appointmentView.startIndex =
          _getDateIndex(appointment._actualStartTime, appointmentPainter);

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
          _getDateIndex(appointment._actualEndTime, appointmentPainter);

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
          appointmentView, appointmentPainter);
    }
  }
}

void _createAppointmentInfoForSpannedAppointment(
    _AppointmentView appointmentView, _AppointmentPainter appointmentPainter) {
  if (appointmentView.startIndex ~/ _kNumberOfDaysInWeek !=
      appointmentView.endIndex ~/ _kNumberOfDaysInWeek) {
    final int endIndex = appointmentView.endIndex;
    appointmentView.endIndex =
        ((((appointmentView.startIndex ~/ _kNumberOfDaysInWeek) + 1) *
                    _kNumberOfDaysInWeek) -
                1)
            .toInt();
    appointmentView.isSpanned = true;
    if (appointmentPainter._appointmentCollection != null &&
        !appointmentPainter._appointmentCollection.contains(appointmentView)) {
      appointmentPainter._appointmentCollection.add(appointmentView);
    }

    final _AppointmentView appointmentView1 =
        _createAppointmentView(appointmentPainter);
    appointmentView1.appointment = appointmentView.appointment;
    appointmentView1.canReuse = false;
    appointmentView1.startIndex = appointmentView.endIndex + 1;
    appointmentView1.endIndex = endIndex;
    _createAppointmentInfoForSpannedAppointment(
        appointmentView1, appointmentPainter);
  } else {
    appointmentView.isSpanned = true;
    if (!appointmentPainter._appointmentCollection.contains(appointmentView)) {
      appointmentPainter._appointmentCollection.add(appointmentView);
    }
  }
}

int _orderAppointmentViewBySpanned(
    _AppointmentView appointmentView1, _AppointmentView appointmentView2) {
  final int boolValue1 = appointmentView1.isSpanned ? -1 : 1;
  final int boolValue2 = appointmentView2.isSpanned ? -1 : 1;

  if (boolValue1 == boolValue2 &&
      appointmentView2.startIndex == appointmentView1.startIndex) {
    return (appointmentView2.endIndex - appointmentView2.startIndex)
        .compareTo(appointmentView1.endIndex - appointmentView1.startIndex);
  }

  return boolValue1.compareTo(boolValue2);
}

void _setAppointmentPosition(List<_AppointmentView> appointmentViewCollection,
    _AppointmentView appointmentView, int viewIndex) {
  for (int j = 0; j < appointmentViewCollection.length; j++) {
    //// Break when the collection reaches current appointment
    if (j >= viewIndex) {
      break;
    }

    final _AppointmentView prevAppointmentView = appointmentViewCollection[j];
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

bool _isInterceptAppointments(
    _AppointmentView appointmentView1, _AppointmentView appointmentView2) {
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

void _updateAppointmentPosition(_AppointmentPainter appointmentPainter) {
  appointmentPainter._appointmentCollection
      .sort((_AppointmentView app1, _AppointmentView app2) {
    if (app1.appointment?._actualStartTime != null &&
        app2.appointment?._actualStartTime != null) {
      return app1.appointment._actualStartTime
          .compareTo(app2.appointment._actualStartTime);
    }

    return 0;
  });
  appointmentPainter._appointmentCollection.sort(
      (_AppointmentView app1, _AppointmentView app2) =>
          _orderAppointmentViewBySpanned(app1, app2));

  for (int j = 0; j < appointmentPainter._appointmentCollection.length; j++) {
    final _AppointmentView appointmentView =
        appointmentPainter._appointmentCollection[j];
    appointmentView.position = 1;
    appointmentView.maxPositions = 1;
    _setAppointmentPosition(
        appointmentPainter._appointmentCollection, appointmentView, j);

    /// Add the appointment views to index appointment based on start and end
    /// index. It is used to get the visible index appointments.
    for (int i = appointmentView.startIndex;
        i <= appointmentView.endIndex;
        i++) {
      /// Check the index already have appointments, if exists then add the
      /// current appointment to that collection, else create the index and
      /// create new collection with current appointment.
      if (appointmentPainter._indexAppointments.containsKey(i)) {
        final List<_AppointmentView> existingAppointments =
            appointmentPainter._indexAppointments[i];
        existingAppointments.add(appointmentView);
        appointmentPainter._indexAppointments[i] = existingAppointments;
      } else {
        appointmentPainter._indexAppointments[i] = <_AppointmentView>[
          appointmentView
        ];
      }
    }
  }
}

int _getDateIndex(DateTime date, _AppointmentPainter appointmentPainter) {
  DateTime dateTime = appointmentPainter.visibleDates[
      appointmentPainter.visibleDates.length - _kNumberOfDaysInWeek];
  int row = 0;
  for (int i = appointmentPainter.visibleDates.length - _kNumberOfDaysInWeek;
      i >= 0;
      i -= _kNumberOfDaysInWeek) {
    DateTime currentDate = appointmentPainter.visibleDates[i];
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day,
        currentDate.hour, currentDate.minute, currentDate.second);
    if (currentDate.isBefore(date) ||
        (currentDate.day == date.day &&
            currentDate.month == date.month &&
            currentDate.year == date.year)) {
      dateTime = currentDate;
      row = i ~/ _kNumberOfDaysInWeek;
      break;
    }
  }

  final DateTime endDateTime = addDuration(dateTime, const Duration(days: 6));
  int currentViewIndex = 0;
  while (dateTime.isBefore(endDateTime) ||
      (dateTime.day == endDateTime.day &&
          dateTime.month == endDateTime.month &&
          dateTime.year == endDateTime.year)) {
    if (dateTime.day == date.day &&
        dateTime.month == date.month &&
        dateTime.year == date.year) {
      return ((row * _kNumberOfDaysInWeek) + currentViewIndex).toInt();
    }

    currentViewIndex++;
    dateTime = addDuration(dateTime, const Duration(days: 1));
  }

  return -1;
}

_AppointmentView _createAppointmentView(
    _AppointmentPainter appointmentPainter) {
  _AppointmentView appointmentView;
  for (int i = 0; i < appointmentPainter._appointmentCollection.length; i++) {
    final _AppointmentView view = appointmentPainter._appointmentCollection[i];
    if (view.canReuse) {
      appointmentView = view;
      break;
    }
  }

  appointmentView = appointmentView ?? _AppointmentView();

  appointmentView.endIndex = -1;
  appointmentView.startIndex = -1;
  appointmentView.position = -1;
  appointmentView.maxPositions = 0;
  appointmentView.isSpanned = false;
  appointmentView.appointment = null;
  appointmentView.canReuse = true;
  return appointmentView;
}

void _updateAppointment(
    _AppointmentPainter appointmentPainter, int startIndex, int endIndex) {
  _createVisibleAppointments(appointmentPainter, startIndex, endIndex);
  if (appointmentPainter.visibleAppointments != null &&
      appointmentPainter.visibleAppointments.isNotEmpty) {
    _updateAppointmentPosition(appointmentPainter);
  }
}
