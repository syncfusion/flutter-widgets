part of datepicker;

int _getRtlIndex(int count, int index) {
  return count - index - 1;
}

List<dynamic> _cloneList(List<dynamic> value) {
  if (value == null || value.isEmpty) {
    return null;
  }

  return value.sublist(0);
}

void _drawSelectedDate(
    Canvas canvas,
    double radius,
    double centerXPosition,
    double cellWidth,
    double cellHeight,
    double x,
    double y,
    _IMonthViewPainter view,
    double centerYPosition) {
  view.selectionPainter.isAntiAlias = true;
  view.selectionPainter.color = view.startRangeSelectionColor ??
      view.datePickerTheme.startRangeSelectionColor;
  switch (view.selectionShape) {
    case DateRangePickerSelectionShape.circle:
      {
        _drawCircleSelection(canvas, x + centerXPosition, y + centerYPosition,
            radius, view.selectionPainter);
      }
      break;
    case DateRangePickerSelectionShape.rectangle:
      {
        _drawFillSelection(
            canvas, x, y, cellWidth, cellHeight, view.selectionPainter);
      }
  }
}

void _drawStartAndEndRange(
    Canvas canvas,
    _IMonthViewPainter view,
    double cellHeight,
    double cellWidth,
    double radius,
    double centerXPosition,
    double centerYPosition,
    double x,
    double y,
    Color color,
    double heightDifference,
    bool isStartRange) {
  switch (view.selectionShape) {
    case DateRangePickerSelectionShape.circle:
      {
        Rect rect;
        if (isStartRange) {
          rect = Rect.fromLTRB(x + centerXPosition, y + heightDifference,
              x + cellWidth, y + cellHeight - heightDifference);
        } else {
          rect = Rect.fromLTRB(x, y + heightDifference, x + centerXPosition,
              y + cellHeight - heightDifference);
        }

        _drawStartEndRangeCircleSelection(canvas, x + centerXPosition,
            y + centerYPosition, radius, rect, view.selectionPainter, color);
      }
      break;
    case DateRangePickerSelectionShape.rectangle:
      {
        if (isStartRange) {
          _drawStartRangeFillSelection(
              canvas, x, y, cellWidth, cellHeight, view.selectionPainter);
        } else {
          _drawEndRangeFillSelection(
              canvas, x, y, cellWidth, cellHeight, view.selectionPainter);
        }
      }
  }
}

TextStyle _drawBetweenSelection(
    Canvas canvas,
    _IMonthViewPainter view,
    double cellWidth,
    double cellHeight,
    double radius,
    double x,
    double y,
    double heightDifference,
    TextStyle selectionRangeTextStyle) {
  switch (view.selectionShape) {
    case DateRangePickerSelectionShape.rectangle:
      heightDifference = 1;
      break;
    case DateRangePickerSelectionShape.circle:
      break;
  }

  view.selectionPainter.color =
      view.rangeSelectionColor ?? view.datePickerTheme.rangeSelectionColor;
  _drawRectRangeSelection(canvas, x, y + heightDifference, x + cellWidth,
      y + cellHeight - heightDifference, view.selectionPainter);
  return selectionRangeTextStyle;
}

double _getCellRadius(
    double selectionRadius, double maxXRadius, double maxYRadius) {
  final double radius = maxXRadius > maxYRadius
      ? maxYRadius - _IMonthViewPainter._selectionPadding
      : maxXRadius - _IMonthViewPainter._selectionPadding;

  if (selectionRadius == null) {
    return radius;
  }

  return radius > selectionRadius ? selectionRadius : radius;
}

List<int> _getSelectedRangeIndex(
    DateTime startDate, DateTime endDate, List<DateTime> visibleDates,
    {int monthStartIndex = -1, int monthEndIndex = -1}) {
  int startIndex = -1;
  int endIndex = -1;
  final List<int> selectedIndex = <int>[];
  if (startDate != null && startDate.isAfter(endDate)) {
    final DateTime temp = startDate;
    startDate = endDate;
    endDate = temp;
  }

  final DateTime viewStartDate =
      monthStartIndex != -1 ? visibleDates[monthStartIndex] : visibleDates[0];
  final DateTime viewEndDate = monthEndIndex != -1
      ? visibleDates[monthEndIndex]
      : visibleDates[visibleDates.length - 1];
  if (startDate != null) {
    if (viewStartDate.isAfter(startDate) && viewStartDate.isBefore(endDate)) {
      startIndex = -1;
    } else {
      startIndex = _getSelectedIndex(startDate, visibleDates,
          viewStartIndex: monthStartIndex);
    }
  }

  if (endDate != null) {
    if (viewEndDate.isAfter(startDate) && viewEndDate.isBefore(endDate)) {
      endIndex = visibleDates.length;
    } else {
      endIndex = _getSelectedIndex(endDate, visibleDates,
          viewStartIndex: monthStartIndex);
    }
  }

  //// If some range end date as null then it end index is start index.
  if (startIndex != -1 && endIndex == -1) {
    endIndex = startIndex;
  }

  if (startIndex > endIndex) {
    final int temp = startIndex;
    startIndex = endIndex;
    endIndex = temp;
  }

  for (int i = startIndex; i <= endIndex; i++) {
    selectedIndex.add(i);
  }

  return selectedIndex;
}

int _getSelectedIndex(DateTime date, List<DateTime> visibleDates,
    {int viewStartIndex = 0}) {
  if (viewStartIndex == -1) {
    viewStartIndex = 0;
  }

  for (int i = viewStartIndex; i < visibleDates.length; i++) {
    if (isSameDate(visibleDates[i], date)) {
      return i;
    }
  }

  return -1;
}

void _drawCircleSelection(
    Canvas canvas, double x, double y, double radius, Paint selectionPainter) {
  canvas.drawCircle(Offset(x, y), radius, selectionPainter);
}

void _drawFillSelection(Canvas canvas, double x, double y, double width,
    double height, Paint selectionPainter) {
  const double padding = 1;
  canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTRB(x + padding, y + padding, x + width - padding,
              y + height - padding),
          Radius.circular(height / 4 > 10 ? 10 : height / 4)),
      selectionPainter);
}

void _drawStartRangeFillSelection(Canvas canvas, double x, double y,
    double width, double height, Paint selectionPainter) {
  const double padding = 1;
  final double cornerRadius = height / 4 > 10 ? 10 : height / 4;
  canvas.drawRRect(
      RRect.fromRectAndCorners(
          Rect.fromLTRB(
              x + padding, y + padding, x + width, y + height - padding),
          bottomLeft: Radius.circular(cornerRadius),
          topLeft: Radius.circular(cornerRadius)),
      selectionPainter);
}

void _drawEndRangeFillSelection(Canvas canvas, double x, double y, double width,
    double height, Paint selectionPainter) {
  const double padding = 1;
  final double cornerRadius = height / 4 > 10 ? 10 : height / 4;
  canvas.drawRRect(
      RRect.fromRectAndCorners(
          Rect.fromLTRB(
              x, y + padding, x + width - padding, y + height - padding),
          bottomRight: Radius.circular(cornerRadius),
          topRight: Radius.circular(cornerRadius)),
      selectionPainter);
}

void _drawStartEndRangeCircleSelection(Canvas canvas, double x, double y,
    double radius, Rect rect, Paint selectionPainter, Color color) {
  canvas.drawRect(rect, selectionPainter);
  selectionPainter.isAntiAlias = true;
  selectionPainter.color = color;
  canvas.drawCircle(Offset(x, y), radius, selectionPainter);
}

void _drawRectRangeSelection(Canvas canvas, double left, double top,
    double right, double bottom, Paint selectionPainter) {
  canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), selectionPainter);
}

void _drawMonthCellsAndSelection(Canvas canvas, Size size,
    _IMonthViewPainter monthViewPainter, double cellWidth, double cellHeight) {
  canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
  double xPosition = 0, yPosition;
  final double webUIPadding = monthViewPainter.multiViewSpacing;
  double width = size.width;
  if (monthViewPainter.enableMultiView) {
    width = (width - webUIPadding) / 2;
  }

  monthViewPainter.textPainter ??= TextPainter(
      textDirection: TextDirection.ltr,
      textScaleFactor: monthViewPainter.textScaleFactor,
      textWidthBasis: TextWidthBasis.longestLine);
  TextStyle textStyle = monthViewPainter.cellStyle.textStyle;
  final int datesCount = monthViewPainter.enableMultiView
      ? (monthViewPainter.visibleDates.length ~/ 2)
      : monthViewPainter.visibleDates.length;
  for (int j = 0; j < (monthViewPainter.enableMultiView ? 2 : 1); j++) {
    final int currentViewIndex = monthViewPainter.isRtl
        ? _getRtlIndex(monthViewPainter.enableMultiView ? 2 : 1, j)
        : j;
    final DateTime _currentDate = monthViewPainter
        .visibleDates[((j * datesCount) + (datesCount / 2)).truncate()];
    final int nextMonth = getNextMonthDate(_currentDate).month;
    final int previousMonth = getPreviousMonthDate(_currentDate).month;
    final DateTime today = DateTime.now();
    bool isCurrentDate;
    final TextStyle selectionTextStyle = monthViewPainter.selectionTextStyle ??
        monthViewPainter.datePickerTheme.selectionTextStyle;
    final TextStyle selectedRangeTextStyle = monthViewPainter.rangeTextStyle ??
        monthViewPainter.datePickerTheme.rangeSelectionTextStyle;

    Decoration dateDecoration;
    const double padding = 1;

    final int viewStartIndex = j * datesCount;
    final int viewEndIndex = ((j + 1) * datesCount) - 1;
    final List<int> selectedIndex =
        monthViewPainter._getSelectedIndexValues(viewStartIndex, viewEndIndex);
    final double viewEndPosition =
        ((currentViewIndex + 1) * width) + (currentViewIndex * webUIPadding);
    final double viewStartPosition =
        (currentViewIndex * width) + (currentViewIndex * webUIPadding);
    xPosition = viewStartPosition;
    yPosition = 0;
    for (int i = 0; i < datesCount; i++) {
      int currentIndex = i;
      if (monthViewPainter.isRtl) {
        final int rowIndex = i ~/ _kNumberOfDaysInWeek;
        currentIndex =
            _getRtlIndex(_kNumberOfDaysInWeek, i % _kNumberOfDaysInWeek) +
                (rowIndex * _kNumberOfDaysInWeek);
      }

      isCurrentDate = false;
      currentIndex = (j * datesCount) + currentIndex;
      final DateTime date = monthViewPainter.visibleDates[currentIndex];
      isCurrentDate = isSameDate(date, today);
      final bool isEnableDate = _isEnabledDate(monthViewPainter.minDate,
          monthViewPainter.maxDate, monthViewPainter.enablePastDates, date);
      final bool isBlackedDate = _isDateWithInVisibleDates(
          monthViewPainter.visibleDates, monthViewPainter.blackoutDates, date);
      final bool isWeekEnd = _isWeekend(monthViewPainter.weekendDays, date);
      final bool isSpecialDate = _isDateWithInVisibleDates(
          monthViewPainter.visibleDates, monthViewPainter.specialDates, date);

      /// Check the x position reaches view end position then draw the
      /// date on next cell.
      /// Padding 1 value used to avoid decimal value difference.
      /// eg., if view end position as 243 and x position as 242.499 then
      /// round method in decimal return 242 rather than 243, so it does
      /// not move the next line for draw date value.
      if (xPosition + 1 >= viewEndPosition) {
        xPosition = viewStartPosition;
        yPosition += cellHeight;
      }

      bool isNextMonth = false;
      bool isPreviousMonth = false;
      if (monthViewPainter.rowCount == 6) {
        if (date.month == nextMonth) {
          if (!monthViewPainter.showLeadingAndTailingDates) {
            xPosition += cellWidth;
            continue;
          }
          isNextMonth = true;
        } else if (date.month == previousMonth) {
          if (!monthViewPainter.showLeadingAndTailingDates) {
            xPosition += cellWidth;
            continue;
          }
          isPreviousMonth = false;
        }
      }

      textStyle = _updateTextStyle(
          monthViewPainter,
          isNextMonth,
          isPreviousMonth,
          isCurrentDate,
          isEnableDate,
          isBlackedDate,
          isWeekEnd,
          isSpecialDate);
      dateDecoration = _updateDecoration(
          isNextMonth,
          isPreviousMonth,
          monthViewPainter,
          isEnableDate,
          isCurrentDate,
          isBlackedDate,
          date,
          isWeekEnd,
          isSpecialDate);

      if (selectedIndex.contains(currentIndex) &&
          !isBlackedDate &&
          isEnableDate &&
          (!monthViewPainter.enableMultiView ||
              (monthViewPainter.rowCount != 6 ||
                  (_currentDate.month == date.month)))) {
        textStyle = _drawCellAndSelection(
            canvas,
            xPosition,
            yPosition,
            selectionTextStyle,
            selectedRangeTextStyle,
            monthViewPainter,
            currentIndex);
      } else if (dateDecoration != null) {
        _drawDecoration(canvas, xPosition, yPosition, padding, cellWidth,
            cellHeight, dateDecoration);
      } else if (isCurrentDate) {
        _drawCurrentDate(canvas, monthViewPainter, xPosition, yPosition,
            padding, cellWidth, cellHeight);
      }

      final TextSpan dateText = TextSpan(
        text: date.day.toString(),
        style: textStyle,
      );

      monthViewPainter.textPainter.text = dateText;
      monthViewPainter.textPainter.layout(minWidth: 0, maxWidth: cellWidth);
      monthViewPainter.textPainter.paint(
          canvas,
          Offset(
              xPosition +
                  (cellWidth / 2 - monthViewPainter.textPainter.width / 2),
              yPosition +
                  ((cellHeight - monthViewPainter.textPainter.height) / 2)));
      if (monthViewPainter.mouseHoverPosition != null) {
        if (selectedIndex.contains(currentIndex) ||
            isBlackedDate ||
            !isEnableDate) {
          xPosition += cellWidth;
          continue;
        }

        _addHoveringEffect(canvas, monthViewPainter, xPosition, yPosition,
            cellWidth, cellHeight);
      }

      xPosition += cellWidth;
    }
  }
}

void _addHoveringEffect(Canvas canvas, _IMonthViewPainter monthViewPainter,
    double xPosition, double yPosition, double cellWidth, double cellHeight) {
  if (xPosition <= monthViewPainter.mouseHoverPosition.dx &&
      xPosition + cellWidth >= monthViewPainter.mouseHoverPosition.dx &&
      yPosition - 5 <= monthViewPainter.mouseHoverPosition.dy &&
      (yPosition + cellHeight) - 5 >= monthViewPainter.mouseHoverPosition.dy) {
    monthViewPainter.selectionPainter =
        monthViewPainter.selectionPainter ?? Paint();
    monthViewPainter.selectionPainter.style = PaintingStyle.fill;
    monthViewPainter.selectionPainter.strokeWidth = 2;
    monthViewPainter.selectionPainter.color =
        monthViewPainter.selectionColor != null
            ? monthViewPainter.selectionColor.withOpacity(0.4)
            : monthViewPainter.datePickerTheme.selectionColor.withOpacity(0.4);
    switch (monthViewPainter.selectionShape) {
      case DateRangePickerSelectionShape.circle:
        {
          final double centerXPosition = cellWidth / 2;
          final double centerYPosition = cellHeight / 2;
          final double radius = _getCellRadius(monthViewPainter.selectionRadius,
              centerXPosition, centerYPosition);
          canvas.drawCircle(
              Offset(xPosition + centerXPosition, yPosition + centerYPosition),
              radius,
              monthViewPainter.selectionPainter);
        }
        break;
      case DateRangePickerSelectionShape.rectangle:
        {
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromLTWH(xPosition + 1, yPosition + 1, cellWidth - 1,
                      cellHeight - 1),
                  Radius.circular(cellHeight / 4 > 10 ? 10 : cellHeight / 4)),
              monthViewPainter.selectionPainter);
        }
    }
  }
}

TextStyle _drawCellAndSelection(
    Canvas canvas,
    double xPosition,
    double yPosition,
    TextStyle selectionTextStyle,
    TextStyle selectedRangeTextStyle,
    _IMonthViewPainter monthViewPainter,
    int currentIndex) {
  monthViewPainter.selectionPainter =
      monthViewPainter.selectionPainter ?? Paint();
  monthViewPainter.selectionPainter.color = monthViewPainter.selectionColor ??
      monthViewPainter.datePickerTheme.selectionColor;
  //// Unwanted space shown at end of the rectangle while enable anti aliasing property.
  monthViewPainter.selectionPainter.isAntiAlias = false;
  monthViewPainter.selectionPainter.strokeWidth = 0.0;
  monthViewPainter.selectionPainter.style = PaintingStyle.fill;
  return monthViewPainter._drawSelection(canvas, xPosition, yPosition,
      currentIndex, selectionTextStyle, selectedRangeTextStyle);
}

void _drawDecoration(
    Canvas canvas,
    double xPosition,
    double yPosition,
    double padding,
    double cellWidth,
    double cellHeight,
    Decoration dateDecoration) {
  final BoxPainter boxPainter = dateDecoration.createBoxPainter();
  boxPainter.paint(
      canvas,
      Offset(xPosition + padding, yPosition + padding),
      ImageConfiguration(
          size: Size(cellWidth - (2 * padding), cellHeight - (2 * padding))));
}

void _drawCurrentDate(
    Canvas canvas,
    _IMonthViewPainter monthViewPainter,
    double xPosition,
    double yPosition,
    double padding,
    double cellWidth,
    double cellHeight) {
  monthViewPainter.selectionPainter =
      monthViewPainter.selectionPainter ?? Paint();
  monthViewPainter.selectionPainter.color =
      monthViewPainter.todayHighlightColor ??
          monthViewPainter.datePickerTheme.todayHighlightColor;
  monthViewPainter.selectionPainter.isAntiAlias = true;
  monthViewPainter.selectionPainter.strokeWidth = 1.0;
  monthViewPainter.selectionPainter.style = PaintingStyle.stroke;

  switch (monthViewPainter.selectionShape) {
    case DateRangePickerSelectionShape.circle:
      {
        final double centerXPosition = cellWidth / 2;
        final double centerYPosition = cellHeight / 2;
        final double radius = _getCellRadius(
            monthViewPainter.selectionRadius, centerXPosition, centerYPosition);
        canvas.drawCircle(
            Offset(xPosition + centerXPosition, yPosition + centerYPosition),
            radius,
            monthViewPainter.selectionPainter);
      }
      break;
    case DateRangePickerSelectionShape.rectangle:
      {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(
                    xPosition + padding,
                    yPosition + padding,
                    xPosition + cellWidth - padding,
                    yPosition + cellHeight - padding),
                Radius.circular(cellHeight / 4 > 10 ? 10 : cellHeight / 4)),
            monthViewPainter.selectionPainter);
      }
  }
}

TextStyle _updateTextStyle(
    _IMonthViewPainter monthViewPainter,
    bool isNextMonth,
    bool isPreviousMonth,
    bool isCurrentDate,
    bool isEnableDate,
    bool isBlackedDate,
    bool isWeekEnd,
    bool isSpecialDate) {
  final TextStyle currentDatesTextStyle =
      monthViewPainter.cellStyle.textStyle ??
          monthViewPainter.datePickerTheme.activeDatesTextStyle;
  if (isBlackedDate) {
    return monthViewPainter.cellStyle.blackoutDateTextStyle ??
        (monthViewPainter.datePickerTheme.blackoutDatesTextStyle ??
            currentDatesTextStyle.copyWith(
                decoration: TextDecoration.lineThrough));
  }

  if (isSpecialDate) {
    return monthViewPainter.cellStyle.specialDatesTextStyle ??
        monthViewPainter.datePickerTheme.specialDatesTextStyle;
  }

  if (!isEnableDate) {
    return monthViewPainter.cellStyle.disabledDatesTextStyle ??
        monthViewPainter.datePickerTheme.disabledDatesTextStyle;
  }

  if (isCurrentDate) {
    return monthViewPainter.cellStyle.todayTextStyle ??
        monthViewPainter.datePickerTheme.todayTextStyle;
  }

  if (isWeekEnd) {
    return monthViewPainter.cellStyle.weekendTextStyle ??
        (monthViewPainter.datePickerTheme != null &&
                monthViewPainter.datePickerTheme.weekendDatesTextStyle != null
            ? monthViewPainter.datePickerTheme.weekendDatesTextStyle
            : currentDatesTextStyle);
  }

  if (isNextMonth) {
    return monthViewPainter.cellStyle.leadingDatesTextStyle ??
        monthViewPainter.datePickerTheme.leadingDatesTextStyle;
  } else if (isPreviousMonth) {
    return monthViewPainter.cellStyle.trailingDatesTextStyle ??
        monthViewPainter.datePickerTheme.trailingDatesTextStyle;
  }

  return currentDatesTextStyle;
}

Decoration _updateDecoration(
    bool isNextMonth,
    bool isPreviousMonth,
    _IMonthViewPainter monthViewPainter,
    isEnableDate,
    isCurrentDate,
    isBlackedDate,
    DateTime date,
    bool isWeekEnd,
    bool isSpecialDate) {
  final Decoration dateDecoration = monthViewPainter.cellStyle.cellDecoration;

  if (isBlackedDate) {
    return monthViewPainter.cellStyle.blackoutDatesDecoration;
  }

  if (isSpecialDate) {
    return monthViewPainter.cellStyle.specialDatesDecoration;
  }

  if (!isEnableDate) {
    return monthViewPainter.cellStyle.disabledDatesDecoration;
  }

  if (isCurrentDate) {
    return monthViewPainter.cellStyle.todayCellDecoration ?? dateDecoration;
  }

  if (isWeekEnd) {
    return monthViewPainter.cellStyle.weekendDatesDecoration ?? dateDecoration;
  }

  if (isNextMonth) {
    return monthViewPainter.cellStyle.leadingDatesDecoration;
  } else if (isPreviousMonth) {
    return monthViewPainter.cellStyle.trailingDatesDecoration;
  }

  return dateDecoration;
}

List<CustomPainterSemantics> _getSemanticsBuilderForMonthView(
    Size size, int rowCount, _IMonthViewPainter monthViewPainter) {
  final List<CustomPainterSemantics> semanticsBuilder =
      <CustomPainterSemantics>[];
  double left, top;
  Map<String, double> leftAndTopValue;
  int count = 1;
  double width = size.width;
  if (monthViewPainter.enableMultiView) {
    count = 2;
    width = (size.width - monthViewPainter.multiViewSpacing) / 2;
  }

  final double cellWidth = width / _kNumberOfDaysInWeek;
  final double cellHeight = size.height / rowCount;
  final int datesCount = monthViewPainter.visibleDates.length ~/ count;
  for (int j = 0; j < count; j++) {
    final int currentViewIndex =
        monthViewPainter.isRtl ? _getRtlIndex(count, j) : j;
    left = monthViewPainter.isRtl ? width - cellWidth : 0;
    top = 0;
    final DateTime middleDate =
        monthViewPainter.visibleDates[(j * datesCount) + (datesCount ~/ 2)];
    for (int i = 0; i < datesCount; i++) {
      final DateTime currentDate =
          monthViewPainter.visibleDates[(j * datesCount) + i];
      if (!_isDateAsCurrentMonthDate(middleDate, monthViewPainter.rowCount,
          monthViewPainter.showLeadingAndTailingDates, currentDate)) {
        leftAndTopValue = _getTopAndLeftValues(
            monthViewPainter.isRtl, left, top, cellWidth, cellHeight, width);
        left = leftAndTopValue['left'];
        top = leftAndTopValue['top'];
        continue;
      } else if (_isDateWithInVisibleDates(monthViewPainter.visibleDates,
          monthViewPainter.blackoutDates, currentDate)) {
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(
              (currentViewIndex * width) +
                  (currentViewIndex * monthViewPainter.multiViewSpacing) +
                  left,
              top,
              cellWidth,
              cellHeight),
          properties: SemanticsProperties(
            label:
                DateFormat('EEE, dd/MMMM/yyyy').format(currentDate).toString() +
                    ', Blackout date',
            textDirection: TextDirection.ltr,
          ),
        ));
        leftAndTopValue = _getTopAndLeftValues(
            monthViewPainter.isRtl, left, top, cellWidth, cellHeight, width);
        left = leftAndTopValue['left'];
        top = leftAndTopValue['top'];
        continue;
      } else if (!_isEnabledDate(
          monthViewPainter.minDate,
          monthViewPainter.maxDate,
          monthViewPainter.enablePastDates,
          currentDate)) {
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(
              (currentViewIndex * width) +
                  (currentViewIndex * monthViewPainter.multiViewSpacing) +
                  left,
              top,
              cellWidth,
              cellHeight),
          properties: SemanticsProperties(
            label:
                DateFormat('EEE, dd/MMMM/yyyy').format(currentDate).toString() +
                    ', Disabled date',
            textDirection: TextDirection.ltr,
          ),
        ));
        leftAndTopValue = _getTopAndLeftValues(
            monthViewPainter.isRtl, left, top, cellWidth, cellHeight, width);
        left = leftAndTopValue['left'];
        top = leftAndTopValue['top'];
        continue;
      }
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(
            (currentViewIndex * width) +
                (currentViewIndex * monthViewPainter.multiViewSpacing) +
                left,
            top,
            cellWidth,
            cellHeight),
        properties: SemanticsProperties(
          label: DateFormat('EEE, dd/MMMM/yyyy').format(currentDate).toString(),
          textDirection: TextDirection.ltr,
        ),
      ));
      leftAndTopValue = _getTopAndLeftValues(
          monthViewPainter.isRtl, left, top, cellWidth, cellHeight, width);
      left = leftAndTopValue['left'];
      top = leftAndTopValue['top'];
    }
  }

  return semanticsBuilder;
}
