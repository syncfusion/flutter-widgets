import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../appointment_engine/appointment_helper.dart';
import '../common/calendar_view_helper.dart';
import '../common/date_time_engine.dart';
import '../common/event_args.dart';
import '../settings/time_slot_view_settings.dart';

/// Used to hold the time slots view on calendar day, week, workweek views.
class TimeSlotWidget extends StatefulWidget {
  /// Constructor to create the time slot widget to holds time slots view for
  /// day, week, workweek views.
  const TimeSlotWidget(
      this.visibleDates,
      this.horizontalLinesCount,
      this.timeIntervalHeight,
      this.timeLabelWidth,
      this.cellBorderColor,
      this.calendarTheme,
      this.themeData,
      this.timeSlotViewSettings,
      this.isRTL,
      this.specialRegion,
      this.calendarCellNotifier,
      this.textScaleFactor,
      this.timeRegionBuilder,
      this.width,
      this.height,
      this.minDate,
      this.maxDate,
      {super.key});

  /// Holds the visible dates collection for current time slot view.
  final List<DateTime> visibleDates;

  /// Defines the total number of time slots needed in the view.
  final double horizontalLinesCount;

  /// Defines the height of single time slot view.
  final double timeIntervalHeight;

  /// Defines the width of time label view.
  final double timeLabelWidth;

  /// Defines the time slot border color.
  final Color? cellBorderColor;

  /// Holds the theme data value for calendar.
  final SfCalendarThemeData calendarTheme;

  /// Holds the framework theme data value.
  final ThemeData themeData;

  /// Defines the time slot setting used to customize the time slots.
  final TimeSlotViewSettings timeSlotViewSettings;

  /// Defines the direction of the calendar widget is RTL or not.
  final bool isRTL;

  /// Used to draw the hovering on time slot view.
  final ValueNotifier<Offset?> calendarCellNotifier;

  /// Defines the special time region for the current time slot view.
  final List<CalendarTimeRegion>? specialRegion;

  /// Defines the scale factor for the time slot time text.
  final double textScaleFactor;

  /// Used to build the widget that replaces the time regions in time slot view.
  final TimeRegionBuilder? timeRegionBuilder;

  /// Holds the current time slot widget width.
  final double width;

  /// Holds the current time slot widget height.
  final double height;

  /// Defines the min date of the calendar.
  final DateTime minDate;

  /// Defines the max date of the calendar.
  final DateTime maxDate;

  @override
  // ignore: library_private_types_in_public_api
  _TimeSlotWidgetState createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {
  final List<Widget> _children = <Widget>[];
  List<TimeRegionView> _specialRegionViews = <TimeRegionView>[];

  @override
  void initState() {
    _updateSpecialRegionDetails();
    super.initState();
  }

  @override
  void didUpdateWidget(TimeSlotWidget oldWidget) {
    if (widget.visibleDates != oldWidget.visibleDates ||
        widget.horizontalLinesCount != oldWidget.horizontalLinesCount ||
        widget.timeIntervalHeight != oldWidget.timeIntervalHeight ||
        widget.timeLabelWidth != oldWidget.timeLabelWidth ||
        widget.isRTL != oldWidget.isRTL ||
        widget.timeSlotViewSettings != oldWidget.timeSlotViewSettings ||
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

    return _TimeSlotRenderWidget(
      widget.visibleDates,
      widget.horizontalLinesCount,
      widget.timeIntervalHeight,
      widget.timeLabelWidth,
      widget.cellBorderColor,
      widget.calendarTheme,
      widget.themeData,
      widget.timeSlotViewSettings,
      widget.isRTL,
      widget.specialRegion,
      widget.calendarCellNotifier,
      widget.textScaleFactor,
      widget.width,
      widget.height,
      _specialRegionViews,
      widget.minDate,
      widget.maxDate,
      widgets: _children,
    );
  }

  void _updateSpecialRegionDetails() {
    _specialRegionViews = <TimeRegionView>[];
    if (widget.specialRegion == null || widget.specialRegion!.isEmpty) {
      return;
    }

    final double minuteHeight = widget.timeIntervalHeight /
        CalendarViewHelper.getTimeInterval(widget.timeSlotViewSettings);
    final DateTime startDate =
        AppointmentHelper.convertToStartTime(widget.visibleDates[0]);
    final int visibleDatesLength = widget.visibleDates.length;
    final DateTime endDate = AppointmentHelper.convertToEndTime(
        widget.visibleDates[visibleDatesLength - 1]);
    final double width = widget.width - widget.timeLabelWidth;
    final double cellWidth = width / visibleDatesLength;
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

      double startYPosition = CalendarViewHelper.getTimeToPosition(
          Duration(
              hours: regionStartTime.hour, minutes: regionStartTime.minute),
          widget.timeSlotViewSettings,
          minuteHeight);
      if (startIndex == -1) {
        if (startDate.isAfter(regionStartTime)) {
          // Set index as 0 when the region start date before the visible
          // start date
          startIndex = 0;
        } else {
          /// Find the next index when the start date as non working date.
          for (int k = 1; k < visibleDatesLength; k++) {
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
        startYPosition = 0;
      }

      double endYPosition = CalendarViewHelper.getTimeToPosition(
          Duration(hours: regionEndTime.hour, minutes: regionEndTime.minute),
          widget.timeSlotViewSettings,
          minuteHeight);
      if (endIndex == -1) {
        /// Find the previous index when the end date as non working date.
        if (endDate.isAfter(regionEndTime)) {
          for (int k = visibleDatesLength - 2; k >= 0; k--) {
            final DateTime currentDate = widget.visibleDates[k];
            if (currentDate.isAfter(regionEndTime)) {
              continue;
            }

            endIndex = k;
            break;
          }

          if (endIndex == -1) {
            endIndex = visibleDatesLength - 1;
          }
        } else {
          /// Set index as visible date end date index when the
          /// region end date before the visible end date
          endIndex = visibleDatesLength - 1;
        }

        /// End date as non working day and its index as previous date index.
        /// so assign the position value as view height
        endYPosition = widget.height;
      }

      for (int j = startIndex; j <= endIndex; j++) {
        final double startPosition = j == startIndex ? startYPosition : 0;
        final double endPosition = j == endIndex ? endYPosition : widget.height;

        /// Check the start and end position not between the visible hours
        /// position(not between start and end hour)
        if ((startPosition <= 0 && endPosition <= 0) ||
            (startPosition >= widget.height && endPosition >= widget.height) ||
            (startPosition == endPosition)) {
          continue;
        }

        double startXPosition = widget.timeLabelWidth + (j * cellWidth);
        if (widget.isRTL) {
          startXPosition = widget.width - (startXPosition + cellWidth);
        }

        final Rect rect = Rect.fromLTRB(startXPosition, startPosition,
            startXPosition + cellWidth, endPosition);
        _specialRegionViews.add(TimeRegionView(j, region, rect));
      }
    }
  }
}

class _TimeSlotRenderWidget extends MultiChildRenderObjectWidget {
  const _TimeSlotRenderWidget(
      this.visibleDates,
      this.horizontalLinesCount,
      this.timeIntervalHeight,
      this.timeLabelWidth,
      this.cellBorderColor,
      this.calendarTheme,
      this.themeData,
      this.timeSlotViewSettings,
      this.isRTL,
      this.specialRegion,
      this.calendarCellNotifier,
      this.textScaleFactor,
      this.width,
      this.height,
      this.specialRegionBounds,
      this.minDate,
      this.maxDate,
      {List<Widget> widgets = const <Widget>[]})
      : super(children: widgets);

  final List<DateTime> visibleDates;
  final double horizontalLinesCount;
  final double timeIntervalHeight;
  final double timeLabelWidth;
  final Color? cellBorderColor;
  final SfCalendarThemeData calendarTheme;
  final ThemeData themeData;
  final TimeSlotViewSettings timeSlotViewSettings;
  final bool isRTL;
  final ValueNotifier<Offset?> calendarCellNotifier;
  final List<CalendarTimeRegion>? specialRegion;
  final double textScaleFactor;
  final double width;
  final double height;
  final List<TimeRegionView> specialRegionBounds;
  final DateTime minDate;
  final DateTime maxDate;

  @override
  _TimeSlotRenderObject createRenderObject(BuildContext context) {
    return _TimeSlotRenderObject(
        visibleDates,
        horizontalLinesCount,
        timeIntervalHeight,
        timeLabelWidth,
        cellBorderColor,
        calendarTheme,
        themeData,
        timeSlotViewSettings,
        isRTL,
        specialRegion,
        calendarCellNotifier,
        textScaleFactor,
        width,
        height,
        specialRegionBounds,
        minDate,
        maxDate);
  }

  @override
  void updateRenderObject(
      BuildContext context, _TimeSlotRenderObject renderObject) {
    renderObject
      ..visibleDates = visibleDates
      ..horizontalLinesCount = horizontalLinesCount
      ..timeIntervalHeight = timeIntervalHeight
      ..timeLabelWidth = timeLabelWidth
      ..cellBorderColor = cellBorderColor
      ..calendarTheme = calendarTheme
      ..themeData = themeData
      ..timeSlotViewSettings = timeSlotViewSettings
      ..isRTL = isRTL
      ..specialRegion = specialRegion
      ..calendarCellNotifier = calendarCellNotifier
      ..textScaleFactor = textScaleFactor
      ..width = width
      ..height = height
      ..minDate = minDate
      ..maxDate = maxDate
      ..specialRegionBounds = specialRegionBounds;
  }
}

class _TimeSlotRenderObject extends CustomCalendarRenderObject {
  _TimeSlotRenderObject(
      this._visibleDates,
      this._horizontalLinesCount,
      this._timeIntervalHeight,
      this._timeLabelWidth,
      this._cellBorderColor,
      this._calendarTheme,
      this._themeData,
      this._timeSlotViewSettings,
      this._isRTL,
      this._specialRegion,
      this._calendarCellNotifier,
      this._textScaleFactor,
      this._width,
      this._height,
      this.specialRegionBounds,
      this._minDate,
      this._maxDate);

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

  double _horizontalLinesCount;

  double get horizontalLinesCount => _horizontalLinesCount;

  set horizontalLinesCount(double value) {
    if (_horizontalLinesCount == value) {
      return;
    }

    _horizontalLinesCount = value;
    markNeedsPaint();
  }

  double _timeIntervalHeight;

  double get timeIntervalHeight => _timeIntervalHeight;

  set timeIntervalHeight(double value) {
    if (_timeIntervalHeight == value) {
      return;
    }

    _timeIntervalHeight = value;
    if (childCount == 0) {
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
  late double _cellWidth;
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
    final double width = size.width - timeLabelWidth;
    final int visibleDatesCount = visibleDates.length;
    _cellWidth = width / visibleDatesCount;
    _minMaxExceeds(minDate, maxDate, context.canvas, visibleDatesCount);
    if (isNeedDefaultPaint) {
      _addSpecialRegions(context.canvas);
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
    _drawTimeSlots(context.canvas, visibleDatesCount);
  }

  void _minMaxExceeds(DateTime minDate, DateTime maxDate, Canvas canvas,
      int visibleDatesCount) {
    final DateTime visibleStartDate = visibleDates[0];
    final DateTime visibleEndDate = visibleDates[visibleDatesCount - 1];
    final DateTime maxEndDate =
        AppointmentHelper.convertToEndTime(visibleDates[visibleDatesCount - 1]);
    if (isDateWithInDateRange(visibleStartDate, visibleEndDate, minDate)) {
      _drawDisabledDate(visibleStartDate, minDate, canvas, visibleDatesCount);
    }
    if (isDateWithInDateRange(visibleStartDate, visibleEndDate, maxDate)) {
      _drawDisabledDate(maxDate, maxEndDate, canvas, visibleDatesCount);
    }
  }

  void _drawDisabledDate(DateTime disabledStartDate, DateTime disabledEndDate,
      Canvas canvas, int visibleDatesCount) {
    final double minuteHeight = timeIntervalHeight /
        CalendarViewHelper.getTimeInterval(timeSlotViewSettings);
    final double viewWidth = width - timeLabelWidth;
    final double cellWidth = viewWidth / visibleDatesCount;

    final int startIndex =
        DateTimeHelper.getVisibleDateIndex(visibleDates, disabledStartDate);
    final int endIndex =
        DateTimeHelper.getVisibleDateIndex(visibleDates, disabledEndDate);
    final double startYPosition = CalendarViewHelper.getTimeToPosition(
        Duration(
            hours: disabledStartDate.hour, minutes: disabledStartDate.minute),
        timeSlotViewSettings,
        minuteHeight);
    final double endYPosition = CalendarViewHelper.getTimeToPosition(
        Duration(hours: disabledEndDate.hour, minutes: disabledEndDate.minute),
        timeSlotViewSettings,
        minuteHeight);
    for (int i = startIndex; i <= endIndex; i++) {
      final double topPosition = i == startIndex ? startYPosition : 0;
      final double bottomPosition = i == endIndex ? endYPosition : height;

      if ((topPosition <= 0 && bottomPosition <= 0) ||
          (topPosition >= height && bottomPosition >= height) ||
          (topPosition == bottomPosition)) {
        continue;
      }
      double leftPosition = timeLabelWidth + (i * cellWidth);
      double rightPosition = leftPosition + cellWidth;

      Rect rect;
      if (isRTL) {
        leftPosition = width - leftPosition;
        rightPosition = width - rightPosition;
      }
      rect = Rect.fromLTRB(
          leftPosition, topPosition, rightPosition, bottomPosition);
      _linePainter.style = PaintingStyle.fill;
      _linePainter.color = Colors.grey.withValues(alpha: 0.2);
      canvas.drawRect(rect, _linePainter);
    }
  }

  void _drawTimeSlots(Canvas canvas, int visibleDatesCount) {
    double y = timeIntervalHeight;
    _linePainter.style = PaintingStyle.stroke;
    _linePainter.strokeWidth = 0.5;
    _linePainter.strokeCap = StrokeCap.round;
    _linePainter.color = cellBorderColor ?? calendarTheme.cellBorderColor!;

    final double startXPosition = isRTL ? 0 : timeLabelWidth;
    final double endXPosition =
        isRTL ? size.width - timeLabelWidth : size.width;
    for (int i = 1; i <= horizontalLinesCount; i++) {
      canvas.drawLine(
          Offset(startXPosition, y), Offset(endXPosition, y), _linePainter);

      y += timeIntervalHeight;
      if (y == size.height) {
        break;
      }
    }

    double x = isRTL ? _cellWidth : timeLabelWidth + _cellWidth;
    for (int i = 0; i < visibleDatesCount - 1; i++) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), _linePainter);
      x += _cellWidth;
    }

    if (calendarCellNotifier.value != null) {
      _addMouseHoveringForTimeSlot(canvas, size);
    }
  }

  void _addMouseHoveringForTimeSlot(Canvas canvas, Size size) {
    const double strokeWidth = 2;
    const double padding = strokeWidth / 2;
    double left = (calendarCellNotifier.value!.dx ~/ _cellWidth) * _cellWidth;
    double top = (calendarCellNotifier.value!.dy ~/ timeIntervalHeight) *
        timeIntervalHeight;
    _linePainter.style = PaintingStyle.stroke;
    _linePainter.strokeWidth = strokeWidth;
    _linePainter.color =
        calendarTheme.selectionBorderColor!.withValues(alpha: 0.4);
    left += isRTL ? 0 : timeLabelWidth;
    double height = timeIntervalHeight;
    if (top == 0) {
      top = padding;
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

  void _addSpecialRegions(Canvas canvas) {
    if (specialRegion == null || specialRegion!.isEmpty) {
      return;
    }

    final TextPainter painter = TextPainter(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        textScaler: TextScaler.linear(textScaleFactor),
        textWidthBasis: TextWidthBasis.longestLine);

    _linePainter.style = PaintingStyle.fill;
    final int count = specialRegionBounds.length;
    final TextStyle defaultTextStyle = TextStyle(
        color: themeData.brightness == Brightness.dark
            ? Colors.white54
            : Colors.black45);
    for (int i = 0; i < count; i++) {
      final TimeRegionView view = specialRegionBounds[i];
      final CalendarTimeRegion region = view.region;
      _linePainter.color = region.color ?? Colors.grey.withValues(alpha: 0.2);

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
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    double left, top;
    top = 0;
    final double cellWidth =
        (size.width - timeLabelWidth) / visibleDates.length;
    left = isRTL ? (size.width - timeLabelWidth) - cellWidth : timeLabelWidth;
    final double cellHeight = timeIntervalHeight;
    final int startHour = timeSlotViewSettings.startHour.toInt();
    final int hour =
        ((timeSlotViewSettings.startHour - startHour) * 60).toInt();
    final int timeInterval =
        CalendarViewHelper.getTimeInterval(timeSlotViewSettings);
    for (int j = 0; j < visibleDates.length; j++) {
      DateTime date = visibleDates[j];
      for (int i = 0; i < horizontalLinesCount; i++) {
        final int minute = (i * timeInterval) + hour;
        date = DateTime(date.year, date.month, date.day, startHour, minute);
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(left, top, cellWidth, cellHeight),
          properties: SemanticsProperties(
            label: DateFormat('h a, dd MMMM yyyy').format(date),
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
}
