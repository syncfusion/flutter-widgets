import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../radial_gauge/axis/radial_axis_widget.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';

/// Represents the renderer of radial gauge widget pointer.
class RenderWidgetPointer extends RenderShiftedBox {
  /// Creates a object for [RenderWidgetPointer].
  RenderWidgetPointer(
      {required double value,
      required this.enableDragging,
      this.onValueChanged,
      this.onValueChangeStart,
      this.onValueChangeEnd,
      this.onValueChanging,
      required GaugeSizeUnit offsetUnit,
      required double offset,
      AnimationController? pointerAnimationController,
      this.pointerInterval,
      required this.animationType,
      required this.enableAnimation,
      required this.isRadialGaugeAnimationEnabled,
      required ValueNotifier<int> repaintNotifier,
      RenderBox? child})
      : _value = value,
        _offsetUnit = offsetUnit,
        _offset = offset,
        _pointerAnimationController = pointerAnimationController,
        _repaintNotifier = repaintNotifier,
        super(child);

  late double _radian;
  late double _totalOffset;
  late double _actualWidgetOffset;
  late double _angle;
  late Offset _pointerOffset;
  late Rect _childRect;
  bool _isAnimating = false;
  late double _radius;
  late double _actualAxisWidth;
  late double _sweepAngle;
  late double _centerXPoint;
  late double _centerYPoint;
  late Offset _axisCenter;
  bool _isInitialLoading = true;

  /// Marker pointer old value.
  double? oldValue;

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

  /// Gets or Sets the enableAnimation assigned to [RenderWidgetPointer].
  bool enableAnimation;

  /// Gets or sets the pointer interval.
  List<double?>? pointerInterval;

  /// Whether the gauge animation enabled or not.
  bool isRadialGaugeAnimationEnabled;

  /// Gets the animation controller assigned to [RenderWidgetPointer].
  AnimationController? get pointerAnimationController =>
      _pointerAnimationController;
  AnimationController? _pointerAnimationController;

  /// Sets the animation controller for [RenderWidgetPointer].
  set pointerAnimationController(AnimationController? value) {
    if (value == _pointerAnimationController) {
      return;
    }

    _pointerAnimationController = value;
    if (_axisRenderer != null && pointerAnimationController != null) {
      _updateAnimation();
    }
  }

  /// Gets the axisRenderer assigned to [RenderWidgetPointer].
  RenderRadialAxisWidget? get axisRenderer => _axisRenderer;
  RenderRadialAxisWidget? _axisRenderer;

  /// Sets the axisRenderer for [RenderWidgetPointer].
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

  /// Gets the animation assigned to [RenderWidgetPointer].
  Animation<double>? get pointerAnimation => _pointerAnimation;
  Animation<double>? _pointerAnimation;

  /// sets the animation for [RenderWidgetPointer].
  set pointerAnimation(Animation<double>? value) {
    if (value == _pointerAnimation) {
      return;
    }

    _removeListeners();
    _pointerAnimation = value;
    _addListeners();
  }

  /// Gets the value assigned to [RenderWidgetPointer].
  double get value => _value;
  double _value;

  /// Sets the value for [RenderWidgetPointer].
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
      markNeedsLayout();
    }
  }

  /// Gets the offsetUnit assigned to [RenderWidgetPointer].
  GaugeSizeUnit get offsetUnit => _offsetUnit;
  GaugeSizeUnit _offsetUnit;

  /// Sets the offsetUnit for [RenderWidgetPointer].
  set offsetUnit(GaugeSizeUnit value) {
    if (value == _offsetUnit) {
      return;
    }

    _offsetUnit = value;
    markNeedsLayout();
  }

  /// Gets the offset assigned to [RenderWidgetPointer].
  double get offset => _offset;
  double _offset;

  /// Sets the offset for [RenderWidgetPointer].
  set offset(double value) {
    if (value == _offset) {
      return;
    }

    _offset = value;
    markNeedsLayout();
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
    _isAnimating = true;
    _isInitialLoading = true;
    oldValue = axisRenderer!.minimum;
    pointerAnimation = _axisRenderer!.createPointerAnimation(this);
  }

  /// method to calculate the marker position.
  void _calculatePosition() {
    _updateAxisValues();
    _angle = getPointerAngle();
    _radian = getDegreeToRadian(_angle);
    _pointerOffset = _getPointerOffset(_radian);
  }

  /// Method returns the angle of  current pointer value.
  double getPointerAngle() {
    return (axisRenderer!.valueToFactor(value) * _sweepAngle) +
        axisRenderer!.startAngle;
  }

  /// Calculates the marker offset position.
  Offset _getPointerOffset(double pointerRadian) {
    _actualWidgetOffset =
        axisRenderer!.getActualValue(offset, offsetUnit, true);
    _totalOffset = _actualWidgetOffset < 0
        ? axisRenderer!.getAxisOffset() + _actualWidgetOffset
        : (_actualWidgetOffset + axisRenderer!.getAxisOffset());
    if (!axisRenderer!.canScaleToFit) {
      final double x = (size.width / 2) +
          (_radius - _totalOffset - (_actualAxisWidth / 2)) *
              math.cos(pointerRadian) -
          _centerXPoint;
      final double y = (size.height / 2) +
          (_radius - _totalOffset - (_actualAxisWidth / 2)) *
              math.sin(pointerRadian) -
          _centerYPoint;
      _pointerOffset = Offset(x, y);
    } else {
      final double x = _axisCenter.dx +
          (_radius - _totalOffset - (_actualAxisWidth / 2)) *
              math.cos(pointerRadian);
      final double y = _axisCenter.dy +
          (_radius - _totalOffset - (_actualAxisWidth / 2)) *
              math.sin(pointerRadian);
      _pointerOffset = Offset(x, y);
    }

    return _pointerOffset;
  }

  void _updateAxisValues() {
    _sweepAngle = axisRenderer!.getAxisSweepAngle();
    _centerXPoint = axisRenderer!.getCenterX();
    _centerYPoint = axisRenderer!.getCenterY();
    _axisCenter = axisRenderer!.getAxisCenter();
    _radius = _axisRenderer!.getRadius();
    _actualAxisWidth = _axisRenderer!.getActualValue(
        _axisRenderer!.thickness, _axisRenderer!.thicknessUnit, false);
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _isAnimating = false;
      if (oldValue != value) {
        oldValue = value;
      }

      _isInitialLoading = false;
    }
  }

  void _addListeners() {
    if (_pointerAnimation != null) {
      _pointerAnimation!.addListener(markNeedsLayout);
      _pointerAnimation!.addStatusListener(_animationStatusListener);
    }

    repaintNotifier.addListener(markNeedsLayout);
  }

  void _removeListeners() {
    if (_pointerAnimation != null) {
      _pointerAnimation!.removeListener(markNeedsLayout);
      _pointerAnimation!.removeStatusListener(_animationStatusListener);
    }

    repaintNotifier.removeListener(markNeedsLayout);
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

  bool _needsShowPointer = false;

  @override
  void performLayout() {
    final BoxConstraints boxConstraints = constraints;

    if (child != null) {
      child!.layout(boxConstraints, parentUsesSize: true);
      size = Size(constraints.maxWidth, constraints.maxHeight);
      _calculatePosition();
    }

    Offset? pointerOffset;
    _needsShowPointer = false;

    if (_pointerAnimation != null && _isAnimating) {
      final double angle =
          (_sweepAngle * _pointerAnimation!.value) + axisRenderer!.startAngle;
      pointerOffset = _getPointerOffset(getDegreeToRadian(angle));
    } else {
      pointerOffset = _pointerOffset;
    }

    if (isRadialGaugeAnimationEnabled) {
      if (_pointerAnimation != null && _isInitialLoading) {
        _needsShowPointer = axisRenderer!.isInversed
            ? _pointerAnimation!.value < 1
            : _pointerAnimation!.value > 0;
      } else {
        _needsShowPointer = true;
      }
    } else {
      _needsShowPointer = true;
    }

    if (child != null) {
      if (child!.parentData is BoxParentData) {
        final BoxParentData? childParentData =
            child!.parentData as BoxParentData?;
        final double dx = pointerOffset.dx - child!.size.width / 2;
        final double dy = pointerOffset.dy - child!.size.height / 2;
        childParentData!.offset = Offset(dx, dy);
      } else {
        size = Size.zero;
      }

      _childRect = Rect.fromLTWH(_pointerOffset.dx, _pointerOffset.dy,
          child!.size.width, child!.size.height);
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    if (enableDragging) {
      return _childRect.contains(position);
    } else {
      return false;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (pointerAnimation == null ||
        (pointerAnimation != null && _needsShowPointer)) {
      super.paint(context, offset);
    }
  }
}
