part of calendar;

@immutable
class _CustomScrollView extends StatefulWidget {
  const _CustomScrollView(
      this.calendar,
      this.view,
      this.width,
      this.height,
      this.agendaSelectedDate,
      this.isRTL,
      this.locale,
      this.calendarTheme,
      this.specialRegions,
      this.blackoutDates,
      this.controller,
      this.removePicker,
      this.resourcePanelScrollController,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.fadeInController,
      {this.updateCalendarState,
      this.getCalendarState});

  final SfCalendar calendar;
  final CalendarView view;
  final double width;
  final double height;
  final bool isRTL;
  final String locale;
  final SfCalendarThemeData calendarTheme;
  final CalendarController controller;
  final _UpdateCalendarState updateCalendarState;
  final VoidCallback removePicker;
  final _UpdateCalendarState getCalendarState;
  final ValueNotifier<DateTime> agendaSelectedDate;
  final List<TimeRegion> specialRegions;
  final ScrollController resourcePanelScrollController;
  final double textScaleFactor;
  final bool isMobilePlatform;
  final List<DateTime> blackoutDates;
  final AnimationController fadeInController;

  @override
  _CustomScrollViewState createState() => _CustomScrollViewState();
}

class _CustomScrollViewState extends State<_CustomScrollView>
    with TickerProviderStateMixin {
  // three views to arrange the view in vertical/horizontal direction and handle the swiping
  _CalendarView _currentView, _nextView, _previousView;

  // the three children which to be added into the layout
  List<_CalendarView> _children;

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

  // Three visible dates for the three views, the dates will updated based on
  // the swiping in the swipe end currentViewVisibleDates which stores the
  // visible dates of the current displaying view
  List<DateTime> _visibleDates,
      _previousViewVisibleDates,
      _nextViewVisibleDates,
      _currentViewVisibleDates;

  /// keys maintained to access the data and methods from the calendar view
  /// class.
  GlobalKey<_CalendarViewState> _previousViewKey, _currentViewKey, _nextViewKey;

  _UpdateCalendarStateDetails _updateCalendarStateDetails;

  /// Appointment view maintained to update the selection when an appointment
  /// selected and navigated to previous/next view.
  _AppointmentView _selectedAppointmentView;

  /// Collection used to store the special regions and
  /// check the special regions manipulations.
  List<TimeRegion> _timeRegions;

  /// Collection used to store the resource collection and check the collection
  /// manipulations(add, remove, reset).
  List<CalendarResource> _resourceCollection;

  /// The variable stores the timeline view scroll start position used to
  /// decide the scroll as timeline scroll or scroll view on scroll update.
  double _timelineScrollStartPosition = 0;

  /// The variable used to store the scroll start position to calculate the
  /// scroll difference on scroll update.
  double _timelineStartPosition = 0;

  /// Boolean value used to trigger the horizontal end animation when user
  /// stops the scroll at middle.
  bool _isNeedTimelineScrollEnd = false;

  /// Used to perform the drag or scroll in timeline view.
  Drag _drag;

  FocusNode _focusNode;

  @override
  void initState() {
    _previousViewKey = GlobalKey<_CalendarViewState>();
    _currentViewKey = GlobalKey<_CalendarViewState>();
    _nextViewKey = GlobalKey<_CalendarViewState>();
    _focusNode = FocusNode();
    if (widget.controller != null) {
      widget.controller._forward = widget.isRTL
          ? _moveToPreviousViewWithAnimation
          : _moveToNextViewWithAnimation;
      widget.controller._backward = widget.isRTL
          ? _moveToNextViewWithAnimation
          : _moveToPreviousViewWithAnimation;
    }

    _updateCalendarStateDetails = _UpdateCalendarStateDetails();
    _currentChildIndex = 1;
    _updateVisibleDates();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: this,
        animationBehavior: AnimationBehavior.normal);
    _tween = Tween<double>(begin: 0.0, end: 0.1);
    _animation = _tween.animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ))
      ..addListener(animationListener);

    _timeRegions = _cloneList(widget.specialRegions);
    _resourceCollection = _cloneList(widget.calendar.dataSource?.resources);

    super.initState();
  }

  @override
  void didUpdateWidget(_CustomScrollView oldWidget) {
    if (oldWidget.controller != widget.controller &&
        widget.controller != null) {
      widget.controller._forward = widget.isRTL
          ? _moveToPreviousViewWithAnimation
          : _moveToNextViewWithAnimation;
      widget.controller._backward = widget.isRTL
          ? _moveToNextViewWithAnimation
          : _moveToPreviousViewWithAnimation;

      if (!_isSameTimeSlot(oldWidget.controller.selectedDate,
              widget.controller.selectedDate) ||
          !_isSameTimeSlot(_updateCalendarStateDetails._selectedDate,
              widget.controller.selectedDate)) {
        _selectResourceProgrammatically();
      }
    }

    if (oldWidget.view != widget.view) {
      _children.clear();

      /// Switching timeline view from non timeline view or non timeline view
      /// from timeline view creates the scroll layout as new because we handle
      /// the scrolling touch for timeline view in this widget, so current
      /// widget tree differ on timeline and non timeline views, so it creates
      /// new widget tree.
      if (_isTimelineView(widget.view) != _isTimelineView(oldWidget.view)) {
        _currentChildIndex = 1;
      }

      _updateVisibleDates();
      _position = 0;
    }

    if ((widget.calendar.monthViewSettings.navigationDirection !=
            oldWidget.calendar.monthViewSettings.navigationDirection) ||
        widget.calendar.scheduleViewMonthHeaderBuilder !=
            oldWidget.calendar.scheduleViewMonthHeaderBuilder ||
        widget.calendar.monthCellBuilder !=
            oldWidget.calendar.monthCellBuilder ||
        widget.width != oldWidget.width ||
        widget.height != oldWidget.height ||
        widget.textScaleFactor != oldWidget.textScaleFactor) {
      _position = null;
      _children.clear();
    }

    if (!_isTimeRegionsEquals(widget.specialRegions, _timeRegions)) {
      _timeRegions = _cloneList(widget.specialRegions);
      _position = null;
      _children.clear();
    }

    if ((widget.view == CalendarView.month ||
            widget.view == CalendarView.timelineMonth) &&
        widget.blackoutDates != oldWidget.blackoutDates) {
      _children.clear();
      if (!_animationController.isAnimating) {
        _position = 0;
      }
    }

    /// Check and re renders the views if the resource collection changed.
    if (_isTimelineView(widget.view) &&
        !_isResourceCollectionEqual(
            widget.calendar.dataSource?.resources, _resourceCollection)) {
      _updateSelectedResourceIndex();
      _resourceCollection = _cloneList(widget.calendar.dataSource?.resources);
      _position = 0;
      _children.clear();
    }

    //// condition to check and update the view when the settings changed, it will check each and every property of settings
    //// to avoid unwanted repainting
    if (oldWidget.calendar.timeSlotViewSettings !=
            widget.calendar.timeSlotViewSettings ||
        oldWidget.calendar.monthViewSettings !=
            widget.calendar.monthViewSettings ||
        oldWidget.calendar.blackoutDatesTextStyle !=
            widget.calendar.blackoutDatesTextStyle ||
        oldWidget.calendar.resourceViewSettings !=
            widget.calendar.resourceViewSettings ||
        oldWidget.calendar.viewHeaderStyle != widget.calendar.viewHeaderStyle ||
        oldWidget.calendar.viewHeaderHeight !=
            widget.calendar.viewHeaderHeight ||
        oldWidget.calendar.todayHighlightColor !=
            widget.calendar.todayHighlightColor ||
        oldWidget.calendar.cellBorderColor != widget.calendar.cellBorderColor ||
        oldWidget.calendarTheme != widget.calendarTheme ||
        oldWidget.locale != widget.locale ||
        oldWidget.calendar.selectionDecoration !=
            widget.calendar.selectionDecoration) {
      final bool isTimelineView = _isTimelineView(widget.view);
      if (widget.view != CalendarView.month &&
          (oldWidget.calendar.timeSlotViewSettings.timeInterval !=
                  widget.calendar.timeSlotViewSettings.timeInterval ||
              (!isTimelineView &&
                  oldWidget.calendar.timeSlotViewSettings.timeIntervalHeight !=
                      widget
                          .calendar.timeSlotViewSettings.timeIntervalHeight) ||
              (isTimelineView &&
                  oldWidget.calendar.timeSlotViewSettings.timeIntervalWidth !=
                      widget
                          .calendar.timeSlotViewSettings.timeIntervalWidth))) {
        if (_currentChildIndex == 0) {
          _previousViewKey.currentState._retainScrolledDateTime();
        } else if (_currentChildIndex == 1) {
          _currentViewKey.currentState._retainScrolledDateTime();
        } else if (_currentChildIndex == 2) {
          _nextViewKey.currentState._retainScrolledDateTime();
        }
      }
      _children.clear();
      _position = 0;
    }

    if (widget.calendar.monthViewSettings.numberOfWeeksInView !=
            oldWidget.calendar.monthViewSettings.numberOfWeeksInView ||
        widget.calendar.timeSlotViewSettings.nonWorkingDays !=
            oldWidget.calendar.timeSlotViewSettings.nonWorkingDays ||
        widget.calendar.firstDayOfWeek != oldWidget.calendar.firstDayOfWeek ||
        widget.isRTL != oldWidget.isRTL) {
      _updateVisibleDates();
      _position = 0;
    }

    if ((widget.calendar.minDate != null &&
            !_isSameTimeSlot(
                widget.calendar.minDate, oldWidget.calendar.minDate)) ||
        (widget.calendar.maxDate != null &&
            !_isSameTimeSlot(
                widget.calendar.maxDate, oldWidget.calendar.maxDate))) {
      _updateVisibleDates();
      _position = 0;
    }

    if (_isTimelineView(widget.view) != _isTimelineView(oldWidget.view)) {
      _children.clear();
    }

    /// position set as zero to maintain the existing scroll position in
    /// timeline view
    if (_isTimelineView(widget.view) &&
        (oldWidget.calendar.backgroundColor !=
                widget.calendar.backgroundColor ||
            oldWidget.calendar.headerStyle != widget.calendar.headerStyle) &&
        _position != null) {
      _position = 0;
    }

    if (widget.controller == oldWidget.controller &&
        widget.controller != null) {
      if (oldWidget.controller.displayDate != widget.controller.displayDate ||
          !isSameDate(_updateCalendarStateDetails._currentDate,
              widget.controller.displayDate)) {
        _updateCalendarStateDetails._currentDate =
            widget.controller.displayDate;
        _updateVisibleDates();
        _updateMoveToDate();
        _position = 0;
      }

      if (!_isSameTimeSlot(oldWidget.controller.selectedDate,
              widget.controller.selectedDate) ||
          !_isSameTimeSlot(_updateCalendarStateDetails._selectedDate,
              widget.controller.selectedDate)) {
        _updateCalendarStateDetails._selectedDate =
            widget.controller.selectedDate;
        _selectResourceProgrammatically();
        _updateSelection();
        _position = 0;
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isTimelineView(widget.view) && widget.view != CalendarView.month) {
      _updateScrollPosition();
    }

    double leftPosition, rightPosition, topPosition, bottomPosition;
    if (widget.calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget.view != CalendarView.month) {
      leftPosition = leftPosition ?? -widget.width;
      rightPosition = rightPosition ?? -widget.width;
      topPosition = 0;
      bottomPosition = 0;
    } else {
      leftPosition = 0;
      rightPosition = 0;
      topPosition = topPosition ?? -widget.height;
      bottomPosition = bottomPosition ?? -widget.height;
    }

    final bool isTimelineView = _isTimelineView(widget.view);
    final Widget customScrollWidget = GestureDetector(
      child: CustomScrollViewerLayout(
          _addViews(),
          widget.view != CalendarView.month ||
                  widget.calendar.monthViewSettings.navigationDirection ==
                      MonthNavigationDirection.horizontal
              ? CustomScrollDirection.horizontal
              : CustomScrollDirection.vertical,
          _position,
          _currentChildIndex),
      onTapDown: (TapDownDetails details) {
        if (!_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
      },
      onHorizontalDragStart: isTimelineView ? null : _onHorizontalStart,
      onHorizontalDragUpdate: isTimelineView ? null : _onHorizontalUpdate,
      onHorizontalDragEnd: isTimelineView ? null : _onHorizontalEnd,
      onVerticalDragStart: widget.view == CalendarView.month &&
              widget.calendar.monthViewSettings.navigationDirection ==
                  MonthNavigationDirection.vertical
          ? _onVerticalStart
          : null,
      onVerticalDragUpdate: widget.view == CalendarView.month &&
              widget.calendar.monthViewSettings.navigationDirection ==
                  MonthNavigationDirection.vertical
          ? _onVerticalUpdate
          : null,
      onVerticalDragEnd: widget.view == CalendarView.month &&
              widget.calendar.monthViewSettings.navigationDirection ==
                  MonthNavigationDirection.vertical
          ? _onVerticalEnd
          : null,
    );

    return Stack(
      children: <Widget>[
        Positioned(
            left: leftPosition,
            right: rightPosition,
            bottom: bottomPosition,
            top: topPosition,
            child: RawKeyboardListener(
              focusNode: _focusNode,
              onKey: _onKeyDown,
              child: isTimelineView
                  ? Listener(
                      onPointerSignal: _handlePointerSignal,
                      child: RawGestureDetector(
                          gestures: {
                            HorizontalDragGestureRecognizer:
                                GestureRecognizerFactoryWithHandlers<
                                    HorizontalDragGestureRecognizer>(
                              () => HorizontalDragGestureRecognizer(),
                              (HorizontalDragGestureRecognizer instance) {
                                instance..onUpdate = _handleDragUpdate;
                                instance..onStart = _handleDragStart;
                                instance..onEnd = _handleDragEnd;
                                instance..onCancel = _handleDragCancel;
                              },
                            )
                          },
                          behavior: HitTestBehavior.opaque,
                          child: customScrollWidget),
                    )
                  : customScrollWidget,
            )),
      ],
    );
  }

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController.dispose();
      _animationController = null;
    }

    if (_animation != null) {
      _animation.removeListener(animationListener);
    }

    super.dispose();
  }

  /// Get the scroll layout current child view state based on its visible dates.
  GlobalKey<_CalendarViewState> _getCurrentViewByVisibleDates() {
    _CalendarView view;
    for (int i = 0; i < _children.length; i++) {
      final _CalendarView currentView = _children[i];
      if (currentView.visibleDates == _currentViewVisibleDates) {
        view = currentView;
        break;
      }
    }

    if (view == null) {
      return null;
    }
    return view.key;
  }

  /// Handle start of the scroll, set the scroll start position and check
  /// the start position as start or end of timeline scroll controller.
  /// If the timeline view scroll starts at min or max scroll position then
  /// move the previous view to end of the scroll or move the next view to
  /// start of the scroll and set the drag as timeline scroll controller drag.
  void _handleDragStart(DragStartDetails details) {
    if (!_isTimelineView(widget.view)) {
      return;
    }
    final GlobalKey<_CalendarViewState> viewKey =
        _getCurrentViewByVisibleDates();
    _timelineScrollStartPosition =
        viewKey.currentState._scrollController.position.pixels;
    _timelineStartPosition = details.globalPosition.dx;
    _isNeedTimelineScrollEnd = false;

    /// If the timeline view scroll starts at min or max scroll position then
    /// move the previous view to end of the scroll or move the next view to
    /// start of the scroll
    if (_timelineScrollStartPosition >=
        viewKey.currentState._scrollController.position.maxScrollExtent) {
      _positionTimelineView();
    } else if (_timelineScrollStartPosition <=
        viewKey.currentState._scrollController.position.minScrollExtent) {
      _positionTimelineView();
    }

    /// Set the drag as timeline scroll controller drag.
    if (viewKey.currentState._scrollController.hasClients &&
        viewKey.currentState._scrollController.position != null) {
      _drag = viewKey.currentState._scrollController.position
          .drag(details, _disposeDrag);
    }
  }

  /// Handles the scroll update, if the scroll moves after the timeline max
  /// scroll position or before the timeline min scroll position then check the
  /// scroll start position if it is start or end of the timeline scroll view
  /// then pass the touch to custom scroll view and set the timeline view
  /// drag as null;
  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isTimelineView(widget.view)) {
      return;
    }
    final GlobalKey<_CalendarViewState> viewKey =
        _getCurrentViewByVisibleDates();

    /// Calculate the scroll difference by current scroll position and start
    /// scroll position.
    final double difference =
        details.globalPosition.dx - _timelineStartPosition;
    if (_timelineScrollStartPosition >=
            viewKey.currentState._scrollController.position.maxScrollExtent &&
        ((difference < 0 && !widget.isRTL) ||
            (difference > 0 && widget.isRTL))) {
      /// Set the scroll position as timeline scroll start position and the
      /// value used on horizontal update method.
      _scrollStartPosition = _timelineStartPosition;
      _drag?.cancel();

      /// Move the touch(drag) to custom scroll view.
      _onHorizontalUpdate(details);

      /// Enable boolean value used to trigger the horizontal end animation on
      /// drag end.
      _isNeedTimelineScrollEnd = true;

      /// Remove the timeline view drag or scroll.
      _disposeDrag();
      return;
    } else if (_timelineScrollStartPosition <=
            viewKey.currentState._scrollController.position.minScrollExtent &&
        ((difference > 0 && !widget.isRTL) ||
            (difference < 0 && widget.isRTL))) {
      /// Set the scroll position as timeline scroll start position and the
      /// value used on horizontal update method.
      _scrollStartPosition = _timelineStartPosition;
      _drag?.cancel();

      /// Move the touch(drag) to custom scroll view.
      _onHorizontalUpdate(details);

      /// Enable boolean value used to trigger the horizontal end animation on
      /// drag end.
      _isNeedTimelineScrollEnd = true;

      /// Remove the timeline view drag or scroll.
      _disposeDrag();
      return;
    }

    _drag?.update(details);
  }

  /// Handle the scroll end to update the timeline view scroll or custom scroll
  /// view scroll based on [_isNeedTimelineScrollEnd] value
  void _handleDragEnd(DragEndDetails details) {
    if (_isNeedTimelineScrollEnd) {
      _isNeedTimelineScrollEnd = false;
      _onHorizontalEnd(details);
      return;
    }

    _isNeedTimelineScrollEnd = false;
    _drag?.end(details);
  }

  /// Handle drag cancel related operations.
  void _handleDragCancel() {
    _isNeedTimelineScrollEnd = false;
    _drag?.cancel();
  }

  /// Remove the drag when the touch(drag) passed to custom scroll view.
  void _disposeDrag() {
    _drag = null;
  }

  /// Handle the pointer scroll when a pointer signal occurs over this object.
  /// eg., track pad scroll.
  void _handlePointerSignal(PointerSignalEvent event) {
    final GlobalKey<_CalendarViewState> viewKey =
        _getCurrentViewByVisibleDates();
    if (event is PointerScrollEvent &&
        viewKey.currentState._scrollController.position != null) {
      final double scrolledPosition =
          widget.isRTL ? -event.scrollDelta.dx : event.scrollDelta.dx;
      final double targetScrollOffset = math.min(
          math.max(
              viewKey.currentState._scrollController.position.pixels +
                  scrolledPosition,
              viewKey.currentState._scrollController.position.minScrollExtent),
          viewKey.currentState._scrollController.position.maxScrollExtent);
      if (targetScrollOffset !=
          viewKey.currentState._scrollController.position.pixels) {
        viewKey.currentState._scrollController.position
            .jumpTo(targetScrollOffset);
      }
    }
  }

  void _updateVisibleDates() {
    widget.getCalendarState(_updateCalendarStateDetails);
    final DateTime currentDate = DateTime(
        _updateCalendarStateDetails._currentDate.year,
        _updateCalendarStateDetails._currentDate.month,
        _updateCalendarStateDetails._currentDate.day);
    final DateTime prevDate = _getPreviousViewStartDate(widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView, currentDate);
    final DateTime nextDate = _getNextViewStartDate(widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView, currentDate);
    final List<int> nonWorkingDays = (widget.view == CalendarView.workWeek ||
            widget.view == CalendarView.timelineWorkWeek)
        ? widget.calendar.timeSlotViewSettings.nonWorkingDays
        : null;
    final int visibleDatesCount = _getViewDatesCount(
        widget.view, widget.calendar.monthViewSettings.numberOfWeeksInView);

    _visibleDates = getVisibleDates(currentDate, nonWorkingDays,
        widget.calendar.firstDayOfWeek, visibleDatesCount);
    _previousViewVisibleDates = getVisibleDates(
        widget.isRTL ? nextDate : prevDate,
        nonWorkingDays,
        widget.calendar.firstDayOfWeek,
        visibleDatesCount);
    _nextViewVisibleDates = getVisibleDates(widget.isRTL ? prevDate : nextDate,
        nonWorkingDays, widget.calendar.firstDayOfWeek, visibleDatesCount);
    if (widget.view == CalendarView.timelineMonth) {
      _visibleDates = _getCurrentMonthDates(_visibleDates);
      _previousViewVisibleDates =
          _getCurrentMonthDates(_previousViewVisibleDates);
      _nextViewVisibleDates = _getCurrentMonthDates(_nextViewVisibleDates);
    }

    _currentViewVisibleDates = _visibleDates;
    _updateCalendarStateDetails._currentViewVisibleDates =
        _currentViewVisibleDates;
    widget.updateCalendarState(_updateCalendarStateDetails);

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

  void _updateNextViewVisibleDates() {
    DateTime currentViewDate = _currentViewVisibleDates[0];
    if (widget.view == CalendarView.month &&
        widget.calendar.monthViewSettings.numberOfWeeksInView == 6) {
      currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length / 2).truncate()];
    }

    if (widget.isRTL) {
      currentViewDate = _getPreviousViewStartDate(
          widget.view,
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          currentViewDate);
    } else {
      currentViewDate = _getNextViewStartDate(
          widget.view,
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          currentViewDate);
    }

    List<DateTime> dates = getVisibleDates(
        currentViewDate,
        widget.view == CalendarView.workWeek ||
                widget.view == CalendarView.timelineWorkWeek
            ? widget.calendar.timeSlotViewSettings.nonWorkingDays
            : null,
        widget.calendar.firstDayOfWeek,
        _getViewDatesCount(widget.view,
            widget.calendar.monthViewSettings.numberOfWeeksInView));

    if (widget.view == CalendarView.timelineMonth) {
      dates = _getCurrentMonthDates(dates);
    }

    if (_currentChildIndex == 0) {
      _nextViewVisibleDates = dates;
    } else if (_currentChildIndex == 1) {
      _previousViewVisibleDates = dates;
    } else {
      _visibleDates = dates;
    }
  }

  void _updatePreviousViewVisibleDates() {
    DateTime currentViewDate = _currentViewVisibleDates[0];
    if (widget.view == CalendarView.month &&
        widget.calendar.monthViewSettings.numberOfWeeksInView == 6) {
      currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length / 2).truncate()];
    }

    if (widget.isRTL) {
      currentViewDate = _getNextViewStartDate(
          widget.view,
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          currentViewDate);
    } else {
      currentViewDate = _getPreviousViewStartDate(
          widget.view,
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          currentViewDate);
    }

    List<DateTime> dates = getVisibleDates(
        currentViewDate,
        widget.view == CalendarView.workWeek ||
                widget.view == CalendarView.timelineWorkWeek
            ? widget.calendar.timeSlotViewSettings.nonWorkingDays
            : null,
        widget.calendar.firstDayOfWeek,
        _getViewDatesCount(widget.view,
            widget.calendar.monthViewSettings.numberOfWeeksInView));

    if (widget.view == CalendarView.timelineMonth) {
      dates = _getCurrentMonthDates(dates);
    }

    if (_currentChildIndex == 0) {
      _visibleDates = dates;
    } else if (_currentChildIndex == 1) {
      _nextViewVisibleDates = dates;
    } else {
      _previousViewVisibleDates = dates;
    }
  }

  void _getCalendarViewStateDetails(_UpdateCalendarStateDetails details) {
    widget.getCalendarState(_updateCalendarStateDetails);
    details._currentDate = _updateCalendarStateDetails._currentDate;
    details._currentViewVisibleDates =
        _updateCalendarStateDetails._currentViewVisibleDates;
    details._selectedDate = _updateCalendarStateDetails._selectedDate;
    details._allDayPanelHeight = _updateCalendarStateDetails._allDayPanelHeight;
    details._allDayAppointmentViewCollection =
        _updateCalendarStateDetails._allDayAppointmentViewCollection;
    details._appointments = _updateCalendarStateDetails._appointments;
    details._visibleAppointments =
        _updateCalendarStateDetails._visibleAppointments;
  }

  void _updateCalendarViewStateDetails(_UpdateCalendarStateDetails details) {
    _updateCalendarStateDetails._selectedDate = details._selectedDate;
    widget.updateCalendarState(_updateCalendarStateDetails);
  }

  /// Return collection of time region, in between the visible dates.
  List<TimeRegion> _getRegions(List<DateTime> visibleDates) {
    return _getVisibleRegions(
        visibleDates[0],
        visibleDates[visibleDates.length - 1],
        _timeRegions,
        widget.calendar.timeZone);
  }

  List<Widget> _addViews() {
    _children = _children ?? <_CalendarView>[];

    if (_children != null && _children.isEmpty) {
      _previousView = _CalendarView(
        widget.calendar,
        widget.view,
        _previousViewVisibleDates,
        widget.width,
        widget.height,
        widget.agendaSelectedDate,
        widget.locale,
        widget.calendarTheme,
        _getRegions(_previousViewVisibleDates),
        _getDatesWithInVisibleDateRange(
            widget.blackoutDates, _previousViewVisibleDates),
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        _resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        key: _previousViewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        getCalendarState: (_UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
      );
      _currentView = _CalendarView(
        widget.calendar,
        widget.view,
        _visibleDates,
        widget.width,
        widget.height,
        widget.agendaSelectedDate,
        widget.locale,
        widget.calendarTheme,
        _getRegions(_visibleDates),
        _getDatesWithInVisibleDateRange(widget.blackoutDates, _visibleDates),
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        _resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        key: _currentViewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        getCalendarState: (_UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
      );
      _nextView = _CalendarView(
        widget.calendar,
        widget.view,
        _nextViewVisibleDates,
        widget.width,
        widget.height,
        widget.agendaSelectedDate,
        widget.locale,
        widget.calendarTheme,
        _getRegions(_nextViewVisibleDates),
        _getDatesWithInVisibleDateRange(
            widget.blackoutDates, _nextViewVisibleDates),
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        _resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        key: _nextViewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        getCalendarState: (_UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
      );

      _children.add(_previousView);
      _children.add(_currentView);
      _children.add(_nextView);
      return _children;
    }

    widget.getCalendarState(_updateCalendarStateDetails);
    final _CalendarView previousView = _updateViews(
        _previousView, _previousViewKey, _previousViewVisibleDates);
    final _CalendarView currentView =
        _updateViews(_currentView, _currentViewKey, _visibleDates);
    final _CalendarView nextView =
        _updateViews(_nextView, _nextViewKey, _nextViewVisibleDates);

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
  _CalendarView _updateViews(_CalendarView view,
      GlobalKey<_CalendarViewState> viewKey, List<DateTime> visibleDates) {
    final int index = _children.indexOf(view);

    final _AppointmentLayout appointmentLayout =
        viewKey.currentState._appointmentLayoutKey.currentWidget;
    // update the view with the visible dates on swiping end.
    if (view.visibleDates != visibleDates) {
      view = _CalendarView(
        widget.calendar,
        widget.view,
        visibleDates,
        widget.width,
        widget.height,
        widget.agendaSelectedDate,
        widget.locale,
        widget.calendarTheme,
        _getRegions(visibleDates),
        _getDatesWithInVisibleDateRange(widget.blackoutDates, visibleDates),
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        _resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        key: viewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        getCalendarState: (_UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
      );

      _children[index] = view;
    } // check and update the visible appointments in the view
    else if (!_isCollectionEqual(appointmentLayout.visibleAppointments.value,
        _updateCalendarStateDetails._visibleAppointments)) {
      if (widget.view != CalendarView.month && !_isTimelineView(widget.view)) {
        view = _CalendarView(
          widget.calendar,
          widget.view,
          visibleDates,
          widget.width,
          widget.height,
          widget.agendaSelectedDate,
          widget.locale,
          widget.calendarTheme,
          view.regions,
          view.blackoutDates,
          _focusNode,
          widget.removePicker,
          widget.calendar.allowViewNavigation,
          widget.controller,
          widget.resourcePanelScrollController,
          _resourceCollection,
          widget.textScaleFactor,
          widget.isMobilePlatform,
          key: viewKey,
          updateCalendarState: (_UpdateCalendarStateDetails details) {
            _updateCalendarViewStateDetails(details);
          },
          getCalendarState: (_UpdateCalendarStateDetails details) {
            _getCalendarViewStateDetails(details);
          },
        );
        _children[index] = view;
      } else if (view.visibleDates == _currentViewVisibleDates) {
        appointmentLayout.visibleAppointments.value =
            _updateCalendarStateDetails._visibleAppointments;
        if (widget.view == CalendarView.month &&
            widget.calendar.monthCellBuilder != null) {
          viewKey.currentState._monthView.visibleAppointmentNotifier.value =
              _updateCalendarStateDetails._visibleAppointments;
        }
      }
    }
    // When calendar state changed the state doesn't pass to the child of
    // custom scroll view, hence to update the calendar state to the child we
    // have added this.
    else if (view.calendar != widget.calendar) {
      /// Update the calendar view when calendar properties like blackout dates
      /// dynamically changed.
      view = _CalendarView(
        widget.calendar,
        widget.view,
        visibleDates,
        widget.width,
        widget.height,
        widget.agendaSelectedDate,
        widget.locale,
        widget.calendarTheme,
        view.regions,
        view.blackoutDates,
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        _resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        key: viewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        getCalendarState: (_UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
      );

      _children[index] = view;
    }

    return view;
  }

  void animationListener() {
    setState(() {
      _position = _animation.value;
    });
  }

  /// Check both the region collection as equal or not.
  bool _isTimeRegionsEquals(
      List<TimeRegion> regions1, List<TimeRegion> regions2) {
    /// Check both instance as equal
    /// eg., if both are null then its equal.
    if (regions1 == regions2) {
      return true;
    }

    /// Check the collections are not equal based on its length
    if ((regions1 != null && regions2 == null) ||
        (regions1 == null && regions2 != null) ||
        (regions1.length != regions2.length)) {
      return false;
    }

    /// Check each of the region is equal to another or not.
    for (int i = 0; i < regions1.length; i++) {
      if (regions1[i] != regions2[i]) {
        return false;
      }
    }

    return true;
  }

  /// Updates the selected date programmatically, when resource enables, in
  /// this scenario the first resource cell will be selected
  void _selectResourceProgrammatically() {
    if (!_isTimelineView(widget.view)) {
      return;
    }

    for (int i = 0; i < _children.length; i++) {
      final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
      if (_isResourceEnabled(widget.calendar.dataSource, widget.view)) {
        viewKey.currentState._selectedResourceIndex = 0;
        viewKey.currentState._selectionPainter.selectedResourceIndex = 0;
      } else {
        viewKey.currentState._selectedResourceIndex = -1;
        viewKey.currentState._selectionPainter.selectedResourceIndex = -1;
      }
    }
  }

  /// Updates the selection, when the resource enabled and the resource
  /// collection modified, moves or removes the selection based on the action
  /// performed.
  void _updateSelectedResourceIndex() {
    for (int i = 0; i < _children.length; i++) {
      final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
      final int selectedResourceIndex =
          viewKey.currentState._selectedResourceIndex;
      if (selectedResourceIndex != -1) {
        final Object selectedResourceId =
            _resourceCollection[selectedResourceIndex].id;
        final int newIndex = _getResourceIndex(
            widget.calendar.dataSource?.resources, selectedResourceId);
        viewKey.currentState._selectedResourceIndex = newIndex;
      }
    }
  }

  void _updateSelection() {
    widget.getCalendarState(_updateCalendarStateDetails);
    final _CalendarViewState previousViewState = _previousViewKey.currentState;
    final _CalendarViewState currentViewState = _currentViewKey.currentState;
    final _CalendarViewState nextViewState = _nextViewKey.currentState;
    previousViewState._allDaySelectionNotifier?.value = null;
    currentViewState._allDaySelectionNotifier?.value = null;
    nextViewState._allDaySelectionNotifier?.value = null;
    previousViewState._selectionPainter.selectedDate =
        _updateCalendarStateDetails._selectedDate;
    nextViewState._selectionPainter.selectedDate =
        _updateCalendarStateDetails._selectedDate;
    currentViewState._selectionPainter.selectedDate =
        _updateCalendarStateDetails._selectedDate;
    previousViewState._selectionNotifier.value =
        !previousViewState._selectionNotifier.value;
    currentViewState._selectionNotifier.value =
        !currentViewState._selectionNotifier.value;
    nextViewState._selectionNotifier.value =
        !nextViewState._selectionNotifier.value;
    if (previousViewState._selectionPainter._appointmentView != null &&
        previousViewState._selectionPainter._appointmentView.appointment !=
            null) {
      _selectedAppointmentView = _cloneAppointmentView(
          previousViewState._selectionPainter._appointmentView);
    } else if (currentViewState._selectionPainter._appointmentView != null &&
        currentViewState._selectionPainter._appointmentView.appointment !=
            null) {
      _selectedAppointmentView = _cloneAppointmentView(
          currentViewState._selectionPainter._appointmentView);
    } else if (nextViewState._selectionPainter._appointmentView != null &&
        nextViewState._selectionPainter._appointmentView.appointment != null) {
      _selectedAppointmentView = _cloneAppointmentView(
          nextViewState._selectionPainter._appointmentView);
    }

    previousViewState._selectionPainter._appointmentView =
        _selectedAppointmentView;
    nextViewState._selectionPainter._appointmentView = _selectedAppointmentView;
    currentViewState._selectionPainter._appointmentView =
        _selectedAppointmentView;
  }

  _AppointmentView _cloneAppointmentView(_AppointmentView view) {
    final _AppointmentView clonedView = _AppointmentView();
    clonedView.appointment = view.appointment;
    clonedView.appointmentRect = view.appointmentRect;
    return clonedView;
  }

  void _updateMoveToDate() {
    if (widget.view == CalendarView.month) {
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_currentChildIndex == 0) {
        _previousViewKey.currentState._scrollToPosition();
      } else if (_currentChildIndex == 1) {
        _currentViewKey.currentState._scrollToPosition();
      } else if (_currentChildIndex == 2) {
        _nextViewKey.currentState._scrollToPosition();
      }
    });
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

    _updateCalendarStateDetails._currentViewVisibleDates =
        _currentViewVisibleDates;
    if (widget.view == CalendarView.month &&
        widget.calendar.monthViewSettings.numberOfWeeksInView == 6) {
      final DateTime currentMonthDate =
          _currentViewVisibleDates[_currentViewVisibleDates.length ~/ 2];
      _updateCalendarStateDetails._currentDate =
          DateTime(currentMonthDate.year, currentMonthDate.month, 01);
    } else {
      _updateCalendarStateDetails._currentDate = _currentViewVisibleDates[0];
    }

    widget.updateCalendarState(_updateCalendarStateDetails);
  }

  void _updateNextView() {
    if (!_animationController.isCompleted) {
      return;
    }

    _updateSelection();
    _updateNextViewVisibleDates();

    /// Updates the all day panel of the view, when the all day panel expanded
    /// and the view swiped with the expanded all day panel, and when we swipe
    /// back to the view or swipes three times will render the all day panel as
    /// expanded, to collapse the all day panel in day, week and work week view,
    /// we have added this condition and called the method.
    if (widget.view != CalendarView.month && !_isTimelineView(widget.view)) {
      _updateAllDayPanel();
    }

    setState(() {
      /// Update the custom scroll layout current child index when the
      /// animation ends.
      if (_currentChildIndex == 0) {
        _currentChildIndex = 1;
      } else if (_currentChildIndex == 1) {
        _currentChildIndex = 2;
      } else if (_currentChildIndex == 2) {
        _currentChildIndex = 0;
      }
    });

    _resetPosition();
    _updateAppointmentPainter();
  }

  void _updatePreviousView() {
    if (!_animationController.isCompleted) {
      return;
    }

    _updateSelection();
    _updatePreviousViewVisibleDates();

    /// Updates the all day panel of the view, when the all day panel expanded
    /// and the view swiped with the expanded all day panel, and when we swipe
    /// back to the view or swipes three times will render the all day panel as
    /// expanded, to collapse the all day panel in day, week and work week view,
    /// we have added this condition and called the method.
    if (widget.view != CalendarView.month && !_isTimelineView(widget.view)) {
      _updateAllDayPanel();
    }

    setState(() {
      /// Update the custom scroll layout current child index when the
      /// animation ends.
      if (_currentChildIndex == 0) {
        _currentChildIndex = 2;
      } else if (_currentChildIndex == 1) {
        _currentChildIndex = 0;
      } else if (_currentChildIndex == 2) {
        _currentChildIndex = 1;
      }
    });

    _resetPosition();
    _updateAppointmentPainter();
  }

  void _moveToNextViewWithAnimation() {
    if (!widget.isMobilePlatform) {
      _moveToNextWebViewWithAnimation();
      return;
    }

    if (!_canMoveToNextView(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        widget.calendar.minDate,
        widget.calendar.maxDate,
        _currentViewVisibleDates,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.isRTL)) {
      return;
    }

    // Resets the controller to forward it again, the animation will forward
    // only from the dismissed state
    if (_animationController.isCompleted || _animationController.isDismissed) {
      _animationController.reset();
    } else {
      return;
    }

    // Handled for time line view, to move the previous and next view to it's
    // start and end position accordingly
    if (_isTimelineView(widget.view)) {
      _positionTimelineView(isScrolledToEnd: false);
    }

    if (widget.calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        widget.view == CalendarView.month) {
      // update the bottom to top swiping
      _tween.begin = 0;
      _tween.end = -widget.height;
    } else {
      // update the right to left swiping
      _tween.begin = 0;
      _tween.end = -widget.width;
    }

    _animationController.duration = const Duration(milliseconds: 250);
    _animationController
        .forward()
        .then<dynamic>((dynamic value) => _updateNextView());

    /// updates the current view visible dates when the view swiped
    _updateCurrentViewVisibleDates(isNextView: true);
  }

  void _moveToPreviousViewWithAnimation() {
    if (!widget.isMobilePlatform) {
      _moveToPreviousWebViewWithAnimation();
      return;
    }

    if (!_canMoveToPreviousView(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        widget.calendar.minDate,
        widget.calendar.maxDate,
        _currentViewVisibleDates,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.isRTL)) {
      return;
    }

    // Resets the controller to backward it again, the animation will backward
    // only from the dismissed state
    if (_animationController.isCompleted || _animationController.isDismissed) {
      _animationController.reset();
    } else {
      return;
    }

    // Handled for time line view, to move the previous and next view to it's
    // start and end position accordingly
    if (_isTimelineView(widget.view)) {
      _positionTimelineView(isScrolledToEnd: false);
    }

    if (widget.calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        widget.view == CalendarView.month) {
      // update the top to bottom swiping
      _tween.begin = 0;
      _tween.end = widget.height;
    } else {
      // update the left to right swiping
      _tween.begin = 0;
      _tween.end = widget.width;
    }

    _animationController.duration = const Duration(milliseconds: 250);
    _animationController
        .forward()
        .then<dynamic>((dynamic value) => _updatePreviousView());

    /// updates the current view visible dates when the view swiped.
    _updateCurrentViewVisibleDates();
  }

  void _moveToPreviousWebViewWithAnimation() {
    if (!_canMoveToPreviousView(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        widget.calendar.minDate,
        widget.calendar.maxDate,
        _currentViewVisibleDates,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.isRTL)) {
      return;
    }

    // Resets the controller to backward it again, the animation will backward
    // only from the dismissed state
    if (widget.fadeInController.isCompleted ||
        widget.fadeInController.isDismissed) {
      widget.fadeInController.reset();
    } else {
      return;
    }

    // Handled for time line view, to move the previous and next view to it's
    // start and end position accordingly
    if (_isTimelineView(widget.view)) {
      _positionTimelineView(isScrolledToEnd: false);
    } else if (!_isTimelineView(widget.view) &&
        widget.view != CalendarView.month) {
      _updateDayViewScrollPosition();
    }

    /// updates the current view visible dates when the view swiped.
    _updateCurrentViewVisibleDates();
    _position = 0;
    widget.fadeInController.forward();
    _updateSelection();
    _updatePreviousViewVisibleDates();

    /// Updates the all day panel of the view, when the all day panel expanded
    /// and the view swiped with the expanded all day panel, and when we swipe
    /// back to the view or swipes three times will render the all day panel as
    /// expanded, to collapse the all day panel in day, week and work week view,
    /// we have added this condition and called the method.
    if (widget.view != CalendarView.month && !_isTimelineView(widget.view)) {
      _updateAllDayPanel();
    }

    if (_currentChildIndex == 0) {
      _currentChildIndex = 2;
    } else if (_currentChildIndex == 1) {
      _currentChildIndex = 0;
    } else if (_currentChildIndex == 2) {
      _currentChildIndex = 1;
    }

    _updateAppointmentPainter();
  }

  void _moveToNextWebViewWithAnimation() {
    if (!_canMoveToNextView(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        widget.calendar.minDate,
        widget.calendar.maxDate,
        _currentViewVisibleDates,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.isRTL)) {
      return;
    }

    // Resets the controller to forward it again, the animation will forward
    // only from the dismissed state
    if (widget.fadeInController.isCompleted ||
        widget.fadeInController.isDismissed) {
      widget.fadeInController.reset();
    } else {
      return;
    }

    // Handled for time line view, to move the previous and next view to it's
    // start and end position accordingly
    if (_isTimelineView(widget.view)) {
      _positionTimelineView(isScrolledToEnd: false);
    } else if (!_isTimelineView(widget.view) &&
        widget.view != CalendarView.month) {
      _updateDayViewScrollPosition();
    }

    /// updates the current view visible dates when the view swiped
    _updateCurrentViewVisibleDates(isNextView: true);

    _position = 0;
    widget.fadeInController.forward();
    _updateSelection();
    _updateNextViewVisibleDates();

    /// Updates the all day panel of the view, when the all day panel expanded
    /// and the view swiped with the expanded all day panel, and when we swipe
    /// back to the view or swipes three times will render the all day panel as
    /// expanded, to collapse the all day panel in day, week and work week view,
    /// we have added this condition and called the method.
    if (widget.view != CalendarView.month && !_isTimelineView(widget.view)) {
      _updateAllDayPanel();
    }

    if (_currentChildIndex == 0) {
      _currentChildIndex = 1;
    } else if (_currentChildIndex == 1) {
      _currentChildIndex = 2;
    } else if (_currentChildIndex == 2) {
      _currentChildIndex = 0;
    }

    _updateAppointmentPainter();
  }

  // resets position to zero on the swipe end to avoid the unwanted date updates
  void _resetPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_position.abs() == widget.width || _position.abs() == widget.height) {
        _position = 0;
      }
    });
  }

  void _updateScrollPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_previousView == null ||
          _currentView == null ||
          _nextView == null ||
          _previousViewKey.currentState == null ||
          _currentViewKey.currentState == null ||
          _nextViewKey.currentState == null ||
          _previousViewKey.currentState._scrollController == null ||
          _currentViewKey.currentState._scrollController == null ||
          _nextViewKey.currentState._scrollController == null ||
          !_previousViewKey.currentState._scrollController.hasClients ||
          !_currentViewKey.currentState._scrollController.hasClients ||
          !_nextViewKey.currentState._scrollController.hasClients) {
        return;
      }

      _updateDayViewScrollPosition();
    });
  }

  /// Update the current day view view scroll position to other views.
  void _updateDayViewScrollPosition() {
    double scrolledPosition = 0;
    if (_currentChildIndex == 0) {
      scrolledPosition = _previousViewKey.currentState._scrollController.offset;
    } else if (_currentChildIndex == 1) {
      scrolledPosition = _currentViewKey.currentState._scrollController.offset;
    } else if (_currentChildIndex == 2) {
      scrolledPosition = _nextViewKey.currentState._scrollController.offset;
    }

    if (_previousViewKey.currentState._scrollController.offset !=
            scrolledPosition &&
        _previousViewKey
                .currentState._scrollController.position.maxScrollExtent >=
            scrolledPosition) {
      _previousViewKey.currentState._scrollController.jumpTo(scrolledPosition);
    }

    if (_currentViewKey.currentState._scrollController.offset !=
            scrolledPosition &&
        _currentViewKey
                .currentState._scrollController.position.maxScrollExtent >=
            scrolledPosition) {
      _currentViewKey.currentState._scrollController.jumpTo(scrolledPosition);
    }

    if (_nextViewKey.currentState._scrollController.offset !=
            scrolledPosition &&
        _nextViewKey.currentState._scrollController.position.maxScrollExtent >=
            scrolledPosition) {
      _nextViewKey.currentState._scrollController.jumpTo(scrolledPosition);
    }
  }

  int _getRowOfDate(
      List<DateTime> visibleDates, _CalendarViewState currentViewState) {
    for (int i = 0; i < visibleDates.length; i++) {
      if (isSameDate(
          currentViewState._selectionPainter.selectedDate, visibleDates[i])) {
        switch (widget.view) {
          case CalendarView.day:
          case CalendarView.week:
          case CalendarView.workWeek:
          case CalendarView.schedule:
            return null;
          case CalendarView.month:
            return i ~/ _kNumberOfDaysInWeek;
          case CalendarView.timelineDay:
          case CalendarView.timelineWeek:
          case CalendarView.timelineWorkWeek:
          case CalendarView.timelineMonth:
            return i;
        }
      }
    }

    return null;
  }

  DateTime _updateSelectedDateForRightArrow(
      _CalendarView currentView, _CalendarViewState currentViewState) {
    DateTime selectedDate;

    /// Condition added to move the view to next view when the selection reaches
    /// the last horizontal cell of the view in day, week, workweek, month and
    /// timeline month.
    if (!_isTimelineView(widget.view)) {
      final int visibleDatesCount = currentView.visibleDates.length;
      if (isSameDate(currentView.visibleDates[visibleDatesCount - 1],
          currentViewState._selectionPainter.selectedDate)) {
        _moveToNextViewWithAnimation();
      }

      selectedDate = addDuration(
          currentViewState._selectionPainter.selectedDate,
          const Duration(days: 1));

      /// Move to next view when the new selected date as next month date.
      if (widget.view == CalendarView.month &&
          !_isCurrentMonthDate(
              widget.calendar.monthViewSettings.numberOfWeeksInView,
              widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
              currentView.visibleDates[visibleDatesCount ~/ 2].month,
              selectedDate)) {
        _moveToNextViewWithAnimation();
      } else if (widget.view == CalendarView.workWeek) {
        for (int i = 0;
            i <
                _kNumberOfDaysInWeek -
                    widget.calendar.timeSlotViewSettings.nonWorkingDays.length;
            i++) {
          if (widget.calendar.timeSlotViewSettings.nonWorkingDays
              .contains(selectedDate.weekday)) {
            selectedDate = addDuration(selectedDate, const Duration(days: 1));
          } else {
            break;
          }
        }
      }
    } else {
      final double xPosition = widget.view == CalendarView.timelineMonth
          ? 0
          : _timeToPosition(
              widget.calendar,
              currentViewState._selectionPainter.selectedDate,
              currentViewState._timeIntervalHeight);
      final int rowIndex =
          _getRowOfDate(currentView.visibleDates, currentViewState);
      final double singleChildWidth =
          _getSingleViewWidthForTimeLineView(currentViewState);
      if ((rowIndex * singleChildWidth) +
              xPosition +
              currentViewState._timeIntervalHeight >=
          currentViewState._scrollController.offset + widget.width) {
        currentViewState._scrollController.jumpTo(
            currentViewState._scrollController.offset +
                currentViewState._timeIntervalHeight);
      }
      if (widget.view == CalendarView.timelineDay &&
          addDuration(currentViewState._selectionPainter.selectedDate,
                      widget.calendar.timeSlotViewSettings.timeInterval)
                  .day !=
              currentView
                  .visibleDates[currentView.visibleDates.length - 1].day) {
        _moveToNextViewWithAnimation();
      }

      if ((rowIndex * singleChildWidth) +
              xPosition +
              currentViewState._timeIntervalHeight ==
          currentViewState._scrollController.position.maxScrollExtent +
              currentViewState._scrollController.position.viewportDimension) {
        _moveToNextViewWithAnimation();
      }

      /// For timeline month view each column represents a single day, and for
      /// other timeline views each column represents a given time interval,
      /// hence to update the selected date for timeline month we must add a day
      /// and for other timeline views we must add the given time interval.
      if (widget.view == CalendarView.timelineMonth) {
        selectedDate = addDuration(
            currentViewState._selectionPainter.selectedDate,
            const Duration(days: 1));
      } else {
        selectedDate = addDuration(
            currentViewState._selectionPainter.selectedDate,
            widget.calendar.timeSlotViewSettings.timeInterval);
      }
      if (widget.view == CalendarView.timelineWorkWeek) {
        for (int i = 0;
            i <
                _kNumberOfDaysInWeek -
                    widget.calendar.timeSlotViewSettings.nonWorkingDays.length;
            i++) {
          if (widget.calendar.timeSlotViewSettings.nonWorkingDays
              .contains(selectedDate.weekday)) {
            selectedDate = addDuration(selectedDate, const Duration(days: 1));
          } else {
            break;
          }
        }
      }
    }

    return selectedDate;
  }

  DateTime _updateSelectedDateForLeftArrow(
      _CalendarView currentView, _CalendarViewState currentViewState) {
    DateTime selectedDate;
    if (!_isTimelineView(widget.view)) {
      if (isSameDate(currentViewState.widget.visibleDates[0],
          currentViewState._selectionPainter.selectedDate)) {
        _moveToPreviousViewWithAnimation();
      }
      selectedDate = addDuration(
          currentViewState._selectionPainter.selectedDate,
          const Duration(days: -1));

      /// Move to previous view when the selected date as previous month date.
      if (widget.view == CalendarView.month &&
          !_isCurrentMonthDate(
              widget.calendar.monthViewSettings.numberOfWeeksInView,
              widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
              currentView
                  .visibleDates[currentView.visibleDates.length ~/ 2].month,
              selectedDate)) {
        _moveToPreviousViewWithAnimation();
      } else if (widget.view == CalendarView.workWeek) {
        for (int i = 0;
            i <
                _kNumberOfDaysInWeek -
                    widget.calendar.timeSlotViewSettings.nonWorkingDays.length;
            i++) {
          if (widget.calendar.timeSlotViewSettings.nonWorkingDays
              .contains(selectedDate.weekday)) {
            selectedDate = addDuration(selectedDate, const Duration(days: -1));
          } else {
            break;
          }
        }
      }
    } else {
      final double xPosition = widget.view == CalendarView.timelineMonth
          ? 0
          : _timeToPosition(
              widget.calendar,
              currentViewState._selectionPainter.selectedDate,
              currentViewState._timeIntervalHeight);
      final int rowIndex =
          _getRowOfDate(currentView.visibleDates, currentViewState);
      final double singleChildWidth =
          _getSingleViewWidthForTimeLineView(currentViewState);

      if ((rowIndex * singleChildWidth) + xPosition == 0) {
        _moveToPreviousViewWithAnimation();
      }

      if ((rowIndex * singleChildWidth) + xPosition <=
          currentViewState._scrollController.offset) {
        currentViewState._scrollController.jumpTo(
            currentViewState._scrollController.offset -
                currentViewState._timeIntervalHeight);
      }

      /// For timeline month view each column represents a single day, and for
      /// other timeline views each column represents a given time interval,
      /// hence to update the selected date for timeline month we must subtract
      /// a day and for other timeline views we must subtract the given time
      /// interval.
      if (widget.view == CalendarView.timelineMonth) {
        selectedDate = addDuration(
            currentViewState._selectionPainter.selectedDate,
            const Duration(days: -1));
      } else {
        selectedDate = subtractDuration(
            currentViewState._selectionPainter.selectedDate,
            widget.calendar.timeSlotViewSettings.timeInterval);
      }
      if (widget.view == CalendarView.timelineWorkWeek) {
        for (int i = 0;
            i <
                _kNumberOfDaysInWeek -
                    widget.calendar.timeSlotViewSettings.nonWorkingDays.length;
            i++) {
          if (widget.calendar.timeSlotViewSettings.nonWorkingDays
              .contains(selectedDate.weekday)) {
            selectedDate = addDuration(selectedDate, const Duration(days: -1));
          } else {
            break;
          }
        }
      }
    }

    return selectedDate;
  }

  DateTime _updateSelectedDateForUpArrow(
      _CalendarView currentView, _CalendarViewState currentViewState) {
    if (widget.view == CalendarView.month) {
      final int rowIndex =
          _getRowOfDate(currentView.visibleDates, currentViewState);
      if (rowIndex == 0) {
        return currentViewState._selectionPainter.selectedDate;
      }

      DateTime selectedDate = addDuration(
          currentViewState._selectionPainter.selectedDate,
          const Duration(days: -_kNumberOfDaysInWeek));

      /// Move to month start date when the new selected date as
      /// previous month date.
      if (!_isCurrentMonthDate(
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
          currentView.visibleDates[currentView.visibleDates.length ~/ 2].month,
          selectedDate)) {
        selectedDate =
            _getMonthStartDate(currentViewState._selectionPainter.selectedDate);
      }

      return selectedDate;
    } else if (!_isTimelineView(widget.view)) {
      final double yPosition = _timeToPosition(
          widget.calendar,
          currentViewState._selectionPainter.selectedDate,
          currentViewState._timeIntervalHeight);
      if (yPosition == 0) {
        return currentViewState._selectionPainter.selectedDate;
      }
      if (yPosition <= currentViewState._scrollController.offset) {
        currentViewState._scrollController
            .jumpTo(yPosition - currentViewState._timeIntervalHeight);
      }
      return subtractDuration(currentViewState._selectionPainter.selectedDate,
          widget.calendar.timeSlotViewSettings.timeInterval);
    } else if (_isResourceEnabled(widget.calendar.dataSource, widget.view)) {
      final double resourceItemHeight = _getResourceItemHeight(
          widget.calendar.resourceViewSettings.size,
          widget.height,
          widget.calendar.resourceViewSettings,
          widget.calendar.dataSource.resources.length);

      if (currentViewState._selectedResourceIndex == 0 ||
          currentViewState._selectedResourceIndex == -1) {
        currentViewState._selectedResourceIndex = 0;
      }

      currentViewState._selectedResourceIndex -= 1;

      if (currentViewState._selectedResourceIndex * resourceItemHeight <=
          currentViewState._timelineViewVerticalScrollController.offset) {
        currentViewState._timelineViewVerticalScrollController.jumpTo(
            currentViewState._timelineViewVerticalScrollController.offset -
                resourceItemHeight);
      }

      return currentViewState._selectionPainter.selectedDate;
    }

    return null;
  }

  DateTime _updateSelectedDateForDownArrow(
      _CalendarView currentView, _CalendarViewState currentViewState) {
    if (widget.view == CalendarView.month) {
      final int rowIndex =
          _getRowOfDate(currentView.visibleDates, currentViewState);
      if (rowIndex ==
          widget.calendar.monthViewSettings.numberOfWeeksInView - 1) {
        return currentViewState._selectionPainter.selectedDate;
      }

      DateTime selectedDate = addDuration(
          currentViewState._selectionPainter.selectedDate,
          const Duration(days: _kNumberOfDaysInWeek));

      /// Move to month end date when the new selected date as next month date.
      if (!_isCurrentMonthDate(
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
          currentView.visibleDates[currentView.visibleDates.length ~/ 2].month,
          selectedDate)) {
        selectedDate =
            _getMonthEndDate(currentViewState._selectionPainter.selectedDate);
      }
      return selectedDate;
    } else if (!_isTimelineView(widget.view)) {
      final double viewHeaderHeight =
          _getViewHeaderHeight(widget.calendar.viewHeaderHeight, widget.view);
      final double yPosition = _timeToPosition(
          widget.calendar,
          currentViewState._selectionPainter.selectedDate,
          currentViewState._timeIntervalHeight);

      if (addDuration(currentViewState._selectionPainter.selectedDate,
                  widget.calendar.timeSlotViewSettings.timeInterval)
              .day !=
          currentViewState._selectionPainter.selectedDate.day) {
        return currentViewState._selectionPainter.selectedDate;
      }

      if (yPosition +
                  currentViewState._timeIntervalHeight +
                  widget.calendar.headerHeight +
                  viewHeaderHeight >=
              currentViewState._scrollController.offset + widget.height &&
          currentViewState._scrollController.offset +
                  currentViewState
                      ._scrollController.position.viewportDimension !=
              currentViewState._scrollController.position.maxScrollExtent) {
        currentViewState._scrollController.jumpTo(
            currentViewState._scrollController.offset +
                currentViewState._timeIntervalHeight);
      }
      return addDuration(currentViewState._selectionPainter.selectedDate,
          widget.calendar.timeSlotViewSettings.timeInterval);
    } else if (_isResourceEnabled(widget.calendar.dataSource, widget.view)) {
      final double resourceItemHeight = _getResourceItemHeight(
          widget.calendar.resourceViewSettings.size,
          widget.height,
          widget.calendar.resourceViewSettings,
          widget.calendar.dataSource.resources.length);
      if (currentViewState._selectedResourceIndex ==
              widget.calendar.dataSource.resources.length - 1 ||
          currentViewState._selectedResourceIndex == -1) {
        currentViewState._selectedResourceIndex =
            widget.calendar.dataSource.resources.length - 1;
      }

      currentViewState._selectedResourceIndex += 1;

      if (currentViewState._selectedResourceIndex * resourceItemHeight >=
          currentViewState._timelineViewVerticalScrollController.offset +
              currentViewState._timelineViewVerticalScrollController.position
                  .viewportDimension) {
        currentViewState._timelineViewVerticalScrollController.jumpTo(
            currentViewState._timelineViewVerticalScrollController.offset +
                resourceItemHeight);
      }

      return currentViewState._selectionPainter.selectedDate;
    }

    return null;
  }

  DateTime _updateSelectedDate(RawKeyEvent event,
      _CalendarViewState currentViewState, _CalendarView currentView) {
    if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
      return _updateSelectedDateForRightArrow(currentView, currentViewState);
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
      return _updateSelectedDateForLeftArrow(currentView, currentViewState);
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowUp) {
      return _updateSelectedDateForUpArrow(currentView, currentViewState);
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown) {
      return _updateSelectedDateForDownArrow(currentView, currentViewState);
    }

    return null;
  }

  /// Checks the selected date is enabled or not.
  bool _isSelectedDateEnabled(DateTime date) {
    if (!isDateWithInDateRange(
        widget.calendar.minDate, widget.calendar.maxDate, date)) {
      return false;
    }

    final List<DateTime> blackoutDates = <DateTime>[];
    if (_currentView.blackoutDates != null) {
      blackoutDates.addAll(_currentView.blackoutDates);
    }
    if (_previousView.blackoutDates != null) {
      blackoutDates.addAll(_previousView.blackoutDates);
    }
    if (_nextView.blackoutDates != null) {
      blackoutDates.addAll(_nextView.blackoutDates);
    }

    final List<TimeRegion> regions = <TimeRegion>[];
    if (_currentView.regions != null) {
      regions.addAll(_currentView.regions);
    }
    if (_previousView.regions != null) {
      regions.addAll(_previousView.regions);
    }
    if (_nextView.regions != null) {
      regions.addAll(_nextView.regions);
    }

    if ((widget.view == CalendarView.month ||
            widget.view == CalendarView.timelineMonth) &&
        _isDateInDateCollection(blackoutDates, date)) {
      return false;
    } else if (widget.view != CalendarView.month) {
      for (int i = 0; i < regions.length; i++) {
        final TimeRegion region = regions[i];
        if (region.enablePointerInteraction ||
            (region._actualStartTime.isAfter(date) &&
                !_isSameTimeSlot(region._actualStartTime, date)) ||
            region._actualEndTime.isBefore(date) ||
            _isSameTimeSlot(region._actualEndTime, date)) {
          continue;
        }

        return false;
      }
    }

    return true;
  }

  void _onKeyDown(RawKeyEvent event) {
    if (event.runtimeType != RawKeyDownEvent) {
      return;
    }

    widget.removePicker();
    _CalendarViewState currentVisibleViewState;
    _CalendarView currentVisibleView;
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

    if (currentVisibleViewState._selectionPainter.selectedDate != null &&
        isDateWithInDateRange(
            currentVisibleViewState.widget.visibleDates[0],
            currentVisibleViewState.widget.visibleDates[
                currentVisibleViewState.widget.visibleDates.length - 1],
            currentVisibleViewState._selectionPainter.selectedDate)) {
      final DateTime selectedDate = _updateSelectedDate(
          event, currentVisibleViewState, currentVisibleView);

      if (selectedDate == null) {
        return;
      }

      if (!_isSelectedDateEnabled(selectedDate)) {
        return;
      }

      if (widget.view == CalendarView.month) {
        widget.agendaSelectedDate.value = selectedDate;
      }

      _updateCalendarStateDetails._selectedDate = selectedDate;
      currentVisibleViewState._selectionPainter.selectedDate = selectedDate;
      currentVisibleViewState._selectionPainter._appointmentView = null;
      currentVisibleViewState._selectionPainter.selectedResourceIndex =
          currentVisibleViewState._selectedResourceIndex;
      currentVisibleViewState._selectionNotifier.value =
          !currentVisibleViewState._selectionNotifier.value;

      widget.updateCalendarState(_updateCalendarStateDetails);
    }
  }

  void _positionTimelineView({bool isScrolledToEnd = true}) {
    final _CalendarViewState previousViewState = _previousViewKey.currentState;
    final _CalendarViewState currentViewState = _currentViewKey.currentState;
    final _CalendarViewState nextViewState = _nextViewKey.currentState;
    if (widget.isRTL) {
      if (_currentChildIndex == 0) {
        currentViewState._scrollController.jumpTo(isScrolledToEnd
            ? currentViewState._scrollController.position.maxScrollExtent
            : 0);
        nextViewState._scrollController.jumpTo(0);
      } else if (_currentChildIndex == 1) {
        nextViewState._scrollController.jumpTo(isScrolledToEnd
            ? nextViewState._scrollController.position.maxScrollExtent
            : 0);
        previousViewState._scrollController.jumpTo(0);
      } else if (_currentChildIndex == 2) {
        previousViewState._scrollController.jumpTo(isScrolledToEnd
            ? previousViewState._scrollController.position.maxScrollExtent
            : 0);
        currentViewState._scrollController.jumpTo(0);
      }
    } else {
      if (_currentChildIndex == 0) {
        nextViewState._scrollController.jumpTo(isScrolledToEnd
            ? nextViewState._scrollController.position.maxScrollExtent
            : 0);
        currentViewState._scrollController.jumpTo(0);
      } else if (_currentChildIndex == 1) {
        previousViewState._scrollController.jumpTo(isScrolledToEnd
            ? previousViewState._scrollController.position.maxScrollExtent
            : 0);
        nextViewState._scrollController.jumpTo(0);
      } else if (_currentChildIndex == 2) {
        currentViewState._scrollController.jumpTo(isScrolledToEnd
            ? currentViewState._scrollController.position.maxScrollExtent
            : 0);
        previousViewState._scrollController.jumpTo(0);
      }
    }
  }

  void _onHorizontalStart(DragStartDetails dragStartDetails) {
    widget.removePicker();
    if (widget.calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget.view != CalendarView.month) {
      _scrollStartPosition = dragStartDetails.globalPosition.dx;
    }

    // Handled for time line view, to move the previous and next view to it's
    // start and end position accordingly
    if (_isTimelineView(widget.view)) {
      _positionTimelineView();
    }
  }

  void _onHorizontalUpdate(DragUpdateDetails dragUpdateDetails) {
    widget.removePicker();

    if (widget.calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget.view != CalendarView.month) {
      final double difference =
          dragUpdateDetails.globalPosition.dx - _scrollStartPosition;
      if (difference < 0 &&
          !_canMoveToNextView(
              widget.view,
              widget.calendar.monthViewSettings.numberOfWeeksInView,
              widget.calendar.minDate,
              widget.calendar.maxDate,
              _currentViewVisibleDates,
              widget.calendar.timeSlotViewSettings.nonWorkingDays,
              widget.isRTL)) {
        _position = 0;
        return;
      } else if (difference > 0 &&
          !_canMoveToPreviousView(
              widget.view,
              widget.calendar.monthViewSettings.numberOfWeeksInView,
              widget.calendar.minDate,
              widget.calendar.maxDate,
              _currentViewVisibleDates,
              widget.calendar.timeSlotViewSettings.nonWorkingDays,
              widget.isRTL)) {
        _position = 0;
        return;
      }
      _position = difference;
      _clearSelection();
      setState(() {
        /* Updates the widget navigated distance and moves the widget
       in the custom scroll view */
      });
    }
  }

  void _onHorizontalEnd(DragEndDetails dragEndDetails) {
    widget.removePicker();

    if (widget.calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget.view != CalendarView.month) {
      // condition to check and update the right to left swiping
      if (-_position >= widget.width / 2) {
        _tween.begin = _position;
        _tween.end = -widget.width;

        // Resets the controller to forward it again, the animation will forward
        // only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updateNextView());

        /// updates the current view visible dates when the view swiped in
        /// right to left direction
        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // fling the view from right to left
      else if (-dragEndDetails.velocity.pixelsPerSecond.dx > widget.width) {
        if (!_canMoveToNextView(
            widget.view,
            widget.calendar.monthViewSettings.numberOfWeeksInView,
            widget.calendar.minDate,
            widget.calendar.maxDate,
            _currentViewVisibleDates,
            widget.calendar.timeSlotViewSettings.nonWorkingDays,
            widget.isRTL)) {
          _position = 0;
          setState(() {
            /* Completes the swiping and rearrange the children position in the
            custom scroll view */
          });
          return;
        }

        _tween.begin = _position;
        _tween.end = -widget.width;

        // Resets the controller to forward it again, the animation will forward
        // only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updateNextView());

        /// updates the current view visible dates when fling the view in
        /// right to left direction
        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // condition to check and update the left to right swiping
      else if (_position >= widget.width / 2) {
        _tween.begin = _position;
        _tween.end = widget.width;

        // Resets the controller to forward it again, the animation will forward
        // only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updatePreviousView());

        /// updates the current view visible dates when the view swiped in
        /// left to right direction
        _updateCurrentViewVisibleDates();
      }
      // fling the view from left to right
      else if (dragEndDetails.velocity.pixelsPerSecond.dx > widget.width) {
        if (!_canMoveToPreviousView(
            widget.view,
            widget.calendar.monthViewSettings.numberOfWeeksInView,
            widget.calendar.minDate,
            widget.calendar.maxDate,
            _currentViewVisibleDates,
            widget.calendar.timeSlotViewSettings.nonWorkingDays,
            widget.isRTL)) {
          _position = 0;
          setState(() {
            /* Completes the swiping and rearrange the children position in the
            custom scroll view */
          });
          return;
        }

        _tween.begin = _position;
        _tween.end = widget.width;

        // Resets the controller to forward it again, the animation will forward
        // only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updatePreviousView());

        /// updates the current view visible dates when fling the view in
        /// left to right direction
        _updateCurrentViewVisibleDates();
      }
      // condition to check and revert the right to left swiping
      else if (_position.abs() <= widget.width / 2) {
        _tween.begin = _position;
        _tween.end = 0.0;

        // Resets the controller to forward it again, the animation will forward
        // only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end) {
          _animationController.reset();
        }

        _animationController.forward();
      }
    }
  }

  void _onVerticalStart(DragStartDetails dragStartDetails) {
    widget.removePicker();
    if (widget.calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        !_isTimelineView(widget.view)) {
      _scrollStartPosition = dragStartDetails.globalPosition.dy;
    }
  }

  void _onVerticalUpdate(DragUpdateDetails dragUpdateDetails) {
    widget.removePicker();
    if (widget.calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        !_isTimelineView(widget.view)) {
      final double difference =
          dragUpdateDetails.globalPosition.dy - _scrollStartPosition;
      if (difference < 0 &&
          !_canMoveToNextView(
              widget.view,
              widget.calendar.monthViewSettings.numberOfWeeksInView,
              widget.calendar.minDate,
              widget.calendar.maxDate,
              _currentViewVisibleDates,
              widget.calendar.timeSlotViewSettings.nonWorkingDays)) {
        _position = 0;
        return;
      } else if (difference > 0 &&
          !_canMoveToPreviousView(
              widget.view,
              widget.calendar.monthViewSettings.numberOfWeeksInView,
              widget.calendar.minDate,
              widget.calendar.maxDate,
              _currentViewVisibleDates,
              widget.calendar.timeSlotViewSettings.nonWorkingDays)) {
        _position = 0;
        return;
      }
      _position = difference;
      setState(() {
        /* Updates the widget navigated distance and moves the widget
       in the custom scroll view */
      });
    }
  }

  void _onVerticalEnd(DragEndDetails dragEndDetails) {
    widget.removePicker();
    if (widget.calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        !_isTimelineView(widget.view)) {
      // condition to check and update the bottom to top swiping
      if (-_position >= widget.height / 2) {
        _tween.begin = _position;
        _tween.end = -widget.height;

        // Resets the controller to forward it again, the animation will forward
        // only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updateNextView());

        /// updates the current view visible dates when the view swiped in
        /// bottom to top direction
        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // fling the view to bottom to top
      else if (-dragEndDetails.velocity.pixelsPerSecond.dy > widget.height) {
        if (!_canMoveToNextView(
            widget.view,
            widget.calendar.monthViewSettings.numberOfWeeksInView,
            widget.calendar.minDate,
            widget.calendar.maxDate,
            _currentViewVisibleDates,
            widget.calendar.timeSlotViewSettings.nonWorkingDays)) {
          _position = 0;
          setState(() {
            /* Completes the swiping and rearrange the children position in the
            custom scroll view */
          });
          return;
        }

        _tween.begin = _position;
        _tween.end = -widget.height;

        // Resets the controller to forward it again, the animation will forward
        // only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updateNextView());

        /// updates the current view visible dates when fling the view in
        /// bottom to top direction
        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // condition to check and update the top to bottom swiping
      else if (_position >= widget.height / 2) {
        _tween.begin = _position;
        _tween.end = widget.height;

        // Resets the controller to forward it again, the animation will forward
        // only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

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
            widget.view,
            widget.calendar.monthViewSettings.numberOfWeeksInView,
            widget.calendar.minDate,
            widget.calendar.maxDate,
            _currentViewVisibleDates,
            widget.calendar.timeSlotViewSettings.nonWorkingDays)) {
          _position = 0;
          setState(() {
            /* Completes the swiping and rearrange the children position in the
            custom scroll view */
          });
          return;
        }

        _tween.begin = _position;
        _tween.end = widget.height;

        // Resets the controller to forward it again, the animation will forward
        // only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updatePreviousView());

        /// updates the current view visible dates when fling the view in
        /// top to bottom direction
        _updateCurrentViewVisibleDates();
      }
      // condition to check and revert the bottom to top swiping
      else if (_position.abs() <= widget.height / 2) {
        _tween.begin = _position;
        _tween.end = 0.0;

        // Resets the controller to forward it again, the animation will forward
        // only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController.forward();
      }
    }
  }

  void _clearSelection() {
    widget.getCalendarState(_updateCalendarStateDetails);
    for (int i = 0; i < _children.length; i++) {
      final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
      if (viewKey.currentState._selectionPainter.selectedDate !=
          _updateCalendarStateDetails._selectedDate) {
        viewKey.currentState._selectionPainter.selectedDate =
            _updateCalendarStateDetails._selectedDate;
        viewKey.currentState._selectionNotifier.value =
            !viewKey.currentState._selectionNotifier.value;
      }
    }
  }

  /// Updates the all day panel of the view, when the all day panel expanded and
  /// the view swiped to next or previous view with the expanded all day panel,
  /// it will be collapsed.
  void _updateAllDayPanel() {
    GlobalKey<_CalendarViewState> viewKey;
    if (_currentChildIndex == 0) {
      viewKey = _previousViewKey;
    } else if (_currentChildIndex == 1) {
      viewKey = _currentViewKey;
    } else if (_currentChildIndex == 2) {
      viewKey = _nextViewKey;
    }
    if (viewKey.currentState._expanderAnimationController?.status ==
        AnimationStatus.completed) {
      viewKey.currentState._expanderAnimationController?.reset();
    }
    viewKey.currentState._isExpanded = false;
  }

  /// Method to clear the appointments in the previous/next view
  void _updateAppointmentPainter() {
    for (int i = 0; i < _children.length; i++) {
      final _CalendarView view = _children[i];
      final GlobalKey<_CalendarViewState> viewKey = view.key;
      if (widget.view == CalendarView.month &&
          widget.calendar.monthCellBuilder != null) {
        if (view.visibleDates == _currentViewVisibleDates) {
          widget.getCalendarState(_updateCalendarStateDetails);
          if (!_isCollectionEqual(
              viewKey.currentState._monthView.visibleAppointmentNotifier.value,
              _updateCalendarStateDetails._visibleAppointments)) {
            viewKey.currentState._monthView.visibleAppointmentNotifier.value =
                _updateCalendarStateDetails._visibleAppointments;
          }
        } else {
          if (!_isEmptyList(viewKey
              .currentState._monthView.visibleAppointmentNotifier.value)) {
            viewKey.currentState._monthView.visibleAppointmentNotifier.value =
                null;
          }
        }
      } else {
        final _AppointmentLayout appointmentLayout =
            viewKey.currentState._appointmentLayoutKey.currentWidget;
        if (view.visibleDates == _currentViewVisibleDates) {
          widget.getCalendarState(_updateCalendarStateDetails);
          if (!_isCollectionEqual(appointmentLayout.visibleAppointments.value,
              _updateCalendarStateDetails._visibleAppointments)) {
            appointmentLayout.visibleAppointments.value =
                _updateCalendarStateDetails._visibleAppointments;
          }
        } else {
          if (!_isEmptyList(appointmentLayout.visibleAppointments.value)) {
            appointmentLayout.visibleAppointments.value = null;
          }
        }
      }
    }
  }
}
