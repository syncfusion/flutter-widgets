part of datepicker;

@immutable
class _PickerView extends StatefulWidget {
  const _PickerView(this.picker, this.controller, this.visibleDates, this.width,
      this.height, this.datePickerTheme, this.focusNode, this.textScaleFactor,
      {Key key,
      this.getPickerStateDetails,
      this.updatePickerStateDetails,
      this.isRtl})
      : super(key: key);

  final List<DateTime> visibleDates;
  final SfDateRangePicker picker;
  final DateRangePickerController controller;
  final double width;
  final double height;
  final _UpdatePickerState getPickerStateDetails;
  final _UpdatePickerState updatePickerStateDetails;
  final SfDateRangePickerThemeData datePickerTheme;
  final bool isRtl;
  final FocusNode focusNode;
  final double textScaleFactor;

  @override
  _PickerViewState createState() => _PickerViewState();
}

class _PickerViewState extends State<_PickerView>
    with TickerProviderStateMixin {
  _PickerStateArgs _pickerStateDetails;
  _IMonthViewPainter _monthView;
  _IPickerYearView _yearView;
  Offset _mouseHoverPosition;

  /// The date time property used to range selection to store the
  /// previous selected date value in range.
  DateTime _previousSelectedDate;

  //// drag start boolean variable used to identify whether the drag started or not
  //// For example., if user start drag from disabled date then the start date of the range not created
  //// so in drag update method update the end date of existing selected range.
  bool _isDragStart;

  @override
  void initState() {
    _pickerStateDetails = _PickerStateArgs();
    _isDragStart = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    widget.getPickerStateDetails(_pickerStateDetails);

    switch (widget.controller.view) {
      case DateRangePickerView.month:
        {
          return GestureDetector(
            child: MouseRegion(
              onEnter: _pointerEnterEvent,
              onHover: _pointerHoverEvent,
              onExit: _pointerExitEvent,
              child: _addMonthView(locale, widget.datePickerTheme),
            ),
            onTapUp: _updateTapCallback,
            onHorizontalDragStart: _getDragStartCallback(),
            onVerticalDragStart: _getDragStartCallback(),
            onHorizontalDragUpdate: _getDragUpdateCallback(),
            onVerticalDragUpdate: _getDragUpdateCallback(),
          );
        }
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          return GestureDetector(
            child: MouseRegion(
              onEnter: _pointerEnterEvent,
              onHover: _pointerHoverEvent,
              onExit: _pointerExitEvent,
              child: _addYearView(locale),
            ),
            onTapUp: _updateTapCallback,
            onHorizontalDragStart: _getDragStartCallback(),
            onVerticalDragStart: _getDragStartCallback(),
            onHorizontalDragUpdate: _getDragUpdateCallback(),
            onVerticalDragUpdate: _getDragUpdateCallback(),
          );
        }
    }

    return null;
  }

  // Returns the month view  as a child for the calendar view.
  Widget _addMonthView(
      Locale locale, SfDateRangePickerThemeData datePickerTheme) {
    double viewHeaderHeight = widget.picker.monthViewSettings.viewHeaderHeight;
    if (widget.controller.view == DateRangePickerView.month &&
        widget.picker.navigationDirection ==
            DateRangePickerNavigationDirection.vertical) {
      viewHeaderHeight = 0;
    }

    final double height = widget.height - viewHeaderHeight;
    _monthView = _getMonthView(locale, widget.datePickerTheme);
    return Stack(
      children: <Widget>[
        _getViewHeader(viewHeaderHeight, locale, datePickerTheme),
        Positioned(
          left: 0,
          top: viewHeaderHeight,
          right: 0,
          height: height,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _monthView,
              size: Size(widget.width, height),
            ),
          ),
        ),
      ],
    );
  }

  _IMonthViewPainter _getMonthView(
      Locale locale, SfDateRangePickerThemeData datePickerTheme) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          return _MonthViewSingleSelectionPainter(
              widget.visibleDates,
              widget.picker.monthViewSettings.numberOfWeeksInView,
              widget.picker.monthCellStyle,
              widget.picker.selectionTextStyle,
              widget.picker.rangeTextStyle,
              widget.picker.selectionColor,
              widget.picker.startRangeSelectionColor,
              widget.picker.endRangeSelectionColor,
              widget.picker.rangeSelectionColor,
              widget.datePickerTheme,
              widget.isRtl,
              widget.picker.todayHighlightColor,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.picker.monthViewSettings.showTrailingAndLeadingDates,
              widget.picker.monthViewSettings.blackoutDates,
              widget.picker.monthViewSettings.specialDates,
              widget.picker.monthViewSettings.weekendDays,
              _pickerStateDetails._selectedDate,
              widget.picker.selectionShape,
              widget.picker.selectionRadius,
              _mouseHoverPosition,
              widget.picker.enableMultiView,
              widget.picker.viewSpacing,
              ValueNotifier<bool>(false),
              widget.textScaleFactor);
        }
      case DateRangePickerSelectionMode.multiple:
        {
          return _MonthViewMultiSelectionPainter(
              widget.visibleDates,
              widget.picker.monthViewSettings.numberOfWeeksInView,
              widget.picker.monthCellStyle,
              widget.picker.selectionTextStyle,
              widget.picker.rangeTextStyle,
              widget.picker.selectionColor,
              widget.picker.startRangeSelectionColor,
              widget.picker.endRangeSelectionColor,
              widget.picker.rangeSelectionColor,
              widget.datePickerTheme,
              widget.isRtl,
              widget.picker.todayHighlightColor,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.picker.monthViewSettings.showTrailingAndLeadingDates,
              widget.picker.monthViewSettings.blackoutDates,
              widget.picker.monthViewSettings.specialDates,
              widget.picker.monthViewSettings.weekendDays,
              _cloneList(_pickerStateDetails._selectedDates),
              widget.picker.selectionShape,
              widget.picker.selectionRadius,
              _mouseHoverPosition,
              widget.picker.enableMultiView,
              widget.picker.viewSpacing,
              ValueNotifier<bool>(false),
              widget.textScaleFactor);
        }
      case DateRangePickerSelectionMode.range:
        {
          return _MonthViewRangeSelectionPainter(
              widget.visibleDates,
              widget.picker.monthViewSettings.numberOfWeeksInView,
              widget.picker.monthCellStyle,
              widget.picker.selectionTextStyle,
              widget.picker.rangeTextStyle,
              widget.picker.selectionColor,
              widget.picker.startRangeSelectionColor,
              widget.picker.endRangeSelectionColor,
              widget.picker.rangeSelectionColor,
              widget.datePickerTheme,
              widget.isRtl,
              widget.picker.todayHighlightColor,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.picker.monthViewSettings.showTrailingAndLeadingDates,
              widget.picker.monthViewSettings.blackoutDates,
              widget.picker.monthViewSettings.specialDates,
              widget.picker.monthViewSettings.weekendDays,
              _pickerStateDetails._selectedRange,
              widget.picker.selectionShape,
              widget.picker.selectionRadius,
              _mouseHoverPosition,
              widget.picker.enableMultiView,
              widget.picker.viewSpacing,
              ValueNotifier<bool>(false),
              widget.textScaleFactor);
        }
      case DateRangePickerSelectionMode.multiRange:
        {
          return _MonthViewMultiRangeSelectionPainter(
              widget.visibleDates,
              widget.picker.monthViewSettings.numberOfWeeksInView,
              widget.picker.monthCellStyle,
              widget.picker.selectionTextStyle,
              widget.picker.rangeTextStyle,
              widget.picker.selectionColor,
              widget.picker.startRangeSelectionColor,
              widget.picker.endRangeSelectionColor,
              widget.picker.rangeSelectionColor,
              widget.datePickerTheme,
              widget.isRtl,
              widget.picker.todayHighlightColor,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.picker.monthViewSettings.showTrailingAndLeadingDates,
              widget.picker.monthViewSettings.blackoutDates,
              widget.picker.monthViewSettings.specialDates,
              widget.picker.monthViewSettings.weekendDays,
              _cloneList(_pickerStateDetails._selectedRanges),
              widget.picker.selectionShape,
              widget.picker.selectionRadius,
              _mouseHoverPosition,
              widget.picker.enableMultiView,
              widget.picker.viewSpacing,
              ValueNotifier<bool>(false),
              widget.textScaleFactor);
        }
    }

    return null;
  }

  Widget _getViewHeader(double viewHeaderHeight, Locale locale,
      SfDateRangePickerThemeData datePickerTheme) {
    if (viewHeaderHeight == 0) {
      return Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: viewHeaderHeight,
          child: Container());
    }

    final Color todayTextColor =
        widget.picker.monthCellStyle.todayTextStyle != null &&
                widget.picker.monthCellStyle.todayTextStyle.color != null
            ? widget.picker.monthCellStyle.todayTextStyle.color
            : (widget.picker.todayHighlightColor != null &&
                    widget.picker.todayHighlightColor != Colors.transparent
                ? widget.picker.todayHighlightColor
                : widget.datePickerTheme.todayHighlightColor);

    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      height: viewHeaderHeight,
      child: Container(
        color:
            widget.picker.monthViewSettings.viewHeaderStyle.backgroundColor ??
                widget.datePickerTheme.viewHeaderBackgroundColor,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _PickerViewHeaderPainter(
                widget.visibleDates,
                widget.picker.monthViewSettings.viewHeaderStyle,
                viewHeaderHeight,
                widget.picker.monthViewSettings,
                widget.datePickerTheme,
                locale,
                widget.isRtl,
                widget.picker.monthCellStyle,
                widget.picker.enableMultiView,
                widget.picker.viewSpacing,
                todayTextColor,
                widget.textScaleFactor),
          ),
        ),
      ),
    );
  }

  void _updateTapCallback(TapUpDetails details) {
    switch (widget.controller.view) {
      case DateRangePickerView.month:
        {
          double viewHeaderHeight =
              widget.picker.monthViewSettings.viewHeaderHeight;
          if (widget.picker.navigationDirection ==
              DateRangePickerNavigationDirection.vertical) {
            viewHeaderHeight = 0;
          }

          if (details.localPosition.dy < viewHeaderHeight) {
            return;
          }

          if (details.localPosition.dy > viewHeaderHeight) {
            _handleTouch(
                Offset(details.localPosition.dx,
                    details.localPosition.dy - viewHeaderHeight),
                details);
          }
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          _handleYearPanelSelection(
              Offset(details.localPosition.dx, details.localPosition.dy));
        }
    }

    if (!widget.focusNode.hasFocus) {
      widget.focusNode.requestFocus();
    }
  }

  void _updateMouseHover(Offset globalPosition) {
    final RenderBox box = context.findRenderObject();
    final Offset localPosition = box.globalToLocal(globalPosition);
    final double viewHeaderHeight =
        widget.controller.view == DateRangePickerView.month
            ? widget.picker.monthViewSettings.viewHeaderHeight
            : 0;
    final double xPosition = localPosition.dx;
    final double yPosition = localPosition.dy - viewHeaderHeight;

    if (localPosition.dy < viewHeaderHeight) {
      return;
    }

    setState(() {
      _mouseHoverPosition = Offset(xPosition, yPosition);
    });
  }

  void _pointerEnterEvent(PointerEnterEvent event) {
    _updateMouseHover(event.position);
  }

  void _pointerHoverEvent(PointerHoverEvent event) {
    _updateMouseHover(event.position);
  }

  void _pointerExitEvent(PointerExitEvent event) {
    setState(() {
      _mouseHoverPosition = null;
    });
  }

  Widget _addYearView(Locale locale) {
    _yearView = _getYearView(locale);
    return RepaintBoundary(
      child: CustomPaint(
        painter: _yearView,
        size: Size(widget.width, widget.height),
      ),
    );
  }

  _IPickerYearView _getYearView(Locale locale) {
    switch (widget.controller.view) {
      case DateRangePickerView.year:
        {
          return _PickerYearViewPainter(
              widget.visibleDates,
              widget.picker.yearCellStyle,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.picker.todayHighlightColor,
              widget.picker.selectionShape,
              widget.picker.monthFormat,
              widget.isRtl,
              widget.datePickerTheme,
              locale,
              _mouseHoverPosition,
              widget.picker.enableMultiView,
              widget.picker.viewSpacing,
              widget.picker.selectionTextStyle,
              widget.picker.rangeTextStyle,
              widget.picker.selectionColor,
              widget.picker.startRangeSelectionColor,
              widget.picker.endRangeSelectionColor,
              widget.picker.rangeSelectionColor,
              !widget.picker.allowViewNavigation
                  ? _getSelectedValue(
                      widget.picker.selectionMode, _pickerStateDetails)
                  : null,
              widget.picker.selectionMode,
              widget.picker.selectionRadius,
              ValueNotifier<bool>(false),
              widget.textScaleFactor);
        }
      case DateRangePickerView.decade:
        {
          return _PickerDecadeViewPainter(
              widget.visibleDates,
              widget.picker.yearCellStyle,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.picker.todayHighlightColor,
              widget.picker.selectionShape,
              widget.isRtl,
              widget.datePickerTheme,
              locale,
              _mouseHoverPosition,
              widget.picker.enableMultiView,
              widget.picker.viewSpacing,
              widget.picker.selectionTextStyle,
              widget.picker.rangeTextStyle,
              widget.picker.selectionColor,
              widget.picker.startRangeSelectionColor,
              widget.picker.endRangeSelectionColor,
              widget.picker.rangeSelectionColor,
              !widget.picker.allowViewNavigation
                  ? _getSelectedValue(
                      widget.picker.selectionMode, _pickerStateDetails)
                  : null,
              widget.picker.selectionMode,
              widget.picker.selectionRadius,
              ValueNotifier<bool>(false),
              widget.textScaleFactor);
        }
      case DateRangePickerView.century:
        {
          return _PickerCenturyViewPainter(
              widget.visibleDates,
              widget.picker.yearCellStyle,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.picker.todayHighlightColor,
              widget.picker.selectionShape,
              widget.isRtl,
              widget.datePickerTheme,
              locale,
              _mouseHoverPosition,
              widget.picker.enableMultiView,
              widget.picker.viewSpacing,
              widget.picker.selectionTextStyle,
              widget.picker.rangeTextStyle,
              widget.picker.selectionColor,
              widget.picker.startRangeSelectionColor,
              widget.picker.endRangeSelectionColor,
              widget.picker.rangeSelectionColor,
              !widget.picker.allowViewNavigation
                  ? _getSelectedValue(
                      widget.picker.selectionMode, _pickerStateDetails)
                  : null,
              widget.picker.selectionMode,
              widget.picker.selectionRadius,
              ValueNotifier<bool>(false),
              widget.textScaleFactor);
        }
      case DateRangePickerView.month:
        {
          return null;
        }
    }

    return null;
  }

  GestureDragStartCallback _getDragStartCallback() {
    //// return drag start start event when selection mode as range or multi range.
    if ((widget.controller.view != DateRangePickerView.month &&
            widget.picker.allowViewNavigation) ||
        !widget.picker.monthViewSettings.enableSwipeSelection) {
      return null;
    }

    if (widget.picker.selectionMode != DateRangePickerSelectionMode.range &&
        widget.picker.selectionMode !=
            DateRangePickerSelectionMode.multiRange) {
      return null;
    }

    switch (widget.controller.view) {
      case DateRangePickerView.month:
        {
          return _dragStart;
        }
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        return _dragStartOnYear;
    }

    return null;
  }

  GestureDragUpdateCallback _getDragUpdateCallback() {
    //// return drag update start event when selection mode as range or multi range.
    if ((widget.controller.view != DateRangePickerView.month &&
            widget.picker.allowViewNavigation) ||
        !widget.picker.monthViewSettings.enableSwipeSelection) {
      return null;
    }

    if (widget.picker.selectionMode != DateRangePickerSelectionMode.range &&
        widget.picker.selectionMode !=
            DateRangePickerSelectionMode.multiRange) {
      return null;
    }

    switch (widget.controller.view) {
      case DateRangePickerView.month:
        {
          return _dragUpdate;
        }
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          return _dragUpdateOnYear;
        }
    }

    return null;
  }

  int _getYearViewIndex(double xPosition, double yPosition) {
    int rowIndex, columnIndex;
    int columnCount = _IPickerYearView._maxColumnCount;
    double width = widget.width;
    int index = -1;
    if (widget.picker.enableMultiView) {
      columnCount *= 2;
      width -= widget.picker.viewSpacing;
      if (xPosition > width / 2 &&
          xPosition < (width / 2) + widget.picker.viewSpacing) {
        return index;
      } else if (xPosition > width / 2) {
        xPosition -= widget.picker.viewSpacing;
      }
    }

    final double cellWidth = width / columnCount;
    final double cellHeight = widget.height / _IPickerYearView._maxRowCount;
    if (yPosition < 0 || xPosition < 0) {
      return index;
    }

    rowIndex = xPosition ~/ cellWidth;
    if (rowIndex >= columnCount) {
      rowIndex = columnCount - 1;
    } else if (rowIndex < 0) {
      return index;
    }

    if (widget.isRtl) {
      rowIndex = _getRtlIndex(columnCount, rowIndex);
    }

    columnIndex = yPosition ~/ cellHeight;
    if (columnIndex >= _IPickerYearView._maxRowCount) {
      columnIndex = _IPickerYearView._maxRowCount - 1;
    } else if (columnIndex < 0) {
      return index;
    }

    const int totalDatesCount =
        _IPickerYearView._maxRowCount * _IPickerYearView._maxColumnCount;
    index = (columnIndex * _IPickerYearView._maxColumnCount) +
        ((rowIndex ~/ _IPickerYearView._maxColumnCount) * totalDatesCount) +
        (rowIndex % _IPickerYearView._maxColumnCount);
    return widget.picker.enableMultiView &&
            _yearView._isTrailingDate(
                index, (index ~/ totalDatesCount) * totalDatesCount)
        ? -1
        : index;
  }

  int _getSelectedIndex(double xPosition, double yPosition) {
    int rowIndex, columnIndex;
    double width = widget.width;
    int index = -1;
    int totalColumnCount = _kNumberOfDaysInWeek;
    if (widget.picker.enableMultiView) {
      width -= widget.picker.viewSpacing;
      totalColumnCount *= 2;
      if (xPosition > width / 2 &&
          xPosition < (width / 2) + widget.picker.viewSpacing) {
        return index;
      } else if (xPosition > width / 2) {
        xPosition -= widget.picker.viewSpacing;
      }
    }

    if (yPosition < 0 || xPosition < 0) {
      return index;
    }

    double viewHeaderHeight = widget.picker.monthViewSettings.viewHeaderHeight;
    if (widget.controller.view == DateRangePickerView.month &&
        widget.picker.navigationDirection ==
            DateRangePickerNavigationDirection.vertical) {
      viewHeaderHeight = 0;
    }

    final double cellWidth = width / totalColumnCount;
    final double cellHeight = (widget.height - viewHeaderHeight) /
        widget.picker.monthViewSettings.numberOfWeeksInView;
    rowIndex = (xPosition / cellWidth).truncate();
    if (rowIndex >= totalColumnCount) {
      rowIndex = totalColumnCount - 1;
    } else if (rowIndex < 0) {
      return index;
    }

    if (widget.isRtl) {
      rowIndex = _getRtlIndex(totalColumnCount, rowIndex);
    }

    columnIndex = (yPosition / cellHeight).truncate();
    if (columnIndex >= widget.picker.monthViewSettings.numberOfWeeksInView) {
      columnIndex = widget.picker.monthViewSettings.numberOfWeeksInView - 1;
    } else if (columnIndex < 0) {
      return index;
    }

    index = (columnIndex * _kNumberOfDaysInWeek) +
        ((rowIndex ~/ _kNumberOfDaysInWeek) *
            (widget.picker.monthViewSettings.numberOfWeeksInView *
                _kNumberOfDaysInWeek)) +
        (rowIndex % _kNumberOfDaysInWeek);
    return index;
  }

  void _dragStart(DragStartDetails details) {
    //// Set drag start value as false, identifies the start date of the range not updated.
    _isDragStart = false;
    widget.getPickerStateDetails(_pickerStateDetails);
    final double xPosition = details.localPosition.dx;
    double yPosition = details.localPosition.dy;
    if (widget.controller.view == DateRangePickerView.month &&
        widget.picker.navigationDirection ==
            DateRangePickerNavigationDirection.horizontal) {
      yPosition = details.localPosition.dy -
          widget.picker.monthViewSettings.viewHeaderHeight;
    }

    final int index = _getSelectedIndex(xPosition, yPosition);
    if (index == -1) {
      return;
    }

    final DateTime selectedDate = widget.visibleDates[index];
    if (!_isEnabledDate(widget.picker.minDate, widget.picker.maxDate,
        widget.picker.enablePastDates, selectedDate)) {
      return;
    }

    final int currentMonthIndex = _getCurrentDateIndex(index);
    if (!_isDateAsCurrentMonthDate(
        widget.visibleDates[currentMonthIndex],
        widget.picker.monthViewSettings.numberOfWeeksInView,
        widget.picker.monthViewSettings.showTrailingAndLeadingDates,
        selectedDate)) {
      return;
    }

    if (_isDateWithInVisibleDates(widget.visibleDates,
        widget.picker.monthViewSettings.blackoutDates, selectedDate)) {
      return;
    }

    //// Set drag start value as false, identifies the start date of the range updated.
    _isDragStart = true;
    _updateSelectedRangesOnDragStart(_monthView, selectedDate);

    /// Assign start date of the range as previous selected date.
    _previousSelectedDate = selectedDate;

    widget.updatePickerStateDetails(_pickerStateDetails);
  }

  void _dragUpdate(DragUpdateDetails details) {
    widget.getPickerStateDetails(_pickerStateDetails);
    final double xPosition = details.localPosition.dx;
    double yPosition = details.localPosition.dy;
    if (widget.controller.view == DateRangePickerView.month &&
        widget.picker.navigationDirection ==
            DateRangePickerNavigationDirection.horizontal) {
      yPosition = details.localPosition.dy -
          widget.picker.monthViewSettings.viewHeaderHeight;
    }

    final int index = _getSelectedIndex(xPosition, yPosition);
    if (index == -1) {
      return;
    }

    final DateTime selectedDate = widget.visibleDates[index];
    if (!_isEnabledDate(widget.picker.minDate, widget.picker.maxDate,
        widget.picker.enablePastDates, selectedDate)) {
      return;
    }

    final int currentMonthIndex = _getCurrentDateIndex(index);
    if (!_isDateAsCurrentMonthDate(
        widget.visibleDates[currentMonthIndex],
        widget.picker.monthViewSettings.numberOfWeeksInView,
        widget.picker.monthViewSettings.showTrailingAndLeadingDates,
        selectedDate)) {
      return;
    }

    if (_isDateWithInVisibleDates(widget.visibleDates,
        widget.picker.monthViewSettings.blackoutDates, selectedDate)) {
      return;
    }

    _updateSelectedRangesOnDragUpdateMonth(selectedDate);

    /// Assign start date of the range as previous selected date.
    _previousSelectedDate = selectedDate;

    //// Set drag start value as false, identifies the start date of the range updated.
    _isDragStart = true;
    widget.updatePickerStateDetails(_pickerStateDetails);
  }

  void _updateSelectedRangesOnDragStart(dynamic view, DateTime selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
      case DateRangePickerSelectionMode.multiple:
        break;
      case DateRangePickerSelectionMode.range:
        {
          _pickerStateDetails._selectedRange =
              PickerDateRange(selectedDate, null);
          view._updateSelection(_pickerStateDetails);
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          _pickerStateDetails._selectedRanges ??= <PickerDateRange>[];
          _pickerStateDetails._selectedRanges
              .add(PickerDateRange(selectedDate, null));
          _removeInterceptRanges(
              _pickerStateDetails._selectedRanges,
              _pickerStateDetails._selectedRanges[
                  _pickerStateDetails._selectedRanges.length - 1]);
          view._updateSelection(_pickerStateDetails);
        }
    }
  }

  void _updateSelectedRangesOnDragUpdateMonth(DateTime selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
      case DateRangePickerSelectionMode.multiple:
        break;
      case DateRangePickerSelectionMode.range:
        {
          //// Check the start date of the range updated or not, if not updated then create the new range.
          if (!_isDragStart) {
            _pickerStateDetails._selectedRange =
                PickerDateRange(selectedDate, null);
          } else {
            if (_pickerStateDetails._selectedRange != null &&
                _pickerStateDetails._selectedRange.startDate != null) {
              final PickerDateRange updatedRange =
                  _getSelectedRangeOnDragUpdate(
                      _pickerStateDetails._selectedRange, selectedDate);
              if (_isRangeEquals(
                  _pickerStateDetails._selectedRange, updatedRange)) {
                return;
              }

              _pickerStateDetails._selectedRange = updatedRange;
            } else {
              _pickerStateDetails._selectedRange =
                  PickerDateRange(selectedDate, null);
            }
          }
          _monthView._updateSelection(_pickerStateDetails);
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          _pickerStateDetails._selectedRanges ??= <PickerDateRange>[];
          final int count = _pickerStateDetails._selectedRanges.length;
          PickerDateRange _lastRange;
          if (count > 0) {
            _lastRange = _pickerStateDetails._selectedRanges[count - 1];
          }

          //// Check the start date of the range updated or not, if not updated then create the new range.
          if (!_isDragStart) {
            _pickerStateDetails._selectedRanges
                .add(PickerDateRange(selectedDate, null));
          } else {
            if (_lastRange != null && _lastRange.startDate != null) {
              final PickerDateRange updatedRange =
                  _getSelectedRangeOnDragUpdate(_lastRange, selectedDate);
              if (_isRangeEquals(_lastRange, updatedRange)) {
                return;
              }

              _pickerStateDetails._selectedRanges[count - 1] = updatedRange;
            } else {
              _pickerStateDetails._selectedRanges
                  .add(PickerDateRange(selectedDate, null));
            }
          }

          _removeInterceptRanges(
              _pickerStateDetails._selectedRanges,
              _pickerStateDetails._selectedRanges[
                  _pickerStateDetails._selectedRanges.length - 1]);
          _monthView._updateSelection(_pickerStateDetails);
        }
    }
  }

  /// Return the range that start date is before of end date in month view.
  PickerDateRange _getSelectedRangeOnDragUpdate(
      PickerDateRange previousRange, DateTime selectedDate) {
    final DateTime previousRangeStartDate = previousRange.startDate;
    final DateTime previousRangeEndDate =
        previousRange.endDate ?? previousRange.startDate;
    DateTime rangeStartDate = previousRangeStartDate;
    DateTime rangeEndDate = selectedDate;
    if (isSameDate(previousRangeStartDate, _previousSelectedDate)) {
      if (isSameOrBeforeDate(previousRangeEndDate, rangeEndDate)) {
        rangeStartDate = selectedDate;
        rangeEndDate = previousRangeEndDate;
      } else {
        rangeStartDate = previousRangeEndDate;
        rangeEndDate = selectedDate;
      }
    } else if (isSameDate(previousRangeEndDate, _previousSelectedDate)) {
      if (isSameOrAfterDate(previousRangeStartDate, rangeEndDate)) {
        rangeStartDate = previousRangeStartDate;
        rangeEndDate = selectedDate;
      } else {
        rangeStartDate = selectedDate;
        rangeEndDate = previousRangeStartDate;
      }
    }

    return PickerDateRange(rangeStartDate, rangeEndDate);
  }

  /// Return the range that start date is before of end date in year view.
  PickerDateRange _getSelectedRangeOnDragUpdateYear(
      PickerDateRange previousRange, DateTime selectedDate) {
    final DateTime previousRangeStartDate = previousRange.startDate;
    final DateTime previousRangeEndDate =
        previousRange.endDate ?? previousRange.startDate;
    DateTime rangeStartDate = previousRangeStartDate;
    DateTime rangeEndDate = selectedDate;
    if (_yearView._isSameView(previousRangeStartDate, _previousSelectedDate)) {
      if (_yearView._isSameOrBeforeView(previousRangeEndDate, rangeEndDate)) {
        rangeStartDate = selectedDate;
        rangeEndDate = previousRangeEndDate;
      } else {
        rangeStartDate = previousRangeEndDate;
        rangeEndDate = selectedDate;
      }
    } else if (_yearView._isSameView(
        previousRangeEndDate, _previousSelectedDate)) {
      if (_yearView._isSameOrAfterView(previousRangeStartDate, rangeEndDate)) {
        rangeStartDate = previousRangeStartDate;
        rangeEndDate = selectedDate;
      } else {
        rangeStartDate = selectedDate;
        rangeEndDate = previousRangeStartDate;
      }
    }

    rangeEndDate = _getLastDate(_pickerStateDetails._view, rangeEndDate);
    if (widget.picker.maxDate != null) {
      rangeEndDate = rangeEndDate.isAfter(widget.picker.maxDate)
          ? widget.picker.maxDate
          : rangeEndDate;
    }
    rangeStartDate = _getFirstDate(_pickerStateDetails._view, rangeStartDate);
    if (widget.picker.minDate != null) {
      rangeStartDate = rangeStartDate.isBefore(widget.picker.minDate)
          ? widget.picker.minDate
          : rangeStartDate;
    }
    return PickerDateRange(rangeStartDate, rangeEndDate);
  }

  void _updateSelectedRangesOnDragUpdateYear(DateTime selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
      case DateRangePickerSelectionMode.multiple:
        break;
      case DateRangePickerSelectionMode.range:
        {
          //// Check the start date of the range updated or not, if not updated then create the new range.
          if (!_isDragStart) {
            _pickerStateDetails._selectedRange =
                PickerDateRange(selectedDate, null);
          } else {
            if (_pickerStateDetails._selectedRange != null &&
                _pickerStateDetails._selectedRange.startDate != null) {
              final PickerDateRange updatedRange =
                  _getSelectedRangeOnDragUpdateYear(
                      _pickerStateDetails._selectedRange, selectedDate);
              if (_isRangeEquals(
                  _pickerStateDetails._selectedRange, updatedRange)) {
                return;
              }

              _pickerStateDetails._selectedRange = updatedRange;
            } else {
              _pickerStateDetails._selectedRange =
                  PickerDateRange(selectedDate, null);
            }
          }
          _yearView._updateSelection(_pickerStateDetails);
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          _pickerStateDetails._selectedRanges ??= <PickerDateRange>[];
          final int count = _pickerStateDetails._selectedRanges.length;
          PickerDateRange _lastRange;
          if (count > 0) {
            _lastRange = _pickerStateDetails._selectedRanges[count - 1];
          }

          //// Check the start date of the range updated or not, if not updated then create the new range.
          if (!_isDragStart) {
            _pickerStateDetails._selectedRanges
                .add(PickerDateRange(selectedDate, null));
          } else {
            if (_lastRange != null && _lastRange.startDate != null) {
              final PickerDateRange updatedRange =
                  _getSelectedRangeOnDragUpdateYear(_lastRange, selectedDate);
              if (_isRangeEquals(_lastRange, updatedRange)) {
                return;
              }

              _pickerStateDetails._selectedRanges[count - 1] = updatedRange;
            } else {
              _pickerStateDetails._selectedRanges
                  .add(PickerDateRange(selectedDate, null));
            }
          }

          _removeInterceptRanges(
              _pickerStateDetails._selectedRanges,
              _pickerStateDetails._selectedRanges[
                  _pickerStateDetails._selectedRanges.length - 1]);
          _yearView._updateSelection(_pickerStateDetails);
        }
    }
  }

  void _dragStartOnYear(DragStartDetails details) {
    //// Set drag start value as false, identifies the start date of the range not updated.
    _isDragStart = false;
    widget.getPickerStateDetails(_pickerStateDetails);
    final int index =
        _getYearViewIndex(details.localPosition.dx, details.localPosition.dy);
    if (index == -1) {
      return;
    }

    final DateTime selectedDate = widget.visibleDates[index];
    if (!_yearView._isBetweenMinMaxMonth(selectedDate)) {
      return;
    }

    //// Set drag start value as false, identifies the start date of the range updated.
    _isDragStart = true;
    _updateSelectedRangesOnDragStart(_yearView, selectedDate);
    _previousSelectedDate = selectedDate;

    widget.updatePickerStateDetails(_pickerStateDetails);
  }

  void _dragUpdateOnYear(DragUpdateDetails details) {
    widget.getPickerStateDetails(_pickerStateDetails);
    final int index =
        _getYearViewIndex(details.localPosition.dx, details.localPosition.dy);
    if (index == -1) {
      return;
    }

    final DateTime selectedDate = widget.visibleDates[index];
    if (!_yearView._isBetweenMinMaxMonth(selectedDate)) {
      return;
    }

    _updateSelectedRangesOnDragUpdateYear(selectedDate);
    _previousSelectedDate = selectedDate;

    //// Set drag start value as false, identifies the start date of the range updated.
    _isDragStart = true;
    widget.updatePickerStateDetails(_pickerStateDetails);
  }

  void _handleTouch(Offset details, TapUpDetails tapUpDetails) {
    widget.getPickerStateDetails(_pickerStateDetails);
    if (widget.controller.view == DateRangePickerView.month) {
      final int index = _getSelectedIndex(details.dx, details.dy);
      if (index == -1) {
        return;
      }

      final DateTime selectedDate = widget.visibleDates[index];
      if (!_isEnabledDate(widget.picker.minDate, widget.picker.maxDate,
          widget.picker.enablePastDates, selectedDate)) {
        return;
      }

      final int currentMonthIndex = _getCurrentDateIndex(index);
      if (!_isDateAsCurrentMonthDate(
          widget.visibleDates[currentMonthIndex],
          widget.picker.monthViewSettings.numberOfWeeksInView,
          widget.picker.monthViewSettings.showTrailingAndLeadingDates,
          selectedDate)) {
        return;
      }

      if (_isDateWithInVisibleDates(widget.visibleDates,
          widget.picker.monthViewSettings.blackoutDates, selectedDate)) {
        return;
      }

      _drawSelection(selectedDate);
      widget.updatePickerStateDetails(_pickerStateDetails);
    }
  }

  int _getCurrentDateIndex(int index) {
    final int datesCount = widget.picker.monthViewSettings.numberOfWeeksInView *
        _kNumberOfDaysInWeek;
    int currentMonthIndex = datesCount ~/ 2;
    if (widget.picker.enableMultiView && index >= datesCount) {
      currentMonthIndex += datesCount;
    }

    return currentMonthIndex;
  }

  void _drawSingleSelectionForYear(DateTime selectedDate) {
    if (widget.picker.toggleDaySelection &&
        _yearView._isSameView(
            selectedDate, _pickerStateDetails._selectedDate)) {
      selectedDate = null;
    }

    _pickerStateDetails._selectedDate = selectedDate;
  }

  void _drawMultipleSelectionForYear(DateTime selectedDate) {
    int selectedIndex = -1;
    if (_pickerStateDetails._selectedDates != null &&
        _pickerStateDetails._selectedDates.isNotEmpty) {
      selectedIndex = _getYearCellIndex(
          _pickerStateDetails._selectedDates, selectedDate, _yearView);
    }

    if (selectedIndex == -1) {
      _pickerStateDetails._selectedDates ??= <DateTime>[];
      _pickerStateDetails._selectedDates.add(selectedDate);
    } else {
      _pickerStateDetails._selectedDates.removeAt(selectedIndex);
    }
  }

  void _drawRangeSelectionForYear(DateTime selectedDate) {
    if (_pickerStateDetails._selectedRange != null &&
        _pickerStateDetails._selectedRange.startDate != null &&
        (_pickerStateDetails._selectedRange.endDate == null ||
            _yearView._isSameView(_pickerStateDetails._selectedRange.startDate,
                _pickerStateDetails._selectedRange.endDate))) {
      DateTime startDate = _pickerStateDetails._selectedRange.startDate;
      DateTime endDate = selectedDate;
      if (startDate.isAfter(endDate)) {
        final DateTime temp = startDate;
        startDate = endDate;
        endDate = temp;
      }

      endDate = _getLastDate(_pickerStateDetails._view, endDate);
      if (widget.picker.maxDate != null) {
        endDate = endDate.isAfter(widget.picker.maxDate)
            ? widget.picker.maxDate
            : endDate;
      }

      if (widget.picker.minDate != null) {
        startDate = startDate.isBefore(widget.picker.minDate)
            ? widget.picker.minDate
            : startDate;
      }

      _pickerStateDetails._selectedRange = PickerDateRange(startDate, endDate);
    } else {
      _pickerStateDetails._selectedRange = PickerDateRange(selectedDate, null);
    }
  }

  void _drawRangesSelectionForYear(DateTime selectedDate) {
    _pickerStateDetails._selectedRanges ??= <PickerDateRange>[];
    int count = _pickerStateDetails._selectedRanges.length;
    PickerDateRange _lastRange;
    if (count > 0) {
      _lastRange = _pickerStateDetails._selectedRanges[count - 1];
    }

    if (_lastRange != null &&
        _lastRange.startDate != null &&
        (_lastRange.endDate == null ||
            _yearView._isSameView(_lastRange.startDate, _lastRange.endDate))) {
      DateTime startDate = _lastRange.startDate;
      DateTime endDate = selectedDate;
      if (startDate.isAfter(endDate)) {
        final DateTime temp = startDate;
        startDate = endDate;
        endDate = temp;
      }

      endDate = _getLastDate(_pickerStateDetails._view, endDate);
      if (widget.picker.maxDate != null) {
        endDate = endDate.isAfter(widget.picker.maxDate)
            ? widget.picker.maxDate
            : endDate;
      }

      if (widget.picker.minDate != null) {
        startDate = startDate.isBefore(widget.picker.minDate)
            ? widget.picker.minDate
            : startDate;
      }

      final PickerDateRange newRange = PickerDateRange(startDate, endDate);
      _pickerStateDetails._selectedRanges[count - 1] = newRange;
    } else {
      _pickerStateDetails._selectedRanges
          .add(PickerDateRange(selectedDate, null));
    }

    count = _pickerStateDetails._selectedRanges.length;
    _removeInterceptRanges(
        _pickerStateDetails._selectedRanges,
        _pickerStateDetails
            ._selectedRanges[_pickerStateDetails._selectedRanges.length - 1]);
    _lastRange = _pickerStateDetails
        ._selectedRanges[_pickerStateDetails._selectedRanges.length - 1];
    if (count != _pickerStateDetails._selectedRanges.length &&
        (_lastRange.endDate == null ||
            _yearView._isSameView(_lastRange.endDate, _lastRange.startDate))) {
      _pickerStateDetails._selectedRanges.removeLast();
    }
  }

  void _drawYearSelection(DateTime selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        _drawSingleSelectionForYear(selectedDate);
        break;
      case DateRangePickerSelectionMode.multiple:
        _drawMultipleSelectionForYear(selectedDate);
        break;
      case DateRangePickerSelectionMode.range:
        _drawRangeSelectionForYear(selectedDate);
        break;
      case DateRangePickerSelectionMode.multiRange:
        _drawRangesSelectionForYear(selectedDate);
    }

    _yearView._updateSelection(_pickerStateDetails);
  }

  void _handleYearPanelSelection(Offset details) {
    final int _selectedIndex = _getYearViewIndex(details.dx, details.dy);
    final int viewCount = widget.picker.enableMultiView ? 2 : 1;
    if (_selectedIndex == -1 || _selectedIndex >= 12 * viewCount) {
      return;
    }

    final DateTime date = widget.visibleDates[_selectedIndex];
    widget.getPickerStateDetails(_pickerStateDetails);
    if (!widget.picker.allowViewNavigation) {
      if (!_yearView._isBetweenMinMaxMonth(date)) {
        return;
      }

      _drawYearSelection(date);
      widget.updatePickerStateDetails(_pickerStateDetails);
      return;
    }

    switch (widget.controller.view) {
      case DateRangePickerView.month:
        break;
      case DateRangePickerView.century:
        {
          final int year = date.year ~/ 10;
          final int minYear = widget.picker.minDate.year ~/ 10;
          final int maxYear = widget.picker.maxDate.year ~/ 10;
          if (year < minYear || year > maxYear) {
            return;
          }

          _pickerStateDetails._view = DateRangePickerView.decade;
        }
        break;
      case DateRangePickerView.decade:
        {
          final int year = date.year;
          if (year < widget.picker.minDate.year ||
              year > widget.picker.maxDate.year) {
            return;
          }

          _pickerStateDetails._view = DateRangePickerView.year;
        }
        break;
      case DateRangePickerView.year:
        {
          final int year = date.year;
          final int month = date.month;
          final int minYear = widget.picker.minDate.year;
          final int maxYear = widget.picker.maxDate.year;
          if ((year < minYear ||
                  (year == minYear && month < widget.picker.minDate.month)) ||
              (year > maxYear ||
                  (year == maxYear && month > widget.picker.maxDate.month))) {
            return;
          }

          _pickerStateDetails._view = DateRangePickerView.month;
        }
    }

    _pickerStateDetails._currentDate = date;
    widget.updatePickerStateDetails(_pickerStateDetails);
  }

  void _drawSingleSelectionForMonth(DateTime selectedDate) {
    if (widget.picker.toggleDaySelection &&
        isSameDate(selectedDate, _pickerStateDetails._selectedDate)) {
      selectedDate = null;
    }

    _pickerStateDetails._selectedDate = selectedDate;
    _monthView._updateSelection(_pickerStateDetails);
  }

  void _drawMultipleSelectionForMonth(DateTime selectedDate) {
    final int selectedIndex = _isDateIndexInCollection(
        _pickerStateDetails._selectedDates, selectedDate);
    if (selectedIndex == -1) {
      _pickerStateDetails._selectedDates ??= <DateTime>[];
      _pickerStateDetails._selectedDates.add(selectedDate);
    } else {
      _pickerStateDetails._selectedDates.removeAt(selectedIndex);
    }

    _monthView._updateSelection(_pickerStateDetails);
  }

  void _drawRangeSelectionForMonth(DateTime selectedDate) {
    if (_pickerStateDetails._selectedRange != null &&
        _pickerStateDetails._selectedRange.startDate != null &&
        (_pickerStateDetails._selectedRange.endDate == null ||
            isSameDate(_pickerStateDetails._selectedRange.startDate,
                _pickerStateDetails._selectedRange.endDate))) {
      DateTime startDate = _pickerStateDetails._selectedRange.startDate;
      DateTime endDate = selectedDate;
      if (startDate.isAfter(endDate)) {
        final DateTime temp = startDate;
        startDate = endDate;
        endDate = temp;
      }

      _pickerStateDetails._selectedRange = PickerDateRange(startDate, endDate);
    } else {
      _pickerStateDetails._selectedRange = PickerDateRange(selectedDate, null);
    }

    _monthView._updateSelection(_pickerStateDetails);
  }

  void _drawRangesSelectionForMonth(DateTime selectedDate) {
    _pickerStateDetails._selectedRanges ??= <PickerDateRange>[];
    int count = _pickerStateDetails._selectedRanges.length;
    PickerDateRange lastRange;
    if (count > 0) {
      lastRange = _pickerStateDetails._selectedRanges[count - 1];
    }

    if (lastRange != null &&
        lastRange.startDate != null &&
        (lastRange.endDate == null ||
            isSameDate(lastRange.startDate, lastRange.endDate))) {
      DateTime startDate = lastRange.startDate;
      DateTime endDate = selectedDate;
      if (startDate.isAfter(endDate)) {
        final DateTime temp = startDate;
        startDate = endDate;
        endDate = temp;
      }

      final PickerDateRange _newRange = PickerDateRange(startDate, endDate);
      _pickerStateDetails._selectedRanges[count - 1] = _newRange;
    } else {
      _pickerStateDetails._selectedRanges
          .add(PickerDateRange(selectedDate, null));
    }

    count = _pickerStateDetails._selectedRanges.length;
    _removeInterceptRanges(
        _pickerStateDetails._selectedRanges,
        _pickerStateDetails
            ._selectedRanges[_pickerStateDetails._selectedRanges.length - 1]);
    lastRange = _pickerStateDetails
        ._selectedRanges[_pickerStateDetails._selectedRanges.length - 1];
    if (count != _pickerStateDetails._selectedRanges.length &&
        (lastRange.endDate == null ||
            isSameDate(lastRange.endDate, lastRange.startDate))) {
      _pickerStateDetails._selectedRanges.removeLast();
    }

    _monthView._updateSelection(_pickerStateDetails);
  }

  void _drawSelection(DateTime selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        _drawSingleSelectionForMonth(selectedDate);
        break;
      case DateRangePickerSelectionMode.multiple:
        _drawMultipleSelectionForMonth(selectedDate);
        break;
      case DateRangePickerSelectionMode.range:
        _drawRangeSelectionForMonth(selectedDate);
        break;
      case DateRangePickerSelectionMode.multiRange:
        _drawRangesSelectionForMonth(selectedDate);
    }
  }

  int _removeInterceptRangesForMonth(PickerDateRange range, DateTime startDate,
      DateTime endDate, int i, PickerDateRange selectedRangeValue) {
    if (range != null &&
        !_isRangeEquals(range, selectedRangeValue) &&
        ((range.startDate != null &&
                ((startDate != null &&
                        isSameDate(range.startDate, startDate)) ||
                    (endDate != null &&
                        isSameDate(range.startDate, endDate)))) ||
            (range.endDate != null &&
                ((startDate != null && isSameDate(range.endDate, startDate)) ||
                    (endDate != null && isSameDate(range.endDate, endDate)))) ||
            (range.startDate != null &&
                range.endDate != null &&
                ((startDate != null &&
                        isDateWithInDateRange(
                            range.startDate, range.endDate, startDate)) ||
                    (endDate != null &&
                        isDateWithInDateRange(
                            range.startDate, range.endDate, endDate)))) ||
            (startDate != null &&
                endDate != null &&
                ((range.startDate != null &&
                        isDateWithInDateRange(
                            startDate, endDate, range.startDate)) ||
                    (range.endDate != null &&
                        isDateWithInDateRange(
                            startDate, endDate, range.endDate)))) ||
            (range.startDate != null &&
                range.endDate != null &&
                startDate != null &&
                endDate != null &&
                ((range.startDate.isAfter(startDate) &&
                        range.endDate.isBefore(endDate)) ||
                    (range.endDate.isAfter(startDate) &&
                        range.startDate.isBefore(endDate)))))) {
      return i;
    }

    return null;
  }

  int _removeInterceptRangesForYear(PickerDateRange range, DateTime startDate,
      DateTime endDate, int i, PickerDateRange selectedRangeValue) {
    if (range != null &&
        !_isRangeEquals(range, selectedRangeValue) &&
        ((range.startDate != null &&
                ((startDate != null &&
                        _yearView._isSameView(range.startDate, startDate)) ||
                    (endDate != null &&
                        _yearView._isSameView(range.startDate, endDate)))) ||
            (range.endDate != null &&
                ((startDate != null &&
                        _yearView._isSameView(range.endDate, startDate)) ||
                    (endDate != null &&
                        _yearView._isSameView(range.endDate, endDate)))) ||
            (range.startDate != null &&
                range.endDate != null &&
                ((startDate != null &&
                        _isDateWithInYearRange(range.startDate, range.endDate,
                            startDate, _yearView)) ||
                    (endDate != null &&
                        _isDateWithInYearRange(range.startDate, range.endDate,
                            endDate, _yearView)))) ||
            (startDate != null &&
                endDate != null &&
                ((range.startDate != null &&
                        _isDateWithInYearRange(
                            startDate, endDate, range.startDate, _yearView)) ||
                    (range.endDate != null &&
                        _isDateWithInYearRange(
                            startDate, endDate, range.endDate, _yearView)))) ||
            (range.startDate != null &&
                range.endDate != null &&
                startDate != null &&
                endDate != null &&
                ((range.startDate.isAfter(startDate) &&
                        range.endDate.isBefore(endDate)) ||
                    (range.endDate.isAfter(startDate) &&
                        range.startDate.isBefore(endDate)))))) {
      return i;
    }

    return null;
  }

  void _removeInterceptRanges(List<PickerDateRange> selectedRanges,
      PickerDateRange selectedRangeValue) {
    if (selectedRanges == null ||
        selectedRanges.isEmpty ||
        selectedRangeValue == null) {
      return;
    }

    DateTime startDate = selectedRangeValue.startDate;
    DateTime endDate = selectedRangeValue.endDate;
    if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
      final DateTime temp = startDate;
      startDate = endDate;
      endDate = temp;
    }

    final List<int> interceptIndex = <int>[];
    for (int i = 0; i < selectedRanges.length; i++) {
      final PickerDateRange range = selectedRanges[i];
      //// The below condition validate the following scenarios
      //// Check the range as not null and range is not a new selected range,
      //// Check the range start date as equal with selected range start or end date
      //// Check the range end date as equal with selected range start or end date
      //// Check the selected start date placed in between range start or end date
      //// Check the selected end date placed in between range start or end date
      //// Check the selected range occupies the range.
      int index;
      switch (_pickerStateDetails._view) {
        case DateRangePickerView.month:
          {
            index = _removeInterceptRangesForMonth(
                range, startDate, endDate, i, selectedRangeValue);
          }
          break;
        case DateRangePickerView.year:
        case DateRangePickerView.decade:
        case DateRangePickerView.century:
          {
            index = _removeInterceptRangesForYear(
                range, startDate, endDate, i, selectedRangeValue);
          }
      }
      if (index != null) {
        interceptIndex.add(index);
      }
    }

    interceptIndex.sort();
    for (int i = interceptIndex.length - 1; i >= 0; i--) {
      selectedRanges.removeAt(interceptIndex[i]);
    }
  }
}
