part of calendar;

/// The class contains all day panel selection details.
/// if all day panel appointment selected then [appointmentView] holds
/// appointment details, else [selectedDate] holds selected region date value.
@immutable
class _SelectionDetails {
  const _SelectionDetails(this.appointmentView, this.selectedDate);

  final _AppointmentView appointmentView;
  final DateTime selectedDate;
}

class _AllDayAppointmentPainter extends CustomPainter {
  _AllDayAppointmentPainter(
      this.calendar,
      this.view,
      this.visibleDates,
      this.visibleAppointment,
      this.timeLabelWidth,
      this.allDayPainterHeight,
      this.isExpandable,
      this.isExpanding,
      this.isRTL,
      this.calendarTheme,
      this.repaintNotifier,
      this.allDayHoverPosition,
      this.textScaleFactor,
      {this.updateCalendarState})
      : super(repaint: repaintNotifier);

  final SfCalendar calendar;
  final CalendarView view;
  final List<DateTime> visibleDates;
  final List<Appointment> visibleAppointment;
  final ValueNotifier<_SelectionDetails> repaintNotifier;
  final _UpdateCalendarState updateCalendarState;
  final double timeLabelWidth;
  final double allDayPainterHeight;
  final bool isRTL;
  final SfCalendarThemeData calendarTheme;
  final Offset allDayHoverPosition;
  final double textScaleFactor;

  //// is expandable variable used to indicate whether the all day layout expandable or not.
  final bool isExpandable;

  //// is expanding variable used to identify the animation currently running or not.
  //// It is used to restrict the expander icon show on initial animation.
  final bool isExpanding;
  double _cellWidth;
  Paint _rectPainter;
  TextPainter _textPainter;
  TextPainter _expanderTextPainter;
  BoxPainter _boxPainter;
  int _maxPosition;
  bool _isHoveringAppointment = false;
  final _UpdateCalendarStateDetails _updateCalendarStateDetails =
      _UpdateCalendarStateDetails();

  @override
  void paint(Canvas canvas, Size size) {
    _updateCalendarStateDetails._allDayAppointmentViewCollection = null;
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    updateCalendarState(_updateCalendarStateDetails);
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _rectPainter = _rectPainter ?? Paint();

    _updateCalendarStateDetails._allDayAppointmentViewCollection =
        _updateCalendarStateDetails._allDayAppointmentViewCollection ??
            <_AppointmentView>[];

    if (view == CalendarView.day) {
      _rectPainter ??= Paint();
      _rectPainter.strokeWidth = 0.5;
      _rectPainter.color =
          calendar.cellBorderColor ?? calendarTheme.cellBorderColor;
      //// Decrease the x position by 0.5 because draw the end point of the view
      /// draws half of the line to current view and hides another half.
      canvas.drawLine(
          Offset(
              isRTL ? size.width - timeLabelWidth + 0.5 : timeLabelWidth - 0.5,
              0),
          Offset(
              isRTL ? size.width - timeLabelWidth + 0.5 : timeLabelWidth - 0.5,
              size.height),
          _rectPainter);
    }

    if (visibleDates != _updateCalendarStateDetails._currentViewVisibleDates) {
      return;
    }

    _rectPainter.isAntiAlias = true;
    _cellWidth = (size.width - timeLabelWidth) / visibleDates.length;
    const double textPadding = 3;
    _maxPosition = 0;
    if (_updateCalendarStateDetails
        ._allDayAppointmentViewCollection.isNotEmpty) {
      _maxPosition = _updateCalendarStateDetails
          ._allDayAppointmentViewCollection
          .reduce(
              (_AppointmentView currentAppView, _AppointmentView nextAppView) =>
                  currentAppView.maxPositions > nextAppView.maxPositions
                      ? currentAppView
                      : nextAppView)
          .maxPositions;
    }

    if (_maxPosition == -1) {
      _maxPosition = 0;
    }

    final int position = allDayPainterHeight ~/ _kAllDayAppointmentHeight;
    for (int i = 0;
        i < _updateCalendarStateDetails._allDayAppointmentViewCollection.length;
        i++) {
      final _AppointmentView appointmentView =
          _updateCalendarStateDetails._allDayAppointmentViewCollection[i];
      if (appointmentView.canReuse) {
        continue;
      }

      final Appointment appointment = appointmentView.appointment;
      RRect rect;
      if (isRTL) {
        rect = RRect.fromRectAndRadius(
            Rect.fromLTRB(
                ((visibleDates.length - appointmentView.endIndex) *
                        _cellWidth) +
                    textPadding,
                (_kAllDayAppointmentHeight * appointmentView.position)
                    .toDouble(),
                (visibleDates.length - appointmentView.startIndex) * _cellWidth,
                ((_kAllDayAppointmentHeight * appointmentView.position) +
                        _kAllDayAppointmentHeight -
                        1)
                    .toDouble()),
            const Radius.circular((_kAllDayAppointmentHeight * 0.1) > 2
                ? 2
                : (_kAllDayAppointmentHeight * 0.1)));
      } else {
        rect = RRect.fromRectAndRadius(
            Rect.fromLTRB(
                timeLabelWidth + (appointmentView.startIndex * _cellWidth),
                (_kAllDayAppointmentHeight * appointmentView.position)
                    .toDouble(),
                (appointmentView.endIndex * _cellWidth) +
                    timeLabelWidth -
                    textPadding,
                ((_kAllDayAppointmentHeight * appointmentView.position) +
                        _kAllDayAppointmentHeight -
                        1)
                    .toDouble()),
            const Radius.circular((_kAllDayAppointmentHeight * 0.1) > 2
                ? 2
                : (_kAllDayAppointmentHeight * 0.1)));
      }

      appointmentView.appointmentRect = rect;
      if (!isRTL && rect.left < timeLabelWidth - 1 ||
          rect.right > size.width + 1 ||
          (rect.bottom > allDayPainterHeight - _kAllDayAppointmentHeight &&
              appointmentView.maxPositions > position)) {
        continue;
      } else if (isRTL && rect.right > size.width - timeLabelWidth + 1 ||
          rect.left < 0 ||
          (rect.bottom > allDayPainterHeight - _kAllDayAppointmentHeight &&
              appointmentView.maxPositions > position)) {
        continue;
      }

      _rectPainter.color = appointment.color;
      canvas.drawRRect(rect, _rectPainter);
      final TextSpan span = TextSpan(
        text: _getAllDayAppointmentText(appointment),
        style: calendar.appointmentTextStyle,
      );
      _textPainter = _textPainter ??
          TextPainter(
              textDirection: TextDirection.ltr,
              maxLines: 1,
              textAlign: TextAlign.left,
              textScaleFactor: textScaleFactor,
              textWidthBasis: TextWidthBasis.longestLine);
      _textPainter.text = span;
      _textPainter.layout(
          minWidth: 0,
          maxWidth:
              rect.width - textPadding >= 0 ? rect.width - textPadding : 0);
      if (_textPainter.maxLines == 1 && _textPainter.height > rect.height) {
        continue;
      }

      final bool canAddSpanIcon =
          _canAddSpanIcon(visibleDates, appointment, view);
      bool canAddForwardIcon = false;
      bool canAddBackwardIcon = false;

      double xPosition = isRTL
          ? rect.right - _textPainter.width - textPadding
          : rect.left + textPadding;

      if (canAddSpanIcon) {
        final DateTime appStartTime = appointment._exactStartTime;
        final DateTime appEndTime = appointment._exactEndTime;
        final DateTime viewStartDate = _convertToStartTime(visibleDates[0]);
        final DateTime viewEndDate =
            _convertToEndTime(visibleDates[visibleDates.length - 1]);
        double iconSize = _getTextSize(
            rect,
            (calendar.appointmentTextStyle.fontSize *
                _textPainter.textScaleFactor));
        if (_canAddForwardSpanIcon(
            appStartTime, appEndTime, viewStartDate, viewEndDate)) {
          canAddForwardIcon = true;
          iconSize = null;
        } else if (_canAddBackwardSpanIcon(
            appStartTime, appEndTime, viewStartDate, viewEndDate)) {
          canAddBackwardIcon = true;
        } else {
          canAddForwardIcon = true;
          canAddBackwardIcon = true;
        }

        if (iconSize != null) {
          if (isRTL) {
            xPosition -= iconSize + (kIsWeb ? 2 : 0);
          } else {
            xPosition += iconSize + (kIsWeb ? 2 : 0);
          }
        }
      }

      _textPainter.paint(
          canvas,
          Offset(
              xPosition, rect.top + (rect.height - _textPainter.height) / 2));
      if (appointment.recurrenceRule != null &&
          appointment.recurrenceRule.isNotEmpty) {
        _addRecurrenceIcon(canvas, rect, textPadding);
      }

      if (canAddSpanIcon) {
        if (canAddForwardIcon && canAddBackwardIcon) {
          _addForwardSpanIconForAllDay(canvas, rect, textPadding);
          _addBackwardSpanIconForAllDay(canvas, rect, textPadding);
        } else if (canAddBackwardIcon) {
          _addBackwardSpanIconForAllDay(canvas, rect, textPadding);
        } else {
          _addForwardSpanIconForAllDay(canvas, rect, textPadding);
        }
      }

      if (allDayHoverPosition != null) {
        _addMouseHoveringForAppointment(canvas, rect);
      }

      if (repaintNotifier.value != null &&
          repaintNotifier.value.appointmentView != null &&
          repaintNotifier.value.appointmentView.appointment != null &&
          repaintNotifier.value.appointmentView.appointment ==
              appointmentView.appointment) {
        _addSelectionForAppointment(canvas, appointmentView);
      }
    }

    if (repaintNotifier.value != null &&
        repaintNotifier.value.selectedDate != null) {
      _addSelectionForAllDayPanel(canvas, size, textPadding);
    }

    if (isExpandable && _maxPosition > position && !isExpanding) {
      _addExpanderText(canvas, position, textPadding);
    }

    if (isExpandable) {
      _addExpandOrCollapseIcon(canvas, size, position);
    }

    if (allDayHoverPosition != null && !_isHoveringAppointment) {
      _addMouseHoveringForAllDayPanel(canvas, size);
    }
  }

  /// To display the different text on spanning appointment for day view, for
  /// other views we just display the subject of the appointment and for day
  /// view  we display the current date, and total dates of the spanning
  /// appointment.
  String _getAllDayAppointmentText(Appointment appointment) {
    if (view != CalendarView.day || !appointment._isSpanned) {
      return appointment.subject;
    }

    return _getSpanAppointmentText(appointment, visibleDates[0]);
  }

  double _getTextSize(RRect rect, double textSize) {
    if (rect.width < textSize || rect.height < textSize) {
      return rect.width > rect.height ? rect.height : rect.width;
    }

    return textSize;
  }

  void _addForwardSpanIconForAllDay(
      Canvas canvas, RRect rect, double textPadding) {
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);
    final TextSpan icon = _getSpanIcon(
        calendar.appointmentTextStyle.color, textSize, isRTL ? false : true);
    final double leftPadding = kIsWeb ? 2 : 1;
    _textPainter.text = icon;
    _textPainter.layout(
        minWidth: 0,
        maxWidth: rect.width - textPadding >= 0 ? rect.width - textPadding : 0);

    final double yPosition = _getYPositionForSpanIcon(icon, _textPainter, rect);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(isRTL ? rect.left : rect.right - textSize, rect.top,
                isRTL ? rect.left : rect.right, rect.bottom),
            rect.brRadius),
        _rectPainter);
    _textPainter.paint(
        canvas,
        Offset(
            isRTL
                ? rect.left + leftPadding
                : rect.right -
                    (textSize * _textPainter.textScaleFactor) -
                    leftPadding,
            yPosition));
  }

  void _addBackwardSpanIconForAllDay(
      Canvas canvas, RRect rect, double textPadding) {
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);
    final TextSpan icon = _getSpanIcon(
        calendar.appointmentTextStyle.color, textSize, isRTL ? true : false);
    final double leftPadding = kIsWeb ? 2 : 1;
    _textPainter.text = icon;
    _textPainter.layout(
        minWidth: 0,
        maxWidth: rect.width - textPadding >= 0 ? rect.width - textPadding : 0);

    final double yPosition = _getYPositionForSpanIcon(icon, _textPainter, rect);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(isRTL ? rect.right - textSize : rect.left, rect.top,
                isRTL ? rect.right : rect.left, rect.bottom),
            rect.brRadius),
        _rectPainter);
    _textPainter.paint(
        canvas,
        Offset(
            isRTL
                ? rect.right -
                    (textSize * _textPainter.textScaleFactor) -
                    leftPadding
                : rect.left + leftPadding,
            yPosition));
  }

  void _addExpanderText(Canvas canvas, int position, double textPadding) {
    TextStyle textStyle = calendar.viewHeaderStyle.dayTextStyle;
    textStyle ??= calendarTheme.viewHeaderDayTextStyle;
    _textPainter = _textPainter ??
        TextPainter(
            textDirection: TextDirection.ltr,
            maxLines: 1,
            textAlign: TextAlign.left,
            textScaleFactor: textScaleFactor,
            textWidthBasis: TextWidthBasis.longestLine);

    final double endYPosition = allDayPainterHeight - _kAllDayAppointmentHeight;
    final int endIndexPosition = position - 1;
    for (int i = 0; i < visibleDates.length; i++) {
      int count = 0;
      for (final _AppointmentView view
          in _updateCalendarStateDetails._allDayAppointmentViewCollection) {
        if (view.appointment == null) {
          continue;
        }

        /// Check appointment after the all day panel height.
        /// start index is used to specify current visible date index and
        /// end index used to specify the next visible date index
        /// eg., if appointment start and end date as same then the
        /// end index is point to next index of start index. start index as
        /// 5 then end index as 6 when the start and end date as equal.
        if (view.startIndex <= i && view.endIndex > i) {
          /// Add after the end position appointment and same position
          /// but its max position greater than end position(add appointment
          /// if appointment position as end position and the visible date
          /// cell have more appointments).
          if (view.position > endIndexPosition ||
              (view.position == endIndexPosition &&
                  view.maxPositions > position)) {
            count++;
          }
        }
      }

      if (count == 0) {
        continue;
      }

      final TextSpan span = TextSpan(
        text: '+ ' + count.toString(),
        style: textStyle,
      );
      _textPainter.text = span;
      _textPainter.layout(
          minWidth: 0,
          maxWidth:
              _cellWidth - textPadding >= 0 ? _cellWidth - textPadding : 0);

      _textPainter.paint(
          canvas,
          Offset(
              isRTL
                  ? ((visibleDates.length - i) * _cellWidth) -
                      _textPainter.width -
                      textPadding
                  : timeLabelWidth + (i * _cellWidth) + textPadding,
              endYPosition +
                  ((_kAllDayAppointmentHeight - _textPainter.height) / 2)));
    }
  }

  void _addExpandOrCollapseIcon(Canvas canvas, Size size, int position) {
    final int iconCodePoint = _maxPosition <= position
        ? Icons.expand_less.codePoint
        : Icons.expand_more.codePoint;
    final TextSpan icon = TextSpan(
        text: String.fromCharCode(iconCodePoint),
        style: TextStyle(
          color: calendar.viewHeaderStyle != null &&
                  calendar.viewHeaderStyle.dayTextStyle != null &&
                  calendar.viewHeaderStyle.dayTextStyle.color != null
              ? calendar.viewHeaderStyle.dayTextStyle.color
              : calendarTheme.viewHeaderDayTextStyle.color,
          fontSize: calendar.viewHeaderStyle != null &&
                  calendar.viewHeaderStyle.dayTextStyle != null &&
                  calendar.viewHeaderStyle.dayTextStyle.fontSize != null
              ? calendar.viewHeaderStyle.dayTextStyle.fontSize * 2
              : _kAllDayAppointmentHeight + 5,
          fontFamily: 'MaterialIcons',
        ));
    _expanderTextPainter ??= TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        textScaleFactor: textScaleFactor,
        maxLines: 1);
    _expanderTextPainter.text = icon;
    _expanderTextPainter.layout(minWidth: 0, maxWidth: timeLabelWidth);
    _expanderTextPainter.paint(
        canvas,
        Offset(
            isRTL
                ? (size.width - timeLabelWidth) +
                    ((timeLabelWidth - _expanderTextPainter.width) / 2)
                : (timeLabelWidth - _expanderTextPainter.width) / 2,
            allDayPainterHeight -
                _kAllDayAppointmentHeight +
                (_kAllDayAppointmentHeight - _expanderTextPainter.height) / 2));
  }

  void _addMouseHoveringForAllDayPanel(Canvas canvas, Size size) {
    final int rowIndex = allDayHoverPosition.dx ~/ _cellWidth;
    final double leftPosition = rowIndex * _cellWidth;
    _rectPainter.color = Colors.grey.withOpacity(0.1);
    canvas.drawRect(
        Rect.fromLTWH(isRTL ? leftPosition : leftPosition + timeLabelWidth, 0,
            _cellWidth, size.height),
        _rectPainter);
  }

  void _addSelectionForAllDayPanel(
      Canvas canvas, Size size, double textPadding) {
    final int index =
        _getIndex(visibleDates, repaintNotifier.value.selectedDate);
    Decoration selectionDecoration = calendar.selectionDecoration;

    /// Set the default selection decoration background color with opacity
    /// value based on theme brightness when selected date hold all day
    /// appointment.
    for (int i = 0;
        i < _updateCalendarStateDetails._allDayAppointmentViewCollection.length;
        i++) {
      final _AppointmentView appointmentView =
          _updateCalendarStateDetails._allDayAppointmentViewCollection[i];
      if (appointmentView.position == 0 &&
          appointmentView.startIndex <= index &&
          appointmentView.endIndex > index) {
        selectionDecoration ??= BoxDecoration(
          color: calendarTheme.brightness == null ||
                  calendarTheme.brightness == Brightness.light
              ? Colors.white.withOpacity(0.3)
              : Colors.black.withOpacity(0.4),
          border:
              Border.all(color: calendarTheme.selectionBorderColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          shape: BoxShape.rectangle,
        );

        break;
      }
    }

    /// Set the default selection decoration background color as transparent
    /// when selected date does not hold all day appointment.
    selectionDecoration ??= BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: calendarTheme.selectionBorderColor, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      shape: BoxShape.rectangle,
    );

    Rect rect;
    double xValue = timeLabelWidth + (index * _cellWidth);
    if (isRTL) {
      xValue = size.width - xValue - _cellWidth;
      rect = Rect.fromLTRB(xValue + textPadding, 0, xValue + _cellWidth,
          _kAllDayAppointmentHeight - 1);
    } else {
      rect = Rect.fromLTRB(xValue, 0, xValue + _cellWidth - textPadding,
          _kAllDayAppointmentHeight - 1);
    }

    _boxPainter = selectionDecoration.createBoxPainter();
    _boxPainter.paint(canvas, Offset(rect.left, rect.top),
        ImageConfiguration(size: rect.size));

    selectionDecoration = null;
  }

  void _addSelectionForAppointment(
      Canvas canvas, _AppointmentView appointmentView) {
    Decoration selectionDecoration = calendar.selectionDecoration;
    selectionDecoration ??= BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: calendarTheme.selectionBorderColor, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(1)),
      shape: BoxShape.rectangle,
    );

    Rect rect = appointmentView.appointmentRect.outerRect;
    rect = Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);
    _boxPainter = selectionDecoration.createBoxPainter();
    _boxPainter.paint(canvas, Offset(rect.left, rect.top),
        ImageConfiguration(size: rect.size));
  }

  void _addMouseHoveringForAppointment(Canvas canvas, RRect rect) {
    _rectPainter ??= Paint();
    _isHoveringAppointment = false;
    if (rect.left < allDayHoverPosition.dx &&
        rect.right - timeLabelWidth > allDayHoverPosition.dx &&
        rect.top < allDayHoverPosition.dy &&
        rect.bottom > allDayHoverPosition.dy) {
      _rectPainter.color = calendarTheme.selectionBorderColor.withOpacity(0.4);
      _rectPainter.strokeWidth = 2;
      _rectPainter.style = PaintingStyle.stroke;
      canvas.drawRect(rect.outerRect, _rectPainter);
      _rectPainter.style = PaintingStyle.fill;
      _isHoveringAppointment = true;
    }
  }

  void _addRecurrenceIcon(Canvas canvas, RRect rect, double textPadding) {
    final double textSize =
        _getTextSize(rect, calendar.appointmentTextStyle.fontSize);
    final TextSpan icon =
        _getRecurrenceIcon(calendar.appointmentTextStyle.color, textSize);
    _textPainter.text = icon;
    _textPainter.layout(
        minWidth: 0,
        maxWidth: rect.width - textPadding >= 0 ? rect.width - textPadding : 0);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(isRTL ? rect.left : rect.right - textSize, rect.top,
                isRTL ? rect.left : rect.right, rect.bottom),
            rect.brRadius),
        _rectPainter);
    _textPainter.paint(
        canvas,
        Offset(isRTL ? rect.left + 1 : rect.right - textSize - 1,
            rect.top + (rect.height - _textPainter.height) / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _AllDayAppointmentPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.allDayPainterHeight != allDayPainterHeight ||
        oldWidget.visibleAppointment != visibleAppointment ||
        oldWidget.calendar.cellBorderColor != calendar.cellBorderColor ||
        oldWidget.calendarTheme != calendarTheme ||
        oldWidget.isRTL != isRTL ||
        oldWidget.view != view ||
        oldWidget.isExpandable != isExpandable ||
        oldWidget.allDayHoverPosition != allDayHoverPosition ||
        oldWidget.textScaleFactor != textScaleFactor;
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
    final _AllDayAppointmentPainter oldWidget = oldDelegate;
    return oldWidget.visibleDates != visibleDates ||
        oldWidget.visibleAppointment != visibleAppointment ||
        oldWidget.allDayPainterHeight != allDayPainterHeight;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    final List<_AppointmentView> appointmentCollection =
        _updateCalendarStateDetails._allDayAppointmentViewCollection;
    if (appointmentCollection == null || appointmentCollection.isEmpty) {
      return semanticsBuilder;
    }

    final int position = allDayPainterHeight ~/ _kAllDayAppointmentHeight;
    final double bottom = allDayPainterHeight - _kAllDayAppointmentHeight;
    if (isExpandable) {
      final double left = isRTL ? size.width - timeLabelWidth : 0;
      final double top = allDayPainterHeight - _kAllDayAppointmentHeight;
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(left, top, isRTL ? size.width : timeLabelWidth,
            _expanderTextPainter.height),
        properties: SemanticsProperties(
          label:
              _maxPosition <= allDayPainterHeight ~/ _kAllDayAppointmentHeight
                  ? 'Collapse all day section'
                  : 'Expand all day section',
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    if (isExpandable &&
        _maxPosition > (allDayPainterHeight ~/ _kAllDayAppointmentHeight) &&
        !isExpanding) {
      final int endIndexPosition = position - 1;
      for (int i = 0; i < visibleDates.length; i++) {
        int count = 0;
        for (final _AppointmentView view
            in _updateCalendarStateDetails._allDayAppointmentViewCollection) {
          if (view.appointment == null) {
            continue;
          }

          /// Check appointment after the all day panel height.
          /// start index is used to specify current visible date index and
          /// end index used to specify the next visible date index
          /// eg., if appointment start and end date as same then the
          /// end index is point to next index of start index. start index as
          /// 5 then end index as 6 when the start and end date as equal.
          if (view.startIndex <= i && view.endIndex > i) {
            /// Add after the end position appointment and same position
            /// but its max position greater than end position(add appointment
            /// if appointment position as end position and the visible date
            /// cell have more appointments).
            if (view.position > endIndexPosition ||
                (view.position == endIndexPosition &&
                    view.maxPositions > position)) {
              count++;
            }
          }
        }

        if (count == 0) {
          continue;
        }

        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(
              isRTL
                  ? ((visibleDates.length - i) * _cellWidth) - _cellWidth
                  : timeLabelWidth + (i * _cellWidth),
              bottom,
              _cellWidth,
              _kAllDayAppointmentHeight),
          properties: SemanticsProperties(
            label: '+' + count.toString(),
            textDirection: TextDirection.ltr,
          ),
        ));
      }
    }

    for (int i = 0; i < appointmentCollection.length; i++) {
      final _AppointmentView view = appointmentCollection[i];
      if (view.appointment == null ||
          (view.appointmentRect != null &&
              view.appointmentRect.bottom > bottom &&
              view.maxPositions > position)) {
        continue;
      }

      semanticsBuilder.add(CustomPainterSemantics(
        rect: view.appointmentRect == null
            ? const Rect.fromLTWH(0, 0, 10, 10)
            : view.appointmentRect?.outerRect,
        properties: SemanticsProperties(
          label: _getAppointmentText(view.appointment),
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    return semanticsBuilder;
  }
}
