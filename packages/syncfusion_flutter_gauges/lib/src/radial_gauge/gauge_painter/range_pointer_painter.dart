import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/foundation.dart';
import '../axis/radial_axis.dart';
import '../common/radial_gauge_renderer.dart';
import '../gauge/radial_gauge.dart';
import '../pointers/range_pointer.dart';
import '../renderers/radial_axis_renderer_base.dart';
import '../renderers/range_pointer_renderer.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Represents the painter to render the range pointer
class RangePointerPainter extends CustomPainter {
  /// Creates the range pointer
  RangePointerPainter(
      this._gauge,
      this._axis,
      this._rangePointer,
      this._isRepaint,
      this._pointerAnimation,
      ValueNotifier<num> notifier,
      this._gaugeThemeData,
      this._renderingDetails,
      this._axisRenderer,
      this._rangePointerRenderer)
      : super(repaint: notifier);

  /// Specifies the circular gauge
  final SfRadialGauge _gauge;

  /// Specifies the gauge axis
  final RadialAxis _axis;

  /// Specifies the needle pointer
  final RangePointer _rangePointer;

  /// Specifies whether to redraw the pointer
  final bool _isRepaint;

  /// Specifies the pointer animation
  final Animation<double>? _pointerAnimation;

  /// Specifies the gauge theme data.
  final SfGaugeThemeData _gaugeThemeData;

  /// Hold the radial gauge rendering details
  final RenderingDetails _renderingDetails;

  /// Holds the radial axis renderer
  final RadialAxisRendererBase _axisRenderer;

  /// Holds the gauge range renderer
  final RangePointerRenderer _rangePointerRenderer;

  @override
  void paint(Canvas canvas, Size size) {
    final bool needsToAnimatePointer = _getNeedsPointerAnimation();
    double sweepRadian =
        _getPointerSweepRadian(_rangePointerRenderer.sweepCornerRadian);
    final double outerRadius =
        _axisRenderer.radius - _rangePointerRenderer.totalOffset;
    final double innerRadius =
        outerRadius - _rangePointerRenderer.actualRangeThickness;
    final double cornerRadius = (innerRadius - outerRadius).abs() / 2;
    final double value = (2 *
            math.pi *
            (innerRadius + outerRadius) /
            2 *
            getRadianToDegree(_rangePointerRenderer.sweepCornerRadian) /
            360)
        .abs();
    final Path path = Path();
    final bool isDashedPointerLine = _getIsDashedLine();
    // Specifies whether the painting style is fill
    bool isFill;
    if (_rangePointerRenderer.currentValue > _axis.minimum) {
      canvas.save();
      canvas.translate(
          _axisRenderer.axisCenter.dx, _axisRenderer.axisCenter.dy);
      canvas.rotate(getDegreeToRadian(_rangePointerRenderer.startArc));
      final double curveRadius =
          _rangePointer.cornerStyle != CornerStyle.bothFlat
              ? _rangePointer.cornerStyle == CornerStyle.startCurve
                  ? cornerRadius
                  : cornerRadius * 2
              : 0;
      if (_rangePointer.cornerStyle != CornerStyle.bothFlat &&
          !isDashedPointerLine &&
          (value.floorToDouble() > curveRadius)) {
        isFill = true;
        if (_rangePointer.cornerStyle == CornerStyle.startCurve ||
            _rangePointer.cornerStyle == CornerStyle.bothCurve) {
          if (needsToAnimatePointer) {
            _drawStartCurve(path, innerRadius, outerRadius);
          }
        }

        if (needsToAnimatePointer) {
          path.addArc(
              Rect.fromCircle(center: const Offset(0, 0), radius: outerRadius),
              _rangePointerRenderer.startCornerRadian,
              sweepRadian);
        }

        if (_rangePointer.cornerStyle == CornerStyle.endCurve ||
            _rangePointer.cornerStyle == CornerStyle.bothCurve) {
          if (needsToAnimatePointer) {
            _drawEndCurve(path, sweepRadian, innerRadius, outerRadius);
          }
        }

        if (needsToAnimatePointer) {
          path.arcTo(
              Rect.fromCircle(center: const Offset(0, 0), radius: innerRadius),
              sweepRadian + _rangePointerRenderer.startCornerRadian,
              -sweepRadian,
              false);
        }
      } else {
        isFill = false;
        sweepRadian = _rangePointer.cornerStyle == CornerStyle.bothFlat
            ? sweepRadian
            : getDegreeToRadian(_rangePointerRenderer.endArc);

        path.addArc(_rangePointerRenderer.arcRect, 0, sweepRadian);
      }

      final Paint paint =
          _getPointerPaint(_rangePointerRenderer.arcRect, isFill);
      if (!isDashedPointerLine) {
        canvas.drawPath(path, paint);
      } else {
        if (_rangePointer.dashArray != null) {
          canvas.drawPath(
              dashPath(path,
                  dashArray:
                      CircularIntervalList<double>(_rangePointer.dashArray!)),
              paint);
        }
      }

      canvas.restore();
      _updateAnimation(sweepRadian, isFill);
    }
  }

  /// Draws the start corner style
  void _drawStartCurve(Path path, double innerRadius, double outerRadius) {
    final Offset midPoint = getDegreeToPoint(
        _axis.isInversed
            ? -_rangePointerRenderer.cornerAngle
            : _rangePointerRenderer.cornerAngle,
        (innerRadius + outerRadius) / 2,
        const Offset(0, 0));
    final double midStartAngle = getDegreeToRadian(180);

    double midEndAngle = midStartAngle + getDegreeToRadian(180);
    midEndAngle = _axis.isInversed ? -midEndAngle : midEndAngle;
    path.addArc(
        Rect.fromCircle(
            center: midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle,
        midEndAngle);
  }

  ///Draws the end corner curve
  void _drawEndCurve(
      Path path, double sweepRadian, double innerRadius, double outerRadius) {
    final double cornerAngle =
        _rangePointer.cornerStyle == CornerStyle.bothCurve
            ? _rangePointerRenderer.cornerAngle
            : 0;
    final double angle = _axis.isInversed
        ? getRadianToDegree(sweepRadian) - cornerAngle
        : getRadianToDegree(sweepRadian) + cornerAngle;
    final Offset midPoint = getDegreeToPoint(
        angle, (innerRadius + outerRadius) / 2, const Offset(0, 0));

    final double midStartAngle = sweepRadian / 2;

    final double midEndAngle = _axis.isInversed
        ? midStartAngle - getDegreeToRadian(180)
        : midStartAngle + getDegreeToRadian(180);

    path.arcTo(
        Rect.fromCircle(
            center: midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle,
        midEndAngle,
        false);
  }

  /// Updates the range pointer animation based on the sweep angle
  void _updateAnimation(double sweepRadian, bool isFill) {
    final bool isPointerEndAngle = _getIsEndAngle(sweepRadian, isFill);

    // Disables the pointer animation once its reached the end value
    if (_rangePointerRenderer.getIsPointerAnimationEnabled() &&
        isPointerEndAngle) {
      _rangePointerRenderer.needsAnimate = false;
    }

    // Disables the load time animation of pointers once
    // its reached the end value
    if (_renderingDetails.needsToAnimatePointers &&
        _gauge.axes[_gauge.axes.length - 1] == _axis &&
        _axis.pointers![_axis.pointers!.length - 1] == _rangePointer &&
        (isPointerEndAngle || _pointerAnimation!.isCompleted)) {
      _renderingDetails.needsToAnimatePointers = false;
    }
  }

  /// Checks whether the current angle is end angle
  bool _getIsEndAngle(double sweepRadian, bool isFill) {
    return sweepRadian == _rangePointerRenderer.sweepCornerRadian ||
        (_rangePointer.cornerStyle != CornerStyle.bothFlat &&
            isFill &&
            sweepRadian == getDegreeToRadian(_rangePointerRenderer.endArc));
  }

  /// Checks whether the axis line is dashed line
  bool _getIsDashedLine() {
    return _rangePointer.dashArray != null &&
        _rangePointer.dashArray!.isNotEmpty &&
        _rangePointer.dashArray!.length > 1 &&
        _rangePointer.dashArray![0] > 0 &&
        _rangePointer.dashArray![1] > 0;
  }

  /// Returns the sweep radian for pointer
  double _getPointerSweepRadian(double sweepRadian) {
    if (_renderingDetails.needsToAnimatePointers ||
        _rangePointerRenderer.getIsPointerAnimationEnabled()) {
      return getDegreeToRadian(
          _axisRenderer.sweepAngle * _pointerAnimation!.value);
    } else {
      return sweepRadian;
    }
  }

  /// Returns whether to animate the pointers
  bool _getNeedsPointerAnimation() {
    return _pointerAnimation == null ||
        (_rangePointerRenderer.needsAnimate != null &&
            !_rangePointerRenderer.needsAnimate!) ||
        (_pointerAnimation!.value.abs() > 0 &&
            (_renderingDetails.needsToAnimatePointers ||
                (_rangePointerRenderer.needsAnimate != null &&
                    _rangePointerRenderer.needsAnimate!)));
  }

  /// Returns the paint for the pointer
  Paint _getPointerPaint(Rect rect, bool isFill) {
    final Paint paint = Paint()
      ..color = _rangePointer.color ?? _gaugeThemeData.rangePointerColor
      ..strokeWidth = _rangePointerRenderer.actualRangeThickness
      ..style = isFill ? PaintingStyle.fill : PaintingStyle.stroke;
    if (_rangePointer.gradient != null &&
        _rangePointer.gradient!.colors.isNotEmpty) {
      // Holds the color for gradient
      List<Color> gradientColors;
      final double sweepAngle =
          getRadianToDegree(_rangePointerRenderer.sweepCornerRadian).abs();
      final List<double?> offsets = _getGradientOffsets();
      gradientColors = _rangePointer.gradient!.colors;
      if (_axis.isInversed) {
        gradientColors = _rangePointer.gradient!.colors.reversed.toList();
      }
      // gradient for the range pointer
      final SweepGradient gradient = SweepGradient(
          colors: gradientColors,
          stops: calculateGradientStops(offsets, _axis.isInversed, sweepAngle));
      paint.shader = gradient.createShader(rect);
    }

    return paint;
  }

  /// Returns the gradient offset
  List<double?> _getGradientOffsets() {
    if (_rangePointer.gradient!.stops != null &&
        _rangePointer.gradient!.stops!.isNotEmpty) {
      return _rangePointer.gradient!.stops!;
    } else {
      // Calculates the gradient stop values based on the number of
      // provided color
      final double difference = 1 / _rangePointer.gradient!.colors.length;
      final List<double?> offsets =
          List<double?>.filled(_rangePointer.gradient!.colors.length, null);
      for (int i = 0; i < _rangePointer.gradient!.colors.length; i++) {
        offsets[i] = i * difference;
      }

      return offsets;
    }
  }

  @override
  bool shouldRepaint(RangePointerPainter oldDelegate) => _isRepaint;
}
