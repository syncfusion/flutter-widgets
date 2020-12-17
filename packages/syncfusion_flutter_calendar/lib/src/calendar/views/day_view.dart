part of calendar;

class _TimeRegionView {
  _TimeRegionView({this.visibleIndex, this.region, this.bound});

  int visibleIndex = -1;
  TimeRegion region;
  Rect bound;
}

class _TimeSlotWidget extends StatefulWidget {
  _TimeSlotWidget(
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
      this.textScaleFactor,
      this.timeRegionBuilder,
      this.width,
      this.height);

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
  final TimeRegionBuilder timeRegionBuilder;
  final double width;
  final double height;

  @override
  _TimeSlotWidgetState createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<_TimeSlotWidget> {
  List<Widget> _children;
  List<_TimeRegionView> _specialRegionViews;

  @override
  void initState() {
    _children = <Widget>[];
    _updateSpecialRegionDetails();
    super.initState();
  }

  @override
  void didUpdateWidget(_TimeSlotWidget oldWidget) {
    if (widget.visibleDates != oldWidget.visibleDates ||
        widget.horizontalLinesCount != oldWidget.horizontalLinesCount ||
        widget.timeIntervalHeight != oldWidget.timeIntervalHeight ||
        widget.timeLabelWidth != oldWidget.timeLabelWidth ||
        widget.isRTL != oldWidget.isRTL ||
        widget.timeSlotViewSettings != oldWidget.timeSlotViewSettings ||
        widget.width != oldWidget.width ||
        widget.height != oldWidget.height ||
        widget.timeRegionBuilder != oldWidget.timeRegionBuilder ||
        !_isCollectionEqual(widget.specialRegion, oldWidget.specialRegion)) {
      _updateSpecialRegionDetails();
      _children.clear();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _children ??= <Widget>[];
    if (_children.isEmpty &&
        widget.timeRegionBuilder != null &&
        _specialRegionViews != null &&
        _specialRegionViews.isNotEmpty) {
      final int count = _specialRegionViews.length;
      for (int i = 0; i < count; i++) {
        final _TimeRegionView view = _specialRegionViews[i];
        final Widget child = widget.timeRegionBuilder(
            context,
            TimeRegionDetails(
                region: view.region,
                date: widget.visibleDates[view.visibleIndex],
                bounds: view.bound));

        /// Throw exception when builder return widget is null.
        assert(child != null, 'Widget must not be null');
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
      widget.timeSlotViewSettings,
      widget.isRTL,
      widget.specialRegion,
      widget.calendarCellNotifier,
      widget.textScaleFactor,
      widget.width,
      widget.height,
      _specialRegionViews,
      widgets: _children,
    );
  }

  void _updateSpecialRegionDetails() {
    _specialRegionViews = <_TimeRegionView>[];
    if (widget.specialRegion == null || widget.specialRegion.isEmpty) {
      return;
    }

    final double minuteHeight = widget.timeIntervalHeight /
        _getTimeInterval(widget.timeSlotViewSettings);
    final DateTime startDate = _convertToStartTime(widget.visibleDates[0]);
    final DateTime endDate =
        _convertToEndTime(widget.visibleDates[widget.visibleDates.length - 1]);
    final double width = widget.width - widget.timeLabelWidth;
    final double cellWidth = width / widget.visibleDates.length;
    for (int i = 0; i < widget.specialRegion.length; i++) {
      final TimeRegion region = widget.specialRegion[i];
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

      int startIndex =
          _getVisibleDateIndex(widget.visibleDates, regionStartTime);
      int endIndex = _getVisibleDateIndex(widget.visibleDates, regionEndTime);

      double startYPosition = _getTimeToPosition(
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
          for (int k = 1; k < widget.visibleDates.length; k++) {
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

      double endYPosition = _getTimeToPosition(
          Duration(hours: regionEndTime.hour, minutes: regionEndTime.minute),
          widget.timeSlotViewSettings,
          minuteHeight);
      if (endIndex == -1) {
        /// Find the previous index when the end date as non working date.
        if (endDate.isAfter(regionEndTime)) {
          for (int k = widget.visibleDates.length - 2; k >= 0; k--) {
            final DateTime currentDate = widget.visibleDates[k];
            if (currentDate.isAfter(regionEndTime)) {
              continue;
            }

            endIndex = k;
            break;
          }

          if (endIndex == -1) {
            endIndex = widget.visibleDates.length - 1;
          }
        } else {
          /// Set index as visible date end date index when the
          /// region end date before the visible end date
          endIndex = widget.visibleDates.length - 1;
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
        _specialRegionViews
            .add(_TimeRegionView(region: region, visibleIndex: j, bound: rect));
      }
    }
  }
}

class _TimeSlotRenderWidget extends MultiChildRenderObjectWidget {
  _TimeSlotRenderWidget(
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
      this.textScaleFactor,
      this.width,
      this.height,
      this.specialRegionBounds,
      {List<Widget> widgets})
      : super(children: widgets);

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
  final double width;
  final double height;
  final List<_TimeRegionView> specialRegionBounds;

  @override
  _TimeSlotRenderObject createRenderObject(BuildContext context) {
    return _TimeSlotRenderObject(
        visibleDates,
        horizontalLinesCount,
        timeIntervalHeight,
        timeLabelWidth,
        cellBorderColor,
        calendarTheme,
        timeSlotViewSettings,
        isRTL,
        specialRegion,
        calendarCellNotifier,
        textScaleFactor,
        width,
        height,
        specialRegionBounds);
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
      ..timeSlotViewSettings = timeSlotViewSettings
      ..isRTL = isRTL
      ..specialRegion = specialRegion
      ..calendarCellNotifier = calendarCellNotifier
      ..textScaleFactor = textScaleFactor
      ..width = width
      ..height = height
      ..specialRegionBounds = specialRegionBounds;
  }
}

class _TimeSlotRenderObject extends _CustomCalendarRenderObject {
  _TimeSlotRenderObject(
      this._visibleDates,
      this._horizontalLinesCount,
      this._timeIntervalHeight,
      this._timeLabelWidth,
      this._cellBorderColor,
      this._calendarTheme,
      this._timeSlotViewSettings,
      this._isRTL,
      this._specialRegion,
      this._calendarCellNotifier,
      this._textScaleFactor,
      this._width,
      this._height,
      this.specialRegionBounds);

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

  Color _cellBorderColor;

  Color get cellBorderColor => _cellBorderColor;

  set cellBorderColor(Color value) {
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

  ValueNotifier<Offset> _calendarCellNotifier;

  ValueNotifier<Offset> get calendarCellNotifier => _calendarCellNotifier;

  set calendarCellNotifier(ValueNotifier<Offset> value) {
    if (_calendarCellNotifier == value) {
      return;
    }

    _calendarCellNotifier?.removeListener(markNeedsPaint);
    _calendarCellNotifier = value;
    _calendarCellNotifier?.addListener(markNeedsPaint);
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

  List<TimeRegion> _specialRegion;

  List<TimeRegion> get specialRegion => _specialRegion;

  set specialRegion(List<TimeRegion> value) {
    if (_isCollectionEqual(_specialRegion, value)) {
      return;
    }

    _specialRegion = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  List<_TimeRegionView> specialRegionBounds;
  double _cellWidth;
  Paint _linePainter;

  @override
  bool get isRepaintBoundary => true;

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _calendarCellNotifier?.addListener(markNeedsPaint);
  }

  /// detach will called when the render object removed from view.
  @override
  void detach() {
    _calendarCellNotifier?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? height : widgetSize.height);
    RenderBox child = firstChild;
    if (specialRegion == null || specialRegion.isEmpty) {
      return;
    }

    final int count = specialRegionBounds.length;
    for (int i = 0; i < count; i++) {
      final _TimeRegionView view = specialRegionBounds[i];
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
    RenderBox child = firstChild;
    final bool isNeedDefaultPaint = childCount == 0;
    final double width = size.width - timeLabelWidth;
    _cellWidth = width / visibleDates.length;
    _linePainter = _linePainter ?? Paint();
    if (isNeedDefaultPaint) {
      _addSpecialRegions(context.canvas);
    } else {
      if (specialRegion == null || specialRegion.isEmpty) {
        return;
      }

      final int count = specialRegionBounds.length;
      for (int i = 0; i < count; i++) {
        final _TimeRegionView view = specialRegionBounds[i];
        if (child == null) {
          continue;
        }
        final Rect rect = view.bound;
        child.paint(context, Offset(rect.left, rect.top));
        child = childAfter(child);
      }
    }

    _drawTimeSlots(context.canvas);
  }

  void _drawTimeSlots(Canvas canvas) {
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

  void _addSpecialRegions(Canvas canvas) {
    if (specialRegion == null || specialRegion.isEmpty) {
      return;
    }

    final TextPainter painter = TextPainter(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        textScaleFactor: textScaleFactor,
        textWidthBasis: TextWidthBasis.longestLine);

    _linePainter.style = PaintingStyle.fill;
    final int count = specialRegionBounds.length;
    for (int i = 0; i < count; i++) {
      final _TimeRegionView view = specialRegionBounds[i];
      final TimeRegion region = view.region;
      _linePainter.color = region.color ?? Colors.grey.withOpacity(0.2);

      final TextStyle textStyle = region.textStyle ??
          TextStyle(
              color: calendarTheme.brightness != null &&
                      calendarTheme.brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.black45);
      final Rect rect = view.bound;
      canvas.drawRect(rect, _linePainter);
      if ((region.text == null || region.text.isEmpty) &&
          region.iconData == null) {
        continue;
      }

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
}
