part of datepicker;

/// Update the year view selected date value from details value.
/// Notify the value changes to year view painter for repaint the painter.
void _updateYearViewSelection(_IPickerYearView view, _PickerStateArgs details) {
  view.selectedDate = _getSelectedValue(view.selectionMode, details);
  view.selectionNotifier.value = !view.selectionNotifier.value;
}

/// Return the selected value from state details based on picker selection mode.
dynamic _getSelectedValue(
    DateRangePickerSelectionMode mode, _PickerStateArgs details) {
  switch (mode) {
    case DateRangePickerSelectionMode.single:
      return details._selectedDate;
    case DateRangePickerSelectionMode.multiple:
      return _cloneList(details._selectedDates);
    case DateRangePickerSelectionMode.range:
      return details._selectedRange;
    case DateRangePickerSelectionMode.multiRange:
      return _cloneList(details._selectedRanges);
  }
}

/// Check whether the date is in between the start and end date value.
bool _isDateWithInYearRange(DateTime startDate, DateTime endDate, DateTime date,
    _IPickerYearView view) {
  if (startDate == null || endDate == null || date == null) {
    return false;
  }

  /// Check the start date as before of end date, if not then swap
  /// the start and end date values.
  if (startDate.isAfter(endDate)) {
    final DateTime temp = startDate;
    startDate = endDate;
    endDate = temp;
  }

  /// Check the date is equal or after of the start date and
  /// the date is equal or before of the end date.
  if ((view._isSameView(endDate, date) || endDate.isAfter(date)) &&
      (view._isSameView(startDate, date) || startDate.isBefore(date))) {
    return true;
  }

  return false;
}

/// Return index of the date value in dates collection.
/// Return -1 when the date does not exist in dates collection.
int _getYearCellIndex(
    List<DateTime> dates, DateTime date, _IPickerYearView view,
    {int viewStartIndex = -1, int viewEndIndex = -1}) {
  if (date == null) {
    return -1;
  }

  viewStartIndex = viewStartIndex == -1 ? 0 : viewStartIndex;
  viewEndIndex = viewEndIndex == -1 ? dates.length - 1 : viewEndIndex;
  for (int i = viewStartIndex; i <= viewEndIndex; i++) {
    final DateTime currentDate = dates[i];
    if (view._isSameView(date, currentDate)) {
      return i;
    }
  }

  return -1;
}

/// Return the previous view date of the date based on picker view.
/// Eg., if picker view as year view and view date as May, 2020 then
/// it return date value as Apr, 2020.
DateTime _getPreviousDate(DateRangePickerView view, DateTime viewDate) {
  DateTime date;
  switch (view) {
    case DateRangePickerView.month:
      break;
    case DateRangePickerView.year:
      {
        date = DateTime(viewDate.year, viewDate.month, 1);
        date = subtractDuration(date, const Duration(days: 1));
        return DateTime(date.year, date.month, 1);
      }
    case DateRangePickerView.decade:
      {
        date = DateTime(viewDate.year, 1, 1);
        date = subtractDuration(date, const Duration(days: 1));
        return DateTime(date.year, 1, 1);
      }
    case DateRangePickerView.century:
      {
        date = DateTime((viewDate.year ~/ 10) * 10, 1, 1);
        date = subtractDuration(date, const Duration(days: 1));
        return DateTime((date.year ~/ 10) * 10, 1, 1);
      }
  }

  return viewDate;
}

/// Return the next view date of the date based on picker view.
/// Eg., if picker view as year view and view date as May, 2020 then
/// it return date value as Jun, 2020.
DateTime _getNextDate(DateRangePickerView view, DateTime viewEndDate) {
  final DateTime date = _getLastDate(view, viewEndDate);
  return addDuration(date, const Duration(days: 1));
}

/// Return the last date of the date based on picker view.
/// Eg., if picker view as year view and view date as May 20, 2020 then
/// it return date value as May 31, 2020.
DateTime _getLastDate(DateRangePickerView view, DateTime viewEndDate) {
  switch (view) {
    case DateRangePickerView.month:
      break;
    case DateRangePickerView.year:
      {
        final DateTime date =
            DateTime(viewEndDate.year, viewEndDate.month + 1, 1);
        return subtractDuration(date, const Duration(days: 1));
      }
    case DateRangePickerView.decade:
      {
        final DateTime date = DateTime(viewEndDate.year + 1, 1, 1);
        return subtractDuration(date, const Duration(days: 1));
      }
    case DateRangePickerView.century:
      {
        final DateTime date =
            DateTime(((viewEndDate.year ~/ 10) * 10) + 10, 1, 1);
        return subtractDuration(date, const Duration(days: 1));
      }
  }

  return viewEndDate;
}

/// Return the first date of the date based on picker view.
/// Eg., if picker view as year view and view date as May 20, 2020 then
/// it return date value as May 1, 2020.
DateTime _getFirstDate(DateRangePickerView view, DateTime viewDate) {
  switch (view) {
    case DateRangePickerView.month:
      break;
    case DateRangePickerView.year:
      {
        return DateTime(viewDate.year, viewDate.month, 1);
      }
    case DateRangePickerView.decade:
      {
        return DateTime(viewDate.year, 1, 1);
      }
    case DateRangePickerView.century:
      {
        return DateTime((viewDate.year ~/ 10) * 10, 1, 1);
      }
  }

  return viewDate;
}

/// Return list of int value in between start and end date index value.
List<int> _getRangeIndex(
    DateTime startDate,
    DateTime endDate,
    _IPickerYearView view,
    DateRangePickerView pickerView,
    int viewStartIndex,
    int viewEndIndex) {
  int startIndex = -1;
  int endIndex = -1;
  final List<int> selectedIndex = <int>[];

  /// Check the start date as before of end date, if not then swap
  /// the start and end date values.
  if (startDate != null && startDate.isAfter(endDate)) {
    final DateTime temp = startDate;
    startDate = endDate;
    endDate = temp;
  }

  final DateTime viewStartDate = view.visibleDates[viewStartIndex];
  final DateTime viewEndDate =
      _getLastDate(pickerView, view.visibleDates[viewEndIndex]);
  if (startDate != null) {
    /// Assign start index as -1 when the start date before of view start date.
    if (viewStartDate.isAfter(startDate) && viewStartDate.isBefore(endDate)) {
      startIndex = -1;
    } else {
      startIndex = _getYearCellIndex(view.visibleDates, startDate, view,
          viewStartIndex: viewStartIndex, viewEndIndex: viewEndIndex);
    }
  }

  if (endDate != null) {
    /// Assign end index as visible dates length when the
    /// end date after of view end date.
    if (viewEndDate.isAfter(startDate) && viewEndDate.isBefore(endDate)) {
      endIndex = viewEndIndex + 1;
    } else {
      endIndex = _getYearCellIndex(view.visibleDates, endDate, view,
          viewStartIndex: viewStartIndex, viewEndIndex: viewEndIndex);
    }
  }

  //// If some range end date as null then it end index is start index.
  if (startIndex != -1 && endIndex == -1) {
    endIndex = startIndex;
  }

  /// Check the start index as before of end index, if not then swap
  /// the start and end index values.
  if (startIndex > endIndex) {
    final int temp = startIndex;
    startIndex = endIndex;
    endIndex = temp;
  }

  /// Add the index values in between start and end index values.
  for (int i = startIndex; i <= endIndex; i++) {
    selectedIndex.add(i);
  }

  return selectedIndex;
}

void _drawYearSelection(
    _IPickerYearView view,
    int viewStartIndex,
    int viewEndIndex,
    List<int> selectedIndex,
    List<List<int>> rangeIndex,
    DateRangePickerView pickerView) {
  switch (view.selectionMode) {
    case DateRangePickerSelectionMode.single:
      {
        final int index = _getYearCellIndex(
            view.visibleDates, view.selectedDate, view,
            viewStartIndex: viewStartIndex, viewEndIndex: viewEndIndex);
        if (index != -1) {
          selectedIndex.add(index);
        }
      }
      break;
    case DateRangePickerSelectionMode.multiple:
      {
        for (int i = 0; i < view.selectedDate.length; i++) {
          final int index = _getYearCellIndex(
              view.visibleDates, view.selectedDate[i], view,
              viewStartIndex: viewStartIndex, viewEndIndex: viewEndIndex);
          if (index != -1) {
            selectedIndex.add(index);
          }
        }
      }
      break;
    case DateRangePickerSelectionMode.range:
      {
        final DateTime startDate = view.selectedDate.startDate;
        final DateTime endDate =
            view.selectedDate.endDate ?? view.selectedDate.startDate;
        selectedIndex.clear();
        selectedIndex.addAll(_getRangeIndex(startDate, endDate, view,
            pickerView, viewStartIndex, viewEndIndex));
        rangeIndex.add(selectedIndex);
      }
      break;
    case DateRangePickerSelectionMode.multiRange:
      {
        for (int i = 0; i < view.selectedDate.length; i++) {
          final PickerDateRange range = view.selectedDate[i];
          final DateTime startDate = range.startDate;
          final DateTime endDate = range.endDate ?? range.startDate;
          final List<int> index = _getRangeIndex(startDate, endDate, view,
              pickerView, viewStartIndex, viewEndIndex);
          rangeIndex.add(index);
          for (int j = 0; j < index.length; j++) {
            selectedIndex.add(index[j]);
          }
        }
      }
  }
}

/// Draws the year cell on canvas based on picker view and [_IPickerYearView]
/// value
void _drawYearCells(Canvas canvas, Size size, _IPickerYearView view,
    DateRangePickerView pickerView) {
  canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
  double width = size.width;
  final double webUIPadding = view.multiViewSpacing;
  if (view.enableMultiView) {
    width = (width - webUIPadding) / 2;
  }

  final double cellWidth = width / _IPickerYearView._maxColumnCount;
  final double cellHeight = size.height / _IPickerYearView._maxRowCount;

  double xPosition = 0, yPosition;
  final DateTime today = DateTime.now();
  view.textPainter ??= TextPainter(
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      maxLines: 2,
      textScaleFactor: view.textScaleFactor,
      textWidthBasis: TextWidthBasis.longestLine);

  const double decorationPadding = 1;
  const double selectionPadding = 3;
  final double centerYPosition = cellHeight / 2;

  final int visibleDatesCount = view.enableMultiView
      ? view.visibleDates.length ~/ 2
      : view.visibleDates.length;
  for (int j = 0; j < (view.enableMultiView ? 2 : 1); j++) {
    final int currentViewIndex =
        view.isRtl ? _getRtlIndex(view.enableMultiView ? 2 : 1, j) : j;
    final List<int> selectedIndex = <int>[];
    final List<List<int>> rangeIndex = <List<int>>[];

    final int viewStartIndex = j * visibleDatesCount;
    final int viewEndIndex = ((j + 1) * visibleDatesCount) - 1;

    /// Calculate the selected index values based on selected date property in
    /// [_IPickerYearView]
    if (view.selectedDate != null) {
      _drawYearSelection(view, viewStartIndex, viewEndIndex, selectedIndex,
          rangeIndex, pickerView);
    }

    final double viewStartPosition =
        (currentViewIndex * width) + (currentViewIndex * webUIPadding);
    final double viewEndPosition =
        ((currentViewIndex + 1) * width) + (currentViewIndex * webUIPadding);
    xPosition = viewStartPosition;
    yPosition = 0;
    for (int i = 0; i < visibleDatesCount; i++) {
      int currentIndex = i;
      if (view.isRtl) {
        final int rowIndex = i ~/ _IPickerYearView._maxColumnCount;
        currentIndex = _getRtlIndex(_IPickerYearView._maxColumnCount,
                i % _IPickerYearView._maxColumnCount) +
            (rowIndex * _IPickerYearView._maxColumnCount);
      }

      currentIndex += viewStartIndex;
      if (xPosition >= viewEndPosition) {
        xPosition = viewStartPosition;
        yPosition += cellHeight;
      }

      if (view.enableMultiView &&
          view._isTrailingDate(currentIndex, viewStartIndex)) {
        xPosition += cellWidth;
        continue;
      }

      final DateTime date = view.visibleDates[currentIndex];
      final bool isCurrentDate = view._isSameView(date, today);
      final bool isSelected = selectedIndex.contains(currentIndex);
      final bool isEnableDate = view._isBetweenMinMaxMonth(date);
      final bool isActiveDate = view._isCurrentView(date, j);
      final TextStyle style = _updateCellTextStyle(
          view, j, isCurrentDate, isSelected, isEnableDate, isActiveDate);
      final Decoration yearDecoration = _updateCellDecoration(
          view, j, isCurrentDate, isEnableDate, isActiveDate);

      final TextSpan yearText = TextSpan(
        text: view._getCellText(date),
        style: style,
      );

      view.textPainter.text = yearText;
      view.textPainter.layout(minWidth: 0, maxWidth: cellWidth);

      final double highlightPadding = view.selectionRadius ?? 10;
      final double textHalfHeight = view.textPainter.height / 2;
      if (isSelected && isEnableDate) {
        _drawYearCellsAndSelection(
            canvas,
            cellWidth,
            currentIndex,
            highlightPadding,
            rangeIndex,
            selectionPadding,
            textHalfHeight,
            centerYPosition,
            view,
            xPosition,
            yPosition,
            yearText);
      } else if (yearDecoration != null) {
        _drawYearDecoration(canvas, yearDecoration, xPosition, yPosition,
            decorationPadding, cellWidth, cellHeight);
      } else if (isCurrentDate) {
        _drawTodayHighlight(
            canvas,
            view,
            cellWidth,
            cellHeight,
            centerYPosition,
            highlightPadding,
            selectionPadding,
            textHalfHeight,
            xPosition,
            yPosition);
      }

      double xOffset = xPosition + ((cellWidth - view.textPainter.width) / 2);
      xOffset = xOffset < 0 ? 0 : xOffset;
      double yOffset = yPosition + ((cellHeight - view.textPainter.height) / 2);
      yOffset = yOffset < 0 ? 0 : yOffset;

      if (view.mouseHoverPosition != null) {
        if (!view._isBetweenMinMaxMonth(date)) {
          view.textPainter.paint(canvas, Offset(xOffset, yOffset));
          xPosition += cellWidth;
          continue;
        }
        _addMouseHovering(
            canvas,
            cellWidth,
            cellHeight,
            centerYPosition,
            currentViewIndex,
            width,
            highlightPadding,
            date,
            selectionPadding,
            textHalfHeight,
            view,
            webUIPadding,
            xOffset,
            xPosition,
            yOffset,
            yPosition);
      }

      view.textPainter.paint(canvas, Offset(xOffset, yOffset));
      xPosition += cellWidth;
    }
  }
}

void _addMouseHovering(
    Canvas canvas,
    double cellWidth,
    double cellHeight,
    double centerYPosition,
    int currentViewIndex,
    double width,
    double highlightPadding,
    DateTime date,
    double selectionPadding,
    double textHalfHeight,
    _IPickerYearView view,
    double webUIPadding,
    double xOffset,
    double xPosition,
    double yOffset,
    double yPosition) {
  if (xPosition <= view.mouseHoverPosition.dx &&
      xPosition + cellWidth >= view.mouseHoverPosition.dx &&
      yPosition - 5 <= view.mouseHoverPosition.dy &&
      (yPosition + cellHeight) - 5 >= view.mouseHoverPosition.dy) {
    view.todayHighlightPaint = view.todayHighlightPaint ?? Paint();
    view.todayHighlightPaint.style = PaintingStyle.fill;
    view.todayHighlightPaint.strokeWidth = 2;
    view.todayHighlightPaint.color = view.selectionColor != null
        ? view.selectionColor.withOpacity(0.4)
        : view.datePickerTheme.selectionColor.withOpacity(0.4);

    if (centerYPosition - textHalfHeight < highlightPadding / 2) {
      highlightPadding = (centerYPosition - textHalfHeight / 2) - 1;
    }

    final Rect rect = Rect.fromLTRB(
        xPosition + selectionPadding,
        yPosition + centerYPosition - highlightPadding - textHalfHeight,
        xPosition + cellWidth - selectionPadding,
        yPosition + centerYPosition + highlightPadding + textHalfHeight);
    double cornerRadius = rect.height / 2;
    switch (view.selectionShape) {
      case DateRangePickerSelectionShape.rectangle:
        {
          cornerRadius = 3;
        }
        break;
      case DateRangePickerSelectionShape.circle:
        break;
    }

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)),
        view.todayHighlightPaint);
  }
}

void _drawTodayHighlight(
    Canvas canvas,
    _IPickerYearView view,
    double cellWidth,
    double cellHeight,
    double centerYPosition,
    double highlightPadding,
    double selectionPadding,
    double textHalfHeight,
    double xPosition,
    double yPosition) {
  view.todayHighlightPaint ??= Paint();
  view.todayHighlightPaint.color =
      view.todayHighlightColor ?? view.datePickerTheme.todayHighlightColor;
  view.todayHighlightPaint.isAntiAlias = true;
  view.todayHighlightPaint.strokeWidth = 1.0;
  view.todayHighlightPaint.style = PaintingStyle.stroke;
  final double maximumHighlight =
      centerYPosition - textHalfHeight - selectionPadding;
  if (maximumHighlight < highlightPadding) {
    highlightPadding = maximumHighlight;
  }

  final Rect rect = Rect.fromLTRB(
      xPosition + selectionPadding,
      yPosition + centerYPosition - highlightPadding - textHalfHeight,
      xPosition + cellWidth - selectionPadding,
      yPosition + centerYPosition + highlightPadding + textHalfHeight);
  double cornerRadius = rect.height / 2;
  switch (view.selectionShape) {
    case DateRangePickerSelectionShape.rectangle:
      {
        cornerRadius = 3;
      }
      break;
    case DateRangePickerSelectionShape.circle:
      break;
  }

  canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)),
      view.todayHighlightPaint);
}

void _drawYearDecoration(
    Canvas canvas,
    Decoration yearDecoration,
    double xPosition,
    double yPosition,
    double decorationPadding,
    double cellWidth,
    double cellHeight) {
  final BoxPainter boxPainter = yearDecoration.createBoxPainter();
  boxPainter.paint(
      canvas,
      Offset(xPosition + decorationPadding, yPosition + decorationPadding),
      ImageConfiguration(
          size: Size(cellWidth - (2 * decorationPadding),
              cellHeight - (2 * decorationPadding))));
}

void _drawYearCellsAndSelection(
    Canvas canvas,
    double cellWidth,
    int currentIndex,
    double highlightPadding,
    List<List<int>> rangeIndex,
    double selectionPadding,
    double textHalfHeight,
    centerYPosition,
    _IPickerYearView view,
    double xPosition,
    double yPosition,
    TextSpan yearText) {
  view.todayHighlightPaint ??= Paint();
  view.todayHighlightPaint.isAntiAlias = true;
  view.todayHighlightPaint.style = PaintingStyle.fill;
  final double maximumHighlight =
      centerYPosition - textHalfHeight - selectionPadding;
  if (maximumHighlight < highlightPadding) {
    highlightPadding = maximumHighlight;
  }

  /// isSelectedDate value used to notify the year cell as selected and
  /// its selection mode as single or multiple or the [PickerDateRange]
  /// holds only start date value on range and multi range selection.
  bool isSelectedDate =
      view.selectionMode == DateRangePickerSelectionMode.single ||
              view.selectionMode == DateRangePickerSelectionMode.multiple
          ? true
          : false;

  /// isStartRange value used to notify the year cell as selected and
  /// the year cell as start date cell of the [PickerDateRange].
  /// its selection mode as range or multi range.
  bool isStartRange = false;

  /// isEndRange value used to notify the year cell as selected and
  /// the year cell as end date cell of the [PickerDateRange].
  /// its selection mode as range or multi range.
  bool isEndRange = false;

  /// isBetweenRange value used to notify the year cell as selected and
  /// the year cell as in between the start and  end date cell of the
  /// [PickerDateRange]. its selection mode as range or multi range.
  bool isBetweenRange = false;
  switch (view.selectionMode) {
    case DateRangePickerSelectionMode.single:
    case DateRangePickerSelectionMode.multiple:
      break;
    case DateRangePickerSelectionMode.range:
    case DateRangePickerSelectionMode.multiRange:
      List<int> range = <int>[];
      for (int k = 0; k < rangeIndex.length; k++) {
        range = rangeIndex[k];
        if (!range.contains(currentIndex)) {
          continue;
        }

        if (range.length == 1) {
          isSelectedDate = true;
        } else if (range[0] == currentIndex) {
          if (view.isRtl) {
            isEndRange = true;
          } else {
            isStartRange = true;
          }
        } else if (range[range.length - 1] == currentIndex) {
          if (view.isRtl) {
            isStartRange = true;
          } else {
            isEndRange = true;
          }
        } else {
          isBetweenRange = true;
        }
      }
  }

  final Rect rect = Rect.fromLTRB(
      xPosition + (isBetweenRange || isEndRange ? 0 : selectionPadding),
      yPosition + centerYPosition - highlightPadding - textHalfHeight,
      xPosition +
          cellWidth -
          (isBetweenRange || isStartRange ? 0 : selectionPadding),
      yPosition + centerYPosition + highlightPadding + textHalfHeight);
  final double cornerRadius = isBetweenRange
      ? 0
      : (view.selectionShape == DateRangePickerSelectionShape.circle
          ? rect.height / 2
          : 3);
  final double leftRadius = isStartRange || isSelectedDate ? cornerRadius : 0;
  final double rightRadius = isEndRange || isSelectedDate ? cornerRadius : 0;
  if (isSelectedDate) {
    switch (view.selectionMode) {
      case DateRangePickerSelectionMode.single:
      case DateRangePickerSelectionMode.multiple:
        {
          view.todayHighlightPaint.color =
              view.selectionColor ?? view.datePickerTheme.selectionColor;
        }
        break;
      case DateRangePickerSelectionMode.range:
      case DateRangePickerSelectionMode.multiRange:
        {
          view.todayHighlightPaint.color = view.startRangeSelectionColor ??
              view.datePickerTheme.startRangeSelectionColor;
        }
    }
  } else if (isStartRange) {
    view.todayHighlightPaint.color = view.startRangeSelectionColor ??
        view.datePickerTheme.startRangeSelectionColor;
  } else if (isBetweenRange) {
    yearText = TextSpan(
      text: yearText.text,
      style:
          view.rangeTextStyle ?? view.datePickerTheme.rangeSelectionTextStyle,
    );

    view.textPainter.text = yearText;
    view.textPainter.layout(minWidth: 0, maxWidth: cellWidth);

    view.todayHighlightPaint.color =
        view.rangeSelectionColor ?? view.datePickerTheme.rangeSelectionColor;
  } else if (isEndRange) {
    view.todayHighlightPaint.color = view.endRangeSelectionColor ??
        view.datePickerTheme.endRangeSelectionColor;
  }

  canvas.drawRRect(
      RRect.fromRectAndCorners(rect,
          topLeft: Radius.circular(leftRadius),
          bottomLeft: Radius.circular(leftRadius),
          bottomRight: Radius.circular(rightRadius),
          topRight: Radius.circular(rightRadius)),
      view.todayHighlightPaint);
}

TextStyle _updateCellTextStyle(_IPickerYearView view, int j, bool isCurrentDate,
    bool isSelected, bool isEnableDate, bool isActiveDate) {
  if (!isEnableDate) {
    return view.cellStyle.disabledDatesTextStyle ??
        view.datePickerTheme.disabledCellTextStyle;
  }

  if (isSelected) {
    return view.selectionTextStyle ?? view.datePickerTheme.selectionTextStyle;
  }

  if (isCurrentDate) {
    return view.cellStyle.todayTextStyle ??
        view.datePickerTheme.todayCellTextStyle;
  }

  if (!isActiveDate) {
    return view.cellStyle.leadingDatesTextStyle ??
        view.datePickerTheme.leadingCellTextStyle;
  }

  return view.cellStyle.textStyle ?? view.datePickerTheme.cellTextStyle;
}

Decoration _updateCellDecoration(_IPickerYearView view, int j,
    bool isCurrentDate, bool isEnableDate, bool isActiveDate) {
  if (!isEnableDate) {
    return view.cellStyle.disabledDatesDecoration;
  }

  if (isCurrentDate) {
    return view.cellStyle.todayCellDecoration;
  }

  if (!isActiveDate) {
    return view.cellStyle.leadingDatesDecoration;
  }

  return view.cellStyle.cellDecoration;
}

List<CustomPainterSemantics> _getSemanticsBuilderForYearView(
    Size size, _IPickerYearView view) {
  final List<CustomPainterSemantics> semanticsBuilder =
      <CustomPainterSemantics>[];
  double left, top;
  Map<String, double> leftAndTopValue;
  int count = 1;
  double width = size.width;
  if (view.enableMultiView) {
    count = 2;
    width = (size.width - view.multiViewSpacing) / 2;
  }

  final double cellWidth = width / 3;
  final double cellHeight = size.height / 4;
  final int datesCount = view.visibleDates.length ~/ count;
  for (int j = 0; j < count; j++) {
    final int currentViewIndex = view.isRtl ? _getRtlIndex(count, j) : j;
    left = view.isRtl ? width - cellWidth : 0;
    top = 0;
    final double startXPosition =
        (currentViewIndex * width) + (currentViewIndex * view.multiViewSpacing);
    final int startIndex = j * datesCount;
    for (int i = 0; i < datesCount; i++) {
      final DateTime date = view.visibleDates[startIndex + i];
      if (view._isTrailingDate(startIndex + i, startIndex)) {
        leftAndTopValue = _getTopAndLeftValues(
            view.isRtl, left, top, cellWidth, cellHeight, width);
        left = leftAndTopValue['left'];
        top = leftAndTopValue['top'];
        continue;
      }

      if (!view._isBetweenMinMaxMonth(date)) {
        semanticsBuilder.add(CustomPainterSemantics(
          rect:
              Rect.fromLTWH(startXPosition + left, top, cellWidth, cellHeight),
          properties: SemanticsProperties(
            label: _getCellText(date, view) + 'Disabled cell',
            textDirection: TextDirection.ltr,
          ),
        ));

        leftAndTopValue = _getTopAndLeftValues(
            view.isRtl, left, top, cellWidth, cellHeight, width);
        left = leftAndTopValue['left'];
        top = leftAndTopValue['top'];
        continue;
      }
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(startXPosition + left, top, cellWidth, cellHeight),
        properties: SemanticsProperties(
          label: _getCellText(date, view),
          textDirection: TextDirection.ltr,
        ),
      ));
      leftAndTopValue = _getTopAndLeftValues(
          view.isRtl, left, top, cellWidth, cellHeight, width);
      left = leftAndTopValue['left'];
      top = leftAndTopValue['top'];
    }
  }

  return semanticsBuilder;
}

String _getCellText(DateTime date, _IPickerYearView view) {
  if (view.runtimeType.toString() == '_PickerYearViewPainter') {
    return DateFormat('MMMM yyyy').format(date).toString();
  } else if (view.runtimeType.toString() == '_PickerDecadeViewPainter') {
    return date.year.toString();
  } else {
    return date.year.toString() + ' to ' + (date.year + 9).toString();
  }
}
