part of calendar;

class _AgendaViewLayout extends StatefulWidget {
  _AgendaViewLayout(
      this.monthViewSettings,
      this.scheduleViewSettings,
      this.selectedDate,
      this.appointments,
      this.isRTL,
      this.locale,
      this.localizations,
      this.calendarTheme,
      this.agendaViewNotifier,
      this.appointmentTimeTextFormat,
      this.timeLabelWidth,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.appointmentBuilder,
      this.width,
      this.height);

  final MonthViewSettings monthViewSettings;
  final ScheduleViewSettings scheduleViewSettings;
  final DateTime selectedDate;
  final List<Appointment> appointments;
  final bool isRTL;
  final String locale;
  final SfCalendarThemeData calendarTheme;
  final ValueNotifier<_ScheduleViewHoveringDetails> agendaViewNotifier;
  final SfLocalizations localizations;
  final double timeLabelWidth;
  final String appointmentTimeTextFormat;
  final CalendarAppointmentBuilder appointmentBuilder;
  final double textScaleFactor;
  final bool isMobilePlatform;
  final double width;
  final double height;

  @override
  _AgendaViewLayoutState createState() => _AgendaViewLayoutState();
}

class _AgendaViewLayoutState extends State<_AgendaViewLayout> {
  /// It holds the appointment views for the visible appointments.
  List<_AppointmentView> _appointmentCollection;

  /// It holds the children of the widget, it holds null or empty when
  /// appointment builder is null.
  List<Widget> _children;

  @override
  void initState() {
    _appointmentCollection = <_AppointmentView>[];
    _children = <Widget>[];
    _updateAppointmentDetails();
    super.initState();
  }

  @override
  void didUpdateWidget(_AgendaViewLayout oldWidget) {
    if (widget.appointments != oldWidget.appointments ||
        widget.selectedDate != oldWidget.selectedDate ||
        widget.timeLabelWidth != oldWidget.timeLabelWidth ||
        widget.width != oldWidget.width ||
        widget.height != oldWidget.height ||
        widget.appointmentBuilder != oldWidget.appointmentBuilder) {
      _updateAppointmentDetails();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _children ??= <Widget>[];

    /// Create the widgets when appointment builder is not null.
    if (_children.isEmpty &&
        widget.appointmentBuilder != null &&
        _appointmentCollection != null) {
      final int appointmentCount = _appointmentCollection.length;
      for (int i = 0; i < appointmentCount; i++) {
        final _AppointmentView view = _appointmentCollection[i];

        /// Check the appointment view have appointment, if not then the
        /// appointment view is not valid or it will be used for reusing view.
        if (view.appointment == null || view.appointmentRect == null) {
          continue;
        }
        final CalendarAppointmentDetails details = CalendarAppointmentDetails(
            appointments:
                List.unmodifiable([view.appointment._data ?? view.appointment]),
            date: widget.selectedDate,
            bounds: view.appointmentRect.outerRect);
        final Widget child = widget.appointmentBuilder(context, details);

        /// Throw exception when builder return widget is null.
        assert(child != null, 'Widget must not be null');
        _children.add(RepaintBoundary(child: child));
      }
    }

    return _AgendaViewRenderWidget(
        widget.monthViewSettings,
        widget.scheduleViewSettings,
        widget.selectedDate,
        widget.appointments,
        widget.isRTL,
        widget.locale,
        widget.localizations,
        widget.calendarTheme,
        widget.agendaViewNotifier,
        widget.appointmentTimeTextFormat,
        widget.timeLabelWidth,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        _appointmentCollection,
        widget.width,
        widget.height,
        widgets: _children);
  }

  void _updateAppointmentDetails() {
    double yPosition = 5;
    const double padding = 5;

    final double totalAgendaViewWidth = widget.width + widget.timeLabelWidth;
    final bool useMobilePlatformUI =
        _isMobileLayoutUI(totalAgendaViewWidth, widget.isMobilePlatform);
    _resetAppointmentView(_appointmentCollection);
    _children.clear();
    if (widget.selectedDate == null ||
        widget.appointments == null ||
        widget.appointments.isEmpty) {
      return;
    }

    final bool isLargerScheduleUI =
        widget.scheduleViewSettings == null || useMobilePlatformUI
            ? false
            : true;

    widget.appointments.sort((Appointment app1, Appointment app2) =>
        app1._actualStartTime.compareTo(app2._actualStartTime));
    widget.appointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));
    widget.appointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1._isSpanned, app2._isSpanned));
    final double agendaItemHeight = _getScheduleAppointmentHeight(
        widget.monthViewSettings, widget.scheduleViewSettings);
    final double agendaAllDayItemHeight = _getScheduleAllDayAppointmentHeight(
        widget.monthViewSettings, widget.scheduleViewSettings);

    for (int i = 0; i < widget.appointments.length; i++) {
      final Appointment appointment = widget.appointments[i];
      final bool isSpanned =
          appointment._actualEndTime.day != appointment._actualStartTime.day ||
              appointment._isSpanned;
      final double appointmentHeight =
          (appointment.isAllDay || isSpanned) && !isLargerScheduleUI
              ? agendaAllDayItemHeight
              : agendaItemHeight;
      final Rect rect = Rect.fromLTWH(
          padding, yPosition, widget.width - (2 * padding), appointmentHeight);
      final Radius cornerRadius = Radius.circular(
          (appointmentHeight * 0.1) > 5 ? 5 : (appointmentHeight * 0.1));
      yPosition += appointmentHeight + padding;
      _AppointmentView appointmentRenderer;
      for (int i = 0; i < _appointmentCollection.length; i++) {
        final _AppointmentView view = _appointmentCollection[i];
        if (view.appointment == null) {
          appointmentRenderer = view;
          break;
        }
      }

      if (appointmentRenderer == null) {
        appointmentRenderer = _AppointmentView();
        appointmentRenderer.appointment = appointment;
        appointmentRenderer.canReuse = false;
        _appointmentCollection.add(appointmentRenderer);
      }

      appointmentRenderer.canReuse = false;
      appointmentRenderer.appointment = appointment;
      appointmentRenderer.appointmentRect =
          RRect.fromRectAndRadius(rect, cornerRadius);
    }
  }
}

class _AgendaViewRenderWidget extends MultiChildRenderObjectWidget {
  _AgendaViewRenderWidget(
      this.monthViewSettings,
      this.scheduleViewSettings,
      this.selectedDate,
      this.appointments,
      this.isRTL,
      this.locale,
      this.localizations,
      this.calendarTheme,
      this.agendaViewNotifier,
      this.appointmentTimeTextFormat,
      this.timeLabelWidth,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.appointmentCollection,
      this.width,
      this.height,
      {List<Widget> widgets})
      : super(children: widgets);

  final MonthViewSettings monthViewSettings;
  final ScheduleViewSettings scheduleViewSettings;
  final DateTime selectedDate;
  final List<Appointment> appointments;
  final bool isRTL;
  final String locale;
  final SfCalendarThemeData calendarTheme;
  final ValueNotifier<_ScheduleViewHoveringDetails> agendaViewNotifier;
  final SfLocalizations localizations;
  final double timeLabelWidth;
  final String appointmentTimeTextFormat;
  final double textScaleFactor;
  final bool isMobilePlatform;
  final List<_AppointmentView> appointmentCollection;
  final double width;
  final double height;

  @override
  _AgendaViewRenderObject createRenderObject(BuildContext context) {
    return _AgendaViewRenderObject(
        monthViewSettings,
        scheduleViewSettings,
        selectedDate,
        appointments,
        isRTL,
        locale,
        localizations,
        calendarTheme,
        agendaViewNotifier,
        appointmentTimeTextFormat,
        timeLabelWidth,
        textScaleFactor,
        isMobilePlatform,
        appointmentCollection,
        width,
        height);
  }

  @override
  void updateRenderObject(
      BuildContext context, _AgendaViewRenderObject renderObject) {
    renderObject
      ..monthViewSettings = monthViewSettings
      ..scheduleViewSettings = scheduleViewSettings
      ..selectedDate = selectedDate
      ..appointments = appointments
      ..isRTL = isRTL
      ..locale = locale
      ..localizations = localizations
      ..calendarTheme = calendarTheme
      ..agendaViewNotifier = agendaViewNotifier
      ..appointmentTimeTextFormat = appointmentTimeTextFormat
      ..timeLabelWidth = timeLabelWidth
      ..textScaleFactor = textScaleFactor
      ..appointmentCollection = appointmentCollection
      ..width = width
      ..height = height;
  }
}

class _AgendaViewRenderObject extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _CalendarParentData> {
  _AgendaViewRenderObject(
      this._monthViewSettings,
      this._scheduleViewSettings,
      this._selectedDate,
      this._appointments,
      this._isRTL,
      this._locale,
      this._localizations,
      this._calendarTheme,
      this._agendaViewNotifier,
      this._appointmentTimeTextFormat,
      this._timeLabelWidth,
      this._textScaleFactor,
      this.isMobilePlatform,
      this._appointmentCollection,
      this._width,
      this._height);

  final bool isMobilePlatform;

  double _height;

  double get height => _height;

  set height(double value) {
    if (_height == value) {
      return;
    }

    _height = value;
    markNeedsLayout();
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

  double _textScaleFactor;

  double get textScaleFactor => _textScaleFactor;

  set textScaleFactor(double value) {
    if (_textScaleFactor == value) {
      return;
    }

    _textScaleFactor = value;
    markNeedsPaint();
  }

  MonthViewSettings _monthViewSettings;

  MonthViewSettings get monthViewSettings => _monthViewSettings;

  set monthViewSettings(MonthViewSettings value) {
    if (_monthViewSettings == value) {
      return;
    }

    _monthViewSettings = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  ScheduleViewSettings _scheduleViewSettings;

  ScheduleViewSettings get scheduleViewSettings => _scheduleViewSettings;

  set scheduleViewSettings(ScheduleViewSettings value) {
    if (_scheduleViewSettings == value) {
      return;
    }

    _scheduleViewSettings = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  String _locale;

  String get locale => _locale;

  set locale(String value) {
    if (_locale == value) {
      return;
    }

    _locale = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  SfLocalizations _localizations;

  SfLocalizations get localizations => _localizations;

  set localizations(SfLocalizations value) {
    if (_localizations == value) {
      return;
    }

    _localizations = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  String _appointmentTimeTextFormat;

  String get appointmentTimeTextFormat => _appointmentTimeTextFormat;

  set appointmentTimeTextFormat(String value) {
    if (_appointmentTimeTextFormat == value) {
      return;
    }

    _appointmentTimeTextFormat = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  double _timeLabelWidth;

  double get timeLabelWidth => _timeLabelWidth;

  set timeLabelWidth(double value) {
    if (_timeLabelWidth == value) {
      return;
    }

    _timeLabelWidth = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  DateTime _selectedDate;

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime value) {
    if (_selectedDate == value) {
      return;
    }

    _selectedDate = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  List<Appointment> _appointments;

  List<Appointment> get appointments => _appointments;

  set appointments(List<Appointment> value) {
    if (_appointments == value) {
      return;
    }

    _appointments = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  List<_AppointmentView> _appointmentCollection;

  List<_AppointmentView> get appointmentCollection => _appointmentCollection;

  set appointmentCollection(List<_AppointmentView> value) {
    if (_appointmentCollection == value) {
      return;
    }

    _appointmentCollection = value;
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

  ValueNotifier<_ScheduleViewHoveringDetails> _agendaViewNotifier;

  ValueNotifier<_ScheduleViewHoveringDetails> get agendaViewNotifier =>
      _agendaViewNotifier;

  set agendaViewNotifier(ValueNotifier<_ScheduleViewHoveringDetails> value) {
    if (_agendaViewNotifier == value) {
      return;
    }

    _agendaViewNotifier?.removeListener(markNeedsPaint);
    _agendaViewNotifier = value;
    _agendaViewNotifier?.addListener(markNeedsPaint);
  }

  Paint _rectPainter;
  TextPainter _textPainter;

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _agendaViewNotifier?.addListener(markNeedsPaint);
  }

  /// detach will called when the render object removed from view.
  @override
  void detach() {
    _agendaViewNotifier?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! _CalendarParentData) {
      child.parentData = _CalendarParentData();
    }
  }

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? height : widgetSize.height);
    RenderBox child = firstChild;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final _AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.appointment == null ||
          child == null ||
          appointmentView.appointmentRect == null) {
        continue;
      }

      child.layout(constraints.copyWith(
          minHeight: appointmentView.appointmentRect.height,
          maxHeight: appointmentView.appointmentRect.height,
          minWidth: appointmentView.appointmentRect.width,
          maxWidth: appointmentView.appointmentRect.width));
      child = childAfter(child);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox child = firstChild;
    final bool _isNeedDefaultPaint = childCount == 0;
    _rectPainter = _rectPainter ?? Paint();
    final double totalAgendaViewWidth = size.width + _timeLabelWidth;
    final bool useMobilePlatformUI =
        _isMobileLayoutUI(totalAgendaViewWidth, isMobilePlatform);
    final bool isLargerScheduleUI =
        scheduleViewSettings == null || useMobilePlatformUI ? false : true;
    if (_isNeedDefaultPaint) {
      _textPainter = _textPainter ?? TextPainter();
      _drawDefaultUI(context.canvas, isLargerScheduleUI, offset);
    } else {
      const double padding = 5.0;
      for (int i = 0; i < appointmentCollection.length; i++) {
        final _AppointmentView appointmentView = appointmentCollection[i];
        if (appointmentView.appointment == null ||
            child == null ||
            appointmentView.appointmentRect == null) {
          continue;
        }

        final RRect rect = appointmentView.appointmentRect.shift(offset);
        child.paint(context, Offset(rect.left, rect.top));
        if (agendaViewNotifier.value != null &&
            isSameDate(agendaViewNotifier.value.hoveringDate, selectedDate)) {
          _addMouseHovering(
              context.canvas, size, rect, isLargerScheduleUI, padding);
        }

        child = childAfter(child);
      }
    }
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
    if (selectedDate == null) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: const SemanticsProperties(
          label: 'No selected date',
          textDirection: TextDirection.ltr,
        ),
      ));
    } else if (selectedDate != null &&
        (appointments == null || appointments.isEmpty)) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: SemanticsProperties(
          label: DateFormat('EEEEE').format(selectedDate).toString() +
              DateFormat('dd/MMMM/yyyy').format(selectedDate).toString() +
              ', '
                  'No events',
          textDirection: TextDirection.ltr,
        ),
      ));
    } else if (selectedDate != null &&
        appointmentCollection != null &&
        appointmentCollection.isNotEmpty) {
      for (int i = 0; i < appointmentCollection.length; i++) {
        final _AppointmentView appointmentView = appointmentCollection[i];
        if (appointmentView.appointment == null) {
          continue;
        }
        semanticsBuilder.add(CustomPainterSemantics(
          rect: appointmentView.appointmentRect.outerRect,
          properties: SemanticsProperties(
            label: _getAppointmentText(appointmentView.appointment),
            textDirection: TextDirection.ltr,
          ),
        ));
      }
    }

    return semanticsBuilder;
  }

  void _drawDefaultUI(Canvas canvas, bool isLargerScheduleUI, Offset offset) {
    _rectPainter = _rectPainter ?? Paint();
    _rectPainter.isAntiAlias = true;
    double yPosition = offset.dy + 5;
    double xPosition = offset.dx + 5;
    const double padding = 5;

    if (selectedDate == null || appointments == null || appointments.isEmpty) {
      _drawDefaultView(canvas, size, xPosition, yPosition, padding);
      return;
    }

    final TextStyle appointmentTextStyle = monthViewSettings != null
        ? monthViewSettings.agendaStyle.appointmentTextStyle ??
            TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto')
        : scheduleViewSettings.appointmentTextStyle ??
            TextStyle(
                color: isLargerScheduleUI &&
                        calendarTheme.brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white,
                fontSize: 13,
                fontFamily: 'Roboto');

    //// Draw Appointments
    for (int i = 0; i < appointmentCollection.length; i++) {
      final _AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.appointment == null) {
        continue;
      }

      final Appointment appointment = appointmentView.appointment;
      _rectPainter.color = appointment.color;
      final bool isSpanned =
          appointment._actualEndTime.day != appointment._actualStartTime.day ||
              appointment._isSpanned;
      final double appointmentHeight = appointmentView.appointmentRect.height;
      final RRect rect = appointmentView.appointmentRect.shift(offset);
      xPosition = rect.left;
      yPosition = rect.top;

      /// Web view does not highlighted by background
      if (!isLargerScheduleUI) {
        canvas.drawRRect(rect, _rectPainter);
      }

      final TextSpan span =
          TextSpan(text: appointment.subject, style: appointmentTextStyle);
      _updateTextPainterProperties(span);
      double timeWidth =
          isLargerScheduleUI ? (size.width - (2 * padding)) * 0.3 : 0;
      timeWidth = timeWidth > 200 ? 200 : timeWidth;
      xPosition += timeWidth;

      final bool isRecurrenceAppointment = appointment.recurrenceRule != null &&
          appointment.recurrenceRule.isNotEmpty;
      final double textSize =
          _getTextSize(rect, appointmentTextStyle, isMobilePlatform);

      double topPadding = 0;

      /// Draw web schedule view.
      if (isLargerScheduleUI) {
        topPadding = _addScheduleViewForWeb(
            canvas,
            size,
            padding,
            xPosition,
            yPosition,
            timeWidth,
            appointmentHeight,
            isSpanned || isRecurrenceAppointment,
            textSize,
            appointment,
            appointmentTextStyle,
            offset);
        if (isSpanned) {
          final TextSpan icon = _getSpanIcon(
              appointmentTextStyle.color,
              isMobilePlatform ? textSize : textSize / 1.5,
              isRTL ? false : true);
          _drawIcon(canvas, size, textSize, rect, padding, isLargerScheduleUI,
              rect.tlRadius, icon, appointmentHeight, topPadding, true, false);
        }
      } else {
        /// Draws spanning appointment UI for schedule view.
        if (isSpanned) {
          _drawSpanningAppointmentForScheduleView(
              canvas,
              size,
              xPosition,
              yPosition,
              padding,
              appointment,
              appointmentTextStyle,
              appointmentHeight,
              rect,
              isMobilePlatform,
              isLargerScheduleUI,
              rect.tlRadius);
        }
        //// Draw Appointments except All day appointment
        else if (!appointment.isAllDay) {
          topPadding = _drawNormalAppointmentUI(
              canvas,
              size,
              xPosition,
              yPosition,
              padding,
              timeWidth,
              isRecurrenceAppointment,
              textSize,
              appointment,
              appointmentHeight,
              appointmentTextStyle);
        } else {
          //// Draw All day appointment
          _updatePainterLinesCount(appointmentHeight,
              isAllDay: true, isSpanned: false);
          final double iconSize = isRecurrenceAppointment ? textSize + 10 : 0;
          _textPainter.layout(
              minWidth: 0, maxWidth: size.width - 10 - padding - iconSize);
          if (isRTL) {
            xPosition = size.width - _textPainter.width - (padding * 3);
          }

          topPadding = (appointmentHeight - _textPainter.height) / 2;
          _textPainter.paint(
              canvas, Offset(xPosition + 5, yPosition + topPadding));
        }
      }

      if (isRecurrenceAppointment) {
        final TextSpan icon =
            _getRecurrenceIcon(appointmentTextStyle.color, textSize);
        _drawIcon(
            canvas,
            size,
            textSize,
            rect,
            padding,
            isLargerScheduleUI,
            rect.tlRadius,
            icon,
            appointmentHeight,
            topPadding,
            false,
            appointment.isAllDay);
      }

      if (agendaViewNotifier.value != null &&
          isSameDate(agendaViewNotifier.value.hoveringDate, selectedDate)) {
        _addMouseHovering(canvas, size, rect, isLargerScheduleUI, padding);
      }
    }
  }

  double _getTextSize(
      RRect rect, TextStyle appointmentTextStyle, bool isMobilePlatform) {
    // The default font size if none is specified.
    // The value taken from framework, for text style when there is no font
    // size given they have used 14 as the default font size.
    const double defaultFontSize = 14;
    final double textSize = isMobilePlatform
        ? appointmentTextStyle.fontSize ?? defaultFontSize
        : appointmentTextStyle.fontSize != null
            ? appointmentTextStyle.fontSize * 1.5
            : defaultFontSize * 1.5;
    if (rect.width < textSize || rect.height < textSize) {
      return rect.width > rect.height ? rect.height : rect.width;
    }

    return textSize;
  }

  void _drawIcon(
      Canvas canvas,
      Size size,
      double textSize,
      RRect rect,
      double padding,
      bool isLargerScheduleUI,
      Radius cornerRadius,
      TextSpan icon,
      double appointmentHeight,
      double yPosition,
      bool isSpan,
      bool isAllDay) {
    _textPainter.text = icon;
    _textPainter.textScaleFactor = textScaleFactor;
    _textPainter.layout(
        minWidth: 0, maxWidth: size.width - (2 * padding) - padding);
    final double iconSize = textSize + 8;
    if (!isLargerScheduleUI) {
      if (isRTL) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(
                    rect.left, rect.top, rect.left + iconSize, rect.bottom),
                cornerRadius),
            _rectPainter);
      } else {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(
                    rect.right - iconSize, rect.top, rect.right, rect.bottom),
                cornerRadius),
            _rectPainter);
      }
    }

    double iconStartPosition = 0;
    if (isSpan) {
      /// There is a space around the font, hence to get the start position we
      /// must calculate the icon start position, apart from the space, and the
      /// value 2 used since the space on top and bottom of icon is not even,
      /// hence to rectify this tha value 2 used, and tested with multiple
      /// device.
      iconStartPosition =
          (_textPainter.height - (icon.style.fontSize * textScaleFactor) / 2) /
              2;
    }

    // Value 8 added as a right side padding for the recurrence icon in the
    // agenda view
    if (isRTL) {
      _textPainter.paint(
          canvas, Offset(8, rect.top + yPosition - iconStartPosition));
    } else {
      _textPainter.paint(
          canvas,
          Offset(rect.right - _textPainter.width - 8,
              rect.top + yPosition - iconStartPosition));
    }
  }

  double _updatePainterLinesCount(double appointmentHeight,
      {bool isSpanned = false, bool isAllDay = false}) {
    final double lineHeight = _textPainter.preferredLineHeight;

    /// Top and bottom padding 5
    const double verticalPadding = 10;
    final int maxLines =
        ((appointmentHeight - verticalPadding) / lineHeight).floor();
    if (maxLines > 1) {
      _textPainter.maxLines = isSpanned || isAllDay ? maxLines : maxLines - 1;
    }

    _textPainter.ellipsis = '..';
    return lineHeight;
  }

  double _drawNormalAppointmentUI(
      Canvas canvas,
      Size size,
      double xPosition,
      double yPosition,
      double padding,
      double timeWidth,
      bool isRecurrence,
      double recurrenceTextSize,
      Appointment appointment,
      double appointmentHeight,
      TextStyle appointmentTextStyle) {
    _textPainter.textScaleFactor = textScaleFactor;
    final double lineHeight = _updatePainterLinesCount(appointmentHeight,
        isAllDay: false, isSpanned: false);
    final double iconSize = isRecurrence ? recurrenceTextSize + 10 : 0;
    _textPainter.layout(
        minWidth: 0,
        maxWidth: size.width - (2 * padding) - xPosition - iconSize);
    final double subjectHeight = _textPainter.height;
    final double topPadding =
        (appointmentHeight - (subjectHeight + lineHeight)) / 2;
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (3 * padding) - timeWidth;
    }

    _textPainter.paint(
        canvas, Offset(xPosition + padding, yPosition + topPadding));

    final String format = appointmentTimeTextFormat ??
        (isSameDate(appointment._actualStartTime, appointment._actualEndTime)
            ? 'hh:mm a'
            : 'MMM dd, hh:mm a');
    final TextSpan span = TextSpan(
        text: DateFormat(format, locale).format(appointment._actualStartTime) +
            ' - ' +
            DateFormat(format, locale).format(appointment._actualEndTime),
        style: appointmentTextStyle);
    _textPainter.text = span;

    _textPainter.maxLines = 1;
    _textPainter.layout(
        minWidth: 0, maxWidth: size.width - (2 * padding) - padding - iconSize);
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (3 * padding);
    }
    _textPainter.paint(canvas,
        Offset(xPosition + padding, yPosition + topPadding + subjectHeight));

    return topPadding;
  }

  double _drawSpanningAppointmentForScheduleView(
      Canvas canvas,
      Size size,
      double xPosition,
      double yPosition,
      double padding,
      Appointment appointment,
      TextStyle appointmentTextStyle,
      double appointmentHeight,
      RRect rect,
      bool isMobilePlatform,
      bool isLargerScheduleUI,
      Radius cornerRadius) {
    final TextSpan span = TextSpan(
        text: _getSpanAppointmentText(appointment, selectedDate),
        style: appointmentTextStyle);

    _updateTextPainterProperties(span);
    _updatePainterLinesCount(appointmentHeight,
        isAllDay: false, isSpanned: true);
    final bool isNeedSpanIcon =
        !isSameDate(appointment._exactEndTime, selectedDate);
    final double textSize =
        _getTextSize(rect, appointmentTextStyle, isMobilePlatform);

    /// Icon padding 8 and 2 additional padding
    final double iconSize = isNeedSpanIcon ? textSize + 10 : 0;
    double maxTextWidth = size.width - 10 - padding - iconSize;
    maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
    _textPainter.layout(minWidth: 0, maxWidth: maxTextWidth);
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (padding * 3);
    }

    final double topPadding = (appointmentHeight - _textPainter.height) / 2;
    _textPainter.paint(
        canvas, Offset(xPosition + padding, yPosition + topPadding));

    if (!isNeedSpanIcon) {
      return topPadding;
    }

    final TextSpan icon = _getSpanIcon(appointmentTextStyle.color,
        isMobilePlatform ? textSize : textSize / 1.5, isRTL ? false : true);
    _drawIcon(canvas, size, textSize, rect, padding, isLargerScheduleUI,
        cornerRadius, icon, appointmentHeight, topPadding, true, false);
    return topPadding;
  }

  void _drawDefaultView(Canvas canvas, Size size, double xPosition,
      double yPosition, double padding) {
    final TextSpan span = TextSpan(
      text: selectedDate == null
          ? localizations.noSelectedDateCalendarLabel
          : localizations.noEventsCalendarLabel,
      style: const TextStyle(
          color: Colors.grey, fontSize: 15, fontFamily: 'Roboto'),
    );

    _updateTextPainterProperties(span);
    _textPainter.layout(minWidth: 0, maxWidth: size.width - 10);
    if (isRTL) {
      xPosition = size.width - _textPainter.width;
    }
    _textPainter.paint(canvas, Offset(xPosition, yPosition + padding));
  }

  void _updateTextPainterProperties(TextSpan span) {
    _textPainter ??= TextPainter();
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaleFactor = textScaleFactor;
  }

  double _addScheduleViewForWeb(
      Canvas canvas,
      Size size,
      double padding,
      double xPosition,
      double yPosition,
      double timeWidth,
      double appointmentHeight,
      bool isNeedIcon,
      double textSize,
      Appointment appointment,
      TextStyle appointmentTextStyle,
      Offset offset) {
    _textPainter.textScaleFactor = textScaleFactor;
    final double centerYPosition = appointmentHeight / 2;
    final double circleRadius =
        centerYPosition > padding ? padding : centerYPosition - 2;
    final double circleStartPosition = offset.dx + (3 * circleRadius);
    canvas.drawCircle(
        Offset(isRTL ? size.width - circleStartPosition : circleStartPosition,
            yPosition + centerYPosition),
        circleRadius,
        _rectPainter);
    final double circleWidth = 5 * circleRadius;
    xPosition += circleWidth;

    _updatePainterLinesCount(appointmentHeight,
        isAllDay: true, isSpanned: true);

    /// Icon padding 8 and 2 additional padding
    final double iconSize = isNeedIcon ? textSize + 10 : 0;

    _textPainter.layout(
        minWidth: 0,
        maxWidth: size.width - (2 * padding) - xPosition - iconSize);

    if (isRTL) {
      xPosition = size.width -
          _textPainter.width -
          (3 * padding) -
          timeWidth -
          circleWidth;
    }

    final double topPadding = ((appointmentHeight - _textPainter.height) / 2);
    _textPainter.paint(
        canvas, Offset(xPosition + padding, yPosition + topPadding));
    final DateFormat format =
        DateFormat(appointmentTimeTextFormat ?? 'hh:mm a', locale);
    final TextSpan span = TextSpan(
        text: appointment.isAllDay || appointment._isSpanned
            ? 'All Day'
            : format.format(appointment._actualStartTime) +
                ' - ' +
                format.format(appointment._actualEndTime),
        style: appointmentTextStyle);
    _textPainter.text = span;

    _textPainter.layout(minWidth: 0, maxWidth: timeWidth - padding);
    xPosition = offset.dx + padding + circleWidth;
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (3 * padding) - circleWidth;
    }

    _textPainter.paint(
        canvas,
        Offset(xPosition + padding,
            yPosition + ((appointmentHeight - _textPainter.height) / 2)));
    return topPadding;
  }

  void _addMouseHovering(Canvas canvas, Size size, RRect rect,
      bool isLargerScheduleUI, double padding) {
    _rectPainter ??= Paint();
    if (rect.left < agendaViewNotifier.value.hoveringOffset.dx &&
        rect.right > agendaViewNotifier.value.hoveringOffset.dx &&
        rect.top < agendaViewNotifier.value.hoveringOffset.dy &&
        rect.bottom > agendaViewNotifier.value.hoveringOffset.dy) {
      if (isLargerScheduleUI) {
        _rectPainter.color = Colors.grey.withOpacity(0.1);
        const double viewPadding = 2;
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(
                    rect.left - padding,
                    rect.top + viewPadding,
                    size.width - (isRTL ? viewPadding : padding),
                    rect.height - (2 * viewPadding)),
                Radius.circular(4)),
            _rectPainter);
      } else {
        _rectPainter.color =
            calendarTheme.selectionBorderColor.withOpacity(0.4);
        _rectPainter.style = PaintingStyle.stroke;
        _rectPainter.strokeWidth = 2;
        canvas.drawRect(rect.outerRect, _rectPainter);
        _rectPainter.style = PaintingStyle.fill;
      }
    }
  }
}

class _AgendaDateTimePainter extends CustomPainter {
  _AgendaDateTimePainter(
      this.selectedDate,
      this.monthViewSettings,
      this.scheduleViewSettings,
      this.todayHighlightColor,
      this.todayTextStyle,
      this.locale,
      this.calendarTheme,
      this.agendaDateNotifier,
      this.viewWidth,
      this.isRTL,
      this.textScaleFactor,
      this.isMobilePlatform)
      : super(repaint: agendaDateNotifier);

  final DateTime selectedDate;
  final MonthViewSettings monthViewSettings;
  final ScheduleViewSettings scheduleViewSettings;
  final Color todayHighlightColor;
  final TextStyle todayTextStyle;
  final String locale;
  final ValueNotifier<_ScheduleViewHoveringDetails> agendaDateNotifier;
  final SfCalendarThemeData calendarTheme;
  final double viewWidth;
  final bool isRTL;
  final double textScaleFactor;
  final bool isMobilePlatform;
  Paint _linePainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _linePainter = _linePainter ?? Paint();
    _linePainter.isAntiAlias = true;
    const double padding = 5;
    if (selectedDate == null) {
      return;
    }

    final bool useMobilePlatformUI =
        _isMobileLayoutUI(viewWidth, isMobilePlatform);
    final bool isToday = isSameDate(selectedDate, DateTime.now());
    TextStyle dateTextStyle, dayTextStyle;
    if (monthViewSettings != null) {
      dayTextStyle = monthViewSettings.agendaStyle.dayTextStyle ??
          calendarTheme.agendaDayTextStyle;
      dateTextStyle = monthViewSettings.agendaStyle.dateTextStyle ??
          calendarTheme.agendaDateTextStyle;
    } else {
      dayTextStyle = scheduleViewSettings.dayHeaderSettings.dayTextStyle ??
          (useMobilePlatformUI
              ? calendarTheme.agendaDayTextStyle
              : TextStyle(
                  color: calendarTheme.agendaDayTextStyle.color,
                  fontSize: 9,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500));
      dateTextStyle = scheduleViewSettings.dayHeaderSettings.dateTextStyle ??
          (useMobilePlatformUI
              ? calendarTheme.agendaDateTextStyle
              : TextStyle(
                  color: calendarTheme.agendaDateTextStyle.color,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal));
    }

    final Color selectedDayTextColor = isToday
        ? todayHighlightColor ?? calendarTheme.todayHighlightColor
        : dayTextStyle != null
            ? dayTextStyle.color
            : calendarTheme.agendaDayTextStyle.color;
    final Color selectedDateTextColor = isToday
        ? calendarTheme.todayTextStyle.color
        : dateTextStyle != null
            ? dateTextStyle.color
            : calendarTheme.agendaDateTextStyle.color;
    dayTextStyle = dayTextStyle.copyWith(color: selectedDayTextColor);
    dateTextStyle = dateTextStyle.copyWith(color: selectedDateTextColor);
    if (isToday) {
      dayTextStyle = todayTextStyle != null
          ? todayTextStyle.copyWith(
              fontSize: dayTextStyle.fontSize, color: selectedDayTextColor)
          : dayTextStyle;
      dateTextStyle = todayTextStyle != null
          ? todayTextStyle.copyWith(
              fontSize: dateTextStyle.fontSize, color: selectedDateTextColor)
          : dateTextStyle;
    }

    /// Draw day label other than web schedule view.
    if (scheduleViewSettings == null || useMobilePlatformUI) {
      _addDayLabelForMobile(canvas, size, padding, dayTextStyle, dateTextStyle,
          isToday, isMobilePlatform);
    } else {
      _addDayLabelForWeb(
          canvas, size, padding, dayTextStyle, dateTextStyle, isToday);
    }
  }

  void _updateTextPainter(TextSpan span) {
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.parent;
    _textPainter.textScaleFactor = textScaleFactor;
  }

  void _addDayLabelForMobile(
      Canvas canvas,
      Size size,
      double padding,
      TextStyle dayTextStyle,
      TextStyle dateTextStyle,
      bool isToday,
      bool isMobile) {
    //// Draw Weekday
    final String dayTextFormat = scheduleViewSettings != null
        ? scheduleViewSettings.dayHeaderSettings.dayFormat
        : 'EEE';
    TextSpan span = TextSpan(
        text: DateFormat(dayTextFormat, locale)
            .format(selectedDate)
            .toUpperCase()
            .toString(),
        style: dayTextStyle);
    _updateTextPainter(span);

    _textPainter.layout(minWidth: 0, maxWidth: size.width);
    _textPainter.paint(
        canvas,
        Offset(
            padding + ((size.width - (2 * padding) - _textPainter.width) / 2),
            padding));

    final double weekDayHeight = padding + _textPainter.height;
    //// Draw Date
    span = TextSpan(text: selectedDate.day.toString(), style: dateTextStyle);
    _updateTextPainter(span);

    _textPainter.layout(minWidth: 0, maxWidth: size.width);

    /// The padding value provides the space between the date and day text.
    const int inBetweenPadding = 2;
    final double xPosition =
        padding + ((size.width - (2 * padding) - _textPainter.width) / 2);
    double yPosition = weekDayHeight;
    if (isToday) {
      yPosition = weekDayHeight + padding + inBetweenPadding;
      _linePainter.color = todayHighlightColor;
      _drawTodayCircle(canvas, xPosition, yPosition, padding);
    }

    /// padding added between date and day labels in web, to avoid the
    /// hovering effect overlapping issue.
    if (!isMobile && !isToday) {
      yPosition = weekDayHeight + padding + inBetweenPadding;
    }
    if (agendaDateNotifier.value != null &&
        isSameDate(agendaDateNotifier.value.hoveringDate, selectedDate)) {
      if (xPosition < agendaDateNotifier.value.hoveringOffset.dx &&
          xPosition + _textPainter.width >
              agendaDateNotifier.value.hoveringOffset.dx &&
          yPosition < agendaDateNotifier.value.hoveringOffset.dy &&
          yPosition + _textPainter.height >
              agendaDateNotifier.value.hoveringOffset.dy) {
        _linePainter.color = isToday
            ? Colors.black.withOpacity(0.1)
            : (calendarTheme.brightness != null &&
                        calendarTheme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87)
                .withOpacity(0.04);
        _drawTodayCircle(canvas, xPosition, yPosition, padding);
      }
    }

    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  void _addDayLabelForWeb(Canvas canvas, Size size, double padding,
      TextStyle dayTextStyle, TextStyle dateTextStyle, bool isToday) {
    /// Draw day label on web schedule view.
    final String dateText = selectedDate.day.toString();

    /// Calculate the date text maximum width value.
    final String maxWidthDateText = '30';
    final String dayText = DateFormat(
            isRTL
                ? scheduleViewSettings.dayHeaderSettings.dayFormat + ', MMM'
                : 'MMM, ' + scheduleViewSettings.dayHeaderSettings.dayFormat,
            locale)
        .format(selectedDate)
        .toUpperCase()
        .toString();

    //// Draw Weekday
    TextSpan span = TextSpan(text: maxWidthDateText, style: dateTextStyle);
    _updateTextPainter(span);
    _textPainter.layout(minWidth: 0, maxWidth: size.width);

    /// Calculate the start padding value for web schedule view date time label.
    double startXPosition = size.width / 5;
    startXPosition = isRTL ? size.width - startXPosition : startXPosition;
    final double dateHeight = size.height;
    final double yPosition = (dateHeight - _textPainter.height) / 2;
    final double painterWidth = _textPainter.width;
    span = TextSpan(text: dateText, style: dateTextStyle);
    _textPainter.text = span;
    _textPainter.layout(minWidth: 0, maxWidth: size.width);
    double dateTextPadding = (painterWidth - _textPainter.width) / 2;
    if (dateTextPadding < 0) {
      dateTextPadding = 0;
    }

    final double dateTextStartPosition = startXPosition + dateTextPadding;
    if (isToday) {
      _linePainter.color = todayHighlightColor;
      _drawTodayCircle(canvas, dateTextStartPosition, yPosition, padding);
    }

    if (agendaDateNotifier.value != null &&
        isSameDate(agendaDateNotifier.value.hoveringDate, selectedDate)) {
      if (dateTextStartPosition <
              (isRTL
                  ? size.width - agendaDateNotifier.value.hoveringOffset.dx
                  : agendaDateNotifier.value.hoveringOffset.dx) &&
          (dateTextStartPosition + _textPainter.width) >
              (isRTL
                  ? size.width - agendaDateNotifier.value.hoveringOffset.dx
                  : agendaDateNotifier.value.hoveringOffset.dx) &&
          yPosition < agendaDateNotifier.value.hoveringOffset.dy &&
          (yPosition + _textPainter.height) >
              agendaDateNotifier.value.hoveringOffset.dy) {
        _linePainter.color = isToday
            ? Colors.black.withOpacity(0.1)
            : (calendarTheme.brightness != null &&
                        calendarTheme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87)
                .withOpacity(0.04);
        _drawTodayCircle(canvas, dateTextStartPosition, yPosition, padding);
      }
    }

    _textPainter.paint(canvas, Offset(dateTextStartPosition, yPosition));

    //// Draw Date
    span = TextSpan(text: dayText, style: dayTextStyle);
    _textPainter.text = span;
    if (isRTL) {
      _textPainter.layout(minWidth: 0, maxWidth: startXPosition);
      startXPosition -= _textPainter.width + (3 * padding);
      if (startXPosition > 0) {
        _textPainter.paint(canvas,
            Offset(startXPosition, (dateHeight - _textPainter.height) / 2));
      }
    } else {
      startXPosition += painterWidth + (3 * padding);
      if (startXPosition > size.width) {
        return;
      }
      _textPainter.layout(minWidth: 0, maxWidth: size.width - startXPosition);
      _textPainter.paint(canvas,
          Offset(startXPosition, (dateHeight - _textPainter.height) / 2));
    }
  }

  void _drawTodayCircle(
      Canvas canvas, double xPosition, double yPosition, double padding) {
    canvas.drawCircle(
        Offset(xPosition + (_textPainter.width / 2),
            yPosition + (_textPainter.height / 2)),
        _textPainter.width > _textPainter.height
            ? (_textPainter.width / 2) + padding
            : (_textPainter.height / 2) + padding,
        _linePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return true;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    if (selectedDate == null) {
      return semanticsBuilder;
    } else if (selectedDate != null) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: SemanticsProperties(
          label: DateFormat('EEEEE').format(selectedDate).toString() +
              DateFormat('dd/MMMM/yyyy').format(selectedDate).toString(),
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    return semanticsBuilder;
  }
}
