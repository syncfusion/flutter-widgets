import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'slider_shapes.dart';

// ignore_for_file: public_member_api_docs
/// Base render box class for all three sliders such as [SfSlider],
/// [SfRangeSlider], and [SfRangeSelector].
class RenderBaseSlider extends RenderProxyBox
    with RelayoutWhenSystemFontsChangeMixin {
  /// Creates a [RenderBaseSlider].
  RenderBaseSlider({
    required dynamic min,
    required dynamic max,
    required double? interval,
    required double? stepSize,
    required SliderStepDuration? stepDuration,
    required int minorTicksPerInterval,
    required bool showTicks,
    required bool showLabels,
    required bool showDividers,
    required bool enableTooltip,
    required bool shouldAlwaysShowTooltip,
    required LabelPlacement labelPlacement,
    required EdgeLabelPlacement edgeLabelPlacement,
    required bool isInversed,
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
    required SfSliderThemeData sliderThemeData,
    this.sliderType,
    SliderTooltipPosition? tooltipPosition,
    required TextDirection textDirection,
    required MediaQueryData mediaQueryData,
  })  : _min = min,
        _max = max,
        _interval = interval,
        _stepSize = stepSize,
        _stepDuration = stepDuration,
        _minorTicksPerInterval = minorTicksPerInterval,
        _showTicks = showTicks,
        _showLabels = showLabels,
        _showDividers = showDividers,
        _enableTooltip = enableTooltip,
        _shouldAlwaysShowTooltip = shouldAlwaysShowTooltip,
        _isInversed = isInversed,
        _labelPlacement = labelPlacement,
        _edgeLabelPlacement = edgeLabelPlacement,
        _numberFormat = numberFormat,
        _dateFormat = dateFormat,
        _dateIntervalType = dateIntervalType,
        _labelFormatterCallback = labelFormatterCallback,
        _tooltipTextFormatterCallback = tooltipTextFormatterCallback,
        _trackShape = trackShape,
        _dividerShape = dividerShape,
        _overlayShape = overlayShape,
        _thumbShape = thumbShape,
        _tickShape = tickShape,
        _minorTickShape = minorTickShape,
        _tooltipShape = tooltipShape,
        _sliderThemeData = sliderThemeData,
        _textDirection = textDirection,
        _mediaQueryData = mediaQueryData,
        _tooltipPosition = tooltipPosition {
    maxTrackHeight = getMaxTrackHeight();
    trackOffset = _getTrackOffset();

    if (isDateTime) {
      // ignore: avoid_as
      _minInMilliseconds = (min as DateTime).millisecondsSinceEpoch.toDouble();
      // ignore: avoid_as
      _maxInMilliseconds = (max as DateTime).millisecondsSinceEpoch.toDouble();
    }

    _visibleLabels = <String>[];
    _majorTickPositions = <double>[];
    _minorTickPositions = <double>[];

    thumbElevationTween =
        Tween<double>(begin: defaultElevation, end: tappedElevation);
  }

  final double minTrackWidth = kMinInteractiveDimension * 3;

  final TextPainter textPainter = TextPainter();

  bool isInactive = false;

  late double _minInMilliseconds;

  late double _maxInMilliseconds;

  final SliderType? sliderType;

  double? divisions;

  //ignore: prefer_final_fields
  bool willDrawTooltip = false;

  //ignore: prefer_final_fields
  bool isInteractionEnd = true;

  late List<String> _visibleLabels;

  late List<double> _majorTickPositions;

  late List<double> _minorTickPositions;

  List<double>? unformattedLabels;

  HorizontalDragGestureRecognizer? horizontalDragGestureRecognizer;

  VerticalDragGestureRecognizer? verticalDragGestureRecognizer;

  late TapGestureRecognizer tapGestureRecognizer;

  late double actualHeight;

  late Offset trackOffset;

  late double maxTrackHeight;

  bool showOverlappingTooltipStroke = false;

  bool showOverlappingThumbStroke = false;

  // It stores the current touch x-position, which is used in
  // the [endInteraction] and [dragUpdate] method.
  //ignore: prefer_final_fields
  double mainAxisOffset = 0.0;

  SfThumb? activeThumb;

  late Tween<double> thumbElevationTween;

  PointerType? currentPointerType;

  dynamic get min => _min;
  dynamic _min;
  set min(dynamic value) {
    if (_min == value) {
      return;
    }
    _min = value;

    if (_min is DateTime) {
      // ignore: avoid_as
      _minInMilliseconds = (_min as DateTime).millisecondsSinceEpoch.toDouble();
    }
    generateLabelsAndMajorTicks();
    generateMinorTicks();
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
      // ignore: avoid_as
      _maxInMilliseconds = (_max as DateTime).millisecondsSinceEpoch.toDouble();
    }
    generateLabelsAndMajorTicks();
    generateMinorTicks();
    markNeedsPaint();
  }

  double? get interval => _interval;
  double? _interval;
  set interval(double? value) {
    if (_interval == value) {
      return;
    }
    _interval = value;
    generateLabelsAndMajorTicks();
    generateMinorTicks();
    markNeedsPaint();
  }

  double? get stepSize => _stepSize;
  double? _stepSize;
  set stepSize(double? value) {
    if (_stepSize == value) {
      return;
    }
    _stepSize = value;
    markNeedsPaint();
  }

  SliderStepDuration? get stepDuration => _stepDuration;
  SliderStepDuration? _stepDuration;
  set stepDuration(SliderStepDuration? value) {
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
    generateMinorTicks();
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

  bool get showDividers => _showDividers;
  bool _showDividers;
  set showDividers(bool value) {
    if (_showDividers == value) {
      return;
    }
    _showDividers = value;
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

  bool get shouldAlwaysShowTooltip => _shouldAlwaysShowTooltip;
  bool _shouldAlwaysShowTooltip;
  set shouldAlwaysShowTooltip(bool value) {
    if (_shouldAlwaysShowTooltip == value) {
      return;
    }
    _shouldAlwaysShowTooltip = value;
    markNeedsPaint();
  }

  // When the directionality of horizontal sliders is set to RTL and
  // the [isInversed] API of SfSlider.vertical, SfRangeSlider.vertical
  // is set to true, the isInversed property is true.
  bool get isInversed => _isInversed;
  bool _isInversed;
  set isInversed(bool value) {
    if (_isInversed == value) {
      return;
    }
    _isInversed = value;
    markNeedsLayout();
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

  EdgeLabelPlacement get edgeLabelPlacement => _edgeLabelPlacement;
  EdgeLabelPlacement _edgeLabelPlacement;
  set edgeLabelPlacement(EdgeLabelPlacement value) {
    if (_edgeLabelPlacement == value) {
      return;
    }
    _edgeLabelPlacement = value;
    markNeedsPaint();
  }

  NumberFormat get numberFormat => _numberFormat;
  NumberFormat _numberFormat;
  set numberFormat(NumberFormat value) {
    if (_numberFormat == value) {
      return;
    }
    _numberFormat = value;
    generateLabelsAndMajorTicks();
    markNeedsPaint();
  }

  DateIntervalType? get dateIntervalType => _dateIntervalType;
  DateIntervalType? _dateIntervalType;
  set dateIntervalType(DateIntervalType? value) {
    if (_dateIntervalType == value) {
      return;
    }
    _dateIntervalType = value;
    generateLabelsAndMajorTicks();
    generateMinorTicks();
    markNeedsPaint();
  }

  DateFormat? get dateFormat => _dateFormat;
  DateFormat? _dateFormat;
  set dateFormat(DateFormat? value) {
    if (_dateFormat == value) {
      return;
    }
    _dateFormat = value;
    generateLabelsAndMajorTicks();
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

  SfDividerShape get dividerShape => _dividerShape;
  SfDividerShape _dividerShape;
  set dividerShape(SfDividerShape value) {
    if (_dividerShape == value) {
      return;
    }
    _dividerShape = value;
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
    markNeedsLayout();
  }

  SliderTooltipPosition? get tooltipPosition => _tooltipPosition;
  SliderTooltipPosition? _tooltipPosition;
  set tooltipPosition(SliderTooltipPosition? value) {
    if (_tooltipPosition == value) {
      return;
    }
    _tooltipPosition = value;
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

  bool get isInteractive => false;

  bool get isDateTime =>
      _min.runtimeType == DateTime && _max.runtimeType == DateTime;

  // ignore: avoid_as
  double get actualMin =>
      isDateTime ? _minInMilliseconds : _min.toDouble() as double;

  // ignore: avoid_as
  double get actualMax =>
      isDateTime ? _maxInMilliseconds : _max.toDouble() as double;

  bool get isDiscrete =>
      (_stepSize != null && _stepSize! > 0) || (_stepDuration != null);

  Size get _actualDividerSize =>
      _dividerShape.getPreferredSize(_sliderThemeData);

  Size get actualTickSize => _tickShape.getPreferredSize(_sliderThemeData);

  Size get actualMinorTickSize =>
      _minorTickShape.getPreferredSize(_sliderThemeData);

  double get maximumFontSize => math.max(
      _sliderThemeData.inactiveLabelStyle!.fontSize!,
      _sliderThemeData.activeLabelStyle!.fontSize!);

  // actualLabelSize is applicable only for horizontal sliders
  Size get actualLabelSize => Size.fromHeight(maximumFontSize);

  Rect get actualTrackRect =>
      _trackShape.getPreferredRect(this, _sliderThemeData, Offset.zero);

  Size get actualThumbSize => _thumbShape.getPreferredSize(_sliderThemeData);

  Size get actualOverlaySize =>
      _overlayShape.getPreferredSize(_sliderThemeData);

  double get actualTickHeight => _showTicks
      ? _sliderThemeData.tickSize!.height +
          (_sliderThemeData.tickOffset != null
              ? _sliderThemeData.tickOffset!.dy
              : 0)
      : 0;

  // actualTickWidth is applicable only for vertical sliders
  double get actualTickWidth => _showTicks
      ? _sliderThemeData.tickSize!.width +
          (_sliderThemeData.tickOffset != null
              ? _sliderThemeData.tickOffset!.dx
              : 0)
      : 0;

  double get actualMinorTickHeight =>
      _minorTicksPerInterval > 0 ? actualMinorTickSize.height : 0;

  // actualMinorTickWidth is applicable only for vertical sliders
  double get actualMinorTickWidth =>
      _minorTicksPerInterval > 0 ? actualMinorTickSize.width : 0;

  double get actualLabelHeight => _showLabels
      ? textPainter.textScaler.scale(actualLabelSize.height) +
          (_sliderThemeData.labelOffset != null
              ? _sliderThemeData.labelOffset!.dy
              : 0)
      : 0;

  // actualLabelOffset is applicable only for vertical sliders
  double get actualLabelOffset => _showLabels
      ? _sliderThemeData.labelOffset != null
          ? (_sliderThemeData.labelOffset!.dx)
          : 0
      : 0;

  // Here 10 is a gap between tooltip nose and thumb.
  double get tooltipStartY => (sliderType == SliderType.horizontal)
      ? _tooltipShape is SfPaddleTooltipShape
          ? math.max(actualThumbSize.height, actualTrackRect.height) / 2
          : math.max(actualThumbSize.height, actualTrackRect.height) / 2 + 10
      : math.max(actualThumbSize.width, actualTrackRect.width) / 2 + 10;

  double get adjustmentUnit => (actualMax - actualMin) / 10;

  dynamic get semanticActionUnit => isDateTime
      ? _stepDuration ?? adjustmentUnit
      : _stepSize ?? adjustmentUnit;

  void updateTextPainter() {
    textPainter
      ..textDirection = _textDirection
      ..textScaler = _mediaQueryData.textScaler;
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
          _actualDividerSize.height,
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
      return _dateFormat != null
          ? _dateFormat!.format(value)
          : value.toString();
    }
    return _numberFormat.format(value);
  }

  double getFactorFromValue(dynamic value) {
    // If min and max are equal, the result will be NAN. This creates exception
    // and widget will not rendered.
    // So we have checked a condition (actualMax <= actualMin).
    final double factor = (value == null || actualMax <= actualMin)
        ? 0.0
        // ignore: avoid_as
        : (value - actualMin) / (actualMax - actualMin) as double;
    if (_isInversed) {
      return 1.0 - factor;
    } else {
      return factor;
    }
  }

  double getPositionFromValue(double value) {
    return sliderType == SliderType.horizontal
        ? getFactorFromValue(value) * actualTrackRect.width +
            actualTrackRect.left
        : actualTrackRect.bottom -
            getFactorFromValue(value) * actualTrackRect.height;
  }

  void generateLabelsAndMajorTicks() {
    _visibleLabels.clear();
    unformattedLabels?.clear();
    _majorTickPositions.clear();
    if (_interval != null && _interval! > 0) {
      _generateLabelsAndMajorTicksBasedOnInterval();
    } else if (_showTicks || _showLabels) {
      _generateEdgeLabelsAndMajorTicks();
    }
  }

  void _generateLabelsAndMajorTicksBasedOnInterval() {
    String label;
    double labelPosition;
    int? valueInMilliseconds;
    dynamic currentValue = _min;
    divisions = (isDateTime
                ? _getDateTimeDifference(_min, _max, _dateIntervalType)
                : _max - _min)
            .toDouble() /
        // ignore: avoid_as
        _interval as double;
    for (int i = 0; i <= divisions!; i++) {
      label =
          _labelFormatterCallback(currentValue, getFormattedText(currentValue));

      if (isDateTime) {
        // ignore: avoid_as
        valueInMilliseconds = (currentValue as DateTime).millisecondsSinceEpoch;
      }
      _visibleLabels.add(label);
      unformattedLabels?.add(isDateTime
          ? valueInMilliseconds!.toDouble()
          : currentValue.toDouble());
      if (sliderType == SliderType.horizontal) {
        labelPosition = getFactorFromValue(
                isDateTime ? valueInMilliseconds : currentValue) *
            (actualTrackRect.width);
      } else {
        labelPosition = getFactorFromValue(
                isDateTime ? valueInMilliseconds : currentValue) *
            (actualTrackRect.height);
      }
      if (!_majorTickPositions.contains(labelPosition)) {
        _majorTickPositions.add(labelPosition);
      }
      currentValue = isDateTime
          ? _getNextDate(currentValue, _dateIntervalType, _interval!)
          : currentValue + _interval;
    }
  }

  void _generateEdgeLabelsAndMajorTicks() {
    String label;
    divisions = 1.0;
    label = _labelFormatterCallback(_min, getFormattedText(_min));
    _visibleLabels.add(label);
    unformattedLabels?.add(
        isDateTime ? _min.millisecondsSinceEpoch.toDouble() : _min.toDouble());
    label = _labelFormatterCallback(_max, getFormattedText(_max));
    _visibleLabels.add(label);
    unformattedLabels?.add(
        isDateTime ? _max.millisecondsSinceEpoch.toDouble() : _max.toDouble());

    if (sliderType == SliderType.horizontal) {
      _majorTickPositions
          .add(getFactorFromValue(actualMin) * actualTrackRect.width);
      _majorTickPositions
          .add(getFactorFromValue(actualMax) * actualTrackRect.width);
    } else {
      _majorTickPositions
          .add(getFactorFromValue(actualMin) * actualTrackRect.height);
      _majorTickPositions
          .add(getFactorFromValue(actualMax) * actualTrackRect.height);
    }
  }

  void generateMinorTicks() {
    if (_interval != null && _interval! > 0) {
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
    DateTime nextDate = _getNextDate(_min, _dateIntervalType, _interval!);
    DateTime currentActualDate =
        _getNextDate(nextDate, _dateIntervalType, -_interval!);
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
          minorTickPosition = _updateMinorTicksPosition(
              nextMinorDate.millisecondsSinceEpoch.toDouble());
          _minorTickPositions.add(minorTickPosition);
        }
      } else {
        final double minorPositionDiff = (nextDate.millisecondsSinceEpoch -
                currentActualDate.millisecondsSinceEpoch) /
            (_minorTicksPerInterval + 1);
        for (int j = 1; j <= _minorTicksPerInterval; j++) {
          minorTickPosition = _updateMinorTicksPosition(
              currentActualDate.millisecondsSinceEpoch +
                  (j * minorPositionDiff));
          _minorTickPositions.add(minorTickPosition);
        }
      }
      currentActualDate = nextDate;
      nextDate = _getNextDate(currentActualDate, _dateIntervalType, _interval!);
    }
  }

  double _updateMinorTicksPosition(double value) {
    return getFactorFromValue(value) *
        (sliderType == SliderType.horizontal
            ? actualTrackRect.width
            : actualTrackRect.height);
  }

  void _generateNumericMinorTicks() {
    final int majorTicksCount = _majorTickPositions.length;
    for (int i = 0; i <= majorTicksCount - 1; i++) {
      final double minorPositionDiff = (i + 1 < majorTicksCount
              ? _majorTickPositions[i + 1] - _majorTickPositions[i]
              : ((sliderType == SliderType.horizontal
                      ? actualTrackRect.width
                      : actualTrackRect.height) -
                  (isInversed
                      ? _majorTickPositions[0]
                      : _majorTickPositions[majorTicksCount - 1]))) /
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
      DateTime min, DateTime max, DateIntervalType? intervalType) {
    assert(intervalType != null);
    final Duration diff = max.difference(min);
    switch (intervalType!) {
      case DateIntervalType.months:
        return ((max.year - min.year) * DateTime.monthsPerYear) +
            max.month -
            min.month;
      case DateIntervalType.days:
        return diff.inDays;
      case DateIntervalType.hours:
        return diff.inHours;
      case DateIntervalType.minutes:
        return diff.inMinutes;
      case DateIntervalType.seconds:
        return diff.inSeconds;
      case DateIntervalType.years:
        return max.year - min.year;
    }
  }

  /// Get the date time label based on the interval and intervalType.
  // ignore: missing_return
  DateTime _getNextDate(
      DateTime currentDate, DateIntervalType? intervalType, double interval) {
    assert(intervalType != null);
    switch (intervalType!) {
      case DateIntervalType.months:
        // Make the label start date will always be 1 other than first label.
        return DateTime(currentDate.year, currentDate.month + interval.ceil());
      case DateIntervalType.days:
        currentDate = currentDate.add(Duration(days: interval.ceil()));
        return DateTime(currentDate.year, currentDate.month, currentDate.day);
      case DateIntervalType.hours:
        currentDate = currentDate.add(Duration(hours: interval.ceil()));
        return DateTime(currentDate.year, currentDate.month, currentDate.day,
            currentDate.hour);
      case DateIntervalType.minutes:
        return currentDate.add(Duration(minutes: interval.ceil()));
      case DateIntervalType.seconds:
        return currentDate.add(Duration(seconds: interval.ceil()));
      case DateIntervalType.years:
        return DateTime(currentDate.year + interval.ceil());
    }
  }

  dynamic getValueFromPosition(double position) {
    double valueFactor;
    if (sliderType == SliderType.horizontal) {
      valueFactor = (position - actualTrackRect.left) / actualTrackRect.width;
      if (_isInversed) {
        valueFactor = 1.0 - valueFactor;
      }
    } else {
      valueFactor =
          (actualTrackRect.height - position) / actualTrackRect.height;
      if (!_isInversed) {
        valueFactor = 1.0 - valueFactor;
      }
    }
    final dynamic actualValue = getValueFromFactor(valueFactor.clamp(0.0, 1.0));
    return getActualValue(valueInDouble: actualValue);
  }

  // The [value] argument holds either [double] or [DateTime] value and the
  // [valueInDouble] argument holds either [double] value for
  // numeric range slider and date time value in milliseconds for
  // date range slider.
  dynamic getActualValue({dynamic value, double? valueInDouble}) {
    if (isDiscrete) {
      if (!isDateTime) {
        final double maxMinDiff = getNumerizedValue(_max - _min);
        double factorValue = (getFactorFromValue(valueInDouble ?? value) *
                    (maxMinDiff / _stepSize!))
                .round() /
            (maxMinDiff / _stepSize!);
        if (_isInversed) {
          factorValue = 1.0 - factorValue;
        }

        value = getValueFromFactor(factorValue.clamp(0.0, 1.0));
      } else {
        // ignore: avoid_as
        DateTime currentDate = _min as DateTime;
        DateTime nextDate;
        value = valueInDouble ?? value.millisecondsSinceEpoch.toDouble();
        // ignore: avoid_as
        final double clampedValue = value.clamp(actualMin, actualMax) as double;

        for (double i = actualMin; i < actualMax;) {
          nextDate = DateTime(
              currentDate.year + _stepDuration!.years,
              currentDate.month + _stepDuration!.months,
              currentDate.day + _stepDuration!.days,
              currentDate.hour + _stepDuration!.hours,
              currentDate.minute + _stepDuration!.minutes,
              currentDate.second + _stepDuration!.seconds);

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
        ? (value ?? DateTime.fromMillisecondsSinceEpoch(valueInDouble!.toInt()))
        : value ?? valueInDouble;
  }

  double getValueFromFactor(double factor) {
    return factor * (actualMax - actualMin) + actualMin;
  }

  double getFactorFromCurrentPosition() {
    final double factor = (sliderType == SliderType.horizontal)
        ? ((mainAxisOffset - actualTrackRect.left) / actualTrackRect.width)
            .clamp(0.0, 1.0)
        : ((actualTrackRect.bottom - mainAxisOffset) / actualTrackRect.height)
            .clamp(0.0, 1.0);
    if (_isInversed) {
      return 1.0 - factor;
    } else {
      return factor;
    }
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

  Rect getPaddleTooltipRect(
      TextPainter textPainter,
      double thumbRadius,
      Offset offset,
      Offset thumbCenter,
      Rect trackRect,
      SfSliderThemeData themeData) {
    final double paddleTooltipRadius =
        textPainter.height > minPaddleTopCircleRadius
            ? textPainter.height
            : minPaddleTopCircleRadius;
    final double topNeckRadius = paddleTooltipRadius - neckDifference;
    final double bottomNeckRadius =
        thumbRadius > minPaddleTopCircleRadius * moveNeckValue
            ? thumbRadius - neckDifference
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
    final double bottom = thumbCenter.dy + thumbRadius;
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

  void drawLabelsTicksAndDividers(
      PaintingContext context,
      Rect trackRect,
      Offset offset,
      Offset? thumbCenter,
      Offset? startThumbCenter,
      Offset? endThumbCenter,
      Animation<double> stateAnimation,
      dynamic value,
      SfRangeValues? values) {
    int dateTimePos = 0;
    bool isActive;
    final double dx =
        sliderType == SliderType.horizontal ? trackRect.left : trackRect.bottom;
    final double dy =
        sliderType == SliderType.horizontal ? trackRect.top : trackRect.left;
    final double halfTrackHeight = sliderType == SliderType.horizontal
        ? trackRect.height / 2
        : trackRect.width / 2;
    if (startThumbCenter != null) {
      if (sliderType == SliderType.horizontal) {
        isActive =
            offset.dx >= startThumbCenter.dx && offset.dx <= endThumbCenter!.dx;
      } else {
        isActive =
            offset.dy <= startThumbCenter.dy && offset.dy >= endThumbCenter!.dy;
      }
    } else {
      if (sliderType == SliderType.horizontal) {
        isActive = offset.dx <= thumbCenter!.dx;
      } else {
        isActive = offset.dy <= thumbCenter!.dy;
      }
    }

    final double dividerRadius = _dividerShape
            .getPreferredSize(_sliderThemeData, isActive: isActive)
            .width /
        2;

    final double tickRadius = sliderType == SliderType.horizontal
        ? _tickShape.getPreferredSize(_sliderThemeData).width / 2
        : _tickShape.getPreferredSize(_sliderThemeData).height / 2;

    // ignore: avoid_as
    double textValue = isDateTime ? 0.0 : _min.toDouble() as double;
    int minorTickIndex = 0;
    // ignore: avoid_as
    final double maxRange =
        (isDateTime ? divisions : _max.toDouble()) as double;

    if (divisions != null && divisions! > 0) {
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

        if (_interval != null && _interval! > 0) {
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

          // Drawing dividers.
          if (_showDividers) {
            _drawDivider(
                dx,
                tickPosition,
                dy,
                halfTrackHeight,
                dateTimePos,
                dividerRadius,
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

        // Drawing labels.
        if (_showLabels) {
          final double dx = sliderType == SliderType.horizontal
              ? trackRect.left
              : trackRect.bottom;

          double offsetX = sliderType == SliderType.horizontal
              ? dx + tickPosition
              : dx - tickPosition;

          if (_labelPlacement == LabelPlacement.betweenTicks) {
            if (sliderType == SliderType.horizontal) {
              offsetX += ((dateTimePos + 1 <= divisions!
                          ? _majorTickPositions[dateTimePos + 1]
                          : (_isInversed ? trackRect.left : trackRect.width)) -
                      tickPosition) /
                  2;
              if (_isInversed
                  ? offsetX <= trackRect.left
                  : offsetX - dx >= trackRect.width) {
                break;
              }
            } else {
              if (dateTimePos + 1 <= divisions!) {
                offsetX -=
                    ((_majorTickPositions[dateTimePos + 1]) - tickPosition) / 2;
              } else {
                break;
              }
            }
          }

          if (_edgeLabelPlacement == EdgeLabelPlacement.inside &&
              _labelPlacement == LabelPlacement.onTicks) {
            final Size labelSize = measureText(
              _visibleLabels[dateTimePos],
              isInactive
                  ? sliderThemeData.inactiveLabelStyle!
                  : sliderThemeData.activeLabelStyle!,
            );
            if (sliderType == SliderType.horizontal) {
              if (dateTimePos == 0) {
                offsetX += labelSize.width / 2;
              } else if (dateTimePos == _majorTickPositions.length - 1) {
                offsetX -= labelSize.width / 2;
              }
            } else {
              if (dateTimePos == 0) {
                offsetX -= labelSize.height / 2;
              } else if (dateTimePos == _majorTickPositions.length - 1) {
                offsetX += labelSize.height / 2;
              }
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
        final double intervalDiff = (isDateTime
            ? 1.0
            : _interval != null && _interval! > 0
                ? _interval
                // ignore: avoid_as
                : _max.toDouble() - _min.toDouble()) as double;
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
      Offset? thumbCenter,
      Offset? startThumbCenter,
      Offset? endThumbCenter,
      dynamic value,
      SfRangeValues? values,
      Animation<double> stateAnimation) {
    Offset actualTickOffset;

    if (sliderType == SliderType.horizontal) {
      if (_majorTickPositions[dateTimePos] == 0.0) {
        actualTickOffset =
            Offset(dx + tickPosition + tickRadius, dy + trackRect.height) +
                (_sliderThemeData.tickOffset ?? Offset.zero);
      }
      // Due to floating-point operations, last [_majorTickPosition] is greater
      // than [trackRect.height] or [trackRect.width]. This happens in some
      // specific layouts alone. To avoid this, we limit it to 8 decimal points.
      // (e.g. Expected [_majorTickPosition] = 100.0909890118
      // Current [_majorTickPosition] = 100.0909890121)
      else if (_majorTickPositions[dateTimePos].toStringAsFixed(8) ==
          trackRect.width.toStringAsFixed(8)) {
        actualTickOffset =
            Offset(dx + tickPosition - tickRadius, dy + trackRect.height) +
                (_sliderThemeData.tickOffset ?? Offset.zero);
      } else {
        actualTickOffset = Offset(dx + tickPosition, dy + trackRect.height) +
            (_sliderThemeData.tickOffset ?? Offset.zero);
      }
    } else {
      if (_majorTickPositions[dateTimePos] == 0.0) {
        actualTickOffset =
            Offset(dy + trackRect.width, dx - tickPosition - tickRadius) +
                (_sliderThemeData.tickOffset ?? Offset.zero);
      }
      // Due to floating-point operations, last [_majorTickPosition] is greater
      // than [trackRect.height] or [trackRect.width]. This happens in some
      // specific layouts alone. To avoid this, we limit it to 8 decimal points.
      // (e.g. Expected [_majorTickPosition] = 100.0909890118
      // Current [_majorTickPosition] = 100.0909890121)
      else if (_majorTickPositions[dateTimePos].toStringAsFixed(8) ==
          trackRect.height.toStringAsFixed(8)) {
        actualTickOffset =
            Offset(dy + trackRect.width, dx - tickPosition + tickRadius) +
                (_sliderThemeData.tickOffset ?? Offset.zero);
      } else {
        actualTickOffset = Offset(dy + trackRect.width, dx - tickPosition) +
            (_sliderThemeData.tickOffset ?? Offset.zero);
      }
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
      Offset? thumbCenter,
      Offset? startThumbCenter,
      Offset? endThumbCenter,
      dynamic value,
      SfRangeValues? values,
      Animation<double> stateAnimation) {
    if (currentMinorTickPosition <
            (sliderType == SliderType.horizontal
                ? trackRect.width
                : trackRect.height) &&
        currentMinorTickPosition > 0) {
      final Offset actualTickOffset = sliderType == SliderType.horizontal
          ? Offset(dx + currentMinorTickPosition, dy + trackRect.height) +
              (_sliderThemeData.tickOffset ?? Offset.zero)
          : Offset(dy + trackRect.width, dx - currentMinorTickPosition) +
              (_sliderThemeData.tickOffset ?? Offset.zero);
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

  void _drawDivider(
      double dx,
      double tickPosition,
      double dy,
      double halfTrackHeight,
      // ignore: no_leading_underscores_for_local_identifiers
      int _dateTimePos,
      double dividerRadius,
      Rect trackRect,
      PaintingContext context,
      Offset? thumbCenter,
      Offset? startThumbCenter,
      Offset? endThumbCenter,
      dynamic value,
      SfRangeValues? values,
      Animation<double> stateAnimation) {
    Offset dividerCenter;

    if (sliderType == SliderType.horizontal) {
      if (_majorTickPositions[_dateTimePos] == 0.0) {
        dividerCenter =
            Offset(dx + tickPosition + dividerRadius, dy + halfTrackHeight);
      }
      // Due to floating-point operations, last [_majorTickPosition] is greater
      // than [trackRect.height] or [trackRect.width]. This happens in some
      // specific layouts alone. To avoid this, we limit it to 8 decimal points.
      // (e.g. Expected [_majorTickPosition] = 100.0909890118
      // Current [_majorTickPosition] = 100.0909890121)
      else if (_majorTickPositions[_dateTimePos].toStringAsFixed(8) ==
          trackRect.width.toStringAsFixed(8)) {
        dividerCenter =
            Offset(dx + tickPosition - dividerRadius, dy + halfTrackHeight);
      } else {
        dividerCenter = Offset(dx + tickPosition, dy + halfTrackHeight);
      }
    } else {
      if (_majorTickPositions[_dateTimePos] == 0.0) {
        dividerCenter =
            Offset(dy + halfTrackHeight, dx - tickPosition - dividerRadius);
      }
      // Due to floating-point operations, last [_majorTickPosition] is greater
      // than [trackRect.height] or [trackRect.width]. This happens in some
      // specific layouts alone. To avoid this, we limit it to 8 decimal points.
      // (e.g. Expected [_majorTickPosition] = 100.0909890118
      // Current [_majorTickPosition] = 100.0909890121)
      else if (_majorTickPositions[_dateTimePos].toStringAsFixed(8) ==
          trackRect.height.toStringAsFixed(8)) {
        dividerCenter =
            Offset(dy + halfTrackHeight, dx - tickPosition + dividerRadius);
      } else {
        dividerCenter = Offset(dy + halfTrackHeight, dx - tickPosition);
      }
    }

    _dividerShape.paint(
        context, dividerCenter, thumbCenter, startThumbCenter, endThumbCenter,
        parentBox: this,
        themeData: _sliderThemeData,
        currentValue: value,
        currentValues: values,
        enableAnimation: stateAnimation,
        textDirection: _textDirection,
        paint: null);
  }

  void _drawLabel(
      // ignore: no_leading_underscores_for_local_identifiers
      int _dateTimePos,
      double dx,
      double tickPosition,
      Rect trackRect,
      double dy,
      PaintingContext context,
      Offset? thumbCenter,
      Offset? startThumbCenter,
      Offset? endThumbCenter,
      dynamic value,
      SfRangeValues? values,
      Animation<double> stateAnimation,
      double offsetX) {
    final double dy =
        sliderType == SliderType.horizontal ? trackRect.top : trackRect.left;
    final String labelText = _visibleLabels[_dateTimePos];
    final Offset actualLabelOffset = sliderType == SliderType.horizontal
        ? Offset(offsetX, dy + trackRect.height + actualTickHeight) +
            (_sliderThemeData.labelOffset ?? Offset.zero)
        : Offset(dy + trackRect.width + actualTickWidth, offsetX) +
            (_sliderThemeData.labelOffset ?? Offset.zero);

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

  void _drawText(PaintingContext context, Offset center, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter, String text,
      {required RenderProxyBox parentBox,
      required SfSliderThemeData themeData,
      dynamic currentValue,
      SfRangeValues? currentValues,
      required Animation<double> enableAnimation,
      required TextPainter textPainter,
      required TextDirection textDirection}) {
    if (sliderType == SliderType.horizontal) {
      // Added this condition to check whether consider single thumb or
      // two thumbs for finding inactive range.
      if (startThumbCenter != null) {
        if (!_isInversed) {
          isInactive =
              center.dx < startThumbCenter.dx || center.dx > endThumbCenter!.dx;
        } else {
          isInactive =
              center.dx > startThumbCenter.dx || center.dx < endThumbCenter!.dx;
        }
      } else {
        if (!_isInversed) {
          isInactive = center.dx > thumbCenter!.dx;
        } else {
          isInactive = center.dx < thumbCenter!.dx;
        }
      }
    } else {
      // Added this condition to check whether consider single thumb or
      // two thumbs for finding inactive range.
      if (startThumbCenter != null) {
        if (!_isInversed) {
          isInactive =
              center.dy > startThumbCenter.dy || center.dy < endThumbCenter!.dy;
        } else {
          isInactive =
              center.dy < startThumbCenter.dy || center.dy > endThumbCenter!.dy;
        }
      } else {
        if (!_isInversed) {
          isInactive = center.dy < thumbCenter!.dy;
        } else {
          isInactive = center.dy > thumbCenter!.dy;
        }
      }
    }

    final TextSpan textSpan = TextSpan(
      text: text,
      style: isInactive
          ? themeData.inactiveLabelStyle
          : themeData.activeLabelStyle,
    );
    textPainter.text = textSpan;
    textPainter.layout();
    if (sliderType == SliderType.horizontal) {
      textPainter.paint(
          context.canvas, Offset(center.dx - textPainter.width / 2, center.dy));
    } else {
      textPainter.paint(context.canvas,
          Offset(center.dx, center.dy - textPainter.height / 2));
    }
  }

  dynamic getNextSemanticValue(dynamic value, dynamic semanticActionUnit,
      {required double actualValue}) {
    if (isDateTime) {
      if (_stepDuration == null) {
        return DateTime.fromMillisecondsSinceEpoch(
            (actualValue + semanticActionUnit)
                .clamp(actualMin, actualMax)
                .toInt());
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
      {required double actualValue}) {
    if (isDateTime) {
      if (_stepDuration == null) {
        return DateTime.fromMillisecondsSinceEpoch(
            (actualValue - semanticActionUnit)
                .clamp(actualMin, actualMax)
                .toInt());
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

  double getNumerizedValue(dynamic value) {
    if (isDateTime) {
      // ignore: avoid_as
      return (value as DateTime).millisecondsSinceEpoch.toDouble();
    }
    // ignore: avoid_as
    return value.toDouble() as double;
  }

  // This method is only applicable for vertical sliders
  Size _textSize(String text, double fontSize) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout();
    return textPainter.size;
  }

  // This method is only applicable for vertical sliders
  double _maximumLabelWidth() {
    double maxLabelWidth = 0.0;
    if (_showLabels && _interval != null && _interval! > 0) {
      String label;
      dynamic currentValue = _min;
      double labelLength;
      divisions = (isDateTime
                  ? _getDateTimeDifference(_min, _max, _dateIntervalType)
                  : _max - _min)
              .toDouble() /
          // ignore: avoid_as
          _interval as double;
      for (int i = 0; i <= divisions!.toInt(); i++) {
        label = _labelFormatterCallback(
            currentValue, getFormattedText(currentValue));

        labelLength = _textSize(label, maximumFontSize).width;

        if (maxLabelWidth < labelLength) {
          maxLabelWidth = labelLength;
        }
        currentValue = isDateTime
            ? _getNextDate(currentValue, _dateIntervalType, _interval!)
            : currentValue + _interval;
      }
    } else if (_showLabels) {
      maxLabelWidth = _edgeLabelWidth();
    }
    return maxLabelWidth;
  }

  // This method is only applicable for vertical sliders
  double _edgeLabelWidth() {
    String minLabel;
    String maxLabel;
    double maxLabelWidth;
    minLabel = _labelFormatterCallback(_min, getFormattedText(_min));
    maxLabel = _labelFormatterCallback(_max, getFormattedText(_max));
    final double minLabelLength = _textSize(minLabel, maximumFontSize).width;
    final double maxLabelLength = _textSize(maxLabel, maximumFontSize).width;
    maxLabelWidth = math.max(minLabelLength, maxLabelLength);
    return maxLabelWidth;
  }

  @override
  void systemFontsDidChange() {
    super.systemFontsDidChange();
    textPainter.markNeedsLayout();
    updateTextPainter();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  @override
  void performLayout() {
    // Here, the required width for the rendering of the
    // vertical sliders is also considered as actualHeight.
    if (sliderType == SliderType.horizontal) {
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
          constraints.hasBoundedHeight ? constraints.maxHeight : actualHeight);
    } else {
      actualHeight = math.max(
          2 * trackOffset.dx,
          trackOffset.dx +
              maxTrackHeight / 2 +
              math.max(actualTickWidth, actualMinorTickWidth) +
              _maximumLabelWidth() +
              actualLabelOffset);
      size = Size(
          constraints.hasBoundedWidth ? constraints.maxWidth : actualHeight,
          constraints.hasBoundedHeight
              ? constraints.maxHeight
              : minTrackWidth + 2 * trackOffset.dy);
    }

    generateLabelsAndMajorTicks();
    generateMinorTicks();
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    // Checked [_isInteractionEnd] for avoiding multi touch.
    if (isInteractionEnd && event.down && event is PointerDownEvent) {
      if (sliderType == SliderType.horizontal) {
        horizontalDragGestureRecognizer!.addPointer(event);
      } else {
        verticalDragGestureRecognizer!.addPointer(event);
      }
      tapGestureRecognizer.addPointer(event);
    }
  }
}
