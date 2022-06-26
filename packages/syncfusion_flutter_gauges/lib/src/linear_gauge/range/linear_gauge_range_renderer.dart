import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../linear_gauge/axis/linear_axis_renderer.dart';
import '../../linear_gauge/utils/enum.dart';
import '../../linear_gauge/utils/linear_gauge_helper.dart';

/// Represents the render object of range element.
class RenderLinearRange extends RenderOpacity {
  ///Creates a instance for RenderLinearRange.
  RenderLinearRange(
      {required double startValue,
      required double midValue,
      required double endValue,
      required double startThickness,
      required double midThickness,
      required double endThickness,
      required Color color,
      required LinearElementPosition position,
      required LinearRangeShapeType rangeShapeType,
      ShaderCallback? shaderCallback,
      required LinearEdgeStyle edgeStyle,
      required LinearGaugeOrientation orientation,
      Animation<double>? rangeAnimation,
      required bool isAxisInversed,
      required bool isMirrored})
      : _startValue = startValue,
        _midValue = midValue,
        _endValue = endValue,
        _startThickness = startThickness,
        _midThickness = midThickness,
        _endThickness = endThickness,
        _color = color,
        _position = position,
        _rangeShapeType = rangeShapeType,
        _shaderCallback = shaderCallback,
        _edgeStyle = edgeStyle,
        _orientation = orientation,
        _rangeAnimation = rangeAnimation,
        _isAxisInversed = isAxisInversed,
        _isMirrored = isMirrored {
    _rangePaint = Paint()..color = Colors.black12;
    _rangeOffsets = List<Offset>.filled(5, Offset.zero);
    _isHorizontal = orientation == LinearGaugeOrientation.horizontal;
    _path = Path();
  }

  late Paint _rangePaint;
  late List<Offset> _rangeOffsets;
  late Offset _rangeOffset;
  late bool _isHorizontal;
  late Path _path;

  Rect _rangeRect = Rect.zero;

  /// Gets or Sets the axis assigned to [RenderLinearRange].
  RenderLinearAxis? axis;

  /// Gets the range animation assigned to [RenderLinearRange].
  Animation<double>? get rangeAnimation => _rangeAnimation;
  Animation<double>? _rangeAnimation;

  /// Gets the range animation assigned to [RenderLinearRange].
  set rangeAnimation(Animation<double>? value) {
    if (value == _rangeAnimation) {
      return;
    }

    _removeAnimationListener();
    _rangeAnimation = value;
    _addAnimationListener();
  }

  /// Gets the isAxisInversed assigned to [RenderLinearRange].
  bool get isAxisInversed => _isAxisInversed;
  bool _isAxisInversed;

  /// Sets the isInverse for [RenderLinearAxis].
  set isAxisInversed(bool value) {
    if (value == _isAxisInversed) {
      return;
    }

    _isAxisInversed = value;
    markNeedsLayout();
  }

  /// Gets the orientation assigned to [RenderLinearRange].
  ///
  /// Default value is [GaugeOrientation.horizontal].
  ///
  LinearGaugeOrientation get orientation => _orientation;
  LinearGaugeOrientation _orientation;

  /// Sets the orientation for [RenderLinearRange].
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

  /// Gets the isMirrored to [RenderLinearRange].
  bool get isMirrored => _isMirrored;
  bool _isMirrored;

  /// Sets the isMirrored for [RenderLinearRange].
  set isMirrored(bool value) {
    if (value == _isMirrored) {
      return;
    }

    _isMirrored = value;
    markNeedsPaint();
  }

  /// Gets the color assigned to [RenderLinearRange].
  Color get color => _color;
  Color _color;

  /// Sets the color for [RenderLinearRange].
  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  /// Gets the position assigned to [RenderLinearRange].
  LinearElementPosition get position => _position;
  LinearElementPosition _position;

  /// Sets the position for [RenderLinearRange].
  set position(LinearElementPosition value) {
    if (value == _position) {
      return;
    }
    _position = value;
    markNeedsLayout();
  }

  /// Gets the startValue assigned to [RenderLinearRange].
  double get startValue => _startValue;
  double _startValue;

  /// Sets the startValue for [RenderLinearRange].
  set startValue(double value) {
    if (value == _startValue) {
      return;
    }

    _startValue = value;
    markNeedsLayout();
  }

  /// Gets the midValue assigned to [RenderLinearRange].
  double get midValue => _midValue;
  double _midValue;

  /// Sets the midValue for [RenderLinearRange].
  set midValue(double value) {
    if (value == _midValue) {
      return;
    }
    _midValue = value;
    markNeedsLayout();
  }

  /// Gets the endValue assigned to [RenderLinearRange].
  double get endValue => _endValue;
  double _endValue;

  /// Sets the endValue for [RenderLinearRange].
  set endValue(double value) {
    if (value == _endValue) {
      return;
    }
    _endValue = value;
    markNeedsLayout();
  }

  /// Gets the startThickness assigned to [RenderLinearRange].
  double get startThickness => _startThickness;
  double _startThickness;

  /// Sets the startThickness for [RenderLinearRange].
  set startThickness(double value) {
    if (value == _startThickness) {
      return;
    }

    _startThickness = value;
    markNeedsLayout();
  }

  /// Gets the midThickness assigned to [RenderLinearRange].
  double get midThickness => _midThickness;
  double _midThickness;

  /// Sets the midThickness for [RenderLinearRange].
  set midThickness(double value) {
    if (value == _midThickness) {
      return;
    }
    _midThickness = value;
    markNeedsLayout();
  }

  /// Gets the endThickness assigned to [RenderLinearRange].
  double get endThickness => _endThickness;
  double _endThickness;

  /// Sets the endThickness for [RenderLinearRange]..
  set endThickness(double value) {
    if (value == _endThickness) {
      return;
    }
    _endThickness = value;
    markNeedsLayout();
  }

  /// Gets the rangeShapeType assigned to [RenderLinearRange].
  LinearRangeShapeType get rangeShapeType => _rangeShapeType;
  LinearRangeShapeType _rangeShapeType;

  /// Sets the rangeShapeType for [RenderLinearRange].
  set rangeShapeType(LinearRangeShapeType value) {
    if (value == _rangeShapeType) {
      return;
    }
    _rangeShapeType = value;
    markNeedsPaint();
  }

  /// Gets the edgeStyle assigned to [RenderLinearRange].
  LinearEdgeStyle get edgeStyle => _edgeStyle;
  LinearEdgeStyle _edgeStyle;

  /// Sets the edgeStyle for [RenderLinearRange].
  set edgeStyle(LinearEdgeStyle value) {
    if (value == _edgeStyle) {
      return;
    }
    _edgeStyle = value;
    markNeedsPaint();
  }

  /// Gets the shader callback assigned to [RenderLinearRange].
  ShaderCallback? get shaderCallback => _shaderCallback;
  ShaderCallback? _shaderCallback;

  /// Sets the  shader callback for [RenderLinearRange].
  set shaderCallback(ShaderCallback? value) {
    if (value == _shaderCallback) {
      return;
    }
    _shaderCallback = value;
    markNeedsPaint();
  }

  void _updateAnimation() {
    if (child != null) {
      opacity = rangeAnimation!.value;
    } else {
      markNeedsPaint();
    }
  }

  void _addAnimationListener() {
    if (_rangeAnimation != null) {
      _rangeAnimation?.addListener(_updateAnimation);
    }
  }

  void _removeAnimationListener() {
    if (_rangeAnimation != null) {
      _rangeAnimation?.removeListener(_updateAnimation);
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
    final double thickness =
        max(max(startThickness, midThickness), endThickness);
    double rangeWidth = 0;

    if (axis != null) {
      rangeWidth =
          (axis!.valueToPixel(endValue) - axis!.valueToPixel(startValue)).abs();
    }

    Size controlSize;
    if (_isHorizontal) {
      controlSize = Size(rangeWidth, thickness);
    } else {
      controlSize = Size(thickness, rangeWidth);
    }

    if (child != null) {
      child!.layout(BoxConstraints.tight(controlSize));
    }

    size = controlSize;
  }

  ///Calculation Position based on value.
  double _getPosition(double value) {
    double factor = (value - startValue) / (endValue - startValue);
    if (_isHorizontal) {
      factor = isAxisInversed ? 1 - factor : factor;
      return (factor * _rangeRect.width) + _rangeOffset.dx;
    } else {
      factor = isAxisInversed ? factor : 1 - factor;
      return (factor * _rangeRect.height) + _rangeOffset.dy;
    }
  }

  double _getRangePosition() {
    return _isHorizontal ? _rangeOffset.dy : _rangeOffset.dx;
  }

  void _getRangeOffsets() {
    final LinearElementPosition rangeElementPosition =
        getEffectiveElementPosition(position, isMirrored);
    double bottom = _rangeOffset.dy + _rangeRect.height;

    if (orientation == LinearGaugeOrientation.vertical) {
      bottom = _rangeOffset.dx + _rangeRect.width;
    }

    final double leftStart = _getPosition(startValue);
    final double leftMid = _getPosition(midValue.clamp(startValue, endValue));
    final double leftEnd = _getPosition(endValue);
    double topStart = bottom - startThickness;
    double topMid = bottom - midThickness;
    double topEnd = bottom - endThickness;

    if (rangeElementPosition == LinearElementPosition.inside) {
      topStart = _getRangePosition() + startThickness;
      topMid = _getRangePosition() + midThickness;
      topEnd = _getRangePosition() + endThickness;
      bottom = _getRangePosition();
    }

    _rangeOffsets[0] = Offset(leftStart, topStart);
    _rangeOffsets[1] = Offset(leftMid, topMid);
    _rangeOffsets[2] = Offset(leftEnd, topEnd);
    _rangeOffsets[3] = Offset(leftEnd, bottom);
    _rangeOffsets[4] = Offset(leftStart, bottom);

    if (orientation == LinearGaugeOrientation.vertical) {
      for (int i = 0; i < 5; i++) {
        _rangeOffsets[i] = Offset(_rangeOffsets[i].dy, _rangeOffsets[i].dx);
      }
    }
  }

  /// Draws the both flat range style.
  void _drawRangeStyle(Path path) {
    path.moveTo(_rangeOffsets[0].dx, _rangeOffsets[0].dy);
    if (rangeShapeType == LinearRangeShapeType.flat) {
      path.lineTo(_rangeOffsets[1].dx, _rangeOffsets[1].dy);
      path.lineTo(_rangeOffsets[2].dx, _rangeOffsets[2].dy);
    } else {
      path.quadraticBezierTo(_rangeOffsets[1].dx, _rangeOffsets[1].dy,
          _rangeOffsets[2].dx, _rangeOffsets[2].dy);
    }

    path.lineTo(_rangeOffsets[3].dx, _rangeOffsets[3].dy);
    path.lineTo(_rangeOffsets[4].dx, _rangeOffsets[4].dy);
  }

  void _getRangePath() {
    if (startThickness == endThickness && startThickness == midThickness) {
      final Rect rangeRect = Rect.fromLTRB(_rangeOffsets[0].dx,
          _rangeOffsets[0].dy, _rangeOffsets[3].dx, _rangeOffsets[3].dy);

      if (rangeRect.hasNaN) {
        return;
      }

      switch (edgeStyle) {
        case LinearEdgeStyle.bothFlat:
          _path.addRect(rangeRect);
          break;
        case LinearEdgeStyle.bothCurve:
          _path.addRRect(RRect.fromRectAndRadius(
              rangeRect, Radius.circular(startThickness / 2)));
          break;
        case LinearEdgeStyle.startCurve:
          _path.addRRect(getStartCurve(
              isHorizontal: _isHorizontal,
              isAxisInversed: isAxisInversed,
              rect: rangeRect,
              radius: startThickness / 2));
          break;
        case LinearEdgeStyle.endCurve:
          _path.addRRect(getEndCurve(
              isHorizontal: _isHorizontal,
              isAxisInversed: isAxisInversed,
              rect: rangeRect,
              radius: startThickness / 2));
          break;
        // ignore: no_default_cases
        default:
          break;
      }
    } else {
      _drawRangeStyle(_path);
    }

    _path.close();
  }

  /// Draws the range element.
  void _drawRangeElement(Canvas canvas) {
    double animationValue = 1;
    if (_rangeAnimation != null) {
      animationValue = _rangeAnimation!.value;
    }

    _rangePaint.color = color.withOpacity(animationValue * color.opacity);
    _path.reset();
    _getRangePath();
    canvas.drawPath(_path, _rangePaint);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if ((_rangeAnimation != null && _rangeAnimation!.value > 0) ||
        rangeAnimation == null) {
      final Canvas canvas = context.canvas;
      _rangePaint.style = PaintingStyle.fill;
      _rangeOffset = offset;
      _rangePaint.color = color;
      _rangeRect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
      if (shaderCallback != null) {
        _rangePaint.shader = shaderCallback!(_rangeRect);
      }

      _getRangeOffsets();
      _drawRangeElement(canvas);

      // Painting the child render box.
      super.paint(context, offset);
    }
  }
}
