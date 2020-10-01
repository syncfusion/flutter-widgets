part of calendar;

class _TimeSlotView extends CustomPainter {
  _TimeSlotView(
      this.visibleDates,
      this.horizontalLinesCount,
      this.timeIntervalHeight,
      this.timeLabelWidth,
      this.cellBorderColor,
      this.calendarTheme,
      this.timeSlotViewSettings,
      this.isRTL,
      this.specialRegion,
      this.calendarCellNotifier,
      this.textScaleFactor)
      : super(repaint: calendarCellNotifier);

  final List<DateTime> visibleDates;
  final double horizontalLinesCount;
  final double timeIntervalHeight;
  final double timeLabelWidth;
  final Color cellBorderColor;
  final SfCalendarThemeData calendarTheme;
  final TimeSlotViewSettings timeSlotViewSettings;
  final bool isRTL;
  final ValueNotifier<Offset> calendarCellNotifier;
  final List<TimeRegion> specialRegion;
  final double textScaleFactor;
  double _cellWidth;
  Paint _linePainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final double width = size.width - timeLabelWidth;
    _cellWidth = width / visibleDates.length;
    _linePainter = _linePainter ?? Paint();

    if (specialRegion != null) {
      _addSpecialRegions(canvas, size);
    }

    double x, y;
    y = timeIntervalHeight;
    _linePainter.style = PaintingStyle.stroke;
    _linePainter.strokeWidth = 0.5;
    _linePainter.strokeCap = StrokeCap.round;
    _linePainter.color = cellBorderColor ?? calendarTheme.cellBorderColor;

    for (int i = 1; i <= horizontalLinesCount; i++) {
      final Offset start = Offset(isRTL ? 0 : timeLabelWidth, y);
      final Offset end =
          Offset(isRTL ? size.width - timeLabelWidth : size.width, y);
      canvas.drawLine(start, end, _linePainter);

      y += timeIntervalHeight;
      if (y == size.height) {
        break;
      }
    }

    if (isRTL) {
      x = _cellWidth;
    } else {
      x = timeLabelWidth + _cellWidth;
    }

    for (int i = 0; i < visibleDates.length - 1; i++) {
      final Offset start = Offset(x, 0);
      final Offset end = Offset(x, size.height);
      canvas.drawLine(start, end, _linePainter);
      x += _cellWidth;
    }

    if (calendarCellNotifier.value != null) {
      _addMouseHoveringForTimeSlot(canvas, size);
    }
  }

  void _addMouseHoveringForTimeSlot(Canvas canvas, Size size) {
    final double padding = 0.5;
    double left = (calendarCellNotifier.value.dx ~/ _cellWidth) * _cellWidth;
    double top = (calendarCellNotifier.value.dy ~/ timeIntervalHeight) *
        timeIntervalHeight;
    _linePainter.style = PaintingStyle.stroke;
    _linePainter.strokeWidth = 2;
    _linePainter.color = calendarTheme.selectionBorderColor.withOpacity(0.4);
    left += (isRTL ? 0 : timeLabelWidth);
    top = top == 0 ? top + padding : top;
    double height = timeIntervalHeight;
    if (top == padding) {
      height -= padding;
    }

    canvas.drawRect(
        Rect.fromLTWH(
            left,
            top,
            left + _cellWidth == size.width ? _cellWidth - padding : _cellWidth,
            top + height == size.height ? height - padding : height),
        _linePainter);
  }

  void _addSpecialRegions(Canvas canvas, Size size) {
    final double minuteHeight =
        timeIntervalHeight / _getTimeInterval(timeSlotViewSettings);
    final DateTime startDate = _convertToStartTime(visibleDates[0]);
    final DateTime endDate =
        _convertToEndTime(visibleDates[visibleDates.length - 1]);
    final TextPainter painter = TextPainter(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        textScaleFactor: textScaleFactor,
        textWidthBasis: TextWidthBasis.longestLine);

    _linePainter.style = PaintingStyle.fill;
    for (int i = 0; i < specialRegion.length; i++) {
      final TimeRegion region = specialRegion[i];
      _linePainter.color = region.color ?? Colors.grey.withOpacity(0.2);
      final DateTime regionStartTime = region._actualStartTime;
      final DateTime regionEndTime = region._actualEndTime;

      /// Check the start date and end date as same.
      if (_isSameTimeSlot(regionStartTime, regionEndTime)) {
        continue;
      }

      /// Check the visible regions holds the region or not
      if (!((regionStartTime.isAfter(startDate) &&
                  regionStartTime.isBefore(endDate)) ||
              (regionEndTime.isAfter(startDate) &&
                  regionEndTime.isBefore(endDate))) &&
          !(regionStartTime.isBefore(startDate) &&
              regionEndTime.isAfter(endDate))) {
        continue;
      }

      int startIndex = _getVisibleDateIndex(visibleDates, regionStartTime);
      int endIndex = _getVisibleDateIndex(visibleDates, regionEndTime);

      double startYPosition = _getTimeToPosition(
          Duration(
              hours: regionStartTime.hour, minutes: regionStartTime.minute),
          timeSlotViewSettings,
          minuteHeight);
      if (startIndex == -1) {
        if (startDate.isAfter(regionStartTime)) {
          // Set index as 0 when the region start date before the visible
          // start date
          startIndex = 0;
        } else {
          /// Find the next index when the start date as non working date.
          for (int k = 1; k < visibleDates.length; k++) {
            final DateTime currentDate = visibleDates[k];
            if (currentDate.isBefore(regionStartTime)) {
              continue;
            }

            startIndex = k;
            break;
          }

          if (startIndex == -1) {
            startIndex = 0;
          }
        }

        /// Start date as non working day and its index as next date index.
        /// so assign the position value as 0
        startYPosition = 0;
      }

      double endYPosition = _getTimeToPosition(
          Duration(hours: regionEndTime.hour, minutes: regionEndTime.minute),
          timeSlotViewSettings,
          minuteHeight);
      if (endIndex == -1) {
        /// Find the previous index when the end date as non working date.
        if (endDate.isAfter(regionEndTime)) {
          for (int k = visibleDates.length - 2; k >= 0; k--) {
            final DateTime currentDate = visibleDates[k];
            if (currentDate.isAfter(regionEndTime)) {
              continue;
            }

            endIndex = k;
            break;
          }

          if (endIndex == -1) {
            endIndex = visibleDates.length - 1;
          }
        } else {
          /// Set index as visible date end date index when the
          /// region end date before the visible end date
          endIndex = visibleDates.length - 1;
        }

        /// End date as non working day and its index as previous date index.
        /// so assign the position value as view height
        endYPosition = size.height;
      }

      final TextStyle textStyle = region.textStyle ??
          TextStyle(
              color: calendarTheme.brightness != null &&
                      calendarTheme.brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.black45);
      for (int j = startIndex; j <= endIndex; j++) {
        final double startPosition = j == startIndex ? startYPosition : 0;
        final double endPosition = j == endIndex ? endYPosition : size.height;

        /// Check the start and end position not between the visible hours
        /// position(not between start and end hour)
        if ((startPosition <= 0 && endPosition <= 0) ||
            (startPosition >= size.height && endPosition >= size.height) ||
            (startPosition == endPosition)) {
          continue;
        }

        double startXPosition = timeLabelWidth + (j * _cellWidth);
        if (isRTL) {
          startXPosition = size.width - (startXPosition + _cellWidth);
        }

        final Rect rect = Rect.fromLTRB(startXPosition, startPosition,
            startXPosition + _cellWidth, endPosition);
        canvas.drawRect(rect, _linePainter);
        if ((region.text == null || region.text.isEmpty) &&
            region.iconData == null) {
          continue;
        }

        painter.textDirection = TextDirection.ltr;
        painter.textAlign = isRTL ? TextAlign.right : TextAlign.left;
        if (region.iconData == null) {
          painter.text = TextSpan(text: region.text, style: textStyle);
          painter.ellipsis = '..';
        } else {
          painter.text = TextSpan(
              text: String.fromCharCode(region.iconData.codePoint),
              style:
                  textStyle.copyWith(fontFamily: region.iconData.fontFamily));
        }

        painter.layout(minWidth: 0, maxWidth: rect.width - 4);
        painter.paint(canvas, Offset(rect.left + 3, rect.top + 3));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimeSlotView oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.timeIntervalHeight != timeIntervalHeight ||
        oldWidget.timeLabelWidth != timeLabelWidth ||
        oldWidget.cellBorderColor != cellBorderColor ||
        oldWidget.horizontalLinesCount != horizontalLinesCount ||
        oldWidget.calendarTheme != calendarTheme ||
        oldWidget.specialRegion != specialRegion ||
        oldWidget.textScaleFactor != textScaleFactor ||
        oldWidget.isRTL != isRTL;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    double left, top;
    top = 0;
    final double cellWidth =
        (size.width - timeLabelWidth) / visibleDates.length;
    left = isRTL ? (size.width - timeLabelWidth) - cellWidth : timeLabelWidth;
    final double cellHeight = timeIntervalHeight;
    final double hour = (timeSlotViewSettings.startHour -
            timeSlotViewSettings.startHour.toInt()) *
        60;
    for (int j = 0; j < visibleDates.length; j++) {
      DateTime date = visibleDates[j];
      for (int i = 0; i < horizontalLinesCount; i++) {
        final double minute =
            (i * _getTimeInterval(timeSlotViewSettings)) + hour;
        date = DateTime(date.year, date.month, date.day,
            timeSlotViewSettings.startHour.toInt(), minute.toInt());
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(left, top, cellWidth, cellHeight),
          properties: SemanticsProperties(
            label: DateFormat('h a, dd/MMMM/yyyy').format(date).toString(),
            textDirection: TextDirection.ltr,
          ),
        ));
        top += cellHeight;
      }

      if (isRTL) {
        if (left.round() == cellWidth.round()) {
          left = 0;
        } else {
          left -= cellWidth;
        }
        top = 0;
        if (left < 0) {
          left = (size.width - timeLabelWidth) - cellWidth;
        }
      } else {
        left += cellWidth;
        top = 0;
        if (left.round() == size.width.round()) {
          left = timeLabelWidth;
        }
      }
    }

    return semanticsBuilder;
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
    final _TimeSlotView oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates;
  }
}
