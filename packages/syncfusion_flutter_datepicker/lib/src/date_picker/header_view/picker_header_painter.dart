part of datepicker;

class _PickerHeaderPainter extends CustomPainter {
  _PickerHeaderPainter(
      this.visibleDates,
      this.headerStyle,
      this.view,
      this.numberOfWeeksInView,
      this.monthFormat,
      this.datePickerTheme,
      this.isRtl,
      this.locale,
      this.enableMultiView,
      this.multiViewSpacing,
      this.hoverColor,
      this.hovering,
      this.textScaleFactor)
      : super(repaint: visibleDates);

  final DateRangePickerHeaderStyle headerStyle;
  final DateRangePickerView view;
  final int numberOfWeeksInView;
  final SfDateRangePickerThemeData datePickerTheme;
  final bool isRtl;
  final String monthFormat;
  final bool hovering;
  final bool enableMultiView;
  final double multiViewSpacing;
  final Color hoverColor;
  final Locale locale;
  final double textScaleFactor;
  ValueNotifier<List<DateTime>> visibleDates;
  String _headerText;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double xPosition = 0;
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaleFactor = textScaleFactor;
    _textPainter.maxLines = 1;

    _headerText = '';
    final double width =
        enableMultiView && headerStyle.textAlign == TextAlign.center
            ? (size.width - multiViewSpacing) / 2
            : size.width;
    final int count =
        enableMultiView && headerStyle.textAlign == TextAlign.center ? 2 : 1;
    for (int j = 0; j < count; j++) {
      final int currentViewIndex = isRtl ? _getRtlIndex(count, j) : j;
      xPosition = (currentViewIndex * width) + 10;
      final String text = _getHeaderText(j);
      _headerText += j == 1 ? ' ' + text : text;
      TextStyle style =
          headerStyle.textStyle ?? datePickerTheme.headerTextStyle;
      if (hovering) {
        style = style.copyWith(color: hoverColor);
      }

      final TextSpan span = TextSpan(text: text, style: style);
      _textPainter.text = span;

      if (headerStyle.textAlign == TextAlign.justify) {
        _textPainter.textAlign = headerStyle.textAlign;
      }

      _textPainter.layout(
          minWidth: 0,
          maxWidth: ((currentViewIndex + 1) * width) - xPosition > 0
              ? ((currentViewIndex + 1) * width) - xPosition
              : 0);

      if (headerStyle.textAlign == TextAlign.center) {
        xPosition = (currentViewIndex * width) +
            (currentViewIndex * multiViewSpacing) +
            (width / 2) -
            (_textPainter.width / 2);
      } else if ((!isRtl &&
              (headerStyle.textAlign == TextAlign.right ||
                  headerStyle.textAlign == TextAlign.end)) ||
          (isRtl &&
              (headerStyle.textAlign == TextAlign.left ||
                  headerStyle.textAlign == TextAlign.start))) {
        xPosition =
            ((currentViewIndex + 1) * width) - _textPainter.width - xPosition;
      }
      _textPainter.paint(
          canvas, Offset(xPosition, size.height / 2 - _textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _PickerHeaderPainter oldWidget = oldDelegate;
    return oldWidget.headerStyle != headerStyle ||
        oldWidget.isRtl != isRtl ||
        oldWidget.numberOfWeeksInView != numberOfWeeksInView ||
        oldWidget.locale != locale ||
        oldWidget.datePickerTheme != datePickerTheme ||
        oldWidget.textScaleFactor != textScaleFactor ||
        (kIsWeb &&
            (oldWidget.hovering != hovering ||
                oldWidget.hoverColor != hoverColor));
  }

  String _getMonthHeaderText(int startIndex, int endIndex, List<DateTime> dates,
      int middleIndex, int datesCount) {
    if (numberOfWeeksInView != 6 &&
        dates[startIndex].month != dates[endIndex].month) {
      final String monthTextFormat =
          monthFormat == null || monthFormat.isEmpty ? 'MMM' : monthFormat;
      int endIndex = dates.length - 1;
      if (enableMultiView && headerStyle.textAlign == TextAlign.center) {
        endIndex = endIndex;
      }

      final String startText = DateFormat(monthTextFormat, locale.toString())
              .format(dates[startIndex])
              .toString() +
          ' ' +
          dates[startIndex].year.toString();
      final String endText = DateFormat(monthTextFormat, locale.toString())
              .format(dates[endIndex])
              .toString() +
          ' ' +
          dates[endIndex].year.toString();
      if (startText == endText) {
        return startText;
      }

      return startText + ' - ' + endText;
    } else {
      final String monthTextFormat =
          monthFormat == null || monthFormat.isEmpty ? 'MMMM' : monthFormat;
      final String text = DateFormat(monthTextFormat, locale.toString())
              .format(dates[middleIndex])
              .toString() +
          ' ' +
          dates[middleIndex].year.toString();
      if (enableMultiView && headerStyle.textAlign != TextAlign.center) {
        return text +
            ' - ' +
            DateFormat(monthTextFormat, locale.toString())
                .format(dates[datesCount + middleIndex])
                .toString() +
            ' ' +
            dates[datesCount + middleIndex].year.toString();
      }

      return text;
    }
  }

  String _getHeaderText(int index) {
    final List<DateTime> dates = visibleDates.value;
    final int count = enableMultiView ? 2 : 1;
    final int datesCount = dates.length ~/ count;
    final int startIndex = index * datesCount;
    final int endIndex = ((index + 1) * datesCount) - 1;
    final int middleIndex = startIndex + (datesCount ~/ 2);
    switch (view) {
      case DateRangePickerView.month:
        {
          return _getMonthHeaderText(
              startIndex, endIndex, dates, middleIndex, datesCount);
        }
        break;
      case DateRangePickerView.year:
        {
          final DateTime date = dates[middleIndex];
          if (enableMultiView && headerStyle.textAlign != TextAlign.center) {
            return date.year.toString() +
                ' - ' +
                dates[datesCount + middleIndex].year.toString();
          }

          return date.year.toString();
        }
      case DateRangePickerView.decade:
        {
          final int year = (dates[middleIndex].year ~/ 10) * 10;
          if (enableMultiView && headerStyle.textAlign != TextAlign.center) {
            return year.toString() +
                ' - ' +
                (((dates[datesCount + middleIndex].year ~/ 10) * 10) + 9)
                    .toString();
          }

          return year.toString() + ' - ' + (year + 9).toString();
        }
      case DateRangePickerView.century:
        {
          final int year = (dates[middleIndex].year ~/ 100) * 100;
          if (enableMultiView && headerStyle.textAlign != TextAlign.center) {
            return year.toString() +
                ' - ' +
                (((dates[datesCount + middleIndex].year ~/ 100) * 100) + 99)
                    .toString();
          }

          return year.toString() + ' - ' + (year + 99).toString();
        }
    }

    return '';
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      final Rect rect = Offset.zero & size;
      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: rect,
          properties: SemanticsProperties(
            label: _headerText != null ? _headerText.replaceAll('-', 'to') : '',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return true;
  }
}
