import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/foundation.dart';
import '../axis/radial_axis.dart';
import '../common/radial_gauge_renderer.dart';
import '../gauge/radial_gauge.dart';
import '../range/gauge_range.dart';
import '../renderers/gauge_range_renderer.dart';
import '../renderers/radial_axis_renderer_base.dart';
import '../utils/helper.dart';

/// Represents the painter to render axis range
class RangePainter extends CustomPainter {
  /// Creates the range painter
  RangePainter(
      this._gauge,
      this._axis,
      this._range,
      this._isRepaint,
      this._rangeAnimation,
      ValueNotifier<num> notifier,
      this._gaugeThemeData,
      this._renderingDetails,
      this._axisRenderer,
      this._rangeRenderer)
      : super(repaint: notifier);

  /// Specifies the circular gauge
  final SfRadialGauge _gauge;

  /// Specifies the gauge axis
  final RadialAxis _axis;

  /// Specifies the needle pointer
  final GaugeRange _range;

  /// Specifies whether to redraw the pointer
  final bool _isRepaint;

  /// Specifies the range animation
  final Animation<double>? _rangeAnimation;

  /// Hold the radial gauge rendering details
  final RenderingDetails _renderingDetails;

  /// Specifies the gauge theme data
  final SfGaugeThemeData _gaugeThemeData;

  /// Holds the radial axis renderer
  final RadialAxisRendererBase _axisRenderer;

  /// Holds the range renderer
  final GaugeRangeRenderer _rangeRenderer;

  @override
  bool shouldRepaint(RangePainter oldDelegate) => _isRepaint;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint;
    final Path path = Path();
    if (_rangeRenderer.actualStartValue != _rangeRenderer.actualEndValue) {
      canvas.save();
      if (!_axis.canScaleToFit) {
        canvas.translate(_rangeRenderer.center.dx - _axisRenderer.centerX,
            _rangeRenderer.center.dy - _axisRenderer.centerY);
      } else {
        canvas.translate(
            _axisRenderer.axisCenter.dx, _axisRenderer.axisCenter.dy);
      }

      canvas.rotate(_rangeRenderer.rangeStartRadian);

      if (_rangeRenderer.rangeRect == null) {
        path.arcTo(
            _rangeRenderer.outerArc.arcRect,
            getDegreeToRadian(_rangeRenderer.outerArc.startAngle),
            getDegreeToRadian(_rangeRenderer.outerArcSweepAngle),
            false);
        path.arcTo(
            _rangeRenderer.innerArc.arcRect,
            getDegreeToRadian(_rangeRenderer.innerArc.endAngle),
            getDegreeToRadian(_rangeRenderer.innerArcSweepAngle),
            false);

        paint = _getRangePaint(true, _rangeRenderer.pathRect, 0);
        canvas.drawPath(path, paint);
      } else {
        paint = _getRangePaint(
            false, _rangeRenderer.rangeRect!, _rangeRenderer.thickness);
        canvas.drawArc(_rangeRenderer.rangeRect!, 0,
            _rangeRenderer.rangeEndRadian, false, paint);
      }
      canvas.restore();
    }

    if (_range.label != null) {
      _renderRangeText(canvas);
    }

    // Disables the load time animation once the end value of the range
    // is reached
    if (_gauge.axes[_gauge.axes.length - 1] == _axis &&
        _axis.ranges![_axis.ranges!.length - 1] == _range &&
        _rangeAnimation != null &&
        _rangeAnimation!.value == 1) {
      _renderingDetails.needsToAnimateRanges = false;
    }
  }

  /// Returns the paint for the range
  Paint _getRangePaint(bool isFill, Rect rect, double strokeWidth) {
    double opacity = 1;
    if (_rangeAnimation != null) {
      opacity = _rangeAnimation!.value;
    }

    final Paint paint = Paint()
      ..style = isFill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = _range.color ?? _gaugeThemeData.rangeColor;
    final double actualOpacity = paint.color.opacity;
    paint.color = paint.color.withOpacity(opacity * actualOpacity);
    if (_range.gradient != null && _range.gradient!.colors.isNotEmpty) {
      List<Color> colors = _range.gradient!.colors;
      if (_axis.isInversed) {
        colors = _range.gradient!.colors.reversed.toList();
      }

      paint.shader = SweepGradient(
              colors: colors, stops: _getGradientStops() as List<double>)
          .createShader(rect);
    }
    return paint;
  }

  /// To calculate the gradient stop based on the sweep angle
  List<double?> _getGradientStops() {
    final double sweepRadian =
        _rangeRenderer.actualStartWidth != _rangeRenderer.actualEndWidth
            ? _rangeRenderer.rangeEndRadian - _rangeRenderer.rangeStartRadian
            : _rangeRenderer.rangeEndRadian;
    double rangeStartAngle =
        _axisRenderer.valueToFactor(_rangeRenderer.actualStartValue) *
                _axisRenderer.sweepAngle +
            _axis.startAngle;
    if (rangeStartAngle < 0) {
      rangeStartAngle += 360;
    }

    if (rangeStartAngle > 360) {
      rangeStartAngle -= 360;
    }

    final double sweepAngle = getRadianToDegree(sweepRadian).abs();
    return calculateGradientStops(
        _getGradientOffset(), _axis.isInversed, sweepAngle);
  }

  /// Returns the gradient stop of axis line gradient
  List<double?> _getGradientOffset() {
    if (_range.gradient!.stops != null && _range.gradient!.stops!.isNotEmpty) {
      return _range.gradient!.stops!;
    } else {
      // Calculates the gradient stop values based on the number of provided
      // color
      final double difference = 1 / _range.gradient!.colors.length;
      final List<double?> offsets =
          List<double?>.filled(_range.gradient!.colors.length, null);
      for (int i = 0; i < _range.gradient!.colors.length; i++) {
        offsets[i] = i * difference;
      }

      return offsets;
    }
  }

  /// Renders the range text
  void _renderRangeText(Canvas canvas) {
    double opacity = 1;
    if (_rangeAnimation != null) {
      opacity = _rangeAnimation!.value;
    }

    final Color color = _range.color ?? _gaugeThemeData.rangeColor;
    final Color labelColor =
        _range.labelStyle.color ?? getSaturationColor(color);
    final double actualOpacity = labelColor.opacity;
    final TextSpan span = TextSpan(
        text: _range.label,
        style: TextStyle(
            color: labelColor.withOpacity(actualOpacity * opacity),
            fontSize: _range.labelStyle.fontSize,
            fontFamily: _range.labelStyle.fontFamily,
            fontStyle: _range.labelStyle.fontStyle,
            fontWeight: _range.labelStyle.fontWeight));
    final TextPainter textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout();
    canvas.save();
    canvas.translate(
        _rangeRenderer.labelPosition.dx, _rangeRenderer.labelPosition.dy);
    canvas.rotate(getDegreeToRadian(_rangeRenderer.labelAngle));
    canvas.scale(-1);
    textPainter.paint(
        canvas,
        Offset(-_rangeRenderer.labelSize.width / 2,
            -_rangeRenderer.labelSize.height / 2));
    canvas.restore();
  }
}
