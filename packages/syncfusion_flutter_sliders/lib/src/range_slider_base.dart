import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'slider_base.dart';
import 'slider_shapes.dart';

/// Base render box class for both [SfRangeSlider] and [SfRangeSelector].
abstract class RenderBaseRangeSlider extends RenderBaseSlider
    implements MouseTrackerAnnotation {
  /// Creates a [RenderBaseRangeSlider].
  RenderBaseRangeSlider({
    required dynamic min,
    required dynamic max,
    required SfRangeValues? values,
    required double? interval,
    required double? stepSize,
    required SliderStepDuration? stepDuration,
    required int minorTicksPerInterval,
    required bool showTicks,
    required bool showLabels,
    required bool showDividers,
    required bool enableTooltip,
    required bool enableIntervalSelection,
    required SliderDragMode dragMode,
    required LabelPlacement labelPlacement,
    required NumberFormat numberFormat,
    required DateFormat? dateFormat,
    required DateIntervalType? dateIntervalType,
    required LabelFormatterCallback labelFormatterCallback,
    required TooltipTextFormatterCallback tooltipTextFormatterCallback,
    required SfTrackShape trackShape,
    required SfDividerShape dividerShape,
    required SfOverlayShape overlayShape,
    required SfThumbShape thumbShape,
    required SfTickShape tickShape,
    required SfTickShape minorTickShape,
    required SfTooltipShape tooltipShape,
    required SfRangeSliderThemeData sliderThemeData,
    required SliderType sliderType,
    required SliderTooltipPosition? tooltipPosition,
    required TextDirection textDirection,
    required MediaQueryData mediaQueryData,
  })  : _values = values!,
        _dragMode = dragMode,
        _enableIntervalSelection = enableIntervalSelection,
        super(
            min: min,
            max: max,
            interval: interval,
            stepSize: stepSize,
            stepDuration: stepDuration,
            minorTicksPerInterval: minorTicksPerInterval,
            showTicks: showTicks,
            showLabels: showLabels,
            showDividers: showDividers,
            enableTooltip: enableTooltip,
            labelPlacement: labelPlacement,
            numberFormat: numberFormat,
            dateFormat: dateFormat,
            dateIntervalType: dateIntervalType,
            labelFormatterCallback: labelFormatterCallback,
            tooltipTextFormatterCallback: tooltipTextFormatterCallback,
            trackShape: trackShape,
            dividerShape: dividerShape,
            overlayShape: overlayShape,
            thumbShape: thumbShape,
            tickShape: tickShape,
            minorTickShape: minorTickShape,
            tooltipShape: tooltipShape,
            sliderThemeData: sliderThemeData,
            sliderType: sliderType,
            tooltipPosition: tooltipPosition,
            textDirection: textDirection,
            mediaQueryData: mediaQueryData) {
    final GestureArenaTeam team = GestureArenaTeam();
    if (sliderType == SliderType.horizontal) {
      horizontalDragGestureRecognizer = HorizontalDragGestureRecognizer()
        ..team = team
        ..onStart = _onDragStart
        ..onUpdate = _onDragUpdate
        ..onEnd = _onDragEnd
        ..onCancel = _onDragCancel;
    }
    if (sliderType == SliderType.vertical) {
      verticalDragGestureRecognizer = VerticalDragGestureRecognizer()
        ..team = team
        ..onStart = _onVerticalDragStart
        ..onUpdate = _onVerticalDragUpdate
        ..onEnd = _onVerticalDragEnd
        ..onCancel = _onVerticalDragCancel;
    }
    tapGestureRecognizer = TapGestureRecognizer()
      ..team = team
      ..onTapDown = _onTapDown
      ..onTapUp = _onTapUp;

    _overlayStartAnimation = CurvedAnimation(
        parent: overlayStartController, curve: Curves.fastOutSlowIn);
    _overlayEndAnimation = CurvedAnimation(
        parent: overlayEndController, curve: Curves.fastOutSlowIn);
    _stateAnimation =
        CurvedAnimation(parent: stateController, curve: Curves.easeInOut);
    _tooltipStartAnimation = CurvedAnimation(
        parent: tooltipAnimationStartController, curve: Curves.fastOutSlowIn);
    _tooltipEndAnimation = CurvedAnimation(
        parent: tooltipAnimationEndController, curve: Curves.fastOutSlowIn);

    if (isDateTime) {
      _valuesInMilliseconds = SfRangeValues(
          values.start.millisecondsSinceEpoch.toDouble(),
          values.end.millisecondsSinceEpoch.toDouble());
    }
    unformattedLabels = <double>[];
    updateTextPainter();

    if (_enableIntervalSelection) {
      startPositionController.value = getFactorFromValue(actualValues.start);
      endPositionController.value = getFactorFromValue(actualValues.end);
    }
  }

  final Map<ChildElements, RenderBox> slotToChild =
      <ChildElements, RenderBox>{};
  final Map<RenderBox, ChildElements> childToSlot =
      <RenderBox, ChildElements>{};

  late AnimationController overlayStartController;
  late AnimationController overlayEndController;
  late AnimationController stateController;
  late AnimationController startPositionController;
  late AnimationController endPositionController;
  late AnimationController tooltipAnimationStartController;
  late AnimationController tooltipAnimationEndController;
  late Animation<double> _overlayStartAnimation;
  late Animation<double> _overlayEndAnimation;
  late Animation<double> _stateAnimation;
  late Animation<double> _tooltipStartAnimation;
  late Animation<double> _tooltipEndAnimation;
  late bool _validForMouseTracker;
  late SfRangeValues _valuesInMilliseconds;
  late SfRangeValues _beginValues;

  bool _isDragging = false;
  bool isIntervalTapped = false;
  bool _isLocked = false;
  bool _isDragStart = false;
  bool? mounted;
  Timer? tooltipDelayTimer;

  // It stores the interaction start it's main axis at [tapDown] and [dragStart]
  // method, which is used to check whether dragging is started or not.
  double _interactionStartOffset = 0.0;

  static const Duration _positionAnimationDuration =
      Duration(milliseconds: 500);

  SfRangeValues get values => _values;
  late SfRangeValues _values;
  set values(SfRangeValues values) {
    if (_values == values) {
      return;
    }
    _values = values;
    if (isDateTime) {
      _valuesInMilliseconds = SfRangeValues(
          _values.start.millisecondsSinceEpoch.toDouble(),
          _values.end.millisecondsSinceEpoch.toDouble());
    }
    markNeedsPaint();
  }

  bool get enableIntervalSelection => _enableIntervalSelection;
  bool _enableIntervalSelection;
  set enableIntervalSelection(bool value) {
    if (_enableIntervalSelection == value) {
      return;
    }
    _enableIntervalSelection = value;
    startPositionController.value = getFactorFromValue(actualValues.start);
    endPositionController.value = getFactorFromValue(actualValues.end);
  }

  SliderDragMode get dragMode => _dragMode;
  SliderDragMode _dragMode;
  set dragMode(SliderDragMode value) {
    if (_dragMode == value) {
      return;
    }
    _dragMode = value;
  }

  RenderBox? get startThumbIcon => _startThumbIcon;
  RenderBox? _startThumbIcon;
  set startThumbIcon(RenderBox? value) {
    _startThumbIcon =
        updateChild(_startThumbIcon, value, ChildElements.startThumbIcon);
  }

  RenderBox? get endThumbIcon => _endThumbIcon;
  RenderBox? _endThumbIcon;
  set endThumbIcon(RenderBox? value) {
    _endThumbIcon =
        updateChild(_endThumbIcon, value, ChildElements.endThumbIcon);
  }

  @override
  SfThumb? get activeThumb => _activeThumb;
  SfThumb? _activeThumb;
  @override
  set activeThumb(SfThumb? value) {
    // Ensuring whether the animation is already completed
    // and calling controller's forward again is not needed.
    if (_activeThumb == value &&
        (overlayEndController.status == AnimationStatus.completed ||
            overlayStartController.status == AnimationStatus.completed)) {
      return;
    }
    _activeThumb = value;
    _forwardTooltipAndOverlayController();
  }

  double get minThumbGap => sliderType == SliderType.vertical
      ? (actualMax - actualMin) * (8 / actualTrackRect.height).clamp(0.0, 1.0)
      : (actualMax - actualMin) * (8 / actualTrackRect.width).clamp(0.0, 1.0);

  SfRangeValues get actualValues =>
      isDateTime ? _valuesInMilliseconds : _values;

  dynamic get increasedStartValue {
    return getNextSemanticValue(values.start, semanticActionUnit,
        actualValue: actualValues.start);
  }

  dynamic get decreasedStartValue {
    return getPrevSemanticValue(values.start, semanticActionUnit,
        actualValue: actualValues.start);
  }

  dynamic get increasedEndValue {
    return getNextSemanticValue(values.end, semanticActionUnit,
        actualValue: actualValues.end);
  }

  dynamic get decreasedEndValue {
    return getPrevSemanticValue(values.end, semanticActionUnit,
        actualValue: actualValues.end);
  }

  RenderBox? updateChild(
      RenderBox? oldChild, RenderBox? newChild, ChildElements slot) {
    if (oldChild != null) {
      dropChild(oldChild);
      childToSlot.remove(oldChild);
      slotToChild.remove(slot);
    }
    if (newChild != null) {
      childToSlot[newChild] = slot;
      slotToChild[slot] = newChild;
      adoptChild(newChild);
    }
    return newChild;
  }

  void _onTapDown(TapDownDetails details) {
    currentPointerType = PointerType.down;
    _interactionStartOffset = sliderType == SliderType.vertical
        ? globalToLocal(details.globalPosition).dy
        : globalToLocal(details.globalPosition).dx;
    mainAxisOffset = _interactionStartOffset;
    _beginInteraction();
  }

  void _onTapUp(TapUpDetails details) {
    _endInteraction();
  }

  void _onDragStart(DragStartDetails details) {
    _isDragStart = true;
    _interactionStartOffset = globalToLocal(details.globalPosition).dx;
    mainAxisOffset = _interactionStartOffset;
    _beginInteraction();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    mainAxisOffset = globalToLocal(details.globalPosition).dx;
    _updateRangeValues(delta: mainAxisOffset - _interactionStartOffset);
    markNeedsPaint();
  }

  void _onDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onDragCancel() {
    _endInteraction();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _isDragStart = true;
    _interactionStartOffset = globalToLocal(details.globalPosition).dy;
    mainAxisOffset = _interactionStartOffset;
    _beginInteraction();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    mainAxisOffset = globalToLocal(details.globalPosition).dy;
    _updateRangeValues(delta: mainAxisOffset - _interactionStartOffset);
    markNeedsPaint();
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onVerticalDragCancel() {
    _endInteraction();
  }

  void _beginInteraction() {
    _beginValues = _values;
    // This field is used in the [paint] method to handle the
    // interval selection animation, so we can't reset this
    // field in [endInteraction] method.
    isIntervalTapped = false;
    isInteractionEnd = false;
    final double startPosition =
        getPositionFromValue(actualValues.start.toDouble());
    final double endPosition =
        getPositionFromValue(actualValues.end.toDouble());
    final double leftThumbWidth = (startPosition - mainAxisOffset).abs();
    final double rightThumbWidth = (endPosition - mainAxisOffset).abs();

    if ((_dragMode == SliderDragMode.both ||
            _dragMode == SliderDragMode.betweenThumbs) &&
        _tappedBetweenThumbs(startPosition, endPosition)) {
      if (_isDragStart) {
        _isLocked = true;
      } else {
        return;
      }
    } else if (rightThumbWidth == leftThumbWidth) {
      switch (activeThumb!) {
        case SfThumb.start:
          overlayStartController.forward();
          break;
        case SfThumb.end:
          overlayEndController.forward();
          break;
      }
    } else if (rightThumbWidth > leftThumbWidth) {
      activeThumb = SfThumb.start;
      overlayStartController.forward();
    } else {
      activeThumb = SfThumb.end;
      overlayEndController.forward();
    }

    _forwardTooltipAnimation();
    _updateRangeValues();
    markNeedsPaint();
  }

  bool _tappedBetweenThumbs(double startPosition, double endPosition) {
    return (sliderType == SliderType.vertical ||
            textDirection == TextDirection.rtl)
        ? startPosition > (mainAxisOffset + minPreferredTouchWidth) &&
            (mainAxisOffset - minPreferredTouchWidth) > endPosition
        : startPosition < (mainAxisOffset - minPreferredTouchWidth) &&
            (mainAxisOffset + minPreferredTouchWidth) < endPosition;
  }

  void _forwardTooltipAnimation() {
    if (enableTooltip) {
      willDrawTooltip = true;
      tooltipAnimationStartController.forward();
      tooltipAnimationEndController.forward();
      tooltipDelayTimer?.cancel();
      tooltipDelayTimer = Timer(const Duration(milliseconds: 500), () {
        _reverseTooltipAnimation();
      });
    }
  }

  void _reverseTooltipAnimation() {
    tooltipDelayTimer = null;
    if (isInteractionEnd &&
        willDrawTooltip &&
        tooltipAnimationStartController.status == AnimationStatus.completed) {
      tooltipAnimationStartController.reverse();
    }
    if (isInteractionEnd &&
        willDrawTooltip &&
        tooltipAnimationEndController.status == AnimationStatus.completed) {
      tooltipAnimationEndController.reverse();
    }
    if (tooltipAnimationStartController.status == AnimationStatus.dismissed &&
        tooltipAnimationEndController.status == AnimationStatus.dismissed) {
      willDrawTooltip = false;
    }
  }

  void _updateRangeValues({double? delta}) {
    SfRangeValues newValues = values;
    _isDragging = (_interactionStartOffset - mainAxisOffset).abs() > 1;
    isIntervalTapped = _enableIntervalSelection && !_isDragging;

    if (!isIntervalTapped) {
      if (_isLocked) {
        if (delta != null) {
          newValues = _getLockRangeValues(delta);
        } else {
          return;
        }
      } else if (_dragMode == SliderDragMode.betweenThumbs) {
        return;
      } else {
        final double factor = getFactorFromCurrentPosition();
        final double value = lerpDouble(actualMin, actualMax, factor)!;
        final double start = getNumerizedValue(
            isDateTime ? values.start : values.start.toDouble());
        final double end =
            getNumerizedValue(isDateTime ? values.end : values.end.toDouble());

        switch (activeThumb!) {
          case SfThumb.start:
            final double startValue = math.min(value, end - minThumbGap);
            final dynamic actualStartValue =
                getActualValue(valueInDouble: startValue);
            newValues = values.copyWith(start: actualStartValue);
            break;
          case SfThumb.end:
            final double endValue = math.max(value, start + minThumbGap);
            final dynamic actualEndValue =
                getActualValue(valueInDouble: endValue);
            newValues = values.copyWith(end: actualEndValue);
            break;
        }
      }
    }

    updateValues(newValues);
  }

  SfRangeValues _getLockRangeValues(double? delta) {
    final bool isVertical = sliderType == SliderType.vertical;
    final bool isRTL = textDirection == TextDirection.rtl;
    double startPosition =
        getPositionFromValue(getNumerizedValue(_beginValues.start));
    double endPosition =
        getPositionFromValue(getNumerizedValue(_beginValues.end));
    final double lockedRangeWidth = (isVertical || isRTL)
        ? startPosition - endPosition
        : endPosition - startPosition;
    startPosition += delta ?? 0.0;
    endPosition += delta ?? 0.0;
    final double actualMinInPx = getPositionFromValue(actualMin);
    final double actualMaxInPx = getPositionFromValue(actualMax);

    if (isVertical || isRTL) {
      if (startPosition > actualMinInPx) {
        startPosition = actualMinInPx;
        endPosition = startPosition - lockedRangeWidth;
      } else if (endPosition < actualMaxInPx) {
        endPosition = actualMaxInPx;
        startPosition = endPosition + lockedRangeWidth;
      }

      if (isVertical) {
        startPosition = actualTrackRect.bottom - startPosition;
        endPosition = actualTrackRect.bottom - endPosition;
      }
    } else {
      if (startPosition < actualMinInPx) {
        startPosition = actualMinInPx;
        endPosition = startPosition + lockedRangeWidth;
      } else if (endPosition > actualMaxInPx) {
        endPosition = actualMaxInPx;
        startPosition = endPosition - lockedRangeWidth;
      }
    }
    return SfRangeValues(
        getValueFromPosition(startPosition), getValueFromPosition(endPosition));
  }

  /// Notify the new values to the users using [onChanged] callback in range
  /// slider and [controller] property in range selector.
  void updateValues(SfRangeValues newValues) {
    markNeedsSemanticsUpdate();
  }

  void _endInteraction() {
    if (!isInteractionEnd) {
      SfRangeValues newValues = values;
      if (_enableIntervalSelection) {
        startPositionController.value = getFactorFromValue(actualValues.start);
        endPositionController.value = getFactorFromValue(actualValues.end);

        if (isIntervalTapped) {
          final double? value =
              lerpDouble(actualMin, actualMax, getFactorFromCurrentPosition());
          newValues = _getSelectedRange(value!);
          _updatePositionControllerValue(newValues);
        }
      }

      updateIntervalTappedAndDeferredUpdateValues(newValues);
      _isDragging = false;
      currentPointerType = PointerType.up;
      overlayStartController.reverse();
      overlayEndController.reverse();
      if (enableTooltip && tooltipDelayTimer == null) {
        tooltipAnimationStartController.reverse();
        tooltipAnimationEndController.reverse();
      }

      _isLocked = false;
      _isDragStart = false;
      isInteractionEnd = true;
      markNeedsPaint();
    }
  }

  SfRangeValues _getSelectedRange(double value) {
    late SfRangeValues rangeValues;
    dynamic start;
    dynamic end;

    for (int i = 0; i < divisions!; i++) {
      final double currentLabel = unformattedLabels![i];
      if (i < divisions! - 1) {
        final double nextLabel = unformattedLabels![i + 1];
        if (value >= currentLabel && value <= nextLabel) {
          if (isDateTime) {
            start = DateTime.fromMillisecondsSinceEpoch(currentLabel.toInt());
            end = DateTime.fromMillisecondsSinceEpoch(nextLabel.toInt());
          } else {
            start = currentLabel;
            end = nextLabel;
          }
          rangeValues = SfRangeValues(start, end);
          break;
        }
      } else {
        start = isDateTime
            ? DateTime.fromMillisecondsSinceEpoch(currentLabel.toInt())
            : currentLabel;
        // ignore: unnecessary_this
        end = this.max;
        rangeValues = SfRangeValues(start, end);
      }
    }
    return rangeValues;
  }

  void _updatePositionControllerValue(SfRangeValues newValues) {
    DateTime? startDate;
    DateTime? endDate;

    if (isDateTime) {
      // ignore: avoid_as
      startDate = newValues.start as DateTime;
      // ignore: avoid_as
      endDate = newValues.end as DateTime;
    }
    final double startValueFactor = getFactorFromValue(isDateTime
        ? startDate!.millisecondsSinceEpoch.toDouble()
        : newValues.start);
    final double endValueFactor = getFactorFromValue(isDateTime
        ? endDate!.millisecondsSinceEpoch.toDouble()
        : newValues.end);
    final double startDistanceFactor =
        (startValueFactor - startPositionController.value).abs();

    final double endDistanceFactor =
        (endValueFactor - endPositionController.value).abs();
    startPositionController.duration = startDistanceFactor != 0.0
        ? _positionAnimationDuration * (1.0 / startDistanceFactor)
        : Duration.zero;
    endPositionController.duration = endDistanceFactor != 0.0
        ? _positionAnimationDuration * (1.0 / endDistanceFactor)
        : Duration.zero;
    startPositionController.animateTo(startValueFactor,
        curve: Curves.easeInOut);
    endPositionController.animateTo(endValueFactor, curve: Curves.easeInOut);
  }

  void _handleTooltipAnimationStatusChange(AnimationStatus status) {
    if (tooltipAnimationStartController.status == AnimationStatus.dismissed &&
        tooltipAnimationEndController.status == AnimationStatus.dismissed) {
      willDrawTooltip = false;
    }
  }

  void _forwardTooltipAndOverlayController() {
    switch (_activeThumb!) {
      case SfThumb.start:
        overlayStartController.forward();
        overlayEndController.reverse();
        if (enableTooltip) {
          willDrawTooltip = true;
          tooltipAnimationStartController.forward();
          tooltipAnimationEndController.reverse();
        }
        break;
      case SfThumb.end:
        overlayEndController.forward();
        overlayStartController.reverse();
        if (enableTooltip) {
          willDrawTooltip = true;
          tooltipAnimationEndController.forward();
          tooltipAnimationStartController.reverse();
        }
        break;
    }
  }

  void _handleExit(PointerExitEvent event) {
    // Ensuring whether the thumb is drag or move
    // not needed to call controller's reverse.
    if (mounted! && currentPointerType != PointerType.move) {
      overlayStartController.reverse();
      overlayEndController.reverse();
      if (enableTooltip) {
        tooltipAnimationStartController.reverse();
        tooltipAnimationEndController.reverse();
      }
    }
  }

  void _handleHover(PointerHoverEvent details) {
    double cursorPosition = 0.0;
    final double startThumbPosition =
        getPositionFromValue(actualValues.start.toDouble());
    final double endThumbPosition =
        getPositionFromValue(actualValues.end.toDouble());
    cursorPosition = sliderType == SliderType.vertical
        ? details.localPosition.dy
        : details.localPosition.dx;
    final double startThumbDistance =
        (cursorPosition - startThumbPosition).abs();
    final double endThumbDistance = (cursorPosition - endThumbPosition).abs();

    if (startThumbDistance == endThumbDistance) {
      // The [activeThumb] value is null at the load time, so setting the
      // [activeThumb] to [SfThumb.end] when start, end and min values are all
      // same otherwise set it to [SfThumb.start].
      if (activeThumb == null) {
        if (isDateTime &&
            _valuesInMilliseconds.start == _valuesInMilliseconds.end) {
          activeThumb = _valuesInMilliseconds.start ==
                  min.millisecondsSinceEpoch.toDouble()
              ? SfThumb.end
              : SfThumb.start;
        } else if (_values.start == _values.end) {
          activeThumb = _values.start == min ? SfThumb.end : SfThumb.start;
        }
      } else {
        _forwardTooltipAndOverlayController();
      }
    } else {
      if (endThumbDistance > startThumbDistance) {
        activeThumb = SfThumb.start;
      } else {
        activeThumb = SfThumb.end;
      }
    }
  }

  void _drawOverlayAndThumb(
    PaintingContext context,
    Offset endThumbCenter,
    Offset startThumbCenter,
  ) {
    final bool isStartThumbActive = activeThumb == SfThumb.start;
    Offset thumbCenter = isStartThumbActive ? endThumbCenter : startThumbCenter;
    RenderBox? thumbIcon = isStartThumbActive ? _endThumbIcon : _startThumbIcon;
    // Ignore overlapping thumb stroke for bottom thumb.
    showOverlappingThumbStroke = false;

    // Drawing thumb.
    thumbShape.paint(context, thumbCenter,
        parentBox: this,
        child: thumbIcon,
        themeData: sliderThemeData,
        currentValues: _values,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        thumb: isStartThumbActive ? SfThumb.end : SfThumb.start,
        paint: null);

    thumbCenter = isStartThumbActive ? startThumbCenter : endThumbCenter;
    thumbIcon = isStartThumbActive ? _startThumbIcon : _endThumbIcon;

    // Drawing overlay.
    overlayShape.paint(
      context,
      thumbCenter,
      parentBox: this,
      themeData: sliderThemeData,
      currentValues: _values,
      animation:
          isStartThumbActive ? _overlayStartAnimation : _overlayEndAnimation,
      thumb: activeThumb,
      paint: null,
    );
    showOverlappingThumbStroke = (getFactorFromValue(actualValues.start) -
                    getFactorFromValue(actualValues.end))
                .abs() *
            (sliderType == SliderType.vertical
                ? actualTrackRect.height
                : actualTrackRect.width) <
        actualThumbSize.width;

    // Drawing thumb.
    thumbShape.paint(context, thumbCenter,
        parentBox: this,
        child: thumbIcon,
        themeData: sliderThemeData,
        currentValues: _values,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        thumb: activeThumb,
        paint: null);
  }

  void _drawTooltip(
      PaintingContext context,
      Offset endThumbCenter,
      Offset startThumbCenter,
      Offset offset,
      Offset actualTrackOffset,
      Rect trackRect) {
    if (willDrawTooltip) {
      final Paint paint = Paint()
        ..color = sliderThemeData.tooltipBackgroundColor!
        ..style = PaintingStyle.fill
        ..strokeWidth = 0;

      final bool isStartThumbActive = activeThumb == SfThumb.start;
      Offset thumbCenter =
          isStartThumbActive ? endThumbCenter : startThumbCenter;
      dynamic actualText = (sliderType == SliderType.vertical)
          ? getValueFromPosition(trackRect.bottom - thumbCenter.dy)
          : getValueFromPosition(thumbCenter.dx - offset.dx);

      String tooltipText = tooltipTextFormatterCallback(
          actualText, getFormattedText(actualText));
      TextSpan textSpan =
          TextSpan(text: tooltipText, style: sliderThemeData.tooltipTextStyle);
      textPainter.text = textSpan;
      textPainter.layout();

      Rect? bottomTooltipRect;
      if (tooltipShape is SfPaddleTooltipShape) {
        bottomTooltipRect = getPaddleTooltipRect(
            textPainter,
            Offset(actualTrackOffset.dx, tooltipStartY),
            thumbCenter,
            trackRect,
            sliderThemeData);
      } else if (tooltipShape is SfRectangularTooltipShape) {
        bottomTooltipRect = getRectangularTooltipRect(
            textPainter,
            Offset(actualTrackOffset.dx, tooltipStartY),
            thumbCenter,
            trackRect,
            sliderThemeData);
      }

      // Ignore overlapping tooltip stroke for bottom tooltip.
      showOverlappingTooltipStroke = false;
      tooltipShape.paint(context, thumbCenter,
          Offset(actualTrackOffset.dx, tooltipStartY), textPainter,
          parentBox: this,
          sliderThemeData: sliderThemeData,
          paint: paint,
          animation: isStartThumbActive
              ? _tooltipEndAnimation
              : _tooltipStartAnimation,
          trackRect: trackRect);

      thumbCenter = isStartThumbActive ? startThumbCenter : endThumbCenter;
      actualText = (sliderType == SliderType.vertical)
          ? getValueFromPosition(trackRect.bottom - thumbCenter.dy)
          : getValueFromPosition(thumbCenter.dx - offset.dx);

      tooltipText = tooltipTextFormatterCallback(
          actualText, getFormattedText(actualText));
      textSpan =
          TextSpan(text: tooltipText, style: sliderThemeData.tooltipTextStyle);
      textPainter.text = textSpan;
      textPainter.layout();

      Rect? topTooltipRect;
      if (tooltipShape is SfPaddleTooltipShape) {
        topTooltipRect = getPaddleTooltipRect(
            textPainter,
            Offset(actualTrackOffset.dx, tooltipStartY),
            thumbCenter,
            trackRect,
            sliderThemeData);
      } else if (tooltipShape is SfRectangularTooltipShape) {
        topTooltipRect = getRectangularTooltipRect(
            textPainter,
            Offset(actualTrackOffset.dx, tooltipStartY),
            thumbCenter,
            trackRect,
            sliderThemeData);
      }
      if (bottomTooltipRect != null && topTooltipRect != null) {
        final Rect overlapRect = topTooltipRect.intersect(bottomTooltipRect);
        showOverlappingTooltipStroke = sliderType == SliderType.vertical
            ? overlapRect.top < overlapRect.bottom
            : overlapRect.right > overlapRect.left;
      }

      tooltipShape.paint(context, thumbCenter,
          Offset(actualTrackOffset.dx, tooltipStartY), textPainter,
          parentBox: this,
          sliderThemeData: sliderThemeData,
          paint: paint,
          animation: isStartThumbActive
              ? _tooltipStartAnimation
              : _tooltipEndAnimation,
          trackRect: trackRect);
    }
  }

  /// This method used to update interval selection value and
  /// deferred update values.
  void updateIntervalTappedAndDeferredUpdateValues(SfRangeValues values);

  /// Used to draw active and inactive regions.
  void drawRegions(PaintingContext context, Rect trackRect, Offset offset,
      Offset startThumbCenter, Offset endThumbCenter) {
    /// This override method declared to draw active and inactive region in
    /// the [SfRangeSelector].
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
    _overlayStartAnimation.addListener(markNeedsPaint);
    _overlayEndAnimation.addListener(markNeedsPaint);
    startPositionController.addListener(markNeedsPaint);
    endPositionController.addListener(markNeedsPaint);
    _stateAnimation.addListener(markNeedsPaint);
    _tooltipStartAnimation.addListener(markNeedsPaint);
    _tooltipStartAnimation
        .addStatusListener(_handleTooltipAnimationStatusChange);
    _tooltipEndAnimation.addListener(markNeedsPaint);
    _tooltipEndAnimation.addStatusListener(_handleTooltipAnimationStatusChange);
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    _overlayStartAnimation.removeListener(markNeedsPaint);
    _overlayEndAnimation.removeListener(markNeedsPaint);
    startPositionController.removeListener(markNeedsPaint);
    endPositionController.removeListener(markNeedsPaint);
    _stateAnimation.removeListener(markNeedsPaint);
    _tooltipStartAnimation.removeListener(markNeedsPaint);
    _tooltipStartAnimation
        .removeStatusListener(_handleTooltipAnimationStatusChange);
    _tooltipEndAnimation.removeListener(markNeedsPaint);
    _tooltipEndAnimation
        .removeStatusListener(_handleTooltipAnimationStatusChange);
    super.detach();
  }

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  PointerEnterEventListener? get onEnter => null;

  /// Used to handle hover interaction.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener get onHover => _handleHover;

  @override
  PointerExitEventListener get onExit => _handleExit;

  @override
  bool get validForMouseTracker => _validForMouseTracker;

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerHoverEvent) {
      onHover(event);
    }
    super.handleEvent(event, entry);
  }

  /// This method used to draw all slider elements such as track, tick,
  /// dividers, thumb, and overlay.
  void drawRangeSliderElements(
      PaintingContext context, Offset offset, Offset actualTrackOffset) {
    // Drawing track.
    final Rect trackRect =
        trackShape.getPreferredRect(this, sliderThemeData, actualTrackOffset);
    final double thumbStartPosition = getFactorFromValue(isIntervalTapped
            ? getValueFromFactor((sliderType == SliderType.horizontal &&
                    textDirection == TextDirection.rtl)
                ? (1 - startPositionController.value)
                : startPositionController.value)
            : actualValues.start) *
        (sliderType == SliderType.vertical
            ? trackRect.height
            : trackRect.width);
    final double thumbEndPosition = getFactorFromValue(isIntervalTapped
            ? getValueFromFactor((sliderType == SliderType.horizontal &&
                    textDirection == TextDirection.rtl)
                ? (1 - endPositionController.value)
                : endPositionController.value)
            : actualValues.end) *
        (sliderType == SliderType.vertical
            ? trackRect.height
            : trackRect.width);
    final Offset startThumbCenter = sliderType == SliderType.vertical
        ? Offset(trackRect.center.dx, trackRect.bottom - thumbStartPosition)
        : Offset(trackRect.left + thumbStartPosition, trackRect.center.dy);
    final Offset endThumbCenter = sliderType == SliderType.vertical
        ? Offset(trackRect.center.dx, trackRect.bottom - thumbEndPosition)
        : Offset(trackRect.left + thumbEndPosition, trackRect.center.dy);

    trackShape.paint(
        context, actualTrackOffset, null, startThumbCenter, endThumbCenter,
        parentBox: this,
        themeData: sliderThemeData,
        currentValues: values,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        activePaint: null,
        inactivePaint: null);

    if (showLabels || showTicks || showDividers) {
      drawLabelsTicksAndDividers(context, trackRect, offset, null,
          startThumbCenter, endThumbCenter, _stateAnimation, null, _values);
    }

    drawRegions(context, trackRect, offset, startThumbCenter, endThumbCenter);
    _drawOverlayAndThumb(context, endThumbCenter, startThumbCenter);
    _drawTooltip(context, endThumbCenter, startThumbCenter, offset,
        actualTrackOffset, trackRect);
  }

  /// Describe the semantics of the start thumb.
  SemanticsNode? startSemanticsNode = SemanticsNode();

  /// Describe the semantics of the end thumb.
  SemanticsNode? endSemanticsNode = SemanticsNode();

  /// Used to set values to the shape properties in diagnostics tree.
  void debugRangeSliderFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(StringProperty(
        'thumbSize', thumbShape.getPreferredSize(sliderThemeData).toString()));
    properties.add(StringProperty(
        'activeDividerSize',
        dividerShape
            .getPreferredSize(sliderThemeData, isActive: true)
            .toString()));
    properties.add(StringProperty(
        'inactiveDividerSize',
        dividerShape
            .getPreferredSize(sliderThemeData, isActive: false)
            .toString()));
    properties.add(StringProperty('overlaySize',
        overlayShape.getPreferredSize(sliderThemeData).toString()));
    properties.add(StringProperty(
        'tickSize', tickShape.getPreferredSize(sliderThemeData).toString()));
    properties.add(StringProperty('minorTickSize',
        minorTickShape.getPreferredSize(sliderThemeData).toString()));
  }
}
