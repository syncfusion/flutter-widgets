part of calendar;

@immutable
class _CalendarHeaderView extends StatefulWidget {
  const _CalendarHeaderView(
      this.visibleDates,
      this.headerStyle,
      this.currentDate,
      this.view,
      this.numberOfWeeksInView,
      this.calendarTheme,
      this.isRTL,
      this.locale,
      this.showNavigationArrow,
      this.controller,
      this.maxDate,
      this.minDate,
      this.width,
      this.height,
      this.nonWorkingDays,
      this.navigationDirection,
      this.showDatePickerButton,
      this.isPickerShown,
      this.allowedViews,
      this.allowViewNavigation,
      this.localizations,
      this.removePicker,
      this.valueChangeNotifier,
      this.viewChangeNotifier,
      this.headerTapCallback,
      this.headerLongPressCallback,
      this.todayHighlightColor,
      this.textScaleFactor,
      this.isMobilePlatform);

  final List<DateTime> visibleDates;
  final CalendarHeaderStyle headerStyle;
  final SfCalendarThemeData calendarTheme;
  final DateTime currentDate;
  final CalendarView view;
  final int numberOfWeeksInView;
  final bool isRTL;
  final String locale;
  final bool showNavigationArrow;
  final CalendarController controller;
  final DateTime maxDate;
  final DateTime minDate;
  final double width;
  final double height;
  final List<int> nonWorkingDays;
  final List<CalendarView> allowedViews;
  final bool allowViewNavigation;
  final MonthNavigationDirection navigationDirection;
  final VoidCallback removePicker;
  final _CalendarHeaderCallback headerTapCallback;
  final _CalendarHeaderCallback headerLongPressCallback;
  final bool showDatePickerButton;
  final SfLocalizations localizations;
  final ValueNotifier<DateTime> valueChangeNotifier;
  final ValueNotifier<bool> viewChangeNotifier;
  final bool isPickerShown;
  final double textScaleFactor;
  final Color todayHighlightColor;
  final bool isMobilePlatform;

  @override
  _CalendarHeaderViewState createState() => _CalendarHeaderViewState();
}

class _CalendarHeaderViewState extends State<_CalendarHeaderView> {
  Map<CalendarView, String> _calendarViews;

  @override
  void initState() {
    widget.valueChangeNotifier.addListener(_updateHeaderChanged);
    _calendarViews = _getCalendarViewsText(widget.localizations);
    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarHeaderView oldWidget) {
    if (widget.valueChangeNotifier != oldWidget.valueChangeNotifier) {
      oldWidget.valueChangeNotifier.removeListener(_updateHeaderChanged);
      widget.valueChangeNotifier.addListener(_updateHeaderChanged);
    }

    _calendarViews = _getCalendarViewsText(widget.localizations);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final bool useMobilePlatformUI =
        _isMobileLayoutUI(widget.width, widget.isMobilePlatform);
    double arrowWidth = 0;
    double headerWidth = widget.width;

    /// Navigation arrow enabled when [showNavigationArrow] in [SfCalendar] is
    /// enabled and calendar view as not schedule, because schedule view does
    /// not have a support for navigation arrow.
    final bool navigationArrowEnabled =
        widget.showNavigationArrow && widget.view != CalendarView.schedule;
    double iconWidth = widget.width / 8;
    iconWidth = iconWidth > 40 ? 40 : iconWidth;
    double calendarViewWidth = 0;

    /// Assign arrow width as icon width when the navigation arrow enabled.
    if (navigationArrowEnabled) {
      arrowWidth = iconWidth;
    }

    final String headerString = _getHeaderText();
    final double totalArrowWidth = arrowWidth * 2;

    /// Show calendar views on header when it is not empty.
    final bool isNeedViewSwitchOption =
        widget.allowedViews != null && widget.allowedViews.isNotEmpty;
    double todayIconWidth = 0;
    double dividerWidth = 0;
    final List<Widget> children = <Widget>[];
    Color headerTextColor = widget.headerStyle.textStyle != null
        ? widget.headerStyle.textStyle.color
        : (widget.calendarTheme.headerTextStyle.color);
    headerTextColor ??= Colors.black87;
    final Color arrowColor =
        headerTextColor.withOpacity(headerTextColor.opacity * 0.6);
    Color prevArrowColor = arrowColor;
    Color nextArrowColor = arrowColor;
    final TextStyle style = TextStyle(color: arrowColor);
    final double defaultCalendarViewTextSize = 12;
    Widget calendarViewIcon = Container(width: 0, height: 0);
    const double padding = 5;
    double headerIconTextWidth = widget.headerStyle.textStyle != null
        ? widget.headerStyle.textStyle.fontSize
        : widget.calendarTheme.headerTextStyle.fontSize;
    headerIconTextWidth ??= 14;
    final String todayText = widget.localizations.todayLabel;

    double maxHeaderHeight = 0;

    /// Today icon shown when the date picker enabled on calendar.
    if (widget.showDatePickerButton) {
      todayIconWidth = iconWidth;
      if (!useMobilePlatformUI) {
        /// 5 as padding for around today text view.
        final Size todayButtonSize = _getTextWidgetWidth(
            todayText, widget.height, widget.width - totalArrowWidth, context,
            style: TextStyle(fontSize: defaultCalendarViewTextSize));
        maxHeaderHeight = todayButtonSize.height;
        todayIconWidth = todayButtonSize.width + padding;
      }
    }

    double headerTextWidth = 0;
    if (!widget.isMobilePlatform) {
      final Size headerTextSize = _getTextWidgetWidth(
          headerString,
          widget.height,
          widget.width - totalArrowWidth - todayIconWidth - padding,
          context,
          style: widget.headerStyle.textStyle ??
              widget.calendarTheme.headerTextStyle);
      headerTextWidth = headerTextSize.width +
          padding +
          (widget.showDatePickerButton ? headerIconTextWidth : 0);
      maxHeaderHeight = maxHeaderHeight > headerTextSize.height
          ? maxHeaderHeight
          : headerTextSize.height;
    }

    if (isNeedViewSwitchOption) {
      calendarViewWidth = iconWidth;
      if (useMobilePlatformUI) {
        maxHeaderHeight =
            maxHeaderHeight != 0 && maxHeaderHeight <= widget.height
                ? maxHeaderHeight
                : widget.height;

        /// Render allowed views icon on mobile view.
        calendarViewIcon = _getCalendarViewWidget(
            useMobilePlatformUI,
            false,
            calendarViewWidth,
            maxHeaderHeight,
            style,
            arrowColor,
            headerTextColor,
            widget.view,
            widget.isMobilePlatform ? false : widget.viewChangeNotifier.value,
            defaultCalendarViewTextSize,
            semanticLabel: 'CalendarView');
      } else {
        /// Assign divider width when today icon text shown.
        dividerWidth = widget.showDatePickerButton ? 5 : 0;

        double totalWidth =
            widget.width - totalArrowWidth - dividerWidth - todayIconWidth;

        totalWidth -= headerTextWidth;
        final Map<CalendarView, double> calendarViewsWidth =
            <CalendarView, double>{};
        double allowedViewsWidth = 0;
        final int allowedViewsLength = widget.allowedViews.length;

        double maxCalendarViewHeight = 0;

        /// Calculate the allowed views horizontal width.
        for (int i = 0; i < allowedViewsLength; i++) {
          final CalendarView currentView = widget.allowedViews[i];
          final Size calendarViewSize = _getTextWidgetWidth(
              _calendarViews[currentView], widget.height, totalWidth, context,
              style: TextStyle(fontSize: defaultCalendarViewTextSize));
          final double currentViewTextWidth = calendarViewSize.width + padding;
          maxCalendarViewHeight =
              maxCalendarViewHeight > calendarViewSize.height
                  ? maxCalendarViewHeight
                  : calendarViewSize.height;
          calendarViewsWidth[currentView] = currentViewTextWidth;
          allowedViewsWidth += currentViewTextWidth;
        }

        /// Check the header view width enough for hold allowed views then
        /// render the allowed views as children.
        if (allowedViewsWidth < totalWidth) {
          calendarViewWidth = allowedViewsWidth;
          maxHeaderHeight = maxCalendarViewHeight > maxHeaderHeight
              ? maxCalendarViewHeight
              : maxHeaderHeight;
          maxHeaderHeight =
              maxHeaderHeight > widget.height ? widget.height : maxHeaderHeight;
          for (int i = 0; i < allowedViewsLength; i++) {
            final CalendarView currentView = widget.allowedViews[i];
            children.add(_getCalendarViewWidget(
                useMobilePlatformUI,
                false,
                calendarViewsWidth[currentView],
                maxHeaderHeight,
                style,
                arrowColor,
                headerTextColor,
                currentView,
                widget.view == currentView,
                defaultCalendarViewTextSize));
          }
        } else {
          /// Render allowed views drop down when header view does not have a
          /// space to hold the allowed views.
          final Size calendarViewSize = _getTextWidgetWidth(
              _calendarViews[widget.view],
              widget.height,
              widget.width - totalArrowWidth,
              context,
              style: TextStyle(fontSize: defaultCalendarViewTextSize));
          maxCalendarViewHeight = calendarViewSize.height;
          maxHeaderHeight = maxCalendarViewHeight > maxHeaderHeight
              ? maxCalendarViewHeight
              : maxHeaderHeight;
          maxHeaderHeight =
              maxHeaderHeight > widget.height ? widget.height : maxHeaderHeight;
          calendarViewWidth =
              calendarViewSize.width + padding + headerIconTextWidth;
          children.add(_getCalendarViewWidget(
              useMobilePlatformUI,
              true,
              calendarViewWidth,
              maxHeaderHeight,
              style,
              arrowColor,
              headerTextColor,
              widget.view,
              widget.viewChangeNotifier.value,
              defaultCalendarViewTextSize,
              semanticLabel: 'CalendarView'));
        }
      }
    }

    headerWidth = widget.width -
        calendarViewWidth -
        todayIconWidth -
        dividerWidth -
        totalArrowWidth;
    final double headerHeight =
        maxHeaderHeight != 0 && maxHeaderHeight <= widget.height
            ? maxHeaderHeight
            : widget.height;
    final List<DateTime> dates = widget.visibleDates;
    if (!_canMoveToNextView(widget.view, widget.numberOfWeeksInView,
        widget.minDate, widget.maxDate, dates, widget.nonWorkingDays)) {
      nextArrowColor = nextArrowColor.withOpacity(nextArrowColor.opacity * 0.5);
    }

    if (!_canMoveToPreviousView(widget.view, widget.numberOfWeeksInView,
        widget.minDate, widget.maxDate, dates, widget.nonWorkingDays)) {
      prevArrowColor = prevArrowColor.withOpacity(prevArrowColor.opacity * 0.5);
    }

    MainAxisAlignment _getAlignmentFromTextAlign() {
      if (widget.headerStyle.textAlign == null ||
          widget.headerStyle.textAlign == TextAlign.left ||
          widget.headerStyle.textAlign == TextAlign.start) {
        return MainAxisAlignment.start;
      } else if (widget.headerStyle.textAlign == TextAlign.right ||
          widget.headerStyle.textAlign == TextAlign.end) {
        return MainAxisAlignment.end;
      }

      return MainAxisAlignment.center;
    }

    double arrowSize =
        headerHeight == widget.height ? headerHeight * 0.6 : headerHeight * 0.8;
    arrowSize = arrowSize > 25 ? 25 : arrowSize;
    arrowSize = arrowSize * widget.textScaleFactor;
    final bool isCenterAlignment = !widget.isMobilePlatform &&
        (navigationArrowEnabled || isNeedViewSwitchOption) &&
        widget.headerStyle.textAlign != null &&
        (widget.headerStyle.textAlign == TextAlign.center ||
            widget.headerStyle.textAlign == TextAlign.justify);

    Alignment _getHeaderAlignment() {
      if (widget.headerStyle.textAlign == null ||
          widget.headerStyle.textAlign == TextAlign.left ||
          widget.headerStyle.textAlign == TextAlign.start) {
        return widget.isRTL ? Alignment.centerRight : Alignment.centerLeft;
      } else if (widget.headerStyle.textAlign == TextAlign.right ||
          widget.headerStyle.textAlign == TextAlign.end) {
        return widget.isRTL ? Alignment.centerLeft : Alignment.centerRight;
      }

      return Alignment.center;
    }

    final Widget headerText = widget.isMobilePlatform
        ? Container(
            alignment: Alignment.center,
            color: widget.headerStyle.backgroundColor ??
                widget.calendarTheme.headerBackgroundColor,
            width: isCenterAlignment && headerWidth > 200 ? 200 : headerWidth,
            height: headerHeight,
            padding: const EdgeInsets.all(2),
            child: Material(
                color: widget.headerStyle.backgroundColor ??
                    widget.calendarTheme.headerBackgroundColor,
                child: InkWell(
                  //// set splash color as transparent when header does not have
                  // date piker.
                  splashColor:
                      !widget.showDatePickerButton ? Colors.transparent : null,
                  highlightColor:
                      !widget.showDatePickerButton ? Colors.transparent : null,
                  hoverColor:
                      !widget.showDatePickerButton ? Colors.transparent : null,
                  splashFactory: _CustomSplashFactory(),
                  onTap: () {
                    widget.headerTapCallback(
                        calendarViewWidth + dividerWidth + todayIconWidth);
                  },
                  onLongPress: () {
                    widget.headerLongPressCallback(
                        calendarViewWidth + dividerWidth + todayIconWidth);
                  },
                  child: Semantics(
                    label: headerString,
                    child: Container(
                        width: isCenterAlignment && headerWidth > 200
                            ? 200
                            : headerWidth,
                        height: headerHeight,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: _getAlignmentFromTextAlign(),
                          children: widget.showDatePickerButton
                              ? [
                                  Flexible(
                                      child: Text(headerString,
                                          style: widget.headerStyle.textStyle ??
                                              widget.calendarTheme
                                                  .headerTextStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                          textDirection: TextDirection.ltr)),
                                  Icon(
                                    widget.isPickerShown
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    color: arrowColor,
                                    size: (widget.headerStyle.textStyle ??
                                                widget.calendarTheme
                                                    .headerTextStyle)
                                            .fontSize ??
                                        14,
                                  )
                                ]
                              : [
                                  Flexible(
                                      child: Text(headerString,
                                          style: widget.headerStyle.textStyle ??
                                              widget.calendarTheme
                                                  .headerTextStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                          textDirection: TextDirection.ltr))
                                ],
                        )),
                  ),
                )),
          )
        : Container(
            alignment: _getHeaderAlignment(),
            color: widget.headerStyle.backgroundColor ??
                widget.calendarTheme.headerBackgroundColor,
            width: isCenterAlignment && headerWidth > 200 ? 200 : headerWidth,
            height: headerHeight,
            padding: const EdgeInsets.all(2),
            child: Material(
                color: widget.headerStyle.backgroundColor ??
                    widget.calendarTheme.headerBackgroundColor,
                child: InkWell(
                  //// set splash color as transparent when header does not have
                  // date piker.
                  splashColor:
                      !widget.showDatePickerButton ? Colors.transparent : null,
                  highlightColor:
                      !widget.showDatePickerButton ? Colors.transparent : null,
                  splashFactory: _CustomSplashFactory(),
                  onTap: () {
                    widget.headerTapCallback(
                        calendarViewWidth + dividerWidth + todayIconWidth);
                  },
                  onLongPress: () {
                    widget.headerLongPressCallback(
                        calendarViewWidth + dividerWidth + todayIconWidth);
                  },
                  child: Semantics(
                    label: headerString,
                    child: Container(
                        color:
                            widget.showDatePickerButton && widget.isPickerShown
                                ? Colors.grey.withOpacity(0.3)
                                : widget.headerStyle.backgroundColor ??
                                    widget.calendarTheme.headerBackgroundColor,
                        width: isCenterAlignment && headerTextWidth > 200
                            ? 200
                            : headerTextWidth,
                        height: headerHeight,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.showDatePickerButton
                              ? [
                                  Flexible(
                                      child: Text(headerString,
                                          style: widget.headerStyle.textStyle ??
                                              widget.calendarTheme
                                                  .headerTextStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                          textDirection: TextDirection.ltr)),
                                  Icon(
                                    widget.isPickerShown
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    color: arrowColor,
                                    size: (widget.headerStyle.textStyle ??
                                                widget.calendarTheme
                                                    .headerTextStyle)
                                            .fontSize ??
                                        14,
                                  )
                                ]
                              : [
                                  Flexible(
                                      child: Text(headerString,
                                          style: widget.headerStyle.textStyle ??
                                              widget.calendarTheme
                                                  .headerTextStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                          textDirection: TextDirection.ltr))
                                ],
                        )),
                  ),
                )),
          );

    final Container leftArrow = Container(
      alignment: Alignment.center,
      color: widget.headerStyle.backgroundColor ??
          widget.calendarTheme.headerBackgroundColor,
      width: arrowWidth,
      height: headerHeight,
      padding: const EdgeInsets.all(2),
      child: Material(
          color: widget.headerStyle.backgroundColor ??
              widget.calendarTheme.headerBackgroundColor,
          child: InkWell(
            //// set splash color as transparent when arrow reaches min date(disabled)
            splashColor:
                prevArrowColor != arrowColor ? Colors.transparent : null,
            highlightColor:
                prevArrowColor != arrowColor ? Colors.transparent : null,
            hoverColor:
                prevArrowColor != arrowColor ? Colors.transparent : null,
            splashFactory: _CustomSplashFactory(),
            onTap: _backward,
            child: Semantics(
              label: 'Backward',
              child: Container(
                  width: arrowWidth,
                  height: headerHeight,
                  alignment: Alignment.center,
                  child: Icon(
                    widget.navigationDirection ==
                            MonthNavigationDirection.horizontal
                        ? Icons.chevron_left
                        : Icons.keyboard_arrow_up,
                    color: prevArrowColor,
                    size: arrowSize,
                  )),
            ),
          )),
    );

    final Container rightArrow = Container(
      alignment: Alignment.center,
      color: widget.headerStyle.backgroundColor ??
          widget.calendarTheme.headerBackgroundColor,
      width: arrowWidth,
      height: headerHeight,
      padding: const EdgeInsets.all(2),
      child: Material(
          color: widget.headerStyle.backgroundColor ??
              widget.calendarTheme.headerBackgroundColor,
          child: InkWell(
            //// set splash color as transparent when arrow reaches max date(disabled)
            splashColor:
                nextArrowColor != arrowColor ? Colors.transparent : null,
            highlightColor:
                nextArrowColor != arrowColor ? Colors.transparent : null,
            hoverColor:
                nextArrowColor != arrowColor ? Colors.transparent : null,
            splashFactory: _CustomSplashFactory(),
            onTap: _forward,
            child: Semantics(
              label: 'Forward',
              child: Container(
                  width: arrowWidth,
                  height: headerHeight,
                  alignment: Alignment.center,
                  child: Icon(
                    widget.navigationDirection ==
                            MonthNavigationDirection.horizontal
                        ? Icons.chevron_right
                        : Icons.keyboard_arrow_down,
                    color: nextArrowColor,
                    size: arrowSize,
                  )),
            ),
          )),
    );

    final Widget todayIcon = Container(
      alignment: Alignment.center,
      color: widget.headerStyle.backgroundColor ??
          widget.calendarTheme.headerBackgroundColor,
      width: todayIconWidth,
      height: headerHeight,
      padding: const EdgeInsets.all(2),
      child: Material(
          color: widget.headerStyle.backgroundColor ??
              widget.calendarTheme.headerBackgroundColor,
          child: InkWell(
            splashFactory: _CustomSplashFactory(),
            onTap: () {
              widget.removePicker();
              widget.controller.displayDate = DateTime.now();
            },
            child: Semantics(
              label: todayText,
              child: useMobilePlatformUI
                  ? Container(
                      width: todayIconWidth,
                      height: headerHeight,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.today,
                        color: style.color,
                        size: style.fontSize,
                      ))
                  : Container(
                      width: todayIconWidth,
                      alignment: Alignment.center,
                      child: Text(
                        todayText,
                        style: TextStyle(
                            color: headerTextColor,
                            fontSize: defaultCalendarViewTextSize),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )),
            ),
          )),
    );

    final Widget dividerWidget = widget.showDatePickerButton &&
            isNeedViewSwitchOption &&
            !useMobilePlatformUI
        ? Container(
            alignment: Alignment.center,
            color: widget.headerStyle.backgroundColor ??
                widget.calendarTheme.headerBackgroundColor,
            width: dividerWidth,
            height: headerHeight,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 0.5,
            ))
        : Container(
            width: 0,
            height: 0,
          );

    List<Widget> rowChildren = <Widget>[];
    if (widget.headerStyle.textAlign == null ||
        widget.headerStyle.textAlign == TextAlign.left ||
        widget.headerStyle.textAlign == TextAlign.start) {
      if (widget.isMobilePlatform) {
        rowChildren = <Widget>[
          headerText,
          todayIcon,
          calendarViewIcon,
          leftArrow,
          rightArrow,
        ];
      } else {
        rowChildren = <Widget>[
          leftArrow,
          rightArrow,
          headerText,
          todayIcon,
          dividerWidget,
        ];
        useMobilePlatformUI
            ? rowChildren.add(calendarViewIcon)
            : rowChildren.addAll(children);
      }

      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rowChildren);
    } else if (widget.headerStyle.textAlign == TextAlign.right ||
        widget.headerStyle.textAlign == TextAlign.end) {
      if (widget.isMobilePlatform) {
        rowChildren = <Widget>[
          leftArrow,
          rightArrow,
          calendarViewIcon,
          todayIcon,
          headerText,
        ];
      } else {
        useMobilePlatformUI
            ? rowChildren.add(calendarViewIcon)
            : rowChildren.addAll(children);

        rowChildren.add(dividerWidget);
        rowChildren.add(todayIcon);
        rowChildren.add(headerText);
        rowChildren.add(leftArrow);
        rowChildren.add(rightArrow);
      }

      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rowChildren);
    } else {
      if (widget.isMobilePlatform) {
        rowChildren = <Widget>[
          leftArrow,
          headerText,
          todayIcon,
          dividerWidget,
          calendarViewIcon,
          rightArrow,
        ];
      } else {
        rowChildren = <Widget>[
          leftArrow,
          headerText,
          rightArrow,
          todayIcon,
          dividerWidget,
        ];
        useMobilePlatformUI
            ? rowChildren.add(calendarViewIcon)
            : rowChildren.addAll(children);
      }

      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rowChildren);
    }
  }

  @override
  void dispose() {
    widget.valueChangeNotifier.removeListener(_updateHeaderChanged);
    super.dispose();
  }

  void _updateHeaderChanged() {
    setState(() {});
  }

  void _backward() {
    widget.removePicker();
    widget.controller.backward();
  }

  void _forward() {
    widget.removePicker();
    widget.controller.forward();
  }

  Widget _getCalendarViewWidget(
      bool useMobilePlatformUI,
      bool isNeedIcon,
      double width,
      double height,
      TextStyle style,
      Color arrowColor,
      Color headerTextColor,
      CalendarView view,
      bool isHighlighted,
      double defaultCalendarViewTextSize,
      {String semanticLabel}) {
    final String text = _calendarViews[view];
    return Container(
      alignment: Alignment.center,
      color: widget.headerStyle.backgroundColor ??
          widget.calendarTheme.headerBackgroundColor,
      width: width,
      height: height,
      padding: EdgeInsets.all(2),
      child: Material(
          color: isHighlighted && (isNeedIcon || useMobilePlatformUI)
              ? Colors.grey.withOpacity(0.3)
              : widget.headerStyle.backgroundColor ??
                  widget.calendarTheme.headerBackgroundColor,
          child: InkWell(
            splashFactory: _CustomSplashFactory(),
            onTap: () {
              if (isNeedIcon || useMobilePlatformUI) {
                widget.viewChangeNotifier.value =
                    !widget.viewChangeNotifier.value;
              } else {
                widget.controller.view = view;
              }
            },
            child: Semantics(
              label: semanticLabel ?? text,
              child: useMobilePlatformUI
                  ? Container(
                      width: width,
                      height: height,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.more_vert,
                        color: style.color,
                        size: style.fontSize,
                      ))
                  : (isNeedIcon
                      ? Container(
                          width: width,
                          height: height,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                    color: headerTextColor,
                                    fontSize: defaultCalendarViewTextSize),
                                maxLines: 1,
                                textDirection: TextDirection.ltr,
                              ),
                              Icon(
                                widget.viewChangeNotifier.value
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: arrowColor,
                                size: (widget.headerStyle.textStyle ??
                                            widget
                                                .calendarTheme.headerTextStyle)
                                        .fontSize ??
                                    14,
                              )
                            ],
                          ))
                      : Container(
                          width: width,
                          height: height,
                          alignment: Alignment.center,
                          child: Text(
                            text,
                            style: TextStyle(
                                color: isHighlighted
                                    ? widget.todayHighlightColor ??
                                        widget.calendarTheme.todayHighlightColor
                                    : headerTextColor,
                                fontSize: defaultCalendarViewTextSize),
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                          ))),
            ),
          )),
    );
  }

  String _getHeaderText() {
    String format = 'MMM';
    switch (widget.view) {
      case CalendarView.schedule:
        {
          format = 'MMMM';
          return DateFormat(format, widget.locale)
                  .format(widget.valueChangeNotifier.value)
                  .toString() +
              ' ' +
              widget.valueChangeNotifier.value.year.toString();
        }
      case CalendarView.month:
      case CalendarView.timelineMonth:
        {
          final DateTime startDate = widget.visibleDates[0];
          final DateTime endDate =
              widget.visibleDates[widget.visibleDates.length - 1];
          if (widget.numberOfWeeksInView != 6 &&
              startDate.month != endDate.month) {
            return DateFormat(format, widget.locale)
                    .format(startDate)
                    .toString() +
                ' ' +
                startDate.year.toString() +
                ' - ' +
                DateFormat(format, widget.locale).format(endDate).toString() +
                ' ' +
                endDate.year.toString();
          }

          format = 'MMMM';
          return DateFormat(format, widget.locale)
                  .format(widget.currentDate)
                  .toString() +
              ' ' +
              widget.currentDate.year.toString();
        }
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.workWeek:
        {
          final DateTime headerDate = widget.visibleDates[0];
          format = 'MMMM';
          return DateFormat(format, widget.locale)
                  .format(headerDate)
                  .toString() +
              ' ' +
              headerDate.year.toString();
        }
      case CalendarView.timelineDay:
        {
          format = 'MMMM';
          final DateTime headerDate = widget.visibleDates[0];
          return DateFormat(format, widget.locale)
                  .format(headerDate)
                  .toString() +
              ' ' +
              headerDate.year.toString();
        }
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
        {
          final DateTime startDate = widget.visibleDates[0];
          final DateTime endDate =
              widget.visibleDates[widget.visibleDates.length - 1];
          String startText =
              DateFormat(format, widget.locale).format(startDate).toString();
          startText = startDate.day.toString() + ' ' + startText + ' - ';
          final String endText = endDate.day.toString() +
              ' ' +
              DateFormat(format, widget.locale).format(endDate).toString() +
              ' ' +
              endDate.year.toString();

          return startText + endText;
        }
    }

    return null;
  }
}
