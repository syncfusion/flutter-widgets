import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_core/theme.dart';
import '../common/common.dart';
import '../pointers/marker_pointer.dart';
import '../renderers/gauge_pointer_renderer.dart';
import '../renderers/marker_pointer_renderer.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

///  The [MarkerPointerRenderer] has methods to render marker pointer
///
class MarkerPointerRendererBase extends GaugePointerRenderer {
  /// Creates the instance for marker pointer renderer
  MarkerPointerRendererBase() : super();

  /// Represents the marker pointer which is corresponding to this renderer
  late MarkerPointer pointer;

  /// Represents the marker pointer renderer
  MarkerPointerRenderer? renderer;

  /// Specifies the margin for calculating marker pointer rect
  final double _margin = 15;

  /// Specifies the marker image
  dart_ui.Image? _image;

  /// Specifies the marker offset
  late Offset offset;

  /// Specifies the radian value of the marker
  late double _radian;

  /// Specifies the angle value
  late double angle;

  /// Specifies the marker text size
  Size? _textSize;

  /// Specifies the total offset considering axis element
  late double _totalOffset;

  /// Specifies actual marker offset value
  late double _actualMarkerOffset;

  /// method to calculate the marker position
  @override
  void calculatePosition() {
    final MarkerPointer markerPointer = gaugePointer as MarkerPointer;
    angle = _getPointerAngle();
    _radian = getDegreeToRadian(angle);
    final Offset offset = getMarkerOffset(_radian, markerPointer);
    if (markerPointer.markerType == MarkerType.image &&
        markerPointer.imageUrl != null) {
      _loadImage(markerPointer);
    } else if (markerPointer.markerType == MarkerType.text &&
        markerPointer.text != null) {
      _textSize = getTextSize(markerPointer.text!, markerPointer.textStyle);
    }

    pointerRect = Rect.fromLTRB(
        offset.dx - markerPointer.markerWidth / 2 - _margin,
        offset.dy - markerPointer.markerHeight / 2 - _margin,
        offset.dx + markerPointer.markerWidth / 2 + _margin,
        offset.dy + markerPointer.markerHeight / 2 + _margin);
  }

  /// Method returns the angle of  current pointer value
  double _getPointerAngle() {
    currentValue = getMinMax(currentValue, axis.minimum, axis.maximum);
    final double currentFactor = (axis.onCreateAxisRenderer != null &&
            axisRenderer.renderer != null &&
            axisRenderer.renderer?.valueToFactor(currentValue) != null)
        ? axisRenderer.renderer?.valueToFactor(currentValue) ??
            axisRenderer.valueToFactor(currentValue)
        : axisRenderer.valueToFactor(currentValue);
    return (currentFactor * axisRenderer.sweepAngle) + axis.startAngle;
  }

  /// Calculates the marker offset position
  Offset getMarkerOffset(double markerRadian, MarkerPointer markerPointer) {
    _actualMarkerOffset = axisRenderer.getActualValue(
        markerPointer.markerOffset, markerPointer.offsetUnit, true);
    _totalOffset = _actualMarkerOffset < 0
        ? axisRenderer.getAxisOffset() + _actualMarkerOffset
        : (_actualMarkerOffset + axisRenderer.axisOffset);
    if (!axis.canScaleToFit) {
      final double x = (axisRenderer.axisSize.width / 2) +
          (axisRenderer.radius -
                  _totalOffset -
                  (axisRenderer.actualAxisWidth / 2)) *
              math.cos(markerRadian) -
          axisRenderer.centerX;
      final double y = (axisRenderer.axisSize.height / 2) +
          (axisRenderer.radius -
                  _totalOffset -
                  (axisRenderer.actualAxisWidth / 2)) *
              math.sin(markerRadian) -
          axisRenderer.centerY;
      offset = Offset(x, y);
    } else {
      final double x = axisRenderer.axisCenter.dx +
          (axisRenderer.radius -
                  _totalOffset -
                  (axisRenderer.actualAxisWidth / 2)) *
              math.cos(markerRadian);
      final double y = axisRenderer.axisCenter.dy +
          (axisRenderer.radius -
                  _totalOffset -
                  (axisRenderer.actualAxisWidth / 2)) *
              math.sin(markerRadian);
      offset = Offset(x, y);
    }
    return offset;
  }

  /// To load the image from the image url
// ignore: avoid_void_async
  void _loadImage(MarkerPointer markerPointer) async {
    await _renderImage(markerPointer);
    axisRenderer.renderingDetails.pointerRepaintNotifier.value++;
  }

  /// Renders the image from the image url
// ignore: prefer_void_to_null
  Future<Null> _renderImage(MarkerPointer markerPointer) async {
    final ByteData imageData = await rootBundle.load(markerPointer.imageUrl!);
    final dart_ui.Codec imageCodec =
        await dart_ui.instantiateImageCodec(imageData.buffer.asUint8List());
    final dart_ui.FrameInfo frameInfo = await imageCodec.getNextFrame();
    _image = frameInfo.image;
  }

  /// Method to draw pointer the marker pointer.
  ///
  /// By overriding this method, you can draw the customized marker
  /// pointer using required values.
  ///
  void drawPointer(Canvas canvas, PointerPaintingDetails pointerPaintingDetails,
      SfGaugeThemeData gaugeThemeData) {
    final MarkerPointer markerPointer = gaugePointer as MarkerPointer;
    final bool hideMarker =
        renderingDetails.needsToAnimatePointers && axis.minimum == currentValue;
    final Paint paint = Paint()
      ..color = markerPointer.color ?? gaugeThemeData.markerColor
      ..style = PaintingStyle.fill;
    Color shadowColor = Colors.black;
    if (hideMarker) {
      final double actualOpacity = paint.color.opacity;
      final double opacity =
          pointerAnimation != null ? pointerAnimation!.value : 1;
      paint.color = paint.color.withOpacity(opacity * actualOpacity);
      final double shadowColorOpacity = shadowColor.opacity;
      shadowColor = shadowColor.withOpacity(opacity * shadowColorOpacity);
    }

    Paint? overlayPaint;
    if ((isHovered != null && isHovered!) &&
        markerPointer.overlayColor != Colors.transparent) {
      overlayPaint = Paint()
        ..color = markerPointer.overlayColor ??
            markerPointer.color?.withOpacity(0.12) ??
            gaugeThemeData.markerColor.withOpacity(0.12)
        ..style = PaintingStyle.fill;
      if (hideMarker) {
        final double actualOpacity = overlayPaint.color.opacity;
        final double opacity =
            pointerAnimation != null ? pointerAnimation!.value : 1;
        overlayPaint.color =
            overlayPaint.color.withOpacity(opacity * actualOpacity);
      }
    }

    Paint? borderPaint;
    if (markerPointer.borderWidth > 0) {
      borderPaint = Paint()
        ..color = markerPointer.borderColor ?? gaugeThemeData.markerBorderColor
        ..strokeWidth = markerPointer.borderWidth
        ..style = PaintingStyle.stroke;

      if (hideMarker) {
        final double actualOpacity = borderPaint.color.opacity;
        final double opacity = pointerAnimation!.value;
        borderPaint.color =
            borderPaint.color.withOpacity(opacity * actualOpacity);
      }
    }
    canvas.save();
    switch (markerPointer.markerType) {
      case MarkerType.circle:
        _drawCircle(canvas, paint, pointerPaintingDetails.startOffset,
            borderPaint, overlayPaint, markerPointer, shadowColor);
        break;
      case MarkerType.rectangle:
        _drawRectangle(
            canvas,
            paint,
            pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle,
            borderPaint,
            overlayPaint,
            markerPointer,
            shadowColor);
        break;
      case MarkerType.image:
        _drawMarkerImage(canvas, paint, pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle, markerPointer);
        break;
      case MarkerType.triangle:
      case MarkerType.invertedTriangle:
        _drawTriangle(
            canvas,
            paint,
            pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle,
            borderPaint,
            overlayPaint,
            markerPointer,
            shadowColor);
        break;
      case MarkerType.diamond:
        _drawDiamond(
            canvas,
            paint,
            pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle,
            borderPaint,
            overlayPaint,
            markerPointer,
            shadowColor);
        break;
      case MarkerType.text:
        if (markerPointer.text != null) {
          _drawText(
              canvas,
              paint,
              pointerPaintingDetails.startOffset,
              pointerPaintingDetails.pointerAngle,
              gaugeThemeData,
              markerPointer);
        }

        break;
    }

    canvas.restore();
  }

  /// To render the MarkerShape.Text
  void _drawText(
      Canvas canvas,
      Paint paint,
      Offset startPosition,
      double pointerAngle,
      SfGaugeThemeData gaugeThemeData,
      MarkerPointer markerPointer) {
    Color labelColor =
        markerPointer.textStyle.color ?? gaugeThemeData.axisLabelColor;
    if (renderingDetails.needsToAnimatePointers &&
        renderingDetails.isOpacityAnimation &&
        axis.minimum == currentValue) {
      final double actualOpacity = labelColor.opacity;
      final double opacity =
          pointerAnimation != null ? pointerAnimation!.value : 1;
      labelColor = labelColor.withOpacity(opacity * actualOpacity);
    }

    final TextSpan span = TextSpan(
        text: markerPointer.text,
        style: TextStyle(
            color: labelColor,
            fontSize: markerPointer.textStyle.fontSize,
            fontFamily: markerPointer.textStyle.fontFamily,
            fontStyle: markerPointer.textStyle.fontStyle,
            fontWeight: markerPointer.textStyle.fontWeight));
    final TextPainter textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout();
    canvas.save();
    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(getDegreeToRadian(pointerAngle - 90));
    canvas.scale(-1);
    textPainter.paint(
        canvas, Offset(-_textSize!.width / 2, -_textSize!.height / 2));
    canvas.restore();
  }

  /// Renders the MarkerShape.circle
  void _drawCircle(
      Canvas canvas,
      Paint paint,
      Offset startPosition,
      Paint? borderPaint,
      Paint? overlayPaint,
      MarkerPointer markerPointer,
      Color shadowColor) {
    final Rect rect = Rect.fromLTRB(
        startPosition.dx - markerPointer.markerWidth / 2,
        startPosition.dy - markerPointer.markerHeight / 2,
        startPosition.dx + markerPointer.markerWidth / 2,
        startPosition.dy + markerPointer.markerHeight / 2);
    final double overlayRadius = markerPointer.overlayRadius ?? 15;
    Rect overlayRect;
    if (markerPointer.overlayRadius != null) {
      overlayRect = Rect.fromLTRB(
          startPosition.dx - overlayRadius,
          startPosition.dy - overlayRadius,
          startPosition.dx + overlayRadius,
          startPosition.dy + overlayRadius);
    } else {
      overlayRect = Rect.fromLTRB(
          rect.left - overlayRadius,
          rect.top - overlayRadius,
          rect.right + overlayRadius,
          rect.bottom + overlayRadius);
    }

    if (overlayPaint != null) {
      canvas.drawOval(overlayRect, overlayPaint);
    }

    if (markerPointer.elevation >= 0) {
      final Path path = Path();
      path.addOval(rect);
      canvas.drawShadow(path, shadowColor, markerPointer.elevation, true);
    }
    canvas.drawOval(rect, paint);
    if (borderPaint != null) {
      canvas.drawOval(rect, borderPaint);
    }
  }

  /// Renders the MarkerShape.rectangle
  void _drawRectangle(
      Canvas canvas,
      Paint paint,
      Offset startPosition,
      double pointerAngle,
      Paint? borderPaint,
      Paint? overlayPaint,
      MarkerPointer markerPointer,
      Color shadowColor) {
    final Rect rect = Rect.fromLTRB(
        -markerPointer.markerWidth / 2,
        -markerPointer.markerHeight / 2,
        markerPointer.markerWidth / 2,
        markerPointer.markerHeight / 2);
    final double overlayRadius = markerPointer.overlayRadius ?? 15;
    Rect overlayRect;
    if (markerPointer.overlayRadius != null) {
      overlayRect = Rect.fromLTRB(
          -overlayRadius, -overlayRadius, overlayRadius, overlayRadius);
    } else {
      overlayRect = Rect.fromLTRB(
          rect.left - overlayRadius,
          rect.top - overlayRadius,
          rect.right + overlayRadius,
          rect.bottom + overlayRadius);
    }

    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(getDegreeToRadian(pointerAngle));
    if (overlayPaint != null) {
      canvas.drawRect(overlayRect, overlayPaint);
    }

    if (markerPointer.elevation >= 0) {
      final Path path = Path();
      path.addRect(rect);
      canvas.drawShadow(path, shadowColor, markerPointer.elevation, true);
    }

    canvas.drawRect(rect, paint);
    if (borderPaint != null) {
      canvas.drawRect(rect, borderPaint);
    }
  }

  /// Renders the MarkerShape.image
  void _drawMarkerImage(Canvas canvas, Paint paint, Offset startPosition,
      double pointerAngle, MarkerPointer markerPointer) {
    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(getDegreeToRadian(pointerAngle + 90));
    final Rect rect = Rect.fromLTRB(
        -markerPointer.markerWidth / 2,
        -markerPointer.markerHeight / 2,
        markerPointer.markerWidth / 2,
        markerPointer.markerHeight / 2);
    if (_image != null) {
      canvas.drawImageNine(_image!, rect, rect, paint);
    }
  }

  /// Renders the MarkerShape.diamond
  void _drawDiamond(
      Canvas canvas,
      Paint paint,
      Offset startPosition,
      double pointerAngle,
      Paint? borderPaint,
      Paint? overlayPaint,
      MarkerPointer markerPointer,
      Color shadowColor) {
    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(getDegreeToRadian(pointerAngle - 90));
    final Path path = Path();
    path.moveTo(-markerPointer.markerWidth / 2, 0);
    path.lineTo(0, markerPointer.markerHeight / 2);
    path.lineTo(markerPointer.markerWidth / 2, 0);
    path.lineTo(0, -markerPointer.markerHeight / 2);
    path.lineTo(-markerPointer.markerWidth / 2, 0);
    path.close();

    if (overlayPaint != null) {
      final double overlayRadius = markerPointer.overlayRadius ?? 30;
      final Path overlayPath = Path();
      if (markerPointer.overlayRadius != null) {
        overlayPath.moveTo(-overlayRadius, 0);
        overlayPath.lineTo(0, overlayRadius);
        overlayPath.lineTo(overlayRadius, 0);
        overlayPath.lineTo(0, -overlayRadius);
        overlayPath.lineTo(-overlayRadius, 0);
      } else {
        overlayPath.moveTo(
            -((markerPointer.markerWidth + overlayRadius) / 2), 0);
        overlayPath.lineTo(
            0, ((markerPointer.markerHeight + overlayRadius) / 2));
        overlayPath.lineTo(
            ((markerPointer.markerWidth + overlayRadius) / 2), 0);
        overlayPath.lineTo(
            0, -((markerPointer.markerHeight + overlayRadius) / 2));
        overlayPath.lineTo(
            -((markerPointer.markerWidth + overlayRadius) / 2), 0);
      }

      overlayPath.close();
      canvas.drawPath(overlayPath, overlayPaint);
    }
    if (markerPointer.elevation >= 0) {
      canvas.drawShadow(path, shadowColor, markerPointer.elevation, true);
    }

    canvas.drawPath(path, paint);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
  }

  /// Renders the triangle and the inverted triangle
  void _drawTriangle(
      Canvas canvas,
      Paint paint,
      Offset startPosition,
      double pointerAngle,
      Paint? borderPaint,
      Paint? overlayPaint,
      MarkerPointer markerPointer,
      Color shadowColor) {
    canvas.translate(startPosition.dx, startPosition.dy);
    final double triangleAngle = markerPointer.markerType == MarkerType.triangle
        ? pointerAngle + 90
        : pointerAngle - 90;
    canvas.rotate(getDegreeToRadian(triangleAngle));

    final Path path = Path();
    path.moveTo(-markerPointer.markerWidth / 2, markerPointer.markerHeight / 2);
    path.lineTo(markerPointer.markerWidth / 2, markerPointer.markerHeight / 2);
    path.lineTo(0, -markerPointer.markerHeight / 2);
    path.lineTo(-markerPointer.markerWidth / 2, markerPointer.markerHeight / 2);
    path.close();
    if (overlayPaint != null) {
      final double overlayRadius = markerPointer.overlayRadius ?? 30;
      final Path overlayPath = Path();
      if (markerPointer.overlayRadius != null) {
        overlayPath.moveTo(-overlayRadius, overlayRadius);
        overlayPath.lineTo(overlayRadius, overlayRadius);
        overlayPath.lineTo(0, -overlayRadius);
        overlayPath.lineTo(-overlayRadius, overlayRadius);
      } else {
        overlayPath.moveTo(-((markerPointer.markerWidth + overlayRadius) / 2),
            (markerPointer.markerHeight + overlayRadius) / 2);
        overlayPath.lineTo(((markerPointer.markerWidth + overlayRadius) / 2),
            ((markerPointer.markerHeight + overlayRadius) / 2));
        overlayPath.lineTo(
            0, -((markerPointer.markerHeight + overlayRadius) / 2));
        overlayPath.lineTo(-((markerPointer.markerWidth + overlayRadius) / 2),
            ((markerPointer.markerHeight + overlayRadius) / 2));
      }

      overlayPath.close();
      canvas.drawPath(overlayPath, overlayPaint);
    }

    if (markerPointer.elevation >= 0) {
      canvas.drawShadow(path, shadowColor, markerPointer.elevation, true);
    }

    canvas.drawPath(path, paint);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
  }
}
