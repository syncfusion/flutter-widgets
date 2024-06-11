import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/axis/radial_axis_widget.dart';
import '../../radial_gauge/pointers/pointer_painting_details.dart';
import '../../radial_gauge/renderers/needle_pointer_renderer.dart';
import '../../radial_gauge/styles/radial_knob_style.dart';
import '../../radial_gauge/styles/radial_tail_style.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';

/// Represents the renderer of radial gauge needle pointer.
class RenderNeedlePointer extends RenderBox {
  /// Creates a object for [RenderNeedlePointer].
  RenderNeedlePointer(
      {required double value,
      required this.enableDragging,
      this.onValueChanged,
      this.onValueChangeStart,
      this.onValueChangeEnd,
      this.onValueChanging,
      required KnobStyle knobStyle,
      TailStyle? tailStyle,
      Gradient? gradient,
      required double needleLength,
      required GaugeSizeUnit lengthUnit,
      required double needleStartWidth,
      required double needleEndWidth,
      NeedlePointerRenderer? needlePointerRenderer,
      Color? needleColor,
      AnimationController? pointerAnimationController,
      this.pointerInterval,
      required this.animationType,
      required this.enableAnimation,
      required this.isRadialGaugeAnimationEnabled,
      required ValueNotifier<int> repaintNotifier,
      required ThemeData themeData,
      required SfColorScheme colorScheme,
      required SfGaugeThemeData gaugeThemeData})
      : _value = value,
        _knobStyle = knobStyle,
        _tailStyle = tailStyle,
        _gradient = gradient,
        _needleLength = needleLength,
        _lengthUnit = lengthUnit,
        _needleStartWidth = needleStartWidth,
        _needleEndWidth = needleEndWidth,
        _needleColor = needleColor,
        _repaintNotifier = repaintNotifier,
        _pointerAnimationController = pointerAnimationController,
        _needlePointerRenderer = needlePointerRenderer,
        _themeData = themeData,
        _colorScheme = colorScheme,
        _gaugeThemeData = gaugeThemeData;

  double _actualTailLength = 0;
  late double _actualNeedleLength;
  late double _actualCapRadius;
  late double _radian;
  late double _startLeftX;
  late double _startLeftY;
  late double _startRightX;
  late double _startRightY;
  late double _stopLeftX;
  late double _stopLeftY;
  late double _stopRightX;
  late double _stopRightY;
  late double _tailLeftStartX;
  late double _tailLeftStartY;
  late double _tailLeftEndX;
  late double _tailLeftEndY;
  late double _tailRightStartX;
  late double _tailRightStartY;
  late double _tailRightEndX;
  late double _tailRightEndY;
  late Offset _centerPoint;
  late double _angle;
  late double _stopX;
  late double _stopY;
  late double _startX;
  late double _startY;
  bool _isAnimating = true;
  bool _isInitialLoading = true;
  late double _radius;
  late double _sweepAngle;
  late Offset _axisCenter;

  /// Marker pointer old value.
  double? oldValue;

  /// Pointer rect.
  Rect? pointerRect;

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

  /// Gets or Sets the enableAnimation [RenderNeedlePointer].
  bool enableAnimation;

  /// Gets or sets the pointer interval.
  List<double?>? pointerInterval;

  /// Whether the gauge animation enabled or not.
  bool isRadialGaugeAnimationEnabled;

  /// Gets the animation controller assigned to [RenderNeedlePointer].
  AnimationController? get pointerAnimationController =>
      _pointerAnimationController;
  AnimationController? _pointerAnimationController;

  /// Gets the animation controller for [RenderNeedlePointer].
  set pointerAnimationController(AnimationController? value) {
    if (value == _pointerAnimationController) {
      return;
    }

    _pointerAnimationController = value;

    if (_axisRenderer != null && _pointerAnimationController != null) {
      _updateAnimation();
    }
  }

  /// Gets the axisRenderer assigned to [RenderNeedlePointer].
  RenderRadialAxisWidget? get axisRenderer => _axisRenderer;
  RenderRadialAxisWidget? _axisRenderer;

  /// Sets the axisRenderer for [RenderNeedlePointer].
  set axisRenderer(RenderRadialAxisWidget? value) {
    if (value == _axisRenderer) {
      return;
    }

    _axisRenderer = value;

    if (_axisRenderer != null) {
      _updateAxisValues();
    }

    if (_axisRenderer != null && pointerAnimationController != null) {
      _isAnimating = true;
      pointerAnimation = _axisRenderer!.createPointerAnimation(this);
    }
  }

  /// Gets the gaugeThemeData assigned to [RenderNeedlePointer].
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

  /// Gets the themeData assigned to [RenderRadialAxisWidget].
  ThemeData get themeData => _themeData;
  ThemeData _themeData;

  /// Sets the themeData for [RenderRadialAxisWidget].
  set themeData(ThemeData value) {
    if (value == _themeData) {
      return;
    }
    _themeData = value;
    markNeedsPaint();
  }

  /// Gets the colors assigned to [RenderNeedlePointer]
  SfColorScheme get colorScheme => _colorScheme;
  SfColorScheme _colorScheme;

  /// Sets the colors for [RenderNeedlePointer]
  set colorScheme(SfColorScheme value) {
    if (value == _colorScheme) {
      return;
    }
    _colorScheme = value;
    markNeedsPaint();
  }

  /// Gets the animation assigned to [RenderNeedlePointer].
  Animation<double>? get pointerAnimation => _pointerAnimation;
  Animation<double>? _pointerAnimation;

  /// Sets the animation for [RenderNeedlePointer].
  set pointerAnimation(Animation<double>? value) {
    if (value == _pointerAnimation) {
      return;
    }

    _removeListeners();
    _pointerAnimation = value;
    _addListeners();
  }

  /// Gets the value assigned to [RenderNeedlePointer].
  double get value => _value;
  double _value;

  /// Sets the value for [RenderNeedlePointer].
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
      _isAnimating = true;
      pointerAnimationController!.forward(from: 0.0);
    }

    if (!enableAnimation) {
      oldValue = value;
      markNeedsPaint();
    }
  }

  /// Gets the knobStyle assigned to [RenderNeedlePointer].
  KnobStyle get knobStyle => _knobStyle;
  KnobStyle _knobStyle;

  /// Sets the knobStyle for [RenderNeedlePointer].
  set knobStyle(KnobStyle value) {
    if (value == _knobStyle) {
      return;
    }

    _knobStyle = value;
    markNeedsPaint();
  }

  /// Gets the tailStyle assigned to [RenderNeedlePointer].
  TailStyle? get tailStyle => _tailStyle;
  TailStyle? _tailStyle;

  /// Sets the tailStyle for [RenderNeedlePointer].
  set tailStyle(TailStyle? value) {
    if (value == _tailStyle) {
      return;
    }

    _tailStyle = value;
    markNeedsPaint();
  }

  /// Gets the gradient assigned to [RenderNeedlePointer].
  Gradient? get gradient => _gradient;
  Gradient? _gradient;

  /// Sets the gradient for [RenderNeedlePointer].
  set gradient(Gradient? value) {
    if (value == _gradient) {
      return;
    }

    _gradient = value;
    markNeedsPaint();
  }

  /// Gets the needleLength assigned to [RenderNeedlePointer].
  double get needleLength => _needleLength;
  double _needleLength;

  /// Sets the needleLength for [RenderNeedlePointer].
  set needleLength(double value) {
    if (value == _needleLength) {
      return;
    }

    _needleLength = value;
    markNeedsPaint();
  }

  /// Gets the lengthUnit assigned to [RenderNeedlePointer].
  GaugeSizeUnit get lengthUnit => _lengthUnit;
  GaugeSizeUnit _lengthUnit;

  /// Sets the lengthUnit for [RenderNeedlePointer].
  set lengthUnit(GaugeSizeUnit value) {
    if (value == _lengthUnit) {
      return;
    }

    _lengthUnit = value;
    markNeedsPaint();
  }

  /// Gets the needleStartWidth assigned to [RenderNeedlePointer].
  double get needleStartWidth => _needleStartWidth;
  double _needleStartWidth;

  /// Sets the needleStartWidth for [RenderNeedlePointer].
  set needleStartWidth(double value) {
    if (value == _needleStartWidth) {
      return;
    }

    _needleStartWidth = value;
    markNeedsPaint();
  }

  /// Gets the needleEndWidth assigned to [RenderNeedlePointer].
  double get needleEndWidth => _needleEndWidth;
  double _needleEndWidth;

  /// Sets the needleEndWidth for [RenderNeedlePointer].
  set needleEndWidth(double value) {
    if (value == _needleEndWidth) {
      return;
    }

    _needleEndWidth = value;
    markNeedsPaint();
  }

  /// Gets the text markerPointerRenderer to [RenderNeedlePointer].
  NeedlePointerRenderer? get needlePointerRenderer => _needlePointerRenderer;
  NeedlePointerRenderer? _needlePointerRenderer;

  /// Sets the markerPointerRenderer for [RenderMarkerPointer].
  set needlePointerRenderer(NeedlePointerRenderer? value) {
    if (value == _needlePointerRenderer) {
      return;
    }

    _needlePointerRenderer = value;
    markNeedsPaint();
  }

  /// Gets the needleColor assigned to [RenderNeedlePointer].
  Color? get needleColor => _needleColor;
  Color? _needleColor;

  /// Sets the needleColor for [RenderNeedlePointer].
  set needleColor(Color? value) {
    if (value == _needleColor) {
      return;
    }

    _needleColor = value;
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

  void _updateAnimation() {
    _isInitialLoading = true;
    oldValue = axisRenderer!.minimum;
    _isAnimating = true;
    pointerAnimation = _axisRenderer!.createPointerAnimation(this);
  }

  void _updateAxisValues() {
    _sweepAngle = axisRenderer!.getAxisSweepAngle();
    _axisCenter = axisRenderer!.getAxisCenter();
    _radius = _axisRenderer!.getRadius();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _isAnimating = false;
      _isInitialLoading = false;
      if (oldValue != value) {
        oldValue = value;
      }
    }
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
    if (enableDragging && pointerRect != null) {
      return pointerRect!.contains(position);
    } else {
      return false;
    }
  }

  /// Calculates the needle position
  void _calculatePosition() {
    _updateAxisValues();
    _calculateDefaultValue();
    _calculateNeedleOffset();
  }

  /// Calculates the default value
  void _calculateDefaultValue() {
    _actualNeedleLength =
        axisRenderer!.getActualValue(needleLength, lengthUnit, false);
    _actualCapRadius = axisRenderer!
        .getActualValue(knobStyle.knobRadius, knobStyle.sizeUnit, false);
    final double currentFactor = (axisRenderer!.renderer != null &&
            axisRenderer!.renderer!.valueToFactor(value) != null)
        ? axisRenderer!.renderer!.valueToFactor(value) ??
            axisRenderer!.valueToFactor(value)
        : axisRenderer!.valueToFactor(value);
    _angle = (currentFactor * _sweepAngle) + axisRenderer!.startAngle;
    _radian = getDegreeToRadian(_angle);
    _centerPoint = _axisCenter;
  }

  /// Calculates the needle pointer offset
  void _calculateNeedleOffset() {
    final double needleRadian = getDegreeToRadian(-90);
    _stopX = _actualNeedleLength * math.cos(needleRadian);
    _stopY = _actualNeedleLength * math.sin(needleRadian);
    _startX = 0;
    _startY = 0;

    if (needleEndWidth >= 0) {
      _startLeftX = _startX - needleEndWidth * math.cos(needleRadian - 90);
      _startLeftY = _startY - needleEndWidth * math.sin(needleRadian - 90);
      _startRightX = _startX - needleEndWidth * math.cos(needleRadian + 90);
      _startRightY = _startY - needleEndWidth * math.sin(needleRadian + 90);
    }

    if (needleStartWidth >= 0) {
      _stopLeftX = _stopX - needleStartWidth * math.cos(needleRadian - 90);
      _stopLeftY = _stopY - needleStartWidth * math.sin(needleRadian - 90);
      _stopRightX = _stopX - needleStartWidth * math.cos(needleRadian + 90);
      _stopRightY = _stopY - needleStartWidth * math.sin(needleRadian + 90);
    }

    _calculatePointerRect();
    if (tailStyle != null) {
      _calculateTailPosition(needleRadian);
    }
  }

  /// Calculates the needle pointer rect based on
  /// its start and the stop value
  void _calculatePointerRect() {
    double x1 = _centerPoint.dx;
    double x2 = _centerPoint.dx + _actualNeedleLength * math.cos(_radian);
    double y1 = _centerPoint.dy;
    double y2 = _centerPoint.dy + _actualNeedleLength * math.sin(_radian);

    if (x1 > x2) {
      final double temp = x1;
      x1 = x2;
      x2 = temp;
    }

    if (y1 > y2) {
      final double temp = y1;
      y1 = y2;
      y2 = temp;
    }

    if (y2 - y1 < 20) {
      y1 -= 10; // Creates the pointer rect with minimum height
      y2 += 10;
    }

    if (x2 - x1 < 20) {
      x1 -= 10; // Creates the pointer rect with minimum width
      x2 += 10;
    }

    pointerRect = Rect.fromLTRB(x1, y1, x2, y2);
  }

  /// Calculates the values to render the needle tail
  void _calculateTailPosition(double needleRadian) {
    final double pointerWidth = tailStyle!.width;
    _actualTailLength = axisRenderer!
        .getActualValue(tailStyle!.length, tailStyle!.lengthUnit, false);
    if (_actualTailLength > 0) {
      final double tailEndX =
          _startX - _actualTailLength * math.cos(needleRadian);
      final double tailEndY =
          _startY - _actualTailLength * math.sin(needleRadian);
      _tailLeftStartX = _startX - pointerWidth * math.cos(needleRadian - 90);
      _tailLeftStartY = _startY - pointerWidth * math.sin(needleRadian - 90);
      _tailRightStartX = _startX - pointerWidth * math.cos(needleRadian + 90);
      _tailRightStartY = _startY - pointerWidth * math.sin(needleRadian + 90);

      _tailLeftEndX = tailEndX - pointerWidth * math.cos(needleRadian - 90);
      _tailLeftEndY = tailEndY - pointerWidth * math.sin(needleRadian - 90);
      _tailRightEndX = tailEndX - pointerWidth * math.cos(needleRadian + 90);
      _tailRightEndY = tailEndY - pointerWidth * math.sin(needleRadian + 90);
    }
  }

  /// Method to draw pointer the needle pointer.
  ///
  /// By overriding this method, you can draw the customized needled pointer
  /// using required values.
  ///
  void drawPointer(Canvas canvas, PointerPaintingDetails pointerPaintingDetails,
      SfGaugeThemeData gaugeThemeData) {
    final double pointerRadian =
        getDegreeToRadian(pointerPaintingDetails.pointerAngle);
    if (_actualNeedleLength > 0) {
      _renderNeedle(canvas, pointerRadian);
    }
    if (_actualTailLength > 0) {
      _renderTail(canvas, pointerRadian);
    }
    _renderCap(canvas, gaugeThemeData);
  }

  /// To render the needle of the pointer
  void _renderNeedle(Canvas canvas, double pointerRadian) {
    final Paint paint = Paint()
      ..color = needleColor ??
          _gaugeThemeData.needleColor ??
          colorScheme.onSurface[255]!
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(_startLeftX, _startLeftY);
    path.lineTo(_stopLeftX, _stopLeftY);
    path.lineTo(_stopRightX, _stopRightY);
    path.lineTo(_startRightX, _startRightY);
    path.close();

    if (gradient != null) {
      paint.shader = gradient!.createShader(path.getBounds());
    }

    canvas.save();
    canvas.translate(_centerPoint.dx, _centerPoint.dy);
    canvas.rotate(pointerRadian);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  /// To render the tail of the pointer
  void _renderTail(Canvas canvas, double pointerRadian) {
    final Path tailPath = Path();
    tailPath.moveTo(_tailLeftStartX, _tailLeftStartY);
    tailPath.lineTo(_tailLeftEndX, _tailLeftEndY);
    tailPath.lineTo(_tailRightEndX, _tailRightEndY);
    tailPath.lineTo(_tailRightStartX, _tailRightStartY);
    tailPath.close();

    canvas.save();
    canvas.translate(_centerPoint.dx, _centerPoint.dy);
    canvas.rotate(pointerRadian);

    final Paint tailPaint = Paint()
      ..color = tailStyle!.color ??
          _gaugeThemeData.tailColor ??
          colorScheme.onSurface[255]!;

    if (tailStyle!.gradient != null) {
      tailPaint.shader =
          tailStyle!.gradient!.createShader(tailPath.getBounds());
    }

    canvas.drawPath(tailPath, tailPaint);

    if (tailStyle!.borderWidth > 0) {
      final Paint tailStrokePaint = Paint()
        ..color = tailStyle!.borderColor ?? _gaugeThemeData.tailBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = tailStyle!.borderWidth;

      canvas.drawPath(tailPath, tailStrokePaint);
    }

    canvas.restore();
  }

  /// To render the cap of needle
  void _renderCap(Canvas canvas, SfGaugeThemeData gaugeThemeData) {
    if (_actualCapRadius > 0) {
      final Paint knobPaint = Paint()
        ..color = knobStyle.color ??
            gaugeThemeData.knobColor ??
            colorScheme.onSurface[255]!;

      canvas.drawCircle(_axisCenter, _actualCapRadius, knobPaint);

      if (knobStyle.borderWidth > 0) {
        final double actualBorderWidth = axisRenderer!
            .getActualValue(knobStyle.borderWidth, knobStyle.sizeUnit, false);
        final Paint strokePaint = Paint()
          ..color = knobStyle.borderColor ?? gaugeThemeData.knobBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = actualBorderWidth;

        canvas.drawCircle(_centerPoint, _actualCapRadius, strokePaint);
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _calculatePosition();
    double? angle;
    bool needsShowPointer = false;

    if (_pointerAnimation != null && _isAnimating) {
      angle = (_sweepAngle * _pointerAnimation!.value) +
          axisRenderer!.startAngle +
          90;
    } else {
      angle = _angle + 90;
    }

    if (isRadialGaugeAnimationEnabled) {
      if (_pointerAnimation != null && _isInitialLoading) {
        needsShowPointer = axisRenderer!.isInversed
            ? _pointerAnimation!.value < 1
            : _pointerAnimation!.value > 0;
      } else {
        needsShowPointer = true;
      }
    } else {
      needsShowPointer = true;
    }

    if (needsShowPointer) {
      final Offset startPosition = Offset(_startX, _startY);
      final Offset endPosition = Offset(_stopX, _stopY);

      final PointerPaintingDetails pointerPaintingDetails =
          PointerPaintingDetails(
              startOffset: startPosition,
              endOffset: endPosition,
              pointerAngle: angle,
              axisRadius: _radius,
              axisCenter: _axisCenter);
      if (needlePointerRenderer != null) {
        needlePointerRenderer!.drawPointer(
            context.canvas, pointerPaintingDetails, _gaugeThemeData);
      } else {
        drawPointer(context.canvas, pointerPaintingDetails, _gaugeThemeData);
      }
    }
  }
}
