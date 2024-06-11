import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/core_internal.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../calendar.dart';
import '../appointment_engine/appointment_helper.dart';
import '../appointment_engine/recurrence_helper.dart';
import '../appointment_layout/allday_appointment_layout.dart';
import '../appointment_layout/appointment_layout.dart';
import '../common/calendar_view_helper.dart';
import '../common/date_time_engine.dart';
import '../views/day_view.dart';
import '../views/month_view.dart';
import '../views/timeline_view.dart';

/// All day appointment views default height
const double _kAllDayLayoutHeight = 60;

/// Holds the looping widget for calendar view(time slot, month, timeline and
/// appointment views) widgets of calendar widget.
@immutable
class CustomCalendarScrollView extends StatefulWidget {
  /// Constructor to create the calendar scroll view for holding calendar
  /// view(time slot, month, timeline and appointment views) widgets of
  /// calendar widget.
  const CustomCalendarScrollView(
      this.calendar,
      this.view,
      this.width,
      this.height,
      this.agendaSelectedDate,
      this.isRTL,
      this.locale,
      this.calendarTheme,
      this.themeData,
      this.specialRegions,
      this.blackoutDates,
      this.controller,
      this.removePicker,
      this.resourcePanelScrollController,
      this.resourceCollection,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.fadeInController,
      this.minDate,
      this.maxDate,
      this.localizations,
      this.timelineMonthWeekNumberNotifier,
      this.updateCalendarState,
      this.getCalendarState,
      {Key? key})
      : super(key: key);

  /// Holds the calendar instance used to get the calendar properties.
  final SfCalendar calendar;

  /// Holds the current calendar view of the calendar widget.
  final CalendarView view;

  /// Defines the width of the calendar scroll view widget.
  final double width;

  /// Defines the height of the calendar scroll view widget.
  final double height;

  /// Defines the direction of calendar widget is RTL or not.
  final bool isRTL;

  /// Defines the locale of the calendar.
  final String locale;

  /// Holds the theme data value for calendar.
  final SfCalendarThemeData calendarTheme;

  /// Holds the framework theme data value.
  final ThemeData themeData;

  /// Holds the calendar controller for the calendar widget.
  final CalendarController controller;

  /// Used to update the calendar state details.
  final UpdateCalendarState updateCalendarState;

  /// Used to get the calendar state details.
  final UpdateCalendarState getCalendarState;

  /// Used to remove the calendar header picker.
  final VoidCallback removePicker;

  /// Holds the agenda selected date value and the value updated on month cell
  /// selection and it set to null on month appointment selection.
  final ValueNotifier<DateTime?> agendaSelectedDate;

  /// Notifier to update the weeknumber of timeline month view based on scroll
  /// changed.
  final ValueNotifier<DateTime?> timelineMonthWeekNumberNotifier;

  /// Holds the special time region of calendar widget.
  final List<TimeRegion>? specialRegions;

  /// Used to get the resource panel scroll position.
  final ScrollController? resourcePanelScrollController;

  /// Collection used to store the resource collection and check the collection
  /// manipulations(add, remove, reset).
  final List<CalendarResource>? resourceCollection;

  /// Defines the scale factor for the calendar widget.
  final double textScaleFactor;

  /// Defines the current platform is mobile platform or not.
  final bool isMobilePlatform;

  /// Holds the blackout dates collection of calendar.
  final List<DateTime>? blackoutDates;

  /// Used to animate the calendar views while navigation and view switching.
  final AnimationController? fadeInController;

  /// Defines the min date of the calendar.
  final DateTime minDate;

  /// Defines the max date of the calendar.
  final DateTime maxDate;

  /// Holds the localization data of the calendar widget.
  final SfLocalizations localizations;

  /// Updates the focus to the custom scroll view element.
  void updateFocus() {
    if (key == null) {
      return;
    }

    // ignore: avoid_as
    final GlobalKey scrollViewKey = key! as GlobalKey;
    final Object? currentState = scrollViewKey.currentState;
    if (currentState == null) {
      return;
    }

    final _CustomCalendarScrollViewState state =
        // ignore: avoid_as
        currentState as _CustomCalendarScrollViewState;
    if (!state._focusNode.hasFocus) {
      state._focusNode.requestFocus();
    }
  }

  /// Updates the calendar details in the calendar view
  CalendarDetails? getCalendarDetails(Offset position) {
    if (key == null) {
      return null;
    }

    // ignore: avoid_as
    final GlobalKey scrollViewKey = key! as GlobalKey;
    final Object? currentState = scrollViewKey.currentState;
    if (currentState == null) {
      return null;
    }

    final _CustomCalendarScrollViewState state =
        // ignore: avoid_as
        currentState as _CustomCalendarScrollViewState;
    return state._getCalendarDetails(position);
  }

  /// Update the scroll position when the display date time changes.
  void updateScrollPosition() {
    if (key == null) {
      return;
    }

    // ignore: avoid_as
    final GlobalKey scrollViewKey = key! as GlobalKey;
    final Object? currentState = scrollViewKey.currentState;
    if (currentState == null) {
      return;
    }

    final _CustomCalendarScrollViewState state =
        // ignore: avoid_as
        currentState as _CustomCalendarScrollViewState;
    state._updateMoveToDate();
  }

  @override
  // ignore: library_private_types_in_public_api
  _CustomCalendarScrollViewState createState() =>
      _CustomCalendarScrollViewState();
}

class _CustomCalendarScrollViewState extends State<CustomCalendarScrollView>
    with TickerProviderStateMixin {
  // three views to arrange the view in vertical/horizontal direction and handle the swiping
  late _CalendarView _currentView, _nextView, _previousView;

  // the three children which to be added into the layout
  final List<_CalendarView> _children = <_CalendarView>[];

  // holds the index of the current displaying view
  int _currentChildIndex = 1;

  // _scrollStartPosition contains the touch movement starting position
  late double _scrollStartPosition;

  // _position contains distance that the view swiped
  double _position = 0;

  // animation controller to control the animation
  late AnimationController _animationController;

  // animation handled for the view swiping
  late Animation<double> _animation;

  // tween animation to handle the animation
  final Tween<double> _tween = Tween<double>(begin: 0.0, end: 0.1);

  // Three visible dates for the three views, the dates will updated based on
  // the swiping in the swipe end currentViewVisibleDates which stores the
  // visible dates of the current displaying view
  late List<DateTime> _visibleDates,
      _previousViewVisibleDates,
      _nextViewVisibleDates,
      _currentViewVisibleDates;

  /// keys maintained to access the data and methods from the calendar view
  /// class.
  final GlobalKey<_CalendarViewState> _previousViewKey =
          GlobalKey<_CalendarViewState>(),
      _currentViewKey = GlobalKey<_CalendarViewState>(),
      _nextViewKey = GlobalKey<_CalendarViewState>();

  final UpdateCalendarStateDetails _updateCalendarStateDetails =
      UpdateCalendarStateDetails();

  /// Collection used to store the special regions and
  /// check the special regions manipulations.
  List<TimeRegion>? _timeRegions;

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
  Drag? _drag;

  final FocusScopeNode _focusNode = FocusScopeNode();

  late ValueNotifier<_DragPaintDetails> _dragDetails;
  Offset? _dragDifferenceOffset;
  Timer? _timer;
  double? _viewPortHeight;

  @override
  void initState() {
    _dragDetails = ValueNotifier<_DragPaintDetails>(
        _DragPaintDetails(position: ValueNotifier<Offset?>(null)));
    widget.controller.forward = widget.isRTL
        ? _moveToPreviousViewWithAnimation
        : _moveToNextViewWithAnimation;
    widget.controller.backward = widget.isRTL
        ? _moveToNextViewWithAnimation
        : _moveToPreviousViewWithAnimation;

    _currentChildIndex = 1;
    _updateVisibleDates();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _animation = _tween.animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ))
      ..addListener(animationListener);

    _timeRegions = CalendarViewHelper.cloneList(widget.specialRegions);

    super.initState();
  }

  @override
  void didUpdateWidget(CustomCalendarScrollView oldWidget) {
    if (oldWidget.controller != widget.controller) {
      widget.controller.forward = widget.isRTL
          ? _moveToPreviousViewWithAnimation
          : _moveToNextViewWithAnimation;
      widget.controller.backward = widget.isRTL
          ? _moveToNextViewWithAnimation
          : _moveToPreviousViewWithAnimation;

      if (!CalendarViewHelper.isSameTimeSlot(oldWidget.controller.selectedDate,
              widget.controller.selectedDate) ||
          !CalendarViewHelper.isSameTimeSlot(
              _updateCalendarStateDetails.selectedDate,
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
      if (CalendarViewHelper.isTimelineView(widget.view) !=
          CalendarViewHelper.isTimelineView(oldWidget.view)) {
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
      _position = 0;
      _children.clear();
    }

    if (!_isTimeRegionsEquals(widget.specialRegions, _timeRegions)) {
      _timeRegions = CalendarViewHelper.cloneList(widget.specialRegions);
      _position = 0;
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
    if (CalendarViewHelper.isTimelineView(widget.view) &&
        !CalendarViewHelper.isCollectionEqual(
            oldWidget.resourceCollection, widget.resourceCollection)) {
      _updateSelectedResourceIndex();
      _position = 0;
      _children.clear();
    }

    if (oldWidget.calendar.showCurrentTimeIndicator !=
        widget.calendar.showCurrentTimeIndicator) {
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
            widget.calendar.selectionDecoration ||
        oldWidget.calendar.weekNumberStyle != widget.calendar.weekNumberStyle) {
      final bool isTimelineView =
          CalendarViewHelper.isTimelineView(widget.view);
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
          _previousViewKey.currentState!._retainScrolledDateTime();
        } else if (_currentChildIndex == 1) {
          _currentViewKey.currentState!._retainScrolledDateTime();
        } else if (_currentChildIndex == 2) {
          _nextViewKey.currentState!._retainScrolledDateTime();
        }
      }
      _children.clear();
      _position = 0;
    }

    if ((widget.view == CalendarView.month &&
            widget.calendar.monthViewSettings.numberOfWeeksInView !=
                oldWidget.calendar.monthViewSettings.numberOfWeeksInView) ||
        widget.calendar.firstDayOfWeek != oldWidget.calendar.firstDayOfWeek ||
        (widget.view != CalendarView.month &&
            (!CalendarViewHelper.isCollectionEqual(
                    widget.calendar.timeSlotViewSettings.nonWorkingDays,
                    oldWidget.calendar.timeSlotViewSettings.nonWorkingDays) ||
                widget.calendar.timeSlotViewSettings.numberOfDaysInView !=
                    oldWidget
                        .calendar.timeSlotViewSettings.numberOfDaysInView)) ||
        widget.isRTL != oldWidget.isRTL) {
      _updateVisibleDates();
      _position = 0;
    }

    if (!isSameDate(widget.calendar.minDate, oldWidget.calendar.minDate) ||
        !isSameDate(widget.calendar.maxDate, oldWidget.calendar.maxDate)) {
      _updateVisibleDates();
      _position = 0;
    }

    if (CalendarViewHelper.isTimelineView(widget.view) !=
        CalendarViewHelper.isTimelineView(oldWidget.view)) {
      _children.clear();
    }

    /// position set as zero to maintain the existing scroll position in
    /// timeline view
    if (CalendarViewHelper.isTimelineView(widget.view) &&
        (oldWidget.calendar.backgroundColor !=
                widget.calendar.backgroundColor ||
            oldWidget.calendar.headerStyle != widget.calendar.headerStyle)) {
      _position = 0;
    }

    if (widget.controller == oldWidget.controller) {
      if (oldWidget.controller.displayDate != widget.controller.displayDate ||
          !isSameDate(_updateCalendarStateDetails.currentDate,
              widget.controller.displayDate)) {
        widget.getCalendarState(_updateCalendarStateDetails);
        _updateCalendarStateDetails.currentDate = widget.controller.displayDate;
        widget.updateCalendarState(_updateCalendarStateDetails);
        if (widget.calendar.showWeekNumber &&
            widget.view == CalendarView.timelineMonth) {
          widget.timelineMonthWeekNumberNotifier.value =
              widget.controller.displayDate;
        }

        _updateVisibleDates();
        _updateMoveToDate();
        _position = 0;
      }

      if (!CalendarViewHelper.isSameTimeSlot(oldWidget.controller.selectedDate,
              widget.controller.selectedDate) ||
          !CalendarViewHelper.isSameTimeSlot(
              _updateCalendarStateDetails.selectedDate,
              widget.controller.selectedDate)) {
        widget.getCalendarState(_updateCalendarStateDetails);
        _updateCalendarStateDetails.selectedDate =
            widget.controller.selectedDate;
        widget.updateCalendarState(_updateCalendarStateDetails);
        _selectResourceProgrammatically();
        _updateSelection();
        _position = 0;
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _viewPortHeight = MediaQuery.of(context).size.height;
    if (!CalendarViewHelper.isTimelineView(widget.view) &&
        widget.view != CalendarView.month) {
      _updateScrollPosition();
    }

    double leftPosition = 0,
        rightPosition = 0,
        topPosition = 0,
        bottomPosition = 0;
    final bool isHorizontalNavigation =
        widget.calendar.monthViewSettings.navigationDirection ==
                MonthNavigationDirection.horizontal ||
            widget.view != CalendarView.month;
    if (isHorizontalNavigation) {
      leftPosition = -widget.width;
      rightPosition = -widget.width;
    } else {
      topPosition = -widget.height;
      bottomPosition = -widget.height;
    }

    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    final bool isTimelineView = CalendarViewHelper.isTimelineView(widget.view);
    final bool isNeedDragAndDrop = widget.calendar.allowDragAndDrop &&
        widget.view != CalendarView.schedule &&
        (!widget.isMobilePlatform ||
            (widget.view != CalendarView.month &&
                widget.view != CalendarView.timelineMonth));
    final double viewHeaderHeight = isDayView
        ? 0
        : CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view);
    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    final bool isResourceEnabled = CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view);
    final double resourceItemHeight = isResourceEnabled
        ? CalendarViewHelper.getResourceItemHeight(
            widget.calendar.resourceViewSettings.size,
            widget.height - viewHeaderHeight - timeLabelWidth,
            widget.calendar.resourceViewSettings,
            widget.calendar.dataSource!.resources!.length)
        : 0;
    final double resourceViewSize =
        isResourceEnabled ? widget.calendar.resourceViewSettings.size : 0;
    final bool isMonthView = widget.view == CalendarView.month ||
        widget.view == CalendarView.timelineMonth;
    final double weekNumberPanelWidth =
        CalendarViewHelper.getWeekNumberPanelWidth(
            widget.calendar.showWeekNumber,
            widget.width,
            widget.isMobilePlatform);

    final Widget customScrollWidget = GestureDetector(
      onTapDown: (TapDownDetails details) {
        if (!_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
      },
      onHorizontalDragStart: isTimelineView
          ? null
          : (DragStartDetails dragStartDetails) {
              _onHorizontalStart(
                  dragStartDetails,
                  isResourceEnabled,
                  isTimelineView,
                  viewHeaderHeight,
                  timeLabelWidth,
                  isNeedDragAndDrop);
            },
      onHorizontalDragUpdate: isTimelineView
          ? null
          : (DragUpdateDetails dragUpdateDetails) {
              _onHorizontalUpdate(
                  dragUpdateDetails,
                  isResourceEnabled,
                  isMonthView,
                  isTimelineView,
                  viewHeaderHeight,
                  timeLabelWidth,
                  resourceItemHeight,
                  weekNumberPanelWidth,
                  isNeedDragAndDrop);
            },
      onHorizontalDragEnd: isTimelineView
          ? null
          : (DragEndDetails dragEndDetails) {
              _onHorizontalEnd(
                  dragEndDetails,
                  isResourceEnabled,
                  isTimelineView,
                  isMonthView,
                  viewHeaderHeight,
                  timeLabelWidth,
                  weekNumberPanelWidth,
                  isNeedDragAndDrop);
            },
      onVerticalDragStart: isHorizontalNavigation
          ? null
          : (DragStartDetails dragStartDetails) {
              _onVerticalStart(
                  dragStartDetails,
                  isResourceEnabled,
                  isTimelineView,
                  viewHeaderHeight,
                  timeLabelWidth,
                  isNeedDragAndDrop);
            },
      onVerticalDragUpdate: isHorizontalNavigation
          ? null
          : (DragUpdateDetails dragUpdateDetails) {
              _onVerticalUpdate(
                  dragUpdateDetails,
                  isResourceEnabled,
                  isMonthView,
                  isTimelineView,
                  viewHeaderHeight,
                  timeLabelWidth,
                  resourceItemHeight,
                  weekNumberPanelWidth,
                  isNeedDragAndDrop);
            },
      onVerticalDragEnd: isHorizontalNavigation
          ? null
          : (DragEndDetails dragEndDetails) {
              _onVerticalEnd(
                  dragEndDetails,
                  isResourceEnabled,
                  isTimelineView,
                  isMonthView,
                  viewHeaderHeight,
                  timeLabelWidth,
                  weekNumberPanelWidth,
                  isNeedDragAndDrop);
            },
      child: CustomScrollViewerLayout(
          _addViews(),
          isHorizontalNavigation
              ? CustomScrollDirection.horizontal
              : CustomScrollDirection.vertical,
          _position,
          _currentChildIndex),
    );

    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        _handleLongPressStart(details, isNeedDragAndDrop, isTimelineView,
            isResourceEnabled, viewHeaderHeight, timeLabelWidth);
      },
      onLongPressMoveUpdate: isNeedDragAndDrop
          ? (LongPressMoveUpdateDetails details) {
              _handleLongPressMove(
                  details.localPosition,
                  isTimelineView,
                  isResourceEnabled,
                  isMonthView,
                  viewHeaderHeight,
                  timeLabelWidth,
                  resourceItemHeight,
                  weekNumberPanelWidth);
            }
          : null,
      onLongPressEnd: isNeedDragAndDrop
          ? (LongPressEndDetails details) {
              _handleLongPressEnd(
                  details.localPosition,
                  isTimelineView,
                  isResourceEnabled,
                  isMonthView,
                  viewHeaderHeight,
                  timeLabelWidth,
                  weekNumberPanelWidth);
            }
          : null,
      child: Stack(
        children: <Widget>[
          Positioned(
              left: leftPosition,
              right: rightPosition,
              bottom: bottomPosition,
              top: topPosition,
              child: FocusScope(
                node: _focusNode,
                onKeyEvent: _onKeyDown,
                child: isTimelineView
                    ? Listener(
                        onPointerSignal: _handlePointerSignal,
                        child: RawGestureDetector(
                            gestures: <Type, GestureRecognizerFactory>{
                              HorizontalDragGestureRecognizer:
                                  GestureRecognizerFactoryWithHandlers<
                                      HorizontalDragGestureRecognizer>(
                                () => HorizontalDragGestureRecognizer(),
                                (HorizontalDragGestureRecognizer instance) {
                                  instance.onUpdate =
                                      (DragUpdateDetails details) {
                                    _handleDragUpdate(
                                        details,
                                        isTimelineView,
                                        isResourceEnabled,
                                        isMonthView,
                                        viewHeaderHeight,
                                        timeLabelWidth,
                                        resourceItemHeight,
                                        weekNumberPanelWidth,
                                        isNeedDragAndDrop,
                                        resourceViewSize);
                                  };
                                  instance.onStart =
                                      (DragStartDetails details) {
                                    _handleDragStart(
                                        details,
                                        isNeedDragAndDrop,
                                        isTimelineView,
                                        isResourceEnabled,
                                        viewHeaderHeight,
                                        timeLabelWidth,
                                        resourceViewSize);
                                  };
                                  instance.onEnd = (DragEndDetails details) {
                                    _handleDragEnd(
                                        details,
                                        isTimelineView,
                                        isResourceEnabled,
                                        isMonthView,
                                        viewHeaderHeight,
                                        timeLabelWidth,
                                        weekNumberPanelWidth,
                                        isNeedDragAndDrop);
                                  };
                                  instance.onCancel = _handleDragCancel;
                                },
                              )
                            },
                            behavior: HitTestBehavior.opaque,
                            child: customScrollWidget),
                      )
                    : customScrollWidget,
              )),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: IgnorePointer(
                  child: RepaintBoundary(
                      child: _DraggingAppointmentWidget(
                          _dragDetails,
                          widget.isRTL,
                          widget.textScaleFactor,
                          widget.isMobilePlatform,
                          AppointmentHelper.getAppointmentTextStyle(
                              widget.calendar.appointmentTextStyle,
                              widget.view,
                              widget.themeData),
                          widget.calendar.dragAndDropSettings,
                          widget.view,
                          _updateCalendarStateDetails.allDayPanelHeight,
                          viewHeaderHeight,
                          timeLabelWidth,
                          resourceItemHeight,
                          widget.calendarTheme,
                          widget.calendar,
                          widget.width,
                          widget.height))))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animation.removeListener(animationListener);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleAppointmentDragStart(
      AppointmentView appointmentView,
      bool isTimelineView,
      Offset details,
      bool isResourceEnabled,
      double viewHeaderHeight,
      double timeLabelWidth) {
    final _CalendarViewState currentState = _getCurrentViewByVisibleDates()!;
    currentState._updateDraggingMouseCursor(true);
    _dragDetails.value.timeIntervalHeight = currentState._getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        currentState.widget.visibleDates.length,
        widget.isMobilePlatform);
    _dragDetails.value.appointmentView = appointmentView;
    _dragDifferenceOffset = null;
    final Offset appointmentPosition = Offset(
        widget.isRTL
            ? appointmentView.appointmentRect!.right
            : appointmentView.appointmentRect!.left,
        appointmentView.appointmentRect!.top);
    double xPosition;
    double yPosition;
    if (isTimelineView) {
      xPosition = (appointmentPosition.dx -
              currentState._scrollController!.position.pixels) -
          details.dx;
      if (widget.isRTL) {
        xPosition = currentState._scrollController!.offset +
            currentState._scrollController!.position.viewportDimension;
        xPosition = xPosition -
            ((currentState._scrollController!.position.viewportDimension +
                    currentState._scrollController!.position.maxScrollExtent) -
                appointmentPosition.dx);
        xPosition -= details.dx;
      }
      yPosition = appointmentPosition.dy +
          viewHeaderHeight +
          timeLabelWidth -
          details.dy;
      if (isResourceEnabled) {
        yPosition -= currentState._timelineViewVerticalScrollController!.offset;
      }
      _dragDifferenceOffset = Offset(xPosition, yPosition);
    } else if (widget.view == CalendarView.month) {
      xPosition = appointmentPosition.dx - details.dx;
      yPosition = appointmentPosition.dy + viewHeaderHeight;
      yPosition = yPosition - details.dy;
      _dragDifferenceOffset = Offset(xPosition, yPosition);
    } else {
      final double allDayHeight = currentState._isExpanded
          ? _updateCalendarStateDetails.allDayPanelHeight
          : currentState._allDayHeight;
      xPosition = appointmentPosition.dx - details.dx;
      yPosition = appointmentPosition.dy +
          viewHeaderHeight +
          allDayHeight -
          currentState._scrollController!.position.pixels;
      if (appointmentView.appointment!.isAllDay ||
          appointmentView.appointment!.isSpanned) {
        yPosition = appointmentPosition.dy + viewHeaderHeight;
      }
      yPosition = yPosition - details.dy;
      _dragDifferenceOffset = Offset(xPosition, yPosition);
    }

    CalendarResource? selectedResource;
    int selectedResourceIndex = -1;

    if (isResourceEnabled) {
      yPosition = details.dy - viewHeaderHeight - timeLabelWidth;
      yPosition += currentState._timelineViewVerticalScrollController!.offset;
      selectedResourceIndex = currentState._getSelectedResourceIndex(
          yPosition, viewHeaderHeight, timeLabelWidth);
      selectedResource =
          widget.calendar.dataSource!.resources![selectedResourceIndex];
    }
    _dragDetails.value.position.value = details + _dragDifferenceOffset!;
    _dragDetails.value.draggingTime =
        yPosition <= 0 && widget.view != CalendarView.month && !isTimelineView
            ? null
            : _dragDetails.value.appointmentView!.appointment!.actualStartTime;
    final dynamic dragStartAppointment = _getCalendarAppointmentToObject(
        appointmentView.appointment, widget.calendar);
    if (widget.calendar.onDragStart != null) {
      widget.calendar.onDragStart!(
          AppointmentDragStartDetails(dragStartAppointment, selectedResource));
    }
  }

  void _handleLongPressStart(
      LongPressStartDetails details,
      bool isNeedDragAndDrop,
      bool isTimelineView,
      bool isResourceEnabled,
      double viewHeaderHeight,
      double timeLabelWidth) {
    final _CalendarViewState currentState = _getCurrentViewByVisibleDates()!;
    AppointmentView? appointmentView =
        _getDragAppointment(details, currentState);
    if (!isNeedDragAndDrop || appointmentView == null) {
      _dragDetails.value.position.value = null;
      return;
    }
    currentState._removeAllWidgetHovering();
    appointmentView = appointmentView.clone();
    _handleAppointmentDragStart(
        appointmentView,
        isTimelineView,
        details.localPosition,
        isResourceEnabled,
        viewHeaderHeight,
        timeLabelWidth);
  }

  AppointmentView? _getDragAppointment(
      LongPressStartDetails details, _CalendarViewState currentState) {
    if (CalendarViewHelper.isTimelineView(widget.view)) {
      return currentState._handleTouchOnTimeline(null, details);
    } else if (widget.view == CalendarView.month) {
      //// return null while the drag operation on mobile platform.
      return currentState._handleTouchOnMonthView(null, details);
    }

    return currentState._handleTouchOnDayView(null, details);
  }

  void _handleLongPressMove(
      Offset details,
      bool isTimelineView,
      bool isResourceEnabled,
      bool isMonthView,
      double viewHeaderHeight,
      double timeLabelWidth,
      double resourceItemHeight,
      double weekNumberPanelWidth) {
    if (_dragDetails.value.appointmentView == null) {
      return;
    }

    final Offset appointmentPosition = details + _dragDifferenceOffset!;
    final _CalendarViewState currentState = _getCurrentViewByVisibleDates()!;
    final double allDayHeight = currentState._isExpanded
        ? _updateCalendarStateDetails.allDayPanelHeight
        : currentState._allDayHeight;

    final double timeIntervalHeight = currentState._getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        currentState.widget.visibleDates.length,
        widget.isMobilePlatform);
    if (isTimelineView) {
      _updateAutoScrollDragTimelineView(
          currentState,
          appointmentPosition,
          viewHeaderHeight,
          timeIntervalHeight,
          resourceItemHeight,
          isResourceEnabled,
          details,
          isMonthView,
          allDayHeight,
          isTimelineView,
          timeLabelWidth,
          weekNumberPanelWidth);
    } else {
      _updateNavigationDayView(
          currentState,
          appointmentPosition,
          viewHeaderHeight,
          allDayHeight,
          timeIntervalHeight,
          timeLabelWidth,
          isResourceEnabled,
          isTimelineView,
          isMonthView,
          details,
          weekNumberPanelWidth);
    }

    _dragDetails.value.position.value = appointmentPosition;
    _updateAppointmentDragUpdateCallback(
        isTimelineView,
        viewHeaderHeight,
        timeLabelWidth,
        allDayHeight,
        appointmentPosition,
        isMonthView,
        timeIntervalHeight,
        currentState,
        details,
        isResourceEnabled,
        weekNumberPanelWidth);
  }

  Future<void> _updateNavigationDayView(
      _CalendarViewState currentState,
      Offset appointmentPosition,
      double viewHeaderHeight,
      double allDayHeight,
      double timeIntervalHeight,
      double timeLabelWidth,
      bool isResourceEnabled,
      bool isTimelineView,
      bool isMonthView,
      Offset details,
      double weekNumberPanelWidth) async {
    if (_dragDetails.value.appointmentView == null) {
      return;
    }

    double navigationThresholdValue = 0;
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    if (isDayView) {
      navigationThresholdValue =
          _dragDetails.value.appointmentView!.appointmentRect!.width * 0.1;
    }

    double rtlValue = 0;
    if (widget.isRTL) {
      rtlValue = _dragDetails.value.appointmentView!.appointmentRect!.width;
    }

    final bool isHorizontalNavigation =
        widget.calendar.monthViewSettings.navigationDirection ==
                MonthNavigationDirection.horizontal ||
            widget.view != CalendarView.month;

    if (widget.calendar.dragAndDropSettings.allowScroll &&
        widget.view != CalendarView.month &&
        appointmentPosition.dy <= viewHeaderHeight + allDayHeight &&
        currentState._scrollController!.position.pixels != 0) {
      if (_timer != null) {
        return;
      }
      _timer = Timer(const Duration(milliseconds: 200), () async {
        if (_dragDetails.value.position.value != null &&
            _dragDetails.value.position.value!.dy <=
                viewHeaderHeight + allDayHeight &&
            currentState._scrollController!.position.pixels != 0) {
          Future<void> updateScrollPosition() async {
            double scrollPosition =
                currentState._scrollController!.position.pixels -
                    timeIntervalHeight;
            if (scrollPosition < 0) {
              scrollPosition = 0;
            }
            await currentState._scrollController!.position.moveTo(
              scrollPosition,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );

            _updateAppointmentDragUpdateCallback(
                isTimelineView,
                viewHeaderHeight,
                timeLabelWidth,
                allDayHeight,
                appointmentPosition,
                isMonthView,
                timeIntervalHeight,
                currentState,
                details,
                isResourceEnabled,
                weekNumberPanelWidth);

            if (_dragDetails.value.position.value != null &&
                _dragDetails.value.position.value!.dy <=
                    viewHeaderHeight + allDayHeight &&
                currentState._scrollController!.position.pixels != 0) {
              updateScrollPosition();
            } else if (_timer != null) {
              _timer!.cancel();
              _timer = null;
            }
          }

          updateScrollPosition();
        } else if (_timer != null) {
          _timer!.cancel();
          _timer = null;
        }
      });
    } else if (widget.calendar.dragAndDropSettings.allowScroll &&
        widget.view != CalendarView.month &&
        appointmentPosition.dy +
                _dragDetails.value.appointmentView!.appointmentRect!.height >=
            widget.height &&
        currentState._scrollController!.position.pixels !=
            currentState._scrollController!.position.maxScrollExtent) {
      if (_timer != null) {
        return;
      }
      _timer = Timer(const Duration(milliseconds: 200), () async {
        if (_dragDetails.value.position.value != null &&
            _dragDetails.value.position.value!.dy +
                    _dragDetails
                        .value.appointmentView!.appointmentRect!.height >=
                widget.height &&
            currentState._scrollController!.position.pixels !=
                currentState._scrollController!.position.maxScrollExtent) {
          Future<void> updateScrollPosition() async {
            double scrollPosition =
                currentState._scrollController!.position.pixels +
                    timeIntervalHeight;
            if (scrollPosition >
                currentState._scrollController!.position.maxScrollExtent) {
              scrollPosition =
                  currentState._scrollController!.position.maxScrollExtent;
            }

            await currentState._scrollController!.position.moveTo(
              scrollPosition,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );

            _updateAppointmentDragUpdateCallback(
                isTimelineView,
                viewHeaderHeight,
                timeLabelWidth,
                allDayHeight,
                appointmentPosition,
                isMonthView,
                timeIntervalHeight,
                currentState,
                details,
                isResourceEnabled,
                weekNumberPanelWidth);

            if (_dragDetails.value.position.value != null &&
                _dragDetails.value.position.value!.dy +
                        _dragDetails
                            .value.appointmentView!.appointmentRect!.height >=
                    widget.height &&
                currentState._scrollController!.position.pixels !=
                    currentState._scrollController!.position.maxScrollExtent) {
              updateScrollPosition();
            } else if (_timer != null) {
              _timer!.cancel();
              _timer = null;
            }
          }

          updateScrollPosition();
        } else if (_timer != null) {
          _timer!.cancel();
          _timer = null;
        }
      });
    } else if (widget.calendar.dragAndDropSettings.allowNavigation &&
        ((isHorizontalNavigation &&
                (appointmentPosition.dx +
                            _dragDetails.value.appointmentView!.appointmentRect!
                                .width) -
                        rtlValue >=
                    widget.width) ||
            (!isHorizontalNavigation &&
                (appointmentPosition.dy +
                        _dragDetails
                            .value.appointmentView!.appointmentRect!.height >=
                    widget.height)))) {
      if (_timer != null) {
        return;
      }
      _timer =
          Timer.periodic(widget.calendar.dragAndDropSettings.autoNavigateDelay,
              (Timer timer) async {
        if (_dragDetails.value.position.value != null &&
            ((isHorizontalNavigation &&
                    (_dragDetails.value.position.value!.dx +
                                _dragDetails.value.appointmentView!
                                    .appointmentRect!.width) -
                            rtlValue >=
                        widget.width + navigationThresholdValue) ||
                (!isHorizontalNavigation &&
                    _dragDetails.value.position.value!.dy +
                            _dragDetails.value.appointmentView!.appointmentRect!
                                .height >=
                        widget.height))) {
          if (widget.isRTL) {
            _moveToPreviousViewWithAnimation();
          } else {
            _moveToNextViewWithAnimation();
          }
          currentState = _getCurrentViewByVisibleDates()!;
          currentState._updateDraggingMouseCursor(true);
          _updateAppointmentDragUpdateCallback(
              isTimelineView,
              viewHeaderHeight,
              timeLabelWidth,
              allDayHeight,
              appointmentPosition,
              isMonthView,
              timeIntervalHeight,
              currentState,
              details,
              isResourceEnabled,
              weekNumberPanelWidth);
        } else if (_timer != null) {
          _timer!.cancel();
          _timer = null;
        }
      });
    } else if (widget.calendar.dragAndDropSettings.allowNavigation &&
        ((isHorizontalNavigation &&
                (appointmentPosition.dx + navigationThresholdValue) -
                        rtlValue <=
                    0) ||
            (!isHorizontalNavigation &&
                appointmentPosition.dy <= viewHeaderHeight))) {
      if (_timer != null) {
        return;
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
        if (_dragDetails.value.position.value != null &&
            ((isHorizontalNavigation &&
                    (_dragDetails.value.position.value!.dx +
                                navigationThresholdValue) -
                            rtlValue <=
                        0) ||
                (!isHorizontalNavigation &&
                    _dragDetails.value.position.value!.dy <=
                        viewHeaderHeight))) {
          if (widget.isRTL) {
            _moveToNextViewWithAnimation();
          } else {
            _moveToPreviousViewWithAnimation();
          }
          currentState = _getCurrentViewByVisibleDates()!;
          currentState._updateDraggingMouseCursor(true);
          _updateAppointmentDragUpdateCallback(
              isTimelineView,
              viewHeaderHeight,
              timeLabelWidth,
              allDayHeight,
              appointmentPosition,
              isMonthView,
              timeIntervalHeight,
              currentState,
              details,
              isResourceEnabled,
              weekNumberPanelWidth);
        } else if (_timer != null) {
          _timer!.cancel();
          _timer = null;
        }
      });
    }
  }

  Future<void> _updateAutoScrollDragTimelineView(
      _CalendarViewState currentState,
      Offset appointmentPosition,
      double viewHeaderHeight,
      double timeIntervalHeight,
      double resourceItemHeight,
      bool isResourceEnabled,
      Offset details,
      bool isMonthView,
      double allDayHeight,
      bool isTimelineView,
      double timeLabelWidth,
      double weekNumberPanelWidth) async {
    if (_dragDetails.value.appointmentView == null) {
      return;
    }

    double rtlValue = 0;
    if (widget.isRTL) {
      rtlValue = _dragDetails.value.appointmentView!.appointmentRect!.width;
    }
    if (widget.calendar.dragAndDropSettings.allowScroll &&
        appointmentPosition.dx - rtlValue <= 0 &&
        ((widget.isRTL &&
                currentState._scrollController!.position.pixels !=
                    currentState._scrollController!.position.maxScrollExtent) ||
            (!widget.isRTL &&
                currentState._scrollController!.position.pixels != 0))) {
      if (_timer != null) {
        return;
      }
      _timer = Timer(const Duration(milliseconds: 200), () async {
        if (_dragDetails.value.position.value != null &&
            _dragDetails.value.position.value!.dx - rtlValue <= 0 &&
            ((widget.isRTL &&
                    currentState._scrollController!.position.pixels !=
                        currentState
                            ._scrollController!.position.maxScrollExtent) ||
                (!widget.isRTL &&
                    currentState._scrollController!.position.pixels != 0))) {
          Future<void> updateScrollPosition() async {
            double scrollPosition =
                currentState._scrollController!.position.pixels -
                    timeIntervalHeight;
            if (widget.isRTL) {
              scrollPosition = currentState._scrollController!.position.pixels +
                  timeIntervalHeight;
            }
            if (!widget.isRTL && scrollPosition < 0) {
              scrollPosition = 0;
            } else if (widget.isRTL &&
                scrollPosition >
                    currentState._scrollController!.position.maxScrollExtent) {
              scrollPosition =
                  currentState._scrollController!.position.maxScrollExtent;
            }
            await currentState._scrollController!.position.moveTo(
              scrollPosition,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );

            _updateAppointmentDragUpdateCallback(
                isTimelineView,
                viewHeaderHeight,
                timeLabelWidth,
                allDayHeight,
                appointmentPosition,
                isMonthView,
                timeIntervalHeight,
                currentState,
                details,
                isResourceEnabled,
                weekNumberPanelWidth);

            if (_dragDetails.value.position.value != null &&
                _dragDetails.value.position.value!.dx - rtlValue <= 0 &&
                ((widget.isRTL &&
                        currentState._scrollController!.position.pixels !=
                            currentState
                                ._scrollController!.position.maxScrollExtent) ||
                    (!widget.isRTL &&
                        currentState._scrollController!.position.pixels !=
                            0))) {
              updateScrollPosition();
            } else if (_timer != null) {
              _timer!.cancel();
              _timer = null;
              _updateAutoViewNavigationTimelineView(
                  currentState,
                  appointmentPosition,
                  viewHeaderHeight,
                  timeIntervalHeight,
                  resourceItemHeight,
                  isResourceEnabled,
                  details,
                  isMonthView,
                  allDayHeight,
                  isTimelineView,
                  timeLabelWidth,
                  weekNumberPanelWidth,
                  rtlValue);
            }
          }

          updateScrollPosition();
        } else if (_timer != null) {
          _timer!.cancel();
          _timer = null;
          _updateAutoViewNavigationTimelineView(
              currentState,
              appointmentPosition,
              viewHeaderHeight,
              timeIntervalHeight,
              resourceItemHeight,
              isResourceEnabled,
              details,
              isMonthView,
              allDayHeight,
              isTimelineView,
              timeLabelWidth,
              weekNumberPanelWidth,
              rtlValue);
        }
      });
    } else if (widget.calendar.dragAndDropSettings.allowScroll &&
        (appointmentPosition.dx +
                    _dragDetails
                        .value.appointmentView!.appointmentRect!.width) -
                rtlValue >=
            widget.width &&
        ((widget.isRTL &&
                currentState._scrollController!.position.pixels != 0) ||
            (!widget.isRTL &&
                currentState._scrollController!.position.pixels !=
                    currentState
                        ._scrollController!.position.maxScrollExtent))) {
      if (_timer != null) {
        return;
      }
      _timer = Timer(const Duration(milliseconds: 200), () async {
        if (_dragDetails.value.position.value != null &&
            (_dragDetails.value.position.value!.dx +
                        _dragDetails
                            .value.appointmentView!.appointmentRect!.width) -
                    rtlValue >=
                widget.width &&
            ((widget.isRTL &&
                    currentState._scrollController!.position.pixels != 0) ||
                (!widget.isRTL &&
                    currentState._scrollController!.position.pixels !=
                        currentState
                            ._scrollController!.position.maxScrollExtent))) {
          Future<void> updateScrollPosition() async {
            double scrollPosition =
                currentState._scrollController!.position.pixels +
                    timeIntervalHeight;
            if (widget.isRTL) {
              scrollPosition = currentState._scrollController!.position.pixels -
                  timeIntervalHeight;
            }
            if (!widget.isRTL &&
                scrollPosition >
                    currentState._scrollController!.position.maxScrollExtent) {
              scrollPosition =
                  currentState._scrollController!.position.maxScrollExtent;
            } else if (widget.isRTL && scrollPosition < 0) {
              scrollPosition = 0;
            }

            await currentState._scrollController!.position.moveTo(
              scrollPosition,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );

            _updateAppointmentDragUpdateCallback(
                isTimelineView,
                viewHeaderHeight,
                timeLabelWidth,
                allDayHeight,
                appointmentPosition,
                isMonthView,
                timeIntervalHeight,
                currentState,
                details,
                isResourceEnabled,
                weekNumberPanelWidth);

            if (_dragDetails.value.position.value != null &&
                (_dragDetails.value.position.value!.dx +
                            _dragDetails.value.appointmentView!.appointmentRect!
                                .width) -
                        rtlValue >=
                    widget.width &&
                ((widget.isRTL &&
                        currentState._scrollController!.position.pixels != 0) ||
                    (!widget.isRTL &&
                        currentState._scrollController!.position.pixels !=
                            currentState._scrollController!.position
                                .maxScrollExtent))) {
              updateScrollPosition();
            } else if (_timer != null) {
              _timer!.cancel();
              _timer = null;
              _updateAutoViewNavigationTimelineView(
                  currentState,
                  appointmentPosition,
                  viewHeaderHeight,
                  timeIntervalHeight,
                  resourceItemHeight,
                  isResourceEnabled,
                  details,
                  isMonthView,
                  allDayHeight,
                  isTimelineView,
                  timeLabelWidth,
                  weekNumberPanelWidth,
                  rtlValue);
            }
          }

          updateScrollPosition();
        } else if (_timer != null) {
          _timer!.cancel();
          _timer = null;
          _updateAutoViewNavigationTimelineView(
              currentState,
              appointmentPosition,
              viewHeaderHeight,
              timeIntervalHeight,
              resourceItemHeight,
              isResourceEnabled,
              details,
              isMonthView,
              allDayHeight,
              isTimelineView,
              timeLabelWidth,
              weekNumberPanelWidth,
              rtlValue);
        }
      });
    }

    _updateAutoViewNavigationTimelineView(
        currentState,
        appointmentPosition,
        viewHeaderHeight,
        timeIntervalHeight,
        resourceItemHeight,
        isResourceEnabled,
        details,
        isMonthView,
        allDayHeight,
        isTimelineView,
        timeLabelWidth,
        weekNumberPanelWidth,
        rtlValue);

    if (_dragDetails.value.appointmentView == null) {
      return;
    }

    if (isResourceEnabled) {
      if (widget.calendar.dragAndDropSettings.allowScroll &&
          appointmentPosition.dy - viewHeaderHeight - timeIntervalHeight <= 0 &&
          currentState._timelineViewVerticalScrollController!.position.pixels !=
              0) {
        if (_timer != null) {
          return;
        }
        _timer = Timer(const Duration(milliseconds: 200), () async {
          if (_dragDetails.value.position.value != null &&
              _dragDetails.value.position.value!.dy -
                      viewHeaderHeight -
                      timeIntervalHeight <=
                  0 &&
              currentState
                      ._timelineViewVerticalScrollController!.position.pixels !=
                  0) {
            Future<void> updateScrollPosition() async {
              double scrollPosition = currentState
                      ._timelineViewVerticalScrollController!.position.pixels -
                  resourceItemHeight;
              if (scrollPosition < 0) {
                scrollPosition = 0;
              }
              await currentState._timelineViewVerticalScrollController!.position
                  .moveTo(
                scrollPosition,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              );

              if (_dragDetails.value.position.value != null &&
                  _dragDetails.value.position.value!.dy -
                          viewHeaderHeight -
                          timeIntervalHeight <=
                      0 &&
                  currentState._timelineViewVerticalScrollController!.position
                          .pixels !=
                      0) {
                updateScrollPosition();
              } else if (_timer != null) {
                _timer!.cancel();
                _timer = null;
              }
            }

            updateScrollPosition();
          } else if (_timer != null) {
            _timer!.cancel();
            _timer = null;
          }
        });
      } else if (widget.calendar.dragAndDropSettings.allowScroll &&
          appointmentPosition.dy +
                  _dragDetails.value.appointmentView!.appointmentRect!.height >=
              widget.height &&
          currentState._timelineViewVerticalScrollController!.position.pixels !=
              currentState._timelineViewVerticalScrollController!.position
                  .maxScrollExtent) {
        if (_timer != null) {
          return;
        }
        _timer = Timer(const Duration(milliseconds: 200), () async {
          if (_dragDetails.value.position.value != null &&
              _dragDetails.value.position.value!.dy +
                      _dragDetails
                          .value.appointmentView!.appointmentRect!.height >=
                  widget.height &&
              currentState
                      ._timelineViewVerticalScrollController!.position.pixels !=
                  currentState._timelineViewVerticalScrollController!.position
                      .maxScrollExtent) {
            Future<void> updateScrollPosition() async {
              double scrollPosition = currentState
                      ._timelineViewVerticalScrollController!.position.pixels +
                  resourceItemHeight;
              if (scrollPosition >
                  currentState._timelineViewVerticalScrollController!.position
                      .maxScrollExtent) {
                scrollPosition = currentState
                    ._timelineViewVerticalScrollController!
                    .position
                    .maxScrollExtent;
              }

              await currentState._timelineViewVerticalScrollController!.position
                  .moveTo(
                scrollPosition,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              );

              if (_dragDetails.value.position.value != null &&
                  _dragDetails.value.position.value!.dy +
                          _dragDetails
                              .value.appointmentView!.appointmentRect!.height >=
                      widget.height &&
                  currentState._timelineViewVerticalScrollController!.position
                          .pixels !=
                      currentState._timelineViewVerticalScrollController!
                          .position.maxScrollExtent) {
                updateScrollPosition();
              } else if (_timer != null) {
                _timer!.cancel();
                _timer = null;
              }
            }

            updateScrollPosition();
          } else if (_timer != null) {
            _timer!.cancel();
            _timer = null;
          }
        });
      }
    }
  }

  void _updateAutoViewNavigationTimelineView(
      _CalendarViewState currentState,
      Offset appointmentPosition,
      double viewHeaderHeight,
      double timeIntervalHeight,
      double resourceItemHeight,
      bool isResourceEnabled,
      dynamic details,
      bool isMonthView,
      double allDayHeight,
      bool isTimelineView,
      double timeLabelWidth,
      double weekNumberPanelWidth,
      double rtlValue) {
    if (widget.calendar.dragAndDropSettings.allowNavigation &&
        (appointmentPosition.dx +
                    _dragDetails
                        .value.appointmentView!.appointmentRect!.width) -
                rtlValue >=
            widget.width &&
        ((!widget.isRTL &&
                currentState._scrollController!.offset ==
                    currentState._scrollController!.position.maxScrollExtent) ||
            (widget.isRTL && currentState._scrollController!.offset == 0))) {
      if (_timer != null) {
        return;
      }
      _timer =
          Timer.periodic(widget.calendar.dragAndDropSettings.autoNavigateDelay,
              (Timer timer) async {
        if (_dragDetails.value.position.value != null &&
            (_dragDetails.value.position.value!.dx +
                        _dragDetails
                            .value.appointmentView!.appointmentRect!.width) -
                    rtlValue >=
                widget.width &&
            ((!widget.isRTL &&
                    currentState._scrollController!.offset ==
                        currentState
                            ._scrollController!.position.maxScrollExtent) ||
                (widget.isRTL &&
                    currentState._scrollController!.offset == 0))) {
          if (widget.isRTL) {
            _moveToPreviousViewWithAnimation(isScrollToEnd: true);
          } else {
            _moveToNextViewWithAnimation();
          }
          currentState = _getCurrentViewByVisibleDates()!;
          currentState._updateDraggingMouseCursor(true);
          _updateAppointmentDragUpdateCallback(
              isTimelineView,
              viewHeaderHeight,
              timeLabelWidth,
              allDayHeight,
              appointmentPosition,
              isMonthView,
              timeIntervalHeight,
              currentState,
              details,
              isResourceEnabled,
              weekNumberPanelWidth);
        } else if (_timer != null) {
          _timer!.cancel();
          _timer = null;
        }
      });
    } else if (widget.calendar.dragAndDropSettings.allowNavigation &&
        ((appointmentPosition.dx) - rtlValue).truncate() <= 0 &&
        ((widget.isRTL &&
                currentState._scrollController!.position.pixels ==
                    currentState._scrollController!.position.maxScrollExtent) ||
            (!widget.isRTL && currentState._scrollController!.offset == 0))) {
      if (_timer != null) {
        return;
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
        if (_dragDetails.value.position.value != null &&
            (_dragDetails.value.position.value!.dx - rtlValue).truncate() <=
                0 &&
            ((widget.isRTL &&
                    currentState._scrollController!.position.pixels ==
                        currentState
                            ._scrollController!.position.maxScrollExtent) ||
                (!widget.isRTL &&
                    currentState._scrollController!.offset == 0))) {
          if (widget.isRTL) {
            _moveToNextViewWithAnimation();
          } else {
            _moveToPreviousViewWithAnimation(isScrollToEnd: true);
          }
          currentState = _getCurrentViewByVisibleDates()!;
          currentState._updateDraggingMouseCursor(true);
          _updateAppointmentDragUpdateCallback(
              isTimelineView,
              viewHeaderHeight,
              timeLabelWidth,
              allDayHeight,
              appointmentPosition,
              isMonthView,
              timeIntervalHeight,
              currentState,
              details,
              isResourceEnabled,
              weekNumberPanelWidth);
        } else if (_timer != null) {
          _timer!.cancel();
          _timer = null;
        }
      });
    }
  }

  void _updateAppointmentDragUpdateCallback(
      bool isTimelineView,
      double viewHeaderHeight,
      double timeLabelWidth,
      double allDayHeight,
      Offset appointmentPosition,
      bool isMonthView,
      double timeIntervalHeight,
      _CalendarViewState currentState,
      Offset details,
      bool isResourceEnabled,
      double weekNumberPanelWidth) {
    if (_dragDetails.value.appointmentView == null) {
      return;
    }

    late DateTime draggingTime;
    double xPosition = details.dx;
    double yPosition = appointmentPosition.dy;
    if (isTimelineView) {
      xPosition = appointmentPosition.dx;
      yPosition -= viewHeaderHeight + timeLabelWidth;
    } else {
      if (widget.view == CalendarView.month) {
        if (yPosition < viewHeaderHeight) {
          yPosition = viewHeaderHeight;
        } else if (yPosition > widget.height - 1) {
          yPosition = widget.height - 1;
        }

        yPosition -= viewHeaderHeight;
        if (!widget.isRTL && xPosition <= weekNumberPanelWidth) {
          xPosition = weekNumberPanelWidth;
        } else if (widget.isRTL &&
            xPosition >= (widget.width - weekNumberPanelWidth)) {
          xPosition = widget.width - weekNumberPanelWidth;
        }
      } else {
        if (yPosition < viewHeaderHeight + allDayHeight) {
          yPosition = viewHeaderHeight + allDayHeight;
        } else if (yPosition > widget.height - 1) {
          yPosition = widget.height - 1;
        }

        yPosition -= viewHeaderHeight + allDayHeight;
        if (!widget.isRTL) {
          xPosition -= timeLabelWidth;
        }

        if (xPosition >= widget.width - timeLabelWidth) {
          xPosition = widget.width - timeLabelWidth - 1;
        }
      }
    }

    if (xPosition < 0) {
      xPosition = 0;
    } else if (xPosition >= widget.width) {
      xPosition = widget.width - 1;
    }

    final double overAllWidth = isTimelineView
        ? currentState._timeIntervalHeight *
            (currentState._horizontalLinesCount! *
                currentState.widget.visibleDates.length)
        : widget.width;
    final double overAllHeight = isTimelineView || isMonthView
        ? widget.height
        : currentState._timeIntervalHeight *
            currentState._horizontalLinesCount!;

    if (isTimelineView &&
        overAllWidth < widget.width &&
        xPosition + _dragDetails.value.appointmentView!.appointmentRect!.width >
            overAllWidth) {
      xPosition = overAllWidth -
          _dragDetails.value.appointmentView!.appointmentRect!.width;
    } else if (!isTimelineView &&
        !isMonthView &&
        overAllHeight < widget.height &&
        yPosition +
                _dragDetails.value.appointmentView!.appointmentRect!.height >
            overAllHeight) {
      yPosition = overAllHeight -
          _dragDetails.value.appointmentView!.appointmentRect!.height;
    }

    draggingTime = currentState._getDateFromPosition(
        xPosition, yPosition, timeLabelWidth)!;
    if (!isMonthView) {
      if (isTimelineView) {
        final DateTime time = _timeFromPosition(
            draggingTime,
            widget.calendar.timeSlotViewSettings,
            xPosition,
            currentState,
            timeIntervalHeight,
            isTimelineView)!;

        draggingTime = DateTime(draggingTime.year, draggingTime.month,
            draggingTime.day, time.hour, time.minute);
      } else {
        if (yPosition < 0) {
          draggingTime =
              DateTime(draggingTime.year, draggingTime.month, draggingTime.day);
        } else {
          draggingTime = _timeFromPosition(
              draggingTime,
              widget.calendar.timeSlotViewSettings,
              yPosition,
              currentState,
              timeIntervalHeight,
              isTimelineView)!;
        }
      }
    }

    _dragDetails.value.position.value = Offset(
        _dragDetails.value.position.value!.dx,
        _dragDetails.value.position.value!.dy - 0.1);
    _dragDetails.value.draggingTime =
        yPosition <= 0 && widget.view != CalendarView.month && !isTimelineView
            ? null
            : draggingTime;
    _dragDetails.value.position.value = Offset(
        _dragDetails.value.position.value!.dx,
        _dragDetails.value.position.value!.dy + 0.1);

    final dynamic draggingAppointment = _getCalendarAppointmentToObject(
        _dragDetails.value.appointmentView!.appointment, widget.calendar);

    CalendarResource? selectedResource, previousResource;
    int targetResourceIndex = -1;
    int sourceSelectedResourceIndex = -1;
    if (isResourceEnabled) {
      targetResourceIndex = currentState._getSelectedResourceIndex(
          appointmentPosition.dy +
              currentState._timelineViewVerticalScrollController!.offset,
          viewHeaderHeight,
          timeLabelWidth);
      if (targetResourceIndex >
          widget.calendar.dataSource!.resources!.length - 1) {
        targetResourceIndex = widget.calendar.dataSource!.resources!.length - 1;
      }
      selectedResource =
          widget.calendar.dataSource!.resources![targetResourceIndex];
      sourceSelectedResourceIndex = currentState._getSelectedResourceIndex(
          _dragDetails.value.appointmentView!.appointmentRect!.top,
          viewHeaderHeight,
          timeLabelWidth);
      previousResource =
          widget.calendar.dataSource!.resources![sourceSelectedResourceIndex];
    }

    final int currentMonth = currentState.widget
        .visibleDates[currentState.widget.visibleDates.length ~/ 2].month;

    final int timeInterval = CalendarViewHelper.getTimeInterval(
        widget.calendar.timeSlotViewSettings);

    final DateTime updateStartTime = draggingTime;

    final Duration appointmentDuration = _dragDetails
                .value.appointmentView!.appointment!.isAllDay &&
            widget.view != CalendarView.month &&
            !isTimelineView
        ? const Duration(hours: 1)
        : _dragDetails.value.appointmentView!.appointment!.endTime.difference(
            _dragDetails.value.appointmentView!.appointment!.startTime);
    final DateTime updatedEndTime = updateStartTime.add(appointmentDuration);

    if (CalendarViewHelper.isDraggingAppointmentHasDisabledCell(
            _getTimeRegions(),
            _getBlackoutDates(),
            updateStartTime,
            updatedEndTime,
            isTimelineView,
            isMonthView,
            widget.calendar.minDate,
            widget.calendar.maxDate,
            timeInterval,
            targetResourceIndex,
            widget.resourceCollection) ||
        (widget.view == CalendarView.month &&
            !CalendarViewHelper.isCurrentMonthDate(
                widget.calendar.monthViewSettings.numberOfWeeksInView,
                widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
                currentMonth,
                draggingTime))) {
      currentState._updateDisabledCellMouseCursor(true);
    } else {
      currentState._updateDisabledCellMouseCursor(false);
    }

    if (widget.calendar.onDragUpdate == null) {
      return;
    }

    if (widget.calendar.onDragUpdate != null) {
      widget.calendar.onDragUpdate!(AppointmentDragUpdateDetails(
          draggingAppointment,
          previousResource,
          selectedResource,
          appointmentPosition,
          _dragDetails.value.draggingTime));
    }
  }

  void _handleLongPressEnd(
      Offset details,
      bool isTimelineView,
      bool isResourceEnabled,
      bool isMonthView,
      double viewHeaderHeight,
      double timeLabelWidth,
      double weekNumberPanelWidth) {
    if (_dragDetails.value.appointmentView == null) {
      return;
    }

    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    final Offset appointmentPosition = details + _dragDifferenceOffset!;
    final _CalendarViewState currentState = _getCurrentViewByVisibleDates()!;
    final double allDayHeight = currentState._isExpanded
        ? _updateCalendarStateDetails.allDayPanelHeight
        : currentState._allDayHeight;
    final double timeIntervalHeight = currentState._getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        currentState.widget.visibleDates.length,
        widget.isMobilePlatform);
    double xPosition = details.dx;
    double yPosition = appointmentPosition.dy;
    if (isTimelineView) {
      xPosition = !isMonthView ? appointmentPosition.dx : xPosition;
      yPosition -= viewHeaderHeight + timeLabelWidth;
    } else {
      if (widget.view == CalendarView.month) {
        if (yPosition < viewHeaderHeight) {
          yPosition = viewHeaderHeight;
        } else if (yPosition > widget.height - 1) {
          yPosition = widget.height - 1;
        }

        yPosition -= viewHeaderHeight;
        if (!widget.isRTL && xPosition <= weekNumberPanelWidth) {
          xPosition = weekNumberPanelWidth;
        } else if (widget.isRTL &&
            xPosition >= (widget.width - weekNumberPanelWidth)) {
          xPosition = widget.width - weekNumberPanelWidth;
        }
      } else {
        yPosition -= viewHeaderHeight + allDayHeight;
        if (!widget.isRTL) {
          xPosition -= timeLabelWidth;
        }

        if (xPosition >= widget.width - timeLabelWidth) {
          xPosition = widget.width - timeLabelWidth - 1;
        }
      }
    }

    if (xPosition < 0) {
      xPosition = 0;
    } else if (xPosition >= widget.width) {
      xPosition = widget.width - 1;
    }

    final double overAllWidth = isTimelineView
        ? currentState._timeIntervalHeight *
            (currentState._horizontalLinesCount! *
                currentState.widget.visibleDates.length)
        : widget.width;
    final double overAllHeight = isTimelineView || isMonthView
        ? widget.height
        : currentState._timeIntervalHeight *
            currentState._horizontalLinesCount!;

    if (isTimelineView &&
        overAllWidth < widget.width &&
        xPosition + _dragDetails.value.appointmentView!.appointmentRect!.width >
            overAllWidth) {
      xPosition = overAllWidth -
          _dragDetails.value.appointmentView!.appointmentRect!.width;
    } else if (!isTimelineView &&
        !isMonthView &&
        overAllHeight < widget.height &&
        yPosition +
                _dragDetails.value.appointmentView!.appointmentRect!.height >
            overAllHeight) {
      yPosition = overAllHeight -
          _dragDetails.value.appointmentView!.appointmentRect!.height;
    }

    final CalendarAppointment? appointment =
        _dragDetails.value.appointmentView!.appointment;
    DateTime? dropTime =
        currentState._getDateFromPosition(xPosition, yPosition, timeLabelWidth);
    if (!isMonthView) {
      if (isTimelineView) {
        final DateTime time = _timeFromPosition(
            dropTime!,
            widget.calendar.timeSlotViewSettings,
            xPosition,
            currentState,
            timeIntervalHeight,
            isTimelineView)!;
        dropTime = DateTime(dropTime.year, dropTime.month, dropTime.day,
            time.hour, time.minute);
      } else {
        dropTime = _timeFromPosition(
            dropTime!,
            widget.calendar.timeSlotViewSettings,
            yPosition,
            currentState,
            timeIntervalHeight,
            isTimelineView);
      }
    }

    CalendarResource? selectedResource, previousResource;
    int targetResourceIndex = -1;
    int sourceSelectedResourceIndex = -1;
    if (isResourceEnabled) {
      targetResourceIndex = currentState._getSelectedResourceIndex(
          (details.dy - viewHeaderHeight - timeLabelWidth) +
              currentState._timelineViewVerticalScrollController!.offset,
          viewHeaderHeight,
          timeLabelWidth);
      if (targetResourceIndex >
          widget.calendar.dataSource!.resources!.length - 1) {
        targetResourceIndex = widget.calendar.dataSource!.resources!.length - 1;
      }
      selectedResource =
          widget.calendar.dataSource!.resources![targetResourceIndex];
      sourceSelectedResourceIndex = currentState._getSelectedResourceIndex(
          _dragDetails.value.appointmentView!.appointmentRect!.top,
          viewHeaderHeight,
          timeLabelWidth);
      previousResource =
          widget.calendar.dataSource!.resources![sourceSelectedResourceIndex];
    }

    final int currentMonth = currentState.widget
        .visibleDates[currentState.widget.visibleDates.length ~/ 2].month;

    bool isAllDay = appointment!.isAllDay;
    if (!isTimelineView && widget.view != CalendarView.month) {
      isAllDay = yPosition < 0;
      if (_dragDetails.value.appointmentView!.appointment!.isSpanned &&
          !appointment.isAllDay) {
        isAllDay = appointment.isAllDay;
      }
    } else {
      isAllDay = appointment.isAllDay;
    }

    DateTime updateStartTime = isAllDay
        ? DateTime(dropTime!.year, dropTime.month, dropTime.day)
        : dropTime!;

    final Duration appointmentDuration = appointment.isAllDay &&
            widget.view != CalendarView.month &&
            !isTimelineView
        ? const Duration(hours: 1)
        : appointment.endTime.difference(appointment.startTime);
    DateTime updatedEndTime =
        isAllDay ? updateStartTime : updateStartTime.add(appointmentDuration);

    final int timeInterval = CalendarViewHelper.getTimeInterval(
        widget.calendar.timeSlotViewSettings);

    final DateTime callbackStartDate = updateStartTime;
    updateStartTime = AppointmentHelper.convertTimeToAppointmentTimeZone(
        updateStartTime, widget.calendar.timeZone, appointment.startTimeZone);
    updatedEndTime = AppointmentHelper.convertTimeToAppointmentTimeZone(
        updatedEndTime, widget.calendar.timeZone, appointment.endTimeZone);

    if (CalendarViewHelper.isDraggingAppointmentHasDisabledCell(
            _getTimeRegions(),
            _getBlackoutDates(),
            updateStartTime,
            updatedEndTime,
            isTimelineView,
            isMonthView,
            widget.calendar.minDate,
            widget.calendar.maxDate,
            timeInterval,
            targetResourceIndex,
            widget.resourceCollection) ||
        (widget.view == CalendarView.month &&
            !CalendarViewHelper.isCurrentMonthDate(
                widget.calendar.monthViewSettings.numberOfWeeksInView,
                widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
                currentMonth,
                dropTime))) {
      if (widget.calendar.onDragEnd != null) {
        widget.calendar.onDragEnd!(AppointmentDragEndDetails(
            _getCalendarAppointmentToObject(appointment, widget.calendar),
            previousResource,
            previousResource,
            appointment.exactStartTime));
      }
      _resetDraggingDetails(currentState);
      return;
    }

    CalendarAppointment? parentAppointment;
    if ((appointment.recurrenceRule != null &&
            appointment.recurrenceRule!.isNotEmpty) ||
        appointment.recurrenceId != null) {
      for (int i = 0;
          i < _updateCalendarStateDetails.appointments.length;
          i++) {
        final CalendarAppointment app =
            _updateCalendarStateDetails.appointments[i];
        if (app.id == appointment.id || app.id == appointment.recurrenceId) {
          parentAppointment = app;
          break;
        }
      }

      final List<DateTime> recurrenceDates =
          RecurrenceHelper.getRecurrenceDateTimeCollection(
              parentAppointment!.recurrenceRule ?? '',
              parentAppointment.exactStartTime,
              recurrenceDuration: AppointmentHelper.getDifference(
                  parentAppointment.exactStartTime,
                  parentAppointment.exactEndTime),
              specificStartDate: currentState.widget.visibleDates[0],
              specificEndDate: currentState.widget
                  .visibleDates[currentState.widget.visibleDates.length - 1]);

      for (int i = 0;
          i < _updateCalendarStateDetails.appointments.length;
          i++) {
        final CalendarAppointment calendarApp =
            _updateCalendarStateDetails.appointments[i];
        if (calendarApp.recurrenceId != null &&
            calendarApp.recurrenceId == parentAppointment.id) {
          recurrenceDates.add(
              AppointmentHelper.convertTimeToAppointmentTimeZone(
                  calendarApp.startTime,
                  calendarApp.startTimeZone,
                  widget.calendar.timeZone));
        }
      }

      if (parentAppointment.recurrenceExceptionDates != null) {
        for (int i = 0;
            i < parentAppointment.recurrenceExceptionDates!.length;
            i++) {
          recurrenceDates.remove(
              AppointmentHelper.convertTimeToAppointmentTimeZone(
                  parentAppointment.recurrenceExceptionDates![i],
                  '',
                  widget.calendar.timeZone));
        }
      }

      recurrenceDates.sort();
      bool canAddRecurrence =
          isSameDate(appointment.exactStartTime, callbackStartDate);
      if (!CalendarViewHelper.isDateInDateCollection(
          recurrenceDates, callbackStartDate)) {
        final int currentRecurrenceIndex =
            recurrenceDates.indexOf(appointment.exactStartTime);
        if (currentRecurrenceIndex == 0 ||
            currentRecurrenceIndex == recurrenceDates.length - 1) {
          canAddRecurrence = true;
        } else if (currentRecurrenceIndex < 0) {
          canAddRecurrence = false;
        } else {
          final DateTime previousRecurrence =
              recurrenceDates[currentRecurrenceIndex - 1];
          final DateTime nextRecurrence =
              recurrenceDates[currentRecurrenceIndex + 1];
          canAddRecurrence = (isDateWithInDateRange(
                      previousRecurrence, nextRecurrence, callbackStartDate) &&
                  !isSameDate(previousRecurrence, callbackStartDate) &&
                  !isSameDate(nextRecurrence, callbackStartDate)) ||
              canAddRecurrence;
        }
      }

      if (!canAddRecurrence) {
        if (widget.calendar.onDragEnd != null) {
          widget.calendar.onDragEnd!(AppointmentDragEndDetails(
              _getCalendarAppointmentToObject(appointment, widget.calendar),
              previousResource,
              previousResource,
              appointment.exactStartTime));
        }
        _resetDraggingDetails(currentState);
        return;
      }

      if (appointment.recurrenceId != null &&
          (appointment.recurrenceRule == null ||
              appointment.recurrenceRule!.isEmpty)) {
        widget.calendar.dataSource!.appointments!.remove(appointment.data);
        widget.calendar.dataSource!.notifyListeners(
            CalendarDataSourceAction.remove, <dynamic>[appointment.data]);
      } else {
        widget.calendar.dataSource!.appointments!
            .remove(parentAppointment.data);
        widget.calendar.dataSource!.notifyListeners(
            CalendarDataSourceAction.remove, <dynamic>[parentAppointment.data]);
        final DateTime exceptionDate =
            AppointmentHelper.convertTimeToAppointmentTimeZone(
                appointment.exactStartTime, widget.calendar.timeZone, '');
        parentAppointment.recurrenceExceptionDates != null
            ? parentAppointment.recurrenceExceptionDates!.add(exceptionDate)
            : parentAppointment.recurrenceExceptionDates = <DateTime>[
                exceptionDate
              ];

        appointment.id =
            appointment.recurrenceId != null ? appointment.id : null;
        appointment.recurrenceId =
            appointment.recurrenceId ?? parentAppointment.id;
        appointment.recurrenceRule = null;
        final dynamic newParentAppointment =
            _getCalendarAppointmentToObject(parentAppointment, widget.calendar);
        widget.calendar.dataSource!.appointments!.add(newParentAppointment);
        widget.calendar.dataSource!.notifyListeners(
            CalendarDataSourceAction.add, <dynamic>[newParentAppointment]);
      }
    } else {
      widget.calendar.dataSource!.appointments!.remove(appointment.data);
      widget.calendar.dataSource!.notifyListeners(
          CalendarDataSourceAction.remove, <dynamic>[appointment.data]);
    }

    appointment.startTime = updateStartTime;
    appointment.endTime = updatedEndTime;
    appointment.isAllDay = isAllDay;
    if (isResourceEnabled) {
      if (appointment.resourceIds != null &&
          appointment.resourceIds!.isNotEmpty) {
        if (previousResource!.id != selectedResource!.id &&
            !appointment.resourceIds!.contains(selectedResource.id)) {
          appointment.resourceIds!.remove(previousResource.id);
          appointment.resourceIds!.add(selectedResource.id);
        }
      } else {
        appointment.resourceIds = <Object>[selectedResource!.id];
      }
    }

    final dynamic newAppointment =
        _getCalendarAppointmentToObject(appointment, widget.calendar);

    widget.calendar.dataSource!.appointments!.add(newAppointment);
    widget.calendar.dataSource!.notifyListeners(
        CalendarDataSourceAction.add, <dynamic>[newAppointment]);

    _resetDraggingDetails(currentState);
    if (widget.calendar.onDragEnd != null) {
      widget.calendar.onDragEnd!(AppointmentDragEndDetails(newAppointment,
          previousResource, selectedResource, callbackStartDate));
    }
  }

  void _resetDraggingDetails(_CalendarViewState currentState) {
    _dragDetails.value.appointmentView = null;
    _dragDetails.value.position.value = null;
    _dragDifferenceOffset = null;
    _dragDetails.value.timeIntervalHeight = null;
    currentState._hoveringAppointmentView = null;
    currentState._updateDraggingMouseCursor(false);
  }

  /// Method added to get the blackout dates in the current visible views of the
  /// calendar, we have filtered the blackoutdates based on visible dates, and
  /// pass them into the child.
  List<DateTime> _getBlackoutDates() {
    final List<DateTime> blackoutDates = <DateTime>[];
    if (_currentView.blackoutDates != null) {
      blackoutDates.addAll(_currentView.blackoutDates!);
    }
    if (_previousView.blackoutDates != null) {
      blackoutDates.addAll(_previousView.blackoutDates!);
    }
    if (_nextView.blackoutDates != null) {
      blackoutDates.addAll(_nextView.blackoutDates!);
    }

    return blackoutDates;
  }

  /// Method added to get the special time regions from the current visible
  /// views of the calendar, we have filtered the special time regions based on
  /// visible dates, and pass them into the child.
  List<CalendarTimeRegion> _getTimeRegions() {
    final List<CalendarTimeRegion> regions = <CalendarTimeRegion>[];
    if (_currentView.regions != null) {
      regions.addAll(_currentView.regions!);
    }
    if (_previousView.regions != null) {
      regions.addAll(_previousView.regions!);
    }
    if (_nextView.regions != null) {
      regions.addAll(_nextView.regions!);
    }

    return regions;
  }

  /// Get the scroll layout current child view state based on its visible dates.
  _CalendarViewState? _getCurrentViewByVisibleDates() {
    _CalendarView? view;
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

    return (view.key! as GlobalKey<_CalendarViewState>).currentState;
  }

  /// Handle start of the scroll, set the scroll start position and check
  /// the start position as start or end of timeline scroll controller.
  /// If the timeline view scroll starts at min or max scroll position then
  /// move the previous view to end of the scroll or move the next view to
  /// start of the scroll and set the drag as timeline scroll controller drag.
  void _handleDragStart(
      DragStartDetails details,
      bool isNeedDragAndDrop,
      bool isTimelineView,
      bool isResourceEnabled,
      double viewHeaderHeight,
      double timeLabelWidth,
      double resourceViewSize) {
    if (!CalendarViewHelper.isTimelineView(widget.view)) {
      return;
    }
    final _CalendarViewState viewKey = _getCurrentViewByVisibleDates()!;
    if (viewKey._hoveringAppointmentView != null &&
        !widget.isMobilePlatform &&
        isNeedDragAndDrop) {
      _handleAppointmentDragStart(
          viewKey._hoveringAppointmentView!.clone(),
          isTimelineView,
          Offset(details.localPosition.dx - widget.width,
              details.localPosition.dy),
          isResourceEnabled,
          viewHeaderHeight,
          timeLabelWidth);
      return;
    }
    _timelineScrollStartPosition = viewKey._scrollController!.position.pixels;
    _timelineStartPosition = details.globalPosition.dx;
    _isNeedTimelineScrollEnd = false;

    /// If the timeline view scroll starts at min or max scroll position then
    /// move the previous view to end of the scroll or move the next view to
    /// start of the scroll
    if (_timelineScrollStartPosition >=
        viewKey._scrollController!.position.maxScrollExtent) {
      _positionTimelineView();
    } else if (_timelineScrollStartPosition <=
        viewKey._scrollController!.position.minScrollExtent) {
      _positionTimelineView();
    }

    /// Set the drag as timeline scroll controller drag.
    if (viewKey._scrollController!.hasClients) {
      _drag = viewKey._scrollController!.position.drag(details, _disposeDrag);
    }
  }

  /// Handles the scroll update, if the scroll moves after the timeline max
  /// scroll position or before the timeline min scroll position then check the
  /// scroll start position if it is start or end of the timeline scroll view
  /// then pass the touch to custom scroll view and set the timeline view
  /// drag as null;
  void _handleDragUpdate(
      DragUpdateDetails details,
      bool isTimelineView,
      bool isResourceEnabled,
      bool isMonthView,
      double viewHeaderHeight,
      double timeLabelWidth,
      double resourceItemHeight,
      double weekNumberPanelWidth,
      bool isNeedDragAndDrop,
      double resourceViewSize) {
    if (!CalendarViewHelper.isTimelineView(widget.view)) {
      return;
    }
    final _CalendarViewState viewKey = _getCurrentViewByVisibleDates()!;

    if (_dragDetails.value.appointmentView != null &&
        !widget.isMobilePlatform &&
        isNeedDragAndDrop) {
      _handleLongPressMove(
          Offset(details.localPosition.dx - widget.width,
              details.localPosition.dy),
          isTimelineView,
          isResourceEnabled,
          isMonthView,
          viewHeaderHeight,
          timeLabelWidth,
          resourceItemHeight,
          weekNumberPanelWidth);
      return;
    }

    /// Calculate the scroll difference by current scroll position and start
    /// scroll position.
    final double difference =
        details.globalPosition.dx - _timelineStartPosition;
    if (_timelineScrollStartPosition >=
            viewKey._scrollController!.position.maxScrollExtent &&
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
            viewKey._scrollController!.position.minScrollExtent &&
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
  void _handleDragEnd(
      DragEndDetails details,
      bool isTimelineView,
      bool isResourceEnabled,
      bool isMonthView,
      double viewHeaderHeight,
      double timeLabelWidth,
      double weekNumberPanelWidth,
      bool isNeedDragAndDrop) {
    if (_dragDetails.value.appointmentView != null &&
        !widget.isMobilePlatform &&
        isNeedDragAndDrop) {
      _handleLongPressEnd(
          _dragDetails.value.position.value! - _dragDifferenceOffset!,
          isTimelineView,
          isResourceEnabled,
          isMonthView,
          viewHeaderHeight,
          timeLabelWidth,
          weekNumberPanelWidth);
      return;
    }

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
    final _CalendarViewState? viewKey = _getCurrentViewByVisibleDates();
    if (event is PointerScrollEvent && viewKey != null) {
      double scrolledPosition =
          widget.isRTL ? -event.scrollDelta.dx : event.scrollDelta.dx;

      /// Check the scrolling is vertical and timeline view does not have
      /// vertical scroll view then scroll the vertical movement on
      /// Horizontal direction.
      if (widget.height <= _viewPortHeight! &&
          event.scrollDelta.dy.abs() > event.scrollDelta.dx.abs() &&
          viewKey._timelineViewVerticalScrollController!.position
                  .maxScrollExtent ==
              0) {
        scrolledPosition =
            widget.isRTL ? -event.scrollDelta.dy : event.scrollDelta.dy;
      }

      final double targetScrollOffset = math.min(
          math.max(
              viewKey._scrollController!.position.pixels + scrolledPosition,
              viewKey._scrollController!.position.minScrollExtent),
          viewKey._scrollController!.position.maxScrollExtent);
      if (targetScrollOffset != viewKey._scrollController!.position.pixels) {
        viewKey._scrollController!.position.jumpTo(targetScrollOffset);
      }
    }
  }

  void _updateVisibleDates() {
    widget.getCalendarState(_updateCalendarStateDetails);
    final List<int>? nonWorkingDays = (widget.view == CalendarView.workWeek ||
            widget.view == CalendarView.timelineWorkWeek)
        ? widget.calendar.timeSlotViewSettings.nonWorkingDays
        : null;
    final int visibleDatesCount = DateTimeHelper.getViewDatesCount(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        nonWorkingDays);

    final DateTime currentDate = DateTime(
        _updateCalendarStateDetails.currentDate!.year,
        _updateCalendarStateDetails.currentDate!.month,
        _updateCalendarStateDetails.currentDate!.day);
    final DateTime prevDate = DateTimeHelper.getPreviousViewStartDate(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        currentDate,
        visibleDatesCount,
        nonWorkingDays);
    final DateTime nextDate = DateTimeHelper.getNextViewStartDate(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        currentDate,
        visibleDatesCount,
        nonWorkingDays);

    _visibleDates = getVisibleDates(currentDate, nonWorkingDays,
            widget.calendar.firstDayOfWeek, visibleDatesCount)
        .cast();
    _previousViewVisibleDates = getVisibleDates(
            widget.isRTL ? nextDate : prevDate,
            nonWorkingDays,
            widget.calendar.firstDayOfWeek,
            visibleDatesCount)
        .cast();
    _nextViewVisibleDates = getVisibleDates(widget.isRTL ? prevDate : nextDate,
            nonWorkingDays, widget.calendar.firstDayOfWeek, visibleDatesCount)
        .cast();
    if (widget.view == CalendarView.timelineMonth) {
      _visibleDates = DateTimeHelper.getCurrentMonthDates(_visibleDates);
      _previousViewVisibleDates =
          DateTimeHelper.getCurrentMonthDates(_previousViewVisibleDates);
      _nextViewVisibleDates =
          DateTimeHelper.getCurrentMonthDates(_nextViewVisibleDates);
    }

    _currentViewVisibleDates = _visibleDates;
    _updateCalendarStateDetails.currentViewVisibleDates =
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
    final List<int>? nonWorkingDays = (widget.view == CalendarView.workWeek ||
            widget.view == CalendarView.timelineWorkWeek)
        ? widget.calendar.timeSlotViewSettings.nonWorkingDays
        : null;
    final int visibleDatesCount = DateTimeHelper.getViewDatesCount(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        nonWorkingDays);

    if (widget.view == CalendarView.month &&
        widget.calendar.monthViewSettings.numberOfWeeksInView == 6) {
      currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length / 2).truncate()];
    }

    if (widget.isRTL) {
      currentViewDate = DateTimeHelper.getPreviousViewStartDate(
          widget.view,
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          currentViewDate,
          visibleDatesCount,
          nonWorkingDays);
    } else {
      currentViewDate = DateTimeHelper.getNextViewStartDate(
          widget.view,
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          currentViewDate,
          visibleDatesCount,
          nonWorkingDays);
    }

    List<DateTime> dates = getVisibleDates(currentViewDate, nonWorkingDays,
            widget.calendar.firstDayOfWeek, visibleDatesCount)
        .cast();

    if (widget.view == CalendarView.timelineMonth) {
      dates = DateTimeHelper.getCurrentMonthDates(dates);
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
    final List<int>? nonWorkingDays = (widget.view == CalendarView.workWeek ||
            widget.view == CalendarView.timelineWorkWeek)
        ? widget.calendar.timeSlotViewSettings.nonWorkingDays
        : null;
    final int visibleDatesCount = DateTimeHelper.getViewDatesCount(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        nonWorkingDays);

    if (widget.view == CalendarView.month &&
        widget.calendar.monthViewSettings.numberOfWeeksInView == 6) {
      currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length / 2).truncate()];
    }

    if (widget.isRTL) {
      currentViewDate = DateTimeHelper.getNextViewStartDate(
          widget.view,
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          currentViewDate,
          visibleDatesCount,
          nonWorkingDays);
    } else {
      currentViewDate = DateTimeHelper.getPreviousViewStartDate(
          widget.view,
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          currentViewDate,
          visibleDatesCount,
          nonWorkingDays);
    }

    List<DateTime> dates = getVisibleDates(currentViewDate, nonWorkingDays,
            widget.calendar.firstDayOfWeek, visibleDatesCount)
        .cast();

    if (widget.view == CalendarView.timelineMonth) {
      dates = DateTimeHelper.getCurrentMonthDates(dates);
    }

    if (_currentChildIndex == 0) {
      _visibleDates = dates;
    } else if (_currentChildIndex == 1) {
      _nextViewVisibleDates = dates;
    } else {
      _previousViewVisibleDates = dates;
    }
  }

  void _getCalendarViewStateDetails(UpdateCalendarStateDetails details) {
    widget.getCalendarState(_updateCalendarStateDetails);
    details.currentDate = _updateCalendarStateDetails.currentDate;
    details.currentViewVisibleDates =
        _updateCalendarStateDetails.currentViewVisibleDates;
    details.selectedDate = _updateCalendarStateDetails.selectedDate;
    details.allDayPanelHeight = _updateCalendarStateDetails.allDayPanelHeight;
    details.allDayAppointmentViewCollection =
        _updateCalendarStateDetails.allDayAppointmentViewCollection;
    details.appointments = _updateCalendarStateDetails.appointments;
    details.visibleAppointments =
        _updateCalendarStateDetails.visibleAppointments;
  }

  void _updateCalendarViewStateDetails(UpdateCalendarStateDetails details) {
    _updateCalendarStateDetails.selectedDate = details.selectedDate;
    widget.updateCalendarState(_updateCalendarStateDetails);
  }

  CalendarTimeRegion _getCalendarTimeRegionFromTimeRegion(TimeRegion region) {
    return CalendarTimeRegion(
      startTime: region.startTime,
      endTime: region.endTime,
      color: region.color,
      text: region.text,
      textStyle: region.textStyle,
      recurrenceExceptionDates: region.recurrenceExceptionDates,
      recurrenceRule: region.recurrenceRule,
      resourceIds: region.resourceIds,
      timeZone: region.timeZone,
      enablePointerInteraction: region.enablePointerInteraction,
      iconData: region.iconData,
    );
  }

  /// Return collection of time region, in between the visible dates.
  List<CalendarTimeRegion> _getRegions(List<DateTime> visibleDates) {
    final DateTime visibleStartDate = visibleDates[0];
    final DateTime visibleEndDate = visibleDates[visibleDates.length - 1];
    final List<CalendarTimeRegion> regionCollection = <CalendarTimeRegion>[];
    if (_timeRegions == null) {
      return regionCollection;
    }

    final DateTime startDate =
        AppointmentHelper.convertToStartTime(visibleStartDate);
    final DateTime endDate = AppointmentHelper.convertToEndTime(visibleEndDate);
    for (int j = 0; j < _timeRegions!.length; j++) {
      final TimeRegion timeRegion = _timeRegions![j];
      final CalendarTimeRegion region =
          _getCalendarTimeRegionFromTimeRegion(timeRegion);
      region.actualStartTime =
          AppointmentHelper.convertTimeToAppointmentTimeZone(
              region.startTime, region.timeZone, widget.calendar.timeZone);
      region.actualEndTime = AppointmentHelper.convertTimeToAppointmentTimeZone(
          region.endTime, region.timeZone, widget.calendar.timeZone);
      region.data = timeRegion;

      if (region.recurrenceRule == null || region.recurrenceRule == '') {
        if (AppointmentHelper.isDateRangeWithinVisibleDateRange(
            region.actualStartTime, region.actualEndTime, startDate, endDate)) {
          regionCollection.add(region);
        }

        continue;
      }

      getRecurrenceRegions(region, regionCollection, startDate, endDate,
          widget.calendar.timeZone);
    }

    return regionCollection;
  }

  /// Get the recurrence time regions in between the visible date range.
  void getRecurrenceRegions(
      CalendarTimeRegion region,
      List<CalendarTimeRegion> regions,
      DateTime visibleStartDate,
      DateTime visibleEndDate,
      String? calendarTimeZone) {
    final DateTime regionStartDate = region.actualStartTime;
    if (regionStartDate.isAfter(visibleEndDate)) {
      return;
    }

    String rule = region.recurrenceRule!;
    if (!rule.contains('COUNT') && !rule.contains('UNTIL')) {
      final DateFormat formatter = DateFormat('yyyyMMdd');
      final String newSubString = ';UNTIL=${formatter.format(visibleEndDate)}';
      rule = rule + newSubString;
    }

    final List<DateTime> recursiveDates =
        RecurrenceHelper.getRecurrenceDateTimeCollection(
            rule, region.actualStartTime,
            recurrenceDuration: AppointmentHelper.getDifference(
                region.actualStartTime, region.actualEndTime),
            specificStartDate: visibleStartDate,
            specificEndDate: visibleEndDate);

    for (int j = 0; j < recursiveDates.length; j++) {
      final DateTime recursiveDate = recursiveDates[j];
      if (region.recurrenceExceptionDates != null) {
        bool isDateContains = false;
        for (int i = 0; i < region.recurrenceExceptionDates!.length; i++) {
          final DateTime date =
              AppointmentHelper.convertTimeToAppointmentTimeZone(
                  region.recurrenceExceptionDates![i], '', calendarTimeZone);
          if (isSameDate(date, recursiveDate)) {
            isDateContains = true;
            break;
          }
        }
        if (isDateContains) {
          continue;
        }
      }

      final CalendarTimeRegion occurrenceRegion =
          cloneRecurrenceRegion(region, recursiveDate, calendarTimeZone);
      regions.add(occurrenceRegion);
    }
  }

  /// Used to clone the time region with new values.
  CalendarTimeRegion cloneRecurrenceRegion(CalendarTimeRegion region,
      DateTime recursiveDate, String? calendarTimeZone) {
    final int minutes = AppointmentHelper.getDifference(
            region.actualStartTime, region.actualEndTime)
        .inMinutes;
    final DateTime actualEndTime = DateTimeHelper.getDateTimeValue(
        addDuration(recursiveDate, Duration(minutes: minutes)));
    final DateTime startDate =
        AppointmentHelper.convertTimeToAppointmentTimeZone(
            recursiveDate, calendarTimeZone, region.timeZone);

    final DateTime endDate = AppointmentHelper.convertTimeToAppointmentTimeZone(
        actualEndTime, calendarTimeZone, region.timeZone);

    final TimeRegion occurrenceTimeRegion =
        region.data.copyWith(startTime: startDate, endTime: endDate);
    final CalendarTimeRegion occurrenceRegion =
        _getCalendarTimeRegionFromTimeRegion(occurrenceTimeRegion);
    occurrenceRegion.actualStartTime = recursiveDate;
    occurrenceRegion.actualEndTime = actualEndTime;
    occurrenceRegion.data = occurrenceTimeRegion;
    return occurrenceRegion;
  }

  /// Return date collection which falls between the visible date range.
  List<DateTime> _getDatesWithInVisibleDateRange(
      List<DateTime>? dates, List<DateTime> visibleDates) {
    final List<DateTime> visibleMonthDates = <DateTime>[];
    if (dates == null) {
      return visibleMonthDates;
    }

    final DateTime visibleStartDate = visibleDates[0];
    final DateTime visibleEndDate = visibleDates[visibleDates.length - 1];
    final int datesCount = dates.length;
    final Map<String, DateTime> dateCollection = <String, DateTime>{};
    for (int i = 0; i < datesCount; i++) {
      final DateTime currentDate = dates[i];
      if (!isDateWithInDateRange(
          visibleStartDate, visibleEndDate, currentDate)) {
        continue;
      }

      if (dateCollection.keys.contains(
          currentDate.day.toString() + currentDate.month.toString())) {
        continue;
      }

      dateCollection[currentDate.day.toString() +
          currentDate.month.toString()] = currentDate;
      visibleMonthDates.add(currentDate);
    }

    return visibleMonthDates;
  }

  List<Widget> _addViews() {
    if (_children.isEmpty) {
      _previousView = _CalendarView(
        widget.calendar,
        widget.view,
        _previousViewVisibleDates,
        widget.width,
        widget.height,
        widget.agendaSelectedDate,
        widget.locale,
        widget.calendarTheme,
        widget.themeData,
        _getRegions(_previousViewVisibleDates),
        _getDatesWithInVisibleDateRange(
            widget.blackoutDates, _previousViewVisibleDates),
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        widget.resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        widget.minDate,
        widget.maxDate,
        widget.localizations,
        widget.timelineMonthWeekNumberNotifier,
        _dragDetails,
        (UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        (UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
        key: _previousViewKey,
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
        widget.themeData,
        _getRegions(_visibleDates),
        _getDatesWithInVisibleDateRange(widget.blackoutDates, _visibleDates),
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        widget.resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        widget.minDate,
        widget.maxDate,
        widget.localizations,
        widget.timelineMonthWeekNumberNotifier,
        _dragDetails,
        (UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        (UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
        key: _currentViewKey,
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
        widget.themeData,
        _getRegions(_nextViewVisibleDates),
        _getDatesWithInVisibleDateRange(
            widget.blackoutDates, _nextViewVisibleDates),
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        widget.resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        widget.minDate,
        widget.maxDate,
        widget.localizations,
        widget.timelineMonthWeekNumberNotifier,
        _dragDetails,
        (UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        (UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
        key: _nextViewKey,
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

    final AppointmentLayout appointmentLayout =
        viewKey.currentState!._appointmentLayout;
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
        widget.themeData,
        _getRegions(visibleDates),
        _getDatesWithInVisibleDateRange(widget.blackoutDates, visibleDates),
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        widget.resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        widget.minDate,
        widget.maxDate,
        widget.localizations,
        widget.timelineMonthWeekNumberNotifier,
        _dragDetails,
        (UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        (UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
        key: viewKey,
      );

      _children[index] = view;
    }
    // check and update the visible appointments in the view
    else if (!CalendarViewHelper.isCollectionEqual(
        appointmentLayout.visibleAppointments.value,
        _updateCalendarStateDetails.visibleAppointments)) {
      if (widget.view != CalendarView.month &&
          !CalendarViewHelper.isTimelineView(widget.view)) {
        view = _CalendarView(
          widget.calendar,
          widget.view,
          visibleDates,
          widget.width,
          widget.height,
          widget.agendaSelectedDate,
          widget.locale,
          widget.calendarTheme,
          widget.themeData,
          view.regions,
          view.blackoutDates,
          _focusNode,
          widget.removePicker,
          widget.calendar.allowViewNavigation,
          widget.controller,
          widget.resourcePanelScrollController,
          widget.resourceCollection,
          widget.textScaleFactor,
          widget.isMobilePlatform,
          widget.minDate,
          widget.maxDate,
          widget.localizations,
          widget.timelineMonthWeekNumberNotifier,
          _dragDetails,
          (UpdateCalendarStateDetails details) {
            _updateCalendarViewStateDetails(details);
          },
          (UpdateCalendarStateDetails details) {
            _getCalendarViewStateDetails(details);
          },
          key: viewKey,
        );
        _children[index] = view;
      } else if (view.calendar != widget.calendar) {
        /// Update the calendar view when calendar properties like appointment
        /// text style dynamically changed.
        view = _CalendarView(
          widget.calendar,
          widget.view,
          visibleDates,
          widget.width,
          widget.height,
          widget.agendaSelectedDate,
          widget.locale,
          widget.calendarTheme,
          widget.themeData,
          view.regions,
          view.blackoutDates,
          _focusNode,
          widget.removePicker,
          widget.calendar.allowViewNavigation,
          widget.controller,
          widget.resourcePanelScrollController,
          widget.resourceCollection,
          widget.textScaleFactor,
          widget.isMobilePlatform,
          widget.minDate,
          widget.maxDate,
          widget.localizations,
          widget.timelineMonthWeekNumberNotifier,
          _dragDetails,
          (UpdateCalendarStateDetails details) {
            _updateCalendarViewStateDetails(details);
          },
          (UpdateCalendarStateDetails details) {
            _getCalendarViewStateDetails(details);
          },
          key: viewKey,
        );

        _children[index] = view;
      } else if (view.visibleDates == _currentViewVisibleDates) {
        /// Remove the appointment selection when the selected
        /// appointment removed.
        if (viewKey.currentState!._selectionPainter != null &&
            viewKey.currentState!._selectionPainter!.appointmentView != null &&
            (!_updateCalendarStateDetails.visibleAppointments.contains(viewKey
                .currentState!
                ._selectionPainter!
                .appointmentView!
                .appointment))) {
          viewKey.currentState!._selectionPainter!.appointmentView = null;
          viewKey.currentState!._selectionPainter!.repaintNotifier.value =
              !viewKey.currentState!._selectionPainter!.repaintNotifier.value;
        }

        appointmentLayout.visibleAppointments.value =
            _updateCalendarStateDetails.visibleAppointments;
        if (widget.view == CalendarView.month &&
            widget.calendar.monthCellBuilder != null) {
          viewKey.currentState!._monthView.visibleAppointmentNotifier.value =
              _updateCalendarStateDetails.visibleAppointments;
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
        widget.themeData,
        view.regions,
        view.blackoutDates,
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        widget.resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        widget.minDate,
        widget.maxDate,
        widget.localizations,
        widget.timelineMonthWeekNumberNotifier,
        _dragDetails,
        (UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        (UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
        key: viewKey,
      );

      _children[index] = view;
    } else if (timeZoneLoaded || widget.calendar.timeZone != '') {
      view = _CalendarView(
        widget.calendar,
        widget.view,
        visibleDates,
        widget.width,
        widget.height,
        widget.agendaSelectedDate,
        widget.locale,
        widget.calendarTheme,
        widget.themeData,
        view.regions,
        view.blackoutDates,
        _focusNode,
        widget.removePicker,
        widget.calendar.allowViewNavigation,
        widget.controller,
        widget.resourcePanelScrollController,
        widget.resourceCollection,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        widget.minDate,
        widget.maxDate,
        widget.localizations,
        widget.timelineMonthWeekNumberNotifier,
        _dragDetails,
        (UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
        (UpdateCalendarStateDetails details) {
          _getCalendarViewStateDetails(details);
        },
        key: viewKey,
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
      List<TimeRegion>? regions1, List<TimeRegion>? regions2) {
    /// Check both instance as equal
    /// eg., if both are null then its equal.
    if (regions1 == regions2) {
      return true;
    }

    /// Check the collections are not equal based on its length
    if (regions2 == null ||
        regions1 == null ||
        regions1.length != regions2.length) {
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
    if (!CalendarViewHelper.isTimelineView(widget.view)) {
      return;
    }

    for (int i = 0; i < _children.length; i++) {
      final GlobalKey<_CalendarViewState> viewKey =
          // ignore: avoid_as
          _children[i].key! as GlobalKey<_CalendarViewState>;
      if (CalendarViewHelper.isResourceEnabled(
          widget.calendar.dataSource, widget.view)) {
        viewKey.currentState!._selectedResourceIndex = 0;
        viewKey.currentState!._selectionPainter!.selectedResourceIndex = 0;
      } else {
        viewKey.currentState!._selectedResourceIndex = -1;
        viewKey.currentState!._selectionPainter!.selectedResourceIndex = -1;
      }
    }
  }

  /// Updates the selection, when the resource enabled and the resource
  /// collection modified, moves or removes the selection based on the action
  /// performed.
  void _updateSelectedResourceIndex() {
    for (int i = 0; i < _children.length; i++) {
      final GlobalKey<_CalendarViewState> viewKey =
          // ignore: avoid_as
          _children[i].key! as GlobalKey<_CalendarViewState>;
      final int selectedResourceIndex =
          viewKey.currentState!._selectedResourceIndex;
      if (selectedResourceIndex != -1) {
        final Object selectedResourceId =
            widget.resourceCollection![selectedResourceIndex].id;
        final int newIndex = CalendarViewHelper.getResourceIndex(
            widget.calendar.dataSource?.resources, selectedResourceId);
        viewKey.currentState!._selectedResourceIndex = newIndex;
      }
    }
  }

  void _updateSelection() {
    widget.getCalendarState(_updateCalendarStateDetails);
    final _CalendarViewState previousViewState = _previousViewKey.currentState!;
    final _CalendarViewState currentViewState = _currentViewKey.currentState!;
    final _CalendarViewState nextViewState = _nextViewKey.currentState!;
    previousViewState._allDaySelectionNotifier.value = null;
    currentViewState._allDaySelectionNotifier.value = null;
    nextViewState._allDaySelectionNotifier.value = null;
    previousViewState._selectionPainter!.selectedDate =
        _updateCalendarStateDetails.selectedDate;
    nextViewState._selectionPainter!.selectedDate =
        _updateCalendarStateDetails.selectedDate;
    currentViewState._selectionPainter!.selectedDate =
        _updateCalendarStateDetails.selectedDate;
    previousViewState._selectionPainter!.appointmentView = null;
    nextViewState._selectionPainter!.appointmentView = null;
    currentViewState._selectionPainter!.appointmentView = null;
    previousViewState._selectionNotifier.value =
        !previousViewState._selectionNotifier.value;
    currentViewState._selectionNotifier.value =
        !currentViewState._selectionNotifier.value;
    nextViewState._selectionNotifier.value =
        !nextViewState._selectionNotifier.value;
  }

  void _updateMoveToDate() {
    if (widget.view == CalendarView.month) {
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_currentChildIndex == 0) {
        _previousViewKey.currentState?._scrollToPosition();
      } else if (_currentChildIndex == 1) {
        _currentViewKey.currentState?._scrollToPosition();
      } else if (_currentChildIndex == 2) {
        _nextViewKey.currentState?._scrollToPosition();
      }
    });
  }

  CalendarDetails? _getCalendarDetails(Offset position) {
    if (_currentChildIndex == 0) {
      return _previousViewKey.currentState?._getCalendarViewDetails(position);
    } else if (_currentChildIndex == 1) {
      return _currentViewKey.currentState?._getCalendarViewDetails(position);
    } else if (_currentChildIndex == 2) {
      return _nextViewKey.currentState?._getCalendarViewDetails(position);
    } else {
      return null;
    }
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

    _updateCalendarStateDetails.currentViewVisibleDates =
        _currentViewVisibleDates;
    if (widget.view == CalendarView.month &&
        widget.calendar.monthViewSettings.numberOfWeeksInView == 6) {
      final DateTime currentMonthDate =
          _currentViewVisibleDates[_currentViewVisibleDates.length ~/ 2];
      _updateCalendarStateDetails.currentDate =
          DateTime(currentMonthDate.year, currentMonthDate.month);
    } else {
      _updateCalendarStateDetails.currentDate = _currentViewVisibleDates[0];
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
    if (widget.view != CalendarView.month &&
        !CalendarViewHelper.isTimelineView(widget.view)) {
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

      // resets position to zero on the swipe end to avoid the
      // unwanted date updates.
      _position = 0;
    });

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
    if (widget.view != CalendarView.month &&
        !CalendarViewHelper.isTimelineView(widget.view)) {
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

      // resets position to zero on the swipe end to avoid the
      // unwanted date updates.
      _position = 0;
    });

    _updateAppointmentPainter();
  }

  void _moveToNextViewWithAnimation() {
    if (!widget.isMobilePlatform) {
      _moveToNextWebViewWithAnimation();
      return;
    }

    if (!DateTimeHelper.canMoveToNextView(
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
    if (CalendarViewHelper.isTimelineView(widget.view)) {
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

  void _moveToPreviousViewWithAnimation({bool isScrollToEnd = false}) {
    if (!widget.isMobilePlatform) {
      _moveToPreviousWebViewWithAnimation(isScrollToEnd: isScrollToEnd);
      return;
    }

    if (!DateTimeHelper.canMoveToPreviousView(
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
    if (CalendarViewHelper.isTimelineView(widget.view)) {
      _positionTimelineView(isScrolledToEnd: isScrollToEnd);
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

  void _moveToPreviousWebViewWithAnimation({bool isScrollToEnd = false}) {
    if (!DateTimeHelper.canMoveToPreviousView(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        widget.calendar.minDate,
        widget.calendar.maxDate,
        _currentViewVisibleDates,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.isRTL)) {
      return;
    }

    /// Resets the animation from, we have added this without condition so that
    /// the selection updates, when the cells selected through keyboard right
    /// arrows with fast finger.
    widget.fadeInController!.reset();

    final bool isTimelineView = CalendarViewHelper.isTimelineView(widget.view);
    // Handled for time line view, to move the previous and next view to it's
    // start and end position accordingly
    if (isTimelineView) {
      _positionTimelineView(isScrolledToEnd: isScrollToEnd);
    } else if (!isTimelineView && widget.view != CalendarView.month) {
      _updateDayViewScrollPosition();
    }

    /// updates the current view visible dates when the view swiped.
    _updateCurrentViewVisibleDates();
    _position = 0;
    widget.fadeInController!.forward();
    _updateSelection();
    _updatePreviousViewVisibleDates();

    /// Updates the all day panel of the view, when the all day panel expanded
    /// and the view swiped with the expanded all day panel, and when we swipe
    /// back to the view or swipes three times will render the all day panel as
    /// expanded, to collapse the all day panel in day, week and work week view,
    /// we have added this condition and called the method.
    if (widget.view != CalendarView.month && !isTimelineView) {
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
    if (!DateTimeHelper.canMoveToNextView(
        widget.view,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        widget.calendar.minDate,
        widget.calendar.maxDate,
        _currentViewVisibleDates,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.isRTL)) {
      return;
    }

    /// Resets the animation from, we have added this without condition so that
    /// the selection updates, when the cells selected through keyboard right
    /// arrows with fast finger.
    widget.fadeInController!.reset();

    final bool isTimelineView = CalendarViewHelper.isTimelineView(widget.view);
    // Handled for time line view, to move the previous and next view to it's
    // start and end position accordingly
    if (isTimelineView) {
      _positionTimelineView(isScrolledToEnd: false);
    } else if (!isTimelineView && widget.view != CalendarView.month) {
      _updateDayViewScrollPosition();
    }

    /// updates the current view visible dates when the view swiped
    _updateCurrentViewVisibleDates(isNextView: true);

    _position = 0;
    widget.fadeInController!.forward();
    _updateSelection();
    _updateNextViewVisibleDates();

    /// Updates the all day panel of the view, when the all day panel expanded
    /// and the view swiped with the expanded all day panel, and when we swipe
    /// back to the view or swipes three times will render the all day panel as
    /// expanded, to collapse the all day panel in day, week and work week view,
    /// we have added this condition and called the method.
    if (widget.view != CalendarView.month && !isTimelineView) {
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

  void _updateScrollPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_previousViewKey.currentState == null ||
          _currentViewKey.currentState == null ||
          _nextViewKey.currentState == null ||
          _previousViewKey.currentState!._scrollController == null ||
          _currentViewKey.currentState!._scrollController == null ||
          _nextViewKey.currentState!._scrollController == null ||
          !_previousViewKey.currentState!._scrollController!.hasClients ||
          !_currentViewKey.currentState!._scrollController!.hasClients ||
          !_nextViewKey.currentState!._scrollController!.hasClients) {
        return;
      }

      _updateDayViewScrollPosition();
    });
  }

  /// Update the current day view view scroll position to other views.
  void _updateDayViewScrollPosition() {
    double scrolledPosition = 0;
    if (_currentChildIndex == 0) {
      scrolledPosition =
          _previousViewKey.currentState!._scrollController!.offset;
    } else if (_currentChildIndex == 1) {
      scrolledPosition =
          _currentViewKey.currentState!._scrollController!.offset;
    } else if (_currentChildIndex == 2) {
      scrolledPosition = _nextViewKey.currentState!._scrollController!.offset;
    }

    if (_previousViewKey.currentState!._scrollController!.offset !=
            scrolledPosition &&
        _previousViewKey
                .currentState!._scrollController!.position.maxScrollExtent >=
            scrolledPosition) {
      _previousViewKey.currentState!._scrollController!
          .jumpTo(scrolledPosition);
    }

    if (_currentViewKey.currentState!._scrollController!.offset !=
            scrolledPosition &&
        _currentViewKey
                .currentState!._scrollController!.position.maxScrollExtent >=
            scrolledPosition) {
      _currentViewKey.currentState!._scrollController!.jumpTo(scrolledPosition);
    }

    if (_nextViewKey.currentState!._scrollController!.offset !=
            scrolledPosition &&
        _nextViewKey
                .currentState!._scrollController!.position.maxScrollExtent >=
            scrolledPosition) {
      _nextViewKey.currentState!._scrollController!.jumpTo(scrolledPosition);
    }
  }

  int _getRowOfDate(List<DateTime> visibleDates, DateTime selectedDate) {
    for (int i = 0; i < visibleDates.length; i++) {
      if (isSameDate(selectedDate, visibleDates[i])) {
        switch (widget.view) {
          case CalendarView.day:
          case CalendarView.week:
          case CalendarView.workWeek:
          case CalendarView.schedule:
            return -1;
          case CalendarView.month:
            return i ~/ DateTime.daysPerWeek;
          case CalendarView.timelineDay:
          case CalendarView.timelineWeek:
          case CalendarView.timelineWorkWeek:
          case CalendarView.timelineMonth:
            return i;
        }
      }
    }

    return -1;
  }

  DateTime _updateSelectedDateForRightArrow(_CalendarView currentView,
      _CalendarViewState currentViewState, DateTime? selectedDate) {
    /// Condition added to move the view to next view when the selection reaches
    /// the last horizontal cell of the view in day, week, workweek, month and
    /// timeline month.
    if (!CalendarViewHelper.isTimelineView(widget.view)) {
      final int visibleDatesCount = currentView.visibleDates.length;
      if (isSameDate(
          currentView.visibleDates[visibleDatesCount - 1], selectedDate)) {
        _moveToNextViewWithAnimation();
      }

      selectedDate = AppointmentHelper.addDaysWithTime(selectedDate!, 1,
          selectedDate.hour, selectedDate.minute, selectedDate.second);

      /// Move to next view when the new selected date as next month date.
      if (widget.view == CalendarView.month &&
          !CalendarViewHelper.isCurrentMonthDate(
              widget.calendar.monthViewSettings.numberOfWeeksInView,
              widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
              currentView.visibleDates[visibleDatesCount ~/ 2].month,
              selectedDate)) {
        _moveToNextViewWithAnimation();
      } else if (widget.view == CalendarView.workWeek) {
        for (int i = 0;
            i <
                DateTime.daysPerWeek -
                    widget.calendar.timeSlotViewSettings.nonWorkingDays.length;
            i++) {
          if (widget.calendar.timeSlotViewSettings.nonWorkingDays
              .contains(selectedDate!.weekday)) {
            selectedDate = AppointmentHelper.addDaysWithTime(selectedDate, 1,
                selectedDate.hour, selectedDate.minute, selectedDate.second);
          } else {
            break;
          }
        }
      }
    } else {
      final double xPosition = widget.view == CalendarView.timelineMonth
          ? 0
          : AppointmentHelper.timeToPosition(widget.calendar, selectedDate!,
              currentViewState._timeIntervalHeight);
      final int rowIndex =
          _getRowOfDate(currentView.visibleDates, selectedDate!);
      final double singleChildWidth =
          _getSingleViewWidthForTimeLineView(currentViewState);
      if ((rowIndex * singleChildWidth) +
              xPosition +
              currentViewState._timeIntervalHeight >=
          currentViewState._scrollController!.offset + widget.width) {
        currentViewState._scrollController!.jumpTo(
            currentViewState._scrollController!.offset +
                currentViewState._timeIntervalHeight);
      }
      if (widget.view == CalendarView.timelineDay &&
          selectedDate
                  .add(widget.calendar.timeSlotViewSettings.timeInterval)
                  .day !=
              currentView
                  .visibleDates[currentView.visibleDates.length - 1].day) {
        _moveToNextViewWithAnimation();
      }

      if ((rowIndex * singleChildWidth) +
              xPosition +
              currentViewState._timeIntervalHeight ==
          currentViewState._scrollController!.position.maxScrollExtent +
              currentViewState._scrollController!.position.viewportDimension) {
        _moveToNextViewWithAnimation();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _moveToSelectedTimeSlot();
        });
      }

      /// For timeline month view each column represents a single day, and for
      /// other timeline views each column represents a given time interval,
      /// hence to update the selected date for timeline month we must add a day
      /// and for other timeline views we must add the given time interval.
      if (widget.view == CalendarView.timelineMonth) {
        selectedDate = AppointmentHelper.addDaysWithTime(selectedDate, 1,
            selectedDate.hour, selectedDate.minute, selectedDate.second);
      } else {
        selectedDate =
            selectedDate.add(widget.calendar.timeSlotViewSettings.timeInterval);
      }
      if (widget.view == CalendarView.timelineWorkWeek) {
        for (int i = 0;
            i <
                DateTime.daysPerWeek -
                    widget.calendar.timeSlotViewSettings.nonWorkingDays.length;
            i++) {
          if (widget.calendar.timeSlotViewSettings.nonWorkingDays
              .contains(selectedDate!.weekday)) {
            selectedDate = AppointmentHelper.addDaysWithTime(selectedDate, 1,
                selectedDate.hour, selectedDate.minute, selectedDate.second);
          } else {
            break;
          }
        }
      }
    }

    return selectedDate!;
  }

  DateTime _updateSelectedDateForLeftArrow(_CalendarView currentView,
      _CalendarViewState currentViewState, DateTime? selectedDate) {
    if (!CalendarViewHelper.isTimelineView(widget.view)) {
      if (isSameDate(currentViewState.widget.visibleDates[0], selectedDate)) {
        _moveToPreviousViewWithAnimation();
      }

      selectedDate = AppointmentHelper.addDaysWithTime(selectedDate!, -1,
          selectedDate.hour, selectedDate.minute, selectedDate.second);

      /// Move to previous view when the selected date as previous month date.
      if (widget.view == CalendarView.month &&
          !CalendarViewHelper.isCurrentMonthDate(
              widget.calendar.monthViewSettings.numberOfWeeksInView,
              widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
              currentView
                  .visibleDates[currentView.visibleDates.length ~/ 2].month,
              selectedDate)) {
        _moveToPreviousViewWithAnimation();
      } else if (widget.view == CalendarView.workWeek) {
        for (int i = 0;
            i <
                DateTime.daysPerWeek -
                    widget.calendar.timeSlotViewSettings.nonWorkingDays.length;
            i++) {
          if (widget.calendar.timeSlotViewSettings.nonWorkingDays
              .contains(selectedDate!.weekday)) {
            selectedDate = AppointmentHelper.addDaysWithTime(selectedDate, -1,
                selectedDate.hour, selectedDate.minute, selectedDate.second);
          } else {
            break;
          }
        }
      }
    } else {
      final double xPosition = widget.view == CalendarView.timelineMonth
          ? 0
          : AppointmentHelper.timeToPosition(widget.calendar, selectedDate!,
              currentViewState._timeIntervalHeight);
      final int rowIndex =
          _getRowOfDate(currentView.visibleDates, selectedDate!);
      final double singleChildWidth =
          _getSingleViewWidthForTimeLineView(currentViewState);

      if ((rowIndex * singleChildWidth) + xPosition == 0) {
        _moveToPreviousViewWithAnimation(isScrollToEnd: true);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _moveToSelectedTimeSlot();
        });
      }

      if ((rowIndex * singleChildWidth) + xPosition <=
          currentViewState._scrollController!.offset) {
        currentViewState._scrollController!.jumpTo(
            currentViewState._scrollController!.offset -
                currentViewState._timeIntervalHeight);
      }

      /// For timeline month view each column represents a single day, and for
      /// other timeline views each column represents a given time interval,
      /// hence to update the selected date for timeline month we must subtract
      /// a day and for other timeline views we must subtract the given time
      /// interval.
      if (widget.view == CalendarView.timelineMonth) {
        selectedDate = AppointmentHelper.addDaysWithTime(selectedDate, -1,
            selectedDate.hour, selectedDate.minute, selectedDate.second);
      } else {
        selectedDate = selectedDate
            .subtract(widget.calendar.timeSlotViewSettings.timeInterval);
      }
      if (widget.view == CalendarView.timelineWorkWeek) {
        for (int i = 0;
            i <
                DateTime.daysPerWeek -
                    widget.calendar.timeSlotViewSettings.nonWorkingDays.length;
            i++) {
          if (widget.calendar.timeSlotViewSettings.nonWorkingDays
              .contains(selectedDate!.weekday)) {
            selectedDate = AppointmentHelper.addDaysWithTime(selectedDate, -1,
                selectedDate.hour, selectedDate.minute, selectedDate.second);
          } else {
            break;
          }
        }
      }
    }

    return selectedDate!;
  }

  DateTime? _updateSelectedDateForUpArrow(
      _CalendarView currentView,
      _CalendarViewState currentViewState,
      DateTime? selectedDate,
      DateTime? appointmentSelectedDate) {
    if (widget.view == CalendarView.month) {
      final int rowIndex =
          _getRowOfDate(currentView.visibleDates, selectedDate!);
      if (rowIndex == 0) {
        return selectedDate;
      }
      selectedDate = AppointmentHelper.addDaysWithTime(
          selectedDate,
          -DateTime.daysPerWeek,
          selectedDate.hour,
          selectedDate.minute,
          selectedDate.second);

      /// Move to month start date when the new selected date as
      /// previous month date.
      if (!CalendarViewHelper.isCurrentMonthDate(
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
          currentView.visibleDates[currentView.visibleDates.length ~/ 2].month,
          selectedDate)) {
        selectedDate = AppointmentHelper.getMonthStartDate(
            currentViewState._selectionPainter!.selectedDate ??
                appointmentSelectedDate!);

        if (CalendarViewHelper.isDateInDateCollection(
            currentView.blackoutDates, selectedDate)) {
          do {
            selectedDate = AppointmentHelper.addDaysWithTime(selectedDate!, 1,
                selectedDate.hour, selectedDate.minute, selectedDate.second);
          } while (CalendarViewHelper.isDateInDateCollection(
              currentView.blackoutDates, selectedDate));
        }
      }

      return selectedDate;
    } else if (!CalendarViewHelper.isTimelineView(widget.view)) {
      final double yPosition = AppointmentHelper.timeToPosition(
          widget.calendar, selectedDate!, currentViewState._timeIntervalHeight);
      if (yPosition < 1) {
        return selectedDate;
      }
      if (yPosition - 1 <= currentViewState._scrollController!.offset) {
        currentViewState._scrollController!
            .jumpTo(yPosition - currentViewState._timeIntervalHeight);
      }
      return selectedDate
          .subtract(widget.calendar.timeSlotViewSettings.timeInterval);
    } else if (CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view)) {
      final double resourceItemHeight =
          CalendarViewHelper.getResourceItemHeight(
              widget.calendar.resourceViewSettings.size,
              widget.height,
              widget.calendar.resourceViewSettings,
              widget.calendar.dataSource!.resources!.length);

      currentViewState._selectedResourceIndex -= 1;

      if (currentViewState._selectedResourceIndex == -1) {
        currentViewState._selectedResourceIndex = 0;
        return selectedDate;
      }

      if (currentViewState._selectedResourceIndex * resourceItemHeight <
          currentViewState._timelineViewVerticalScrollController!.offset) {
        double scrollPosition =
            currentViewState._timelineViewVerticalScrollController!.offset -
                resourceItemHeight;
        scrollPosition = scrollPosition > 0 ? scrollPosition : 0;
        currentViewState._timelineViewVerticalScrollController!
            .jumpTo(scrollPosition);
      }

      return selectedDate;
    }

    return null;
  }

  DateTime? _updateSelectedDateForDownArrow(
      _CalendarView currentView,
      _CalendarViewState currentViewState,
      DateTime? selectedDate,
      DateTime? selectedAppointmentDate) {
    if (widget.view == CalendarView.month) {
      final int rowIndex =
          _getRowOfDate(currentView.visibleDates, selectedDate!);
      if (rowIndex ==
          widget.calendar.monthViewSettings.numberOfWeeksInView - 1) {
        return selectedDate;
      }

      selectedDate = AppointmentHelper.addDaysWithTime(
          selectedDate,
          DateTime.daysPerWeek,
          selectedDate.hour,
          selectedDate.minute,
          selectedDate.second);

      /// Move to month end date when the new selected date as next month date.
      if (!CalendarViewHelper.isCurrentMonthDate(
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
          currentView.visibleDates[currentView.visibleDates.length ~/ 2].month,
          selectedDate)) {
        selectedDate = AppointmentHelper.getMonthEndDate(
            currentViewState._selectionPainter!.selectedDate ??
                selectedAppointmentDate!);

        if (CalendarViewHelper.isDateInDateCollection(
            currentView.blackoutDates, selectedDate)) {
          do {
            selectedDate = AppointmentHelper.addDaysWithTime(selectedDate!, -1,
                selectedDate.hour, selectedDate.minute, selectedDate.second);
          } while (CalendarViewHelper.isDateInDateCollection(
              currentView.blackoutDates, selectedDate));
        }
      }
      return selectedDate;
    } else if (!CalendarViewHelper.isTimelineView(widget.view)) {
      final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
          widget.calendar.viewHeaderHeight, widget.view);
      final double yPosition = AppointmentHelper.timeToPosition(
          widget.calendar, selectedDate!, currentViewState._timeIntervalHeight);

      if (selectedDate
              .add(widget.calendar.timeSlotViewSettings.timeInterval)
              .day !=
          selectedDate.day) {
        return selectedDate;
      }

      if (currentViewState._scrollController!.offset +
                  (widget.height - viewHeaderHeight) <
              currentViewState._scrollController!.position.viewportDimension +
                  currentViewState
                      ._scrollController!.position.maxScrollExtent &&
          yPosition +
                  currentViewState._timeIntervalHeight +
                  widget.calendar.headerHeight +
                  viewHeaderHeight >=
              currentViewState._scrollController!.offset + widget.height &&
          currentViewState._scrollController!.offset +
                  currentViewState
                      ._scrollController!.position.viewportDimension !=
              currentViewState._scrollController!.position.maxScrollExtent) {
        currentViewState._scrollController!.jumpTo(
            currentViewState._scrollController!.offset +
                currentViewState._timeIntervalHeight);
      }
      return selectedDate
          .add(widget.calendar.timeSlotViewSettings.timeInterval);
    } else if (CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view)) {
      final double resourceItemHeight =
          CalendarViewHelper.getResourceItemHeight(
              widget.calendar.resourceViewSettings.size,
              widget.height,
              widget.calendar.resourceViewSettings,
              widget.calendar.dataSource!.resources!.length);
      if (currentViewState._selectedResourceIndex ==
              widget.calendar.dataSource!.resources!.length - 1 ||
          currentViewState._selectedResourceIndex == -1) {
        return selectedDate;
      }

      currentViewState._selectedResourceIndex += 1;

      if (currentViewState._selectedResourceIndex * resourceItemHeight >=
          currentViewState._timelineViewVerticalScrollController!.offset +
              currentViewState._timelineViewVerticalScrollController!.position
                  .viewportDimension) {
        double scrollPosition =
            currentViewState._timelineViewVerticalScrollController!.offset +
                resourceItemHeight;
        scrollPosition = scrollPosition >
                currentViewState._timelineViewVerticalScrollController!.position
                    .maxScrollExtent
            ? currentViewState
                ._timelineViewVerticalScrollController!.position.maxScrollExtent
            : scrollPosition;
        currentViewState._timelineViewVerticalScrollController!
            .jumpTo(scrollPosition);
      }

      return selectedDate!;
    }

    return null;
  }

  /// Moves the view to the selected time slot.
  void _moveToSelectedTimeSlot() {
    _CalendarViewState currentViewState;
    if (_currentChildIndex == 0) {
      currentViewState = _previousViewKey.currentState!;
    } else if (_currentChildIndex == 1) {
      currentViewState = _currentViewKey.currentState!;
    } else {
      currentViewState = _nextViewKey.currentState!;
    }

    final double scrollPosition =
        currentViewState._getScrollPositionForCurrentDate(
            currentViewState._selectionPainter!.selectedDate!);
    if (scrollPosition == -1 ||
        currentViewState._scrollController!.position.pixels == scrollPosition) {
      return;
    }

    currentViewState._scrollController!.jumpTo(
        currentViewState._scrollController!.position.maxScrollExtent >
                scrollPosition
            ? scrollPosition
            : currentViewState._scrollController!.position.maxScrollExtent);
  }

  DateTime? _updateSelectedDate(
      KeyEvent event,
      _CalendarViewState currentViewState,
      _CalendarView currentView,
      int resourceIndex,
      DateTime? selectedAppointmentDate,
      bool isAllDayAppointment) {
    DateTime? selectedDate = currentViewState._selectionPainter!.selectedDate ??
        selectedAppointmentDate;
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      do {
        selectedDate = _updateSelectedDateForRightArrow(
            currentView, currentViewState, selectedDate);
      } while (!_isSelectedDateEnabled(selectedDate, resourceIndex, true));

      return selectedDate;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      do {
        selectedDate = _updateSelectedDateForLeftArrow(
            currentView, currentViewState, selectedDate);
      } while (!_isSelectedDateEnabled(selectedDate, resourceIndex, true));

      return selectedDate;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      do {
        selectedDate = _updateSelectedDateForUpArrow(currentView,
            currentViewState, selectedDate, selectedAppointmentDate);
        if (resourceIndex != -1 &&
            currentView.regions != null &&
            currentView.regions!.isNotEmpty) {
          resourceIndex -= 1;
        }

        if (widget.controller.view != CalendarView.month &&
            !CalendarViewHelper.isTimelineView(widget.calendar.view)) {
          double yPosition = AppointmentHelper.timeToPosition(widget.calendar,
              selectedDate!, currentViewState._timeIntervalHeight);
          if (yPosition < 1 &&
              !_isSelectedDateEnabled(selectedDate, resourceIndex, true)) {
            yPosition = AppointmentHelper.timeToPosition(
                widget.calendar,
                currentViewState._selectionPainter!.selectedDate!,
                currentViewState._timeIntervalHeight);
            currentViewState._scrollController!.jumpTo(yPosition);
            break;
          }
        }
      } while (!_isSelectedDateEnabled(selectedDate!, resourceIndex, true) &&
          _getRowOfDate(currentView.visibleDates, selectedDate) != 0);
      return selectedDate;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (isAllDayAppointment) {
        return selectedDate;
      }

      do {
        selectedDate = _updateSelectedDateForDownArrow(currentView,
            currentViewState, selectedDate, selectedAppointmentDate);
        if (resourceIndex != -1 &&
            currentView.regions != null &&
            currentView.regions!.isNotEmpty) {
          resourceIndex += 1;
        }

        if (widget.controller.view != CalendarView.month &&
            !CalendarViewHelper.isTimelineView(widget.calendar.view)) {
          if (selectedDate!
                  .add(widget.calendar.timeSlotViewSettings.timeInterval)
                  .day !=
              selectedDate.day) {
            final double yPosition = AppointmentHelper.timeToPosition(
                widget.calendar,
                currentViewState._selectionPainter!.selectedDate!,
                currentViewState._timeIntervalHeight);
            if (yPosition <= currentViewState._scrollController!.offset) {
              currentViewState._scrollController!.jumpTo(yPosition);
            }
            break;
          }
        }
      } while (!_isSelectedDateEnabled(selectedDate!, resourceIndex, true) &&
          _getRowOfDate(currentView.visibleDates, selectedDate) !=
              widget.calendar.monthViewSettings.numberOfWeeksInView - 1);
      return selectedDate;
    }

    return null;
  }

  /// Checks the selected date is enabled or not.
  bool _isSelectedDateEnabled(DateTime date, int resourceIndex,
      [bool isMinMaxDate = false]) {
    final bool isMonthView = widget.view == CalendarView.month ||
        widget.view == CalendarView.timelineMonth;
    final int timeInterval = CalendarViewHelper.getTimeInterval(
        widget.calendar.timeSlotViewSettings);
    if ((isMonthView &&
            !isDateWithInDateRange(
                widget.calendar.minDate, widget.calendar.maxDate, date)) ||
        (!isMonthView &&
            !CalendarViewHelper.isDateTimeWithInDateTimeRange(
                widget.calendar.minDate,
                widget.calendar.maxDate,
                date,
                timeInterval))) {
      return isMinMaxDate;
    }

    if (isMonthView &&
        CalendarViewHelper.isDateInDateCollection(_getBlackoutDates(), date)) {
      return false;
    } else if (!isMonthView) {
      final List<CalendarTimeRegion> regions = _getTimeRegions();

      for (int i = 0; i < regions.length; i++) {
        final CalendarTimeRegion region = regions[i];
        if (region.enablePointerInteraction ||
            (region.actualStartTime.isAfter(date) &&
                !CalendarViewHelper.isSameTimeSlot(
                    region.actualStartTime, date)) ||
            region.actualEndTime.isBefore(date) ||
            CalendarViewHelper.isSameTimeSlot(region.actualEndTime, date)) {
          continue;
        }

        /// Condition added ensure that the region is disabled only on the
        /// specified resource slot, for other resources it must be enabled.
        if (resourceIndex != -1 &&
            region.resourceIds != null &&
            region.resourceIds!.isNotEmpty &&
            !region.resourceIds!
                .contains(widget.resourceCollection![resourceIndex].id)) {
          continue;
        }

        return false;
      }
    }

    return true;
  }

  /// Method to handle the page up/down key for timeslot views in calendar.
  KeyEventResult _updatePageUpAndDown(KeyEvent event,
      _CalendarViewState currentViewState, bool isResourceEnabled) {
    if (widget.controller.view != CalendarView.day &&
        widget.controller.view != CalendarView.week &&
        widget.controller.view != CalendarView.workWeek &&
        !isResourceEnabled) {
      return KeyEventResult.ignored;
    }

    final bool isDayView = CalendarViewHelper.isDayView(
        widget.controller.view!,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    final ScrollController scrollController = isResourceEnabled
        ? widget.resourcePanelScrollController!
        : currentViewState._scrollController!;
    final TargetPlatform platform = Theme.of(context).platform;

    double difference = 0;
    final double scrollViewHeight = scrollController.position.maxScrollExtent +
        scrollController.position.viewportDimension;
    double divideValue = 0.25;
    if (scrollController.position.pixels > scrollViewHeight / 2) {
      divideValue = 0.5;
    }
    if (event.logicalKey == LogicalKeyboardKey.pageUp ||
        (platform == TargetPlatform.windows &&
            event.logicalKey.keyId == 0x10700000021)) {
      if (scrollController.position.pixels == 0) {
        return KeyEventResult.ignored;
      }
      difference = scrollController.position.pixels * divideValue;
      scrollController.jumpTo(difference);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.pageDown ||
        (platform == TargetPlatform.windows &&
            event.logicalKey.keyId == 0x10700000022)) {
      double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
          widget.calendar.viewHeaderHeight, widget.controller.view!);
      double allDayHeight = 0;

      if (isDayView) {
        allDayHeight = _kAllDayLayoutHeight;
        viewHeaderHeight = 0;
      } else {
        allDayHeight = allDayHeight > _kAllDayLayoutHeight
            ? _kAllDayLayoutHeight
            : allDayHeight;
      }

      final double timeRulerSize = CalendarViewHelper.getTimeLabelWidth(
          widget.calendar.timeSlotViewSettings.timeRulerSize,
          widget.controller.view!);

      final double viewPortHeight = isResourceEnabled
          ? widget.height - viewHeaderHeight - timeRulerSize
          : widget.height - allDayHeight - viewHeaderHeight;

      final double viewPortEndPosition =
          scrollController.position.pixels + viewPortHeight;
      if (viewPortEndPosition == scrollViewHeight) {
        return KeyEventResult.ignored;
      }
      difference =
          (scrollViewHeight - scrollController.position.pixels) * divideValue;
      difference += scrollController.position.pixels;
      if (difference + viewPortHeight >= scrollViewHeight) {
        difference = scrollViewHeight - viewPortHeight;
      }
      scrollController.jumpTo(difference);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Updates the appointment selection based on keyboard navigation in calendar
  KeyEventResult _updateAppointmentSelection(
      KeyEvent event,
      _CalendarViewState currentVisibleViewState,
      bool isResourceEnabled,
      AppointmentView? currentSelectedAppointment,
      AppointmentView? currentAllDayAppointment) {
    if (widget.controller.view == CalendarView.schedule) {
      return KeyEventResult.ignored;
    }

    AppointmentView? selectedAppointment;
    bool isAllDay = currentAllDayAppointment != null;
    final List<AppointmentView> appointmentCollection = currentVisibleViewState
        ._appointmentLayout
        .getAppointmentViewCollection();
    final List<AppointmentView> allDayAppointmentCollection =
        _updateCalendarStateDetails.allDayAppointmentViewCollection;
    final List<AppointmentView> tempAppColl =
        isAllDay ? allDayAppointmentCollection : appointmentCollection;
    if (HardwareKeyboard.instance.isShiftPressed) {
      if (event.logicalKey == LogicalKeyboardKey.tab) {
        if (currentAllDayAppointment != null ||
            currentSelectedAppointment != null) {
          int index = tempAppColl.indexOf(isAllDay
              ? currentAllDayAppointment
              : currentSelectedAppointment!);
          index -= 1;
          if (tempAppColl.length > index && !index.isNegative) {
            selectedAppointment = tempAppColl[index].appointment != null
                ? tempAppColl[index]
                : null;
          }
        }

        if (currentSelectedAppointment != null && selectedAppointment == null) {
          isAllDay = allDayAppointmentCollection.isNotEmpty;
          selectedAppointment = isAllDay
              ? allDayAppointmentCollection[
                  allDayAppointmentCollection.length - 1]
              : null;
        } else if (currentSelectedAppointment == null &&
            currentAllDayAppointment == null &&
            selectedAppointment == null) {
          if (currentVisibleViewState._selectionPainter!.selectedDate != null &&
              appointmentCollection.isNotEmpty) {
            for (int i = 0; i < appointmentCollection.length; i++) {
              if (AppointmentHelper.getDifference(
                      currentVisibleViewState._selectionPainter!.selectedDate!,
                      appointmentCollection[i].appointment!.actualStartTime)
                  .isNegative) {
                continue;
              }

              if (i != 0) {
                selectedAppointment = appointmentCollection[i - 1];
              }
              break;
            }
          } else {
            selectedAppointment = appointmentCollection.isNotEmpty
                ? appointmentCollection[appointmentCollection.length - 1]
                : null;
          }
        }

        return _updateAppointmentSelectionOnView(
            selectedAppointment,
            currentVisibleViewState,
            isAllDay,
            isResourceEnabled,
            !HardwareKeyboard.instance.isShiftPressed);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.tab) {
      if (currentAllDayAppointment != null ||
          currentSelectedAppointment != null) {
        int index = tempAppColl.indexOf(
            isAllDay ? currentAllDayAppointment : currentSelectedAppointment!);
        index += 1;
        if (tempAppColl.length > index) {
          selectedAppointment = tempAppColl[index].appointment != null
              ? tempAppColl[index]
              : null;
        }
      }

      if (currentAllDayAppointment != null && selectedAppointment == null) {
        isAllDay = false;
        selectedAppointment = appointmentCollection[0];
      } else if (currentAllDayAppointment == null &&
          currentSelectedAppointment == null) {
        if (currentVisibleViewState._selectionPainter!.selectedDate != null &&
            appointmentCollection.isNotEmpty) {
          for (int i = 0; i < appointmentCollection.length; i++) {
            if (AppointmentHelper.getDifference(
                    currentVisibleViewState._selectionPainter!.selectedDate!,
                    appointmentCollection[i].appointment!.actualStartTime)
                .isNegative) {
              continue;
            }

            selectedAppointment = appointmentCollection[i];
            break;
          }
        } else {
          isAllDay = allDayAppointmentCollection.isNotEmpty;
          selectedAppointment = isAllDay
              ? allDayAppointmentCollection[0]
              : appointmentCollection.isNotEmpty
                  ? appointmentCollection[0]
                  : null;
        }
      }

      return _updateAppointmentSelectionOnView(
          selectedAppointment,
          currentVisibleViewState,
          isAllDay,
          isResourceEnabled,
          !HardwareKeyboard.instance.isShiftPressed);
    }

    return KeyEventResult.ignored;
  }

  /// Updates the selection for appointment view based on keyboard navigation
  /// in Calendar.
  KeyEventResult _updateAppointmentSelectionOnView(
      AppointmentView? selectedAppointment,
      _CalendarViewState currentVisibleViewState,
      bool isAllDay,
      bool isResourceEnabled,
      bool isForward) {
    final DateTime visibleStartDate = AppointmentHelper.convertToStartTime(
        currentVisibleViewState.widget.visibleDates[0]);
    final DateTime visibleEndDate = AppointmentHelper.convertToEndTime(
        currentVisibleViewState.widget.visibleDates[
            currentVisibleViewState.widget.visibleDates.length - 1]);

    final bool isDayView = CalendarViewHelper.isDayView(
        widget.controller.view!,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);

    if (isAllDay && selectedAppointment != null) {
      currentVisibleViewState._updateAllDaySelection(selectedAppointment, null);
      currentVisibleViewState._selectionPainter!.appointmentView = null;
      currentVisibleViewState._selectionPainter!.selectedDate = null;
      currentVisibleViewState._selectionNotifier.value =
          !currentVisibleViewState._selectionNotifier.value;
      _updateCalendarStateDetails.selectedDate = null;
      widget.updateCalendarState(_updateCalendarStateDetails);
      return KeyEventResult.handled;
    }

    if (selectedAppointment != null &&
        AppointmentHelper.isAppointmentWithinVisibleDateRange(
            selectedAppointment.appointment!,
            visibleStartDate,
            visibleEndDate)) {
      currentVisibleViewState._allDaySelectionNotifier.value = null;
      currentVisibleViewState._selectionPainter!.appointmentView =
          selectedAppointment;
      currentVisibleViewState._selectionPainter!.selectedDate = null;
      currentVisibleViewState._selectionNotifier.value =
          !currentVisibleViewState._selectionNotifier.value;

      if (widget.controller.view != CalendarView.month) {
        late double offset;
        late double viewPortSize;
        final double scrollViewHeight = currentVisibleViewState
                ._scrollController!.position.maxScrollExtent +
            currentVisibleViewState
                ._scrollController!.position.viewportDimension;
        final double resourceViewSize =
            isResourceEnabled ? widget.calendar.resourceViewSettings.size : 0;
        final bool isTimeline =
            CalendarViewHelper.isTimelineView(widget.controller.view!);
        double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.controller.view!);

        if (isTimeline) {
          viewPortSize = widget.width - resourceViewSize;
          offset = selectedAppointment.appointmentRect!.left;
        } else {
          double allDayHeight = 0;

          if (isDayView) {
            allDayHeight = _kAllDayLayoutHeight;
            viewHeaderHeight = 0;
          } else {
            allDayHeight = allDayHeight > _kAllDayLayoutHeight
                ? _kAllDayLayoutHeight
                : allDayHeight;
          }
          viewPortSize = widget.height - allDayHeight - viewHeaderHeight;
          offset = selectedAppointment.appointmentRect!.top;
        }

        _updateScrollViewToAppointment(
            offset,
            currentVisibleViewState._scrollController!,
            viewPortSize,
            scrollViewHeight);

        if (isResourceEnabled) {
          final double resourcePanelHeight = widget
                  .resourcePanelScrollController!.position.viewportDimension +
              widget.resourcePanelScrollController!.position.maxScrollExtent;
          final double timeRulerSize = CalendarViewHelper.getTimeLabelWidth(
                  widget.calendar.timeSlotViewSettings.timeRulerSize,
                  widget.controller.view!),
              viewPortSize = widget.height - viewHeaderHeight - timeRulerSize;
          _updateScrollViewToAppointment(
              selectedAppointment.appointmentRect!.top,
              widget.resourcePanelScrollController!,
              viewPortSize,
              resourcePanelHeight);
        }
      } else if (widget.controller.view == CalendarView.month) {
        widget.agendaSelectedDate.value = null;
      }

      _updateCalendarStateDetails.selectedDate = null;
      widget.updateCalendarState(_updateCalendarStateDetails);
      return KeyEventResult.handled;
    } else {
      currentVisibleViewState._allDaySelectionNotifier.value = null;
      currentVisibleViewState._selectionPainter!.appointmentView = null;
      currentVisibleViewState._selectionPainter!.selectedDate = null;
      currentVisibleViewState._selectionNotifier.value =
          !currentVisibleViewState._selectionNotifier.value;
      _updateCalendarStateDetails.selectedDate = null;
      widget.updateCalendarState(_updateCalendarStateDetails);
      isForward
          ? FocusScope.of(context).nextFocus()
          : FocusScope.of(context).previousFocus();
      return KeyEventResult.handled;
    }
  }

  /// Moves the scroll panel to the selected appointments position, if the
  /// selected appointment doesn't falls on the view port.
  void _updateScrollViewToAppointment(
      double offset,
      ScrollController scrollController,
      double viewPortSize,
      double panelHeight) {
    if (offset < scrollController.position.pixels ||
        offset > (scrollController.position.pixels + viewPortSize)) {
      if (offset + viewPortSize > panelHeight) {
        offset = panelHeight - viewPortSize;
      }
      scrollController.jumpTo(offset);
    }
  }

  KeyEventResult _onKeyDown(FocusNode node, KeyEvent event) {
    KeyEventResult result = KeyEventResult.ignored;
    if (event.runtimeType != KeyDownEvent) {
      return result;
    }

    widget.removePicker();

    if (HardwareKeyboard.instance.isControlPressed &&
        widget.view != CalendarView.schedule) {
      final bool canMoveToNextView = DateTimeHelper.canMoveToNextView(
          widget.view,
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          widget.calendar.minDate,
          widget.calendar.maxDate,
          _currentViewVisibleDates,
          widget.calendar.timeSlotViewSettings.nonWorkingDays,
          widget.isRTL);
      final bool canMoveToPreviousView = DateTimeHelper.canMoveToPreviousView(
          widget.view,
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          widget.calendar.minDate,
          widget.calendar.maxDate,
          _currentViewVisibleDates,
          widget.calendar.timeSlotViewSettings.nonWorkingDays,
          widget.isRTL);
      if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          canMoveToNextView) {
        widget.isRTL
            ? _moveToPreviousViewWithAnimation()
            : _moveToNextViewWithAnimation();
        result = KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
          canMoveToPreviousView) {
        widget.isRTL
            ? _moveToNextViewWithAnimation()
            : _moveToPreviousViewWithAnimation();
        result = KeyEventResult.handled;
      }
      result = KeyEventResult.ignored;
    }

    CalendarViewHelper.handleViewSwitchKeyBoardEvent(
        event, widget.controller, widget.calendar.allowedViews);

    _CalendarViewState currentVisibleViewState;
    _CalendarView currentVisibleView;
    final bool isResourcesEnabled = CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view);
    if (_currentChildIndex == 0) {
      currentVisibleViewState = _previousViewKey.currentState!;
      currentVisibleView = _previousView;
    } else if (_currentChildIndex == 1) {
      currentVisibleViewState = _currentViewKey.currentState!;
      currentVisibleView = _currentView;
    } else {
      currentVisibleViewState = _nextViewKey.currentState!;
      currentVisibleView = _nextView;
    }

    result = _updatePageUpAndDown(
        event, currentVisibleViewState, isResourcesEnabled);

    AppointmentView? currentSelectedAppointment =
        currentVisibleViewState._selectionPainter!.appointmentView;
    AppointmentView? currentAllDayAppointment =
        currentVisibleViewState._allDaySelectionNotifier.value?.appointmentView;

    result = _updateAppointmentSelection(
        event,
        currentVisibleViewState,
        isResourcesEnabled,
        currentSelectedAppointment,
        currentAllDayAppointment);

    currentSelectedAppointment =
        currentVisibleViewState._selectionPainter!.appointmentView;
    currentAllDayAppointment =
        currentVisibleViewState._allDaySelectionNotifier.value?.appointmentView;

    if (event.logicalKey == LogicalKeyboardKey.enter &&
        CalendarViewHelper.shouldRaiseCalendarTapCallback(
            widget.calendar.onTap)) {
      final AppointmentView? selectedAppointment = currentVisibleViewState
              ._allDaySelectionNotifier.value?.appointmentView ??
          currentVisibleViewState._selectionPainter!.appointmentView;
      final List<CalendarAppointment>? selectedAppointments =
          widget.controller.view == CalendarView.month &&
                  selectedAppointment == null
              ? AppointmentHelper.getSelectedDateAppointments(
                  _updateCalendarStateDetails.appointments,
                  widget.calendar.timeZone,
                  _updateCalendarStateDetails.selectedDate)
              : selectedAppointment != null
                  ? <CalendarAppointment>[selectedAppointment.appointment!]
                  : null;
      final CalendarElement tappedElement =
          _updateCalendarStateDetails.selectedDate != null
              ? CalendarElement.calendarCell
              : CalendarElement.appointment;

      CalendarViewHelper.raiseCalendarTapCallback(
          widget.calendar,
          tappedElement == CalendarElement.appointment
              ? selectedAppointments![0].startTime
              : _updateCalendarStateDetails.selectedDate,
          CalendarViewHelper.getCustomAppointments(
              selectedAppointments, widget.calendar.dataSource),
          tappedElement,
          isResourcesEnabled
              ? widget.calendar.dataSource!
                  .resources![currentVisibleViewState._selectedResourceIndex]
              : null);
    }

    final int previousResourceIndex = isResourcesEnabled
        ? currentVisibleViewState._selectedResourceIndex
        : -1;

    if ((currentVisibleViewState._selectionPainter!.selectedDate != null &&
            isDateWithInDateRange(
                currentVisibleViewState.widget.visibleDates[0],
                currentVisibleViewState.widget.visibleDates[
                    currentVisibleViewState.widget.visibleDates.length - 1],
                currentVisibleViewState._selectionPainter!.selectedDate)) ||
        (currentSelectedAppointment != null ||
            currentAllDayAppointment != null)) {
      final int resourceIndex = isResourcesEnabled
          ? currentVisibleViewState._selectedResourceIndex
          : -1;

      final DateTime? selectedAppointmentDate = currentAllDayAppointment != null
          ? AppointmentHelper.convertToStartTime(
              currentAllDayAppointment.appointment!.actualStartTime)
          : currentSelectedAppointment?.appointment!.actualStartTime;

      final bool isAllDayAppointment = currentAllDayAppointment != null;

      final DateTime? selectedDate = _updateSelectedDate(
          event,
          currentVisibleViewState,
          currentVisibleView,
          resourceIndex,
          selectedAppointmentDate,
          isAllDayAppointment);

      if (selectedDate == null) {
        result = KeyEventResult.ignored;
        return result;
      }

      if (!_isSelectedDateEnabled(selectedDate, resourceIndex)) {
        currentVisibleViewState._selectedResourceIndex = previousResourceIndex;
        return KeyEventResult.ignored;
      }

      if (widget.view == CalendarView.month) {
        widget.agendaSelectedDate.value = selectedDate;
      }

      _updateCalendarStateDetails.selectedDate = selectedDate;
      if (widget.calendar.onSelectionChanged != null &&
          (!CalendarViewHelper.isSameTimeSlot(
                  currentVisibleViewState._selectionPainter!.selectedDate,
                  selectedDate) ||
              (isResourcesEnabled &&
                  currentVisibleViewState
                          ._selectionPainter!.selectedResourceIndex !=
                      currentVisibleViewState._selectedResourceIndex))) {
        CalendarViewHelper.raiseCalendarSelectionChangedCallback(
            widget.calendar,
            selectedDate,
            isResourcesEnabled
                ? widget.resourceCollection![
                    currentVisibleViewState._selectedResourceIndex]
                : null);
      }
      currentVisibleViewState._selectionPainter!.selectedDate = selectedDate;
      currentVisibleViewState._updateAllDaySelection(null, null);
      currentVisibleViewState._selectionPainter!.appointmentView = null;
      currentVisibleViewState._selectionPainter!.selectedResourceIndex =
          currentVisibleViewState._selectedResourceIndex;
      currentVisibleViewState._selectionNotifier.value =
          !currentVisibleViewState._selectionNotifier.value;

      widget.updateCalendarState(_updateCalendarStateDetails);
      result = KeyEventResult.handled;
    }

    return result;
  }

  void _positionTimelineView({bool isScrolledToEnd = true}) {
    final _CalendarViewState previousViewState = _previousViewKey.currentState!;
    final _CalendarViewState currentViewState = _currentViewKey.currentState!;
    final _CalendarViewState nextViewState = _nextViewKey.currentState!;
    if (widget.isRTL) {
      if (_currentChildIndex == 0) {
        currentViewState._scrollController!.jumpTo(isScrolledToEnd
            ? currentViewState._scrollController!.position.maxScrollExtent
            : 0);
        nextViewState._scrollController!.jumpTo(0);
      } else if (_currentChildIndex == 1) {
        nextViewState._scrollController!.jumpTo(isScrolledToEnd
            ? nextViewState._scrollController!.position.maxScrollExtent
            : 0);
        previousViewState._scrollController!.jumpTo(0);
      } else if (_currentChildIndex == 2) {
        previousViewState._scrollController!.jumpTo(isScrolledToEnd
            ? previousViewState._scrollController!.position.maxScrollExtent
            : 0);
        currentViewState._scrollController!.jumpTo(0);
      }
    } else {
      if (_currentChildIndex == 0) {
        nextViewState._scrollController!.jumpTo(isScrolledToEnd
            ? nextViewState._scrollController!.position.maxScrollExtent
            : 0);
        currentViewState._scrollController!.jumpTo(0);
      } else if (_currentChildIndex == 1) {
        previousViewState._scrollController!.jumpTo(isScrolledToEnd
            ? previousViewState._scrollController!.position.maxScrollExtent
            : 0);
        nextViewState._scrollController!.jumpTo(0);
      } else if (_currentChildIndex == 2) {
        currentViewState._scrollController!.jumpTo(isScrolledToEnd
            ? currentViewState._scrollController!.position.maxScrollExtent
            : 0);
        previousViewState._scrollController!.jumpTo(0);
      }
    }
  }

  void _onHorizontalStart(
      DragStartDetails dragStartDetails,
      bool isResourceEnabled,
      bool isTimelineView,
      double viewHeaderHeight,
      double timeLabelWidth,
      bool isNeedDragAndDrop) {
    final _CalendarViewState currentState = _getCurrentViewByVisibleDates()!;
    if (currentState._hoveringAppointmentView != null &&
        currentState._hoveringAppointmentView!.appointment != null &&
        !widget.isMobilePlatform &&
        isNeedDragAndDrop) {
      _handleAppointmentDragStart(
          currentState._hoveringAppointmentView!.clone(),
          isTimelineView,
          Offset(dragStartDetails.localPosition.dx - widget.width,
              dragStartDetails.localPosition.dy),
          isResourceEnabled,
          viewHeaderHeight,
          timeLabelWidth);
      return;
    }
    switch (widget.calendar.viewNavigationMode) {
      case ViewNavigationMode.none:
        return;
      case ViewNavigationMode.snap:
        widget.removePicker();
        if (widget.calendar.monthViewSettings.navigationDirection ==
                MonthNavigationDirection.horizontal ||
            widget.view != CalendarView.month) {
          _scrollStartPosition = dragStartDetails.globalPosition.dx;
        }

        // Handled for time line view, to move the previous and
        // next view to it's start and end position accordingly
        if (CalendarViewHelper.isTimelineView(widget.view)) {
          _positionTimelineView();
        }
    }
  }

  void _onHorizontalUpdate(DragUpdateDetails dragUpdateDetails,
      [bool isResourceEnabled = false,
      bool isMonthView = false,
      bool isTimelineView = false,
      double viewHeaderHeight = 0,
      double timeLabelWidth = 0,
      double resourceItemHeight = 0,
      double weekNumberPanelWidth = 0,
      bool isNeedDragAndDrop = false]) {
    if (_dragDetails.value.appointmentView != null &&
        !widget.isMobilePlatform &&
        isNeedDragAndDrop) {
      _handleLongPressMove(
          Offset(dragUpdateDetails.localPosition.dx - widget.width,
              dragUpdateDetails.localPosition.dy),
          isTimelineView,
          isResourceEnabled,
          isMonthView,
          viewHeaderHeight,
          timeLabelWidth,
          resourceItemHeight,
          weekNumberPanelWidth);
      return;
    }
    switch (widget.calendar.viewNavigationMode) {
      case ViewNavigationMode.none:
        return;
      case ViewNavigationMode.snap:
        widget.removePicker();
        if (widget.calendar.monthViewSettings.navigationDirection ==
                MonthNavigationDirection.horizontal ||
            widget.view != CalendarView.month) {
          final double difference =
              dragUpdateDetails.globalPosition.dx - _scrollStartPosition;
          if (difference < 0 &&
              !DateTimeHelper.canMoveToNextView(
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
              !DateTimeHelper.canMoveToPreviousView(
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
  }

  void _onHorizontalEnd(DragEndDetails dragEndDetails,
      [bool isResourceEnabled = false,
      bool isTimelineView = false,
      bool isMonthView = false,
      double viewHeaderHeight = 0,
      double timeLabelWidth = 0,
      double weekNumberPanelWidth = 0,
      bool isNeedDragAndDrop = false]) {
    if (_dragDetails.value.appointmentView != null &&
        !widget.isMobilePlatform &&
        isNeedDragAndDrop) {
      _handleLongPressEnd(
          _dragDetails.value.position.value! - _dragDifferenceOffset!,
          isTimelineView,
          isResourceEnabled,
          isMonthView,
          viewHeaderHeight,
          timeLabelWidth,
          weekNumberPanelWidth);
      return;
    }
    switch (widget.calendar.viewNavigationMode) {
      case ViewNavigationMode.none:
        return;
      case ViewNavigationMode.snap:
        widget.removePicker();
        if (widget.calendar.monthViewSettings.navigationDirection ==
                MonthNavigationDirection.horizontal ||
            widget.view != CalendarView.month) {
          // condition to check and update the right to left swiping
          if (-_position >= widget.width / 2) {
            _tween.begin = _position;
            _tween.end = -widget.width;

            // Resets the controller to forward it again,
            // the animation will forward only from the dismissed state
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
            if (!DateTimeHelper.canMoveToNextView(
                widget.view,
                widget.calendar.monthViewSettings.numberOfWeeksInView,
                widget.calendar.minDate,
                widget.calendar.maxDate,
                _currentViewVisibleDates,
                widget.calendar.timeSlotViewSettings.nonWorkingDays,
                widget.isRTL)) {
              _position = 0;
              setState(() {
                /* Completes the swiping and rearrange the children position
                in the custom scroll view */
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

            _animationController
                .forward()
                .then<dynamic>((dynamic value) => _updatePreviousView());

            /// updates the current view visible dates when the view swiped in
            /// left to right direction
            _updateCurrentViewVisibleDates();
          }
          // fling the view from left to right
          else if (dragEndDetails.velocity.pixelsPerSecond.dx > widget.width) {
            if (!DateTimeHelper.canMoveToPreviousView(
                widget.view,
                widget.calendar.monthViewSettings.numberOfWeeksInView,
                widget.calendar.minDate,
                widget.calendar.maxDate,
                _currentViewVisibleDates,
                widget.calendar.timeSlotViewSettings.nonWorkingDays,
                widget.isRTL)) {
              _position = 0;
              setState(() {
                /* Completes the swiping and rearrange the children position
            in the custom scroll view */
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

            _animationController.forward();
          }
        }
    }
  }

  void _onVerticalStart(
      DragStartDetails dragStartDetails,
      bool isResourceEnabled,
      bool isTimelineView,
      double viewHeaderHeight,
      double timeLabelWidth,
      bool isNeedDragAndDrop) {
    final _CalendarViewState currentState = _getCurrentViewByVisibleDates()!;
    if (currentState._hoveringAppointmentView != null &&
        currentState._hoveringAppointmentView!.appointment != null &&
        !widget.isMobilePlatform &&
        isNeedDragAndDrop) {
      _handleAppointmentDragStart(
          currentState._hoveringAppointmentView!.clone(),
          isTimelineView,
          Offset(dragStartDetails.localPosition.dx,
              dragStartDetails.localPosition.dy - widget.height),
          isResourceEnabled,
          viewHeaderHeight,
          timeLabelWidth);
      return;
    }
    switch (widget.calendar.viewNavigationMode) {
      case ViewNavigationMode.none:
        return;
      case ViewNavigationMode.snap:
        widget.removePicker();
        if (widget.calendar.monthViewSettings.navigationDirection ==
                MonthNavigationDirection.vertical &&
            !CalendarViewHelper.isTimelineView(widget.view)) {
          _scrollStartPosition = dragStartDetails.globalPosition.dy;
        }
    }
  }

  void _onVerticalUpdate(DragUpdateDetails dragUpdateDetails,
      [bool isResourceEnabled = false,
      bool isMonthView = false,
      bool isTimelineView = false,
      double viewHeaderHeight = 0,
      double timeLabelWidth = 0,
      double resourceItemHeight = 0,
      double weekNumberPanelWidth = 0,
      bool isNeedDragAndDrop = false]) {
    if (_dragDetails.value.appointmentView != null &&
        !widget.isMobilePlatform &&
        isNeedDragAndDrop) {
      _handleLongPressMove(
          Offset(dragUpdateDetails.localPosition.dx,
              dragUpdateDetails.localPosition.dy - widget.height),
          isTimelineView,
          isResourceEnabled,
          isMonthView,
          viewHeaderHeight,
          timeLabelWidth,
          resourceItemHeight,
          weekNumberPanelWidth);
      return;
    }
    switch (widget.calendar.viewNavigationMode) {
      case ViewNavigationMode.none:
        return;
      case ViewNavigationMode.snap:
        widget.removePicker();
        if (widget.calendar.monthViewSettings.navigationDirection ==
                MonthNavigationDirection.vertical &&
            !CalendarViewHelper.isTimelineView(widget.view)) {
          final double difference =
              dragUpdateDetails.globalPosition.dy - _scrollStartPosition;
          if (difference < 0 &&
              !DateTimeHelper.canMoveToNextView(
                  widget.view,
                  widget.calendar.monthViewSettings.numberOfWeeksInView,
                  widget.calendar.minDate,
                  widget.calendar.maxDate,
                  _currentViewVisibleDates,
                  widget.calendar.timeSlotViewSettings.nonWorkingDays)) {
            _position = 0;
            return;
          } else if (difference > 0 &&
              !DateTimeHelper.canMoveToPreviousView(
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
  }

  void _onVerticalEnd(DragEndDetails dragEndDetails,
      [bool isResourceEnabled = false,
      bool isTimelineView = false,
      bool isMonthView = false,
      double viewHeaderHeight = 0,
      double timeLabelWidth = 0,
      double weekNumberPanelWidth = 0,
      bool isNeedDragAndDrop = false]) {
    if (_dragDetails.value.appointmentView != null &&
        !widget.isMobilePlatform &&
        isNeedDragAndDrop) {
      _handleLongPressEnd(
          _dragDetails.value.position.value! - _dragDifferenceOffset!,
          isTimelineView,
          isResourceEnabled,
          isMonthView,
          viewHeaderHeight,
          timeLabelWidth,
          weekNumberPanelWidth);
      return;
    }
    switch (widget.calendar.viewNavigationMode) {
      case ViewNavigationMode.none:
        return;
      case ViewNavigationMode.snap:
        widget.removePicker();
        if (widget.calendar.monthViewSettings.navigationDirection ==
                MonthNavigationDirection.vertical &&
            !CalendarViewHelper.isTimelineView(widget.view)) {
          // condition to check and update the bottom to top swiping
          if (-_position >= widget.height / 2) {
            _tween.begin = _position;
            _tween.end = -widget.height;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
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
          else if (-dragEndDetails.velocity.pixelsPerSecond.dy >
              widget.height) {
            if (!DateTimeHelper.canMoveToNextView(
                widget.view,
                widget.calendar.monthViewSettings.numberOfWeeksInView,
                widget.calendar.minDate,
                widget.calendar.maxDate,
                _currentViewVisibleDates,
                widget.calendar.timeSlotViewSettings.nonWorkingDays)) {
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

            _animationController
                .forward()
                .then<dynamic>((dynamic value) => _updatePreviousView());

            /// updates the current view visible dates when the view swiped in
            /// top to bottom direction
            _updateCurrentViewVisibleDates();
          }
          // fling the view to top to bottom
          else if (dragEndDetails.velocity.pixelsPerSecond.dy > widget.height) {
            if (!DateTimeHelper.canMoveToPreviousView(
                widget.view,
                widget.calendar.monthViewSettings.numberOfWeeksInView,
                widget.calendar.minDate,
                widget.calendar.maxDate,
                _currentViewVisibleDates,
                widget.calendar.timeSlotViewSettings.nonWorkingDays)) {
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

            _animationController.forward();
          }
        }
    }
  }

  void _clearSelection() {
    widget.getCalendarState(_updateCalendarStateDetails);
    for (int i = 0; i < _children.length; i++) {
      final GlobalKey<_CalendarViewState> viewKey =
          // ignore: avoid_as
          _children[i].key! as GlobalKey<_CalendarViewState>;
      if (viewKey.currentState!._selectionPainter!.selectedDate !=
          _updateCalendarStateDetails.selectedDate) {
        viewKey.currentState!._selectionPainter!.selectedDate =
            _updateCalendarStateDetails.selectedDate;
        viewKey.currentState!._selectionNotifier.value =
            !viewKey.currentState!._selectionNotifier.value;
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
    } else {
      viewKey = _nextViewKey;
    }
    if (viewKey.currentState!._expanderAnimationController?.status ==
        AnimationStatus.completed) {
      viewKey.currentState!._expanderAnimationController?.reset();
    }
    viewKey.currentState!._isExpanded = false;
  }

  /// Method to clear the appointments in the previous/next view
  void _updateAppointmentPainter() {
    for (int i = 0; i < _children.length; i++) {
      final _CalendarView view = _children[i];
      final GlobalKey<_CalendarViewState> viewKey =
          // ignore: avoid_as
          view.key! as GlobalKey<_CalendarViewState>;
      if (widget.view == CalendarView.month &&
          widget.calendar.monthCellBuilder != null) {
        if (view.visibleDates == _currentViewVisibleDates) {
          widget.getCalendarState(_updateCalendarStateDetails);
          if (!CalendarViewHelper.isCollectionEqual(
              viewKey.currentState!._monthView.visibleAppointmentNotifier.value,
              _updateCalendarStateDetails.visibleAppointments)) {
            viewKey.currentState!._monthView.visibleAppointmentNotifier.value =
                _updateCalendarStateDetails.visibleAppointments;
          }
        } else {
          if (!CalendarViewHelper.isEmptyList(viewKey
              .currentState!._monthView.visibleAppointmentNotifier.value)) {
            viewKey.currentState!._monthView.visibleAppointmentNotifier.value =
                null;
          }
        }
      } else {
        final AppointmentLayout appointmentLayout =
            viewKey.currentState!._appointmentLayout;
        if (view.visibleDates == _currentViewVisibleDates) {
          widget.getCalendarState(_updateCalendarStateDetails);
          if (!CalendarViewHelper.isCollectionEqual(
              appointmentLayout.visibleAppointments.value,
              _updateCalendarStateDetails.visibleAppointments)) {
            appointmentLayout.visibleAppointments.value =
                _updateCalendarStateDetails.visibleAppointments;
          }
        } else {
          if (!CalendarViewHelper.isEmptyList(
              appointmentLayout.visibleAppointments.value)) {
            appointmentLayout.visibleAppointments.value = null;
          }
        }
      }
    }
  }
}

@immutable
class _CalendarView extends StatefulWidget {
  const _CalendarView(
      this.calendar,
      this.view,
      this.visibleDates,
      this.width,
      this.height,
      this.agendaSelectedDate,
      this.locale,
      this.calendarTheme,
      this.themeData,
      this.regions,
      this.blackoutDates,
      this.focusNode,
      this.removePicker,
      this.allowViewNavigation,
      this.controller,
      this.resourcePanelScrollController,
      this.resourceCollection,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.minDate,
      this.maxDate,
      this.localizations,
      this.timelineMonthWeekNumberNotifier,
      this.dragDetails,
      this.updateCalendarState,
      this.getCalendarState,
      {Key? key})
      : super(key: key);

  final List<DateTime> visibleDates;
  final List<CalendarTimeRegion>? regions;
  final List<DateTime>? blackoutDates;
  final SfCalendar calendar;
  final CalendarView view;
  final double width;
  final SfCalendarThemeData calendarTheme;
  final ThemeData themeData;
  final double height;
  final String locale;
  final ValueNotifier<DateTime?> agendaSelectedDate,
      timelineMonthWeekNumberNotifier;
  final CalendarController controller;
  final VoidCallback removePicker;
  final UpdateCalendarState updateCalendarState;
  final UpdateCalendarState getCalendarState;
  final bool allowViewNavigation;
  final FocusNode focusNode;
  final ScrollController? resourcePanelScrollController;
  final List<CalendarResource>? resourceCollection;
  final double textScaleFactor;
  final bool isMobilePlatform;
  final DateTime minDate;
  final DateTime maxDate;
  final SfLocalizations localizations;
  final ValueNotifier<_DragPaintDetails> dragDetails;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView>
    with TickerProviderStateMixin {
  // line count is the total time slot lines to be drawn in the view
  // line count per view is for time line view which contains the time slot
  // count for per view
  double? _horizontalLinesCount;

  // all day scroll controller is used to identify the scroll position for draw
  // all day selection.
  ScrollController? _scrollController;
  ScrollController? _timelineViewHeaderScrollController,
      _timelineViewVerticalScrollController,
      _timelineRulerController;

  late AppointmentLayout _appointmentLayout;
  AnimationController? _timelineViewAnimationController;
  Animation<double>? _timelineViewAnimation;
  final Tween<double> _timelineViewTween = Tween<double>(begin: 0.0, end: 0.1);

  //// timeline header is used to implement the sticky view header in horizontal calendar view mode.
  late TimelineViewHeaderView _timelineViewHeader;
  _SelectionPainter? _selectionPainter;
  double _allDayHeight = 0;
  late double _timeIntervalHeight;
  final UpdateCalendarStateDetails _updateCalendarStateDetails =
      UpdateCalendarStateDetails();
  ValueNotifier<SelectionDetails?> _allDaySelectionNotifier =
      ValueNotifier<SelectionDetails?>(null);
  late ValueNotifier<Offset?> _viewHeaderNotifier;
  final ValueNotifier<Offset?> _calendarCellNotifier =
          ValueNotifier<Offset?>(null),
      _allDayNotifier = ValueNotifier<Offset?>(null),
      _appointmentHoverNotifier = ValueNotifier<Offset?>(null);
  final ValueNotifier<bool> _selectionNotifier = ValueNotifier<bool>(false),
      _timelineViewHeaderNotifier = ValueNotifier<bool>(false);
  late bool _isRTL;

  bool _isExpanded = false;
  DateTime? _hoveringDate;
  SystemMouseCursor _mouseCursor = SystemMouseCursors.basic;
  AppointmentView? _hoveringAppointmentView;

  /// The property to hold the resource value associated with the selected
  /// calendar cell.
  int _selectedResourceIndex = -1;
  AnimationController? _animationController;
  Animation<double>? _heightAnimation;
  Animation<double>? _allDayExpanderAnimation;
  AnimationController? _expanderAnimationController;

  /// Store the month widget instance used to update the month view
  /// when the visible appointment updated.
  late MonthViewWidget _monthView;

  /// Used to hold the global key for restrict the new appointment layout
  /// creation.
  /// if set the appointment layout key property as new Global key when create
  /// the appointment layout then each of the time it creates new appointment
  /// layout rather than update the existing appointment layout.
  final GlobalKey _appointmentLayoutKey = GlobalKey();

  Timer? _timer, _autoScrollTimer;
  late ValueNotifier<int> _currentTimeNotifier;

  late ValueNotifier<_ResizingPaintDetails> _resizingDetails;
  double? _maximumResizingPosition;

  @override
  void initState() {
    _resizingDetails = ValueNotifier<_ResizingPaintDetails>(
        _ResizingPaintDetails(position: ValueNotifier<Offset?>(null)));
    _viewHeaderNotifier = ValueNotifier<Offset?>(null)
      ..addListener(_timelineViewHoveringUpdate);
    if (!CalendarViewHelper.isTimelineView(widget.view) &&
        widget.view != CalendarView.month) {
      _animationController = AnimationController(
          duration: const Duration(milliseconds: 200), vsync: this);
      _heightAnimation =
          CurveTween(curve: Curves.easeIn).animate(_animationController!)
            ..addListener(() {
              setState(() {
                /* Animates the all day panel height when
              expanding or collapsing */
              });
            });

      _expanderAnimationController = AnimationController(
          duration: const Duration(milliseconds: 100), vsync: this);
      _allDayExpanderAnimation = CurveTween(curve: Curves.easeIn)
          .animate(_expanderAnimationController!)
        ..addListener(() {
          setState(() {
            /* Animates the all day panel height when
              expanding or collapsing */
          });
        });
    }

    _timeIntervalHeight = _getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        widget.visibleDates.length,
        widget.isMobilePlatform);
    if (widget.view != CalendarView.month) {
      _horizontalLinesCount = CalendarViewHelper.getHorizontalLinesCount(
          widget.calendar.timeSlotViewSettings, widget.view);
      _scrollController = ScrollController()..addListener(_scrollListener);
      if (CalendarViewHelper.isTimelineView(widget.view)) {
        _timelineRulerController = ScrollController()
          ..addListener(_timeRulerListener);
        _timelineViewHeaderScrollController = ScrollController();
        _timelineViewAnimationController = AnimationController(
            duration: const Duration(milliseconds: 300), vsync: this);
        _timelineViewAnimation = _timelineViewTween
            .animate(_timelineViewAnimationController!)
          ..addListener(_scrollAnimationListener);
        _timelineViewVerticalScrollController = ScrollController()
          ..addListener(_updateResourceScroll);
        widget.resourcePanelScrollController
            ?.addListener(_updateResourcePanelScroll);
      }

      _scrollToPosition();
    }

    final DateTime today = DateTime.now();
    _currentTimeNotifier = ValueNotifier<int>(
        (today.day * 24 * 60) + (today.hour * 60) + today.minute);
    _timer = _createTimer();
    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarView oldWidget) {
    final bool isTimelineView = CalendarViewHelper.isTimelineView(widget.view);
    if (widget.view != CalendarView.month) {
      if (!isTimelineView) {
        _updateTimeSlotView(oldWidget);
      }

      _updateHorizontalLineCount(oldWidget);

      _scrollController ??= ScrollController()..addListener(_scrollListener);

      if (isTimelineView) {
        _updateTimelineViews(oldWidget);
      }
    }

    /// Update the scroll position with following scenarios
    /// 1. View changed from month or schedule view.
    /// 2. View changed from timeline view(timeline day, timeline week,
    /// timeline work week) to timeslot view(day, week, work week).
    /// 3. View changed from timeslot view(day, week, work week) to
    /// timeline view(timeline day, timeline week, timeline work week).
    ///
    /// This condition used to restrict the following scenarios
    /// 1. View changed to month view.
    /// 2. View changed with in the day, week, work week
    /// (eg., view changed to week from day).
    /// 3. View changed with in the timeline day, timeline week, timeline
    /// work week(eg., view changed to timeline week from timeline day).
    if ((oldWidget.view == CalendarView.month ||
            oldWidget.view == CalendarView.schedule ||
            (oldWidget.view != widget.view && isTimelineView) ||
            (CalendarViewHelper.isTimelineView(oldWidget.view) &&
                !isTimelineView)) &&
        widget.view != CalendarView.month) {
      _scrollToPosition();
    }

    widget.getCalendarState(_updateCalendarStateDetails);

    /// Method called to update all day height, when the view changed from
    /// day to week views to avoid the blank space at the bottom of the view.
    final bool isCurrentView =
        _updateCalendarStateDetails.currentViewVisibleDates ==
            widget.visibleDates;
    _updateAllDayHeight(isCurrentView);

    _timeIntervalHeight = _getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        widget.visibleDates.length,
        widget.isMobilePlatform);

    /// Clear the all day panel selection when the calendar view changed
    /// Eg., if select the all day panel and switch to month view and again
    /// select the same month cell and move to day view then the view show
    /// calendar cell selection and all day panel selection.
    if (oldWidget.view != widget.view) {
      _allDaySelectionNotifier = ValueNotifier<SelectionDetails?>(null);
      final DateTime today = DateTime.now();
      _currentTimeNotifier = ValueNotifier<int>(
          (today.day * 24 * 60) + (today.hour * 60) + today.minute);
      _timer?.cancel();
      _timer = null;
    }

    if (oldWidget.calendar.showCurrentTimeIndicator !=
        widget.calendar.showCurrentTimeIndicator) {
      _timer?.cancel();
      _timer = _createTimer();
    }

    if ((oldWidget.view != widget.view ||
            oldWidget.width != widget.width ||
            oldWidget.height != widget.height) &&
        _selectionPainter!.appointmentView != null) {
      _selectionPainter!.appointmentView = null;
    }

    /// When view switched from any other view to timeline view, and resource
    /// enabled the selection must render the first resource view.
    if (!CalendarViewHelper.isTimelineView(oldWidget.view) &&
        _updateCalendarStateDetails.selectedDate != null &&
        CalendarViewHelper.isResourceEnabled(
            widget.calendar.dataSource, widget.view) &&
        _selectedResourceIndex == -1) {
      _selectedResourceIndex = 0;
    }

    if (!CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view)) {
      _selectedResourceIndex = -1;
    }

    _timer ??= _createTimer();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _isRTL = CalendarViewHelper.isRTLLayout(context);
    widget.getCalendarState(_updateCalendarStateDetails);
    switch (widget.view) {
      case CalendarView.schedule:
        return Container();
      case CalendarView.month:
        return _getMonthView();
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        return _getDayView();
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
        return _getTimelineView();
    }
  }

  @override
  void dispose() {
    _viewHeaderNotifier.removeListener(_timelineViewHoveringUpdate);

    _calendarCellNotifier.removeListener(_timelineViewHoveringUpdate);

    if (_timelineViewAnimation != null) {
      _timelineViewAnimation!.removeListener(_scrollAnimationListener);
    }

    if (widget.resourcePanelScrollController != null) {
      widget.resourcePanelScrollController!
          .removeListener(_updateResourcePanelScroll);
    }

    if (CalendarViewHelper.isTimelineView(widget.view) &&
        _timelineViewAnimationController != null) {
      _timelineViewAnimationController!.dispose();
      _timelineViewAnimationController = null;
    }
    if (_scrollController != null) {
      _scrollController!.removeListener(_scrollListener);
      _scrollController!.dispose();
      _scrollController = null;
    }
    if (_timelineViewHeaderScrollController != null) {
      _timelineViewHeaderScrollController!.dispose();
      _timelineViewHeaderScrollController = null;
    }
    if (_animationController != null) {
      _animationController!.dispose();
      _animationController = null;
    }
    if (_timelineRulerController != null) {
      _timelineRulerController!.dispose();
      _timelineRulerController = null;
    }

    if (_expanderAnimationController != null) {
      _expanderAnimationController!.dispose();
      _expanderAnimationController = null;
    }

    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    super.dispose();
  }

  Timer? _createTimer() {
    return widget.calendar.showCurrentTimeIndicator &&
            widget.view != CalendarView.month &&
            widget.view != CalendarView.timelineMonth
        ? Timer.periodic(const Duration(seconds: 1), (Timer t) {
            final DateTime today = DateTime.now();
            final DateTime viewEndDate =
                widget.visibleDates[widget.visibleDates.length - 1];

            /// Check the today date is in between visible date range and
            /// today date hour and minute is 0(12 AM) because in day view
            /// current time as Feb 16, 23.59 and changed to Feb 17 then view
            /// will update both Feb 16 and 17 views.
            if (!isDateWithInDateRange(
                    widget.visibleDates[0], viewEndDate, today) &&
                !(today.hour == 0 &&
                    today.minute == 0 &&
                    isSameDate(addDays(today, -1), viewEndDate))) {
              return;
            }

            _currentTimeNotifier.value =
                (today.day * 24 * 60) + (today.hour * 60) + today.minute;
          })
        : null;
  }

  /// Updates the resource panel scroll based on timeline scroll in vertical
  /// direction.
  void _updateResourcePanelScroll() {
    if (_updateCalendarStateDetails.currentViewVisibleDates ==
        widget.visibleDates) {
      widget.removePicker();
    }

    if (widget.resourcePanelScrollController == null ||
        !CalendarViewHelper.isResourceEnabled(
            widget.calendar.dataSource, widget.view)) {
      return;
    }

    if (_timelineViewVerticalScrollController != null &&
        _timelineViewVerticalScrollController!.hasClients &&
        widget.resourcePanelScrollController!.offset !=
            _timelineViewVerticalScrollController!.offset) {
      _timelineViewVerticalScrollController!
          .jumpTo(widget.resourcePanelScrollController!.offset);
    }
  }

  /// Updates the timeline view scroll in vertical direction based on resource
  /// panel scroll.
  void _updateResourceScroll() {
    if (_updateCalendarStateDetails.currentViewVisibleDates ==
        widget.visibleDates) {
      widget.removePicker();
    }

    if (widget.resourcePanelScrollController == null ||
        !CalendarViewHelper.isResourceEnabled(
            widget.calendar.dataSource, widget.view)) {
      return;
    }

    if (widget.resourcePanelScrollController!.offset !=
        _timelineViewVerticalScrollController!.offset) {
      widget.resourcePanelScrollController!
          .jumpTo(_timelineViewVerticalScrollController!.offset);
    }
  }

  Widget _getMonthView() {
    final SystemMouseCursor currentCursor =
        _mouseCursor == SystemMouseCursors.resizeUp ||
                _mouseCursor == SystemMouseCursors.resizeDown
            ? SystemMouseCursors.resizeUpDown
            : _mouseCursor == SystemMouseCursors.resizeRight ||
                    _mouseCursor == SystemMouseCursors.resizeLeft
                ? SystemMouseCursors.resizeLeftRight
                : _mouseCursor;

    return MouseRegion(
      cursor: currentCursor,
      onEnter: _pointerEnterEvent,
      onExit: _pointerExitEvent,
      onHover: _pointerHoverEvent,
      child: Stack(children: <Widget>[
        GestureDetector(
          onTapUp: _handleOnTapForMonth,
          child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: _addMonthView(_isRTL, widget.locale)),
        ),
        _getResizeShadowView()
      ]),
    );
  }

  Widget _getDayView() {
    final bool isCurrentView =
        _updateCalendarStateDetails.currentViewVisibleDates ==
            widget.visibleDates;

    // Check and update the time interval height while the all day panel
    // appointments updated(all day height is default value) for current view.
    if (isCurrentView && _updateCalendarStateDetails.allDayPanelHeight != 0) {
      final bool isDayView = CalendarViewHelper.isDayView(
          widget.view,
          widget.calendar.timeSlotViewSettings.numberOfDaysInView,
          widget.calendar.timeSlotViewSettings.nonWorkingDays,
          widget.calendar.monthViewSettings.numberOfWeeksInView);
      final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
          widget.calendar.viewHeaderHeight, widget.view);
      // Default all day height is 0 on week and work week view
      // Default all day height is view header height on day view.
      final double defaultAllDayHeight = isDayView ? viewHeaderHeight : 0;
      if (_allDayHeight == defaultAllDayHeight) {
        _timeIntervalHeight = _getTimeIntervalHeight(
            widget.calendar,
            widget.view,
            widget.width,
            widget.height,
            widget.visibleDates.length,
            widget.isMobilePlatform);
      }
    }

    _updateAllDayHeight(isCurrentView);

    final SystemMouseCursor currentCursor =
        _mouseCursor == SystemMouseCursors.resizeUp ||
                _mouseCursor == SystemMouseCursors.resizeDown
            ? SystemMouseCursors.resizeUpDown
            : _mouseCursor == SystemMouseCursors.resizeRight ||
                    _mouseCursor == SystemMouseCursors.resizeLeft
                ? SystemMouseCursors.resizeLeftRight
                : _mouseCursor;

    return MouseRegion(
      cursor: currentCursor,
      onEnter: _pointerEnterEvent,
      onHover: _pointerHoverEvent,
      onExit: _pointerExitEvent,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapUp: _handleOnTapForDay,
            child: SizedBox(
                height: widget.height,
                width: widget.width,
                child: _addDayView(
                    widget.width,
                    _timeIntervalHeight * _horizontalLinesCount!,
                    _isRTL,
                    widget.locale,
                    isCurrentView)),
          ),
          _getResizeShadowView()
        ],
      ),
    );
  }

  /// Method to update alldayHeight calculation for day, week and work week
  /// view, based on the view also based on the timeintervalheight.
  void _updateAllDayHeight(bool isCurrentView) {
    if (widget.view != CalendarView.day &&
        widget.view != CalendarView.week &&
        widget.view != CalendarView.workWeek) {
      return;
    }

    _allDayHeight = 0;
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    if (isDayView) {
      final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
          widget.calendar.viewHeaderHeight, widget.view);
      if (isCurrentView) {
        _allDayHeight = _kAllDayLayoutHeight > viewHeaderHeight &&
                _updateCalendarStateDetails.allDayPanelHeight > viewHeaderHeight
            ? _updateCalendarStateDetails.allDayPanelHeight >
                    _kAllDayLayoutHeight
                ? _kAllDayLayoutHeight
                : _updateCalendarStateDetails.allDayPanelHeight
            : viewHeaderHeight;
        if (_allDayHeight < _updateCalendarStateDetails.allDayPanelHeight) {
          _allDayHeight += kAllDayAppointmentHeight;
        }
      } else {
        _allDayHeight = viewHeaderHeight;
      }
    } else if (isCurrentView) {
      _allDayHeight =
          _updateCalendarStateDetails.allDayPanelHeight > _kAllDayLayoutHeight
              ? _kAllDayLayoutHeight
              : _updateCalendarStateDetails.allDayPanelHeight;
      _allDayHeight = _allDayHeight * _heightAnimation!.value;
    }
  }

  Widget _getTimelineView() {
    final SystemMouseCursor currentCursor =
        _mouseCursor == SystemMouseCursors.resizeUp ||
                _mouseCursor == SystemMouseCursors.resizeDown
            ? SystemMouseCursors.resizeUpDown
            : _mouseCursor == SystemMouseCursors.resizeRight ||
                    _mouseCursor == SystemMouseCursors.resizeLeft
                ? SystemMouseCursors.resizeLeftRight
                : _mouseCursor;
    return MouseRegion(
        cursor: currentCursor,
        onEnter: _pointerEnterEvent,
        onHover: _pointerHoverEvent,
        onExit: _pointerExitEvent,
        child: Stack(children: <Widget>[
          GestureDetector(
            onTapUp: _handleOnTapForTimeline,
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: _addTimelineView(
                  _timeIntervalHeight *
                      (_horizontalLinesCount! * widget.visibleDates.length),
                  widget.height,
                  widget.locale),
            ),
          ),
          _getResizeShadowView()
        ]));
  }

  void _timelineViewHoveringUpdate() {
    if (!CalendarViewHelper.isTimelineView(widget.view) && mounted) {
      return;
    }

    // Updates the timeline views based on mouse hovering position.
    _timelineViewHeaderNotifier.value = !_timelineViewHeaderNotifier.value;
  }

  void _scrollAnimationListener() {
    _scrollController!.jumpTo(_timelineViewAnimation!.value);
  }

  void _scrollToPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.view == CalendarView.month) {
        return;
      }

      widget.getCalendarState(_updateCalendarStateDetails);
      final double scrollPosition = _getScrollPositionForCurrentDate(
          _updateCalendarStateDetails.currentDate!);
      if (scrollPosition == -1 ||
          _scrollController!.position.pixels == scrollPosition) {
        return;
      }

      _scrollController!.jumpTo(
          _scrollController!.position.maxScrollExtent > scrollPosition
              ? scrollPosition
              : _scrollController!.position.maxScrollExtent);
    });
  }

  double _getScrollPositionForCurrentDate(DateTime date) {
    final int visibleDatesCount = widget.visibleDates.length;
    if (!isDateWithInDateRange(widget.visibleDates[0],
        widget.visibleDates[visibleDatesCount - 1], date)) {
      return -1;
    }

    double timeToPosition = 0;
    if (!CalendarViewHelper.isTimelineView(widget.view)) {
      timeToPosition = AppointmentHelper.timeToPosition(
          widget.calendar, date, _timeIntervalHeight);
    } else {
      for (int i = 0; i < visibleDatesCount; i++) {
        if (!isSameDate(date, widget.visibleDates[i])) {
          continue;
        }

        if (widget.view == CalendarView.timelineMonth) {
          timeToPosition = _timeIntervalHeight * i;
        } else {
          timeToPosition = (_getSingleViewWidthForTimeLineView(this) * i) +
              AppointmentHelper.timeToPosition(
                  widget.calendar, date, _timeIntervalHeight);
        }

        break;
      }
    }

    if (_scrollController!.hasClients) {
      if (timeToPosition > _scrollController!.position.maxScrollExtent) {
        timeToPosition = _scrollController!.position.maxScrollExtent;
      } else if (timeToPosition < _scrollController!.position.minScrollExtent) {
        timeToPosition = _scrollController!.position.minScrollExtent;
      }
    }

    return timeToPosition;
  }

  /// Used to retain the scrolled date time.
  void _retainScrolledDateTime() {
    if (widget.view == CalendarView.month) {
      return;
    }

    DateTime scrolledDate = widget.visibleDates[0];
    double scrolledPosition = 0;
    if (CalendarViewHelper.isTimelineView(widget.view)) {
      final double singleViewWidth = _getSingleViewWidthForTimeLineView(this);

      /// Calculate the scrolled position date.
      scrolledDate = widget
          .visibleDates[_scrollController!.position.pixels ~/ singleViewWidth];

      /// Calculate the scrolled hour position without visible date position.
      scrolledPosition = _scrollController!.position.pixels % singleViewWidth;
    } else {
      /// Calculate the scrolled hour position.
      scrolledPosition = _scrollController!.position.pixels;
    }

    /// Calculate the current horizontal line based on time interval height.
    final double columnIndex = scrolledPosition / _timeIntervalHeight;

    /// Calculate the time based on calculated horizontal position.
    final double time = ((CalendarViewHelper.getTimeInterval(
                    widget.calendar.timeSlotViewSettings) /
                60) *
            columnIndex) +
        widget.calendar.timeSlotViewSettings.startHour;
    final int hour = time.toInt();
    final int minute = ((time - hour) * 60).round();
    scrolledDate = DateTime(
        scrolledDate.year, scrolledDate.month, scrolledDate.day, hour, minute);

    /// Update the scrolled position after the widget generated.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController!.jumpTo(_getPositionFromDate(scrolledDate));
    });
  }

  /// Calculate the position from date.
  double _getPositionFromDate(DateTime date) {
    final int visibleDatesCount = widget.visibleDates.length;
    _timeIntervalHeight = _getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        visibleDatesCount,
        widget.isMobilePlatform);
    double timeToPosition = 0;
    final bool isTimelineView = CalendarViewHelper.isTimelineView(widget.view);
    if (!isTimelineView) {
      timeToPosition = AppointmentHelper.timeToPosition(
          widget.calendar, date, _timeIntervalHeight);
    } else {
      for (int i = 0; i < visibleDatesCount; i++) {
        if (!isSameDate(date, widget.visibleDates[i])) {
          continue;
        }

        if (widget.view == CalendarView.timelineMonth) {
          timeToPosition = _timeIntervalHeight * i;
        } else {
          timeToPosition = (_getSingleViewWidthForTimeLineView(this) * i) +
              AppointmentHelper.timeToPosition(
                  widget.calendar, date, _timeIntervalHeight);
        }

        break;
      }
    }

    double maxScrollPosition = 0;
    if (!isTimelineView) {
      final double scrollViewHeight = widget.height -
          _allDayHeight -
          CalendarViewHelper.getViewHeaderHeight(
              widget.calendar.viewHeaderHeight, widget.view);
      final double scrollViewContentHeight =
          CalendarViewHelper.getHorizontalLinesCount(
                  widget.calendar.timeSlotViewSettings, widget.view) *
              _timeIntervalHeight;
      maxScrollPosition = scrollViewContentHeight - scrollViewHeight;
    } else {
      final double scrollViewContentWidth =
          CalendarViewHelper.getHorizontalLinesCount(
                  widget.calendar.timeSlotViewSettings, widget.view) *
              _timeIntervalHeight *
              visibleDatesCount;
      maxScrollPosition = scrollViewContentWidth - widget.width;
    }

    return maxScrollPosition > timeToPosition
        ? timeToPosition
        : maxScrollPosition;
  }

  void _expandOrCollapseAllDay() {
    _isExpanded = !_isExpanded;
    if (_isExpanded) {
      _expanderAnimationController!.forward();
    } else {
      _expanderAnimationController!.reverse();
    }
  }

  /// Update the time slot view scroll based on time ruler view scroll in
  /// timeslot views.
  void _timeRulerListener() {
    if (!CalendarViewHelper.isTimelineView(widget.view)) {
      return;
    }

    if (_timelineRulerController!.offset != _scrollController!.offset) {
      _scrollController!.jumpTo(_timelineRulerController!.offset);
    }
  }

  void _scrollListener() {
    if (_updateCalendarStateDetails.currentViewVisibleDates ==
        widget.visibleDates) {
      widget.removePicker();
    }

    if (CalendarViewHelper.isTimelineView(widget.view)) {
      widget.getCalendarState(_updateCalendarStateDetails);
      if (widget.view != CalendarView.timelineMonth) {
        _timelineViewHeaderNotifier.value = !_timelineViewHeaderNotifier.value;
      }

      if (_timelineRulerController!.offset != _scrollController!.offset) {
        _timelineRulerController!.jumpTo(_scrollController!.offset);
      }

      if (widget.view == CalendarView.timelineMonth &&
          widget.calendar.showWeekNumber) {
        final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
            widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
        final DateTime? date =
            _getDateFromPosition(_scrollController!.offset, 0, timeLabelWidth);
        if (date != null) {
          widget.timelineMonthWeekNumberNotifier.value = date;
        }
      }

      _timelineViewHeaderScrollController!.jumpTo(_scrollController!.offset);
    }
  }

  void _updateTimeSlotView(_CalendarView oldWidget) {
    _animationController ??= AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _heightAnimation ??=
        CurveTween(curve: Curves.easeIn).animate(_animationController!)
          ..addListener(() {
            setState(() {
              /*Animates the all day panel when it's expanding or
        collapsing*/
            });
          });

    _expanderAnimationController ??= AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _allDayExpanderAnimation ??=
        CurveTween(curve: Curves.easeIn).animate(_expanderAnimationController!)
          ..addListener(() {
            setState(() {
              /*Animates the all day panel when it's expanding or
        collapsing*/
            });
          });

    if (!CalendarViewHelper.isDayView(
            widget.view,
            widget.calendar.timeSlotViewSettings.numberOfDaysInView,
            widget.calendar.timeSlotViewSettings.nonWorkingDays,
            widget.calendar.monthViewSettings.numberOfWeeksInView) &&
        _allDayHeight == 0) {
      if (_animationController!.status == AnimationStatus.completed) {
        _animationController!.reset();
      }

      _animationController!.forward();
    }
  }

  void _updateHorizontalLineCount(_CalendarView oldWidget) {
    if (widget.calendar.timeSlotViewSettings.startHour !=
            oldWidget.calendar.timeSlotViewSettings.startHour ||
        widget.calendar.timeSlotViewSettings.endHour !=
            oldWidget.calendar.timeSlotViewSettings.endHour ||
        CalendarViewHelper.getTimeInterval(
                widget.calendar.timeSlotViewSettings) !=
            CalendarViewHelper.getTimeInterval(
                oldWidget.calendar.timeSlotViewSettings) ||
        oldWidget.view == CalendarView.month ||
        oldWidget.view == CalendarView.timelineMonth ||
        oldWidget.view != CalendarView.timelineMonth &&
            widget.view == CalendarView.timelineMonth) {
      _horizontalLinesCount = CalendarViewHelper.getHorizontalLinesCount(
          widget.calendar.timeSlotViewSettings, widget.view);
    } else {
      _horizontalLinesCount = _horizontalLinesCount ??
          CalendarViewHelper.getHorizontalLinesCount(
              widget.calendar.timeSlotViewSettings, widget.view);
    }
  }

  void _updateTimelineViews(_CalendarView oldWidget) {
    _timelineRulerController ??= ScrollController()
      ..addListener(_timeRulerListener);

    _timelineViewAnimationController ??= AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _timelineViewAnimation ??= _timelineViewTween
        .animate(_timelineViewAnimationController!)
      ..addListener(_scrollAnimationListener);

    _timelineViewHeaderScrollController ??= ScrollController();
    _timelineViewVerticalScrollController = ScrollController();
    _timelineViewVerticalScrollController!.addListener(_updateResourceScroll);
    widget.resourcePanelScrollController
        ?.addListener(_updateResourcePanelScroll);
  }

  void _getPainterProperties(UpdateCalendarStateDetails details) {
    widget.getCalendarState(_updateCalendarStateDetails);
    details.allDayAppointmentViewCollection =
        _updateCalendarStateDetails.allDayAppointmentViewCollection;
    details.currentViewVisibleDates =
        _updateCalendarStateDetails.currentViewVisibleDates;
    details.visibleAppointments =
        _updateCalendarStateDetails.visibleAppointments;
    details.selectedDate = _updateCalendarStateDetails.selectedDate;
  }

  Widget _addAllDayAppointmentPanel(
      SfCalendarThemeData calendarTheme, bool isCurrentView) {
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    final Color borderColor =
        widget.calendar.cellBorderColor ?? calendarTheme.cellBorderColor!;
    final Widget shadowView = Divider(
      height: 1,
      thickness: 1,
      color: borderColor.withOpacity(borderColor.opacity * 0.5),
    );

    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    double topPosition = CalendarViewHelper.getViewHeaderHeight(
        widget.calendar.viewHeaderHeight, widget.view);
    if (isDayView) {
      topPosition = _allDayHeight;
    }

    if (_allDayHeight == 0 ||
        (!isDayView &&
            widget.visibleDates !=
                _updateCalendarStateDetails.currentViewVisibleDates)) {
      return Positioned(
          left: 0, right: 0, top: topPosition, height: 1, child: shadowView);
    }

    if (isDayView) {
      //// Default minimum view header width in day view as 50,so set 50
      //// when view header width less than 50.
      topPosition = 0;
    }

    double panelHeight = isCurrentView
        ? _updateCalendarStateDetails.allDayPanelHeight - _allDayHeight
        : 0;
    if (panelHeight < 0) {
      panelHeight = 0;
    }

    /// Remove the all day appointment selection when the selected all
    /// day appointment removed.
    if (_allDaySelectionNotifier.value != null &&
        _allDaySelectionNotifier.value!.appointmentView != null &&
        (!_updateCalendarStateDetails.visibleAppointments.contains(
            _allDaySelectionNotifier.value!.appointmentView!.appointment))) {
      _allDaySelectionNotifier.value = null;
    }

    final double allDayExpanderHeight =
        _allDayHeight + (panelHeight * _allDayExpanderAnimation!.value);
    return Positioned(
      left: 0,
      top: topPosition,
      right: 0,
      height: allDayExpanderHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: _isExpanded ? allDayExpanderHeight : _allDayHeight,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: <Widget>[
                _getAllDayLayout(timeLabelWidth, panelHeight,
                    allDayExpanderHeight, isCurrentView)
              ],
            ),
          ),
          Positioned(
              left: 0,
              top: allDayExpanderHeight - 1,
              right: 0,
              height: 1,
              child: shadowView),
        ],
      ),
    );
  }

  Widget _getAllDayLayout(double timeLabelWidth, double panelHeight,
      double allDayExpanderHeight, bool isCurrentView) {
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    final Widget allDayLayout = AllDayAppointmentLayout(
        widget.calendar,
        widget.view,
        widget.visibleDates,
        widget.visibleDates ==
                _updateCalendarStateDetails.currentViewVisibleDates
            ? _updateCalendarStateDetails.visibleAppointments
            : null,
        timeLabelWidth,
        allDayExpanderHeight,
        panelHeight > 0 && (_heightAnimation!.value == 1 || isDayView),
        _allDayExpanderAnimation!.value != 0.0 &&
            _allDayExpanderAnimation!.value != 1,
        _isRTL,
        widget.calendarTheme,
        widget.themeData,
        _allDaySelectionNotifier,
        _allDayNotifier,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        widget.width,
        (isDayView &&
                    _updateCalendarStateDetails.allDayPanelHeight <
                        _allDayHeight) ||
                !isCurrentView
            ? _allDayHeight
            : _updateCalendarStateDetails.allDayPanelHeight,
        widget.localizations,
        _getPainterProperties);

    if ((_mouseCursor == SystemMouseCursors.basic ||
            _mouseCursor == SystemMouseCursors.move) ||
        !widget.calendar.allowAppointmentResize) {
      return allDayLayout;
    } else {
      return GestureDetector(
        onHorizontalDragStart: _onHorizontalStart,
        onHorizontalDragUpdate: _onHorizontalUpdate,
        onHorizontalDragEnd: _onHorizontalEnd,
        child: allDayLayout,
      );
    }
  }

  Widget _addAppointmentPainter(double width, double height,
      [double? resourceItemHeight]) {
    final List<CalendarAppointment>? visibleAppointments =
        widget.visibleDates ==
                _updateCalendarStateDetails.currentViewVisibleDates
            ? _updateCalendarStateDetails.visibleAppointments
            : null;
    _appointmentLayout = AppointmentLayout(
      widget.calendar,
      widget.view,
      widget.visibleDates,
      ValueNotifier<List<CalendarAppointment>?>(visibleAppointments),
      _timeIntervalHeight,
      widget.calendarTheme,
      widget.themeData,
      _isRTL,
      _appointmentHoverNotifier,
      widget.resourceCollection,
      resourceItemHeight,
      widget.textScaleFactor,
      widget.isMobilePlatform,
      width,
      height,
      widget.localizations,
      _getPainterProperties,
      key: _appointmentLayoutKey,
    );

    return _appointmentLayout;
  }

  void _onVerticalStart(DragStartDetails details) {
    final double xPosition = details.localPosition.dx;
    double yPosition = details.localPosition.dy;
    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    AppointmentView? appointmentView;
    const double padding = 10;
    final bool isForwardResize = _mouseCursor == SystemMouseCursors.resizeDown;
    final bool isBackwardResize = _mouseCursor == SystemMouseCursors.resizeUp;
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    final double viewHeaderHeight = isDayView
        ? 0
        : CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view);
    if (!CalendarViewHelper.isTimelineView(widget.view) &&
        widget.view != CalendarView.month) {
      if (xPosition < timeLabelWidth) {
        return;
      }

      final double allDayPanelHeight = _isExpanded
          ? _updateCalendarStateDetails.allDayPanelHeight
          : _allDayHeight;

      yPosition = yPosition -
          viewHeaderHeight -
          allDayPanelHeight +
          _scrollController!.offset;

      if (isBackwardResize) {
        yPosition += padding;
      } else if (isForwardResize) {
        yPosition -= padding;
      }
      appointmentView =
          _appointmentLayout.getAppointmentViewOnPoint(xPosition, yPosition);
      if (appointmentView == null) {
        return;
      }

      _resizingDetails.value.isAllDayPanel = false;
      yPosition = details.localPosition.dy -
          viewHeaderHeight -
          allDayPanelHeight +
          _scrollController!.offset;

      if (_mouseCursor != SystemMouseCursors.basic &&
          _mouseCursor != SystemMouseCursors.move) {
        _resizingDetails.value.appointmentView = appointmentView.clone();
      } else {
        appointmentView = null;
        return;
      }

      _updateMaximumResizingPosition(isForwardResize, isBackwardResize,
          appointmentView, allDayPanelHeight, viewHeaderHeight);
      _resizingDetails.value.position.value = Offset(
          appointmentView.appointmentRect!.left, details.localPosition.dy);
    }

    _resizingDetails.value.resizingTime = isBackwardResize
        ? _resizingDetails.value.appointmentView!.appointment!.actualStartTime
        : _resizingDetails.value.appointmentView!.appointment!.actualEndTime;
    _resizingDetails.value.scrollPosition = null;
    if (widget.calendar.appointmentBuilder == null) {
      _resizingDetails.value.appointmentColor =
          appointmentView!.appointment!.color;
    }
    if (CalendarViewHelper.shouldRaiseAppointmentResizeStartCallback(
        widget.calendar.onAppointmentResizeStart)) {
      CalendarViewHelper.raiseAppointmentResizeStartCallback(
          widget.calendar,
          _getCalendarAppointmentToObject(
              appointmentView!.appointment, widget.calendar),
          null);
    }
  }

  void _onVerticalUpdate(DragUpdateDetails details) {
    if (_resizingDetails.value.appointmentView == null) {
      return;
    }

    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    final double viewHeaderHeight = isDayView
        ? 0
        : CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view);
    double yPosition = details.localPosition.dy;
    final bool isForwardResize = _mouseCursor == SystemMouseCursors.resizeDown;
    final bool isBackwardResize = _mouseCursor == SystemMouseCursors.resizeUp;
    final double allDayPanelHeight = _isExpanded
        ? _updateCalendarStateDetails.allDayPanelHeight
        : _allDayHeight;
    if (!CalendarViewHelper.isTimelineView(widget.view) &&
        widget.view != CalendarView.month) {
      _updateMaximumResizingPosition(
          isForwardResize,
          isBackwardResize,
          _resizingDetails.value.appointmentView!,
          allDayPanelHeight,
          viewHeaderHeight);
      if ((isForwardResize && yPosition < _maximumResizingPosition!) ||
          (isBackwardResize && yPosition > _maximumResizingPosition!)) {
        yPosition = _maximumResizingPosition!;
      }

      _updateAutoScrollDay(details, viewHeaderHeight, allDayPanelHeight,
          isForwardResize, isBackwardResize, yPosition);
    }

    _resizingDetails.value.scrollPosition = null;
    _resizingDetails.value.position.value = Offset(
        _resizingDetails.value.appointmentView!.appointmentRect!.left,
        yPosition);
    _updateAppointmentResizingUpdateCallback(isForwardResize, isBackwardResize,
        yPosition, viewHeaderHeight, allDayPanelHeight);
  }

  void _onVerticalEnd(DragEndDetails details) {
    if (_resizingDetails.value.appointmentView == null) {
      _resizingDetails.value.position.value = null;
      return;
    }

    if (_autoScrollTimer != null) {
      _autoScrollTimer!.cancel();
      _autoScrollTimer = null;
    }

    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    final double viewHeaderHeight = isDayView
        ? 0
        : CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view);

    final double allDayPanelHeight = _isExpanded
        ? _updateCalendarStateDetails.allDayPanelHeight
        : _allDayHeight;

    final double currentYPosition =
        _resizingDetails.value.position.value!.dy > widget.height - 1
            ? widget.height - 1
            : _resizingDetails.value.position.value!.dy;
    double yPosition = currentYPosition -
        viewHeaderHeight -
        allDayPanelHeight +
        _scrollController!.offset;

    final CalendarAppointment appointment =
        _resizingDetails.value.appointmentView!.appointment!;
    final double timeIntervalHeight = _getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        widget.visibleDates.length,
        widget.isMobilePlatform);

    final double overAllHeight = _timeIntervalHeight * _horizontalLinesCount!;
    if (overAllHeight < widget.height && yPosition > overAllHeight) {
      yPosition = overAllHeight;
    }

    final DateTime resizingTime = _timeFromPosition(
        appointment.actualStartTime,
        widget.calendar.timeSlotViewSettings,
        yPosition,
        null,
        timeIntervalHeight,
        false)!;

    final int timeInterval = CalendarViewHelper.getTimeInterval(
        widget.calendar.timeSlotViewSettings);

    DateTime updatedStartTime = appointment.actualStartTime,
        updatedEndTime = appointment.actualEndTime;

    if (AppointmentHelper.canAddSpanIcon(
        widget.visibleDates, appointment, widget.view)) {
      updatedStartTime = appointment.exactStartTime;
      updatedEndTime = appointment.exactEndTime;
    }

    if (_mouseCursor == SystemMouseCursors.resizeDown) {
      updatedEndTime = resizingTime;
    } else if (_mouseCursor == SystemMouseCursors.resizeUp) {
      updatedStartTime = resizingTime;
    }

    final DateTime callbackStartDate = updatedStartTime;
    final DateTime callbackEndDate = updatedEndTime;
    updatedStartTime = AppointmentHelper.convertTimeToAppointmentTimeZone(
        updatedStartTime, widget.calendar.timeZone, appointment.startTimeZone);
    updatedEndTime = AppointmentHelper.convertTimeToAppointmentTimeZone(
        updatedEndTime, widget.calendar.timeZone, appointment.endTimeZone);

    if (CalendarViewHelper.isDraggingAppointmentHasDisabledCell(
        widget.regions!,
        widget.blackoutDates!,
        updatedStartTime,
        updatedEndTime,
        false,
        false,
        widget.calendar.minDate,
        widget.calendar.maxDate,
        timeInterval,
        -1,
        widget.resourceCollection)) {
      if (CalendarViewHelper.shouldRaiseAppointmentResizeEndCallback(
          widget.calendar.onAppointmentResizeEnd)) {
        CalendarViewHelper.raiseAppointmentResizeEndCallback(
            widget.calendar,
            appointment.data,
            null,
            appointment.exactStartTime,
            appointment.exactEndTime);
      }

      _resetResizingPainter();
      return;
    }

    CalendarAppointment? parentAppointment;
    if (appointment.recurrenceRule != null &&
        appointment.recurrenceRule!.isNotEmpty) {
      for (int i = 0;
          i < _updateCalendarStateDetails.appointments.length;
          i++) {
        final CalendarAppointment app =
            _updateCalendarStateDetails.appointments[i];
        if (app.id == appointment.id) {
          parentAppointment = app;
          break;
        }
      }

      widget.calendar.dataSource!.appointments!.remove(parentAppointment!.data);
      widget.calendar.dataSource!.notifyListeners(
          CalendarDataSourceAction.remove, <dynamic>[parentAppointment.data]);

      final DateTime exceptionDate =
          AppointmentHelper.convertTimeToAppointmentTimeZone(
              appointment.exactStartTime, widget.calendar.timeZone, '');
      parentAppointment.recurrenceExceptionDates != null
          ? parentAppointment.recurrenceExceptionDates!.add(exceptionDate)
          : parentAppointment.recurrenceExceptionDates = <DateTime>[
              exceptionDate
            ];

      final dynamic newParentAppointment =
          _getCalendarAppointmentToObject(parentAppointment, widget.calendar);
      widget.calendar.dataSource!.appointments!.add(newParentAppointment);
      widget.calendar.dataSource!.notifyListeners(
          CalendarDataSourceAction.add, <dynamic>[newParentAppointment]);
    } else {
      widget.calendar.dataSource!.appointments!.remove(appointment.data);
      widget.calendar.dataSource!.notifyListeners(
          CalendarDataSourceAction.remove, <dynamic>[appointment.data]);
    }

    appointment.startTime = updatedStartTime;
    appointment.endTime = updatedEndTime;
    appointment.recurrenceId = parentAppointment != null
        ? parentAppointment.id
        : appointment.recurrenceId;
    appointment.recurrenceRule =
        appointment.recurrenceId != null ? null : appointment.recurrenceRule;
    appointment.id = parentAppointment != null ? null : appointment.id;
    final dynamic newAppointment =
        _getCalendarAppointmentToObject(appointment, widget.calendar);
    widget.calendar.dataSource!.appointments!.add(newAppointment);
    widget.calendar.dataSource!.notifyListeners(
        CalendarDataSourceAction.add, <dynamic>[newAppointment]);

    if (CalendarViewHelper.shouldRaiseAppointmentResizeEndCallback(
        widget.calendar.onAppointmentResizeEnd)) {
      CalendarViewHelper.raiseAppointmentResizeEndCallback(widget.calendar,
          newAppointment, null, callbackStartDate, callbackEndDate);
    }

    _resetResizingPainter();
  }

  void _onHorizontalStart(DragStartDetails details) {
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    final double viewHeaderHeight = isDayView
        ? 0
        : CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view);
    double xPosition = details.localPosition.dx;
    CalendarResource? resource;
    double yPosition = details.localPosition.dy;
    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    final bool isTimelineView = CalendarViewHelper.isTimelineView(widget.view);
    AppointmentView? appointmentView;
    const double padding = 10;
    final bool isForwardResize = _mouseCursor == SystemMouseCursors.resizeRight;
    final bool isBackwardResize = _mouseCursor == SystemMouseCursors.resizeLeft;
    if (!isTimelineView && widget.view != CalendarView.month) {
      if ((!_isRTL && xPosition < timeLabelWidth) ||
          (_isRTL && xPosition > (widget.width - timeLabelWidth))) {
        return;
      }

      if (isBackwardResize) {
        xPosition += padding;
      } else if (isForwardResize) {
        xPosition -= padding;
      }

      appointmentView = _getAllDayAppointmentOnPoint(
          _updateCalendarStateDetails.allDayAppointmentViewCollection,
          xPosition,
          yPosition);
      if (appointmentView == null) {
        return;
      }

      xPosition = details.localPosition.dx;
      yPosition = appointmentView.appointmentRect!.top + viewHeaderHeight;
      _resizingDetails.value.isAllDayPanel = true;
      _updateMaximumResizingPosition(isForwardResize, isBackwardResize,
          appointmentView, null, viewHeaderHeight);
    } else if (isTimelineView) {
      yPosition -= viewHeaderHeight + timeLabelWidth;
      xPosition = _scrollController!.offset + details.localPosition.dx;
      if (_isRTL) {
        xPosition = _scrollController!.offset +
            (_scrollController!.position.viewportDimension -
                details.localPosition.dx);
        xPosition = (_scrollController!.position.viewportDimension +
                _scrollController!.position.maxScrollExtent) -
            xPosition;
      }

      if (isBackwardResize) {
        xPosition += padding;
      } else if (isForwardResize) {
        xPosition -= padding;
      }

      final bool isResourceEnabled = CalendarViewHelper.isResourceEnabled(
          widget.calendar.dataSource, widget.view);

      if (isResourceEnabled) {
        yPosition += _timelineViewVerticalScrollController!.offset;
      }

      appointmentView =
          _appointmentLayout.getAppointmentViewOnPoint(xPosition, yPosition);
      _resizingDetails.value.isAllDayPanel = false;
      if (appointmentView == null) {
        return;
      }
      if (isResourceEnabled) {
        resource = widget.calendar.dataSource!.resources![
            _getSelectedResourceIndex(appointmentView.appointmentRect!.top,
                viewHeaderHeight, timeLabelWidth)];
      }

      yPosition = appointmentView.appointmentRect!.top +
          viewHeaderHeight +
          timeLabelWidth;
      if (isResourceEnabled) {
        yPosition -= _timelineViewVerticalScrollController!.offset;
      }
      _updateMaximumResizingPosition(isForwardResize, isBackwardResize,
          appointmentView, null, viewHeaderHeight);
    } else if (widget.view == CalendarView.month) {
      _resizingDetails.value.monthRowCount = 0;
      yPosition -= viewHeaderHeight;
      xPosition = details.localPosition.dx;
      if (isBackwardResize) {
        xPosition += padding;
      } else if (isForwardResize) {
        xPosition -= padding;
      }

      appointmentView =
          _appointmentLayout.getAppointmentViewOnPoint(xPosition, yPosition);
      _resizingDetails.value.isAllDayPanel = false;
      if (appointmentView == null) {
        return;
      }

      xPosition = details.localPosition.dx;
      yPosition = appointmentView.appointmentRect!.top + viewHeaderHeight;

      _updateMaximumResizingPosition(isForwardResize, isBackwardResize,
          appointmentView, null, viewHeaderHeight);
    }

    if (_mouseCursor != SystemMouseCursors.basic &&
        _mouseCursor != SystemMouseCursors.move) {
      _resizingDetails.value.appointmentView = appointmentView!.clone();
    } else {
      appointmentView = null;
      return;
    }

    _resizingDetails.value.scrollPosition = null;
    if (widget.calendar.appointmentBuilder == null) {
      _resizingDetails.value.appointmentColor =
          appointmentView.appointment!.color;
    }
    if (isTimelineView && _isRTL) {
      _resizingDetails.value.resizingTime = isForwardResize
          ? _resizingDetails.value.appointmentView!.appointment!.actualStartTime
          : _resizingDetails.value.appointmentView!.appointment!.actualEndTime;
    } else {
      _resizingDetails.value.resizingTime = isBackwardResize
          ? _resizingDetails.value.appointmentView!.appointment!.actualStartTime
          : _resizingDetails.value.appointmentView!.appointment!.actualEndTime;
    }
    _resizingDetails.value.position.value =
        Offset(details.localPosition.dx, yPosition);
    if (CalendarViewHelper.shouldRaiseAppointmentResizeStartCallback(
        widget.calendar.onAppointmentResizeStart)) {
      CalendarViewHelper.raiseAppointmentResizeStartCallback(
          widget.calendar,
          _getCalendarAppointmentToObject(
              appointmentView.appointment, widget.calendar),
          resource);
    }
  }

  void _onHorizontalUpdate(DragUpdateDetails details) {
    if (_resizingDetails.value.appointmentView == null) {
      return;
    }

    final bool isResourceEnabled = CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view);
    final bool isForwardResize = _mouseCursor == SystemMouseCursors.resizeRight;
    final bool isBackwardResize = _mouseCursor == SystemMouseCursors.resizeLeft;
    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    final bool isTimelineView = CalendarViewHelper.isTimelineView(widget.view);
    double xPosition = details.localPosition.dx;
    double yPosition = _resizingDetails.value.position.value!.dy;
    late DateTime resizingTime;
    final double timeIntervalHeight = _getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        widget.visibleDates.length,
        widget.isMobilePlatform);

    if (isTimelineView) {
      _updateMaximumResizingPosition(isForwardResize, isBackwardResize,
          _resizingDetails.value.appointmentView!, null, null);
      if ((isForwardResize && xPosition < _maximumResizingPosition!) ||
          (isBackwardResize && xPosition > _maximumResizingPosition!)) {
        xPosition = _maximumResizingPosition!;
      }

      _updateAutoScrollTimeline(
          details,
          timeIntervalHeight,
          isForwardResize,
          isBackwardResize,
          xPosition,
          yPosition,
          timeLabelWidth,
          isResourceEnabled);
    } else if (widget.view == CalendarView.month) {
      final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
          widget.calendar.viewHeaderHeight, widget.view);
      double resizingPosition = details.localPosition.dy - viewHeaderHeight;
      if (resizingPosition < 0) {
        resizingPosition = 0;
      } else if (resizingPosition > widget.height - viewHeaderHeight - 1) {
        resizingPosition = widget.height - viewHeaderHeight - 1;
      }

      final double cellHeight = (widget.height - viewHeaderHeight) /
          widget.calendar.monthViewSettings.numberOfWeeksInView;
      final int appointmentRowIndex =
          (_resizingDetails.value.appointmentView!.appointmentRect!.top /
                  cellHeight)
              .truncate();
      int resizingRowIndex = (resizingPosition / cellHeight).truncate();
      final double weekNumberPanelWidth =
          CalendarViewHelper.getWeekNumberPanelWidth(
              widget.calendar.showWeekNumber,
              widget.width,
              widget.isMobilePlatform);
      if (!_isRTL) {
        if (xPosition < weekNumberPanelWidth) {
          xPosition = weekNumberPanelWidth;
        } else if (xPosition > widget.width - 1) {
          xPosition = widget.width - 1;
        }
      } else {
        if (xPosition > widget.width - weekNumberPanelWidth - 1) {
          xPosition = widget.width - weekNumberPanelWidth - 1;
        } else if (xPosition < 0) {
          xPosition = 0;
        }
      }

      /// Handle the appointment resize after and before the current month
      /// dates when hide trailing and leading dates enabled.
      if (!widget.calendar.monthViewSettings.showTrailingAndLeadingDates &&
          widget.calendar.monthViewSettings.numberOfWeeksInView == 6) {
        final DateTime currentMonthDate =
            widget.visibleDates[widget.visibleDates.length ~/ 2];
        final int startIndex = DateTimeHelper.getVisibleDateIndex(
            widget.visibleDates,
            AppointmentHelper.getMonthStartDate(currentMonthDate));
        final int endIndex = DateTimeHelper.getVisibleDateIndex(
            widget.visibleDates,
            AppointmentHelper.getMonthEndDate(currentMonthDate));
        final int startRowCount = startIndex ~/ DateTime.daysPerWeek;
        final int startColumnCount = startIndex % DateTime.daysPerWeek;
        final int endRowCount = endIndex ~/ DateTime.daysPerWeek;
        final int endColumnCount = endIndex % DateTime.daysPerWeek;
        if (resizingRowIndex >= endRowCount) {
          resizingRowIndex = endRowCount;
          resizingPosition = resizingRowIndex * cellHeight;
          final double cellWidth =
              (widget.width - weekNumberPanelWidth) / DateTime.daysPerWeek;
          if (_isRTL) {
            final double currentXPosition =
                (DateTime.daysPerWeek - endColumnCount - 1) * cellWidth;
            xPosition =
                xPosition > currentXPosition ? xPosition : currentXPosition;
          } else {
            final double currentXPosition =
                ((endColumnCount + 1) * cellWidth) + weekNumberPanelWidth - 1;
            xPosition =
                xPosition > currentXPosition ? currentXPosition : xPosition;
          }
        } else if (resizingRowIndex <= startRowCount) {
          resizingRowIndex = startRowCount;
          resizingPosition = resizingRowIndex * cellHeight;
          final double cellWidth =
              (widget.width - weekNumberPanelWidth) / DateTime.daysPerWeek;
          if (_isRTL) {
            double currentXPosition =
                (DateTime.daysPerWeek - startColumnCount) * cellWidth;
            if (currentXPosition != 0) {
              currentXPosition -= 1;
            }

            xPosition =
                xPosition < currentXPosition ? xPosition : currentXPosition;
          } else {
            final double currentXPosition =
                (startColumnCount * cellWidth) + weekNumberPanelWidth;
            xPosition =
                xPosition < currentXPosition ? currentXPosition : xPosition;
          }
        }
      }

      /// Restrict by max resize position only restrict the appointment resize
      /// on previous and next row also so check the row index also to resolve
      /// the issue with both RTL and LTR scenarios.
      if (_isRTL) {
        if (isForwardResize &&
            ((appointmentRowIndex == resizingRowIndex &&
                    xPosition < _maximumResizingPosition!) ||
                appointmentRowIndex < resizingRowIndex)) {
          xPosition = _maximumResizingPosition!;
          resizingRowIndex = appointmentRowIndex;
          resizingPosition =
              _resizingDetails.value.appointmentView!.appointmentRect!.top;
        } else if (isBackwardResize &&
            ((appointmentRowIndex == resizingRowIndex &&
                    xPosition > _maximumResizingPosition!) ||
                appointmentRowIndex > resizingRowIndex)) {
          xPosition = _maximumResizingPosition!;
          resizingRowIndex = appointmentRowIndex;
          resizingPosition =
              _resizingDetails.value.appointmentView!.appointmentRect!.top;
        }
      } else {
        if (isForwardResize &&
            ((appointmentRowIndex == resizingRowIndex &&
                    xPosition < _maximumResizingPosition!) ||
                appointmentRowIndex > resizingRowIndex)) {
          xPosition = _maximumResizingPosition!;
          resizingRowIndex = appointmentRowIndex;
          resizingPosition =
              _resizingDetails.value.appointmentView!.appointmentRect!.top;
        } else if (isBackwardResize &&
            ((appointmentRowIndex == resizingRowIndex &&
                    xPosition > _maximumResizingPosition!) ||
                appointmentRowIndex < resizingRowIndex)) {
          xPosition = _maximumResizingPosition!;
          resizingRowIndex = appointmentRowIndex;
          resizingPosition =
              _resizingDetails.value.appointmentView!.appointmentRect!.top;
        }
      }

      resizingTime =
          _getDateFromPosition(xPosition, resizingPosition, timeLabelWidth)!;
      final int rowDifference = isBackwardResize
          ? _isRTL
              ? (appointmentRowIndex - resizingRowIndex).abs()
              : appointmentRowIndex - resizingRowIndex
          : _isRTL
              ? appointmentRowIndex - resizingRowIndex
              : (appointmentRowIndex - resizingRowIndex).abs();
      if (((!_isRTL &&
                  ((isBackwardResize &&
                          appointmentRowIndex > resizingRowIndex) ||
                      (isForwardResize &&
                          appointmentRowIndex < resizingRowIndex))) ||
              (_isRTL &&
                  ((isBackwardResize &&
                          appointmentRowIndex < resizingRowIndex) ||
                      (isForwardResize &&
                          appointmentRowIndex > resizingRowIndex)))) &&
          resizingRowIndex != appointmentRowIndex &&
          rowDifference != _resizingDetails.value.monthRowCount) {
        if (isForwardResize) {
          if (_isRTL) {
            if (_resizingDetails.value.monthRowCount > rowDifference) {
              yPosition += cellHeight;
            } else {
              yPosition -= cellHeight;
            }
          } else {
            if (_resizingDetails.value.monthRowCount > rowDifference) {
              yPosition -= cellHeight;
            } else {
              yPosition += cellHeight;
            }
          }
        } else {
          if (_isRTL) {
            if (_resizingDetails.value.monthRowCount > rowDifference) {
              yPosition -= cellHeight;
            } else {
              yPosition += cellHeight;
            }
          } else {
            if (_resizingDetails.value.monthRowCount > rowDifference) {
              yPosition += cellHeight;
            } else {
              yPosition -= cellHeight;
            }
          }
        }
        _resizingDetails.value.monthRowCount = rowDifference;
        _resizingDetails.value.monthCellHeight = cellHeight;
      } else if (resizingRowIndex == appointmentRowIndex &&
          rowDifference == 0) {
        _resizingDetails.value.monthRowCount = rowDifference;
        _resizingDetails.value.monthCellHeight = cellHeight;
        yPosition =
            _resizingDetails.value.appointmentView!.appointmentRect!.top +
                viewHeaderHeight;
      }
    } else {
      if ((isForwardResize && xPosition < _maximumResizingPosition!) ||
          (isBackwardResize && xPosition > _maximumResizingPosition!)) {
        xPosition = _maximumResizingPosition!;
      }

      double currentXPosition = xPosition;
      if (_isRTL) {
        if (currentXPosition > widget.width - timeLabelWidth - 1) {
          currentXPosition = widget.width - timeLabelWidth - 1;
        } else if (currentXPosition < 0) {
          currentXPosition = 0;
        }
      } else {
        if (currentXPosition < timeLabelWidth) {
          currentXPosition = timeLabelWidth;
        } else if (currentXPosition > widget.width - 1) {
          currentXPosition = widget.width - 1;
        }

        currentXPosition -= timeLabelWidth;
      }
      resizingTime =
          _getDateFromPosition(currentXPosition, yPosition, timeLabelWidth)!;
    }

    if (_resizingDetails.value.isAllDayPanel ||
        widget.view == CalendarView.month) {
      resizingTime =
          DateTime(resizingTime.year, resizingTime.month, resizingTime.day);
    }

    _resizingDetails.value.position.value = Offset(xPosition, yPosition);

    if (isTimelineView) {
      _updateAppointmentResizingUpdateCallback(
          isForwardResize, isBackwardResize, yPosition, null, null,
          xPosition: xPosition,
          timeLabelWidth: timeLabelWidth,
          isResourceEnabled: isResourceEnabled,
          details: details);
      return;
    }

    if (CalendarViewHelper.shouldRaiseAppointmentResizeUpdateCallback(
        widget.calendar.onAppointmentResizeUpdate)) {
      CalendarViewHelper.raiseAppointmentResizeUpdateCallback(
          widget.calendar,
          _getCalendarAppointmentToObject(
              _resizingDetails.value.appointmentView!.appointment,
              widget.calendar),
          null,
          resizingTime,
          _resizingDetails.value.position.value!);
    }
  }

  void _onHorizontalEnd(DragEndDetails details) {
    if (_resizingDetails.value.appointmentView == null) {
      _resizingDetails.value.position.value = null;
      return;
    }

    if (_autoScrollTimer != null) {
      _autoScrollTimer!.cancel();
      _autoScrollTimer = null;
    }

    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    final double viewHeaderHeight = isDayView
        ? 0
        : CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view);

    final bool isTimelineView = CalendarViewHelper.isTimelineView(widget.view);

    double xPosition = _resizingDetails.value.position.value!.dx;
    double yPosition = _resizingDetails.value.position.value!.dy;

    final bool isResourceEnabled = CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view);

    final CalendarAppointment appointment =
        _resizingDetails.value.appointmentView!.appointment!;
    final double timeIntervalHeight = _getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        widget.visibleDates.length,
        widget.isMobilePlatform);

    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    if (!isTimelineView && widget.view != CalendarView.month) {
      if (_isRTL) {
        if (xPosition > widget.width - timeLabelWidth - 1) {
          xPosition = widget.width - timeLabelWidth - 1;
        } else if (xPosition < 0) {
          xPosition = 0;
        }
      } else {
        if (xPosition < timeLabelWidth) {
          xPosition = timeLabelWidth;
        } else if (xPosition > widget.width - 1) {
          xPosition = widget.width - 1;
        }

        xPosition -= timeLabelWidth;
      }
    } else if (widget.view == CalendarView.month) {
      final double weekNumberPanelWidth =
          CalendarViewHelper.getWeekNumberPanelWidth(
              widget.calendar.showWeekNumber,
              widget.width,
              widget.isMobilePlatform);
      _resizingDetails.value.monthRowCount = 0;
      if (!_isRTL) {
        if (xPosition < weekNumberPanelWidth) {
          xPosition = weekNumberPanelWidth;
        }
      } else {
        if (xPosition > widget.width - weekNumberPanelWidth) {
          xPosition = widget.width - weekNumberPanelWidth;
        }
      }
      yPosition -= viewHeaderHeight;
    } else if (isTimelineView) {
      if (xPosition < 0) {
        xPosition = 0;
      } else if (xPosition > widget.width - 1) {
        xPosition = widget.width - 1;
      }

      final double overAllWidth = _timeIntervalHeight *
          (_horizontalLinesCount! * widget.visibleDates.length);

      if (overAllWidth < widget.width && xPosition > overAllWidth) {
        xPosition = overAllWidth;
      }
    }

    DateTime resizingTime =
        _getDateFromPosition(xPosition, yPosition, timeLabelWidth)!;
    if (_resizingDetails.value.isAllDayPanel ||
        widget.view == CalendarView.month ||
        widget.view == CalendarView.timelineMonth) {
      resizingTime =
          DateTime(resizingTime.year, resizingTime.month, resizingTime.day);
    } else if (isTimelineView) {
      final DateTime time = _timeFromPosition(
          resizingTime,
          widget.calendar.timeSlotViewSettings,
          xPosition,
          this,
          timeIntervalHeight,
          isTimelineView)!;

      resizingTime = DateTime(resizingTime.year, resizingTime.month,
          resizingTime.day, time.hour, time.minute, time.second);
    }

    CalendarResource? resource;
    int selectedResourceIndex = -1;
    if (isResourceEnabled) {
      selectedResourceIndex = _getSelectedResourceIndex(
          _resizingDetails.value.appointmentView!.appointmentRect!.top,
          viewHeaderHeight,
          timeLabelWidth);
      resource = widget.calendar.dataSource!.resources![selectedResourceIndex];
    }

    final bool isMonthView = widget.view == CalendarView.timelineMonth ||
        widget.view == CalendarView.month;

    final int timeInterval = CalendarViewHelper.getTimeInterval(
        widget.calendar.timeSlotViewSettings);

    DateTime updatedStartTime = appointment.actualStartTime,
        updatedEndTime = appointment.actualEndTime;
    if ((_isRTL && _mouseCursor == SystemMouseCursors.resizeLeft) ||
        (!_isRTL && _mouseCursor == SystemMouseCursors.resizeRight)) {
      if (isMonthView) {
        updatedEndTime = DateTime(resizingTime.year, resizingTime.month,
            resizingTime.day, updatedEndTime.hour, updatedEndTime.minute);
      } else {
        updatedEndTime = resizingTime;
      }
    } else if ((_isRTL && _mouseCursor == SystemMouseCursors.resizeRight) ||
        (!_isRTL && _mouseCursor == SystemMouseCursors.resizeLeft)) {
      if (isMonthView) {
        updatedStartTime = DateTime(resizingTime.year, resizingTime.month,
            resizingTime.day, updatedStartTime.hour, updatedStartTime.minute);
      } else {
        updatedStartTime = resizingTime;
      }
    }

    final DateTime callbackStartDate = updatedStartTime;
    final DateTime callbackEndDate = updatedEndTime;
    updatedStartTime = AppointmentHelper.convertTimeToAppointmentTimeZone(
        updatedStartTime, widget.calendar.timeZone, appointment.startTimeZone);
    updatedEndTime = AppointmentHelper.convertTimeToAppointmentTimeZone(
        updatedEndTime, widget.calendar.timeZone, appointment.endTimeZone);
    if (CalendarViewHelper.isDraggingAppointmentHasDisabledCell(
        widget.regions!,
        widget.blackoutDates!,
        updatedStartTime,
        updatedEndTime,
        isTimelineView,
        isMonthView,
        widget.calendar.minDate,
        widget.calendar.maxDate,
        timeInterval,
        selectedResourceIndex,
        widget.resourceCollection)) {
      if (CalendarViewHelper.shouldRaiseAppointmentResizeEndCallback(
          widget.calendar.onAppointmentResizeEnd)) {
        CalendarViewHelper.raiseAppointmentResizeEndCallback(
            widget.calendar,
            appointment.data,
            resource,
            appointment.exactStartTime,
            appointment.exactEndTime);
      }

      _resetResizingPainter();
      return;
    }

    CalendarAppointment? parentAppointment;
    widget.getCalendarState(_updateCalendarStateDetails);
    if ((appointment.recurrenceRule != null &&
            appointment.recurrenceRule!.isNotEmpty) ||
        appointment.recurrenceId != null) {
      for (int i = 0;
          i < _updateCalendarStateDetails.appointments.length;
          i++) {
        final CalendarAppointment app =
            _updateCalendarStateDetails.appointments[i];
        if (app.id == appointment.id || app.id == appointment.recurrenceId) {
          parentAppointment = app;
          break;
        }
      }

      final List<DateTime> recurrenceDates =
          RecurrenceHelper.getRecurrenceDateTimeCollection(
              parentAppointment!.recurrenceRule ?? '',
              parentAppointment.exactStartTime,
              recurrenceDuration: AppointmentHelper.getDifference(
                  parentAppointment.exactStartTime,
                  parentAppointment.exactEndTime),
              specificStartDate: widget.visibleDates[0],
              specificEndDate:
                  widget.visibleDates[widget.visibleDates.length - 1]);

      for (int i = 0;
          i < _updateCalendarStateDetails.appointments.length;
          i++) {
        final CalendarAppointment calendarApp =
            _updateCalendarStateDetails.appointments[i];
        if (calendarApp.recurrenceId != null &&
            calendarApp.recurrenceId == parentAppointment.id) {
          recurrenceDates.add(
              AppointmentHelper.convertTimeToAppointmentTimeZone(
                  calendarApp.startTime,
                  calendarApp.startTimeZone,
                  widget.calendar.timeZone));
        }
      }

      if (parentAppointment.recurrenceExceptionDates != null) {
        for (int i = 0;
            i < parentAppointment.recurrenceExceptionDates!.length;
            i++) {
          recurrenceDates.remove(
              AppointmentHelper.convertTimeToAppointmentTimeZone(
                  parentAppointment.recurrenceExceptionDates![i],
                  '',
                  widget.calendar.timeZone));
        }
      }

      recurrenceDates.sort();
      final int currentRecurrenceIndex =
          recurrenceDates.indexOf(appointment.exactStartTime);
      if (currentRecurrenceIndex != -1) {
        final DateTime? previousRecurrence = currentRecurrenceIndex <= 0
            ? null
            : recurrenceDates[currentRecurrenceIndex - 1];
        final DateTime? nextRecurrence =
            currentRecurrenceIndex >= recurrenceDates.length - 1
                ? null
                : recurrenceDates[currentRecurrenceIndex + 1];

        /// Check the resizing time is in between previous and next recurrence
        /// date. If previous recurrence is null(means resized appointment
        /// is first occurrence) then it does not have a limit for previous
        /// occurrence.
        if (!((nextRecurrence == null ||
                    isSameOrBeforeDate(nextRecurrence, resizingTime)) &&
                (previousRecurrence == null ||
                    isSameOrAfterDate(previousRecurrence, resizingTime)) &&
                !isSameDate(previousRecurrence, resizingTime) &&
                !isSameDate(nextRecurrence, resizingTime)) &&
            !isSameDate(appointment.exactStartTime, resizingTime)) {
          if (CalendarViewHelper.shouldRaiseAppointmentResizeEndCallback(
              widget.calendar.onAppointmentResizeEnd)) {
            CalendarViewHelper.raiseAppointmentResizeEndCallback(
                widget.calendar,
                appointment.data,
                resource,
                appointment.exactStartTime,
                appointment.exactEndTime);
          }

          _resetResizingPainter();
          return;
        }
      }

      if (appointment.recurrenceId != null &&
          (appointment.recurrenceRule == null ||
              appointment.recurrenceRule!.isEmpty)) {
        widget.calendar.dataSource!.appointments!.remove(appointment.data);
        widget.calendar.dataSource!.notifyListeners(
            CalendarDataSourceAction.remove, <dynamic>[appointment.data]);
      } else {
        widget.calendar.dataSource!.appointments!
            .remove(parentAppointment.data);
        widget.calendar.dataSource!.notifyListeners(
            CalendarDataSourceAction.remove, <dynamic>[parentAppointment.data]);

        final DateTime exceptionDate =
            AppointmentHelper.convertTimeToAppointmentTimeZone(
                appointment.exactStartTime, widget.calendar.timeZone, '');
        parentAppointment.recurrenceExceptionDates != null
            ? parentAppointment.recurrenceExceptionDates!.add(exceptionDate)
            : parentAppointment.recurrenceExceptionDates = <DateTime>[
                exceptionDate
              ];

        final dynamic newParentAppointment =
            _getCalendarAppointmentToObject(parentAppointment, widget.calendar);
        widget.calendar.dataSource!.appointments!.add(newParentAppointment);
        widget.calendar.dataSource!.notifyListeners(
            CalendarDataSourceAction.add, <dynamic>[newParentAppointment]);
      }
    } else {
      widget.calendar.dataSource!.appointments!.remove(appointment.data);
      widget.calendar.dataSource!.notifyListeners(
          CalendarDataSourceAction.remove, <dynamic>[appointment.data]);
    }

    appointment.startTime = updatedStartTime;
    appointment.endTime = updatedEndTime;
    appointment.recurrenceId = parentAppointment != null
        ? parentAppointment.id
        : appointment.recurrenceId;
    appointment.recurrenceRule =
        appointment.recurrenceId != null ? null : appointment.recurrenceRule;
    appointment.id = parentAppointment != null ? null : appointment.id;
    final dynamic newAppointment =
        _getCalendarAppointmentToObject(appointment, widget.calendar);

    widget.calendar.dataSource!.appointments!.add(newAppointment);
    widget.calendar.dataSource!.notifyListeners(
        CalendarDataSourceAction.add, <dynamic>[newAppointment]);

    if (CalendarViewHelper.shouldRaiseAppointmentResizeEndCallback(
        widget.calendar.onAppointmentResizeEnd)) {
      CalendarViewHelper.raiseAppointmentResizeEndCallback(widget.calendar,
          newAppointment, resource, callbackStartDate, callbackEndDate);
    }

    _resetResizingPainter();
  }

  Future<void> _updateAutoScrollDay(
      DragUpdateDetails details,
      double viewHeaderHeight,
      double allDayPanelHeight,
      bool isForwardResize,
      bool isBackwardResize,
      double? yPosition) async {
    if (_resizingDetails.value.appointmentView == null) {
      return;
    }

    final double timeIntervalHeight = _getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        widget.visibleDates.length,
        widget.isMobilePlatform);

    if (yPosition! <= viewHeaderHeight + allDayPanelHeight &&
        _scrollController!.position.pixels != 0) {
      if (_autoScrollTimer != null) {
        return;
      }
      _autoScrollTimer = Timer(const Duration(milliseconds: 200), () async {
        yPosition = _resizingDetails.value.position.value?.dy;
        if (yPosition != null &&
            yPosition! <= viewHeaderHeight + allDayPanelHeight &&
            _scrollController!.offset != 0) {
          Future<void> updateScrollPosition() async {
            double scrollPosition =
                _scrollController!.position.pixels - timeIntervalHeight;
            if (scrollPosition < 0) {
              scrollPosition = 0;
            }

            _resizingDetails.value.scrollPosition = scrollPosition;

            _resizingDetails.value.position.value = Offset(
                _resizingDetails.value.appointmentView!.appointmentRect!.left,
                yPosition! - 0.1);

            await _scrollController!.position.animateTo(
              scrollPosition,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
            if (_resizingDetails.value.appointmentView == null) {
              if (_autoScrollTimer != null) {
                _autoScrollTimer!.cancel();
                _autoScrollTimer = null;
              }

              return;
            }

            yPosition = _resizingDetails.value.position.value?.dy;
            _updateMaximumResizingPosition(
                isForwardResize,
                isBackwardResize,
                _resizingDetails.value.appointmentView!,
                allDayPanelHeight,
                viewHeaderHeight);
            if ((isForwardResize && yPosition! < _maximumResizingPosition!) ||
                (isBackwardResize && yPosition! > _maximumResizingPosition!)) {
              yPosition = _maximumResizingPosition;
            }
            _updateAppointmentResizingUpdateCallback(
                isForwardResize,
                isBackwardResize,
                yPosition!,
                viewHeaderHeight,
                allDayPanelHeight);

            _resizingDetails.value.position.value = Offset(
                _resizingDetails.value.appointmentView!.appointmentRect!.left,
                yPosition!);

            if (yPosition != null &&
                yPosition! <= viewHeaderHeight + allDayPanelHeight &&
                _scrollController!.offset != 0) {
              updateScrollPosition();
            } else if (_autoScrollTimer != null) {
              _autoScrollTimer!.cancel();
              _autoScrollTimer = null;
            }
          }

          updateScrollPosition();
        } else if (_autoScrollTimer != null) {
          _autoScrollTimer!.cancel();
          _autoScrollTimer = null;
        }
      });
    } else if (yPosition >= widget.height &&
        _scrollController!.position.pixels !=
            _scrollController!.position.maxScrollExtent) {
      if (_autoScrollTimer != null) {
        return;
      }
      _autoScrollTimer = Timer(const Duration(milliseconds: 200), () async {
        yPosition = _resizingDetails.value.position.value?.dy;
        if (yPosition != null &&
            yPosition! >= widget.height &&
            _scrollController!.position.pixels !=
                _scrollController!.position.maxScrollExtent) {
          Future<void> updateScrollPosition() async {
            double scrollPosition =
                _scrollController!.position.pixels + timeIntervalHeight;
            if (scrollPosition > _scrollController!.position.maxScrollExtent) {
              scrollPosition = _scrollController!.position.maxScrollExtent;
            }

            _resizingDetails.value.scrollPosition = scrollPosition;

            _resizingDetails.value.position.value = Offset(
                _resizingDetails.value.appointmentView!.appointmentRect!.left,
                yPosition! - 0.1);

            await _scrollController!.position.moveTo(
              scrollPosition,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
            if (_resizingDetails.value.appointmentView == null) {
              if (_autoScrollTimer != null) {
                _autoScrollTimer!.cancel();
                _autoScrollTimer = null;
              }

              return;
            }

            yPosition = _resizingDetails.value.position.value?.dy;

            _updateMaximumResizingPosition(
                isForwardResize,
                isBackwardResize,
                _resizingDetails.value.appointmentView!,
                allDayPanelHeight,
                viewHeaderHeight);
            if ((isForwardResize && yPosition! < _maximumResizingPosition!) ||
                (isBackwardResize && yPosition! > _maximumResizingPosition!)) {
              yPosition = _maximumResizingPosition;
            }
            _updateAppointmentResizingUpdateCallback(
                isForwardResize,
                isBackwardResize,
                yPosition!,
                viewHeaderHeight,
                allDayPanelHeight);

            _resizingDetails.value.position.value = Offset(
                _resizingDetails.value.appointmentView!.appointmentRect!.left,
                yPosition!);

            if (yPosition != null &&
                yPosition! >= widget.height &&
                _scrollController!.position.pixels !=
                    _scrollController!.position.maxScrollExtent) {
              updateScrollPosition();
            } else if (_autoScrollTimer != null) {
              _autoScrollTimer!.cancel();
              _autoScrollTimer = null;
            }
          }

          updateScrollPosition();
        } else if (_autoScrollTimer != null) {
          _autoScrollTimer!.cancel();
          _autoScrollTimer = null;
        }
      });
    }
  }

  Future<void> _updateAutoScrollTimeline(
      DragUpdateDetails details,
      double timeIntervalHeight,
      bool isForwardResize,
      bool isBackwardResize,
      double? xPosition,
      double yPosition,
      double timeLabelWidth,
      bool isResourceEnabled) async {
    if (_resizingDetails.value.appointmentView == null) {
      return;
    }

    const int padding = 5;

    if (xPosition! <= 0 &&
        ((_isRTL &&
                _scrollController!.position.pixels !=
                    _scrollController!.position.maxScrollExtent) ||
            (!_isRTL && _scrollController!.position.pixels != 0))) {
      if (_autoScrollTimer != null) {
        return;
      }
      _autoScrollTimer = Timer(const Duration(milliseconds: 200), () async {
        xPosition = _resizingDetails.value.position.value?.dx;
        if (xPosition != null &&
            xPosition! <= 0 &&
            ((_isRTL &&
                    _scrollController!.position.pixels !=
                        _scrollController!.position.maxScrollExtent) ||
                (!_isRTL && _scrollController!.position.pixels != 0))) {
          Future<void> updateScrollPosition() async {
            double scrollPosition =
                _scrollController!.position.pixels - timeIntervalHeight;
            if (_isRTL) {
              scrollPosition =
                  _scrollController!.position.pixels + timeIntervalHeight;
            }
            if (scrollPosition < 0 && !_isRTL) {
              scrollPosition = 0;
            } else if (_isRTL &&
                scrollPosition > _scrollController!.position.maxScrollExtent) {
              scrollPosition = _scrollController!.position.maxScrollExtent;
            }

            _resizingDetails.value.scrollPosition = scrollPosition;

            _resizingDetails.value.position.value = Offset(
                xPosition! - 0.1, _resizingDetails.value.position.value!.dy);

            await _scrollController!.position.animateTo(
              scrollPosition,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
            if (_resizingDetails.value.appointmentView == null) {
              if (_autoScrollTimer != null) {
                _autoScrollTimer!.cancel();
                _autoScrollTimer = null;
              }

              return;
            }

            xPosition = _resizingDetails.value.position.value?.dx;
            _updateMaximumResizingPosition(isForwardResize, isBackwardResize,
                _resizingDetails.value.appointmentView!, null, null);
            if ((isForwardResize && xPosition! < _maximumResizingPosition!) ||
                (isBackwardResize && xPosition! > _maximumResizingPosition!)) {
              xPosition = _maximumResizingPosition;
            }

            _updateAppointmentResizingUpdateCallback(
                isForwardResize, isBackwardResize, yPosition, null, null,
                xPosition: xPosition,
                timeLabelWidth: timeLabelWidth,
                isResourceEnabled: isResourceEnabled,
                details: details);

            _resizingDetails.value.position.value =
                Offset(xPosition!, _resizingDetails.value.position.value!.dy);

            if (xPosition != null &&
                xPosition! <= 0 &&
                ((_isRTL &&
                        _scrollController!.position.pixels !=
                            _scrollController!.position.maxScrollExtent) ||
                    (!_isRTL && _scrollController!.position.pixels != 0))) {
              updateScrollPosition();
            } else if (_autoScrollTimer != null) {
              _autoScrollTimer!.cancel();
              _autoScrollTimer = null;
            }
          }

          updateScrollPosition();
        } else if (_autoScrollTimer != null) {
          _autoScrollTimer!.cancel();
          _autoScrollTimer = null;
        }
      });
    } else if (xPosition + padding >= widget.width &&
        ((!_isRTL &&
                _scrollController!.position.pixels !=
                    _scrollController!.position.maxScrollExtent) ||
            (_isRTL && _scrollController!.position.pixels != 0))) {
      if (_autoScrollTimer != null) {
        return;
      }
      _autoScrollTimer = Timer(const Duration(milliseconds: 200), () async {
        xPosition = _resizingDetails.value.position.value?.dx;
        if (_resizingDetails.value.position.value != null &&
            xPosition! + padding >= widget.width &&
            ((!_isRTL &&
                    _scrollController!.position.pixels !=
                        _scrollController!.position.maxScrollExtent) ||
                (_isRTL && _scrollController!.position.pixels != 0))) {
          Future<void> updateScrollPosition() async {
            double scrollPosition =
                _scrollController!.position.pixels + timeIntervalHeight;
            if (_isRTL) {
              scrollPosition =
                  _scrollController!.position.pixels - timeIntervalHeight;
            }
            if (scrollPosition > _scrollController!.position.maxScrollExtent &&
                !_isRTL) {
              scrollPosition = _scrollController!.position.maxScrollExtent;
            } else if (_isRTL && scrollPosition < 0) {
              scrollPosition = 0;
            }

            _resizingDetails.value.scrollPosition = scrollPosition;

            _resizingDetails.value.position.value = Offset(
                xPosition! + 0.1, _resizingDetails.value.position.value!.dy);

            await _scrollController!.position.moveTo(
              scrollPosition,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
            if (_resizingDetails.value.appointmentView == null) {
              if (_autoScrollTimer != null) {
                _autoScrollTimer!.cancel();
                _autoScrollTimer = null;
              }

              return;
            }

            xPosition = _resizingDetails.value.position.value?.dx;
            _updateMaximumResizingPosition(isForwardResize, isBackwardResize,
                _resizingDetails.value.appointmentView!, null, null);
            if ((isForwardResize && xPosition! < _maximumResizingPosition!) ||
                (isBackwardResize && xPosition! > _maximumResizingPosition!)) {
              xPosition = _maximumResizingPosition;
            }

            _updateAppointmentResizingUpdateCallback(
                isForwardResize, isBackwardResize, yPosition, null, null,
                xPosition: xPosition,
                timeLabelWidth: timeLabelWidth,
                isResourceEnabled: isResourceEnabled,
                details: details);

            _resizingDetails.value.position.value =
                Offset(xPosition!, _resizingDetails.value.position.value!.dy);

            if (xPosition != null &&
                xPosition! + padding >= widget.width &&
                ((!_isRTL &&
                        _scrollController!.position.pixels !=
                            _scrollController!.position.maxScrollExtent) ||
                    (_isRTL && _scrollController!.position.pixels != 0))) {
              updateScrollPosition();
            } else if (_autoScrollTimer != null) {
              _autoScrollTimer!.cancel();
              _autoScrollTimer = null;
            }
          }

          updateScrollPosition();
        } else if (_autoScrollTimer != null) {
          _autoScrollTimer!.cancel();
          _autoScrollTimer = null;
        }
      });
    }
  }

  void _updateMaximumResizingPosition(
      bool isForwardResize,
      bool isBackwardResize,
      AppointmentView appointmentView,
      double? allDayPanelHeight,
      double? viewHeaderHeight) {
    switch (widget.view) {
      case CalendarView.schedule:
        break;
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          if (_resizingDetails.value.isAllDayPanel) {
            final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
                widget.calendar.timeSlotViewSettings.timeRulerSize,
                widget.view);
            final double minimumCellWidth =
                ((widget.width - timeLabelWidth) / widget.visibleDates.length) /
                    2;
            if (isForwardResize) {
              _maximumResizingPosition = appointmentView.appointmentRect!.left +
                  (appointmentView.appointmentRect!.width > minimumCellWidth
                      ? minimumCellWidth
                      : appointmentView.appointmentRect!.width);
            } else if (isBackwardResize) {
              _maximumResizingPosition =
                  appointmentView.appointmentRect!.right -
                      (appointmentView.appointmentRect!.width > minimumCellWidth
                          ? minimumCellWidth
                          : appointmentView.appointmentRect!.width);
            }
          } else {
            final double timeIntervalSize = _getTimeIntervalHeight(
                widget.calendar,
                widget.view,
                widget.width,
                widget.height,
                widget.visibleDates.length,
                widget.isMobilePlatform);
            double minimumTimeIntervalSize = timeIntervalSize / 4;
            if (minimumTimeIntervalSize < 20) {
              minimumTimeIntervalSize = 20;
            }

            if (isForwardResize) {
              _maximumResizingPosition = (appointmentView.appointmentRect!.top -
                      _scrollController!.offset +
                      allDayPanelHeight! +
                      viewHeaderHeight!) +
                  (appointmentView.appointmentRect!.height / 2 >
                          minimumTimeIntervalSize
                      ? minimumTimeIntervalSize
                      : appointmentView.appointmentRect!.height / 2);
            } else if (isBackwardResize) {
              _maximumResizingPosition =
                  (appointmentView.appointmentRect!.bottom -
                          _scrollController!.offset +
                          allDayPanelHeight! +
                          viewHeaderHeight!) -
                      (appointmentView.appointmentRect!.height / 2 >
                              minimumTimeIntervalSize
                          ? minimumTimeIntervalSize
                          : appointmentView.appointmentRect!.height / 2);
            }
          }
        }
        break;
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
        {
          final double timeIntervalSize = _getTimeIntervalHeight(
              widget.calendar,
              widget.view,
              widget.width,
              widget.height,
              widget.visibleDates.length,
              widget.isMobilePlatform);
          double minimumTimeIntervalSize = timeIntervalSize /
              (widget.view == CalendarView.timelineMonth ? 2 : 4);
          if (minimumTimeIntervalSize < 20) {
            minimumTimeIntervalSize = 20;
          }
          if (isForwardResize) {
            _maximumResizingPosition = appointmentView.appointmentRect!.left -
                _scrollController!.offset;
            if (_isRTL) {
              _maximumResizingPosition = _scrollController!.offset -
                  _scrollController!.position.maxScrollExtent +
                  appointmentView.appointmentRect!.left;
            }
            _maximumResizingPosition = _maximumResizingPosition! +
                (appointmentView.appointmentRect!.width / 2 >
                        minimumTimeIntervalSize
                    ? minimumTimeIntervalSize
                    : appointmentView.appointmentRect!.width / 2);
          } else if (isBackwardResize) {
            _maximumResizingPosition = appointmentView.appointmentRect!.right -
                _scrollController!.offset;
            if (_isRTL) {
              _maximumResizingPosition = _scrollController!.offset -
                  _scrollController!.position.maxScrollExtent +
                  appointmentView.appointmentRect!.right;
            }
            _maximumResizingPosition = _maximumResizingPosition! -
                (appointmentView.appointmentRect!.width / 2 >
                        minimumTimeIntervalSize
                    ? minimumTimeIntervalSize
                    : appointmentView.appointmentRect!.width / 2);
          }
        }
        break;
      case CalendarView.month:
        {
          final double weekNumberPanelWidth =
              CalendarViewHelper.getWeekNumberPanelWidth(
                  widget.calendar.showWeekNumber,
                  widget.width,
                  widget.isMobilePlatform);
          final double minimumCellWidth =
              ((widget.width - weekNumberPanelWidth) / DateTime.daysPerWeek) /
                  2;
          if (isForwardResize) {
            _maximumResizingPosition = appointmentView.appointmentRect!.left +
                (appointmentView.appointmentRect!.width / 2 > minimumCellWidth
                    ? minimumCellWidth
                    : appointmentView.appointmentRect!.width / 2);
          } else if (isBackwardResize) {
            _maximumResizingPosition = appointmentView.appointmentRect!.right -
                (appointmentView.appointmentRect!.width / 2 > minimumCellWidth
                    ? minimumCellWidth
                    : appointmentView.appointmentRect!.width / 2);
          }
        }
    }
  }

  void _updateAppointmentResizingUpdateCallback(
      bool isForwardResize,
      bool isBackwardResize,
      double yPosition,
      double? viewHeaderHeight,
      double? allDayPanelHeight,
      {bool isResourceEnabled = false,
      double? timeLabelWidth,
      double? xPosition,
      DragUpdateDetails? details}) {
    final double timeIntervalHeight = _getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        widget.visibleDates.length,
        widget.isMobilePlatform);
    late DateTime resizingTime;
    CalendarResource? resource;
    int selectedResourceIndex = -1;
    if (isResourceEnabled) {
      final bool isDayView = CalendarViewHelper.isDayView(
          widget.view,
          widget.calendar.timeSlotViewSettings.numberOfDaysInView,
          widget.calendar.timeSlotViewSettings.nonWorkingDays,
          widget.calendar.monthViewSettings.numberOfWeeksInView);
      final double viewHeaderHeight = isDayView
          ? 0
          : CalendarViewHelper.getViewHeaderHeight(
              widget.calendar.viewHeaderHeight, widget.view);
      selectedResourceIndex = _getSelectedResourceIndex(
          _resizingDetails.value.appointmentView!.appointmentRect!.top,
          viewHeaderHeight,
          timeLabelWidth!);
      resource = widget.calendar.dataSource!.resources![selectedResourceIndex];
    }

    if (CalendarViewHelper.isTimelineView(widget.view)) {
      final double overAllWidth = _timeIntervalHeight *
          (_horizontalLinesCount! * widget.visibleDates.length);
      double updatedXPosition = details!.localPosition.dx;
      if (updatedXPosition > widget.width - 1) {
        updatedXPosition = widget.width - 1;
      } else if (updatedXPosition < 0) {
        updatedXPosition = 0;
      }
      if (overAllWidth < widget.width && updatedXPosition > overAllWidth) {
        updatedXPosition = overAllWidth;
      }

      resizingTime = _getDateFromPosition(
          updatedXPosition, details.localPosition.dy, timeLabelWidth!)!;
      final DateTime time = _timeFromPosition(
          resizingTime,
          widget.calendar.timeSlotViewSettings,
          xPosition! > widget.width - 1
              ? widget.width - 1
              : (xPosition < 0 ? 0 : xPosition),
          this,
          timeIntervalHeight,
          true)!;

      if (widget.view == CalendarView.timelineMonth) {
        resizingTime =
            DateTime(resizingTime.year, resizingTime.month, resizingTime.day);
      } else {
        resizingTime = DateTime(resizingTime.year, resizingTime.month,
            resizingTime.day, time.hour, time.minute, time.second);
      }
    } else {
      final double overAllHeight = _timeIntervalHeight * _horizontalLinesCount!;
      double updatedYPosition =
          yPosition > widget.height - 1 ? widget.height - 1 : yPosition;
      if (overAllHeight < widget.height && updatedYPosition > overAllHeight) {
        updatedYPosition = overAllHeight;
      }
      final double currentYPosition =
          updatedYPosition - viewHeaderHeight! - allDayPanelHeight!;
      resizingTime = _timeFromPosition(
          _resizingDetails.value.appointmentView!.appointment!.actualStartTime,
          widget.calendar.timeSlotViewSettings,
          currentYPosition > 0 ? currentYPosition : 0,
          this,
          timeIntervalHeight,
          false)!;
    }

    _resizingDetails.value.resizingTime = resizingTime;
    if (CalendarViewHelper.shouldRaiseAppointmentResizeUpdateCallback(
        widget.calendar.onAppointmentResizeUpdate)) {
      CalendarViewHelper.raiseAppointmentResizeUpdateCallback(
          widget.calendar,
          _getCalendarAppointmentToObject(
              _resizingDetails.value.appointmentView!.appointment,
              widget.calendar),
          resource,
          resizingTime,
          _resizingDetails.value.position.value!);
    }
  }

  void _resetResizingPainter() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _resizingDetails.value.position.value = null;
    });
    _resizingDetails.value.isAllDayPanel = false;
    _resizingDetails.value.scrollPosition = null;
    _resizingDetails.value.monthRowCount = 0;
    _resizingDetails.value.monthCellHeight = null;
    _resizingDetails.value.appointmentView = null;
    _resizingDetails.value.appointmentColor = Colors.transparent;
  }

  // Returns the month view  as a child for the calendar view.
  Widget _addMonthView(bool isRTL, String locale) {
    final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
        widget.calendar.viewHeaderHeight, widget.view);
    final double height = widget.height - viewHeaderHeight;
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: viewHeaderHeight,
          child: Container(
            color: widget.calendar.viewHeaderStyle.backgroundColor ??
                widget.calendarTheme.viewHeaderBackgroundColor,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _ViewHeaderViewPainter(
                    widget.visibleDates,
                    widget.view,
                    widget.calendar.viewHeaderStyle,
                    widget.calendar.timeSlotViewSettings,
                    CalendarViewHelper.getTimeLabelWidth(
                        widget.calendar.timeSlotViewSettings.timeRulerSize,
                        widget.view),
                    CalendarViewHelper.getViewHeaderHeight(
                        widget.calendar.viewHeaderHeight, widget.view),
                    widget.calendar.monthViewSettings,
                    isRTL,
                    widget.locale,
                    widget.calendarTheme,
                    widget.themeData,
                    widget.calendar.todayHighlightColor ??
                        widget.calendarTheme.todayHighlightColor,
                    widget.calendar.todayTextStyle,
                    widget.calendar.cellBorderColor,
                    widget.calendar.minDate,
                    widget.calendar.maxDate,
                    _viewHeaderNotifier,
                    widget.textScaleFactor,
                    widget.calendar.showWeekNumber,
                    widget.isMobilePlatform,
                    widget.calendar.weekNumberStyle,
                    widget.localizations),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: viewHeaderHeight,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
              child: _CalendarMultiChildContainer(
            width: widget.width,
            height: height,
            children: <Widget>[
              RepaintBoundary(child: _getMonthWidget(isRTL, height)),
              RepaintBoundary(
                  child: _addAppointmentPainter(widget.width, height)),
            ],
          )),
        ),
        Positioned(
          left: 0,
          top: viewHeaderHeight,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _addSelectionView(),
              size: Size(widget.width, height),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getMonthWidget(bool isRTL, double height) {
    final List<CalendarAppointment>? visibleAppointments =
        widget.visibleDates ==
                _updateCalendarStateDetails.currentViewVisibleDates
            ? _updateCalendarStateDetails.visibleAppointments
            : null;
    _monthView = MonthViewWidget(
        widget.visibleDates,
        widget.calendar.monthViewSettings.numberOfWeeksInView,
        widget.calendar.monthViewSettings.monthCellStyle,
        isRTL,
        widget.calendar.todayHighlightColor ??
            widget.calendarTheme.todayHighlightColor,
        widget.calendar.todayTextStyle,
        widget.calendar.cellBorderColor,
        widget.calendarTheme,
        widget.themeData,
        _calendarCellNotifier,
        widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
        widget.calendar.minDate,
        widget.calendar.maxDate,
        widget.calendar,
        widget.blackoutDates,
        widget.calendar.blackoutDatesTextStyle,
        widget.textScaleFactor,
        widget.calendar.monthCellBuilder,
        widget.width,
        height,
        widget.calendar.weekNumberStyle,
        widget.isMobilePlatform,
        ValueNotifier<List<CalendarAppointment>?>(visibleAppointments));
    return _monthView;
  }

  Widget _getResizeShadowView() {
    if (widget.isMobilePlatform || !widget.calendar.allowAppointmentResize) {
      return const SizedBox(width: 0, height: 0);
    }

    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    final double viewHeaderHeight = isDayView
        ? 0
        : CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view);
    final double allDayPanelHeight = _isExpanded
        ? _updateCalendarStateDetails.allDayPanelHeight
        : _allDayHeight;
    final bool isVerticalResize = _mouseCursor == SystemMouseCursors.resizeUp ||
        _mouseCursor == SystemMouseCursors.resizeDown;
    final bool isTimelineView = CalendarViewHelper.isTimelineView(widget.view);
    final bool isAllDayPanel = !isVerticalResize &&
        (!isTimelineView && widget.view != CalendarView.month);
    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    final double weekNumberPanelWidth =
        CalendarViewHelper.getWeekNumberPanelWidth(
            widget.calendar.showWeekNumber,
            widget.width,
            widget.isMobilePlatform);

    final double overAllWidth = isTimelineView
        ? _timeIntervalHeight *
            (_horizontalLinesCount! * widget.visibleDates.length)
        : widget.width;
    final double overAllHeight =
        isTimelineView || widget.view == CalendarView.month
            ? widget.height
            : viewHeaderHeight +
                allDayPanelHeight +
                (_timeIntervalHeight * _horizontalLinesCount!);

    return Positioned(
        left: 0,
        width: overAllWidth,
        height: overAllHeight,
        top: 0,
        child: GestureDetector(
          onVerticalDragStart: isVerticalResize ? _onVerticalStart : null,
          onVerticalDragUpdate: isVerticalResize ? _onVerticalUpdate : null,
          onVerticalDragEnd: isVerticalResize ? _onVerticalEnd : null,
          onHorizontalDragStart: isVerticalResize ? null : _onHorizontalStart,
          onHorizontalDragUpdate: isVerticalResize ? null : _onHorizontalUpdate,
          onHorizontalDragEnd: isVerticalResize ? null : _onHorizontalEnd,
          child: IgnorePointer(
              ignoring: _mouseCursor == SystemMouseCursors.basic ||
                  _mouseCursor == SystemMouseCursors.move ||
                  isAllDayPanel,
              child: RepaintBoundary(
                  child: CustomPaint(
                painter: _ResizingAppointmentPainter(
                    _resizingDetails,
                    _isRTL,
                    widget.textScaleFactor,
                    widget.isMobilePlatform,
                    AppointmentHelper.getAppointmentTextStyle(
                        widget.calendar.appointmentTextStyle,
                        widget.view,
                        widget.themeData),
                    allDayPanelHeight,
                    viewHeaderHeight,
                    timeLabelWidth,
                    _timeIntervalHeight,
                    _scrollController,
                    widget.calendar.dragAndDropSettings,
                    widget.view,
                    _mouseCursor,
                    weekNumberPanelWidth,
                    widget.calendarTheme),
              ))),
        ));
  }

  // Returns the day view as a child for the calendar view.
  Widget _addDayView(double width, double height, bool isRTL, String locale,
      bool isCurrentView) {
    double viewHeaderWidth = widget.width;
    final double actualViewHeaderHeight =
        CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view);
    double viewHeaderHeight = actualViewHeaderHeight;
    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    if (isDayView) {
      viewHeaderWidth = timeLabelWidth < 50 ? 50 : timeLabelWidth;
      viewHeaderHeight =
          _allDayHeight > viewHeaderHeight ? _allDayHeight : viewHeaderHeight;
    }

    double panelHeight = isCurrentView
        ? _updateCalendarStateDetails.allDayPanelHeight - _allDayHeight
        : 0;
    if (panelHeight < 0) {
      panelHeight = 0;
    }

    final double allDayExpanderHeight =
        panelHeight * _allDayExpanderAnimation!.value;
    return Stack(
      children: <Widget>[
        _addAllDayAppointmentPanel(widget.calendarTheme, isCurrentView),
        Positioned(
          left: isRTL ? widget.width - viewHeaderWidth : 0,
          top: 0,
          right: isRTL ? 0 : widget.width - viewHeaderWidth,
          height: actualViewHeaderHeight,
          child: Container(
            color: widget.calendar.viewHeaderStyle.backgroundColor ??
                widget.calendarTheme.viewHeaderBackgroundColor,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _ViewHeaderViewPainter(
                    widget.visibleDates,
                    widget.view,
                    widget.calendar.viewHeaderStyle,
                    widget.calendar.timeSlotViewSettings,
                    CalendarViewHelper.getTimeLabelWidth(
                        widget.calendar.timeSlotViewSettings.timeRulerSize,
                        widget.view),
                    actualViewHeaderHeight,
                    widget.calendar.monthViewSettings,
                    isRTL,
                    widget.locale,
                    widget.calendarTheme,
                    widget.themeData,
                    widget.calendar.todayHighlightColor ??
                        widget.calendarTheme.todayHighlightColor,
                    widget.calendar.todayTextStyle,
                    widget.calendar.cellBorderColor,
                    widget.calendar.minDate,
                    widget.calendar.maxDate,
                    _viewHeaderNotifier,
                    widget.textScaleFactor,
                    widget.calendar.showWeekNumber,
                    widget.isMobilePlatform,
                    widget.calendar.weekNumberStyle,
                    widget.localizations),
              ),
            ),
          ),
        ),
        Positioned(
            top: isDayView
                ? viewHeaderHeight + allDayExpanderHeight
                : viewHeaderHeight + _allDayHeight + allDayExpanderHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: !widget.isMobilePlatform,
              child: ListView(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  children: <Widget>[
                    Stack(children: <Widget>[
                      RepaintBoundary(
                          child: _CalendarMultiChildContainer(
                              width: width,
                              height: height,
                              children: <Widget>[
                            RepaintBoundary(
                              child: TimeSlotWidget(
                                  widget.visibleDates,
                                  _horizontalLinesCount!,
                                  _timeIntervalHeight,
                                  timeLabelWidth,
                                  widget.calendar.cellBorderColor,
                                  widget.calendarTheme,
                                  widget.themeData,
                                  widget.calendar.timeSlotViewSettings,
                                  isRTL,
                                  widget.regions,
                                  _calendarCellNotifier,
                                  widget.textScaleFactor,
                                  widget.calendar.timeRegionBuilder,
                                  width,
                                  height,
                                  widget.calendar.minDate,
                                  widget.calendar.maxDate),
                            ),
                            RepaintBoundary(
                                child: _addAppointmentPainter(width, height)),
                          ])),
                      RepaintBoundary(
                        child: CustomPaint(
                          painter: _TimeRulerView(
                              _horizontalLinesCount!,
                              _timeIntervalHeight,
                              widget.calendar.timeSlotViewSettings,
                              widget.calendar.cellBorderColor,
                              isRTL,
                              widget.locale,
                              widget.calendarTheme,
                              CalendarViewHelper.isTimelineView(widget.view),
                              widget.visibleDates,
                              widget.textScaleFactor),
                          size: Size(timeLabelWidth, height),
                        ),
                      ),
                      RepaintBoundary(
                        child: CustomPaint(
                          painter: _addSelectionView(),
                          size: Size(width, height),
                        ),
                      ),
                      _getCurrentTimeIndicator(
                          timeLabelWidth, width, height, false),
                    ])
                  ]),
            )),
      ],
    );
  }

  Widget _getCurrentTimeIndicator(
      double timeLabelSize, double width, double height, bool isTimelineView) {
    if (!widget.calendar.showCurrentTimeIndicator ||
        widget.view == CalendarView.timelineMonth) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }

    return RepaintBoundary(
      child: CustomPaint(
        painter: _CurrentTimeIndicator(
          _timeIntervalHeight,
          timeLabelSize,
          widget.calendar.timeSlotViewSettings,
          isTimelineView,
          widget.visibleDates,
          widget.calendar.todayHighlightColor ??
              widget.calendarTheme.todayHighlightColor,
          _isRTL,
          _currentTimeNotifier,
          widget.calendar.timeZone ?? '',
        ),
        size: Size(width, height),
      ),
    );
  }

  /// Updates the cell selection when the initial display date property of
  /// calendar has value, on this scenario the first resource cell must be
  /// selected;
  void _updateProgrammaticSelectedResourceIndex() {
    if (_updateCalendarStateDetails.selectedDate != null &&
        _selectedResourceIndex == -1) {
      final bool isTimelineMonth = widget.view == CalendarView.timelineMonth;
      if ((isTimelineMonth &&
              (isSameDate(_updateCalendarStateDetails.selectedDate,
                  widget.calendar.initialSelectedDate))) ||
          (!isTimelineMonth &&
              (CalendarViewHelper.isSameTimeSlot(
                  _updateCalendarStateDetails.selectedDate,
                  widget.calendar.initialSelectedDate)))) {
        _selectedResourceIndex = 0;
      }
    }
  }

  // Returns the timeline view  as a child for the calendar view.
  Widget _addTimelineView(double width, double height, String locale) {
    final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
        widget.calendar.viewHeaderHeight, widget.view);
    final double timeLabelSize = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    final bool isResourceEnabled = CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view);
    double resourceItemHeight = 0;
    height -= viewHeaderHeight + timeLabelSize;
    if (isResourceEnabled) {
      _updateProgrammaticSelectedResourceIndex();
      final double resourceViewSize = widget.calendar.resourceViewSettings.size;
      resourceItemHeight = CalendarViewHelper.getResourceItemHeight(
          resourceViewSize,
          widget.height - viewHeaderHeight - timeLabelSize,
          widget.calendar.resourceViewSettings,
          widget.calendar.dataSource!.resources!.length);
      height = resourceItemHeight * widget.resourceCollection!.length;
    }
    return Stack(children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: viewHeaderHeight,
        child: Container(
          color: widget.calendar.viewHeaderStyle.backgroundColor ??
              widget.calendarTheme.viewHeaderBackgroundColor,
          child: _getTimelineViewHeader(width, viewHeaderHeight, widget.locale),
        ),
      ),
      Positioned(
          top: viewHeaderHeight,
          left: 0,
          right: 0,
          height: timeLabelSize,
          child: ListView(
            padding: EdgeInsets.zero,
            controller: _timelineRulerController,
            scrollDirection: Axis.horizontal,
            physics: const _CustomNeverScrollableScrollPhysics(),
            children: <Widget>[
              RepaintBoundary(
                  child: CustomPaint(
                painter: _TimeRulerView(
                    _horizontalLinesCount!,
                    _timeIntervalHeight,
                    widget.calendar.timeSlotViewSettings,
                    widget.calendar.cellBorderColor,
                    _isRTL,
                    locale,
                    widget.calendarTheme,
                    CalendarViewHelper.isTimelineView(widget.view),
                    widget.visibleDates,
                    widget.textScaleFactor),
                size: Size(width, timeLabelSize),
              )),
            ],
          )),
      Positioned(
          top: viewHeaderHeight + timeLabelSize,
          left: 0,
          right: 0,
          bottom: 0,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: !widget.isMobilePlatform,
            child: ListView(
                padding: EdgeInsets.zero,
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const _CustomNeverScrollableScrollPhysics(),
                children: <Widget>[
                  SizedBox(
                      width: width,
                      child: Stack(children: <Widget>[
                        Scrollbar(
                            controller: _timelineViewVerticalScrollController,
                            thumbVisibility: !widget.isMobilePlatform,
                            child: ListView(
                                padding: EdgeInsets.zero,
                                controller:
                                    _timelineViewVerticalScrollController,
                                physics: isResourceEnabled
                                    ? const ClampingScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  Stack(children: <Widget>[
                                    RepaintBoundary(
                                        child: _CalendarMultiChildContainer(
                                      width: width,
                                      height: height,
                                      children: <Widget>[
                                        RepaintBoundary(
                                            child: TimelineWidget(
                                                _horizontalLinesCount!,
                                                widget.visibleDates,
                                                widget.calendar
                                                    .timeSlotViewSettings,
                                                _timeIntervalHeight,
                                                widget.calendar.cellBorderColor,
                                                _isRTL,
                                                widget.calendarTheme,
                                                widget.themeData,
                                                _calendarCellNotifier,
                                                _scrollController!,
                                                widget.regions,
                                                resourceItemHeight,
                                                widget.resourceCollection,
                                                widget.textScaleFactor,
                                                widget.isMobilePlatform,
                                                widget
                                                    .calendar.timeRegionBuilder,
                                                width,
                                                height,
                                                widget.minDate,
                                                widget.maxDate,
                                                widget.blackoutDates)),
                                        RepaintBoundary(
                                            child: _addAppointmentPainter(width,
                                                height, resourceItemHeight)),
                                      ],
                                    )),
                                    RepaintBoundary(
                                      child: CustomPaint(
                                        painter: _addSelectionView(
                                            resourceItemHeight),
                                        size: Size(width, height),
                                      ),
                                    ),
                                    _getCurrentTimeIndicator(
                                        timeLabelSize, width, height, true),
                                  ]),
                                ])),
                      ])),
                ]),
          )),
    ]);
  }

  //// Get the calendar details for all calendar views.
  CalendarDetails? _getCalendarViewDetails(Offset position) {
    switch (widget.view) {
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        return _getDetailsForDay(position);
      case CalendarView.month:
        return _getDetailsForMonth(position);
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
        return _getDetailsForTimeline(position);
      case CalendarView.schedule:
        return null;
    }
  }

  //// Get the calendar details for month cells and view header of month.
  CalendarDetails? _getDetailsForMonth(Offset position) {
    final double xPosition = position.dx;
    double yPosition = position.dy;
    final double weekNumberPanelWidth =
        CalendarViewHelper.getWeekNumberPanelWidth(
            widget.calendar.showWeekNumber,
            widget.width,
            widget.isMobilePlatform);
    if ((!_isRTL && xPosition < weekNumberPanelWidth) ||
        (_isRTL && xPosition > widget.width - weekNumberPanelWidth)) {
      /// Return null while the [getCalendarDetailsAtOffset] position placed on
      /// week number panel in month view.
      return null;
    }

    final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
        widget.calendar.viewHeaderHeight, widget.view);

    if (yPosition < viewHeaderHeight) {
      /// Return calendar details while the [getCalendarDetailsAtOffset]
      /// position placed on view header in month view.
      return CalendarDetails(
          null,
          _getTappedViewHeaderDate(position, widget.width),
          CalendarElement.viewHeader,
          null);
    }

    yPosition = yPosition - viewHeaderHeight;
    AppointmentView? appointmentView;
    bool isMoreTapped = false;
    if (widget.calendar.monthViewSettings.appointmentDisplayMode ==
        MonthAppointmentDisplayMode.appointment) {
      appointmentView =
          _appointmentLayout.getAppointmentViewOnPoint(xPosition, yPosition);
      isMoreTapped = appointmentView != null &&
          appointmentView.startIndex == -1 &&
          appointmentView.endIndex == -1 &&
          appointmentView.position == -1 &&
          appointmentView.maxPositions == -1;
    }

    final DateTime getDate = _getDateFromPosition(xPosition, yPosition, 0)!;

    if (appointmentView == null) {
      final int currentMonth =
          widget.visibleDates[widget.visibleDates.length ~/ 2].month;

      /// Check the position of date as trailing or leading date when
      /// [SfCalendar] month not shown leading and trailing dates.
      if (!CalendarViewHelper.isCurrentMonthDate(
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
          currentMonth,
          getDate)) {
        /// Return null while the [getCalendarDetailsAtOffset] position placed
        /// on not shown leading and trailing dates.
        return null;
      }
    }

    final List<dynamic> selectedAppointments =
        appointmentView == null || isMoreTapped
            ? _getSelectedAppointments(getDate)
            : <dynamic>[
                CalendarViewHelper.getAppointmentDetail(
                    appointmentView.appointment!, widget.calendar.dataSource)
              ];
    final CalendarElement selectedElement = appointmentView == null
        ? CalendarElement.calendarCell
        : isMoreTapped
            ? CalendarElement.moreAppointmentRegion
            : CalendarElement.appointment;

    /// Return calendar details while the [getCalendarDetailsAtOffset]
    /// position placed on month cells in month view.
    return CalendarDetails(
        selectedAppointments, getDate, selectedElement, null);
  }

  //// Handles the onTap callback for month cells, and view header of month
  void _handleOnTapForMonth(TapUpDetails details) {
    _handleTouchOnMonthView(details, null);
  }

  /// Handles the tap and long press related functions for month view.
  AppointmentView? _handleTouchOnMonthView(
      TapUpDetails? tapDetails, LongPressStartDetails? longPressDetails) {
    widget.removePicker();
    final DateTime? previousSelectedDate = _selectionPainter!.selectedDate;
    double xDetails = 0, yDetails = 0;
    bool isTapCallback = false;
    if (tapDetails != null) {
      isTapCallback = true;
      xDetails = tapDetails.localPosition.dx;
      yDetails = tapDetails.localPosition.dy;
    } else if (longPressDetails != null) {
      xDetails = longPressDetails.localPosition.dx;
      yDetails = longPressDetails.localPosition.dy;
    }

    final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
        widget.calendar.viewHeaderHeight, widget.view);
    final double weekNumberPanelWidth =
        CalendarViewHelper.getWeekNumberPanelWidth(
            widget.calendar.showWeekNumber,
            widget.width,
            widget.isMobilePlatform);
    if ((!_isRTL && xDetails < weekNumberPanelWidth) ||
        (_isRTL && xDetails > widget.width - weekNumberPanelWidth)) {
      return null;
    }
    if (yDetails < viewHeaderHeight) {
      if (isTapCallback) {
        _handleOnTapForViewHeader(tapDetails!, widget.width);
      } else if (!isTapCallback) {
        _handleOnLongPressForViewHeader(longPressDetails!, widget.width);
      }
    } else if (yDetails > viewHeaderHeight) {
      if (!widget.focusNode.hasFocus) {
        widget.focusNode.requestFocus();
      }

      AppointmentView? appointmentView;
      bool isMoreTapped = false;
      if (!widget.isMobilePlatform &&
          widget.calendar.monthViewSettings.appointmentDisplayMode ==
              MonthAppointmentDisplayMode.appointment) {
        appointmentView = _appointmentLayout.getAppointmentViewOnPoint(
            xDetails, yDetails - viewHeaderHeight);
        isMoreTapped = appointmentView != null &&
            appointmentView.startIndex == -1 &&
            appointmentView.endIndex == -1 &&
            appointmentView.position == -1 &&
            appointmentView.maxPositions == -1;
      }

      if (appointmentView == null) {
        _drawSelection(xDetails, yDetails - viewHeaderHeight, 0);
      } else {
        _updateCalendarStateDetails.selectedDate = null;
        widget.agendaSelectedDate.value = null;
        _selectionPainter!.selectedDate = null;
        _selectionPainter!.appointmentView = appointmentView;
        _selectionNotifier.value = !_selectionNotifier.value;
      }

      widget.updateCalendarState(_updateCalendarStateDetails);
      final DateTime selectedDate =
          _getDateFromPosition(xDetails, yDetails - viewHeaderHeight, 0)!;
      if (appointmentView == null) {
        if (!isDateWithInDateRange(widget.calendar.minDate,
                widget.calendar.maxDate, selectedDate) ||
            CalendarViewHelper.isDateInDateCollection(
                widget.blackoutDates, selectedDate)) {
          return null;
        }

        final int currentMonth =
            widget.visibleDates[widget.visibleDates.length ~/ 2].month;

        /// Check the selected cell date as trailing or leading date when
        /// [SfCalendar] month not shown leading and trailing dates.
        if (!CalendarViewHelper.isCurrentMonthDate(
            widget.calendar.monthViewSettings.numberOfWeeksInView,
            widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
            currentMonth,
            selectedDate)) {
          return null;
        }

        _handleMonthCellTapNavigation(selectedDate);
      }

      final bool canRaiseTap =
          CalendarViewHelper.shouldRaiseCalendarTapCallback(
                  widget.calendar.onTap) &&
              isTapCallback;
      final bool canRaiseLongPress =
          CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
                  widget.calendar.onLongPress) &&
              !isTapCallback;
      final bool canRaiseSelectionChanged =
          CalendarViewHelper.shouldRaiseCalendarSelectionChangedCallback(
              widget.calendar.onSelectionChanged);

      if (canRaiseLongPress || canRaiseTap || canRaiseSelectionChanged) {
        final List<dynamic> selectedAppointments = appointmentView == null ||
                isMoreTapped
            ? _getSelectedAppointments(selectedDate)
            : <dynamic>[
                CalendarViewHelper.getAppointmentDetail(
                    appointmentView.appointment!, widget.calendar.dataSource)
              ];
        final CalendarElement selectedElement = appointmentView == null
            ? CalendarElement.calendarCell
            : isMoreTapped
                ? CalendarElement.moreAppointmentRegion
                : CalendarElement.appointment;
        if (canRaiseTap) {
          CalendarViewHelper.raiseCalendarTapCallback(widget.calendar,
              selectedDate, selectedAppointments, selectedElement, null);
        } else if (canRaiseLongPress) {
          CalendarViewHelper.raiseCalendarLongPressCallback(widget.calendar,
              selectedDate, selectedAppointments, selectedElement, null);
        }

        _updatedSelectionChangedCallback(
            canRaiseSelectionChanged, previousSelectedDate);
      }
      return appointmentView;
    }
    return null;
  }

  /// Raise selection changed callback based on the arguments passed.
  void _updatedSelectionChangedCallback(
      bool canRaiseSelectionChanged, DateTime? previousSelectedDate,
      [CalendarResource? selectedResource,
      int? previousSelectedResourceIndex]) {
    final bool isMonthView = widget.view == CalendarView.month ||
        widget.view == CalendarView.timelineMonth;
    if (canRaiseSelectionChanged &&
        ((isMonthView &&
                !isSameDate(
                    previousSelectedDate, _selectionPainter!.selectedDate)) ||
            (!isMonthView &&
                !CalendarViewHelper.isSameTimeSlot(
                    previousSelectedDate, _selectionPainter!.selectedDate)) ||
            (CalendarViewHelper.isResourceEnabled(
                    widget.calendar.dataSource, widget.view) &&
                _selectionPainter!.selectedResourceIndex !=
                    previousSelectedResourceIndex))) {
      CalendarViewHelper.raiseCalendarSelectionChangedCallback(
          widget.calendar, _selectionPainter!.selectedDate, selectedResource);
    }
  }

  void _handleMonthCellTapNavigation(DateTime date) {
    if (!widget.allowViewNavigation ||
        widget.view != CalendarView.month ||
        widget.calendar.monthViewSettings.showAgenda) {
      return;
    }

    widget.controller.view = CalendarView.day;
    widget.controller.displayDate = date;
  }

  //// Handles the onTap callback for timeline view cells, and view header of timeline.
  void _handleOnTapForTimeline(TapUpDetails details) {
    _handleTouchOnTimeline(details, null);
  }

  /// Returns the index of resource value associated with the selected calendar
  /// cell in timeline views.
  int _getSelectedResourceIndex(
      double yPosition, double viewHeaderHeight, double timeLabelSize) {
    final int resourceCount = widget.calendar.dataSource != null &&
            widget.calendar.dataSource!.resources != null
        ? widget.calendar.dataSource!.resources!.length
        : 0;
    final double resourceItemHeight = CalendarViewHelper.getResourceItemHeight(
        widget.calendar.resourceViewSettings.size,
        widget.height - viewHeaderHeight - timeLabelSize,
        widget.calendar.resourceViewSettings,
        resourceCount);
    return (yPosition / resourceItemHeight).truncate();
  }

  /// Get the calendar details for timeline view.
  CalendarDetails? _getDetailsForTimeline(Offset position) {
    final double xDetails = position.dx;
    final double yDetails = position.dy;

    final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
        widget.calendar.viewHeaderHeight, widget.view);

    if (yDetails < viewHeaderHeight) {
      /// Return calendar details while the [getCalendarDetailsAtOffset]
      /// position placed on view header in timeline views.
      return CalendarDetails(
          null,
          _getTappedViewHeaderDate(position, widget.width),
          CalendarElement.viewHeader,
          null);
    }

    double xPosition = _scrollController!.offset + xDetails;
    double yPosition = yDetails - viewHeaderHeight;

    final double timeLabelHeight = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);

    if (yPosition < timeLabelHeight) {
      /// Return null while the [getCalendarDetailsAtOffset] position placed on
      /// above resource panel equal to view header in timeline views.
      return null;
    }

    yPosition -= timeLabelHeight;

    CalendarResource? calendarResource;

    if (CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view)) {
      yPosition += _timelineViewVerticalScrollController!.offset;
      _selectedResourceIndex = _getSelectedResourceIndex(
          yPosition, viewHeaderHeight, timeLabelHeight);
      calendarResource =
          widget.calendar.dataSource!.resources![_selectedResourceIndex];
    }

    if (_isRTL) {
      xPosition = _scrollController!.offset +
          (_scrollController!.position.viewportDimension - xDetails);
      xPosition = (_scrollController!.position.viewportDimension +
              _scrollController!.position.maxScrollExtent) -
          xPosition;
    }

    final AppointmentView? appointmentView =
        _appointmentLayout.getAppointmentViewOnPoint(xPosition, yPosition);

    final DateTime getDate =
        _getDateFromPosition(xDetails, yDetails - viewHeaderHeight, 0)!;

    if (appointmentView == null) {
      /// Return calendar details while the [getCalendarDetailsAtOffset]
      /// position placed on calendar cell in timeline views.
      return CalendarDetails(
          null, getDate, CalendarElement.calendarCell, calendarResource);
    } else {
      /// Return calendar details while the [getCalendarDetailsAtOffset]
      /// position placed on appointment in timeline views.
      return CalendarDetails(<dynamic>[
        CalendarViewHelper.getAppointmentDetail(
            appointmentView.appointment!, widget.calendar.dataSource)
      ], getDate, CalendarElement.appointment, calendarResource);
    }
  }

  /// Handles the tap and long press related functions for timeline view.
  AppointmentView? _handleTouchOnTimeline(
      TapUpDetails? tapDetails, LongPressStartDetails? longPressDetails) {
    widget.removePicker();
    final DateTime? previousSelectedDate = _selectionPainter!.selectedDate;
    double xDetails = 0, yDetails = 0;
    bool isTapCallback = false;
    if (tapDetails != null) {
      isTapCallback = true;
      xDetails = tapDetails.localPosition.dx;
      yDetails = tapDetails.localPosition.dy;
    } else if (longPressDetails != null) {
      xDetails = longPressDetails.localPosition.dx;
      yDetails = longPressDetails.localPosition.dy;
    }

    final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
        widget.calendar.viewHeaderHeight, widget.view);

    if (yDetails < viewHeaderHeight) {
      if (isTapCallback) {
        _handleOnTapForViewHeader(tapDetails!, widget.width);
      } else if (!isTapCallback) {
        _handleOnLongPressForViewHeader(longPressDetails!, widget.width);
      }
    } else if (yDetails > viewHeaderHeight) {
      if (!widget.focusNode.hasFocus) {
        widget.focusNode.requestFocus();
      }

      widget.getCalendarState(_updateCalendarStateDetails);
      DateTime? selectedDate = _updateCalendarStateDetails.selectedDate;

      double xPosition = _scrollController!.offset + xDetails;
      double yPosition = yDetails - viewHeaderHeight;
      final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
          widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);

      if (yPosition < timeLabelWidth) {
        return null;
      }

      yPosition -= timeLabelWidth;

      CalendarResource? selectedResource;

      if (CalendarViewHelper.isResourceEnabled(
          widget.calendar.dataSource, widget.view)) {
        yPosition += _timelineViewVerticalScrollController!.offset;
        _selectedResourceIndex = _getSelectedResourceIndex(
            yPosition, viewHeaderHeight, timeLabelWidth);
        selectedResource =
            widget.calendar.dataSource!.resources![_selectedResourceIndex];
      }

      final int previousSelectedResourceIndex =
          _selectionPainter!.selectedResourceIndex;
      _selectionPainter!.selectedResourceIndex = _selectedResourceIndex;

      if (_isRTL) {
        xPosition = _scrollController!.offset +
            (_scrollController!.position.viewportDimension - xDetails);
        xPosition = (_scrollController!.position.viewportDimension +
                _scrollController!.position.maxScrollExtent) -
            xPosition;
      }

      final AppointmentView? appointmentView =
          _appointmentLayout.getAppointmentViewOnPoint(xPosition, yPosition);
      if (appointmentView == null) {
        _drawSelection(xDetails, yPosition, timeLabelWidth);
        selectedDate = _selectionPainter!.selectedDate;
      } else {
        if (selectedDate != null) {
          selectedDate = null;
          _selectionPainter!.selectedDate = selectedDate;
          _updateCalendarStateDetails.selectedDate = selectedDate;
        }

        _selectionPainter!.appointmentView = appointmentView;
        _selectionNotifier.value = !_selectionNotifier.value;
      }

      widget.updateCalendarState(_updateCalendarStateDetails);
      final bool canRaiseTap =
          CalendarViewHelper.shouldRaiseCalendarTapCallback(
                  widget.calendar.onTap) &&
              isTapCallback;
      final bool canRaiseLongPress =
          CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
                  widget.calendar.onLongPress) &&
              !isTapCallback;
      final bool canRaiseSelectionChanged =
          CalendarViewHelper.shouldRaiseCalendarSelectionChangedCallback(
              widget.calendar.onSelectionChanged);

      if (canRaiseLongPress || canRaiseTap || canRaiseSelectionChanged) {
        final DateTime? selectedDate =
            _getDateFromPosition(xDetails, yDetails - viewHeaderHeight, 0);

        /// Restrict the tap/long press callback while interact after
        /// the timeslots.
        if (selectedDate == null) {
          return null;
        }

        final int timeInterval = CalendarViewHelper.getTimeInterval(
            widget.calendar.timeSlotViewSettings);
        if (appointmentView == null) {
          if (!CalendarViewHelper.isDateTimeWithInDateTimeRange(
                  widget.calendar.minDate,
                  widget.calendar.maxDate,
                  selectedDate,
                  timeInterval) ||
              (widget.view == CalendarView.timelineMonth &&
                  CalendarViewHelper.isDateInDateCollection(
                      widget.calendar.blackoutDates, selectedDate))) {
            return null;
          }

          /// Restrict the callback, while selected region as disabled
          /// [TimeRegion].
          if (!_isEnabledRegion(
              xDetails, selectedDate, _selectedResourceIndex)) {
            return null;
          }

          if (canRaiseTap) {
            CalendarViewHelper.raiseCalendarTapCallback(
                widget.calendar,
                selectedDate,
                null,
                CalendarElement.calendarCell,
                selectedResource);
          } else if (canRaiseLongPress) {
            CalendarViewHelper.raiseCalendarLongPressCallback(
                widget.calendar,
                selectedDate,
                null,
                CalendarElement.calendarCell,
                selectedResource);
          }
          _updatedSelectionChangedCallback(
              canRaiseSelectionChanged,
              previousSelectedDate,
              selectedResource,
              previousSelectedResourceIndex);
        } else {
          if (canRaiseTap) {
            CalendarViewHelper.raiseCalendarTapCallback(
                widget.calendar,
                selectedDate,
                <dynamic>[
                  CalendarViewHelper.getAppointmentDetail(
                      appointmentView.appointment!, widget.calendar.dataSource)
                ],
                CalendarElement.appointment,
                selectedResource);
          } else if (canRaiseLongPress) {
            CalendarViewHelper.raiseCalendarLongPressCallback(
                widget.calendar,
                selectedDate,
                <dynamic>[
                  CalendarViewHelper.getAppointmentDetail(
                      appointmentView.appointment!, widget.calendar.dataSource)
                ],
                CalendarElement.appointment,
                selectedResource);
          }
          _updatedSelectionChangedCallback(
              canRaiseSelectionChanged,
              previousSelectedDate,
              selectedResource,
              previousSelectedResourceIndex);
        }
      }

      return appointmentView;
    }
    return null;
  }

  void _updateAllDaySelection(AppointmentView? view, DateTime? date) {
    if (_allDaySelectionNotifier.value != null &&
        view == _allDaySelectionNotifier.value!.appointmentView &&
        isSameDate(date, _allDaySelectionNotifier.value!.selectedDate)) {
      return;
    }

    _allDaySelectionNotifier.value = SelectionDetails(view, date);
  }

  //// Handles the onTap callback for day view cells, all day panel, and view
  //// header of day.
  void _handleOnTapForDay(TapUpDetails details) {
    _handleTouchOnDayView(details, null);
  }

  /// Get the calendar details for day, week work week views.
  CalendarDetails? _getDetailsForDay(Offset position) {
    final double xDetails = position.dx;
    final double yDetails = position.dy;

    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);

    final double viewHeaderHeight = isDayView
        ? 0
        : CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view);
    final double allDayHeight = _isExpanded
        ? _updateCalendarStateDetails.allDayPanelHeight
        : _allDayHeight;
    // time ruler position on time slot scroll view.
    if (!_isRTL &&
        xDetails <= timeLabelWidth &&
        yDetails > viewHeaderHeight + allDayHeight) {
      /// Return null while the [getCalendarDetailsAtOffset] position placed
      /// on time ruler position.
      return null;
    }

    // In RTL, time ruler position on time slot scroll view.
    if (_isRTL &&
        xDetails >= widget.width - timeLabelWidth &&
        yDetails > viewHeaderHeight + allDayHeight) {
      /// Return null while the [getCalendarDetailsAtOffset] position placed
      /// on time ruler position in RTL.
      return null;
    }

    if (yDetails < viewHeaderHeight) {
      // week, workweek view header because view header height variable value is
      // 0 on day view.
      if ((!_isRTL && xDetails <= timeLabelWidth) ||
          (_isRTL && widget.width - xDetails <= timeLabelWidth)) {
        // Return null while the [getCalendarDetailsAtOffset] position placed on
        // week number in view header.
        return null;
      }

      /// Return calendar details while the [getCalendarDetailsAtOffset]
      /// position placed on view header in week and work week view.
      return CalendarDetails(
          null,
          _getTappedViewHeaderDate(position, widget.width),
          CalendarElement.viewHeader,
          null);
    } else if (yDetails < viewHeaderHeight + allDayHeight) {
      /// Check the position in view header when [CalendarView] is day
      /// If RTL, view header placed at right side,
      /// else view header placed at left side.
      if (isDayView &&
          ((!_isRTL && xDetails <= timeLabelWidth) ||
              (_isRTL && widget.width - xDetails <= timeLabelWidth)) &&
          yDetails <
              CalendarViewHelper.getViewHeaderHeight(
                  widget.calendar.viewHeaderHeight, widget.view)) {
        /// Return calendar details while the [getCalendarDetailsAtOffset]
        /// position placed on view header in day view.
        return CalendarDetails(
            null,
            _getTappedViewHeaderDate(position, widget.width),
            CalendarElement.viewHeader,
            null);
      } else if ((!_isRTL && timeLabelWidth >= xDetails) ||
          (_isRTL && xDetails > widget.width - timeLabelWidth)) {
        /// Return null while the [getCalendarDetailsAtOffset] position placed
        /// on expander icon in all day panel.
        return null;
      }

      final double yPosition = yDetails - viewHeaderHeight;
      final AppointmentView? appointmentView = _getAllDayAppointmentOnPoint(
          _updateCalendarStateDetails.allDayAppointmentViewCollection,
          xDetails,
          yPosition);

      /// Check the count position tapped or not
      bool isTappedOnCount = appointmentView != null &&
          _updateCalendarStateDetails.allDayPanelHeight > allDayHeight &&
          yPosition > allDayHeight - kAllDayAppointmentHeight;
      DateTime? selectedDate;
      if (appointmentView == null || isTappedOnCount) {
        selectedDate = _getTappedViewHeaderDate(position, widget.width);
      }

      List<CalendarAppointment>? moreRegionAppointments;
      // Expand and collapsed the all day panel creates all the appointment
      // views including the hidden appointment. In that case, is tapped count
      // boolean property sets true.
      if (isTappedOnCount && selectedDate != null) {
        final int currentSelectedIndex = DateTimeHelper.getVisibleDateIndex(
            widget.visibleDates, selectedDate);
        if (currentSelectedIndex != -1) {
          moreRegionAppointments = <CalendarAppointment>[];
          for (int i = 0;
              i <
                  _updateCalendarStateDetails
                      .allDayAppointmentViewCollection.length;
              i++) {
            final AppointmentView currentView =
                _updateCalendarStateDetails.allDayAppointmentViewCollection[i];
            if (currentView.appointment == null) {
              continue;
            }

            if (currentView.startIndex <= currentSelectedIndex &&
                currentView.endIndex > currentSelectedIndex) {
              moreRegionAppointments.add(currentView.appointment!);
            }
          }
        }
      }

      /// Check the tap position inside the last appointment rendering position
      /// when the panel as collapsed and it does not position does not have
      /// appointment.
      /// Eg., If July 8 have 3 all day appointments spanned to July 9 and
      /// July 9 have 1 all day appointment spanned to July 10 then July 10
      /// appointment view does not shown and it only have count label.
      /// If user tap on count label then the panel does not have appointment
      /// view, because the view rendered after the end position, so calculate
      /// the visible date cell appointment and it have appointments after
      /// end position then perform expand operation.
      if (appointmentView == null &&
          selectedDate != null &&
          _updateCalendarStateDetails.allDayPanelHeight > allDayHeight &&
          yPosition > allDayHeight - kAllDayAppointmentHeight) {
        final int currentSelectedIndex = DateTimeHelper.getVisibleDateIndex(
            widget.visibleDates, selectedDate);
        if (currentSelectedIndex != -1) {
          moreRegionAppointments = <CalendarAppointment>[];
          final List<AppointmentView> selectedIndexAppointment =
              <AppointmentView>[];
          for (int i = 0;
              i <
                  _updateCalendarStateDetails
                      .allDayAppointmentViewCollection.length;
              i++) {
            final AppointmentView currentView =
                _updateCalendarStateDetails.allDayAppointmentViewCollection[i];
            if (currentView.appointment == null) {
              continue;
            }

            if (currentView.startIndex <= currentSelectedIndex &&
                currentView.endIndex > currentSelectedIndex) {
              selectedIndexAppointment.add(currentView);
              moreRegionAppointments.add(currentView.appointment!);
            }
          }

          int maxPosition = 0;
          if (selectedIndexAppointment.isNotEmpty) {
            maxPosition = selectedIndexAppointment
                .reduce((AppointmentView currentAppView,
                        AppointmentView nextAppView) =>
                    currentAppView.maxPositions > nextAppView.maxPositions
                        ? currentAppView
                        : nextAppView)
                .maxPositions;
          }
          final int endAppointmentPosition =
              allDayHeight ~/ kAllDayAppointmentHeight;
          if (endAppointmentPosition < maxPosition) {
            isTappedOnCount = true;
          }
        }
      }

      if (appointmentView != null &&
          (yPosition < allDayHeight - kAllDayAppointmentHeight ||
              _updateCalendarStateDetails.allDayPanelHeight <= allDayHeight ||
              appointmentView.position + 1 >= appointmentView.maxPositions)) {
        final List<dynamic> appointmentDetails = <dynamic>[
          CalendarViewHelper.getAppointmentDetail(
              appointmentView.appointment!, widget.calendar.dataSource)
        ];

        /// Return calendar details while the [getCalendarDetailsAtOffset]
        /// position placed on appointments in day, week and workweek view.
        return CalendarDetails(
            appointmentDetails, null, CalendarElement.appointment, null);
      } else if (isTappedOnCount) {
        /// Return calendar details while the [getCalendarDetailsAtOffset]
        /// position placed on more appointment region in day, week and workweek
        /// view.
        return CalendarDetails(
            widget.calendar.dataSource != null &&
                    !AppointmentHelper.isCalendarAppointment(
                        widget.calendar.dataSource!)
                ? CalendarViewHelper.getCustomAppointments(
                    moreRegionAppointments, widget.calendar.dataSource)
                : moreRegionAppointments,
            selectedDate,
            CalendarElement.moreAppointmentRegion,
            null);
      } else if (appointmentView == null) {
        /// Return calendar details while the [getCalendarDetailsAtOffset]
        /// position placed on all day panel in day, week and work week view.
        return CalendarDetails(
            null, selectedDate, CalendarElement.allDayPanel, null);
      }

      return null;
    }

    double yPosition =
        yDetails - viewHeaderHeight - allDayHeight + _scrollController!.offset;
    final AppointmentView? appointmentView =
        _appointmentLayout.getAppointmentViewOnPoint(xDetails, yPosition);

    if (appointmentView == null) {
      /// Remove the scroll position for internally handles the scroll position
      /// in _getDateFromPosition method
      yPosition = yPosition - _scrollController!.offset;
      final DateTime? selectedDate = _getDateFromPosition(
          !_isRTL ? xDetails - timeLabelWidth : xDetails,
          yPosition,
          timeLabelWidth);

      /// Return calendar details while the [getCalendarDetailsAtOffset]
      /// position placed on calendar cell in day, week and work week view.
      return CalendarDetails(
          null, selectedDate, CalendarElement.calendarCell, null);
    } else {
      final List<dynamic> appointmentDetails = <dynamic>[
        CalendarViewHelper.getAppointmentDetail(
            appointmentView.appointment!, widget.calendar.dataSource)
      ];

      /// Return calendar details while the [getCalendarDetailsAtOffset]
      /// position placed on appointments in day, week and work week view.
      return CalendarDetails(
          appointmentDetails, null, CalendarElement.appointment, null);
    }
  }

  /// Handles the tap and long press related functions for day, week
  /// work week views.
  AppointmentView? _handleTouchOnDayView(
      TapUpDetails? tapDetails, LongPressStartDetails? longPressDetails) {
    widget.removePicker();
    final DateTime? previousSelectedDate = _selectionPainter!.selectedDate;
    final int timeInterval = CalendarViewHelper.getTimeInterval(
        widget.calendar.timeSlotViewSettings);
    double xDetails = 0, yDetails = 0;
    bool isTappedCallback = false;
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    if (tapDetails != null) {
      isTappedCallback = true;
      xDetails = tapDetails.localPosition.dx;
      yDetails = tapDetails.localPosition.dy;
    } else if (longPressDetails != null) {
      xDetails = longPressDetails.localPosition.dx;
      yDetails = longPressDetails.localPosition.dy;
    }
    if (!widget.focusNode.hasFocus) {
      widget.focusNode.requestFocus();
    }

    widget.getCalendarState(_updateCalendarStateDetails);
    AppointmentView? selectedAppointmentView;
    dynamic selectedAppointment;
    List<dynamic>? selectedAppointments;
    CalendarElement targetElement = CalendarElement.viewHeader;
    DateTime? selectedDate = _updateCalendarStateDetails.selectedDate;
    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);

    final double viewHeaderHeight = isDayView
        ? 0
        : CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view);
    final double allDayHeight = _isExpanded
        ? _updateCalendarStateDetails.allDayPanelHeight
        : _allDayHeight;
    if (!_isRTL &&
        xDetails <= timeLabelWidth &&
        yDetails > viewHeaderHeight + allDayHeight) {
      return null;
    }

    if (_isRTL &&
        xDetails >= widget.width - timeLabelWidth &&
        yDetails > viewHeaderHeight + allDayHeight) {
      return null;
    }

    if (yDetails < viewHeaderHeight) {
      /// Check the touch position in time ruler view
      /// If RTL, time ruler placed at right side,
      /// else time ruler placed at left side.
      if ((!_isRTL && xDetails <= timeLabelWidth) ||
          (_isRTL && widget.width - xDetails <= timeLabelWidth)) {
        return null;
      }

      if (isTappedCallback) {
        _handleOnTapForViewHeader(tapDetails!, widget.width);
      } else if (!isTappedCallback) {
        _handleOnLongPressForViewHeader(longPressDetails!, widget.width);
      }

      return null;
    } else if (yDetails < viewHeaderHeight + allDayHeight) {
      /// Check the touch position in view header when [CalendarView] is day
      /// If RTL, view header placed at right side,
      /// else view header placed at left side.
      if (isDayView &&
          ((!_isRTL && xDetails <= timeLabelWidth) ||
              (_isRTL && widget.width - xDetails <= timeLabelWidth)) &&
          yDetails <
              CalendarViewHelper.getViewHeaderHeight(
                  widget.calendar.viewHeaderHeight, widget.view)) {
        if (isTappedCallback) {
          _handleOnTapForViewHeader(tapDetails!, widget.width);
        } else if (!isTappedCallback) {
          _handleOnLongPressForViewHeader(longPressDetails!, widget.width);
        }

        return null;
      } else if ((!_isRTL && timeLabelWidth >= xDetails) ||
          (_isRTL && xDetails > widget.width - timeLabelWidth)) {
        /// Perform expand or collapse when the touch position on
        /// expander icon in all day panel.
        _expandOrCollapseAllDay();
        return null;
      }

      final double yPosition = yDetails - viewHeaderHeight;
      final AppointmentView? appointmentView = _getAllDayAppointmentOnPoint(
          _updateCalendarStateDetails.allDayAppointmentViewCollection,
          xDetails,
          yPosition);

      if (appointmentView == null) {
        targetElement = CalendarElement.allDayPanel;
        if (isTappedCallback) {
          selectedDate =
              _getTappedViewHeaderDate(tapDetails!.localPosition, widget.width);
        } else {
          selectedDate = _getTappedViewHeaderDate(
              longPressDetails!.localPosition, widget.width);
        }
      }

      /// Check the count position tapped or not
      bool isTappedOnCount = appointmentView != null &&
          _updateCalendarStateDetails.allDayPanelHeight > allDayHeight &&
          yPosition > allDayHeight - kAllDayAppointmentHeight;

      /// Check the tap position inside the last appointment rendering position
      /// when the panel as collapsed and it does not position does not have
      /// appointment.
      /// Eg., If July 8 have 3 all day appointments spanned to July 9 and
      /// July 9 have 1 all day appointment spanned to July 10 then July 10
      /// appointment view does not shown and it only have count label.
      /// If user tap on count label then the panel does not have appointment
      /// view, because the view rendered after the end position, so calculate
      /// the visible date cell appointment and it have appointments after
      /// end position then perform expand operation.
      if (appointmentView == null &&
          selectedDate != null &&
          _updateCalendarStateDetails.allDayPanelHeight > allDayHeight &&
          yPosition > allDayHeight - kAllDayAppointmentHeight) {
        final int currentSelectedIndex = DateTimeHelper.getVisibleDateIndex(
            widget.visibleDates, selectedDate);
        if (currentSelectedIndex != -1) {
          final List<AppointmentView> selectedIndexAppointment =
              <AppointmentView>[];
          for (int i = 0;
              i <
                  _updateCalendarStateDetails
                      .allDayAppointmentViewCollection.length;
              i++) {
            final AppointmentView currentView =
                _updateCalendarStateDetails.allDayAppointmentViewCollection[i];
            if (currentView.appointment == null) {
              continue;
            }
            if (currentView.startIndex <= currentSelectedIndex &&
                currentView.endIndex > currentSelectedIndex) {
              selectedIndexAppointment.add(currentView);
            }
          }

          int maxPosition = 0;
          if (selectedIndexAppointment.isNotEmpty) {
            maxPosition = selectedIndexAppointment
                .reduce((AppointmentView currentAppView,
                        AppointmentView nextAppView) =>
                    currentAppView.maxPositions > nextAppView.maxPositions
                        ? currentAppView
                        : nextAppView)
                .maxPositions;
          }
          final int endAppointmentPosition =
              allDayHeight ~/ kAllDayAppointmentHeight;
          if (endAppointmentPosition < maxPosition) {
            isTappedOnCount = true;
          }
        }
      }

      if (appointmentView != null &&
          (yPosition < allDayHeight - kAllDayAppointmentHeight ||
              _updateCalendarStateDetails.allDayPanelHeight <= allDayHeight ||
              appointmentView.position + 1 >= appointmentView.maxPositions)) {
        if ((!CalendarViewHelper.isDateTimeWithInDateTimeRange(
                    widget.calendar.minDate,
                    widget.calendar.maxDate,
                    appointmentView.appointment!.actualStartTime,
                    timeInterval) ||
                !CalendarViewHelper.isDateTimeWithInDateTimeRange(
                    widget.calendar.minDate,
                    widget.calendar.maxDate,
                    appointmentView.appointment!.actualEndTime,
                    timeInterval)) &&
            !appointmentView.appointment!.isSpanned) {
          return null;
        }
        if (selectedDate != null) {
          selectedDate = null;
          _selectionPainter!.selectedDate = selectedDate;
          _updateCalendarStateDetails.selectedDate = selectedDate;
        }

        _selectionPainter!.appointmentView = null;
        _selectionNotifier.value = !_selectionNotifier.value;
        selectedAppointment = appointmentView.appointment;
        selectedAppointments = null;
        targetElement = CalendarElement.appointment;
        _updateAllDaySelection(appointmentView, null);
      } else if (isTappedOnCount) {
        _expandOrCollapseAllDay();
        return null;
      } else if (appointmentView == null) {
        _updateAllDaySelection(null, selectedDate);
        _selectionPainter!.selectedDate = null;
        _selectionPainter!.appointmentView = null;
        _selectionNotifier.value = !_selectionNotifier.value;
        _updateCalendarStateDetails.selectedDate = null;
      }

      selectedAppointmentView = appointmentView;
    } else {
      final double yPosition = yDetails -
          viewHeaderHeight -
          allDayHeight +
          _scrollController!.offset;
      final AppointmentView? appointmentView =
          _appointmentLayout.getAppointmentViewOnPoint(xDetails, yPosition);
      _allDaySelectionNotifier.value = null;
      if (appointmentView == null) {
        if (_isRTL) {
          _drawSelection(xDetails, yDetails - viewHeaderHeight - allDayHeight,
              timeLabelWidth);
        } else {
          _drawSelection(xDetails - timeLabelWidth,
              yDetails - viewHeaderHeight - allDayHeight, timeLabelWidth);
        }
        targetElement = CalendarElement.calendarCell;
      } else {
        if (selectedDate != null) {
          selectedDate = null;
          _selectionPainter!.selectedDate = selectedDate;
          _updateCalendarStateDetails.selectedDate = selectedDate;
        }

        _selectionPainter!.appointmentView = appointmentView;
        _selectionNotifier.value = !_selectionNotifier.value;
        selectedAppointmentView = appointmentView;
        selectedAppointment = appointmentView.appointment;
        targetElement = CalendarElement.appointment;
      }
    }

    widget.updateCalendarState(_updateCalendarStateDetails);
    final bool canRaiseTap = CalendarViewHelper.shouldRaiseCalendarTapCallback(
            widget.calendar.onTap) &&
        isTappedCallback;
    final bool canRaiseLongPress =
        CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
                widget.calendar.onLongPress) &&
            !isTappedCallback;
    final bool canRaiseSelectionChanged =
        CalendarViewHelper.shouldRaiseCalendarSelectionChangedCallback(
            widget.calendar.onSelectionChanged);
    if (canRaiseLongPress || canRaiseTap || canRaiseSelectionChanged) {
      final double yPosition = yDetails - viewHeaderHeight - allDayHeight;
      if (_selectionPainter!.selectedDate != null &&
          targetElement != CalendarElement.allDayPanel) {
        selectedAppointments = null;

        /// In LTR, remove the time ruler width value from the
        /// touch x position while calculate the selected date value.
        selectedDate = _getDateFromPosition(
            !_isRTL ? xDetails - timeLabelWidth : xDetails,
            yPosition,
            timeLabelWidth);

        /// Restrict the tap/long press callback while interact after
        /// the timeslots.
        if (selectedDate == null) {
          return null;
        }

        if (!CalendarViewHelper.isDateTimeWithInDateTimeRange(
            widget.calendar.minDate,
            widget.calendar.maxDate,
            selectedDate,
            timeInterval)) {
          return null;
        }

        /// Restrict the callback, while selected region as disabled
        /// [TimeRegion].
        if (targetElement == CalendarElement.calendarCell &&
            !_isEnabledRegion(
                yPosition, selectedDate, _selectedResourceIndex)) {
          return null;
        }

        if (canRaiseTap) {
          CalendarViewHelper.raiseCalendarTapCallback(
              widget.calendar,
              _selectionPainter!.selectedDate,
              selectedAppointments,
              targetElement,
              null);
        } else if (canRaiseLongPress) {
          CalendarViewHelper.raiseCalendarLongPressCallback(
              widget.calendar,
              _selectionPainter!.selectedDate,
              selectedAppointments,
              targetElement,
              null);
        }
        _updatedSelectionChangedCallback(
            canRaiseSelectionChanged, previousSelectedDate);
      } else if (selectedAppointment != null) {
        selectedAppointments = <dynamic>[
          CalendarViewHelper.getAppointmentDetail(
              selectedAppointment, widget.calendar.dataSource)
        ];

        /// In LTR, remove the time ruler width value from the
        /// touch x position while calculate the selected date value.
        selectedDate = _getDateFromPosition(
            !_isRTL ? xDetails - timeLabelWidth : xDetails,
            yPosition,
            timeLabelWidth);

        if (canRaiseTap) {
          CalendarViewHelper.raiseCalendarTapCallback(
              widget.calendar,
              selectedDate,
              selectedAppointments,
              CalendarElement.appointment,
              null);
        } else if (canRaiseLongPress) {
          CalendarViewHelper.raiseCalendarLongPressCallback(
              widget.calendar,
              selectedDate,
              selectedAppointments,
              CalendarElement.appointment,
              null);
        }
        _updatedSelectionChangedCallback(
            canRaiseSelectionChanged, previousSelectedDate);
      } else if (selectedDate != null &&
          targetElement == CalendarElement.allDayPanel) {
        if (canRaiseTap) {
          CalendarViewHelper.raiseCalendarTapCallback(
              widget.calendar, selectedDate, null, targetElement, null);
        } else if (canRaiseLongPress) {
          CalendarViewHelper.raiseCalendarLongPressCallback(
              widget.calendar, selectedDate, null, targetElement, null);
        }
        _updatedSelectionChangedCallback(
            canRaiseSelectionChanged, previousSelectedDate);
      }
    }

    return selectedAppointmentView;
  }

  /// Check the selected date region as enabled time region or not.
  bool _isEnabledRegion(double y, DateTime? selectedDate, int resourceIndex) {
    if (widget.regions == null ||
        widget.regions!.isEmpty ||
        widget.view == CalendarView.month ||
        widget.view == CalendarView.timelineMonth ||
        selectedDate == null) {
      return true;
    }

    final double timeIntervalSize = _getTimeIntervalHeight(
        widget.calendar,
        widget.view,
        widget.width,
        widget.height,
        widget.visibleDates.length,
        widget.isMobilePlatform);

    final double minuteHeight = timeIntervalSize /
        CalendarViewHelper.getTimeInterval(
            widget.calendar.timeSlotViewSettings);
    final Duration startDuration = Duration(
        hours: widget.calendar.timeSlotViewSettings.startHour.toInt(),
        minutes: ((widget.calendar.timeSlotViewSettings.startHour -
                    widget.calendar.timeSlotViewSettings.startHour.toInt()) *
                60)
            .toInt());
    int minutes;
    if (CalendarViewHelper.isTimelineView(widget.view)) {
      final double viewWidth = _timeIntervalHeight * _horizontalLinesCount!;
      if (_isRTL) {
        minutes = ((_scrollController!.offset +
                    (_scrollController!.position.viewportDimension - y)) %
                viewWidth) ~/
            minuteHeight;
      } else {
        minutes = ((_scrollController!.offset + y) % viewWidth) ~/ minuteHeight;
      }
    } else {
      minutes = (_scrollController!.offset + y) ~/ minuteHeight;
    }

    final DateTime date = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, 0, minutes + startDuration.inMinutes);
    bool isValidRegion = true;
    final bool isResourcesEnabled = CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view);
    for (int i = 0; i < widget.regions!.length; i++) {
      final CalendarTimeRegion region = widget.regions![i];
      if (region.actualStartTime.isAfter(date) ||
          region.actualEndTime.isBefore(date)) {
        continue;
      }

      /// Condition added ensure that the region is disabled only on the
      /// specified resource slot, for other resources it must be enabled.
      if (isResourcesEnabled &&
          resourceIndex != -1 &&
          region.resourceIds != null &&
          region.resourceIds!.isNotEmpty &&
          !region.resourceIds!
              .contains(widget.resourceCollection![resourceIndex].id)) {
        continue;
      }

      isValidRegion = region.enablePointerInteraction;
    }

    return isValidRegion;
  }

  bool _isAutoTimeIntervalHeight(SfCalendar calendar, bool isTimelineView) {
    if (isTimelineView) {
      return calendar.timeSlotViewSettings.timeIntervalWidth == -1;
    }

    return calendar.timeSlotViewSettings.timeIntervalHeight == -1;
  }

  /// Returns the default time interval width for timeline views.
  double _getTimeIntervalWidth(double timeIntervalHeight, CalendarView view,
      double width, bool isMobilePlatform) {
    if (timeIntervalHeight >= 0) {
      return timeIntervalHeight;
    }

    if (view == CalendarView.timelineMonth &&
        !CalendarViewHelper.isMobileLayoutUI(width, isMobilePlatform)) {
      return 160;
    }

    return 60;
  }

  /// Returns the time interval width based on property value, also arrange the
  /// time slots into the view port size.
  double _getTimeIntervalHeight(
      SfCalendar calendar,
      CalendarView view,
      double width,
      double height,
      int visibleDatesCount,
      bool isMobilePlatform) {
    final bool isTimelineView = CalendarViewHelper.isTimelineView(view);
    final bool isDayView = CalendarViewHelper.isDayView(
        view,
        calendar.timeSlotViewSettings.numberOfDaysInView,
        calendar.timeSlotViewSettings.nonWorkingDays,
        calendar.monthViewSettings.numberOfWeeksInView);
    double timeIntervalHeight = isTimelineView
        ? _getTimeIntervalWidth(calendar.timeSlotViewSettings.timeIntervalWidth,
            view, width, isMobilePlatform)
        : calendar.timeSlotViewSettings.timeIntervalHeight;

    if (!_isAutoTimeIntervalHeight(calendar, isTimelineView)) {
      return timeIntervalHeight;
    }

    double viewHeaderHeight =
        CalendarViewHelper.getViewHeaderHeight(calendar.viewHeaderHeight, view);

    double allDayViewHeight = 0;

    final bool isCurrentView =
        _updateCalendarStateDetails.currentViewVisibleDates ==
            widget.visibleDates;
    if (isDayView) {
      if (isCurrentView) {
        allDayViewHeight = _kAllDayLayoutHeight > viewHeaderHeight &&
                _updateCalendarStateDetails.allDayPanelHeight > viewHeaderHeight
            ? _updateCalendarStateDetails.allDayPanelHeight >
                    _kAllDayLayoutHeight
                ? _kAllDayLayoutHeight
                : _updateCalendarStateDetails.allDayPanelHeight
            : viewHeaderHeight;
        if (allDayViewHeight < _updateCalendarStateDetails.allDayPanelHeight) {
          allDayViewHeight += kAllDayAppointmentHeight;
        }
      } else {
        allDayViewHeight = viewHeaderHeight;
      }

      viewHeaderHeight = 0;
    } else if (isCurrentView) {
      allDayViewHeight =
          _updateCalendarStateDetails.allDayPanelHeight > _kAllDayLayoutHeight
              ? _kAllDayLayoutHeight
              : _updateCalendarStateDetails.allDayPanelHeight;
    }

    switch (view) {
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        timeIntervalHeight = (height - allDayViewHeight - viewHeaderHeight) /
            CalendarViewHelper.getHorizontalLinesCount(
                calendar.timeSlotViewSettings, view);
        break;
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
        {
          final double horizontalLinesCount =
              CalendarViewHelper.getHorizontalLinesCount(
                  calendar.timeSlotViewSettings, view);
          timeIntervalHeight =
              width / (horizontalLinesCount * visibleDatesCount);
          if (!_isValidWidth(
              width, calendar, visibleDatesCount, horizontalLinesCount)) {
            /// we have used 40 as a default time interval height for timeline
            /// view when the time interval height set for auto time
            /// interval height.
            timeIntervalHeight = 40;
          }
        }
        break;
      case CalendarView.schedule:
      case CalendarView.month:
        return 0;
    }

    return timeIntervalHeight;
  }

  /// checks whether the width can afford the line count or else creates a
  /// scrollable width
  bool _isValidWidth(double screenWidth, SfCalendar calendar,
      int visibleDatesCount, double horizontalLinesCount) {
    const int offSetValue = 10;
    final double tempWidth =
        visibleDatesCount * offSetValue * horizontalLinesCount;

    if (tempWidth < screenWidth) {
      return true;
    }

    return false;
  }

  //// Handles the on tap callback for view header
  void _handleOnTapForViewHeader(TapUpDetails details, double width) {
    final DateTime tappedDate =
        _getTappedViewHeaderDate(details.localPosition, width)!;
    _handleViewHeaderTapNavigation(tappedDate);
    if (!CalendarViewHelper.shouldRaiseCalendarTapCallback(
        widget.calendar.onTap)) {
      return;
    }

    CalendarViewHelper.raiseCalendarTapCallback(
        widget.calendar, tappedDate, null, CalendarElement.viewHeader, null);
  }

  //// Handles the on long press callback for view header
  void _handleOnLongPressForViewHeader(
      LongPressStartDetails details, double width) {
    final DateTime tappedDate =
        _getTappedViewHeaderDate(details.localPosition, width)!;
    _handleViewHeaderTapNavigation(tappedDate);
    if (!CalendarViewHelper.shouldRaiseCalendarLongPressCallback(
        widget.calendar.onLongPress)) {
      return;
    }

    CalendarViewHelper.raiseCalendarLongPressCallback(
        widget.calendar, tappedDate, null, CalendarElement.viewHeader, null);
  }

  void _handleViewHeaderTapNavigation(DateTime date) {
    if (!widget.allowViewNavigation ||
        widget.view == CalendarView.day ||
        widget.view == CalendarView.timelineDay ||
        widget.view == CalendarView.month) {
      return;
    }

    if (!isDateWithInDateRange(
            widget.calendar.minDate, widget.calendar.maxDate, date) ||
        (widget.controller.view == CalendarView.timelineMonth &&
            CalendarViewHelper.isDateInDateCollection(
                widget.blackoutDates, date))) {
      return;
    }

    if (widget.view == CalendarView.week ||
        widget.view == CalendarView.workWeek) {
      widget.controller.view = CalendarView.day;
    } else {
      widget.controller.view = CalendarView.timelineDay;
    }

    widget.controller.displayDate = date;
  }

  DateTime? _getTappedViewHeaderDate(Offset localPosition, double width) {
    int index = 0;
    final double timeLabelViewWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    final int visibleDatesLength = widget.visibleDates.length;
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);
    if (!CalendarViewHelper.isTimelineView(widget.view)) {
      double cellWidth = 0;
      if (widget.view != CalendarView.month) {
        cellWidth = (width - timeLabelViewWidth) / visibleDatesLength;

        /// Set index value as 0 when calendar view as day because day view hold
        /// single visible date.
        if (isDayView) {
          index = 0;
        } else {
          index = ((localPosition.dx - (_isRTL ? 0 : timeLabelViewWidth)) /
                  cellWidth)
              .truncate();
        }
      } else {
        cellWidth = width / DateTime.daysPerWeek;
        index = (localPosition.dx / cellWidth).truncate();
      }

      /// Calculate the RTL based value of index when the widget direction as
      /// RTL.
      if (_isRTL && widget.view != CalendarView.month) {
        index = visibleDatesLength - index - 1;
      } else if (_isRTL && widget.view == CalendarView.month) {
        index = DateTime.daysPerWeek - index - 1;
      }

      if (index < 0 || index >= visibleDatesLength) {
        return null;
      }

      return widget.visibleDates[index];
    } else {
      index = ((_scrollController!.offset +
                  (_isRTL
                      ? _scrollController!.position.viewportDimension -
                          localPosition.dx
                      : localPosition.dx)) /
              _getSingleViewWidthForTimeLineView(this))
          .truncate();

      if (index < 0 || index >= visibleDatesLength) {
        return null;
      }

      return widget.visibleDates[index];
    }
  }

  void _updateHoveringForAppointment(double xPosition, double yPosition) {
    if (_viewHeaderNotifier.value != null) {
      _viewHeaderNotifier.value = null;
    }

    if (_calendarCellNotifier.value != null) {
      _calendarCellNotifier.value = null;
    }

    if (_allDayNotifier.value != null) {
      _allDayNotifier.value = null;
      if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }
    }

    if (_hoveringDate != null) {
      _hoveringDate = null;
    }

    _appointmentHoverNotifier.value = Offset(xPosition, yPosition);
  }

  void _updateHoveringForAllDayPanel(double xPosition, double yPosition) {
    if (_viewHeaderNotifier.value != null) {
      _viewHeaderNotifier.value = null;
    }

    if (_calendarCellNotifier.value != null) {
      _hoveringDate = null;
      _calendarCellNotifier.value = null;
    }

    if (_appointmentHoverNotifier.value != null) {
      _appointmentHoverNotifier.value = null;
      if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }
    }

    if (_hoveringDate != null) {
      _hoveringDate = null;
    }

    _allDayNotifier.value = Offset(xPosition, yPosition);
  }

  /// Removes the view header hovering in multiple occasions, when the pointer
  /// hovering the disabled or blackout dates, and when the pointer moves out
  /// of the view header.
  void _removeViewHeaderHovering() {
    if (_hoveringDate != null) {
      _hoveringDate = null;
    }

    if (_viewHeaderNotifier.value != null) {
      _viewHeaderNotifier.value = null;
    }
  }

  void _removeAllWidgetHovering() {
    if (_hoveringDate != null) {
      _hoveringDate = null;
    }

    if (_viewHeaderNotifier.value != null) {
      _viewHeaderNotifier.value = null;
    }

    if (_calendarCellNotifier.value != null) {
      _hoveringDate = null;
      _calendarCellNotifier.value = null;
    }

    if (_allDayNotifier.value != null) {
      _allDayNotifier.value = null;
      _hoveringAppointmentView = null;
      if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }
    }

    if (_appointmentHoverNotifier.value != null) {
      _appointmentHoverNotifier.value = null;
      _hoveringAppointmentView = null;
      if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }
    }
  }

  void _updateHoveringForViewHeader(Offset localPosition, double xPosition,
      double yPosition, double viewHeaderHeight) {
    if (widget.calendar.onTap == null && widget.calendar.onLongPress == null) {
      final bool isViewNavigationEnabled =
          widget.calendar.allowViewNavigation &&
              widget.view != CalendarView.month &&
              widget.view != CalendarView.day &&
              widget.view != CalendarView.timelineDay;
      if (!isViewNavigationEnabled) {
        _removeAllWidgetHovering();
        return;
      }
    }

    if (yPosition < 0) {
      if (_hoveringDate != null) {
        _hoveringDate = null;
      }

      if (_viewHeaderNotifier.value != null) {
        _viewHeaderNotifier.value = null;
      }

      if (_calendarCellNotifier.value != null) {
        _calendarCellNotifier.value = null;
      }

      if (_allDayNotifier.value != null) {
        _allDayNotifier.value = null;
        _hoveringAppointmentView = null;
        if (_mouseCursor != SystemMouseCursors.basic) {
          setState(() {
            _mouseCursor = SystemMouseCursors.basic;
          });
        }
      }

      if (_appointmentHoverNotifier.value != null) {
        _appointmentHoverNotifier.value = null;
        _hoveringAppointmentView = null;
        if (_mouseCursor != SystemMouseCursors.basic) {
          setState(() {
            _mouseCursor = SystemMouseCursors.basic;
          });
        }
      }
    }

    final DateTime? hoverDate = _getTappedViewHeaderDate(
        Offset(
            CalendarViewHelper.isTimelineView(widget.view)
                ? localPosition.dx
                : xPosition,
            yPosition),
        widget.width);

    // Remove the hovering when the position not in cell regions.
    if (hoverDate == null) {
      _removeViewHeaderHovering();

      return;
    }

    if (!isDateWithInDateRange(
        widget.calendar.minDate, widget.calendar.maxDate, hoverDate)) {
      _removeViewHeaderHovering();

      return;
    }

    if (widget.view == CalendarView.timelineMonth &&
        CalendarViewHelper.isDateInDateCollection(
            widget.blackoutDates, hoverDate)) {
      _removeViewHeaderHovering();

      return;
    }

    _hoveringDate = hoverDate;

    if (_calendarCellNotifier.value != null) {
      _calendarCellNotifier.value = null;
    }

    if (_allDayNotifier.value != null) {
      _allDayNotifier.value = null;
      _hoveringAppointmentView = null;
      if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }
    }

    if (_appointmentHoverNotifier.value != null) {
      _appointmentHoverNotifier.value = null;
      _hoveringAppointmentView = null;
      if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }
    }

    _viewHeaderNotifier.value = Offset(xPosition, yPosition);
  }

  void _updateDraggingMouseCursor(bool isDragging) {
    if (_mouseCursor != SystemMouseCursors.move && isDragging) {
      setState(() {
        _mouseCursor = SystemMouseCursors.move;
      });
    } else if (!isDragging && _mouseCursor != SystemMouseCursors.basic) {
      setState(() {
        _mouseCursor = SystemMouseCursors.basic;
      });
    }
  }

  void _updateDisabledCellMouseCursor(bool isDisabled) {
    if (isDisabled && _mouseCursor != SystemMouseCursors.noDrop) {
      setState(() {
        _mouseCursor = SystemMouseCursors.noDrop;
      });
    } else if (!isDisabled && _mouseCursor == SystemMouseCursors.noDrop) {
      setState(() {
        _mouseCursor = SystemMouseCursors.move;
      });
    }
  }

  void _updateMouseCursorForAppointment(AppointmentView? appointmentView,
      double xPosition, double yPosition, bool isTimelineViews,
      {bool isAllDayPanel = false}) {
    _hoveringAppointmentView = appointmentView;
    if (!widget.calendar.allowAppointmentResize ||
        (widget.view == CalendarView.month &&
            widget.calendar.monthViewSettings.appointmentDisplayMode !=
                MonthAppointmentDisplayMode.appointment)) {
      return;
    }

    if (appointmentView == null || appointmentView.appointment == null) {
      if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }

      return;
    }

    const double padding = 5;

    if (isAllDayPanel ||
        (widget.view == CalendarView.month || isTimelineViews)) {
      final bool isMonthView = widget.view == CalendarView.month ||
          widget.view == CalendarView.timelineMonth;
      final DateTime viewStartDate =
          AppointmentHelper.convertToStartTime(widget.visibleDates[0]);
      final DateTime viewEndDate = AppointmentHelper.convertToEndTime(
          widget.visibleDates[widget.visibleDates.length - 1]);
      final DateTime appStartTime = appointmentView.appointment!.exactStartTime;
      final DateTime appEndTime = appointmentView.appointment!.exactEndTime;

      final bool canAddForwardSpanIcon =
          AppointmentHelper.canAddForwardSpanIcon(
              appStartTime, appEndTime, viewStartDate, viewEndDate);
      final bool canAddBackwardSpanIcon =
          AppointmentHelper.canAddBackwardSpanIcon(
              appStartTime, appEndTime, viewStartDate, viewEndDate);

      final DateTime appointmentStartTime =
          appointmentView.appointment!.isAllDay
              ? AppointmentHelper.convertToStartTime(
                  appointmentView.appointment!.actualStartTime)
              : appointmentView.appointment!.actualStartTime;
      final DateTime appointmentEndTime = appointmentView.appointment!.isAllDay
          ? AppointmentHelper.convertToEndTime(
              appointmentView.appointment!.actualEndTime)
          : appointmentView.appointment!.actualEndTime;
      final DateTime appointmentExactStartTime =
          appointmentView.appointment!.isAllDay
              ? AppointmentHelper.convertToStartTime(
                  appointmentView.appointment!.exactStartTime)
              : appointmentView.appointment!.exactStartTime;
      final DateTime appointmentExactEndTime =
          appointmentView.appointment!.isAllDay
              ? AppointmentHelper.convertToEndTime(
                  appointmentView.appointment!.exactEndTime)
              : appointmentView.appointment!.exactEndTime;

      if (xPosition >= appointmentView.appointmentRect!.left &&
          xPosition <= appointmentView.appointmentRect!.left + padding &&
          ((isMonthView &&
                  isSameDate(
                      _isRTL ? appointmentEndTime : appointmentStartTime,
                      _isRTL
                          ? appointmentExactEndTime
                          : appointmentExactStartTime)) ||
              (!isMonthView &&
                  CalendarViewHelper.isSameTimeSlot(
                      _isRTL ? appointmentEndTime : appointmentStartTime,
                      _isRTL
                          ? appointmentExactEndTime
                          : appointmentExactStartTime))) &&
          ((_isRTL && !canAddForwardSpanIcon) ||
              (!_isRTL && !canAddBackwardSpanIcon))) {
        setState(() {
          _mouseCursor = SystemMouseCursors.resizeLeft;
        });
      } else if (xPosition <= appointmentView.appointmentRect!.right &&
          xPosition >= appointmentView.appointmentRect!.right - padding &&
          ((isMonthView &&
                  isSameDate(
                      _isRTL ? appointmentStartTime : appointmentEndTime,
                      _isRTL
                          ? appointmentExactStartTime
                          : appointmentExactEndTime)) ||
              (!isMonthView &&
                  CalendarViewHelper.isSameTimeSlot(
                      _isRTL ? appointmentStartTime : appointmentEndTime,
                      _isRTL
                          ? appointmentExactStartTime
                          : appointmentExactEndTime))) &&
          ((_isRTL && !canAddBackwardSpanIcon) ||
              (!_isRTL && !canAddForwardSpanIcon))) {
        setState(() {
          _mouseCursor = SystemMouseCursors.resizeRight;
        });
      } else if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }
    } else {
      if (yPosition >= appointmentView.appointmentRect!.top &&
          yPosition <= appointmentView.appointmentRect!.top + padding &&
          CalendarViewHelper.isSameTimeSlot(
              appointmentView.appointment!.actualStartTime,
              appointmentView.appointment!.exactStartTime)) {
        setState(() {
          _mouseCursor = SystemMouseCursors.resizeUp;
        });
      } else if (yPosition <= appointmentView.appointmentRect!.bottom &&
          yPosition >= appointmentView.appointmentRect!.bottom - padding &&
          CalendarViewHelper.isSameTimeSlot(
              appointmentView.appointment!.actualEndTime,
              appointmentView.appointment!.exactEndTime)) {
        setState(() {
          _mouseCursor = SystemMouseCursors.resizeDown;
        });
      } else if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }
    }
  }

  void _updatePointerHover(Offset globalPosition) {
    if (widget.isMobilePlatform ||
        _resizingDetails.value.appointmentView != null ||
        widget.dragDetails.value.appointmentView != null &&
            widget.calendar.appointmentBuilder == null) {
      return;
    }

    // ignore: avoid_as
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);
    double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
        widget.calendar.viewHeaderHeight, widget.view);
    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        widget.calendar.timeSlotViewSettings.timeRulerSize, widget.view);
    double allDayHeight = _isExpanded
        ? _updateCalendarStateDetails.allDayPanelHeight
        : _allDayHeight;
    final bool isDayView = CalendarViewHelper.isDayView(
        widget.view,
        widget.calendar.timeSlotViewSettings.numberOfDaysInView,
        widget.calendar.timeSlotViewSettings.nonWorkingDays,
        widget.calendar.monthViewSettings.numberOfWeeksInView);

    /// All day panel and view header are arranged horizontally,
    /// so get the maximum value from all day height and view header height and
    /// use the value instead of adding of view header height and all day
    /// height.
    if (isDayView) {
      if (allDayHeight > viewHeaderHeight) {
        viewHeaderHeight = allDayHeight;
      }

      allDayHeight = 0;
    }

    double xPosition;
    double yPosition;
    final bool isTimelineViews = CalendarViewHelper.isTimelineView(widget.view);
    if (widget.view != CalendarView.month && !isTimelineViews) {
      /// In LTR, remove the time ruler width value from the
      /// touch x position while calculate the selected date from position.
      xPosition = _isRTL ? localPosition.dx : localPosition.dx - timeLabelWidth;

      if (localPosition.dy < viewHeaderHeight) {
        if (isDayView) {
          if ((_isRTL && localPosition.dx < widget.width - timeLabelWidth) ||
              (!_isRTL && localPosition.dx > timeLabelWidth)) {
            _updateHoveringForAllDayPanel(localPosition.dx, localPosition.dy);

            final AppointmentView? appointment = _getAllDayAppointmentOnPoint(
                _updateCalendarStateDetails.allDayAppointmentViewCollection,
                localPosition.dx,
                localPosition.dy);
            _updateMouseCursorForAppointment(appointment, localPosition.dx,
                localPosition.dy, isTimelineViews,
                isAllDayPanel: true);
            return;
          }

          _updateHoveringForViewHeader(
              localPosition,
              _isRTL ? widget.width - localPosition.dx : localPosition.dx,
              localPosition.dy,
              viewHeaderHeight);
          return;
        }

        _updateHoveringForViewHeader(localPosition, localPosition.dx,
            localPosition.dy, viewHeaderHeight);
        return;
      }

      double panelHeight =
          _updateCalendarStateDetails.allDayPanelHeight - _allDayHeight;
      if (panelHeight < 0) {
        panelHeight = 0;
      }

      final double allDayExpanderHeight =
          panelHeight * _allDayExpanderAnimation!.value;
      final double allDayBottom = isDayView
          ? viewHeaderHeight
          : viewHeaderHeight + _allDayHeight + allDayExpanderHeight;
      if (localPosition.dy > viewHeaderHeight &&
          localPosition.dy < allDayBottom) {
        if ((_isRTL && localPosition.dx < widget.width - timeLabelWidth) ||
            (!_isRTL && localPosition.dx > timeLabelWidth)) {
          _updateHoveringForAllDayPanel(
              localPosition.dx, localPosition.dy - viewHeaderHeight);
          final AppointmentView? appointment = _getAllDayAppointmentOnPoint(
              _updateCalendarStateDetails.allDayAppointmentViewCollection,
              localPosition.dx,
              localPosition.dy - viewHeaderHeight);
          _updateMouseCursorForAppointment(appointment, localPosition.dx,
              localPosition.dy - viewHeaderHeight, isTimelineViews,
              isAllDayPanel: true);
        } else {
          _removeAllWidgetHovering();
        }

        return;
      }

      yPosition = localPosition.dy - (viewHeaderHeight + allDayHeight);

      final AppointmentView? appointment =
          _appointmentLayout.getAppointmentViewOnPoint(
              localPosition.dx, yPosition + _scrollController!.offset);
      _hoveringAppointmentView = appointment;
      if (appointment != null) {
        _updateHoveringForAppointment(
            localPosition.dx, yPosition + _scrollController!.offset);
        _updateMouseCursorForAppointment(appointment, localPosition.dx,
            yPosition + _scrollController!.offset, isTimelineViews);
        _hoveringDate = null;
        return;
      }
    } else {
      xPosition = localPosition.dx;

      /// Remove the hovering when the position not in week number panel.
      if (widget.calendar.showWeekNumber && widget.view == CalendarView.month) {
        final double weekNumberPanelWidth =
            CalendarViewHelper.getWeekNumberPanelWidth(
                widget.calendar.showWeekNumber,
                widget.width,
                widget.isMobilePlatform);
        if ((!_isRTL && xPosition < weekNumberPanelWidth) ||
            (_isRTL && xPosition > widget.width - weekNumberPanelWidth)) {
          _hoveringDate = null;
          _calendarCellNotifier.value = null;
          _viewHeaderNotifier.value = null;
          _appointmentHoverNotifier.value = null;
          if (_mouseCursor != SystemMouseCursors.basic) {
            setState(() {
              _mouseCursor = SystemMouseCursors.basic;
            });
          }
          _allDayNotifier.value = null;
          _hoveringAppointmentView = null;
          return;
        }
      }

      /// Update the x position value with scroller offset and the value
      /// assigned to mouse hover position.
      /// mouse hover position value used for highlight the position
      /// on all the calendar views.
      if (isTimelineViews) {
        if (_isRTL) {
          xPosition = (_getSingleViewWidthForTimeLineView(this) *
                  widget.visibleDates.length) -
              (_scrollController!.offset +
                  (_scrollController!.position.viewportDimension -
                      localPosition.dx));
        } else {
          xPosition = localPosition.dx + _scrollController!.offset;
        }
      }

      if (localPosition.dy < viewHeaderHeight) {
        _updateHoveringForViewHeader(
            localPosition, xPosition, localPosition.dy, viewHeaderHeight);
        return;
      }

      yPosition = localPosition.dy - viewHeaderHeight - timeLabelWidth;
      if (CalendarViewHelper.isResourceEnabled(
          widget.calendar.dataSource, widget.view)) {
        yPosition += _timelineViewVerticalScrollController!.offset;
      }

      final AppointmentView? appointment =
          _appointmentLayout.getAppointmentViewOnPoint(xPosition, yPosition);
      _hoveringAppointmentView = appointment;
      if (appointment != null) {
        _updateHoveringForAppointment(xPosition, yPosition);
        _updateMouseCursorForAppointment(
            appointment, xPosition, yPosition, isTimelineViews);
        _hoveringDate = null;
        return;
      }
    }

    /// Remove the hovering when the position not in cell regions.
    if (yPosition < 0) {
      if (_hoveringDate != null) {
        _hoveringDate = null;
      }

      if (_calendarCellNotifier.value != null) {
        _calendarCellNotifier.value = null;
      }

      return;
    }

    final DateTime? hoverDate = _getDateFromPosition(
        isTimelineViews ? localPosition.dx : xPosition,
        yPosition,
        timeLabelWidth);

    /// Remove the hovering when the position not in cell regions or non active
    /// cell regions.
    final bool isMonthView = widget.view == CalendarView.month ||
        widget.view == CalendarView.timelineMonth;
    final int timeInterval = CalendarViewHelper.getTimeInterval(
        widget.calendar.timeSlotViewSettings);
    if (hoverDate == null ||
        (isMonthView &&
            !isDateWithInDateRange(
                widget.calendar.minDate, widget.calendar.maxDate, hoverDate)) ||
        (!isMonthView &&
            !CalendarViewHelper.isDateTimeWithInDateTimeRange(
                widget.calendar.minDate,
                widget.calendar.maxDate,
                hoverDate,
                timeInterval))) {
      if (_hoveringDate != null) {
        _hoveringDate = null;
      }

      if (_calendarCellNotifier.value != null) {
        _calendarCellNotifier.value = null;
      }

      return;
    }

    /// Check the hovering month cell date is blackout date.
    if (isMonthView &&
        CalendarViewHelper.isDateInDateCollection(
            widget.blackoutDates, hoverDate)) {
      if (_hoveringDate != null) {
        _hoveringDate = null;
      }

      /// Remove the existing cell hovering.
      if (_calendarCellNotifier.value != null) {
        _calendarCellNotifier.value = null;
      }

      /// Remove the existing appointment hovering.
      if (_appointmentHoverNotifier.value != null) {
        _appointmentHoverNotifier.value = null;
        _hoveringAppointmentView = null;
        if (_mouseCursor != SystemMouseCursors.basic) {
          setState(() {
            _mouseCursor = SystemMouseCursors.basic;
          });
        }
      }

      return;
    }

    final int hoveringResourceIndex =
        _getSelectedResourceIndex(yPosition, viewHeaderHeight, timeLabelWidth);

    /// Restrict the hovering, while selected region as disabled [TimeRegion].
    if (((widget.view == CalendarView.day ||
                widget.view == CalendarView.week ||
                widget.view == CalendarView.workWeek) &&
            !_isEnabledRegion(yPosition, hoverDate, hoveringResourceIndex)) ||
        (isTimelineViews &&
            !_isEnabledRegion(
                localPosition.dx, hoverDate, hoveringResourceIndex))) {
      if (_hoveringDate != null) {
        _hoveringDate = null;
      }

      if (_calendarCellNotifier.value != null) {
        _calendarCellNotifier.value = null;
      }
      return;
    }

    final int currentMonth =
        widget.visibleDates[widget.visibleDates.length ~/ 2].month;

    /// Check the selected cell date as trailing or leading date when
    /// [SfCalendar] month not shown leading and trailing dates.
    if (isMonthView &&
        !CalendarViewHelper.isCurrentMonthDate(
            widget.calendar.monthViewSettings.numberOfWeeksInView,
            widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
            currentMonth,
            hoverDate)) {
      if (_hoveringDate != null) {
        _hoveringDate = null;
      }

      /// Remove the existing cell hovering.
      if (_calendarCellNotifier.value != null) {
        _calendarCellNotifier.value = null;
      }

      /// Remove the existing appointment hovering.
      if (_appointmentHoverNotifier.value != null) {
        _appointmentHoverNotifier.value = null;
        _hoveringAppointmentView = null;
        if (_mouseCursor != SystemMouseCursors.basic) {
          setState(() {
            _mouseCursor = SystemMouseCursors.basic;
          });
        }
      }

      return;
    }

    final bool isResourceEnabled = CalendarViewHelper.isResourceEnabled(
        widget.calendar.dataSource, widget.view);

    /// If resource enabled the selected date or time slot can be same but the
    /// resource value differs hence to handle this scenario we are excluding
    /// the following conditions, if resource enabled.
    if (!isResourceEnabled) {
      if ((widget.view == CalendarView.month &&
              isSameDate(_hoveringDate, hoverDate) &&
              _viewHeaderNotifier.value == null) ||
          (widget.view != CalendarView.month &&
              CalendarViewHelper.isSameTimeSlot(_hoveringDate, hoverDate) &&
              _viewHeaderNotifier.value == null)) {
        return;
      }
    }

    _hoveringDate = hoverDate;

    if (widget.view == CalendarView.month &&
        isSameDate(_selectionPainter!.selectedDate, _hoveringDate)) {
      _calendarCellNotifier.value = null;
      return;
    } else if (widget.view != CalendarView.month &&
        CalendarViewHelper.isSameTimeSlot(
            _selectionPainter!.selectedDate, _hoveringDate) &&
        hoveringResourceIndex == _selectedResourceIndex) {
      _calendarCellNotifier.value = null;
      return;
    }

    if (widget.view != CalendarView.month && !isTimelineViews) {
      yPosition += _scrollController!.offset;
    }

    if (_viewHeaderNotifier.value != null) {
      _viewHeaderNotifier.value = null;
    }

    if (_allDayNotifier.value != null) {
      _allDayNotifier.value = null;
      _hoveringAppointmentView = null;
      if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }
    }

    if (_appointmentHoverNotifier.value != null) {
      _appointmentHoverNotifier.value = null;
      _hoveringAppointmentView = null;
      if (_mouseCursor != SystemMouseCursors.basic) {
        setState(() {
          _mouseCursor = SystemMouseCursors.basic;
        });
      }
    }

    _calendarCellNotifier.value = Offset(xPosition, yPosition);
  }

  void _pointerEnterEvent(PointerEnterEvent event) {
    _updatePointerHover(event.position);
  }

  void _pointerHoverEvent(PointerHoverEvent event) {
    _updatePointerHover(event.position);
  }

  void _pointerExitEvent(PointerExitEvent event) {
    _hoveringDate = null;
    _calendarCellNotifier.value = null;
    _viewHeaderNotifier.value = null;
    _appointmentHoverNotifier.value = null;
    if (_mouseCursor != SystemMouseCursors.basic &&
        _resizingDetails.value.appointmentView == null) {
      setState(() {
        _mouseCursor = SystemMouseCursors.basic;
      });
    }
    _allDayNotifier.value = null;
    _hoveringAppointmentView = null;
  }

  AppointmentView? _getAllDayAppointmentOnPoint(
      List<AppointmentView>? appointmentCollection, double x, double y) {
    if (appointmentCollection == null) {
      return null;
    }

    AppointmentView? selectedAppointmentView;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.appointment != null &&
          appointmentView.appointmentRect != null &&
          appointmentView.appointmentRect!.left <= x &&
          appointmentView.appointmentRect!.right >= x &&
          appointmentView.appointmentRect!.top <= y &&
          appointmentView.appointmentRect!.bottom >= y) {
        selectedAppointmentView = appointmentView;
        break;
      }
    }

    return selectedAppointmentView;
  }

  List<dynamic> _getSelectedAppointments(DateTime selectedDate) {
    return (widget.calendar.dataSource != null &&
            !AppointmentHelper.isCalendarAppointment(
                widget.calendar.dataSource!))
        ? CalendarViewHelper.getCustomAppointments(
            AppointmentHelper.getSelectedDateAppointments(
                _updateCalendarStateDetails.appointments,
                widget.calendar.timeZone,
                selectedDate),
            widget.calendar.dataSource)
        : (AppointmentHelper.getSelectedDateAppointments(
            _updateCalendarStateDetails.appointments,
            widget.calendar.timeZone,
            selectedDate));
  }

  DateTime? _getDateFromPositionForMonth(
      double cellWidth, double cellHeight, double x, double y) {
    final int rowIndex = (x / cellWidth).truncate();
    final int columnIndex = (y / cellHeight).truncate();
    int index = 0;
    if (_isRTL) {
      index = (columnIndex * DateTime.daysPerWeek) +
          (DateTime.daysPerWeek - rowIndex) -
          1;
    } else {
      index = (columnIndex * DateTime.daysPerWeek) + rowIndex;
    }

    if (index < 0 || index >= widget.visibleDates.length) {
      return null;
    }

    return widget.visibleDates[index];
  }

  DateTime? _getDateFromPositionForWeek(
      double cellWidth, double cellHeight, double x, double y) {
    final int columnIndex =
        ((_scrollController!.offset + y) / cellHeight).truncate();
    final double time = columnIndex == -1
        ? 0
        : ((CalendarViewHelper.getTimeInterval(
                        widget.calendar.timeSlotViewSettings) /
                    60) *
                columnIndex) +
            widget.calendar.timeSlotViewSettings.startHour;
    final int hour = time.toInt();
    final int minute = ((time - hour) * 60).round();
    int rowIndex = (x / cellWidth).truncate();
    if (_isRTL) {
      rowIndex = (widget.visibleDates.length - rowIndex) - 1;
    }

    if (rowIndex < 0 || rowIndex >= widget.visibleDates.length) {
      return null;
    }

    final DateTime date = widget.visibleDates[rowIndex];

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  DateTime? _getDateFromPositionForTimeline(
      double cellWidth, double cellHeight, double x, double y) {
    int rowIndex, columnIndex;
    if (_isRTL) {
      rowIndex = (((_scrollController!.offset %
                      _getSingleViewWidthForTimeLineView(this)) +
                  (_scrollController!.position.viewportDimension - x)) /
              cellWidth)
          .truncate();
    } else {
      rowIndex = (((_scrollController!.offset %
                      _getSingleViewWidthForTimeLineView(this)) +
                  x) /
              cellWidth)
          .truncate();
    }
    columnIndex =
        (_scrollController!.offset / _getSingleViewWidthForTimeLineView(this))
            .truncate();
    if (rowIndex >= _horizontalLinesCount!) {
      columnIndex += rowIndex ~/ _horizontalLinesCount!;
      rowIndex = (rowIndex % _horizontalLinesCount!).toInt();
    }
    final double time = ((CalendarViewHelper.getTimeInterval(
                    widget.calendar.timeSlotViewSettings) /
                60) *
            rowIndex) +
        widget.calendar.timeSlotViewSettings.startHour;
    final int hour = time.toInt();
    final int minute = ((time - hour) * 60).round();
    if (columnIndex < 0) {
      columnIndex = 0;
    } else if (columnIndex >= widget.visibleDates.length) {
      columnIndex = widget.visibleDates.length - 1;
    }

    if (columnIndex < 0 || columnIndex >= widget.visibleDates.length) {
      return null;
    }

    final DateTime date = widget.visibleDates[columnIndex];

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  DateTime? _getDateFromPosition(double x, double y, double timeLabelWidth) {
    double cellWidth = 0;
    double cellHeight = 0;
    final double width = widget.width - timeLabelWidth;
    switch (widget.view) {
      case CalendarView.schedule:
        return null;
      case CalendarView.month:
        {
          /// Remove the selection when the position is to week number panel.
          final double weekNumberPanelWidth =
              CalendarViewHelper.getWeekNumberPanelWidth(
                  widget.calendar.showWeekNumber,
                  widget.width,
                  widget.isMobilePlatform);
          if (x > widget.width ||
              (!_isRTL && x < weekNumberPanelWidth) ||
              (_isRTL && x > widget.width - weekNumberPanelWidth)) {
            return null;
          }

          /// In RTL the week number panel will render on the right side hence,
          /// we didn't consider the week number panel width in rtl.
          if (!_isRTL) {
            x -= weekNumberPanelWidth;
          }

          cellWidth =
              (widget.width - weekNumberPanelWidth) / DateTime.daysPerWeek;
          cellHeight = (widget.height -
                  CalendarViewHelper.getViewHeaderHeight(
                      widget.calendar.viewHeaderHeight, widget.view)) /
              widget.calendar.monthViewSettings.numberOfWeeksInView;
          return _getDateFromPositionForMonth(cellWidth, cellHeight, x, y);
        }
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          if (y >= _timeIntervalHeight * _horizontalLinesCount! ||
              x > width ||
              x < 0) {
            return null;
          }
          cellWidth = width / widget.visibleDates.length;
          cellHeight = _timeIntervalHeight;
          return _getDateFromPositionForWeek(cellWidth, cellHeight, x, y);
        }
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
        {
          final double viewWidth = _timeIntervalHeight *
              (_horizontalLinesCount! * widget.visibleDates.length);
          if ((!_isRTL && x >= viewWidth) ||
              (_isRTL && x < (widget.width - viewWidth))) {
            return null;
          }
          cellWidth = _timeIntervalHeight;
          cellHeight = widget.height;
          return _getDateFromPositionForTimeline(cellWidth, cellHeight, x, y);
        }
    }
  }

  void _drawSelection(double x, double y, double timeLabelWidth) {
    final DateTime? selectedDate = _getDateFromPosition(x, y, timeLabelWidth);
    final bool isMonthView = widget.view == CalendarView.month ||
        widget.view == CalendarView.timelineMonth;
    final int timeInterval = CalendarViewHelper.getTimeInterval(
        widget.calendar.timeSlotViewSettings);
    if (selectedDate == null ||
        (isMonthView &&
            !isDateWithInDateRange(widget.calendar.minDate,
                widget.calendar.maxDate, selectedDate)) ||
        (!isMonthView &&
            !CalendarViewHelper.isDateTimeWithInDateTimeRange(
                widget.calendar.minDate,
                widget.calendar.maxDate,
                selectedDate,
                timeInterval))) {
      return;
    }

    /// Restrict the selection update, while selected region as disabled
    /// [TimeRegion].
    if (((widget.view == CalendarView.day ||
                widget.view == CalendarView.week ||
                widget.view == CalendarView.workWeek) &&
            !_isEnabledRegion(y, selectedDate, _selectedResourceIndex)) ||
        (CalendarViewHelper.isTimelineView(widget.view) &&
            !_isEnabledRegion(x, selectedDate, _selectedResourceIndex))) {
      return;
    }

    if (isMonthView &&
        CalendarViewHelper.isDateInDateCollection(
            widget.blackoutDates, selectedDate)) {
      return;
    }

    if (widget.view == CalendarView.month) {
      final int currentMonth =
          widget.visibleDates[widget.visibleDates.length ~/ 2].month;

      /// Check the selected cell date as trailing or leading date when
      /// [SfCalendar] month not shown leading and trailing dates.
      if (!CalendarViewHelper.isCurrentMonthDate(
          widget.calendar.monthViewSettings.numberOfWeeksInView,
          widget.calendar.monthViewSettings.showTrailingAndLeadingDates,
          currentMonth,
          selectedDate)) {
        return;
      }

      widget.agendaSelectedDate.value = selectedDate;
    }

    _updateCalendarStateDetails.selectedDate = selectedDate;
    _selectionPainter!.selectedDate = selectedDate;
    _selectionPainter!.appointmentView = null;
    _selectionNotifier.value = !_selectionNotifier.value;
  }

  _SelectionPainter _addSelectionView([double? resourceItemHeight]) {
    AppointmentView? appointmentView;
    if (_selectionPainter?.appointmentView != null) {
      appointmentView = _selectionPainter!.appointmentView;
    }

    _selectionPainter = _SelectionPainter(
      widget.calendar,
      widget.view,
      widget.visibleDates,
      _updateCalendarStateDetails.selectedDate,
      widget.calendar.selectionDecoration,
      _timeIntervalHeight,
      widget.calendarTheme,
      _selectionNotifier,
      _isRTL,
      _selectedResourceIndex,
      resourceItemHeight,
      widget.calendar.showWeekNumber,
      widget.isMobilePlatform,
      (UpdateCalendarStateDetails details) {
        _getPainterProperties(details);
      },
    );

    if (appointmentView != null &&
        _updateCalendarStateDetails.visibleAppointments
            .contains(appointmentView.appointment)) {
      _selectionPainter!.appointmentView = appointmentView;
    }

    return _selectionPainter!;
  }

  Widget _getTimelineViewHeader(double width, double height, String locale) {
    _timelineViewHeader = TimelineViewHeaderView(
        widget.visibleDates,
        _timelineViewHeaderScrollController!,
        _timelineViewHeaderNotifier,
        widget.calendar.viewHeaderStyle,
        widget.calendar.timeSlotViewSettings,
        CalendarViewHelper.getViewHeaderHeight(
            widget.calendar.viewHeaderHeight, widget.view),
        _isRTL,
        widget.calendar.todayHighlightColor ??
            widget.calendarTheme.todayHighlightColor,
        widget.calendar.todayTextStyle,
        widget.locale,
        widget.calendarTheme,
        widget.themeData,
        widget.calendar.minDate,
        widget.calendar.maxDate,
        _viewHeaderNotifier,
        widget.calendar.cellBorderColor,
        widget.blackoutDates,
        widget.calendar.blackoutDatesTextStyle,
        widget.textScaleFactor);
    return ListView(
        padding: EdgeInsets.zero,
        controller: _timelineViewHeaderScrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          CustomPaint(
            painter: _timelineViewHeader,
            size: Size(width, height),
          )
        ]);
  }
}

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
      this.themeData,
      this.todayHighlightColor,
      this.todayTextStyle,
      this.cellBorderColor,
      this.minDate,
      this.maxDate,
      this.viewHeaderNotifier,
      this.textScaleFactor,
      this.showWeekNumber,
      this.isMobilePlatform,
      this.weekNumberStyle,
      this.localizations)
      : super(repaint: viewHeaderNotifier);

  final CalendarView view;
  final ViewHeaderStyle viewHeaderStyle;
  final TimeSlotViewSettings timeSlotViewSettings;
  final MonthViewSettings monthViewSettings;
  final List<DateTime> visibleDates;
  final double timeLabelWidth;
  final double viewHeaderHeight;
  final SfCalendarThemeData calendarTheme;
  final ThemeData themeData;
  final bool isRTL;
  final String locale;
  final Color? todayHighlightColor;
  final TextStyle? todayTextStyle;
  final Color? cellBorderColor;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueNotifier<Offset?> viewHeaderNotifier;
  final double textScaleFactor;
  final Paint _circlePainter = Paint();
  final TextPainter _dayTextPainter = TextPainter(),
      _dateTextPainter = TextPainter();
  final bool showWeekNumber;
  final bool isMobilePlatform;
  final WeekNumberStyle weekNumberStyle;
  final SfLocalizations localizations;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final double weekNumberPanelWidth =
        CalendarViewHelper.getWeekNumberPanelWidth(
            showWeekNumber, size.width, isMobilePlatform);
    double width = view == CalendarView.month
        ? size.width - weekNumberPanelWidth
        : size.width;
    width = _getViewHeaderWidth(width);

    /// Initializes the default text style for the texts in view header of
    /// calendar.
    final TextStyle viewHeaderDayStyle = calendarTheme.viewHeaderDayTextStyle!;
    final TextStyle viewHeaderDateStyle =
        calendarTheme.viewHeaderDateTextStyle!;

    final DateTime today = DateTime.now();
    if (view != CalendarView.month) {
      _addViewHeaderForTimeSlotViews(
          canvas, size, viewHeaderDayStyle, viewHeaderDateStyle, width, today);
    } else {
      _addViewHeaderForMonthView(
          canvas, size, viewHeaderDayStyle, width, today, weekNumberPanelWidth);
    }
  }

  void _addViewHeaderForMonthView(
      Canvas canvas,
      Size size,
      TextStyle viewHeaderDayStyle,
      double width,
      DateTime today,
      double weekNumberPanelWidth) {
    TextStyle dayTextStyle = viewHeaderDayStyle;
    double xPosition = isRTL
        ? size.width - width - weekNumberPanelWidth
        : weekNumberPanelWidth;
    double yPosition = 0;
    final int visibleDatesLength = visibleDates.length;
    bool hasToday = monthViewSettings.numberOfWeeksInView > 0 &&
            monthViewSettings.numberOfWeeksInView < 6 ||
        visibleDates[visibleDatesLength ~/ 2].month == today.month;
    if (hasToday) {
      hasToday = isDateWithInDateRange(
          visibleDates[0], visibleDates[visibleDatesLength - 1], today);
    }

    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      final DateTime currentDate = visibleDates[i];
      String dayText = DateFormat(monthViewSettings.dayFormat, locale)
          .format(currentDate)
          .toUpperCase();

      dayText = _updateViewHeaderFormat(monthViewSettings.dayFormat, dayText);

      if (hasToday && currentDate.weekday == today.weekday) {
        final Color? todayTextColor =
            CalendarViewHelper.getTodayHighlightTextColor(
                todayHighlightColor, todayTextStyle, calendarTheme);

        dayTextStyle = todayTextStyle != null
            ? calendarTheme.todayTextStyle!.copyWith(
                fontSize: viewHeaderDayStyle.fontSize, color: todayTextColor)
            : viewHeaderDayStyle.copyWith(color: todayTextColor);
      } else {
        dayTextStyle = viewHeaderDayStyle;
      }

      _updateDayTextPainter(dayTextStyle, width, dayText);

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
    if (weekNumberPanelWidth != 0 && showWeekNumber) {
      const double defaultFontSize = 14;
      final TextStyle weekNumberTextStyle = calendarTheme.weekNumberTextStyle!;
      final double xPosition = isRTL ? (size.width - weekNumberPanelWidth) : 0;

      _updateDayTextPainter(weekNumberTextStyle, weekNumberPanelWidth,
          localizations.weeknumberLabel);

      /// Condition added to remove the ellipsis, when the width is too small
      /// the ellipsis alone displayed, hence to resolve this removed ecclipsis
      /// when the width is too small, in this scenario the remaining letters
      /// were clipped.
      if (_dayTextPainter.didExceedMaxLines &&
          (_dayTextPainter.width <=
              (weekNumberTextStyle.fontSize ?? defaultFontSize) * 1.5)) {
        _dayTextPainter.ellipsis = null;
        _dayTextPainter.layout(maxWidth: weekNumberPanelWidth);
      }

      _dayTextPainter.paint(
          canvas,
          Offset(
              xPosition +
                  (weekNumberPanelWidth / 2 - _dayTextPainter.width / 2),
              yPosition));
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
    final bool isDayView = CalendarViewHelper.isDayView(
        view,
        timeSlotViewSettings.numberOfDaysInView,
        timeSlotViewSettings.nonWorkingDays,
        monthViewSettings.numberOfWeeksInView);
    final double labelWidth =
        isDayView && timeLabelWidth < 50 ? 50 : timeLabelWidth;
    TextStyle dayTextStyle = viewHeaderDayStyle;
    TextStyle dateTextStyle = viewHeaderDateStyle;
    const double topPadding = 5;
    if (isDayView) {
      width = labelWidth;
    }

    final Paint linePainter = Paint();
    xPosition = isDayView ? 0 : timeLabelWidth;
    yPosition = 2;
    final int visibleDatesLength = visibleDates.length;
    final double cellWidth = width / visibleDatesLength;
    if (isRTL && !isDayView) {
      xPosition = size.width - timeLabelWidth - cellWidth;
    }
    for (int i = 0; i < visibleDatesLength; i++) {
      final DateTime currentDate = visibleDates[i];

      String dayText = DateFormat(timeSlotViewSettings.dayFormat, locale)
          .format(currentDate)
          .toUpperCase();

      dayText =
          _updateViewHeaderFormat(timeSlotViewSettings.dayFormat, dayText);

      final String dateText =
          DateFormat(timeSlotViewSettings.dateFormat).format(currentDate);
      final bool isToday = isSameDate(currentDate, today);
      if (isToday) {
        final Color? todayTextStyleColor = calendarTheme.todayTextStyle!.color;
        final Color? todayTextColor =
            CalendarViewHelper.getTodayHighlightTextColor(
                todayHighlightColor, todayTextStyle, calendarTheme);
        dayTextStyle = todayTextStyle != null
            ? calendarTheme.todayTextStyle!.copyWith(
                fontSize: viewHeaderDayStyle.fontSize, color: todayTextColor)
            : viewHeaderDayStyle.copyWith(color: todayTextColor);
        dateTextStyle = todayTextStyle != null
            ? calendarTheme.todayTextStyle!
                .copyWith(fontSize: viewHeaderDateStyle.fontSize)
            : viewHeaderDateStyle.copyWith(color: todayTextStyleColor);
      } else {
        dayTextStyle = viewHeaderDayStyle;
        dateTextStyle = viewHeaderDateStyle;
      }

      if (!isDateWithInDateRange(minDate, maxDate, currentDate)) {
        dayTextStyle = dayTextStyle.copyWith(
            color: dayTextStyle.color != null
                ? dayTextStyle.color!.withOpacity(0.38)
                : themeData.brightness == Brightness.light
                    ? Colors.black26
                    : Colors.white38);
        dateTextStyle = dateTextStyle.copyWith(
            color: dateTextStyle.color != null
                ? dateTextStyle.color!.withOpacity(0.38)
                : themeData.brightness == Brightness.light
                    ? Colors.black26
                    : Colors.white38);
      }

      _updateDayTextPainter(dayTextStyle, width, dayText);

      final TextSpan dateTextSpan = TextSpan(
        text: dateText,
        style: dateTextStyle,
      );

      _dateTextPainter.text = dateTextSpan;
      _dateTextPainter.textDirection = TextDirection.ltr;
      _dateTextPainter.textAlign = TextAlign.left;
      _dateTextPainter.textWidthBasis = TextWidthBasis.longestLine;
      _dateTextPainter.textScaler = TextScaler.linear(textScaleFactor);

      _dateTextPainter.layout(maxWidth: width);

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
      if (!isDayView &&
          showWeekNumber &&
          ((currentDate.weekday == DateTime.monday) ||
              (view == CalendarView.workWeek &&
                  timeSlotViewSettings.nonWorkingDays
                      .contains(DateTime.monday) &&
                  i == visibleDatesLength ~/ 2))) {
        final String weekNumber =
            DateTimeHelper.getWeekNumberOfYear(currentDate).toString();
        final TextStyle weekNumberTextStyle =
            calendarTheme.weekNumberTextStyle!;
        final TextSpan dayTextSpan = TextSpan(
          text: weekNumber,
          style: weekNumberTextStyle,
        );
        _dateTextPainter.text = dayTextSpan;
        _dateTextPainter.textDirection = TextDirection.ltr;
        _dateTextPainter.textAlign = TextAlign.left;
        _dateTextPainter.textWidthBasis = TextWidthBasis.longestLine;
        _dateTextPainter.textScaler = TextScaler.linear(textScaleFactor);
        _dateTextPainter.layout(maxWidth: timeLabelWidth);
        final double weekNumberPosition = isRTL
            ? (size.width - timeLabelWidth) +
                ((timeLabelWidth - _dateTextPainter.width) / 2)
            : (timeLabelWidth - _dateTextPainter.width) / 2;
        final double weekNumberYPosition = size.height / 2 -
            (_dayTextPainter.height +
                    topPadding +
                    _dateTextPainter.height +
                    inBetweenPadding) /
                2 +
            topPadding +
            _dayTextPainter.height +
            inBetweenPadding;
        const double padding = 10;
        final Rect rect = Rect.fromLTRB(
            weekNumberPosition - padding,
            weekNumberYPosition - (padding / 2),
            weekNumberPosition + _dateTextPainter.width + padding,
            weekNumberYPosition + _dateTextPainter.height + (padding / 2));
        linePainter.style = PaintingStyle.fill;
        linePainter.color = weekNumberStyle.backgroundColor ??
            calendarTheme.weekNumberBackgroundColor!;
        final RRect roundedRect =
            RRect.fromRectAndRadius(rect, const Radius.circular(padding / 2));
        canvas.drawRRect(roundedRect, linePainter);
        _dateTextPainter.paint(
            canvas, Offset(weekNumberPosition, weekNumberYPosition));
        final double xPosition = isRTL ? (size.width - timeLabelWidth) : 0;
        _updateDayTextPainter(
            weekNumberTextStyle, timeLabelWidth, localizations.weeknumberLabel);
        _dayTextPainter.paint(
            canvas,
            Offset(xPosition + (timeLabelWidth / 2 - _dayTextPainter.width / 2),
                yPosition));
      }

      if (isRTL) {
        xPosition -= cellWidth;
      } else {
        xPosition += cellWidth;
      }
    }
  }

  void _addMouseHoverForMonth(Canvas canvas, Size size, double xPosition,
      double yPosition, double width) {
    if (xPosition + (width / 2 - _dayTextPainter.width / 2) <=
            viewHeaderNotifier.value!.dx &&
        xPosition +
                (width / 2 - _dayTextPainter.width / 2) +
                _dayTextPainter.width >=
            viewHeaderNotifier.value!.dx &&
        yPosition - 5 <= viewHeaderNotifier.value!.dy &&
        (yPosition + size.height) - 5 >= viewHeaderNotifier.value!.dy) {
      _drawTodayCircle(
          canvas,
          xPosition + (width / 2 - _dayTextPainter.width / 2),
          yPosition,
          _dayTextPainter,
          hoveringColor: (themeData.brightness == Brightness.dark
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
    if (xPosition + dateXPosition <= viewHeaderNotifier.value!.dx &&
        xPosition + dateXPosition + _dateTextPainter.width >=
            viewHeaderNotifier.value!.dx) {
      final Color hoveringColor = isToday
          ? Colors.black.withOpacity(0.12)
          : (themeData.brightness == Brightness.dark
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

  String _updateViewHeaderFormat(String dayFormat, String dayText) {
    switch (view) {
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          if (!CalendarViewHelper.isDayView(
                  view,
                  timeSlotViewSettings.numberOfDaysInView,
                  timeSlotViewSettings.nonWorkingDays,
                  monthViewSettings.numberOfWeeksInView) &&
              (dayFormat == 'EE' && (locale.contains('en')))) {
            return dayText[0];
          }
          break;
        }
      case CalendarView.schedule:
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
        break;
      case CalendarView.month:
        {
          //// EE format value shows the week days as S, M, T, W, T, F, S.
          if (dayFormat == 'EE' && (locale.contains('en'))) {
            return dayText[0];
          }
        }
    }

    return dayText;
  }

  void _updateDayTextPainter(
      TextStyle dayTextStyle, double width, String dayText) {
    final TextSpan dayTextSpan = TextSpan(
      text: dayText,
      style: dayTextStyle,
    );

    _dayTextPainter.text = dayTextSpan;
    _dayTextPainter.textDirection = TextDirection.ltr;
    _dayTextPainter.textAlign = TextAlign.left;
    _dayTextPainter.textWidthBasis = TextWidthBasis.longestLine;
    _dayTextPainter.textScaler = TextScaler.linear(textScaleFactor);
    _dayTextPainter.ellipsis = '...';
    _dayTextPainter.maxLines = 1;

    _dayTextPainter.layout(maxWidth: width);
  }

  double _getViewHeaderWidth(double width) {
    switch (view) {
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineMonth:
      case CalendarView.schedule:
        return 0;
      case CalendarView.month:
        return width / DateTime.daysPerWeek;
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          if (CalendarViewHelper.isDayView(
              view,
              timeSlotViewSettings.numberOfDaysInView,
              timeSlotViewSettings.nonWorkingDays,
              monthViewSettings.numberOfWeeksInView)) {
            return timeLabelWidth;
          }
          return width - timeLabelWidth;
        }
    }
  }

  @override
  bool shouldRepaint(_ViewHeaderViewPainter oldDelegate) {
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
        oldWidget.textScaleFactor != textScaleFactor ||
        oldWidget.weekNumberStyle != weekNumberStyle ||
        oldWidget.showWeekNumber != showWeekNumber;
  }

  //// draw today highlight circle in view header.
  void _drawTodayCircle(
      Canvas canvas, double x, double y, TextPainter dateTextPainter,
      {Color? hoveringColor}) {
    _circlePainter.color = (hoveringColor ?? todayHighlightColor)!;
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
  bool shouldRebuildSemantics(_ViewHeaderViewPainter oldDelegate) {
    final _ViewHeaderViewPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates;
  }

  String _getAccessibilityText(DateTime date) {
    if (!isDateWithInDateRange(minDate, maxDate, date)) {
      // ignore: lines_longer_than_80_chars
      return '${DateFormat('EEEEE').format(date)}${DateFormat('dd MMMM yyyy').format(date)}, Disabled date';
    }

    return DateFormat('EEEEE').format(date) +
        DateFormat('dd MMMM yyyy').format(date);
  }

  List<CustomPainterSemantics> _getSemanticsForMonthViewHeader(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    final double cellWidth = size.width / DateTime.daysPerWeek;
    double left = isRTL ? size.width - cellWidth : 0;
    const double top = 0;
    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(left, top, cellWidth, size.height),
        properties: SemanticsProperties(
          label: DateFormat('EEEEE').format(visibleDates[i]).toUpperCase(),
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
    final bool isDayView = CalendarViewHelper.isDayView(
        view,
        timeSlotViewSettings.numberOfDaysInView,
        timeSlotViewSettings.nonWorkingDays,
        monthViewSettings.numberOfWeeksInView);
    final double cellWidth = isDayView
        ? size.width
        : (size.width - timeLabelWidth) / visibleDates.length;
    if (isRTL) {
      left = isDayView
          ? size.width - timeLabelWidth
          : (size.width - timeLabelWidth) - cellWidth;
    } else {
      left = isDayView ? 0 : timeLabelWidth;
    }
    for (int i = 0; i < visibleDates.length; i++) {
      final DateTime visibleDate = visibleDates[i];
      if (showWeekNumber &&
          ((visibleDate.weekday == DateTime.monday && !isDayView) ||
              (view == CalendarView.workWeek &&
                  timeSlotViewSettings.nonWorkingDays
                      .contains(DateTime.monday) &&
                  i == visibleDates.length ~/ 2))) {
        final int weekNumber = DateTimeHelper.getWeekNumberOfYear(visibleDate);
        semanticsBuilder.add(CustomPainterSemantics(
            rect: Rect.fromLTWH(isRTL ? (size.width - timeLabelWidth) : 0, 0,
                isRTL ? size.width : timeLabelWidth, viewHeaderHeight),
            properties: SemanticsProperties(
              label: 'week$weekNumber',
              textDirection: TextDirection.ltr,
            )));
      }
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
        return <CustomPainterSemantics>[];
      case CalendarView.month:
        return _getSemanticsForMonthViewHeader(size);
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        return _getSemanticsForDayHeader(size);
    }
  }
}

class _SelectionPainter extends CustomPainter {
  _SelectionPainter(
      this.calendar,
      this.view,
      this.visibleDates,
      this.selectedDate,
      this.selectionDecoration,
      this.timeIntervalHeight,
      this.calendarTheme,
      this.repaintNotifier,
      this.isRTL,
      this.selectedResourceIndex,
      this.resourceItemHeight,
      this.showWeekNumber,
      this.isMobilePlatform,
      this.getCalendarState)
      : super(repaint: repaintNotifier);

  final SfCalendar calendar;
  final CalendarView view;
  final SfCalendarThemeData calendarTheme;
  final List<DateTime> visibleDates;
  Decoration? selectionDecoration;
  DateTime? selectedDate;
  final double timeIntervalHeight;
  final bool isRTL;
  final UpdateCalendarState getCalendarState;
  int selectedResourceIndex;
  final double? resourceItemHeight;

  late BoxPainter _boxPainter;
  AppointmentView? appointmentView;
  double _cellWidth = 0, _cellHeight = 0, _xPosition = 0, _yPosition = 0;
  final ValueNotifier<bool> repaintNotifier;
  final UpdateCalendarStateDetails _updateCalendarStateDetails =
      UpdateCalendarStateDetails();
  final bool showWeekNumber;
  final bool isMobilePlatform;

  @override
  void paint(Canvas canvas, Size size) {
    selectionDecoration ??= BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: calendarTheme.selectionBorderColor!, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(2)),
    );

    getCalendarState(_updateCalendarStateDetails);
    selectedDate = _updateCalendarStateDetails.selectedDate;
    final bool isDayView = CalendarViewHelper.isDayView(
        view,
        calendar.timeSlotViewSettings.numberOfDaysInView,
        calendar.timeSlotViewSettings.nonWorkingDays,
        calendar.monthViewSettings.numberOfWeeksInView);
    final bool isMonthView =
        view == CalendarView.month || view == CalendarView.timelineMonth;
    final int timeInterval =
        CalendarViewHelper.getTimeInterval(calendar.timeSlotViewSettings);
    if (selectedDate != null &&
        ((isMonthView &&
                !isDateWithInDateRange(
                    calendar.minDate, calendar.maxDate, selectedDate)) ||
            (!isMonthView &&
                !CalendarViewHelper.isDateTimeWithInDateTimeRange(
                    calendar.minDate,
                    calendar.maxDate,
                    selectedDate!,
                    timeInterval)))) {
      return;
    }
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final double timeLabelWidth = CalendarViewHelper.getTimeLabelWidth(
        calendar.timeSlotViewSettings.timeRulerSize, view);
    double width = size.width;
    final bool isTimeline = CalendarViewHelper.isTimelineView(view);
    if (view != CalendarView.month && !isTimeline) {
      width -= timeLabelWidth;
    }

    final bool isResourceEnabled = isTimeline &&
        CalendarViewHelper.isResourceEnabled(calendar.dataSource, view);
    if ((selectedDate == null && appointmentView == null) ||
        visibleDates != _updateCalendarStateDetails.currentViewVisibleDates ||
        (isResourceEnabled && selectedResourceIndex == -1)) {
      return;
    }

    if (!isTimeline) {
      if (view == CalendarView.month) {
        _cellWidth = width / DateTime.daysPerWeek;
        _cellHeight =
            size.height / calendar.monthViewSettings.numberOfWeeksInView;
      } else {
        _cellWidth = width / visibleDates.length;
        _cellHeight = timeIntervalHeight;
      }
    } else {
      _cellWidth = timeIntervalHeight;
      _cellHeight = size.height;

      /// The selection view must render on the resource area alone, when the
      /// resource enabled.
      if (isResourceEnabled && selectedResourceIndex >= 0) {
        _cellHeight = resourceItemHeight!;
      }
    }

    if (appointmentView != null && appointmentView!.appointment != null) {
      _drawAppointmentSelection(canvas);
    }

    switch (view) {
      case CalendarView.schedule:
        return;
      case CalendarView.month:
        {
          if (selectedDate != null) {
            _drawMonthSelection(canvas, size, width);
          }
        }
        break;
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          if (selectedDate != null) {
            if (isDayView) {
              _drawDaySelection(canvas, size, width, timeLabelWidth);
            } else {
              _drawWeekSelection(canvas, size, timeLabelWidth, width);
            }
          }
        }
        break;
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
        {
          if (selectedDate != null) {
            _drawTimelineWeekSelection(canvas, size, width);
          }
        }
        break;
      case CalendarView.timelineMonth:
        {
          if (selectedDate != null) {
            _drawTimelineMonthSelection(canvas, size, width);
          }
        }
    }
  }

  @override
  bool? hitTest(Offset position) {
    return false;
  }

  void _drawMonthSelection(Canvas canvas, Size size, double width) {
    final int visibleDatesLength = visibleDates.length;
    if (!isDateWithInDateRange(
        visibleDates[0], visibleDates[visibleDatesLength - 1], selectedDate)) {
      return;
    }

    final int currentMonth = visibleDates[visibleDatesLength ~/ 2].month;

    /// Check the selected cell date as trailing or leading date when
    /// [SfCalendar] month not shown leading and trailing dates.
    if (!CalendarViewHelper.isCurrentMonthDate(
        calendar.monthViewSettings.numberOfWeeksInView,
        calendar.monthViewSettings.showTrailingAndLeadingDates,
        currentMonth,
        selectedDate!)) {
      return;
    }

    if (CalendarViewHelper.isDateInDateCollection(
        calendar.blackoutDates, selectedDate!)) {
      return;
    }

    for (int i = 0; i < visibleDatesLength; i++) {
      if (isSameDate(visibleDates[i], selectedDate)) {
        final double weekNumberPanelWidth =
            CalendarViewHelper.getWeekNumberPanelWidth(
                showWeekNumber, width, isMobilePlatform);
        _cellWidth = (size.width - weekNumberPanelWidth) / DateTime.daysPerWeek;
        final int columnIndex = (i / DateTime.daysPerWeek).truncate();
        _yPosition = columnIndex * _cellHeight;
        final int rowIndex = i % DateTime.daysPerWeek;
        if (isRTL) {
          _xPosition = (DateTime.daysPerWeek - 1 - rowIndex) * _cellWidth;
        } else {
          _xPosition = rowIndex * _cellWidth + weekNumberPanelWidth;
        }
        _drawSlotSelection(width, size.height, canvas);
        break;
      }
    }
  }

  void _drawDaySelection(
      Canvas canvas, Size size, double width, double timeLabelWidth) {
    if (isSameDate(visibleDates[0], selectedDate)) {
      if (isRTL) {
        _xPosition = 0;
      } else {
        _xPosition = timeLabelWidth;
      }

      selectedDate = _updateSelectedDate();

      _yPosition = AppointmentHelper.timeToPosition(
          calendar, selectedDate!, timeIntervalHeight);
      _drawSlotSelection(width + timeLabelWidth, size.height, canvas);
    }
  }

  /// Method to update the selected date, when the selected date not fill the
  /// exact time slot, and render the mid of time slot, on this scenario we
  /// have updated the selected date to update the exact time slot.
  ///
  /// Eg: If the time interval is 60min, and the selected date is 12.45 PM the
  /// selection renders on the center of 12 to 1 PM slot, to avoid this we have
  /// modified the selected date to 1 PM so that the selection will render the
  /// exact time slot.
  DateTime _updateSelectedDate() {
    final int timeInterval =
        CalendarViewHelper.getTimeInterval(calendar.timeSlotViewSettings);
    final int startHour = calendar.timeSlotViewSettings.startHour.toInt();
    final double startMinute = (calendar.timeSlotViewSettings.startHour -
            calendar.timeSlotViewSettings.startHour.toInt()) *
        60;
    final int selectedMinutes = ((selectedDate!.hour - startHour) * 60) +
        (selectedDate!.minute - startMinute.toInt());
    if (selectedMinutes % timeInterval != 0) {
      final int diff = selectedMinutes % timeInterval;
      if (diff < (timeInterval / 2)) {
        return selectedDate!.subtract(Duration(minutes: diff));
      } else {
        return selectedDate!.add(Duration(minutes: timeInterval - diff));
      }
    }

    return selectedDate!;
  }

  void _drawWeekSelection(
      Canvas canvas, Size size, double timeLabelWidth, double width) {
    final int visibleDatesLength = visibleDates.length;
    if (isDateWithInDateRange(
        visibleDates[0], visibleDates[visibleDatesLength - 1], selectedDate)) {
      for (int i = 0; i < visibleDatesLength; i++) {
        if (isSameDate(selectedDate, visibleDates[i])) {
          final int rowIndex = i;
          if (isRTL) {
            _xPosition = _cellWidth * (visibleDatesLength - 1 - rowIndex);
          } else {
            _xPosition = timeLabelWidth + _cellWidth * rowIndex;
          }

          selectedDate = _updateSelectedDate();
          _yPosition = AppointmentHelper.timeToPosition(
              calendar, selectedDate!, timeIntervalHeight);
          _drawSlotSelection(width + timeLabelWidth, size.height, canvas);
          break;
        }
      }
    }
  }

  /// Returns the yPosition for selection view based on resource associated with
  /// the selected cell in  timeline views when resource enabled.
  double _getTimelineYPosition() {
    if (selectedResourceIndex == -1) {
      return 0;
    }

    return selectedResourceIndex * resourceItemHeight!;
  }

  void _drawTimelineMonthSelection(Canvas canvas, Size size, double width) {
    if (!isDateWithInDateRange(
        visibleDates[0], visibleDates[visibleDates.length - 1], selectedDate)) {
      return;
    }

    if (CalendarViewHelper.isDateInDateCollection(
        calendar.blackoutDates, selectedDate!)) {
      return;
    }

    for (int i = 0; i < visibleDates.length; i++) {
      if (isSameDate(visibleDates[i], selectedDate)) {
        _yPosition = _getTimelineYPosition();
        _xPosition =
            isRTL ? size.width - ((i + 1) * _cellWidth) : i * _cellWidth;
        final double height = selectedResourceIndex == -1
            ? size.height
            : _yPosition + resourceItemHeight!;
        _drawSlotSelection(width, height, canvas);
        break;
      }
    }
  }

  void _drawTimelineWeekSelection(Canvas canvas, Size size, double width) {
    if (isDateWithInDateRange(
        visibleDates[0], visibleDates[visibleDates.length - 1], selectedDate)) {
      selectedDate = _updateSelectedDate();
      for (int i = 0; i < visibleDates.length; i++) {
        if (isSameDate(selectedDate, visibleDates[i])) {
          final double singleViewWidth = width / visibleDates.length;
          _xPosition = (i * singleViewWidth) +
              AppointmentHelper.timeToPosition(
                  calendar, selectedDate!, timeIntervalHeight);
          if (isRTL) {
            _xPosition = size.width - _xPosition - _cellWidth;
          }
          _yPosition = _getTimelineYPosition();
          final double height = selectedResourceIndex == -1
              ? size.height
              : _yPosition + resourceItemHeight!;
          _drawSlotSelection(width, height, canvas);
          break;
        }
      }
    }
  }

  void _drawAppointmentSelection(Canvas canvas) {
    Rect rect = appointmentView!.appointmentRect!.outerRect;
    rect = Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);
    _boxPainter = selectionDecoration!
        .createBoxPainter(_updateSelectionDecorationPainter);
    _boxPainter.paint(canvas, Offset(rect.left, rect.top),
        ImageConfiguration(size: rect.size));
  }

  /// Used to pass the argument of create box painter and it is called when
  /// decoration have asynchronous data like image.
  void _updateSelectionDecorationPainter() {
    repaintNotifier.value = !repaintNotifier.value;
  }

  void _drawSlotSelection(double width, double height, Canvas canvas) {
    //// padding used to avoid first, last row and column selection clipping.
    const double padding = 0.5;
    final Rect rect = Rect.fromLTRB(
        _xPosition == 0 ? _xPosition + padding : _xPosition,
        _yPosition == 0 ? _yPosition + padding : _yPosition,
        _xPosition + _cellWidth == width
            ? _xPosition + _cellWidth - padding
            : _xPosition + _cellWidth,
        _yPosition + _cellHeight == height
            ? _yPosition + _cellHeight - padding
            : _yPosition + _cellHeight);

    _boxPainter = selectionDecoration!
        .createBoxPainter(_updateSelectionDecorationPainter);
    _boxPainter.paint(canvas, Offset(rect.left, rect.top),
        ImageConfiguration(size: rect.size, textDirection: TextDirection.ltr));
  }

  @override
  bool shouldRepaint(_SelectionPainter oldDelegate) {
    final _SelectionPainter oldWidget = oldDelegate;
    return oldWidget.selectionDecoration != selectionDecoration ||
        oldWidget.selectedDate != selectedDate ||
        oldWidget.view != view ||
        oldWidget.visibleDates != visibleDates ||
        oldWidget.selectedResourceIndex != selectedResourceIndex ||
        oldWidget.isRTL != isRTL;
  }
}

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
  final Color? cellBorderColor;
  final bool isTimelineView;
  final List<DateTime> visibleDates;
  final double textScaleFactor;
  final Paint _linePainter = Paint();
  final TextPainter _textPainter = TextPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    const double offset = 0.5;
    double xPosition, yPosition;
    DateTime date = visibleDates[0];

    xPosition = isRTL && isTimelineView ? size.width : 0;
    yPosition = timeIntervalHeight;
    _linePainter.strokeWidth = offset;
    _linePainter.color = cellBorderColor ?? calendarTheme.cellBorderColor!;

    if (!isTimelineView) {
      final double lineXPosition = isRTL ? offset : size.width - offset;
      // Draw vertical time label line
      canvas.drawLine(Offset(lineXPosition, 0),
          Offset(lineXPosition, size.height), _linePainter);
    }

    _textPainter.textDirection =
        CalendarViewHelper.getTextDirectionBasedOnLocale(locale);
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaler = TextScaler.linear(textScaleFactor);

    final TextStyle timeTextStyle = calendarTheme.timeTextStyle!;

    final double hour = (timeSlotViewSettings.startHour -
            timeSlotViewSettings.startHour.toInt()) *
        60;
    if (isTimelineView) {
      canvas.drawLine(Offset.zero, Offset(size.width, 0), _linePainter);
      final double timelineViewWidth =
          timeIntervalHeight * horizontalLinesCount;
      for (int i = 0; i < visibleDates.length; i++) {
        date = visibleDates[i];
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

  /// Draws the time labels in the time label view for timeslot views in
  /// calendar.
  void _drawTimeLabels(Canvas canvas, Size size, DateTime date, double hour,
      double xPosition, double yPosition, TextStyle timeTextStyle) {
    const int padding = 5;
    final int timeInterval =
        CalendarViewHelper.getTimeInterval(timeSlotViewSettings);

    final List<String> timeFormatStrings =
        CalendarViewHelper.getListFromString(timeSlotViewSettings.timeFormat);

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

      final double minute = (i * timeInterval) + hour;
      date = DateTime(date.year, date.month, date.day,
          timeSlotViewSettings.startHour.toInt(), minute.toInt());
      final String time = CalendarViewHelper.getLocalizedString(
          date, timeFormatStrings, locale);

      final TextSpan span = TextSpan(
        text: time,
        style: timeTextStyle,
      );

      final double cellWidth = isTimelineView ? timeIntervalHeight : size.width;

      _textPainter.text = span;
      _textPainter.layout(maxWidth: cellWidth);
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
  bool shouldRepaint(_TimeRulerView oldDelegate) {
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

class _CalendarMultiChildContainer extends Stack {
  const _CalendarMultiChildContainer(
      // ignore: unused_element
      {this.painter,
      List<Widget> children = const <Widget>[],
      required this.width,
      required this.height})
      : super(children: children);
  final CustomPainter? painter;
  final double width;
  final double height;

  @override
  RenderStack createRenderObject(BuildContext context) {
    final Directionality? widget =
        context.dependOnInheritedWidgetOfExactType<Directionality>();
    return _MultiChildContainerRenderObject(width, height,
        painter: painter, direction: widget?.textDirection);
  }

  @override
  void updateRenderObject(BuildContext context, RenderStack renderObject) {
    super.updateRenderObject(context, renderObject);
    if (renderObject is _MultiChildContainerRenderObject) {
      final Directionality? widget =
          context.dependOnInheritedWidgetOfExactType<Directionality>();
      renderObject
        ..width = width
        ..height = height
        ..painter = painter
        ..textDirection = widget?.textDirection;
    }
  }
}

class _MultiChildContainerRenderObject extends RenderStack {
  _MultiChildContainerRenderObject(this._width, this._height,
      {CustomPainter? painter, TextDirection? direction})
      : _painter = painter,
        super(textDirection: direction);

  CustomPainter? get painter => _painter;
  CustomPainter? _painter;

  set painter(CustomPainter? value) {
    if (_painter == value) {
      return;
    }

    final CustomPainter? oldPainter = _painter;
    _painter = value;
    _updatePainter(_painter, oldPainter);
    if (attached) {
      oldPainter?.removeListener(markNeedsPaint);
      _painter?.addListener(markNeedsPaint);
    }
  }

  double get width => _width;

  set width(double value) {
    if (_width == value) {
      return;
    }

    _width = value;
    markNeedsLayout();
  }

  double _width;
  double _height;

  double get height => _height;

  set height(double value) {
    if (_height == value) {
      return;
    }

    _height = value;
    markNeedsLayout();
  }

  /// Caches [SemanticsNode]s created during [assembleSemanticsNode] so they
  /// can be re-used when [assembleSemanticsNode] is called again. This ensures
  /// stable ids for the [SemanticsNode]s of children across
  /// [assembleSemanticsNode] invocations.
  /// Ref: assembleSemanticsNode method in RenderParagraph class
  /// (https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/rendering/paragraph.dart)
  List<SemanticsNode>? _cacheNodes;

  void _updatePainter(CustomPainter? newPainter, CustomPainter? oldPainter) {
    if (newPainter == null) {
      markNeedsPaint();
    } else if (oldPainter == null ||
        newPainter.runtimeType != oldPainter.runtimeType ||
        newPainter.shouldRepaint(oldPainter)) {
      markNeedsPaint();
    }

    if (newPainter == null) {
      if (attached) {
        markNeedsSemanticsUpdate();
      }
    } else if (oldPainter == null ||
        newPainter.runtimeType != oldPainter.runtimeType ||
        newPainter.shouldRebuildSemantics(oldPainter)) {
      markNeedsSemanticsUpdate();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _painter?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _painter?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? height : widgetSize.height);
    for (dynamic child = firstChild; child != null; child = childAfter(child)) {
      child.layout(constraints);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_painter != null) {
      _painter!.paint(context.canvas, size);
    }

    paintStack(context, offset);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = true;
  }

  @override
  void assembleSemanticsNode(
    SemanticsNode node,
    SemanticsConfiguration config,
    Iterable<SemanticsNode> children,
  ) {
    _cacheNodes ??= <SemanticsNode>[];
    final List<CustomPainterSemantics> semantics = _semanticsBuilder(size);
    final List<SemanticsNode> semanticsNodes = <SemanticsNode>[];
    for (int i = 0; i < semantics.length; i++) {
      final CustomPainterSemantics currentSemantics = semantics[i];
      final SemanticsNode newChild = _cacheNodes!.isNotEmpty
          ? _cacheNodes!.removeAt(0)
          : SemanticsNode(key: currentSemantics.key);

      final SemanticsProperties properties = currentSemantics.properties;
      final SemanticsConfiguration config = SemanticsConfiguration();
      if (properties.label != null) {
        config.label = properties.label!;
      }
      if (properties.textDirection != null) {
        config.textDirection = properties.textDirection;
      }

      newChild.updateWith(
        config: config,
        // As of now CustomPainter does not support multiple tree levels.
        childrenInInversePaintOrder: const <SemanticsNode>[],
      );

      newChild
        ..rect = currentSemantics.rect
        ..transform = currentSemantics.transform
        ..tags = currentSemantics.tags;

      semanticsNodes.add(newChild);
    }

    final List<SemanticsNode> finalChildren = <SemanticsNode>[];
    finalChildren.addAll(semanticsNodes);
    finalChildren.addAll(children);
    _cacheNodes = semanticsNodes;
    super.assembleSemanticsNode(node, config, finalChildren);
  }

  @override
  void clearSemantics() {
    super.clearSemantics();
    _cacheNodes = null;
  }

  SemanticsBuilderCallback get _semanticsBuilder {
    final List<CustomPainterSemantics> semantics = <CustomPainterSemantics>[];
    if (painter != null) {
      semantics.addAll(painter!.semanticsBuilder!(size));
    }
    // ignore: avoid_as
    for (RenderRepaintBoundary? child = firstChild! as RenderRepaintBoundary;
        child != null;
        // ignore: avoid_as
        child = childAfter(child) as RenderRepaintBoundary?) {
      if (child.child is! CustomCalendarRenderObject) {
        continue;
      }

      final CustomCalendarRenderObject appointmentRenderObject =
          // ignore: avoid_as
          child.child! as CustomCalendarRenderObject;
      semantics.addAll(appointmentRenderObject.semanticsBuilder!(size));
    }

    return (Size size) {
      return semantics;
    };
  }
}

class _CustomNeverScrollableScrollPhysics extends NeverScrollableScrollPhysics {
  /// Creates scroll physics that does not let the user scroll.
  const _CustomNeverScrollableScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  _CustomNeverScrollableScrollPhysics applyTo(ScrollPhysics? ancestor) {
    /// Set the clamping scroll physics as default parent for never scroll
    /// physics, because flutter framework set different parent physics
    /// based on platform(iOS, Android, etc.,)
    return _CustomNeverScrollableScrollPhysics(
        parent: buildParent(const ClampingScrollPhysics(
            parent: RangeMaintainingScrollPhysics())));
  }
}

class _CurrentTimeIndicator extends CustomPainter {
  _CurrentTimeIndicator(
    this.timeIntervalSize,
    this.timeRulerSize,
    this.timeSlotViewSettings,
    this.isTimelineView,
    this.visibleDates,
    this.todayHighlightColor,
    this.isRTL,
    ValueNotifier<int> repaintNotifier,
    this.timeZone,
  ) : super(repaint: repaintNotifier);
  final double timeIntervalSize;
  final TimeSlotViewSettings timeSlotViewSettings;
  final bool isTimelineView;
  final List<DateTime> visibleDates;
  final double timeRulerSize;
  final Color? todayHighlightColor;
  final bool isRTL;
  final String timeZone;

  @override
  void paint(Canvas canvas, Size size) {
    final DateTime now = DateTime.now();
    final int hours = now.hour;
    final int minutes = now.minute;
    final int totalMinutes = (hours * 60) + minutes;
    final int viewStartMinutes = (timeSlotViewSettings.startHour * 60).toInt();
    final int viewEndMinutes = (timeSlotViewSettings.endHour * 60).toInt();
    DateTime getLocationDateTime = DateTime.now();

    if (!timeZoneLoaded && timeZone == null) {
      return;
    }
    if (totalMinutes < viewStartMinutes || totalMinutes > viewEndMinutes) {
      return;
    }

    int index = -1;
    for (int i = 0; i < visibleDates.length; i++) {
      final DateTime date = visibleDates[i];
      if (isSameDate(date, now)) {
        index = i;
        break;
      }
    }

    if (index == -1) {
      return;
    }

    final double minuteHeight = timeIntervalSize /
        CalendarViewHelper.getTimeInterval(timeSlotViewSettings);

    if (timeZoneLoaded && timeZone != '') {
      getLocationDateTime = AppointmentHelper.convertTimezone(now, timeZone);
    } else {
      getLocationDateTime = DateTime.now();
    }

    final double currentTimePosition = CalendarViewHelper.getTimeToPosition(
        Duration(
            hours: getLocationDateTime.hour,
            minutes: getLocationDateTime.minute),
        timeSlotViewSettings,
        minuteHeight);
    final Paint painter = Paint()
      ..color = todayHighlightColor!
      ..strokeWidth = 1
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    if (isTimelineView) {
      final double viewSize = size.width / visibleDates.length;
      double startXPosition = (index * viewSize) + currentTimePosition;
      if (isRTL) {
        startXPosition = size.width - startXPosition;
      }
      canvas.drawCircle(Offset(startXPosition, 5), 5, painter);
      canvas.drawLine(Offset(startXPosition, 0),
          Offset(startXPosition, size.height), painter);
    } else {
      final double viewSize =
          (size.width - timeRulerSize) / visibleDates.length;
      final double startYPosition = currentTimePosition;
      double viewStartPosition = (index * viewSize) + timeRulerSize;
      double viewEndPosition = viewStartPosition + viewSize;
      double startXPosition = viewStartPosition < 5 ? 5 : viewStartPosition;
      if (isRTL) {
        viewStartPosition = size.width - viewStartPosition;
        viewEndPosition = size.width - viewEndPosition;
        startXPosition = size.width - startXPosition;
      }
      canvas.drawCircle(Offset(startXPosition, startYPosition), 5, painter);
      canvas.drawLine(Offset(viewStartPosition, startYPosition),
          Offset(viewEndPosition, startYPosition), painter);
    }
  }

  @override
  bool? hitTest(Offset position) {
    return false;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// Returns the date time value from the position.
DateTime? _timeFromPosition(
    DateTime date,
    TimeSlotViewSettings timeSlotViewSettings,
    double positionY,
    _CalendarViewState? currentState,
    double timeIntervalHeight,
    bool isTimelineView) {
  final double topPosition =
      currentState == null ? 0 : currentState._scrollController!.offset;

  final double singleIntervalHeightForAnHour =
      (60 / CalendarViewHelper.getTimeInterval(timeSlotViewSettings)) *
          timeIntervalHeight;
  final double startHour = timeSlotViewSettings.startHour;
  final double endHour = timeSlotViewSettings.endHour;
  if (isTimelineView) {
    if (currentState!._isRTL) {
      positionY = (currentState._scrollController!.offset %
              _getSingleViewWidthForTimeLineView(currentState)) +
          (currentState._scrollController!.position.viewportDimension -
              positionY);
    } else {
      positionY += currentState._scrollController!.offset %
          _getSingleViewWidthForTimeLineView(currentState);
    }
  } else {
    positionY += topPosition;
  }
  if (positionY >= 0) {
    double totalHour = positionY / singleIntervalHeightForAnHour;
    totalHour += startHour;
    int hour = totalHour.toInt();
    final int minute = ((totalHour - hour) * 60).round();
    if (isTimelineView) {
      while (hour >= endHour) {
        hour = ((hour - endHour) + startHour).toInt();
      }
    }
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  return DateTime(date.year, date.month, date.day);
}

/// Returns the single view width from the time line view for time line
double _getSingleViewWidthForTimeLineView(_CalendarViewState viewState) {
  return (viewState._scrollController!.position.maxScrollExtent +
          viewState._scrollController!.position.viewportDimension) /
      viewState.widget.visibleDates.length;
}

class _ResizingPaintDetails {
  _ResizingPaintDetails(
      // ignore: unused_element
      {this.appointmentView,
      required this.position,
      // ignore: unused_element
      this.isAllDayPanel = false,
      // ignore: unused_element
      this.scrollPosition,
      // ignore: unused_element
      this.monthRowCount = 0,
      // ignore: unused_element
      this.monthCellHeight,
      // ignore: unused_element
      this.appointmentColor = Colors.transparent,
      // ignore: unused_element
      this.resizingTime});

  AppointmentView? appointmentView;
  final ValueNotifier<Offset?> position;
  bool isAllDayPanel;
  double? scrollPosition;
  int monthRowCount;
  double? monthCellHeight;
  Color appointmentColor;
  DateTime? resizingTime;
}

class _ResizingAppointmentPainter extends CustomPainter {
  _ResizingAppointmentPainter(
      this.resizingDetails,
      this.isRTL,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.appointmentTextStyle,
      this.allDayHeight,
      this.viewHeaderHeight,
      this.timeLabelWidth,
      this.timeIntervalHeight,
      this.scrollController,
      this.dragAndDropSettings,
      this.view,
      this.mouseCursor,
      this.weekNumberPanelWidth,
      this.calendarTheme)
      : super(repaint: resizingDetails.value.position);

  final ValueNotifier<_ResizingPaintDetails> resizingDetails;

  final bool isRTL;

  final double textScaleFactor;

  final bool isMobilePlatform;

  final TextStyle appointmentTextStyle;

  final double allDayHeight;

  final double viewHeaderHeight;

  final ScrollController? scrollController;

  final CalendarView view;

  final double weekNumberPanelWidth;

  final SystemMouseCursor mouseCursor;

  final SfCalendarThemeData calendarTheme;

  final DragAndDropSettings dragAndDropSettings;

  final double timeLabelWidth;

  final double timeIntervalHeight;

  final Paint _shadowPainter = Paint();
  final TextPainter _textPainter = TextPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (resizingDetails.value.appointmentView == null ||
        resizingDetails.value.appointmentView!.appointmentRect == null) {
      return;
    }
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final double scrollOffset =
        view == CalendarView.month || resizingDetails.value.isAllDayPanel
            ? 0
            : resizingDetails.value.scrollPosition ?? scrollController!.offset;

    final bool isForwardResize = mouseCursor == SystemMouseCursors.resizeDown ||
        mouseCursor == SystemMouseCursors.resizeRight;
    final bool isBackwardResize = mouseCursor == SystemMouseCursors.resizeUp ||
        mouseCursor == SystemMouseCursors.resizeLeft;

    const int textStartPadding = 3;
    double xPosition = resizingDetails.value.position.value!.dx;
    double yPosition = resizingDetails.value.position.value!.dy;

    _shadowPainter.color = resizingDetails.value.appointmentColor;
    final bool isTimelineView = CalendarViewHelper.isTimelineView(view);

    final bool isHorizontalResize = resizingDetails.value.isAllDayPanel ||
        isTimelineView ||
        view == CalendarView.month;
    double left = resizingDetails.value.position.value!.dx,
        top = resizingDetails.value.appointmentView!.appointmentRect!.top,
        right = resizingDetails.value.appointmentView!.appointmentRect!.right,
        bottom = resizingDetails.value.appointmentView!.appointmentRect!.bottom;

    bool canUpdateSubjectPosition = true;
    late Rect rect;
    if (resizingDetails.value.monthRowCount != 0 &&
        view == CalendarView.month) {
      final int lastRow = resizingDetails.value.monthRowCount;
      for (int i = lastRow; i >= 0; i--) {
        if (i == 0) {
          if (isBackwardResize) {
            left = isRTL ? 0 : weekNumberPanelWidth;
            right =
                resizingDetails.value.appointmentView!.appointmentRect!.right;
            if (isRTL) {
              top -= resizingDetails.value.monthCellHeight!;
              xPosition = right;
              yPosition = top;
            } else {
              top += resizingDetails.value.monthCellHeight!;
            }
          } else {
            left = resizingDetails.value.appointmentView!.appointmentRect!.left;
            right = isRTL ? size.width - weekNumberPanelWidth : size.width;
            if (isRTL) {
              top += resizingDetails.value.monthCellHeight!;
            } else {
              top -= resizingDetails.value.monthCellHeight!;
            }

            if (!isRTL) {
              xPosition = left;
              yPosition = top;
            }
          }
        } else if (i == lastRow) {
          if (isBackwardResize) {
            left = resizingDetails.value.position.value!.dx;
            right = isRTL ? size.width - weekNumberPanelWidth : size.width;
            xPosition = left;
            yPosition = resizingDetails.value.position.value!.dy;
          } else {
            right = resizingDetails.value.position.value!.dx;
            left = isRTL ? 0 : weekNumberPanelWidth;
            if (!isRTL) {
              xPosition = right;
              yPosition = top;
            }
          }
          top = resizingDetails.value.position.value!.dy;
        } else {
          left = isRTL ? 0 : weekNumberPanelWidth;
          if (isForwardResize) {
            if (isRTL) {
              top += resizingDetails.value.monthCellHeight!;
            } else {
              top -= resizingDetails.value.monthCellHeight!;
            }
          } else {
            if (isRTL) {
              top -= resizingDetails.value.monthCellHeight!;
            } else {
              top += resizingDetails.value.monthCellHeight!;
            }
          }
          right = isRTL ? size.width : size.width - weekNumberPanelWidth;
        }

        bottom = top +
            resizingDetails.value.appointmentView!.appointmentRect!.height;
        rect = Rect.fromLTRB(left, top, right, bottom);
        canvas.drawRect(rect, _shadowPainter);
        paintBorder(canvas, rect,
            left: BorderSide(
                color: calendarTheme.selectionBorderColor!, width: 2),
            right: BorderSide(
                color: calendarTheme.selectionBorderColor!, width: 2),
            bottom: BorderSide(
                color: calendarTheme.selectionBorderColor!, width: 2),
            top: BorderSide(
                color: calendarTheme.selectionBorderColor!, width: 2));
      }
    } else {
      if (isForwardResize) {
        if (isHorizontalResize) {
          if (resizingDetails.value.isAllDayPanel ||
              view == CalendarView.month) {
            left = resizingDetails.value.appointmentView!.appointmentRect!.left;
          } else if (isTimelineView) {
            left =
                resizingDetails.value.appointmentView!.appointmentRect!.left -
                    scrollOffset;
            if (isRTL) {
              left =
                  scrollOffset + scrollController!.position.viewportDimension;
              left = left -
                  ((scrollController!.position.viewportDimension +
                          scrollController!.position.maxScrollExtent) -
                      resizingDetails
                          .value.appointmentView!.appointmentRect!.left);
            }
          }
          right = resizingDetails.value.position.value!.dx;
          top = resizingDetails.value.position.value!.dy;
          bottom = top +
              resizingDetails.value.appointmentView!.appointmentRect!.height;
        } else {
          top = resizingDetails.value.appointmentView!.appointmentRect!.top -
              scrollOffset +
              allDayHeight +
              viewHeaderHeight;
          bottom = resizingDetails.value.position.value!.dy;
          if (top < viewHeaderHeight + allDayHeight) {
            top = viewHeaderHeight + allDayHeight;
            canUpdateSubjectPosition = false;
          }
          bottom = bottom > size.height ? size.height : bottom;
        }

        xPosition = isRTL ? right : left;
      } else {
        if (isHorizontalResize) {
          if (resizingDetails.value.isAllDayPanel ||
              view == CalendarView.month) {
            right =
                resizingDetails.value.appointmentView!.appointmentRect!.right;
          } else if (isTimelineView) {
            right =
                resizingDetails.value.appointmentView!.appointmentRect!.right -
                    scrollOffset;
            if (isRTL) {
              right =
                  scrollOffset + scrollController!.position.viewportDimension;
              right = right -
                  ((scrollController!.position.viewportDimension +
                          scrollController!.position.maxScrollExtent) -
                      resizingDetails
                          .value.appointmentView!.appointmentRect!.right);
            }
          }

          left = resizingDetails.value.position.value!.dx;
          top = resizingDetails.value.position.value!.dy;
          bottom = top +
              resizingDetails.value.appointmentView!.appointmentRect!.height;
        } else {
          top = resizingDetails.value.position.value!.dy;
          bottom =
              resizingDetails.value.appointmentView!.appointmentRect!.bottom -
                  scrollOffset +
                  allDayHeight +
                  viewHeaderHeight;
          if (top < viewHeaderHeight + allDayHeight) {
            top = viewHeaderHeight + allDayHeight;
          }
          bottom = bottom > size.height ? size.height : bottom;
        }

        xPosition = isRTL ? right : left;
        if (!isHorizontalResize) {
          if (top < viewHeaderHeight + allDayHeight) {
            top = viewHeaderHeight + allDayHeight;
            canUpdateSubjectPosition = false;
          }
          bottom = bottom > size.height ? size.height : bottom;
        }
      }
      rect = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawRect(rect, _shadowPainter);
      yPosition = top;
    }
    if (dragAndDropSettings.showTimeIndicator &&
        resizingDetails.value.resizingTime != null) {
      _drawTimeIndicator(canvas, isTimelineView, size, isBackwardResize);
    }

    if (!canUpdateSubjectPosition) {
      return;
    }

    final TextSpan span = TextSpan(
      text: resizingDetails.value.appointmentView!.appointment!.subject,
      style: appointmentTextStyle,
    );

    final bool isRecurrenceAppointment =
        resizingDetails.value.appointmentView!.appointment!.recurrenceRule !=
                null &&
            resizingDetails
                .value.appointmentView!.appointment!.recurrenceRule!.isNotEmpty;

    _updateTextPainter(span);

    if (view != CalendarView.month) {
      _addSubjectTextForTimeslotViews(canvas, textStartPadding, xPosition,
          yPosition, isRecurrenceAppointment, rect);
    } else {
      _addSubjectTextForMonthView(
          canvas,
          resizingDetails.value.appointmentView!.appointmentRect!,
          appointmentTextStyle,
          span,
          isRecurrenceAppointment,
          xPosition,
          rect,
          yPosition);
    }

    paintBorder(canvas, rect,
        left: BorderSide(color: calendarTheme.selectionBorderColor!, width: 2),
        right: BorderSide(color: calendarTheme.selectionBorderColor!, width: 2),
        bottom:
            BorderSide(color: calendarTheme.selectionBorderColor!, width: 2),
        top: BorderSide(color: calendarTheme.selectionBorderColor!, width: 2));
  }

  /// Draw the time indicator when resizing the appointment on all calendar
  /// views except month and timelineMonth views.
  void _drawTimeIndicator(
      Canvas canvas, bool isTimelineView, Size size, bool isBackwardResize) {
    if (view == CalendarView.month || view == CalendarView.timelineMonth) {
      return;
    }

    if (!isTimelineView &&
        resizingDetails.value.position.value!.dy <
            viewHeaderHeight + allDayHeight) {
      return;
    }

    final TextSpan span = TextSpan(
      text: DateFormat(dragAndDropSettings.indicatorTimeFormat)
          .format(resizingDetails.value.resizingTime!),
      style: calendarTheme.timeIndicatorTextStyle,
    );
    _updateTextPainter(span);
    _textPainter.layout(
        maxWidth: isTimelineView ? timeIntervalHeight : timeLabelWidth);
    double xPosition;
    double yPosition;
    if (isTimelineView) {
      yPosition = viewHeaderHeight + (timeLabelWidth - _textPainter.height);
      xPosition = resizingDetails.value.position.value!.dx;
      if (isRTL) {
        xPosition -= _textPainter.width;
        if (isBackwardResize) {
          xPosition += _textPainter.width;
        }
      }
      if (!isBackwardResize && !isRTL) {
        xPosition -= _textPainter.width;
      }
    } else {
      yPosition = resizingDetails.value.position.value!.dy;
      xPosition = (timeLabelWidth - _textPainter.width) / 2;
      if (isRTL) {
        xPosition = (size.width - timeLabelWidth) + xPosition;
      }
    }
    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _addSubjectTextForTimeslotViews(
      Canvas canvas,
      int textStartPadding,
      double xPosition,
      double yPosition,
      bool isRecurrenceAppointment,
      Rect rect) {
    final double totalHeight =
        resizingDetails.value.appointmentView!.appointmentRect!.height -
            textStartPadding;
    _updatePainterMaxLines(totalHeight);

    double maxTextWidth =
        resizingDetails.value.appointmentView!.appointmentRect!.width -
            textStartPadding;
    maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
    _textPainter.layout(maxWidth: maxTextWidth);
    if (isRTL) {
      xPosition -= textStartPadding + _textPainter.width;
    }
    _textPainter.paint(
        canvas,
        Offset(xPosition + (isRTL ? 0 : textStartPadding),
            yPosition + textStartPadding));
    if (isRecurrenceAppointment ||
        resizingDetails.value.appointmentView!.appointment!.recurrenceId !=
            null) {
      double textSize = appointmentTextStyle.fontSize!;
      if (rect.width < textSize || rect.height < textSize) {
        textSize = rect.width > rect.height ? rect.height : rect.width;
      }
      _addRecurrenceIcon(
          rect, canvas, textStartPadding, isRecurrenceAppointment, textSize);
    }
  }

  void _addSubjectTextForMonthView(
      Canvas canvas,
      RRect appointmentRect,
      TextStyle style,
      TextSpan span,
      bool isRecurrenceAppointment,
      double xPosition,
      Rect rect,
      double yPosition) {
    double textSize = -1;
    if (textSize == -1) {
      //// left and right side padding value 2 subtracted in appointment width
      double maxTextWidth = appointmentRect.width - 2;
      maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
      for (double j = style.fontSize! - 1; j > 0; j--) {
        _textPainter.layout(maxWidth: maxTextWidth);
        if (_textPainter.height >= appointmentRect.height) {
          style = style.copyWith(fontSize: j);
          span = TextSpan(
              text: resizingDetails.value.appointmentView!.appointment!.subject,
              style: style);
          _updateTextPainter(span);
        } else {
          textSize = j + 1;
          break;
        }
      }
    } else {
      span = TextSpan(
          text: resizingDetails.value.appointmentView!.appointment!.subject,
          style: style.copyWith(fontSize: textSize));
      _updateTextPainter(span);
    }
    final double textWidth =
        appointmentRect.width - (isRecurrenceAppointment ? textSize : 1);
    _textPainter.layout(maxWidth: textWidth > 0 ? textWidth : 0);
    if (isRTL) {
      xPosition -= (isRTL ? 0 : 2) + _textPainter.width;
    }
    yPosition =
        yPosition + ((appointmentRect.height - _textPainter.height) / 2);
    _textPainter.paint(canvas, Offset(xPosition + (isRTL ? 0 : 2), yPosition));

    if (isRecurrenceAppointment ||
        resizingDetails.value.appointmentView!.appointment!.recurrenceId !=
            null) {
      _addRecurrenceIcon(rect, canvas, null, isRecurrenceAppointment, textSize);
    }
  }

  void _updateTextPainter(TextSpan span) {
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = isRTL ? TextAlign.right : TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaler = TextScaler.linear(textScaleFactor);
  }

  void _addRecurrenceIcon(Rect rect, Canvas canvas, int? textPadding,
      bool isRecurrenceAppointment, double textSize) {
    const double xPadding = 2;
    const double bottomPadding = 2;

    final TextSpan icon = AppointmentHelper.getRecurrenceIcon(
        appointmentTextStyle.color!, textSize, isRecurrenceAppointment);
    _textPainter.text = icon;

    if (view == CalendarView.month) {
      _textPainter.layout(maxWidth: rect.width + 1 > 0 ? rect.width + 1 : 0);
      final double yPosition =
          rect.top + ((rect.height - _textPainter.height) / 2);
      const double rightPadding = 0;
      final double recurrenceStartPosition = isRTL
          ? rect.left + rightPadding
          : rect.right - _textPainter.width - rightPadding;
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTRB(recurrenceStartPosition, yPosition,
                  recurrenceStartPosition + _textPainter.width, rect.bottom),
              resizingDetails.value.appointmentView!.appointmentRect!.tlRadius),
          _shadowPainter);
      _textPainter.paint(canvas, Offset(recurrenceStartPosition, yPosition));
    } else {
      double maxTextWidth =
          resizingDetails.value.appointmentView!.appointmentRect!.width -
              textPadding! -
              2;
      maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
      _textPainter.layout(maxWidth: maxTextWidth);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTRB(
                  isRTL
                      ? rect.left + textSize + xPadding
                      : rect.right - textSize - xPadding,
                  rect.bottom - bottomPadding - textSize,
                  isRTL ? rect.left : rect.right,
                  rect.bottom),
              resizingDetails.value.appointmentView!.appointmentRect!.tlRadius),
          _shadowPainter);
      _textPainter.paint(
          canvas,
          Offset(
              isRTL ? rect.left + xPadding : rect.right - textSize - xPadding,
              rect.bottom - bottomPadding - textSize));
    }
  }

  void _updatePainterMaxLines(double height) {
    /// [preferredLineHeight] is used to get the line height based on text
    /// style and text. floor the calculated value to set the minimum line
    /// count to painter max lines property.
    final int maxLines = (height / _textPainter.preferredLineHeight).floor();
    if (maxLines <= 0) {
      return;
    }

    _textPainter.maxLines = maxLines;
  }
}

dynamic _getCalendarAppointmentToObject(
    CalendarAppointment? calendarAppointment, SfCalendar calendar) {
  if (calendarAppointment == null) {
    return null;
  }

  final Appointment appointment =
      calendarAppointment.convertToCalendarAppointment();

  if (calendarAppointment.data is Appointment) {
    return appointment;
  }
  final dynamic customObject = calendar.dataSource!
      .convertAppointmentToObject(calendarAppointment.data, appointment);
  assert(customObject != null,
      'Implement convertToCalendarAppointment method from CalendarDataSource');
  return customObject;
}

class _DragPaintDetails {
  _DragPaintDetails(
      // ignore: unused_element
      {this.appointmentView,
      required this.position,
      // ignore: unused_element
      this.draggingTime,
      // ignore: unused_element
      this.timeIntervalHeight});

  AppointmentView? appointmentView;
  final ValueNotifier<Offset?> position;
  DateTime? draggingTime;
  double? timeIntervalHeight;
}

@immutable
class _DraggingAppointmentWidget extends StatefulWidget {
  const _DraggingAppointmentWidget(
      this.dragDetails,
      this.isRTL,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.appointmentTextStyle,
      this.dragAndDropSettings,
      this.calendarView,
      this.allDayPanelHeight,
      this.viewHeaderHeight,
      this.timeLabelWidth,
      this.resourceItemHeight,
      this.calendarTheme,
      this.calendar,
      this.width,
      this.height);

  final ValueNotifier<_DragPaintDetails> dragDetails;

  final bool isRTL;

  final double textScaleFactor;

  final bool isMobilePlatform;

  final TextStyle appointmentTextStyle;

  final DragAndDropSettings dragAndDropSettings;

  final CalendarView calendarView;

  final double allDayPanelHeight;

  final double viewHeaderHeight;

  final double timeLabelWidth;

  final double resourceItemHeight;

  final SfCalendarThemeData calendarTheme;

  final SfCalendar calendar;

  final double width;

  final double height;

  @override
  _DraggingAppointmentState createState() => _DraggingAppointmentState();
}

class _DraggingAppointmentState extends State<_DraggingAppointmentWidget> {
  AppointmentView? _draggingAppointmentView;

  @override
  void initState() {
    _draggingAppointmentView = widget.dragDetails.value.appointmentView;
    widget.dragDetails.value.position.addListener(_updateDraggingAppointment);
    super.initState();
  }

  @override
  void dispose() {
    widget.dragDetails.value.position
        .removeListener(_updateDraggingAppointment);
    super.dispose();
  }

  void _updateDraggingAppointment() {
    if (_draggingAppointmentView != widget.dragDetails.value.appointmentView) {
      _draggingAppointmentView = widget.dragDetails.value.appointmentView;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? child;
    if (widget.dragDetails.value.appointmentView != null &&
        widget.calendar.appointmentBuilder != null) {
      final DateTime date = DateTime(
          _draggingAppointmentView!.appointment!.actualStartTime.year,
          _draggingAppointmentView!.appointment!.actualStartTime.month,
          _draggingAppointmentView!.appointment!.actualStartTime.day);

      child = widget.calendar.appointmentBuilder!(
          context,
          CalendarAppointmentDetails(
              date,
              List<dynamic>.unmodifiable(<dynamic>[
                CalendarViewHelper.getAppointmentDetail(
                    _draggingAppointmentView!.appointment!,
                    widget.calendar.dataSource)
              ]),
              Rect.fromLTWH(
                  widget.dragDetails.value.position.value!.dx,
                  widget.dragDetails.value.position.value!.dy,
                  widget.isRTL
                      ? -_draggingAppointmentView!.appointmentRect!.width
                      : _draggingAppointmentView!.appointmentRect!.width,
                  _draggingAppointmentView!.appointmentRect!.height)));
    }

    return _DraggingAppointmentRenderObjectWidget(
      widget.dragDetails.value,
      widget.isRTL,
      widget.textScaleFactor,
      widget.isMobilePlatform,
      widget.appointmentTextStyle,
      widget.dragAndDropSettings,
      widget.calendarView,
      widget.allDayPanelHeight,
      widget.viewHeaderHeight,
      widget.timeLabelWidth,
      widget.resourceItemHeight,
      widget.calendarTheme,
      widget.width,
      widget.height,
      child: child,
    );
  }
}

@immutable
class _DraggingAppointmentRenderObjectWidget
    extends SingleChildRenderObjectWidget {
  const _DraggingAppointmentRenderObjectWidget(
      this.dragDetails,
      this.isRTL,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.appointmentTextStyle,
      this.dragAndDropSettings,
      this.calendarView,
      this.allDayPanelHeight,
      this.viewHeaderHeight,
      this.timeLabelWidth,
      this.resourceItemHeight,
      this.calendarTheme,
      this.width,
      this.height,
      {Widget? child})
      : super(child: child);
  final _DragPaintDetails dragDetails;

  final bool isRTL;

  final double textScaleFactor;

  final bool isMobilePlatform;

  final TextStyle appointmentTextStyle;

  final DragAndDropSettings dragAndDropSettings;

  final CalendarView calendarView;

  final double allDayPanelHeight;

  final double viewHeaderHeight;

  final double timeLabelWidth;

  final double resourceItemHeight;

  final SfCalendarThemeData calendarTheme;

  final double width;

  final double height;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _DraggingAppointmentRenderObject(
        dragDetails,
        isRTL,
        textScaleFactor,
        isMobilePlatform,
        appointmentTextStyle,
        dragAndDropSettings,
        calendarView,
        allDayPanelHeight,
        viewHeaderHeight,
        timeLabelWidth,
        resourceItemHeight,
        calendarTheme,
        width,
        height);
  }

  @override
  void updateRenderObject(
      BuildContext context, _DraggingAppointmentRenderObject renderObject) {
    renderObject
      ..dragDetails = dragDetails
      ..isRTL = isRTL
      ..textScaleFactor = textScaleFactor
      ..isMobilePlatform = isMobilePlatform
      ..appointmentTextStyle = appointmentTextStyle
      ..dragAndDropSettings = dragAndDropSettings
      ..calendarView = calendarView
      ..allDayPanelHeight = allDayPanelHeight
      ..viewHeaderHeight = viewHeaderHeight
      ..timeLabelWidth = timeLabelWidth
      ..resourceItemHeight = resourceItemHeight
      ..calendarTheme = calendarTheme
      ..width = width
      ..height = height;
  }
}

class _DraggingAppointmentRenderObject extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  _DraggingAppointmentRenderObject(
      this._dragDetails,
      this._isRTL,
      this._textScaleFactor,
      this._isMobilePlatform,
      this._appointmentTextStyle,
      this._dragAndDropSettings,
      this._calendarView,
      this._allDayPanelHeight,
      this._viewHeaderHeight,
      this._timeLabelWidth,
      this._resourceItemHeight,
      this._calendarTheme,
      this._width,
      this._height);

  double _width;

  double get width => _width;

  set width(double value) {
    if (_width == value) {
      return;
    }

    _width = value;
    if (child != null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  double _height;

  double get height => _height;

  set height(double value) {
    if (_height == value) {
      return;
    }

    _height = value;
    if (child != null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  _DragPaintDetails _dragDetails;

  _DragPaintDetails get dragDetails => _dragDetails;

  set dragDetails(_DragPaintDetails value) {
    if (_dragDetails == value) {
      return;
    }

    _dragDetails.position.removeListener(markNeedsPaint);
    _dragDetails = value;
    _dragDetails.position.addListener(markNeedsPaint);
    if (child == null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  bool _isRTL;

  bool get isRTL => _isRTL;

  set isRTL(bool value) {
    if (_isRTL == value) {
      return;
    }

    _isRTL = value;
    if (child == null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
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

  bool _isMobilePlatform;

  bool get isMobilePlatform => _isMobilePlatform;

  set isMobilePlatform(bool value) {
    if (_isMobilePlatform == value) {
      return;
    }

    _isMobilePlatform = value;
    if (child == null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  TextStyle _appointmentTextStyle;

  TextStyle get appointmentTextStyle => _appointmentTextStyle;

  set appointmentTextStyle(TextStyle value) {
    if (_appointmentTextStyle == value) {
      return;
    }

    _appointmentTextStyle = value;
    if (child == null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  DragAndDropSettings _dragAndDropSettings;

  DragAndDropSettings get dragAndDropSettings => _dragAndDropSettings;

  set dragAndDropSettings(DragAndDropSettings value) {
    if (_dragAndDropSettings == value) {
      return;
    }

    _dragAndDropSettings = value;
    if (child == null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  CalendarView _calendarView;

  CalendarView get calendarView => _calendarView;

  set calendarView(CalendarView value) {
    if (_calendarView == value) {
      return;
    }

    _calendarView = value;
    if (child == null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  double _allDayPanelHeight;

  double get allDayPanelHeight => _allDayPanelHeight;

  set allDayPanelHeight(double value) {
    if (_allDayPanelHeight == value) {
      return;
    }

    _allDayPanelHeight = value;
    if (child == null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  double _viewHeaderHeight;

  double get viewHeaderHeight => _viewHeaderHeight;

  set viewHeaderHeight(double value) {
    if (_viewHeaderHeight == value) {
      return;
    }

    _viewHeaderHeight = value;
    if (child == null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  double _timeLabelWidth;

  double get timeLabelWidth => _timeLabelWidth;

  set timeLabelWidth(double value) {
    if (_timeLabelWidth == value) {
      return;
    }

    _timeLabelWidth = value;
    if (child == null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  double _resourceItemHeight;

  double get resourceItemHeight => _resourceItemHeight;

  set resourceItemHeight(double value) {
    if (_resourceItemHeight == value) {
      return;
    }

    _resourceItemHeight = value;
    if (child == null) {
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
    if (child == null) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _dragDetails.position.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _dragDetails.position.removeListener(markNeedsPaint);
    super.detach();
  }

  final Paint _shadowPainter = Paint();

  final TextPainter _textPainter = TextPainter();

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? height : widgetSize.height);

    child?.layout(constraints.copyWith(
        minWidth: dragDetails.appointmentView!.appointmentRect!.width,
        minHeight: dragDetails.appointmentView!.appointmentRect!.height,
        maxWidth: dragDetails.appointmentView!.appointmentRect!.width,
        maxHeight: dragDetails.appointmentView!.appointmentRect!.height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final bool isTimelineView = CalendarViewHelper.isTimelineView(calendarView);
    if (child == null) {
      _drawDefaultUI(context.canvas, isTimelineView);
    } else {
      context.paintChild(
          child!,
          Offset(
              isRTL
                  ? dragDetails.position.value!.dx -
                      dragDetails.appointmentView!.appointmentRect!.width
                  : dragDetails.position.value!.dx,
              dragDetails.position.value!.dy));
      if (dragAndDropSettings.showTimeIndicator &&
          dragDetails.draggingTime != null) {
        _drawTimeIndicator(context.canvas, isTimelineView, size);
      }
    }
  }

  void _drawDefaultUI(Canvas canvas, bool isTimelineView) {
    if (dragDetails.appointmentView == null ||
        dragDetails.appointmentView!.appointmentRect == null) {
      return;
    }

    const int textStartPadding = 3;
    double xPosition;
    double yPosition;
    xPosition = dragDetails.position.value!.dx;
    yPosition = dragDetails.position.value!.dy;
    _shadowPainter.color =
        dragDetails.appointmentView!.appointment!.color.withOpacity(0.5);

    final RRect rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            dragDetails.position.value!.dx,
            dragDetails.position.value!.dy,
            isRTL
                ? -dragDetails.appointmentView!.appointmentRect!.width
                : dragDetails.appointmentView!.appointmentRect!.width,
            dragDetails.appointmentView!.appointmentRect!.height),
        dragDetails.appointmentView!.appointmentRect!.tlRadius);
    final Path path = Path();
    path.addRRect(rect);
    canvas.drawPath(path, _shadowPainter);
    canvas.drawShadow(path, _shadowPainter.color, 0.1, true);
    final TextSpan span = TextSpan(
      text: dragDetails.appointmentView!.appointment!.subject,
      style: appointmentTextStyle,
    );

    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = isRTL ? TextAlign.right : TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaler = TextScaler.linear(textScaleFactor);
    double maxTextWidth =
        dragDetails.appointmentView!.appointmentRect!.width - textStartPadding;
    maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
    _textPainter.layout(maxWidth: maxTextWidth);

    if (isRTL) {
      xPosition -= textStartPadding + _textPainter.width;
    }

    final double totalHeight =
        dragDetails.appointmentView!.appointmentRect!.height - textStartPadding;
    _updatePainterMaxLines(totalHeight);

    maxTextWidth =
        dragDetails.appointmentView!.appointmentRect!.width - textStartPadding;
    maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
    _textPainter.layout(maxWidth: maxTextWidth);

    _textPainter.paint(
        canvas,
        isTimelineView
            ? Offset(xPosition + (isRTL ? 0 : textStartPadding),
                yPosition + textStartPadding)
            : Offset(xPosition + (isRTL ? 0 : textStartPadding),
                yPosition + textStartPadding));
    if (dragAndDropSettings.showTimeIndicator &&
        dragDetails.draggingTime != null) {
      _drawTimeIndicator(canvas, isTimelineView, size);
    }
  }

  void _drawTimeIndicator(Canvas canvas, bool isTimelineView, Size size) {
    if (calendarView == CalendarView.month ||
        calendarView == CalendarView.timelineMonth) {
      return;
    }

    final TextSpan span = TextSpan(
      text: DateFormat(dragAndDropSettings.indicatorTimeFormat)
          .format(dragDetails.draggingTime!),
      style: calendarTheme.timeIndicatorTextStyle,
    );
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = isRTL ? TextAlign.right : TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaler = TextScaler.linear(textScaleFactor);
    final double timeLabelSize =
        isTimelineView ? dragDetails.timeIntervalHeight! : timeLabelWidth;
    _textPainter.layout(maxWidth: timeLabelSize);
    double xPosition;
    double yPosition;
    if (isTimelineView) {
      yPosition = viewHeaderHeight + (timeLabelWidth - _textPainter.height);
      xPosition = dragDetails.position.value!.dx;
      if (isRTL) {
        xPosition -= _textPainter.width;
      }
    } else {
      yPosition = dragDetails.position.value!.dy;
      xPosition = (timeLabelSize - _textPainter.width) / 2;
      if (isRTL) {
        xPosition = (size.width - timeLabelSize) + xPosition;
      }
    }
    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  void _updatePainterMaxLines(double height) {
    /// [preferredLineHeight] is used to get the line height based on text
    /// style and text. floor the calculated value to set the minimum line
    /// count to painter max lines property.
    final int maxLines = (height / _textPainter.preferredLineHeight).floor();
    if (maxLines <= 0) {
      return;
    }

    _textPainter.maxLines = maxLines;
  }
}
