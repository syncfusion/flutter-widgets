import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../calendar.dart';
import '../appointment_engine/appointment_helper.dart';
import '../common/calendar_view_helper.dart';
import '../common/date_time_engine.dart';

/// Used to holds the all day appointment views in calendar widgets.
class AllDayAppointmentLayout extends StatefulWidget {
  /// Constructor to create the all day appointment layout that holds the
  /// all day appointment views in calendar widget.
  const AllDayAppointmentLayout(
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
      this.themeData,
      this.repaintNotifier,
      this.allDayHoverPosition,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.width,
      this.height,
      this.localizations,
      this.updateCalendarState,
      {super.key});

  /// Holds the calendar instance used the get the properties of calendar.
  final SfCalendar calendar;

  /// Defines the current calendar view of the calendar widget.
  final CalendarView view;

  /// Holds the visible dates of the appointments view.
  final List<DateTime> visibleDates;

  /// Holds the visible appointment collection of the calendar widget.
  final List<CalendarAppointment>? visibleAppointments;

  /// Holds the selection details and user to trigger repaint to draw the
  /// selection.
  final ValueNotifier<AllDayPanelSelectionDetails?> repaintNotifier;

  /// Used to get the calendar state details.
  final UpdateCalendarState updateCalendarState;

  /// Holds the time label width of calendar widget.
  final double timeLabelWidth;

  /// Used to holds the all painter height. Value is differ while
  /// expanded and collapsed and the initial value does not depends on expander
  /// initial page navigation animation.
  final double allDayPainterHeight;

  /// Defines the direction of the calendar widget is RTL or not.
  final bool isRTL;

  /// Holds the theme data of the calendar widget.
  final SfCalendarThemeData calendarTheme;

  /// Holds the framework theme data values.
  final ThemeData themeData;

  /// Used to hold the all day appointment hovering position.
  final ValueNotifier<Offset?> allDayHoverPosition;

  /// Defines the scale factor of the calendar widget.
  final double textScaleFactor;

  /// Defines the current platform is mobile platform or not.
  final bool isMobilePlatform;

  /// Defines the height of the all day appointment layout widget.
  final double height;

  /// Defines the width of the all day appointment layout widget.
  final double width;

  /// Is expandable variable used to indicate whether the all day layout
  /// expandable or not.
  final bool isExpandable;

  /// Is expanding variable used to identify the animation currently running or
  /// not. It is used to restrict the expander icon show on initial animation.
  final bool isExpanding;

  /// Holds the localization data of the calendar widget.
  final SfLocalizations localizations;

  @override
  // ignore: library_private_types_in_public_api
  _AllDayAppointmentLayoutState createState() =>
      _AllDayAppointmentLayoutState();
}

class _AllDayAppointmentLayoutState extends State<AllDayAppointmentLayout> {
  final UpdateCalendarStateDetails _updateCalendarStateDetails =
      UpdateCalendarStateDetails();

  /// It holds the appointment list based on its visible index value.
  Map<int, List<AppointmentView>> _indexAppointments =
      <int, List<AppointmentView>>{};

  /// It holds the more appointment index appointment counts based on its index.
  Map<int, int> _moreAppointmentIndex = <int, int>{};

  /// It holds the appointment views for the visible appointments.
  List<AppointmentView> _appointmentCollection = <AppointmentView>[];

  /// It holds the children of the widget, it holds empty when
  /// appointment builder is null.
  final List<Widget> _children = <Widget>[];

  @override
  void initState() {
    widget.updateCalendarState(_updateCalendarStateDetails);
    _updateAppointmentDetails();
    super.initState();
  }

  @override
  void didUpdateWidget(AllDayAppointmentLayout oldWidget) {
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
    /// Create the widgets when appointment builder is not null.
    if (_children.isEmpty && widget.calendar.appointmentBuilder != null) {
      final DateTime initialVisibleDate = widget.visibleDates[0];
      for (int i = 0; i < _appointmentCollection.length; i++) {
        final AppointmentView appointmentView = _appointmentCollection[i];

        /// Check the appointment view have appointment, if not then the
        /// appointment view is not valid or it will be placed on in expandable
        /// region.
        if (appointmentView.appointment == null ||
            appointmentView.appointmentRect == null) {
          continue;
        }

        final DateTime appStartTime = DateTime(
            appointmentView.appointment!.actualStartTime.year,
            appointmentView.appointment!.actualStartTime.month,
            appointmentView.appointment!.actualStartTime.day);
        final DateTime date = appStartTime.isBefore(initialVisibleDate)
            ? initialVisibleDate
            : appStartTime;

        final Widget child = widget.calendar.appointmentBuilder!(
            context,
            CalendarAppointmentDetails(
                date,
                List<dynamic>.unmodifiable(<dynamic>[
                  CalendarViewHelper.getAppointmentDetail(
                      appointmentView.appointment!, widget.calendar.dataSource)
                ]),
                Rect.fromLTWH(
                    appointmentView.appointmentRect!.left,
                    appointmentView.appointmentRect!.top,
                    appointmentView.appointmentRect!.width,
                    appointmentView.appointmentRect!.right)));

        _children.add(RepaintBoundary(child: child));
      }

      /// Get the more appointment index(more appointment index map holds more
      /// appointment needed cell index and it appointment count)
      final List<int> keys = _moreAppointmentIndex.keys.toList();

      /// Calculate the cell width based on time label width and visible dates
      /// count.
      final double cellWidth =
          (widget.width - widget.timeLabelWidth) / widget.visibleDates.length;

      final double cellEndPadding = CalendarViewHelper.getCellEndPadding(
          widget.calendar.cellEndPadding, widget.isMobilePlatform);

      /// Calculate the maximum appointment width based on cell end padding.
      final double maxAppointmentWidth = cellWidth - cellEndPadding;
      for (int i = 0; i < keys.length; i++) {
        final int index = keys[i];
        final DateTime date = widget.visibleDates[index];
        final double xPosition = widget.timeLabelWidth + (index * cellWidth);
        final List<CalendarAppointment> moreAppointments =
            <CalendarAppointment>[];
        final List<AppointmentView> moreAppointmentViews =
            _indexAppointments[index]!;

        /// Get the appointments of the more appointment cell index from more
        /// appointment views.
        for (int j = 0; j < moreAppointmentViews.length; j++) {
          final AppointmentView currentAppointment = moreAppointmentViews[j];
          moreAppointments.add(currentAppointment.appointment!);
        }
        final Widget child = widget.calendar.appointmentBuilder!(
            context,
            CalendarAppointmentDetails(
                date,
                List<dynamic>.unmodifiable(
                    CalendarViewHelper.getCustomAppointments(
                        moreAppointments, widget.calendar.dataSource)),
                Rect.fromLTWH(
                    widget.isRTL
                        ? widget.width - xPosition - maxAppointmentWidth
                        : xPosition,
                    widget.height - kAllDayAppointmentHeight,
                    maxAppointmentWidth,
                    kAllDayAppointmentHeight - 1),
                isMoreAppointmentRegion: true));

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
      widget.themeData,
      widget.repaintNotifier,
      widget.allDayHoverPosition,
      widget.textScaleFactor,
      widget.isMobilePlatform,
      widget.width,
      widget.height,
      widget.localizations,
      _appointmentCollection,
      _moreAppointmentIndex,
      widgets: _children,
    );
  }

  void _updateAppointmentDetails() {
    _indexAppointments = <int, List<AppointmentView>>{};
    _moreAppointmentIndex = <int, int>{};
    _appointmentCollection = <AppointmentView>[];

    /// Return when the widget as not placed on current visible calendar view.
    if (widget.visibleDates !=
        _updateCalendarStateDetails.currentViewVisibleDates) {
      return;
    }

    _appointmentCollection =
        _updateCalendarStateDetails.allDayAppointmentViewCollection;
    final double cellWidth =
        (widget.width - widget.timeLabelWidth) / widget.visibleDates.length;
    const double cornerRadius = (kAllDayAppointmentHeight * 0.1) > 2
        ? 2
        : kAllDayAppointmentHeight * 0.1;

    final double cellEndPadding = CalendarViewHelper.getCellEndPadding(
        widget.calendar.cellEndPadding, widget.isMobilePlatform);

    /// Calculate the maximum position of the appointment this widget can hold.
    final int position = widget.allDayPainterHeight ~/ kAllDayAppointmentHeight;
    for (int i = 0; i < _appointmentCollection.length; i++) {
      final AppointmentView appointmentView = _appointmentCollection[i];
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
                kAllDayAppointmentHeight * appointmentView.position,
                (widget.visibleDates.length - appointmentView.startIndex) *
                    cellWidth,
                (kAllDayAppointmentHeight * appointmentView.position) +
                    kAllDayAppointmentHeight -
                    1),
            const Radius.circular(cornerRadius));
      } else {
        rect = RRect.fromRectAndRadius(
            Rect.fromLTRB(
                widget.timeLabelWidth +
                    (appointmentView.startIndex * cellWidth),
                kAllDayAppointmentHeight * appointmentView.position,
                (appointmentView.endIndex * cellWidth) +
                    widget.timeLabelWidth -
                    cellEndPadding,
                (kAllDayAppointmentHeight * appointmentView.position) +
                    kAllDayAppointmentHeight -
                    1),
            const Radius.circular(cornerRadius));
      }

      for (int j = appointmentView.startIndex;
          j < appointmentView.endIndex;
          j++) {
        List<AppointmentView> appointmentViews;
        if (_indexAppointments.containsKey(j)) {
          appointmentViews = _indexAppointments[j]!;
          appointmentViews.add(appointmentView);
        } else {
          appointmentViews = <AppointmentView>[appointmentView];
        }
        _indexAppointments[j] = appointmentViews;
      }

      /// Calculate the appointment bound for visible region appointments not
      /// all visible appointments of the widget.
      if (!widget.isRTL &&
          (rect.left < widget.timeLabelWidth - 1 ||
              rect.right > widget.width + 1 ||
              (rect.bottom >
                      widget.allDayPainterHeight - kAllDayAppointmentHeight &&
                  appointmentView.maxPositions > position))) {
        continue;
      } else if (widget.isRTL &&
          (rect.right > widget.width - widget.timeLabelWidth + 1 ||
              rect.left < 0 ||
              (rect.bottom >
                      widget.allDayPainterHeight - kAllDayAppointmentHeight &&
                  appointmentView.maxPositions > position))) {
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
              (AppointmentView currentAppView, AppointmentView nextAppView) =>
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
        final List<AppointmentView> appointmentViews = _indexAppointments[key]!;
        int count = 0;
        if (appointmentViews.isNotEmpty) {
          /// Calculate the current index appointments max position.
          maxPosition = appointmentViews
              .reduce((AppointmentView currentAppView,
                      AppointmentView nextAppView) =>
                  currentAppView.maxPositions > nextAppView.maxPositions
                      ? currentAppView
                      : nextAppView)
              .maxPositions;
        }
        if (maxPosition <= position) {
          continue;
        }

        for (final AppointmentView view in appointmentViews) {
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
  const _AllDayAppointmentRenderWidget(
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
      this.themeData,
      this.repaintNotifier,
      this.allDayHoverPosition,
      this.textScaleFactor,
      this.isMobilePlatform,
      this.width,
      this.height,
      this.localizations,
      this.appointmentCollection,
      this.moreAppointmentIndex,
      {List<Widget> widgets = const <Widget>[]})
      : super(children: widgets);
  final SfCalendar calendar;
  final CalendarView view;
  final List<DateTime> visibleDates;
  final List<CalendarAppointment>? visibleAppointments;
  final ValueNotifier<AllDayPanelSelectionDetails?> repaintNotifier;
  final double timeLabelWidth;
  final double allDayPainterHeight;
  final bool isRTL;
  final SfCalendarThemeData calendarTheme;
  final ThemeData themeData;
  final ValueNotifier<Offset?> allDayHoverPosition;
  final double textScaleFactor;
  final bool isMobilePlatform;
  final double height;
  final double width;
  final bool isExpandable;
  final bool isExpanding;
  final SfLocalizations localizations;
  final Map<int, int> moreAppointmentIndex;
  final List<AppointmentView> appointmentCollection;

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
        themeData,
        repaintNotifier,
        allDayHoverPosition,
        textScaleFactor,
        isMobilePlatform,
        width,
        height,
        localizations,
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
      ..themeData = themeData
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
      ..localizations = localizations
      ..width = width
      ..height = height;
  }
}

class _AllDayAppointmentRenderObject extends CustomCalendarRenderObject {
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
      this._themeData,
      this._selectionNotifier,
      this._allDayHoverPosition,
      this._textScaleFactor,
      this.isMobilePlatform,
      this._width,
      this._height,
      this._localizations,
      this.appointmentCollection,
      this.moreAppointmentIndex);

  SfCalendar calendar;
  bool isMobilePlatform;
  bool isExpanding;
  Map<int, int> moreAppointmentIndex;
  List<AppointmentView> appointmentCollection;

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

  List<CalendarAppointment>? _visibleAppointments;

  List<CalendarAppointment>? get visibleAppointments => _visibleAppointments;

  set visibleAppointments(List<CalendarAppointment>? value) {
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

  ThemeData _themeData;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData value) {
    if (_themeData == value) {
      return;
    }

    _themeData = value;
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

  ValueNotifier<Offset?> _allDayHoverPosition;

  ValueNotifier<Offset?> get allDayHoverPosition => _allDayHoverPosition;

  set allDayHoverPosition(ValueNotifier<Offset?> value) {
    if (_allDayHoverPosition == value) {
      return;
    }

    _allDayHoverPosition.removeListener(markNeedsPaint);
    _allDayHoverPosition = value;
    _allDayHoverPosition.addListener(markNeedsPaint);
  }

  ValueNotifier<AllDayPanelSelectionDetails?> _selectionNotifier;

  ValueNotifier<AllDayPanelSelectionDetails?> get selectionNotifier =>
      _selectionNotifier;

  set selectionNotifier(ValueNotifier<AllDayPanelSelectionDetails?> value) {
    if (_selectionNotifier == value) {
      return;
    }

    _selectionNotifier.removeListener(markNeedsPaint);
    _selectionNotifier = value;
    _selectionNotifier.addListener(markNeedsPaint);
  }

  /// Caches [SemanticsNode]s created during [assembleSemanticsNode] so they
  /// can be re-used when [assembleSemanticsNode] is called again. This ensures
  /// stable ids for the [SemanticsNode]s of children across
  /// [assembleSemanticsNode] invocations.
  /// Ref: assembleSemanticsNode method in RenderParagraph class
  /// (https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/rendering/paragraph.dart)
  List<SemanticsNode>? _cacheNodes;
  final Paint _rectPainter = Paint();
  final TextPainter _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
      textAlign: TextAlign.left,
      textWidthBasis: TextWidthBasis.longestLine);
  final TextPainter _expanderTextPainter = TextPainter(
      textDirection: TextDirection.ltr, textAlign: TextAlign.left, maxLines: 1);
  late BoxPainter _boxPainter;
  bool _isHoveringAppointment = false;
  int _maxPosition = 0;
  double _cellWidth = 0;

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _allDayHoverPosition.addListener(markNeedsPaint);
    _selectionNotifier.addListener(markNeedsPaint);
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = firstChild;
    if (child == null) {
      return false;
    }

    final int maxPosition = allDayPainterHeight ~/ kAllDayAppointmentHeight;
    final double maximumBottomPosition =
        allDayPainterHeight - kAllDayAppointmentHeight;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.appointment == null ||
          child == null ||
          appointmentView.appointmentRect == null) {
        continue;
      }

      final RRect appointmentRect = appointmentView.appointmentRect!;
      if (!isRTL &&
          (appointmentRect.left < timeLabelWidth - 1 ||
              appointmentRect.right > size.width + 1 ||
              (appointmentRect.bottom > maximumBottomPosition &&
                  appointmentView.maxPositions > maxPosition))) {
        child = childAfter(child);
        continue;
      } else if (isRTL &&
          (appointmentRect.right > size.width - timeLabelWidth + 1 ||
              appointmentRect.left < 0 ||
              (appointmentRect.bottom > maximumBottomPosition &&
                  appointmentView.maxPositions > maxPosition))) {
        child = childAfter(child);
        continue;
      }

      final Offset offset = Offset(appointmentRect.left, appointmentRect.top);
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

    _cellWidth = (size.width - timeLabelWidth) / visibleDates.length;
    final double cellEndPadding = CalendarViewHelper.getCellEndPadding(
        calendar.cellEndPadding, isMobilePlatform);
    final List<int> keys = moreAppointmentIndex.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      if (child == null) {
        continue;
      }

      final int index = keys[i];
      final double leftPosition = isRTL
          ? ((visibleDates.length - index - 1) * _cellWidth) + cellEndPadding
          : timeLabelWidth + (index * _cellWidth);
      final Offset offset = Offset(leftPosition, maximumBottomPosition);
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

  /// detach will called when the render object removed from view.
  @override
  void detach() {
    _allDayHoverPosition.removeListener(markNeedsPaint);
    _selectionNotifier.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? height : widgetSize.height);
    RenderBox? child = firstChild;
    final int position = allDayPainterHeight ~/ kAllDayAppointmentHeight;
    final double maximumBottomPosition =
        allDayPainterHeight - kAllDayAppointmentHeight;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.appointment == null ||
          child == null ||
          appointmentView.appointmentRect == null) {
        continue;
      }

      final RRect appointmentRect = appointmentView.appointmentRect!;
      if (!isRTL &&
          (appointmentRect.left < timeLabelWidth - 1 ||
              appointmentRect.right > size.width + 1 ||
              (appointmentRect.bottom > maximumBottomPosition &&
                  appointmentView.maxPositions > position))) {
        child = childAfter(child);
        continue;
      } else if (isRTL &&
          (appointmentRect.right > size.width - timeLabelWidth + 1 ||
              appointmentRect.left < 0 ||
              (appointmentRect.bottom > maximumBottomPosition &&
                  appointmentView.maxPositions > position))) {
        child = childAfter(child);
        continue;
      }

      child.layout(constraints.copyWith(
          minHeight: appointmentRect.height,
          maxHeight: appointmentRect.height,
          minWidth: appointmentRect.width,
          maxWidth: appointmentRect.width));
      final CalendarParentData childParentData =
          child.parentData! as CalendarParentData;
      childParentData.offset =
          Offset(appointmentRect.left, appointmentRect.top);
      child = childAfter(child);
    }

    _cellWidth = (size.width - timeLabelWidth) / visibleDates.length;
    const double appointmentHeight = kAllDayAppointmentHeight - 1;
    final double cellEndPadding = CalendarViewHelper.getCellEndPadding(
        calendar.cellEndPadding, isMobilePlatform);
    final double maxAppointmentWidth = _cellWidth - cellEndPadding;
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
      final CalendarParentData childParentData =
          child.parentData! as CalendarParentData;
      final int index = keys[i];
      final double leftPosition = isRTL
          ? ((visibleDates.length - index - 1) * _cellWidth) + cellEndPadding
          : timeLabelWidth + (index * _cellWidth);
      childParentData.offset = Offset(leftPosition, maximumBottomPosition);
      child = childAfter(child);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _textPainter.textScaler = TextScaler.linear(textScaleFactor);
    double leftPosition = 0, rightPosition = size.width;
    if (CalendarViewHelper.isDayView(
        view,
        calendar.timeSlotViewSettings.numberOfDaysInView,
        calendar.timeSlotViewSettings.nonWorkingDays,
        calendar.monthViewSettings.numberOfWeeksInView)) {
      _rectPainter.strokeWidth = 0.5;
      _rectPainter.color =
          calendar.cellBorderColor ?? calendarTheme.cellBorderColor!;
      //// Decrease the x position by 0.5 because draw the end point of the view
      /// draws half of the line to current view and hides another half.
      context.canvas.drawLine(
          Offset(
              isRTL ? size.width - timeLabelWidth + 0.5 : timeLabelWidth - 0.5,
              0),
          Offset(
              isRTL ? size.width - timeLabelWidth + 0.5 : timeLabelWidth - 0.5,
              size.height),
          _rectPainter);

      leftPosition = isRTL ? 0 : timeLabelWidth;
      rightPosition = isRTL ? size.width - timeLabelWidth : size.width;

      final double viewHeaderHeight = CalendarViewHelper.getViewHeaderHeight(
          calendar.viewHeaderHeight, view);
      _rectPainter.color = calendar.timeSlotViewSettings.allDayPanelColor ??
          calendarTheme.allDayPanelColor!;
      context.canvas.drawRect(
          Rect.fromLTRB(
              isRTL ? size.width - timeLabelWidth : 0,
              viewHeaderHeight,
              isRTL ? size.width : timeLabelWidth,
              size.height),
          _rectPainter);
    }
    _rectPainter.color = calendar.timeSlotViewSettings.allDayPanelColor ??
        calendarTheme.allDayPanelColor!;
    context.canvas.drawRect(
        Rect.fromLTRB(leftPosition, 0, rightPosition, size.height),
        _rectPainter);

    _rectPainter.isAntiAlias = true;
    _cellWidth = (size.width - timeLabelWidth) / visibleDates.length;
    const double textPadding = 3;
    _maxPosition = 0;
    if (appointmentCollection.isNotEmpty) {
      _maxPosition = appointmentCollection
          .reduce(
              (AppointmentView currentAppView, AppointmentView nextAppView) =>
                  currentAppView.maxPositions > nextAppView.maxPositions
                      ? currentAppView
                      : nextAppView)
          .maxPositions;
    }

    if (_maxPosition == -1) {
      _maxPosition = 0;
    }

    _isHoveringAppointment = false;
    final int position = allDayPainterHeight ~/ kAllDayAppointmentHeight;
    RenderBox? child = firstChild;
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.canReuse ||
          appointmentView.appointmentRect == null ||
          appointmentView.appointment == null) {
        continue;
      }

      final RRect rect = appointmentView.appointmentRect!;
      if (!isRTL &&
          (rect.left < timeLabelWidth - 1 ||
              rect.right > size.width + 1 ||
              (rect.bottom > allDayPainterHeight - kAllDayAppointmentHeight &&
                  appointmentView.maxPositions > position))) {
        if (child != null) {
          child = childAfter(child);
        }
        continue;
      } else if (isRTL &&
          (rect.right > size.width - timeLabelWidth + 1 ||
              rect.left < 0 ||
              (rect.bottom > allDayPainterHeight - kAllDayAppointmentHeight &&
                  appointmentView.maxPositions > position))) {
        if (child != null) {
          child = childAfter(child);
        }
        continue;
      }

      if (child != null) {
        context.paintChild(child, Offset(rect.left, rect.top));
        child = childAfter(child);
      } else {
        _drawAllDayAppointmentView(context, offset, appointmentView);
      }

      _addMouseHoveringForAppointment(context.canvas, rect);

      if (selectionNotifier.value != null &&
          selectionNotifier.value!.appointmentView != null &&
          selectionNotifier.value!.appointmentView == appointmentView &&
          selectionNotifier.value!.appointmentView!.appointment != null &&
          selectionNotifier.value!.appointmentView!.appointment ==
              appointmentView.appointment) {
        _addSelectionForAppointment(context.canvas, appointmentView);
      }
    }

    if (selectionNotifier.value != null &&
        selectionNotifier.value!.selectedDate != null) {
      _addSelectionForAllDayPanel(context.canvas, size);
    }

    if (isExpandable && _maxPosition > position && !isExpanding) {
      if (child != null) {
        final double endYPosition =
            allDayPainterHeight - kAllDayAppointmentHeight;
        final double cellEndPadding = CalendarViewHelper.getCellEndPadding(
            calendar.cellEndPadding, isMobilePlatform);
        final List<int> keys = moreAppointmentIndex.keys.toList();
        for (final int index in keys) {
          if (child == null) {
            continue;
          }

          final double xPosition = isRTL
              ? ((visibleDates.length - index - 1) * _cellWidth) +
                  cellEndPadding
              : timeLabelWidth + (index * _cellWidth);
          context.paintChild(child, Offset(xPosition, endYPosition));
          child = childAfter(child);
        }
      } else {
        _addExpanderText(context.canvas, position, textPadding);
      }
    }

    if (isExpandable) {
      _addExpandOrCollapseIcon(context.canvas, size, position);
    }

    if (!_isHoveringAppointment) {
      _addMouseHoveringForAllDayPanel(context.canvas, size);
    }
  }

  /// To display the different text on spanning appointment for day view, for
  /// other views we just display the subject of the appointment and for day
  /// view  we display the current date, and total dates of the spanning
  /// appointment.
  String _getAllDayAppointmentText(CalendarAppointment appointment) {
    if (!CalendarViewHelper.isDayView(
            view,
            calendar.timeSlotViewSettings.numberOfDaysInView,
            calendar.timeSlotViewSettings.nonWorkingDays,
            calendar.monthViewSettings.numberOfWeeksInView) ||
        !appointment.isSpanned) {
      return appointment.subject;
    }

    return AppointmentHelper.getSpanAppointmentText(
        appointment, visibleDates[0], _localizations);
  }

  double _getTextSize(RRect rect, double textSize) {
    if (rect.width < textSize || rect.height < textSize) {
      return rect.width > rect.height ? rect.height : rect.width;
    }

    return textSize;
  }

  void _addForwardSpanIconForAllDay(
      Canvas canvas,
      RRect rect,
      double iconTextSize,
      double forwardIconSize,
      TextStyle appointmentTextStyle) {
    final TextSpan icon = AppointmentHelper.getSpanIcon(
        appointmentTextStyle.color!, iconTextSize, !isRTL);
    _textPainter.text = icon;
    _textPainter.layout(maxWidth: rect.width >= 0 ? rect.width : 0);

    final double yPosition =
        AppointmentHelper.getYPositionForSpanIcon(icon, _textPainter, rect);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                isRTL ? rect.left : rect.right - forwardIconSize,
                rect.top,
                isRTL ? rect.left + forwardIconSize : rect.right,
                rect.bottom),
            rect.brRadius),
        _rectPainter);
    double iconPadding = (forwardIconSize - _textPainter.width) / 2;
    if (iconPadding < 0) {
      iconPadding = 0;
    }

    _textPainter.paint(
        canvas,
        Offset((isRTL ? rect.left : rect.right - forwardIconSize) + iconPadding,
            yPosition));
  }

  void _drawAllDayAppointmentView(
      PaintingContext context, Offset offset, AppointmentView appointmentView) {
    final CalendarAppointment appointment = appointmentView.appointment!;
    final RRect rect = appointmentView.appointmentRect!;

    _rectPainter.color = appointment.color;
    context.canvas.drawRRect(rect, _rectPainter);

    final TextStyle appointmentTextStyle =
        AppointmentHelper.getAppointmentTextStyle(
            calendar.appointmentTextStyle, view, themeData);
    final double iconTextSize = _getTextSize(
        rect, _textPainter.textScaler.scale(appointmentTextStyle.fontSize!));
    const double iconPadding = 2;
    //// Padding 4 is left and right 2 padding.
    final double iconSize = iconTextSize + (2 * iconPadding);
    final bool isRecurrenceAppointment = appointment.recurrenceRule != null &&
        appointment.recurrenceRule!.isNotEmpty;
    final double recurrenceIconSize =
        isRecurrenceAppointment || appointment.recurrenceId != null
            ? iconSize
            : 0;
    double forwardSpanIconSize = 0;
    double backwardSpanIconSize = 0;

    final bool canAddSpanIcon =
        AppointmentHelper.canAddSpanIcon(visibleDates, appointment, view);
    if (canAddSpanIcon) {
      final DateTime appStartTime = appointment.exactStartTime;
      final DateTime appEndTime = appointment.exactEndTime;
      final DateTime viewStartDate =
          AppointmentHelper.convertToStartTime(visibleDates[0]);
      final DateTime viewEndDate = AppointmentHelper.convertToEndTime(
          visibleDates[visibleDates.length - 1]);
      if (AppointmentHelper.canAddForwardSpanIcon(
          appStartTime, appEndTime, viewStartDate, viewEndDate)) {
        forwardSpanIconSize = iconSize;
      } else if (AppointmentHelper.canAddBackwardSpanIcon(
          appStartTime, appEndTime, viewStartDate, viewEndDate)) {
        backwardSpanIconSize = iconSize;
      } else {
        forwardSpanIconSize = iconSize;
        backwardSpanIconSize = iconSize;
      }
    }

    final TextSpan span = TextSpan(
      text: _getAllDayAppointmentText(appointment),
      style: appointmentTextStyle,
    );
    _textPainter.text = span;
    final double totalIconSize =
        recurrenceIconSize + forwardSpanIconSize + backwardSpanIconSize;
    const double textPadding = 1;
    _textPainter.layout(
        maxWidth: rect.width - totalIconSize - (2 * textPadding) >= 0
            ? rect.width - totalIconSize - (2 * textPadding)
            : 0);
    if (_textPainter.maxLines == 1 && _textPainter.height > rect.height) {
      return;
    }
    final double xPosition = isRTL
        ? rect.right - _textPainter.width - backwardSpanIconSize - textPadding
        : rect.left + backwardSpanIconSize + textPadding;
    _textPainter.paint(context.canvas,
        Offset(xPosition, rect.top + (rect.height - _textPainter.height) / 2));

    if (backwardSpanIconSize != 0) {
      _addBackwardSpanIconForAllDay(context.canvas, rect, iconTextSize,
          backwardSpanIconSize, appointmentTextStyle);
    }

    if (recurrenceIconSize != 0) {
      _addRecurrenceIcon(
          context.canvas,
          rect,
          isRecurrenceAppointment,
          iconTextSize,
          recurrenceIconSize,
          forwardSpanIconSize,
          appointmentTextStyle);
    }

    if (forwardSpanIconSize != 0) {
      _addForwardSpanIconForAllDay(context.canvas, rect, iconTextSize,
          forwardSpanIconSize, appointmentTextStyle);
    }
  }

  void _addBackwardSpanIconForAllDay(
      Canvas canvas,
      RRect rect,
      double iconTextSize,
      double backwardIconSize,
      TextStyle appointmentTextStyle) {
    final TextSpan icon = AppointmentHelper.getSpanIcon(
        appointmentTextStyle.color!, iconTextSize, isRTL);
    _textPainter.text = icon;
    _textPainter.layout(maxWidth: rect.width >= 0 ? rect.width : 0);

    final double yPosition =
        AppointmentHelper.getYPositionForSpanIcon(icon, _textPainter, rect);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                isRTL ? rect.right - backwardIconSize : rect.left,
                rect.top,
                isRTL ? rect.right : rect.left + iconTextSize,
                rect.bottom),
            rect.brRadius),
        _rectPainter);
    double iconPadding = (backwardIconSize - _textPainter.width) / 2;
    if (iconPadding < 0) {
      iconPadding = 0;
    }

    _textPainter.paint(
        canvas,
        Offset(
            (isRTL ? rect.right - backwardIconSize : rect.left) + iconPadding,
            yPosition));
  }

  void _addExpanderText(Canvas canvas, int position, double textPadding) {
    final TextStyle textStyle = calendarTheme.viewHeaderDayTextStyle!;
    final double endYPosition = allDayPainterHeight - kAllDayAppointmentHeight;
    final List<int> keys = moreAppointmentIndex.keys.toList();
    for (final int index in keys) {
      final TextSpan span = TextSpan(
        text: '+ ${moreAppointmentIndex[index]}',
        style: textStyle,
      );
      _textPainter.text = span;
      _textPainter.layout(
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
                  ((kAllDayAppointmentHeight - _textPainter.height) / 2)));
    }
  }

  void _addExpandOrCollapseIcon(Canvas canvas, Size size, int position) {
    final int iconCodePoint = _maxPosition <= position
        ? Icons.expand_less.codePoint
        : Icons.expand_more.codePoint;
    final TextSpan icon = TextSpan(
        text: String.fromCharCode(iconCodePoint),
        style: TextStyle(
          color: calendarTheme.viewHeaderDayTextStyle!.color,
          fontSize: calendar.viewHeaderStyle.dayTextStyle != null &&
                  calendar.viewHeaderStyle.dayTextStyle!.fontSize != null
              ? calendar.viewHeaderStyle.dayTextStyle!.fontSize! * 2
              : kAllDayAppointmentHeight + 5,
          fontFamily: 'MaterialIcons',
        ));
    _expanderTextPainter.textScaler = TextScaler.linear(textScaleFactor);
    _expanderTextPainter.text = icon;
    _expanderTextPainter.layout(maxWidth: timeLabelWidth);
    _expanderTextPainter.paint(
        canvas,
        Offset(
            isRTL
                ? (size.width - timeLabelWidth) +
                    ((timeLabelWidth - _expanderTextPainter.width) / 2)
                : (timeLabelWidth - _expanderTextPainter.width) / 2,
            allDayPainterHeight -
                kAllDayAppointmentHeight +
                (kAllDayAppointmentHeight - _expanderTextPainter.height) / 2));
  }

  void _addMouseHoveringForAllDayPanel(Canvas canvas, Size size) {
    if (allDayHoverPosition.value == null) {
      return;
    }
    final int rowIndex =
        (allDayHoverPosition.value!.dx - (isRTL ? 0 : timeLabelWidth)) ~/
            _cellWidth;
    final double leftPosition =
        (rowIndex * _cellWidth) + (isRTL ? 0 : timeLabelWidth);
    _rectPainter.color = Colors.grey.withValues(alpha: 0.1);
    canvas.drawRect(
        Rect.fromLTWH(leftPosition, 0, _cellWidth, size.height), _rectPainter);
  }

  void _addSelectionForAllDayPanel(Canvas canvas, Size size) {
    final int index = DateTimeHelper.getIndex(
        visibleDates, selectionNotifier.value!.selectedDate!);
    Decoration? selectionDecoration = calendar.selectionDecoration;
    final double cellEndPadding = CalendarViewHelper.getCellEndPadding(
        calendar.cellEndPadding, isMobilePlatform);

    /// Set the default selection decoration background color with opacity
    /// value based on theme brightness when selected date hold all day
    /// appointment.
    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView appointmentView = appointmentCollection[i];
      if (appointmentView.position == 0 &&
          appointmentView.startIndex <= index &&
          appointmentView.endIndex > index) {
        selectionDecoration ??= BoxDecoration(
          color: themeData.brightness == Brightness.light
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.4),
          border:
              Border.all(color: calendarTheme.selectionBorderColor!, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        );

        break;
      }
    }

    /// Set the default selection decoration background color as transparent
    /// when selected date does not hold all day appointment.
    selectionDecoration ??= BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: calendarTheme.selectionBorderColor!, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(2)),
    );

    Rect rect;
    double xValue = timeLabelWidth + (index * _cellWidth);
    if (isRTL) {
      xValue = size.width - xValue - _cellWidth;
      rect = Rect.fromLTRB(xValue + cellEndPadding, 0, xValue + _cellWidth,
          kAllDayAppointmentHeight - 1);
    } else {
      rect = Rect.fromLTRB(xValue, 0, xValue + _cellWidth - cellEndPadding,
          kAllDayAppointmentHeight - 1);
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
    selectionNotifier.value = AllDayPanelSelectionDetails(
        selectionNotifier.value!.appointmentView,
        selectionNotifier.value!.selectedDate);
  }

  void _addSelectionForAppointment(
      Canvas canvas, AppointmentView appointmentView) {
    Decoration? selectionDecoration = calendar.selectionDecoration;
    selectionDecoration ??= BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: calendarTheme.selectionBorderColor!, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(1)),
    );

    Rect rect = appointmentView.appointmentRect!.outerRect;
    rect = Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);
    _boxPainter =
        selectionDecoration.createBoxPainter(_updateSelectionDecorationPainter);
    _boxPainter.paint(canvas, Offset(rect.left, rect.top),
        ImageConfiguration(size: rect.size));
  }

  void _addMouseHoveringForAppointment(Canvas canvas, RRect rect) {
    if (allDayHoverPosition.value == null) {
      return;
    }

    if (rect.left < allDayHoverPosition.value!.dx &&
        rect.right > allDayHoverPosition.value!.dx &&
        rect.top < allDayHoverPosition.value!.dy &&
        rect.bottom > allDayHoverPosition.value!.dy) {
      _rectPainter.color =
          calendarTheme.selectionBorderColor!.withValues(alpha: 0.4);
      _rectPainter.strokeWidth = 2;
      _rectPainter.style = PaintingStyle.stroke;
      canvas.drawRRect(rect, _rectPainter);
      _rectPainter.style = PaintingStyle.fill;
      _isHoveringAppointment = true;
    }
  }

  void _addRecurrenceIcon(
      Canvas canvas,
      RRect rect,
      bool isRecurrenceAppointment,
      double iconTextSize,
      double recurrenceIconSize,
      double forwardSpanIconSize,
      TextStyle appointmentTextStyle) {
    final TextSpan icon = AppointmentHelper.getRecurrenceIcon(
        appointmentTextStyle.color!, iconTextSize, isRecurrenceAppointment);
    _textPainter.text = icon;
    _textPainter.layout(maxWidth: rect.width >= 0 ? rect.width : 0);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                isRTL
                    ? rect.left + forwardSpanIconSize
                    : rect.right - recurrenceIconSize - forwardSpanIconSize,
                rect.top,
                isRTL
                    ? rect.left + recurrenceIconSize + forwardSpanIconSize
                    : rect.right - forwardSpanIconSize,
                rect.bottom),
            rect.brRadius),
        _rectPainter);
    double iconPadding = (recurrenceIconSize - _textPainter.width) / 2;
    if (iconPadding < 0) {
      iconPadding = 0;
    }

    _textPainter.paint(
        canvas,
        Offset(
            (isRTL
                    ? rect.left + forwardSpanIconSize
                    : rect.right - recurrenceIconSize - forwardSpanIconSize) +
                iconPadding,
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

    if (appointmentCollection.isEmpty) {
      return semanticsBuilder;
    }

    final int position = allDayPainterHeight ~/ kAllDayAppointmentHeight;
    final double bottom = allDayPainterHeight - kAllDayAppointmentHeight;
    if (isExpandable) {
      final double left = isRTL ? size.width - timeLabelWidth : 0;
      final double top = allDayPainterHeight - kAllDayAppointmentHeight;
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(left, top, isRTL ? size.width : timeLabelWidth,
            _expanderTextPainter.height),
        properties: SemanticsProperties(
          label: _maxPosition <= allDayPainterHeight ~/ kAllDayAppointmentHeight
              ? 'Collapse all day section'
              : 'Expand all day section',
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    if (isExpandable &&
        _maxPosition > (allDayPainterHeight ~/ kAllDayAppointmentHeight) &&
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
              kAllDayAppointmentHeight),
          properties: SemanticsProperties(
            label: '+${moreAppointmentIndex[index]}',
            textDirection: TextDirection.ltr,
          ),
        ));
      }
    }

    for (int i = 0; i < appointmentCollection.length; i++) {
      final AppointmentView view = appointmentCollection[i];
      if (view.appointment == null ||
          view.appointmentRect == null ||
          (view.appointmentRect != null &&
              view.appointmentRect!.bottom > bottom &&
              view.maxPositions > position)) {
        continue;
      }

      semanticsBuilder.add(CustomPainterSemantics(
        rect: view.appointmentRect!.outerRect,
        properties: SemanticsProperties(
          label:
              CalendarViewHelper.getAppointmentSemanticsText(view.appointment!),
          textDirection: TextDirection.ltr,
        ),
      ));
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
}
