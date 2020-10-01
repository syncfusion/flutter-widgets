part of datepicker;

class _PickerYearViewPainter extends _IPickerYearView {
  _PickerYearViewPainter(
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
  final String monthFormat;
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
  final Locale locale;
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
  @override
  Paint todayHighlightPaint;
  @override
  final SfDateRangePickerThemeData datePickerTheme;
  @override
  final double textScaleFactor;

  @override
  void paint(Canvas canvas, Size size) {
    _drawYearCells(canvas, size, this, DateRangePickerView.year);
  }

  @override
  bool _isSameView(DateTime date, DateTime currentDate) {
    if (date == null || currentDate == null) {
      return false;
    }

    if (date.month == currentDate.month && date.year == currentDate.year) {
      return true;
    }

    return false;
  }

  @override
  bool _isTrailingDate(int index, int viewStartIndex) {
    return false;
  }

  @override
  bool _isBetweenMinMaxMonth(DateTime date) {
    if (date == null || minDate == null || maxDate == null) {
      return true;
    }

    final DateTime today = DateTime.now();
    if (((date.month >= minDate.month && date.year == minDate.year) ||
            date.year > minDate.year) &&
        ((date.month <= maxDate.month && date.year == maxDate.year) ||
            date.year < maxDate.year) &&
        (enablePastDates ||
            (!enablePastDates &&
                ((date.month >= today.month && date.year == today.year) ||
                    date.year > today.year)))) {
      return true;
    }

    return false;
  }

  @override
  bool _isSameOrBeforeView(DateTime currentMaxDate, DateTime currentDate) {
    return (currentDate.month <= currentMaxDate.month &&
            currentDate.year == currentMaxDate.year) ||
        currentDate.year < currentMaxDate.year;
  }

  @override
  bool _isSameOrAfterView(DateTime currentMinDate, DateTime currentDate) {
    return (currentDate.month >= currentMinDate.month &&
            currentDate.year == currentMinDate.year) ||
        currentDate.year > currentMinDate.year;
  }

  @override
  void _updateSelection(_PickerStateArgs details) {
    _updateYearViewSelection(this, details);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _PickerYearViewPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.todayHighlightColor != todayHighlightColor ||
        oldWidget.enablePastDates != enablePastDates ||
        oldWidget.cellStyle != cellStyle ||
        oldWidget.minDate != minDate ||
        oldWidget.maxDate != maxDate ||
        oldWidget.enableMultiView != enableMultiView ||
        oldWidget.multiViewSpacing != multiViewSpacing ||
        oldWidget.selectionShape != selectionShape ||
        oldWidget.monthFormat != monthFormat ||
        oldWidget.isRtl != isRtl ||
        oldWidget.datePickerTheme != datePickerTheme ||
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
    return DateFormat(
            monthFormat == null || monthFormat.isEmpty ? 'MMM' : monthFormat,
            locale.toString())
        .format(date)
        .toString();
  }

  @override
  bool _isCurrentView(DateTime date, int index) {
    return true;
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilderForYearView(size, this);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _PickerYearViewPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates;
  }
}
