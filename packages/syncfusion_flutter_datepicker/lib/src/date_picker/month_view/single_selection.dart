part of datepicker;

class _MonthViewSingleSelectionPainter extends _IMonthViewPainter {
  _MonthViewSingleSelectionPainter(
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
      this.selectedDate,
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
  final List<DateTime> specialDates;
  @override
  final List<int> weekendDays;
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
  DateTime selectedDate;
  @override
  ValueNotifier<bool> selectionNotifier;
  @override
  final double textScaleFactor;
  @override
  Paint selectionPainter;
  @override
  TextPainter textPainter;
  double _cellWidth, _cellHeight;
  double _centerXPosition, _centerYPosition;

  @override
  TextStyle _drawSelection(Canvas canvas, double x, double y, int index,
      TextStyle selectionTextStyle, TextStyle selectionRangeTextStyle) {
    selectionPainter.isAntiAlias = true;
    switch (selectionShape) {
      case DateRangePickerSelectionShape.circle:
        {
          final double radius = _getCellRadius(
              selectionRadius, _centerXPosition, _centerYPosition);
          _drawCircleSelection(canvas, x + _centerXPosition,
              y + _centerYPosition, radius, selectionPainter);
        }
        break;
      case DateRangePickerSelectionShape.rectangle:
        {
          _drawFillSelection(
              canvas, x, y, _cellWidth, _cellHeight, selectionPainter);
        }
    }

    return selectionTextStyle;
  }

  @override
  List<int> _getSelectedIndexValues(int viewStartIndex, int viewEndIndex) {
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
    final _MonthViewSingleSelectionPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.rowCount != rowCount ||
        oldWidget.todayHighlightColor != todayHighlightColor ||
        oldWidget.enablePastDates != enablePastDates ||
        oldWidget.showLeadingAndTailingDates != showLeadingAndTailingDates ||
        oldWidget.cellStyle != cellStyle ||
        oldWidget.minDate != minDate ||
        oldWidget.enableMultiView != enableMultiView ||
        oldWidget.multiViewSpacing != multiViewSpacing ||
        oldWidget.maxDate != maxDate ||
        oldWidget.selectedDate != selectedDate ||
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
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilderForMonthView(size, rowCount, this);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _MonthViewSingleSelectionPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates;
  }

  @override
  void _updateSelection(_PickerStateArgs details) {
    if (isSameDate(details._selectedDate, selectedDate)) {
      return;
    }

    selectedDate = details._selectedDate;
    selectionNotifier.value = !selectionNotifier.value;
  }
}
