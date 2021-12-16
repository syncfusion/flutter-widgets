import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/axis/radial_axis_widget.dart';
import '../../radial_gauge/styles/radial_text_style.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';

/// Represents the renderer of radial gauge range.
class RenderGaugeRange extends RenderBox {
  ///Creates a object for [RenderGaugeRange].
  RenderGaugeRange(
      {required double startValue,
      required double endValue,
      double? startWidth,
      double? endWidth,
      required GaugeSizeUnit sizeUnit,
      Color? color,
      Gradient? gradient,
      required double rangeOffset,
      String? label,
      required GaugeTextStyle labelStyle,
      Animation<double>? rangeAnimation,
      required ValueNotifier<int> repaintNotifier,
      required SfGaugeThemeData gaugeThemeData})
      : _startValue = startValue,
        _endValue = endValue,
        _startWidth = startWidth,
        _endWidth = endWidth,
        _sizeUnit = sizeUnit,
        _color = color,
        _gradient = gradient,
        _rangeOffset = rangeOffset,
        _label = label,
        _labelStyle = labelStyle,
        _repaintNotifier = repaintNotifier,
        _rangeAnimation = rangeAnimation,
        _gaugeThemeData = gaugeThemeData;

  late double _rangeMidRadian;
  late double _maxAngle;
  late double _rangeStartValue;
  late double _rangeEndValue;
  late double _rangeMidValue;
  late double _outerStartOffset;
  late double _outerEndOffset;
  late double _innerStartOffset;
  late double _innerEndOffset;
  late double _totalOffset;
  late double _actualRangeOffset;
  late double _actualStartWidth;
  late double _actualEndWidth;
  late ArcData _outerArc;
  late ArcData _innerArc;
  late double _outerArcSweepAngle;
  late double _innerArcSweepAngle;
  late double _thickness;
  late Offset _center;
  late double _rangeStartRadian;
  late double _rangeEndRadian;
  late double _labelAngle;
  late Offset _labelPosition;
  late Size _labelSize;
  late Rect _pathRect;
  Rect? _rangeRect;

  late double _radius;
  late double _sweepAngle;
  late double _centerXPoint;
  late double _centerYPoint;
  late Offset _axisCenter;

  /// Gets the axisRenderer assigned to [RenderMarkerPointer].
  RenderRadialAxisWidget? get axisRenderer => _axisRenderer;
  RenderRadialAxisWidget? _axisRenderer;

  /// Gets the axisRenderer for [RenderMarkerPointer].
  set axisRenderer(RenderRadialAxisWidget? value) {
    if (value == _axisRenderer) {
      return;
    }

    _axisRenderer = value;

    if (_axisRenderer != null) {
      _updateAxisValues();
    }
  }

  /// Gets the animation assigned to [RenderGaugeRange].
  Animation<double>? get rangeAnimation => _rangeAnimation;
  Animation<double>? _rangeAnimation;

  /// Sets the animation for [RenderGaugeRange].
  set rangeAnimation(Animation<double>? value) {
    if (value == _rangeAnimation) {
      return;
    }

    _removeListeners();
    _rangeAnimation = value;
    _addListeners();
  }

  /// Gets the gaugeThemeData assigned to [RenderGaugeRange].
  SfGaugeThemeData get gaugeThemeData => _gaugeThemeData;
  SfGaugeThemeData _gaugeThemeData;

  /// Sets the gaugeThemeData for [RenderGaugeRange].
  set gaugeThemeData(SfGaugeThemeData value) {
    if (value == _gaugeThemeData) {
      return;
    }
    _gaugeThemeData = value;
    markNeedsPaint();
  }

  /// Gets the startValue assigned to [RenderGaugeRange].
  double get startValue => _startValue;
  double _startValue;

  /// Sets the startValue for [RenderGaugeRange].
  set startValue(double value) {
    if (value == _startValue) {
      return;
    }

    _startValue = value;
    markNeedsPaint();
  }

  /// Gets the endValue assigned to [RenderGaugeRange].
  double get endValue => _endValue;
  double _endValue;

  /// Sets the endValue for [RenderGaugeRange].
  set endValue(double value) {
    if (value == _endValue) {
      return;
    }

    _endValue = value;
    markNeedsPaint();
  }

  /// Gets the startWidth assigned to [RenderGaugeRange].
  double? get startWidth => _startWidth;
  double? _startWidth;

  /// Sets the startWidth for [RenderGaugeRange].
  set startWidth(double? value) {
    if (value == _startWidth) {
      return;
    }

    _startWidth = value;
    markNeedsPaint();
  }

  /// Gets the endWidth assigned to [RenderGaugeRange].
  double? get endWidth => _endWidth;
  double? _endWidth;

  /// Sets the endWidth for [RenderGaugeRange].
  set endWidth(double? value) {
    if (value == _endWidth) {
      return;
    }

    _endWidth = value;
    markNeedsPaint();
  }

  /// Gets the sizeUnit assigned to [RenderGaugeRange].
  GaugeSizeUnit get sizeUnit => _sizeUnit;
  GaugeSizeUnit _sizeUnit;

  /// Sets the sizeUnit for [RenderGaugeRange].
  set sizeUnit(GaugeSizeUnit value) {
    if (value == _sizeUnit) {
      return;
    }

    _sizeUnit = value;
    markNeedsPaint();
  }

  /// Gets the gradient assigned to [RenderGaugeRange].
  Gradient? get gradient => _gradient;
  Gradient? _gradient;

  /// Sets the gradient for [RenderGaugeRange].
  set gradient(Gradient? value) {
    if (value == _gradient) {
      return;
    }

    _gradient = value;
    markNeedsPaint();
  }

  /// Gets the color assigned to [RenderGaugeRange].
  Color? get color => _color;
  Color? _color;

  /// Sets the color for [RenderGaugeRange].
  set color(Color? value) {
    if (value == _color) {
      return;
    }

    _color = value;
    markNeedsPaint();
  }

  /// Gets the label assigned to [RenderGaugeRange].
  String? get label => _label;
  String? _label;

  /// Sets the label for [RenderGaugeRange].
  set label(String? value) {
    if (value == _label) {
      return;
    }

    _label = value;
    markNeedsPaint();
  }

  /// Gets the rangeOffset assigned to [RenderGaugeRange].
  double get rangeOffset => _rangeOffset;
  double _rangeOffset;

  /// Sets the rangeOffset for [RenderGaugeRange].
  set rangeOffset(double value) {
    if (value == _rangeOffset) {
      return;
    }

    _rangeOffset = value;
    markNeedsPaint();
  }

  /// Gets the textStyle assigned to [RenderGaugeRange].
  GaugeTextStyle get labelStyle => _labelStyle;
  GaugeTextStyle _labelStyle;

  /// Sets the textStyle for [RenderGaugeRange].
  set labelStyle(GaugeTextStyle value) {
    if (value == _labelStyle) {
      return;
    }

    _labelStyle = value;
    markNeedsPaint();
  }

  /// Gets the repaintNotifier assigned to [RenderNeedlePointer].
  ValueNotifier<int> get repaintNotifier => _repaintNotifier;
  ValueNotifier<int> _repaintNotifier;

  /// Sets the repaintNotifier for [RenderNeedlePointer].
  set repaintNotifier(ValueNotifier<int> value) {
    if (value == _repaintNotifier) {
      return;
    }

    _removeListeners();
    _repaintNotifier = value;
    _addListeners();
  }

  void _updateAxisValues() {
    _sweepAngle = axisRenderer!.getAxisSweepAngle();
    _centerXPoint = axisRenderer!.getCenterX();
    _centerYPoint = axisRenderer!.getCenterY();
    _axisCenter = axisRenderer!.getAxisCenter();
    _radius = _axisRenderer!.getRadius();
  }

  void _addListeners() {
    if (_rangeAnimation != null) {
      _rangeAnimation!.addListener(markNeedsPaint);
    }

    repaintNotifier.addListener(markNeedsPaint);
  }

  void _removeListeners() {
    if (_rangeAnimation != null) {
      _rangeAnimation!.removeListener(markNeedsPaint);
    }

    repaintNotifier.removeListener(markNeedsPaint);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _addListeners();
  }

  @override
  void detach() {
    _removeListeners();
    super.detach();
  }

  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool hitTestSelf(Offset position) {
    return false;
  }

  /// Calculates the range position
  void _calculateRangePosition() {
    _updateAxisValues();
    _calculateActualWidth();
    _actualRangeOffset =
        axisRenderer!.getActualValue(rangeOffset, sizeUnit, true);
    _center = !axisRenderer!.canScaleToFit
        ? Offset(size.width / 2, size.height / 2)
        : _axisCenter;
    _totalOffset = _actualRangeOffset < 0
        ? axisRenderer!.getAxisOffset() + _actualRangeOffset
        : (_actualRangeOffset + axisRenderer!.getAxisOffset());
    _maxAngle = _sweepAngle;
    _calculateRangeAngle();
    if (_actualStartWidth != _actualEndWidth) {
      _calculateInEqualWidthArc();
    } else {
      _calculateEqualWidthArc();
    }

    if (label != null) {
      _labelSize = getTextSize(label!, labelStyle);
      _calculateLabelPosition();
    }
  }

  /// Method to calculate rect for in equal width range
  void _calculateInEqualWidthArc() {
    _outerEndOffset = 0;
    _rangeRect = null;
    _outerStartOffset = _outerEndOffset;
    _innerStartOffset = _actualStartWidth;
    _innerEndOffset = _actualEndWidth;

    _outerArc = _getRadiusToAngleConversion(_outerStartOffset, _outerEndOffset);
    _innerArc = _getRadiusToAngleConversion(_innerStartOffset, _innerEndOffset);

    _outerArcSweepAngle =
        _getSweepAngle(_outerArc.endAngle - _outerArc.startAngle);
    _innerArcSweepAngle =
        _getSweepAngle(_innerArc.endAngle - _innerArc.startAngle);
    _innerArcSweepAngle *= -1;

    final double left = _outerArc.arcRect.left < _innerArc.arcRect.left
        ? _outerArc.arcRect.left
        : _innerArc.arcRect.left;
    final double top = _outerArc.arcRect.top < _innerArc.arcRect.top
        ? _outerArc.arcRect.top
        : _innerArc.arcRect.top;
    final double right = _outerArc.arcRect.right < _innerArc.arcRect.right
        ? _innerArc.arcRect.right
        : _outerArc.arcRect.right;
    final double bottom = _outerArc.arcRect.bottom < _innerArc.arcRect.bottom
        ? _innerArc.arcRect.bottom
        : _outerArc.arcRect.bottom;
    _pathRect = Rect.fromLTRB(left, top, right, bottom);
  }

  /// Calculates the range angle
  void _calculateRangeAngle() {
    if (!axisRenderer!.isInversed) {
      _rangeStartValue = axisRenderer!.startAngle +
          (_maxAngle /
              ((axisRenderer!.maximum - axisRenderer!.minimum) /
                  (startValue - axisRenderer!.minimum)));
      _rangeEndValue = axisRenderer!.startAngle +
          (_maxAngle /
              ((axisRenderer!.maximum - axisRenderer!.minimum) /
                  (endValue - axisRenderer!.minimum)));
      _rangeMidValue = axisRenderer!.startAngle +
          (_maxAngle /
              ((axisRenderer!.maximum - axisRenderer!.minimum) /
                  ((endValue - startValue) / 2 + startValue)));
    } else {
      _rangeStartValue = axisRenderer!.startAngle +
          _maxAngle -
          (_maxAngle /
              ((axisRenderer!.maximum - axisRenderer!.minimum) /
                  (startValue - axisRenderer!.minimum)));
      _rangeEndValue = axisRenderer!.startAngle +
          _maxAngle -
          (_maxAngle /
              ((axisRenderer!.maximum - axisRenderer!.minimum) /
                  (endValue - axisRenderer!.minimum)));
      _rangeMidValue = axisRenderer!.startAngle +
          _maxAngle -
          (_maxAngle /
              ((axisRenderer!.maximum - axisRenderer!.minimum) /
                  ((endValue - startValue) / 2 + startValue)));
    }

    _rangeStartRadian = getDegreeToRadian(_rangeStartValue);
    _rangeEndRadian = getDegreeToRadian(_rangeEndValue);
    _rangeMidRadian = getDegreeToRadian(_rangeMidValue);
  }

  /// Method to calculate the rect for range with equal start and end width
  void _calculateEqualWidthArc() {
    _thickness = _actualStartWidth;
    final double startFactor = (axisRenderer!.renderer != null &&
            axisRenderer!.renderer!.valueToFactor(startValue) != null)
        ? axisRenderer!.renderer!.valueToFactor(startValue) ??
            axisRenderer!.valueToFactor(startValue)
        : axisRenderer!.valueToFactor(startValue);
    _rangeStartRadian = getDegreeToRadian(
        (startFactor * _sweepAngle) + axisRenderer!.startAngle);
    final double endFactor = (axisRenderer!.renderer != null &&
            axisRenderer!.renderer!.valueToFactor(endValue) != null)
        ? axisRenderer!.renderer!.valueToFactor(endValue) ??
            axisRenderer!.valueToFactor(endValue)
        : axisRenderer!.valueToFactor(endValue);
    final double endRadian =
        getDegreeToRadian((endFactor * _sweepAngle) + axisRenderer!.startAngle);
    _rangeEndRadian = endRadian - _rangeStartRadian;

    // To render the range in clock wise if the start value is greater than the end value
    // for full circle axis track.
    if (axisRenderer!.startAngle == axisRenderer!.endAngle &&
        startValue > endValue) {
      final double midFactor = (axisRenderer!.renderer != null &&
              axisRenderer!.renderer!.valueToFactor(axisRenderer!.maximum) !=
                  null)
          ? axisRenderer!.renderer!.valueToFactor(axisRenderer!.maximum) ??
              axisRenderer!.valueToFactor(axisRenderer!.maximum)
          : axisRenderer!.valueToFactor(axisRenderer!.maximum);
      final double midRadian = getDegreeToRadian(
          (midFactor * _sweepAngle) + axisRenderer!.startAngle);
      final double startRadian = getDegreeToRadian(axisRenderer!.startAngle);
      _rangeEndRadian =
          (midRadian - _rangeStartRadian) + (endRadian - startRadian);
    }

    _rangeRect = Rect.fromLTRB(
        -(_radius - (_actualStartWidth / 2 + _totalOffset)),
        -(_radius - (_actualStartWidth / 2 + _totalOffset)),
        _radius - (_actualStartWidth / 2 + _totalOffset),
        _radius - (_actualStartWidth / 2 + _totalOffset));
  }

  /// Method to calculate the sweep angle
  double _getSweepAngle(double sweepAngle) {
    if (sweepAngle < 0 && !axisRenderer!.isInversed) {
      sweepAngle += 360;
    }

    if (sweepAngle > 0 && axisRenderer!.isInversed) {
      sweepAngle -= 360;
    }
    return sweepAngle;
  }

  /// Converts radius to angle
  ArcData _getRadiusToAngleConversion(double startOffset, double endOffset) {
    final double startRadius = _radius - startOffset;
    final double endRadius = _radius - endOffset;
    final double midRadius = _radius - (startOffset + endOffset) / 2;

    final double startX = startRadius * math.cos(getDegreeToRadian(0));
    final double startY = startRadius * math.sin(getDegreeToRadian(0));
    final Offset rangeStartOffset = Offset(startX, startY);

    final double endX =
        endRadius * math.cos(_rangeEndRadian - _rangeStartRadian);
    final double endY =
        endRadius * math.sin(_rangeEndRadian - _rangeStartRadian);
    final Offset rangeEndOffset = Offset(endX, endY);

    final double midX =
        midRadius * math.cos(_rangeMidRadian - _rangeStartRadian);
    final double midY =
        midRadius * math.sin(_rangeMidRadian - _rangeStartRadian);
    final Offset rangeMidOffset = Offset(midX, midY);
    return _getArcData(rangeStartOffset, rangeEndOffset, rangeMidOffset);
  }

  /// Method to create the arc data
  ArcData _getArcData(
      Offset rangeStartOffset, Offset rangeEndOffset, Offset rangeMidOffset) {
    final Offset controlPoint =
        _getPointConversion(rangeStartOffset, rangeEndOffset, rangeMidOffset);

    final double distance = math.sqrt(
        math.pow(rangeStartOffset.dx - controlPoint.dx, 2) +
            math.pow(rangeStartOffset.dy - controlPoint.dy, 2));

    double actualStartAngle = getRadianToDegree(math.atan2(
      rangeStartOffset.dy - controlPoint.dy,
      rangeStartOffset.dx - controlPoint.dx,
    ));
    double actualEndAngle = getRadianToDegree(math.atan2(
      rangeEndOffset.dy - controlPoint.dy,
      rangeEndOffset.dx - controlPoint.dx,
    ));

    if (actualStartAngle < 0) {
      actualStartAngle += 360;
    }

    if (actualEndAngle < 0) {
      actualEndAngle += 360;
    }

    if (startValue > endValue) {
      final double temp = actualEndAngle;
      actualEndAngle = actualStartAngle;
      actualStartAngle = temp;
    }

    final ArcData arcData = ArcData();
    arcData.startAngle = actualStartAngle;
    arcData.endAngle = actualEndAngle;
    arcData.arcRect = Rect.fromLTRB(
        controlPoint.dx - distance + _totalOffset,
        controlPoint.dy - distance + _totalOffset,
        controlPoint.dx + distance - _totalOffset,
        controlPoint.dy + distance - _totalOffset);
    return arcData;
  }

  /// calculates the control point for range arc
  Offset _getPointConversion(Offset offset1, Offset offset2, Offset offset3) {
    double distance1 = (offset1.dy - offset2.dy) / (offset1.dx - offset2.dx);
    distance1 = (offset1.dy - offset2.dy) == 0 || (offset1.dx - offset2.dx) == 0
        ? 0
        : distance1;
    double distance2 = (offset3.dy - offset2.dy) / (offset3.dx - offset2.dx);
    distance2 = (offset3.dy - offset2.dy) == 0 || (offset3.dx - offset2.dx) == 0
        ? 0
        : distance2;
    double x = (distance1 * distance2 * (offset3.dy - offset1.dy) +
            distance1 * (offset2.dx + offset3.dx) -
            distance2 * (offset1.dx + offset2.dx)) /
        (2 * (distance1 - distance2));
    final double diff = (1 / distance1).isInfinite ? 0 : (1 / distance1);
    double y = -diff * (x - ((offset1.dx + offset2.dx) / 2)) +
        ((offset1.dy + offset2.dy) / 2);
    x = x.isNaN ? 0 : x;
    y = y.isNaN ? 0 : y;
    return Offset(x, y);
  }

  /// Calculates the actual range width
  void _calculateActualWidth() {
    _actualStartWidth = _getRangeValue(startWidth);
    _actualEndWidth = _getRangeValue(endWidth);
  }

  /// Calculates the actual value
  double _getRangeValue(double? value) {
    double actualValue = 0;
    if (value != null) {
      switch (sizeUnit) {
        case GaugeSizeUnit.factor:
          {
            actualValue = value * _radius;
          }
          break;
        case GaugeSizeUnit.logicalPixel:
          {
            actualValue = value;
          }
      }
    } else if (label != null) {
      final Size size = getTextSize(label!, labelStyle);
      actualValue = size.height;
    }

    return actualValue;
  }

  /// Calculates the label position
  void _calculateLabelPosition() {
    final double midValueFactor = (axisRenderer!.renderer != null &&
            axisRenderer!.renderer!
                    .valueToFactor((endValue + startValue) / 2) !=
                null)
        ? axisRenderer!.renderer!.valueToFactor((endValue + startValue) / 2) ??
            axisRenderer!.valueToFactor((endValue + startValue) / 2)
        : axisRenderer!.valueToFactor((endValue + startValue) / 2);
    final double midAngle =
        (midValueFactor * _sweepAngle) + axisRenderer!.startAngle;
    final double labelRadian = getDegreeToRadian(midAngle);
    _labelAngle = midAngle - 90;
    final double height = _actualStartWidth != _actualEndWidth
        ? (_actualEndWidth - _actualStartWidth).abs() / 2
        : _actualEndWidth / 2;
    if (!axisRenderer!.canScaleToFit) {
      final double x = size.width / 2 +
          ((_radius - (_totalOffset + height)) * math.cos(labelRadian)) -
          _centerXPoint;
      final double y = size.height / 2 +
          ((_radius - (_totalOffset + height)) * math.sin(labelRadian)) -
          _centerYPoint;
      _labelPosition = Offset(x, y);
    } else {
      final double x = _axisCenter.dx +
          ((_radius - (_totalOffset + height)) * math.cos(labelRadian));
      final double y = _axisCenter.dy +
          ((_radius - (_totalOffset + height)) * math.sin(labelRadian));
      _labelPosition = Offset(x, y);
    }
  }

  /// Returns the paint for the range
  Paint _getRangePaint(bool isFill, Rect rect, double strokeWidth) {
    double opacity = 1;
    if (_rangeAnimation != null) {
      opacity = _rangeAnimation!.value;
    }

    final Paint paint = Paint()
      ..style = isFill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color ?? _gaugeThemeData.rangeColor ?? const Color(0xFFF67280);
    final double actualOpacity = paint.color.opacity;
    paint.color = paint.color.withOpacity(opacity * actualOpacity);
    if (gradient != null && gradient!.colors.isNotEmpty) {
      List<Color> colors = gradient!.colors;
      if (axisRenderer!.isInversed) {
        colors = gradient!.colors.reversed.toList();
      }

      paint.shader = SweepGradient(
              colors: colors, stops: _getGradientStops() as List<double>)
          .createShader(rect);
    }
    return paint;
  }

  /// To calculate the gradient stop based on the sweep angle
  List<double?> _getGradientStops() {
    final double sweepRadian = _actualStartWidth != _actualEndWidth
        ? _rangeEndRadian - _rangeStartRadian
        : _rangeEndRadian;
    double rangeStartAngle =
        axisRenderer!.valueToFactor(startValue) * _sweepAngle +
            axisRenderer!.startAngle;
    if (rangeStartAngle < 0) {
      rangeStartAngle += 360;
    }

    if (rangeStartAngle > 360) {
      rangeStartAngle -= 360;
    }

    final double sweepAngle = getRadianToDegree(sweepRadian).abs();
    return calculateGradientStops(
        _getGradientOffset(), axisRenderer!.isInversed, sweepAngle);
  }

  /// Returns the gradient stop of axis line gradient
  List<double?> _getGradientOffset() {
    if (gradient!.stops != null && gradient!.stops!.isNotEmpty) {
      return gradient!.stops!;
    } else {
      // Calculates the gradient stop values based on the number of provided
      // color
      final double difference = 1 / gradient!.colors.length;
      final List<double?> offsets =
          List<double?>.filled(gradient!.colors.length, null);
      for (int i = 0; i < gradient!.colors.length; i++) {
        offsets[i] = i * difference;
      }

      return offsets;
    }
  }

  /// Renders the range text
  void _renderRangeText(Canvas canvas) {
    double opacity = 1;
    if (_rangeAnimation != null) {
      opacity = _rangeAnimation!.value;
    }

    final Color rangeColor =
        color ?? _gaugeThemeData.rangeColor ?? const Color(0xFFF67280);
    final Color labelColor = labelStyle.color ?? getSaturationColor(rangeColor);
    final double actualOpacity = labelColor.opacity;
    final TextSpan span = TextSpan(
        text: label,
        style: TextStyle(
            color: labelColor.withOpacity(actualOpacity * opacity),
            fontSize: labelStyle.fontSize,
            fontFamily: labelStyle.fontFamily,
            fontStyle: labelStyle.fontStyle,
            fontWeight: labelStyle.fontWeight));
    final TextPainter textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout();
    canvas.save();
    canvas.translate(_labelPosition.dx, _labelPosition.dy);
    canvas.rotate(getDegreeToRadian(_labelAngle));
    canvas.scale(-1);
    textPainter.paint(
        canvas, Offset(-_labelSize.width / 2, -_labelSize.height / 2));
    canvas.restore();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Paint paint;
    final Canvas canvas = context.canvas;
    final Path path = Path();
    _calculateRangePosition();
    if (startValue != endValue) {
      canvas.save();
      if (!axisRenderer!.canScaleToFit) {
        canvas.translate(
            _center.dx - _centerXPoint, _center.dy - _centerYPoint);
      } else {
        canvas.translate(_axisCenter.dx, _axisCenter.dy);
      }

      canvas.rotate(_rangeStartRadian);

      if (_rangeRect == null) {
        path.arcTo(_outerArc.arcRect, getDegreeToRadian(_outerArc.startAngle),
            getDegreeToRadian(_outerArcSweepAngle), false);
        path.arcTo(_innerArc.arcRect, getDegreeToRadian(_innerArc.endAngle),
            getDegreeToRadian(_innerArcSweepAngle), false);

        paint = _getRangePaint(true, _pathRect, 0);
        canvas.drawPath(path, paint);
      } else {
        paint = _getRangePaint(false, _rangeRect!, _thickness);
        canvas.drawArc(_rangeRect!, 0, _rangeEndRadian, false, paint);
      }
      canvas.restore();
    }

    if (label != null) {
      _renderRangeText(canvas);
    }
  }
}
