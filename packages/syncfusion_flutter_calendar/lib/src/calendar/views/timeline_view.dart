import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../appointment_engine/appointment_helper.dart';
import '../common/calendar_view_helper.dart';
import '../common/date_time_engine.dart';
import '../common/event_args.dart';
import '../resource_view/calendar_resource.dart';
import '../settings/time_slot_view_settings.dart';
import '../settings/view_header_style.dart';

/// Used to hold the time slots view on calendar timeline views.
class TimelineWidget extends StatefulWidget {
  /// Constructor to create the timeline widget to holds time slots view for
  /// timeline views.
  const TimelineWidget(
      this.horizontalLinesCountPerView,
      this.visibleDates,
      this.timeSlotViewSettings,
      this.timeIntervalWidth,
      this.cellBorderColor,
      this.isRTL,
      this.calendarTheme,
      this.themeData,
      this.calendarCellNotifier,
      this.scrollController,
      this.specialRegion,
      this.resourceItemHeight,
      this.resourceCollection,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.timeRegionBuilder,
      this.width,
      this.height,
      this.minDate,
      this.maxDate,
      this.blackoutDates);

  /// Defines the total number of time slots needed in the view.
  final double horizontalLinesCountPerView;

  /// Holds the visible dates collection for current timeline view.
  final List<DateTime> visibleDates;

  /// Defines the timeline view slot setting used to customize the time slots.
  final TimeSlotViewSettings timeSlotViewSettings;

  /// Defines the width of time slot view.
  final double timeIntervalWidth;

  /// Defines the time slot border color.
  final Color? cellBorderColor;

  /// Holds the theme data value for calendar.
  final SfCalendarThemeData calendarTheme;

  /// Holds the framework theme data values.
  final ThemeData themeData;

  /// Defines the direction of the calendar widget is RTL or not.
  final bool isRTL;

  /// Used to draw the hovering on timeline view.
  final ValueNotifier<Offset?> calendarCellNotifier;

  /// Used to get the current scroll position of the timeline view.
  final ScrollController scrollController;

  /// Defines the special time region for the current timeline view.
  final List<CalendarTimeRegion>? specialRegion;

  /// Defines the resource view item height.
  final double resourceItemHeight;

  /// Holds the resource collection used to draw the time slots based on
  /// resource value.
  final List<CalendarResource>? resourceCollection;

  /// Defines the scale factor for the time slot time text.
  final double textScaleFactor;

  /// Defines the current platform is mobile platform or not.
  final bool isMobilePlatform;

  /// Holds the current timeline widget width.
  final double width;

  /// Holds the current timeline widget height.
  final double height;

  /// Used to build the widget that replaces the time regions in timeline view.
  final TimeRegionBuilder? timeRegionBuilder;

  /// Defines the min date of the calendar.
  final DateTime minDate;

  /// Defines the max date of the calendar.
  final DateTime maxDate;

  /// Holds the blackout dates collection of calendar.
  final List<DateTime>? blackoutDates;

  @override
  // ignore: library_private_types_in_public_api
  _TimelineWidgetState createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  final List<Widget> _children = <Widget>[];
  List<TimeRegionView> _specialRegionViews = <TimeRegionView>[];

  @override
  void initState() {
    _updateSpecialRegionDetails();
    super.initState();
  }

  @override
  void didUpdateWidget(TimelineWidget oldWidget) {
    if (widget.visibleDates != oldWidget.visibleDates ||
        widget.timeIntervalWidth != oldWidget.timeIntervalWidth ||
        widget.timeSlotViewSettings != oldWidget.timeSlotViewSettings ||
        widget.isRTL != oldWidget.isRTL ||
        widget.resourceItemHeight != oldWidget.resourceItemHeight ||
        widget.resourceCollection != oldWidget.resourceCollection ||
        widget.width != oldWidget.width ||
        widget.height != oldWidget.height ||
        widget.timeRegionBuilder != oldWidget.timeRegionBuilder ||
        !CalendarViewHelper.isCollectionEqual(
            widget.specialRegion, oldWidget.specialRegion)) {
      _updateSpecialRegionDetails();
      _children.clear();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_children.isEmpty &&
        widget.timeRegionBuilder != null &&
        _specialRegionViews.isNotEmpty) {
      final int count = _specialRegionViews.length;
      for (int i = 0; i < count; i++) {
        final TimeRegionView view = _specialRegionViews[i];
        final Widget child = widget.timeRegionBuilder!(
            context,
            TimeRegionDetails(view.region.data,
                widget.visibleDates[view.visibleIndex], view.bound));

        _children.add(RepaintBoundary(child: child));
      }
    }

    return _TimelineRenderWidget(
      widget.horizontalLinesCountPerView,
      widget.visibleDates,
      widget.timeSlotViewSettings,
      widget.timeIntervalWidth,
      widget.cellBorderColor,
      widget.isRTL,
      widget.calendarTheme,
      widget.themeData,
      widget.calendarCellNotifier,
      widget.scrollController,
      widget.specialRegion,
      widget.resourceItemHeight,
      widget.resourceCollection,
      widget.textScaleFactor,
      widget.isMobilePlatform,
      widget.width,
      widget.height,
      _specialRegionViews,
      widget.minDate,
      widget.maxDate,
      widget.blackoutDates,
      widgets: _children,
    );
  }

  void _updateSpecialRegionDetails() {
    _specialRegionViews = <TimeRegionView>[];
    final int visibleDatesCount = widget.visibleDates.length;
    if (visibleDatesCount > DateTime.daysPerWeek ||
        widget.specialRegion == null ||
        widget.specialRegion!.isEmpty) {
      return;
    }

    final double minuteHeight = widget.timeIntervalWidth /
        CalendarViewHelper.getTimeInterval(widget.timeSlotViewSettings);
    final DateTime startDate =
        AppointmentHelper.convertToStartTime(widget.visibleDates[0]);
    final DateTime endDate = AppointmentHelper.convertToEndTime(
        widget.visibleDates[visibleDatesCount - 1]);
    final double viewWidth = widget.width / visibleDatesCount;
    final bool isResourceEnabled = widget.resourceCollection != null &&
        widget.resourceCollection!.isNotEmpty;
    for (int i = 0; i < widget.specialRegion!.length; i++) {
      final CalendarTimeRegion region = widget.specialRegion![i];
      final DateTime regionStartTime = region.actualStartTime;
      final DateTime regionEndTime = region.actualEndTime;

      /// Check the start date and end date as same.
      if (CalendarViewHelper.isSameTimeSlot(regionStartTime, regionEndTime)) {
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

      int startIndex = DateTimeHelper.getVisibleDateIndex(
          widget.visibleDates, regionStartTime);
      int endIndex = DateTimeHelper.getVisibleDateIndex(
          widget.visibleDates, regionEndTime);

      double startXPosition = CalendarViewHelper.getTimeToPosition(
          Duration(
              hours: regionStartTime.hour, minutes: regionStartTime.minute),
          widget.timeSlotViewSettings,
          minuteHeight);
      if (startIndex == -1) {
        if (startDate.isAfter(regionStartTime)) {
          /// Set index as 0 when the region start date before the visible
          /// start date
          startIndex = 0;
        } else {
          /// Find the next index when the start date as non working date.
          for (int k = 1; k < visibleDatesCount; k++) {
            final DateTime currentDate = widget.visibleDates[k];
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

      double endXPosition = CalendarViewHelper.getTimeToPosition(
          Duration(hours: regionEndTime.hour, minutes: regionEndTime.minute),
          widget.timeSlotViewSettings,
          minuteHeight);
      if (endIndex == -1) {
        /// Find the previous index when the end date as non working date.
        if (endDate.isAfter(regionEndTime)) {
          for (int k = visibleDatesCount - 2; k >= 0; k--) {
            final DateTime currentDate = widget.visibleDates[k];
            if (currentDate.isAfter(regionEndTime)) {
              continue;
            }

            endIndex = k;
            break;
          }

          if (endIndex == -1) {
            endIndex = visibleDatesCount - 1;
          }
        } else {
          /// Set index as visible date end date index when the
          /// region end date before the visible end date
          endIndex = visibleDatesCount - 1;
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
          (startPosition >= widget.width && endPosition >= widget.width) ||
          (startPosition == endPosition)) {
        continue;
      }

      if (widget.isRTL) {
        startPosition = widget.width - startPosition;
        endPosition = widget.width - endPosition;
      }

      double topPosition = 0;
      double bottomPosition = widget.height;
      if (isResourceEnabled &&
          region.resourceIds != null &&
          region.resourceIds!.isNotEmpty) {
        for (int i = 0; i < region.resourceIds!.length; i++) {
          final int index = CalendarViewHelper.getResourceIndex(
              widget.resourceCollection, region.resourceIds![i]);
          topPosition = index * widget.resourceItemHeight;
          bottomPosition = topPosition + widget.resourceItemHeight;
          _updateSpecialRegionRect(region, startPosition, endPosition,
              topPosition, bottomPosition, startIndex);
        }
      } else {
        _updateSpecialRegionRect(region, startPosition, endPosition,
            topPosition, bottomPosition, startIndex);
      }
    }
  }

  void _updateSpecialRegionRect(
      CalendarTimeRegion region,
      double startPosition,
      double endPosition,
      double topPosition,
      double bottomPosition,
      int index) {
    Rect rect;
    if (widget.isRTL) {
      rect = Rect.fromLTRB(
          endPosition, topPosition, startPosition, bottomPosition);
    } else {
      rect = Rect.fromLTRB(
          startPosition, topPosition, endPosition, bottomPosition);
    }

    _specialRegionViews.add(TimeRegionView(index, region, rect));
  }
}

class _TimelineRenderWidget extends MultiChildRenderObjectWidget {
  const _TimelineRenderWidget(
      this.horizontalLinesCountPerView,
      this.visibleDates,
      this.timeSlotViewSettings,
      this.timeIntervalWidth,
      this.cellBorderColor,
      this.isRTL,
      this.calendarTheme,
      this.themeData,
      this.calendarCellNotifier,
      this.scrollController,
      this.specialRegion,
      this.resourceItemHeight,
      this.resourceCollection,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.width,
      this.height,
      this.specialRegionBounds,
      this.minDate,
      this.maxDate,
      this.blackoutDates,
      {List<Widget> widgets = const <Widget>[]})
      : super(children: widgets);

  final double horizontalLinesCountPerView;
  final List<DateTime> visibleDates;
  final TimeSlotViewSettings timeSlotViewSettings;
  final double timeIntervalWidth;
  final Color? cellBorderColor;
  final SfCalendarThemeData calendarTheme;
  final ThemeData themeData;
  final bool isRTL;
  final ValueNotifier<Offset?> calendarCellNotifier;
  final ScrollController scrollController;
  final List<CalendarTimeRegion>? specialRegion;
  final double resourceItemHeight;
  final List<CalendarResource>? resourceCollection;
  final double textScaleFactor;
  final bool isMobilePlatform;
  final double width;
  final double height;
  final List<TimeRegionView> specialRegionBounds;
  final DateTime minDate;
  final DateTime maxDate;
  final List<DateTime>? blackoutDates;

  @override
  _TimelineRenderObject createRenderObject(BuildContext context) {
    return _TimelineRenderObject(
        horizontalLinesCountPerView,
        visibleDates,
        timeSlotViewSettings,
        timeIntervalWidth,
        cellBorderColor,
        isRTL,
        calendarTheme,
        themeData,
        calendarCellNotifier,
        scrollController,
        specialRegion,
        resourceItemHeight,
        resourceCollection,
        textScaleFactor,
        isMobilePlatform,
        width,
        height,
        specialRegionBounds,
        minDate,
        maxDate,
        blackoutDates);
  }

  @override
  void updateRenderObject(
      BuildContext context, _TimelineRenderObject renderObject) {
    renderObject
      ..horizontalLinesCountPerView = horizontalLinesCountPerView
      ..visibleDates = visibleDates
      ..timeSlotViewSettings = timeSlotViewSettings
      ..timeIntervalWidth = timeIntervalWidth
      ..cellBorderColor = cellBorderColor
      ..isRTL = isRTL
      ..calendarTheme = calendarTheme
      ..themeData = themeData
      ..calendarCellNotifier = calendarCellNotifier
      ..scrollController = scrollController
      ..specialRegion = specialRegion
      ..resourceItemHeight = resourceItemHeight
      ..resourceCollection = resourceCollection
      ..textScaleFactor = textScaleFactor
      ..isMobilePlatform = isMobilePlatform
      ..width = width
      ..height = height
      ..minDate = minDate
      ..maxDate = maxDate
      ..blackoutDates = blackoutDates
      ..specialRegionBounds = specialRegionBounds;
  }
}

class _TimelineRenderObject extends CustomCalendarRenderObject {
  _TimelineRenderObject(
      this._horizontalLinesCountPerView,
      this._visibleDates,
      this._timeSlotViewSettings,
      this._timeIntervalWidth,
      this._cellBorderColor,
      this._isRTL,
      this._calendarTheme,
      this._themeData,
      this._calendarCellNotifier,
      this.scrollController,
      this._specialRegion,
      this._resourceItemHeight,
      this.resourceCollection,
      this._textScaleFactor,
      this.isMobilePlatform,
      this._width,
      this._height,
      this.specialRegionBounds,
      this._minDate,
      this._maxDate,
      this._blackoutDates);

  double _horizontalLinesCountPerView;

  double get horizontalLinesCountPerView => _horizontalLinesCountPerView;

  set horizontalLinesCountPerView(double value) {
    if (_horizontalLinesCountPerView == value) {
      return;
    }

    _horizontalLinesCountPerView = value;
    markNeedsPaint();
  }

  List<DateTime> _visibleDates;

  List<DateTime> get visibleDates => _visibleDates;

  set visibleDates(List<DateTime> value) {
    if (_visibleDates == value) {
      return;
    }

    _visibleDates = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  TimeSlotViewSettings _timeSlotViewSettings;

  TimeSlotViewSettings get timeSlotViewSettings => _timeSlotViewSettings;

  set timeSlotViewSettings(TimeSlotViewSettings value) {
    if (_timeSlotViewSettings == value) {
      return;
    }

    _timeSlotViewSettings = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  double _timeIntervalWidth;

  double get timeIntervalWidth => _timeIntervalWidth;

  set timeIntervalWidth(double value) {
    if (_timeIntervalWidth == value) {
      return;
    }

    _timeIntervalWidth = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  Color? _cellBorderColor;

  Color? get cellBorderColor => _cellBorderColor;

  set cellBorderColor(Color? value) {
    if (_cellBorderColor == value) {
      return;
    }

    _cellBorderColor = value;
    markNeedsPaint();
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

  ThemeData _themeData;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData value) {
    if (_themeData == value) {
      return;
    }

    _themeData = value;
  }

  double _resourceItemHeight;

  double get resourceItemHeight => _resourceItemHeight;

  set resourceItemHeight(double value) {
    if (_resourceItemHeight == value) {
      return;
    }

    _resourceItemHeight = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  List<CalendarResource>? resourceCollection;

  bool _isRTL;

  bool get isRTL => _isRTL;

  set isRTL(bool value) {
    if (_isRTL == value) {
      return;
    }

    _isRTL = value;
    markNeedsPaint();
  }

  ValueNotifier<Offset?> _calendarCellNotifier;

  ValueNotifier<Offset?> get calendarCellNotifier => _calendarCellNotifier;

  set calendarCellNotifier(ValueNotifier<Offset?> value) {
    if (_calendarCellNotifier == value) {
      return;
    }

    _calendarCellNotifier.removeListener(markNeedsPaint);
    _calendarCellNotifier = value;
    _calendarCellNotifier.addListener(markNeedsPaint);
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

  double _height;

  double get height => _height;

  set height(double value) {
    if (_height == value) {
      return;
    }

    _height = value;
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

  List<CalendarTimeRegion>? _specialRegion;

  List<CalendarTimeRegion>? get specialRegion => _specialRegion;

  set specialRegion(List<CalendarTimeRegion>? value) {
    if (CalendarViewHelper.isCollectionEqual(_specialRegion, value)) {
      return;
    }

    _specialRegion = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  List<TimeRegionView> specialRegionBounds;

  DateTime _minDate;

  DateTime get minDate => _minDate;

  set minDate(DateTime value) {
    if (CalendarViewHelper.isSameTimeSlot(_minDate, value)) {
      return;
    }

    _minDate = value;
    markNeedsPaint();
  }

  DateTime _maxDate;

  DateTime get maxDate => _maxDate;

  set maxDate(DateTime value) {
    if (CalendarViewHelper.isSameTimeSlot(_maxDate, value)) {
      return;
    }

    _maxDate = value;
    markNeedsPaint();
  }

  List<DateTime>? _blackoutDates;

  List<DateTime>? get blackoutDates => _blackoutDates;

  set blackoutDates(List<DateTime>? value) {
    if (CalendarViewHelper.isDateCollectionEqual(_blackoutDates, value)) {
      return;
    }

    _blackoutDates = value;
    markNeedsPaint();
  }

  late ScrollController scrollController;
  late bool isMobilePlatform;
  final Paint _linePainter = Paint();

  @override
  bool get isRepaintBoundary => true;

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _calendarCellNotifier.addListener(markNeedsPaint);
  }

  /// detach will called when the render object removed from view.
  @override
  void detach() {
    _calendarCellNotifier.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? height : widgetSize.height);
    RenderBox? child = firstChild;
    if (specialRegion == null || specialRegion!.isEmpty) {
      return;
    }

    final int count = specialRegionBounds.length;
    for (int i = 0; i < count; i++) {
      final TimeRegionView view = specialRegionBounds[i];
      if (child == null) {
        continue;
      }
      final Rect rect = view.bound;
      child.layout(constraints.copyWith(
          minHeight: rect.height,
          maxHeight: rect.height,
          minWidth: rect.width,
          maxWidth: rect.width));
      child = childAfter(child);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    final bool isNeedDefaultPaint = childCount == 0;
    final bool isResourceEnabled =
        resourceCollection != null && resourceCollection!.isNotEmpty;
    final int visibleDatesCount = visibleDates.length;
    final bool isTimelineMonth = visibleDatesCount > DateTime.daysPerWeek;
    _minMaxExceeds(visibleDatesCount, isTimelineMonth, minDate, maxDate,
        blackoutDates, context.canvas);
    if (isNeedDefaultPaint) {
      _addSpecialRegion(context.canvas, isResourceEnabled, isTimelineMonth);
    } else {
      if (specialRegion == null || specialRegion!.isEmpty) {
        return;
      }

      final int count = specialRegionBounds.length;
      for (int i = 0; i < count; i++) {
        final TimeRegionView view = specialRegionBounds[i];
        if (child == null) {
          continue;
        }
        final Rect rect = view.bound;
        context.paintChild(child, Offset(rect.left, rect.top));
        child = childAfter(child);
      }
    }

    _drawTimeline(context.canvas, isResourceEnabled, visibleDatesCount);
  }

  void _minMaxExceeds(
      int visibleDatesCount,
      bool isTimelineMonth,
      DateTime minDate,
      DateTime maxDate,
      List<DateTime>? blackoutDates,
      Canvas canvas) {
    final DateTime visibleStartDate = visibleDates[0];
    final DateTime visibleEndDate = visibleDates[visibleDatesCount - 1];
    final int timeInterval =
        CalendarViewHelper.getTimeInterval(timeSlotViewSettings);

    if (isDateWithInDateRange(visibleStartDate, visibleEndDate, minDate)) {
      _drawDisabledDate(minDate, false, false, canvas, isTimelineMonth,
          timeInterval, visibleDatesCount);
    }
    if (isDateWithInDateRange(visibleStartDate, visibleEndDate, maxDate)) {
      _drawDisabledDate(maxDate, true, false, canvas, isTimelineMonth,
          timeInterval, visibleDatesCount);
    }

    if (blackoutDates == null || !isTimelineMonth) {
      return;
    }

    final int count = blackoutDates.length;
    for (int i = 0; i < count; i++) {
      final DateTime blackoutDate = blackoutDates[i];
      if (isDateWithInDateRange(
          visibleStartDate, visibleEndDate, blackoutDate)) {
        _drawDisabledDate(blackoutDate, false, true, canvas, isTimelineMonth,
            timeInterval, visibleDatesCount);
      }
    }
  }

  void _drawDisabledDate(
      DateTime disabledDate,
      bool isMaxDate,
      bool isBlackOutDate,
      Canvas canvas,
      bool isTimelineMonth,
      int timeInterval,
      int visibleDatesCount) {
    final double minuteHeight = timeIntervalWidth / timeInterval;
    final double viewWidth = width / visibleDatesCount;
    final int dateIndex =
        DateTimeHelper.getVisibleDateIndex(visibleDates, disabledDate);
    double leftPosition = 0;
    const double topPosition = 0;

    final double xPosition = isTimelineMonth
        ? 0
        : CalendarViewHelper.getTimeToPosition(
            Duration(hours: disabledDate.hour, minutes: disabledDate.minute),
            timeSlotViewSettings,
            minuteHeight);
    double rightPosition = (dateIndex * viewWidth) + xPosition;
    if (isMaxDate == true) {
      leftPosition =
          (dateIndex * viewWidth) + (isTimelineMonth ? viewWidth : xPosition);
      rightPosition = size.width;
    }
    final double bottomPosition = topPosition + height;
    if (isBlackOutDate == true) {
      leftPosition = dateIndex * timeIntervalWidth;
      rightPosition = leftPosition + timeIntervalWidth;
    }
    Rect rect;
    if (isRTL) {
      leftPosition = width - leftPosition;
      rightPosition = width - rightPosition;
    }
    rect =
        Rect.fromLTRB(leftPosition, topPosition, rightPosition, bottomPosition);
    _linePainter.style = PaintingStyle.fill;
    _linePainter.color = Colors.grey.withOpacity(0.2);
    canvas.drawRect(rect, _linePainter);
  }

  void _drawTimeline(
      Canvas canvas, bool isResourceEnabled, int visibleDatesCount) {
    _linePainter.strokeWidth = 0.5;
    _linePainter.strokeCap = StrokeCap.round;
    _linePainter.color = cellBorderColor ?? calendarTheme.cellBorderColor!;
    double startXPosition = 0;
    double endXPosition = size.width;
    double startYPosition = 0.5;
    double endYPosition = 0.5;

    final Offset start = Offset(startXPosition, startYPosition);
    final Offset end = Offset(endXPosition, endYPosition);
    canvas.drawLine(start, end, _linePainter);

    startXPosition = 0;
    endXPosition = 0;
    startYPosition = 0;
    endYPosition = size.height;
    if (isRTL) {
      startXPosition = size.width;
      endXPosition = size.width;
    }

    final List<Offset> points = <Offset>[];
    for (int i = 0; i < horizontalLinesCountPerView * visibleDatesCount; i++) {
      if (isMobilePlatform) {
        points.add(Offset(startXPosition, startYPosition));
        points.add(Offset(endXPosition, endYPosition));
      } else {
        canvas.drawLine(Offset(startXPosition, startYPosition),
            Offset(endXPosition, endYPosition), _linePainter);
      }

      if (isRTL) {
        startXPosition -= timeIntervalWidth;
        endXPosition -= timeIntervalWidth;
      } else {
        startXPosition += timeIntervalWidth;
        endXPosition += timeIntervalWidth;
      }
    }

    if (isMobilePlatform) {
      canvas.drawPoints(PointMode.lines, points, _linePainter);
    }

    /// Draws the vertical line to separate the slots based on resource count.
    if (isResourceEnabled) {
      startXPosition = 0;
      endXPosition = size.width;
      startYPosition = resourceItemHeight;
      for (int i = 0; i < resourceCollection!.length; i++) {
        canvas.drawLine(Offset(startXPosition, startYPosition),
            Offset(endXPosition, startYPosition), _linePainter);
        startYPosition += resourceItemHeight;
      }
    }

    if (calendarCellNotifier.value != null) {
      _addMouseHovering(canvas, size, isResourceEnabled);
    }
  }

  void _addMouseHovering(Canvas canvas, Size size, bool isResourceEnabled) {
    double left = (calendarCellNotifier.value!.dx ~/ timeIntervalWidth) *
        timeIntervalWidth;
    double top = 0;
    double height = size.height;
    if (isResourceEnabled) {
      final int index =
          (calendarCellNotifier.value!.dy / resourceItemHeight).truncate();
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
    double width = timeIntervalWidth;
    double difference = 0;
    if (isRTL &&
        (size.width - scrollController.offset) <
            scrollController.position.viewportDimension) {
      difference = scrollController.position.viewportDimension - size.width;
    }

    if ((size.width - scrollController.offset) <
            scrollController.position.viewportDimension &&
        (left + timeIntervalWidth).round() == size.width.round()) {
      width -= padding;
    }

    _linePainter.style = PaintingStyle.stroke;
    _linePainter.strokeWidth = 2;
    _linePainter.color = calendarTheme.selectionBorderColor!.withOpacity(0.4);
    left = left == 0 ? left - difference + padding : left - difference;
    canvas.drawRect(Rect.fromLTWH(left, top, width, height), _linePainter);
  }

  /// Calculate the position for special regions and draw the special regions
  /// in the timeline views .
  void _addSpecialRegion(
      Canvas canvas, bool isResourceEnabled, bool isTimelineMonth) {
    /// Condition added to check and add the special region for timeline day,
    /// timeline week and timeline work week view only, since the special region
    /// support not applicable for timeline month view.
    if (isTimelineMonth || _specialRegion == null || _specialRegion!.isEmpty) {
      return;
    }

    final TextPainter painter = TextPainter(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textScaleFactor: textScaleFactor,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        textWidthBasis: TextWidthBasis.longestLine);

    _linePainter.style = PaintingStyle.fill;
    final int count = specialRegionBounds.length;
    final TextStyle defaultTextStyle = TextStyle(
        color: calendarTheme.brightness == Brightness.dark
            ? Colors.white54
            : Colors.black45);
    for (int i = 0; i < count; i++) {
      final TimeRegionView view = specialRegionBounds[i];
      final CalendarTimeRegion region = view.region;
      _linePainter.color = region.color ?? Colors.grey.withOpacity(0.2);
      final TextStyle textStyle = themeData.textTheme.bodyMedium!
          .copyWith(fontSize: 14)
          .merge(region.textStyle ?? defaultTextStyle);
      final Rect rect = view.bound;
      canvas.drawRect(rect, _linePainter);
      if ((region.text == null || region.text!.isEmpty) &&
          region.iconData == null) {
        continue;
      }

      if (region.iconData == null) {
        painter.text = TextSpan(text: region.text, style: textStyle);
        painter.ellipsis = '..';
      } else {
        painter.text = TextSpan(
            text: String.fromCharCode(region.iconData!.codePoint),
            style: textStyle.copyWith(fontFamily: region.iconData!.fontFamily));
      }

      painter.layout(maxWidth: rect.width - 4);
      painter.paint(canvas, Offset(rect.left + 3, rect.top + 3));
    }
  }

  @override
  List<CustomPainterSemantics> Function(Size size) get semanticsBuilder =>
      _getSemanticsBuilder;

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    List<CustomPainterSemantics> semanticsBuilder = <CustomPainterSemantics>[];
    final bool isResourceEnabled =
        resourceCollection != null && resourceCollection!.isNotEmpty;
    final double height = isResourceEnabled ? resourceItemHeight : size.height;
    double top = 0;
    if (isResourceEnabled) {
      for (int i = 0; i < resourceCollection!.length; i++) {
        semanticsBuilder = _getAccessibilityDates(
            size, top, height, semanticsBuilder, resourceCollection![i]);
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
      [CalendarResource? resource]) {
    double left = isRTL ? size.width - timeIntervalWidth : 0;
    final int startHour = timeSlotViewSettings.startHour.toInt();
    final int startHourMinutes =
        ((timeSlotViewSettings.startHour - startHour) * 60).toInt();
    final int timeInterval =
        CalendarViewHelper.getTimeInterval(timeSlotViewSettings);
    for (int j = 0; j < visibleDates.length; j++) {
      DateTime date = visibleDates[j];
      for (int i = 0; i < horizontalLinesCountPerView; i++) {
        final int minute = (i * timeInterval) + startHourMinutes;
        date = DateTime(date.year, date.month, date.day, startHour, minute);
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(left, top, timeIntervalWidth, height),
          properties: SemanticsProperties(
            label: _getAccessibilityText(date, resource),
            textDirection: TextDirection.ltr,
          ),
        ));
        if (isRTL) {
          left -= timeIntervalWidth;
        } else {
          left += timeIntervalWidth;
        }
      }
    }

    return semanticsBuilder;
  }

  String _getAccessibilityText(DateTime date, [CalendarResource? resource]) {
    String dateText;
    if (visibleDates.length > DateTime.daysPerWeek) {
      dateText = DateFormat('EEEEE, dd MMMM yyyy').format(date);
    }
    dateText = DateFormat('h a, dd MMMM yyyy').format(date);

    if (resource != null) {
      dateText = dateText + resource.displayName;
    }

    return dateText;
  }
}

/// Used to hold the view header cells for timeline view.
class TimelineViewHeaderView extends CustomPainter {
  /// Constructor to create the view header view to holds header cell for
  /// timeline views.
  TimelineViewHeaderView(
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
      this.themeData,
      this.minDate,
      this.maxDate,
      this.viewHeaderNotifier,
      this.cellBorderColor,
      this.blackoutDates,
      this.blackoutDatesTextStyle,
      this.textScaleFactor)
      : super(repaint: repaintNotifier);

  /// Holds the visible dates collection for current timeline view.
  final List<DateTime> visibleDates;

  /// Defines the view header cell style.
  final ViewHeaderStyle viewHeaderStyle;

  /// Defines the timeline view slot setting used to provide the day and
  /// date format of the view header cell.
  final TimeSlotViewSettings timeSlotViewSettings;

  /// Defines the height of the view header.
  final double viewHeaderHeight;

  /// Defines the today view header cell text color.
  final Color? todayHighlightColor;

  /// Defines the today view header cell text style.
  final TextStyle? todayTextStyle;

  /// Used to repaint the current view based on the timeline scroll to
  /// achieve the sticky view header.
  final ValueNotifier<bool> repaintNotifier;

  /// Used to holds the current timeline scroll position.
  final ScrollController timelineViewHeaderScrollController;

  /// Holds the theme data value for calendar.
  final SfCalendarThemeData calendarTheme;

  /// Holds the framework theme data value.
  final ThemeData themeData;

  /// Defines the direction of the calendar widget is RTL or not.
  final bool isRTL;

  /// Defines the locale of the calendar.
  final String locale;

  /// Defines the min date of the calendar.
  final DateTime minDate;

  /// Defines the max date of the calendar.
  final DateTime maxDate;

  /// Holds the current view header hovering position used to paint hovering.
  final ValueNotifier<Offset?> viewHeaderNotifier;

  /// Defines the hovering view header cell background color.
  final Color? cellBorderColor;

  /// Holds the blackout dates collection and it only applicable on
  /// timeline month view.
  final List<DateTime>? blackoutDates;

  /// Defines the style of the blackout dates cell and it only applicable on
  /// timeline month view.
  final TextStyle? blackoutDatesTextStyle;

  /// Defines the scale factor for the view header cell text.
  final double textScaleFactor;
  final double _padding = 5;
  double _xPosition = 0;
  final TextPainter _dayTextPainter = TextPainter(),
      _dateTextPainter = TextPainter();
  final Paint _hoverPainter = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final int visibleDatesLength = visibleDates.length;
    final bool isTimelineMonth = visibleDatesLength > DateTime.daysPerWeek;
    final DateTime today = DateTime.now();
    final double childWidth = size.width / visibleDatesLength;
    final int index = isTimelineMonth
        ? 0
        : timelineViewHeaderScrollController.offset ~/ childWidth;
    _xPosition = !isTimelineMonth
        ? timelineViewHeaderScrollController.offset
        : isRTL
            ? size.width - childWidth
            : 0;

    final TextStyle defaultThemeViewHeaderDayTextStyle =
        themeData.textTheme.bodySmall!.copyWith(
      color: themeData.colorScheme.onSurface.withOpacity(0.87),
      fontSize: 11,
    );
    final TextStyle defaultThemeViewHeaderDateTextStyle =
        themeData.textTheme.bodyMedium!.copyWith(
      color: themeData.colorScheme.onSurface.withOpacity(0.87),
      fontSize: 15,
    );

    TextStyle viewHeaderDateStyle = calendarTheme.viewHeaderDateTextStyle!;
    TextStyle viewHeaderDayStyle = calendarTheme.viewHeaderDayTextStyle!;
    if (viewHeaderDateStyle == defaultThemeViewHeaderDateTextStyle &&
        isTimelineMonth) {
      viewHeaderDateStyle =
          viewHeaderDateStyle.copyWith(fontSize: viewHeaderDayStyle.fontSize);
    }

    if (viewHeaderDayStyle == defaultThemeViewHeaderDayTextStyle &&
        !isTimelineMonth) {
      viewHeaderDayStyle =
          viewHeaderDayStyle.copyWith(fontSize: viewHeaderDateStyle.fontSize);
    }

    final TextStyle? blackoutDatesStyle = calendarTheme.blackoutDatesTextStyle;

    TextStyle dayTextStyle = viewHeaderDayStyle;
    TextStyle dateTextStyle = viewHeaderDateStyle;

    final Color? todayTextColor = CalendarViewHelper.getTodayHighlightTextColor(
        todayHighlightColor, todayTextStyle, calendarTheme);

    if (isTimelineMonth) {
      _hoverPainter.strokeWidth = 0.5;
      _hoverPainter.strokeCap = StrokeCap.round;
      _hoverPainter.color = cellBorderColor ?? calendarTheme.cellBorderColor!;
      canvas.drawLine(Offset.zero, Offset(size.width, 0), _hoverPainter);
    }

    for (int i = 0; i < visibleDatesLength; i++) {
      if (i < index && !isTimelineMonth) {
        continue;
      }

      final DateTime currentDate = visibleDates[i];
      String dayFormat = 'EE';
      dayFormat =
          dayFormat == timeSlotViewSettings.dayFormat && !isTimelineMonth
              ? 'EEEE'
              : timeSlotViewSettings.dayFormat;

      final String dayText = DateFormat(dayFormat, locale).format(currentDate);
      final String dateText =
          DateFormat(timeSlotViewSettings.dateFormat).format(currentDate);

      final bool isBlackoutDate =
          CalendarViewHelper.isDateInDateCollection(blackoutDates, currentDate);

      if (isSameDate(currentDate, today)) {
        dayTextStyle = todayTextStyle != null
            ? calendarTheme.todayTextStyle!.copyWith(
                fontSize: viewHeaderDayStyle.fontSize, color: todayTextColor)
            : viewHeaderDayStyle.copyWith(color: todayTextColor);
        dateTextStyle = todayTextStyle != null
            ? calendarTheme.todayTextStyle!.copyWith(
                fontSize: viewHeaderDateStyle.fontSize, color: todayTextColor)
            : viewHeaderDateStyle.copyWith(color: todayTextColor);
      } else {
        dateTextStyle = viewHeaderDateStyle;
        dayTextStyle = viewHeaderDayStyle;
      }

      if (isTimelineMonth && isBlackoutDate) {
        if (blackoutDatesStyle != null) {
          dateTextStyle = dateTextStyle.merge(blackoutDatesStyle);
          dayTextStyle = dayTextStyle.merge(blackoutDatesStyle);
        } else {
          dateTextStyle =
              dateTextStyle.copyWith(decoration: TextDecoration.lineThrough);
          dayTextStyle =
              dayTextStyle.copyWith(decoration: TextDecoration.lineThrough);
        }
      }

      if (!isDateWithInDateRange(minDate, maxDate, currentDate)) {
        dayTextStyle = dayTextStyle.copyWith(
            color: dayTextStyle.color != null
                ? dayTextStyle.color!.withOpacity(0.38)
                : calendarTheme.brightness == Brightness.light
                    ? Colors.black26
                    : Colors.white38);
        dateTextStyle = dateTextStyle.copyWith(
            color: dateTextStyle.color != null
                ? dateTextStyle.color!.withOpacity(0.38)
                : calendarTheme.brightness == Brightness.light
                    ? Colors.black26
                    : Colors.white38);
      }

      final TextSpan dayTextSpan = TextSpan(text: dayText, style: dayTextStyle);

      _dayTextPainter.text = dayTextSpan;
      _dayTextPainter.textDirection = TextDirection.ltr;
      _dayTextPainter.textAlign = TextAlign.left;
      _dayTextPainter.textWidthBasis = TextWidthBasis.longestLine;
      _dayTextPainter.textScaleFactor = textScaleFactor;

      final TextSpan dateTextSpan =
          TextSpan(text: dateText, style: dateTextStyle);

      _dateTextPainter.text = dateTextSpan;
      _dateTextPainter.textDirection = TextDirection.ltr;
      _dateTextPainter.textAlign = TextAlign.left;
      _dateTextPainter.textWidthBasis = TextWidthBasis.longestLine;
      _dateTextPainter.textScaleFactor = textScaleFactor;

      _dayTextPainter.layout(maxWidth: childWidth);
      _dateTextPainter.layout(maxWidth: childWidth);
      if (isTimelineMonth) {
        canvas.save();
        _drawTimelineMonthViewHeader(canvas, childWidth, size, isBlackoutDate);
      } else {
        _drawTimelineTimeSlotsViewHeader(canvas, size, childWidth, index, i);
      }
    }
  }

  void _drawTimelineTimeSlotsViewHeader(
      Canvas canvas, Size size, double childWidth, int index, int i) {
    if (_dateTextPainter.width +
            _xPosition +
            (_padding * 2) +
            _dayTextPainter.width >
        (i + 1) * childWidth) {
      _xPosition = ((i + 1) * childWidth) -
          (_dateTextPainter.width + (_padding * 2) + _dayTextPainter.width);
    }

    if (viewHeaderNotifier.value != null) {
      _addMouseHovering(canvas, size);
    }

    if (isRTL) {
      _dateTextPainter.paint(
          canvas,
          Offset(size.width - _xPosition - _padding - _dateTextPainter.width,
              viewHeaderHeight / 2 - _dateTextPainter.height / 2));
      _dayTextPainter.paint(
          canvas,
          Offset(
              size.width -
                  _xPosition -
                  (_padding * 2) -
                  _dayTextPainter.width -
                  _dateTextPainter.width,
              viewHeaderHeight / 2 - _dayTextPainter.height / 2));
    } else {
      _dateTextPainter.paint(
          canvas,
          Offset(_padding + _xPosition,
              viewHeaderHeight / 2 - _dateTextPainter.height / 2));
      _dayTextPainter.paint(
          canvas,
          Offset(_dateTextPainter.width + _xPosition + (_padding * 2),
              viewHeaderHeight / 2 - _dayTextPainter.height / 2));
    }

    if (index == i) {
      _xPosition = (i + 1) * childWidth;
    } else {
      _xPosition += childWidth;
    }
  }

  void _drawTimelineMonthViewHeader(
      Canvas canvas, double childWidth, Size size, bool isBlackoutDate) {
    canvas.clipRect(Rect.fromLTWH(_xPosition, 0, childWidth, size.height));
    const double leftPadding = 2;
    final double startXPosition = _xPosition +
        (childWidth -
                (_dateTextPainter.width +
                    leftPadding +
                    _dayTextPainter.width)) /
            2;
    final double startYPosition = (size.height -
            (_dayTextPainter.height > _dateTextPainter.height
                ? _dayTextPainter.height
                : _dateTextPainter.height)) /
        2;
    if (viewHeaderNotifier.value != null && !isBlackoutDate) {
      _addMouseHovering(canvas, size, childWidth);
    }
    if (!isRTL) {
      _dateTextPainter.paint(canvas, Offset(startXPosition, startYPosition));
      _dayTextPainter.paint(
          canvas,
          Offset(startXPosition + _dateTextPainter.width + leftPadding,
              startYPosition));
    } else {
      _dayTextPainter.paint(canvas, Offset(startXPosition, startYPosition));
      _dateTextPainter.paint(
          canvas,
          Offset(startXPosition + _dayTextPainter.width + leftPadding,
              startYPosition));
    }

    if (isRTL) {
      _xPosition -= childWidth;
    } else {
      _xPosition += childWidth;
    }

    _hoverPainter.color = cellBorderColor ?? calendarTheme.cellBorderColor!;
    canvas.restore();
    canvas.drawLine(
        Offset(_xPosition, 0), Offset(_xPosition, size.height), _hoverPainter);
  }

  void _addMouseHovering(Canvas canvas, Size size, [double? cellWidth]) {
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
            _dayTextPainter.width -
            _dateTextPainter.width -
            _padding
        : _xPosition;
    final double rightPosition = isRTL && cellWidth == null
        ? size.width - _xPosition
        : cellWidth != null
            ? _xPosition + cellWidth - _padding
            : _xPosition +
                _dayTextPainter.width +
                _dateTextPainter.width +
                (2 * _padding);
    if (leftPosition + difference <= viewHeaderNotifier.value!.dx &&
        rightPosition + difference >= viewHeaderNotifier.value!.dx &&
        (size.height) - _padding >= viewHeaderNotifier.value!.dy) {
      _hoverPainter.color = (calendarTheme.brightness == Brightness.dark
              ? Colors.white
              : Colors.black87)
          .withOpacity(0.04);
      canvas.drawRect(
          Rect.fromLTRB(leftPosition, 0, rightPosition + _padding, size.height),
          _hoverPainter);
    }
  }

  @override
  bool shouldRepaint(TimelineViewHeaderView oldDelegate) {
    final TimelineViewHeaderView oldWidget = oldDelegate;
    final bool isTimelineMonth = visibleDates.length > DateTime.daysPerWeek;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.viewHeaderStyle != viewHeaderStyle ||
        oldWidget.timeSlotViewSettings != timeSlotViewSettings ||
        oldWidget.viewHeaderHeight != viewHeaderHeight ||
        oldWidget.todayHighlightColor != todayHighlightColor ||
        oldWidget.isRTL != isRTL ||
        oldWidget.locale != locale ||
        oldWidget.viewHeaderNotifier.value != viewHeaderNotifier.value ||
        oldWidget.todayTextStyle != todayTextStyle ||
        oldWidget.textScaleFactor != textScaleFactor ||
        oldWidget.calendarTheme != calendarTheme ||
        (isTimelineMonth &&
            (oldWidget.blackoutDatesTextStyle != blackoutDatesTextStyle ||
                !CalendarViewHelper.isDateCollectionEqual(
                    oldWidget.blackoutDates, blackoutDates)));
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    final int visibleDatesLength = visibleDates.length;
    final double cellWidth = size.width / visibleDatesLength;
    double left = isRTL ? size.width - cellWidth : 0;
    const double top = 0;
    for (int i = 0; i < visibleDatesLength; i++) {
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
    final String textString = DateFormat('EEEEE').format(date) +
        DateFormat('dd/MMMM/yyyy').format(date);
    if (!isDateWithInDateRange(minDate, maxDate, date)) {
      return '$textString, Disabled date';
    }

    if (CalendarViewHelper.isDateInDateCollection(blackoutDates, date)) {
      return '$textString, Blackout date';
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
  bool shouldRebuildSemantics(TimelineViewHeaderView oldDelegate) {
    final TimelineViewHeaderView oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates;
  }
}
