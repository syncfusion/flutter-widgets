part of calendar;

class _ViewHeaderViewPainter extends CustomPainter {
  _ViewHeaderViewPainter(
      this.visibleDates,
      this.view,
      this.viewHeaderStyle,
      this.timeSlotViewSettings,
      this.timeLabelWidth,
      this.viewHeaderHeight,
      this.monthViewSettings,
      this.isRTL,
      this.locale,
      this.calendarTheme,
      this.todayHighlightColor,
      this.todayTextStyle,
      this.cellBorderColor,
      this.minDate,
      this.maxDate,
      this.viewHeaderNotifier,
      this.textScaleFactor)
      : super(repaint: viewHeaderNotifier);

  final CalendarView view;
  final ViewHeaderStyle viewHeaderStyle;
  final TimeSlotViewSettings timeSlotViewSettings;
  final MonthViewSettings monthViewSettings;
  final List<DateTime> visibleDates;
  final double timeLabelWidth;
  final double viewHeaderHeight;
  final SfCalendarThemeData calendarTheme;
  final bool isRTL;
  final String locale;
  final Color todayHighlightColor;
  final TextStyle todayTextStyle;
  final Color cellBorderColor;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueNotifier<Offset> viewHeaderNotifier;
  final double textScaleFactor;
  DateTime _currentDate;
  String _dayText, _dateText;
  Paint _circlePainter;
  TextPainter _dayTextPainter, _dateTextPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double width = size.width;
    width = _getViewHeaderWidth(width);

    /// Initializes the default text style for the texts in view header of
    /// calendar.
    final TextStyle viewHeaderDayStyle =
        viewHeaderStyle.dayTextStyle ?? calendarTheme.viewHeaderDayTextStyle;
    final TextStyle viewHeaderDateStyle =
        viewHeaderStyle.dateTextStyle ?? calendarTheme.viewHeaderDateTextStyle;

    final DateTime today = DateTime.now();
    if (view != CalendarView.month) {
      _addViewHeaderForTimeSlotViews(
          canvas, size, viewHeaderDayStyle, viewHeaderDateStyle, width, today);
    } else {
      _addViewHeaderForMonthView(
          canvas, size, viewHeaderDayStyle, width, today);
    }
  }

  void _addViewHeaderForMonthView(Canvas canvas, Size size,
      TextStyle viewHeaderDayStyle, double width, DateTime today) {
    TextStyle dayTextStyle = viewHeaderDayStyle;
    double xPosition = 0;
    double yPosition = 0;
    if (isRTL) {
      xPosition = size.width - width;
    }
    bool hasToday = false;
    for (int i = 0; i < _kNumberOfDaysInWeek; i++) {
      _currentDate = visibleDates[i];
      _dayText = DateFormat(monthViewSettings.dayFormat, locale)
          .format(_currentDate)
          .toString()
          .toUpperCase();

      _dayText = _updateViewHeaderFormat(monthViewSettings.dayFormat);

      hasToday = monthViewSettings.numberOfWeeksInView > 0 &&
              monthViewSettings.numberOfWeeksInView < 6
          ? true
          : visibleDates[visibleDates.length ~/ 2].month == today.month
              ? true
              : false;

      if (hasToday &&
          isDateWithInDateRange(
              visibleDates[0], visibleDates[visibleDates.length - 1], today) &&
          _currentDate.weekday == today.weekday) {
        dayTextStyle = todayTextStyle != null
            ? todayTextStyle.copyWith(
                fontSize: viewHeaderDayStyle.fontSize,
                color: todayHighlightColor)
            : viewHeaderDayStyle.copyWith(color: todayHighlightColor);
      } else {
        dayTextStyle = viewHeaderDayStyle;
      }

      _updateDayTextPainter(dayTextStyle, width);

      if (yPosition == 0) {
        yPosition = (viewHeaderHeight - _dayTextPainter.height) / 2;
      }

      if (viewHeaderNotifier.value != null) {
        _addMouseHoverForMonth(canvas, size, xPosition, yPosition, width);
      }

      _dayTextPainter.paint(
          canvas,
          Offset(
              xPosition + (width / 2 - _dayTextPainter.width / 2), yPosition));

      if (isRTL) {
        xPosition -= width;
      } else {
        xPosition += width;
      }
    }
  }

  void _addViewHeaderForTimeSlotViews(
      Canvas canvas,
      Size size,
      TextStyle viewHeaderDayStyle,
      TextStyle viewHeaderDateStyle,
      double width,
      DateTime today) {
    double xPosition, yPosition;
    final double labelWidth =
        view == CalendarView.day && timeLabelWidth < 50 ? 50 : timeLabelWidth;
    TextStyle dayTextStyle = viewHeaderDayStyle;
    TextStyle dateTextStyle = viewHeaderDateStyle;
    const double topPadding = 5;
    if (view == CalendarView.day) {
      width = labelWidth;
    }

    xPosition = view == CalendarView.day ? 0 : timeLabelWidth;
    yPosition = 2;
    final double cellWidth = width / visibleDates.length;
    if (isRTL && view != CalendarView.day) {
      xPosition = size.width - timeLabelWidth - cellWidth;
    }
    for (int i = 0; i < visibleDates.length; i++) {
      _currentDate = visibleDates[i];
      _dayText = DateFormat(timeSlotViewSettings.dayFormat, locale)
          .format(_currentDate)
          .toString()
          .toUpperCase();

      _dayText = _updateViewHeaderFormat(timeSlotViewSettings.dayFormat);

      _dateText = DateFormat(timeSlotViewSettings.dateFormat)
          .format(_currentDate)
          .toString();
      final bool isToday = isSameDate(_currentDate, today);
      if (isToday) {
        dayTextStyle = todayTextStyle != null
            ? todayTextStyle.copyWith(
                fontSize: viewHeaderDayStyle.fontSize,
                color: todayHighlightColor)
            : viewHeaderDayStyle.copyWith(color: todayHighlightColor);
        dateTextStyle = todayTextStyle != null
            ? todayTextStyle.copyWith(fontSize: viewHeaderDateStyle.fontSize)
            : viewHeaderDateStyle.copyWith(
                color: calendarTheme.todayTextStyle.color);
      } else {
        dayTextStyle = viewHeaderDayStyle;
        dateTextStyle = viewHeaderDateStyle;
      }

      if (!isDateWithInDateRange(minDate, maxDate, _currentDate)) {
        if (calendarTheme.brightness == Brightness.light) {
          dayTextStyle = dayTextStyle.copyWith(color: Colors.black26);
          dateTextStyle = dateTextStyle.copyWith(color: Colors.black26);
        } else {
          dayTextStyle = dayTextStyle.copyWith(color: Colors.white38);
          dateTextStyle = dateTextStyle.copyWith(color: Colors.white38);
        }
      }

      _updateDayTextPainter(dayTextStyle, width);

      final TextSpan dateTextSpan = TextSpan(
        text: _dateText,
        style: dateTextStyle,
      );

      _dateTextPainter = _dateTextPainter ?? TextPainter();
      _dateTextPainter.text = dateTextSpan;
      _dateTextPainter.textDirection = TextDirection.ltr;
      _dateTextPainter.textAlign = TextAlign.left;
      _dateTextPainter.textWidthBasis = TextWidthBasis.longestLine;
      _dateTextPainter.textScaleFactor = textScaleFactor;

      _dateTextPainter.layout(minWidth: 0, maxWidth: width);

      /// To calculate the day start position by width and day painter
      final double dayXPosition = (cellWidth - _dayTextPainter.width) / 2;

      /// To calculate the date start position by width and date painter
      final double dateXPosition = (cellWidth - _dateTextPainter.width) / 2;

      const int inBetweenPadding = 2;
      yPosition = size.height / 2 -
          (_dayTextPainter.height +
                  topPadding +
                  _dateTextPainter.height +
                  inBetweenPadding) /
              2;

      _dayTextPainter.paint(
          canvas, Offset(xPosition + dayXPosition, yPosition));

      if (isToday) {
        _drawTodayCircle(
            canvas,
            xPosition + dateXPosition,
            yPosition + topPadding + _dayTextPainter.height + inBetweenPadding,
            _dateTextPainter);
      }

      if (viewHeaderNotifier.value != null) {
        _addMouseHoverForTimeSlotView(canvas, size, xPosition, yPosition,
            dateXPosition, topPadding, isToday, inBetweenPadding);
      }

      _dateTextPainter.paint(
          canvas,
          Offset(
              xPosition + dateXPosition,
              yPosition +
                  topPadding +
                  _dayTextPainter.height +
                  inBetweenPadding));

      if (isRTL) {
        xPosition -= cellWidth;
      } else {
        xPosition += cellWidth;
      }
    }
  }

  void _addMouseHoverForMonth(Canvas canvas, Size size, double xPosition,
      double yPosition, double width) {
    _circlePainter ??= Paint();
    if (xPosition + (width / 2 - _dayTextPainter.width / 2) <=
            viewHeaderNotifier.value.dx &&
        xPosition +
                (width / 2 - _dayTextPainter.width / 2) +
                _dayTextPainter.width >=
            viewHeaderNotifier.value.dx &&
        yPosition - 5 <= viewHeaderNotifier.value.dy &&
        (yPosition + size.height) - 5 >= viewHeaderNotifier.value.dy) {
      _drawTodayCircle(
          canvas,
          xPosition + (width / 2 - _dayTextPainter.width / 2),
          yPosition,
          _dayTextPainter,
          hoveringColor: (calendarTheme.brightness != null &&
                      calendarTheme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87)
              .withOpacity(0.04));
    }
  }

  void _addMouseHoverForTimeSlotView(
      Canvas canvas,
      Size size,
      double xPosition,
      double yPosition,
      double dateXPosition,
      double topPadding,
      bool isToday,
      int padding) {
    _circlePainter ??= Paint();
    if (xPosition + dateXPosition <= viewHeaderNotifier.value.dx &&
        xPosition + dateXPosition + _dateTextPainter.width >=
            viewHeaderNotifier.value.dx) {
      final Color hoveringColor = isToday
          ? Colors.black.withOpacity(0.12)
          : (calendarTheme.brightness != null &&
                      calendarTheme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87)
              .withOpacity(0.04);
      _drawTodayCircle(
          canvas,
          xPosition + dateXPosition,
          yPosition + topPadding + _dayTextPainter.height + padding,
          _dateTextPainter,
          hoveringColor: hoveringColor);
    }
  }

  String _updateViewHeaderFormat(String dayFormat) {
    switch (view) {
      case CalendarView.day:
      case CalendarView.schedule:
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
        break;
      case CalendarView.month:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          //// EE format value shows the week days as S, M, T, W, T, F, S.
          if (dayFormat == 'EE' && (locale == null || locale.contains('en'))) {
            return _dayText[0];
          }
        }
    }

    return _dayText;
  }

  void _updateDayTextPainter(TextStyle dayTextStyle, double width) {
    final TextSpan dayTextSpan = TextSpan(
      text: _dayText,
      style: dayTextStyle,
    );

    _dayTextPainter = _dayTextPainter ?? TextPainter();
    _dayTextPainter.text = dayTextSpan;
    _dayTextPainter.textDirection = TextDirection.ltr;
    _dayTextPainter.textAlign = TextAlign.left;
    _dayTextPainter.textWidthBasis = TextWidthBasis.longestLine;
    _dayTextPainter.textScaleFactor = textScaleFactor;

    _dayTextPainter.layout(minWidth: 0, maxWidth: width);
  }

  double _getViewHeaderWidth(double width) {
    switch (view) {
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
      case CalendarView.schedule:
        return null;
      case CalendarView.month:
        return width / _kNumberOfDaysInWeek;
      case CalendarView.day:
        return timeLabelWidth;
      case CalendarView.week:
      case CalendarView.workWeek:
        return width - timeLabelWidth;
    }

    return null;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _ViewHeaderViewPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.viewHeaderStyle != viewHeaderStyle ||
        oldWidget.viewHeaderHeight != viewHeaderHeight ||
        oldWidget.todayHighlightColor != todayHighlightColor ||
        oldWidget.timeSlotViewSettings != timeSlotViewSettings ||
        oldWidget.monthViewSettings != monthViewSettings ||
        oldWidget.cellBorderColor != cellBorderColor ||
        oldWidget.calendarTheme != calendarTheme ||
        oldWidget.isRTL != isRTL ||
        oldWidget.locale != locale ||
        oldWidget.todayTextStyle != todayTextStyle ||
        oldWidget.textScaleFactor != textScaleFactor;
  }

  //// draw today highlight circle in view header.
  void _drawTodayCircle(
      Canvas canvas, double x, double y, TextPainter dateTextPainter,
      {Color hoveringColor}) {
    _circlePainter = _circlePainter ?? Paint();
    _circlePainter.color = hoveringColor ?? todayHighlightColor;
    const double circlePadding = 5;
    final double painterWidth = dateTextPainter.width / 2;
    final double painterHeight = dateTextPainter.height / 2;
    final double radius =
        painterHeight > painterWidth ? painterHeight : painterWidth;
    canvas.drawCircle(Offset(x + painterWidth, y + painterHeight),
        radius + circlePadding, _circlePainter);
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
    final _ViewHeaderViewPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates;
  }

  String _getAccessibilityText(DateTime date) {
    if (!isDateWithInDateRange(minDate, maxDate, date)) {
      return DateFormat('EEEEE').format(date).toString() +
          DateFormat('dd/MMMM/yyyy').format(date).toString() +
          ', Disabled date';
    }

    return DateFormat('EEEEE').format(date).toString() +
        DateFormat('dd/MMMM/yyyy').format(date).toString();
  }

  List<CustomPainterSemantics> _getSemanticsForMonthViewHeader(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    final double cellWidth = size.width / _kNumberOfDaysInWeek;
    double left = isRTL ? size.width - cellWidth : 0;
    const double top = 0;
    for (int i = 0; i < _kNumberOfDaysInWeek; i++) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(left, top, cellWidth, size.height),
        properties: SemanticsProperties(
          label: DateFormat('EEEEE')
              .format(visibleDates[i])
              .toString()
              .toUpperCase(),
          textDirection: TextDirection.ltr,
        ),
      ));
      if (isRTL) {
        left -= cellWidth;
      } else {
        left += cellWidth;
      }
    }

    return semanticsBuilder;
  }

  List<CustomPainterSemantics> _getSemanticsForDayHeader(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    const double top = 0;
    double left;
    final double cellWidth = view == CalendarView.day
        ? size.width
        : (size.width - timeLabelWidth) / visibleDates.length;
    if (isRTL) {
      left = view == CalendarView.day
          ? size.width - timeLabelWidth
          : (size.width - timeLabelWidth) - cellWidth;
    } else {
      left = view == CalendarView.day ? 0 : timeLabelWidth;
    }
    for (int i = 0; i < visibleDates.length; i++) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(left, top, cellWidth, size.height),
        properties: SemanticsProperties(
          label: _getAccessibilityText(visibleDates[i]),
          textDirection: TextDirection.ltr,
        ),
      ));
      if (isRTL) {
        left -= cellWidth;
      } else {
        left += cellWidth;
      }
    }

    return semanticsBuilder;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    switch (view) {
      case CalendarView.schedule:
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
        return null;
      case CalendarView.month:
        return _getSemanticsForMonthViewHeader(size);
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        return _getSemanticsForDayHeader(size);
    }

    return null;
  }
}
