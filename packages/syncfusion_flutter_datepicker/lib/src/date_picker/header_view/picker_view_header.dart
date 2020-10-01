part of datepicker;

class _PickerViewHeaderPainter extends CustomPainter {
  _PickerViewHeaderPainter(
      this.visibleDates,
      this.viewHeaderStyle,
      this.viewHeaderHeight,
      this.monthViewSettings,
      this.datePickerTheme,
      this.locale,
      this.isRtl,
      this.monthCellStyle,
      this.enableMultiView,
      this.multiViewSpacing,
      this.todayHighlightColor,
      this.textScaleFactor);

  final DateRangePickerViewHeaderStyle viewHeaderStyle;
  final DateRangePickerMonthViewSettings monthViewSettings;
  final List<DateTime> visibleDates;
  final double viewHeaderHeight;
  final DateRangePickerMonthCellStyle monthCellStyle;
  final Locale locale;
  final bool isRtl;
  final Color todayHighlightColor;
  final bool enableMultiView;
  final double multiViewSpacing;
  final SfDateRangePickerThemeData datePickerTheme;
  final double textScaleFactor;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double width = size.width / _kNumberOfDaysInWeek;
    if (enableMultiView) {
      width = (size.width - multiViewSpacing) / (_kNumberOfDaysInWeek * 2);
    }

    /// Initializes the default text style for the texts in view header of
    /// calendar.
    final TextStyle viewHeaderDayStyle =
        viewHeaderStyle.textStyle ?? datePickerTheme.viewHeaderTextStyle;
    final DateTime today = DateTime.now();
    TextStyle dayTextStyle = viewHeaderDayStyle;
    double xPosition = 0;
    double yPosition = 0;
    final int count = enableMultiView ? 2 : 1;
    final int datesCount =
        enableMultiView ? visibleDates.length ~/ 2 : visibleDates.length;
    for (int j = 0; j < count; j++) {
      final int currentViewIndex = isRtl ? _getRtlIndex(count, j) : j;
      DateTime currentDate;
      final bool hasToday = monthViewSettings.numberOfWeeksInView > 0 &&
              monthViewSettings.numberOfWeeksInView < 6
          ? true
          : (visibleDates[(currentViewIndex * datesCount) + (datesCount ~/ 2)]
                          .month ==
                      today.month &&
                  visibleDates[(currentViewIndex * datesCount) +
                              (datesCount ~/ 2)]
                          .year ==
                      today.year)
              ? true
              : false;
      for (int i = 0; i < _kNumberOfDaysInWeek; i++) {
        int index = isRtl ? _getRtlIndex(_kNumberOfDaysInWeek, i) : i;
        index = index + (currentViewIndex * datesCount);
        currentDate = visibleDates[index];
        String dayText =
            DateFormat(monthViewSettings.dayFormat, locale.toString())
                .format(currentDate)
                .toString()
                .toUpperCase();
        dayText = _updateViewHeaderFormat(dayText);

        if (hasToday &&
            currentDate.weekday == today.weekday &&
            isDateWithInDateRange(
                visibleDates[(currentViewIndex * datesCount)],
                visibleDates[((currentViewIndex + 1) * datesCount) - 1],
                today)) {
          final Color textColor = monthCellStyle.todayTextStyle != null &&
                  monthCellStyle.todayTextStyle.color != null
              ? monthCellStyle.todayTextStyle.color
              : todayHighlightColor ?? datePickerTheme.todayHighlightColor;
          dayTextStyle = viewHeaderDayStyle.copyWith(color: textColor);
        } else {
          dayTextStyle = viewHeaderDayStyle;
        }

        final TextSpan dayTextSpan = TextSpan(
          text: dayText,
          style: dayTextStyle,
        );

        _textPainter = _textPainter ??
            TextPainter(
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                textScaleFactor: textScaleFactor,
                textWidthBasis: TextWidthBasis.longestLine);
        _textPainter.text = dayTextSpan;
        _textPainter.layout(minWidth: 0, maxWidth: width);
        yPosition = (viewHeaderHeight - _textPainter.height) / 2;
        _textPainter.paint(
            canvas,
            Offset(
                xPosition + (width / 2 - _textPainter.width / 2), yPosition));
        xPosition += width;
      }

      xPosition += multiViewSpacing;
    }
  }

  String _updateViewHeaderFormat(String dayText) {
    //// EE format value shows the week days as S, M, T, W, T, F, S.
    /// For other languages showing the first letter of the weekday turns into
    /// wrong meaning, hence we have shown the first letter of weekday when the
    /// date farmat set as defautlt and the locale set as English.
    ///
    /// Eg: In chinesh the first letter or `Sunday` represents `Weekday`, hence
    /// to avoid this added this condition based on locale.
    if (monthViewSettings.dayFormat == 'EE' &&
        (locale == null || locale.languageCode == 'en')) {
      dayText = dayText[0];
    }

    return dayText;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _PickerViewHeaderPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.viewHeaderStyle != viewHeaderStyle ||
        oldWidget.viewHeaderHeight != viewHeaderHeight ||
        oldWidget.todayHighlightColor != todayHighlightColor ||
        oldWidget.monthViewSettings != monthViewSettings ||
        oldWidget.datePickerTheme != datePickerTheme ||
        oldWidget.isRtl != isRtl ||
        oldWidget.locale != locale ||
        oldWidget.textScaleFactor != textScaleFactor;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    double left, cellWidth;
    cellWidth = size.width / _kNumberOfDaysInWeek;
    int count = 1;
    int datesCount = visibleDates.length;
    if (enableMultiView) {
      cellWidth = (size.width - multiViewSpacing) / 14;
      count = 2;
      datesCount = visibleDates.length ~/ 2;
    }

    left = isRtl ? size.width - cellWidth : 0;
    const double top = 0;
    for (int j = 0; j < count; j++) {
      for (int i = 0; i < _kNumberOfDaysInWeek; i++) {
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(left, top, cellWidth, size.height),
          properties: SemanticsProperties(
            label: DateFormat('EEEEE')
                .format(visibleDates[(j * datesCount) + i])
                .toString()
                .toUpperCase(),
            textDirection: TextDirection.ltr,
          ),
        ));
        if (isRtl) {
          left -= cellWidth;
        } else {
          left += cellWidth;
        }
      }

      if (isRtl) {
        left -= multiViewSpacing;
      } else {
        left += multiViewSpacing;
      }
    }

    return semanticsBuilder;
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilder(size);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _PickerViewHeaderPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates;
  }
}
