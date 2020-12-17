import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart'
    show TapGestureRecognizer, HorizontalDragGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'slider_shapes.dart';

class RenderBaseSlider extends RenderProxyBox
    with RelayoutWhenSystemFontsChangeMixin {
  RenderBaseSlider({
    dynamic min,
    dynamic max,
    double interval,
    double stepSize,
    SliderStepDuration stepDuration,
    int minorTicksPerInterval,
    bool showTicks,
    bool showLabels,
    bool showDivisors,
    bool enableTooltip,
    LabelPlacement labelPlacement,
    NumberFormat numberFormat,
    DateFormat dateFormat,
    DateIntervalType dateIntervalType,
    LabelFormatterCallback labelFormatterCallback,
    TooltipTextFormatterCallback tooltipTextFormatterCallback,
    SfTrackShape trackShape,
    SfDivisorShape divisorShape,
    SfOverlayShape overlayShape,
    SfThumbShape thumbShape,
    SfTickShape tickShape,
    SfTickShape minorTickShape,
    SfTooltipShape tooltipShape,
    SfSliderThemeData sliderThemeData,
    TextDirection textDirection,
    MediaQueryData mediaQueryData,
  })  : _min = min,
        _max = max,
        _interval = interval,
        _stepSize = stepSize,
        _stepDuration = stepDuration,
        _minorTicksPerInterval = minorTicksPerInterval,
        _showTicks = showTicks,
        _showLabels = showLabels,
        _showDivisors = showDivisors,
        _enableTooltip = enableTooltip,
        _labelPlacement = labelPlacement,
        _numberFormat = numberFormat,
        _dateFormat = dateFormat,
        _dateIntervalType = dateIntervalType,
        _labelFormatterCallback = labelFormatterCallback,
        _tooltipTextFormatterCallback = tooltipTextFormatterCallback,
        _trackShape = trackShape,
        _divisorShape = divisorShape,
        _overlayShape = overlayShape,
        _thumbShape = thumbShape,
        _tickShape = tickShape,
        _minorTickShape = minorTickShape,
        _tooltipShape = tooltipShape,
        _sliderThemeData = sliderThemeData,
        _textDirection = textDirection,
        _mediaQueryData = mediaQueryData {
    maxTrackHeight = getMaxTrackHeight();
    trackOffset = _getTrackOffset();

    if (isDateTime) {
      _minInMilliseconds = min.millisecondsSinceEpoch.toDouble();
      _maxInMilliseconds = max.millisecondsSinceEpoch.toDouble();
    }

    _visibleLabels = <String>[];
    _majorTickPositions = <double>[];
    _minorTickPositions = <double>[];

    thumbElevationTween =
        Tween<double>(begin: defaultElevation, end: tappedElevation);
  }

  final double minTrackWidth = kMinInteractiveDimension * 3;

  final TextPainter textPainter = TextPainter();

  double _minInMilliseconds;

  double _maxInMilliseconds;

  double divisions;

  //ignore: prefer_final_fields
  bool willDrawTooltip = false;

  //ignore: prefer_final_fields
  bool isInteractionEnd = true;

  List<String> _visibleLabels;

  List<double> _majorTickPositions;

  List<double> _minorTickPositions;

  List<double> unformattedLabels;

  HorizontalDragGestureRecognizer dragGestureRecognizer;

  TapGestureRecognizer tapGestureRecognizer;

  double actualHeight;

  Offset trackOffset;

  double maxTrackHeight;

  bool showOverlappingTooltipStroke = false;

  bool showOverlappingThumbStroke = false;

  // It stores the current touch x-position, which is used in
  // the [endInteraction] and [dragUpdate] method.
  //ignore: prefer_final_fields
  double currentX = 0.0;

  SfThumb activeThumb;

  Tween<double> thumbElevationTween;

  PointerType currentPointerType;

  dynamic get min => _min;
  dynamic _min;
  set min(dynamic value) {
    if (_min == value) {
      return;
    }
    _min = value;

    if (_min is DateTime) {
      _minInMilliseconds = _min.millisecondsSinceEpoch.toDouble();
    }
    markNeedsPaint();
  }

  dynamic get max => _max;
  dynamic _max;
  set max(dynamic value) {
    if (_max == value) {
      return;
    }
    _max = value;

    if (_max is DateTime) {
      _maxInMilliseconds = _max.millisecondsSinceEpoch.toDouble();
    }
    markNeedsPaint();
  }

  double get interval => _interval;
  double _interval;

  set interval(double value) {
    if (_interval == value) {
      return;
    }
    _interval = value;
    markNeedsPaint();
  }

  double get stepSize => _stepSize;
  double _stepSize;

  set stepSize(double value) {
    if (_stepSize == value) {
      return;
    }
    _stepSize = value;
    markNeedsPaint();
  }

  SliderStepDuration get stepDuration => _stepDuration;
  SliderStepDuration _stepDuration;
  set stepDuration(SliderStepDuration value) {
    if (_stepDuration == value) {
      return;
    }
    _stepDuration = value;
  }

  int get minorTicksPerInterval => _minorTicksPerInterval;
  int _minorTicksPerInterval;

  set minorTicksPerInterval(int value) {
    if (_minorTicksPerInterval == value) {
      return;
    }
    _minorTicksPerInterval = value;
    markNeedsPaint();
  }

  bool get showTicks => _showTicks;
  bool _showTicks;

  set showTicks(bool value) {
    if (_showTicks == value) {
      return;
    }
    _showTicks = value;
    markNeedsLayout();
  }

  bool get showLabels => _showLabels;
  bool _showLabels;

  set showLabels(bool value) {
    if (_showLabels == value) {
      return;
    }
    _showLabels = value;
    markNeedsLayout();
  }

  bool get showDivisors => _showDivisors;
  bool _showDivisors;

  set showDivisors(bool value) {
    if (_showDivisors == value) {
      return;
    }
    _showDivisors = value;
    markNeedsLayout();
  }

  bool get enableTooltip => _enableTooltip;
  bool _enableTooltip;
  set enableTooltip(bool value) {
    if (_enableTooltip == value) {
      return;
    }
    _enableTooltip = value;
  }

  LabelPlacement get labelPlacement => _labelPlacement;
  LabelPlacement _labelPlacement;

  set labelPlacement(LabelPlacement value) {
    if (_labelPlacement == value) {
      return;
    }
    _labelPlacement = value;
    markNeedsPaint();
  }

  NumberFormat get numberFormat => _numberFormat;
  NumberFormat _numberFormat;

  set numberFormat(NumberFormat value) {
    if (_numberFormat == value) {
      return;
    }
    _numberFormat = value;
    markNeedsPaint();
  }

  DateIntervalType get dateIntervalType => _dateIntervalType;
  DateIntervalType _dateIntervalType;

  set dateIntervalType(DateIntervalType value) {
    if (_dateIntervalType == value) {
      return;
    }
    _dateIntervalType = value;
    markNeedsPaint();
  }

  DateFormat get dateFormat => _dateFormat;
  DateFormat _dateFormat;

  set dateFormat(DateFormat value) {
    if (_dateFormat == value) {
      return;
    }
    _dateFormat = value;
    markNeedsPaint();
  }

  LabelFormatterCallback get labelFormatterCallback => _labelFormatterCallback;
  LabelFormatterCallback _labelFormatterCallback;

  set labelFormatterCallback(LabelFormatterCallback value) {
    if (_labelFormatterCallback == value) {
      return;
    }
    _labelFormatterCallback = value;
    markNeedsSemanticsUpdate();
  }

  TooltipTextFormatterCallback get tooltipTextFormatterCallback =>
      _tooltipTextFormatterCallback;
  TooltipTextFormatterCallback _tooltipTextFormatterCallback;

  set tooltipTextFormatterCallback(TooltipTextFormatterCallback value) {
    if (_tooltipTextFormatterCallback == value) {
      return;
    }
    _tooltipTextFormatterCallback = value;
    markNeedsSemanticsUpdate();
  }

  SfThumbShape get thumbShape => _thumbShape;
  SfThumbShape _thumbShape;

  set thumbShape(SfThumbShape value) {
    if (_thumbShape == value) {
      return;
    }
    _thumbShape = value;
    markNeedsLayout();
  }

  SfOverlayShape get overlayShape => _overlayShape;
  SfOverlayShape _overlayShape;

  set overlayShape(SfOverlayShape value) {
    if (_overlayShape == value) {
      return;
    }
    _overlayShape = value;
  }

  SfTrackShape get trackShape => _trackShape;
  SfTrackShape _trackShape;

  set trackShape(SfTrackShape value) {
    if (_trackShape == value) {
      return;
    }
    _trackShape = value;
    markNeedsLayout();
  }

  SfDivisorShape get divisorShape => _divisorShape;
  SfDivisorShape _divisorShape;

  set divisorShape(SfDivisorShape value) {
    if (_divisorShape == value) {
      return;
    }
    _divisorShape = value;
    markNeedsLayout();
  }

  SfTickShape get tickShape => _tickShape;
  SfTickShape _tickShape;

  set tickShape(SfTickShape value) {
    if (_tickShape == value) {
      return;
    }
    _tickShape = value;
    markNeedsLayout();
  }

  SfTickShape get minorTickShape => _minorTickShape;
  SfTickShape _minorTickShape;

  set minorTickShape(SfTickShape value) {
    if (_minorTickShape == value) {
      return;
    }
    _minorTickShape = value;
    markNeedsLayout();
  }

  SfTooltipShape get tooltipShape => _tooltipShape;
  SfTooltipShape _tooltipShape;
  set tooltipShape(SfTooltipShape value) {
    if (_tooltipShape == value) {
      return;
    }
    _tooltipShape = value;
  }

  SfSliderThemeData get sliderThemeData => _sliderThemeData;
  SfSliderThemeData _sliderThemeData;

  set sliderThemeData(SfSliderThemeData value) {
    if (_sliderThemeData == value) {
      return;
    }
    _sliderThemeData = value;
    markNeedsPaint();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    updateTextPainter();
    markNeedsPaint();
  }

  MediaQueryData get mediaQueryData => _mediaQueryData;
  MediaQueryData _mediaQueryData;

  set mediaQueryData(MediaQueryData value) {
    if (_mediaQueryData == value) {
      return;
    }
    _mediaQueryData = value;
    updateTextPainter();
    markNeedsLayout();
  }

  bool get isDateTime =>
      _min.runtimeType == DateTime && _max.runtimeType == DateTime;

  double get actualMin => isDateTime ? _minInMilliseconds : _min;

  double get actualMax => isDateTime ? _maxInMilliseconds : _max;

  bool get isDiscrete =>
      (_stepSize != null && _stepSize > 0) || (_stepDuration != null);

  Size get actualDivisorSize =>
      _divisorShape.getPreferredSize(_sliderThemeData);

  Size get actualTickSize => _tickShape.getPreferredSize(_sliderThemeData);

  Size get actualMinorTickSize =>
      _minorTickShape.getPreferredSize(_sliderThemeData);

  Size get actualLabelSize => Size.fromHeight(math.max(
      _sliderThemeData.inactiveLabelStyle.fontSize,
      _sliderThemeData.activeLabelStyle.fontSize));

  Rect get actualTrackRect =>
      _trackShape.getPreferredRect(this, _sliderThemeData, Offset.zero);

  Size get actualThumbSize => _thumbShape.getPreferredSize(_sliderThemeData);

  Size get actualOverlaySize =>
      _overlayShape.getPreferredSize(_sliderThemeData);

  double get actualTickHeight => _showTicks
      ? _sliderThemeData.tickSize.height +
          (_sliderThemeData.tickOffset != null
              ? _sliderThemeData.tickOffset.dy
              : 0)
      : 0;

  double get actualMinorTickHeight =>
      _minorTicksPerInterval != null ? actualMinorTickSize.height : 0;

  double get actualLabelHeight => _showLabels
      ? actualLabelSize.height * textPainter.textScaleFactor +
          (_sliderThemeData.labelOffset != null
              ? _sliderThemeData.labelOffset.dy
              : 0)
      : 0;

  // Here 10 is a gap between tooltip nose and thumb.
  double get tooltipStartY => _tooltipShape is SfPaddleTooltipShape
      ? math.max(actualThumbSize.height, actualTrackRect.height) / 2
      : math.max(actualThumbSize.height, actualTrackRect.height) / 2 + 10;

  double get adjustmentUnit => (actualMax - actualMin) / 10;

  dynamic get semanticActionUnit => isDateTime
      ? _stepDuration ?? adjustmentUnit
      : _stepSize ?? adjustmentUnit;

  void updateTextPainter() {
    textPainter
      ..textDirection = _textDirection
      ..textScaleFactor = _mediaQueryData.textScaleFactor;
  }

  Offset _getTrackOffset() {
    final double dx = <double>[
          actualOverlaySize.width,
          actualThumbSize.width,
          actualTickSize.width,
          actualMinorTickSize.width
        ].reduce(math.max) /
        2;

    final double dy = <double>[
          actualOverlaySize.height,
          actualThumbSize.height,
          actualDivisorSize.height,
          maxTrackHeight
        ].reduce(math.max) /
        2;

    return Offset(dx, dy);
  }

  double getMaxTrackHeight() {
    return math.max(_sliderThemeData.activeTrackHeight,
        _sliderThemeData.inactiveTrackHeight);
  }

  String getFormattedText(dynamic value) {
    if (isDateTime) {
      return _dateFormat != null ? _dateFormat.format(value) : value.toString();
    }
    return _numberFormat.format(value);
  }

  double getFactorFromValue(dynamic value) {
    // If min and max are equal, the result will be NAN. This creates exception
    // and widget will not rendered.
    // So we have checked a condition (actualMax <= actualMin).
    final double factor = (value == null || actualMax <= actualMin)
        ? 0.0
        : ((value - actualMin) / (actualMax - actualMin));
    return (_textDirection == TextDirection.rtl) ? 1.0 - factor : factor;
  }

  double getPositionFromValue(double value) {
    return getFactorFromValue(value) * actualTrackRect.width +
        actualTrackRect.left;
  }

  void generateLabelsAndMajorTicks() {
    _visibleLabels.clear();
    unformattedLabels?.clear();
    _majorTickPositions.clear();
    if (_interval != null && _interval > 0) {
      _generateLabelsAndMajorTicksBasedOnInterval();
    } else if (_showTicks || _showLabels) {
      _generateEdgeLabelsAndMajorTicks();
    }
  }

  void _generateLabelsAndMajorTicksBasedOnInterval() {
    String label;
    double labelPosition;
    int valueInMilliseconds;
    dynamic currentValue = _min;
    divisions = (isDateTime
                ? _getDateTimeDifference(_min, _max, _dateIntervalType)
                : _max - _min)
            .toDouble() /
        _interval;
    for (int i = 0; i <= divisions; i++) {
      label =
          _labelFormatterCallback(currentValue, getFormattedText(currentValue));

      if (isDateTime) {
        valueInMilliseconds = currentValue.millisecondsSinceEpoch;
      }
      _visibleLabels.add(label);
      unformattedLabels
          ?.add(isDateTime ? valueInMilliseconds.toDouble() : currentValue);

      labelPosition =
          getFactorFromValue(isDateTime ? valueInMilliseconds : currentValue) *
              (actualTrackRect.width);
      if (!_majorTickPositions.contains(labelPosition)) {
        _majorTickPositions.add(labelPosition);
      }

      currentValue = isDateTime
          ? _getNextDate(currentValue, _dateIntervalType, _interval)
          : currentValue + _interval;
    }
  }

  void _generateEdgeLabelsAndMajorTicks() {
    String label;
    double labelPosition;
    divisions = 1.0;
    label = _labelFormatterCallback(_min, getFormattedText(_min));
    _visibleLabels.add(label);
    unformattedLabels
        ?.add(isDateTime ? _min.millisecondsSinceEpoch.toDouble() : _min);
    label = _labelFormatterCallback(_max, getFormattedText(_max));
    _visibleLabels.add(label);
    unformattedLabels
        ?.add(isDateTime ? _max.millisecondsSinceEpoch.toDouble() : _max);

    labelPosition = getFactorFromValue(actualMin) * (actualTrackRect.width);
    _majorTickPositions.add(labelPosition);
    labelPosition = getFactorFromValue(actualMax) * (actualTrackRect.width);
    _majorTickPositions.add(labelPosition);
  }

  void generateMinorTicks() {
    if (_interval != null && _interval > 0) {
      _minorTickPositions.clear();
      if (_minorTicksPerInterval > 0) {
        if (isDateTime) {
          _generateDateTimeMinorTicks();
        } else {
          _generateNumericMinorTicks();
        }
      }
    }
  }

  void _generateDateTimeMinorTicks() {
    final int majorTicksCount = _majorTickPositions.length;
    double minorTickPosition;
    DateTime nextDate = _getNextDate(_min, _dateIntervalType, _interval);
    DateTime currentActualDate =
        _getNextDate(nextDate, _dateIntervalType, -_interval);
    for (int i = 1; i <= majorTicksCount; i++) {
      // Need to divide the region based on _minorTicksPerInterval.
      // So, added 1 with _minorTicksPerInterval.
      final double intervalDiff = _getDateTimeDifference(
              currentActualDate, nextDate, _dateIntervalType) /
          (_minorTicksPerInterval + 1);
      // On dividing region equally between two dates, then it will be
      // equal to 1.0.
      if (intervalDiff == 1.0) {
        // To get nextDate of minorTick, need to pass intervals.
        // So, iteration value is used as interval and is started with 1.
        for (double j = 1; j <= _minorTicksPerInterval; j++) {
          final DateTime nextMinorDate =
              _getNextDate(currentActualDate, _dateIntervalType, j);
          minorTickPosition = getPositionFromValue(
                  nextMinorDate.millisecondsSinceEpoch.toDouble()) -
              actualTrackRect.left;
          _minorTickPositions.add(minorTickPosition);
        }
      } else {
        final double minorPositionDiff = (nextDate.millisecondsSinceEpoch -
                currentActualDate.millisecondsSinceEpoch) /
            (_minorTicksPerInterval + 1);
        for (int j = 1; j <= _minorTicksPerInterval; j++) {
          minorTickPosition = getPositionFromValue(
                  currentActualDate.millisecondsSinceEpoch +
                      (j * minorPositionDiff)) -
              actualTrackRect.left;
          _minorTickPositions.add(minorTickPosition);
        }
      }
      currentActualDate = nextDate;
      nextDate = _getNextDate(currentActualDate, _dateIntervalType, _interval);
    }
  }

  void _generateNumericMinorTicks() {
    final int majorTicksCount = _majorTickPositions.length;
    for (int i = 0; i <= majorTicksCount - 1; i++) {
      final double minorPositionDiff = ((i + 1 < majorTicksCount
                  ? _majorTickPositions[i + 1]
                  : actualTrackRect.width) -
              _majorTickPositions[i]) /
          (_minorTicksPerInterval + 1);
      for (int j = 1; j <= _minorTicksPerInterval; j++) {
        _minorTickPositions.add(_majorTickPositions[i] + j * minorPositionDiff);
      }
    }
  }

  /// Get the minimum and maximum value based on the
  /// intervalType to find the exact range.
  // ignore: missing_return
  int _getDateTimeDifference(
      DateTime min, DateTime max, DateIntervalType intervalType) {
    assert(intervalType != null);
    final Duration diff = max.difference(min);
    switch (intervalType) {
      case DateIntervalType.months:
        return ((max.year - min.year) * DateTime.monthsPerYear) +
            max.month -
            min.month;
        break;
      case DateIntervalType.days:
        return diff.inDays;
        break;
      case DateIntervalType.hours:
        return diff.inHours;
        break;
      case DateIntervalType.minutes:
        return diff.inMinutes;
        break;
      case DateIntervalType.seconds:
        return diff.inSeconds;
        break;
      case DateIntervalType.years:
        return max.year - min.year;
        break;
    }
  }

  /// Get the date time label based on the interval and intervalType.
  // ignore: missing_return
  DateTime _getNextDate(
      DateTime currentDate, DateIntervalType intervalType, double interval) {
    assert(intervalType != null);
    switch (intervalType) {
      case DateIntervalType.months:
        // Make the label start date will always be 1 other than first label.
        return DateTime(
            currentDate.year, currentDate.month + interval.ceil(), 1);
        break;
      case DateIntervalType.days:
        currentDate = currentDate.add(Duration(days: interval.ceil()));
        return DateTime(currentDate.year, currentDate.month, currentDate.day);
        break;
      case DateIntervalType.hours:
        currentDate = currentDate.add(Duration(hours: interval.ceil()));
        return DateTime(currentDate.year, currentDate.month, currentDate.day,
            currentDate.hour);
        break;
      case DateIntervalType.minutes:
        return currentDate.add(Duration(minutes: interval.ceil()));
        break;
      case DateIntervalType.seconds:
        return currentDate.add(Duration(seconds: interval.ceil()));
        break;
      case DateIntervalType.years:
        return DateTime(currentDate.year + interval.ceil(), 1, 1);
        break;
    }
  }

  dynamic getValueFromPosition(double position) {
    double valueFactor =
        ((position - actualTrackRect.left) / actualTrackRect.width)
            .clamp(0.0, 1.0);
    if (_textDirection == TextDirection.rtl) {
      valueFactor = 1.0 - valueFactor;
    }

    final dynamic actualValue = getValueFromFactor(valueFactor);
    return getActualValue(valueInDouble: actualValue);
  }

  // The [value] argument holds either [double] or [DateTime] value and the
  // [valueInDouble] argument holds either [double] value for
  // numeric range slider and date time value in milliseconds for
  // date range slider.
  dynamic getActualValue({dynamic value, double valueInDouble}) {
    if (isDiscrete) {
      if (!isDateTime) {
        final double maxMinDiff = _max - _min;
        value = getValueFromFactor(
            ((getFactorFromValue(valueInDouble ?? value) *
                            (maxMinDiff / _stepSize))
                        .round() /
                    (maxMinDiff / _stepSize))
                .clamp(0.0, 1.0));
      } else {
        DateTime currentDate = _min;
        DateTime nextDate;
        value = valueInDouble ?? value.millisecondsSinceEpoch.toDouble();
        final double clampedValue = value.clamp(actualMin, actualMax);

        for (double i = actualMin; i < actualMax;) {
          nextDate = DateTime(
              currentDate.year + _stepDuration.years,
              currentDate.month + _stepDuration.months,
              currentDate.day + _stepDuration.days,
              currentDate.hour + _stepDuration.days,
              currentDate.minute + _stepDuration.minutes,
              currentDate.second + _stepDuration.seconds);

          final double currentDateInms =
              currentDate.millisecondsSinceEpoch.toDouble();
          final double nextDateInms =
              nextDate.millisecondsSinceEpoch.toDouble();

          if (clampedValue >= currentDateInms && clampedValue <= nextDateInms) {
            final double dateDiff = (nextDateInms - currentDateInms).abs();
            final double halfDateDiff = dateDiff / 2;
            final bool shouldMoveNextInterval =
                clampedValue >= (currentDateInms + halfDateDiff);
            value = shouldMoveNextInterval ? nextDate : currentDate;
            break;
          }
          i = nextDateInms;
          currentDate = nextDate;
        }
      }
    }

    return isDateTime
        ? (value ?? DateTime.fromMillisecondsSinceEpoch(valueInDouble.toInt()))
        : value ?? valueInDouble;
  }

  double getValueFromFactor(double factor) {
    return factor * (actualMax - actualMin) + actualMin;
  }

  double getFactorFromCurrentPosition() {
    assert(currentX != null);
    final double factor =
        ((currentX - actualTrackRect.left) / actualTrackRect.width)
            .clamp(0.0, 1.0);
    return (_textDirection == TextDirection.rtl) ? 1.0 - factor : factor;
  }

  Rect getRectangularTooltipRect(TextPainter textPainter, Offset offset,
      Offset thumbCenter, Rect trackRect, SfSliderThemeData themeData) {
    final double rectangularTooltipHeight =
        textPainter.height + tooltipTextPadding.dy > minTooltipHeight
            ? textPainter.height + tooltipTextPadding.dy
            : minTooltipHeight;
    final double halfTextWidth =
        textPainter.width + tooltipTextPadding.dx > minTooltipWidth
            ? (textPainter.width + tooltipTextPadding.dx) / 2
            : minTooltipWidth / 2;

    double rightLineWidth = thumbCenter.dx + halfTextWidth > trackRect.right
        ? trackRect.right - thumbCenter.dx
        : halfTextWidth;
    final double leftLineWidth = thumbCenter.dx - halfTextWidth < trackRect.left
        ? thumbCenter.dx - trackRect.left
        : (halfTextWidth * 2) - rightLineWidth;
    rightLineWidth = leftLineWidth < halfTextWidth
        ? halfTextWidth - leftLineWidth + rightLineWidth
        : rightLineWidth;

    final double left = thumbCenter.dx - leftLineWidth;
    final double right = thumbCenter.dx + rightLineWidth;
    final double top = thumbCenter.dy -
        rectangularTooltipHeight -
        offset.dy -
        tooltipTriangleHeight;
    final double bottom = thumbCenter.dy - offset.dy;

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Rect getPaddleTooltipRect(TextPainter textPainter, Offset offset,
      Offset thumbCenter, Rect trackRect, SfSliderThemeData themeData) {
    final double paddleTooltipRadius =
        textPainter.height > minPaddleTopCircleRadius
            ? textPainter.height
            : minPaddleTopCircleRadius;
    final double topNeckRadius = paddleTooltipRadius - neckDifference;
    final double bottomNeckRadius =
        themeData.thumbRadius > minPaddleTopCircleRadius * moveNeckValue
            ? themeData.thumbRadius - neckDifference
            : 4.0;
    final double halfTextWidth = textPainter.width / 2 + textPadding;
    final double halfPaddleWidth = halfTextWidth > paddleTooltipRadius
        ? halfTextWidth
        : paddleTooltipRadius;
    final double shift = _getAdjustPaddleWidth(thumbCenter, offset,
        halfTextWidth - paddleTooltipRadius, paddleTooltipRadius, trackRect);
    final double left = thumbCenter.dx - halfPaddleWidth - shift;
    final double right = thumbCenter.dx + halfPaddleWidth - shift;
    final double top = thumbCenter.dy -
        paddleTooltipRadius -
        paddleTooltipRadius * (1.0 - moveNeckValue) -
        topNeckRadius -
        offset.dy * (1.0 - moveNeckValue) -
        bottomNeckRadius;
    final double bottom = thumbCenter.dy + themeData.thumbRadius;
    return Rect.fromLTRB(left, top, right, bottom);
  }

  double _getAdjustPaddleWidth(Offset thumbCenter, Offset offset,
      double halfTextWidth, double paddleTopCircleRadius, Rect trackRect) {
    final double leftShiftWidth =
        thumbCenter.dx - offset.dx - halfTextWidth - paddleTopCircleRadius;
    // Moving the paddle top circle width from left to right.
    // When the tooltip leaves to the render box.
    double shiftPaddleWidth = leftShiftWidth < 0 ? leftShiftWidth : 0;
    final double rightEndPosition =
        trackRect.right + trackRect.left - offset.dx;
    // Moving the paddle top circle width from right to left.
    // When the tooltip leaves to the render box.
    shiftPaddleWidth = thumbCenter.dx + halfTextWidth + paddleTopCircleRadius >
            rightEndPosition
        ? thumbCenter.dx +
            halfTextWidth +
            paddleTopCircleRadius -
            rightEndPosition
        : shiftPaddleWidth;
    return shiftPaddleWidth;
  }

  void drawLabelsTicksAndDivisors(
      PaintingContext context,
      Rect trackRect,
      Offset offset,
      Offset thumbCenter,
      Offset startThumbCenter,
      Offset endThumbCenter,
      Animation<double> stateAnimation,
      dynamic value,
      SfRangeValues values) {
    int dateTimePos = 0;
    final double dx = trackRect.left;
    final double dy = trackRect.top;
    final double halfTrackHeight = trackRect.height / 2;
    final bool isActive = startThumbCenter != null
        ? offset.dx >= startThumbCenter.dx && offset.dx <= endThumbCenter.dx
        : offset.dx <= thumbCenter.dx;
    final double divisorRadius = _divisorShape
            .getPreferredSize(_sliderThemeData, isActive: isActive)
            .width /
        2;

    final double tickRadius =
        _tickShape.getPreferredSize(_sliderThemeData).width / 2;

    double textValue = isDateTime ? 0.0 : _min;
    int minorTickIndex = 0;
    final double maxRange = isDateTime ? divisions : _max;

    if (divisions != null && divisions > 0) {
      while (textValue <= maxRange) {
        final double tickPosition = _majorTickPositions[dateTimePos];

        // Drawing ticks.
        if (_showTicks) {
          _drawTick(
              dx,
              tickPosition,
              dy,
              trackRect,
              dateTimePos,
              tickRadius,
              context,
              thumbCenter,
              startThumbCenter,
              endThumbCenter,
              value,
              values,
              stateAnimation);
        }

        if (_interval != null && _interval > 0) {
          // Drawing minor ticks.
          if (_minorTicksPerInterval > 0) {
            for (int j = 0; j < _minorTicksPerInterval; j++) {
              final double currentMinorTickPosition =
                  _minorTickPositions[minorTickIndex];
              minorTickIndex++;
              _drawMinorTick(
                  currentMinorTickPosition,
                  trackRect,
                  dx,
                  dy,
                  context,
                  thumbCenter,
                  startThumbCenter,
                  endThumbCenter,
                  value,
                  values,
                  stateAnimation);
            }
          }

          // Drawing divisors.
          if (_showDivisors) {
            _drawDivisor(
                dx,
                tickPosition,
                dy,
                halfTrackHeight,
                dateTimePos,
                divisorRadius,
                trackRect,
                context,
                thumbCenter,
                startThumbCenter,
                endThumbCenter,
                value,
                values,
                stateAnimation);
          }
        }

        // Drawing label.
        if (_showLabels) {
          final double dx = trackRect.left;
          final bool isRTL = _textDirection == TextDirection.rtl;
          double offsetX = dx + tickPosition;
          if (_labelPlacement == LabelPlacement.betweenTicks) {
            offsetX += ((dateTimePos + 1 <= divisions
                        ? _majorTickPositions[dateTimePos + 1]
                        : (isRTL ? trackRect.left : trackRect.width)) -
                    tickPosition) /
                2;
            if (isRTL
                ? offsetX <= trackRect.left
                : offsetX - dx >= trackRect.width) {
              break;
            }
          }

          _drawLabel(
              dateTimePos,
              dx,
              tickPosition,
              trackRect,
              dy,
              context,
              thumbCenter,
              startThumbCenter,
              endThumbCenter,
              value,
              values,
              stateAnimation,
              offsetX);
        }

        // When interval is not set but [showLabels], [showTicks] enabled,
        // we need to show labels/ticks on min, max values. So we used
        // interval as _max - _min.
        final double intervalDiff = isDateTime
            ? 1
            : _interval != null && _interval > 0
                ? _interval
                : _max - _min;
        textValue += intervalDiff;
        dateTimePos += 1;
      }
    }
  }

  void _drawTick(
      double dx,
      double tickPosition,
      double dy,
      Rect trackRect,
      int dateTimePos,
      double tickRadius,
      PaintingContext context,
      Offset thumbCenter,
      Offset startThumbCenter,
      Offset endThumbCenter,
      value,
      SfRangeValues values,
      Animation<double> stateAnimation) {
    Offset actualTickOffset = Offset(dx + tickPosition, dy + trackRect.height) +
        (_sliderThemeData.tickOffset ?? const Offset(0, 0));
    if (_majorTickPositions[dateTimePos] == 0.0) {
      actualTickOffset =
          Offset(dx + tickPosition + tickRadius, dy + trackRect.height) +
              (_sliderThemeData.tickOffset ?? const Offset(0, 0));
    } else if (_majorTickPositions[dateTimePos] == trackRect.width) {
      actualTickOffset =
          Offset(dx + tickPosition - tickRadius, dy + trackRect.height) +
              (_sliderThemeData.tickOffset ?? const Offset(0, 0));
    }

    _tickShape.paint(context, actualTickOffset, thumbCenter, startThumbCenter,
        endThumbCenter,
        parentBox: this,
        themeData: _sliderThemeData,
        currentValue: value,
        currentValues: values,
        enableAnimation: stateAnimation,
        textDirection: _textDirection);
  }

  void _drawMinorTick(
      double currentMinorTickPosition,
      Rect trackRect,
      double dx,
      double dy,
      PaintingContext context,
      Offset thumbCenter,
      Offset startThumbCenter,
      Offset endThumbCenter,
      value,
      SfRangeValues values,
      Animation<double> stateAnimation) {
    if (currentMinorTickPosition < trackRect.width &&
        currentMinorTickPosition > 0) {
      final Offset actualTickOffset =
          Offset(dx + currentMinorTickPosition, dy + trackRect.height) +
              (_sliderThemeData.tickOffset ?? const Offset(0, 0));
      _minorTickShape.paint(context, actualTickOffset, thumbCenter,
          startThumbCenter, endThumbCenter,
          parentBox: this,
          themeData: _sliderThemeData,
          currentValue: value,
          currentValues: values,
          enableAnimation: stateAnimation,
          textDirection: _textDirection);
    }
  }

  void _drawDivisor(
      double dx,
      double tickPosition,
      double dy,
      double halfTrackHeight,
      int _dateTimePos,
      double divisorRadius,
      Rect trackRect,
      PaintingContext context,
      Offset thumbCenter,
      Offset startThumbCenter,
      Offset endThumbCenter,
      value,
      SfRangeValues values,
      Animation<double> stateAnimation) {
    Offset divisorCenter = Offset(dx + tickPosition, dy + halfTrackHeight);
    if (_majorTickPositions[_dateTimePos] == 0.0) {
      divisorCenter =
          Offset(dx + tickPosition + divisorRadius, dy + halfTrackHeight);
    } else if (_majorTickPositions[_dateTimePos] == trackRect.width) {
      divisorCenter =
          Offset(dx + tickPosition - divisorRadius, dy + halfTrackHeight);
    }
    _divisorShape.paint(
        context, divisorCenter, thumbCenter, startThumbCenter, endThumbCenter,
        parentBox: this,
        themeData: _sliderThemeData,
        currentValue: value,
        currentValues: values,
        enableAnimation: stateAnimation,
        textDirection: _textDirection);
  }

  void _drawLabel(
      int _dateTimePos,
      double dx,
      double tickPosition,
      Rect trackRect,
      double dy,
      PaintingContext context,
      Offset thumbCenter,
      Offset startThumbCenter,
      Offset endThumbCenter,
      value,
      SfRangeValues values,
      Animation<double> stateAnimation,
      double offsetX) {
    final double dy = trackRect.top;
    final String labelText = _visibleLabels[_dateTimePos];
    final Offset actualLabelOffset =
        Offset(offsetX, dy + trackRect.height + actualTickHeight) +
            (_sliderThemeData.labelOffset ?? const Offset(0, 0));

    _drawText(context, actualLabelOffset, thumbCenter, startThumbCenter,
        endThumbCenter, labelText,
        parentBox: this,
        themeData: _sliderThemeData,
        currentValue: value,
        currentValues: values,
        enableAnimation: stateAnimation,
        textPainter: textPainter,
        textDirection: _textDirection);
  }

  void _drawText(PaintingContext context, Offset center, Offset thumbCenter,
      Offset startThumbCenter, Offset endThumbCenter, String text,
      {RenderProxyBox parentBox,
      SfSliderThemeData themeData,
      dynamic currentValue,
      SfRangeValues currentValues,
      Animation<double> enableAnimation,
      TextPainter textPainter,
      TextDirection textDirection}) {
    bool isInactive;
    switch (textDirection) {
      case TextDirection.ltr:
        // Added this condition to check whether consider single thumb or
        // two thumbs for finding inactive range.
        isInactive = startThumbCenter != null
            ? center.dx < startThumbCenter.dx || center.dx > endThumbCenter.dx
            : center.dx > thumbCenter.dx;
        break;
      case TextDirection.rtl:
        isInactive = startThumbCenter != null
            ? center.dx > startThumbCenter.dx || center.dx < endThumbCenter.dx
            : center.dx < thumbCenter.dx;
        break;
    }

    final TextSpan textSpan = TextSpan(
      text: text,
      style: isInactive
          ? themeData.inactiveLabelStyle
          : themeData.activeLabelStyle,
    );
    textPainter.text = textSpan;
    textPainter.layout();
    textPainter.paint(
        context.canvas, Offset(center.dx - textPainter.width / 2, center.dy));
  }

  dynamic getNextSemanticValue(dynamic value, dynamic semanticActionUnit,
      {double actualValue}) {
    if (isDateTime) {
      if (_stepDuration == null) {
        if (actualValue != null) {
          return DateTime.fromMillisecondsSinceEpoch(
              (actualValue + semanticActionUnit)
                  .clamp(actualMin, actualMax)
                  .toInt());
        }
      } else {
        final DateTime nextDate = DateTime(
            value.year + semanticActionUnit.years,
            value.month + semanticActionUnit.months,
            value.day + semanticActionUnit.days,
            value.hour + semanticActionUnit.days,
            value.minute + semanticActionUnit.minutes,
            value.second + semanticActionUnit.seconds);

        final double nextDateInms = nextDate.millisecondsSinceEpoch.toDouble();
        return nextDateInms < actualMax ? nextDate : _max;
      }
    } else {
      return (value + semanticActionUnit).clamp(_min, _max);
    }
  }

  dynamic getPrevSemanticValue(dynamic value, dynamic semanticActionUnit,
      {double actualValue}) {
    if (isDateTime) {
      if (_stepDuration == null) {
        if (actualValue != null) {
          return DateTime.fromMillisecondsSinceEpoch(
              (actualValue - semanticActionUnit)
                  .clamp(actualMin, actualMax)
                  .toInt());
        }
      } else {
        final DateTime prevDate = DateTime(
            value.year - semanticActionUnit.years,
            value.month - semanticActionUnit.months,
            value.day - semanticActionUnit.days,
            value.hour - semanticActionUnit.days,
            value.minute - semanticActionUnit.minutes,
            value.second - semanticActionUnit.seconds);

        final double prevDateInms = prevDate.millisecondsSinceEpoch.toDouble();
        return prevDateInms > actualMin ? prevDate : _min;
      }
    } else {
      return (value - semanticActionUnit).clamp(_min, _max);
    }
  }

  @override
  void systemFontsDidChange() {
    super.systemFontsDidChange();
    textPainter.markNeedsLayout();
    updateTextPainter();
  }

  @override
  void performLayout() {
    actualHeight = math.max(
        2 * trackOffset.dy,
        trackOffset.dy +
            maxTrackHeight / 2 +
            math.max(actualTickHeight, actualMinorTickHeight) +
            actualLabelHeight);

    size = Size(
      constraints.hasBoundedWidth
          ? constraints.maxWidth
          : minTrackWidth + 2 * trackOffset.dx,
      constraints.hasBoundedHeight ? constraints.maxHeight : actualHeight,
    );
    generateLabelsAndMajorTicks();
    generateMinorTicks();
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    // Checked [_isInteractionEnd] for avoiding multi touch.
    if (isInteractionEnd && event.down && event is PointerDownEvent) {
      dragGestureRecognizer.addPointer(event);
      tapGestureRecognizer.addPointer(event);
    }
  }
}
