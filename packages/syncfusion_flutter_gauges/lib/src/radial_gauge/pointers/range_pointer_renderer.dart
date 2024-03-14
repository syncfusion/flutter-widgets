import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/axis/radial_axis_widget.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';
import '../utils/radial_callback_args.dart';

/// Represents the renderer of radial gauge range pointer.
class RenderRangePointer extends RenderBox {
  /// Creates a object for [RenderRangePointer].
  RenderRangePointer(
      {required double value,
      required this.enableDragging,
      this.onValueChanged,
      this.onValueChangeStart,
      this.onValueChangeEnd,
      this.onValueChanging,
      required CornerStyle cornerStyle,
      Gradient? gradient,
      required double pointerOffset,
      required GaugeSizeUnit sizeUnit,
      required double width,
      List<double>? dashArray,
      Color? color,
      AnimationController? pointerAnimationController,
      this.pointerInterval,
      required this.animationType,
      required this.enableAnimation,
      required this.isRadialGaugeAnimationEnabled,
      required ValueNotifier<int> repaintNotifier,
      required ThemeData themeData,
      required SfGaugeThemeData gaugeThemeData})
      : _value = value,
        _cornerStyle = cornerStyle,
        _gradient = gradient,
        _pointerOffset = pointerOffset,
        _sizeUnit = sizeUnit,
        _width = width,
        _dashArray = dashArray,
        _color = color,
        _pointerAnimationController = pointerAnimationController,
        _repaintNotifier = repaintNotifier,
        _themeData = themeData,
        _gaugeThemeData = gaugeThemeData;

  late double _rangeArcTop;
  late double _rangeArcBottom;
  late double _rangeArcLeft;
  late double _rangeArcRight;
  late double _cornerCenter;
  late double _actualPointerOffset;
  late double _startArc;
  late double _endArc;
  late double _actualRangeThickness;
  late Rect _arcRect;
  late double _startCornerRadian;
  late double _sweepCornerRadian;
  late double _cornerAngle;
  late double _totalOffset;

  late double _radius;
  late double _sweepAngle;
  late Offset _axisCenter;
  bool _isAnimating = true;
  bool _isInitialLoading = true;

  /// Range pointer animation start value.
  double? animationStartValue;

  /// Range pointer old value.
  double? oldValue;

  /// Holds the pointer rect.
  late Rect pointerRect;

  /// Holds the arc path.
  late Path arcPath;

  /// Specifies the value whether the pointer is dragged
  bool? isDragStarted;

  /// Specifies whether the pointer is hovered
  bool? isHovered;

  /// Gets or Sets the enableDragging value.
  bool enableDragging;

  /// Gets or Sets the onValueChanged value.
  ValueChanged<double>? onValueChanged;

  /// Gets or Sets the onValueChangeStart value.
  ValueChanged<double>? onValueChangeStart;

  /// Gets or Sets the onValueChangeEnd value.
  ValueChanged<double>? onValueChangeEnd;

  /// Gets or Sets the onValueChanging value.
  ValueChanged<ValueChangingArgs>? onValueChanging;

  /// AnimationType.
  AnimationType animationType;

  /// Gets or Sets the enableAnimation value.
  bool enableAnimation;

  /// Gets or sets the pointer interval.
  List<double?>? pointerInterval;

  /// Whether the gauge animation enabled or not.
  bool isRadialGaugeAnimationEnabled;

  /// Gets the animation controller assigned to [RenderRangePointer].
  AnimationController? get pointerAnimationController =>
      _pointerAnimationController;
  AnimationController? _pointerAnimationController;

  /// Gets the animation controller for [RenderRangePointer].
  set pointerAnimationController(AnimationController? value) {
    if (value == _pointerAnimationController) {
      return;
    }

    _pointerAnimationController = value;

    if (_axisRenderer != null && _pointerAnimationController != null) {
      _updateAnimation();
    }
  }

  /// Gets the axisrenderer assigned to [RenderRangePointer].
  RenderRadialAxisWidget? get axisRenderer => _axisRenderer;
  RenderRadialAxisWidget? _axisRenderer;

  /// Sets axisRenderer for [RenderRangePointer].
  set axisRenderer(RenderRadialAxisWidget? value) {
    if (value == _axisRenderer) {
      return;
    }

    _axisRenderer = value;

    if (_axisRenderer != null) {
      _calculatePosition();
    }

    if (_axisRenderer != null && pointerAnimationController != null) {
      _isAnimating = true;
      pointerAnimation = _axisRenderer!.createPointerAnimation(this);
    }
  }

  /// Gets the gaugeThemeData assigned to [RenderRangePointer].
  SfGaugeThemeData get gaugeThemeData => _gaugeThemeData;
  SfGaugeThemeData _gaugeThemeData;

  /// Sets the gaugeThemeData for [RenderMarkerPointer].
  set gaugeThemeData(SfGaugeThemeData value) {
    if (value == _gaugeThemeData) {
      return;
    }
    _gaugeThemeData = value;
    markNeedsPaint();
  }

  /// Gets the gaugeThemeData assigned to [RenderRangePointer].
  ThemeData get themeData => _themeData;
  ThemeData _themeData;

  /// Sets the gaugeThemeData for [RenderMarkerPointer].
  set themeData(ThemeData value) {
    if (value == _themeData) {
      return;
    }
    _themeData = value;
    markNeedsPaint();
  }

  /// Gets the animation assigned to [RenderRangePointer].
  Animation<double>? get pointerAnimation => _pointerAnimation;
  Animation<double>? _pointerAnimation;

  /// Gets the animation assigned to [RenderRangePointer].
  set pointerAnimation(Animation<double>? value) {
    if (value == _pointerAnimation) {
      return;
    }

    _removeListeners();
    _pointerAnimation = value;
    _addListeners();
  }

  /// Gets the value assigned to [RenderRangePointer].
  double get value => _value;
  double _value;

  /// Sets the value for [RenderRangePointer].
  set value(double value) {
    if (value == _value) {
      return;
    }

    if (pointerAnimationController != null &&
        pointerAnimationController!.isAnimating &&
        enableAnimation) {
      oldValue = _value;
      pointerAnimationController!.stop();
      _isAnimating = false;
    }

    _value = value;

    if (pointerAnimationController != null &&
        oldValue != value &&
        enableAnimation) {
      pointerAnimation = _axisRenderer!.createPointerAnimation(this);
      pointerAnimationController!.forward(from: 0.0);
      _isAnimating = true;
    }

    if (!enableAnimation) {
      oldValue = value;
      markNeedsPaint();
    }
  }

  /// Gets the cornerStyle assigned to [RenderRangePointer].
  CornerStyle get cornerStyle => _cornerStyle;
  CornerStyle _cornerStyle;

  /// Sets the cornerStyle for [RenderRangePointer].
  set cornerStyle(CornerStyle value) {
    if (value == _cornerStyle) {
      return;
    }

    _cornerStyle = value;
    markNeedsPaint();
  }

  /// Gets the gradient assigned to [RenderRangePointer].
  Gradient? get gradient => _gradient;
  Gradient? _gradient;

  /// Sets the gradient for [RenderRangePointer].
  set gradient(Gradient? value) {
    if (value == _gradient) {
      return;
    }

    _gradient = value;
    markNeedsPaint();
  }

  /// Gets the pointerOffset assigned to [RenderRangePointer].
  double get pointerOffset => _pointerOffset;
  double _pointerOffset;

  /// Sets the pointerOffset for [RenderRangePointer].
  set pointerOffset(double value) {
    if (value == _pointerOffset) {
      return;
    }

    _pointerOffset = value;
    markNeedsPaint();
  }

  /// Gets the sizeUnit assigned to [RenderRangePointer].
  GaugeSizeUnit get sizeUnit => _sizeUnit;
  GaugeSizeUnit _sizeUnit;

  /// Sets the sizeUnit for [RenderRangePointer].
  set sizeUnit(GaugeSizeUnit value) {
    if (value == _sizeUnit) {
      return;
    }

    _sizeUnit = value;
    markNeedsPaint();
  }

  /// Gets the width assigned to [RenderRangePointer].
  double get width => _width;
  double _width;

  /// Sets the width for [RenderRangePointer].
  set width(double value) {
    if (value == _width) {
      return;
    }

    _width = value;
    markNeedsPaint();
  }

  /// Gets the dashArray assigned to [RenderRangePointer].
  List<double>? get dashArray => _dashArray;
  List<double>? _dashArray;

  /// Sets the dashArray for [RenderRangePointer].
  set dashArray(List<double>? value) {
    if (value == _dashArray) {
      return;
    }

    _dashArray = value;
    markNeedsPaint();
  }

  /// Gets the color assigned to [RenderRangePointer].
  Color? get color => _color;
  Color? _color;

  /// Sets the color for [RenderRangePointer].
  set color(Color? value) {
    if (value == _color) {
      return;
    }

    _color = value;
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

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (oldValue != value) {
        oldValue = value;
      }

      _isAnimating = false;
      _isInitialLoading = false;
    }
  }

  void _updateAnimation() {
    _isAnimating = true;
    _isInitialLoading = true;
    oldValue = axisRenderer!.minimum;
    pointerAnimation = _axisRenderer!.createPointerAnimation(this);
  }

  void _updateAxisValues() {
    _sweepAngle = axisRenderer!.getAxisSweepAngle();
    _axisCenter = axisRenderer!.getAxisCenter();
    _radius = _axisRenderer!.getRadius();
  }

  void _addListeners() {
    if (_pointerAnimation != null) {
      _pointerAnimation!.addListener(markNeedsPaint);
      _pointerAnimation!.addStatusListener(_animationStatusListener);
    }

    repaintNotifier.addListener(markNeedsPaint);
  }

  void _removeListeners() {
    if (_pointerAnimation != null) {
      _pointerAnimation!.removeListener(markNeedsPaint);
      _pointerAnimation!.removeStatusListener(_animationStatusListener);
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
    if (enableDragging) {
      final Rect pathRect = Rect.fromLTRB(
          arcPath.getBounds().left + _axisCenter.dx - 5,
          arcPath.getBounds().top + _axisCenter.dy - 5,
          arcPath.getBounds().right + _axisCenter.dx + 5,
          arcPath.getBounds().bottom + _axisCenter.dy + 5);
      return pathRect.contains(position);
    } else {
      return false;
    }
  }

  /// Method to calculate pointer position.
  void _calculatePosition() {
    _updateAxisValues();
    _actualRangeThickness =
        axisRenderer!.getActualValue(width, sizeUnit, false);
    _actualPointerOffset =
        axisRenderer!.getActualValue(pointerOffset, sizeUnit, true);
    _totalOffset = _actualPointerOffset < 0
        ? axisRenderer!.getAxisOffset() + _actualPointerOffset
        : (_actualPointerOffset + axisRenderer!.getAxisOffset());
    final double minFactor = (axisRenderer!.renderer != null &&
            axisRenderer!.renderer!.valueToFactor(axisRenderer!.minimum) !=
                null)
        ? axisRenderer!.renderer!.valueToFactor(axisRenderer!.minimum) ??
            axisRenderer!.valueToFactor(axisRenderer!.minimum)
        : axisRenderer!.valueToFactor(axisRenderer!.minimum);
    _startArc = (minFactor * _sweepAngle) + axisRenderer!.startAngle;
    final double maxFactor = (axisRenderer!.renderer != null &&
            axisRenderer!.renderer!.valueToFactor(value) != null)
        ? axisRenderer!.renderer!.valueToFactor(value) ??
            axisRenderer!.valueToFactor(value)
        : axisRenderer!.valueToFactor(value);
    final double rangeEndAngle =
        (maxFactor * _sweepAngle) + axisRenderer!.startAngle;
    _endArc = rangeEndAngle - _startArc;

    _rangeArcLeft = -(_radius - (_actualRangeThickness / 2 + _totalOffset));
    _rangeArcTop = -(_radius - (_actualRangeThickness / 2 + _totalOffset));
    _rangeArcRight = _radius - (_actualRangeThickness / 2 + _totalOffset);
    _rangeArcBottom = _radius - (_actualRangeThickness / 2 + _totalOffset);

    _createRangeRect();
  }

  /// To creates the arc rect for range pointer
  void _createRangeRect() {
    _arcRect = Rect.fromLTRB(
        _rangeArcLeft, _rangeArcTop, _rangeArcRight, _rangeArcBottom);
    pointerRect = Rect.fromLTRB(
        _rangeArcLeft, _rangeArcTop, _rangeArcRight, _rangeArcBottom);
    arcPath = Path();
    arcPath.arcTo(_arcRect, getDegreeToRadian(_startArc),
        getDegreeToRadian(_endArc), true);
    _calculateCornerStylePosition();
  }

  /// Calculates the rounded corner position
  void _calculateCornerStylePosition() {
    _cornerCenter = (_arcRect.right - _arcRect.left) / 2;
    _cornerAngle = cornerRadiusAngle(_cornerCenter, _actualRangeThickness / 2);

    switch (cornerStyle) {
      case CornerStyle.startCurve:
        {
          _startCornerRadian = axisRenderer!.isInversed
              ? getDegreeToRadian(-_cornerAngle)
              : getDegreeToRadian(_cornerAngle);
          _sweepCornerRadian = axisRenderer!.isInversed
              ? getDegreeToRadian(_endArc + _cornerAngle)
              : getDegreeToRadian(_endArc - _cornerAngle);
        }
        break;
      case CornerStyle.endCurve:
        {
          _startCornerRadian = getDegreeToRadian(0);
          _sweepCornerRadian = axisRenderer!.isInversed
              ? getDegreeToRadian(_endArc + _cornerAngle)
              : getDegreeToRadian(_endArc - _cornerAngle);
        }
        break;
      case CornerStyle.bothCurve:
        {
          _startCornerRadian = axisRenderer!.isInversed
              ? getDegreeToRadian(-_cornerAngle)
              : getDegreeToRadian(_cornerAngle);
          _sweepCornerRadian = axisRenderer!.isInversed
              ? getDegreeToRadian(_endArc + 2 * _cornerAngle)
              : getDegreeToRadian(_endArc - 2 * _cornerAngle);
        }
        break;
      case CornerStyle.bothFlat:
        {
          _startCornerRadian = getDegreeToRadian(_startArc);
          _sweepCornerRadian = getDegreeToRadian(_endArc);
        }
        break;
    }
  }

  /// Calculates the range sweep angle.
  double getSweepAngle() {
    _calculatePosition();
    return getRadianToDegree(_sweepCornerRadian) / _sweepAngle;
  }

  /// Draws the start corner style.
  void _drawStartCurve(Path path, double innerRadius, double outerRadius) {
    final Offset midPoint = getDegreeToPoint(
        axisRenderer!.isInversed ? -_cornerAngle : _cornerAngle,
        (innerRadius + outerRadius) / 2,
        Offset.zero);
    final double midStartAngle = getDegreeToRadian(180);
    double midEndAngle = midStartAngle + getDegreeToRadian(180);
    midEndAngle = axisRenderer!.isInversed ? -midEndAngle : midEndAngle;
    path.addArc(
        Rect.fromCircle(
            center: midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle,
        midEndAngle);
  }

  ///Draws the end corner curve.
  void _drawEndCurve(
      Path path, double sweepRadian, double innerRadius, double outerRadius) {
    final double cornerAngle =
        cornerStyle == CornerStyle.bothCurve ? _cornerAngle : 0;
    final double angle = axisRenderer!.isInversed
        ? getRadianToDegree(sweepRadian) - cornerAngle
        : getRadianToDegree(sweepRadian) + cornerAngle;
    final Offset midPoint =
        getDegreeToPoint(angle, (innerRadius + outerRadius) / 2, Offset.zero);

    final double midStartAngle = sweepRadian / 2;

    final double midEndAngle = axisRenderer!.isInversed
        ? midStartAngle - getDegreeToRadian(180)
        : midStartAngle + getDegreeToRadian(180);

    path.arcTo(
        Rect.fromCircle(
            center: midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle,
        midEndAngle,
        false);
  }

  /// Checks whether the axis line is dashed line.
  bool _getIsDashedLine() {
    return dashArray != null &&
        dashArray!.isNotEmpty &&
        dashArray!.length > 1 &&
        dashArray![0] > 0 &&
        dashArray![1] > 0;
  }

  /// Returns the sweep radian for pointer.
  double _getPointerSweepRadian(double sweepRadian) {
    if (pointerAnimation != null && _isAnimating) {
      if (axisRenderer != null && axisRenderer!.isInversed) {
        return sweepRadian * _pointerAnimation!.value;
      } else {
        return getDegreeToRadian(_sweepAngle * _pointerAnimation!.value);
      }
    } else {
      return sweepRadian;
    }
  }

  /// Returns the paint for the pointer.
  Paint _getPointerPaint(Rect rect, bool isFill) {
    final Paint paint = Paint()
      ..color = color ??
          gaugeThemeData.rangePointerColor ??
          (_themeData.useMaterial3
                  ? _themeData.colorScheme.primary
                  : _themeData.colorScheme.secondaryContainer)
              .withOpacity(0.8)
      ..strokeWidth = _actualRangeThickness
      ..style = isFill ? PaintingStyle.fill : PaintingStyle.stroke;

    if (gradient != null && gradient!.colors.isNotEmpty) {
      // Holds the color for gradient.
      List<Color> gradientColors;
      final double sweepAngle = getRadianToDegree(_sweepCornerRadian).abs();
      final List<double?> offsets = _getGradientOffsets();
      gradientColors = gradient!.colors;
      if (axisRenderer!.isInversed) {
        gradientColors = gradient!.colors.reversed.toList();
      }
      // gradient for the range pointer.
      final SweepGradient sweepGradient = SweepGradient(
          colors: gradientColors,
          stops: calculateGradientStops(
              offsets, axisRenderer!.isInversed, sweepAngle));
      paint.shader = sweepGradient.createShader(rect);
    }

    return paint;
  }

  /// Returns the gradient offset.
  List<double?> _getGradientOffsets() {
    if (gradient!.stops != null && gradient!.stops!.isNotEmpty) {
      return gradient!.stops!;
    } else {
      // Calculates the gradient stop values based on the number of
      // provided color.
      final double difference = 1 / gradient!.colors.length;
      final List<double?> offsets =
          List<double?>.filled(gradient!.colors.length, null);
      for (int i = 0; i < gradient!.colors.length; i++) {
        offsets[i] = i * difference;
      }

      return offsets;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    _calculatePosition();
    bool needsToAnimatePointer = false;

    if (_pointerAnimation != null && _isInitialLoading) {
      needsToAnimatePointer = _pointerAnimation!.value > 0;
    } else {
      needsToAnimatePointer = true;
    }

    double sweepRadian = _getPointerSweepRadian(_sweepCornerRadian);
    final double outerRadius = _radius - _totalOffset;
    final double innerRadius = outerRadius - _actualRangeThickness;
    final double cornerRadius = (innerRadius - outerRadius).abs() / 2;
    final double refCurveRadius = (2 *
            math.pi *
            (innerRadius + outerRadius) /
            2 *
            getRadianToDegree(_sweepCornerRadian) /
            360)
        .abs();
    final Path path = Path();
    final bool isDashedPointerLine = _getIsDashedLine();

    // Specifies whether the painting style is fill.
    bool isFill;
    if (value > axisRenderer!.minimum) {
      canvas.save();
      canvas.translate(_axisCenter.dx, _axisCenter.dy);
      canvas.rotate(getDegreeToRadian(_startArc));
      final double curveRadius = cornerStyle != CornerStyle.bothFlat
          ? cornerStyle == CornerStyle.startCurve
              ? cornerRadius
              : cornerRadius * 2
          : 0;
      if (cornerStyle != CornerStyle.bothFlat &&
          !isDashedPointerLine &&
          (refCurveRadius.floorToDouble() > curveRadius)) {
        isFill = true;
        if (cornerStyle == CornerStyle.startCurve ||
            cornerStyle == CornerStyle.bothCurve) {
          if (needsToAnimatePointer) {
            _drawStartCurve(path, innerRadius, outerRadius);
          }
        }

        if (needsToAnimatePointer) {
          path.addArc(Rect.fromCircle(center: Offset.zero, radius: outerRadius),
              _startCornerRadian, sweepRadian);
        }

        if (cornerStyle == CornerStyle.endCurve ||
            cornerStyle == CornerStyle.bothCurve) {
          if (needsToAnimatePointer) {
            _drawEndCurve(path, sweepRadian, innerRadius, outerRadius);
          }
        }

        if (needsToAnimatePointer) {
          path.arcTo(Rect.fromCircle(center: Offset.zero, radius: innerRadius),
              sweepRadian + _startCornerRadian, -sweepRadian, false);
        }
      } else {
        isFill = false;
        sweepRadian = cornerStyle == CornerStyle.bothFlat
            ? sweepRadian
            : getDegreeToRadian(_endArc);

        path.addArc(_arcRect, 0, sweepRadian);
      }

      final Paint paint = _getPointerPaint(_arcRect, isFill);
      if (!isDashedPointerLine) {
        canvas.drawPath(path, paint);
      } else {
        if (dashArray != null) {
          canvas.drawPath(
              dashPath(path,
                  dashArray: CircularIntervalList<double>(dashArray!)),
              paint);
        }
      }

      canvas.restore();
    }
  }
}
