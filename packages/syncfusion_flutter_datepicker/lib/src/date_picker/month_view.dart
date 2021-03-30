import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import '../../datepicker.dart';
import 'date_picker_manager.dart';
import 'picker_helper.dart';

/// Used to hold the month cell widgets.
class MonthView extends StatefulWidget {
  /// Constructor for create the month view widget used to hold the month cell
  /// widgets.
  MonthView(
      this.visibleDates,
      this.rowCount,
      this.cellStyle,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.datePickerTheme,
      this.isRtl,
      this.todayHighlightColor,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.showLeadingAndTailingDates,
      this.blackoutDates,
      this.specialDates,
      this.weekendDays,
      this.selectionShape,
      this.selectionRadius,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionNotifier,
      this.textScaleFactor,
      this.selectionMode,
      this.isHijri,
      this.localizations,
      this.navigationDirection,
      this.width,
      this.height,
      this.getPickerStateDetails,
      this.cellBuilder);

  /// Defines the month row count.
  final int rowCount;

  /// Defines the month cell style.
  final dynamic cellStyle;

  /// Holds the visible dates for the month view.
  final List<dynamic> visibleDates;

  /// Used to identify the widget direction is RTL.
  final bool isRtl;

  /// Defines the today cell highlight color.
  final Color? todayHighlightColor;

  /// Holds the theme data for date range picker.
  final SfDateRangePickerThemeData datePickerTheme;

  /// The minimum date as much as the [SfDateRangePicker] will navigate.
  final dynamic minDate;

  /// The maximum date as much as the [SfDateRangePicker] will navigate.
  final dynamic maxDate;

  /// Decides to enable past dates or not.
  final bool enablePastDates;

  /// Decides the trailing and leading of month view will visible or not.
  final bool showLeadingAndTailingDates;

  /// Holds the blackout dates of the [SfDateRangePicker].
  final List<dynamic>? blackoutDates;

  /// Holds the special dates of the [SfDateRangePicker].
  final List<dynamic>? specialDates;

  /// Holds the list of week day index of the [SfDateRangePicker].
  final List<int> weekendDays;

  /// Decides the month cell highlight and selection shape.
  final DateRangePickerSelectionShape selectionShape;

  /// Holds the selection radius of the month cell.
  final double selectionRadius;

  /// Used to call repaint when the selection changes.
  final ValueNotifier<bool> selectionNotifier;

  /// Used to specify the mouse hover position of the month view.
  final ValueNotifier<Offset?> mouseHoverPosition;

  /// Decides to show the multi view of month view or not.
  final bool enableMultiView;

  /// Specifies the space between the multi month views.
  final double multiViewSpacing;

  /// Defines the text style for selected month cell.
  final TextStyle? selectionTextStyle;

  /// Defines the range text style for selected range month cell.
  final TextStyle? rangeTextStyle;

  /// Defines the background color for selected month cell.
  final Color? selectionColor;

  /// Defines the background color for selected range start date month cell.
  final Color? startRangeSelectionColor;

  /// Defines the background color for selected range end date month cell.
  final Color? endRangeSelectionColor;

  /// Defines the background color for selected range in between dates cell.
  final Color? rangeSelectionColor;

  /// Defines the text scale factor of [SfDateRangePicker].
  final double textScaleFactor;

  /// Defines the selection mode of the [SfDateRangePicker].
  final DateRangePickerSelectionMode selectionMode;

  /// Defines the height of the month view.
  final double height;

  /// Defines the width of the month view.
  final double width;

  /// Used to get the picker state details from picker view widget.
  final UpdatePickerState getPickerStateDetails;

  /// Used to build the widget that replaces the month cells in month view.
  final dynamic cellBuilder;

  /// Specifies the pickerType for [SfDateRangePicker].
  final bool isHijri;

  /// Specifies the localizations.
  final SfLocalizations localizations;

  /// Defines the navigation direction for [SfDateRangePicker].
  final DateRangePickerNavigationDirection navigationDirection;

  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  PickerStateArgs _pickerStateDetails = PickerStateArgs();
  dynamic? _selectedDate;
  List<dynamic>? _selectedDates;
  dynamic? _selectedRange;
  List<dynamic>? _selectedRanges;
  List<Widget> _children = <Widget>[];

  @override
  void initState() {
    widget.getPickerStateDetails(_pickerStateDetails);
    _selectedDate = _pickerStateDetails.selectedDate;
    _selectedDates =
        DateRangePickerHelper.cloneList(_pickerStateDetails.selectedDates);
    _selectedRange = _pickerStateDetails.selectedRange;
    _selectedRanges =
        DateRangePickerHelper.cloneList(_pickerStateDetails.selectedRanges);
    widget.selectionNotifier.addListener(_updateSelection);
    super.initState();
  }

  @override
  void didUpdateWidget(MonthView oldWidget) {
    if (widget.height != oldWidget.height ||
        widget.width != oldWidget.width ||
        widget.enablePastDates != oldWidget.enablePastDates ||
        widget.minDate != oldWidget.minDate ||
        widget.maxDate != oldWidget.maxDate ||
        widget.cellBuilder != oldWidget.cellBuilder ||
        widget.selectionMode != oldWidget.selectionMode ||
        widget.multiViewSpacing != oldWidget.multiViewSpacing ||
        widget.enableMultiView != oldWidget.enableMultiView ||
        !DateRangePickerHelper.isDateCollectionEquals(
            widget.blackoutDates, oldWidget.blackoutDates) ||
        !DateRangePickerHelper.isDateCollectionEquals(
            widget.specialDates, oldWidget.specialDates) ||
        widget.showLeadingAndTailingDates !=
            oldWidget.showLeadingAndTailingDates ||
        widget.rowCount != oldWidget.rowCount ||
        widget.localizations != oldWidget.localizations ||
        widget.isHijri != oldWidget.isHijri ||
        widget.navigationDirection != oldWidget.navigationDirection ||
        widget.visibleDates != oldWidget.visibleDates) {
      _children.clear();
    }

    if (widget.selectionNotifier != oldWidget.selectionNotifier) {
      oldWidget.selectionNotifier.removeListener(_updateSelection);
      widget.selectionNotifier.addListener(_updateSelection);
    }

    _updateSelection(isNeedSetState: false);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.selectionNotifier.removeListener(_updateSelection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cellBuilder != null && _children.isEmpty) {
      double webUIPadding = 0;
      double width = widget.width;
      double height = widget.height;
      int viewCount = 1;
      final bool isHorizontalMultiView = widget.enableMultiView &&
          widget.navigationDirection ==
              DateRangePickerNavigationDirection.horizontal;
      final bool isVerticalMultiView = widget.enableMultiView &&
          widget.navigationDirection ==
              DateRangePickerNavigationDirection.vertical;

      if (isHorizontalMultiView) {
        webUIPadding = widget.multiViewSpacing;
        viewCount = 2;
        width = (width - webUIPadding) / viewCount;
      } else if (isVerticalMultiView) {
        webUIPadding = widget.multiViewSpacing;
        viewCount = 2;
        height = (height - webUIPadding) / viewCount;
      }

      final int datesCount = widget.visibleDates.length ~/ viewCount;
      final double cellWidth = width / DateTime.daysPerWeek;
      final double cellHeight = height / widget.rowCount;
      final bool hideLeadingAndTrailingDates =
          (widget.rowCount == 6 && !widget.showLeadingAndTailingDates) ||
              widget.isHijri;
      for (int j = 0; j < viewCount; j++) {
        final int currentViewIndex =
            widget.isRtl ? DateRangePickerHelper.getRtlIndex(viewCount, j) : j;
        final int viewStartIndex = j * datesCount;
        final int currentMonth = widget
            .visibleDates[(viewStartIndex + (datesCount / 2)).truncate()].month;
        final double viewStartPosition = isVerticalMultiView
            ? 0
            : (currentViewIndex * width) +
                (currentViewIndex * widget.multiViewSpacing);
        final double viewEndPosition = viewStartPosition + width;
        double xPosition = viewStartPosition;
        double yPosition = isHorizontalMultiView
            ? 0
            : (currentViewIndex * height) +
                (currentViewIndex * widget.multiViewSpacing);
        for (int i = 0; i < datesCount; i++) {
          int currentIndex = i;
          if (widget.isRtl) {
            final int rowIndex = i ~/ DateTime.daysPerWeek;
            currentIndex = DateRangePickerHelper.getRtlIndex(
                    DateTime.daysPerWeek, i % DateTime.daysPerWeek) +
                (rowIndex * DateTime.daysPerWeek);
          }

          currentIndex += viewStartIndex;

          /// Check the x position reaches view end position then draw the
          /// date on next cell.
          /// Padding 1 value used to avoid decimal value difference.
          /// eg., if view end position as 243 and x position as 242.499 then
          /// round method in decimal return 242 rather than 243, so it does
          /// not move the next line for draw date value.
          if (xPosition + 1 >= viewEndPosition) {
            xPosition = viewStartPosition;
            yPosition += cellHeight;
          }

          final dynamic date = widget.visibleDates[currentIndex];
          if (hideLeadingAndTrailingDates && date.month != currentMonth) {
            xPosition += cellWidth;
            continue;
          }

          final Widget child = widget.cellBuilder(
              context,
              widget.isHijri
                  ? HijriDateRangePickerCellDetails(
                      date: date,
                      visibleDates: widget.visibleDates.cast<HijriDateTime>(),
                      bounds: Rect.fromLTWH(
                          xPosition, yPosition, cellWidth, cellHeight))
                  : DateRangePickerCellDetails(
                      date: date,
                      visibleDates: widget.visibleDates.cast<DateTime>(),
                      bounds: Rect.fromLTWH(
                          xPosition, yPosition, cellWidth, cellHeight)));
          _children.add(child);
          xPosition += cellWidth;
        }
      }
    }

    return _getMonthRenderWidget();
  }

  void _updateSelection({bool isNeedSetState = true}) {
    widget.getPickerStateDetails(_pickerStateDetails);
    if (_isSelectedValueEquals()) {
      return;
    }

    _children.clear();
    _selectedDate = _pickerStateDetails.selectedDate;
    _selectedDates =
        DateRangePickerHelper.cloneList(_pickerStateDetails.selectedDates);
    _selectedRange = _pickerStateDetails.selectedRange;
    _selectedRanges =
        DateRangePickerHelper.cloneList(_pickerStateDetails.selectedRanges);

    if (!isNeedSetState) {
      return;
    }

    setState(() {
      /// Update the state while selection notifier value and does not update
      /// the state while did update widget call this method.
    });
  }

  bool _isSelectedValueEquals() {
    switch (widget.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          return isSameDate(_selectedDate, _pickerStateDetails.selectedDate);
        }
      case DateRangePickerSelectionMode.multiple:
        {
          return DateRangePickerHelper.isDateCollectionEquals(
              _selectedDates, _pickerStateDetails.selectedDates);
        }
      case DateRangePickerSelectionMode.range:
        {
          return DateRangePickerHelper.isRangeEquals(
              _selectedRange, _pickerStateDetails.selectedRange);
        }
      case DateRangePickerSelectionMode.multiRange:
        {
          return DateRangePickerHelper.isDateRangesEquals(
              _selectedRanges, _pickerStateDetails.selectedRanges);
        }
    }
  }

  MultiChildRenderObjectWidget _getMonthRenderWidget() {
    switch (widget.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          return _MonthViewSingleSelectionRenderWidget(
              widget.visibleDates,
              widget.rowCount,
              widget.cellStyle,
              widget.selectionTextStyle,
              widget.rangeTextStyle,
              widget.selectionColor,
              widget.startRangeSelectionColor,
              widget.endRangeSelectionColor,
              widget.rangeSelectionColor,
              widget.datePickerTheme,
              widget.isRtl,
              widget.todayHighlightColor,
              widget.minDate,
              widget.maxDate,
              widget.enablePastDates,
              widget.showLeadingAndTailingDates,
              widget.blackoutDates,
              widget.specialDates,
              widget.weekendDays,
              widget.selectionShape,
              widget.selectionRadius,
              widget.mouseHoverPosition,
              widget.enableMultiView,
              widget.multiViewSpacing,
              widget.selectionNotifier,
              widget.textScaleFactor,
              widget.height,
              widget.width,
              _selectedDate,
              widget.isHijri,
              widget.localizations,
              widget.navigationDirection,
              widgets: _children);
        }
      case DateRangePickerSelectionMode.multiple:
        {
          return _MonthViewMultiSelectionRenderWidget(
              widget.visibleDates,
              widget.rowCount,
              widget.cellStyle,
              widget.selectionTextStyle,
              widget.rangeTextStyle,
              widget.selectionColor,
              widget.startRangeSelectionColor,
              widget.endRangeSelectionColor,
              widget.rangeSelectionColor,
              widget.datePickerTheme,
              widget.isRtl,
              widget.todayHighlightColor,
              widget.minDate,
              widget.maxDate,
              widget.enablePastDates,
              widget.showLeadingAndTailingDates,
              widget.blackoutDates,
              widget.specialDates,
              widget.weekendDays,
              widget.selectionShape,
              widget.selectionRadius,
              widget.mouseHoverPosition,
              widget.enableMultiView,
              widget.multiViewSpacing,
              widget.selectionNotifier,
              widget.textScaleFactor,
              widget.height,
              widget.width,
              _selectedDates,
              widget.isHijri,
              widget.localizations,
              widget.navigationDirection,
              widgets: _children);
        }
      case DateRangePickerSelectionMode.range:
        {
          return _MonthViewRangeSelectionRenderWidget(
              widget.visibleDates,
              widget.rowCount,
              widget.cellStyle,
              widget.selectionTextStyle,
              widget.rangeTextStyle,
              widget.selectionColor,
              widget.startRangeSelectionColor,
              widget.endRangeSelectionColor,
              widget.rangeSelectionColor,
              widget.datePickerTheme,
              widget.isRtl,
              widget.todayHighlightColor,
              widget.minDate,
              widget.maxDate,
              widget.enablePastDates,
              widget.showLeadingAndTailingDates,
              widget.blackoutDates,
              widget.specialDates,
              widget.weekendDays,
              widget.selectionShape,
              widget.selectionRadius,
              widget.mouseHoverPosition,
              widget.enableMultiView,
              widget.multiViewSpacing,
              widget.selectionNotifier,
              widget.textScaleFactor,
              widget.height,
              widget.width,
              _selectedRange,
              widget.isHijri,
              widget.localizations,
              widget.navigationDirection,
              widgets: _children);
        }
      case DateRangePickerSelectionMode.multiRange:
        {
          return _MonthViewMultiRangeSelectionRenderWidget(
              widget.visibleDates,
              widget.rowCount,
              widget.cellStyle,
              widget.selectionTextStyle,
              widget.rangeTextStyle,
              widget.selectionColor,
              widget.startRangeSelectionColor,
              widget.endRangeSelectionColor,
              widget.rangeSelectionColor,
              widget.datePickerTheme,
              widget.isRtl,
              widget.todayHighlightColor,
              widget.minDate,
              widget.maxDate,
              widget.enablePastDates,
              widget.showLeadingAndTailingDates,
              widget.blackoutDates,
              widget.specialDates,
              widget.weekendDays,
              widget.selectionShape,
              widget.selectionRadius,
              widget.mouseHoverPosition,
              widget.enableMultiView,
              widget.multiViewSpacing,
              widget.selectionNotifier,
              widget.textScaleFactor,
              widget.height,
              widget.width,
              _selectedRanges,
              widget.isHijri,
              widget.localizations,
              widget.navigationDirection,
              widgets: _children);
        }
    }
  }
}

class _MonthViewSingleSelectionRenderWidget
    extends MultiChildRenderObjectWidget {
  _MonthViewSingleSelectionRenderWidget(
      this.visibleDates,
      this.rowCount,
      this.cellStyle,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.datePickerTheme,
      this.isRtl,
      this.todayHighlightColor,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.showLeadingAndTailingDates,
      this.blackoutDates,
      this.specialDates,
      this.weekendDays,
      this.selectionShape,
      this.selectionRadius,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionNotifier,
      this.textScaleFactor,
      this.height,
      this.width,
      this.selectedDate,
      this.isHijri,
      this.localizations,
      this.navigationDirection,
      {List<Widget> widgets = const <Widget>[]})
      : super(children: widgets);

  final int rowCount;

  final dynamic cellStyle;

  final List<dynamic> visibleDates;

  final bool isRtl;

  final Color? todayHighlightColor;

  final SfDateRangePickerThemeData datePickerTheme;

  final dynamic minDate;

  final dynamic maxDate;

  final DateRangePickerNavigationDirection navigationDirection;

  final bool enablePastDates;

  final bool showLeadingAndTailingDates;

  final List<dynamic>? blackoutDates;

  final List<dynamic>? specialDates;

  final List<int> weekendDays;

  final DateRangePickerSelectionShape selectionShape;

  final double selectionRadius;

  final ValueNotifier<bool> selectionNotifier;

  final ValueNotifier<Offset?> mouseHoverPosition;

  final bool enableMultiView;

  final double multiViewSpacing;

  final TextStyle? selectionTextStyle;

  final TextStyle? rangeTextStyle;

  final Color? selectionColor;

  final Color? startRangeSelectionColor;

  final Color? endRangeSelectionColor;

  final Color? rangeSelectionColor;

  final double textScaleFactor;

  final double height;

  final double width;

  final dynamic selectedDate;

  final bool isHijri;

  final SfLocalizations localizations;

  @override
  _MonthViewSingleSelectionRenderObject createRenderObject(
      BuildContext context) {
    return _MonthViewSingleSelectionRenderObject(
        visibleDates,
        rowCount,
        cellStyle,
        selectionTextStyle,
        rangeTextStyle,
        selectionColor,
        startRangeSelectionColor,
        endRangeSelectionColor,
        rangeSelectionColor,
        datePickerTheme,
        isRtl,
        todayHighlightColor,
        minDate,
        maxDate,
        enablePastDates,
        showLeadingAndTailingDates,
        blackoutDates,
        specialDates,
        weekendDays,
        selectionShape,
        selectionRadius,
        mouseHoverPosition,
        enableMultiView,
        multiViewSpacing,
        selectionNotifier,
        textScaleFactor,
        height,
        width,
        isHijri,
        navigationDirection,
        localizations,
        selectedDate);
  }

  @override
  void updateRenderObject(BuildContext context,
      _MonthViewSingleSelectionRenderObject renderObject) {
    renderObject
      ..visibleDates = visibleDates
      ..rowCount = rowCount
      ..cellStyle = cellStyle
      ..selectionTextStyle = selectionTextStyle
      ..rangeTextStyle = rangeTextStyle
      ..selectionColor = selectionColor
      ..startRangeSelectionColor = startRangeSelectionColor
      ..endRangeSelectionColor = endRangeSelectionColor
      ..rangeSelectionColor = rangeSelectionColor
      ..datePickerTheme = datePickerTheme
      ..isRtl = isRtl
      ..todayHighlightColor = todayHighlightColor
      ..minDate = minDate
      ..maxDate = maxDate
      ..enablePastDates = enablePastDates
      ..showLeadingAndTailingDates = showLeadingAndTailingDates
      ..blackoutDates = blackoutDates
      ..specialDates = specialDates
      ..weekendDays = weekendDays
      ..selectionShape = selectionShape
      ..selectionRadius = selectionRadius
      ..mouseHoverPosition = mouseHoverPosition
      ..enableMultiView = enableMultiView
      ..multiViewSpacing = multiViewSpacing
      ..selectionNotifier = selectionNotifier
      ..textScaleFactor = textScaleFactor
      ..height = height
      ..width = width
      ..isHijri = isHijri
      ..localizations = localizations
      ..navigationDirection = navigationDirection
      ..selectedDate = selectedDate;
  }
}

class _MonthViewMultiSelectionRenderWidget
    extends MultiChildRenderObjectWidget {
  _MonthViewMultiSelectionRenderWidget(
      this.visibleDates,
      this.rowCount,
      this.cellStyle,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.datePickerTheme,
      this.isRtl,
      this.todayHighlightColor,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.showLeadingAndTailingDates,
      this.blackoutDates,
      this.specialDates,
      this.weekendDays,
      this.selectionShape,
      this.selectionRadius,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionNotifier,
      this.textScaleFactor,
      this.height,
      this.width,
      this.selectedDates,
      this.isHijri,
      this.localizations,
      this.navigationDirection,
      {List<Widget> widgets = const <Widget>[]})
      : super(children: widgets);

  final int rowCount;

  final dynamic cellStyle;

  final List<dynamic> visibleDates;

  final bool isRtl;

  final Color? todayHighlightColor;

  final SfDateRangePickerThemeData datePickerTheme;

  final dynamic minDate;

  final dynamic maxDate;

  final DateRangePickerNavigationDirection navigationDirection;

  final bool enablePastDates;

  final bool showLeadingAndTailingDates;

  final List<dynamic>? blackoutDates;

  final List<dynamic>? specialDates;

  final List<int> weekendDays;

  final DateRangePickerSelectionShape selectionShape;

  final double selectionRadius;

  final ValueNotifier<bool> selectionNotifier;

  final ValueNotifier<Offset?> mouseHoverPosition;

  final bool enableMultiView;

  final double multiViewSpacing;

  final TextStyle? selectionTextStyle;

  final TextStyle? rangeTextStyle;

  final Color? selectionColor;

  final Color? startRangeSelectionColor;

  final Color? endRangeSelectionColor;

  final Color? rangeSelectionColor;

  final double textScaleFactor;

  final double height;

  final double width;

  final List<dynamic>? selectedDates;

  final bool isHijri;

  final SfLocalizations localizations;

  @override
  _MonthViewMultiSelectionRenderObject createRenderObject(
      BuildContext context) {
    return _MonthViewMultiSelectionRenderObject(
        visibleDates,
        rowCount,
        cellStyle,
        selectionTextStyle,
        rangeTextStyle,
        selectionColor,
        startRangeSelectionColor,
        endRangeSelectionColor,
        rangeSelectionColor,
        datePickerTheme,
        isRtl,
        todayHighlightColor,
        minDate,
        maxDate,
        enablePastDates,
        showLeadingAndTailingDates,
        blackoutDates,
        specialDates,
        weekendDays,
        selectionShape,
        selectionRadius,
        mouseHoverPosition,
        enableMultiView,
        multiViewSpacing,
        selectionNotifier,
        textScaleFactor,
        height,
        width,
        isHijri,
        navigationDirection,
        localizations,
        selectedDates);
  }

  @override
  void updateRenderObject(
      BuildContext context, _MonthViewMultiSelectionRenderObject renderObject) {
    renderObject
      ..visibleDates = visibleDates
      ..rowCount = rowCount
      ..cellStyle = cellStyle
      ..selectionTextStyle = selectionTextStyle
      ..rangeTextStyle = rangeTextStyle
      ..selectionColor = selectionColor
      ..startRangeSelectionColor = startRangeSelectionColor
      ..endRangeSelectionColor = endRangeSelectionColor
      ..rangeSelectionColor = rangeSelectionColor
      ..datePickerTheme = datePickerTheme
      ..isRtl = isRtl
      ..todayHighlightColor = todayHighlightColor
      ..minDate = minDate
      ..maxDate = maxDate
      ..enablePastDates = enablePastDates
      ..showLeadingAndTailingDates = showLeadingAndTailingDates
      ..blackoutDates = blackoutDates
      ..specialDates = specialDates
      ..weekendDays = weekendDays
      ..selectionShape = selectionShape
      ..selectionRadius = selectionRadius
      ..mouseHoverPosition = mouseHoverPosition
      ..enableMultiView = enableMultiView
      ..multiViewSpacing = multiViewSpacing
      ..selectionNotifier = selectionNotifier
      ..textScaleFactor = textScaleFactor
      ..height = height
      ..width = width
      ..isHijri = isHijri
      ..localizations = localizations
      ..navigationDirection = navigationDirection
      ..selectedDates = selectedDates;
  }
}

class _MonthViewRangeSelectionRenderWidget
    extends MultiChildRenderObjectWidget {
  _MonthViewRangeSelectionRenderWidget(
      this.visibleDates,
      this.rowCount,
      this.cellStyle,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.datePickerTheme,
      this.isRtl,
      this.todayHighlightColor,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.showLeadingAndTailingDates,
      this.blackoutDates,
      this.specialDates,
      this.weekendDays,
      this.selectionShape,
      this.selectionRadius,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionNotifier,
      this.textScaleFactor,
      this.height,
      this.width,
      this.selectedRange,
      this.isHijri,
      this.localizations,
      this.navigationDirection,
      {required List<Widget> widgets})
      : super(children: widgets);

  final int rowCount;

  final dynamic cellStyle;

  final List<dynamic> visibleDates;

  final bool isRtl;

  final Color? todayHighlightColor;

  final SfDateRangePickerThemeData datePickerTheme;

  final dynamic minDate;

  final dynamic maxDate;

  final DateRangePickerNavigationDirection navigationDirection;

  final bool enablePastDates;

  final bool showLeadingAndTailingDates;

  final List<dynamic>? blackoutDates;

  final List<dynamic>? specialDates;

  final List<int> weekendDays;

  final DateRangePickerSelectionShape selectionShape;

  final double selectionRadius;

  final ValueNotifier<bool> selectionNotifier;

  final ValueNotifier<Offset?> mouseHoverPosition;

  final bool enableMultiView;

  final double multiViewSpacing;

  final TextStyle? selectionTextStyle;

  final TextStyle? rangeTextStyle;

  final Color? selectionColor;

  final Color? startRangeSelectionColor;

  final Color? endRangeSelectionColor;

  final Color? rangeSelectionColor;

  final double textScaleFactor;

  final double height;

  final double width;

  final dynamic? selectedRange;

  final bool isHijri;

  final SfLocalizations localizations;

  @override
  _MonthViewRangeSelectionRenderObject createRenderObject(
      BuildContext context) {
    return _MonthViewRangeSelectionRenderObject(
        visibleDates,
        rowCount,
        cellStyle,
        selectionTextStyle,
        rangeTextStyle,
        selectionColor,
        startRangeSelectionColor,
        endRangeSelectionColor,
        rangeSelectionColor,
        datePickerTheme,
        isRtl,
        todayHighlightColor,
        minDate,
        maxDate,
        enablePastDates,
        showLeadingAndTailingDates,
        blackoutDates,
        specialDates,
        weekendDays,
        selectionShape,
        selectionRadius,
        mouseHoverPosition,
        enableMultiView,
        multiViewSpacing,
        selectionNotifier,
        textScaleFactor,
        height,
        width,
        isHijri,
        navigationDirection,
        localizations,
        selectedRange);
  }

  @override
  void updateRenderObject(
      BuildContext context, _MonthViewRangeSelectionRenderObject renderObject) {
    renderObject
      ..visibleDates = visibleDates
      ..rowCount = rowCount
      ..cellStyle = cellStyle
      ..selectionTextStyle = selectionTextStyle
      ..rangeTextStyle = rangeTextStyle
      ..selectionColor = selectionColor
      ..startRangeSelectionColor = startRangeSelectionColor
      ..endRangeSelectionColor = endRangeSelectionColor
      ..rangeSelectionColor = rangeSelectionColor
      ..datePickerTheme = datePickerTheme
      ..isRtl = isRtl
      ..todayHighlightColor = todayHighlightColor
      ..minDate = minDate
      ..maxDate = maxDate
      ..enablePastDates = enablePastDates
      ..showLeadingAndTailingDates = showLeadingAndTailingDates
      ..blackoutDates = blackoutDates
      ..specialDates = specialDates
      ..weekendDays = weekendDays
      ..selectionShape = selectionShape
      ..selectionRadius = selectionRadius
      ..mouseHoverPosition = mouseHoverPosition
      ..enableMultiView = enableMultiView
      ..multiViewSpacing = multiViewSpacing
      ..selectionNotifier = selectionNotifier
      ..textScaleFactor = textScaleFactor
      ..height = height
      ..width = width
      ..isHijri = isHijri
      ..localizations = localizations
      ..navigationDirection = navigationDirection
      ..selectedRange = selectedRange;
  }
}

class _MonthViewMultiRangeSelectionRenderWidget
    extends MultiChildRenderObjectWidget {
  _MonthViewMultiRangeSelectionRenderWidget(
      this.visibleDates,
      this.rowCount,
      this.cellStyle,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.datePickerTheme,
      this.isRtl,
      this.todayHighlightColor,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.showLeadingAndTailingDates,
      this.blackoutDates,
      this.specialDates,
      this.weekendDays,
      this.selectionShape,
      this.selectionRadius,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionNotifier,
      this.textScaleFactor,
      this.height,
      this.width,
      this.selectedRanges,
      this.isHijri,
      this.localizations,
      this.navigationDirection,
      {required List<Widget> widgets})
      : super(children: widgets);

  final int rowCount;

  final dynamic cellStyle;

  final List<dynamic> visibleDates;

  final bool isRtl;

  final Color? todayHighlightColor;

  final SfDateRangePickerThemeData datePickerTheme;

  final dynamic minDate;

  final dynamic maxDate;

  final bool enablePastDates;

  final bool showLeadingAndTailingDates;

  final List<dynamic>? blackoutDates;

  final List<dynamic>? specialDates;

  final List<int> weekendDays;

  final DateRangePickerSelectionShape selectionShape;

  final double selectionRadius;

  final ValueNotifier<bool> selectionNotifier;

  final ValueNotifier<Offset?> mouseHoverPosition;

  final bool enableMultiView;

  final double multiViewSpacing;

  final TextStyle? selectionTextStyle;

  final TextStyle? rangeTextStyle;

  final Color? selectionColor;

  final Color? startRangeSelectionColor;

  final Color? endRangeSelectionColor;

  final Color? rangeSelectionColor;

  final double textScaleFactor;

  final double height;

  final double width;

  final List<dynamic>? selectedRanges;

  final bool isHijri;

  final SfLocalizations localizations;

  final DateRangePickerNavigationDirection navigationDirection;

  @override
  _MonthViewMultiRangeSelectionRenderObject createRenderObject(
      BuildContext context) {
    return _MonthViewMultiRangeSelectionRenderObject(
        visibleDates,
        rowCount,
        cellStyle,
        selectionTextStyle,
        rangeTextStyle,
        selectionColor,
        startRangeSelectionColor,
        endRangeSelectionColor,
        rangeSelectionColor,
        datePickerTheme,
        isRtl,
        todayHighlightColor,
        minDate,
        maxDate,
        enablePastDates,
        showLeadingAndTailingDates,
        blackoutDates,
        specialDates,
        weekendDays,
        selectionShape,
        selectionRadius,
        mouseHoverPosition,
        enableMultiView,
        multiViewSpacing,
        selectionNotifier,
        textScaleFactor,
        height,
        width,
        isHijri,
        navigationDirection,
        localizations,
        selectedRanges);
  }

  @override
  void updateRenderObject(BuildContext context,
      _MonthViewMultiRangeSelectionRenderObject renderObject) {
    renderObject
      ..visibleDates = visibleDates
      ..rowCount = rowCount
      ..cellStyle = cellStyle
      ..selectionTextStyle = selectionTextStyle
      ..rangeTextStyle = rangeTextStyle
      ..selectionColor = selectionColor
      ..startRangeSelectionColor = startRangeSelectionColor
      ..endRangeSelectionColor = endRangeSelectionColor
      ..rangeSelectionColor = rangeSelectionColor
      ..datePickerTheme = datePickerTheme
      ..isRtl = isRtl
      ..todayHighlightColor = todayHighlightColor
      ..minDate = minDate
      ..maxDate = maxDate
      ..enablePastDates = enablePastDates
      ..showLeadingAndTailingDates = showLeadingAndTailingDates
      ..blackoutDates = blackoutDates
      ..specialDates = specialDates
      ..weekendDays = weekendDays
      ..selectionShape = selectionShape
      ..selectionRadius = selectionRadius
      ..mouseHoverPosition = mouseHoverPosition
      ..enableMultiView = enableMultiView
      ..multiViewSpacing = multiViewSpacing
      ..selectionNotifier = selectionNotifier
      ..textScaleFactor = textScaleFactor
      ..height = height
      ..width = width
      ..isHijri = isHijri
      ..localizations = localizations
      ..navigationDirection = navigationDirection
      ..selectedRanges = selectedRanges;
  }
}

class _DatePickerParentData extends ContainerBoxParentData<RenderBox> {}

abstract class _IMonthView extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _DatePickerParentData> {
  _IMonthView(
      this._visibleDates,
      this._rowCount,
      this._cellStyle,
      this._selectionTextStyle,
      this._rangeTextStyle,
      this._selectionColor,
      this._startRangeSelectionColor,
      this._endRangeSelectionColor,
      this._rangeSelectionColor,
      this._datePickerTheme,
      this._isRtl,
      this._todayHighlightColor,
      this._minDate,
      this._maxDate,
      this._enablePastDates,
      this._showLeadingAndTailingDates,
      this._blackoutDates,
      this._specialDates,
      this._weekendDays,
      this._selectionShape,
      this._selectionRadius,
      this._mouseHoverPosition,
      this._enableMultiView,
      this._multiViewSpacing,
      this.selectionNotifier,
      this._textScaleFactor,
      this._height,
      this._width,
      this._isHijri,
      this._navigationDirection,
      this.localizations);

  DateRangePickerNavigationDirection _navigationDirection;

  DateRangePickerNavigationDirection get navigationDirection =>
      _navigationDirection;

  set navigationDirection(DateRangePickerNavigationDirection value) {
    if (_navigationDirection == value) {
      return;
    }

    _navigationDirection = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// Defines the month row count.
  int _rowCount;

  int get rowCount => _rowCount;

  set rowCount(int value) {
    if (_rowCount == value) {
      return;
    }

    _rowCount = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// Holds the visible dates for the month view.
  List<dynamic> _visibleDates;

  List<dynamic> get visibleDates => _visibleDates;

  set visibleDates(List<dynamic> value) {
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

  /// Defines the month cell style.
  dynamic? _cellStyle;

  dynamic? get cellStyle => _cellStyle;

  set cellStyle(dynamic? value) {
    if (_cellStyle == value) {
      return;
    }

    _cellStyle = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  /// Used to identify the widget direction is RTL.
  bool _isRtl;

  bool get isRtl => _isRtl;

  set isRtl(bool value) {
    if (_isRtl == value) {
      return;
    }

    _isRtl = value;
    markNeedsPaint();
  }

  /// Defines the today cell highlight color.
  Color? _todayHighlightColor;

  Color? get todayHighlightColor => _todayHighlightColor;

  set todayHighlightColor(Color? value) {
    if (_todayHighlightColor == value) {
      return;
    }

    _todayHighlightColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  /// Holds the theme data for date range picker.
  SfDateRangePickerThemeData _datePickerTheme;

  SfDateRangePickerThemeData get datePickerTheme => _datePickerTheme;

  set datePickerTheme(SfDateRangePickerThemeData value) {
    if (_datePickerTheme == value) {
      return;
    }

    _datePickerTheme = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  /// The minimum date as much as the [SfDateRangePicker] will navigate.
  dynamic _minDate;

  dynamic get minDate => _minDate;

  set minDate(dynamic value) {
    if (_minDate == value) {
      return;
    }

    _minDate = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// The maximum date as much as the [SfDateRangePicker] will navigate.
  dynamic _maxDate;

  dynamic get maxDate => _maxDate;

  set maxDate(dynamic value) {
    if (_maxDate == value) {
      return;
    }

    _maxDate = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// Decides to enable past dates or not.
  bool _enablePastDates;

  bool get enablePastDates => _enablePastDates;

  set enablePastDates(bool value) {
    if (_enablePastDates == value) {
      return;
    }

    _enablePastDates = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// Decides the trailing and leading of month view will visible or not.
  bool _showLeadingAndTailingDates;

  bool get showLeadingAndTailingDates => _showLeadingAndTailingDates;

  set showLeadingAndTailingDates(bool value) {
    if (_showLeadingAndTailingDates == value) {
      return;
    }

    _showLeadingAndTailingDates = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// Holds the blackout dates of the [SfDateRangePicker].
  List<dynamic>? _blackoutDates;

  List<dynamic>? get blackoutDates => _blackoutDates;

  set blackoutDates(List<dynamic>? value) {
    if (DateRangePickerHelper.isDateCollectionEquals(_blackoutDates, value)) {
      return;
    }

    _blackoutDates = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// Holds the special dates of the [SfDateRangePicker].
  List<dynamic>? _specialDates;

  List<dynamic>? get specialDates => _specialDates;

  set specialDates(List<dynamic>? value) {
    if (DateRangePickerHelper.isDateCollectionEquals(_specialDates, value)) {
      return;
    }

    _specialDates = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// Holds the list of week day index of the [SfDateRangePicker].
  List<int> _weekendDays;

  List<int> get weekendDays => _weekendDays;

  set weekendDays(List<int> value) {
    if (_weekendDays == value) {
      return;
    }

    _weekendDays = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  /// Decides the month cell highlight and selection shape.
  DateRangePickerSelectionShape _selectionShape;

  DateRangePickerSelectionShape get selectionShape => _selectionShape;

  set selectionShape(DateRangePickerSelectionShape value) {
    if (_selectionShape == value) {
      return;
    }

    _selectionShape = value;
    markNeedsPaint();
  }

  /// Holds the selection radius of the month cell.
  double _selectionRadius;

  double get selectionRadius => _selectionRadius;

  set selectionRadius(double value) {
    if (_selectionRadius == value) {
      return;
    }

    _selectionRadius = value;
    markNeedsPaint();
  }

  /// Used to call repaint when the selection changes.
  ValueNotifier<bool> selectionNotifier;

  /// Used to specify the mouse hover position of the month view.
  ValueNotifier<Offset?> _mouseHoverPosition;

  ValueNotifier<Offset?> get mouseHoverPosition => _mouseHoverPosition;

  set mouseHoverPosition(ValueNotifier<Offset?> value) {
    if (_mouseHoverPosition == value) {
      return;
    }

    _mouseHoverPosition.removeListener(markNeedsPaint);
    _mouseHoverPosition = value;
    _mouseHoverPosition.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  /// Decides to show the multi view of month view or not.
  bool _enableMultiView;

  bool get enableMultiView => _enableMultiView;

  set enableMultiView(bool value) {
    if (_enableMultiView == value) {
      return;
    }

    _enableMultiView = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// Specifies the space between the multi month views.
  double _multiViewSpacing;

  double get multiViewSpacing => _multiViewSpacing;

  set multiViewSpacing(double value) {
    if (_multiViewSpacing == value) {
      return;
    }

    _multiViewSpacing = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  /// Defines the text style for selected month cell.
  TextStyle? _selectionTextStyle;

  TextStyle? get selectionTextStyle => _selectionTextStyle;

  set selectionTextStyle(TextStyle? value) {
    if (_selectionTextStyle == value) {
      return;
    }

    _selectionTextStyle = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  /// Defines the range text style for selected range month cell.
  TextStyle? _rangeTextStyle;

  TextStyle? get rangeTextStyle => _rangeTextStyle;

  set rangeTextStyle(TextStyle? value) {
    if (_rangeTextStyle == value) {
      return;
    }

    _rangeTextStyle = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  /// Defines the background color for selected month cell.
  Color? _selectionColor;

  Color? get selectionColor => _selectionColor;

  set selectionColor(Color? value) {
    if (_selectionColor == value) {
      return;
    }

    _selectionColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  /// Defines the background color for selected range start date month cell.
  Color? _startRangeSelectionColor;

  Color? get startRangeSelectionColor => _startRangeSelectionColor;

  set startRangeSelectionColor(Color? value) {
    if (_startRangeSelectionColor == value) {
      return;
    }

    _startRangeSelectionColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  /// Defines the background color for selected range end date month cell.
  Color? _endRangeSelectionColor;

  Color? get endRangeSelectionColor => _endRangeSelectionColor;

  set endRangeSelectionColor(Color? value) {
    if (_endRangeSelectionColor == value) {
      return;
    }

    _endRangeSelectionColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  /// Defines the background color for selected range in between dates cell.
  Color? _rangeSelectionColor;

  Color? get rangeSelectionColor => _rangeSelectionColor;

  set rangeSelectionColor(Color? value) {
    if (_rangeSelectionColor == value) {
      return;
    }

    _rangeSelectionColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  /// Defines the text scale factor of [SfDateRangePicker].
  double _textScaleFactor;

  double get textScaleFactor => _textScaleFactor;

  set textScaleFactor(double value) {
    if (_textScaleFactor == value) {
      return;
    }

    _textScaleFactor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  double _height;

  double get height => _height;

  set height(double value) {
    if (_height == value) {
      return;
    }

    _height = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  double _width;

  double get width => _width;

  set width(double value) {
    if (_width == value) {
      return;
    }

    _width = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  bool _isHijri;

  bool get isHijri => _isHijri;

  set isHijri(bool value) {
    if (_isHijri == value) {
      return;
    }

    _isHijri = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  SfLocalizations localizations;

  /// Used to paint the selection of month cell on all the selection mode.
  Paint _selectionPainter = Paint();

  /// Used to draw month cell text in month view.
  TextPainter _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine);

  static const int _selectionPadding = 2;

  /// Caches [SemanticsNode]s created during [assembleSemanticsNode] so they
  /// can be re-used when [assembleSemanticsNode] is called again. This ensures
  /// stable ids for the [SemanticsNode]s of children across
  /// [assembleSemanticsNode] invocations.
  /// Ref: assembleSemanticsNode method in RenderParagraph class
  /// (https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/rendering/paragraph.dart)
  List<SemanticsNode>? _cacheNodes;

  late double _cellWidth, _cellHeight;
  late double _centerXPosition, _centerYPosition;

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _mouseHoverPosition.addListener(markNeedsPaint);
  }

  /// detach will called when the render object removed from view.
  @override
  void detach() {
    _mouseHoverPosition.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! _DatePickerParentData) {
      child.parentData = _DatePickerParentData();
    }
  }

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? height : widgetSize.height);
    RenderBox? child = firstChild;
    if (child == null) {
      return;
    }

    double currentWidth = size.width;
    double currentHeight = size.height;
    if (_enableMultiView) {
      if (_navigationDirection ==
          DateRangePickerNavigationDirection.horizontal) {
        currentWidth = (currentWidth - multiViewSpacing) / 2;
      } else {
        currentHeight = (currentHeight - multiViewSpacing) / 2;
      }
    }

    final double cellWidth = currentWidth / DateTime.daysPerWeek;
    final double cellHeight = currentHeight / rowCount;
    while (child != null) {
      child.layout(constraints.copyWith(
          minHeight: cellHeight,
          maxHeight: cellHeight,
          minWidth: cellWidth,
          maxWidth: cellWidth));
      child = childAfter(child);
    }
  }

  /// Update the selection details(date, dates, range, ranges) based on
  /// [SfDateRangePicker] selection mode.
  void updateSelection(PickerStateArgs details);

  /// Return the list of selected index based on it selection mode
  /// value(date, dates, range, ranges).
  List<int> getSelectedIndexValues(int viewStartIndex, int viewEndIndex);

  /// Draw the highlight for selected month cell based on it selection mode
  /// value(date, dates, range, ranges).
  TextStyle drawSelection(Canvas canvas, double x, double y, int index,
      TextStyle selectionTextStyle, TextStyle selectionRangeTextStyle);

  /// Draw the highlight for selected month cell based on it selection mode
  /// value(date, dates, range, ranges) when the month cell have custom widget.
  void drawCustomCellSelection(Canvas canvas, double x, double y, int index);

  @override
  void paint(PaintingContext context, Offset offset);

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

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    return;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    double left, top;
    Map<String, double> leftAndTopValue;
    double webUIPadding = 0;
    double width = size.width;
    double height = size.height;
    int viewCount = 1;
    final bool isHorizontalMultiView = _enableMultiView &&
        _navigationDirection == DateRangePickerNavigationDirection.horizontal;
    final bool isVerticalMultiView = _enableMultiView &&
        _navigationDirection == DateRangePickerNavigationDirection.vertical;

    if (isHorizontalMultiView) {
      webUIPadding = _multiViewSpacing;
      viewCount = 2;
      width = (width - webUIPadding) / viewCount;
    } else if (isVerticalMultiView) {
      webUIPadding = _multiViewSpacing;
      viewCount = 2;
      height = (height - webUIPadding) / viewCount;
    }

    final double cellWidth = width / DateTime.daysPerWeek;
    final double cellHeight = height / rowCount;
    final int datesCount = _visibleDates.length ~/ viewCount;
    for (int j = 0; j < viewCount; j++) {
      final int currentViewIndex =
          _isRtl ? DateRangePickerHelper.getRtlIndex(viewCount, j) : j;
      left = _isRtl ? width - cellWidth : 0;
      top = 0;
      final dynamic middleDate =
          _visibleDates[(j * datesCount) + (datesCount ~/ 2)];
      final double viewXStartPosition = isVerticalMultiView
          ? 0
          : (currentViewIndex * width) + (currentViewIndex * _multiViewSpacing);
      final double viewYStartPosition = isHorizontalMultiView
          ? 0
          : (currentViewIndex * height) +
              (currentViewIndex * _multiViewSpacing);
      for (int i = 0; i < datesCount; i++) {
        final dynamic currentDate = _visibleDates[(j * datesCount) + i];
        if (!DateRangePickerHelper.isDateAsCurrentMonthDate(middleDate,
            _rowCount, _showLeadingAndTailingDates, currentDate, _isHijri)) {
          leftAndTopValue = DateRangePickerHelper.getTopAndLeftValues(
              _isRtl, left, top, cellWidth, cellHeight, width);
          left = leftAndTopValue['left']!;
          top = leftAndTopValue['top']!;
          continue;
        } else if (DateRangePickerHelper.isDateWithInVisibleDates(
            _visibleDates, _blackoutDates, currentDate)) {
          semanticsBuilder.add(CustomPainterSemantics(
            rect: Rect.fromLTWH(viewXStartPosition + left,
                viewYStartPosition + top, cellWidth, cellHeight),
            properties: SemanticsProperties(
              label: _getSemanticMonthLabel(currentDate) + ', Blackout date',
              textDirection: TextDirection.ltr,
            ),
          ));
          leftAndTopValue = DateRangePickerHelper.getTopAndLeftValues(
              _isRtl, left, top, cellWidth, cellHeight, width);
          left = leftAndTopValue['left']!;
          top = leftAndTopValue['top']!;
          continue;
        } else if (!DateRangePickerHelper.isEnabledDate(
            _minDate, _maxDate, _enablePastDates, currentDate, _isHijri)) {
          semanticsBuilder.add(CustomPainterSemantics(
            rect: Rect.fromLTWH(viewXStartPosition + left,
                viewYStartPosition + top, cellWidth, cellHeight),
            properties: SemanticsProperties(
              label: _getSemanticMonthLabel(currentDate) + ', Disabled date',
              textDirection: TextDirection.ltr,
            ),
          ));
          leftAndTopValue = DateRangePickerHelper.getTopAndLeftValues(
              _isRtl, left, top, cellWidth, cellHeight, width);
          left = leftAndTopValue['left']!;
          top = leftAndTopValue['top']!;
          continue;
        }
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(viewXStartPosition + left,
              viewYStartPosition + top, cellWidth, cellHeight),
          properties: SemanticsProperties(
            label: _getSemanticMonthLabel(currentDate),
            textDirection: TextDirection.ltr,
          ),
        ));
        leftAndTopValue = DateRangePickerHelper.getTopAndLeftValues(
            _isRtl, left, top, cellWidth, cellHeight, width);
        left = leftAndTopValue['left']!;
        top = leftAndTopValue['top']!;
      }
    }

    return semanticsBuilder;
  }

  ///  Returns the accessibility text for the month cell.
  String _getSemanticMonthLabel(dynamic date) {
    if (_isHijri) {
      return DateFormat('EEE').format(date.toDateTime()).toString() +
          ',' +
          date.day.toString() +
          '/' +
          DateRangePickerHelper.getHijriMonthText(date, localizations, 'MMMM') +
          '/' +
          date.year.toString();
    } else {
      return DateFormat('EEE, dd/MMMM/yyyy').format(date).toString();
    }
  }
}

class _MonthViewSingleSelectionRenderObject extends _IMonthView {
  _MonthViewSingleSelectionRenderObject(
      List<dynamic> visibleDates,
      int rowCount,
      dynamic cellStyle,
      TextStyle? selectionTextStyle,
      TextStyle? rangeTextStyle,
      Color? selectionColor,
      Color? startRangeSelectionColor,
      Color? endRangeSelectionColor,
      Color? rangeSelectionColor,
      SfDateRangePickerThemeData datePickerTheme,
      bool isRtl,
      Color? todayHighlightColor,
      dynamic minDate,
      dynamic maxDate,
      bool enablePastDates,
      bool showLeadingAndTailingDates,
      List<dynamic>? blackoutDates,
      List<dynamic>? specialDates,
      List<int> weekendDays,
      DateRangePickerSelectionShape selectionShape,
      double selectionRadius,
      ValueNotifier<Offset?> mouseHoverPosition,
      bool enableMultiView,
      double multiViewSpacing,
      ValueNotifier<bool> selectionNotifier,
      double textScaleFactor,
      double height,
      double width,
      bool isHijri,
      DateRangePickerNavigationDirection navigationDirection,
      SfLocalizations localizations,
      this._selectedDate)
      : super(
            visibleDates,
            rowCount,
            cellStyle,
            selectionTextStyle,
            rangeTextStyle,
            selectionColor,
            startRangeSelectionColor,
            endRangeSelectionColor,
            rangeSelectionColor,
            datePickerTheme,
            isRtl,
            todayHighlightColor,
            minDate,
            maxDate,
            enablePastDates,
            showLeadingAndTailingDates,
            blackoutDates,
            specialDates,
            weekendDays,
            selectionShape,
            selectionRadius,
            mouseHoverPosition,
            enableMultiView,
            multiViewSpacing,
            selectionNotifier,
            textScaleFactor,
            height,
            width,
            isHijri,
            navigationDirection,
            localizations);

  dynamic? _selectedDate;

  dynamic get selectedDate => _selectedDate;

  set selectedDate(dynamic value) {
    if (isSameDate(_selectedDate, value)) {
      return;
    }

    _selectedDate = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _cellWidth = size.width / DateTime.daysPerWeek;
    _cellHeight = size.height / rowCount;
    if (enableMultiView) {
      switch (_navigationDirection) {
        case DateRangePickerNavigationDirection.horizontal:
          {
            _cellWidth =
                (size.width - _multiViewSpacing) / (DateTime.daysPerWeek * 2);
          }
          break;
        case DateRangePickerNavigationDirection.vertical:
          {
            _cellHeight = (size.height - _multiViewSpacing) / (2 * rowCount);
          }
      }
    }

    _centerXPosition = _cellWidth / 2;
    _centerYPosition = _cellHeight / 2;
    _drawMonthCellsAndSelection(context, size, this, _cellWidth, _cellHeight);
  }

  @override
  TextStyle drawSelection(Canvas canvas, double x, double y, int index,
      TextStyle selectionTextStyle, TextStyle selectionRangeTextStyle) {
    _selectionPainter.isAntiAlias = true;
    switch (selectionShape) {
      case DateRangePickerSelectionShape.circle:
        {
          final double radius = _getCellRadius(
              selectionRadius, _centerXPosition, _centerYPosition);
          _drawCircleSelection(canvas, x + _centerXPosition,
              y + _centerYPosition, radius, _selectionPainter);
        }
        break;
      case DateRangePickerSelectionShape.rectangle:
        {
          _drawFillSelection(
              canvas, x, y, _cellWidth, _cellHeight, _selectionPainter);
        }
    }

    return selectionTextStyle;
  }

  @override
  void drawCustomCellSelection(Canvas canvas, double x, double y, int index) {
    _selectionPainter.color = selectionColor ?? datePickerTheme.selectionColor!;
    _selectionPainter.strokeWidth = 0.0;
    _selectionPainter.style = PaintingStyle.fill;
    _selectionPainter.isAntiAlias = true;
    canvas.drawRect(Rect.fromLTRB(x, y, x + _cellWidth, y + _cellHeight),
        _selectionPainter);
  }

  @override
  List<int> getSelectedIndexValues(int viewStartIndex, int viewEndIndex) {
    final List<int> selectedIndex = <int>[];
    if (selectedDate != null) {
      if (isDateWithInDateRange(visibleDates[viewStartIndex],
          visibleDates[viewEndIndex], selectedDate)) {
        final int index = _getSelectedIndex(selectedDate, visibleDates,
            viewStartIndex: viewStartIndex);
        selectedIndex.add(index);
      }
    }

    return selectedIndex;
  }

  @override
  void updateSelection(PickerStateArgs details) {
    if (isSameDate(details.selectedDate, selectedDate)) {
      return;
    }

    selectedDate = details.selectedDate;
    selectionNotifier.value = !selectionNotifier.value;
  }
}

class _MonthViewMultiSelectionRenderObject extends _IMonthView {
  _MonthViewMultiSelectionRenderObject(
      List<dynamic> visibleDates,
      int rowCount,
      dynamic cellStyle,
      TextStyle? selectionTextStyle,
      TextStyle? rangeTextStyle,
      Color? selectionColor,
      Color? startRangeSelectionColor,
      Color? endRangeSelectionColor,
      Color? rangeSelectionColor,
      SfDateRangePickerThemeData datePickerTheme,
      bool isRtl,
      Color? todayHighlightColor,
      dynamic minDate,
      dynamic maxDate,
      bool enablePastDates,
      bool showLeadingAndTailingDates,
      List<dynamic>? blackoutDates,
      List<dynamic>? specialDates,
      List<int> weekendDays,
      DateRangePickerSelectionShape selectionShape,
      double selectionRadius,
      ValueNotifier<Offset?> mouseHoverPosition,
      bool enableMultiView,
      double multiViewSpacing,
      ValueNotifier<bool> selectionNotifier,
      double textScaleFactor,
      double height,
      double width,
      bool isHijri,
      DateRangePickerNavigationDirection navigationDirection,
      SfLocalizations localizations,
      this._selectedDates)
      : super(
            visibleDates,
            rowCount,
            cellStyle,
            selectionTextStyle,
            rangeTextStyle,
            selectionColor,
            startRangeSelectionColor,
            endRangeSelectionColor,
            rangeSelectionColor,
            datePickerTheme,
            isRtl,
            todayHighlightColor,
            minDate,
            maxDate,
            enablePastDates,
            showLeadingAndTailingDates,
            blackoutDates,
            specialDates,
            weekendDays,
            selectionShape,
            selectionRadius,
            mouseHoverPosition,
            enableMultiView,
            multiViewSpacing,
            selectionNotifier,
            textScaleFactor,
            height,
            width,
            isHijri,
            navigationDirection,
            localizations);

  List<dynamic>? _selectedDates;

  List<dynamic>? get selectedDates => _selectedDates;

  set selectedDates(List<dynamic>? value) {
    if (DateRangePickerHelper.isDateCollectionEquals(_selectedDates, value)) {
      return;
    }

    _selectedDates = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  @override
  TextStyle drawSelection(Canvas canvas, double x, double y, int index,
      TextStyle selectionTextStyle, TextStyle selectionRangeTextStyle) {
    _selectionPainter.isAntiAlias = true;
    switch (selectionShape) {
      case DateRangePickerSelectionShape.circle:
        {
          final double radius = _getCellRadius(
              selectionRadius, _centerXPosition, _centerYPosition);
          _drawCircleSelection(canvas, x + _centerXPosition,
              y + _centerYPosition, radius, _selectionPainter);
        }
        break;
      case DateRangePickerSelectionShape.rectangle:
        {
          _drawFillSelection(
              canvas, x, y, _cellWidth, _cellHeight, _selectionPainter);
        }
    }

    return selectionTextStyle;
  }

  @override
  void drawCustomCellSelection(Canvas canvas, double x, double y, int index) {
    _selectionPainter.color = selectionColor ?? datePickerTheme.selectionColor!;
    _selectionPainter.strokeWidth = 0.0;
    _selectionPainter.style = PaintingStyle.fill;
    _selectionPainter.isAntiAlias = true;
    canvas.drawRect(Rect.fromLTRB(x, y, x + _cellWidth, y + _cellHeight),
        _selectionPainter);
  }

  @override
  List<int> getSelectedIndexValues(int viewStartIndex, int viewEndIndex) {
    final List<int> selectedIndex = <int>[];
    if (selectedDates != null) {
      for (int j = 0; j < selectedDates!.length; j++) {
        final dynamic date = selectedDates![j];
        if (!isDateWithInDateRange(
            visibleDates[viewStartIndex], visibleDates[viewEndIndex], date)) {
          continue;
        }

        selectedIndex.add(_getSelectedIndex(date, visibleDates,
            viewStartIndex: viewStartIndex));
      }
    }

    return selectedIndex;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _cellWidth = size.width / DateTime.daysPerWeek;
    _cellHeight = size.height / rowCount;
    if (enableMultiView) {
      switch (_navigationDirection) {
        case DateRangePickerNavigationDirection.horizontal:
          {
            _cellWidth =
                (size.width - _multiViewSpacing) / (DateTime.daysPerWeek * 2);
          }
          break;
        case DateRangePickerNavigationDirection.vertical:
          {
            _cellHeight = (size.height - _multiViewSpacing) / (2 * rowCount);
          }
      }
    }

    _centerXPosition = _cellWidth / 2;
    _centerYPosition = _cellHeight / 2;
    _drawMonthCellsAndSelection(context, size, this, _cellWidth, _cellHeight);
  }

  @override
  void updateSelection(PickerStateArgs details) {
    if (DateRangePickerHelper.isDateCollectionEquals(
        details.selectedDates, selectedDates)) {
      return;
    }

    selectedDates = DateRangePickerHelper.cloneList(details.selectedDates);
    selectionNotifier.value = !selectionNotifier.value;
  }
}

class _MonthViewRangeSelectionRenderObject extends _IMonthView {
  _MonthViewRangeSelectionRenderObject(
      List<dynamic> visibleDates,
      int rowCount,
      dynamic cellStyle,
      TextStyle? selectionTextStyle,
      TextStyle? rangeTextStyle,
      Color? selectionColor,
      Color? startRangeSelectionColor,
      Color? endRangeSelectionColor,
      Color? rangeSelectionColor,
      SfDateRangePickerThemeData datePickerTheme,
      bool isRtl,
      Color? todayHighlightColor,
      dynamic minDate,
      dynamic maxDate,
      bool enablePastDates,
      bool showLeadingAndTailingDates,
      List<dynamic>? blackoutDates,
      List<dynamic>? specialDates,
      List<int> weekendDays,
      DateRangePickerSelectionShape selectionShape,
      double selectionRadius,
      ValueNotifier<Offset?> mouseHoverPosition,
      bool enableMultiView,
      double multiViewSpacing,
      ValueNotifier<bool> selectionNotifier,
      double textScaleFactor,
      double height,
      double width,
      bool isHijri,
      DateRangePickerNavigationDirection navigationDirection,
      SfLocalizations localizations,
      this._selectedRange)
      : super(
            visibleDates,
            rowCount,
            cellStyle,
            selectionTextStyle,
            rangeTextStyle,
            selectionColor,
            startRangeSelectionColor,
            endRangeSelectionColor,
            rangeSelectionColor,
            datePickerTheme,
            isRtl,
            todayHighlightColor,
            minDate,
            maxDate,
            enablePastDates,
            showLeadingAndTailingDates,
            blackoutDates,
            specialDates,
            weekendDays,
            selectionShape,
            selectionRadius,
            mouseHoverPosition,
            enableMultiView,
            multiViewSpacing,
            selectionNotifier,
            textScaleFactor,
            height,
            width,
            isHijri,
            navigationDirection,
            localizations);

  dynamic? _selectedRange;

  dynamic? get selectedRange => _selectedRange;

  set selectedRange(dynamic? value) {
    if (DateRangePickerHelper.isRangeEquals(_selectedRange, value)) {
      return;
    }

    _selectedRange = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  List<int> _selectedIndex = <int>[];

  @override
  TextStyle drawSelection(Canvas canvas, double x, double y, int index,
      TextStyle selectionTextStyle, TextStyle selectionRangeTextStyle) {
    final List<bool> selectionDetails = _getSelectedRangePosition(index);
    final bool isSelectedDate = selectionDetails[0];
    final bool isStartRange = selectionDetails[1];
    final bool isEndRange = selectionDetails[2];
    final bool isBetweenRange = selectionDetails[3];

    final double radius =
        _getCellRadius(selectionRadius, _centerXPosition, _centerYPosition);
    final double heightDifference = _cellHeight / 2 - radius;
    if (isSelectedDate) {
      _drawSelectedDate(canvas, radius, _centerXPosition, _cellWidth,
          _cellHeight, x, y, this, _centerYPosition);
    } else if (isStartRange) {
      _selectionPainter.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor!;
      _drawStartAndEndRange(
          canvas,
          this,
          _cellHeight,
          _cellWidth,
          radius,
          _centerXPosition,
          _centerYPosition,
          x,
          y,
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor!,
          heightDifference,
          isStartRange);
    } else if (isEndRange) {
      _selectionPainter.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor!;
      _drawStartAndEndRange(
          canvas,
          this,
          _cellHeight,
          _cellWidth,
          radius,
          _centerXPosition,
          _centerYPosition,
          x,
          y,
          endRangeSelectionColor ?? datePickerTheme.endRangeSelectionColor!,
          heightDifference,
          isStartRange);
    } else if (isBetweenRange) {
      return _drawBetweenSelection(canvas, this, _cellWidth, _cellHeight,
          radius, x, y, heightDifference, selectionRangeTextStyle);
    }

    return selectionTextStyle;
  }

  @override
  void drawCustomCellSelection(Canvas canvas, double x, double y, int index) {
    _selectionPainter.strokeWidth = 0.0;
    _selectionPainter.style = PaintingStyle.fill;
    _selectionPainter.isAntiAlias = true;
    final List<bool> selectionDetails = _getSelectedRangePosition(index);
    final bool isSelectedDate = selectionDetails[0];
    final bool isStartRange = selectionDetails[1];
    final bool isEndRange = selectionDetails[2];
    final bool isBetweenRange = selectionDetails[3];
    if (isSelectedDate) {
      _selectionPainter.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor!;
    } else if (isStartRange) {
      _selectionPainter.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor!;
    } else if (isEndRange) {
      _selectionPainter.color =
          endRangeSelectionColor ?? datePickerTheme.endRangeSelectionColor!;
    } else if (isBetweenRange) {
      _selectionPainter.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor!;
    }

    canvas.drawRect(Rect.fromLTRB(x, y, x + _cellWidth, y + _cellHeight),
        _selectionPainter);
  }

  List<bool> _getSelectedRangePosition(int index) {
    /// isSelectedDate value used to notify the year cell as selected and
    /// the range hold only start date value on range and multi range selection.
    bool isSelectedDate = false;

    /// isStartRange value used to notify the year cell as selected and
    /// the year cell as start date cell of the picker date range.
    /// its selection mode as range or multi range.
    bool isStartRange = false;

    /// isEndRange value used to notify the year cell as selected and
    /// the year cell as end date cell of the picker date range.
    /// its selection mode as range or multi range.
    bool isEndRange = false;

    /// isBetweenRange value used to notify the year cell as selected and
    /// the year cell as in between the start and  end date cell of the
    /// picker date range. its selection mode as range or multi range.
    bool isBetweenRange = false;
    if (_selectedIndex.length == 1) {
      isSelectedDate = true;
    } else if (_selectedIndex[0] == index) {
      if (isRtl) {
        isEndRange = true;
      } else {
        isStartRange = true;
      }
    } else if (_selectedIndex[_selectedIndex.length - 1] == index) {
      if (isRtl) {
        isStartRange = true;
      } else {
        isEndRange = true;
      }
    } else {
      isBetweenRange = true;
    }

    return <bool>[isSelectedDate, isStartRange, isEndRange, isBetweenRange];
  }

  @override
  List<int> getSelectedIndexValues(int viewStartIndex, int viewEndIndex) {
    _selectedIndex = <int>[];
    if (selectedRange != null) {
      final dynamic startDate = selectedRange.startDate;
      final dynamic endDate = selectedRange.endDate ?? selectedRange.startDate;
      _selectedIndex = _getSelectedRangeIndex(startDate, endDate, visibleDates,
          monthStartIndex: viewStartIndex, monthEndIndex: viewEndIndex);
    }

    return _selectedIndex;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _cellWidth = size.width / DateTime.daysPerWeek;
    _cellHeight = size.height / rowCount;
    if (enableMultiView) {
      switch (_navigationDirection) {
        case DateRangePickerNavigationDirection.horizontal:
          {
            _cellWidth =
                (size.width - _multiViewSpacing) / (DateTime.daysPerWeek * 2);
          }
          break;
        case DateRangePickerNavigationDirection.vertical:
          {
            _cellHeight = (size.height - _multiViewSpacing) / (2 * rowCount);
          }
      }
    }

    _centerXPosition = _cellWidth / 2;
    _centerYPosition = _cellHeight / 2;
    _drawMonthCellsAndSelection(context, size, this, _cellWidth, _cellHeight);
  }

  @override
  void updateSelection(PickerStateArgs details) {
    if (DateRangePickerHelper.isRangeEquals(
        details.selectedRange, selectedRange)) {
      return;
    }

    selectedRange = details.selectedRange;
    selectionNotifier.value = !selectionNotifier.value;
  }
}

class _MonthViewMultiRangeSelectionRenderObject extends _IMonthView {
  _MonthViewMultiRangeSelectionRenderObject(
      List<dynamic> visibleDates,
      int rowCount,
      dynamic cellStyle,
      TextStyle? selectionTextStyle,
      TextStyle? rangeTextStyle,
      Color? selectionColor,
      Color? startRangeSelectionColor,
      Color? endRangeSelectionColor,
      Color? rangeSelectionColor,
      SfDateRangePickerThemeData datePickerTheme,
      bool isRtl,
      Color? todayHighlightColor,
      dynamic minDate,
      dynamic maxDate,
      bool enablePastDates,
      bool showLeadingAndTailingDates,
      List<dynamic>? blackoutDates,
      List<dynamic>? specialDates,
      List<int> weekendDays,
      DateRangePickerSelectionShape selectionShape,
      double selectionRadius,
      ValueNotifier<Offset?> mouseHoverPosition,
      bool enableMultiView,
      double multiViewSpacing,
      ValueNotifier<bool> selectionNotifier,
      double textScaleFactor,
      double height,
      double width,
      bool isHijri,
      DateRangePickerNavigationDirection navigationDirection,
      SfLocalizations localizations,
      this._selectedRanges)
      : super(
            visibleDates,
            rowCount,
            cellStyle,
            selectionTextStyle,
            rangeTextStyle,
            selectionColor,
            startRangeSelectionColor,
            endRangeSelectionColor,
            rangeSelectionColor,
            datePickerTheme,
            isRtl,
            todayHighlightColor,
            minDate,
            maxDate,
            enablePastDates,
            showLeadingAndTailingDates,
            blackoutDates,
            specialDates,
            weekendDays,
            selectionShape,
            selectionRadius,
            mouseHoverPosition,
            enableMultiView,
            multiViewSpacing,
            selectionNotifier,
            textScaleFactor,
            height,
            width,
            isHijri,
            navigationDirection,
            localizations);

  List<dynamic>? _selectedRanges;

  List<dynamic>? get selectedRanges => _selectedRanges;

  set selectedRanges(List<dynamic>? value) {
    if (DateRangePickerHelper.isDateRangesEquals(_selectedRanges, value)) {
      return;
    }

    _selectedRanges = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  List<List<int>> _selectedRangesIndex = <List<int>>[];

  @override
  TextStyle drawSelection(Canvas canvas, double x, double y, int index,
      TextStyle selectionTextStyle, TextStyle selectionRangeTextStyle) {
    final List<bool> selectionDetails = _getSelectedRangePosition(index);
    final bool isSelectedDate = selectionDetails[0];
    final bool isStartRange = selectionDetails[1];
    final bool isEndRange = selectionDetails[2];
    final bool isBetweenRange = selectionDetails[3];

    final double radius =
        _getCellRadius(selectionRadius, _centerXPosition, _centerYPosition);
    final double heightDifference = _cellHeight / 2 - radius;
    if (isSelectedDate) {
      _drawSelectedDate(canvas, radius, _centerXPosition, _cellWidth,
          _cellHeight, x, y, this, _centerYPosition);
    } else if (isStartRange) {
      _selectionPainter.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor!;
      _drawStartAndEndRange(
          canvas,
          this,
          _cellHeight,
          _cellWidth,
          radius,
          _centerXPosition,
          _centerYPosition,
          x,
          y,
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor!,
          heightDifference,
          isStartRange);
    } else if (isEndRange) {
      _selectionPainter.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor!;
      _drawStartAndEndRange(
          canvas,
          this,
          _cellHeight,
          _cellWidth,
          radius,
          _centerXPosition,
          _centerYPosition,
          x,
          y,
          endRangeSelectionColor ?? datePickerTheme.endRangeSelectionColor!,
          heightDifference,
          isStartRange);
    } else if (isBetweenRange) {
      return _drawBetweenSelection(canvas, this, _cellWidth, _cellHeight,
          radius, x, y, heightDifference, selectionRangeTextStyle);
    }

    return selectionTextStyle;
  }

  @override
  void drawCustomCellSelection(Canvas canvas, double x, double y, int index) {
    _selectionPainter.strokeWidth = 0.0;
    _selectionPainter.style = PaintingStyle.fill;
    _selectionPainter.isAntiAlias = true;
    final List<bool> selectionDetails = _getSelectedRangePosition(index);
    final bool isSelectedDate = selectionDetails[0];
    final bool isStartRange = selectionDetails[1];
    final bool isEndRange = selectionDetails[2];
    final bool isBetweenRange = selectionDetails[3];
    if (isSelectedDate) {
      _selectionPainter.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor!;
    } else if (isStartRange) {
      _selectionPainter.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor!;
    } else if (isEndRange) {
      _selectionPainter.color =
          endRangeSelectionColor ?? datePickerTheme.endRangeSelectionColor!;
    } else if (isBetweenRange) {
      _selectionPainter.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor!;
    }

    canvas.drawRect(Rect.fromLTRB(x, y, x + _cellWidth, y + _cellHeight),
        _selectionPainter);
  }

  List<bool> _getSelectedRangePosition(int index) {
    /// isSelectedDate value used to notify the year cell as selected and
    /// the range hold only start date value on range and multi range selection.
    bool isSelectedDate = false;

    /// isStartRange value used to notify the year cell as selected and
    /// the year cell as start date cell of the picker date range.
    /// its selection mode as range or multi range.
    bool isStartRange = false;

    /// isEndRange value used to notify the year cell as selected and
    /// the year cell as end date cell of the picker date range.
    /// its selection mode as range or multi range.
    bool isEndRange = false;

    /// isBetweenRange value used to notify the year cell as selected and
    /// the year cell as in between the start and  end date cell of the
    /// picker date range. its selection mode as range or multi range.
    bool isBetweenRange = false;
    for (int j = 0; j < _selectedRangesIndex.length; j++) {
      final List<int> rangeIndex = _selectedRangesIndex[j];
      if (!rangeIndex.contains(index)) {
        continue;
      }

      if (rangeIndex.length == 1) {
        isSelectedDate = true;
      } else if (rangeIndex[0] == index) {
        if (isRtl) {
          isEndRange = true;
        } else {
          isStartRange = true;
        }
      } else if (rangeIndex[rangeIndex.length - 1] == index) {
        if (isRtl) {
          isStartRange = true;
        } else {
          isEndRange = true;
        }
      } else {
        isBetweenRange = true;
      }

      break;
    }

    return <bool>[isSelectedDate, isStartRange, isEndRange, isBetweenRange];
  }

  @override
  List<int> getSelectedIndexValues(int viewStartIndex, int viewEndIndex) {
    final List<int> selectedIndex = <int>[];
    _selectedRangesIndex = <List<int>>[];
    if (selectedRanges != null) {
      for (int j = 0; j < selectedRanges!.length; j++) {
        final dynamic range = selectedRanges![j];
        final dynamic startDate = range.startDate;
        final dynamic endDate = range.endDate ?? range.startDate;
        final List<int> rangeIndex = _getSelectedRangeIndex(
            startDate, endDate, visibleDates,
            monthStartIndex: viewStartIndex, monthEndIndex: viewEndIndex);
        for (int i = 0; i < rangeIndex.length; i++) {
          selectedIndex.add(rangeIndex[i]);
        }

        _selectedRangesIndex.add(rangeIndex);
      }
    }

    return selectedIndex;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _cellWidth = size.width / DateTime.daysPerWeek;
    _cellHeight = size.height / rowCount;
    if (enableMultiView) {
      switch (_navigationDirection) {
        case DateRangePickerNavigationDirection.horizontal:
          {
            _cellWidth =
                (size.width - _multiViewSpacing) / (DateTime.daysPerWeek * 2);
          }
          break;
        case DateRangePickerNavigationDirection.vertical:
          {
            _cellHeight = (size.height - _multiViewSpacing) / (2 * rowCount);
          }
      }
    }

    _centerXPosition = _cellWidth / 2;
    _centerYPosition = _cellHeight / 2;
    _drawMonthCellsAndSelection(context, size, this, _cellWidth, _cellHeight);
  }

  @override
  void updateSelection(PickerStateArgs details) {
    if (DateRangePickerHelper.isDateRangesEquals(
        details.selectedRanges, selectedRanges)) {
      return;
    }

    selectedRanges = DateRangePickerHelper.cloneList(details.selectedRanges);
    selectionNotifier.value = !selectionNotifier.value;
  }
}

void _drawSelectedDate(
    Canvas canvas,
    double radius,
    double centerXPosition,
    double cellWidth,
    double cellHeight,
    double x,
    double y,
    _IMonthView view,
    double centerYPosition) {
  view._selectionPainter.isAntiAlias = true;
  view._selectionPainter.color = view.startRangeSelectionColor ??
      view.datePickerTheme.startRangeSelectionColor!;
  switch (view.selectionShape) {
    case DateRangePickerSelectionShape.circle:
      {
        _drawCircleSelection(canvas, x + centerXPosition, y + centerYPosition,
            radius, view._selectionPainter);
      }
      break;
    case DateRangePickerSelectionShape.rectangle:
      {
        _drawFillSelection(
            canvas, x, y, cellWidth, cellHeight, view._selectionPainter);
      }
  }
}

void _drawStartAndEndRange(
    Canvas canvas,
    _IMonthView view,
    double cellHeight,
    double cellWidth,
    double radius,
    double centerXPosition,
    double centerYPosition,
    double x,
    double y,
    Color color,
    double heightDifference,
    bool isStartRange) {
  switch (view.selectionShape) {
    case DateRangePickerSelectionShape.circle:
      {
        Rect rect;
        if (isStartRange) {
          rect = Rect.fromLTRB(x + centerXPosition, y + heightDifference,
              x + cellWidth, y + cellHeight - heightDifference);
        } else {
          rect = Rect.fromLTRB(x, y + heightDifference, x + centerXPosition,
              y + cellHeight - heightDifference);
        }

        _drawStartEndRangeCircleSelection(canvas, x + centerXPosition,
            y + centerYPosition, radius, rect, view._selectionPainter, color);
      }
      break;
    case DateRangePickerSelectionShape.rectangle:
      {
        view._selectionPainter.isAntiAlias = true;
        view._selectionPainter.color = color;
        if (isStartRange) {
          _drawStartRangeFillSelection(
              canvas, x, y, cellWidth, cellHeight, view._selectionPainter);
        } else {
          _drawEndRangeFillSelection(
              canvas, x, y, cellWidth, cellHeight, view._selectionPainter);
        }
      }
  }
}

TextStyle _drawBetweenSelection(
    Canvas canvas,
    _IMonthView view,
    double cellWidth,
    double cellHeight,
    double radius,
    double x,
    double y,
    double heightDifference,
    TextStyle selectionRangeTextStyle) {
  switch (view.selectionShape) {
    case DateRangePickerSelectionShape.rectangle:
      heightDifference = 1;
      break;
    case DateRangePickerSelectionShape.circle:
      break;
  }

  view._selectionPainter.color =
      view.rangeSelectionColor ?? view.datePickerTheme.rangeSelectionColor!;
  _drawRectRangeSelection(canvas, x, y + heightDifference, x + cellWidth,
      y + cellHeight - heightDifference, view._selectionPainter);
  return selectionRangeTextStyle;
}

double _getCellRadius(
    double selectionRadius, double maxXRadius, double maxYRadius) {
  final double radius = maxXRadius > maxYRadius
      ? maxYRadius - _IMonthView._selectionPadding
      : maxXRadius - _IMonthView._selectionPadding;

  if (selectionRadius == -1) {
    return radius;
  }

  return radius > selectionRadius ? selectionRadius : radius;
}

List<int> _getSelectedRangeIndex(
    dynamic startDate, dynamic endDate, List<dynamic> visibleDates,
    {int monthStartIndex = -1, int monthEndIndex = -1}) {
  int startIndex = -1;
  int endIndex = -1;
  final List<int> selectedIndex = <int>[];
  if (startDate != null && startDate.isAfter(endDate)) {
    final dynamic temp = startDate;
    startDate = endDate;
    endDate = temp;
  }

  final dynamic viewStartDate =
      monthStartIndex != -1 ? visibleDates[monthStartIndex] : visibleDates[0];
  final dynamic viewEndDate = monthEndIndex != -1
      ? visibleDates[monthEndIndex]
      : visibleDates[visibleDates.length - 1];
  if (startDate != null) {
    if (viewStartDate.isAfter(startDate) && viewStartDate.isBefore(endDate)) {
      startIndex = -1;
    } else {
      startIndex = _getSelectedIndex(startDate, visibleDates,
          viewStartIndex: monthStartIndex);
    }
  }

  if (endDate != null) {
    if (viewEndDate.isAfter(startDate) && viewEndDate.isBefore(endDate)) {
      endIndex = visibleDates.length;
    } else {
      endIndex = _getSelectedIndex(endDate, visibleDates,
          viewStartIndex: monthStartIndex);
    }
  }

  //// If some range end date as null then it end index is start index.
  if (startIndex != -1 && endIndex == -1) {
    endIndex = startIndex;
  }

  if (startIndex > endIndex) {
    final int temp = startIndex;
    startIndex = endIndex;
    endIndex = temp;
  }

  for (int i = startIndex; i <= endIndex; i++) {
    selectedIndex.add(i);
  }

  return selectedIndex;
}

int _getSelectedIndex(dynamic date, List<dynamic> visibleDates,
    {int viewStartIndex = 0}) {
  if (viewStartIndex == -1) {
    viewStartIndex = 0;
  }

  for (int i = viewStartIndex; i < visibleDates.length; i++) {
    if (isSameDate(visibleDates[i], date)) {
      return i;
    }
  }

  return -1;
}

void _drawCircleSelection(
    Canvas canvas, double x, double y, double radius, Paint selectionPainter) {
  canvas.drawCircle(Offset(x, y), radius, selectionPainter);
}

void _drawFillSelection(Canvas canvas, double x, double y, double width,
    double height, Paint selectionPainter) {
  const double padding = 1;
  canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTRB(x + padding, y + padding, x + width - padding,
              y + height - padding),
          Radius.circular(height / 4 > 10 ? 10 : height / 4)),
      selectionPainter);
}

void _drawStartRangeFillSelection(Canvas canvas, double x, double y,
    double width, double height, Paint selectionPainter) {
  const double padding = 1;
  final double cornerRadius = height / 4 > 10 ? 10 : height / 4;
  canvas.drawRRect(
      RRect.fromRectAndCorners(
          Rect.fromLTRB(
              x + padding, y + padding, x + width, y + height - padding),
          bottomLeft: Radius.circular(cornerRadius),
          topLeft: Radius.circular(cornerRadius)),
      selectionPainter);
}

void _drawEndRangeFillSelection(Canvas canvas, double x, double y, double width,
    double height, Paint selectionPainter) {
  const double padding = 1;
  final double cornerRadius = height / 4 > 10 ? 10 : height / 4;
  canvas.drawRRect(
      RRect.fromRectAndCorners(
          Rect.fromLTRB(
              x, y + padding, x + width - padding, y + height - padding),
          bottomRight: Radius.circular(cornerRadius),
          topRight: Radius.circular(cornerRadius)),
      selectionPainter);
}

void _drawStartEndRangeCircleSelection(Canvas canvas, double x, double y,
    double radius, Rect rect, Paint selectionPainter, Color color) {
  canvas.drawRect(rect, selectionPainter);
  selectionPainter.isAntiAlias = true;
  selectionPainter.color = color;
  canvas.drawCircle(Offset(x, y), radius, selectionPainter);
}

void _drawRectRangeSelection(Canvas canvas, double left, double top,
    double right, double bottom, Paint selectionPainter) {
  canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), selectionPainter);
}

void _drawMonthCellsAndSelection(PaintingContext context, Size size,
    _IMonthView monthView, double cellWidth, double cellHeight) {
  final Canvas canvas = context.canvas;
  double xPosition = 0, yPosition;
  double webUIPadding = 0;
  double width = size.width;
  double height = size.height;
  int viewCount = 1;
  final bool isHorizontalMultiView = monthView.enableMultiView &&
      monthView.navigationDirection ==
          DateRangePickerNavigationDirection.horizontal;
  final bool isVerticalMultiView = monthView.enableMultiView &&
      monthView.navigationDirection ==
          DateRangePickerNavigationDirection.vertical;

  if (isHorizontalMultiView) {
    webUIPadding = monthView.multiViewSpacing;
    viewCount = 2;
    width = (width - webUIPadding) / viewCount;
  } else if (isVerticalMultiView) {
    webUIPadding = monthView.multiViewSpacing;
    viewCount = 2;
    height = (height - webUIPadding) / viewCount;
  }

  monthView._textPainter.textScaleFactor = monthView.textScaleFactor;
  TextStyle textStyle = monthView.cellStyle.textStyle ??
      monthView.datePickerTheme.activeDatesTextStyle;
  final int datesCount = monthView.visibleDates.length ~/ viewCount;
  final bool isNeedWidgetPaint = monthView.childCount != 0;
  final bool hideLeadingAndTrailingDates =
      (monthView.rowCount == 6 && !monthView.showLeadingAndTailingDates) ||
          monthView.isHijri;
  if (isNeedWidgetPaint) {
    RenderBox? child = monthView.firstChild;
    for (int j = 0; j < viewCount; j++) {
      final int currentViewIndex =
          monthView.isRtl ? DateRangePickerHelper.getRtlIndex(viewCount, j) : j;
      final int currentMonth = monthView
          .visibleDates[((j * datesCount) + (datesCount / 2)).truncate()].month;

      final int viewStartIndex = j * datesCount;
      final int viewEndIndex = ((j + 1) * datesCount) - 1;
      final List<int> selectedIndex =
          monthView.getSelectedIndexValues(viewStartIndex, viewEndIndex);
      final double viewStartPosition = isVerticalMultiView
          ? 0
          : (currentViewIndex * width) + (currentViewIndex * webUIPadding);
      final double viewEndPosition = viewStartPosition + width;
      xPosition = viewStartPosition;
      yPosition = yPosition = isHorizontalMultiView
          ? 0
          : (currentViewIndex * height) + (currentViewIndex * webUIPadding);
      for (int i = 0; i < datesCount; i++) {
        int currentIndex = i;
        if (monthView.isRtl) {
          final int rowIndex = i ~/ DateTime.daysPerWeek;
          currentIndex = DateRangePickerHelper.getRtlIndex(
                  DateTime.daysPerWeek, i % DateTime.daysPerWeek) +
              (rowIndex * DateTime.daysPerWeek);
        }

        currentIndex = (j * datesCount) + currentIndex;
        final dynamic date = monthView.visibleDates[currentIndex];
        final int currentDateMonth = date.month;

        /// Check the x position reaches view end position then draw the
        /// date on next cell.
        /// Padding 1 value used to avoid decimal value difference.
        /// eg., if view end position as 243 and x position as 242.499 then
        /// round method in decimal return 242 rather than 243, so it does
        /// not move the next line for draw date value.
        if (xPosition + 1 >= viewEndPosition) {
          xPosition = viewStartPosition;
          yPosition += cellHeight;
        }

        if (hideLeadingAndTrailingDates && currentDateMonth != currentMonth) {
          xPosition += cellWidth;
          continue;
        }

        final bool isEnableDate = DateRangePickerHelper.isEnabledDate(
            monthView.minDate,
            monthView.maxDate,
            monthView.enablePastDates,
            date,
            monthView.isHijri);
        final bool isBlackedDate =
            DateRangePickerHelper.isDateWithInVisibleDates(
                monthView.visibleDates, monthView.blackoutDates, date);
        final bool isSelectedDate = selectedIndex.contains(currentIndex);

        if (isSelectedDate &&
            !isBlackedDate &&
            isEnableDate &&
            (!monthView.enableMultiView ||
                (monthView.rowCount != 6 ||
                    (currentMonth == currentDateMonth)))) {
          monthView.drawCustomCellSelection(
              canvas, xPosition, yPosition, currentIndex);
        }

        child!.paint(context, Offset(xPosition, yPosition));
        child = monthView.childAfter(child);
        if (monthView.mouseHoverPosition.value != null) {
          if (isSelectedDate || isBlackedDate || !isEnableDate) {
            xPosition += cellWidth;
            continue;
          }

          if (xPosition <= monthView.mouseHoverPosition.value!.dx &&
              xPosition + cellWidth >= monthView.mouseHoverPosition.value!.dx &&
              yPosition <= monthView.mouseHoverPosition.value!.dy &&
              yPosition + cellHeight >=
                  monthView.mouseHoverPosition.value!.dy) {
            monthView._selectionPainter.style = PaintingStyle.fill;
            monthView._selectionPainter.strokeWidth = 2;
            monthView._selectionPainter.color = monthView.selectionColor != null
                ? monthView.selectionColor!.withOpacity(0.4)
                : monthView.datePickerTheme.selectionColor!.withOpacity(0.4);
            canvas.drawRRect(
                RRect.fromRectAndRadius(
                    Rect.fromLTWH(xPosition, yPosition, cellWidth, cellHeight),
                    Radius.circular(2)),
                monthView._selectionPainter);
          }
        }

        xPosition += cellWidth;
      }
    }

    return;
  }

  final dynamic today = DateRangePickerHelper.getToday(monthView.isHijri);
  for (int j = 0; j < viewCount; j++) {
    final int currentViewIndex =
        monthView.isRtl ? DateRangePickerHelper.getRtlIndex(viewCount, j) : j;
    final dynamic currentMonthDate = monthView
        .visibleDates[((j * datesCount) + (datesCount / 2)).truncate()];
    final int nextMonth = getNextMonthDate(currentMonthDate).month;
    final int previousMonth = getPreviousMonthDate(currentMonthDate).month;
    bool isCurrentDate;
    final TextStyle selectionTextStyle = monthView.selectionTextStyle ??
        monthView.datePickerTheme.selectionTextStyle;
    final TextStyle selectedRangeTextStyle = monthView.rangeTextStyle ??
        monthView.datePickerTheme.rangeSelectionTextStyle;

    Decoration? dateDecoration;
    const double padding = 1;

    final int viewStartIndex = j * datesCount;
    final int viewEndIndex = ((j + 1) * datesCount) - 1;
    final List<int> selectedIndex =
        monthView.getSelectedIndexValues(viewStartIndex, viewEndIndex);
    final double viewStartPosition = isVerticalMultiView
        ? 0
        : (currentViewIndex * width) + (currentViewIndex * webUIPadding);
    final double viewEndPosition = viewStartPosition + width;
    xPosition = viewStartPosition;
    yPosition = isHorizontalMultiView
        ? 0
        : (currentViewIndex * height) + (currentViewIndex * webUIPadding);
    for (int i = 0; i < datesCount; i++) {
      int currentIndex = i;
      if (monthView.isRtl) {
        final int rowIndex = i ~/ DateTime.daysPerWeek;
        currentIndex = DateRangePickerHelper.getRtlIndex(
                DateTime.daysPerWeek, i % DateTime.daysPerWeek) +
            (rowIndex * DateTime.daysPerWeek);
      }

      isCurrentDate = false;
      currentIndex = (j * datesCount) + currentIndex;
      final dynamic date = monthView.visibleDates[currentIndex];
      final int currentDateMonth = date.month;

      /// Check the x position reaches view end position then draw the
      /// date on next cell.
      /// Padding 1 value used to avoid decimal value difference.
      /// eg., if view end position as 243 and x position as 242.499 then
      /// round method in decimal return 242 rather than 243, so it does
      /// not move the next line for draw date value.
      if (xPosition + 1 >= viewEndPosition) {
        xPosition = viewStartPosition;
        yPosition += cellHeight;
      }

      bool isNextMonth = false;
      bool isPreviousMonth = false;
      if (monthView.rowCount == 6 || monthView.isHijri) {
        if (currentDateMonth == nextMonth) {
          if (!monthView.showLeadingAndTailingDates || monthView.isHijri) {
            xPosition += cellWidth;
            continue;
          }
          isNextMonth = true;
        } else if (currentDateMonth == previousMonth) {
          if (!monthView.showLeadingAndTailingDates || monthView.isHijri) {
            xPosition += cellWidth;
            continue;
          }
          isPreviousMonth = true;
        }
      }

      isCurrentDate = isSameDate(date, today);
      final bool isEnableDate = DateRangePickerHelper.isEnabledDate(
          monthView.minDate,
          monthView.maxDate,
          monthView.enablePastDates,
          date,
          monthView.isHijri);
      final bool isBlackedDate = DateRangePickerHelper.isDateWithInVisibleDates(
          monthView.visibleDates, monthView.blackoutDates, date);
      final bool isWeekEnd =
          DateRangePickerHelper.isWeekend(monthView.weekendDays, date);
      final bool isSpecialDate = DateRangePickerHelper.isDateWithInVisibleDates(
          monthView.visibleDates, monthView.specialDates, date);

      textStyle = _updateTextStyle(monthView, isNextMonth, isPreviousMonth,
          isCurrentDate, isEnableDate, isBlackedDate, isWeekEnd, isSpecialDate);
      dateDecoration = _updateDecoration(
          isNextMonth,
          isPreviousMonth,
          monthView,
          isEnableDate,
          isCurrentDate,
          isBlackedDate,
          date,
          isWeekEnd,
          isSpecialDate);

      final bool isSelectedDate = selectedIndex.contains(currentIndex);
      if (isSelectedDate &&
          !isBlackedDate &&
          isEnableDate &&
          (!monthView.enableMultiView ||
              (monthView.rowCount != 6 ||
                  (currentMonthDate.month == currentDateMonth)))) {
        textStyle = _drawCellAndSelection(
            canvas,
            xPosition,
            yPosition,
            selectionTextStyle,
            selectedRangeTextStyle,
            monthView,
            currentIndex);
      } else if (dateDecoration != null) {
        _drawDecoration(canvas, xPosition, yPosition, padding, cellWidth,
            cellHeight, dateDecoration, monthView);
      } else if (isCurrentDate) {
        _drawCurrentDate(canvas, monthView, xPosition, yPosition, padding,
            cellWidth, cellHeight);
      }

      final TextSpan dateText = TextSpan(
        text: date.day.toString(),
        style: textStyle,
      );

      monthView._textPainter.text = dateText;
      monthView._textPainter.layout(minWidth: cellWidth, maxWidth: cellWidth);
      monthView._textPainter.paint(
          canvas,
          Offset(xPosition + (cellWidth / 2 - monthView._textPainter.width / 2),
              yPosition + ((cellHeight - monthView._textPainter.height) / 2)));
      if (monthView.mouseHoverPosition.value != null) {
        if (isSelectedDate || isBlackedDate || !isEnableDate) {
          xPosition += cellWidth;
          continue;
        }

        _addHoveringEffect(
            canvas, monthView, xPosition, yPosition, cellWidth, cellHeight);
      }

      xPosition += cellWidth;
    }
  }
}

void _addHoveringEffect(Canvas canvas, _IMonthView monthView, double xPosition,
    double yPosition, double cellWidth, double cellHeight) {
  if (xPosition <= monthView.mouseHoverPosition.value!.dx &&
      xPosition + cellWidth >= monthView.mouseHoverPosition.value!.dx &&
      yPosition <= monthView.mouseHoverPosition.value!.dy &&
      yPosition + cellHeight >= monthView.mouseHoverPosition.value!.dy) {
    monthView._selectionPainter.style = PaintingStyle.fill;
    monthView._selectionPainter.strokeWidth = 2;
    monthView._selectionPainter.color = monthView.selectionColor != null
        ? monthView.selectionColor!.withOpacity(0.4)
        : monthView.datePickerTheme.selectionColor!.withOpacity(0.4);
    switch (monthView.selectionShape) {
      case DateRangePickerSelectionShape.circle:
        {
          final double centerXPosition = cellWidth / 2;
          final double centerYPosition = cellHeight / 2;
          final double radius = _getCellRadius(
              monthView.selectionRadius, centerXPosition, centerYPosition);
          canvas.drawCircle(
              Offset(xPosition + centerXPosition, yPosition + centerYPosition),
              radius,
              monthView._selectionPainter);
        }
        break;
      case DateRangePickerSelectionShape.rectangle:
        {
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromLTWH(xPosition + 1, yPosition + 1, cellWidth - 1,
                      cellHeight - 1),
                  Radius.circular(cellHeight / 4 > 10 ? 10 : cellHeight / 4)),
              monthView._selectionPainter);
        }
    }
  }
}

TextStyle _drawCellAndSelection(
    Canvas canvas,
    double xPosition,
    double yPosition,
    TextStyle selectionTextStyle,
    TextStyle selectedRangeTextStyle,
    _IMonthView monthView,
    int currentIndex) {
  monthView._selectionPainter.color =
      monthView.selectionColor ?? monthView.datePickerTheme.selectionColor!;
  //// Unwanted space shown at end of the rectangle while enable anti aliasing property.
  monthView._selectionPainter.isAntiAlias = false;
  monthView._selectionPainter.strokeWidth = 0.0;
  monthView._selectionPainter.style = PaintingStyle.fill;
  return monthView.drawSelection(canvas, xPosition, yPosition, currentIndex,
      selectionTextStyle, selectedRangeTextStyle);
}

void _drawDecoration(
    Canvas canvas,
    double xPosition,
    double yPosition,
    double padding,
    double cellWidth,
    double cellHeight,
    Decoration dateDecoration,
    _IMonthView monthView) {
  final BoxPainter boxPainter =
      dateDecoration.createBoxPainter(monthView.markNeedsPaint);
  boxPainter.paint(
      canvas,
      Offset(xPosition + padding, yPosition + padding),
      ImageConfiguration(
          size: Size(cellWidth - (2 * padding), cellHeight - (2 * padding))));
}

void _drawCurrentDate(Canvas canvas, _IMonthView monthView, double xPosition,
    double yPosition, double padding, double cellWidth, double cellHeight) {
  monthView._selectionPainter.color = monthView.todayHighlightColor ??
      monthView.datePickerTheme.todayHighlightColor!;
  monthView._selectionPainter.isAntiAlias = true;
  monthView._selectionPainter.strokeWidth = 1.0;
  monthView._selectionPainter.style = PaintingStyle.stroke;

  switch (monthView.selectionShape) {
    case DateRangePickerSelectionShape.circle:
      {
        final double centerXPosition = cellWidth / 2;
        final double centerYPosition = cellHeight / 2;
        final double radius = _getCellRadius(
            monthView.selectionRadius, centerXPosition, centerYPosition);
        canvas.drawCircle(
            Offset(xPosition + centerXPosition, yPosition + centerYPosition),
            radius,
            monthView._selectionPainter);
      }
      break;
    case DateRangePickerSelectionShape.rectangle:
      {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(
                    xPosition + padding,
                    yPosition + padding,
                    xPosition + cellWidth - padding,
                    yPosition + cellHeight - padding),
                Radius.circular(cellHeight / 4 > 10 ? 10 : cellHeight / 4)),
            monthView._selectionPainter);
      }
  }
}

TextStyle _updateTextStyle(
    _IMonthView monthView,
    bool isNextMonth,
    bool isPreviousMonth,
    bool isCurrentDate,
    bool isEnableDate,
    bool isBlackedDate,
    bool isWeekEnd,
    bool isSpecialDate) {
  final TextStyle currentDatesTextStyle = monthView.cellStyle.textStyle ??
      monthView.datePickerTheme.activeDatesTextStyle;
  if (isBlackedDate) {
    return monthView.cellStyle.blackoutDateTextStyle ??
        (monthView.datePickerTheme.blackoutDatesTextStyle ??
            currentDatesTextStyle.copyWith(
                decoration: TextDecoration.lineThrough));
  }

  if (isSpecialDate) {
    return monthView.cellStyle.specialDatesTextStyle ??
        monthView.datePickerTheme.specialDatesTextStyle;
  }

  if (!isEnableDate) {
    return monthView.cellStyle.disabledDatesTextStyle ??
        monthView.datePickerTheme.disabledDatesTextStyle;
  }

  if (isCurrentDate) {
    return monthView.cellStyle.todayTextStyle ??
        monthView.datePickerTheme.todayTextStyle;
  }

  if (isWeekEnd && monthView.cellStyle.weekendTextStyle != null) {
    return monthView.cellStyle.weekendTextStyle;
  } else if (isWeekEnd &&
      monthView.datePickerTheme.weekendDatesTextStyle != null) {
    return monthView.datePickerTheme.weekendDatesTextStyle!;
  }

  if (isNextMonth && !monthView.isHijri) {
    return monthView.cellStyle.leadingDatesTextStyle ??
        monthView.datePickerTheme.leadingDatesTextStyle;
  } else if (isPreviousMonth && !monthView.isHijri) {
    return monthView.cellStyle.trailingDatesTextStyle ??
        monthView.datePickerTheme.trailingDatesTextStyle;
  }

  return currentDatesTextStyle;
}

Decoration? _updateDecoration(
    bool isNextMonth,
    bool isPreviousMonth,
    _IMonthView monthView,
    isEnableDate,
    isCurrentDate,
    isBlackedDate,
    dynamic date,
    bool isWeekEnd,
    bool isSpecialDate) {
  final Decoration? dateDecoration = monthView.cellStyle.cellDecoration;

  if (isBlackedDate) {
    return monthView.cellStyle.blackoutDatesDecoration;
  }

  if (isSpecialDate) {
    return monthView.cellStyle.specialDatesDecoration;
  }

  if (!isEnableDate) {
    return monthView.cellStyle.disabledDatesDecoration;
  }

  if (isCurrentDate) {
    return monthView.cellStyle.todayCellDecoration ?? dateDecoration;
  }

  if (isWeekEnd && monthView.cellStyle.weekendDatesDecoration != null) {
    return monthView.cellStyle.weekendDatesDecoration;
  }

  if (isNextMonth && !monthView.isHijri) {
    return monthView.cellStyle.leadingDatesDecoration;
  } else if (isPreviousMonth && !monthView.isHijri) {
    return monthView.cellStyle.trailingDatesDecoration;
  }

  return dateDecoration;
}
