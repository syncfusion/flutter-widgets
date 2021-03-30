import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/foundation.dart';
import '../axis/radial_axis.dart';
import '../common/axis_label.dart';
import '../common/radial_gauge_renderer.dart';
import '../gauge/radial_gauge.dart';
import '../renderers/radial_axis_renderer_base.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Custom painter to paint gauge axis
class AxisPainter extends CustomPainter {
  /// Creates the painter for axis pointer
  ///
  AxisPainter(
      this._gauge,
      this._axis,
      this._isRepaint,
      ValueNotifier<num> notifier,
      this._axisLineAnimation,
      this._axisElementsAnimation,
      this._gaugeThemeData,
      this._renderingDetails,
      this._axisRenderer)
      : super(repaint: notifier);

  /// Specifies the circular gauge
  final SfRadialGauge _gauge;

  /// Specifies whether to repaint the series
  final bool _isRepaint;

  /// Specifies the axis of the painter
  final RadialAxis _axis;

  /// Specifies the animation for axis line
  final Animation<double>? _axisLineAnimation;

  /// Specifies the animation for axis elements
  final Animation<double>? _axisElementsAnimation;

  /// Specifies the gauge theme data.
  final SfGaugeThemeData _gaugeThemeData;

  /// Holds the radial gauge rendering details
  final RenderingDetails _renderingDetails;

  /// Holds the radial axis renderer
  final RadialAxisRendererBase _axisRenderer;

  @override
  void paint(Canvas canvas, Size size) {
    if (_axis.backgroundImage != null &&
        _axisRenderer.backgroundImageInfo != null) {
      double radius;
      Rect rect;
      if (!_axis.canScaleToFit) {
        radius = math.min(
                _axisRenderer.axisSize.width, _axisRenderer.axisSize.height) /
            2;
        rect = Rect.fromLTRB(
            _axisRenderer.axisSize.width / 2 - radius - _axisRenderer.centerX,
            _axisRenderer.axisSize.height / 2 - radius - _axisRenderer.centerY,
            _axisRenderer.axisSize.width / 2 + radius - _axisRenderer.centerX,
            _axisRenderer.axisSize.height / 2 + radius - _axisRenderer.centerY);
      } else {
        radius = _axisRenderer.radius;
        rect = Rect.fromLTRB(
            _axisRenderer.axisCenter.dx - radius,
            _axisRenderer.axisCenter.dy - radius,
            _axisRenderer.axisCenter.dx + radius,
            _axisRenderer.axisCenter.dx + radius);
      }

      // Draws the background image of axis
      paintImage(
        canvas: canvas,
        rect: rect,
        scale: _axisRenderer.backgroundImageInfo!.scale,
        image: _axisRenderer.backgroundImageInfo!.image,
        fit: BoxFit.fill,
      );
    }

    if (_axis.showAxisLine && _axisRenderer.actualAxisWidth > 0) {
      _drawAxisLine(canvas);
    }

    if (_axis.showTicks) {
      _drawMajorTicks(canvas);
      _drawMinorTicks(canvas);
    }

    if (_axis.showLabels) {
      _drawAxisLabels(canvas);
    }

    if (_gauge.axes[_gauge.axes.length - 1] == _axis &&
        _renderingDetails.needsToAnimateAxes &&
        _getHasAxisLineAnimation() &&
        _getHasAxisElementsAnimation()) {
      _renderingDetails.needsToAnimateAxes = false;
    }
  }

  /// Checks whether the show axis line is enabled
  bool _getHasAxisLineAnimation() {
    return (_axisLineAnimation != null && _axisLineAnimation!.value == 1) ||
        _axisLineAnimation == null;
  }

  /// Checks whether the labels and the ticks are enabled
  bool _getHasAxisElementsAnimation() {
    return (_axisElementsAnimation != null &&
            _axisElementsAnimation!.value == 1) ||
        _axisElementsAnimation == null;
  }

  /// Method to draw the axis line
  void _drawAxisLine(Canvas canvas) {
    // whether the dash array is enabled for axis.
    final bool isDashedAxisLine = _getIsDashedLine();
    SweepGradient? gradient;
    if (_axis.axisLineStyle.gradient != null &&
        _axis.axisLineStyle.gradient!.colors.isNotEmpty) {
      gradient = SweepGradient(
          stops: calculateGradientStops(
              _getGradientOffset(), _axis.isInversed, _axisRenderer.sweepAngle),
          colors: _axis.isInversed
              ? _axis.axisLineStyle.gradient!.colors.reversed.toList()
              : _axis.axisLineStyle.gradient!.colors);
    }
    if (_axis.axisLineStyle.cornerStyle == CornerStyle.bothFlat ||
        isDashedAxisLine) {
      _drawAxisPath(canvas, _axisRenderer.startRadian, _axisRenderer.endRadian,
          gradient, isDashedAxisLine);
    } else {
      _drawAxisPath(canvas, _axisRenderer.startCornerRadian,
          _axisRenderer.sweepCornerRadian, gradient, isDashedAxisLine);
    }
  }

  /// Returns the gradient stop of axis line gradient
  List<double?> _getGradientOffset() {
    if (_axis.axisLineStyle.gradient!.stops != null &&
        _axis.axisLineStyle.gradient!.stops!.isNotEmpty) {
      return _axis.axisLineStyle.gradient!.stops!;
    } else {
      // Calculates the gradient stop values based on the provided color
      final double difference = 1 / _axis.axisLineStyle.gradient!.colors.length;
      final List<double?> offsets = List<double?>.filled(
          _axis.axisLineStyle.gradient!.colors.length, null);
      for (int i = 0; i < _axis.axisLineStyle.gradient!.colors.length; i++) {
        offsets[i] = i * difference;
      }

      return offsets;
    }
  }

  /// Method to draw axis line
  void _drawAxisPath(Canvas canvas, double startRadian, double endRadian,
      SweepGradient? gradient, bool isDashedAxisLine) {
    if (_axisLineAnimation != null) {
      endRadian = endRadian * _axisLineAnimation!.value;
    }

    canvas.save();
    canvas.translate(_axisRenderer.axisCenter.dx, _axisRenderer.axisCenter.dy);
    canvas.rotate(_axis.isInversed
        ? getDegreeToRadian(_axis.startAngle + _axisRenderer.sweepAngle)
        : getDegreeToRadian(_axis.startAngle));

    Path path = Path();
    //whether the style of paint is fill
    bool isFill = false;
    if (_axis.axisLineStyle.cornerStyle != CornerStyle.bothFlat) {
      if (isDashedAxisLine) {
        path = _getPath(endRadian, isFill);
      } else {
        isFill = true;
        final double outerRadius =
            _axisRenderer.radius - _axisRenderer.axisOffset;
        final double innerRadius = outerRadius - _axisRenderer.actualAxisWidth;

        // Adds the rounded corner at start of axis line
        if (_axis.axisLineStyle.cornerStyle == CornerStyle.startCurve ||
            _axis.axisLineStyle.cornerStyle == CornerStyle.bothCurve) {
          _drawStartCurve(path, endRadian, innerRadius, outerRadius);
        }

        path.addArc(
            Rect.fromCircle(center: const Offset(0, 0), radius: outerRadius),
            _axisRenderer.startCornerRadian,
            endRadian);

        // Adds the rounded corner at end of axis line
        if (_axis.axisLineStyle.cornerStyle == CornerStyle.endCurve ||
            _axis.axisLineStyle.cornerStyle == CornerStyle.bothCurve) {
          _drawEndCurve(path, endRadian, innerRadius, outerRadius);
        }
        path.arcTo(
            Rect.fromCircle(center: const Offset(0, 0), radius: innerRadius),
            endRadian + _axisRenderer.startCornerRadian,
            -endRadian,
            false);
      }
    } else {
      path = _getPath(endRadian, isFill);
    }

    _renderPath(isDashedAxisLine, path, canvas, gradient, isFill);
  }

  // Method to render the path
  void _renderPath(bool isDashedAxisLine, Path path, Canvas canvas,
      SweepGradient? gradient, bool isFill) {
    final Paint paint = _getPaint(gradient, isFill);
    if (!isDashedAxisLine) {
      canvas.drawPath(path, paint);
    } else {
      if (_axis.axisLineStyle.dashArray != null) {
        canvas.drawPath(
            dashPath(path,
                dashArray: CircularIntervalList<double>(
                    _axis.axisLineStyle.dashArray!)),
            paint);
      }
    }

    canvas.restore();
  }

  /// Returns the axis path
  Path _getPath(double endRadian, bool isFill) {
    final Path path = Path();
    isFill = false;
    if (_axis.isInversed) {
      endRadian = endRadian * -1;
    }

    path.addArc(_axisRenderer.axisRect, 0, endRadian);
    return path;
  }

  Paint _getPaint(SweepGradient? gradient, bool isFill) {
    final Paint paint = Paint()
      ..color = _axis.axisLineStyle.color ?? _gaugeThemeData.axisLineColor
      ..style = !isFill ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = _axisRenderer.actualAxisWidth;
    if (gradient != null) {
      paint.shader = gradient.createShader(_axisRenderer.axisRect);
    }

    return paint;
  }

  /// Draws the start corner style
  void _drawStartCurve(
      Path path, double endRadian, double innerRadius, double outerRadius) {
    final Offset midPoint = getDegreeToPoint(
        _axis.isInversed
            ? -_axisRenderer.cornerAngle
            : _axisRenderer.cornerAngle,
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
        _axis.axisLineStyle.cornerStyle == CornerStyle.bothCurve
            ? _axisRenderer.cornerAngle
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

  /// Checks whether the axis line is dashed line
  bool _getIsDashedLine() {
    return _axis.axisLineStyle.dashArray != null &&
        _axis.axisLineStyle.dashArray!.isNotEmpty &&
        _axis.axisLineStyle.dashArray!.length > 1 &&
        _axis.axisLineStyle.dashArray![0] > 0 &&
        _axis.axisLineStyle.dashArray![1] > 0;
  }

  /// Method to draw the major ticks
  void _drawMajorTicks(Canvas canvas) {
    double length = _axisRenderer.majorTickOffsets.length.toDouble();
    if (_axisElementsAnimation != null) {
      length =
          _axisRenderer.majorTickOffsets.length * _axisElementsAnimation!.value;
    }

    if (_axisRenderer.actualMajorTickLength > 0 &&
        _axis.majorTickStyle.thickness > 0) {
      final Paint tickPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _axis.majorTickStyle.thickness;
      for (int i = 0; i < length; i++) {
        final TickOffset tickOffset = _axisRenderer.majorTickOffsets[i];
        if (!(i == 0 && _axisRenderer.sweepAngle == 360)) {
          tickPaint.color = _axis.useRangeColorForAxis
              ? _axisRenderer.getRangeColor(
                      tickOffset.value, _gaugeThemeData) ??
                  _axis.majorTickStyle.color ??
                  _gaugeThemeData.majorTickColor
              : _axis.majorTickStyle.color ?? _gaugeThemeData.majorTickColor;

          if (_axis.majorTickStyle.dashArray != null &&
              _axis.majorTickStyle.dashArray!.isNotEmpty) {
            final Path path = Path()
              ..moveTo(tickOffset.startPoint.dx, tickOffset.startPoint.dy)
              ..lineTo(tickOffset.endPoint.dx, tickOffset.endPoint.dy);
            canvas.drawPath(
                dashPath(path,
                    dashArray: CircularIntervalList<double>(
                        _axis.majorTickStyle.dashArray!)),
                tickPaint);
          } else {
            if ((i == _axisRenderer.majorTickOffsets.length - 1) &&
                _axisRenderer.sweepAngle == 360) {
              // Reposition the last tick when its sweep angle is 360
              final double x1 =
                  (_axisRenderer.majorTickOffsets[0].startPoint.dx +
                          _axisRenderer.majorTickOffsets[i].startPoint.dx) /
                      2;
              final double y1 =
                  (_axisRenderer.majorTickOffsets[0].startPoint.dy +
                          _axisRenderer.majorTickOffsets[i].startPoint.dy) /
                      2;
              final double x2 = (_axisRenderer.majorTickOffsets[0].endPoint.dx +
                      _axisRenderer.majorTickOffsets[i].endPoint.dx) /
                  2;
              final double y2 = (_axisRenderer.majorTickOffsets[0].endPoint.dy +
                      _axisRenderer.majorTickOffsets[i].endPoint.dy) /
                  2;
              canvas.drawLine(Offset(x1, y1), Offset(x2, y2), tickPaint);
            } else {
              canvas.drawLine(
                  tickOffset.startPoint, tickOffset.endPoint, tickPaint);
            }
          }
        }
      }
    }
  }

  /// Method to draw the mior ticks
  void _drawMinorTicks(Canvas canvas) {
    double length = _axisRenderer.minorTickOffsets.length.toDouble();
    if (_axisElementsAnimation != null) {
      length =
          _axisRenderer.minorTickOffsets.length * _axisElementsAnimation!.value;
    }
    if (_axisRenderer.actualMinorTickLength > 0 &&
        _axis.minorTickStyle.thickness > 0) {
      final Paint tickPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _axis.minorTickStyle.thickness;
      for (int i = 0; i < length; i++) {
        final TickOffset tickOffset = _axisRenderer.minorTickOffsets[i];
        tickPaint.color = _axis.useRangeColorForAxis
            ? _axisRenderer.getRangeColor(tickOffset.value, _gaugeThemeData) ??
                _axis.minorTickStyle.color ??
                _gaugeThemeData.minorTickColor
            : _axis.minorTickStyle.color ?? _gaugeThemeData.minorTickColor;
        if (_axis.minorTickStyle.dashArray != null &&
            _axis.minorTickStyle.dashArray!.isNotEmpty) {
          final Path path = Path()
            ..moveTo(tickOffset.startPoint.dx, tickOffset.startPoint.dy)
            ..lineTo(tickOffset.endPoint.dx, tickOffset.endPoint.dy);
          canvas.drawPath(
              dashPath(path,
                  dashArray: CircularIntervalList<double>(
                      _axis.minorTickStyle.dashArray!)),
              tickPaint);
        } else {
          canvas.drawLine(
              tickOffset.startPoint, tickOffset.endPoint, tickPaint);
        }
      }
    }
  }

  /// Method to draw the axis labels
  void _drawAxisLabels(Canvas canvas) {
    double length = _axisRenderer.axisLabels!.length.toDouble();
    if (_axisElementsAnimation != null) {
      length = _axisRenderer.axisLabels!.length * _axisElementsAnimation!.value;
    }
    for (int i = 0; i < length; i++) {
      if (!((i == 0 && !_axis.showFirstLabel) ||
          (i == _axisRenderer.axisLabels!.length - 1 &&
              !_axis.showLastLabel &&
              _axisRenderer.isMaxiumValueIncluded))) {
        final CircularAxisLabel label = _axisRenderer.axisLabels![i];
        final Color labelColor =
            label.labelStyle.color ?? _gaugeThemeData.axisLabelColor;
        final TextSpan span = TextSpan(
            text: label.text,
            style: TextStyle(
                color: _axis.ranges != null &&
                        _axis.ranges!.isNotEmpty &&
                        _axis.useRangeColorForAxis
                    ? _axisRenderer.getRangeColor(
                            label.value, _gaugeThemeData) ??
                        labelColor
                    : labelColor,
                fontSize: label.labelStyle.fontSize,
                fontFamily: label.labelStyle.fontFamily,
                fontStyle: label.labelStyle.fontStyle,
                fontWeight: label.labelStyle.fontWeight));

        final TextPainter textPainter = TextPainter(
            text: span,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center);
        textPainter.layout();
        _renderText(canvas, textPainter, label);
      }
    }
  }

  // Methods to render the range label
  void _renderText(
      Canvas canvas, TextPainter textPainter, CircularAxisLabel label) {
    if (_axis.canRotateLabels || label.needsRotateLabel) {
      canvas.save();
      canvas.translate(label.position.dx, label.position.dy);
      // Rotates the labels to its calculated angle
      canvas.rotate(getDegreeToRadian(label.angle));
      canvas.scale(-1);
      textPainter.paint(canvas,
          Offset(-label.labelSize.width / 2, -label.labelSize.height / 2));
      canvas.restore();
    } else {
      textPainter.paint(
          canvas,
          Offset(label.position.dx - label.labelSize.width / 2,
              label.position.dy - label.labelSize.height / 2));
    }
  }

  @override
  bool shouldRepaint(AxisPainter oldDelegate) => _isRepaint;
}
