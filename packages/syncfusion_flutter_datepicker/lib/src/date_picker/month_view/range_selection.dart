part of datepicker;

class _MonthViewRangeSelectionPainter extends _IMonthViewPainter {
  _MonthViewRangeSelectionPainter(
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
      this.selectedRange,
      this.selectionShape,
      this.selectionRadius,
      this.mouseHoverPosition,
      this.enableMultiView,
      this.multiViewSpacing,
      this.selectionNotifier,
      this.textScaleFactor)
      : super(selectionNotifier: selectionNotifier);

  @override
  final int rowCount;
  @override
  final DateRangePickerMonthCellStyle cellStyle;
  @override
  final List<DateTime> visibleDates;
  @override
  final SfDateRangePickerThemeData datePickerTheme;
  @override
  final bool isRtl;
  @override
  final Color todayHighlightColor;
  @override
  final DateTime minDate;
  @override
  final DateTime maxDate;
  @override
  final bool enablePastDates;
  @override
  final bool showLeadingAndTailingDates;
  @override
  final List<DateTime> blackoutDates;
  @override
  final List<int> weekendDays;
  @override
  final List<DateTime> specialDates;
  @override
  final DateRangePickerSelectionShape selectionShape;
  @override
  final double selectionRadius;
  @override
  final bool enableMultiView;
  @override
  final double multiViewSpacing;
  @override
  final Offset mouseHoverPosition;
  @override
  final TextStyle selectionTextStyle;
  @override
  final TextStyle rangeTextStyle;
  @override
  final Color selectionColor;
  @override
  final Color startRangeSelectionColor;
  @override
  final Color endRangeSelectionColor;
  @override
  final Color rangeSelectionColor;
  PickerDateRange selectedRange;
  @override
  ValueNotifier<bool> selectionNotifier;
  @override
  Paint selectionPainter;
  @override
  TextPainter textPainter;
  @override
  final double textScaleFactor;
  double _cellWidth, _cellHeight;
  double _centerXPosition, _centerYPosition;
  List<int> _selectedIndex;

  @override
  TextStyle _drawSelection(Canvas canvas, double x, double y, int index,
      TextStyle selectionTextStyle, TextStyle selectionRangeTextStyle) {
    bool isSelectedDate = false;
    bool isStartRange = false;
    bool isEndRange = false;
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

    final double radius =
        _getCellRadius(selectionRadius, _centerXPosition, _centerYPosition);
    final double heightDifference = _cellHeight / 2 - radius;
    if (isSelectedDate) {
      _drawSelectedDate(canvas, radius, _centerXPosition, _cellWidth,
          _cellHeight, x, y, this, _centerYPosition);
    } else if (isStartRange) {
      selectionPainter.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor;
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
          startRangeSelectionColor ?? datePickerTheme.startRangeSelectionColor,
          heightDifference,
          isStartRange);
    } else if (isEndRange) {
      selectionPainter.color =
          rangeSelectionColor ?? datePickerTheme.rangeSelectionColor;
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
          endRangeSelectionColor ?? datePickerTheme.endRangeSelectionColor,
          heightDifference,
          isStartRange);
    } else if (isBetweenRange) {
      return _drawBetweenSelection(canvas, this, _cellWidth, _cellHeight,
          radius, x, y, heightDifference, selectionRangeTextStyle);
    }

    return selectionTextStyle;
  }

  @override
  List<int> _getSelectedIndexValues(int viewStartIndex, int viewEndIndex) {
    _selectedIndex = <int>[];
    if (selectedRange != null) {
      final DateTime startDate = selectedRange.startDate;
      final DateTime endDate = selectedRange.endDate ?? selectedRange.startDate;
      _selectedIndex = _getSelectedRangeIndex(startDate, endDate, visibleDates,
          monthStartIndex: viewStartIndex, monthEndIndex: viewEndIndex);
    }

    return _selectedIndex;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _cellWidth = size.width / _kNumberOfDaysInWeek;
    if (enableMultiView) {
      _cellWidth = (size.width - multiViewSpacing) / (_kNumberOfDaysInWeek * 2);
    }

    _cellHeight = size.height / rowCount;
    _centerXPosition = _cellWidth / 2;
    _centerYPosition = _cellHeight / 2;
    _drawMonthCellsAndSelection(canvas, size, this, _cellWidth, _cellHeight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _MonthViewRangeSelectionPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.rowCount != rowCount ||
        oldWidget.todayHighlightColor != todayHighlightColor ||
        oldWidget.enablePastDates != enablePastDates ||
        oldWidget.showLeadingAndTailingDates != showLeadingAndTailingDates ||
        oldWidget.cellStyle != cellStyle ||
        oldWidget.minDate != minDate ||
        oldWidget.maxDate != maxDate ||
        oldWidget.enableMultiView != enableMultiView ||
        oldWidget.multiViewSpacing != multiViewSpacing ||
        oldWidget.selectedRange != selectedRange ||
        oldWidget.blackoutDates != blackoutDates ||
        oldWidget.specialDates != specialDates ||
        oldWidget.selectionShape != selectionShape ||
        oldWidget.selectionRadius != selectionRadius ||
        oldWidget.rangeSelectionColor != rangeSelectionColor ||
        oldWidget.endRangeSelectionColor != endRangeSelectionColor ||
        oldWidget.startRangeSelectionColor != startRangeSelectionColor ||
        oldWidget.selectionColor != selectionColor ||
        oldWidget.rangeTextStyle != rangeTextStyle ||
        oldWidget.selectionTextStyle != selectionTextStyle ||
        oldWidget.isRtl != isRtl ||
        oldWidget.datePickerTheme != datePickerTheme ||
        oldWidget.textScaleFactor != textScaleFactor ||
        (kIsWeb && oldWidget.mouseHoverPosition != mouseHoverPosition);
  }

  @override
  void _updateSelection(_PickerStateArgs details) {
    if (_isRangeEquals(details._selectedRange, selectedRange)) {
      return;
    }

    selectedRange = details._selectedRange;
    selectionNotifier.value = !selectionNotifier.value;
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilderForMonthView(size, rowCount, this);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _MonthViewRangeSelectionPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates;
  }
}
