import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../calendar.dart';
import '../appointment_engine/appointment_helper.dart';
import '../common/calendar_view_helper.dart';

/// Used to holds the agenda appointment views in calendar widgets.
class AgendaViewLayout extends StatefulWidget {
  /// Constructor to create the agenda appointment layout that holds the agenda
  /// appointment views in calendar widget.
  const AgendaViewLayout(
      this.monthViewSettings,
      this.scheduleViewSettings,
      this.selectedDate,
      this.appointments,
      this.isRTL,
      this.locale,
      this.localizations,
      this.calendarTheme,
      this.themeData,
      this.agendaViewNotifier,
      this.appointmentTimeTextFormat,
      this.timeLabelWidth,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.appointmentBuilder,
      this.width,
      this.height,
      this.placeholderTextStyle,
      this.calendar);

  /// Defines the month view customization details.
  final MonthViewSettings? monthViewSettings;

  /// Defines the schedule view customization details.
  final ScheduleViewSettings? scheduleViewSettings;

  /// Holds the current selected date value of calendar.
  final DateTime? selectedDate;

  /// Holds the selected date appointment collection.
  final List<CalendarAppointment>? appointments;

  /// Defines the direction of the calendar widget is RTL or not.
  final bool isRTL;

  /// Defines the locale of the calendar widget
  final String locale;

  /// Holds the theme data of the calendar widget.
  final SfCalendarThemeData calendarTheme;

  /// Holds the framework theme data details.
  final ThemeData themeData;

  /// Holds the hovering details of the agenda view widget.
  final ValueNotifier<ScheduleViewHoveringDetails?> agendaViewNotifier;

  /// Holds the localization data of the calendar widget.
  final SfLocalizations localizations;

  /// Defines the width of time label widget in calendar.
  final double timeLabelWidth;

  /// Defines the appointment time text format on appointment view.
  final String? appointmentTimeTextFormat;

  /// Used to build the widget that replaces the appointment view in agenda
  /// appointment widget.
  final CalendarAppointmentBuilder? appointmentBuilder;

  /// Defines the scale factor of the calendar widget.
  final double textScaleFactor;

  /// Defines the current platform is mobile platform or not.
  final bool isMobilePlatform;

  /// Defines the width of the agenda appointment layout widget.
  final double width;

  /// Defines the height of the agenda appointment layout widget.
  final double height;

  /// Defines the calendar widget.
  final SfCalendar calendar;

  /// Defines the text style of the no events and no selected date.
  final TextStyle placeholderTextStyle;

  @override
  // ignore: library_private_types_in_public_api
  _AgendaViewLayoutState createState() => _AgendaViewLayoutState();
}

class _AgendaViewLayoutState extends State<AgendaViewLayout> {
  /// It holds the appointment views for the visible appointments.
  final List<AppointmentView> _appointmentCollection = <AppointmentView>[];

  /// It holds the children of the widget, it holds empty when
  /// appointment builder is null.
  final List<Widget> _children = <Widget>[];

  @override
  void initState() {
    _updateAppointmentDetails();
    super.initState();
  }

  @override
  void didUpdateWidget(AgendaViewLayout oldWidget) {
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
    /// Create the widgets when appointment builder is not null.
    if (_children.isEmpty && widget.appointmentBuilder != null) {
      final int appointmentCount = _appointmentCollection.length;
      for (int i = 0; i < appointmentCount; i++) {
        final AppointmentView view = _appointmentCollection[i];

        /// Check the appointment view have appointment, if not then the
        /// appointment view is not valid or it will be used for reusing view.
        if (view.appointment == null || view.appointmentRect == null) {
          continue;
        }
        final CalendarAppointmentDetails details = CalendarAppointmentDetails(
            widget.selectedDate!,
            List<dynamic>.unmodifiable(<dynamic>[
              CalendarViewHelper.getAppointmentDetail(
                  view.appointment!, widget.calendar.dataSource)
            ]),
            view.appointmentRect!.outerRect);
        final Widget child = widget.appointmentBuilder!(context, details);
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
        widget.themeData,
        widget.agendaViewNotifier,
        widget.appointmentTimeTextFormat,
        widget.timeLabelWidth,
        widget.textScaleFactor,
        widget.isMobilePlatform,
        _appointmentCollection,
        widget.width,
        widget.height,
        widget.placeholderTextStyle,
        widgets: _children);
  }

  void _updateAppointmentDetails() {
    double yPosition = 5;
    const double padding = 5;

    final double totalAgendaViewWidth = widget.width + widget.timeLabelWidth;
    final bool useMobilePlatformUI = CalendarViewHelper.isMobileLayoutUI(
        totalAgendaViewWidth, widget.isMobilePlatform);
    AppointmentHelper.resetAppointmentView(_appointmentCollection);
    _children.clear();
    if (widget.selectedDate == null ||
        widget.appointments == null ||
        widget.appointments!.isEmpty) {
      return;
    }

    final bool isLargerScheduleUI =
        widget.scheduleViewSettings != null && !useMobilePlatformUI;

    widget.appointments!.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            app1.actualStartTime.compareTo(app2.actualStartTime));
    widget.appointments!.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            AppointmentHelper.orderAppointmentsAscending(
                app1.isAllDay, app2.isAllDay));
    widget.appointments!.sort(
        (CalendarAppointment app1, CalendarAppointment app2) =>
            AppointmentHelper.orderAppointmentsAscending(
                app1.isSpanned, app2.isSpanned));
    final double agendaItemHeight =
        CalendarViewHelper.getScheduleAppointmentHeight(
            widget.monthViewSettings, widget.scheduleViewSettings);
    final double agendaAllDayItemHeight =
        CalendarViewHelper.getScheduleAllDayAppointmentHeight(
            widget.monthViewSettings, widget.scheduleViewSettings);

    for (int i = 0; i < widget.appointments!.length; i++) {
      final CalendarAppointment appointment = widget.appointments![i];
      final bool isSpanned =
          appointment.actualEndTime.day != appointment.actualStartTime.day ||
              appointment.isSpanned;
      final double appointmentHeight =
          (appointment.isAllDay || isSpanned) && !isLargerScheduleUI
              ? agendaAllDayItemHeight
              : agendaItemHeight;
      final Rect rect = Rect.fromLTWH(
          padding, yPosition, widget.width - (2 * padding), appointmentHeight);
      final Radius cornerRadius = Radius.circular(
          (appointmentHeight * 0.1) > 5 ? 5 : (appointmentHeight * 0.1));
      yPosition += appointmentHeight + padding;
      AppointmentView? appointmentRenderer;
      for (int i = 0; i < _appointmentCollection.length; i++) {
        final AppointmentView view = _appointmentCollection[i];
        if (view.appointment == null) {
          appointmentRenderer = view;
          break;
        }
      }

      if (appointmentRenderer == null) {
        appointmentRenderer = AppointmentView();
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
  const _AgendaViewRenderWidget(
      this.monthViewSettings,
      this.scheduleViewSettings,
      this.selectedDate,
      this.appointments,
      this.isRTL,
      this.locale,
      this.localizations,
      this.calendarTheme,
      this.themeData,
      this.agendaViewNotifier,
      this.appointmentTimeTextFormat,
      this.timeLabelWidth,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.appointmentCollection,
      this.width,
      this.height,
      this.placeholderTextStyle,
      {List<Widget> widgets = const <Widget>[]})
      : super(children: widgets);

  final MonthViewSettings? monthViewSettings;
  final ScheduleViewSettings? scheduleViewSettings;
  final DateTime? selectedDate;
  final List<CalendarAppointment>? appointments;
  final bool isRTL;
  final String locale;
  final SfCalendarThemeData calendarTheme;
  final ThemeData themeData;
  final ValueNotifier<ScheduleViewHoveringDetails?> agendaViewNotifier;
  final SfLocalizations localizations;
  final double timeLabelWidth;
  final String? appointmentTimeTextFormat;
  final double textScaleFactor;
  final bool isMobilePlatform;
  final List<AppointmentView> appointmentCollection;
  final double width;
  final double height;
  final TextStyle placeholderTextStyle;

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
      themeData,
      agendaViewNotifier,
      appointmentTimeTextFormat,
      timeLabelWidth,
      textScaleFactor,
      isMobilePlatform,
      appointmentCollection,
      width,
      height,
      placeholderTextStyle,
    );
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
      ..themeData = themeData
      ..agendaViewNotifier = agendaViewNotifier
      ..appointmentTimeTextFormat = appointmentTimeTextFormat
      ..timeLabelWidth = timeLabelWidth
      ..textScaleFactor = textScaleFactor
      ..appointmentCollection = appointmentCollection
      ..width = width
      ..height = height
      ..placeholderTextStyle = placeholderTextStyle;
  }
}

class _AgendaViewRenderObject extends CustomCalendarRenderObject {
  _AgendaViewRenderObject(
      this._monthViewSettings,
      this._scheduleViewSettings,
      this._selectedDate,
      this._appointments,
      this._isRTL,
      this._locale,
      this._localizations,
      this._calendarTheme,
      this._themeData,
      this._agendaViewNotifier,
      this._appointmentTimeTextFormat,
      this._timeLabelWidth,
      this._textScaleFactor,
      this.isMobilePlatform,
      this._appointmentCollection,
      this._width,
      this._height,
      this._placeholderTextStyle);

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

  TextStyle _placeholderTextStyle;

  TextStyle get placeholderTextStyle => _placeholderTextStyle;

  set placeholderTextStyle(TextStyle value) {
    if (_placeholderTextStyle == value) {
      return;
    }

    _placeholderTextStyle = value;
    markNeedsPaint();
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

  MonthViewSettings? _monthViewSettings;

  MonthViewSettings? get monthViewSettings => _monthViewSettings;

  set monthViewSettings(MonthViewSettings? value) {
    if (_monthViewSettings == value) {
      return;
    }

    _monthViewSettings = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  ScheduleViewSettings? _scheduleViewSettings;

  ScheduleViewSettings? get scheduleViewSettings => _scheduleViewSettings;

  set scheduleViewSettings(ScheduleViewSettings? value) {
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

  String? _appointmentTimeTextFormat;

  String? get appointmentTimeTextFormat => _appointmentTimeTextFormat;

  set appointmentTimeTextFormat(String? value) {
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

  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? value) {
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

  List<CalendarAppointment>? _appointments;

  List<CalendarAppointment>? get appointments => _appointments;

  set appointments(List<CalendarAppointment>? value) {
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

  List<AppointmentView> _appointmentCollection;

  List<AppointmentView> get appointmentCollection => _appointmentCollection;

  set appointmentCollection(List<AppointmentView> value) {
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

  ThemeData _themeData;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData value) {
    if (_themeData == value) {
      return;
    }

    _themeData = value;
  }

  ValueNotifier<ScheduleViewHoveringDetails?> _agendaViewNotifier;

  ValueNotifier<ScheduleViewHoveringDetails?> get agendaViewNotifier =>
      _agendaViewNotifier;

  set agendaViewNotifier(ValueNotifier<ScheduleViewHoveringDetails?> value) {
    if (_agendaViewNotifier == value) {
      return;
    }

    _agendaViewNotifier.removeListener(markNeedsPaint);
    _agendaViewNotifier = value;
    _agendaViewNotifier.addListener(markNeedsPaint);
  }

  /// Caches [SemanticsNode]s created during [assembleSemanticsNode] so they
  /// can be re-used when [assembleSemanticsNode] is called again. This ensures
  /// stable ids for the [SemanticsNode]s of children across
  /// [assembleSemanticsNode] invocations.
  /// Ref: assembleSemanticsNode method in RenderParagraph class
  /// (https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/rendering/paragraph.dart)
  List<SemanticsNode>? _cacheNodes;
  final Paint _rectPainter = Paint();
  final TextPainter _textPainter = TextPainter();

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _agendaViewNotifier.addListener(markNeedsPaint);
  }

  /// detach will called when the render object removed from view.
  @override
  void detach() {
    _agendaViewNotifier.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = firstChild;
    if (child == null) {
      return false;
    }

    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.appointment == null ||
          child == null ||
          appointmentView.appointmentRect == null) {
        continue;
      }

      final Offset offset = Offset(appointmentView.appointmentRect!.left,
          appointmentView.appointmentRect!.top);
      final bool isHit = result.addWithPaintOffset(
        offset: offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset? transformed) {
          assert(transformed == position - offset);
          return child!.hitTest(result, position: transformed!);
        },
      );
      if (isHit) {
        return true;
      }
      child = childAfter(child);
    }

    return false;
  }

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? height : widgetSize.height);
    RenderBox? child = firstChild;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.appointment == null ||
          child == null ||
          appointmentView.appointmentRect == null) {
        continue;
      }

      child.layout(constraints.copyWith(
          minHeight: appointmentView.appointmentRect!.height,
          maxHeight: appointmentView.appointmentRect!.height,
          minWidth: appointmentView.appointmentRect!.width,
          maxWidth: appointmentView.appointmentRect!.width));
      final CalendarParentData childParentData =
          child.parentData! as CalendarParentData;
      childParentData.offset = Offset(appointmentView.appointmentRect!.left,
          appointmentView.appointmentRect!.top);
      child = childAfter(child);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    final bool isNeedDefaultPaint = childCount == 0;
    final double totalAgendaViewWidth = size.width + timeLabelWidth;
    final bool useMobilePlatformUI = CalendarViewHelper.isMobileLayoutUI(
        totalAgendaViewWidth, isMobilePlatform);
    final bool isLargerScheduleUI =
        scheduleViewSettings != null && !useMobilePlatformUI;
    if (isNeedDefaultPaint) {
      _drawDefaultUI(context.canvas, isLargerScheduleUI, offset);
    } else {
      const double padding = 5.0;
      for (int i = 0; i < appointmentCollection.length; i++) {
        final AppointmentView appointmentView = appointmentCollection[i];
        if (appointmentView.appointment == null ||
            child == null ||
            appointmentView.appointmentRect == null) {
          continue;
        }

        final RRect rect = appointmentView.appointmentRect!.shift(offset);
        context.paintChild(child, Offset(rect.left, rect.top));
        if (agendaViewNotifier.value != null &&
            isSameDate(agendaViewNotifier.value!.hoveringDate, selectedDate)) {
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
    _cacheNodes ??= <SemanticsNode>[];
    final List<CustomPainterSemantics> semantics = _getSemanticsBuilder(size);
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

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];

    final RenderBox? child = firstChild;
    if (child != null) {
      return semanticsBuilder;
    }

    if (selectedDate == null) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: const SemanticsProperties(
          label: 'No selected date',
          textDirection: TextDirection.ltr,
        ),
      ));
    } else if (selectedDate != null &&
        (appointments == null || appointments!.isEmpty)) {
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: SemanticsProperties(
          label:
              // ignore: lines_longer_than_80_chars
              '${DateFormat('EEEEE').format(selectedDate!)}${DateFormat('dd MMMM yyyy').format(selectedDate!)}, No events',
          textDirection: TextDirection.ltr,
        ),
      ));
    } else if (selectedDate != null) {
      for (int i = 0; i < appointmentCollection.length; i++) {
        final AppointmentView appointmentView = appointmentCollection[i];
        if (appointmentView.appointment == null) {
          continue;
        }
        semanticsBuilder.add(CustomPainterSemantics(
          rect: appointmentView.appointmentRect!.outerRect,
          properties: SemanticsProperties(
            label: CalendarViewHelper.getAppointmentSemanticsText(
                appointmentView.appointment!),
            textDirection: TextDirection.ltr,
          ),
        ));
      }
    }

    return semanticsBuilder;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    RenderBox? child = firstChild;
    if (child == null) {
      return;
    }
    while (child != null) {
      visitor(child);
      child = childAfter(child);
    }
  }

  void _drawDefaultUI(Canvas canvas, bool isLargerScheduleUI, Offset offset) {
    _rectPainter.isAntiAlias = true;
    double yPosition = offset.dy + 5;
    double xPosition = offset.dx + 5;
    const double padding = 5;

    if (selectedDate == null || appointments == null || appointments!.isEmpty) {
      _drawDefaultView(canvas, size, xPosition, yPosition, padding);
      return;
    }

    final TextStyle appointmentTextStyle = monthViewSettings != null
        ? themeData.textTheme.bodyMedium!
            .copyWith(color: Colors.white, fontSize: 13)
            .merge(monthViewSettings!.agendaStyle.appointmentTextStyle)
        : themeData.textTheme.bodyMedium!
            .copyWith(
                color: isLargerScheduleUI &&
                        calendarTheme.brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white,
                fontSize: 13)
            .merge(scheduleViewSettings!.appointmentTextStyle);

    final List<String> appointmentStringFormats =
        appointmentTimeTextFormat == null
            ? <String>[]
            : CalendarViewHelper.getListFromString(appointmentTimeTextFormat!);
    final List<String> sameDateAppointmentStringFormats =
        CalendarViewHelper.getListFromString('hh:mm a');
    final List<String> diffDateAppointmentStringFormats =
        CalendarViewHelper.getListFromString('MMM dd, hh:mm a');

    //// Draw Appointments
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.appointment == null) {
        continue;
      }

      final CalendarAppointment appointment = appointmentView.appointment!;
      _rectPainter.color = appointment.color;
      final bool isSpanned =
          appointment.actualEndTime.day != appointment.actualStartTime.day ||
              appointment.isSpanned;
      final double appointmentHeight = appointmentView.appointmentRect!.height;
      final RRect rect = appointmentView.appointmentRect!.shift(offset);
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
          appointment.recurrenceRule!.isNotEmpty;

      final double textSize =
          _getTextSize(rect, appointmentTextStyle, isMobilePlatform);

      double topPadding = 0;
      double spanIconWidth = 0;

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
            isSpanned,
            isRecurrenceAppointment,
            textSize,
            appointment,
            appointmentTextStyle,
            appointmentStringFormats,
            sameDateAppointmentStringFormats,
            offset);
        if (isSpanned) {
          final TextSpan icon = AppointmentHelper.getSpanIcon(
              appointmentTextStyle.color!,
              isMobilePlatform ? textSize : textSize / 1.5,
              !isRTL);
          spanIconWidth = _drawIcon(
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
              true,
              false,
              spanIconWidth);
        }
      } else {
        /// Draws spanning appointment UI for schedule view.
        if (isSpanned) {
          final List<double> iconPositions =
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
          spanIconWidth = iconPositions[0];
          topPadding = iconPositions[1];
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
              appointmentTextStyle,
              appointmentStringFormats,
              sameDateAppointmentStringFormats,
              diffDateAppointmentStringFormats);
        } else {
          //// Draw All day appointment
          _updatePainterLinesCount(appointmentHeight, isAllDay: true);
          final double iconSize = isRecurrenceAppointment ? textSize + 10 : 0;
          _textPainter.layout(maxWidth: size.width - 10 - padding - iconSize);
          if (isRTL) {
            xPosition = size.width - _textPainter.width - (padding * 3);
          }

          topPadding = (appointmentHeight - _textPainter.height) / 2;
          _textPainter.paint(
              canvas, Offset(xPosition + 5, yPosition + topPadding));
        }
      }

      if (isRecurrenceAppointment || appointment.recurrenceId != null) {
        final TextSpan icon = AppointmentHelper.getRecurrenceIcon(
            appointmentTextStyle.color!, textSize, isRecurrenceAppointment);
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
            appointment.isAllDay,
            spanIconWidth);
      }

      if (agendaViewNotifier.value != null &&
          isSameDate(agendaViewNotifier.value!.hoveringDate, selectedDate)) {
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
            ? appointmentTextStyle.fontSize! * 1.5
            : defaultFontSize * 1.5;
    if (rect.width < textSize || rect.height < textSize) {
      return rect.width > rect.height ? rect.height : rect.width;
    }

    return textSize;
  }

  double _drawIcon(
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
      bool isAllDay,
      double spanIconWidth) {
    _textPainter.text = icon;
    _textPainter.textScaleFactor = textScaleFactor;
    _textPainter.layout(maxWidth: size.width - (2 * padding) - padding);
    final double iconSize = textSize + 8;
    if (!isLargerScheduleUI) {
      if (isRTL) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(rect.left + spanIconWidth, rect.top,
                    rect.left + spanIconWidth + iconSize, rect.bottom),
                cornerRadius),
            _rectPainter);
      } else {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(rect.right - spanIconWidth - iconSize, rect.top,
                    rect.right - spanIconWidth, rect.bottom),
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
      iconStartPosition = (_textPainter.height -
              (icon.style!.fontSize! * textScaleFactor) / 2) /
          2;
    }

    // Value 8 added as a right side padding for the recurrence icon in the
    // agenda view
    if (isRTL) {
      _textPainter.paint(canvas,
          Offset(8 + spanIconWidth, rect.top + yPosition - iconStartPosition));
    } else {
      _textPainter.paint(
          canvas,
          Offset(rect.right - _textPainter.width - 8 - spanIconWidth,
              rect.top + yPosition - iconStartPosition));
    }
    return _textPainter.width + 8;
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
      CalendarAppointment appointment,
      double appointmentHeight,
      TextStyle appointmentTextStyle,
      List<String> appointmentFormatString,
      List<String> sameDateAppointmentFormatString,
      List<String> diffDateAppointmentFormatString) {
    _textPainter.textScaleFactor = textScaleFactor;
    final double lineHeight = _updatePainterLinesCount(appointmentHeight);
    final double iconSize = isRecurrence ? recurrenceTextSize + 10 : 0;
    _textPainter.layout(
        maxWidth: size.width - (2 * padding) - xPosition - iconSize);
    final double subjectHeight = _textPainter.height;
    final double topPadding =
        (appointmentHeight - (subjectHeight + lineHeight)) / 2;
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (3 * padding) - timeWidth;
    }

    _textPainter.paint(
        canvas, Offset(xPosition + padding, yPosition + topPadding));

    final List<String> format = appointmentFormatString.isEmpty
        ? (isSameDate(appointment.actualStartTime, appointment.actualEndTime)
            ? sameDateAppointmentFormatString
            : diffDateAppointmentFormatString)
        : appointmentFormatString;
    final String startDateText = CalendarViewHelper.getLocalizedString(
        appointment.actualStartTime, format, locale);
    final String endDateText = CalendarViewHelper.getLocalizedString(
        appointment.actualEndTime, format, locale);
    final TextSpan span = TextSpan(
        text: '$startDateText - $endDateText', style: appointmentTextStyle);
    _textPainter.text = span;

    _textPainter.maxLines = 1;
    _textPainter.layout(
        maxWidth: size.width - (2 * padding) - padding - iconSize);
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (3 * padding);
    }
    _textPainter.paint(canvas,
        Offset(xPosition + padding, yPosition + topPadding + subjectHeight));

    return topPadding;
  }

  List<double> _drawSpanningAppointmentForScheduleView(
      Canvas canvas,
      Size size,
      double xPosition,
      double yPosition,
      double padding,
      CalendarAppointment appointment,
      TextStyle appointmentTextStyle,
      double appointmentHeight,
      RRect rect,
      bool isMobilePlatform,
      bool isLargerScheduleUI,
      Radius cornerRadius) {
    final TextSpan span = TextSpan(
        text: AppointmentHelper.getSpanAppointmentText(
            appointment, selectedDate!, localizations),
        style: appointmentTextStyle);

    _updateTextPainterProperties(span);
    _updatePainterLinesCount(appointmentHeight, isSpanned: true);
    final bool isNeedSpanIcon =
        !isSameDate(appointment.exactEndTime, selectedDate);
    final double textSize =
        _getTextSize(rect, appointmentTextStyle, isMobilePlatform);

    /// Icon padding 8 and 2 additional padding
    final double iconSize = isNeedSpanIcon ? textSize + 10 : 0;
    double maxTextWidth = size.width - 10 - padding - iconSize;
    maxTextWidth = maxTextWidth > 0 ? maxTextWidth : 0;
    _textPainter.layout(maxWidth: maxTextWidth);
    if (isRTL) {
      xPosition = size.width - _textPainter.width - (padding * 3);
    }

    final double topPadding = (appointmentHeight - _textPainter.height) / 2;
    _textPainter.paint(
        canvas, Offset(xPosition + padding, yPosition + topPadding));

    if (!isNeedSpanIcon) {
      return <double>[0, topPadding];
    }

    final TextSpan icon = AppointmentHelper.getSpanIcon(
        appointmentTextStyle.color!,
        isMobilePlatform ? textSize : textSize / 1.5,
        !isRTL);
    return <double>[
      _drawIcon(canvas, size, textSize, rect, padding, isLargerScheduleUI,
          cornerRadius, icon, appointmentHeight, topPadding, true, false, 0),
      topPadding
    ];
  }

  void _drawDefaultView(Canvas canvas, Size size, double xPosition,
      double yPosition, double padding) {
    final TextSpan span = TextSpan(
      text: selectedDate == null
          ? localizations.noSelectedDateCalendarLabel
          : localizations.noEventsCalendarLabel,
      style: themeData.textTheme.bodyMedium!.merge(placeholderTextStyle),
    );

    _updateTextPainterProperties(span);
    _textPainter.layout(maxWidth: size.width - 10);
    if (isRTL) {
      xPosition = size.width - _textPainter.width;
    }
    _textPainter.paint(canvas, Offset(xPosition, yPosition + padding));
  }

  void _updateTextPainterProperties(TextSpan span) {
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection =
        CalendarViewHelper.getTextDirectionBasedOnLocale(locale);
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
      bool isNeedSpanIcon,
      bool isNeedRecurrenceIcon,
      double textSize,
      CalendarAppointment appointment,
      TextStyle appointmentTextStyle,
      List<String> appointmentFormatString,
      List<String> sameDateAppointmentFormatString,
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
    double iconSize = isNeedSpanIcon ? textSize + 10 : 0;
    iconSize += isNeedRecurrenceIcon ? textSize + 10 : 0;

    _textPainter.layout(
        maxWidth:
            offset.dx + size.width - (2 * padding) - xPosition - iconSize);

    if (isRTL) {
      xPosition = size.width -
          _textPainter.width -
          (3 * padding) -
          timeWidth -
          circleWidth;
    }

    final double topPadding = (appointmentHeight - _textPainter.height) / 2;
    _textPainter.paint(
        canvas, Offset(xPosition + padding, yPosition + topPadding));
    final List<String> format = appointmentFormatString.isEmpty
        ? sameDateAppointmentFormatString
        : appointmentFormatString;
    final String startDateText = CalendarViewHelper.getLocalizedString(
        appointment.actualStartTime, format, locale);
    final String endDateText = CalendarViewHelper.getLocalizedString(
        appointment.actualEndTime, format, locale);
    final TextSpan span = TextSpan(
        text: appointment.isAllDay || appointment.isSpanned
            ? _localizations.allDayLabel
            : '$startDateText - $endDateText',
        style: appointmentTextStyle);
    _textPainter.text = span;

    _textPainter.layout(maxWidth: timeWidth - padding);
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
    if (rect.left < agendaViewNotifier.value!.hoveringOffset.dx &&
        rect.right > agendaViewNotifier.value!.hoveringOffset.dx &&
        rect.top < agendaViewNotifier.value!.hoveringOffset.dy &&
        rect.bottom > agendaViewNotifier.value!.hoveringOffset.dy) {
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
                const Radius.circular(4)),
            _rectPainter);
      } else {
        _rectPainter.color =
            calendarTheme.selectionBorderColor!.withOpacity(0.4);
        _rectPainter.style = PaintingStyle.stroke;
        _rectPainter.strokeWidth = 2;
        if (childCount == 0) {
          final Radius cornerRadius = Radius.circular(
              (rect.outerRect.height * 0.1) > 5
                  ? 5
                  : (rect.outerRect.height * 0.1));
          canvas.drawRRect(
              RRect.fromRectAndRadius(rect.outerRect, cornerRadius),
              _rectPainter);
        } else {
          canvas.drawRect(rect.outerRect, _rectPainter);
        }

        _rectPainter.style = PaintingStyle.fill;
      }
    }
  }
}
