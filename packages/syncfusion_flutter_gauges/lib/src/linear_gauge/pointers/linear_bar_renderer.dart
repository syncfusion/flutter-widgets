import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../linear_gauge/axis/linear_axis_renderer.dart';
import '../../linear_gauge/utils/enum.dart';
import '../../linear_gauge/utils/linear_gauge_helper.dart';

/// Represents the render object of bar pointer.
class RenderLinearBarPointer extends RenderOpacity {
  /// Creates a instance for [RenderLinearBarPointer].
  RenderLinearBarPointer(
      {required double value,
      required LinearEdgeStyle edgeStyle,
      ShaderCallback? shaderCallback,
      required Color color,
      required Color borderColor,
      required double borderWidth,
      required double thickness,
      required double offset,
      required LinearElementPosition position,
      required LinearGaugeOrientation orientation,
      Animation<double>? pointerAnimation,
      VoidCallback? onAnimationCompleted,
      this.animationController,
      required bool isAxisInversed})
      : _value = value,
        _edgeStyle = edgeStyle,
        _shaderCallback = shaderCallback,
        _color = color,
        _borderColor = borderColor,
        _borderWidth = borderWidth,
        _thickness = thickness,
        _offset = offset,
        _position = position,
        _orientation = orientation,
        _pointerAnimation = pointerAnimation,
        _onAnimationCompleted = onAnimationCompleted,
        _isAxisInversed = isAxisInversed {
    _barPaint = Paint();
    _isHorizontal = orientation == LinearGaugeOrientation.horizontal;
    _path = Path();
  }

  late Paint _barPaint;
  late bool _isHorizontal;
  late Path _path;
  late Offset _barPointerOffset;

  Rect _barRect = Rect.zero;
  Rect _oldBarRect = Rect.zero;

  /// Gets or sets the axis assigned to [RenderLinearBarPointer].
  RenderLinearAxis? axis;

  /// Gets or Sets the animation controller assigned to [RenderLinearBarPointer].
  AnimationController? animationController;

  /// Gets the value assigned to [RenderLinearBarPointer].
  double get value => _value;
  double _value;

  /// Sets the value for [RenderLinearBarPointer].
  set value(double value) {
    if (value == _value) {
      return;
    }

    if (animationController != null && animationController!.isAnimating) {
      animationController!.stop();
      _oldBarRect = Rect.fromLTWH(
          _barPointerOffset.dx, _barPointerOffset.dy, size.width, size.height);
    }

    _value = value;

    if (animationController != null) {
      animationController!.forward(from: 0.01);
    }

    markNeedsLayout();
  }

  /// Gets the thickness assigned to [RenderLinearBarPointer].
  double get thickness => _thickness;
  double _thickness;

  /// Sets the thickness for [RenderLinearBarPointer].
  set thickness(double value) {
    if (value == _thickness) {
      return;
    }

    _thickness = value;
    markNeedsLayout();
  }

  /// Gets the color assigned to [RenderLinearBarPointer].
  Color get color => _color;
  Color _color;

  /// Sets the color for [RenderLinearBarPointer].
  set color(Color value) {
    if (value == _color) {
      return;
    }

    _color = value;
    markNeedsPaint();
  }

  /// Gets the borderColor assigned to [RenderLinearBarPointer].
  Color get borderColor => _borderColor;
  Color _borderColor;

  /// Sets the borderColor for [RenderLinearBarPointer].
  set borderColor(Color value) {
    if (value == _borderColor) {
      return;
    }

    _borderColor = value;
    markNeedsPaint();
  }

  /// Gets the borderWidth assigned to [RenderLinearBarPointer].
  double get borderWidth => _borderWidth;
  double _borderWidth;

  /// Sets the borderWidth for [RenderLinearBarPointer].
  set borderWidth(double value) {
    if (value == _borderWidth) {
      return;
    }

    _borderWidth = value;
    markNeedsPaint();
  }

  /// Gets the offset assigned to [RenderLinearBarPointer].
  double get offset => _offset;
  double _offset;

  /// Sets the offset for [RenderLinearBarPointer].
  set offset(double value) {
    if (value == _offset) {
      return;
    }

    _offset = value;
    markNeedsLayout();
  }

  /// Gets the edgeStyle assigned to [RenderLinearBarPointer].
  LinearEdgeStyle get edgeStyle => _edgeStyle;
  LinearEdgeStyle _edgeStyle;

  /// Sets the edgeStyle for [RenderLinearBarPointer].
  set edgeStyle(LinearEdgeStyle value) {
    if (value == _edgeStyle) {
      return;
    }
    _edgeStyle = value;
    markNeedsPaint();
  }

  /// Gets the position assigned to [RenderLinearBarPointer].
  LinearElementPosition get position => _position;
  LinearElementPosition _position;

  /// Sets the position for [RenderLinearBarPointer].
  set position(LinearElementPosition value) {
    if (value == _position) {
      return;
    }
    _position = value;
    markNeedsLayout();
  }

  /// Gets the shader callback assigned to [RenderLinearBarPointer].
  ShaderCallback? get shaderCallback => _shaderCallback;
  ShaderCallback? _shaderCallback;

  /// Sets the  shader callback for [RenderLinearBarPointer].
  set shaderCallback(ShaderCallback? value) {
    if (value == _shaderCallback) {
      return;
    }

    _shaderCallback = value;
    markNeedsPaint();
  }

  /// Gets the isAxisInversed assigned to [RenderLinearBarPointer].
  bool get isAxisInversed => _isAxisInversed;
  bool _isAxisInversed;

  /// Sets the isInverse for [RenderLinearAxis].
  set isAxisInversed(bool value) {
    if (value == _isAxisInversed) {
      return;
    }

    _isAxisInversed = value;
    markNeedsPaint();
  }

  /// Gets the orientation assigned to [RenderLinearBarPointer].
  ///
  /// Default value is [GaugeOrientation.horizontal].
  ///
  LinearGaugeOrientation get orientation => _orientation;
  LinearGaugeOrientation _orientation;

  /// Sets the orientation for [RenderLinearBarPointer].
  ///
  /// Default value is [GaugeOrientation.horizontal].
  set orientation(LinearGaugeOrientation value) {
    if (value == _orientation) {
      return;
    }
    _orientation = value;
    _isHorizontal = orientation == LinearGaugeOrientation.horizontal;
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

  /// Gets the animation assigned to [RenderLinearShapePointer].
  Animation<double>? get pointerAnimation => _pointerAnimation;
  Animation<double>? _pointerAnimation;

  /// Sets the animation animation for [RenderLinearShapePointer].
  set pointerAnimation(Animation<double>? value) {
    if (value == _pointerAnimation) {
      return;
    }

    _removeAnimationListener();
    _pointerAnimation = value;
    _addAnimationListener();
  }

  void _updateAnimation() {
    if (child != null) {
      opacity = _pointerAnimation!.value;
    } else {
      markNeedsPaint();
    }
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (onAnimationCompleted != null) {
        onAnimationCompleted!();
      }

      _oldBarRect = _barRect;
    }
  }

  void _addAnimationListener() {
    if (pointerAnimation != null) {
      pointerAnimation!.addListener(_updateAnimation);
      pointerAnimation!.addStatusListener(_animationStatusListener);
    }
  }

  void _removeAnimationListener() {
    if (pointerAnimation != null) {
      pointerAnimation!.removeListener(_updateAnimation);
      pointerAnimation!.removeStatusListener(_animationStatusListener);
    }
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
  void performLayout() {
    double barWidth = 0;

    if (axis != null) {
      barWidth =
          (axis!.valueToPixel(value) - axis!.valueToPixel(axis!.minimum)).abs();
    }

    Size controlSize;

    if (_isHorizontal) {
      controlSize = Size(barWidth, thickness);
    } else {
      controlSize = Size(thickness, barWidth);
    }

    if (child != null) {
      child!.layout(BoxConstraints.tight(controlSize));
    }

    size = controlSize;
  }

  ///Measures the bar rect.
  void _getBarRect(Offset offset) {
    if (size.isEmpty) {
      _barRect = Rect.zero;
      return;
    }

    double animationValue = 1;
    if (_pointerAnimation != null) {
      animationValue = _pointerAnimation!.value;
    }

    if (_isHorizontal) {
      _barRect = Rect.fromLTWH(
          offset.dx +
              (isAxisInversed
                  ? (size.width - _oldBarRect.width) -
                      ((size.width - _oldBarRect.width) * animationValue)
                  : 0),
          offset.dy,
          _oldBarRect.width +
              ((size.width - _oldBarRect.width) * animationValue),
          size.height);
    } else {
      _barRect = Rect.fromLTWH(
        offset.dx,
        offset.dy +
            (!isAxisInversed
                ? (size.height - _oldBarRect.height) -
                    ((size.height - _oldBarRect.height) * animationValue)
                : 0),
        size.width,
        _oldBarRect.height +
            ((size.height - _oldBarRect.height) * animationValue),
      );
    }

    if (borderWidth > 0) {
      _barRect = Rect.fromLTWH(
          _barRect.left + borderWidth / 2,
          _barRect.top + borderWidth / 2,
          _barRect.width - borderWidth,
          _barRect.height - borderWidth);
    }
  }

  Path _getBarPointerPath(Offset offset) {
    _path.reset();
    switch (edgeStyle) {
      case LinearEdgeStyle.bothFlat:
        _path.addRect(_barRect);
        break;
      case LinearEdgeStyle.bothCurve:
        _path.addRRect(
            RRect.fromRectAndRadius(_barRect, Radius.circular(thickness / 2)));
        break;
      case LinearEdgeStyle.startCurve:
        _path.addRRect(getStartCurve(
            isHorizontal: _isHorizontal,
            isAxisInversed: isAxisInversed,
            rect: _barRect,
            radius: thickness / 2));
        break;
      case LinearEdgeStyle.endCurve:
        _path.addRRect(getEndCurve(
            isHorizontal: _isHorizontal,
            isAxisInversed: isAxisInversed,
            rect: _barRect,
            radius: thickness / 2));
        break;
      // ignore: no_default_cases
      default:
        break;
    }

    return _path;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _barPointerOffset = offset;
    final Canvas canvas = context.canvas;

    if (_pointerAnimation == null ||
        (_pointerAnimation != null && _pointerAnimation!.value > 0)) {
      _getBarRect(offset);
      _barPaint.style = PaintingStyle.fill;
      _barPaint.color = color;
      if (shaderCallback != null) {
        _barPaint.shader = shaderCallback!(_barRect);
      }

      final Path path = _getBarPointerPath(offset);
      canvas.drawPath(path, _barPaint);

      if (borderWidth > 0) {
        _barPaint.shader = null;
        _barPaint.style = PaintingStyle.stroke;
        _barPaint.strokeWidth = borderWidth;
        _barPaint.color = borderColor;
        canvas.drawPath(path, _barPaint);
      }

      super.paint(context, offset);
    }
  }
}
