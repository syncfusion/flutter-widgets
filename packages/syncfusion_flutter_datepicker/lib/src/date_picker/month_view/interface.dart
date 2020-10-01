part of datepicker;

abstract class _IMonthViewPainter extends CustomPainter {
  _IMonthViewPainter({ValueNotifier<bool> selectionNotifier})
      : super(repaint: selectionNotifier);

  int rowCount;
  DateRangePickerMonthCellStyle cellStyle;
  List<DateTime> visibleDates;
  bool isRtl;
  Color todayHighlightColor;
  SfDateRangePickerThemeData datePickerTheme;
  DateTime minDate;
  DateTime maxDate;
  bool enablePastDates;
  bool showLeadingAndTailingDates;
  List<DateTime> blackoutDates;
  List<DateTime> specialDates;
  List<int> weekendDays;
  DateRangePickerSelectionShape selectionShape;
  double selectionRadius;
  ValueNotifier<bool> selectionNotifier;
  Paint selectionPainter;
  TextPainter textPainter;
  Offset mouseHoverPosition;
  bool enableMultiView;
  double multiViewSpacing;
  TextStyle selectionTextStyle;
  TextStyle rangeTextStyle;
  Color selectionColor;
  Color startRangeSelectionColor;
  Color endRangeSelectionColor;
  Color rangeSelectionColor;
  double textScaleFactor;
  static const double _selectionPadding = 2;

  void _updateSelection(_PickerStateArgs details);

  @override
  void paint(Canvas canvas, Size size);

  @override
  bool shouldRepaint(CustomPainter oldDelegate);

  List<int> _getSelectedIndexValues(int viewStartIndex, int viewEndIndex);

  TextStyle _drawSelection(Canvas canvas, double x, double y, int index,
      TextStyle selectionTextStyle, TextStyle selectionRangeTextStyle);

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate);
}
