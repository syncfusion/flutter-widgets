import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../linear_gauge/utils/enum.dart';

/// Represents the render object of shape pointer.
class RenderLinearShapePointer extends RenderBox {
  /// Creates a instance for [RenderLinearShapePointer].
  RenderLinearShapePointer(
      {required double value,
      ValueChanged? onValueChanged,
      required Color color,
      required Color borderColor,
      required double borderWidth,
      required double width,
      required double height,
      required double offset,
      required LinearElementPosition position,
      required LinearShapePointerType shapeType,
      required double elevation,
      required LinearGaugeOrientation orientation,
      required Color elevationColor,
      required LinearMarkerAlignment markerAlignment,
      required bool isMirrored,
      Animation<double>? pointerAnimation,
      VoidCallback? onAnimationCompleted,
      AnimationController? animationController})
      : _value = value,
        _onValueChanged = onValueChanged,
        _color = color,
        _borderColor = borderColor,
        _borderWidth = borderWidth,
        _shapeType = shapeType,
        _elevation = elevation,
        _orientation = orientation,
        _elevationColor = elevationColor,
        _width = width,
        _height = height,
        _offset = offset,
        _position = position,
        _markerAlignment = markerAlignment,
        _isMirrored = isMirrored,
        animationController = animationController,
        _onAnimationCompleted = onAnimationCompleted,
        _pointerAnimation = pointerAnimation {
    _shapePaint = Paint();
    _path = Path();
  }

  late Paint _shapePaint;
  late Path _path;

  Rect _shapeRect = Rect.zero;

  /// Shape Pointer old value.
  double? oldValue;

  /// Gets or Sets the animation controller assigned to [RenderLinearShapePointer].
  AnimationController? animationController;

  /// Gets the orientation to [RenderLinearShapePointer].
  LinearGaugeOrientation? get orientation => _orientation;
  LinearGaugeOrientation? _orientation;

  /// Sets the orientation for [RenderLinearShapePointer].
  ///
  /// Default value is [GaugeOrientation.horizontal].
  set orientation(LinearGaugeOrientation? value) {
    if (value == _orientation) {
      return;
    }

    _orientation = value;
    markNeedsLayout();
  }

  /// Gets the shapeType assigned to [RenderLinearShapePointer].
  LinearShapePointerType? get shapeType => _shapeType;
  LinearShapePointerType? _shapeType;

  /// Sets the shapeType for [RenderLinearShapePointer].
  set shapeType(LinearShapePointerType? value) {
    if (value == _shapeType) {
      return;
    }
    _shapeType = value;
    markNeedsPaint();
  }

  /// Gets the value assigned to [RenderLinearShapePointer].
  double get value => _value;
  double _value;

  /// Sets the value for [RenderLinearShapePointer].
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

  /// Gets the onValueChanged assigned to [RenderLinearShapePointer].
  ValueChanged? get onValueChanged => _onValueChanged;
  ValueChanged? _onValueChanged;

  /// Sets the onValueChanged callback for [RenderLinearShapePointer].
  set onValueChanged(ValueChanged? value) {
    if (value == _onValueChanged) {
      return;
    }

    _onValueChanged = value;
  }

  /// Gets the width assigned to [RenderLinearShapePointer].
  double get width => _width;
  double _width;

  /// Sets the width for [RenderLinearShapePointer].
  set width(double value) {
    if (value == _width) {
      return;
    }

    _width = value;
    markNeedsLayout();
  }

  /// Gets the height assigned to [RenderLinearShapePointer].
  double get height => _height;
  double _height;

  /// Sets the height for [RenderLinearShapePointer].
  set height(double value) {
    if (value == _height) {
      return;
    }

    _height = value;
    markNeedsLayout();
  }

  /// Gets the color assigned to [RenderLinearShapePointer].
  Color get color => _color;
  Color _color;

  /// Sets the color for [RenderLinearShapePointer].
  set color(Color value) {
    if (value == _color) {
      return;
    }

    _color = value;
    markNeedsPaint();
  }

  /// Gets the borderColor assigned to [RenderLinearShapePointer].
  Color get borderColor => _borderColor;
  Color _borderColor;

  /// Sets the borderColor for [RenderLinearShapePointer].
  set borderColor(Color value) {
    if (value == _borderColor) {
      return;
    }

    _borderColor = value;
    markNeedsPaint();
  }

  /// Gets the borderWidth assigned to [RenderLinearShapePointer].
  double get borderWidth => _borderWidth;
  double _borderWidth;

  /// Sets the borderWidth for [RenderLinearShapePointer].
  set borderWidth(double value) {
    if (value == _borderWidth) {
      return;
    }

    _borderWidth = value;
    markNeedsPaint();
  }

  /// Gets the offset assigned to [RenderLinearShapePointer].
  double get offset => _offset;
  double _offset;

  /// Sets the offset for [RenderLinearShapePointer].
  set offset(double value) {
    if (value == _offset) {
      return;
    }

    _offset = value;
    markNeedsLayout();
  }

  /// Gets the position assigned to [RenderLinearShapePointer].
  LinearElementPosition get position => _position;
  LinearElementPosition _position;

  /// Sets the position for [RenderLinearShapePointer].
  set position(LinearElementPosition value) {
    if (value == _position) {
      return;
    }

    _position = value;
    markNeedsLayout();
  }

  /// Gets the elevation assigned to [RenderLinearShapePointer].
  double get elevation => _elevation;
  double _elevation;

  /// Sets the elevation for [RenderLinearShapePointer].
  set elevation(double value) {
    if (value == _elevation) {
      return;
    }

    _elevation = value;
    markNeedsPaint();
  }

  /// Gets the elevation color assigned to [RenderLinearShapePointer].
  Color get elevationColor => _elevationColor;
  Color _elevationColor;

  /// Sets the elevation color for [RenderLinearShapePointer].
  set elevationColor(Color value) {
    if (value == _elevationColor) {
      return;
    }

    _elevationColor = value;
    markNeedsPaint();
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

  /// Gets the Marker Alignment assigned to [RenderLinearShapePointer].
  LinearMarkerAlignment? get markerAlignment => _markerAlignment;
  LinearMarkerAlignment? _markerAlignment;

  /// Sets the Marker Alignment for [RenderLinearShapePointer].
  set markerAlignment(LinearMarkerAlignment? value) {
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

  /// Gets the isMirrored to [RenderLinearShapePointer].
  bool get isMirrored => _isMirrored;
  bool _isMirrored;

  /// Sets the isMirrored for [RenderLinearShapePointer].
  set isMirrored(bool value) {
    if (value == _isMirrored) {
      return;
    }

    _isMirrored = value;
    markNeedsPaint();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (onAnimationCompleted != null) {
        onAnimationCompleted!();
      }

      if (oldValue != value) oldValue = value;
    }
  }

  void _addAnimationListener() {
    if (pointerAnimation != null) {
      pointerAnimation!.addListener(markNeedsPaint);
      pointerAnimation!.addStatusListener(_animationStatusListener);
    }
  }

  void _removeAnimationListener() {
    if (pointerAnimation != null) {
      pointerAnimation!.removeListener(markNeedsPaint);
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
    size = Size(width, height);
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  ///Gets the diamond path for shape drawing.
  void _getDiamondPath(double left, double top, double height, double width) {
    _path
      ..moveTo(left + width / 2.0, top)
      ..lineTo(left, top + height / 2.0)
      ..lineTo(left + width / 2.0, top + height)
      ..lineTo(left + width, top + height / 2.0)
      ..close();
  }

  ///Gets the triangle path for shape drawing.
  void _getTrianglePath(double left, double top, {bool isInverted = true}) {
    if (_orientation == LinearGaugeOrientation.horizontal) {
      if (isInverted) {
        _path.moveTo(left, top);
        _path.lineTo(left + width, top);
        _path.lineTo(left + (width / 2), top + height);
      } else {
        _path.moveTo(left + (width / 2), top);
        _path.lineTo(left, top + height);
        _path.lineTo(left + width, top + height);
      }
    } else {
      if (isInverted) {
        _path.moveTo(left, top);
        _path.lineTo(left + width, top + (height / 2));
        _path.lineTo(left, top + height);
      } else {
        _path.moveTo(left, top + (height / 2));
        _path.lineTo(left + width, top);
        _path.lineTo(left + width, top + height);
      }
    }

    _path.close();
  }

  void _setBorderStyle() {
    _shapePaint.style = PaintingStyle.stroke;
    _shapePaint.strokeWidth = borderWidth;
    _shapePaint.color = borderColor;
  }

  void _drawCircleShape(Canvas canvas) {
    if (elevation > 0) {
      _path.addOval(_shapeRect);
      canvas.drawShadow(_path, elevationColor, elevation, true);
    }

    canvas.drawOval(_shapeRect, _shapePaint);

    if (borderWidth > 0) {
      _setBorderStyle();
      canvas.drawOval(_shapeRect, _shapePaint);
    }
  }

  void _drawRectangleShape(Canvas canvas) {
    _path.addRect(_shapeRect);
    if (elevation > 0) {
      canvas.drawShadow(_path, elevationColor, elevation, true);
    }

    canvas.drawRect(_shapeRect, _shapePaint);

    if (borderWidth > 0) {
      _setBorderStyle();
      canvas.drawRect(_shapeRect, _shapePaint);
    }
  }

  void _drawTriangle(Canvas canvas, bool isInverted) {
    _getTrianglePath(_shapeRect.left, _shapeRect.top, isInverted: isInverted);
    if (elevation > 0) {
      canvas.drawShadow(_path, elevationColor, elevation, true);
    }
    canvas.drawPath(_path, _shapePaint);

    if (borderWidth > 0) {
      _setBorderStyle();
      canvas.drawPath(_path, _shapePaint);
    }
  }

  void _drawDiamond(Canvas canvas) {
    _getDiamondPath(
        _shapeRect.left, _shapeRect.top, _shapeRect.height, _shapeRect.width);

    if (elevation > 0) {
      canvas.drawShadow(_path, elevationColor, elevation, true);
    }

    canvas.drawPath(_path, _shapePaint);

    if (borderWidth > 0) {
      _setBorderStyle();
      canvas.drawPath(_path, _shapePaint);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (pointerAnimation == null ||
        (pointerAnimation != null && pointerAnimation!.value > 0)) {
      _shapeRect = Rect.fromLTWH(
          offset.dx + borderWidth / 2,
          offset.dy + borderWidth / 2,
          size.width - borderWidth,
          size.height - borderWidth);
      _shapePaint.style = PaintingStyle.fill;
      _shapePaint.color = color;

      final canvas = context.canvas;
      _path.reset();
      switch (shapeType) {
        case LinearShapePointerType.circle:
          _drawCircleShape(canvas);
          break;
        case LinearShapePointerType.rectangle:
          _drawRectangleShape(canvas);
          break;
        case LinearShapePointerType.triangle:
          _drawTriangle(canvas, isMirrored ? true : false);
          break;
        case LinearShapePointerType.invertedTriangle:
          _drawTriangle(canvas, isMirrored ? false : true);
          break;
        case LinearShapePointerType.diamond:
          _drawDiamond(canvas);
          break;
        default:
          break;
      }
    }
  }
}
