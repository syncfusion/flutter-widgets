part of calendar;

class _MonthViewWidget extends StatefulWidget {
  _MonthViewWidget(
      this.visibleDates,
      this.rowCount,
      this.monthCellStyle,
      this.isRTL,
      this.todayHighlightColor,
      this.todayTextStyle,
      this.cellBorderColor,
      this.calendarTheme,
      this.calendarCellNotifier,
      this.showTrailingAndLeadingDates,
      this.minDate,
      this.maxDate,
      this.calendar,
      this.blackoutDates,
      this.blackoutDatesTextStyle,
      this.textScaleFactor,
      this.builder,
      this.width,
      this.height,
      this.visibleAppointmentNotifier);

  final int rowCount;
  final MonthCellStyle monthCellStyle;
  final List<DateTime> visibleDates;
  final bool isRTL;
  final Color todayHighlightColor;
  final TextStyle todayTextStyle;
  final Color cellBorderColor;
  final SfCalendarThemeData calendarTheme;
  final ValueNotifier<Offset> calendarCellNotifier;
  final DateTime minDate;
  final DateTime maxDate;
  final SfCalendar calendar;
  final bool showTrailingAndLeadingDates;
  final List<DateTime> blackoutDates;
  final TextStyle blackoutDatesTextStyle;
  final double textScaleFactor;
  final double width;
  final double height;
  final MonthCellBuilder builder;
  final ValueNotifier<List<Appointment>> visibleAppointmentNotifier;

  @override
  _MonthViewWidgetState createState() => _MonthViewWidgetState();
}

class _MonthViewWidgetState extends State<_MonthViewWidget> {
  @override
  void initState() {
    widget.visibleAppointmentNotifier.addListener(_updateAppointment);
    super.initState();
  }

  @override
  void didUpdateWidget(_MonthViewWidget oldWidget) {
    if (widget.visibleAppointmentNotifier !=
        oldWidget.visibleAppointmentNotifier) {
      oldWidget.visibleAppointmentNotifier?.removeListener(_updateAppointment);
      widget.visibleAppointmentNotifier?.addListener(_updateAppointment);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.visibleAppointmentNotifier?.removeListener(_updateAppointment);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (widget.builder != null) {
      final int visibleDatesCount = widget.visibleDates.length;
      final double cellWidth = widget.width / _kNumberOfDaysInWeek;
      final double cellHeight = widget.height / widget.rowCount;
      double xPosition = 0, yPosition = 0;
      final int currentMonth =
          widget.visibleDates[visibleDatesCount ~/ 2].month;
      final bool showTrailingLeadingDates = _isLeadingAndTrailingDatesVisible(
          widget.rowCount, widget.showTrailingAndLeadingDates);
      for (int i = 0; i < visibleDatesCount; i++) {
        final DateTime currentVisibleDate = widget.visibleDates[i];
        if (!showTrailingLeadingDates &&
            currentMonth != currentVisibleDate.month) {
          xPosition += cellWidth;
          if (xPosition + 1 >= widget.width) {
            xPosition = 0;
            yPosition += cellHeight;
          }

          continue;
        }

        final List<Appointment> appointments = _getSelectedDateAppointments(
            widget.visibleAppointmentNotifier.value,
            widget.calendar.timeZone,
            currentVisibleDate);
        List<dynamic> monthCellAppointment = appointments;
        if (widget.calendar.dataSource != null &&
            !_isCalendarAppointment(widget.calendar.dataSource)) {
          monthCellAppointment = _getCustomAppointments(appointments);
        }

        final MonthCellDetails details = MonthCellDetails(
            date: currentVisibleDate,
            visibleDates: List.unmodifiable(widget.visibleDates),
            appointments: List.unmodifiable(monthCellAppointment),
            bounds: Rect.fromLTWH(
                widget.isRTL ? widget.width - xPosition - cellWidth : xPosition,
                yPosition,
                cellWidth,
                cellHeight));
        final Widget child = widget.builder(context, details);
        if (child != null) {
          children.add(RepaintBoundary(child: child));
        }

        xPosition += cellWidth;
        if (xPosition + 1 >= widget.width) {
          xPosition = 0;
          yPosition += cellHeight;
        }
      }
    }

    return _MonthViewRenderObjectWidget(
      widget.visibleDates,
      widget.visibleAppointmentNotifier.value,
      widget.rowCount,
      widget.monthCellStyle,
      widget.isRTL,
      widget.todayHighlightColor,
      widget.todayTextStyle,
      widget.cellBorderColor,
      widget.calendarTheme,
      widget.calendarCellNotifier,
      widget.minDate,
      widget.maxDate,
      widget.blackoutDates,
      widget.blackoutDatesTextStyle,
      widget.showTrailingAndLeadingDates,
      widget.textScaleFactor,
      widget.width,
      widget.height,
      children: children,
    );
  }

  void _updateAppointment() {
    setState(() {
      /// Update the children when visible appointment changed.
    });
  }
}

class _MonthViewRenderObjectWidget extends MultiChildRenderObjectWidget {
  _MonthViewRenderObjectWidget(
      this.visibleDates,
      this.visibleAppointments,
      this.rowCount,
      this.monthCellStyle,
      this.isRTL,
      this.todayHighlightColor,
      this.todayTextStyle,
      this.cellBorderColor,
      this.calendarTheme,
      this.calendarCellNotifier,
      this.minDate,
      this.maxDate,
      this.blackoutDates,
      this.blackoutDatesTextStyle,
      this.showTrailingAndLeadingDates,
      this.textScaleFactor,
      this.width,
      this.height,
      {List<Widget> children})
      : super(children: children);

  final int rowCount;
  final MonthCellStyle monthCellStyle;
  final List<DateTime> visibleDates;
  final List<Appointment> visibleAppointments;
  final bool isRTL;
  final Color todayHighlightColor;
  final TextStyle todayTextStyle;
  final Color cellBorderColor;
  final SfCalendarThemeData calendarTheme;
  final ValueNotifier<Offset> calendarCellNotifier;
  final DateTime minDate;
  final DateTime maxDate;
  final List<DateTime> blackoutDates;
  final TextStyle blackoutDatesTextStyle;
  final bool showTrailingAndLeadingDates;
  final double textScaleFactor;
  final double width;
  final double height;

  @override
  _MonthViewRenderObject createRenderObject(BuildContext context) {
    return _MonthViewRenderObject(
        visibleDates,
        visibleAppointments,
        rowCount,
        monthCellStyle,
        isRTL,
        todayHighlightColor,
        todayTextStyle,
        cellBorderColor,
        calendarTheme,
        calendarCellNotifier,
        minDate,
        maxDate,
        blackoutDates,
        blackoutDatesTextStyle,
        showTrailingAndLeadingDates,
        textScaleFactor,
        width,
        height);
  }

  @override
  void updateRenderObject(
      BuildContext context, _MonthViewRenderObject renderObject) {
    renderObject
      ..visibleDates = visibleDates
      ..visibleAppointments = visibleAppointments
      ..rowCount = rowCount
      ..monthCellStyle = monthCellStyle
      ..isRTL = isRTL
      ..todayHighlightColor = todayHighlightColor
      ..todayTextStyle = todayTextStyle
      ..cellBorderColor = cellBorderColor
      ..calendarTheme = calendarTheme
      ..calendarCellNotifier = calendarCellNotifier
      ..minDate = minDate
      ..maxDate = maxDate
      ..blackoutDates = blackoutDates
      ..blackoutDatesTextStyle = blackoutDatesTextStyle
      ..showTrailingAndLeadingDates = showTrailingAndLeadingDates
      ..textScaleFactor = textScaleFactor
      ..width = width
      ..height = height;
  }
}

class _MonthViewRenderObject extends _CustomCalendarRenderObject {
  _MonthViewRenderObject(
      this._visibleDates,
      this._visibleAppointments,
      this._rowCount,
      this._monthCellStyle,
      this._isRTL,
      this._todayHighlightColor,
      this._todayTextStyle,
      this._cellBorderColor,
      this._calendarTheme,
      this._calendarCellNotifier,
      this._minDate,
      this._maxDate,
      this._blackoutDates,
      this._blackoutDatesTextStyle,
      this._showTrailingAndLeadingDates,
      this._textScaleFactor,
      this._width,
      this._height);

  double _height;

  double get height => _height;

  set height(double value) {
    if (_height == value) {
      return;
    }

    _height = value;
    markNeedsLayout();
  }

  double _width;

  double get width => _width;

  set width(double value) {
    if (_width == value) {
      return;
    }

    _width = value;
    markNeedsLayout();
  }

  int _rowCount;

  int get rowCount => _rowCount;

  set rowCount(int value) {
    if (_rowCount == value) {
      return;
    }

    _rowCount = value;
    markNeedsLayout();
  }

  double _textScaleFactor;

  double get textScaleFactor => _textScaleFactor;

  set textScaleFactor(double value) {
    if (_textScaleFactor == value) {
      return;
    }

    _textScaleFactor = value;
    markNeedsPaint();
  }

  Color _todayHighlightColor;

  Color get todayHighlightColor => _todayHighlightColor;

  set todayHighlightColor(Color value) {
    if (_todayHighlightColor == value) {
      return;
    }

    _todayHighlightColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  TextStyle _todayTextStyle;

  TextStyle get todayTextStyle => _todayTextStyle;

  set todayTextStyle(TextStyle value) {
    if (_todayTextStyle == value) {
      return;
    }

    _todayTextStyle = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  Color _cellBorderColor;

  Color get cellBorderColor => _cellBorderColor;

  set cellBorderColor(Color value) {
    if (_cellBorderColor == value) {
      return;
    }

    _cellBorderColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  DateTime _minDate;

  DateTime get minDate => _minDate;

  set minDate(DateTime value) {
    if (_minDate == value || isSameDate(_minDate, value)) {
      return;
    }

    _minDate = value;
    markNeedsPaint();
  }

  DateTime _maxDate;

  DateTime get maxDate => _maxDate;

  set maxDate(DateTime value) {
    if (_maxDate == value || isSameDate(_maxDate, value)) {
      return;
    }

    _maxDate = value;
    markNeedsPaint();
  }

  MonthCellStyle _monthCellStyle;

  MonthCellStyle get monthCellStyle => _monthCellStyle;

  set monthCellStyle(MonthCellStyle value) {
    if (_monthCellStyle == value) {
      return;
    }

    _monthCellStyle = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  bool _isRTL;

  bool get isRTL => _isRTL;

  set isRTL(bool value) {
    if (_isRTL == value) {
      return;
    }

    _isRTL = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  bool _showTrailingAndLeadingDates;

  bool get showTrailingAndLeadingDates => _showTrailingAndLeadingDates;

  set showTrailingAndLeadingDates(bool value) {
    if (_showTrailingAndLeadingDates == value) {
      return;
    }

    _showTrailingAndLeadingDates = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  SfCalendarThemeData _calendarTheme;

  SfCalendarThemeData get calendarTheme => _calendarTheme;

  set calendarTheme(SfCalendarThemeData value) {
    if (_calendarTheme == value) {
      return;
    }

    _calendarTheme = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  List<DateTime> _visibleDates;

  List<DateTime> get visibleDates => _visibleDates;

  set visibleDates(List<DateTime> value) {
    if (_visibleDates == value) {
      return;
    }

    _visibleDates = value;
    markNeedsPaint();
  }

  List<Appointment> _visibleAppointments;

  List<Appointment> get visibleAppointments => _visibleAppointments;

  set visibleAppointments(List<Appointment> value) {
    if (_visibleAppointments == value) {
      return;
    }

    _visibleAppointments = value;
    if (childCount == 0) {
      return;
    }

    markNeedsPaint();
  }

  List<DateTime> _blackoutDates;

  List<DateTime> get blackoutDates => _blackoutDates;

  set blackoutDates(List<DateTime> value) {
    if (_blackoutDates == value) {
      return;
    }

    final List<DateTime> oldDates = _blackoutDates;
    _blackoutDates = value;
    if (_isEmptyList(_blackoutDates) && _isEmptyList(oldDates)) {
      return;
    }

    _updateBlackoutDatesIndex();
    markNeedsPaint();
  }

  TextStyle _blackoutDatesTextStyle;

  TextStyle get blackoutDatesTextStyle => _blackoutDatesTextStyle;

  set blackoutDatesTextStyle(TextStyle value) {
    if (_blackoutDatesTextStyle == value) {
      return;
    }

    _blackoutDatesTextStyle = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  ValueNotifier<Offset> _calendarCellNotifier;

  ValueNotifier<Offset> get calendarCellNotifier => _calendarCellNotifier;

  set calendarCellNotifier(ValueNotifier<Offset> value) {
    if (_calendarCellNotifier == value) {
      return;
    }

    _calendarCellNotifier?.removeListener(markNeedsPaint);
    _calendarCellNotifier = value;
    _calendarCellNotifier?.addListener(markNeedsPaint);
  }

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _calendarCellNotifier?.addListener(markNeedsPaint);
  }

  /// detach will called when the render object removed from view.
  @override
  void detach() {
    _calendarCellNotifier?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? height : widgetSize.height);
    final double cellWidth = size.width / _kNumberOfDaysInWeek;
    final double cellHeight = size.height / rowCount;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      child.layout(constraints.copyWith(
          minWidth: cellWidth,
          minHeight: cellHeight,
          maxWidth: cellWidth,
          maxHeight: cellHeight));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final bool _isNeedCustomPaint = childCount != 0;
    final double cellWidth = size.width / _kNumberOfDaysInWeek;
    final double cellHeight = size.height / rowCount;
    if (!_isNeedCustomPaint) {
      _drawMonthCells(context.canvas, size);
    } else {
      double xPosition = 0, yPosition = 0;
      RenderBox child = firstChild;
      final int visibleDatesCount = visibleDates.length;
      final int currentMonth = visibleDates[visibleDatesCount ~/ 2].month;
      final bool showTrailingLeadingDates = _isLeadingAndTrailingDatesVisible(
          rowCount, showTrailingAndLeadingDates);
      for (int i = 0; i < visibleDatesCount; i++) {
        final DateTime currentVisibleDate = visibleDates[i];
        if (!showTrailingLeadingDates &&
            currentMonth != currentVisibleDate.month) {
          xPosition += cellWidth;
          if (xPosition + 1 >= size.width) {
            xPosition = 0;
            yPosition += cellHeight;
          }
          continue;
        }

        child.paint(
            context,
            Offset(isRTL ? size.width - xPosition - cellWidth : xPosition,
                yPosition));
        child = childAfter(child);

        if (calendarCellNotifier.value != null &&
            !_isDateInDateCollection(blackoutDates, currentVisibleDate)) {
          _addMouseHovering(context.canvas, size, cellWidth, cellHeight,
              xPosition, yPosition);
        }

        xPosition += cellWidth;
        if (xPosition + 1 >= size.width) {
          xPosition = 0;
          yPosition += cellHeight;
        }
      }
    }
  }

  Paint _linePainter;
  TextPainter _textPainter;
  static const double linePadding = 0.5;
  List<int> _blackoutDatesIndex;

  void _updateBlackoutDatesIndex() {
    _blackoutDatesIndex = <int>[];
    final int count = blackoutDates == null ? 0 : blackoutDates.length;
    for (int i = 0; i < count; i++) {
      final DateTime blackoutDate = blackoutDates[i];
      final int blackoutDateIndex =
          _getVisibleDateIndex(visibleDates, blackoutDate);
      if (blackoutDateIndex == -1) {
        continue;
      }

      _blackoutDatesIndex.add(blackoutDateIndex);
    }
  }

  void _drawMonthCells(Canvas canvas, Size size) {
    if (_blackoutDatesIndex == null || _blackoutDatesIndex.isEmpty) {
      _updateBlackoutDatesIndex();
    }

    double xPosition, yPosition;
    final double cellWidth = size.width / _kNumberOfDaysInWeek;
    final double cellHeight = size.height / rowCount;
    xPosition = isRTL ? size.width - cellWidth : 0;
    const double viewPadding = 5;
    const double circlePadding = 4;
    yPosition = viewPadding;
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaleFactor = textScaleFactor;
    TextStyle textStyle =
        monthCellStyle.textStyle ?? calendarTheme.activeDatesTextStyle;
    final int visibleDatesCount = visibleDates.length;
    final DateTime currentMonthDate = visibleDates[visibleDatesCount ~/ 2];
    final int nextMonth = getNextMonthDate(currentMonthDate).month;
    final int previousMonth = getPreviousMonthDate(currentMonthDate).month;
    final DateTime today = DateTime.now();
    bool isCurrentDate;

    _linePainter = _linePainter ?? Paint();
    _linePainter.isAntiAlias = true;
    final TextStyle todayStyle = todayTextStyle ?? calendarTheme.todayTextStyle;
    final TextStyle currentMonthTextStyle =
        monthCellStyle.textStyle ?? calendarTheme.activeDatesTextStyle;
    final TextStyle previousMonthTextStyle =
        monthCellStyle.trailingDatesTextStyle ??
            calendarTheme.trailingDatesTextStyle;
    final TextStyle nextMonthTextStyle = monthCellStyle.leadingDatesTextStyle ??
        calendarTheme.leadingDatesTextStyle;
    final TextStyle blackoutDatesStyle =
        blackoutDatesTextStyle ?? calendarTheme.blackoutDatesTextStyle;

    final bool showTrailingLeadingDates = _isLeadingAndTrailingDatesVisible(
        rowCount, showTrailingAndLeadingDates);

    for (int i = 0; i < visibleDatesCount; i++) {
      isCurrentDate = false;
      final DateTime currentVisibleDate = visibleDates[i];
      if (currentVisibleDate.month == nextMonth) {
        if (!showTrailingLeadingDates) {
          if (isRTL) {
            if (xPosition.round() == cellWidth.round()) {
              xPosition = 0;
            } else {
              xPosition -= cellWidth;
            }
            if (xPosition < 0) {
              xPosition = size.width - cellWidth;
              yPosition += cellHeight;
            }
          } else {
            xPosition += cellWidth;
            if (xPosition.round() >= size.width.round()) {
              xPosition = 0;
              yPosition += cellHeight;
            }
          }

          continue;
        }

        textStyle = nextMonthTextStyle;
        _linePainter.color = monthCellStyle.leadingDatesBackgroundColor ??
            calendarTheme.leadingDatesBackgroundColor;
      } else if (currentVisibleDate.month == previousMonth) {
        if (!showTrailingLeadingDates) {
          if (isRTL) {
            if (xPosition.round() == cellWidth.round()) {
              xPosition = 0;
            } else {
              xPosition -= cellWidth;
            }
            if (xPosition < 0) {
              xPosition = size.width - cellWidth;
              yPosition += cellHeight;
            }
          } else {
            xPosition += cellWidth;
            if (xPosition.round() >= size.width.round()) {
              xPosition = 0;
              yPosition += cellHeight;
            }
          }

          continue;
        }

        textStyle = previousMonthTextStyle;
        _linePainter.color = monthCellStyle.trailingDatesBackgroundColor ??
            calendarTheme.trailingDatesBackgroundColor;
      } else {
        textStyle = currentMonthTextStyle;
        _linePainter.color = monthCellStyle.backgroundColor ??
            calendarTheme.activeDatesBackgroundColor;
      }

      if (rowCount <= 4) {
        textStyle = currentMonthTextStyle;
      }

      if (isSameDate(currentVisibleDate, today)) {
        _linePainter.color = monthCellStyle.todayBackgroundColor ??
            calendarTheme.todayBackgroundColor;
        textStyle = todayStyle;
        isCurrentDate = true;
      }

      if (!isDateWithInDateRange(minDate, maxDate, currentVisibleDate)) {
        if (calendarTheme.brightness == Brightness.light) {
          textStyle = TextStyle(
              color: Colors.black26, fontSize: 13, fontFamily: 'Roboto');
        } else {
          textStyle = TextStyle(
              color: Colors.white38, fontSize: 13, fontFamily: 'Roboto');
        }
      }

      final bool isBlackoutDate = _blackoutDatesIndex.contains(i);
      if (isBlackoutDate) {
        textStyle = blackoutDatesStyle ??
            textStyle.copyWith(decoration: TextDecoration.lineThrough);
      }

      final TextSpan span = TextSpan(
        text: currentVisibleDate.day.toString(),
        style: textStyle,
      );

      _textPainter.text = span;

      _textPainter.layout(minWidth: 0, maxWidth: cellWidth);

      //// In web when the mouse hovering the cell, the painter style set as stroke,
      //// hence if background color set for an cell and mouse hovered for the
      //// cell before it will change the background color from fill to stroke
      //// for the cells after it, hence to fill the background color we have set
      //// the style s fill.
      _linePainter.style = PaintingStyle.fill;
      canvas.drawRect(
          Rect.fromLTWH(
              xPosition, yPosition - viewPadding, cellWidth, cellHeight),
          _linePainter);

      if (calendarCellNotifier.value != null && !isBlackoutDate) {
        _addMouseHovering(canvas, size, cellWidth, cellHeight, xPosition,
            yPosition - viewPadding);
      }

      if (isCurrentDate) {
        _linePainter ??= Paint();
        _linePainter.style = PaintingStyle.fill;
        _linePainter.color = todayHighlightColor;
        _linePainter.isAntiAlias = true;

        final double textHeight = _textPainter.height / 2;
        canvas.drawCircle(
            Offset(xPosition + cellWidth / 2,
                yPosition + circlePadding + textHeight),
            textHeight + viewPadding,
            _linePainter);
      }

      _textPainter.paint(
          canvas,
          Offset(xPosition + (cellWidth / 2 - _textPainter.width / 2),
              yPosition + circlePadding));
      if (isRTL) {
        if (xPosition.round() == cellWidth.round()) {
          xPosition = 0;
        } else {
          xPosition -= cellWidth;
        }
        if (xPosition < 0) {
          xPosition = size.width - cellWidth;
          yPosition += cellHeight;
        }
      } else {
        xPosition += cellWidth;
        if (xPosition.round() >= size.width.round()) {
          xPosition = 0;
          yPosition += cellHeight;
        }
      }
    }

    _drawVerticalAndHorizontalLines(
        canvas, size, yPosition, xPosition, cellHeight, cellWidth);
  }

  void _addMouseHovering(Canvas canvas, Size size, double cellWidth,
      double cellHeight, double xPosition, double yPosition) {
    if (xPosition <= calendarCellNotifier.value.dx &&
        xPosition + cellWidth >= calendarCellNotifier.value.dx &&
        yPosition <= calendarCellNotifier.value.dy &&
        yPosition + cellHeight >= calendarCellNotifier.value.dy) {
      _linePainter = _linePainter ?? Paint();
      _linePainter.style = PaintingStyle.stroke;
      _linePainter.strokeWidth = 2;
      _linePainter.color = calendarTheme.selectionBorderColor.withOpacity(0.4);
      canvas.drawRect(
          Rect.fromLTWH(
              xPosition == 0 ? xPosition + linePadding : xPosition,
              yPosition,
              (xPosition + cellWidth).round() >= size.width
                  ? cellWidth - linePadding - 1
                  : cellWidth - 1,
              (yPosition + cellHeight).round() >= size.height.round()
                  ? cellHeight - 1 - linePadding
                  : cellHeight - 1),
          _linePainter);
    }
  }

  void _drawVerticalAndHorizontalLines(Canvas canvas, Size size,
      double yPosition, double xPosition, double cellHeight, double cellWidth) {
    yPosition = cellHeight;
    _linePainter.strokeWidth = linePadding;
    _linePainter.color = cellBorderColor ?? calendarTheme.cellBorderColor;
    canvas.drawLine(const Offset(0, linePadding),
        Offset(size.width, linePadding), _linePainter);
    for (int i = 0; i < rowCount - 1; i++) {
      canvas.drawLine(
          Offset(0, yPosition), Offset(size.width, yPosition), _linePainter);
      yPosition += cellHeight;
    }

    canvas.drawLine(Offset(0, size.height - linePadding),
        Offset(size.width, size.height - linePadding), _linePainter);
    xPosition = cellWidth;
    canvas.drawLine(const Offset(linePadding, 0),
        Offset(linePadding, size.height), _linePainter);
    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
          Offset(xPosition, 0), Offset(xPosition, size.height), _linePainter);
      xPosition += cellWidth;
    }
  }

  String _getAccessibilityText(DateTime date, int index) {
    final String accessibilityText =
        DateFormat('EEE, dd/MMMM/yyyy').format(date).toString();
    if (_blackoutDatesIndex != null && _blackoutDatesIndex.contains(index)) {
      return accessibilityText + ', Blackout date';
    }

    if (!isDateWithInDateRange(minDate, maxDate, date)) {
      return accessibilityText + ', Disabled date';
    }

    return accessibilityText;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    double left = 0, top = 0;
    final double cellWidth = size.width / _kNumberOfDaysInWeek;
    final double cellHeight = size.height / rowCount;
    final bool showTrailingLeadingDates = _isLeadingAndTrailingDatesVisible(
        rowCount, showTrailingAndLeadingDates);
    final int currentMonth = visibleDates[visibleDates.length ~/ 2].month;
    for (int i = 0; i < visibleDates.length; i++) {
      final DateTime currentVisibleDate = visibleDates[i];
      if (showTrailingLeadingDates ||
          currentMonth == currentVisibleDate.month) {
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(isRTL ? size.width - left - cellWidth : left, top,
              cellWidth, cellHeight),
          properties: SemanticsProperties(
            label: _getAccessibilityText(currentVisibleDate, i),
            textDirection: TextDirection.ltr,
          ),
        ));
      }

      left += cellWidth;
      if (left + 1 >= size.width) {
        top += cellHeight;
        left = 0;
      }
    }

    return semanticsBuilder;
  }

  @override
  List<CustomPainterSemantics> Function(Size size) get semanticsBuilder =>
      _getSemanticsBuilder;
}
