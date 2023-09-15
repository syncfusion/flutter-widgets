import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart' as core;

import '../../linear_gauge/utils/enum.dart';
import 'linear_marker_pointer.dart';

/// Represents the render object of shape pointer.
class RenderLinearShapePointer extends RenderLinearPointerBase {
  /// Creates a instance for [RenderLinearShapePointer].
  RenderLinearShapePointer({
    required double value,
    ValueChanged<double>? onChanged,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
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
    required bool isAxisInversed,
    Animation<double>? pointerAnimation,
    VoidCallback? onAnimationCompleted,
    required LinearMarkerDragBehavior dragBehavior,
    AnimationController? animationController,
  })  : _color = color,
        _borderColor = borderColor,
        _borderWidth = borderWidth,
        _shapeType = shapeType,
        _elevation = elevation,
        _orientation = orientation,
        _elevationColor = elevationColor,
        _width = width,
        _height = height,
        super(
            value: value,
            onChanged: onChanged,
            onChangeStart: onChangeStart,
            onChangeEnd: onChangeEnd,
            offset: offset,
            position: position,
            dragBehavior: dragBehavior,
            markerAlignment: markerAlignment,
            isMirrored: isMirrored,
            isAxisInversed: isAxisInversed,
            pointerAnimation: pointerAnimation,
            animationController: animationController,
            onAnimationCompleted: onAnimationCompleted) {
    _shapePaint = Paint();
    _borderPaint = Paint();
  }

  late Paint _shapePaint;
  Paint? _borderPaint;

  Rect _shapeRect = Rect.zero;

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

      if (_borderPaint != null && borderWidth > 0) {
        _borderPaint!.style = PaintingStyle.stroke;
        _borderPaint!.strokeWidth = borderWidth;
        _borderPaint!.color = borderColor;
      } else {
        _borderPaint = null;
      }

      final Canvas canvas = context.canvas;
      LinearShapePointerType gaugeShapeType = shapeType!;

      if (isMirrored) {
        if (gaugeShapeType == LinearShapePointerType.triangle) {
          gaugeShapeType = LinearShapePointerType.invertedTriangle;
        } else if (gaugeShapeType == LinearShapePointerType.invertedTriangle) {
          gaugeShapeType = LinearShapePointerType.triangle;
        }
      }

      late core.ShapeMarkerType markerType;

      switch (gaugeShapeType) {
        case LinearShapePointerType.circle:
          markerType = core.ShapeMarkerType.circle;
          break;
        case LinearShapePointerType.rectangle:
          markerType = core.ShapeMarkerType.rectangle;
          break;
        case LinearShapePointerType.triangle:
          markerType = core.ShapeMarkerType.triangle;
          if (orientation == LinearGaugeOrientation.vertical) {
            markerType = core.ShapeMarkerType.verticalTriangle;
          }
          break;
        case LinearShapePointerType.invertedTriangle:
          markerType = core.ShapeMarkerType.invertedTriangle;
          if (orientation == LinearGaugeOrientation.vertical) {
            markerType = core.ShapeMarkerType.verticalInvertedTriangle;
          }
          break;
        case LinearShapePointerType.diamond:
          markerType = core.ShapeMarkerType.diamond;
          break;
        // ignore: no_default_cases
        default:
          break;
      }

      core.paint(
          canvas: canvas,
          rect: _shapeRect,
          elevation: elevation,
          shapeType: markerType,
          elevationColor: elevationColor,
          paint: _shapePaint,
          borderPaint: _borderPaint);
    }
  }
}
