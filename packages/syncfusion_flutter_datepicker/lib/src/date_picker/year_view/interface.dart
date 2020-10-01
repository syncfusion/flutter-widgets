part of datepicker;

abstract class _IPickerYearView extends CustomPainter {
  _IPickerYearView({ValueNotifier<bool> selectionNotifier})
      : super(repaint: selectionNotifier);
  DateRangePickerYearCellStyle cellStyle;
  TextStyle selectionTextStyle;
  TextStyle rangeTextStyle;
  Color selectionColor;
  Color startRangeSelectionColor;
  Color endRangeSelectionColor;
  Color rangeSelectionColor;
  List<DateTime> visibleDates;
  bool isRtl;
  Color todayHighlightColor;
  DateTime minDate;
  DateTime maxDate;
  bool enablePastDates;
  DateRangePickerSelectionShape selectionShape;
  SfDateRangePickerThemeData datePickerTheme;
  TextPainter textPainter;
  Paint todayHighlightPaint;
  Offset mouseHoverPosition;
  ValueNotifier<bool> selectionNotifier;
  dynamic selectedDate;
  double selectionRadius;
  DateRangePickerSelectionMode selectionMode;
  bool enableMultiView;
  double multiViewSpacing;
  double textScaleFactor;
  static const int _maxColumnCount = 3;
  static const int _maxRowCount = 4;

  @override
  void paint(Canvas canvas, Size size);

  /// Update selection method used to update the selected date value and
  /// call the draw method to update selection on year, decade and century views
  void _updateSelection(_PickerStateArgs details);

  @override
  bool shouldRepaint(CustomPainter oldDelegate);

  /// Check whether the dates are in same view or not.
  /// eg., In year view 05-03-2020 and 18-03-2020 are different dates
  /// but they are in same cell on year view.
  bool _isSameView(DateTime date, DateTime currentDate);

  /// Check whether the dates are in same or before of current view or not.
  /// eg., In year view 05-03-2020 and 18-03-2020 are different dates
  /// but they are in same cell on year view. In year view 05-02-2020 is before
  /// of 05-03-2020.
  bool _isSameOrBeforeView(DateTime date, DateTime currentDate);

  /// Check whether the dates are in same or after of current view or not.
  /// eg., In year view 05-03-2020 and 18-03-2020 are different dates
  /// but they are in same cell on year view. In year view 05-03-2020 is after
  /// of 05-02-2020.
  bool _isSameOrAfterView(DateTime date, DateTime currentDate);

  /// Check whether the date is in between the minimum and maximum dates
  bool _isBetweenMinMaxMonth(DateTime date);

  /// Return the string value used to rendering the text on view cell on year,
  /// decade and century views
  String _getCellText(DateTime date);

  /// Check the given index as trailing index or not.
  bool _isTrailingDate(int index, int viewStartIndex);

  /// Check whether the date as current view date or other view date.
  bool _isCurrentView(DateTime date, int index);

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate);
}
