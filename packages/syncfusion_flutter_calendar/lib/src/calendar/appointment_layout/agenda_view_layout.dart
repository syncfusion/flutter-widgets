part of calendar;

class _AgendaViewPainter extends CustomPainter {
  _AgendaViewPainter(
      this.monthViewSettings,
      this.scheduleViewSettings,
      this.selectedDate,
      this.appointments,
      this.isRTL,
      this.locale,
      this.localizations,
      this.calendarTheme,
      this.agendaViewNotifier,
      this.appointmentTimeTextFormat,
      this._timeLabelWidth,
      this.textScaleFactor)
      : super(repaint: agendaViewNotifier);

  final MonthViewSettings monthViewSettings;
  final ScheduleViewSettings scheduleViewSettings;
  final DateTime selectedDate;
  final List<Appointment> appointments;
  final bool isRTL;
  final String locale;
  final SfCalendarThemeData calendarTheme;
  final ValueNotifier<_ScheduleViewHoveringDetails> agendaViewNotifier;
  final SfLocalizations localizations;
  final double _timeLabelWidth;
  final String appointmentTimeTextFormat;
  final double textScaleFactor;
  Paint _rectPainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _rectPainter = _rectPainter ?? Paint();
    _rectPainter.isAntiAlias = true;
    double yPosition = 5;
    double xPosition = 5;
    const double padding = 5;

    if (selectedDate == null || appointments == null || appointments.isEmpty) {
      _drawDefaultView(canvas, size, xPosition, yPosition, padding);
      return;
    }

    final bool isScheduleWebUI = scheduleViewSettings != null &&
            (kIsWeb && (size.width + _timeLabelWidth) > _kMobileViewWidth)
        ? true
        : false;

    appointments.sort((Appointment app1, Appointment app2) =>
        app1._actualStartTime.compareTo(app2._actualStartTime));
    appointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));
    appointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1._isSpanned, app2._isSpanned));
    final TextStyle appointmentTextStyle = monthViewSettings != null
        ? monthViewSettings.agendaStyle.appointmentTextStyle ??
            TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto')
        : scheduleViewSettings.appointmentTextStyle ??
            TextStyle(
                color: isScheduleWebUI &&
                        calendarTheme.brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white,
                fontSize: 13,
                fontFamily: 'Roboto');
    final double agendaItemHeight =
        _getScheduleAppointmentHeight(monthViewSettings, scheduleViewSettings);
    final double agendaAllDayItemHeight = _getScheduleAllDayAppointmentHeight(
        monthViewSettings, scheduleViewSettings);

    //// Draw Appointments
    for (int i = 0; i < appointments.length; i++) {
      final Appointment appointment = appointments[i];
      xPosition = 5;
      _rectPainter.color = appointment.color;
      final bool isSpanned =
          appointment._actualEndTime.day != appointment._actualStartTime.day ||
              appointment._isSpanned;
      final double appointmentHeight =
          (appointment.isAllDay || isSpanned) && !isScheduleWebUI
              ? agendaAllDayItemHeight
              : agendaItemHeight;
      final Rect rect = Rect.fromLTWH(xPosition, yPosition,
          size.width - xPosition - padding, appointmentHeight);
      final Radius cornerRadius = Radius.circular(
          (appointmentHeight * 0.1) > 5 ? 5 : (appointmentHeight * 0.1));

      /// Web view does not highlighted by background
      if (!isScheduleWebUI) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(rect, cornerRadius), _rectPainter);
      }

      final TextSpan span =
          TextSpan(text: appointment.subject, style: appointmentTextStyle);
      _updateTextPainterProperties(span);
      double timeWidth =
          isScheduleWebUI ? (size.width - (2 * padding)) * 0.3 : 0;
      timeWidth = timeWidth > 200 ? 200 : timeWidth;
      xPosition += timeWidth;

      final bool isRecurrenceAppointment = appointment.recurrenceRule != null &&
          appointment.recurrenceRule.isNotEmpty;
      final double textSize = _getTextSize(rect, appointmentTextStyle);

      double topPadding = 0;

      /// Draw web schedule view.
      if (isScheduleWebUI) {
        topPadding = _addScheduleViewForWeb(
            canvas,
            size,
            agendaItemHeight,
            padding,
            xPosition,
            yPosition,
            timeWidth,
            appointmentHeight,
            isSpanned || isRecurrenceAppointment,
            textSize,
            appointment,
            appointmentTextStyle);
        if (isSpanned) {
          final TextSpan icon = _getSpanIcon(appointmentTextStyle.color,
              kIsWeb ? textSize / 1.5 : textSize, isRTL ? false : true);
          _drawIcon(canvas, size, textSize, rect, padding, isScheduleWebUI,
              cornerRadius, icon, appointmentHeight, topPadding, true, false);
        }
      } else {
        /// Draws spanning appointment UI for schedule view.
        if (isSpanned) {
          _drawSpanningAppointmentForScheduleView(
              canvas,
              size,
              xPosition,
              yPosition,
              padding,
              appointment,
              appointmentTextStyle,
              appointmentHeight,
              rect,
              isScheduleWebUI,
              cornerRadius);
        }
        //// Draw Appointments except All day appointment
        else if (!appointment.isAllDay) {
          topPadding = _drawNormalAppointmentUI(
              canvas,
              size,
              xPosition,
              yPosition,
              padding,
              timeWidth,
              isRecurrenceAppointment,
              textSize,
              appointment,
              appointmentHeight,
              appointmentTextStyle);
        } else {
          //// Draw All day appointment
          _updatePainterLinesCount(appointmentHeight,
              isAllDay: true, isSpanned: false);
          final double iconSize = isRecurrenceAppointment ? textSize + 10 : 0;
          _textPainter.layout(
              minWidth: 0, maxWidth: size.width - 10 - padding - iconSize);
          if (isRTL) {
            xPosition = size.width - _textPainter.width - (padding * 3);
          }

          topPadding = (appointmentHeight - _textPainter.height) / 2;
          _textPainter.paint(
              canvas, Offset(xPosition + 5, yPosition + topPadding));
        }
      }

      if (isRecurrenceAppointment) {
        final TextSpan icon =
            _getRecurrenceIcon(appointmentTextStyle.color, textSize);
        _drawIcon(
            canvas,
            size,
            textSize,
            rect,
            padding,
            isScheduleWebUI,
            cornerRadius,
            icon,
            appointmentHeight,
            topPadding,
            false,
            appointment.isAllDay);
      }

      if (agendaViewNotifier.value != null &&
          isSameDate(agendaViewNotifier.value.hoveringDate, selectedDate)) {
        _addMouseHovering(canvas, size, rect, isScheduleWebUI, padding);
      }

      yPosition += appointmentHeight + padding;
    }
  }

  double _getTextSize(Rect rect, TextStyle appointmentTextStyle) {
    // The default font size if none is specified.
    // The value taken from framework, for text style when there is no font
    // size given they have used 14 as the default font size.
    const double defaultFontSize = 14;
    final double textSize = kIsWeb
        ? appointmentTextStyle.fontSize != null
            ? appointmentTextStyle.fontSize * 1.5
            : defaultFontSize * 1.5
        : appointmentTextStyle.fontSize ?? defaultFontSize;
    if (rect.width < textSize || rect.height < textSize) {
      return rect.width > rect.height ? rect.height : rect.width;
    }

    return textSize;
  }

  void _drawIcon(
      Canvas canvas,
      Size size,
      double textSize,
      Rect rect,
      double padding,
      bool isScheduleWebUI,
      Radius cornerRadius,
      TextSpan icon,
      double appointmentHeight,
      double yPosition,
      bool isSpan,
      bool isAllDay) {
    _textPainter.text = icon;
    _textPainter.textScaleFactor = textScaleFactor;
    _textPainter.layout(
        minWidth: 0, maxWidth: size.width - (2 * padding) - padding);
    final double iconSize = textSize + 8;
    if (!isScheduleWebUI) {
      if (isRTL) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(
                    rect.left, rect.top, rect.left + iconSize, rect.bottom),
                cornerRadius),
            _rectPainter);
      } else {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(
                    rect.right - iconSize, rect.top, rect.right, rect.bottom),
                cornerRadius),
            _rectPainter);
      }
    }

    double iconStartPosition = 0;
    if (isSpan) {
      /// There is a space around the font, hence to get the start position we
      /// must calculate the icon start position, apart from the space, and the
      /// value 2 used since the space on top and bottom of icon is not even,
      /// hence to rectify this tha value 2 used, and tested with multiple
      /// device.
      iconStartPosition =
          (_textPainter.height - (icon.style.fontSize * textScaleFactor) / 2) /
              2;
    }

    // Value 8 added as a right side padding for the recurrence icon in the
    // agenda view
    if (isRTL) {
      _textPainter.paint(
          canvas, Offset(8, rect.top + yPosition - iconStartPosition));
    } else {
      _textPainter.paint(
          canvas,
          Offset(rect.right - _textPainter.width - 8,
              rect.top + yPosition - iconStartPosition));
    }
  }

  double _updatePainterLinesCount(double appointmentHeight,
      {bool isSpanned = false, bool isAllDay = false}) {
    final double lineHeight = _textPainter.preferredLineHeight;

    /// Top and bottom padding 5
    const double verticalPadding = 10;
    final int maxLines =
        ((appointmentHeight - verticalPadding) / lineHeight).floor();
    if (maxLines > 1) {
      _textPainter.maxLines = isSpanned || isAllDay ? maxLines : maxLines - 1;
    }

    _textPainter.ellipsis = '..';
    return lineHeight;
  }

  double _drawNormalAppointmentUI(
      Canvas canvas,
      Size size,
      double xPosition,
      double yPosition,
      double padding,
      double timeWidth,
      bool isRecurrence,
      double recurrenceTextSize,
      Appointment appointment,
      double appointmentHeight,
      TextStyle appointmentTextStyle) {
    _textPainter.textScaleFactor = textScaleFactor;
    final double lineHeight = _updatePainterLinesCount(appointmentHeight,
        isAllDay: false, isSpanned: false);
    final double iconSize = isRecurrence ? recurrenceTextSize + 10 : 0;
    _textPainter.layout(
        minWidth: 0,
        maxWidth: size.width - (2 * padding) - xPosition - iconSize);
    final double subjectHeight = _textPainter.height;
    final double topPadding =
        (appointmentHeight - (subjectHeight + lineHeight)) / 2;
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (3 * padding) - timeWidth;
    }

    _textPainter.paint(
        canvas, Offset(xPosition + padding, yPosition + topPadding));

    final String format = appointmentTimeTextFormat ??
        (isSameDate(appointment._actualStartTime, appointment._actualEndTime)
            ? 'hh:mm a'
            : 'MMM dd, hh:mm a');
    final TextSpan span = TextSpan(
        text: DateFormat(format, locale).format(appointment._actualStartTime) +
            ' - ' +
            DateFormat(format, locale).format(appointment._actualEndTime),
        style: appointmentTextStyle);
    _textPainter.text = span;

    _textPainter.maxLines = 1;
    _textPainter.layout(
        minWidth: 0, maxWidth: size.width - (2 * padding) - padding - iconSize);
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (3 * padding);
    }
    _textPainter.paint(canvas,
        Offset(xPosition + padding, yPosition + topPadding + subjectHeight));

    return topPadding;
  }

  double _drawSpanningAppointmentForScheduleView(
      Canvas canvas,
      Size size,
      double xPosition,
      double yPosition,
      double padding,
      Appointment appointment,
      TextStyle appointmentTextStyle,
      double appointmentHeight,
      Rect rect,
      bool isScheduleWebUI,
      Radius cornerRadius) {
    final TextSpan span = TextSpan(
        text: _getSpanAppointmentText(appointment, selectedDate),
        style: appointmentTextStyle);

    _updateTextPainterProperties(span);
    _updatePainterLinesCount(appointmentHeight,
        isAllDay: false, isSpanned: true);
    final bool isNeedSpanIcon =
        !isSameDate(appointment._exactEndTime, selectedDate);
    final double textSize = _getTextSize(rect, appointmentTextStyle);

    /// Icon padding 8 and 2 additional padding
    final double iconSize = isNeedSpanIcon ? textSize + 10 : 0;
    double maxTextWidth = size.width - 10 - padding - iconSize;
    maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
    _textPainter.layout(minWidth: 0, maxWidth: maxTextWidth);
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (padding * 3);
    }

    final double topPadding = (appointmentHeight - _textPainter.height) / 2;
    _textPainter.paint(
        canvas, Offset(xPosition + padding, yPosition + topPadding));

    if (!isNeedSpanIcon) {
      return topPadding;
    }

    final TextSpan icon = _getSpanIcon(appointmentTextStyle.color,
        kIsWeb ? textSize / 1.5 : textSize, isRTL ? false : true);
    _drawIcon(canvas, size, textSize, rect, padding, isScheduleWebUI,
        cornerRadius, icon, appointmentHeight, topPadding, true, false);
    return topPadding;
  }

  void _drawDefaultView(Canvas canvas, Size size, double xPosition,
      double yPosition, double padding) {
    final TextSpan span = TextSpan(
      text: selectedDate == null
          ? localizations.noSelectedDateCalendarLabel
          : localizations.noEventsCalendarLabel,
      style: const TextStyle(
          color: Colors.grey, fontSize: 15, fontFamily: 'Roboto'),
    );

    _updateTextPainterProperties(span);
    _textPainter.layout(minWidth: 0, maxWidth: size.width - 10);
    if (isRTL) {
      xPosition = size.width - _textPainter.width;
    }
    _textPainter.paint(canvas, Offset(xPosition, yPosition + padding));
  }

  void _updateTextPainterProperties(TextSpan span) {
    _textPainter ??= TextPainter();
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaleFactor = textScaleFactor;
  }

  double _addScheduleViewForWeb(
      Canvas canvas,
      Size size,
      double agendaItemHeight,
      double padding,
      double xPosition,
      double yPosition,
      double timeWidth,
      double appointmentHeight,
      bool isNeedIcon,
      double textSize,
      Appointment appointment,
      TextStyle appointmentTextStyle) {
    _textPainter.textScaleFactor = textScaleFactor;
    final double centerYPosition = agendaItemHeight / 2;
    final double circleRadius =
        centerYPosition > padding ? padding : centerYPosition - 2;
    final double circleStartPosition = 3 * circleRadius;
    canvas.drawCircle(
        Offset(isRTL ? size.width - circleStartPosition : circleStartPosition,
            yPosition + centerYPosition),
        circleRadius,
        _rectPainter);
    final double circleWidth = 5 * circleRadius;
    xPosition += circleWidth;

    _updatePainterLinesCount(appointmentHeight,
        isAllDay: true, isSpanned: true);

    /// Icon padding 8 and 2 additional padding
    final double iconSize = isNeedIcon ? textSize + 10 : 0;

    _textPainter.layout(
        minWidth: 0,
        maxWidth: size.width - (2 * padding) - xPosition - iconSize);

    if (isRTL) {
      xPosition = size.width -
          _textPainter.width -
          (3 * padding) -
          timeWidth -
          circleWidth;
    }

    final double topPadding = ((appointmentHeight - _textPainter.height) / 2);
    _textPainter.paint(
        canvas, Offset(xPosition + padding, yPosition + topPadding));
    final DateFormat format =
        DateFormat(appointmentTimeTextFormat ?? 'hh:mm a', locale);
    final TextSpan span = TextSpan(
        text: appointment.isAllDay || appointment._isSpanned
            ? 'All Day'
            : format.format(appointment._actualStartTime) +
                ' - ' +
                format.format(appointment._actualEndTime),
        style: appointmentTextStyle);
    _textPainter.text = span;

    _textPainter.layout(minWidth: 0, maxWidth: timeWidth - padding);
    xPosition = padding + circleWidth;
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (3 * padding) - circleWidth;
    }

    _textPainter.paint(
        canvas,
        Offset(xPosition + padding,
            yPosition + ((appointmentHeight - _textPainter.height) / 2)));
    return topPadding;
  }

  void _addMouseHovering(Canvas canvas, Size size, Rect rect,
      bool isScheduleWebUI, double padding) {
    _rectPainter ??= Paint();
    if (rect.left < agendaViewNotifier.value.hoveringOffset.dx &&
        rect.right > agendaViewNotifier.value.hoveringOffset.dx &&
        rect.top < agendaViewNotifier.value.hoveringOffset.dy &&
        rect.bottom > agendaViewNotifier.value.hoveringOffset.dy) {
      if (isScheduleWebUI) {
        _rectPainter.color = Colors.grey.withOpacity(0.1);
        const double viewPadding = 2;
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(
                    0,
                    rect.top + viewPadding,
                    size.width - (isRTL ? viewPadding : padding),
                    rect.height - (2 * viewPadding)),
                Radius.circular(4)),
            _rectPainter);
      } else {
        _rectPainter.color =
            calendarTheme.selectionBorderColor.withOpacity(0.4);
        _rectPainter.style = PaintingStyle.stroke;
        _rectPainter.strokeWidth = 2;
        canvas.drawRect(rect, _rectPainter);
        _rectPainter.style = PaintingStyle.fill;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilder(size);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return true;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    const double left = 5.0;
    double top = 5.0;
    const double padding = 5.0;
    final double agendaItemHeight =
        _getScheduleAppointmentHeight(monthViewSettings, scheduleViewSettings);
    final double agendaAllDayItemHeight = _getScheduleAllDayAppointmentHeight(
        monthViewSettings, scheduleViewSettings);
    if (selectedDate == null) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: const SemanticsProperties(
          label: 'No selected date',
          textDirection: TextDirection.ltr,
        ),
      ));
    } else if (selectedDate != null &&
        (appointments == null || appointments.isEmpty)) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: SemanticsProperties(
          label: DateFormat('EEEEE').format(selectedDate).toString() +
              DateFormat('dd/MMMM/yyyy').format(selectedDate).toString() +
              ', '
                  'No events',
          textDirection: TextDirection.ltr,
        ),
      ));
    } else if (selectedDate != null &&
        appointments != null &&
        appointments.isNotEmpty) {
      final bool isScheduleWebUI =
          scheduleViewSettings != null && kIsWeb ? true : false;
      for (int i = 0; i < appointments.length; i++) {
        final Appointment currentAppointment = appointments[i];
        final double height = (currentAppointment.isAllDay ||
                    currentAppointment._actualEndTime.day !=
                        currentAppointment._actualStartTime.day ||
                    currentAppointment._isSpanned) &&
                !isScheduleWebUI
            ? agendaAllDayItemHeight
            : agendaItemHeight;
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(left, top, size.width - left - padding, height),
          properties: SemanticsProperties(
            label: _getAppointmentText(currentAppointment),
            textDirection: TextDirection.ltr,
          ),
        ));
        top += height + padding;
      }
    }

    return semanticsBuilder;
  }
}

class _AgendaDateTimePainter extends CustomPainter {
  _AgendaDateTimePainter(
      this.selectedDate,
      this.monthViewSettings,
      this.scheduleViewSettings,
      this.todayHighlightColor,
      this.todayTextStyle,
      this.locale,
      this.calendarTheme,
      this.agendaDateNotifier,
      this.viewWidth,
      this.isRTL,
      this.textScaleFactor)
      : super(repaint: agendaDateNotifier);

  final DateTime selectedDate;
  final MonthViewSettings monthViewSettings;
  final ScheduleViewSettings scheduleViewSettings;
  final Color todayHighlightColor;
  final TextStyle todayTextStyle;
  final String locale;
  final ValueNotifier<_ScheduleViewHoveringDetails> agendaDateNotifier;
  final SfCalendarThemeData calendarTheme;
  final double viewWidth;
  final bool isRTL;
  final double textScaleFactor;
  Paint _linePainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _linePainter = _linePainter ?? Paint();
    _linePainter.isAntiAlias = true;
    const double padding = 5;
    if (selectedDate == null) {
      return;
    }

    final bool isToday = isSameDate(selectedDate, DateTime.now());
    TextStyle dateTextStyle, dayTextStyle;
    if (monthViewSettings != null) {
      dayTextStyle = monthViewSettings.agendaStyle.dayTextStyle ??
          calendarTheme.agendaDayTextStyle;
      dateTextStyle = monthViewSettings.agendaStyle.dateTextStyle ??
          calendarTheme.agendaDateTextStyle;
    } else {
      dayTextStyle = scheduleViewSettings.dayHeaderSettings.dayTextStyle ??
          ((kIsWeb && viewWidth > _kMobileViewWidth)
              ? TextStyle(
                  color: calendarTheme.agendaDayTextStyle.color,
                  fontSize: 9,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500)
              : calendarTheme.agendaDayTextStyle);
      dateTextStyle = scheduleViewSettings.dayHeaderSettings.dateTextStyle ??
          ((kIsWeb && viewWidth > _kMobileViewWidth)
              ? TextStyle(
                  color: calendarTheme.agendaDateTextStyle.color,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal)
              : calendarTheme.agendaDateTextStyle);
    }

    final Color selectedDayTextColor = isToday
        ? todayHighlightColor ?? calendarTheme.todayHighlightColor
        : dayTextStyle != null
            ? dayTextStyle.color
            : calendarTheme.agendaDayTextStyle.color;
    final Color selectedDateTextColor = isToday
        ? calendarTheme.todayTextStyle.color
        : dateTextStyle != null
            ? dateTextStyle.color
            : calendarTheme.agendaDateTextStyle.color;
    dayTextStyle = dayTextStyle.copyWith(color: selectedDayTextColor);
    dateTextStyle = dateTextStyle.copyWith(color: selectedDateTextColor);
    if (isToday) {
      dayTextStyle = todayTextStyle != null
          ? todayTextStyle.copyWith(
              fontSize: dayTextStyle.fontSize, color: selectedDayTextColor)
          : dayTextStyle;
      dateTextStyle = todayTextStyle != null
          ? todayTextStyle.copyWith(
              fontSize: dateTextStyle.fontSize, color: selectedDateTextColor)
          : dateTextStyle;
    }

    /// Draw day label other than web schedule view.
    if (scheduleViewSettings == null ||
        (!kIsWeb || (kIsWeb && viewWidth < _kMobileViewWidth))) {
      _addDayLabelForMobile(
          canvas, size, padding, dayTextStyle, dateTextStyle, isToday);
    } else {
      _addDayLabelForWeb(
          canvas, size, padding, dayTextStyle, dateTextStyle, isToday);
    }
  }

  void _updateTextPainter(TextSpan span) {
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.parent;
    _textPainter.textScaleFactor = textScaleFactor;
  }

  void _addDayLabelForMobile(Canvas canvas, Size size, double padding,
      TextStyle dayTextStyle, TextStyle dateTextStyle, bool isToday) {
    //// Draw Weekday
    final String dayTextFormat = scheduleViewSettings != null
        ? scheduleViewSettings.dayHeaderSettings.dayFormat
        : 'EEE';
    TextSpan span = TextSpan(
        text: DateFormat(dayTextFormat, locale)
            .format(selectedDate)
            .toUpperCase()
            .toString(),
        style: dayTextStyle);
    _updateTextPainter(span);

    _textPainter.layout(minWidth: 0, maxWidth: size.width);
    _textPainter.paint(
        canvas,
        Offset(
            padding + ((size.width - (2 * padding) - _textPainter.width) / 2),
            padding));

    final double weekDayHeight = padding + _textPainter.height;
    //// Draw Date
    span = TextSpan(text: selectedDate.day.toString(), style: dateTextStyle);
    _updateTextPainter(span);

    _textPainter.layout(minWidth: 0, maxWidth: size.width);

    /// The padding value provides the space between the date and day text.
    const int inBetweenPadding = 2;
    final double xPosition =
        padding + ((size.width - (2 * padding) - _textPainter.width) / 2);
    double yPosition = weekDayHeight;
    if (isToday) {
      yPosition = weekDayHeight + padding + inBetweenPadding;
      _linePainter.color = todayHighlightColor;
      _drawTodayCircle(canvas, xPosition, yPosition, padding);
    }

    /// padding added between date and day labels in web, to avoid the
    /// hovering effect overlapping issue.
    if (kIsWeb && !isToday) {
      yPosition = weekDayHeight + padding + inBetweenPadding;
    }
    if (agendaDateNotifier.value != null &&
        isSameDate(agendaDateNotifier.value.hoveringDate, selectedDate)) {
      if (xPosition < agendaDateNotifier.value.hoveringOffset.dx &&
          xPosition + _textPainter.width >
              agendaDateNotifier.value.hoveringOffset.dx &&
          yPosition < agendaDateNotifier.value.hoveringOffset.dy &&
          yPosition + _textPainter.height >
              agendaDateNotifier.value.hoveringOffset.dy) {
        _linePainter.color = isToday
            ? Colors.black.withOpacity(0.1)
            : (calendarTheme.brightness != null &&
                        calendarTheme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87)
                .withOpacity(0.04);
        _drawTodayCircle(canvas, xPosition, yPosition, padding);
      }
    }

    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  void _addDayLabelForWeb(Canvas canvas, Size size, double padding,
      TextStyle dayTextStyle, TextStyle dateTextStyle, bool isToday) {
    /// Draw day label on web schedule view.
    final String dateText = selectedDate.day.toString();

    /// Calculate the date text maximum width value.
    final String maxWidthDateText = '30';
    final String dayText = DateFormat(
            isRTL
                ? scheduleViewSettings.dayHeaderSettings.dayFormat + ', MMM'
                : 'MMM, ' + scheduleViewSettings.dayHeaderSettings.dayFormat,
            locale)
        .format(selectedDate)
        .toUpperCase()
        .toString();

    //// Draw Weekday
    TextSpan span = TextSpan(text: maxWidthDateText, style: dateTextStyle);
    _updateTextPainter(span);
    _textPainter.layout(minWidth: 0, maxWidth: size.width);

    /// Calculate the start padding value for web schedule view date time label.
    double startXPosition = size.width / 5;
    startXPosition = isRTL ? size.width - startXPosition : startXPosition;
    final double dateHeight = size.height;
    final double yPosition = (dateHeight - _textPainter.height) / 2;
    final double painterWidth = _textPainter.width;
    span = TextSpan(text: dateText, style: dateTextStyle);
    _textPainter.text = span;
    _textPainter.layout(minWidth: 0, maxWidth: size.width);
    double dateTextPadding = (painterWidth - _textPainter.width) / 2;
    if (dateTextPadding < 0) {
      dateTextPadding = 0;
    }

    final double dateTextStartPosition = startXPosition + dateTextPadding;
    if (isToday) {
      _linePainter.color = todayHighlightColor;
      _drawTodayCircle(canvas, dateTextStartPosition, yPosition, padding);
    }

    if (agendaDateNotifier.value != null &&
        isSameDate(agendaDateNotifier.value.hoveringDate, selectedDate)) {
      if (dateTextStartPosition <
              (isRTL
                  ? size.width - agendaDateNotifier.value.hoveringOffset.dx
                  : agendaDateNotifier.value.hoveringOffset.dx) &&
          (dateTextStartPosition + _textPainter.width) >
              (isRTL
                  ? size.width - agendaDateNotifier.value.hoveringOffset.dx
                  : agendaDateNotifier.value.hoveringOffset.dx) &&
          yPosition < agendaDateNotifier.value.hoveringOffset.dy &&
          (yPosition + _textPainter.height) >
              agendaDateNotifier.value.hoveringOffset.dy) {
        _linePainter.color = isToday
            ? Colors.black.withOpacity(0.1)
            : (calendarTheme.brightness != null &&
                        calendarTheme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87)
                .withOpacity(0.04);
        _drawTodayCircle(canvas, dateTextStartPosition, yPosition, padding);
      }
    }

    _textPainter.paint(canvas, Offset(dateTextStartPosition, yPosition));

    //// Draw Date
    span = TextSpan(text: dayText, style: dayTextStyle);
    _textPainter.text = span;
    if (isRTL) {
      _textPainter.layout(minWidth: 0, maxWidth: startXPosition);
      startXPosition -= _textPainter.width + (3 * padding);
      if (startXPosition > 0) {
        _textPainter.paint(canvas,
            Offset(startXPosition, (dateHeight - _textPainter.height) / 2));
      }
    } else {
      startXPosition += painterWidth + (3 * padding);
      if (startXPosition > size.width) {
        return;
      }
      _textPainter.layout(minWidth: 0, maxWidth: size.width - startXPosition);
      _textPainter.paint(canvas,
          Offset(startXPosition, (dateHeight - _textPainter.height) / 2));
    }
  }

  void _drawTodayCircle(
      Canvas canvas, double xPosition, double yPosition, double padding) {
    canvas.drawCircle(
        Offset(xPosition + (_textPainter.width / 2),
            yPosition + (_textPainter.height / 2)),
        _textPainter.width > _textPainter.height
            ? (_textPainter.width / 2) + padding
            : (_textPainter.height / 2) + padding,
        _linePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilder(size);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return true;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    if (selectedDate == null) {
      return semanticsBuilder;
    } else if (selectedDate != null) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: SemanticsProperties(
          label: DateFormat('EEEEE').format(selectedDate).toString() +
              DateFormat('dd/MMMM/yyyy').format(selectedDate).toString(),
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    return semanticsBuilder;
  }
}
