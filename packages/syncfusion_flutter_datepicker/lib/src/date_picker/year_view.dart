import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../datepicker.dart';
import 'date_picker_manager.dart';
import 'picker_helper.dart';

/// Used to hold the year cell widgets.
class YearView extends StatefulWidget {
  /// Constructor for create the year view widget used to hold the year cell
  /// widgets.
  YearView(
      this.visibleDates,
      this.cellStyle,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.todayHighlightColor,
      this.selectionShape,
      this.monthFormat,
      this.isRtl,
      this.datePickerTheme,
      this.locale,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.selectionMode,
      this.selectionRadius,
      this.selectionNotifier,
      this.textScaleFactor,
      this.allowViewNavigation,
      this.cellBuilder,
      this.getPickerStateDetails,
      this.view,
      this.isHijri,
      this.localizations,
      this.navigationDirection,
      this.width,
      this.height);

  /// Defines the year cell style.
  final dynamic cellStyle;

  /// Defines the text style for selected year cell.
  final TextStyle selectionTextStyle;

  /// Defines the range text style for selected range year cell.
  final TextStyle rangeTextStyle;

  /// Defines the background color for selected year cell.
  final Color selectionColor;

  /// Defines the navigation direction for [SfDateRangePicker].
  final DateRangePickerNavigationDirection navigationDirection;

  /// Defines the background color for selected range start date year cell.
  final Color startRangeSelectionColor;

  /// Defines the background color for selected range end date year cell.
  final Color endRangeSelectionColor;

  /// Defines the background color for selected range in between dates cell.
  final Color rangeSelectionColor;

  /// Holds the visible dates for the year view.
  final List<dynamic> visibleDates;

  /// Used to identify the widget direction is RTL.
  final bool isRtl;

  /// Defines the today cell highlight color.
  final Color todayHighlightColor;

  /// The minimum date as much as the [SfDateRangePicker] will navigate.
  final dynamic minDate;

  /// The maximum date as much as the [SfDateRangePicker] will navigate.
  final dynamic maxDate;

  /// Decides to enable past dates or not.
  final bool enablePastDates;

  /// Decides the year cell highlight and selection shape.
  final DateRangePickerSelectionShape selectionShape;

  /// Holds the theme data for date range picker.
  final SfDateRangePickerThemeData datePickerTheme;

  /// Used to specify the mouse hover position of the year view.
  final ValueNotifier<Offset> mouseHoverPosition;

  /// Used to call repaint when the selection changes.
  final ValueNotifier<bool> selectionNotifier;

  /// Holds the selection radius of the year cell.
  final double selectionRadius;

  /// Holds the [SfDateRangePicker] selection mode.
  final DateRangePickerSelectionMode selectionMode;

  /// Decides to show the multi view of year view or not.
  final bool enableMultiView;

  /// Specifies the space between the multi year views.
  final double multiViewSpacing;

  /// Defines the text scale factor of [SfDateRangePicker].
  final double textScaleFactor;

  /// Defines the year view panel will draw selection or not.
  final bool allowViewNavigation;

  /// Used to get the picker state details from picker view widget.
  final UpdatePickerState getPickerStateDetails;

  /// Defines the current view of the picker.
  final DateRangePickerView view;

  /// Used to build the widget that replaces the month cells in month view.
  final DateRangePickerCellBuilder cellBuilder;

  /// Defines the month format for the year view cell text.
  final String monthFormat;

  /// Defines the locale of the picker.
  final Locale locale;

  /// Defines the width of the month view.
  final double width;

  /// Defines the height of the month view.
  final double height;

  /// Defines the pickerType for [SfDateRangePicker].
  final bool isHijri;

  /// Specifies the localizations.
  final SfLocalizations localizations;

  /// Defines the year view maximum column count.
  static const int maxColumnCount = 3;

  /// Defines the year view maximum row count.
  static const int maxRowCount = 4;

  @override
  _YearViewState createState() => _YearViewState();
}

class _YearViewState extends State<YearView> {
  PickerStateArgs _pickerStateDetails;
  dynamic _selectedDate;
  List<dynamic> _selectedDates;
  dynamic _selectedRange;
  List<dynamic> _selectedRanges;
  List<Widget> _children;

  @override
  void initState() {
    _pickerStateDetails = PickerStateArgs();
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
  void didUpdateWidget(YearView oldWidget) {
    if (widget.height != oldWidget.height ||
        widget.width != oldWidget.width ||
        widget.enablePastDates != oldWidget.enablePastDates ||
        widget.minDate != oldWidget.minDate ||
        widget.view != oldWidget.view ||
        widget.maxDate != oldWidget.maxDate ||
        widget.cellBuilder != oldWidget.cellBuilder ||
        widget.selectionMode != oldWidget.selectionMode ||
        widget.multiViewSpacing != oldWidget.multiViewSpacing ||
        widget.enableMultiView != oldWidget.enableMultiView ||
        widget.allowViewNavigation != oldWidget.allowViewNavigation ||
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
  Widget build(BuildContext context) {
    _children ??= <Widget>[];
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

      final double cellWidth = width / YearView.maxColumnCount;
      final double cellHeight = height / YearView.maxRowCount;
      final int visibleDatesCount = widget.visibleDates.length ~/ viewCount;
      for (int j = 0; j < viewCount; j++) {
        final int currentViewIndex =
            widget.isRtl ? DateRangePickerHelper.getRtlIndex(viewCount, j) : j;

        final int viewStartIndex = j * visibleDatesCount;

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
        for (int i = 0; i < visibleDatesCount; i++) {
          int currentIndex = i;
          if (widget.isRtl) {
            final int rowIndex = i ~/ YearView.maxColumnCount;
            currentIndex = DateRangePickerHelper.getRtlIndex(
                    YearView.maxColumnCount, i % YearView.maxColumnCount) +
                (rowIndex * YearView.maxColumnCount);
          }

          currentIndex += viewStartIndex;
          if (xPosition >= viewEndPosition) {
            xPosition = viewStartPosition;
            yPosition += cellHeight;
          }

          if ((widget.enableMultiView || widget.isHijri) &&
              DateRangePickerHelper.isLeadingCellDate(currentIndex,
                  viewStartIndex, widget.visibleDates, widget.view)) {
            xPosition += cellWidth;
            continue;
          }

          final dynamic date = widget.visibleDates[currentIndex];

          final DateRangePickerCellDetails cellDetails =
              DateRangePickerCellDetails(
                  date: date,
                  visibleDates: widget.visibleDates,
                  bounds: Rect.fromLTWH(
                      xPosition, yPosition, cellWidth, cellHeight));
          final Widget child = widget.cellBuilder(context, cellDetails);
          assert(child != null, 'Widget must not be null');
          _children.add(child);
          xPosition += cellWidth;
        }
      }
    }

    return _getRenderWidget();
  }

  MultiChildRenderObjectWidget _getRenderWidget() {
    switch (widget.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          return _SingleSelectionRenderWidget(
              widget.visibleDates,
              widget.cellStyle,
              widget.minDate,
              widget.maxDate,
              widget.enablePastDates,
              widget.todayHighlightColor,
              widget.selectionShape,
              widget.monthFormat,
              widget.isRtl,
              widget.datePickerTheme,
              widget.locale,
              widget.mouseHoverPosition,
              widget.enableMultiView,
              widget.multiViewSpacing,
              widget.selectionTextStyle,
              widget.rangeTextStyle,
              widget.selectionColor,
              widget.startRangeSelectionColor,
              widget.endRangeSelectionColor,
              widget.rangeSelectionColor,
              widget.allowViewNavigation ? null : _getSelectedDateValue(),
              widget.selectionRadius,
              widget.selectionNotifier,
              widget.textScaleFactor,
              widget.width,
              widget.height,
              widget.view,
              widget.isHijri,
              widget.localizations,
              widget.navigationDirection,
              widgets: _children);
        }
      case DateRangePickerSelectionMode.multiple:
        {
          return _MultiSelectionRenderWidget(
              widget.visibleDates,
              widget.cellStyle,
              widget.minDate,
              widget.maxDate,
              widget.enablePastDates,
              widget.todayHighlightColor,
              widget.selectionShape,
              widget.monthFormat,
              widget.isRtl,
              widget.datePickerTheme,
              widget.locale,
              widget.mouseHoverPosition,
              widget.enableMultiView,
              widget.multiViewSpacing,
              widget.selectionTextStyle,
              widget.rangeTextStyle,
              widget.selectionColor,
              widget.startRangeSelectionColor,
              widget.endRangeSelectionColor,
              widget.rangeSelectionColor,
              widget.allowViewNavigation ? null : _getSelectedDateValue(),
              widget.selectionRadius,
              widget.selectionNotifier,
              widget.textScaleFactor,
              widget.width,
              widget.height,
              widget.view,
              widget.isHijri,
              widget.localizations,
              widget.navigationDirection,
              widgets: _children);
        }
      case DateRangePickerSelectionMode.range:
        {
          return _RangeSelectionRenderWidget(
              widget.visibleDates,
              widget.cellStyle,
              widget.minDate,
              widget.maxDate,
              widget.enablePastDates,
              widget.todayHighlightColor,
              widget.selectionShape,
              widget.monthFormat,
              widget.isRtl,
              widget.datePickerTheme,
              widget.locale,
              widget.mouseHoverPosition,
              widget.enableMultiView,
              widget.multiViewSpacing,
              widget.selectionTextStyle,
              widget.rangeTextStyle,
              widget.selectionColor,
              widget.startRangeSelectionColor,
              widget.endRangeSelectionColor,
              widget.rangeSelectionColor,
              widget.allowViewNavigation ? null : _getSelectedDateValue(),
              widget.selectionRadius,
              widget.selectionNotifier,
              widget.textScaleFactor,
              widget.width,
              widget.height,
              widget.view,
              widget.isHijri,
              widget.localizations,
              widget.navigationDirection,
              widgets: _children);
        }
      case DateRangePickerSelectionMode.multiRange:
        {
          return _MultiRangeSelectionRenderWidget(
              widget.visibleDates,
              widget.cellStyle,
              widget.minDate,
              widget.maxDate,
              widget.enablePastDates,
              widget.todayHighlightColor,
              widget.selectionShape,
              widget.monthFormat,
              widget.isRtl,
              widget.datePickerTheme,
              widget.locale,
              widget.mouseHoverPosition,
              widget.enableMultiView,
              widget.multiViewSpacing,
              widget.selectionTextStyle,
              widget.rangeTextStyle,
              widget.selectionColor,
              widget.startRangeSelectionColor,
              widget.endRangeSelectionColor,
              widget.rangeSelectionColor,
              widget.allowViewNavigation ? null : _getSelectedDateValue(),
              widget.selectionRadius,
              widget.selectionNotifier,
              widget.textScaleFactor,
              widget.width,
              widget.height,
              widget.view,
              widget.isHijri,
              widget.localizations,
              widget.navigationDirection,
              widgets: _children);
        }
    }

    return null;
  }

  void _updateSelection({bool isNeedSetState = true}) {
    widget.getPickerStateDetails(_pickerStateDetails);
    if (widget.allowViewNavigation) {
      _selectedDate = _pickerStateDetails.selectedDate;
      _selectedDates =
          DateRangePickerHelper.cloneList(_pickerStateDetails.selectedDates);
      _selectedRange = _pickerStateDetails.selectedRange;
      _selectedRanges =
          DateRangePickerHelper.cloneList(_pickerStateDetails.selectedRanges);
      return;
    }

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

  dynamic _getSelectedDateValue() {
    switch (widget.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          return _selectedDate;
        }
      case DateRangePickerSelectionMode.multiple:
        {
          return _selectedDates;
        }
      case DateRangePickerSelectionMode.range:
        {
          return _selectedRange;
        }
      case DateRangePickerSelectionMode.multiRange:
        {
          return _selectedRanges;
        }
    }

    return null;
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
    return false;
  }
}

class _SingleSelectionRenderWidget extends MultiChildRenderObjectWidget {
  _SingleSelectionRenderWidget(
      this.visibleDates,
      this.cellStyle,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.todayHighlightColor,
      this.selectionShape,
      this.monthFormat,
      this.isRtl,
      this.datePickerTheme,
      this.locale,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.selectedDate,
      this.selectionRadius,
      this.selectionNotifier,
      this.textScaleFactor,
      this.width,
      this.height,
      this.view,
      this.isHijri,
      this.localizations,
      this.navigationDirection,
      {List<Widget> widgets})
      : super(children: widgets);

  /// Defines the year cell style.
  final dynamic cellStyle;

  final DateRangePickerNavigationDirection navigationDirection;

  /// Defines the text style for selected year cell.
  final TextStyle selectionTextStyle;

  /// Defines the range text style for selected range year cell.
  final TextStyle rangeTextStyle;

  /// Defines the background color for selected year cell.
  final Color selectionColor;

  /// Defines the background color for selected range start date year cell.
  final Color startRangeSelectionColor;

  /// Defines the background color for selected range end date year cell.
  final Color endRangeSelectionColor;

  /// Defines the background color for selected range in between dates cell.
  final Color rangeSelectionColor;

  /// Holds the visible dates for the year view.
  final List<dynamic> visibleDates;

  /// Used to identify the widget direction is RTL.
  final bool isRtl;

  /// Defines the today cell highlight color.
  final Color todayHighlightColor;

  /// The minimum date as much as the [SfDateRangePicker] will navigate.
  final dynamic minDate;

  /// The maximum date as much as the [SfDateRangePicker] will navigate.
  final dynamic maxDate;

  /// Decides to enable past dates or not.
  final bool enablePastDates;

  /// Decides the year cell highlight and selection shape.
  final DateRangePickerSelectionShape selectionShape;

  /// Holds the theme data for date range picker.
  final SfDateRangePickerThemeData datePickerTheme;

  /// Used to specify the mouse hover position of the year view.
  final ValueNotifier<Offset> mouseHoverPosition;

  /// Used to call repaint when the selection changes.
  final ValueNotifier<bool> selectionNotifier;

  /// Holds the selected date value.
  final dynamic selectedDate;

  /// Holds the selection radius of the year cell.
  final double selectionRadius;

  /// Decides to show the multi view of year view or not.
  final bool enableMultiView;

  /// Specifies the space between the multi year views.
  final double multiViewSpacing;

  /// Defines the text scale factor of [SfDateRangePicker].
  final double textScaleFactor;

  final String monthFormat;

  final Locale locale;

  final double width;

  final double height;

  final DateRangePickerView view;

  /// Defines the pickerType for [SfDateRangePicker].
  final bool isHijri;

  /// Specifies the localizations.
  final SfLocalizations localizations;

  @override
  _SingleSelectionRenderObject createRenderObject(BuildContext context) {
    return _SingleSelectionRenderObject(
        visibleDates,
        cellStyle,
        minDate,
        maxDate,
        enablePastDates,
        todayHighlightColor,
        selectionShape,
        isRtl,
        datePickerTheme,
        mouseHoverPosition,
        enableMultiView,
        multiViewSpacing,
        selectionTextStyle,
        rangeTextStyle,
        selectionColor,
        startRangeSelectionColor,
        endRangeSelectionColor,
        rangeSelectionColor,
        selectionRadius,
        textScaleFactor,
        width,
        height,
        monthFormat,
        locale,
        view,
        isHijri,
        navigationDirection,
        localizations,
        selectedDate);
  }

  @override
  void updateRenderObject(
      BuildContext context, _SingleSelectionRenderObject renderObject) {
    renderObject
      ..visibleDates = visibleDates
      ..cellStyle = cellStyle
      ..minDate = minDate
      ..maxDate = maxDate
      ..enablePastDates = enablePastDates
      ..todayHighlightColor = todayHighlightColor
      ..selectionShape = selectionShape
      ..isRtl = isRtl
      ..datePickerTheme = datePickerTheme
      ..mouseHoverPosition = mouseHoverPosition
      ..enableMultiView = enableMultiView
      ..multiViewSpacing = multiViewSpacing
      ..selectionTextStyle = selectionTextStyle
      ..rangeTextStyle = rangeTextStyle
      ..selectionColor = selectionColor
      ..startRangeSelectionColor = startRangeSelectionColor
      ..endRangeSelectionColor = endRangeSelectionColor
      ..rangeSelectionColor = rangeSelectionColor
      ..selectedDate = selectedDate
      ..selectionRadius = selectionRadius
      ..textScaleFactor = textScaleFactor
      ..width = width
      ..height = height
      ..isHijri = isHijri
      ..localizations = localizations
      ..navigationDirection = navigationDirection
      ..monthFormat = monthFormat
      ..locale = locale
      ..view = view;
  }
}

class _MultiSelectionRenderWidget extends MultiChildRenderObjectWidget {
  _MultiSelectionRenderWidget(
      this.visibleDates,
      this.cellStyle,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.todayHighlightColor,
      this.selectionShape,
      this.monthFormat,
      this.isRtl,
      this.datePickerTheme,
      this.locale,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.selectedDates,
      this.selectionRadius,
      this.selectionNotifier,
      this.textScaleFactor,
      this.width,
      this.height,
      this.view,
      this.isHijri,
      this.localizations,
      this.navigationDirection,
      {List<Widget> widgets})
      : super(children: widgets);

  /// Defines the year cell style.
  final dynamic cellStyle;

  final DateRangePickerNavigationDirection navigationDirection;

  /// Defines the text style for selected year cell.
  final TextStyle selectionTextStyle;

  /// Defines the range text style for selected range year cell.
  final TextStyle rangeTextStyle;

  /// Defines the background color for selected year cell.
  final Color selectionColor;

  /// Defines the background color for selected range start date year cell.
  final Color startRangeSelectionColor;

  /// Defines the background color for selected range end date year cell.
  final Color endRangeSelectionColor;

  /// Defines the background color for selected range in between dates cell.
  final Color rangeSelectionColor;

  /// Holds the visible dates for the year view.
  final List<dynamic> visibleDates;

  /// Used to identify the widget direction is RTL.
  final bool isRtl;

  /// Defines the today cell highlight color.
  final Color todayHighlightColor;

  /// The minimum date as much as the [SfDateRangePicker] will navigate.
  final dynamic minDate;

  /// The maximum date as much as the [SfDateRangePicker] will navigate.
  final dynamic maxDate;

  /// Decides to enable past dates or not.
  final bool enablePastDates;

  /// Decides the year cell highlight and selection shape.
  final DateRangePickerSelectionShape selectionShape;

  /// Holds the theme data for date range picker.
  final SfDateRangePickerThemeData datePickerTheme;

  /// Used to specify the mouse hover position of the year view.
  final ValueNotifier<Offset> mouseHoverPosition;

  /// Used to call repaint when the selection changes.
  final ValueNotifier<bool> selectionNotifier;

  /// Holds the selected dates value.
  final List<dynamic> selectedDates;

  /// Holds the selection radius of the year cell.
  final double selectionRadius;

  /// Decides to show the multi view of year view or not.
  final bool enableMultiView;

  /// Specifies the space between the multi year views.
  final double multiViewSpacing;

  /// Defines the text scale factor of [SfDateRangePicker].
  final double textScaleFactor;

  final String monthFormat;

  final Locale locale;

  final double width;

  final double height;

  final DateRangePickerView view;

  /// Defines the pickerType for [SfDateRangePicker].
  final bool isHijri;

  /// Specifies the localizations.
  final SfLocalizations localizations;

  @override
  _MultipleSelectionRenderObject createRenderObject(BuildContext context) {
    return _MultipleSelectionRenderObject(
        visibleDates,
        cellStyle,
        minDate,
        maxDate,
        enablePastDates,
        todayHighlightColor,
        selectionShape,
        isRtl,
        datePickerTheme,
        mouseHoverPosition,
        enableMultiView,
        multiViewSpacing,
        selectionTextStyle,
        rangeTextStyle,
        selectionColor,
        startRangeSelectionColor,
        endRangeSelectionColor,
        rangeSelectionColor,
        selectionRadius,
        textScaleFactor,
        width,
        height,
        monthFormat,
        locale,
        view,
        isHijri,
        navigationDirection,
        localizations,
        selectedDates);
  }

  @override
  void updateRenderObject(
      BuildContext context, _MultipleSelectionRenderObject renderObject) {
    renderObject
      ..visibleDates = visibleDates
      ..cellStyle = cellStyle
      ..minDate = minDate
      ..maxDate = maxDate
      ..enablePastDates = enablePastDates
      ..todayHighlightColor = todayHighlightColor
      ..selectionShape = selectionShape
      ..isRtl = isRtl
      ..datePickerTheme = datePickerTheme
      ..mouseHoverPosition = mouseHoverPosition
      ..enableMultiView = enableMultiView
      ..multiViewSpacing = multiViewSpacing
      ..selectionTextStyle = selectionTextStyle
      ..rangeTextStyle = rangeTextStyle
      ..selectionColor = selectionColor
      ..startRangeSelectionColor = startRangeSelectionColor
      ..endRangeSelectionColor = endRangeSelectionColor
      ..rangeSelectionColor = rangeSelectionColor
      ..selectedDates = selectedDates
      ..selectionRadius = selectionRadius
      ..textScaleFactor = textScaleFactor
      ..width = width
      ..height = height
      ..isHijri = isHijri
      ..localizations = localizations
      ..navigationDirection = navigationDirection
      ..monthFormat = monthFormat
      ..locale = locale
      ..view = view;
  }
}

class _RangeSelectionRenderWidget extends MultiChildRenderObjectWidget {
  _RangeSelectionRenderWidget(
      this.visibleDates,
      this.cellStyle,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.todayHighlightColor,
      this.selectionShape,
      this.monthFormat,
      this.isRtl,
      this.datePickerTheme,
      this.locale,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.selectedRange,
      this.selectionRadius,
      this.selectionNotifier,
      this.textScaleFactor,
      this.width,
      this.height,
      this.view,
      this.isHijri,
      this.localizations,
      this.navigationDirection,
      {List<Widget> widgets})
      : super(children: widgets);

  /// Defines the year cell style.
  final dynamic cellStyle;

  /// Defines the text style for selected year cell.
  final TextStyle selectionTextStyle;

  /// Defines the range text style for selected range year cell.
  final TextStyle rangeTextStyle;

  /// Defines the background color for selected year cell.
  final Color selectionColor;

  /// Defines the background color for selected range start date year cell.
  final Color startRangeSelectionColor;

  /// Defines the background color for selected range end date year cell.
  final Color endRangeSelectionColor;

  /// Defines the background color for selected range in between dates cell.
  final Color rangeSelectionColor;

  /// Holds the visible dates for the year view.
  final List<dynamic> visibleDates;

  /// Used to identify the widget direction is RTL.
  final bool isRtl;

  /// Defines the today cell highlight color.
  final Color todayHighlightColor;

  /// The minimum date as much as the [SfDateRangePicker] will navigate.
  final dynamic minDate;

  /// The maximum date as much as the [SfDateRangePicker] will navigate.
  final dynamic maxDate;

  final DateRangePickerNavigationDirection navigationDirection;

  /// Decides to enable past dates or not.
  final bool enablePastDates;

  /// Decides the year cell highlight and selection shape.
  final DateRangePickerSelectionShape selectionShape;

  /// Holds the theme data for date range picker.
  final SfDateRangePickerThemeData datePickerTheme;

  /// Used to specify the mouse hover position of the year view.
  final ValueNotifier<Offset> mouseHoverPosition;

  /// Used to call repaint when the selection changes.
  final ValueNotifier<bool> selectionNotifier;

  /// Holds the selected range value..
  final dynamic selectedRange;

  /// Holds the selection radius of the year cell.
  final double selectionRadius;

  /// Decides to show the multi view of year view or not.
  final bool enableMultiView;

  /// Specifies the space between the multi year views.
  final double multiViewSpacing;

  /// Defines the text scale factor of [SfDateRangePicker].
  final double textScaleFactor;

  final String monthFormat;

  final Locale locale;

  final double width;

  final double height;

  final DateRangePickerView view;

  /// Defines the pickerType for [SfDateRangePicker].
  final bool isHijri;

  /// Specifies the localizations.
  final SfLocalizations localizations;

  @override
  _RangeSelectionRenderObject createRenderObject(BuildContext context) {
    return _RangeSelectionRenderObject(
        visibleDates,
        cellStyle,
        minDate,
        maxDate,
        enablePastDates,
        todayHighlightColor,
        selectionShape,
        isRtl,
        datePickerTheme,
        mouseHoverPosition,
        enableMultiView,
        multiViewSpacing,
        selectionTextStyle,
        rangeTextStyle,
        selectionColor,
        startRangeSelectionColor,
        endRangeSelectionColor,
        rangeSelectionColor,
        selectionRadius,
        textScaleFactor,
        width,
        height,
        monthFormat,
        locale,
        view,
        isHijri,
        navigationDirection,
        localizations,
        selectedRange);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RangeSelectionRenderObject renderObject) {
    renderObject
      ..visibleDates = visibleDates
      ..cellStyle = cellStyle
      ..minDate = minDate
      ..maxDate = maxDate
      ..enablePastDates = enablePastDates
      ..todayHighlightColor = todayHighlightColor
      ..selectionShape = selectionShape
      ..isRtl = isRtl
      ..datePickerTheme = datePickerTheme
      ..mouseHoverPosition = mouseHoverPosition
      ..enableMultiView = enableMultiView
      ..multiViewSpacing = multiViewSpacing
      ..selectionTextStyle = selectionTextStyle
      ..rangeTextStyle = rangeTextStyle
      ..selectionColor = selectionColor
      ..startRangeSelectionColor = startRangeSelectionColor
      ..endRangeSelectionColor = endRangeSelectionColor
      ..rangeSelectionColor = rangeSelectionColor
      ..selectedRange = selectedRange
      ..selectionRadius = selectionRadius
      ..textScaleFactor = textScaleFactor
      ..width = width
      ..height = height
      ..isHijri = isHijri
      ..localizations = localizations
      ..navigationDirection = navigationDirection
      ..monthFormat = monthFormat
      ..locale = locale
      ..view = view;
  }
}

class _MultiRangeSelectionRenderWidget extends MultiChildRenderObjectWidget {
  _MultiRangeSelectionRenderWidget(
      this.visibleDates,
      this.cellStyle,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.todayHighlightColor,
      this.selectionShape,
      this.monthFormat,
      this.isRtl,
      this.datePickerTheme,
      this.locale,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.selectedRanges,
      this.selectionRadius,
      this.selectionNotifier,
      this.textScaleFactor,
      this.width,
      this.height,
      this.view,
      this.isHijri,
      this.localizations,
      this.navigationDirection,
      {List<Widget> widgets})
      : super(children: widgets);

  /// Defines the year cell style.
  final dynamic cellStyle;

  /// Defines the text style for selected year cell.
  final TextStyle selectionTextStyle;

  /// Defines the range text style for selected range year cell.
  final TextStyle rangeTextStyle;

  /// Defines the background color for selected year cell.
  final Color selectionColor;

  /// Defines the background color for selected range start date year cell.
  final Color startRangeSelectionColor;

  /// Defines the background color for selected range end date year cell.
  final Color endRangeSelectionColor;

  /// Defines the background color for selected range in between dates cell.
  final Color rangeSelectionColor;

  /// Holds the visible dates for the year view.
  final List<dynamic> visibleDates;

  /// Used to identify the widget direction is RTL.
  final bool isRtl;

  /// Defines the today cell highlight color.
  final Color todayHighlightColor;

  /// The minimum date as much as the [SfDateRangePicker] will navigate.
  final dynamic minDate;

  /// The maximum date as much as the [SfDateRangePicker] will navigate.
  final dynamic maxDate;

  /// Defines the navigation direction for [SfDateRangePicker].
  final DateRangePickerNavigationDirection navigationDirection;

  /// Decides to enable past dates or not.
  final bool enablePastDates;

  /// Decides the year cell highlight and selection shape.
  final DateRangePickerSelectionShape selectionShape;

  /// Holds the theme data for date range picker.
  final SfDateRangePickerThemeData datePickerTheme;

  /// Used to specify the mouse hover position of the year view.
  final ValueNotifier<Offset> mouseHoverPosition;

  /// Used to call repaint when the selection changes.
  final ValueNotifier<bool> selectionNotifier;

  /// Holds the selected value based on [SfDateRangePicker] selection mode.
  final List<dynamic> selectedRanges;

  /// Holds the selection radius of the year cell.
  final double selectionRadius;

  /// Decides to show the multi view of year view or not.
  final bool enableMultiView;

  /// Specifies the space between the multi year views.
  final double multiViewSpacing;

  /// Defines the text scale factor of [SfDateRangePicker].
  final double textScaleFactor;

  final String monthFormat;

  final Locale locale;

  final double width;

  final double height;

  final DateRangePickerView view;

  /// Defines the pickerType for [SfDateRangePicker].
  final bool isHijri;

  /// Specifies the localizations.
  final SfLocalizations localizations;

  @override
  _MultiRangeSelectionRenderObject createRenderObject(BuildContext context) {
    return _MultiRangeSelectionRenderObject(
        visibleDates,
        cellStyle,
        minDate,
        maxDate,
        enablePastDates,
        todayHighlightColor,
        selectionShape,
        isRtl,
        datePickerTheme,
        mouseHoverPosition,
        enableMultiView,
        multiViewSpacing,
        selectionTextStyle,
        rangeTextStyle,
        selectionColor,
        startRangeSelectionColor,
        endRangeSelectionColor,
        rangeSelectionColor,
        selectionRadius,
        textScaleFactor,
        width,
        height,
        monthFormat,
        locale,
        view,
        isHijri,
        navigationDirection,
        localizations,
        selectedRanges);
  }

  @override
  void updateRenderObject(
      BuildContext context, _MultiRangeSelectionRenderObject renderObject) {
    renderObject
      ..visibleDates = visibleDates
      ..cellStyle = cellStyle
      ..minDate = minDate
      ..maxDate = maxDate
      ..enablePastDates = enablePastDates
      ..todayHighlightColor = todayHighlightColor
      ..selectionShape = selectionShape
      ..isRtl = isRtl
      ..datePickerTheme = datePickerTheme
      ..mouseHoverPosition = mouseHoverPosition
      ..enableMultiView = enableMultiView
      ..multiViewSpacing = multiViewSpacing
      ..selectionTextStyle = selectionTextStyle
      ..rangeTextStyle = rangeTextStyle
      ..selectionColor = selectionColor
      ..startRangeSelectionColor = startRangeSelectionColor
      ..endRangeSelectionColor = endRangeSelectionColor
      ..rangeSelectionColor = rangeSelectionColor
      ..selectedRanges = selectedRanges
      ..selectionRadius = selectionRadius
      ..textScaleFactor = textScaleFactor
      ..width = width
      ..height = height
      ..isHijri = isHijri
      ..localizations = localizations
      ..monthFormat = monthFormat
      ..locale = locale
      ..navigationDirection = navigationDirection
      ..view = view;
  }
}

class _DatePickerParentData extends ContainerBoxParentData<RenderBox> {}

abstract class _IYearViewRenderObject extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _DatePickerParentData> {
  _IYearViewRenderObject(
      this._visibleDates,
      this._cellStyle,
      this._minDate,
      this._maxDate,
      this._enablePastDates,
      this._todayHighlightColor,
      this._selectionShape,
      this._isRtl,
      this._datePickerTheme,
      this._mouseHoverPosition,
      this._enableMultiView,
      this._multiViewSpacing,
      this._selectionTextStyle,
      this._rangeTextStyle,
      this._selectionColor,
      this._startRangeSelectionColor,
      this._endRangeSelectionColor,
      this._rangeSelectionColor,
      this._selectionRadius,
      this._textScaleFactor,
      this._width,
      this._height,
      this._monthFormat,
      this._locale,
      this._view,
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

  dynamic _cellStyle;

  dynamic get cellStyle => _cellStyle;

  set cellStyle(dynamic value) {
    if (_cellStyle == value) {
      return;
    }

    _cellStyle = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  TextStyle _selectionTextStyle;

  TextStyle get selectionTextStyle => _selectionTextStyle;

  set selectionTextStyle(TextStyle value) {
    if (_selectionTextStyle == value) {
      return;
    }

    _selectionTextStyle = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  TextStyle _rangeTextStyle;

  TextStyle get rangeTextStyle => _rangeTextStyle;

  set rangeTextStyle(TextStyle value) {
    if (_rangeTextStyle == value) {
      return;
    }

    _rangeTextStyle = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  Color _selectionColor;

  Color get selectionColor => _selectionColor;

  set selectionColor(Color value) {
    if (_selectionColor == value) {
      return;
    }

    _selectionColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  Color _startRangeSelectionColor;

  Color get startRangeSelectionColor => _startRangeSelectionColor;

  set startRangeSelectionColor(Color value) {
    if (_startRangeSelectionColor == value) {
      return;
    }

    _startRangeSelectionColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  Color _endRangeSelectionColor;

  Color get endRangeSelectionColor => _endRangeSelectionColor;

  set endRangeSelectionColor(Color value) {
    if (_endRangeSelectionColor == value) {
      return;
    }

    _endRangeSelectionColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  Color _rangeSelectionColor;

  Color get rangeSelectionColor => _rangeSelectionColor;

  set rangeSelectionColor(Color value) {
    if (_rangeSelectionColor == value) {
      return;
    }

    _rangeSelectionColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

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

  bool _isRtl;

  bool get isRtl => _isRtl;

  set isRtl(bool value) {
    if (_isRtl == value) {
      return;
    }

    _isRtl = value;
    markNeedsPaint();
  }

  Color _todayHighlightColor;

  Color get todayHighlightColor => _todayHighlightColor;

  set todayHighlightColor(Color value) {
    if (_todayHighlightColor == value) {
      return;
    }

    _todayHighlightColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

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

  DateRangePickerSelectionShape _selectionShape;

  DateRangePickerSelectionShape get selectionShape => _selectionShape;

  set selectionShape(DateRangePickerSelectionShape value) {
    if (_selectionShape == value) {
      return;
    }

    _selectionShape = value;
    markNeedsPaint();
  }

  ValueNotifier<Offset> _mouseHoverPosition;

  ValueNotifier<Offset> get mouseHoverPosition => _mouseHoverPosition;

  set mouseHoverPosition(ValueNotifier<Offset> value) {
    if (_mouseHoverPosition == value) {
      return;
    }

    _mouseHoverPosition?.removeListener(markNeedsPaint);
    _mouseHoverPosition = value;
    markNeedsPaint();
  }

  double _selectionRadius;

  double get selectionRadius => _selectionRadius;

  set selectionRadius(double value) {
    if (_selectionRadius == value) {
      return;
    }

    _selectionRadius = value;
    markNeedsPaint();
  }

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

  String _monthFormat;

  String get monthFormat => _monthFormat;

  set monthFormat(String value) {
    if (_monthFormat == value) {
      return;
    }

    _monthFormat = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  Locale _locale;

  Locale get locale => _locale;

  set locale(Locale value) {
    if (_locale == value) {
      return;
    }

    _locale = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  DateRangePickerView _view;

  DateRangePickerView get view => _view;

  set view(DateRangePickerView value) {
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

  /// Defines the pickerType for [SfDateRangePicker].
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

  /// Specifies the localizations.
  SfLocalizations localizations;

  /// Used to draw year cell text in month view.
  TextPainter _textPainter;

  /// Used to paint the selection of year cell and today highlight on all
  /// the selection mode.
  Paint _todayHighlightPaint;

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _mouseHoverPosition?.addListener(markNeedsPaint);
  }

  /// detach will called when the render object removed from view.
  @override
  void detach() {
    _mouseHoverPosition?.removeListener(markNeedsPaint);
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
    RenderBox child = firstChild;
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

    final double cellWidth = currentWidth / YearView.maxColumnCount;
    final double cellHeight = currentHeight / YearView.maxRowCount;
    while (child != null) {
      child.layout(constraints.copyWith(
          minHeight: cellHeight,
          maxHeight: cellHeight,
          minWidth: cellWidth,
          maxWidth: cellWidth));
      child = childAfter(child);
    }
  }

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

  List<int> getSelectedIndex(int viewStartIndex, int viewEndIndex);

  void drawSelection(
      Canvas canvas,
      double cellWidth,
      int currentIndex,
      double highlightPadding,
      double selectionPadding,
      double textHalfHeight,
      centerYPosition,
      double xPosition,
      double yPosition,
      TextSpan yearText);

  /// draw selection when the cell have custom widget.
  void drawCustomCellSelection(Canvas canvas, Rect rect, int index);

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    double left, top;
    Map<String, double> leftAndTopValue;
    int count = 1;
    double width = size.width;
    double height = size.height;
    double webUIPadding = 0;
    final bool isHorizontalMultiView = _enableMultiView &&
        _navigationDirection == DateRangePickerNavigationDirection.horizontal;
    final bool isVerticalMultiView = _enableMultiView &&
        _navigationDirection == DateRangePickerNavigationDirection.vertical;
    if (isHorizontalMultiView) {
      webUIPadding = _multiViewSpacing;
      count = 2;
      width = (width - webUIPadding) / count;
    } else if (isVerticalMultiView) {
      webUIPadding = _multiViewSpacing;
      count = 2;
      height = (height - webUIPadding) / count;
    }

    final double cellWidth = width / 3;
    final double cellHeight = height / 4;
    final int datesCount = visibleDates.length ~/ count;
    for (int j = 0; j < count; j++) {
      final int currentViewIndex =
          isRtl ? DateRangePickerHelper.getRtlIndex(count, j) : j;
      left = isRtl ? width - cellWidth : 0;
      top = 0;
      final double startXPosition = isVerticalMultiView
          ? 0
          : (currentViewIndex * width) + (currentViewIndex * webUIPadding);
      final double startYPosition = isHorizontalMultiView
          ? 0
          : (currentViewIndex * height) + (currentViewIndex * webUIPadding);

      final int startIndex = j * datesCount;
      for (int i = 0; i < datesCount; i++) {
        final dynamic date = visibleDates[startIndex + i];
        if (DateRangePickerHelper.isLeadingCellDate(
            startIndex + i, startIndex, _visibleDates, _view)) {
          leftAndTopValue = DateRangePickerHelper.getTopAndLeftValues(
              isRtl, left, top, cellWidth, cellHeight, width);
          left = leftAndTopValue['left'];
          top = leftAndTopValue['top'];
          continue;
        }

        if (!DateRangePickerHelper.isBetweenMinMaxDateCell(
            date, _minDate, _maxDate, _enablePastDates, _view, _isHijri)) {
          semanticsBuilder.add(CustomPainterSemantics(
            rect: Rect.fromLTWH(startXPosition + left, startYPosition + top,
                cellWidth, cellHeight),
            properties: SemanticsProperties(
              label: getCellSemanticsText(date) + 'Disabled cell',
              textDirection: TextDirection.ltr,
            ),
          ));

          leftAndTopValue = DateRangePickerHelper.getTopAndLeftValues(
              isRtl, left, top, cellWidth, cellHeight, width);
          left = leftAndTopValue['left'];
          top = leftAndTopValue['top'];
          continue;
        }
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(startXPosition + left, startYPosition + top,
              cellWidth, cellHeight),
          properties: SemanticsProperties(
            label: getCellSemanticsText(date),
            textDirection: TextDirection.ltr,
          ),
        ));
        leftAndTopValue = DateRangePickerHelper.getTopAndLeftValues(
            isRtl, left, top, cellWidth, cellHeight, width);
        left = leftAndTopValue['left'];
        top = leftAndTopValue['top'];
      }
    }

    return semanticsBuilder;
  }

  /// Return list of int value in between start and end date index value.
  List<int> _getRangeIndex(dynamic startDate, dynamic endDate,
      DateRangePickerView pickerView, int viewStartIndex, int viewEndIndex) {
    int startIndex = -1;
    int endIndex = -1;
    final List<int> selectedIndex = <int>[];

    /// Check the start date as before of end date, if not then swap
    /// the start and end date values.
    if (startDate != null && startDate.isAfter(endDate)) {
      final dynamic temp = startDate;
      startDate = endDate;
      endDate = temp;
    }

    final dynamic viewStartDate = visibleDates[viewStartIndex];
    final dynamic viewEndDate = DateRangePickerHelper.getLastDate(
        visibleDates[viewEndIndex], pickerView, _isHijri);
    if (startDate != null) {
      /// Assign start index as -1 when the start date before view start date.
      if (viewStartDate.isAfter(startDate) && viewStartDate.isBefore(endDate)) {
        startIndex = -1;
      } else {
        startIndex = DateRangePickerHelper.getDateCellIndex(
            visibleDates, startDate, pickerView,
            viewStartIndex: viewStartIndex, viewEndIndex: viewEndIndex);
      }
    }

    if (endDate != null) {
      /// Assign end index as visible dates length when the
      /// end date after of view end date.
      if (viewEndDate.isAfter(startDate) && viewEndDate.isBefore(endDate)) {
        endIndex = viewEndIndex + 1;
      } else {
        endIndex = DateRangePickerHelper.getDateCellIndex(
            visibleDates, endDate, _view,
            viewStartIndex: viewStartIndex, viewEndIndex: viewEndIndex);
      }
    }

    //// If some range end date as null then it end index is start index.
    if (startIndex != -1 && endIndex == -1) {
      endIndex = startIndex;
    }

    /// Check the start index as before of end index, if not then swap
    /// the start and end index values.
    if (startIndex > endIndex) {
      final int temp = startIndex;
      startIndex = endIndex;
      endIndex = temp;
    }

    /// Add the index values in between start and end index values.
    for (int i = startIndex; i <= endIndex; i++) {
      selectedIndex.add(i);
    }

    return selectedIndex;
  }

  String _getCellText(dynamic date) {
    if (_view == DateRangePickerView.year) {
      final String format =
          monthFormat == null || monthFormat.isEmpty ? 'MMM' : monthFormat;
      if (isHijri) {
        return DateRangePickerHelper.getHijriMonthText(
            date, localizations, format);
      } else {
        return DateFormat(format, locale.toString()).format(date).toString();
      }
    } else if (_view == DateRangePickerView.decade) {
      return date.year.toString();
    } else if (_view == DateRangePickerView.century) {
      return date.year.toString() + ' - ' + (date.year + 9).toString();
    }

    return '';
  }

  String getCellSemanticsText(dynamic date) {
    if (_view == DateRangePickerView.year) {
      if (isHijri) {
        return DateRangePickerHelper.getHijriMonthText(
                date, localizations, 'MMMM') +
            date.year.toString();
      } else {
        return DateFormat('MMMM yyyy').format(date).toString();
      }
    } else if (_view == DateRangePickerView.decade) {
      return date.year.toString();
    } else if (_view == DateRangePickerView.century) {
      return date.year.toString() + ' to ' + (date.year + 9).toString();
    }

    return '';
  }

  void _addMouseHovering(
      Canvas canvas,
      double cellWidth,
      double cellHeight,
      double centerYPosition,
      int currentViewIndex,
      double width,
      double highlightPadding,
      dynamic date,
      double selectionPadding,
      double textHalfHeight,
      double webUIPadding,
      double xOffset,
      double xPosition,
      double yOffset,
      double yPosition) {
    if (xPosition <= _mouseHoverPosition.value.dx &&
        xPosition + cellWidth >= _mouseHoverPosition.value.dx &&
        yPosition <= _mouseHoverPosition.value.dy &&
        yPosition + cellHeight >= _mouseHoverPosition.value.dy) {
      _todayHighlightPaint = _todayHighlightPaint ?? Paint();
      _todayHighlightPaint.style = PaintingStyle.fill;
      _todayHighlightPaint.strokeWidth = 2;
      _todayHighlightPaint.color = selectionColor != null
          ? selectionColor.withOpacity(0.4)
          : datePickerTheme.selectionColor.withOpacity(0.4);

      if (centerYPosition - textHalfHeight < highlightPadding / 2) {
        highlightPadding = (centerYPosition - textHalfHeight / 2) - 1;
      }

      final Rect rect = Rect.fromLTRB(
          xPosition + selectionPadding,
          yPosition + centerYPosition - highlightPadding - textHalfHeight,
          xPosition + cellWidth - selectionPadding,
          yPosition + centerYPosition + highlightPadding + textHalfHeight);
      double cornerRadius = rect.height / 2;
      switch (selectionShape) {
        case DateRangePickerSelectionShape.rectangle:
          {
            cornerRadius = 3;
          }
          break;
        case DateRangePickerSelectionShape.circle:
          break;
      }

      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)),
          _todayHighlightPaint);
    }
  }

  void _drawTodayHighlight(
      Canvas canvas,
      double cellWidth,
      double cellHeight,
      double centerYPosition,
      double highlightPadding,
      double selectionPadding,
      double textHalfHeight,
      double xPosition,
      double yPosition) {
    _todayHighlightPaint ??= Paint();
    _todayHighlightPaint.color =
        todayHighlightColor ?? datePickerTheme.todayHighlightColor;
    _todayHighlightPaint.isAntiAlias = true;
    _todayHighlightPaint.strokeWidth = 1.0;
    _todayHighlightPaint.style = PaintingStyle.stroke;
    final double maximumHighlight =
        centerYPosition - textHalfHeight - selectionPadding;
    if (maximumHighlight < highlightPadding) {
      highlightPadding = maximumHighlight;
    }

    final Rect rect = Rect.fromLTRB(
        xPosition + selectionPadding,
        yPosition + centerYPosition - highlightPadding - textHalfHeight,
        xPosition + cellWidth - selectionPadding,
        yPosition + centerYPosition + highlightPadding + textHalfHeight);
    double cornerRadius = rect.height / 2;
    switch (selectionShape) {
      case DateRangePickerSelectionShape.rectangle:
        {
          cornerRadius = 3;
        }
        break;
      case DateRangePickerSelectionShape.circle:
        break;
    }

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)),
        _todayHighlightPaint);
  }

  void _drawYearDecoration(
      Canvas canvas,
      Decoration yearDecoration,
      double xPosition,
      double yPosition,
      double decorationPadding,
      double cellWidth,
      double cellHeight) {
    final BoxPainter boxPainter =
        yearDecoration.createBoxPainter(markNeedsPaint);
    boxPainter.paint(
        canvas,
        Offset(xPosition + decorationPadding, yPosition + decorationPadding),
        ImageConfiguration(
            size: Size(cellWidth - (2 * decorationPadding),
                cellHeight - (2 * decorationPadding))));
  }

  TextStyle _updateCellTextStyle(int j, bool isCurrentDate, bool isSelected,
      bool isEnableDate, bool isActiveDate) {
    if (!isEnableDate) {
      return cellStyle.disabledDatesTextStyle ??
          datePickerTheme.disabledCellTextStyle;
    }

    if (isSelected) {
      return selectionTextStyle ?? datePickerTheme.selectionTextStyle;
    }

    if (isCurrentDate) {
      return cellStyle.todayTextStyle ?? datePickerTheme.todayCellTextStyle;
    }

    if (!isActiveDate && !_isHijri) {
      return cellStyle.leadingDatesTextStyle ??
          datePickerTheme.leadingCellTextStyle;
    }

    return cellStyle.textStyle ?? datePickerTheme.cellTextStyle;
  }

  Decoration _updateCellDecoration(
      int j, bool isCurrentDate, bool isEnableDate, bool isActiveDate) {
    if (!isEnableDate) {
      return cellStyle.disabledDatesDecoration;
    }

    if (isCurrentDate) {
      return cellStyle.todayCellDecoration ?? cellStyle.cellDecoration;
    }

    if (!isActiveDate && !_isHijri) {
      return cellStyle.leadingDatesDecoration;
    }

    return cellStyle.cellDecoration;
  }
}

class _SingleSelectionRenderObject extends _IYearViewRenderObject {
  _SingleSelectionRenderObject(
      List<dynamic> visibleDates,
      cellStyle,
      dynamic minDate,
      dynamic maxDate,
      bool enablePastDates,
      Color todayHighlightColor,
      DateRangePickerSelectionShape selectionShape,
      bool isRtl,
      SfDateRangePickerThemeData datePickerTheme,
      ValueNotifier<Offset> mouseHoverPosition,
      bool enableMultiView,
      double multiViewSpacing,
      TextStyle selectionTextStyle,
      TextStyle rangeTextStyle,
      Color selectionColor,
      Color startRangeSelectionColor,
      Color endRangeSelectionColor,
      Color rangeSelectionColor,
      double selectionRadius,
      double textScaleFactor,
      double width,
      double height,
      String monthFormat,
      Locale locale,
      DateRangePickerView view,
      bool isHijri,
      DateRangePickerNavigationDirection navigationDirection,
      SfLocalizations localizations,
      this._selectedDate)
      : super(
            visibleDates,
            cellStyle,
            minDate,
            maxDate,
            enablePastDates,
            todayHighlightColor,
            selectionShape,
            isRtl,
            datePickerTheme,
            mouseHoverPosition,
            enableMultiView,
            multiViewSpacing,
            selectionTextStyle,
            rangeTextStyle,
            selectionColor,
            startRangeSelectionColor,
            endRangeSelectionColor,
            rangeSelectionColor,
            selectionRadius,
            textScaleFactor,
            width,
            height,
            monthFormat,
            locale,
            view,
            isHijri,
            navigationDirection,
            localizations);

  dynamic _selectedDate;

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
    _drawYearCells(context, size, this);
  }

  @override
  void drawSelection(
      Canvas canvas,
      double cellWidth,
      int currentIndex,
      double highlightPadding,
      double selectionPadding,
      double textHalfHeight,
      centerYPosition,
      double xPosition,
      double yPosition,
      TextSpan yearText) {
    _todayHighlightPaint ??= Paint();
    _todayHighlightPaint.isAntiAlias = true;
    _todayHighlightPaint.style = PaintingStyle.fill;
    final double maximumHighlight =
        centerYPosition - textHalfHeight - selectionPadding;
    if (maximumHighlight < highlightPadding) {
      highlightPadding = maximumHighlight;
    }

    final Rect rect = Rect.fromLTRB(
        xPosition + selectionPadding,
        yPosition + centerYPosition - highlightPadding - textHalfHeight,
        xPosition + cellWidth - selectionPadding,
        yPosition + centerYPosition + highlightPadding + textHalfHeight);
    final double cornerRadius =
        selectionShape == DateRangePickerSelectionShape.circle
            ? rect.height / 2
            : 3;
    _todayHighlightPaint.color =
        selectionColor ?? datePickerTheme.selectionColor;

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)),
        _todayHighlightPaint);
  }

  @override
  void drawCustomCellSelection(Canvas canvas, Rect rect, int index) {
    _todayHighlightPaint ??= Paint();
    _todayHighlightPaint.isAntiAlias = true;
    _todayHighlightPaint.style = PaintingStyle.fill;
    _todayHighlightPaint.color =
        selectionColor ?? datePickerTheme.selectionColor;
    canvas.drawRect(rect, _todayHighlightPaint);
  }

  @override
  List<int> getSelectedIndex(int viewStartIndex, int viewEndIndex) {
    final List<int> selectedIndex = <int>[];
    if (_selectedDate == null) {
      return selectedIndex;
    }

    final int index = DateRangePickerHelper.getDateCellIndex(
        visibleDates, _selectedDate, _view,
        viewStartIndex: viewStartIndex, viewEndIndex: viewEndIndex);
    if (index != -1) {
      selectedIndex.add(index);
    }

    return selectedIndex;
  }
}

class _MultipleSelectionRenderObject extends _IYearViewRenderObject {
  _MultipleSelectionRenderObject(
      List<dynamic> visibleDates,
      cellStyle,
      dynamic minDate,
      dynamic maxDate,
      bool enablePastDates,
      Color todayHighlightColor,
      DateRangePickerSelectionShape selectionShape,
      bool isRtl,
      SfDateRangePickerThemeData datePickerTheme,
      ValueNotifier<Offset> mouseHoverPosition,
      bool enableMultiView,
      double multiViewSpacing,
      TextStyle selectionTextStyle,
      TextStyle rangeTextStyle,
      Color selectionColor,
      Color startRangeSelectionColor,
      Color endRangeSelectionColor,
      Color rangeSelectionColor,
      double selectionRadius,
      double textScaleFactor,
      double width,
      double height,
      String monthFormat,
      Locale locale,
      DateRangePickerView view,
      bool isHijri,
      DateRangePickerNavigationDirection navigationDirection,
      SfLocalizations localizations,
      this._selectedDates)
      : super(
            visibleDates,
            cellStyle,
            minDate,
            maxDate,
            enablePastDates,
            todayHighlightColor,
            selectionShape,
            isRtl,
            datePickerTheme,
            mouseHoverPosition,
            enableMultiView,
            multiViewSpacing,
            selectionTextStyle,
            rangeTextStyle,
            selectionColor,
            startRangeSelectionColor,
            endRangeSelectionColor,
            rangeSelectionColor,
            selectionRadius,
            textScaleFactor,
            width,
            height,
            monthFormat,
            locale,
            view,
            isHijri,
            navigationDirection,
            localizations);

  List<dynamic> _selectedDates;

  List<dynamic> get selectedDates => _selectedDates;

  set selectedDates(List<dynamic> value) {
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
  void paint(PaintingContext context, Offset offset) {
    _drawYearCells(context, size, this);
  }

  @override
  void drawSelection(
      Canvas canvas,
      double cellWidth,
      int currentIndex,
      double highlightPadding,
      double selectionPadding,
      double textHalfHeight,
      centerYPosition,
      double xPosition,
      double yPosition,
      TextSpan yearText) {
    _todayHighlightPaint ??= Paint();
    _todayHighlightPaint.isAntiAlias = true;
    _todayHighlightPaint.style = PaintingStyle.fill;
    final double maximumHighlight =
        centerYPosition - textHalfHeight - selectionPadding;
    if (maximumHighlight < highlightPadding) {
      highlightPadding = maximumHighlight;
    }

    final Rect rect = Rect.fromLTRB(
        xPosition + selectionPadding,
        yPosition + centerYPosition - highlightPadding - textHalfHeight,
        xPosition + cellWidth - selectionPadding,
        yPosition + centerYPosition + highlightPadding + textHalfHeight);
    final double cornerRadius =
        selectionShape == DateRangePickerSelectionShape.circle
            ? rect.height / 2
            : 3;
    _todayHighlightPaint.color =
        selectionColor ?? datePickerTheme.selectionColor;

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)),
        _todayHighlightPaint);
  }

  @override
  void drawCustomCellSelection(Canvas canvas, Rect rect, int index) {
    _todayHighlightPaint ??= Paint();
    _todayHighlightPaint.isAntiAlias = true;
    _todayHighlightPaint.style = PaintingStyle.fill;
    _todayHighlightPaint.color =
        selectionColor ?? datePickerTheme.selectionColor;
    canvas.drawRect(rect, _todayHighlightPaint);
  }

  @override
  List<int> getSelectedIndex(int viewStartIndex, int viewEndIndex) {
    final List<int> selectedIndex = <int>[];
    if (_selectedDates == null) {
      return selectedIndex;
    }
    for (int i = 0; i < _selectedDates.length; i++) {
      final int index = DateRangePickerHelper.getDateCellIndex(
          visibleDates, _selectedDates[i], _view,
          viewStartIndex: viewStartIndex, viewEndIndex: viewEndIndex);
      if (index != -1) {
        selectedIndex.add(index);
      }
    }

    return selectedIndex;
  }
}

class _RangeSelectionRenderObject extends _IYearViewRenderObject {
  _RangeSelectionRenderObject(
      List<dynamic> visibleDates,
      cellStyle,
      dynamic minDate,
      dynamic maxDate,
      bool enablePastDates,
      Color todayHighlightColor,
      DateRangePickerSelectionShape selectionShape,
      bool isRtl,
      SfDateRangePickerThemeData datePickerTheme,
      ValueNotifier<Offset> mouseHoverPosition,
      bool enableMultiView,
      double multiViewSpacing,
      TextStyle selectionTextStyle,
      TextStyle rangeTextStyle,
      Color selectionColor,
      Color startRangeSelectionColor,
      Color endRangeSelectionColor,
      Color rangeSelectionColor,
      double selectionRadius,
      double textScaleFactor,
      double width,
      double height,
      String monthFormat,
      Locale locale,
      DateRangePickerView view,
      bool isHijri,
      DateRangePickerNavigationDirection navigationDirection,
      SfLocalizations localizations,
      this._selectedRange)
      : super(
            visibleDates,
            cellStyle,
            minDate,
            maxDate,
            enablePastDates,
            todayHighlightColor,
            selectionShape,
            isRtl,
            datePickerTheme,
            mouseHoverPosition,
            enableMultiView,
            multiViewSpacing,
            selectionTextStyle,
            rangeTextStyle,
            selectionColor,
            startRangeSelectionColor,
            endRangeSelectionColor,
            rangeSelectionColor,
            selectionRadius,
            textScaleFactor,
            width,
            height,
            monthFormat,
            locale,
            view,
            isHijri,
            navigationDirection,
            localizations);

  dynamic _selectedRange;

  dynamic get selectedRange => _selectedRange;

  set selectedRange(dynamic value) {
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

  List<int> _selectedIndex;

  @override
  void paint(PaintingContext context, Offset offset) {
    _selectedIndex = <int>[];
    _drawYearCells(context, size, this);
  }

  @override
  void drawSelection(
      Canvas canvas,
      double cellWidth,
      int currentIndex,
      double highlightPadding,
      double selectionPadding,
      double textHalfHeight,
      centerYPosition,
      double xPosition,
      double yPosition,
      TextSpan yearText) {
    _todayHighlightPaint ??= Paint();
    _todayHighlightPaint.isAntiAlias = true;
    _todayHighlightPaint.style = PaintingStyle.fill;
    final double maximumHighlight =
        centerYPosition - textHalfHeight - selectionPadding;
    if (maximumHighlight < highlightPadding) {
      highlightPadding = maximumHighlight;
    }

    final List<bool> selectionDetails = _getSelectedRangePosition(currentIndex);
    final bool isSelectedDate = selectionDetails[0];
    final bool isStartRange = selectionDetails[1];
    final bool isEndRange = selectionDetails[2];
    final bool isBetweenRange = selectionDetails[3];

    final Rect rect = Rect.fromLTRB(
        xPosition + (isBetweenRange || isEndRange ? 0 : selectionPadding),
        yPosition + centerYPosition - highlightPadding - textHalfHeight,
        xPosition +
            cellWidth -
            (isBetweenRange || isStartRange ? 0 : selectionPadding),
        yPosition + centerYPosition + highlightPadding + textHalfHeight);
    final double cornerRadius = isBetweenRange
        ? 0
        : (selectionShape == DateRangePickerSelectionShape.circle
            ? rect.height / 2
            : 3);
    final double leftRadius = isStartRange || isSelectedDate ? cornerRadius : 0;
    final double rightRadius = isEndRange || isSelectedDate ? cornerRadius : 0;
    if (isSelectedDate) {
      _todayHighlightPaint.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor;
    } else if (isStartRange) {
      _todayHighlightPaint.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor;
    } else if (isBetweenRange) {
      yearText = TextSpan(
        text: yearText.text,
        style: rangeTextStyle ?? datePickerTheme.rangeSelectionTextStyle,
      );

      _todayHighlightPaint.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor;
      _textPainter.text = yearText;
      _textPainter.layout(minWidth: cellWidth, maxWidth: cellWidth);
    } else if (isEndRange) {
      _todayHighlightPaint.color =
          endRangeSelectionColor ?? datePickerTheme.endRangeSelectionColor;
    }

    canvas.drawRRect(
        RRect.fromRectAndCorners(rect,
            topLeft: Radius.circular(leftRadius),
            bottomLeft: Radius.circular(leftRadius),
            bottomRight: Radius.circular(rightRadius),
            topRight: Radius.circular(rightRadius)),
        _todayHighlightPaint);
  }

  @override
  void drawCustomCellSelection(Canvas canvas, Rect rect, int index) {
    _todayHighlightPaint ??= Paint();
    _todayHighlightPaint.isAntiAlias = true;
    _todayHighlightPaint.style = PaintingStyle.fill;
    final List<bool> selectionDetails = _getSelectedRangePosition(index);
    final bool isSelectedDate = selectionDetails[0];
    final bool isStartRange = selectionDetails[1];
    final bool isEndRange = selectionDetails[2];
    final bool isBetweenRange = selectionDetails[3];
    if (isSelectedDate) {
      _todayHighlightPaint.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor;
    } else if (isStartRange) {
      _todayHighlightPaint.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor;
    } else if (isBetweenRange) {
      _todayHighlightPaint.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor;
    } else if (isEndRange) {
      _todayHighlightPaint.color =
          endRangeSelectionColor ?? datePickerTheme.endRangeSelectionColor;
    }
    canvas.drawRect(rect, _todayHighlightPaint);
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
  List<int> getSelectedIndex(int viewStartIndex, int viewEndIndex) {
    _selectedIndex = <int>[];
    if (_selectedRange == null) {
      return _selectedIndex;
    }

    final dynamic startDate = _selectedRange.startDate;
    final dynamic endDate = _selectedRange.endDate ?? _selectedRange.startDate;
    _selectedIndex.addAll(
        _getRangeIndex(startDate, endDate, view, viewStartIndex, viewEndIndex));

    return _selectedIndex;
  }
}

class _MultiRangeSelectionRenderObject extends _IYearViewRenderObject {
  _MultiRangeSelectionRenderObject(
      List<dynamic> visibleDates,
      cellStyle,
      dynamic minDate,
      dynamic maxDate,
      bool enablePastDates,
      Color todayHighlightColor,
      DateRangePickerSelectionShape selectionShape,
      bool isRtl,
      SfDateRangePickerThemeData datePickerTheme,
      ValueNotifier<Offset> mouseHoverPosition,
      bool enableMultiView,
      double multiViewSpacing,
      TextStyle selectionTextStyle,
      TextStyle rangeTextStyle,
      Color selectionColor,
      Color startRangeSelectionColor,
      Color endRangeSelectionColor,
      Color rangeSelectionColor,
      double selectionRadius,
      double textScaleFactor,
      double width,
      double height,
      String monthFormat,
      Locale locale,
      DateRangePickerView view,
      bool isHijri,
      DateRangePickerNavigationDirection navigationDirection,
      SfLocalizations localizations,
      this._selectedRanges)
      : super(
            visibleDates,
            cellStyle,
            minDate,
            maxDate,
            enablePastDates,
            todayHighlightColor,
            selectionShape,
            isRtl,
            datePickerTheme,
            mouseHoverPosition,
            enableMultiView,
            multiViewSpacing,
            selectionTextStyle,
            rangeTextStyle,
            selectionColor,
            startRangeSelectionColor,
            endRangeSelectionColor,
            rangeSelectionColor,
            selectionRadius,
            textScaleFactor,
            width,
            height,
            monthFormat,
            locale,
            view,
            isHijri,
            navigationDirection,
            localizations);

  List<dynamic> _selectedRanges;

  List<dynamic> get selectedRanges => _selectedRanges;

  set selectedRanges(List<dynamic> value) {
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

  List<List<int>> _rangesIndex;

  @override
  void paint(PaintingContext context, Offset offset) {
    _rangesIndex = <List<int>>[];
    _drawYearCells(context, size, this);
  }

  @override
  void drawSelection(
      Canvas canvas,
      double cellWidth,
      int currentIndex,
      double highlightPadding,
      double selectionPadding,
      double textHalfHeight,
      centerYPosition,
      double xPosition,
      double yPosition,
      TextSpan yearText) {
    _todayHighlightPaint ??= Paint();
    _todayHighlightPaint.isAntiAlias = true;
    _todayHighlightPaint.style = PaintingStyle.fill;
    final double maximumHighlight =
        centerYPosition - textHalfHeight - selectionPadding;
    if (maximumHighlight < highlightPadding) {
      highlightPadding = maximumHighlight;
    }

    final List<bool> selectionDetails = _getSelectedRangePosition(currentIndex);
    final bool isSelectedDate = selectionDetails[0];
    final bool isStartRange = selectionDetails[1];
    final bool isEndRange = selectionDetails[2];
    final bool isBetweenRange = selectionDetails[3];

    final Rect rect = Rect.fromLTRB(
        xPosition + (isBetweenRange || isEndRange ? 0 : selectionPadding),
        yPosition + centerYPosition - highlightPadding - textHalfHeight,
        xPosition +
            cellWidth -
            (isBetweenRange || isStartRange ? 0 : selectionPadding),
        yPosition + centerYPosition + highlightPadding + textHalfHeight);
    final double cornerRadius = isBetweenRange
        ? 0
        : (selectionShape == DateRangePickerSelectionShape.circle
            ? rect.height / 2
            : 3);
    final double leftRadius = isStartRange || isSelectedDate ? cornerRadius : 0;
    final double rightRadius = isEndRange || isSelectedDate ? cornerRadius : 0;
    if (isSelectedDate) {
      _todayHighlightPaint.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor;
    } else if (isStartRange) {
      _todayHighlightPaint.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor;
    } else if (isBetweenRange) {
      yearText = TextSpan(
        text: yearText.text,
        style: rangeTextStyle ?? datePickerTheme.rangeSelectionTextStyle,
      );

      _todayHighlightPaint.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor;
      _textPainter.text = yearText;
      _textPainter.layout(minWidth: cellWidth, maxWidth: cellWidth);
    } else if (isEndRange) {
      _todayHighlightPaint.color =
          endRangeSelectionColor ?? datePickerTheme.endRangeSelectionColor;
    }

    canvas.drawRRect(
        RRect.fromRectAndCorners(rect,
            topLeft: Radius.circular(leftRadius),
            bottomLeft: Radius.circular(leftRadius),
            bottomRight: Radius.circular(rightRadius),
            topRight: Radius.circular(rightRadius)),
        _todayHighlightPaint);
  }

  @override
  void drawCustomCellSelection(Canvas canvas, Rect rect, int index) {
    _todayHighlightPaint ??= Paint();
    _todayHighlightPaint.isAntiAlias = true;
    _todayHighlightPaint.style = PaintingStyle.fill;
    final List<bool> selectionDetails = _getSelectedRangePosition(index);
    final bool isSelectedDate = selectionDetails[0];
    final bool isStartRange = selectionDetails[1];
    final bool isEndRange = selectionDetails[2];
    final bool isBetweenRange = selectionDetails[3];
    if (isSelectedDate) {
      _todayHighlightPaint.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor;
    } else if (isStartRange) {
      _todayHighlightPaint.color =
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor;
    } else if (isBetweenRange) {
      _todayHighlightPaint.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor;
    } else if (isEndRange) {
      _todayHighlightPaint.color =
          endRangeSelectionColor ?? datePickerTheme.endRangeSelectionColor;
    }
    canvas.drawRect(rect, _todayHighlightPaint);
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
    for (int i = 0; i < _rangesIndex.length; i++) {
      final List<int> range = _rangesIndex[i];
      if (!range.contains(index)) {
        continue;
      }

      if (range.length == 1) {
        isSelectedDate = true;
      } else if (range[0] == index) {
        if (isRtl) {
          isEndRange = true;
        } else {
          isStartRange = true;
        }
      } else if (range[range.length - 1] == index) {
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
  List<int> getSelectedIndex(int viewStartIndex, int viewEndIndex) {
    final List<int> selectedIndex = <int>[];
    if (_selectedRanges == null) {
      return selectedIndex;
    }

    for (int i = 0; i < _selectedRanges.length; i++) {
      final dynamic range = _selectedRanges[i];
      final dynamic startDate = range.startDate;
      final dynamic endDate = range.endDate ?? range.startDate;
      final List<int> index = _getRangeIndex(
          startDate, endDate, view, viewStartIndex, viewEndIndex);
      _rangesIndex.add(index);
      selectedIndex.addAll(index);
    }

    return selectedIndex;
  }
}

/// Check the date cell placed in current view or not.
bool _isCurrentViewDateCell(dynamic date, int index, List<dynamic> visibleDates,
    bool enableMultiView, dynamic view) {
  final DateRangePickerView pickerView =
      DateRangePickerHelper.getPickerView(view);

  if (pickerView == DateRangePickerView.year) {
    return true;
  }

  final int datesCount =
      enableMultiView ? visibleDates.length ~/ 2 : visibleDates.length;
  final int middleIndex = (index * datesCount) + (datesCount ~/ 2);
  final int currentYear = visibleDates[middleIndex].year;
  if (pickerView == DateRangePickerView.decade) {
    return currentYear ~/ 10 == date.year ~/ 10;
  } else if (pickerView == DateRangePickerView.century) {
    return currentYear ~/ 100 == date.year ~/ 100;
  }

  return false;
}

/// Draws the year cell on canvas based on selection mode.
void _drawYearCells(
    PaintingContext context, Size size, _IYearViewRenderObject yearView) {
  final Canvas canvas = context.canvas;
  double webUIPadding = 0;
  int count = 1;
  double width = size.width;
  double height = size.height;
  final bool isHorizontalMultiView = yearView.enableMultiView &&
      yearView.navigationDirection ==
          DateRangePickerNavigationDirection.horizontal;
  final bool isVerticalMultiView = yearView.enableMultiView &&
      yearView.navigationDirection ==
          DateRangePickerNavigationDirection.vertical;
  if (isHorizontalMultiView) {
    webUIPadding = yearView.multiViewSpacing;
    count = 2;
    width = (width - webUIPadding) / count;
  } else if (isVerticalMultiView) {
    webUIPadding = yearView.multiViewSpacing;
    count = 2;
    height = (height - webUIPadding) / count;
  }

  final int visibleDatesCount = yearView.visibleDates.length ~/ count;
  final double cellWidth = width / YearView.maxColumnCount;
  final double cellHeight = height / YearView.maxRowCount;

  double xPosition = 0, yPosition;
  final bool isNeedWidgetPaint = yearView.childCount != 0;
  final DateRangePickerView view =
      DateRangePickerHelper.getPickerView(yearView.view);

  if (isNeedWidgetPaint) {
    RenderBox child = yearView.firstChild;
    for (int j = 0; j < count; j++) {
      final int currentViewIndex =
          yearView.isRtl ? DateRangePickerHelper.getRtlIndex(count, j) : j;

      final int viewStartIndex = j * visibleDatesCount;
      final int viewEndIndex = ((j + 1) * visibleDatesCount) - 1;

      /// Calculate the selected index values based on selected date property.
      final List<int> selectedIndex =
          yearView.getSelectedIndex(viewStartIndex, viewEndIndex);

      final double viewStartPosition = isVerticalMultiView
          ? 0
          : (currentViewIndex * width) + (currentViewIndex * webUIPadding);
      final double viewEndPosition = viewStartPosition + width;
      xPosition = viewStartPosition;
      yPosition = isHorizontalMultiView
          ? 0
          : (currentViewIndex * height) + (currentViewIndex * webUIPadding);
      for (int i = 0; i < visibleDatesCount; i++) {
        int currentIndex = i;
        if (yearView.isRtl) {
          final int rowIndex = i ~/ YearView.maxColumnCount;
          currentIndex = DateRangePickerHelper.getRtlIndex(
                  YearView.maxColumnCount, i % YearView.maxColumnCount) +
              (rowIndex * YearView.maxColumnCount);
        }

        currentIndex += viewStartIndex;
        if (xPosition >= viewEndPosition) {
          xPosition = viewStartPosition;
          yPosition += cellHeight;
        }

        if ((yearView.enableMultiView || yearView.isHijri) &&
            DateRangePickerHelper.isLeadingCellDate(
                currentIndex, viewStartIndex, yearView.visibleDates, view)) {
          xPosition += cellWidth;
          continue;
        }

        final dynamic date = yearView.visibleDates[currentIndex];
        final bool isSelected = selectedIndex.contains(currentIndex);
        final bool isEnableDate = DateRangePickerHelper.isBetweenMinMaxDateCell(
            date,
            yearView.minDate,
            yearView.maxDate,
            yearView.enablePastDates,
            view,
            yearView.isHijri);

        if (isSelected && isEnableDate) {
          yearView.drawCustomCellSelection(
              canvas,
              Rect.fromLTRB(xPosition, yPosition, xPosition + cellWidth,
                  yPosition + cellHeight),
              currentIndex);
        }

        child.paint(context, Offset(xPosition, yPosition));

        if (!isSelected &&
            isEnableDate &&
            yearView.mouseHoverPosition != null &&
            yearView.mouseHoverPosition.value != null) {
          if (xPosition <= yearView.mouseHoverPosition.value.dx &&
              xPosition + cellWidth >= yearView.mouseHoverPosition.value.dx &&
              yPosition <= yearView.mouseHoverPosition.value.dy &&
              yPosition + cellHeight >= yearView.mouseHoverPosition.value.dy) {
            yearView._todayHighlightPaint =
                yearView._todayHighlightPaint ?? Paint();
            yearView._todayHighlightPaint.style = PaintingStyle.fill;
            yearView._todayHighlightPaint.strokeWidth = 2;
            yearView._todayHighlightPaint.color =
                yearView.selectionColor != null
                    ? yearView.selectionColor.withOpacity(0.4)
                    : yearView.datePickerTheme.selectionColor.withOpacity(0.4);

            final Rect rect = Rect.fromLTRB(xPosition, yPosition,
                xPosition + cellWidth, yPosition + cellHeight);
            canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(2)),
                yearView._todayHighlightPaint);
          }
        }

        xPosition += cellWidth;
        child = yearView.childAfter(child);
      }
    }
    return;
  }

  final dynamic today = DateRangePickerHelper.getToday(yearView.isHijri);
  yearView._textPainter ??= TextPainter(
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      maxLines: 2,
      textScaleFactor: yearView.textScaleFactor,
      textWidthBasis: TextWidthBasis.longestLine);

  const double decorationPadding = 1;
  const double selectionPadding = 3;
  final double centerYPosition = cellHeight / 2;

  for (int j = 0; j < count; j++) {
    final int currentViewIndex =
        yearView.isRtl ? DateRangePickerHelper.getRtlIndex(count, j) : j;

    final int viewStartIndex = j * visibleDatesCount;
    final int viewEndIndex = ((j + 1) * visibleDatesCount) - 1;

    /// Calculate the selected index values based on selected date property.
    final List<int> selectedIndex =
        yearView.getSelectedIndex(viewStartIndex, viewEndIndex);

    final double viewStartPosition = isVerticalMultiView
        ? 0
        : (currentViewIndex * width) + (currentViewIndex * webUIPadding);
    final double viewEndPosition = viewStartPosition + width;
    xPosition = viewStartPosition;
    yPosition = isHorizontalMultiView
        ? 0
        : (currentViewIndex * height) + (currentViewIndex * webUIPadding);

    for (int i = 0; i < visibleDatesCount; i++) {
      int currentIndex = i;
      if (yearView.isRtl) {
        final int rowIndex = i ~/ YearView.maxColumnCount;
        currentIndex = DateRangePickerHelper.getRtlIndex(
                YearView.maxColumnCount, i % YearView.maxColumnCount) +
            (rowIndex * YearView.maxColumnCount);
      }

      currentIndex += viewStartIndex;
      if (xPosition >= viewEndPosition) {
        xPosition = viewStartPosition;
        yPosition += cellHeight;
      }

      if ((yearView.enableMultiView || yearView.isHijri) &&
          DateRangePickerHelper.isLeadingCellDate(
              currentIndex, viewStartIndex, yearView.visibleDates, view)) {
        xPosition += cellWidth;
        continue;
      }

      final dynamic date = yearView.visibleDates[currentIndex];
      final bool isCurrentDate =
          DateRangePickerHelper.isSameCellDates(date, today, view);
      final bool isSelected = selectedIndex.contains(currentIndex);
      final bool isEnableDate = DateRangePickerHelper.isBetweenMinMaxDateCell(
          date,
          yearView.minDate,
          yearView.maxDate,
          yearView.enablePastDates,
          view,
          yearView.isHijri);
      final bool isActiveDate = _isCurrentViewDateCell(
          date, j, yearView.visibleDates, yearView.enableMultiView, view);
      final TextStyle style = yearView._updateCellTextStyle(
          j, isCurrentDate, isSelected, isEnableDate, isActiveDate);
      final Decoration yearDecoration = yearView._updateCellDecoration(
          j, isCurrentDate, isEnableDate, isActiveDate);

      final TextSpan yearText = TextSpan(
        text: yearView._getCellText(date),
        style: style,
      );

      yearView._textPainter.text = yearText;
      yearView._textPainter.layout(minWidth: cellWidth, maxWidth: cellWidth);

      final double highlightPadding = yearView.selectionRadius ?? 10;
      final double textHalfHeight = yearView._textPainter.height / 2;
      if (isSelected && isEnableDate) {
        yearView.drawSelection(
            canvas,
            cellWidth,
            currentIndex,
            highlightPadding,
            selectionPadding,
            textHalfHeight,
            centerYPosition,
            xPosition,
            yPosition,
            yearText);
      } else if (yearDecoration != null) {
        yearView._drawYearDecoration(canvas, yearDecoration, xPosition,
            yPosition, decorationPadding, cellWidth, cellHeight);
      } else if (isCurrentDate) {
        yearView._drawTodayHighlight(
            canvas,
            cellWidth,
            cellHeight,
            centerYPosition,
            highlightPadding,
            selectionPadding,
            textHalfHeight,
            xPosition,
            yPosition);
      }

      double xOffset =
          xPosition + ((cellWidth - yearView._textPainter.width) / 2);
      xOffset = xOffset < 0 ? 0 : xOffset;
      double yOffset =
          yPosition + ((cellHeight - yearView._textPainter.height) / 2);
      yOffset = yOffset < 0 ? 0 : yOffset;

      if (!isSelected &&
          isEnableDate &&
          yearView.mouseHoverPosition != null &&
          yearView.mouseHoverPosition.value != null) {
        yearView._addMouseHovering(
            canvas,
            cellWidth,
            cellHeight,
            centerYPosition,
            currentViewIndex,
            width,
            highlightPadding,
            date,
            selectionPadding,
            textHalfHeight,
            webUIPadding,
            xOffset,
            xPosition,
            yOffset,
            yPosition);
      }

      yearView._textPainter.paint(canvas, Offset(xOffset, yOffset));
      xPosition += cellWidth;
    }
  }
}
