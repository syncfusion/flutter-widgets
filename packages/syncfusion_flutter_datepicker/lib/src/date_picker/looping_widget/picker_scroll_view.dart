part of datepicker;

@immutable
class _PickerScrollView extends StatefulWidget {
  const _PickerScrollView(this.picker, this.controller, this.width, this.height,
      this.isRtl, this.datePickerTheme, this.locale, this.textScaleFactor,
      {Key key, this.getPickerStateValues, this.updatePickerStateValues})
      : super(key: key);

  final SfDateRangePicker picker;
  final double width;
  final double height;
  final bool isRtl;
  final _UpdatePickerState getPickerStateValues;
  final _UpdatePickerState updatePickerStateValues;
  final DateRangePickerController controller;
  final SfDateRangePickerThemeData datePickerTheme;
  final Locale locale;
  final double textScaleFactor;

  @override
  _PickerScrollViewState createState() => _PickerScrollViewState();
}

class _PickerScrollViewState extends State<_PickerScrollView>
    with TickerProviderStateMixin {
  // three views to arrange the view in vertical/horizontal direction and handle the swiping
  _PickerView _currentView, _nextView, _previousView;

  // the three children which to be added into the layout
  List<_PickerView> _children;

  // holds the index of the current displaying view
  int _currentChildIndex;

  // _scrollStartPosition contains the touch movement starting position
  // _position contains distance that the view swiped
  double _scrollStartPosition, _position;

  // animation controller to control the animation
  AnimationController _animationController;

  // animation handled for the view swiping
  Animation<double> _animation;

  // tween animation to handle the animation
  Tween<double> _tween;

  // three visible dates for the three views, the dates will updated based on
  // the swiping in the swipe end _currentViewVisibleDates which stores the
  // visible dates of the current displaying view
  List<DateTime> _visibleDates,
      _previousViewVisibleDates,
      _nextViewVisibleDates,
      _currentViewVisibleDates;

  /// keys maintained to access the data and methods from the calendar view
  /// class.
  GlobalKey<_PickerViewState> _previousViewKey, _currentViewKey, _nextViewKey;

  _PickerStateArgs _pickerStateDetails;
  FocusNode _focusNode;

  @override
  void initState() {
    _previousViewKey = GlobalKey<_PickerViewState>();
    _currentViewKey = GlobalKey<_PickerViewState>();
    _nextViewKey = GlobalKey<_PickerViewState>();
    _focusNode = FocusNode();
    _pickerStateDetails = _PickerStateArgs();
    _currentChildIndex = 1;
    _updateVisibleDates();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: this,
        animationBehavior: AnimationBehavior.normal);
    _tween = Tween<double>(begin: 0.0, end: 0.1);
    _animation = _tween.animate(_animationController)
      ..addListener(animationListener);

    super.initState();
  }

  @override
  void didUpdateWidget(_PickerScrollView oldWidget) {
    if (widget.picker.navigationDirection !=
            oldWidget.picker.navigationDirection ||
        widget.width != oldWidget.width ||
        oldWidget.datePickerTheme != widget.datePickerTheme ||
        widget.picker.viewSpacing != oldWidget.picker.viewSpacing ||
        widget.picker.selectionMode != oldWidget.picker.selectionMode ||
        widget.height != oldWidget.height) {
      _position = 0;
      _children.clear();
    }

    if (oldWidget.textScaleFactor != widget.textScaleFactor) {
      _position = 0;
      _children.clear();
    }

    if (oldWidget.picker.controller != widget.picker.controller) {
      _position = 0;
      _updateSelectedValuesWithMinMaxDate();
      _children.clear();
      _updateVisibleDates();
    }

    if (widget.isRtl != oldWidget.isRtl ||
        widget.picker.enableMultiView != oldWidget.picker.enableMultiView) {
      _position = 0;
      _children.clear();
      _updateVisibleDates();
    }

    _updateSettings(oldWidget);

    if (widget.controller.view == DateRangePickerView.year &&
        (widget.picker.monthFormat != oldWidget.picker.monthFormat ||
            widget.picker.yearCellStyle != oldWidget.picker.yearCellStyle)) {
      _position = 0;
      _children.clear();
    }

    if (widget.picker.minDate != oldWidget.picker.minDate ||
        widget.picker.maxDate != oldWidget.picker.maxDate) {
      final DateTime previousVisibleDate = _pickerStateDetails._currentDate;
      widget.getPickerStateValues(_pickerStateDetails);
      if (!isSameDate(_pickerStateDetails._currentDate, previousVisibleDate)) {
        _updateVisibleDates();
      }

      _position = 0;
      _updateSelectedValuesWithMinMaxDate();
      _children.clear();
    }

    if (widget.picker.enablePastDates != oldWidget.picker.enablePastDates) {
      _position = 0;
      _updateSelectedValuesWithMinMaxDate();
      _children.clear();
    }

    if (widget.controller.view == DateRangePickerView.month &&
        (oldWidget.picker.monthViewSettings.viewHeaderStyle !=
                widget.picker.monthViewSettings.viewHeaderStyle ||
            oldWidget.picker.monthViewSettings.viewHeaderHeight !=
                widget.picker.monthViewSettings.viewHeaderHeight ||
            widget.picker.monthViewSettings.showTrailingAndLeadingDates !=
                oldWidget
                    .picker.monthViewSettings.showTrailingAndLeadingDates)) {
      _children.clear();
      _position = 0;
    }

    if (widget.picker.monthViewSettings.numberOfWeeksInView !=
            oldWidget.picker.monthViewSettings.numberOfWeeksInView ||
        widget.picker.monthViewSettings.firstDayOfWeek !=
            oldWidget.picker.monthViewSettings.firstDayOfWeek) {
      _updateVisibleDates();
      _position = 0;
    }

    /// Update the selection when [allowViewNavigation] property in
    /// [SfDateRangePicker] changed with current picker view not as month view.
    /// because year, decade and century views highlight selection when
    /// [allowViewNavigation] property value as false.
    if (oldWidget.picker.allowViewNavigation !=
            widget.picker.allowViewNavigation &&
        widget.controller.view != DateRangePickerView.month) {
      _drawYearSelection();
    }

    if (oldWidget.picker.controller != widget.picker.controller ||
        widget.picker.controller == null) {
      widget.getPickerStateValues(_pickerStateDetails);
      super.didUpdateWidget(oldWidget);
      return;
    }

    if (oldWidget.picker.controller.displayDate !=
            widget.picker.controller.displayDate ||
        !isSameDate(
            _pickerStateDetails._currentDate, widget.controller.displayDate)) {
      _pickerStateDetails._currentDate = widget.picker.controller.displayDate;
      _updateVisibleDates();
    }

    _drawSelection(oldWidget);

    if (widget.picker.controller.view != oldWidget.picker.controller.view ||
        _pickerStateDetails._view != widget.controller._view) {
      _pickerStateDetails._view = widget.controller._view;
      _position = 0;
      _children.clear();
      _updateVisibleDates();
    }

    widget.getPickerStateValues(_pickerStateDetails);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double leftPosition, rightPosition, topPosition, bottomPosition;
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        {
          leftPosition = leftPosition ?? -widget.width;
          rightPosition = rightPosition ?? -widget.width;
          topPosition = 0;
          bottomPosition = 0;
        }
        break;
      case DateRangePickerNavigationDirection.vertical:
        {
          leftPosition = 0;
          rightPosition = 0;
          topPosition = topPosition ?? -widget.height;
          bottomPosition = bottomPosition ?? -widget.height;
        }
    }

    return Stack(
      children: <Widget>[
        Positioned(
          left: leftPosition,
          right: rightPosition,
          bottom: bottomPosition,
          top: topPosition,
          child: GestureDetector(
            child: RawKeyboardListener(
              focusNode: _focusNode,
              onKey: _onKeyDown,
              child: CustomScrollViewerLayout(
                  _addViews(context),
                  widget.picker.navigationDirection ==
                          DateRangePickerNavigationDirection.horizontal
                      ? CustomScrollDirection.horizontal
                      : CustomScrollDirection.vertical,
                  _position,
                  _currentChildIndex),
            ),
            onHorizontalDragStart: widget.picker.navigationDirection ==
                    DateRangePickerNavigationDirection.horizontal
                ? _onHorizontalStart
                : null,
            onHorizontalDragUpdate: widget.picker.navigationDirection ==
                    DateRangePickerNavigationDirection.horizontal
                ? _onHorizontalUpdate
                : null,
            onHorizontalDragEnd: widget.picker.navigationDirection ==
                    DateRangePickerNavigationDirection.horizontal
                ? _onHorizontalEnd
                : null,
            onVerticalDragStart: widget.picker.navigationDirection ==
                    DateRangePickerNavigationDirection.vertical
                ? _onVerticalStart
                : null,
            onVerticalDragUpdate: widget.picker.navigationDirection ==
                    DateRangePickerNavigationDirection.vertical
                ? _onVerticalUpdate
                : null,
            onVerticalDragEnd: widget.picker.navigationDirection ==
                    DateRangePickerNavigationDirection.vertical
                ? _onVerticalEnd
                : null,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    if (_animation != null) {
      _animation.removeListener(animationListener);
    }
    super.dispose();
  }

  void _updateVisibleDates() {
    widget.getPickerStateValues(_pickerStateDetails);
    final DateTime currentDate = _pickerStateDetails._currentDate;
    final DateTime prevDate = _getPreviousViewStartDate(
        widget.controller.view,
        widget.picker.monthViewSettings.numberOfWeeksInView,
        _pickerStateDetails._currentDate,
        widget.isRtl);
    final DateTime nextDate = _getNextViewStartDate(
        widget.controller.view,
        widget.picker.monthViewSettings.numberOfWeeksInView,
        _pickerStateDetails._currentDate,
        widget.isRtl);

    DateTime afterNextViewDate;
    List<DateTime> afterVisibleDates;
    if (widget.picker.enableMultiView) {
      afterNextViewDate = _getNextViewStartDate(
          widget.controller.view,
          widget.picker.monthViewSettings.numberOfWeeksInView,
          widget.isRtl ? prevDate : nextDate,
          false);
    }

    switch (widget.controller.view) {
      case DateRangePickerView.month:
        {
          _visibleDates = getVisibleDates(
              currentDate,
              null,
              widget.picker.monthViewSettings.firstDayOfWeek,
              _getViewDatesCount(widget.controller.view,
                  widget.picker.monthViewSettings.numberOfWeeksInView));
          _previousViewVisibleDates = getVisibleDates(
              prevDate,
              null,
              widget.picker.monthViewSettings.firstDayOfWeek,
              _getViewDatesCount(widget.controller.view,
                  widget.picker.monthViewSettings.numberOfWeeksInView));
          _nextViewVisibleDates = getVisibleDates(
              nextDate,
              null,
              widget.picker.monthViewSettings.firstDayOfWeek,
              _getViewDatesCount(widget.controller.view,
                  widget.picker.monthViewSettings.numberOfWeeksInView));
          if (widget.picker.enableMultiView) {
            afterVisibleDates = getVisibleDates(
                afterNextViewDate,
                null,
                widget.picker.monthViewSettings.firstDayOfWeek,
                _getViewDatesCount(widget.controller.view,
                    widget.picker.monthViewSettings.numberOfWeeksInView));
          }
        }
        break;
      case DateRangePickerView.decade:
      case DateRangePickerView.year:
      case DateRangePickerView.century:
        {
          _visibleDates =
              _getVisibleYearDates(currentDate, widget.controller.view);
          _previousViewVisibleDates =
              _getVisibleYearDates(prevDate, widget.controller.view);
          _nextViewVisibleDates =
              _getVisibleYearDates(nextDate, widget.controller.view);
          if (widget.picker.enableMultiView) {
            afterVisibleDates =
                _getVisibleYearDates(afterNextViewDate, widget.controller.view);
          }
        }
    }

    if (widget.picker.enableMultiView) {
      _updateVisibleDatesForMultiView(afterVisibleDates);
    }

    _currentViewVisibleDates = _visibleDates;
    _pickerStateDetails._currentViewVisibleDates = _currentViewVisibleDates;
    widget.updatePickerStateValues(_pickerStateDetails);

    if (_currentChildIndex == 0) {
      _visibleDates = _nextViewVisibleDates;
      _nextViewVisibleDates = _previousViewVisibleDates;
      _previousViewVisibleDates = _currentViewVisibleDates;
    } else if (_currentChildIndex == 1) {
      _visibleDates = _currentViewVisibleDates;
    } else if (_currentChildIndex == 2) {
      _visibleDates = _previousViewVisibleDates;
      _previousViewVisibleDates = _nextViewVisibleDates;
      _nextViewVisibleDates = _currentViewVisibleDates;
    }
  }

  void _updateVisibleDatesForMultiView(List<DateTime> afterVisibleDates) {
    if (widget.isRtl) {
      for (int i = 0; i < _visibleDates.length; i++) {
        _nextViewVisibleDates.add(_visibleDates[i]);
      }
      for (int i = 0; i < _previousViewVisibleDates.length; i++) {
        _visibleDates.add(_previousViewVisibleDates[i]);
      }
      for (int i = 0; i < afterVisibleDates.length; i++) {
        _previousViewVisibleDates.add(afterVisibleDates[i]);
      }
    } else {
      for (int i = 0; i < _visibleDates.length; i++) {
        _previousViewVisibleDates.add(_visibleDates[i]);
      }
      for (int i = 0; i < _nextViewVisibleDates.length; i++) {
        _visibleDates.add(_nextViewVisibleDates[i]);
      }
      for (int i = 0; i < afterVisibleDates.length; i++) {
        _nextViewVisibleDates.add(afterVisibleDates[i]);
      }
    }
  }

  void _updateNextViewVisibleDates() {
    DateTime currentViewDate = _currentViewVisibleDates[0];
    if ((widget.controller.view == DateRangePickerView.month &&
            widget.picker.monthViewSettings.numberOfWeeksInView == 6) ||
        widget.controller.view == DateRangePickerView.year ||
        widget.controller.view == DateRangePickerView.decade ||
        widget.controller.view == DateRangePickerView.century) {
      currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length /
                  (widget.picker.enableMultiView ? 4 : 2))
              .truncate()];
    }

    currentViewDate = _getNextViewStartDate(
        widget.controller.view,
        widget.picker.monthViewSettings.numberOfWeeksInView,
        currentViewDate,
        widget.isRtl);
    List<DateTime> afterVisibleDates;
    DateTime afterNextViewDate;
    if (widget.picker.enableMultiView && !widget.isRtl) {
      afterNextViewDate = _getNextViewStartDate(
          widget.controller.view,
          widget.picker.monthViewSettings.numberOfWeeksInView,
          currentViewDate,
          widget.isRtl);
    }
    List<DateTime> dates;
    switch (widget.controller.view) {
      case DateRangePickerView.month:
        {
          dates = getVisibleDates(
              currentViewDate,
              null,
              widget.picker.monthViewSettings.firstDayOfWeek,
              _getViewDatesCount(widget.controller.view,
                  widget.picker.monthViewSettings.numberOfWeeksInView));
          if (widget.picker.enableMultiView && !widget.isRtl) {
            afterVisibleDates = getVisibleDates(
                afterNextViewDate,
                null,
                widget.picker.monthViewSettings.firstDayOfWeek,
                _getViewDatesCount(widget.controller.view,
                    widget.picker.monthViewSettings.numberOfWeeksInView));
          }
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          dates = _getVisibleYearDates(currentViewDate, widget.controller.view);
          if (widget.picker.enableMultiView && !widget.isRtl) {
            afterVisibleDates =
                _getVisibleYearDates(afterNextViewDate, widget.controller.view);
          }
        }
    }

    if (widget.picker.enableMultiView) {
      dates.addAll(_updateNextVisibleDateForMultiView(afterVisibleDates));
    }

    if (_currentChildIndex == 0) {
      _nextViewVisibleDates = dates;
    } else if (_currentChildIndex == 1) {
      _previousViewVisibleDates = dates;
    } else {
      _visibleDates = dates;
    }
  }

  List<DateTime> _updateNextVisibleDateForMultiView(
      List<DateTime> afterVisibleDates) {
    final List<DateTime> dates = <DateTime>[];
    if (!widget.isRtl) {
      for (int i = 0; i < afterVisibleDates.length; i++) {
        dates.add(afterVisibleDates[i]);
      }
    } else {
      for (int i = 0; i < _currentViewVisibleDates.length ~/ 2; i++) {
        dates.add(_currentViewVisibleDates[i]);
      }
    }

    return dates;
  }

  void _updatePreviousViewVisibleDates() {
    DateTime currentViewDate = _currentViewVisibleDates[0];
    if ((widget.controller.view == DateRangePickerView.month &&
            widget.picker.monthViewSettings.numberOfWeeksInView == 6) ||
        widget.controller.view == DateRangePickerView.year ||
        widget.controller.view == DateRangePickerView.decade ||
        widget.controller.view == DateRangePickerView.century) {
      currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length /
                  (widget.picker.enableMultiView ? 4 : 2))
              .truncate()];
    }

    currentViewDate = _getPreviousViewStartDate(
        widget.controller.view,
        widget.picker.monthViewSettings.numberOfWeeksInView,
        currentViewDate,
        widget.isRtl);
    List<DateTime> dates;
    List<DateTime> afterVisibleDates;
    DateTime afterNextViewDate;
    if (widget.picker.enableMultiView && widget.isRtl) {
      afterNextViewDate = _getPreviousViewStartDate(
          widget.controller.view,
          widget.picker.monthViewSettings.numberOfWeeksInView,
          currentViewDate,
          widget.isRtl);
    }

    switch (widget.controller.view) {
      case DateRangePickerView.month:
        {
          dates = getVisibleDates(
              currentViewDate,
              null,
              widget.picker.monthViewSettings.firstDayOfWeek,
              _getViewDatesCount(widget.controller.view,
                  widget.picker.monthViewSettings.numberOfWeeksInView));
          if (widget.picker.enableMultiView && widget.isRtl) {
            afterVisibleDates = getVisibleDates(
                afterNextViewDate,
                null,
                widget.picker.monthViewSettings.firstDayOfWeek,
                _getViewDatesCount(widget.controller.view,
                    widget.picker.monthViewSettings.numberOfWeeksInView));
          }
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          dates = _getVisibleYearDates(currentViewDate, widget.controller.view);
          if (widget.picker.enableMultiView && widget.isRtl) {
            afterVisibleDates =
                _getVisibleYearDates(afterNextViewDate, widget.controller.view);
          }
        }
    }

    if (widget.picker.enableMultiView) {
      dates.addAll(_updatePreviousDatesForMultiView(afterVisibleDates));
    }

    if (_currentChildIndex == 0) {
      _visibleDates = dates;
    } else if (_currentChildIndex == 1) {
      _nextViewVisibleDates = dates;
    } else {
      _previousViewVisibleDates = dates;
    }
  }

  List<DateTime> _updatePreviousDatesForMultiView(
      List<DateTime> afterVisibleDates) {
    final List<DateTime> dates = <DateTime>[];
    if (widget.isRtl) {
      for (int i = 0; i < (afterVisibleDates.length); i++) {
        dates.add(afterVisibleDates[i]);
      }
    } else {
      for (int i = 0; i < (_currentViewVisibleDates.length / 2); i++) {
        dates.add(_currentViewVisibleDates[i]);
      }
    }
    return dates;
  }

  void _getPickerViewStateDetails(_PickerStateArgs details) {
    details._currentViewVisibleDates = _currentViewVisibleDates;
    details._currentDate = _pickerStateDetails._currentDate;
    details._selectedDate = _pickerStateDetails._selectedDate;
    details._selectedDates = _pickerStateDetails._selectedDates;
    details._selectedRange = _pickerStateDetails._selectedRange;
    details._selectedRanges = _pickerStateDetails._selectedRanges;
    details._view = _pickerStateDetails._view;
  }

  void _updatePickerViewStateDetails(_PickerStateArgs details) {
    _pickerStateDetails._currentDate = details._currentDate;
    _pickerStateDetails._selectedDate = details._selectedDate;
    _pickerStateDetails._selectedDates = details._selectedDates;
    _pickerStateDetails._selectedRange = details._selectedRange;
    _pickerStateDetails._selectedRanges = details._selectedRanges;
    _pickerStateDetails._view = details._view;
    widget.updatePickerStateValues(_pickerStateDetails);
  }

  _PickerView _getView(List<DateTime> dates, GlobalKey key) {
    return _PickerView(
      widget.picker,
      widget.controller,
      dates,
      widget.width,
      widget.height,
      widget.datePickerTheme,
      _focusNode,
      widget.textScaleFactor,
      key: key,
      getPickerStateDetails: (_PickerStateArgs details) {
        _getPickerViewStateDetails(details);
      },
      updatePickerStateDetails: (_PickerStateArgs details) {
        _updatePickerViewStateDetails(details);
      },
      isRtl: widget.isRtl,
    );
  }

  List<Widget> _addViews(BuildContext context) {
    _children = _children ?? <_PickerView>[];
    if (_children != null && _children.isEmpty) {
      _previousView = _getView(_previousViewVisibleDates, _previousViewKey);
      _currentView = _getView(_visibleDates, _currentViewKey);
      _nextView = _getView(_nextViewVisibleDates, _nextViewKey);

      _children.add(_previousView);
      _children.add(_currentView);
      _children.add(_nextView);
      return _children;
    }

    final _PickerView previousView = _updateViews(
        _previousView, _previousView.visibleDates, _previousViewVisibleDates);
    final _PickerView currentView =
        _updateViews(_currentView, _currentView.visibleDates, _visibleDates);
    final _PickerView nextView =
        _updateViews(_nextView, _nextView.visibleDates, _nextViewVisibleDates);

    //// Update views while the all day view height differ from original height,
    //// else repaint the appointment painter while current child visible appointment not equals calendar visible appointment
    if (_previousView != previousView) {
      _previousView = previousView;
    }
    if (_currentView != currentView) {
      _currentView = currentView;
    }
    if (_nextView != nextView) {
      _nextView = nextView;
    }

    return _children;
  }

  // method to check and update the views and appointments on the swiping end
  Widget _updateViews(
      Widget view, List<DateTime> viewDates, List<DateTime> visibleDates) {
    final int index = _children.indexOf(view);
    // update the view with the visible dates on swiping end.
    if (viewDates != visibleDates) {
      view = _getView(visibleDates, view.key);
      _children[index] = view;
    } // check and update the visible appointments in the view

    return view;
  }

  void animationListener() {
    setState(() {
      _position = _animation.value;
    });
  }

  void _updateSettings(_PickerScrollView oldWidget) {
    //// condition to check and update the view when the settings changed, it will check each and every property of settings
    //// to avoid unwanted repainting
    if (oldWidget.picker.monthViewSettings != widget.picker.monthViewSettings ||
        oldWidget.picker.monthCellStyle != widget.picker.monthCellStyle ||
        oldWidget.picker.selectionRadius != widget.picker.selectionRadius ||
        oldWidget.picker.startRangeSelectionColor !=
            widget.picker.startRangeSelectionColor ||
        oldWidget.picker.endRangeSelectionColor !=
            widget.picker.endRangeSelectionColor ||
        oldWidget.picker.rangeSelectionColor !=
            widget.picker.rangeSelectionColor ||
        oldWidget.picker.selectionColor != widget.picker.selectionColor ||
        oldWidget.picker.selectionTextStyle !=
            widget.picker.selectionTextStyle ||
        oldWidget.picker.rangeTextStyle != widget.picker.rangeTextStyle ||
        oldWidget.picker.monthViewSettings.blackoutDates !=
            widget.picker.monthViewSettings.blackoutDates ||
        oldWidget.picker.monthViewSettings.specialDates !=
            widget.picker.monthViewSettings.specialDates ||
        oldWidget.picker.monthViewSettings.weekendDays !=
            widget.picker.monthViewSettings.weekendDays ||
        oldWidget.picker.selectionShape != widget.picker.selectionShape ||
        oldWidget.picker.todayHighlightColor !=
            widget.picker.todayHighlightColor ||
        oldWidget.locale != widget.locale) {
      _children.clear();
      _position = 0;
    }
  }

  void _drawSelection(_PickerScrollView oldWidget) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          if ((oldWidget.picker.controller.selectedDate !=
                  widget.picker.controller.selectedDate ||
              !isSameDate(_pickerStateDetails._selectedDate,
                  widget.controller.selectedDate))) {
            _pickerStateDetails._selectedDate =
                widget.picker.controller.selectedDate;
            if (widget.controller.view != DateRangePickerView.month &&
                !widget.picker.allowViewNavigation) {
              _drawYearSelection();
            } else {
              _drawMonthSelection();
            }

            _position = 0;
          }
        }
        break;
      case DateRangePickerSelectionMode.multiple:
        {
          if (oldWidget.picker.controller.selectedDates !=
                  widget.picker.controller.selectedDates ||
              !_isDateCollectionEquals(_pickerStateDetails._selectedDates,
                  widget.picker.controller.selectedDates)) {
            _pickerStateDetails._selectedDates =
                widget.picker.controller.selectedDates;
            if (widget.controller.view != DateRangePickerView.month &&
                !widget.picker.allowViewNavigation) {
              _drawYearSelection();
            } else {
              _drawMonthSelection();
            }

            _position = 0;
          }
        }
        break;
      case DateRangePickerSelectionMode.range:
        {
          if (oldWidget.picker.controller.selectedRange !=
                  widget.picker.controller.selectedRange ||
              !_isRangeEquals(_pickerStateDetails._selectedRange,
                  widget.picker.controller.selectedRange)) {
            _pickerStateDetails._selectedRange =
                widget.picker.controller.selectedRange;
            if (widget.controller.view != DateRangePickerView.month &&
                !widget.picker.allowViewNavigation) {
              _drawYearSelection();
            } else {
              _drawMonthSelection();
            }

            _position = 0;
          }
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          if (oldWidget.picker.controller.selectedRanges !=
                  widget.picker.controller.selectedRanges ||
              !_isDateRangesEquals(_pickerStateDetails._selectedRanges,
                  widget.picker.controller.selectedRanges)) {
            _pickerStateDetails._selectedRanges =
                widget.picker.controller.selectedRanges;
            if (widget.controller.view != DateRangePickerView.month &&
                !widget.picker.allowViewNavigation) {
              _drawYearSelection();
            } else {
              _drawMonthSelection();
            }

            _position = 0;
          }
        }
    }
  }

  bool _isDisabledDate(DateTime selectedDate) {
    return !_isEnabledDate(widget.picker.minDate, widget.picker.maxDate,
        widget.picker.enablePastDates, selectedDate);
  }

  bool _isDisabledRange(PickerDateRange range) {
    if ((_pickerStateDetails._selectedRange.startDate != null &&
            !_isEnabledDate(
                widget.picker.minDate,
                widget.picker.maxDate,
                widget.picker.enablePastDates,
                _pickerStateDetails._selectedRange.startDate)) ||
        (_pickerStateDetails._selectedRange.endDate != null &&
            !_isEnabledDate(
                widget.picker.minDate,
                widget.picker.maxDate,
                widget.picker.enablePastDates,
                _pickerStateDetails._selectedRange.endDate))) {
      return true;
    }
    return false;
  }

  void _updateSelectedValuesWithMinMaxDate() {
    widget.getPickerStateValues(_pickerStateDetails);
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          if (_pickerStateDetails._selectedDate != null) {
            final bool isDisabled =
                _isDisabledDate(_pickerStateDetails._selectedDate);
            if (isDisabled) {
              _pickerStateDetails._selectedDate = null;
              widget.updatePickerStateValues(_pickerStateDetails);
            }
          }
        }
        break;
      case DateRangePickerSelectionMode.multiple:
        {
          if (_pickerStateDetails._selectedDates != null &&
              _pickerStateDetails._selectedDates.isNotEmpty) {
            final List<int> indexList = <int>[];
            for (int i = 0;
                i < _pickerStateDetails._selectedDates.length;
                i++) {
              final bool isDisabled =
                  _isDisabledDate(_pickerStateDetails._selectedDates[i]);
              if (isDisabled) {
                indexList.add(i);
              }
            }

            if (indexList != null && indexList.isNotEmpty) {
              for (int i = indexList.length - 1; i >= 0; i--) {
                _pickerStateDetails._selectedDates.removeAt(indexList[i]);
              }

              widget.updatePickerStateValues(_pickerStateDetails);
            }
          }
        }
        break;
      case DateRangePickerSelectionMode.range:
        {
          if (_pickerStateDetails._selectedRange != null) {
            final bool isDisabled =
                _isDisabledRange(_pickerStateDetails._selectedRange);
            if (isDisabled) {
              _pickerStateDetails._selectedRange = null;
            }

            widget.updatePickerStateValues(_pickerStateDetails);
          }
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          if (_pickerStateDetails._selectedRanges != null &&
              _pickerStateDetails._selectedRanges.isNotEmpty) {
            final List<int> indexList = <int>[];
            for (int i = 0;
                i < _pickerStateDetails._selectedRanges.length;
                i++) {
              final bool isDisabled =
                  _isDisabledRange(_pickerStateDetails._selectedRanges[i]);
              if (isDisabled) {
                indexList.add(i);
              }
            }

            if (indexList != null && indexList.isNotEmpty) {
              for (int i = indexList.length - 1; i >= 0; i--) {
                _pickerStateDetails._selectedRanges.removeAt(indexList[i]);
              }

              widget.updatePickerStateValues(_pickerStateDetails);
            }
          }
        }
    }
  }

  void _moveToNextViewWithAnimation() {
    // Resets the controller to forward it again, the animation will forward
    // only from the dismissed state
    if (_animationController.isCompleted || _animationController.isDismissed) {
      _animationController.reset();
    } else {
      return;
    }

    _updateSelection();
    if (widget.picker.navigationDirection ==
        DateRangePickerNavigationDirection.vertical) {
      // update the bottom to top swiping
      _tween.begin = 0;
      _tween.end = -widget.height;
    } else {
      // update the right to left swiping
      _tween.begin = 0;
      _tween.end = -widget.width;
    }

    _animationController.duration = const Duration(milliseconds: 500);
    _animationController
        .forward()
        .then<dynamic>((dynamic value) => _updateNextView());

    /// updates the current view visible dates when the view swiped
    _updateCurrentViewVisibleDates(isNextView: true);
  }

  void _moveToPreviousViewWithAnimation() {
    // Resets the controller to backward it again, the animation will backward
    // only from the dismissed state
    if (_animationController.isCompleted || _animationController.isDismissed) {
      _animationController.reset();
    } else {
      return;
    }

    _updateSelection();
    if (widget.picker.navigationDirection ==
        DateRangePickerNavigationDirection.vertical) {
      // update the top to bottom swiping
      _tween.begin = 0;
      _tween.end = widget.height;
    } else {
      // update the left to right swiping
      _tween.begin = 0;
      _tween.end = widget.width;
    }

    _animationController.duration = const Duration(milliseconds: 500);
    _animationController
        .forward()
        .then<dynamic>((dynamic value) => _updatePreviousView());

    /// updates the current view visible dates when the view swiped.
    _updateCurrentViewVisibleDates();
  }

  /// Update the selection details to scroll view children except current view
  /// while view navigation.
  void _updateSelection() {
    /// Update selection on month view and update selection on year view when
    /// [allowViewNavigation] property on [SfDateRangePicker] as false
    if (widget.controller.view != DateRangePickerView.month &&
        widget.picker.allowViewNavigation) {
      return;
    }

    widget.getPickerStateValues(_pickerStateDetails);
    for (int i = 0; i < _children.length; i++) {
      if (i == _currentChildIndex) {
        continue;
      }

      final _PickerViewState viewState = _getCurrentViewState(i);
      switch (widget.controller.view) {
        case DateRangePickerView.month:
          {
            viewState._monthView._updateSelection(_pickerStateDetails);
          }
          break;
        case DateRangePickerView.year:
        case DateRangePickerView.decade:
        case DateRangePickerView.century:
          {
            viewState._yearView._updateSelection(_pickerStateDetails);
          }
      }
    }
  }

  /// Draw the selection on current month view when selected date value
  /// changed dynamically.
  void _drawMonthSelection() {
    if (widget.controller.view != DateRangePickerView.month ||
        _children.isEmpty) {
      return;
    }

    for (int i = 0; i < _children.length; i++) {
      final _PickerViewState viewState = _getCurrentViewState(i);

      /// Check the visible dates rather than current child index because
      /// current child index value not updated when the selected date value
      /// changed on view changed callback
      if (viewState == null ||
          viewState._monthView.visibleDates !=
              _pickerStateDetails._currentViewVisibleDates) {
        continue;
      }

      viewState._monthView._updateSelection(_pickerStateDetails);
    }
  }

  /// Draw the selection on current year, decade, century view when
  /// selected date value changed dynamically.
  void _drawYearSelection() {
    if (widget.controller.view == DateRangePickerView.month ||
        _children.isEmpty) {
      return;
    }

    for (int i = 0; i < _children.length; i++) {
      final _PickerViewState viewState = _getCurrentViewState(i);

      /// Check the visible dates rather than current child index because
      /// current child index value not updated when the selected date value
      /// changed on view changed callback
      if (viewState == null ||
          viewState._yearView.visibleDates !=
              _pickerStateDetails._currentViewVisibleDates) {
        continue;
      }

      viewState._yearView._updateSelection(_pickerStateDetails);
    }
  }

  /// Return the picker view state details based on view index.
  _PickerViewState _getCurrentViewState(int index) {
    if (index == 1) {
      return _currentViewKey.currentState;
    } else if (index == 2) {
      return _nextViewKey.currentState;
    }

    return _previousViewKey.currentState;
  }

  /// Updates the current view visible dates for calendar in the swiping end
  void _updateCurrentViewVisibleDates({bool isNextView = false}) {
    if (isNextView) {
      if (_currentChildIndex == 0) {
        _currentViewVisibleDates = _visibleDates;
      } else if (_currentChildIndex == 1) {
        _currentViewVisibleDates = _nextViewVisibleDates;
      } else {
        _currentViewVisibleDates = _previousViewVisibleDates;
      }
    } else {
      if (_currentChildIndex == 0) {
        _currentViewVisibleDates = _nextViewVisibleDates;
      } else if (_currentChildIndex == 1) {
        _currentViewVisibleDates = _previousViewVisibleDates;
      } else {
        _currentViewVisibleDates = _visibleDates;
      }
    }

    _pickerStateDetails._currentViewVisibleDates = _currentViewVisibleDates;
    _pickerStateDetails._currentDate = _currentViewVisibleDates[0];
    if (widget.controller.view == DateRangePickerView.month &&
        widget.picker.monthViewSettings.numberOfWeeksInView == 6) {
      final DateTime date = _currentViewVisibleDates[
          _currentViewVisibleDates.length ~/
              (widget.picker.enableMultiView ? 4 : 2)];
      _pickerStateDetails._currentDate = DateTime(date.year, date.month, 1);
    }

    widget.updatePickerStateValues(_pickerStateDetails);
  }

  void _updateNextView() {
    if (!_animationController.isCompleted) {
      return;
    }

    _updateNextViewVisibleDates();

    if (_currentChildIndex == 0) {
      _currentChildIndex = 1;
    } else if (_currentChildIndex == 1) {
      _currentChildIndex = 2;
    } else if (_currentChildIndex == 2) {
      _currentChildIndex = 0;
    }

    if (kIsWeb) {
      setState(() {
        /// set state called to call the build method to fix the date doesn't
        /// update properly issue on web, in Andriod and iOS the build method
        /// called automatically when the animation ends but in web it doesn't
        /// work on that way, hence we have manually called the build method by
        /// adding setstate and i have logged and issue in framework once i got
        /// the solution will remove this setstate
      });
    }

    _resetPosition();
  }

  void _updatePreviousView() {
    if (!_animationController.isCompleted) {
      return;
    }

    _updatePreviousViewVisibleDates();

    if (_currentChildIndex == 0) {
      _currentChildIndex = 2;
    } else if (_currentChildIndex == 1) {
      _currentChildIndex = 0;
    } else if (_currentChildIndex == 2) {
      _currentChildIndex = 1;
    }

    if (kIsWeb) {
      setState(() {
        /// set state called to call the build method to fix the date doesn't
        /// update properly issue on web, in Andriod and iOS the build method
        /// called automatically when the animation ends but in web it doesn't
        /// work on that way, hence we have manually called the build method by
        /// adding setstate and i have logged and issue in framework once i got
        /// the solution will remove this setstate
      });
    }

    _resetPosition();
  }

  // resets position to zero on the swipe end to avoid the unwanted date
  // updates.
  void _resetPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_position.abs() == widget.width || _position.abs() == widget.height) {
        _position = 0;
      }
    });
  }

  /// Calculate and return the date time value based on previous selected date,
  /// keyboard action and current picker view.
  DateTime _getYearSelectedDate(DateTime selectedDate, PhysicalKeyboardKey key,
      _PickerView view, _PickerViewState state) {
    DateTime date;

    /// Calculate the index value for previous selected date.
    int index =
        _getYearCellIndex(view.visibleDates, selectedDate, state._yearView);
    if (key == PhysicalKeyboardKey.arrowRight) {
      /// If index value as last cell index in current view then
      /// navigate to next view. Calculate the selected index on navigated view
      /// and return the selected date on navigated view on right arrow pressed
      /// action.
      if ((index == view.visibleDates.length - 1 ||
              (widget.picker.enableMultiView &&
                  widget.controller.view != DateRangePickerView.year &&
                  index >= view.visibleDates.length - 3)) &&
          widget.picker.selectionMode == DateRangePickerSelectionMode.single) {
        widget.isRtl
            ? _moveToPreviousViewWithAnimation()
            : _moveToNextViewWithAnimation();
      }

      if (index != -1) {
        date = _getNextDate(widget.controller.view, selectedDate);
      }
    } else if (key == PhysicalKeyboardKey.arrowLeft) {
      /// If index value as first cell index in current view then
      /// navigate to previous view. Calculate the selected index on navigated
      /// view and return the selected date on navigated view on left arrow
      /// pressed action.
      if (index == 0 &&
          widget.picker.selectionMode == DateRangePickerSelectionMode.single) {
        widget.isRtl
            ? _moveToNextViewWithAnimation()
            : _moveToPreviousViewWithAnimation();
      }

      if (index != -1) {
        date = _getPreviousDate(widget.controller.view, selectedDate);
      }
    } else if (key == PhysicalKeyboardKey.arrowUp) {
      /// If index value not in first row then calculate the date by
      /// subtracting the index value with 3 and return the date value.
      if (index >= 3 && index != -1) {
        index -= 3;
        date = view.visibleDates[index];
      }
    } else if (key == PhysicalKeyboardKey.arrowDown) {
      /// If index value not in last row then calculate the date by
      /// adding the index value with 3 and return the date value.
      if (index <= 8 && index != -1) {
        index += 3;
        date = view.visibleDates[index];
      }
    }

    return date;
  }

  void _switchViewsByKeyBoardEvent(RawKeyEvent event) {
    /// Ctrl + and Ctrl - used by browser to zoom the page, hence as referred
    /// EJ2 scheduler, we have used alt + numeric to switch between views in
    /// datepicker web
    if (event.isAltPressed) {
      if (event.physicalKey == PhysicalKeyboardKey.digit1) {
        _pickerStateDetails._view = DateRangePickerView.month;
      } else if (event.physicalKey == PhysicalKeyboardKey.digit2) {
        _pickerStateDetails._view = DateRangePickerView.year;
      } else if (event.physicalKey == PhysicalKeyboardKey.digit3) {
        _pickerStateDetails._view = DateRangePickerView.decade;
      } else if (event.physicalKey == PhysicalKeyboardKey.digit4) {
        _pickerStateDetails._view = DateRangePickerView.century;
      }

      widget.updatePickerStateValues(_pickerStateDetails);
      return;
    }
  }

  void _updateYearSelectionByKeyBoardNavigation(
      _PickerViewState currentVisibleViewState,
      _PickerView currentVisibleView,
      RawKeyEvent event) {
    DateTime selectedDate;
    if (_pickerStateDetails._selectedDate != null &&
        widget.picker.selectionMode == DateRangePickerSelectionMode.single) {
      selectedDate = _getYearSelectedDate(_pickerStateDetails._selectedDate,
          event.physicalKey, currentVisibleView, currentVisibleViewState);
      if (selectedDate != null &&
          currentVisibleViewState._yearView
              ._isBetweenMinMaxMonth(selectedDate)) {
        _pickerStateDetails._selectedDate = selectedDate;
      }
    } else if (widget.picker.selectionMode ==
            DateRangePickerSelectionMode.multiple &&
        _pickerStateDetails._selectedDates != null &&
        _pickerStateDetails._selectedDates.isNotEmpty &&
        event.isShiftPressed) {
      final DateTime date = _pickerStateDetails
          ._selectedDates[_pickerStateDetails._selectedDates.length - 1];
      selectedDate = _getYearSelectedDate(
          date, event.physicalKey, currentVisibleView, currentVisibleViewState);
      if (selectedDate != null &&
          currentVisibleViewState._yearView
              ._isBetweenMinMaxMonth(selectedDate)) {
        _pickerStateDetails._selectedDates =
            _cloneList(_pickerStateDetails._selectedDates)..add(selectedDate);
      }
    }

    widget.updatePickerStateValues(_pickerStateDetails);
    _drawYearSelection();
  }

  void _updateSelectionByKeyboardNavigation(DateTime selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          _pickerStateDetails._selectedDate = selectedDate;
        }
        break;
      case DateRangePickerSelectionMode.multiple:
        {
          _pickerStateDetails._selectedDates.add(selectedDate);
        }
        break;
      case DateRangePickerSelectionMode.range:
        {
          if (_pickerStateDetails._selectedRange != null &&
              _pickerStateDetails._selectedRange.startDate != null &&
              (_pickerStateDetails._selectedRange.endDate == null ||
                  isSameDate(_pickerStateDetails._selectedRange.startDate,
                      _pickerStateDetails._selectedRange.endDate))) {
            _pickerStateDetails._selectedRange = PickerDateRange(
                _pickerStateDetails._selectedRange.startDate, selectedDate);
          } else {
            _pickerStateDetails._selectedRange =
                PickerDateRange(selectedDate, null);
          }
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        break;
    }
  }

  void _onKeyDown(RawKeyEvent event) {
    if (event.runtimeType != RawKeyDownEvent) {
      return;
    }

    _switchViewsByKeyBoardEvent(event);

    if (widget.controller.view != DateRangePickerView.month &&
        widget.picker.allowViewNavigation) {
      return;
    }

    if (_pickerStateDetails._selectedDate == null &&
        (_pickerStateDetails._selectedDates == null ||
            _pickerStateDetails._selectedDates.isEmpty) &&
        _pickerStateDetails._selectedRange == null &&
        (_pickerStateDetails._selectedRanges == null ||
            _pickerStateDetails._selectedRanges.isEmpty)) {
      return;
    }

    _PickerViewState currentVisibleViewState;
    _PickerView currentVisibleView;
    if (_currentChildIndex == 0) {
      currentVisibleViewState = _previousViewKey.currentState;
      currentVisibleView = _previousView;
    } else if (_currentChildIndex == 1) {
      currentVisibleViewState = _currentViewKey.currentState;
      currentVisibleView = _currentView;
    } else if (_currentChildIndex == 2) {
      currentVisibleViewState = _nextViewKey.currentState;
      currentVisibleView = _nextView;
    }

    if (widget.controller.view != DateRangePickerView.month) {
      _updateYearSelectionByKeyBoardNavigation(
          currentVisibleViewState, currentVisibleView, event);
      return;
    }

    final DateTime selectedDate =
        _updateSelectedDate(event, currentVisibleViewState, currentVisibleView);

    if (_isDateWithInVisibleDates(currentVisibleView.visibleDates,
            widget.picker.monthViewSettings.blackoutDates, selectedDate) ||
        !_isEnabledDate(widget.picker.minDate, widget.picker.maxDate,
            widget.picker.enablePastDates, selectedDate)) {
      return;
    }

    if (!_isDateAsCurrentMonthDate(
        currentVisibleView.visibleDates[
            currentVisibleView.visibleDates.length ~/
                (widget.picker.enableMultiView ? 4 : 2)],
        widget.picker.monthViewSettings.numberOfWeeksInView,
        widget.picker.monthViewSettings.showTrailingAndLeadingDates,
        selectedDate)) {
      if (selectedDate.month ==
          getNextMonthDate(currentVisibleView.visibleDates[
                  currentVisibleView.visibleDates.length ~/
                      (widget.picker.enableMultiView ? 4 : 2)])
              .month) {
        widget.isRtl
            ? _moveToPreviousViewWithAnimation()
            : _moveToNextViewWithAnimation();
      } else {
        widget.isRtl
            ? _moveToNextViewWithAnimation()
            : _moveToPreviousViewWithAnimation();
      }
    }

    currentVisibleViewState._drawSelection(selectedDate);

    _updateSelectionByKeyboardNavigation(selectedDate);
    widget.updatePickerStateValues(_pickerStateDetails);
    _updateSelection();
  }

  DateTime _updateSingleSelectionByKeyBoardKeys(
      RawKeyEvent event, _PickerView currentView) {
    if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
      if (isSameDate(_pickerStateDetails._selectedDate,
          currentView.visibleDates[currentView.visibleDates.length - 1])) {
        _moveToNextViewWithAnimation();
      }

      return addDuration(
          _pickerStateDetails._selectedDate, const Duration(days: 1));
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
      if (isSameDate(
          _pickerStateDetails._selectedDate, currentView.visibleDates[0])) {
        _moveToPreviousViewWithAnimation();
      }

      return subtractDuration(
          _pickerStateDetails._selectedDate, const Duration(days: 1));
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowUp) {
      return subtractDuration(_pickerStateDetails._selectedDate,
          const Duration(days: _kNumberOfDaysInWeek));
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown) {
      return addDuration(_pickerStateDetails._selectedDate,
          const Duration(days: _kNumberOfDaysInWeek));
    }
    return null;
  }

  DateTime _updateMultiAndRangeSelectionByKeyBoard(RawKeyEvent event) {
    if (event.isShiftPressed &&
        event.physicalKey == PhysicalKeyboardKey.arrowRight) {
      if (widget.picker.selectionMode ==
          DateRangePickerSelectionMode.multiple) {
        return addDuration(
            _pickerStateDetails
                ._selectedDates[_pickerStateDetails._selectedDates.length - 1],
            const Duration(days: 1));
      } else {
        return addDuration(_pickerStateDetails._selectedRange.startDate,
            const Duration(days: 1));
      }
    } else if (event.isShiftPressed &&
        event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
      if (widget.picker.selectionMode ==
          DateRangePickerSelectionMode.multiple) {
        return addDuration(
            _pickerStateDetails
                ._selectedDates[_pickerStateDetails._selectedDates.length - 1],
            const Duration(days: -1));
      } else {
        return addDuration(_pickerStateDetails._selectedRange.startDate,
            const Duration(days: -1));
      }
    } else if (event.isShiftPressed &&
        event.physicalKey == PhysicalKeyboardKey.arrowUp) {
      if (widget.picker.selectionMode ==
          DateRangePickerSelectionMode.multiple) {
        return addDuration(
            _pickerStateDetails
                ._selectedDates[_pickerStateDetails._selectedDates.length - 1],
            const Duration(days: -_kNumberOfDaysInWeek));
      } else {
        return addDuration(_pickerStateDetails._selectedRange.startDate,
            const Duration(days: -_kNumberOfDaysInWeek));
      }
    } else if (event.isShiftPressed &&
        event.physicalKey == PhysicalKeyboardKey.arrowDown) {
      if (widget.picker.selectionMode ==
          DateRangePickerSelectionMode.multiple) {
        return addDuration(
            _pickerStateDetails
                ._selectedDates[_pickerStateDetails._selectedDates.length - 1],
            const Duration(days: _kNumberOfDaysInWeek));
      } else {
        return addDuration(_pickerStateDetails._selectedRange.startDate,
            const Duration(days: _kNumberOfDaysInWeek));
      }
    }
    return null;
  }

  DateTime _updateSelectedDate(RawKeyEvent event, _PickerViewState currentState,
      _PickerView currentView) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          return _updateSingleSelectionByKeyBoardKeys(event, currentView);
        }
      case DateRangePickerSelectionMode.multiple:
      case DateRangePickerSelectionMode.range:
        {
          return _updateMultiAndRangeSelectionByKeyBoard(event);
        }
      case DateRangePickerSelectionMode.multiRange:
        break;
    }

    return null;
  }

  void _onHorizontalStart(DragStartDetails dragStartDetails) {
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        {
          _scrollStartPosition = dragStartDetails.globalPosition.dx;
          _updateSelection();
        }
        break;
      case DateRangePickerNavigationDirection.vertical:
        break;
    }
  }

  void _onHorizontalUpdate(DragUpdateDetails dragUpdateDetails) {
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        {
          final double difference =
              dragUpdateDetails.globalPosition.dx - _scrollStartPosition;
          if (difference < 0 &&
              !_canMoveToNextViewRtl(
                  widget.controller.view,
                  widget.picker.monthViewSettings.numberOfWeeksInView,
                  widget.picker.minDate,
                  widget.picker.maxDate,
                  _currentViewVisibleDates,
                  widget.isRtl,
                  widget.picker.enableMultiView)) {
            return;
          } else if (difference > 0 &&
              !_canMoveToPreviousViewRtl(
                  widget.controller.view,
                  widget.picker.monthViewSettings.numberOfWeeksInView,
                  widget.picker.minDate,
                  widget.picker.maxDate,
                  _currentViewVisibleDates,
                  widget.isRtl,
                  widget.picker.enableMultiView)) {
            return;
          }

          _position = difference;
          setState(() {
            /* Updates the widget navigated distance and moves the widget
              in the custom scroll view */
          });
        }
        break;
      case DateRangePickerNavigationDirection.vertical:
        break;
    }
  }

  void _onHorizontalEnd(DragEndDetails dragEndDetails) {
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.vertical:
        break;
      case DateRangePickerNavigationDirection.horizontal:
        {
          _position ??= 0;
          // condition to check and update the right to left swiping
          if (-_position >= widget.width / 2) {
            _tween.begin = _position;
            _tween.end = -widget.width;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted && _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .forward()
                .then<dynamic>((dynamic value) => _updateNextView());

            /// updates the current view visible dates when the view swiped in
            /// right to left direction
            _updateCurrentViewVisibleDates(isNextView: true);
          }
          // fling the view from right to left
          else if (-dragEndDetails.velocity.pixelsPerSecond.dx > widget.width) {
            if (!_canMoveToNextViewRtl(
                widget.controller.view,
                widget.picker.monthViewSettings.numberOfWeeksInView,
                widget.picker.minDate,
                widget.picker.maxDate,
                _currentViewVisibleDates,
                widget.isRtl,
                widget.picker.enableMultiView)) {
              _position = 0;
              setState(() {
                /* Completes the swiping and rearrange the children position in
                  the custom scroll view */
              });
              return;
            }

            _tween.begin = _position;
            _tween.end = -widget.width;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted && _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .fling(
                    velocity: 5.0, animationBehavior: AnimationBehavior.normal)
                .then<dynamic>((dynamic value) => _updateNextView());

            /// updates the current view visible dates when fling the view in
            /// right to left direction
            _updateCurrentViewVisibleDates(isNextView: true);
          }
          // condition to check and update the left to right swiping
          else if (_position >= widget.width / 2) {
            _tween.begin = _position;
            _tween.end = widget.width;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .forward()
                .then<dynamic>((dynamic value) => _updatePreviousView());

            /// updates the current view visible dates when the view swiped in
            /// left to right direction
            _updateCurrentViewVisibleDates();
          }
          // fling the view from left to right
          else if (dragEndDetails.velocity.pixelsPerSecond.dx > widget.width) {
            if (!_canMoveToPreviousViewRtl(
                widget.controller.view,
                widget.picker.monthViewSettings.numberOfWeeksInView,
                widget.picker.minDate,
                widget.picker.maxDate,
                _currentViewVisibleDates,
                widget.isRtl,
                widget.picker.enableMultiView)) {
              _position = 0;
              setState(() {
                /* Completes the swiping and rearrange the children position in
                  the custom scroll view */
              });
              return;
            }

            _tween.begin = _position;
            _tween.end = widget.width;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted && _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .fling(
                    velocity: 5.0, animationBehavior: AnimationBehavior.normal)
                .then<dynamic>((dynamic value) => _updatePreviousView());

            /// updates the current view visible dates when fling the view in
            /// left to right direction
            _updateCurrentViewVisibleDates();
          }
          // condition to check and revert the right to left swiping
          else if (_position.abs() <= widget.width / 2) {
            _tween.begin = _position;
            _tween.end = 0.0;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted && _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController.forward();
          }
        }
    }
  }

  void _onVerticalStart(DragStartDetails dragStartDetails) {
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        break;
      case DateRangePickerNavigationDirection.vertical:
        {
          _scrollStartPosition = dragStartDetails.globalPosition.dy;
        }
        break;
    }
  }

  void _onVerticalUpdate(DragUpdateDetails dragUpdateDetails) {
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        break;
      case DateRangePickerNavigationDirection.vertical:
        {
          final double difference =
              dragUpdateDetails.globalPosition.dy - _scrollStartPosition;
          if (difference < 0 &&
              !_canMoveToNextView(
                  widget.controller.view,
                  widget.picker.monthViewSettings.numberOfWeeksInView,
                  widget.picker.maxDate,
                  _currentViewVisibleDates,
                  widget.picker.enableMultiView)) {
            return;
          } else if (difference > 0 &&
              !_canMoveToPreviousView(
                  widget.controller.view,
                  widget.picker.monthViewSettings.numberOfWeeksInView,
                  widget.picker.minDate,
                  _currentViewVisibleDates,
                  widget.picker.enableMultiView)) {
            return;
          }

          _position = difference;
          setState(() {
            /* Updates the widget navigated distance and moves the widget
              in the custom scroll view */
          });
        }
    }
  }

  void _onVerticalEnd(DragEndDetails dragEndDetails) {
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        break;
      case DateRangePickerNavigationDirection.vertical:
        {
          _position ??= 0;
          // condition to check and update the bottom to top swiping
          if (-_position >= widget.height / 2) {
            _tween.begin = _position;
            _tween.end = -widget.height;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .forward()
                .then<dynamic>((dynamic value) => _updateNextView());

            /// updates the current view visible dates when the view swiped in
            /// bottom to top direction
            _updateCurrentViewVisibleDates(isNextView: true);
          }
          // fling the view to bottom to top
          else if (-dragEndDetails.velocity.pixelsPerSecond.dy >
              widget.height) {
            if (!_canMoveToNextView(
                widget.controller.view,
                widget.picker.monthViewSettings.numberOfWeeksInView,
                widget.picker.maxDate,
                _currentViewVisibleDates,
                widget.picker.enableMultiView)) {
              _position = 0;
              setState(() {
                /* Completes the swiping and rearrange the children position in
                  the custom scroll view */
              });
              return;
            }
            _tween.begin = _position;
            _tween.end = -widget.height;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .fling(
                    velocity: 5.0, animationBehavior: AnimationBehavior.normal)
                .then<dynamic>((dynamic value) => _updateNextView());

            /// updates the current view visible dates when fling the view in
            /// bottom to top direction
            _updateCurrentViewVisibleDates(isNextView: true);
          }
          // condition to check and update the top to bottom swiping
          else if (_position >= widget.height / 2) {
            _tween.begin = _position;
            _tween.end = widget.height;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .forward()
                .then<dynamic>((dynamic value) => _updatePreviousView());

            /// updates the current view visible dates when the view swiped in
            /// top to bottom direction
            _updateCurrentViewVisibleDates();
          }
          // fling the view to top to bottom
          else if (dragEndDetails.velocity.pixelsPerSecond.dy > widget.height) {
            if (!_canMoveToPreviousView(
                widget.controller.view,
                widget.picker.monthViewSettings.numberOfWeeksInView,
                widget.picker.minDate,
                _currentViewVisibleDates,
                widget.picker.enableMultiView)) {
              _position = 0;
              setState(() {
                /* Completes the swiping and rearrange the children position in
                  the custom scroll view */
              });
              return;
            }

            _tween.begin = _position;
            _tween.end = widget.height;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .fling(
                    velocity: 5.0, animationBehavior: AnimationBehavior.normal)
                .then<dynamic>((dynamic value) => _updatePreviousView());

            /// updates the current view visible dates when fling the view in
            /// top to bottom direction
            _updateCurrentViewVisibleDates();
          }
          // condition to check and revert the bottom to top swiping
          else if (_position.abs() <= widget.height / 2) {
            _tween.begin = _position;
            _tween.end = 0.0;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController.forward();
          }
        }
    }
  }
}
