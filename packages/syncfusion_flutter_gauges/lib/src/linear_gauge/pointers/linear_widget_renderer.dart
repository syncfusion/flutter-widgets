import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../linear_gauge/utils/enum.dart';

/// Represents the render object of shape pointer.
class RenderLinearWidgetPointer extends RenderProxyBox {
  /// Creates a instance for [RenderLinearWidgetPointer].
  RenderLinearWidgetPointer(
      {required double value,
      ValueChanged? onValueChanged,
      required double offset,
      required LinearElementPosition position,
      required LinearMarkerAlignment markerAlignment,
      Animation<double>? pointerAnimation,
      VoidCallback? onAnimationCompleted,
      AnimationController? animationController})
      : _value = value,
        _onValueChanged = onValueChanged,
        _offset = offset,
        _position = position,
        _markerAlignment = markerAlignment,
        _pointerAnimation = pointerAnimation,
        _onAnimationCompleted = onAnimationCompleted,
        animationController = animationController;

  /// Gets or sets the shape pointer old value.
  double? oldValue;

  /// Gets or sets the animation controller assigned to [RenderLinearShapePointer].
  AnimationController? animationController;

  /// Gets the value assigned to [RenderLinearWidgetPointer].
  double get value => _value;
  double _value;

  /// Sets the value for [RenderLinearWidgetPointer].
  set value(double value) {
    if (value == _value) {
      return;
    }

    if (animationController != null && animationController!.isAnimating) {
      oldValue = _value;
      animationController!.stop();
    }

    _value = value;

    if (animationController != null && oldValue != value) {
      animationController!.forward(from: 0.01);
    }

    markNeedsLayout();
  }

  /// Gets the onValueChanged assigned to [RenderLinearWidgetPointer].
  ValueChanged? get onValueChanged => _onValueChanged;
  ValueChanged? _onValueChanged;

  /// Sets the onValueChanged callback for [RenderLinearWidgetPointer].
  set onValueChanged(ValueChanged? value) {
    if (value == _onValueChanged) {
      return;
    }

    _onValueChanged = value;
  }

  /// Gets the offset assigned to [RenderLinearWidgetPointer].
  double get offset => _offset;
  double _offset;

  /// Sets the offset for [RenderLinearWidgetPointer].
  set offset(double value) {
    if (value == _offset) {
      return;
    }

    _offset = value;
    markNeedsLayout();
  }

  /// Gets the position assigned to [RenderLinearWidgetPointer].
  LinearElementPosition get position => _position;
  LinearElementPosition _position;

  /// Sets the position for [RenderLinearWidgetPointer].
  set position(LinearElementPosition value) {
    if (value == _position) {
      return;
    }

    _position = value;
    markNeedsLayout();
  }

  /// Gets the animation assigned to [RenderLinearWidgetPointer].
  Animation<double>? get pointerAnimation => _pointerAnimation;
  Animation<double>? _pointerAnimation;

  /// Sets the animation for [RenderLinearWidgetPointer].
  set pointerAnimation(Animation<double>? value) {
    if (value == _pointerAnimation) {
      return;
    }

    _removeAnimationListener();
    _pointerAnimation = value;
    _addAnimationListener();
  }

  /// Gets the Marker Alignment assigned to [RenderLinearWidgetPointer].
  LinearMarkerAlignment get markerAlignment => _markerAlignment;
  LinearMarkerAlignment _markerAlignment;

  /// Sets the Marker Alignment for [RenderLinearWidgetPointer].
  set markerAlignment(LinearMarkerAlignment value) {
    if (value == _markerAlignment) {
      return;
    }
    _markerAlignment = value;
    markNeedsLayout();
  }

  /// Gets the animation completed callback.
  VoidCallback? get onAnimationCompleted => _onAnimationCompleted;
  VoidCallback? _onAnimationCompleted;

  /// Sets the animation completed callback.
  set onAnimationCompleted(VoidCallback? value) {
    if (value == _onAnimationCompleted) {
      return;
    }

    _onAnimationCompleted = value;
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (onAnimationCompleted != null) {
        onAnimationCompleted!();
      }

      if (oldValue != value) {
        oldValue = value;
      }
    }
  }

  void _addAnimationListener() {
    if (pointerAnimation == null) return;

    pointerAnimation!.addListener(markNeedsPaint);
    pointerAnimation!.addStatusListener(_animationStatusListener);
  }

  void _removeAnimationListener() {
    if (pointerAnimation == null) return;

    pointerAnimation!.removeListener(markNeedsPaint);
    pointerAnimation!.removeStatusListener(_animationStatusListener);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _addAnimationListener();
  }

  @override
  void detach() {
    _removeAnimationListener();
    super.detach();
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if ((pointerAnimation == null ||
        (pointerAnimation != null && pointerAnimation!.value > 0))) {
      super.paint(context, offset);
    }
  }
}
