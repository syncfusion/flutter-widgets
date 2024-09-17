import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../radial_gauge/axis/radial_axis_widget.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';

/// Represents the renderer of radial gauge annotation.
class RenderGaugeAnnotation extends RenderOpacity {
  /// Creates a instance for [RenderGaugeAnnotation].
  RenderGaugeAnnotation(
      {double? axisValue,
      required GaugeAlignment horizontalAlignment,
      double? angle,
      required GaugeAlignment verticalAlignment,
      required double positionFactor,
      Animation<double>? annotationAnimation,
      required ValueNotifier<int> repaintNotifier,
      RenderBox? child})
      : _axisValue = axisValue,
        _horizontalAlignment = horizontalAlignment,
        _angle = angle,
        _verticalAlignment = verticalAlignment,
        _positionFactor = positionFactor,
        _repaintNotifier = repaintNotifier,
        _annotationAnimation = annotationAnimation,
        super(child: child);

  /// Specifies the offset of positioning the annotation.
  late Offset _annotationPosition;
  late double _radius;
  late double _actualAxisWidth;
  late double _sweepAngle;
  late double _centerXPoint;
  late double _centerYPoint;
  late Offset _axisCenter;
  late Size _axisSize;

  /// Gets the fade animation assigned to [RenderGaugeAnnotation].
  RenderRadialAxisWidget? get axisRenderer => _axisRenderer;
  RenderRadialAxisWidget? _axisRenderer;

  /// Gets the fade animation assigned to [RenderGaugeAnnotation].
  set axisRenderer(RenderRadialAxisWidget? value) {
    if (value == _axisRenderer) {
      return;
    }

    _axisRenderer = value;

    if (_axisRenderer != null) {
      _updateAxisValues();
    }
  }

  /// Gets the annotation axisValue.
  double? get axisValue => _axisValue;
  double? _axisValue;

  /// Sets the annotation angle.
  set axisValue(double? value) {
    if (_axisValue != value) {
      _axisValue = value;
      markNeedsLayout();
    }
  }

  /// Gets the annotation angle.
  double? get angle => _angle;
  double? _angle;

  /// Sets the annotation angle.
  set angle(double? value) {
    if (_angle != value) {
      _angle = value;
      markNeedsLayout();
    }
  }

  /// Gets the positionFactor.
  double get positionFactor => _positionFactor;
  double _positionFactor;

  /// Sets the positionFactor.
  set positionFactor(double value) {
    if (_positionFactor != value) {
      _positionFactor = value;
      markNeedsLayout();
    }
  }

  /// Gets the horizontal alignment of annotation.
  GaugeAlignment get horizontalAlignment => _horizontalAlignment;
  GaugeAlignment _horizontalAlignment;

  /// Sets the horizontal alignment of annotation.
  set horizontalAlignment(GaugeAlignment value) {
    if (_horizontalAlignment != value) {
      _horizontalAlignment = value;
      markNeedsLayout();
    }
  }

  /// Gets the vertical alignment of annotation.
  GaugeAlignment get verticalAlignment => _verticalAlignment;
  GaugeAlignment _verticalAlignment;

  /// Sets the vertical alignment of annotation.
  set verticalAlignment(GaugeAlignment value) {
    if (_verticalAlignment != value) {
      _verticalAlignment = value;
      markNeedsLayout();
    }
  }

  /// Gets the fade animation assigned to [RenderGaugeAnnotation].
  Animation<double>? get annotationAnimation => _annotationAnimation;
  Animation<double>? _annotationAnimation;

  /// Gets the fade animation assigned to [RenderGaugeAnnotation].
  set annotationAnimation(Animation<double>? value) {
    if (value == _annotationAnimation) {
      return;
    }

    _removeListeners();
    _annotationAnimation = value;
    _addListeners();
  }

  /// Calculates the actual angle value.
  double _calculateActualAngle() {
    double actualValue = 0;
    if (angle != null) {
      actualValue = angle!;
    } else if (axisValue != null) {
      actualValue = (axisRenderer!.valueToFactor(axisValue!) * _sweepAngle) +
          axisRenderer!.startAngle;
    }

    return actualValue;
  }

  /// Gets the repaintNotifier assigned to [RenderMarkerPointer].
  ValueNotifier<int> get repaintNotifier => _repaintNotifier;
  ValueNotifier<int> _repaintNotifier;

  /// Sets the repaintNotifier for [RenderMarkerPointer].
  set repaintNotifier(ValueNotifier<int> value) {
    if (value == _repaintNotifier) {
      return;
    }

    _removeListeners();
    _repaintNotifier = value;
    _addListeners();
  }

  /// Calculate the pixel position in axis to place the annotation widget.
  void _calculateAxisPosition() {
    _updateAxisValues();
    final double value = positionFactor;
    final double offset = value * _radius;
    final double angle = _calculateActualAngle();
    final double radian = getDegreeToRadian(angle);
    final double axisHalfWidth = positionFactor == 1 ? _actualAxisWidth / 2 : 0;
    if (!axisRenderer!.canScaleToFit) {
      final double x = (_axisSize.width / 2) +
          (offset - axisHalfWidth) * math.cos(radian) -
          _centerXPoint;
      final double y = (_axisSize.height / 2) +
          (offset - axisHalfWidth) * math.sin(radian) -
          _centerYPoint;
      _annotationPosition = Offset(x, y);
    } else {
      final double x =
          _axisCenter.dx + (offset - axisHalfWidth) * math.cos(radian);
      final double y =
          _axisCenter.dy + (offset - axisHalfWidth) * math.sin(radian);
      _annotationPosition = Offset(x, y);
    }
  }

  void _updateAnimation() {
    if (child != null) {
      opacity = _annotationAnimation!.value;
    }
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

  void _addListeners() {
    if (_annotationAnimation != null) {
      _annotationAnimation!.addListener(_updateAnimation);
    }

    repaintNotifier.addListener(markNeedsLayout);
  }

  void _removeListeners() {
    if (_annotationAnimation != null) {
      _annotationAnimation!.removeListener(_updateAnimation);
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

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    _axisSize = Size(constraints.maxWidth, constraints.maxHeight);
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(Size(child!.size.width, child!.size.height));
      _calculateAxisPosition();

      if (child!.parentData is BoxParentData) {
        final BoxParentData? childParentData =
            child!.parentData as BoxParentData?;
        final double dx = _annotationPosition.dx -
            (horizontalAlignment == GaugeAlignment.near
                ? 0
                : horizontalAlignment == GaugeAlignment.center
                    ? child!.size.width / 2
                    : child!.size.width);
        final double dy = _annotationPosition.dy -
            (verticalAlignment == GaugeAlignment.near
                ? 0
                : verticalAlignment == GaugeAlignment.center
                    ? child!.size.height / 2
                    : child!.size.height);
        childParentData!.offset = Offset(dx, dy);
      }
    } else {
      size = Size.zero;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    bool needsShowPointer;
    if (annotationAnimation != null) {
      needsShowPointer = annotationAnimation!.value > 0;
    } else {
      needsShowPointer = true;
    }

    if (((annotationAnimation != null && needsShowPointer) ||
            annotationAnimation == null) &&
        child != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      super.paint(context, childParentData.offset + offset);
    }
  }
}
