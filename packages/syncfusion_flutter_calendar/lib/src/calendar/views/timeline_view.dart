part of calendar;

class _TimelineView extends CustomPainter {
  _TimelineView(
      this.horizontalLinesCountPerView,
      this.visibleDates,
      this.timeSlotViewSettings,
      this.timeIntervalHeight,
      this.cellBorderColor,
      this.isRTL,
      this.locale,
      this.calendarTheme,
      this.calendarCellNotifier,
      this.scrollController,
      this.specialRegion,
      this.resourceItemHeight,
      this.resourceCollection,
      this.textScaleFactor)
      : super(repaint: calendarCellNotifier);

  final double horizontalLinesCountPerView;
  final List<DateTime> visibleDates;
  final TimeSlotViewSettings timeSlotViewSettings;
  final double timeIntervalHeight;
  final Color cellBorderColor;
  final SfCalendarThemeData calendarTheme;
  final String locale;
  final bool isRTL;
  final ValueNotifier<Offset> calendarCellNotifier;
  final ScrollController scrollController;
  final List<TimeRegion> specialRegion;
  final double resourceItemHeight;
  final List<CalendarResource> resourceCollection;
  final double textScaleFactor;
  double _x1, _x2, _y1, _y2;
  Paint _linePainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final bool isResourceEnabled =
        resourceCollection != null && resourceCollection.isNotEmpty;
    _x1 = 0;
    _x2 = size.width;
    _y1 = timeIntervalHeight;
    _y2 = timeIntervalHeight;
    _linePainter = _linePainter ?? Paint();
    if (specialRegion != null) {
      _addSpecialRegion(canvas, size, isResourceEnabled);
    }

    _linePainter.strokeWidth = 0.5;
    _linePainter.strokeCap = StrokeCap.round;
    _linePainter.color = cellBorderColor ?? calendarTheme.cellBorderColor;
    _x1 = 0;
    _x2 = size.width;
    _y1 = 0.5;
    _y2 = 0.5;

    final Offset start = Offset(_x1, _y1);
    final Offset end = Offset(_x2, _y2);
    canvas.drawLine(start, end, _linePainter);

    _x1 = 0;
    _x2 = 0;
    _y2 = size.height;
    if (isRTL) {
      _x1 = size.width;
      _x2 = size.width;
    }
    final List<Offset> points = <Offset>[];
    for (int i = 0;
        i < horizontalLinesCountPerView * visibleDates.length;
        i++) {
      _y1 = 0;
      if (kIsWeb) {
        canvas.drawLine(Offset(_x1, _y1), Offset(_x2, _y2), _linePainter);
      } else {
        points.add(Offset(_x1, _y1));
        points.add(Offset(_x2, _y2));
      }

      if (isRTL) {
        _x1 -= timeIntervalHeight;
        _x2 -= timeIntervalHeight;
      } else {
        _x1 += timeIntervalHeight;
        _x2 += timeIntervalHeight;
      }
    }

    if (!kIsWeb) {
      canvas.drawPoints(PointMode.lines, points, _linePainter);
    }

    /// Draws the vertical line to separate the slots based on resource count.
    if (isResourceEnabled) {
      _x1 = 0;
      _x2 = size.width;
      _y1 = resourceItemHeight;
      for (int i = 0; i < resourceCollection.length; i++) {
        canvas.drawLine(Offset(_x1, _y1), Offset(_x2, _y1), _linePainter);
        _y1 += resourceItemHeight;
      }
    }

    if (calendarCellNotifier.value != null) {
      _addMouseHovering(canvas, size, isResourceEnabled);
    }
  }

  void _addMouseHovering(Canvas canvas, Size size, bool isResourceEnabled) {
    double left = (calendarCellNotifier.value.dx ~/ timeIntervalHeight) *
        timeIntervalHeight;
    double top = 0;
    double height = size.height;
    if (isResourceEnabled) {
      final int index =
          (calendarCellNotifier.value.dy / resourceItemHeight).truncate();
      top = index * resourceItemHeight;
      height = resourceItemHeight;
    }
    const double padding = 0.5;
    top = top == 0 ? padding : top;
    height = height == size.height
        ? top == padding
            ? height - (padding * 2)
            : height - padding
        : height;
    double width = timeIntervalHeight;
    double difference = 0;
    if (isRTL &&
        (size.width - scrollController.offset) <
            scrollController.position.viewportDimension) {
      difference = scrollController.position.viewportDimension - size.width;
    }

    if ((size.width - scrollController.offset) <
            scrollController.position.viewportDimension &&
        (left + timeIntervalHeight).round() == size.width.round()) {
      width -= padding;
    }

    _linePainter.style = PaintingStyle.stroke;
    _linePainter.strokeWidth = 2;
    _linePainter.color = calendarTheme.selectionBorderColor.withOpacity(0.4);
    left = left == 0 ? left - difference + padding : left - difference;
    canvas.drawRect(Rect.fromLTWH(left, top, width, height), _linePainter);
  }

  /// Calculate the position for special regions and draw the special regions
  /// in the timeline views .
  void _addSpecialRegion(Canvas canvas, Size size, bool isResourceEnabled) {
    /// Condition added to check and add the special region for timeline day,
    /// timeline week and timeline work week view only, since the special region
    /// support not applicable for timeline month view.
    if (visibleDates.length > _kNumberOfDaysInWeek) {
      return;
    }

    final double minuteHeight =
        timeIntervalHeight / _getTimeInterval(timeSlotViewSettings);
    final DateTime startDate = _convertToStartTime(visibleDates[0]);
    final DateTime endDate =
        _convertToEndTime(visibleDates[visibleDates.length - 1]);
    _linePainter.style = PaintingStyle.fill;
    final double viewWidth = size.width / visibleDates.length;
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

      double startXPosition = _getTimeToPosition(
          Duration(
              hours: regionStartTime.hour, minutes: regionStartTime.minute),
          timeSlotViewSettings,
          minuteHeight);
      if (startIndex == -1) {
        if (startDate.isAfter(regionStartTime)) {
          /// Set index as 0 when the region start date before the visible
          /// start date
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
        startXPosition = 0;
      }

      double endXPosition = _getTimeToPosition(
          Duration(hours: regionEndTime.hour, minutes: regionEndTime.minute),
          timeSlotViewSettings,
          minuteHeight);
      if (endIndex == -1) {
        /// Find the previous index when the end date as non working date.
        if (endDate.isAfter(regionEndTime)) {
          for (int k = visibleDates.length - 2; k >= 0; k--) {
            final DateTime _currentDate = visibleDates[k];
            if (_currentDate.isAfter(regionEndTime)) {
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
        /// so assign the position value as view width
        endXPosition = viewWidth;
      }

      double startPosition = (startIndex * viewWidth) + startXPosition;
      double endPosition = (endIndex * viewWidth) + endXPosition;

      /// Check the start and end position not between the visible hours
      /// position(not between start and end hour)
      if ((startPosition <= 0 && endPosition <= 0) ||
          (startPosition >= size.width && endPosition >= size.width) ||
          (startPosition == endPosition)) {
        continue;
      }

      if (isRTL) {
        startPosition = size.width - startPosition;
        endPosition = size.width - endPosition;
      }

      double topPosition = 0;
      double bottomPosition = size.height;
      if (isResourceEnabled &&
          region.resourceIds != null &&
          region.resourceIds.isNotEmpty) {
        for (int i = 0; i < region.resourceIds.length; i++) {
          final int index =
              _getResourceIndex(resourceCollection, region.resourceIds[i]);
          topPosition = index * resourceItemHeight;
          bottomPosition = topPosition + resourceItemHeight;
          _drawSpecialRegion(canvas, size, bottomPosition, endPosition,
              startPosition, topPosition, region);
        }
      } else {
        _drawSpecialRegion(canvas, size, bottomPosition, endPosition,
            startPosition, topPosition, region);
      }
    }
  }

  /// Draw the special region  based on the calculated positions.
  void _drawSpecialRegion(
      Canvas canvas,
      Size size,
      double bottomPosition,
      double endPosition,
      double startPosition,
      double topPosition,
      TimeRegion region) {
    final TextPainter painter = TextPainter(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textScaleFactor: textScaleFactor,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        textWidthBasis: TextWidthBasis.longestLine);
    Rect rect;
    if (isRTL) {
      rect = Rect.fromLTRB(
          endPosition, topPosition, startPosition, bottomPosition);
    } else {
      rect = Rect.fromLTRB(
          startPosition, topPosition, endPosition, bottomPosition);
    }
    canvas.drawRect(rect, _linePainter);
    if ((region.text == null || region.text.isEmpty) &&
        region.iconData == null) {
      return;
    }

    final TextStyle textStyle = region.textStyle ??
        TextStyle(
            color: calendarTheme.brightness != null &&
                    calendarTheme.brightness == Brightness.dark
                ? Colors.white54
                : Colors.black45);
    painter.textDirection = TextDirection.ltr;
    painter.textAlign = isRTL ? TextAlign.right : TextAlign.left;
    if (region.iconData == null) {
      painter.text = TextSpan(text: region.text, style: textStyle);
      painter.ellipsis = '..';
    } else {
      painter.text = TextSpan(
          text: String.fromCharCode(region.iconData.codePoint),
          style: textStyle.copyWith(fontFamily: region.iconData.fontFamily));
    }

    painter.layout(minWidth: 0, maxWidth: rect.width - 4);
    painter.paint(canvas, Offset(rect.left + 3, rect.top + 3));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimelineView oldWidget = oldDelegate;
    return oldWidget.horizontalLinesCountPerView !=
            horizontalLinesCountPerView ||
        oldWidget.visibleDates != visibleDates ||
        oldWidget.cellBorderColor != cellBorderColor ||
        oldWidget.calendarTheme != calendarTheme ||
        oldWidget.timeSlotViewSettings != timeSlotViewSettings ||
        oldWidget.isRTL != isRTL ||
        oldWidget.locale != locale ||
        oldWidget.calendarCellNotifier.value != calendarCellNotifier.value ||
        oldWidget.resourceItemHeight != resourceItemHeight ||
        oldWidget.resourceCollection != resourceCollection ||
        oldWidget.textScaleFactor != textScaleFactor ||
        oldWidget.specialRegion != specialRegion;
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

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    List<CustomPainterSemantics> semanticsBuilder = <CustomPainterSemantics>[];
    final bool isResourceEnabled =
        resourceCollection != null && resourceCollection.isNotEmpty;
    final double height = isResourceEnabled ? resourceItemHeight : size.height;
    double top = 0;
    if (isResourceEnabled) {
      for (int i = 0; i < resourceCollection.length; i++) {
        semanticsBuilder = _getAccessibilityDates(
            size, top, height, semanticsBuilder, resourceCollection[i]);
        top += height;
      }
    } else {
      semanticsBuilder =
          _getAccessibilityDates(size, top, height, semanticsBuilder);
    }

    return semanticsBuilder;
  }

  /// Returns the custom painter semantics for visible dates collection.
  List<CustomPainterSemantics> _getAccessibilityDates(Size size, double top,
      double height, List<CustomPainterSemantics> semanticsBuilder,
      [CalendarResource resource]) {
    double left = isRTL ? size.width - timeIntervalHeight : 0;
    for (int j = 0; j < visibleDates.length; j++) {
      DateTime date = visibleDates[j];
      final double hour = (timeSlotViewSettings.startHour -
              timeSlotViewSettings.startHour.toInt()) *
          60;
      for (int i = 0; i < horizontalLinesCountPerView; i++) {
        final double minute =
            (i * _getTimeInterval(timeSlotViewSettings)) + hour;
        date = DateTime(date.year, date.month, date.day,
            timeSlotViewSettings.startHour.toInt(), minute.toInt());
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(left, top, timeIntervalHeight, height),
          properties: SemanticsProperties(
            label: _getAccessibilityText(date, resource),
            textDirection: TextDirection.ltr,
          ),
        ));
        if (isRTL) {
          left -= timeIntervalHeight;
        } else {
          left += timeIntervalHeight;
        }
      }
    }

    return semanticsBuilder;
  }

  String _getAccessibilityText(DateTime date, [CalendarResource resource]) {
    String dateText;
    if (visibleDates.length > _kNumberOfDaysInWeek) {
      dateText = DateFormat('EEEEE, dd\MMMM\yyyy').format(date).toString();
    }
    dateText = DateFormat('h a, dd/MMMM/yyyy').format(date).toString();

    if (resource != null) {
      dateText = dateText + resource.displayName;
    }

    return dateText;
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _TimelineView oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates;
  }
}

class _TimelineViewHeaderView extends CustomPainter {
  _TimelineViewHeaderView(
      this.visibleDates,
      this.timelineViewHeaderScrollController,
      this.repaintNotifier,
      this.viewHeaderStyle,
      this.timeSlotViewSettings,
      this.viewHeaderHeight,
      this.isRTL,
      this.todayHighlightColor,
      this.todayTextStyle,
      this.locale,
      this.calendarTheme,
      this.minDate,
      this.maxDate,
      this.viewHeaderNotifier,
      this.cellBorderColor,
      this.blackoutDates,
      this.blackoutDatesTextStyle,
      this.textScaleFactor)
      : super(repaint: repaintNotifier);

  final List<DateTime> visibleDates;
  final ViewHeaderStyle viewHeaderStyle;
  final TimeSlotViewSettings timeSlotViewSettings;
  final double viewHeaderHeight;
  final Color todayHighlightColor;
  final TextStyle todayTextStyle;
  final double _padding = 5;
  final ValueNotifier<bool> repaintNotifier;
  final ScrollController timelineViewHeaderScrollController;
  final SfCalendarThemeData calendarTheme;
  final bool isRTL;
  final String locale;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueNotifier<Offset> viewHeaderNotifier;
  final Color cellBorderColor;
  final List<DateTime> blackoutDates;
  final TextStyle blackoutDatesTextStyle;
  final double textScaleFactor;
  double _xPosition = 0;
  TextPainter dayTextPainter, dateTextPainter;
  Paint _hoverPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final bool isTimelineMonth = visibleDates.length > _kNumberOfDaysInWeek;
    final DateTime today = DateTime.now();
    final double childWidth = size.width / visibleDates.length;
    final int index = isTimelineMonth
        ? 0
        : timelineViewHeaderScrollController.offset ~/ childWidth;
    _xPosition = !isTimelineMonth
        ? timelineViewHeaderScrollController.offset
        : isRTL
            ? size.width - childWidth
            : _xPosition;

    TextStyle viewHeaderDayTextStyle =
        calendarTheme.brightness == Brightness.light
            ? TextStyle(
                color: Colors.black87,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto')
            : TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto');
    TextStyle viewHeaderDateTextStyle =
        calendarTheme.brightness == Brightness.light
            ? const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto')
            : TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto');

    if (viewHeaderDateTextStyle == calendarTheme.viewHeaderDateTextStyle &&
        isTimelineMonth) {
      viewHeaderDateTextStyle = viewHeaderDateTextStyle.copyWith(
          fontSize: viewHeaderDayTextStyle.fontSize);
    }
    final TextStyle viewHeaderDateStyle =
        viewHeaderStyle.dateTextStyle ?? viewHeaderDateTextStyle;
    if (viewHeaderDayTextStyle == calendarTheme.viewHeaderDayTextStyle &&
        !isTimelineMonth) {
      viewHeaderDayTextStyle = viewHeaderDayTextStyle.copyWith(
          fontSize: viewHeaderDateStyle.fontSize);
    }

    final TextStyle viewHeaderDayStyle =
        viewHeaderStyle.dayTextStyle ?? viewHeaderDayTextStyle;

    final TextStyle blackoutDatesStyle =
        blackoutDatesTextStyle ?? calendarTheme.blackoutDatesTextStyle;

    TextStyle dayTextStyle = viewHeaderDayStyle;
    TextStyle dateTextStyle = viewHeaderDateStyle;

    if (isTimelineMonth) {
      _hoverPainter ??= Paint();
      _hoverPainter.strokeWidth = 0.5;
      _hoverPainter.strokeCap = StrokeCap.round;
      _hoverPainter.color = cellBorderColor ?? calendarTheme.cellBorderColor;
      canvas.drawLine(Offset(0, 0), Offset(size.width, 0), _hoverPainter);
    }

    for (int i = 0; i < visibleDates.length; i++) {
      if (i < index && !isTimelineMonth) {
        continue;
      }

      final DateTime currentDate = visibleDates[i];
      String dayFormat = 'EE';
      dayFormat =
          dayFormat == timeSlotViewSettings.dayFormat && !isTimelineMonth
              ? 'EEEE'
              : timeSlotViewSettings.dayFormat;

      final String dayText =
          DateFormat(dayFormat, locale).format(currentDate).toString();
      final String dateText = DateFormat(timeSlotViewSettings.dateFormat)
          .format(currentDate)
          .toString();

      final bool isBlackoutDate =
          _isDateInDateCollection(blackoutDates, currentDate);

      if (isSameDate(currentDate, today)) {
        dayTextStyle = todayTextStyle != null
            ? todayTextStyle.copyWith(
                fontSize: viewHeaderDayStyle.fontSize,
                color: todayHighlightColor)
            : viewHeaderDayStyle.copyWith(color: todayHighlightColor);
        dateTextStyle = todayTextStyle != null
            ? todayTextStyle.copyWith(
                fontSize: viewHeaderDateStyle.fontSize,
                color: todayHighlightColor)
            : viewHeaderDateStyle.copyWith(color: todayHighlightColor);
      } else {
        dateTextStyle = viewHeaderDateStyle;
        dayTextStyle = viewHeaderDayStyle;
      }

      if (isTimelineMonth && isBlackoutDate) {
        dateTextStyle = blackoutDatesStyle ??
            dateTextStyle.copyWith(decoration: TextDecoration.lineThrough);
        dayTextStyle = blackoutDatesStyle ??
            dayTextStyle.copyWith(decoration: TextDecoration.lineThrough);
      }

      if (!isDateWithInDateRange(minDate, maxDate, currentDate)) {
        if (calendarTheme.brightness == Brightness.light) {
          dayTextStyle = dayTextStyle.copyWith(color: Colors.black26);
          dateTextStyle = dateTextStyle.copyWith(color: Colors.black26);
        } else {
          dayTextStyle = dayTextStyle.copyWith(color: Colors.white38);
          dateTextStyle = dateTextStyle.copyWith(color: Colors.white38);
        }
      }

      final TextSpan dayTextSpan = TextSpan(text: dayText, style: dayTextStyle);

      dayTextPainter = dayTextPainter ?? TextPainter();
      dayTextPainter.text = dayTextSpan;
      dayTextPainter.textDirection = TextDirection.ltr;
      dayTextPainter.textAlign = TextAlign.left;
      dayTextPainter.textWidthBasis = TextWidthBasis.longestLine;
      dayTextPainter.textScaleFactor = textScaleFactor;

      final TextSpan dateTextSpan =
          TextSpan(text: dateText, style: dateTextStyle);

      dateTextPainter = dateTextPainter ?? TextPainter();
      dateTextPainter.text = dateTextSpan;
      dateTextPainter.textDirection = TextDirection.ltr;
      dateTextPainter.textAlign = TextAlign.left;
      dateTextPainter.textWidthBasis = TextWidthBasis.longestLine;
      dateTextPainter.textScaleFactor = textScaleFactor;

      dayTextPainter.layout(minWidth: 0, maxWidth: childWidth);
      dateTextPainter.layout(minWidth: 0, maxWidth: childWidth);
      if (isTimelineMonth) {
        _drawTimelineMonthViewHeader(canvas, childWidth, size, isBlackoutDate);
      } else {
        _drawTimelineTimeSlotsViewHeader(canvas, size, childWidth, index, i);
      }
    }
  }

  void _drawTimelineTimeSlotsViewHeader(
      Canvas canvas, Size size, double childWidth, int index, int i) {
    if (dateTextPainter.width +
            _xPosition +
            (_padding * 2) +
            dayTextPainter.width >
        (i + 1) * childWidth) {
      _xPosition = ((i + 1) * childWidth) -
          (dateTextPainter.width + (_padding * 2) + dayTextPainter.width);
    }

    if (viewHeaderNotifier.value != null) {
      _addMouseHovering(canvas, size);
    }

    if (isRTL) {
      dateTextPainter.paint(
          canvas,
          Offset(
              size.width -
                  _xPosition -
                  (_padding * 2) -
                  dayTextPainter.width -
                  dateTextPainter.width,
              viewHeaderHeight / 2 - dateTextPainter.height / 2));
      dayTextPainter.paint(
          canvas,
          Offset(size.width - _xPosition - _padding - dayTextPainter.width,
              viewHeaderHeight / 2 - dayTextPainter.height / 2));
    } else {
      dateTextPainter.paint(
          canvas,
          Offset(_padding + _xPosition,
              viewHeaderHeight / 2 - dateTextPainter.height / 2));
      dayTextPainter.paint(
          canvas,
          Offset(dateTextPainter.width + _xPosition + (_padding * 2),
              viewHeaderHeight / 2 - dayTextPainter.height / 2));
    }

    if (index == i) {
      _xPosition = (i + 1) * childWidth;
    } else {
      _xPosition += childWidth;
    }
  }

  void _drawTimelineMonthViewHeader(
      Canvas canvas, double childWidth, Size size, bool isBlackoutDate) {
    const double leftPadding = 2;
    final double startXPosition = _xPosition +
        (childWidth -
                (dateTextPainter.width + leftPadding + dayTextPainter.width)) /
            2;
    final double startYPosition = (size.height -
            (dayTextPainter.height > dateTextPainter.height
                ? dayTextPainter.height
                : dateTextPainter.height)) /
        2;
    if (viewHeaderNotifier.value != null && !isBlackoutDate) {
      _addMouseHovering(canvas, size, childWidth);
    }
    dateTextPainter.paint(canvas, Offset(startXPosition, startYPosition));
    dayTextPainter.paint(
        canvas,
        Offset(startXPosition + dateTextPainter.width + leftPadding,
            startYPosition));
    if (isRTL) {
      _xPosition -= childWidth;
    } else {
      _xPosition += childWidth;
    }

    _hoverPainter.color = cellBorderColor ?? calendarTheme.cellBorderColor;
    canvas.drawLine(
        Offset(_xPosition, 0), Offset(_xPosition, size.height), _hoverPainter);
  }

  void _addMouseHovering(Canvas canvas, Size size, [double cellWidth]) {
    _hoverPainter ??= Paint();
    double difference = 0;
    if (isRTL &&
        (size.width - timelineViewHeaderScrollController.offset) <
            timelineViewHeaderScrollController.position.viewportDimension) {
      difference =
          timelineViewHeaderScrollController.position.viewportDimension -
              size.width;
    }
    final double leftPosition = isRTL && cellWidth == null
        ? size.width -
            _xPosition -
            (_padding * 2) -
            dayTextPainter.width -
            dateTextPainter.width -
            _padding
        : _xPosition;
    final double rightPosition = isRTL && cellWidth == null
        ? size.width - _xPosition
        : cellWidth != null
            ? _xPosition + cellWidth - _padding
            : _xPosition +
                dayTextPainter.width +
                dateTextPainter.width +
                (2 * _padding);
    if (leftPosition + difference <= viewHeaderNotifier.value.dx &&
        rightPosition + difference >= viewHeaderNotifier.value.dx &&
        (size.height) - _padding >= viewHeaderNotifier.value.dy) {
      _hoverPainter.color = (calendarTheme.brightness != null &&
                  calendarTheme.brightness == Brightness.dark
              ? Colors.white
              : Colors.black87)
          .withOpacity(0.04);
      canvas.drawRect(
          Rect.fromLTRB(leftPosition, 0, rightPosition + _padding, size.height),
          _hoverPainter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimelineViewHeaderView oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget._xPosition != _xPosition ||
        oldWidget.viewHeaderStyle != viewHeaderStyle ||
        oldWidget.timeSlotViewSettings != timeSlotViewSettings ||
        oldWidget.viewHeaderHeight != viewHeaderHeight ||
        oldWidget.todayHighlightColor != todayHighlightColor ||
        oldWidget.isRTL != isRTL ||
        oldWidget.locale != locale ||
        oldWidget.viewHeaderNotifier.value != viewHeaderNotifier.value ||
        oldWidget.todayTextStyle != todayTextStyle ||
        oldWidget.textScaleFactor != textScaleFactor ||
        !_isDateCollectionEqual(oldWidget.blackoutDates, blackoutDates);
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    final double cellWidth = size.width / visibleDates.length;
    double left = isRTL ? size.width - cellWidth : 0;
    const double top = 0;
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

  String _getAccessibilityText(DateTime date) {
    final String textString = DateFormat('EEEEE').format(date).toString() +
        DateFormat('dd/MMMM/yyyy').format(date).toString();
    if (!isDateWithInDateRange(minDate, maxDate, date)) {
      return textString + ', Disabled date';
    }

    if (_isDateInDateCollection(blackoutDates, date)) {
      return textString + ', Blackout date';
    }

    return textString;
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
    final _TimelineViewHeaderView oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.calendarTheme != calendarTheme;
  }
}
