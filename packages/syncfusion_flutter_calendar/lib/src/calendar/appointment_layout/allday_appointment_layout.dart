part of calendar;

/// The class contains all day panel selection details.
/// if all day panel appointment selected then [appointmentView] holds
/// appointment details, else [selectedDate] holds selected region date value.
@immutable
class _SelectionDetails {
  const _SelectionDetails(this.appointmentView, this.selectedDate);

  final _AppointmentView appointmentView;
  final DateTime selectedDate;
}

class _AllDayAppointmentLayout extends StatefulWidget {
  _AllDayAppointmentLayout(
      this.calendar,
      this.view,
      this.visibleDates,
      this.visibleAppointments,
      this.timeLabelWidth,
      this.allDayPainterHeight,
      this.isExpandable,
      this.isExpanding,
      this.isRTL,
      this.calendarTheme,
      this.repaintNotifier,
      this.allDayHoverPosition,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.width,
      this.height,
      {this.updateCalendarState});

  final SfCalendar calendar;
  final CalendarView view;
  final List<DateTime> visibleDates;
  final List<Appointment> visibleAppointments;
  final ValueNotifier<_SelectionDetails> repaintNotifier;
  final _UpdateCalendarState updateCalendarState;
  final double timeLabelWidth;
  final double allDayPainterHeight;
  final bool isRTL;
  final SfCalendarThemeData calendarTheme;
  final ValueNotifier<Offset> allDayHoverPosition;
  final double textScaleFactor;
  final bool isMobilePlatform;
  final double height;
  final double width;

  //// is expandable variable used to indicate whether the all day layout expandable or not.
  final bool isExpandable;

  //// is expanding variable used to identify the animation currently running or not.
  //// It is used to restrict the expander icon show on initial animation.
  final bool isExpanding;

  @override
  _AllDayAppointmentLayoutState createState() =>
      _AllDayAppointmentLayoutState();
}

class _AllDayAppointmentLayoutState extends State<_AllDayAppointmentLayout> {
  final _UpdateCalendarStateDetails _updateCalendarStateDetails =
      _UpdateCalendarStateDetails();

  /// It holds the appointment list based on its visible index value.
  Map<int, List<_AppointmentView>> _indexAppointments;

  /// It holds the more appointment index appointment counts based on its index.
  Map<int, int> _moreAppointmentIndex;

  /// It holds the appointment views for the visible appointments.
  List<_AppointmentView> _appointmentCollection;

  /// It holds the children of the widget, it holds null or empty when
  /// appointment builder is null.
  List<Widget> _children;

  @override
  void initState() {
    _children = <Widget>[];
    widget.updateCalendarState(_updateCalendarStateDetails);
    _updateAppointmentDetails();
    super.initState();
  }

  @override
  void didUpdateWidget(_AllDayAppointmentLayout oldWidget) {
    widget.updateCalendarState(_updateCalendarStateDetails);
    if (widget.visibleDates != oldWidget.visibleDates ||
        widget.width != oldWidget.width ||
        widget.height != oldWidget.height ||
        widget.allDayPainterHeight != oldWidget.allDayPainterHeight ||
        widget.calendar != oldWidget.calendar ||
        widget.view != oldWidget.view ||
        widget.isRTL != oldWidget.isRTL ||
        widget.isExpandable != oldWidget.isExpandable ||
        widget.visibleAppointments != oldWidget.visibleAppointments) {
      _updateAppointmentDetails();
      _children.clear();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _children ??= <Widget>[];

    /// Create the widgets when appointment builder is not null.
    if (_children.isEmpty &&
        _appointmentCollection != null &&
        widget.calendar.appointmentBuilder != null) {
      for (int i = 0; i < _appointmentCollection.length; i++) {
        final _AppointmentView appointmentView = _appointmentCollection[i];

        /// Check the appointment view have appointment, if not then the
        /// appointment view is not valid or it will be placed on in expandable
        /// region.
        if (appointmentView.appointment == null ||
            appointmentView.appointmentRect == null) {
          continue;
        }

        final DateTime date = DateTime(
            appointmentView.appointment._actualStartTime.year,
            appointmentView.appointment._actualStartTime.month,
            appointmentView.appointment._actualStartTime.day);
        final Widget child = widget.calendar.appointmentBuilder(
            context,
            CalendarAppointmentDetails(
                date: date,
                bounds: Rect.fromLTWH(
                    appointmentView.appointmentRect.left,
                    appointmentView.appointmentRect.top,
                    appointmentView.appointmentRect.width,
                    appointmentView.appointmentRect.right),
                appointments: List.unmodifiable([
                  appointmentView.appointment._data ??
                      appointmentView.appointment
                ]),
                isMoreAppointmentRegion: false));

        /// Throw exception when builder return widget is null.
        assert(child != null, 'Widget must not be null');
        _children.add(RepaintBoundary(child: child));
      }

      /// Get the more appointment index(more appointment index map holds more
      /// appointment needed cell index and it appointment count)
      final List<int> keys = _moreAppointmentIndex.keys.toList();

      /// Calculate the cell width based on time label width and visible dates
      /// count.
      final double cellWidth =
          (widget.width - widget.timeLabelWidth) / widget.visibleDates.length;

      /// Calculate the maximum appointment width based on cell end padding.
      final double maxAppointmentWidth =
          cellWidth - widget.calendar.cellEndPadding;
      for (int i = 0; i < keys.length; i++) {
        final int index = keys[i];
        final DateTime date = widget.visibleDates[index];
        final double xPosition = widget.timeLabelWidth + (index * cellWidth);
        final List<Appointment> moreAppointments = <Appointment>[];
        final List<_AppointmentView> moreAppointmentViews =
            _indexAppointments[index];

        /// Get the appointments of the more appointment cell index from more
        /// appointment views.
        for (int j = 0; j < moreAppointmentViews.length; j++) {
          final _AppointmentView currentAppointment = moreAppointmentViews[j];
          moreAppointments.add(currentAppointment.appointment);
        }
        final Widget child = widget.calendar.appointmentBuilder(
            context,
            CalendarAppointmentDetails(
                date: date,
                bounds: Rect.fromLTWH(
                    widget.isRTL
                        ? widget.width - xPosition - maxAppointmentWidth
                        : xPosition,
                    widget.height - _kAllDayAppointmentHeight,
                    maxAppointmentWidth,
                    _kAllDayAppointmentHeight - 1),
                appointments:
                    List.unmodifiable(_getCustomAppointments(moreAppointments)),
                isMoreAppointmentRegion: true));

        /// Throw exception when builder return widget is null.
        assert(child != null, 'Widget must not be null');
        _children.add(RepaintBoundary(child: child));
      }
    }

    return _AllDayAppointmentRenderWidget(
      widget.calendar,
      widget.view,
      widget.visibleDates,
      widget.visibleAppointments,
      widget.timeLabelWidth,
      widget.allDayPainterHeight,
      widget.isExpandable,
      widget.isExpanding,
      widget.isRTL,
      widget.calendarTheme,
      widget.repaintNotifier,
      widget.allDayHoverPosition,
      widget.textScaleFactor,
      widget.isMobilePlatform,
      widget.width,
      widget.height,
      _appointmentCollection,
      _moreAppointmentIndex,
      widgets: _children,
    );
  }

  void _updateAppointmentDetails() {
    _indexAppointments = <int, List<_AppointmentView>>{};
    _moreAppointmentIndex = <int, int>{};
    _appointmentCollection = <_AppointmentView>[];

    /// Return when the widget as not placed on current visible calendar view.
    if (widget.visibleDates !=
        _updateCalendarStateDetails._currentViewVisibleDates) {
      return;
    }

    _appointmentCollection =
        _updateCalendarStateDetails._allDayAppointmentViewCollection ??
            <_AppointmentView>[];
    final double cellWidth =
        (widget.width - widget.timeLabelWidth) / widget.visibleDates.length;
    final double cellEndPadding = widget.calendar.cellEndPadding;
    const double cornerRadius = (_kAllDayAppointmentHeight * 0.1) > 2
        ? 2
        : _kAllDayAppointmentHeight * 0.1;

    /// Calculate the maximum position of the appointment this widget can hold.
    final int position =
        widget.allDayPainterHeight ~/ _kAllDayAppointmentHeight;
    for (int i = 0; i < _appointmentCollection.length; i++) {
      final _AppointmentView appointmentView = _appointmentCollection[i];
      if (appointmentView.canReuse) {
        continue;
      }

      RRect rect;
      if (widget.isRTL) {
        rect = RRect.fromRectAndRadius(
            Rect.fromLTRB(
                ((widget.visibleDates.length - appointmentView.endIndex) *
                        cellWidth) +
                    cellEndPadding,
                (_kAllDayAppointmentHeight * appointmentView.position)
                    .toDouble(),
                (widget.visibleDates.length - appointmentView.startIndex) *
                    cellWidth,
                ((_kAllDayAppointmentHeight * appointmentView.position) +
                        _kAllDayAppointmentHeight -
                        1)
                    .toDouble()),
            const Radius.circular(cornerRadius));
      } else {
        rect = RRect.fromRectAndRadius(
            Rect.fromLTRB(
                widget.timeLabelWidth +
                    (appointmentView.startIndex * cellWidth),
                (_kAllDayAppointmentHeight * appointmentView.position)
                    .toDouble(),
                (appointmentView.endIndex * cellWidth) +
                    widget.timeLabelWidth -
                    cellEndPadding,
                ((_kAllDayAppointmentHeight * appointmentView.position) +
                        _kAllDayAppointmentHeight -
                        1)
                    .toDouble()),
            const Radius.circular(cornerRadius));
      }

      for (int j = appointmentView.startIndex;
          j < appointmentView.endIndex;
          j++) {
        List<_AppointmentView> appointmentViews;
        if (_indexAppointments.containsKey(j)) {
          appointmentViews = _indexAppointments[j];
          appointmentViews.add(appointmentView);
        } else {
          appointmentViews = <_AppointmentView>[appointmentView];
        }
        _indexAppointments[j] = appointmentViews;
      }

      /// Calculate the appointment bound for visible region appointments not
      /// all visible appointments of the widget.
      if (!widget.isRTL && rect.left < widget.timeLabelWidth - 1 ||
          rect.right > widget.width + 1 ||
          (rect.bottom >
                  widget.allDayPainterHeight - _kAllDayAppointmentHeight &&
              appointmentView.maxPositions > position)) {
        continue;
      } else if (widget.isRTL &&
              rect.right > widget.width - widget.timeLabelWidth + 1 ||
          rect.left < 0 ||
          (rect.bottom >
                  widget.allDayPainterHeight - _kAllDayAppointmentHeight &&
              appointmentView.maxPositions > position)) {
        continue;
      }

      appointmentView.appointmentRect = rect;
    }

    int maxPosition = 0;
    if (_appointmentCollection.isNotEmpty) {
      /// Calculate the maximum appointment position of all the appointment
      /// views in the widget.
      maxPosition = _appointmentCollection
          .reduce(
              (_AppointmentView currentAppView, _AppointmentView nextAppView) =>
                  currentAppView.maxPositions > nextAppView.maxPositions
                      ? currentAppView
                      : nextAppView)
          .maxPositions;
    }

    if (maxPosition == -1) {
      maxPosition = 0;
    }

    /// Calculate the more appointments region when the widget as expandable
    /// and its max position greater than widget holding position.
    if (widget.isExpandable && maxPosition > position && !widget.isExpanding) {
      final List<int> keys = _indexAppointments.keys.toList();
      final int endIndexPosition = position - 1;
      for (int i = 0; i < keys.length; i++) {
        final int key = keys[i];
        final List<_AppointmentView> appointmentViews = _indexAppointments[key];
        int count = 0;
        if (appointmentViews.isNotEmpty) {
          /// Calculate the current index appointments max position.
          maxPosition = appointmentViews
              .reduce((_AppointmentView currentAppView,
                      _AppointmentView nextAppView) =>
                  currentAppView.maxPositions > nextAppView.maxPositions
                      ? currentAppView
                      : nextAppView)
              .maxPositions;
        }
        if (maxPosition <= position) {
          continue;
        }

        for (final _AppointmentView view in appointmentViews) {
          if (view.appointment == null) {
            continue;
          }

          /// Check if position greater than more appointment region index then
          /// increase the count, else if the position equal to more appointment
          /// region index then check it max position greater than position
          /// (because max position value is addition of maximum position
          /// with 1).
          if (view.position > endIndexPosition ||
              (view.position == endIndexPosition &&
                  view.maxPositions > position)) {
            count++;
          }
        }

        if (count == 0) {
          continue;
        }

        _moreAppointmentIndex[key] = count;
      }
    }
  }
}

class _AllDayAppointmentRenderWidget extends MultiChildRenderObjectWidget {
  _AllDayAppointmentRenderWidget(
      this.calendar,
      this.view,
      this.visibleDates,
      this.visibleAppointments,
      this.timeLabelWidth,
      this.allDayPainterHeight,
      this.isExpandable,
      this.isExpanding,
      this.isRTL,
      this.calendarTheme,
      this.repaintNotifier,
      this.allDayHoverPosition,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.width,
      this.height,
      this.appointmentCollection,
      this.moreAppointmentIndex,
      {List<Widget> widgets})
      : super(children: widgets);
  final SfCalendar calendar;
  final CalendarView view;
  final List<DateTime> visibleDates;
  final List<Appointment> visibleAppointments;
  final ValueNotifier<_SelectionDetails> repaintNotifier;
  final double timeLabelWidth;
  final double allDayPainterHeight;
  final bool isRTL;
  final SfCalendarThemeData calendarTheme;
  final ValueNotifier<Offset> allDayHoverPosition;
  final double textScaleFactor;
  final bool isMobilePlatform;
  final double height;
  final double width;
  final bool isExpandable;
  final bool isExpanding;
  final Map<int, int> moreAppointmentIndex;
  final List<_AppointmentView> appointmentCollection;

  @override
  _AllDayAppointmentRenderObject createRenderObject(BuildContext context) {
    return _AllDayAppointmentRenderObject(
        calendar,
        view,
        visibleDates,
        visibleAppointments,
        timeLabelWidth,
        allDayPainterHeight,
        isExpandable,
        isExpanding,
        isRTL,
        calendarTheme,
        repaintNotifier,
        allDayHoverPosition,
        textScaleFactor,
        isMobilePlatform,
        width,
        height,
        appointmentCollection,
        moreAppointmentIndex);
  }

  @override
  void updateRenderObject(
      BuildContext context, _AllDayAppointmentRenderObject renderObject) {
    renderObject
      ..appointmentCollection = appointmentCollection
      ..moreAppointmentIndex = moreAppointmentIndex
      ..calendar = calendar
      ..view = view
      ..visibleDates = visibleDates
      ..visibleAppointments = visibleAppointments
      ..timeLabelWidth = timeLabelWidth
      ..allDayPainterHeight = allDayPainterHeight
      ..isExpandable = isExpandable
      ..isExpanding = isExpanding
      ..isRTL = isRTL
      ..calendarTheme = calendarTheme
      ..selectionNotifier = repaintNotifier
      ..allDayHoverPosition = allDayHoverPosition
      ..textScaleFactor = textScaleFactor
      ..isMobilePlatform = isMobilePlatform
      ..width = width
      ..height = height;
  }
}

class _AllDayAppointmentRenderObject extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _CalendarParentData> {
  _AllDayAppointmentRenderObject(
      this.calendar,
      this._view,
      this._visibleDates,
      this._visibleAppointments,
      this._timeLabelWidth,
      this._allDayPainterHeight,
      this._isExpandable,
      this.isExpanding,
      this._isRTL,
      this._calendarTheme,
      this._selectionNotifier,
      this._allDayHoverPosition,
      this._textScaleFactor,
      this.isMobilePlatform,
      this._width,
      this._height,
      this.appointmentCollection,
      this.moreAppointmentIndex);

  SfCalendar calendar;
  bool isMobilePlatform;
  bool isExpanding;
  Map<int, int> moreAppointmentIndex;
  List<_AppointmentView> appointmentCollection;

  /// Width of the widget.
  double _width;

  double get width => _width;

  set width(double value) {
    if (_width == value) {
      return;
    }

    _width = value;
    markNeedsLayout();
  }

  /// Total height of the widget.
  double _height;

  double get height => _height;

  set height(double value) {
    if (_height == value) {
      return;
    }

    _height = value;
    markNeedsLayout();
  }

  /// Current height of the widget.
  double _allDayPainterHeight;

  double get allDayPainterHeight => _allDayPainterHeight;

  set allDayPainterHeight(double value) {
    if (_allDayPainterHeight == value) {
      return;
    }

    _allDayPainterHeight = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// Current calendar view of the widget.
  CalendarView _view;

  CalendarView get view => _view;

  set view(CalendarView value) {
    if (_view == value) {
      return;
    }

    _view = value;
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

  /// Used to check whether the widget is expandable or not.
  bool _isExpandable;

  bool get isExpandable => _isExpandable;

  set isExpandable(bool value) {
    if (_isExpandable == value) {
      return;
    }

    _isExpandable = value;
    if (childCount == 0) {
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

  List<Appointment> _visibleAppointments;

  List<Appointment> get visibleAppointments => _visibleAppointments;

  set visibleAppointments(List<Appointment> value) {
    if (_visibleAppointments == value) {
      return;
    }

    _visibleAppointments = value;
    if (childCount == 0) {
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
    if (childCount != 0) {
      return;
    }

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

  bool _isRTL;

  bool get isRTL => _isRTL;

  set isRTL(bool value) {
    if (_isRTL == value) {
      return;
    }

    _isRTL = value;
    markNeedsPaint();
  }

  ValueNotifier<Offset> _allDayHoverPosition;

  ValueNotifier<Offset> get allDayHoverPosition => _allDayHoverPosition;

  set allDayHoverPosition(ValueNotifier<Offset> value) {
    if (_allDayHoverPosition == value) {
      return;
    }

    _allDayHoverPosition?.removeListener(markNeedsPaint);
    _allDayHoverPosition = value;
    _allDayHoverPosition?.addListener(markNeedsPaint);
  }

  ValueNotifier<_SelectionDetails> _selectionNotifier;

  ValueNotifier<_SelectionDetails> get selectionNotifier => _selectionNotifier;

  set selectionNotifier(ValueNotifier<_SelectionDetails> value) {
    if (_selectionNotifier == value) {
      return;
    }

    _selectionNotifier?.removeListener(markNeedsPaint);
    _selectionNotifier = value;
    _selectionNotifier?.addListener(markNeedsPaint);
  }

  Paint _rectPainter;
  TextPainter _textPainter;
  TextPainter _expanderTextPainter;
  BoxPainter _boxPainter;
  bool _isHoveringAppointment = false;
  int _maxPosition = 0;
  double _cellWidth = 0;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! _CalendarParentData) {
      child.parentData = _CalendarParentData();
    }
  }

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _allDayHoverPosition?.addListener(markNeedsPaint);
    _selectionNotifier?.addListener(markNeedsPaint);
  }

  /// detach will called when the render object removed from view.
  @override
  void detach() {
    _allDayHoverPosition?.removeListener(markNeedsPaint);
    _selectionNotifier?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? height : widgetSize.height);
    RenderBox child = firstChild;
    final int position = allDayPainterHeight ~/ _kAllDayAppointmentHeight;
    final double maximumBottomPosition =
        allDayPainterHeight - _kAllDayAppointmentHeight;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final _AppointmentView _appointmentView = appointmentCollection[i];
      if (_appointmentView.appointment == null ||
          child == null ||
          _appointmentView.appointmentRect == null) {
        continue;
      }

      if (!isRTL &&
              _appointmentView.appointmentRect.left < timeLabelWidth - 1 ||
          _appointmentView.appointmentRect.right > size.width + 1 ||
          (_appointmentView.appointmentRect.bottom > maximumBottomPosition &&
              _appointmentView.maxPositions > position)) {
        child = childAfter(child);
        continue;
      } else if (isRTL &&
              _appointmentView.appointmentRect.right >
                  size.width - timeLabelWidth + 1 ||
          _appointmentView.appointmentRect.left < 0 ||
          (_appointmentView.appointmentRect.bottom > maximumBottomPosition &&
              _appointmentView.maxPositions > position)) {
        child = childAfter(child);
        continue;
      }

      child.layout(constraints.copyWith(
          minHeight: _appointmentView.appointmentRect.height,
          maxHeight: _appointmentView.appointmentRect.height,
          minWidth: _appointmentView.appointmentRect.width,
          maxWidth: _appointmentView.appointmentRect.width));
      child = childAfter(child);
    }

    _cellWidth = (size.width - timeLabelWidth) / visibleDates.length;
    final double appointmentHeight = _kAllDayAppointmentHeight - 1;
    final double maxAppointmentWidth = _cellWidth - calendar.cellEndPadding;
    final List<int> keys = moreAppointmentIndex.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      if (child == null) {
        continue;
      }

      child.layout(constraints.copyWith(
          minHeight: appointmentHeight,
          maxHeight: appointmentHeight,
          minWidth: maxAppointmentWidth,
          maxWidth: maxAppointmentWidth));
      child = childAfter(child);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _rectPainter ??= Paint();
    final Canvas canvas = context.canvas;
    if (view == CalendarView.day) {
      _rectPainter ??= Paint();
      _rectPainter.strokeWidth = 0.5;
      _rectPainter.color =
          calendar.cellBorderColor ?? calendarTheme.cellBorderColor;
      //// Decrease the x position by 0.5 because draw the end point of the view
      /// draws half of the line to current view and hides another half.
      canvas.drawLine(
          Offset(
              isRTL ? size.width - timeLabelWidth + 0.5 : timeLabelWidth - 0.5,
              0),
          Offset(
              isRTL ? size.width - timeLabelWidth + 0.5 : timeLabelWidth - 0.5,
              size.height),
          _rectPainter);
    }

    _rectPainter.isAntiAlias = true;
    _cellWidth = (size.width - timeLabelWidth) / visibleDates.length;
    const double textPadding = 3;
    final double cellEndPadding = calendar.cellEndPadding;
    _maxPosition = 0;
    if (appointmentCollection.isNotEmpty) {
      _maxPosition = appointmentCollection
          .reduce(
              (_AppointmentView currentAppView, _AppointmentView nextAppView) =>
                  currentAppView.maxPositions > nextAppView.maxPositions
                      ? currentAppView
                      : nextAppView)
          .maxPositions;
    }

    if (_maxPosition == -1) {
      _maxPosition = 0;
    }

    _isHoveringAppointment = false;
    final int position = allDayPainterHeight ~/ _kAllDayAppointmentHeight;
    RenderBox child = firstChild;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final _AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.canReuse ||
          appointmentView.appointmentRect == null ||
          appointmentView.appointment == null) {
        continue;
      }

      final RRect rect = appointmentView.appointmentRect;
      if (!isRTL && rect.left < timeLabelWidth - 1 ||
          rect.right > size.width + 1 ||
          (rect.bottom > allDayPainterHeight - _kAllDayAppointmentHeight &&
              appointmentView.maxPositions > position)) {
        if (child != null) {
          child = childAfter(child);
        }
        continue;
      } else if (isRTL && rect.right > size.width - timeLabelWidth + 1 ||
          rect.left < 0 ||
          (rect.bottom > allDayPainterHeight - _kAllDayAppointmentHeight &&
              appointmentView.maxPositions > position)) {
        if (child != null) {
          child = childAfter(child);
        }
        continue;
      }

      if (child != null) {
        child.paint(context, Offset(rect.left, rect.top));
        child = childAfter(child);
      } else {
        final Appointment appointment = appointmentView.appointment;
        _rectPainter.color = appointment.color;
        canvas.drawRRect(rect, _rectPainter);
        final TextSpan span = TextSpan(
          text: _getAllDayAppointmentText(appointment),
          style: calendar.appointmentTextStyle,
        );
        _textPainter = _textPainter ??
            TextPainter(
                textDirection: TextDirection.ltr,
                maxLines: 1,
                textAlign: TextAlign.left,
                textScaleFactor: textScaleFactor,
                textWidthBasis: TextWidthBasis.longestLine);
        _textPainter.text = span;
        _textPainter.layout(
            minWidth: 0,
            maxWidth:
                rect.width - textPadding >= 0 ? rect.width - textPadding : 0);
        if (_textPainter.maxLines == 1 && _textPainter.height > rect.height) {
          continue;
        }

        final bool canAddSpanIcon =
            _canAddSpanIcon(visibleDates, appointment, view);
        bool canAddForwardIcon = false;
        bool canAddBackwardIcon = false;

        double xPosition = isRTL
            ? rect.right - _textPainter.width - textPadding
            : rect.left + textPadding;

        if (canAddSpanIcon) {
          final DateTime appStartTime = appointment._exactStartTime;
          final DateTime appEndTime = appointment._exactEndTime;
          final DateTime viewStartDate = _convertToStartTime(visibleDates[0]);
          final DateTime viewEndDate =
              _convertToEndTime(visibleDates[visibleDates.length - 1]);
          double iconSize = _getTextSize(
              rect,
              (calendar.appointmentTextStyle.fontSize *
                  _textPainter.textScaleFactor));
          if (_canAddForwardSpanIcon(
              appStartTime, appEndTime, viewStartDate, viewEndDate)) {
            canAddForwardIcon = true;
            iconSize = null;
          } else if (_canAddBackwardSpanIcon(
              appStartTime, appEndTime, viewStartDate, viewEndDate)) {
            canAddBackwardIcon = true;
          } else {
            canAddForwardIcon = true;
            canAddBackwardIcon = true;
          }

          if (iconSize != null) {
            if (isRTL) {
              xPosition -= iconSize + (isMobilePlatform ? 0 : 2);
            } else {
              xPosition += iconSize + (isMobilePlatform ? 0 : 2);
            }
          }
        }

        _textPainter.paint(
            canvas,
            Offset(
                xPosition, rect.top + (rect.height - _textPainter.height) / 2));
        if (appointment.recurrenceRule != null &&
            appointment.recurrenceRule.isNotEmpty) {
          _addRecurrenceIcon(canvas, rect, textPadding);
        }

        if (canAddSpanIcon) {
          if (canAddForwardIcon && canAddBackwardIcon) {
            _addForwardSpanIconForAllDay(
                canvas, rect, textPadding, isMobilePlatform);
            _addBackwardSpanIconForAllDay(
                canvas, rect, textPadding, isMobilePlatform);
          } else if (canAddBackwardIcon) {
            _addBackwardSpanIconForAllDay(
                canvas, rect, textPadding, isMobilePlatform);
          } else {
            _addForwardSpanIconForAllDay(
                canvas, rect, textPadding, isMobilePlatform);
          }
        }
      }

      if (allDayHoverPosition != null) {
        _addMouseHoveringForAppointment(canvas, rect);
      }

      if (selectionNotifier.value != null &&
          selectionNotifier.value.appointmentView != null &&
          selectionNotifier.value.appointmentView.appointment != null &&
          selectionNotifier.value.appointmentView.appointment ==
              appointmentView.appointment) {
        _addSelectionForAppointment(canvas, appointmentView);
      }
    }

    if (selectionNotifier.value != null &&
        selectionNotifier.value.selectedDate != null) {
      _addSelectionForAllDayPanel(canvas, size, cellEndPadding);
    }

    if (isExpandable && _maxPosition > position && !isExpanding) {
      if (child != null) {
        final double endYPosition =
            allDayPainterHeight - _kAllDayAppointmentHeight;
        final List<int> keys = moreAppointmentIndex.keys.toList();
        for (final int index in keys) {
          if (child == null) {
            continue;
          }

          final double xPosition = isRTL
              ? ((visibleDates.length - index - 1) * _cellWidth) +
                  cellEndPadding
              : timeLabelWidth + (index * _cellWidth);
          child.paint(context, Offset(xPosition, endYPosition));
          child = childAfter(child);
        }
      } else {
        _addExpanderText(canvas, position, textPadding);
      }
    }

    if (isExpandable) {
      _addExpandOrCollapseIcon(canvas, size, position);
    }

    if (allDayHoverPosition != null && !_isHoveringAppointment) {
      _addMouseHoveringForAllDayPanel(canvas, size);
    }
  }

  /// To display the different text on spanning appointment for day view, for
  /// other views we just display the subject of the appointment and for day
  /// view  we display the current date, and total dates of the spanning
  /// appointment.
  String _getAllDayAppointmentText(Appointment appointment) {
    if (view != CalendarView.day || !appointment._isSpanned) {
      return appointment.subject;
    }

    return _getSpanAppointmentText(appointment, visibleDates[0]);
  }

  double _getTextSize(RRect rect, double textSize) {
    if (rect.width < textSize || rect.height < textSize) {
      return rect.width > rect.height ? rect.height : rect.width;
    }

    return textSize;
  }

  void _addForwardSpanIconForAllDay(
      Canvas canvas, RRect rect, double textPadding, bool isMobilePlatform) {
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);
    final TextSpan icon = _getSpanIcon(
        calendar.appointmentTextStyle.color, textSize, isRTL ? false : true);
    final double leftPadding = isMobilePlatform ? 1 : 2;
    _textPainter.text = icon;
    _textPainter.layout(
        minWidth: 0,
        maxWidth: rect.width - textPadding >= 0 ? rect.width - textPadding : 0);

    final double yPosition = _getYPositionForSpanIcon(icon, _textPainter, rect);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(isRTL ? rect.left : rect.right - textSize, rect.top,
                isRTL ? rect.left : rect.right, rect.bottom),
            rect.brRadius),
        _rectPainter);
    _textPainter.paint(
        canvas,
        Offset(
            isRTL
                ? rect.left + leftPadding
                : rect.right -
                    (textSize * _textPainter.textScaleFactor) -
                    leftPadding,
            yPosition));
  }

  void _addBackwardSpanIconForAllDay(
      Canvas canvas, RRect rect, double textPadding, bool isMobilePlatform) {
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);
    final TextSpan icon = _getSpanIcon(
        calendar.appointmentTextStyle.color, textSize, isRTL ? true : false);
    final double leftPadding = isMobilePlatform ? 1 : 2;
    _textPainter.text = icon;
    _textPainter.layout(
        minWidth: 0,
        maxWidth: rect.width - textPadding >= 0 ? rect.width - textPadding : 0);

    final double yPosition = _getYPositionForSpanIcon(icon, _textPainter, rect);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(isRTL ? rect.right - textSize : rect.left, rect.top,
                isRTL ? rect.right : rect.left, rect.bottom),
            rect.brRadius),
        _rectPainter);
    _textPainter.paint(
        canvas,
        Offset(
            isRTL
                ? rect.right -
                    (textSize * _textPainter.textScaleFactor) -
                    leftPadding
                : rect.left + leftPadding,
            yPosition));
  }

  void _addExpanderText(Canvas canvas, int position, double textPadding) {
    TextStyle textStyle = calendar.viewHeaderStyle.dayTextStyle;
    textStyle ??= calendarTheme.viewHeaderDayTextStyle;
    _textPainter = _textPainter ??
        TextPainter(
            textDirection: TextDirection.ltr,
            maxLines: 1,
            textAlign: TextAlign.left,
            textScaleFactor: textScaleFactor,
            textWidthBasis: TextWidthBasis.longestLine);

    final double endYPosition = allDayPainterHeight - _kAllDayAppointmentHeight;
    final List<int> keys = moreAppointmentIndex.keys.toList();
    for (final int index in keys) {
      final TextSpan span = TextSpan(
        text: '+ ' + moreAppointmentIndex[index].toString(),
        style: textStyle,
      );
      _textPainter.text = span;
      _textPainter.layout(
          minWidth: 0,
          maxWidth:
              _cellWidth - textPadding >= 0 ? _cellWidth - textPadding : 0);

      _textPainter.paint(
          canvas,
          Offset(
              isRTL
                  ? ((visibleDates.length - index) * _cellWidth) -
                      _textPainter.width -
                      textPadding
                  : timeLabelWidth + (index * _cellWidth) + textPadding,
              endYPosition +
                  ((_kAllDayAppointmentHeight - _textPainter.height) / 2)));
    }
  }

  void _addExpandOrCollapseIcon(Canvas canvas, Size size, int position) {
    final int iconCodePoint = _maxPosition <= position
        ? Icons.expand_less.codePoint
        : Icons.expand_more.codePoint;
    final TextSpan icon = TextSpan(
        text: String.fromCharCode(iconCodePoint),
        style: TextStyle(
          color: calendar.viewHeaderStyle != null &&
                  calendar.viewHeaderStyle.dayTextStyle != null &&
                  calendar.viewHeaderStyle.dayTextStyle.color != null
              ? calendar.viewHeaderStyle.dayTextStyle.color
              : calendarTheme.viewHeaderDayTextStyle.color,
          fontSize: calendar.viewHeaderStyle != null &&
                  calendar.viewHeaderStyle.dayTextStyle != null &&
                  calendar.viewHeaderStyle.dayTextStyle.fontSize != null
              ? calendar.viewHeaderStyle.dayTextStyle.fontSize * 2
              : _kAllDayAppointmentHeight + 5,
          fontFamily: 'MaterialIcons',
        ));
    _expanderTextPainter ??= TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        textScaleFactor: textScaleFactor,
        maxLines: 1);
    _expanderTextPainter.text = icon;
    _expanderTextPainter.layout(minWidth: 0, maxWidth: timeLabelWidth);
    _expanderTextPainter.paint(
        canvas,
        Offset(
            isRTL
                ? (size.width - timeLabelWidth) +
                    ((timeLabelWidth - _expanderTextPainter.width) / 2)
                : (timeLabelWidth - _expanderTextPainter.width) / 2,
            allDayPainterHeight -
                _kAllDayAppointmentHeight +
                (_kAllDayAppointmentHeight - _expanderTextPainter.height) / 2));
  }

  void _addMouseHoveringForAllDayPanel(Canvas canvas, Size size) {
    if (allDayHoverPosition == null || allDayHoverPosition.value == null) {
      return;
    }
    final int rowIndex =
        (allDayHoverPosition.value.dx - (isRTL ? 0 : timeLabelWidth)) ~/
            _cellWidth;
    final double leftPosition =
        (rowIndex * _cellWidth) + (isRTL ? 0 : timeLabelWidth);
    _rectPainter.color = Colors.grey.withOpacity(0.1);
    canvas.drawRect(
        Rect.fromLTWH(leftPosition, 0, _cellWidth, size.height), _rectPainter);
  }

  void _addSelectionForAllDayPanel(
      Canvas canvas, Size size, double appointmentEndPadding) {
    final int index =
        _getIndex(visibleDates, selectionNotifier.value.selectedDate);
    Decoration selectionDecoration = calendar.selectionDecoration;

    /// Set the default selection decoration background color with opacity
    /// value based on theme brightness when selected date hold all day
    /// appointment.
    for (int i = 0; i < appointmentCollection.length; i++) {
      final _AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.position == 0 &&
          appointmentView.startIndex <= index &&
          appointmentView.endIndex > index) {
        selectionDecoration ??= BoxDecoration(
          color: calendarTheme.brightness == null ||
                  calendarTheme.brightness == Brightness.light
              ? Colors.white.withOpacity(0.3)
              : Colors.black.withOpacity(0.4),
          border:
              Border.all(color: calendarTheme.selectionBorderColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          shape: BoxShape.rectangle,
        );

        break;
      }
    }

    /// Set the default selection decoration background color as transparent
    /// when selected date does not hold all day appointment.
    selectionDecoration ??= BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: calendarTheme.selectionBorderColor, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      shape: BoxShape.rectangle,
    );

    Rect rect;
    double xValue = timeLabelWidth + (index * _cellWidth);
    if (isRTL) {
      xValue = size.width - xValue - _cellWidth;
      rect = Rect.fromLTRB(xValue + appointmentEndPadding, 0,
          xValue + _cellWidth, _kAllDayAppointmentHeight - 1);
    } else {
      rect = Rect.fromLTRB(
          xValue,
          0,
          xValue + _cellWidth - appointmentEndPadding,
          _kAllDayAppointmentHeight - 1);
    }

    _boxPainter =
        selectionDecoration.createBoxPainter(_updateSelectionDecorationPainter);
    _boxPainter.paint(canvas, Offset(rect.left, rect.top),
        ImageConfiguration(size: rect.size));

    selectionDecoration = null;
  }

  /// Used to pass the argument of create box painter and it is called when
  /// decoration have asynchronous data like image.
  void _updateSelectionDecorationPainter() {
    selectionNotifier.value = _SelectionDetails(
        selectionNotifier.value.appointmentView,
        selectionNotifier.value.selectedDate);
  }

  void _addSelectionForAppointment(
      Canvas canvas, _AppointmentView appointmentView) {
    Decoration selectionDecoration = calendar.selectionDecoration;
    selectionDecoration ??= BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: calendarTheme.selectionBorderColor, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(1)),
      shape: BoxShape.rectangle,
    );

    Rect rect = appointmentView.appointmentRect.outerRect;
    rect = Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);
    _boxPainter =
        selectionDecoration.createBoxPainter(_updateSelectionDecorationPainter);
    _boxPainter.paint(canvas, Offset(rect.left, rect.top),
        ImageConfiguration(size: rect.size));
  }

  void _addMouseHoveringForAppointment(Canvas canvas, RRect rect) {
    _rectPainter ??= Paint();
    if (allDayHoverPosition == null || allDayHoverPosition.value == null) {
      return;
    }

    if (rect.left < allDayHoverPosition.value.dx &&
        rect.right > allDayHoverPosition.value.dx &&
        rect.top < allDayHoverPosition.value.dy &&
        rect.bottom > allDayHoverPosition.value.dy) {
      _rectPainter.color = calendarTheme.selectionBorderColor.withOpacity(0.4);
      _rectPainter.strokeWidth = 2;
      _rectPainter.style = PaintingStyle.stroke;
      canvas.drawRect(rect.outerRect, _rectPainter);
      _rectPainter.style = PaintingStyle.fill;
      _isHoveringAppointment = true;
    }
  }

  void _addRecurrenceIcon(Canvas canvas, RRect rect, double textPadding) {
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);
    final TextSpan icon =
        _getRecurrenceIcon(calendar.appointmentTextStyle.color, textSize);
    _textPainter.text = icon;
    _textPainter.layout(
        minWidth: 0,
        maxWidth: rect.width - textPadding >= 0 ? rect.width - textPadding : 0);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(isRTL ? rect.left : rect.right - textSize, rect.top,
                isRTL ? rect.left : rect.right, rect.bottom),
            rect.brRadius),
        _rectPainter);
    _textPainter.paint(
        canvas,
        Offset(isRTL ? rect.left + 1 : rect.right - textSize - 1,
            rect.top + (rect.height - _textPainter.height) / 2));
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
    final List<CustomPainterSemantics> semantics = _getSemanticsBuilder(size);
    final List<SemanticsNode> semanticsNodes = <SemanticsNode>[];
    for (int i = 0; i < semantics.length; i++) {
      final CustomPainterSemantics currentSemantics = semantics[i];
      final SemanticsNode newChild = SemanticsNode(
        key: currentSemantics.key,
      );

      final SemanticsProperties properties = currentSemantics.properties;
      final SemanticsConfiguration config = SemanticsConfiguration();
      if (properties.label != null) {
        config.label = properties.label;
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

    super.assembleSemanticsNode(node, config, finalChildren);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    return;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    if (appointmentCollection == null || appointmentCollection.isEmpty) {
      return semanticsBuilder;
    }

    final int position = allDayPainterHeight ~/ _kAllDayAppointmentHeight;
    final double bottom = allDayPainterHeight - _kAllDayAppointmentHeight;
    if (isExpandable) {
      final double left = isRTL ? size.width - timeLabelWidth : 0;
      final double top = allDayPainterHeight - _kAllDayAppointmentHeight;
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(left, top, isRTL ? size.width : timeLabelWidth,
            _expanderTextPainter.height),
        properties: SemanticsProperties(
          label:
              _maxPosition <= allDayPainterHeight ~/ _kAllDayAppointmentHeight
                  ? 'Collapse all day section'
                  : 'Expand all day section',
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    if (isExpandable &&
        _maxPosition > (allDayPainterHeight ~/ _kAllDayAppointmentHeight) &&
        !isExpanding) {
      final List<int> keys = moreAppointmentIndex.keys.toList();
      for (final int index in keys) {
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(
              isRTL
                  ? ((visibleDates.length - index) * _cellWidth) - _cellWidth
                  : timeLabelWidth + (index * _cellWidth),
              bottom,
              _cellWidth,
              _kAllDayAppointmentHeight),
          properties: SemanticsProperties(
            label: '+' + moreAppointmentIndex[index].toString(),
            textDirection: TextDirection.ltr,
          ),
        ));
      }
    }

    for (int i = 0; i < appointmentCollection.length; i++) {
      final _AppointmentView view = appointmentCollection[i];
      if (view.appointment == null ||
          view.appointmentRect == null ||
          (view.appointmentRect != null &&
              view.appointmentRect.bottom > bottom &&
              view.maxPositions > position)) {
        continue;
      }

      semanticsBuilder.add(CustomPainterSemantics(
        rect: view.appointmentRect?.outerRect,
        properties: SemanticsProperties(
          label: _getAppointmentText(view.appointment),
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    return semanticsBuilder;
  }
}
