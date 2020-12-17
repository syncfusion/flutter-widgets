part of calendar;

class _TimeRulerView extends CustomPainter {
  _TimeRulerView(
      this.horizontalLinesCount,
      this.timeIntervalHeight,
      this.timeSlotViewSettings,
      this.cellBorderColor,
      this.isRTL,
      this.locale,
      this.calendarTheme,
      this.isTimelineView,
      this.visibleDates,
      this.textScaleFactor);

  final double horizontalLinesCount;
  final double timeIntervalHeight;
  final TimeSlotViewSettings timeSlotViewSettings;
  final bool isRTL;
  final String locale;
  final SfCalendarThemeData calendarTheme;
  final Color cellBorderColor;
  final bool isTimelineView;
  final List<DateTime> visibleDates;
  final double textScaleFactor;
  Paint _linePainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    const double offset = 0.5;
    double xPosition, yPosition;
    final DateTime date = DateTime.now();
    xPosition = isRTL && isTimelineView ? size.width : 0;
    yPosition = timeIntervalHeight;
    _linePainter = _linePainter ?? Paint();
    _linePainter.strokeWidth = offset;
    _linePainter.color = cellBorderColor ?? calendarTheme.cellBorderColor;

    if (!isTimelineView) {
      final double lineXPosition = isRTL ? offset : size.width - offset;
      // Draw vertical time label line
      canvas.drawLine(Offset(lineXPosition, 0),
          Offset(lineXPosition, size.height), _linePainter);
    }

    _textPainter = _textPainter ?? TextPainter();
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaleFactor = textScaleFactor;

    final TextStyle timeTextStyle =
        timeSlotViewSettings.timeTextStyle ?? calendarTheme.timeTextStyle;

    final double hour = (timeSlotViewSettings.startHour -
            timeSlotViewSettings.startHour.toInt()) *
        60;
    if (isTimelineView) {
      canvas.drawLine(Offset(0, 0), Offset(size.width, 0), _linePainter);
      final double timelineViewWidth =
          timeIntervalHeight * horizontalLinesCount;
      for (int i = 0; i < visibleDates.length; i++) {
        _drawTimeLabels(
            canvas, size, date, hour, xPosition, yPosition, timeTextStyle);
        if (isRTL) {
          xPosition -= timelineViewWidth;
        } else {
          xPosition += timelineViewWidth;
        }
      }
    } else {
      _drawTimeLabels(
          canvas, size, date, hour, xPosition, yPosition, timeTextStyle);
    }
  }

  /// Draws the time labeels in the time label view for timeslot views in
  /// calendar.
  void _drawTimeLabels(Canvas canvas, Size size, DateTime date, double hour,
      double xPosition, double yPosition, TextStyle timeTextStyle) {
    final int padding = 5;

    /// For timeline view we will draw 24 lines where as in day, week and work
    /// week view we will draw 23 lines excluding the 12 AM, hence to rectify
    /// this the i value handled accordingly.
    for (int i = isTimelineView ? 0 : 1;
        i <= (isTimelineView ? horizontalLinesCount - 1 : horizontalLinesCount);
        i++) {
      if (isTimelineView) {
        canvas.save();
        canvas.clipRect(
            Rect.fromLTWH(xPosition, 0, timeIntervalHeight, size.height));
        canvas.restore();
        canvas.drawLine(
            Offset(xPosition, 0), Offset(xPosition, size.height), _linePainter);
      }

      final double minute = (i * _getTimeInterval(timeSlotViewSettings)) + hour;
      date = DateTime(date.day, date.month, date.year,
          timeSlotViewSettings.startHour.toInt(), minute.toInt());
      final String time = DateFormat(timeSlotViewSettings.timeFormat, locale)
          .format(date)
          .toString();
      final TextSpan span = TextSpan(
        text: time,
        style: timeTextStyle,
      );

      final double cellWidth = isTimelineView ? timeIntervalHeight : size.width;

      _textPainter.text = span;
      _textPainter.layout(minWidth: 0, maxWidth: cellWidth);
      if (isTimelineView && _textPainter.height > size.height) {
        return;
      }

      double startXPosition = (cellWidth - _textPainter.width) / 2;
      if (startXPosition < 0) {
        startXPosition = 0;
      }

      if (isTimelineView) {
        startXPosition = isRTL ? xPosition - _textPainter.width : xPosition;
      }

      double startYPosition = yPosition - (_textPainter.height / 2);

      if (isTimelineView) {
        startYPosition = (size.height - _textPainter.height) / 2;
        startXPosition =
            isRTL ? startXPosition - padding : startXPosition + padding;
      }

      _textPainter.paint(canvas, Offset(startXPosition, startYPosition));

      if (!isTimelineView) {
        final Offset start =
            Offset(isRTL ? 0 : size.width - (startXPosition / 2), yPosition);
        final Offset end =
            Offset(isRTL ? startXPosition / 2 : size.width, yPosition);
        canvas.drawLine(start, end, _linePainter);
        yPosition += timeIntervalHeight;
        if (yPosition.round() == size.height.round()) {
          break;
        }
      } else {
        if (isRTL) {
          xPosition -= timeIntervalHeight;
        } else {
          xPosition += timeIntervalHeight;
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimeRulerView oldWidget = oldDelegate;
    return oldWidget.timeSlotViewSettings != timeSlotViewSettings ||
        oldWidget.cellBorderColor != cellBorderColor ||
        oldWidget.calendarTheme != calendarTheme ||
        oldWidget.isRTL != isRTL ||
        oldWidget.locale != locale ||
        oldWidget.visibleDates != visibleDates ||
        oldWidget.isTimelineView != isTimelineView ||
        oldWidget.textScaleFactor != textScaleFactor;
  }
}
