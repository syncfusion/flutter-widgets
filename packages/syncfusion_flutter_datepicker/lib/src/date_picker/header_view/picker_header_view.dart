part of datepicker;

@immutable
class _PickerHeaderView extends StatefulWidget {
  const _PickerHeaderView(
      this.visibleDates,
      this.headerStyle,
      this.selectionMode,
      this.view,
      this.numberOfWeeksInView,
      this.showNavigationArrow,
      this.navigationDirection,
      this.enableSwipeSelection,
      this.minDate,
      this.maxDate,
      this.monthFormat,
      this.datePickerTheme,
      this.locale,
      this.width,
      this.height,
      this.allowViewNavigation,
      this.previousNavigationCallback,
      this.nextNavigationCallback,
      this.enableMultiView,
      this.multiViewSpacing,
      this.hoverColor,
      this.isRtl,
      this.textScaleFactor,
      {Key key})
      : super(key: key);

  final double textScaleFactor;
  final DateRangePickerSelectionMode selectionMode;
  final DateRangePickerHeaderStyle headerStyle;
  final DateRangePickerView view;
  final int numberOfWeeksInView;
  final bool showNavigationArrow;
  final DateRangePickerNavigationDirection navigationDirection;
  final DateTime minDate;
  final DateTime maxDate;
  final String monthFormat;
  final bool enableSwipeSelection;
  final bool allowViewNavigation;
  final SfDateRangePickerThemeData datePickerTheme;
  final Locale locale;
  final ValueNotifier<List<DateTime>> visibleDates;
  final VoidCallback previousNavigationCallback;
  final VoidCallback nextNavigationCallback;
  final double width;
  final double height;
  final bool isRtl;
  final Color hoverColor;
  final bool enableMultiView;
  final double multiViewSpacing;

  @override
  _PickerHeaderViewState createState() => _PickerHeaderViewState();
}

class _PickerHeaderViewState extends State<_PickerHeaderView> {
  bool _hovering;

  @override
  void initState() {
    _hovering = false;
    _addListener();
    super.initState();
  }

  @override
  void didUpdateWidget(_PickerHeaderView oldWidget) {
    widget.visibleDates.removeListener(_listener);
    _addListener();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double arrowWidth = 0;
    double headerWidth = widget.width;
    if (widget.showNavigationArrow ||
        ((widget.view == DateRangePickerView.month ||
                !widget.allowViewNavigation) &&
            widget.enableSwipeSelection &&
            (widget.selectionMode == DateRangePickerSelectionMode.range ||
                widget.selectionMode ==
                    DateRangePickerSelectionMode.multiRange))) {
      arrowWidth = widget.width / 6;
      arrowWidth = arrowWidth > 50 ? 50 : arrowWidth;
      headerWidth = widget.width - (arrowWidth * 2);
    }

    Color arrowColor = widget.headerStyle.textStyle != null
        ? widget.headerStyle.textStyle.color
        : (widget.datePickerTheme.headerTextStyle.color);
    arrowColor = arrowColor.withOpacity(arrowColor.opacity * 0.6);
    Color prevArrowColor = arrowColor;
    Color nextArrowColor = arrowColor;
    final List<DateTime> dates = widget.visibleDates.value;
    if (!_canMoveToNextView(widget.view, widget.numberOfWeeksInView,
        widget.maxDate, dates, widget.enableMultiView)) {
      nextArrowColor = nextArrowColor.withOpacity(arrowColor.opacity * 0.5);
    }

    if (!_canMoveToPreviousView(widget.view, widget.numberOfWeeksInView,
        widget.minDate, dates, widget.enableMultiView)) {
      prevArrowColor = prevArrowColor.withOpacity(arrowColor.opacity * 0.5);
    }

    final Widget headerText = _getHeaderText(headerWidth);

    double arrowSize = widget.height * 0.5;
    arrowSize = arrowSize > 25 ? 25 : arrowSize;
    arrowSize = arrowSize * widget.textScaleFactor;
    final Container leftArrow =
        _getLeftArrow(arrowWidth, arrowColor, prevArrowColor, arrowSize);

    final Container rightArrow =
        _getRightArrow(arrowWidth, arrowColor, nextArrowColor, arrowSize);

    if (widget.headerStyle.textAlign == TextAlign.left ||
        widget.headerStyle.textAlign == TextAlign.start) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            headerText,
            leftArrow,
            rightArrow,
          ]);
    } else if (widget.headerStyle.textAlign == TextAlign.right ||
        widget.headerStyle.textAlign == TextAlign.end) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            leftArrow,
            rightArrow,
            headerText,
          ]);
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            leftArrow,
            headerText,
            rightArrow,
          ]);
    }
  }

  @override
  void dispose() {
    widget.visibleDates.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (!mounted) {
      return;
    }

    if (widget.showNavigationArrow ||
        ((widget.view == DateRangePickerView.month ||
                !widget.allowViewNavigation) &&
            widget.enableSwipeSelection &&
            (widget.selectionMode == DateRangePickerSelectionMode.range ||
                widget.selectionMode ==
                    DateRangePickerSelectionMode.multiRange))) {
      setState(() {/*Updates the header when visible dates changes */});
    }
  }

  void _addListener() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.visibleDates.addListener(_listener);
    });
  }

  Widget _getHeaderText(double headerWidth) {
    return MouseRegion(
        onEnter: (PointerEnterEvent event) {
          if (widget.view == DateRangePickerView.century) {
            return;
          }

          setState(() {
            _hovering = true;
          });
        },
        onHover: (PointerHoverEvent event) {
          if (widget.view == DateRangePickerView.century) {
            return;
          }

          setState(() {
            _hovering = true;
          });
        },
        onExit: (PointerExitEvent event) {
          setState(() {
            _hovering = false;
          });
        },
        child: RepaintBoundary(
            child: CustomPaint(
          // Returns the header view  as a child for the calendar.
          painter: _PickerHeaderPainter(
              widget.visibleDates,
              widget.headerStyle,
              widget.view,
              widget.numberOfWeeksInView,
              widget.monthFormat,
              widget.datePickerTheme,
              widget.isRtl,
              widget.locale,
              widget.enableMultiView,
              widget.multiViewSpacing,
              widget.hoverColor,
              _hovering,
              widget.textScaleFactor),
          size: Size(headerWidth, widget.height),
        )));
  }

  Widget _getLeftArrow(double arrowWidth, Color arrowColor,
      Color prevArrowColor, double arrowSize) {
    return Container(
      alignment: Alignment.center,
      color: widget.headerStyle.backgroundColor ??
          widget.datePickerTheme.headerBackgroundColor,
      width: arrowWidth,
      padding: const EdgeInsets.all(0),
      child: FlatButton(
        //// set splash color as transparent when arrow reaches min date(disabled)
        splashColor: prevArrowColor != arrowColor ? Colors.transparent : null,
        hoverColor: prevArrowColor != arrowColor ? Colors.transparent : null,
        highlightColor:
            prevArrowColor != arrowColor ? Colors.transparent : null,
        color: widget.headerStyle.backgroundColor ??
            widget.datePickerTheme.headerBackgroundColor,
        onPressed: widget.previousNavigationCallback,
        padding: const EdgeInsets.all(0),
        child: Semantics(
          label: 'Backward',
          child: Icon(
            widget.navigationDirection ==
                    DateRangePickerNavigationDirection.horizontal
                ? Icons.chevron_left
                : Icons.keyboard_arrow_up,
            color: prevArrowColor,
            size: arrowSize,
          ),
        ),
      ),
    );
  }

  Widget _getRightArrow(double arrowWidth, Color arrowColor,
      Color nextArrowColor, double arrowSize) {
    return Container(
      alignment: Alignment.center,
      color: widget.headerStyle.backgroundColor ??
          widget.datePickerTheme.headerBackgroundColor,
      width: arrowWidth,
      padding: const EdgeInsets.all(0),
      child: FlatButton(
        //// set splash color as transparent when arrow reaches max date(disabled)
        splashColor: nextArrowColor != arrowColor ? Colors.transparent : null,
        hoverColor: nextArrowColor != arrowColor ? Colors.transparent : null,
        highlightColor:
            nextArrowColor != arrowColor ? Colors.transparent : null,
        color: widget.headerStyle.backgroundColor ??
            widget.datePickerTheme.headerBackgroundColor,
        onPressed: widget.nextNavigationCallback,
        padding: const EdgeInsets.all(0),
        child: Semantics(
          label: 'Forward',
          child: Icon(
            widget.navigationDirection ==
                    DateRangePickerNavigationDirection.horizontal
                ? Icons.chevron_right
                : Icons.keyboard_arrow_down,
            color: nextArrowColor,
            size: arrowSize,
          ),
        ),
      ),
    );
  }
}
