part of datepicker;

class _PickerCenturyViewPainter extends _IPickerYearView {
  _PickerCenturyViewPainter(
      this.visibleDates,
      this.cellStyle,
      this.minDate,
      this.maxDate,
      this.enablePastDates,
      this.todayHighlightColor,
      this.selectionShape,
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
      this.selectionMode,
      this.selectionRadius,
      this.selectionNotifier,
      this.textScaleFactor)
      : super(selectionNotifier: selectionNotifier);

  @override
  final DateRangePickerYearCellStyle cellStyle;
  @override
  final List<DateTime> visibleDates;
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
  final DateRangePickerSelectionShape selectionShape;
  @override
  final Offset mouseHoverPosition;
  @override
  final DateRangePickerSelectionMode selectionMode;
  @override
  final double selectionRadius;
  @override
  final bool enableMultiView;
  @override
  final double multiViewSpacing;
  @override
  final ValueNotifier<bool> selectionNotifier;
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
  @override
  dynamic selectedDate;
  @override
  TextPainter textPainter;
  final Locale locale;
  @override
  Paint todayHighlightPaint;
  @override
  final SfDateRangePickerThemeData datePickerTheme;
  @override
  final double textScaleFactor;

  @override
  void paint(Canvas canvas, Size size) {
    _drawYearCells(canvas, size, this, DateRangePickerView.century);
  }

  @override
  bool _isSameView(DateTime date, DateTime currentDate) {
    if (date == null || currentDate == null) {
      return false;
    }

    if (date.year ~/ 10 == currentDate.year ~/ 10) {
      return true;
    }

    return false;
  }

  @override
  bool _isTrailingDate(int index, int viewStartIndex) {
    final DateTime currentDate = visibleDates[index];
    final DateTime viewStartDate = visibleDates[viewStartIndex];
    return currentDate.year ~/ 100 != viewStartDate.year ~/ 100;
  }

  @override
  bool _isBetweenMinMaxMonth(DateTime date) {
    if (date == null || minDate == null || maxDate == null) {
      return true;
    }

    final int today = DateTime.now().year ~/ 10;
    final int currentYear = date.year ~/ 10;
    if (currentYear >= (minDate.year ~/ 10) &&
        currentYear <= (maxDate.year ~/ 10) &&
        (enablePastDates || (!enablePastDates && currentYear >= today))) {
      return true;
    }

    return false;
  }

  @override
  bool _isSameOrBeforeView(DateTime currentMaxDate, DateTime currentDate) {
    return (currentDate.year ~/ 10) <= (currentMaxDate.year ~/ 10);
  }

  @override
  bool _isSameOrAfterView(DateTime currentMinDate, DateTime currentDate) {
    return (currentDate.year ~/ 10) >= (currentMinDate.year ~/ 10);
  }

  @override
  void _updateSelection(_PickerStateArgs details) {
    _updateYearViewSelection(this, details);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _PickerCenturyViewPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.todayHighlightColor != todayHighlightColor ||
        oldWidget.enablePastDates != enablePastDates ||
        oldWidget.cellStyle != cellStyle ||
        oldWidget.minDate != minDate ||
        oldWidget.maxDate != maxDate ||
        oldWidget.selectionShape != selectionShape ||
        oldWidget.isRtl != isRtl ||
        oldWidget.datePickerTheme != datePickerTheme ||
        oldWidget.enableMultiView != enableMultiView ||
        oldWidget.multiViewSpacing != multiViewSpacing ||
        oldWidget.selectedDate != selectedDate ||
        oldWidget.selectionMode != selectionMode ||
        oldWidget.rangeSelectionColor != rangeSelectionColor ||
        oldWidget.endRangeSelectionColor != endRangeSelectionColor ||
        oldWidget.startRangeSelectionColor != startRangeSelectionColor ||
        oldWidget.selectionColor != selectionColor ||
        oldWidget.rangeTextStyle != rangeTextStyle ||
        oldWidget.selectionTextStyle != selectionTextStyle ||
        oldWidget.selectionRadius != selectionRadius ||
        oldWidget.locale != locale ||
        oldWidget.textScaleFactor != textScaleFactor ||
        (kIsWeb && oldWidget.mouseHoverPosition != mouseHoverPosition);
  }

  @override
  String _getCellText(DateTime date) {
    return date.year.toString() + ' - ' + (date.year + 9).toString();
  }

  @override
  bool _isCurrentView(DateTime date, int index) {
    final int datesCount =
        enableMultiView ? visibleDates.length ~/ 2 : visibleDates.length;
    final int middleIndex = (index * datesCount) + (datesCount ~/ 2);
    final int currentYear = visibleDates[middleIndex].year;
    return currentYear ~/ 100 == date.year ~/ 100;
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilderForYearView(size, this);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _PickerCenturyViewPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates;
  }
}
