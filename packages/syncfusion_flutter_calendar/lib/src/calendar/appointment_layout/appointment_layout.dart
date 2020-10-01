part of calendar;

class _AppointmentView {
  bool canReuse;
  int startIndex = -1;
  int endIndex = -1;
  Appointment appointment;
  int position = -1;
  int maxPositions = -1;
  bool isSpanned = false;
  RRect appointmentRect;
  int resourceIndex = -1;
}

class _AppointmentPainter extends CustomPainter {
  _AppointmentPainter(
      this.calendar,
      this.view,
      this.visibleDates,
      this.visibleAppointments,
      this.timeIntervalHeight,
      this.repaintNotifier,
      this.calendarTheme,
      this.isRTL,
      this.appointmentHoverPosition,
      this.resourceCollection,
      this.resourceItemHeight,
      this.textScaleFactor,
      {this.updateCalendarState})
      : super(repaint: repaintNotifier);

  SfCalendar calendar;
  final CalendarView view;
  final List<DateTime> visibleDates;
  final double timeIntervalHeight;
  final _UpdateCalendarState updateCalendarState;
  final bool isRTL;
  final SfCalendarThemeData calendarTheme;
  final Offset appointmentHoverPosition;
  final ValueNotifier<bool> repaintNotifier;
  final List<CalendarResource> resourceCollection;
  final double resourceItemHeight;
  final double textScaleFactor;

  List<Appointment> visibleAppointments;
  List<_AppointmentView> _appointmentCollection;
  Map<int, List<_AppointmentView>> _indexAppointments;
  List<RRect> _monthAppointmentCountViews;
  Paint _appointmentPainter;
  TextPainter _textPainter;
  final _UpdateCalendarStateDetails _updateCalendarStateDetails =
      _UpdateCalendarStateDetails();

  @override
  void paint(Canvas canvas, Size size) {
    updateCalendarState(_updateCalendarStateDetails);
    visibleAppointments = _updateCalendarStateDetails._visibleAppointments;
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _appointmentPainter = _appointmentPainter ?? Paint();
    _appointmentPainter.isAntiAlias = true;
    _appointmentCollection = _appointmentCollection ?? <_AppointmentView>[];

    _resetAppointmentView(_appointmentCollection);

    if (visibleDates != _updateCalendarStateDetails._currentViewVisibleDates) {
      return;
    }

    switch (view) {
      case CalendarView.month:
        {
          _drawMonthAppointment(canvas, size, _appointmentPainter);
        }
        break;
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          _drawDayAppointments(canvas, size, _appointmentPainter);
        }
        break;
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
        {
          _drawTimelineAppointments(canvas, size, _appointmentPainter);
        }
        break;
      case CalendarView.schedule:
        return;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _AppointmentPainter oldWidget = oldDelegate;
    if (oldWidget.visibleDates != visibleDates ||
        oldWidget.visibleAppointments != visibleAppointments ||
        oldWidget.view != view ||
        oldWidget.isRTL != isRTL ||
        oldWidget.resourceCollection != resourceCollection ||
        oldWidget.appointmentHoverPosition != appointmentHoverPosition ||
        oldWidget.textScaleFactor != textScaleFactor) {
      return true;
    }

    _appointmentCollection = oldWidget._appointmentCollection;
    return false;
  }

  void _updateTextPainter(TextSpan span) {
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = isRTL ? TextAlign.right : TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaleFactor = textScaleFactor;
  }

  void _drawMonthAppointment(Canvas canvas, Size size, Paint paint) {
    final double cellWidth = size.width / _kNumberOfDaysInWeek;
    final double cellHeight =
        size.height / calendar.monthViewSettings.numberOfWeeksInView;
    _monthAppointmentCountViews = <RRect>[];
    _indexAppointments = <int, List<_AppointmentView>>{};
    if (calendar.monthCellBuilder != null) {
      return;
    }

    switch (calendar.monthViewSettings.appointmentDisplayMode) {
      case MonthAppointmentDisplayMode.none:
        return;
      case MonthAppointmentDisplayMode.appointment:
        _drawMonthAppointmentView(canvas, size, cellWidth, cellHeight, paint);
        break;
      case MonthAppointmentDisplayMode.indicator:
        _drawMonthAppointmentIndicator(canvas, cellWidth, cellHeight, paint);
    }
  }

  void _drawMonthAppointmentView(Canvas canvas, Size size, double cellWidth,
      double cellHeight, Paint paint) {
    double xPosition = 0;
    double yPosition = 0;
    final int count = visibleDates.length;
    DateTime visibleStartDate = _convertToStartTime(visibleDates[0]);
    DateTime visibleEndDate = _convertToEndTime(visibleDates[count - 1]);
    int visibleStartIndex = 0;
    int visibleEndIndex = (calendar.monthViewSettings.numberOfWeeksInView *
            _kNumberOfDaysInWeek) -
        1;
    final bool showTrailingLeadingDates = _isLeadingAndTrailingDatesVisible(
        calendar.monthViewSettings.numberOfWeeksInView,
        calendar.monthViewSettings.showTrailingAndLeadingDates);
    if (!showTrailingLeadingDates) {
      final DateTime currentMonthDate = visibleDates[count ~/ 2];
      visibleStartDate =
          _convertToStartTime(_getMonthStartDate(currentMonthDate));
      visibleEndDate = _convertToEndTime(_getMonthEndDate(currentMonthDate));
      visibleStartIndex = _getIndex(visibleDates, visibleStartDate);
      visibleEndIndex = _getIndex(visibleDates, visibleEndDate);
    }

    _updateAppointment(this, visibleStartIndex, visibleEndIndex);
    final TextStyle style =
        calendar.todayTextStyle ?? calendarTheme.todayTextStyle;
    final TextSpan dateText =
        TextSpan(text: DateTime.now().day.toString(), style: style);
    _updateTextPainter(dateText);

    /// cell padding and start position calculated by month date cell
    /// rendering padding and size.
    /// Cell padding value includes month cell text top padding(5) and circle
    /// top(4) and bottom(4) padding
    const double cellPadding = 13;

    /// Today circle radius as circle radius added after the text height.
    const double todayCircleRadius = 5;
    final double startPosition =
        cellPadding + _textPainter.preferredLineHeight + todayCircleRadius;
    final int maximumDisplayCount =
        calendar.monthViewSettings.appointmentDisplayCount ?? 3;
    final double appointmentHeight =
        (cellHeight - startPosition) / maximumDisplayCount;
    double textSize = -1;
    // right side padding used to add padding on appointment view right side
    // in month view
    const int rightSidePadding = 4;
    for (int i = 0; i < _appointmentCollection.length; i++) {
      final _AppointmentView appointmentView = _appointmentCollection[i];
      if (appointmentView.canReuse || appointmentView.appointment == null) {
        continue;
      }

      if (appointmentView.position < maximumDisplayCount ||
          (appointmentView.position == maximumDisplayCount &&
              appointmentView.maxPositions == maximumDisplayCount)) {
        final double appointmentWidth =
            (appointmentView.endIndex - appointmentView.startIndex + 1) *
                cellWidth;

        final Appointment appointment = appointmentView.appointment;
        final bool canAddSpanIcon = _canAddSpanIcon(
            visibleDates, appointment, view,
            visibleStartDate: visibleStartDate,
            visibleEndDate: visibleEndDate,
            showTrailingLeadingDates: showTrailingLeadingDates);

        if (isRTL) {
          xPosition =
              (6 - (appointmentView.startIndex % _kNumberOfDaysInWeek)) *
                  cellWidth;
          xPosition -= appointmentWidth - cellWidth;
        } else {
          xPosition =
              (appointmentView.startIndex % _kNumberOfDaysInWeek) * cellWidth;
        }

        yPosition =
            (appointmentView.startIndex ~/ _kNumberOfDaysInWeek) * cellHeight;
        if (appointmentView.position <= maximumDisplayCount) {
          yPosition = yPosition +
              startPosition +
              (appointmentHeight * (appointmentView.position - 1));
        } else {
          yPosition = yPosition +
              startPosition +
              (appointmentHeight * (maximumDisplayCount - 1));
        }

        final Radius cornerRadius = Radius.circular(
            (appointmentHeight * 0.1) > 2 ? 2 : (appointmentHeight * 0.1));
        final RRect rect = RRect.fromRectAndRadius(
            Rect.fromLTWH(
                isRTL ? xPosition + rightSidePadding : xPosition,
                yPosition,
                appointmentWidth - rightSidePadding > 0
                    ? appointmentWidth - rightSidePadding
                    : 0,
                appointmentHeight - 1),
            cornerRadius);

        paint.color = appointment.color;
        TextStyle style = calendar.appointmentTextStyle;
        TextSpan span = TextSpan(text: appointment.subject, style: style);
        _updateTextPainter(span);

        if (textSize == -1) {
          //// left and right side padding value 2 subtracted in appointment width
          double maxTextWidth = appointmentWidth - 2;
          maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
          for (double j = style.fontSize - 1; j > 0; j--) {
            _textPainter.layout(minWidth: 0, maxWidth: maxTextWidth);
            if (_textPainter.height >= appointmentHeight - 1) {
              style = style.copyWith(fontSize: j);
              span = TextSpan(text: appointment.subject, style: style);
              _updateTextPainter(span);
            } else {
              textSize = j + 1;
              break;
            }
          }
        } else {
          span = TextSpan(
              text: appointment.subject,
              style: style.copyWith(fontSize: textSize));
          _updateTextPainter(span);
        }

        appointmentView.appointmentRect = rect;
        canvas.drawRRect(rect, paint);

        final bool isRecurrenceAppointment =
            appointment.recurrenceRule != null &&
                appointment.recurrenceRule.isNotEmpty;

        /// left and right side padding value subtracted in appointment width
        /// Recurrence icon width also subtracted in appointment text width
        /// when it recurrence appointment.
        final double textWidth = appointmentWidth -
            rightSidePadding -
            (isRecurrenceAppointment ? textSize : 1);
        _textPainter.layout(
            minWidth: 0, maxWidth: textWidth > 0 ? textWidth : 0);
        yPosition += ((appointmentHeight - 1 - _textPainter.height) / 2);
        if (isRTL && !canAddSpanIcon) {
          xPosition += appointmentWidth - _textPainter.width - 2;
        }

        if (canAddSpanIcon) {
          xPosition += (appointmentWidth - _textPainter.width) / 2;
        }

        _textPainter.paint(canvas, Offset(xPosition + 2, yPosition));

        if (isRecurrenceAppointment) {
          _drawRecurrenceIconForMonth(canvas, size, style, textSize, yPosition,
              rect, cornerRadius, paint);
        }

        if (canAddSpanIcon) {
          final int appStartIndex =
              _getDateIndex(appointment._exactStartTime, this);
          final int appEndIndex =
              _getDateIndex(appointment._exactEndTime, this);
          if (appStartIndex == appointmentView.startIndex &&
              appEndIndex == appointmentView.endIndex) {
            continue;
          }

          if (appStartIndex != appointmentView.startIndex &&
              appEndIndex != appointmentView.endIndex) {
            _drawForwardSpanIconForMonth(
                canvas, size, style, textSize, rect, cornerRadius, paint);
            _drawBackwardSpanIconForMonth(
                canvas, style, textSize, rect, cornerRadius, paint);
          } else if (appEndIndex != appointmentView.endIndex) {
            _drawForwardSpanIconForMonth(
                canvas, size, style, textSize, rect, cornerRadius, paint);
          } else {
            _drawBackwardSpanIconForMonth(
                canvas, style, textSize, rect, cornerRadius, paint);
          }
        }

        if (appointmentHoverPosition != null) {
          paint ??= Paint();
          _updateAppointmentHovering(rect, canvas, paint);
        }
      }
    }

    const double padding = 2;
    const double startPadding = 5;
    double radius = appointmentHeight * 0.12;
    if (radius > 3) {
      radius = 3;
    }

    final List<int> keys = _indexAppointments.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      final int _index = keys[i];
      final int maxPosition = _indexAppointments[_index]
          .reduce(
              (_AppointmentView currentAppView, _AppointmentView nextAppView) =>
                  currentAppView.maxPositions > nextAppView.maxPositions
                      ? currentAppView
                      : nextAppView)
          .maxPositions;
      if (maxPosition <= maximumDisplayCount) {
        continue;
      }
      if (isRTL) {
        xPosition = (6 - (_index % _kNumberOfDaysInWeek)) * cellWidth;
      } else {
        xPosition = (_index % _kNumberOfDaysInWeek) * cellWidth;
      }

      yPosition = ((_index ~/ _kNumberOfDaysInWeek) * cellHeight) +
          cellHeight -
          appointmentHeight;
      double startXPosition = xPosition + startPadding;
      if (isRTL) {
        startXPosition = xPosition + (cellWidth - startPadding);
      }

      final RRect hoveringRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
              isRTL ? xPosition + rightSidePadding : xPosition,
              yPosition,
              cellWidth - rightSidePadding > 0
                  ? cellWidth - rightSidePadding
                  : 0,
              appointmentHeight - 1),
          const Radius.circular(0));

      paint.color = Colors.grey[600];
      for (int j = 0; j < 3; j++) {
        canvas.drawCircle(
            Offset(startXPosition, yPosition + (appointmentHeight / 2)),
            radius,
            paint);
        if (isRTL) {
          startXPosition -= padding + (2 * radius);
        } else {
          startXPosition += padding + (2 * radius);
        }
      }

      _monthAppointmentCountViews.add(hoveringRect);
      if (appointmentHoverPosition != null) {
        paint ??= Paint();
        _updateAppointmentHovering(hoveringRect, canvas, paint);
      }
    }
  }

  void _drawForwardSpanIconForMonth(Canvas canvas, Size size, TextStyle style,
      double textSize, RRect rect, Radius cornerRadius, Paint paint) {
    final TextSpan icon =
        _getSpanIcon(style.color, textSize, isRTL ? false : true);
    _textPainter.text = icon;
    _textPainter.layout(
        minWidth: 0, maxWidth: rect.width + 1 > 0 ? rect.width + 1 : 0);

    final double yPosition = _getYPositionForSpanIcon(icon, _textPainter, rect);
    final double rightPadding =
        kIsWeb && size.width > _kMobileViewWidth ? 2 : 0;
    final double xPosition = isRTL
        ? rect.left + rightPadding
        : rect.right - _textPainter.width - rightPadding;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(xPosition, rect.top, xPosition + _textPainter.width,
                rect.bottom),
            cornerRadius),
        paint);
    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  void _drawBackwardSpanIconForMonth(Canvas canvas, TextStyle style,
      double textSize, RRect rect, Radius cornerRadius, Paint paint) {
    final TextSpan icon =
        _getSpanIcon(style.color, textSize, isRTL ? true : false);
    _textPainter.text = icon;
    _textPainter.layout(
        minWidth: 0, maxWidth: rect.width + 1 > 0 ? rect.width + 1 : 0);

    final double yPosition = _getYPositionForSpanIcon(icon, _textPainter, rect);
    final double rightPadding = 2;
    final double xPosition =
        isRTL ? rect.right - textSize - rightPadding : rect.left + rightPadding;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                xPosition, rect.top, xPosition + textSize, rect.bottom),
            cornerRadius),
        paint);
    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  void _drawMonthAppointmentIndicator(
      Canvas canvas, double cellWidth, double cellHeight, Paint paint) {
    double xPosition = 0;
    double yPosition = 0;
    const double radius = 2.5;
    const double diameter = radius * 2;
    final double bottomPadding =
        cellHeight * 0.2 < radius ? radius : cellHeight * 0.2;
    final int visibleDatesCount = visibleDates.length;
    final int currentMonth = visibleDates[visibleDatesCount ~/ 2].month;
    final bool showTrailingLeadingDates = _isLeadingAndTrailingDatesVisible(
        calendar.monthViewSettings.numberOfWeeksInView,
        calendar.monthViewSettings.showTrailingAndLeadingDates);

    for (int i = 0; i < visibleDatesCount; i++) {
      final DateTime currentVisibleDate = visibleDates[i];
      if (!showTrailingLeadingDates &&
          currentVisibleDate.month != currentMonth) {
        continue;
      }

      final List<Appointment> appointmentLists =
          _getSpecificDateVisibleAppointment(
              calendar, currentVisibleDate, visibleAppointments);
      appointmentLists.sort((Appointment app1, Appointment app2) =>
          app1._actualStartTime.compareTo(app2._actualStartTime));
      appointmentLists.sort((Appointment app1, Appointment app2) =>
          _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));
      appointmentLists.sort((Appointment app1, Appointment app2) =>
          _orderAppointmentsAscending(app1._isSpanned, app2._isSpanned));
      final int count = appointmentLists.length <=
              calendar.monthViewSettings.appointmentDisplayCount
          ? appointmentLists.length
          : calendar.monthViewSettings.appointmentDisplayCount;
      const double indicatorPadding = 2;
      final double indicatorWidth =
          count * diameter + (count - 1) * indicatorPadding;
      if (indicatorWidth > cellWidth) {
        xPosition = indicatorPadding + radius;
      } else {
        final double difference = cellWidth - indicatorWidth;
        xPosition = (difference / 2) + radius;
      }

      double startXPosition = 0;
      if (isRTL) {
        startXPosition = (6 - (i % _kNumberOfDaysInWeek).toInt()) * cellWidth;
      } else {
        startXPosition = ((i % _kNumberOfDaysInWeek).toInt()) * cellWidth;
      }

      xPosition += startXPosition;
      yPosition = (((i / _kNumberOfDaysInWeek) + 1).toInt()) * cellHeight;
      for (int j = 0; j < count; j++) {
        paint.color = appointmentLists[j].color;
        canvas.drawCircle(
            Offset(xPosition, yPosition - bottomPadding), radius, paint);
        xPosition += diameter + indicatorPadding;
        if (startXPosition + cellWidth < xPosition + diameter) {
          break;
        }
      }
    }
  }

  void _drawRecurrenceIconForMonth(
      Canvas canvas,
      Size size,
      TextStyle style,
      double textSize,
      double yPosition,
      RRect rect,
      Radius cornerRadius,
      Paint paint) {
    final TextSpan icon = _getRecurrenceIcon(style.color, textSize);
    _textPainter.text = icon;
    _textPainter.layout(
        minWidth: 0, maxWidth: rect.width + 1 > 0 ? rect.width + 1 : 0);
    yPosition = rect.top + ((rect.height - _textPainter.height) / 2);
    final double rightPadding =
        kIsWeb && size.width > _kMobileViewWidth ? 2 : 0;
    final double recurrenceStartPosition = isRTL
        ? rect.left + rightPadding
        : rect.right - _textPainter.width - rightPadding;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(recurrenceStartPosition, yPosition,
                recurrenceStartPosition + _textPainter.width, rect.bottom),
            cornerRadius),
        paint);
    _textPainter.paint(canvas, Offset(recurrenceStartPosition, yPosition));
  }

  void _drawDayAppointments(Canvas canvas, Size size, Paint paint) {
    final double timeLabelWidth =
        _getTimeLabelWidth(calendar.timeSlotViewSettings.timeRulerSize, view);
    final double width = size.width - timeLabelWidth;
    _setAppointmentPositionAndMaxPosition(
        this, calendar, view, visibleAppointments, false, timeIntervalHeight);
    final double cellWidth = width / visibleDates.length;
    final double cellHeight = timeIntervalHeight;
    double xPosition = timeLabelWidth;
    double yPosition = 0;
    const int textStartPadding = 3;
    double rightSidePadding = cellWidth * 0.1;
    if (view == CalendarView.day) {
      rightSidePadding = rightSidePadding > 10 ? 10 : rightSidePadding;
    } else {
      rightSidePadding = rightSidePadding > 5 ? 5 : rightSidePadding;
    }

    final int timeInterval = _getTimeInterval(calendar.timeSlotViewSettings);
    for (int i = 0; i < _appointmentCollection.length; i++) {
      final _AppointmentView appointmentView = _appointmentCollection[i];
      if (appointmentView.canReuse) {
        continue;
      }

      final Appointment appointment = appointmentView.appointment;
      int column = -1;
      final int count = visibleDates.length;

      int datesCount = 0;
      for (int j = 0; j < count; j++) {
        final DateTime _date = visibleDates[j];
        if (_date != null &&
            _date.day == appointment._actualStartTime.day &&
            _date.month == appointment._actualStartTime.month &&
            _date.year == appointment._actualStartTime.year) {
          column = isRTL ? visibleDates.length - 1 - datesCount : datesCount;
          break;
        } else if (_date != null) {
          datesCount++;
        }
      }

      if (column == -1 ||
          appointment._isSpanned ||
          (appointment.endTime.difference(appointment.startTime).inDays > 0) ||
          appointment.isAllDay) {
        continue;
      }

      final int totalHours = appointment._actualStartTime.hour -
          calendar.timeSlotViewSettings.startHour.toInt();
      final double mins = appointment._actualStartTime.minute -
          ((calendar.timeSlotViewSettings.startHour -
                  calendar.timeSlotViewSettings.startHour.toInt()) *
              60);
      final int totalMins = (totalHours * 60 + mins).toInt();
      final int row = totalMins ~/ timeInterval;

      final double appointmentWidth =
          (cellWidth - rightSidePadding) / appointmentView.maxPositions;
      if (isRTL) {
        xPosition = column * cellWidth +
            (appointmentView.position * appointmentWidth) +
            rightSidePadding;
      } else {
        xPosition = column * cellWidth +
            (appointmentView.position * appointmentWidth) +
            timeLabelWidth;
      }

      yPosition = row * cellHeight;

      Duration difference =
          appointment._actualEndTime.difference(appointment._actualStartTime);
      final double minuteHeight = cellHeight / timeInterval;
      yPosition += ((appointment._actualStartTime.hour * 60 +
                  appointment._actualStartTime.minute) %
              timeInterval) *
          minuteHeight;

      double height = difference.inMinutes * minuteHeight;
      if (calendar.timeSlotViewSettings.minimumAppointmentDuration != null &&
          calendar.timeSlotViewSettings.minimumAppointmentDuration.inMinutes >
              0) {
        if (difference <
                calendar.timeSlotViewSettings.minimumAppointmentDuration &&
            difference.inMinutes * minuteHeight <
                calendar.timeSlotViewSettings.timeIntervalHeight) {
          difference = calendar.timeSlotViewSettings.minimumAppointmentDuration;
          height = difference.inMinutes * minuteHeight;
          //// Check the minimum appointment duration height does not greater than time interval height.
          if (height > calendar.timeSlotViewSettings.timeIntervalHeight) {
            height = calendar.timeSlotViewSettings.timeIntervalHeight;
          }
        }
      }

      final Radius cornerRadius =
          Radius.circular((height * 0.1) > 2 ? 2 : (height * 0.1));
      paint.color = appointment.color;
      final RRect rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(xPosition, yPosition, appointmentWidth - 1, height - 1),
          cornerRadius);
      appointmentView.appointmentRect = rect;
      canvas.drawRRect(rect, paint);

      final bool canAddSpanIcon =
          _canAddSpanIcon(visibleDates, appointment, view);
      bool canAddForwardIcon = false;
      if (canAddSpanIcon) {
        if (_isSameTimeSlot(
                appointment._exactStartTime, appointment._actualStartTime) &&
            !_isSameTimeSlot(
                appointment._exactEndTime, appointment._actualEndTime)) {
          canAddForwardIcon = true;
        } else if (!_isSameTimeSlot(
                appointment._exactStartTime, appointment._actualStartTime) &&
            _isSameTimeSlot(
                appointment._exactEndTime, appointment._actualEndTime)) {
          yPosition += _getTextSize(
              rect, (calendar.appointmentTextStyle.fontSize * textScaleFactor));
        }
      }

      final TextSpan span = TextSpan(
        text: appointment.subject,
        style: calendar.appointmentTextStyle,
      );

      _updateTextPainter(span);

      final double totalHeight = height - textStartPadding - 1;
      _updatePainterMaxLines(totalHeight);

      //// left and right side padding value 2 subtracted in appointment width
      double maxTextWidth = appointmentWidth - textStartPadding - 1;
      maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
      _textPainter.layout(minWidth: 0, maxWidth: maxTextWidth);

      /// minIntrinsicWidth property in text painter used to get the
      /// minimum text width of the text.
      /// eg., The text as 'Meeting' and it rendered in two lines and
      /// first line has 'Meet' text and second line has 'ing' text then it
      /// return second lines width.
      /// We are using the minIntrinsicWidth to restrict the text rendering
      /// when the appointment view bound does not hold single letter.
      final double textWidth = appointmentWidth - textStartPadding;
      if (textWidth < _textPainter.minIntrinsicWidth &&
          textWidth < _textPainter.width &&
          textWidth <
              (calendar.appointmentTextStyle.fontSize ?? 15) *
                  textScaleFactor) {
        if (appointmentHoverPosition != null) {
          paint ??= Paint();
          _updateAppointmentHovering(rect, canvas, paint);
        }

        continue;
      }

      if ((_textPainter.maxLines == 1 || _textPainter.maxLines == null) &&
          _textPainter.height > totalHeight) {
        if (appointmentHoverPosition != null) {
          paint ??= Paint();
          _updateAppointmentHovering(rect, canvas, paint);
        }

        continue;
      }

      if (isRTL) {
        xPosition += appointmentWidth - textStartPadding - _textPainter.width;
      }

      _textPainter.paint(canvas,
          Offset(xPosition + textStartPadding, yPosition + textStartPadding));
      if (appointment.recurrenceRule != null &&
          appointment.recurrenceRule.isNotEmpty) {
        _addRecurrenceIconForDay(canvas, size, rect, appointmentWidth,
            textStartPadding, paint, cornerRadius);
      }

      if (canAddSpanIcon) {
        if (canAddForwardIcon) {
          _addForwardSpanIconForDay(canvas, rect, size, cornerRadius, paint);
        } else {
          _addBackwardSpanIconForDay(canvas, rect, size, cornerRadius, paint);
        }
      }

      if (appointmentHoverPosition != null) {
        paint ??= Paint();
        _updateAppointmentHovering(rect, canvas, paint);
      }
    }
  }

  void _addBackwardSpanIconForDay(
      Canvas canvas, RRect rect, Size size, Radius cornerRadius, Paint paint) {
    canvas.save();
    const double bottomPadding = 2;
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);
    final TextSpan icon =
        _getSpanIcon(calendar.appointmentTextStyle.color, textSize, false);
    _updateTextPainter(icon);
    _textPainter.layout(minWidth: 0, maxWidth: rect.width);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                rect.left, rect.top, rect.right, rect.top + _textPainter.width),
            cornerRadius),
        paint);

    final double xPosition = _getXPositionForSpanIconForDay(icon, rect);

    final double yPosition = rect.top + bottomPadding;
    canvas.translate(xPosition, yPosition);
    final radians = 90 * math.pi / 180;
    canvas.rotate(radians);
    _textPainter.paint(canvas, Offset(0, 0));
    canvas.restore();
  }

  double _getXPositionForSpanIconForDay(TextSpan icon, RRect rect) {
    /// There is a space around the font, hence to get the start position we
    /// must calculate the icon start position, apart from the space, and the
    /// value 1.5 used since the space on top and bottom of icon is not even,
    /// hence to rectify this tha value 1.5 used, and tested with multiple
    /// device.
    final double iconStartPosition =
        (_textPainter.height - (icon.style.fontSize * textScaleFactor)) / 1.5;
    return rect.left +
        (rect.width - _textPainter.height) / 2 +
        _textPainter.height +
        iconStartPosition;
  }

  void _addForwardSpanIconForDay(
      Canvas canvas, RRect rect, Size size, Radius cornerRadius, Paint paint) {
    canvas.save();
    const double bottomPadding = 2;
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);
    final TextSpan icon =
        _getSpanIcon(calendar.appointmentTextStyle.color, textSize, true);
    _updateTextPainter(icon);
    _textPainter.layout(minWidth: 0, maxWidth: rect.width);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(rect.left, rect.bottom - _textPainter.width,
                rect.right, rect.bottom),
            cornerRadius),
        paint);

    final double xPosition = _getXPositionForSpanIconForDay(icon, rect);
    final double yPosition =
        rect.bottom - (textSize * textScaleFactor) - bottomPadding;
    canvas.translate(xPosition, yPosition);
    final radians = 90 * math.pi / 180;
    canvas.rotate(radians);
    _textPainter.paint(canvas, Offset(0, 0));
    canvas.restore();
  }

  void _updatePainterMaxLines(double height) {
    /// [preferredLineHeight] is used to get the line height based on text
    /// style and text. floor the calculated value to set the minimum line
    /// count to painter max lines property.
    final int maxLines = (height / _textPainter.preferredLineHeight).floor();
    if (maxLines <= 0) {
      return;
    }

    _textPainter.maxLines = maxLines;
  }

  void _addRecurrenceIconForDay(
      Canvas canvas,
      Size size,
      RRect rect,
      double appointmentWidth,
      int textPadding,
      Paint paint,
      Radius cornerRadius) {
    final double xPadding = kIsWeb && size.width > _kMobileViewWidth ? 2 : 1;
    const double bottomPadding = 2;
    double textSize = calendar.appointmentTextStyle.fontSize;
    if (rect.width < textSize || rect.height < textSize) {
      textSize = rect.width > rect.height ? rect.height : rect.width;
    }

    final TextSpan icon =
        _getRecurrenceIcon(calendar.appointmentTextStyle.color, textSize);
    _textPainter.text = icon;
    double maxTextWidth = appointmentWidth - textPadding - 2;
    maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
    _textPainter.layout(minWidth: 0, maxWidth: maxTextWidth);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                isRTL
                    ? rect.left + textSize + xPadding
                    : rect.right - textSize - xPadding,
                rect.bottom - bottomPadding - textSize,
                isRTL ? rect.left : rect.right,
                rect.bottom),
            cornerRadius),
        paint);
    _textPainter.paint(
        canvas,
        Offset(isRTL ? rect.left + xPadding : rect.right - textSize - xPadding,
            rect.bottom - bottomPadding - textSize));
  }

  void _drawTimelineAppointments(Canvas canvas, Size size, Paint paint) {
    final bool isResourceEnabled =
        _isResourceEnabled(calendar.dataSource, view);

    /// Filters the appointment for each resource from the visible appointment
    /// collection, and assign appointment views for all the collections.
    if (isResourceEnabled && visibleAppointments != null) {
      for (int i = 0; i < calendar.dataSource.resources.length; i++) {
        final CalendarResource resource = calendar.dataSource.resources[i];

        /// Filters the appointment for each resource from the visible
        /// appointment collection.
        final List<Appointment> appointmentForEachResource = visibleAppointments
            .where((app) =>
                app.resourceIds != null &&
                app.resourceIds.isNotEmpty &&
                app.resourceIds.contains(resource.id))
            .toList();
        _setAppointmentPositionAndMaxPosition(this, calendar, view,
            appointmentForEachResource, false, timeIntervalHeight, i);
      }
    } else {
      _setAppointmentPositionAndMaxPosition(
          this, calendar, view, visibleAppointments, false, timeIntervalHeight);
    }

    final double viewWidth = size.width / visibleDates.length;
    final double cellWidth = timeIntervalHeight;
    double xPosition = 0;
    double yPosition = 0;
    const int textStartPadding = 3;
    final int count = visibleDates.length;
    final int timeSlotCount =
        _getHorizontalLinesCount(calendar.timeSlotViewSettings, view).toInt();
    final int timeInterval = _getTimeInterval(calendar.timeSlotViewSettings);
    for (int i = 0; i < _appointmentCollection.length; i++) {
      final _AppointmentView appointmentView = _appointmentCollection[i];
      if (appointmentView.canReuse) {
        continue;
      }

      final Appointment appointment = appointmentView.appointment;
      int column = -1;

      DateTime startTime = appointment._actualStartTime;
      int datesCount = 0;
      for (int j = 0; j < count; j++) {
        final DateTime date = visibleDates[j];
        if (date != null &&
            date.day == startTime.day &&
            date.month == startTime.month &&
            date.year == startTime.year) {
          column = isRTL ? visibleDates.length - 1 - datesCount : datesCount;
          break;
        } else if (startTime.isBefore(date)) {
          column = isRTL ? visibleDates.length - 1 - datesCount : datesCount;
          startTime = DateTime(date.year, date.month, date.day, 0, 0, 0);
          break;
        } else if (date != null) {
          datesCount++;
        }
      }

      if (column == -1 &&
          appointment._actualStartTime.isBefore(visibleDates[0])) {
        column = 0;
      }

      /// For timeline day, week and work week view each column represents a
      /// time slots for timeline month each column represent a day, and as
      /// rendering wise the column here represents the day hence the `-1`
      /// added in the above calculation not required for timeline month view,
      /// hence to rectify this we have added +1.
      if (isRTL && view == CalendarView.timelineMonth) {
        column += 1;
      }

      DateTime endTime = appointment._actualEndTime;
      int endColumn = 0;
      if (view == CalendarView.timelineWorkWeek) {
        endColumn = -1;
        datesCount = 0;
        for (int j = 0; j < count; j++) {
          DateTime date = visibleDates[j];
          if (date != null &&
              date.day == endTime.day &&
              date.month == endTime.month &&
              date.year == endTime.year) {
            endColumn =
                isRTL ? visibleDates.length - 1 - datesCount : datesCount;
            break;
          } else if (endTime.isBefore(date)) {
            endColumn = isRTL
                ? visibleDates.length - 1 - datesCount - 1
                : datesCount - 1;
            if (endColumn != -1) {
              date = visibleDates[endColumn];
              endTime = DateTime(date.year, date.month, date.day, 59, 59, 0);
            }
            break;
          } else if (date != null) {
            datesCount++;
          }
        }

        if (endColumn == -1 &&
            appointment._actualEndTime
                .isAfter(visibleDates[visibleDates.length - 1])) {
          endColumn = isRTL ? 0 : visibleDates.length - 1;
        }
      }

      if (column == -1 || endColumn == -1) {
        continue;
      }

      int row = 0;
      int totalHours = 0;
      int totalMinutes = 0;
      double minutes = 0;
      if (view != CalendarView.timelineMonth) {
        totalHours =
            startTime.hour - calendar.timeSlotViewSettings.startHour.toInt();
        minutes = startTime.minute -
            ((calendar.timeSlotViewSettings.startHour -
                    calendar.timeSlotViewSettings.startHour.toInt()) *
                60);
        totalMinutes = (totalHours * 60 + minutes).toInt();
        row = totalMinutes ~/ timeInterval;
        if (isRTL) {
          row = timeSlotCount - row;
        }
      }

      final double minuteHeight = cellWidth / timeInterval;

      double appointmentHeight =
          _getTimelineAppointmentHeight(calendar.timeSlotViewSettings, view);
      final double slotHeight =
          isResourceEnabled ? resourceItemHeight : size.height;
      if (appointmentHeight * appointmentView.maxPositions > slotHeight) {
        appointmentHeight = slotHeight / appointmentView.maxPositions;
      }

      xPosition = (column * viewWidth) + (row * cellWidth);
      yPosition = appointmentHeight * appointmentView.position;
      if (isResourceEnabled &&
          appointment.resourceIds != null &&
          appointment.resourceIds.isNotEmpty) {
        /// To render the appointment on specific resource slot, we have got the
        /// appointment's resource index  and calculated y position based on
        /// this.
        yPosition += appointmentView.resourceIndex * resourceItemHeight;
      }
      if (view != CalendarView.timelineMonth) {
        /// Calculate the in between minute height
        /// Eg., If start time as 12.07 PM and time interval as 60 minutes
        /// then the height holds the value of 07 minutes height.
        final double inBetweenMinuteHeight =
            ((startTime.hour * 60 + startTime.minute) % timeInterval) *
                minuteHeight;
        if (isRTL) {
          /// If the view direction as RTL then we subtract the in between
          /// minute height because the value used to calculate the start
          /// position of the appointment.
          xPosition -= inBetweenMinuteHeight;
        } else {
          xPosition += inBetweenMinuteHeight;
        }
      }

      paint.color = appointment.color;
      double width = 0;
      if (view == CalendarView.timelineWorkWeek) {
        totalHours =
            endTime.hour - calendar.timeSlotViewSettings.startHour.toInt();
        minutes = endTime.minute -
            ((calendar.timeSlotViewSettings.startHour -
                    calendar.timeSlotViewSettings.startHour.toInt()) *
                60);
        totalMinutes = (totalHours * 60 + minutes).toInt();
        row = totalMinutes ~/ timeInterval;

        /// Calculate the in between minute height
        /// Eg., If end time as 12.07 PM and time interval as 60 minutes
        /// then the height holds the value of 07 minutes height.
        double inBetweenMinuteHeight =
            ((endTime.hour * 60 + endTime.minute) % timeInterval) *
                minuteHeight;
        if (isRTL) {
          row = timeSlotCount - row;

          /// If the view direction as RTL then we subtract the in between
          /// minute height because the value used to calculate the end
          ///  position of the appointment.
          inBetweenMinuteHeight = -inBetweenMinuteHeight;
        }
        final double endXPosition =
            (endColumn * viewWidth) + (row * cellWidth) + inBetweenMinuteHeight;
        if (isRTL) {
          width = xPosition - endXPosition;
        } else {
          width = endXPosition - xPosition;
        }
      } else {
        final Duration difference = endTime.difference(startTime);
        if (view != CalendarView.timelineMonth) {
          /// The width for the appointment UI, calculated based on the minutes
          /// difference between the start and end time of the appointment.
          width = difference.inMinutes * minuteHeight;
        } else {
          /// The width for the appointment UI, calculated based on the date
          /// difference between the start and end time of the appointment.
          width = (difference.inDays + 1) * cellWidth;

          /// For span appointment less than 23 hours the difference will fall
          /// as 0 hence to render the appointment on the next day, added one
          /// the width for next day.
          if (difference.inDays == 0 && endTime.day != startTime.day) {
            width += cellWidth;
          }
        }
      }

      if (calendar.timeSlotViewSettings.minimumAppointmentDuration != null &&
          calendar.timeSlotViewSettings.minimumAppointmentDuration.inMinutes >
              0 &&
          view != CalendarView.timelineMonth) {
        final double minWidth = _getAppointmentHeightFromDuration(
            calendar.timeSlotViewSettings.minimumAppointmentDuration,
            calendar,
            timeIntervalHeight);
        width = width > minWidth ? width : minWidth;
      }

      final Radius cornerRadius = Radius.circular(
          (appointmentHeight * 0.1) > 2 ? 2 : (appointmentHeight * 0.1));
      final RRect rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(isRTL ? xPosition - width : xPosition, yPosition,
              width - 1, appointmentHeight - 1),
          cornerRadius);
      appointmentView.appointmentRect = rect;
      canvas.drawRRect(rect, paint);
      final bool canAddSpanIcon =
          _canAddSpanIcon(visibleDates, appointment, view);
      bool canAddForwardIcon = false;
      bool canAddBackwardIcon = false;

      double maxWidth = width - textStartPadding - 2;
      maxWidth = maxWidth > 0 ? maxWidth : 0;

      if (canAddSpanIcon) {
        final DateTime appStartTime = appointment._exactStartTime;
        final DateTime appEndTime = appointment._exactEndTime;
        final DateTime viewStartDate = _convertToStartTime(visibleDates[0]);
        final DateTime viewEndDate =
            _convertToEndTime(visibleDates[visibleDates.length - 1]);
        double iconSize = _getTextSize(rect,
                (calendar.appointmentTextStyle.fontSize * textScaleFactor)) +
            textStartPadding;
        if (_canAddForwardSpanIcon(
            appStartTime, appEndTime, viewStartDate, viewEndDate)) {
          canAddForwardIcon = true;
          iconSize = null;
        } else if (_canAddBackwardSpanIcon(
            appStartTime, appEndTime, viewStartDate, viewEndDate)) {
          canAddBackwardIcon = true;
        } else {
          canAddForwardIcon = true;
          canAddBackwardIcon = true;
        }

        if (iconSize != null) {
          if (isRTL) {
            xPosition -= iconSize;
          } else {
            xPosition += iconSize;
          }
        }
      }

      final TextSpan span = TextSpan(
        text: _getTimelineAppointmentText(appointment, canAddSpanIcon),
        style: calendar.appointmentTextStyle,
      );

      _updateTextPainter(span);
      final double totalHeight = appointmentHeight - textStartPadding - 2;
      _updatePainterMaxLines(totalHeight);

      /// In RTL, when the text wraps into multiple line the tine width is
      /// smaller than the expected when we use the
      /// 'TextWidthBasis.longestLine]` which renders the subject text out of
      /// the appointment rect, hence to overcome this we have added checked
      /// this condition and set the text width basis.
      if (view == CalendarView.timelineMonth) {
        _textPainter.textWidthBasis = TextWidthBasis.parent;
      }

      //// left and right side padding value 2 subtracted in appointment width
      _textPainter.layout(minWidth: 0, maxWidth: maxWidth);
      if ((_textPainter.maxLines == null || _textPainter.maxLines == 1) &&
          _textPainter.height > totalHeight) {
        if (appointmentHoverPosition != null) {
          paint ??= Paint();
          _updateAppointmentHovering(rect, canvas, paint);
        }
        continue;
      }

      if (isRTL) {
        if (canAddSpanIcon) {
          xPosition -= textStartPadding;
        }

        xPosition -= _textPainter.width + textStartPadding + 2;
      }

      _textPainter.paint(canvas,
          Offset(xPosition + textStartPadding, yPosition + textStartPadding));
      if (appointment.recurrenceRule != null &&
          appointment.recurrenceRule.isNotEmpty) {
        _addRecurrenceIconForTimeline(
            canvas, size, rect, maxWidth, cornerRadius, paint);
      }

      if (canAddSpanIcon) {
        if (canAddForwardIcon && canAddBackwardIcon) {
          _addForwardSpanIconForTimeline(
              canvas, size, rect, maxWidth, cornerRadius, paint);
          _addBackwardSpanIconForTimeline(
              canvas, size, rect, maxWidth, cornerRadius, paint);
        } else if (canAddForwardIcon) {
          _addForwardSpanIconForTimeline(
              canvas, size, rect, maxWidth, cornerRadius, paint);
        } else {
          _addBackwardSpanIconForTimeline(
              canvas, size, rect, maxWidth, cornerRadius, paint);
        }
      }

      if (appointmentHoverPosition != null) {
        paint ??= Paint();
        _updateAppointmentHovering(rect, canvas, paint);
      }
    }
  }

  /// To display the different text on spanning appointment for timeline day
  /// view, for other views we just display the subject of the appointment and
  /// for timeline day view  we display the current date, and total dates of the
  ///  spanning appointment.
  String _getTimelineAppointmentText(
      Appointment appointment, bool canAddSpanIcon) {
    if (view != CalendarView.timelineDay || !canAddSpanIcon) {
      return appointment.subject;
    }

    return _getSpanAppointmentText(appointment, visibleDates[0]);
  }

  double _getTextSize(RRect rect, double textSize) {
    if (rect.width < textSize || rect.height < textSize) {
      return rect.width > rect.height ? rect.height : rect.width;
    }

    return textSize;
  }

  double _getYPositionForSpanIconInTimeline(
      TextSpan icon, RRect rect, double xPadding) {
    /// There is a space around the font, hence to get the start position we
    /// must calculate the icon start position, apart from the space, and the
    /// value 2 used since the space on top and bottom of icon is not even,
    /// hence to rectify this tha value 2 used, and tested with multiple
    /// device.
    final double iconStartPosition =
        (_textPainter.height - (icon.style.fontSize * textScaleFactor) / 2) / 2;
    return rect.top - iconStartPosition + (kIsWeb ? xPadding : 1);
  }

  void _addForwardSpanIconForTimeline(Canvas canvas, Size size, RRect rect,
      double maxWidth, Radius cornerRadius, Paint paint) {
    final double xPadding = 2;
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);

    final TextSpan icon = _getSpanIcon(
        calendar.appointmentTextStyle.color, textSize, isRTL ? false : true);
    _updateTextPainter(icon);
    _textPainter.layout(minWidth: 0, maxWidth: maxWidth);
    final double xPosition = isRTL
        ? rect.left + xPadding
        : rect.right - _textPainter.width - xPadding;

    final double yPosition =
        _getYPositionForSpanIconInTimeline(icon, rect, xPadding);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(xPosition, rect.top + 1,
                isRTL ? rect.left : rect.right, rect.bottom),
            cornerRadius),
        paint);
    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  void _addBackwardSpanIconForTimeline(Canvas canvas, Size size, RRect rect,
      double maxWidth, Radius cornerRadius, Paint paint) {
    final double xPadding = 2;
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);

    final TextSpan icon = _getSpanIcon(
        calendar.appointmentTextStyle.color, textSize, isRTL ? true : false);
    _updateTextPainter(icon);
    _textPainter.layout(minWidth: 0, maxWidth: maxWidth);
    final double xPosition = isRTL
        ? rect.right - _textPainter.width - xPadding
        : rect.left + xPadding;

    final double yPosition =
        _getYPositionForSpanIconInTimeline(icon, rect, xPadding);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(xPosition, rect.top + 1,
                isRTL ? rect.right : rect.left, rect.bottom),
            cornerRadius),
        paint);
    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  void _addRecurrenceIconForTimeline(Canvas canvas, Size size, RRect rect,
      double maxWidth, Radius cornerRadius, Paint paint) {
    final double xPadding = kIsWeb && size.width > _kMobileViewWidth ? 2 : 1;
    const double bottomPadding = 2;
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);

    final TextSpan icon =
        _getRecurrenceIcon(calendar.appointmentTextStyle.color, textSize);
    _textPainter.text = icon;
    _textPainter.layout(minWidth: 0, maxWidth: maxWidth);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                isRTL ? rect.left + xPadding : rect.right - textSize - xPadding,
                rect.bottom - bottomPadding - textSize,
                isRTL ? rect.left : rect.right,
                rect.bottom),
            cornerRadius),
        paint);
    _textPainter.paint(
        canvas,
        Offset(isRTL ? rect.left + xPadding : rect.right - textSize - xPadding,
            rect.bottom - bottomPadding - textSize));
  }

  void _updateAppointmentHovering(RRect rect, Canvas canvas, Paint paint) {
    if (rect.left < appointmentHoverPosition.dx &&
        rect.right > appointmentHoverPosition.dx &&
        rect.top < appointmentHoverPosition.dy &&
        rect.bottom > appointmentHoverPosition.dy) {
      paint.color = calendarTheme.selectionBorderColor.withOpacity(0.4);
      paint.strokeWidth = 2;
      paint.style = PaintingStyle.stroke;
      canvas.drawRect(rect.outerRect, paint);
      paint.style = PaintingStyle.fill;
    }
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the
  /// list of custom painter semantics which contains the rect area and the
  /// semantics properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilder(size);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _AppointmentPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.visibleAppointments != visibleAppointments;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    if (_appointmentCollection == null || _appointmentCollection.isEmpty) {
      return semanticsBuilder;
    }

    for (int i = 0; i < _appointmentCollection.length; i++) {
      if (_appointmentCollection[i].appointment == null) {
        return semanticsBuilder;
      }

      semanticsBuilder.add(CustomPainterSemantics(
        rect: _appointmentCollection[i].appointmentRect == null
            ? const Rect.fromLTWH(0, 0, 10, 10)
            : _appointmentCollection[i].appointmentRect?.outerRect,
        properties: SemanticsProperties(
          label: _getAppointmentText(_appointmentCollection[i].appointment),
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    return semanticsBuilder;
  }
}
