part of calendar;

/// Used to store the height and intersection point of scroll view item.
/// intersection point used to identify the view does not have same month dates.
class _ScheduleViewDetails {
  double _height;
  double _intersectPoint;
}

@immutable
class _ScheduleViewHoveringDetails {
  const _ScheduleViewHoveringDetails(this.hoveringDate, this.hoveringOffset);

  final DateTime hoveringDate;
  final Offset hoveringOffset;
}

//// Extra small devices (phones, 600px and down)
//// @media only screen and (max-width: 600px) {...}
////
//// Small devices (portrait tablets and large phones, 600px and up)
//// @media only screen and (min-width: 600px) {...}
////
//// Medium devices (landscape tablets, 768px and up)
//// media only screen and (min-width: 768px) {...}
////
//// Large devices (laptops/desktops, 992px and up)
//// media only screen and (min-width: 992px) {...}
////
//// Extra large devices (large laptops and desktops, 1200px and up)
//// media only screen and (min-width: 1200px) {...}
//// Default width to render the mobile UI in web, if the device width exceeds
//// the given width agenda view will render the web UI.
const double _kMobileViewWidth = 767;

/// It is used to generate the week and month label of schedule calendar view.
class _ScheduleLabelPainter extends CustomPainter {
  _ScheduleLabelPainter(
      this.startDate,
      this.endDate,
      this.scheduleViewSettings,
      this.isMonthLabel,
      this.isRTL,
      this.locale,
      this.isScheduleWebUI,
      this.agendaViewNotifier,
      this.calendarTheme,
      this._localizations,
      this.textScaleFactor,
      {this.isDisplayDate = false})
      : super(repaint: isDisplayDate ? agendaViewNotifier : null);

  final DateTime startDate;
  final DateTime endDate;
  final bool isMonthLabel;
  final bool isRTL;
  final String locale;
  final ScheduleViewSettings scheduleViewSettings;
  final SfLocalizations _localizations;
  final bool isScheduleWebUI;
  final ValueNotifier<_ScheduleViewHoveringDetails> agendaViewNotifier;
  final SfCalendarThemeData calendarTheme;
  final bool isDisplayDate;
  final double textScaleFactor;
  TextPainter _textPainter;
  Paint _backgroundPainter;

  @override
  void paint(Canvas canvas, Size size) {
    /// Draw the week label.
    if (!isMonthLabel) {
      if (isDisplayDate) {
        _addDisplayDateLabel(canvas, size);
      } else {
        _addWeekLabel(canvas, size);
      }
    } else {
      /// Draw the month label
      _addMonthLabel(canvas, size);
    }
  }

  void _addDisplayDateLabel(Canvas canvas, Size size) {
    /// Add the localized add new appointment text for display date view.
    final TextSpan span = TextSpan(
      text: _localizations.scheduleViewNewEventLabel,
      style: scheduleViewSettings.weekHeaderSettings.weekTextStyle ??
          const TextStyle(
              color: Colors.grey, fontSize: 15, fontFamily: 'Roboto'),
    );

    double xPosition = 10;
    _updateTextPainter(span);

    _textPainter.layout(
        minWidth: 0,
        maxWidth: size.width - xPosition > 0 ? size.width - xPosition : 0);
    if (isRTL) {
      xPosition = size.width - _textPainter.width - xPosition;
    }

    /// Draw display date view text
    _textPainter.paint(
        canvas, Offset(xPosition, (size.height - _textPainter.height) / 2));

    /// Add hovering effect on display date view.
    if (isDisplayDate &&
        agendaViewNotifier.value != null &&
        isSameDate(agendaViewNotifier.value.hoveringDate, startDate)) {
      _backgroundPainter ??= Paint();
      const double padding = 5;
      if (isScheduleWebUI) {
        const double viewPadding = 2;
        final Rect rect = Rect.fromLTWH(
            0,
            padding + viewPadding,
            size.width - (isRTL ? viewPadding : padding),
            size.height - (2 * (viewPadding + padding)));
        _backgroundPainter.color = Colors.grey.withOpacity(0.1);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(4)),
            _backgroundPainter);
      } else {
        final Rect rect = Rect.fromLTWH(
            0, padding, size.width - 2, size.height - (2 * padding));
        _backgroundPainter.color =
            calendarTheme.selectionBorderColor.withOpacity(0.4);
        _backgroundPainter.style = PaintingStyle.stroke;
        _backgroundPainter.strokeWidth = 2;
        canvas.drawRect(rect, _backgroundPainter);
        _backgroundPainter.style = PaintingStyle.fill;
      }
    }
  }

  void _addWeekLabel(Canvas canvas, Size size) {
    double xPosition = 0;
    const double yPosition = 0;
    final String startDateFormat =
        scheduleViewSettings.weekHeaderSettings.startDateFormat ?? 'MMM dd';
    String endDateFormat =
        scheduleViewSettings.weekHeaderSettings.endDateFormat;
    if (startDate.month == endDate.month && endDateFormat == null) {
      endDateFormat = 'dd';
    }

    endDateFormat ??= 'MMM dd';
    final String firstDate =
        DateFormat(startDateFormat, locale).format(startDate).toString();
    final String lastDate =
        DateFormat(endDateFormat, locale).format(endDate).toString();
    final TextSpan span = TextSpan(
      text: firstDate + ' - ' + lastDate,
      style: scheduleViewSettings.weekHeaderSettings.weekTextStyle ??
          const TextStyle(
              color: Colors.grey, fontSize: 15, fontFamily: 'Roboto'),
    );
    _backgroundPainter ??= Paint();
    _backgroundPainter.color =
        scheduleViewSettings.weekHeaderSettings.backgroundColor;

    /// Draw week label background.
    canvas.drawRect(
        Rect.fromLTWH(0, yPosition, size.width,
            scheduleViewSettings.weekHeaderSettings.height),
        _backgroundPainter);
    _updateTextPainter(span);

    _textPainter.layout(
        minWidth: 0, maxWidth: size.width - 10 > 0 ? size.width - 10 : 0);

    if (scheduleViewSettings.weekHeaderSettings.textAlign == TextAlign.right ||
        scheduleViewSettings.weekHeaderSettings.textAlign == TextAlign.end) {
      xPosition = size.width - _textPainter.width;
    } else if (scheduleViewSettings.weekHeaderSettings.textAlign ==
        TextAlign.center) {
      xPosition = size.width / 2 - _textPainter.width / 2;
    }

    if (isRTL) {
      xPosition = size.width - _textPainter.width - xPosition;
      if (scheduleViewSettings.weekHeaderSettings.textAlign == TextAlign.left ||
          scheduleViewSettings.weekHeaderSettings.textAlign == TextAlign.end) {
        xPosition = 0;
      } else if (scheduleViewSettings.weekHeaderSettings.textAlign ==
          TextAlign.center) {
        xPosition = size.width / 2 - _textPainter.width / 2;
      }
    }

    /// Draw week label text
    _textPainter.paint(
        canvas,
        Offset(
            xPosition,
            yPosition +
                (scheduleViewSettings.weekHeaderSettings.height / 2 -
                    _textPainter.height / 2)));
  }

  void _addMonthLabel(Canvas canvas, Size size) {
    double xPosition = 0;
    const double yPosition = 0;
    final String monthFormat =
        scheduleViewSettings.monthHeaderSettings.monthFormat;
    final TextSpan span = TextSpan(
      text: DateFormat(monthFormat, locale).format(startDate).toString(),
      style: scheduleViewSettings.monthHeaderSettings.monthTextStyle ??
          TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Roboto'),
    );
    _backgroundPainter ??= Paint();
    _backgroundPainter.shader = null;
    _backgroundPainter.color =
        scheduleViewSettings.monthHeaderSettings.backgroundColor;
    final Rect rect = Rect.fromLTWH(0, yPosition, size.width,
        scheduleViewSettings.monthHeaderSettings.height);

    /// Draw month label background.
    canvas.drawRect(rect, _backgroundPainter);
    _updateTextPainter(span);

    _textPainter.layout(
        minWidth: 0, maxWidth: size.width - 10 > 0 ? size.width - 10 : 0);

    final double viewPadding = size.width * 0.15;
    xPosition = viewPadding;
    if (scheduleViewSettings.monthHeaderSettings.textAlign == TextAlign.right ||
        scheduleViewSettings.monthHeaderSettings.textAlign == TextAlign.end) {
      xPosition = size.width - _textPainter.width;
    } else if (scheduleViewSettings.monthHeaderSettings.textAlign ==
        TextAlign.center) {
      xPosition = size.width / 2 - _textPainter.width / 2;
    }

    if (isRTL) {
      xPosition = size.width - _textPainter.width - xPosition;
      if (scheduleViewSettings.monthHeaderSettings.textAlign ==
              TextAlign.left ||
          scheduleViewSettings.monthHeaderSettings.textAlign == TextAlign.end) {
        xPosition = 0;
      } else if (scheduleViewSettings.monthHeaderSettings.textAlign ==
          TextAlign.center) {
        xPosition = size.width / 2 - _textPainter.width / 2;
      }
    }

    /// Draw month label text.
    _textPainter.paint(canvas, Offset(xPosition, _textPainter.height));
  }

  void _updateTextPainter(TextSpan span) {
    _textPainter ??= TextPainter();
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaleFactor = textScaleFactor;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    double cellHeight;
    const double top = 0;
    const double left = 0;
    cellHeight = 0;
    String accessibilityText;
    if (!isMonthLabel) {
      if (!isDisplayDate) {
        cellHeight = scheduleViewSettings.weekHeaderSettings.height;
        accessibilityText =
            DateFormat('dd', locale).format(startDate).toString() +
                'to' +
                DateFormat('dd MMM', locale)
                    .format(endDate.add(const Duration(days: 6)))
                    .toString();
      } else {
        cellHeight = size.height;
        accessibilityText = _localizations.scheduleViewNewEventLabel;
      }
    } else {
      cellHeight = scheduleViewSettings.monthHeaderSettings.height;
      accessibilityText =
          DateFormat('MMMM yyyy', locale).format(startDate).toString();
    }
    semanticsBuilder.add(CustomPainterSemantics(
      rect: Rect.fromLTWH(left, top, size.width, cellHeight),
      properties: SemanticsProperties(
        label: accessibilityText,
        textDirection: TextDirection.ltr,
      ),
    ));

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
    return true;
  }
}

/// Used to implement the sticky header in schedule calendar view
/// based on its header and content widget.
class _ScheduleAppointmentView extends Stack {
  _ScheduleAppointmentView({
    Widget content,
    Widget header,
    AlignmentDirectional alignment,
    Key key,
  }) : super(
          key: key,
          children: <Widget>[
            RepaintBoundary(child: content),
            RepaintBoundary(child: header)
          ],
          alignment: alignment ?? AlignmentDirectional.topStart,
          overflow: Overflow.clip,
        );

  @override
  RenderStack createRenderObject(BuildContext context) =>
      _AppointmentViewHeaderRenderObject(
        scrollableState: Scrollable.of(context),
        alignment: alignment,
        textDirection: textDirection ?? Directionality.of(context),
        fit: fit,
      );

  @override
  @mustCallSuper
  void updateRenderObject(BuildContext context, RenderStack renderObject) {
    super.updateRenderObject(context, renderObject);

    if (renderObject is _AppointmentViewHeaderRenderObject) {
      renderObject..scrollableState = Scrollable.of(context);
    }
  }
}

/// Render object of the schedule calendar view item.
class _AppointmentViewHeaderRenderObject extends RenderStack {
  _AppointmentViewHeaderRenderObject({
    ScrollableState scrollableState,
    AlignmentGeometry alignment,
    TextDirection textDirection,
    StackFit fit,
  })  : _scrollableState = scrollableState,
        super(
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
        );

  /// Used to update the child position when it scroll changed.
  ScrollableState _scrollableState;

  /// Current view port.
  RenderAbstractViewport get _stackViewPort => RenderAbstractViewport.of(this);

  ScrollableState get scrollableState => _scrollableState;

  set scrollableState(ScrollableState newScrollable) {
    final ScrollableState oldScrollable = _scrollableState;
    _scrollableState = newScrollable;

    markNeedsPaint();
    if (attached) {
      oldScrollable.position.removeListener(markNeedsPaint);
      newScrollable.position.addListener(markNeedsPaint);
    }
  }

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    scrollableState.position.addListener(markNeedsPaint);
  }

  /// attach will called when the render object removed from view.
  @override
  void detach() {
    scrollableState.position.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset paintOffset) {
    /// Update the child position.
    updateHeaderOffset();
    paintStack(context, paintOffset);
  }

  void updateHeaderOffset() {
    /// Content widget height
    final double contentSize = firstChild.size.height;
    final RenderBox headerView = lastChild;

    /// Header view height
    final double headerSize = headerView.size.height;

    /// Current view position on scroll view.
    final double viewPosition =
        _stackViewPort.getOffsetToReveal(this, 0).offset;

    /// Calculate the current view offset by view position on scroll view,
    /// scrolled position and scroll view view port.
    final double currentViewOffset =
        viewPosition - _scrollableState.position.pixels - _scrollableHeight;

    /// Check current header offset exits content size, if exist then place the
    /// header at content size.
    final double offset = _getCurrentOffset(currentViewOffset, contentSize);
    final StackParentData headerParentData = headerView.parentData;
    final double headerYOffset =
        _getHeaderOffset(contentSize, offset, headerSize);

    /// Update the header start y position.
    if (headerYOffset != headerParentData.offset.dy) {
      headerParentData.offset =
          Offset(headerParentData.offset.dx, headerYOffset);
    }
  }

  /// Return the view port height.
  double get _scrollableHeight {
    final Object viewPort = _stackViewPort;
    double viewPortHeight;

    if (viewPort is RenderBox) {
      viewPortHeight = viewPort.size.height;
    }

    double anchor = 0;
    if (viewPort is RenderViewport) {
      anchor = viewPort.anchor;
    }

    return -viewPortHeight * anchor;
  }

  /// Check current header offset exits content size, if exist then place the
  /// header at content size.
  double _getCurrentOffset(double currentOffset, double contentSize) {
    final double currentHeaderPosition =
        -currentOffset > contentSize ? contentSize : -currentOffset;
    return currentHeaderPosition > 0 ? currentHeaderPosition : 0;
  }

  /// Return current offset value from header size and content size.
  double _getHeaderOffset(
    double contentSize,
    double offset,
    double headerSize,
  ) {
    return headerSize + offset < contentSize
        ? offset
        : contentSize - headerSize;
  }
}
