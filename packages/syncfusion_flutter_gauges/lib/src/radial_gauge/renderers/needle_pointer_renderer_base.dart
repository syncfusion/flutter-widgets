import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../common/common.dart';
import '../pointers/needle_pointer.dart';
import '../renderers/gauge_pointer_renderer.dart';
import '../renderers/needle_pointer_renderer.dart';
import '../utils/helper.dart';

/// The [NeedlePointerRenderer] has methods to render needle pointer
class NeedlePointerRendererBase extends GaugePointerRenderer {
  /// Creates the instance for needle pointer renderer
  NeedlePointerRendererBase() : super();

  /// Represents the needle pointer which is corresponding to this renderer
  late NeedlePointer pointer;

  /// Represents the renderer class
  NeedlePointerRenderer? renderer;

  /// Specifies the actual tail length
  double _actualTailLength = 0;

  /// Specifies the actual length of the pointer based on the coordinate unit
  late double _actualNeedleLength;

  /// Specifies the actual knob radius
  late double _actualCapRadius;

  /// Specifies the angle of the needle pointer
  late double angle;

  /// Specifies the radian value of needle pointer
  late double _radian;

  /// Specifies the stop x value
  late double stopX;

  /// Specifies the stop y value
  late double stopY;

  /// Specifies the start left x value
  late double _startLeftX;

  /// Specifies the start left y value
  late double _startLeftY;

  /// Specifies the start right x value
  late double _startRightX;

  /// Specifies the start right y value
  late double _startRightY;

  /// Specifies the stop left x value
  late double _stopLeftX;

  /// Specifies the stop left y value
  late double _stopLeftY;

  /// Specifies the stop right x value
  late double _stopRightX;

  /// Specifies the stop right y value
  late double _stopRightY;

  /// Specifies the start x value
  late double startX;

  /// Specifies the start y value
  late double startY;

  /// Specifies the tail left start x value
  late double _tailLeftStartX;

  /// Specifies the tail left start y value
  late double _tailLeftStartY;

  /// Specifies the tail left end x value
  late double _tailLeftEndX;

  /// Specifies the tail left end y value
  late double _tailLeftEndY;

  /// Specifies the tail right start x value
  late double _tailRightStartX;

  /// Specifies the tail right start y value
  late double _tailRightStartY;

  /// Specifies the tail right end x value
  late double _tailRightEndX;

  /// Specifies the tail right end y value
  late double _tailRightEndY;

  /// Specified the axis center point
  late Offset _centerPoint;

  /// Calculates the needle position
  @override
  void calculatePosition() {
    final NeedlePointer needlePointer = gaugePointer as NeedlePointer;
    _calculateDefaultValue(needlePointer);
    _calculateNeedleOffset(needlePointer);
  }

  /// Calculates the default value
  void _calculateDefaultValue(NeedlePointer needlePointer) {
    _actualNeedleLength = axisRenderer.getActualValue(
        needlePointer.needleLength, needlePointer.lengthUnit, false);
    _actualCapRadius = axisRenderer.getActualValue(
        needlePointer.knobStyle.knobRadius,
        needlePointer.knobStyle.sizeUnit,
        false);
    currentValue = getMinMax(currentValue, axis.minimum, axis.maximum);
    final double currentFactor = (axis.onCreateAxisRenderer != null &&
            axisRenderer.renderer != null &&
            axisRenderer.renderer!.valueToFactor(currentValue) != null)
        ? axisRenderer.renderer!.valueToFactor(currentValue) ??
            axisRenderer.valueToFactor(currentValue)
        : axisRenderer.valueToFactor(currentValue);
    angle = (currentFactor * axisRenderer.sweepAngle) + axis.startAngle;
    _radian = getDegreeToRadian(angle);
    _centerPoint = axisRenderer.axisCenter;
  }

  /// Calculates the needle pointer offset
  void _calculateNeedleOffset(NeedlePointer needlePointer) {
    final double needleRadian = getDegreeToRadian(-90);
    stopX = _actualNeedleLength * math.cos(needleRadian);
    stopY = _actualNeedleLength * math.sin(needleRadian);
    startX = 0;
    startY = 0;

    if (needlePointer.needleEndWidth >= 0) {
      _startLeftX =
          startX - needlePointer.needleEndWidth * math.cos(needleRadian - 90);
      _startLeftY =
          startY - needlePointer.needleEndWidth * math.sin(needleRadian - 90);
      _startRightX =
          startX - needlePointer.needleEndWidth * math.cos(needleRadian + 90);
      _startRightY =
          startY - needlePointer.needleEndWidth * math.sin(needleRadian + 90);
    }

    if (needlePointer.needleStartWidth >= 0) {
      _stopLeftX =
          stopX - needlePointer.needleStartWidth * math.cos(needleRadian - 90);
      _stopLeftY =
          stopY - needlePointer.needleStartWidth * math.sin(needleRadian - 90);
      _stopRightX =
          stopX - needlePointer.needleStartWidth * math.cos(needleRadian + 90);
      _stopRightY =
          stopY - needlePointer.needleStartWidth * math.sin(needleRadian + 90);
    }

    _calculatePointerRect();
    if (needlePointer.tailStyle != null && needlePointer.tailStyle!.width > 0) {
      _calculateTailPosition(needleRadian, needlePointer);
    }
  }

  /// Calculates the needle pointer rect based on
  /// its start and the stop value
  void _calculatePointerRect() {
    double x1 = _centerPoint.dx;
    double x2 = _centerPoint.dx + _actualNeedleLength * math.cos(_radian);
    double y1 = _centerPoint.dy;
    double y2 = _centerPoint.dy + _actualNeedleLength * math.sin(_radian);

    if (x1 > x2) {
      final double temp = x1;
      x1 = x2;
      x2 = temp;
    }

    if (y1 > y2) {
      final double temp = y1;
      y1 = y2;
      y2 = temp;
    }

    if (y2 - y1 < 20) {
      y1 -= 10; // Creates the pointer rect with minimum height
      y2 += 10;
    }

    if (x2 - x1 < 20) {
      x1 -= 10; // Creates the pointer rect with minimum width
      x2 += 10;
    }

    pointerRect = Rect.fromLTRB(x1, y1, x2, y2);
  }

  /// Calculates the values to render the needle tail
  void _calculateTailPosition(
      double needleRadian, NeedlePointer needlePointer) {
    final double pointerWidth = needlePointer.tailStyle!.width;
    _actualTailLength = axisRenderer.getActualValue(
        needlePointer.tailStyle!.length,
        needlePointer.tailStyle!.lengthUnit,
        false);
    if (_actualTailLength > 0) {
      final double tailEndX =
          startX - _actualTailLength * math.cos(needleRadian);
      final double tailEndY =
          startY - _actualTailLength * math.sin(needleRadian);
      _tailLeftStartX = startX - pointerWidth * math.cos(needleRadian - 90);
      _tailLeftStartY = startY - pointerWidth * math.sin(needleRadian - 90);
      _tailRightStartX = startX - pointerWidth * math.cos(needleRadian + 90);
      _tailRightStartY = startY - pointerWidth * math.sin(needleRadian + 90);

      _tailLeftEndX = tailEndX - pointerWidth * math.cos(needleRadian - 90);
      _tailLeftEndY = tailEndY - pointerWidth * math.sin(needleRadian - 90);
      _tailRightEndX = tailEndX - pointerWidth * math.cos(needleRadian + 90);
      _tailRightEndY = tailEndY - pointerWidth * math.sin(needleRadian + 90);
    }
  }

  /// Method to draw pointer the needle pointer.
  ///
  /// By overriding this method, you can draw the customized needled pointer
  /// using required values.
  ///
  void drawPointer(Canvas canvas, PointerPaintingDetails pointerPaintingDetails,
      SfGaugeThemeData gaugeThemeData) {
    final NeedlePointer needlePointer = gaugePointer as NeedlePointer;
    final double pointerRadian =
        getDegreeToRadian(pointerPaintingDetails.pointerAngle);
    if (_actualNeedleLength > 0) {
      _renderNeedle(canvas, pointerRadian, gaugeThemeData, needlePointer);
    }
    if (_actualTailLength > 0) {
      _renderTail(canvas, pointerRadian, gaugeThemeData, needlePointer);
    }
    _renderCap(canvas, gaugeThemeData, needlePointer);
  }

  /// To render the needle of the pointer
  void _renderNeedle(Canvas canvas, double pointerRadian,
      SfGaugeThemeData gaugeThemeData, NeedlePointer needlePointer) {
    final Paint paint = Paint()
      ..color = needlePointer.needleColor ?? gaugeThemeData.needleColor
      ..style = PaintingStyle.fill;

    if (renderingDetails.needsToAnimatePointers &&
        axis.minimum == currentValue) {
      final double actualOpacity = paint.color.opacity;
      final double opacity =
          pointerAnimation != null ? pointerAnimation!.value : 1;
      final double colorOpacity =
          opacity * actualOpacity > 1.0 ? 1.0 : opacity * actualOpacity;
      paint.color = paint.color.withOpacity(colorOpacity);
    }

    final Path path = Path();
    path.moveTo(_startLeftX, _startLeftY);
    path.lineTo(_stopLeftX, _stopLeftY);
    path.lineTo(_stopRightX, _stopRightY);
    path.lineTo(_startRightX, _startRightY);
    path.close();

    if (needlePointer.gradient != null) {
      paint.shader = needlePointer.gradient!.createShader(path.getBounds());
    }

    canvas.save();
    canvas.translate(_centerPoint.dx, _centerPoint.dy);
    canvas.rotate(pointerRadian);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  /// To render the tail of the pointer
  void _renderTail(Canvas canvas, double pointerRadian,
      SfGaugeThemeData gaugeThemeData, NeedlePointer needlePointer) {
    final Path tailPath = Path();
    tailPath.moveTo(_tailLeftStartX, _tailLeftStartY);
    tailPath.lineTo(_tailLeftEndX, _tailLeftEndY);
    tailPath.lineTo(_tailRightEndX, _tailRightEndY);
    tailPath.lineTo(_tailRightStartX, _tailRightStartY);
    tailPath.close();

    canvas.save();
    canvas.translate(_centerPoint.dx, _centerPoint.dy);
    canvas.rotate(pointerRadian);

    final Paint tailPaint = Paint()
      ..color = needlePointer.tailStyle!.color ?? gaugeThemeData.tailColor;
    if (needlePointer.tailStyle!.gradient != null) {
      tailPaint.shader =
          needlePointer.tailStyle!.gradient!.createShader(tailPath.getBounds());
    }

    if (renderingDetails.needsToAnimatePointers &&
        axis.minimum == currentValue) {
      final double actualOpacity = tailPaint.color.opacity;
      final double opacity =
          pointerAnimation != null ? pointerAnimation!.value : 1;
      final double colorOpacity =
          opacity * actualOpacity > 1.0 ? 1.0 : opacity * actualOpacity;
      tailPaint.color = tailPaint.color.withOpacity(colorOpacity);
    }

    canvas.drawPath(tailPath, tailPaint);

    if (needlePointer.tailStyle!.borderWidth > 0) {
      final Paint tailStrokePaint = Paint()
        ..color = needlePointer.tailStyle!.borderColor ??
            gaugeThemeData.tailBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = needlePointer.tailStyle!.borderWidth;

      if (renderingDetails.needsToAnimatePointers &&
          axis.minimum == currentValue) {
        final double actualOpacity = tailStrokePaint.color.opacity;
        final double opacity =
            pointerAnimation != null ? pointerAnimation!.value : 1;
        final double colorOpacity =
            opacity * actualOpacity > 1.0 ? 1.0 : opacity * actualOpacity;
        tailStrokePaint.color = tailStrokePaint.color.withOpacity(colorOpacity);
      }

      canvas.drawPath(tailPath, tailStrokePaint);
    }

    canvas.restore();
  }

  /// To render the cap of needle
  void _renderCap(Canvas canvas, SfGaugeThemeData gaugeThemeData,
      NeedlePointer needlePointer) {
    if (_actualCapRadius > 0) {
      final Paint knobPaint = Paint()
        ..color = needlePointer.knobStyle.color ?? gaugeThemeData.knobColor;

      if (renderingDetails.needsToAnimatePointers &&
          axis.minimum == currentValue) {
        final double actualOpacity = knobPaint.color.opacity;
        final double opacity =
            pointerAnimation != null ? pointerAnimation!.value : 1;
        final double colorOpacity =
            opacity * actualOpacity > 1.0 ? 1.0 : opacity * actualOpacity;
        knobPaint.color = knobPaint.color.withOpacity(colorOpacity);
      }

      canvas.drawCircle(axisRenderer.axisCenter, _actualCapRadius, knobPaint);

      if (needlePointer.knobStyle.borderWidth > 0) {
        final double actualBorderWidth = axisRenderer.getActualValue(
            needlePointer.knobStyle.borderWidth,
            needlePointer.knobStyle.sizeUnit,
            false);
        final Paint strokePaint = Paint()
          ..color = needlePointer.knobStyle.borderColor ??
              gaugeThemeData.knobBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = actualBorderWidth;

        if (renderingDetails.needsToAnimatePointers &&
            axis.minimum == currentValue) {
          final double actualOpacity = strokePaint.color.opacity;
          final double opacity =
              pointerAnimation != null ? pointerAnimation!.value : 1;
          final double colorOpacity =
              opacity * actualOpacity > 1.0 ? 1.0 : opacity * actualOpacity;
          strokePaint.color = strokePaint.color.withOpacity(colorOpacity);
        }

        canvas.drawCircle(_centerPoint, _actualCapRadius, strokePaint);
      }
    }
  }
}
