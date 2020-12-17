import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'render_slider_base.dart';

/// Base class for [SfSlider], [SfRangeSlider] and [SfRangeSelector] track
/// shapes.
class SfTrackShape {
  /// Enables subclasses to provide constant constructors.
  const SfTrackShape();

  /// Returns the size based on the values passed to it.
  Rect getPreferredRect(
      RenderBox parentBox, SfSliderThemeData themeData, Offset offset,
      {bool isActive}) {
    final double maxRadius = math.max(themeData.overlayRadius,
        math.max(themeData.thumbRadius, themeData.tickSize.width / 2));
    final double maxTrackHeight =
        math.max(themeData.activeTrackHeight, themeData.inactiveTrackHeight);
    final double left = offset.dx + maxRadius;
    double top = offset.dy;
    if (isActive != null) {
      top += isActive
          ? (maxTrackHeight - themeData.activeTrackHeight) / 2
          : (maxTrackHeight - themeData.inactiveTrackHeight) / 2;
    }
    final double right = left + parentBox.size.width - (2 * maxRadius);
    final double bottom = top +
        (isActive == null
            ? maxTrackHeight
            : (isActive
                ? themeData.activeTrackHeight
                : themeData.inactiveTrackHeight));
    return Rect.fromLTRB(
        math.min(left, right), top, math.max(left, right), bottom);
  }

  /// Paints the track based on the values passed to it.
  void paint(
    PaintingContext context,
    Offset offset,
    Offset thumbCenter,
    Offset startThumbCenter,
    Offset endThumbCenter, {
    RenderBox parentBox,
    SfSliderThemeData themeData,
    SfRangeValues currentValues,
    dynamic currentValue,
    Animation<double> enableAnimation,
    Paint inactivePaint,
    Paint activePaint,
    TextDirection textDirection,
  }) {
    final Radius radius = Radius.circular(themeData.trackCornerRadius);
    final Rect inactiveTrackRect =
        getPreferredRect(parentBox, themeData, offset, isActive: false);
    final Rect activeTrackRect =
        getPreferredRect(parentBox, themeData, offset, isActive: true);

    if (inactivePaint == null) {
      inactivePaint = Paint();
      final ColorTween inactiveTrackColorTween = ColorTween(
          begin: themeData.disabledInactiveTrackColor,
          end: themeData.inactiveTrackColor);
      inactivePaint.color = inactiveTrackColorTween.evaluate(enableAnimation);
    }

    if (activePaint == null) {
      activePaint = Paint();
      final ColorTween activeTrackColorTween = ColorTween(
          begin: themeData.disabledActiveTrackColor,
          end: themeData.activeTrackColor);
      activePaint.color = activeTrackColorTween.evaluate(enableAnimation);
    }

    _drawTrackRect(
        textDirection,
        thumbCenter,
        startThumbCenter,
        endThumbCenter,
        activePaint,
        inactivePaint,
        inactiveTrackRect,
        radius,
        context,
        activeTrackRect);
  }

  void _drawTrackRect(
      TextDirection textDirection,
      Offset thumbCenter,
      Offset startThumbCenter,
      Offset endThumbCenter,
      Paint activePaint,
      Paint inactivePaint,
      Rect inactiveTrackRect,
      Radius radius,
      PaintingContext context,
      Rect activeTrackRect) {
    Offset leftThumbCenter;
    Offset rightThumbCenter;
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    Rect leftTrackRect;
    Rect rightTrackRect;
    if (textDirection == TextDirection.rtl) {
      if (thumbCenter == null) {
        // For range slider and range selector widget.
        leftThumbCenter = endThumbCenter;
        rightThumbCenter = startThumbCenter;
      } else {
        // For slider widget.
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        leftTrackRect = inactiveTrackRect;
        rightTrackRect = activeTrackRect;
      }
    } else {
      if (thumbCenter == null) {
        // For range slider and range selector widget.
        leftThumbCenter = startThumbCenter;
        rightThumbCenter = endThumbCenter;
      } else {
        // For slider widget.
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        leftTrackRect = activeTrackRect;
        rightTrackRect = inactiveTrackRect;
      }
    }

    if (thumbCenter == null) {
      // Drawing range slider track.
      _drawRangeSliderTrack(inactiveTrackRect, leftThumbCenter, radius, context,
          inactivePaint, activeTrackRect, rightThumbCenter, activePaint);
    } else {
      // Drawing slider track.
      _drawSliderTrack(leftTrackRect, thumbCenter, radius, context,
          leftTrackPaint, rightTrackRect, rightTrackPaint);
    }
  }

  void _drawSliderTrack(
      Rect activeTrackRect,
      Offset thumbCenter,
      Radius radius,
      PaintingContext context,
      Paint activePaint,
      Rect inactiveTrackRect,
      Paint inactivePaint) {
    RRect inactiveTrackRRect;
    // Drawing active track.
    Rect trackRect = Rect.fromLTRB(activeTrackRect.left, activeTrackRect.top,
        thumbCenter.dx, activeTrackRect.bottom);
    final RRect activeTrackRRect = RRect.fromRectAndCorners(trackRect,
        topLeft: radius, bottomLeft: radius);
    context.canvas.drawRRect(activeTrackRRect, activePaint);

    // Drawing inactive track.
    trackRect = Rect.fromLTRB(
        thumbCenter.dx,
        inactiveTrackRect.top,
        inactiveTrackRect.width + inactiveTrackRect.left,
        inactiveTrackRect.bottom);
    inactiveTrackRRect = RRect.fromRectAndCorners(trackRect,
        topLeft: Radius.zero,
        topRight: radius,
        bottomLeft: Radius.zero,
        bottomRight: radius);
    context.canvas.drawRRect(inactiveTrackRRect, inactivePaint);
  }

  void _drawRangeSliderTrack(
      Rect inactiveTrackRect,
      Offset startThumbCenter,
      Radius radius,
      PaintingContext context,
      Paint inactivePaint,
      Rect activeTrackRect,
      Offset endThumbCenter,
      Paint activePaint) {
    RRect inactiveTrackRRect;
    // Drawing inactive track.
    Rect trackRect = Rect.fromLTRB(inactiveTrackRect.left,
        inactiveTrackRect.top, startThumbCenter.dx, inactiveTrackRect.bottom);
    inactiveTrackRRect = RRect.fromRectAndCorners(trackRect,
        topLeft: radius, bottomLeft: radius);
    context.canvas.drawRRect(inactiveTrackRRect, inactivePaint);

    // Drawing active track.
    final Rect activeTrackRRect = Rect.fromLTRB(startThumbCenter.dx,
        activeTrackRect.top, endThumbCenter.dx, activeTrackRect.bottom);
    context.canvas.drawRect(activeTrackRRect, activePaint);

    // Drawing inactive track.
    trackRect = Rect.fromLTRB(
        endThumbCenter.dx,
        inactiveTrackRect.top,
        inactiveTrackRect.width + inactiveTrackRect.left,
        inactiveTrackRect.bottom);
    inactiveTrackRRect = RRect.fromRectAndCorners(trackRect,
        topLeft: Radius.zero,
        topRight: radius,
        bottomLeft: Radius.zero,
        bottomRight: radius);
    context.canvas.drawRRect(inactiveTrackRRect, inactivePaint);
  }
}

/// Base class for [SfSlider], [SfRangeSlider] and [SfRangeSelector] thumb
/// shapes.
class SfThumbShape {
  /// Enables subclasses to provide constant constructors.
  const SfThumbShape();

  bool _isThumbOverlap(RenderBaseSlider parentBox) {
    return parentBox.showOverlappingThumbStroke;
  }

  /// Returns the size based on the values passed to it.
  Size getPreferredSize(SfSliderThemeData themeData) {
    return Size.fromRadius(themeData.thumbRadius);
  }

  /// Paints the thumb based on the values passed to it.
  void paint(PaintingContext context, Offset center,
      {RenderBox parentBox,
      RenderBox child,
      SfSliderThemeData themeData,
      SfRangeValues currentValues,
      dynamic currentValue,
      Paint paint,
      Animation<double> enableAnimation,
      TextDirection textDirection,
      SfThumb thumb}) {
    final double radius = getPreferredSize(themeData).width / 2;
    final bool isThumbStroke = themeData.thumbStrokeColor != null &&
        themeData.thumbStrokeColor != Colors.transparent &&
        themeData.thumbStrokeWidth != null &&
        themeData.thumbStrokeWidth > 0;

    final bool showThumbShadow = themeData.thumbColor != Colors.transparent;
    final RenderBaseSlider parentRenderBox = parentBox;
    if (showThumbShadow) {
      final Path path = Path();
      final bool isThumbActive =
          (parentRenderBox.activeThumb == thumb || thumb == null) &&
              parentRenderBox.currentPointerType != null &&
              parentRenderBox.currentPointerType != PointerType.up;
      path.addOval(
          Rect.fromCircle(center: center, radius: themeData.thumbRadius));
      final double thumbElevation = isThumbActive
          ? parentRenderBox.thumbElevationTween.evaluate(enableAnimation)
          : defaultElevation;

      context.canvas.drawShadow(path, shadowColor, thumbElevation, true);
    }

    if (!isThumbStroke &&
        _isThumbOverlap(parentBox) &&
        themeData.thumbColor != Colors.transparent) {
      final Color thumbOverlappingStrokeColor =
          themeData is SfRangeSliderThemeData
              ? themeData.overlappingThumbStrokeColor
              : null;
      if (thumbOverlappingStrokeColor != null) {
        final Paint strokePaint = Paint()
          ..color = thumbOverlappingStrokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

        context.canvas.drawCircle(
            center, getPreferredSize(themeData).width / 2, strokePaint);
      }
    }

    if (paint == null) {
      paint = Paint();
      paint.isAntiAlias = true;
      paint.color = ColorTween(
              begin: themeData.disabledThumbColor, end: themeData.thumbColor)
          .evaluate(enableAnimation);
    }

    context.canvas
        .drawCircle(center, getPreferredSize(themeData).width / 2, paint);
    if (child != null) {
      context.paintChild(
          child,
          Offset(center.dx - (child.size.width) / 2,
              center.dy - (child.size.height) / 2));
    }

    if (themeData.thumbStrokeColor != null &&
        themeData.thumbStrokeWidth != null &&
        themeData.thumbStrokeWidth > 0) {
      context.canvas.drawCircle(
          center,
          themeData.thumbStrokeWidth > radius
              ? radius / 2
              : radius - themeData.thumbStrokeWidth / 2,
          paint
            ..color = themeData.thumbStrokeColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = themeData.thumbStrokeWidth > radius
                ? radius
                : themeData.thumbStrokeWidth);
    }
  }
}

/// Base class for [SfSlider], [SfRangeSlider] and [SfRangeSelector] divisors
/// shapes.
class SfDivisorShape {
  /// Enables subclasses to provide constant constructors.
  const SfDivisorShape();

  /// Returns the size based on the values passed to it.
  Size getPreferredSize(SfSliderThemeData themeData, {bool isActive}) {
    return Size.fromRadius(isActive != null
        ? (isActive
            ? themeData.activeDivisorRadius
            : themeData.inactiveDivisorRadius)
        : 0);
  }

  /// Paints the divisors based on the values passed to it.
  void paint(PaintingContext context, Offset center, Offset thumbCenter,
      Offset startThumbCenter, Offset endThumbCenter,
      {RenderBox parentBox,
      SfSliderThemeData themeData,
      SfRangeValues currentValues,
      dynamic currentValue,
      Paint paint,
      Animation<double> enableAnimation,
      TextDirection textDirection}) {
    bool isActive;
    switch (textDirection) {
      case TextDirection.ltr:
        // Added this condition to check whether consider single thumb or
        // two thumbs for finding active range.
        isActive = startThumbCenter != null
            ? center.dx >= startThumbCenter.dx && center.dx <= endThumbCenter.dx
            : center.dx <= thumbCenter.dx;
        break;
      case TextDirection.rtl:
        isActive = startThumbCenter != null
            ? center.dx >= endThumbCenter.dx && center.dx <= startThumbCenter.dx
            : center.dx >= thumbCenter.dx;
        break;
    }

    if (paint == null) {
      paint = Paint();
      final Color begin = isActive
          ? themeData.disabledActiveDivisorColor
          : themeData.disabledInactiveDivisorColor;
      final Color end = isActive
          ? themeData.activeDivisorColor
          : themeData.inactiveDivisorColor;

      paint.color =
          ColorTween(begin: begin, end: end).evaluate(enableAnimation);
    }

    final double divisorRadius =
        getPreferredSize(themeData, isActive: isActive).width / 2;
    context.canvas.drawCircle(center, divisorRadius, paint);

    final double divisorStrokeWidth = isActive
        ? themeData.activeDivisorStrokeWidth
        : themeData.inactiveDivisorStrokeWidth;
    final Color divisorStrokeColor = isActive
        ? themeData.activeDivisorStrokeColor
        : themeData.inactiveDivisorStrokeColor;

    if (divisorStrokeColor != null &&
        divisorStrokeWidth != null &&
        divisorStrokeWidth > 0) {
      // Drawing divisor stroke
      context.canvas.drawCircle(
          center,
          divisorStrokeWidth > divisorRadius
              ? divisorRadius / 2
              : divisorRadius - divisorStrokeWidth / 2,
          paint
            ..color = divisorStrokeColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = divisorStrokeWidth > divisorRadius
                ? divisorRadius
                : divisorStrokeWidth);
    }
  }
}

/// Base class for [SfSlider], [SfRangeSlider] and [SfRangeSelector] overlay
/// shapes.
class SfOverlayShape {
  /// Enables subclasses to provide constant constructors.
  const SfOverlayShape();

  /// Returns the size based on the values passed to it.
  Size getPreferredSize(SfSliderThemeData themeData) {
    return Size.fromRadius(themeData.overlayRadius);
  }

  /// Paints the overlay based on the values passed to it.
  void paint(PaintingContext context, Offset center,
      {RenderBox parentBox,
      SfSliderThemeData themeData,
      SfRangeValues currentValues,
      dynamic currentValue,
      Paint paint,
      Animation<double> animation,
      SfThumb thumb}) {
    final double radius = getPreferredSize(themeData).width / 2;
    final Tween<double> tween = Tween<double>(begin: 0.0, end: radius);

    if (paint == null) {
      paint = Paint();
      paint.color = themeData.overlayColor;
    }
    context.canvas.drawCircle(center, tween.evaluate(animation), paint);
  }
}

/// Base class for [SfSlider], [SfRangeSlider] and [SfRangeSelector] major tick
/// shapes.
class SfTickShape {
  /// Enables subclasses to provide constant constructors.
  const SfTickShape();

  /// Returns the size based on the values passed to it.
  Size getPreferredSize(SfSliderThemeData themeData) {
    return Size.copy(themeData.tickSize);
  }

  /// Paints the major ticks based on the values passed to it.
  void paint(PaintingContext context, Offset offset, Offset thumbCenter,
      Offset startThumbCenter, Offset endThumbCenter,
      {RenderBox parentBox,
      SfSliderThemeData themeData,
      SfRangeValues currentValues,
      dynamic currentValue,
      Animation<double> enableAnimation,
      TextDirection textDirection}) {
    bool isInactive;
    final Size tickSize = getPreferredSize(themeData);
    switch (textDirection) {
      case TextDirection.ltr:
        // Added this condition to check whether consider single thumb or
        // two thumbs for finding inactive range.
        isInactive = startThumbCenter != null
            ? offset.dx < startThumbCenter.dx || offset.dx > endThumbCenter.dx
            : offset.dx > thumbCenter.dx;
        break;
      case TextDirection.rtl:
        isInactive = startThumbCenter != null
            ? offset.dx > startThumbCenter.dx || offset.dx < endThumbCenter.dx
            : offset.dx < thumbCenter.dx;
        break;
    }

    final Color begin = isInactive
        ? themeData.disabledInactiveTickColor
        : themeData.disabledActiveTickColor;
    final Color end =
        isInactive ? themeData.inactiveTickColor : themeData.activeTickColor;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = tickSize.width
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation);
    context.canvas.drawLine(
        offset, Offset(offset.dx, offset.dy + tickSize.height), paint);
  }
}

/// A base class which is used to render rectangular or paddle shape tooltip.
abstract class SfTooltipShape {
  /// Enables subclasses to provide constant constructors.
  const SfTooltipShape();

  /// Draws the tooltip based on the values passed in the arguments.
  void paint(PaintingContext context, Offset thumbCenter, Offset offset,
      TextPainter textPainter,
      {RenderBox parentBox,
      SfSliderThemeData sliderThemeData,
      Paint paint,
      Animation<double> animation,
      Rect trackRect});
}

class SfMinorTickShape extends SfTickShape {
  @override
  Size getPreferredSize(SfSliderThemeData themeData) {
    return Size.copy(themeData.minorTickSize);
  }

  @override
  void paint(PaintingContext context, Offset offset, Offset thumbCenter,
      Offset startThumbCenter, Offset endThumbCenter,
      {RenderBox parentBox,
      SfRangeValues currentValues,
      dynamic currentValue,
      SfSliderThemeData themeData,
      Animation<double> enableAnimation,
      TextDirection textDirection}) {
    bool isInactive;
    final Size minorTickSize = getPreferredSize(themeData);
    switch (textDirection) {
      case TextDirection.ltr:
        isInactive = startThumbCenter != null
            ? offset.dx < startThumbCenter.dx || offset.dx > endThumbCenter.dx
            : offset.dx > thumbCenter.dx;
        break;
      case TextDirection.rtl:
        isInactive = startThumbCenter != null
            ? offset.dx > startThumbCenter.dx || offset.dx < endThumbCenter.dx
            : offset.dx < thumbCenter.dx;
        break;
    }

    final Color begin = isInactive
        ? themeData.disabledInactiveMinorTickColor
        : themeData.disabledActiveMinorTickColor;
    final Color end = isInactive
        ? themeData.inactiveMinorTickColor
        : themeData.activeMinorTickColor;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = minorTickSize.width
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation);
    context.canvas.drawLine(
        offset, Offset(offset.dx, offset.dy + minorTickSize.height), paint);
  }
}

/// A class which is used to render paddle shape tooltip.
class SfPaddleTooltipShape extends SfTooltipShape {
  bool _isTooltipOverlapStroke(RenderBaseSlider parentBox) {
    return parentBox.showOverlappingTooltipStroke;
  }

  void _drawPaddleTooltip(
      RenderBox parentBox,
      TextPainter textPainter,
      double minPaddleTopCircleRadius,
      double neckDifference,
      SfSliderThemeData sliderThemeData,
      double defaultThumbRadius,
      double minBottomNeckRadius,
      double textPadding,
      Offset offset,
      double moveNeckValue,
      Offset thumbCenter,
      Rect trackRect,
      PaintingContext context,
      Animation<double> animation,
      Paint paint) {
    final double paddleTopCircleRadius =
        textPainter.height > minPaddleTopCircleRadius
            ? textPainter.height
            : minPaddleTopCircleRadius;
    final double topNeckRadius = paddleTopCircleRadius - neckDifference;
    final double bottomNeckRadius =
        sliderThemeData.thumbRadius > defaultThumbRadius
            ? sliderThemeData.thumbRadius - neckDifference * 2
            : minBottomNeckRadius;
    final double halfTextWidth = textPainter.width / 2 + textPadding;
    final double paddleTopCircleX = halfTextWidth > paddleTopCircleRadius
        ? halfTextWidth - paddleTopCircleRadius
        : 0;
    final double minPaddleWidth =
        paddleTopCircleRadius + topNeckRadius + neckDifference / 2;
    final Offset topNeckCenter = Offset(
        topNeckRadius + neckDifference / 2, -offset.dy - bottomNeckRadius);
    final Offset paddleTopCircleCenter = Offset(
        paddleTopCircleX,
        -paddleTopCircleRadius * (1.0 - moveNeckValue) -
            topNeckRadius -
            offset.dy -
            bottomNeckRadius);
    final Offset bottomNeckCenter = Offset(
        bottomNeckRadius + neckDifference / 2,
        -sliderThemeData.thumbRadius -
            bottomNeckRadius * (1.0 - moveNeckValue));
    final double leftShiftWidth = thumbCenter.dx - offset.dx - halfTextWidth;
    double shiftPaddleWidth = leftShiftWidth < 0 ? leftShiftWidth : 0;
    final double rightEndPosition =
        trackRect.right + trackRect.left - offset.dx;
    shiftPaddleWidth = thumbCenter.dx + halfTextWidth > rightEndPosition
        ? thumbCenter.dx + halfTextWidth - rightEndPosition
        : shiftPaddleWidth;
    final double leftPaddleWidth =
        paddleTopCircleRadius + paddleTopCircleCenter.dx + shiftPaddleWidth;
    final double rightPaddleWidth =
        paddleTopCircleRadius + paddleTopCircleCenter.dx - shiftPaddleWidth;
    final double moveLeftTopNeckY = leftPaddleWidth > paddleTopCircleRadius
        ? leftPaddleWidth < minPaddleWidth
            ? (leftPaddleWidth - topNeckRadius) * moveNeckValue
            : paddleTopCircleRadius * moveNeckValue
        : 0;
    final double moveLeftTopNeckAngle = leftPaddleWidth > paddleTopCircleRadius
        ? leftPaddleWidth < minPaddleWidth
            ? moveLeftTopNeckY * math.pi / 180
            : 30 * math.pi / 180
        : 0;
    final double moveRightTopNeckY = rightPaddleWidth > paddleTopCircleRadius
        ? rightPaddleWidth < minPaddleWidth
            ? (rightPaddleWidth - topNeckRadius) * moveNeckValue
            : paddleTopCircleRadius * moveNeckValue
        : 0;
    final double moveRightTopNeckAngle =
        rightPaddleWidth > paddleTopCircleRadius
            ? rightPaddleWidth < minPaddleWidth
                ? moveRightTopNeckY * math.pi / 180
                : 30 * math.pi / 180
            : 0;
    final double leftNeckStretchValue = leftPaddleWidth < minPaddleWidth
        ? (1.0 - (leftPaddleWidth / minPaddleWidth))
        : 0;
    final double rightNeckStretchValue = rightPaddleWidth < minPaddleWidth
        ? (1.0 - (rightPaddleWidth / minPaddleWidth))
        : 0;
    final double adjustPaddleCircleLeftArcAngle =
        shiftPaddleWidth < 0 && leftPaddleWidth < minPaddleWidth
            ? (leftNeckStretchValue * (math.pi / 2 + moveLeftTopNeckAngle))
            : 0;
    final double adjustPaddleCircleRightArcAngle =
        shiftPaddleWidth > 0 && rightPaddleWidth < minPaddleWidth
            ? (rightNeckStretchValue * (math.pi / 2 + moveRightTopNeckAngle))
            : 0.0;
    final double adjustLeftNeckArcAngle =
        adjustPaddleCircleLeftArcAngle * (1.0 - moveNeckValue);
    final double adjustRightNeckArcAngle =
        adjustPaddleCircleRightArcAngle * (1.0 - moveNeckValue);

    final Path path = _getPaddleTooltipPath(
        neckDifference,
        topNeckCenter,
        moveRightTopNeckY,
        topNeckRadius,
        moveRightTopNeckAngle,
        adjustRightNeckArcAngle,
        paddleTopCircleCenter,
        shiftPaddleWidth,
        paddleTopCircleRadius,
        adjustPaddleCircleRightArcAngle,
        adjustPaddleCircleLeftArcAngle,
        moveLeftTopNeckY,
        moveLeftTopNeckAngle,
        adjustLeftNeckArcAngle,
        bottomNeckCenter,
        bottomNeckRadius,
        sliderThemeData);

    context.canvas.save();
    context.canvas.translate(thumbCenter.dx, thumbCenter.dy);
    context.canvas.scale(animation.value);
    if (_isTooltipOverlapStroke(parentBox) &&
        sliderThemeData.tooltipBackgroundColor != Colors.transparent) {
      final Paint strokePaint = Paint()
        ..color = sliderThemeData is SfRangeSliderThemeData
            ? sliderThemeData.overlappingTooltipStrokeColor
            : null
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      context.canvas.drawPath(path, strokePaint);
    }

    context.canvas.drawPath(path, paint);
    textPainter.paint(
        context.canvas,
        Offset(-textPainter.width / 2 - shiftPaddleWidth,
            paddleTopCircleCenter.dy - textPainter.height / 2));
    context.canvas.restore();
  }

  Path _getPaddleTooltipPath(
      double neckDifference,
      Offset topNeckCenter,
      double moveRightTopNeckY,
      double topNeckRadius,
      double moveRightTopNeckAngle,
      double adjustRightNeckArcAngle,
      Offset paddleTopCircleCenter,
      double shiftPaddleWidth,
      double paddleTopCircleRadius,
      double adjustPaddleCircleRightArcAngle,
      double adjustPaddleCircleLeftArcAngle,
      double moveLeftTopNeckY,
      double moveLeftTopNeckAngle,
      double adjustLeftNeckArcAngle,
      Offset bottomNeckCenter,
      double bottomNeckRadius,
      SfSliderThemeData sliderThemeData) {
    final Path path = Path();
    path.moveTo(
        neckDifference / 2, topNeckCenter.dy + topNeckRadius * moveNeckValue);
    // Drawn top paddle shape.
    path.arcTo(
        Rect.fromCircle(
            center:
                Offset(topNeckCenter.dx, topNeckCenter.dy + moveRightTopNeckY),
            radius: topNeckRadius),
        math.pi,
        math.pi / 3 + moveRightTopNeckAngle - adjustRightNeckArcAngle,
        false);
    path.arcTo(
        Rect.fromCircle(
            center: Offset(paddleTopCircleCenter.dx - shiftPaddleWidth,
                paddleTopCircleCenter.dy),
            radius: paddleTopCircleRadius),
        math.pi / 2 - adjustPaddleCircleRightArcAngle,
        -math.pi + adjustPaddleCircleRightArcAngle,
        false);
    path.arcTo(
        Rect.fromCircle(
            center: Offset(-paddleTopCircleCenter.dx - shiftPaddleWidth,
                paddleTopCircleCenter.dy),
            radius: paddleTopCircleRadius),
        3 * math.pi / 2,
        -math.pi + adjustPaddleCircleLeftArcAngle,
        false);
    path.arcTo(
        Rect.fromCircle(
            center:
                Offset(-topNeckCenter.dx, topNeckCenter.dy + moveLeftTopNeckY),
            radius: topNeckRadius),
        5 * math.pi / 3 - moveLeftTopNeckAngle + adjustLeftNeckArcAngle,
        math.pi / 3 + moveLeftTopNeckAngle - adjustLeftNeckArcAngle,
        false);

    // Drawn bottom thumb shape.
    path.arcTo(
        Rect.fromCircle(
            center: Offset(-bottomNeckCenter.dx, bottomNeckCenter.dy),
            radius: bottomNeckRadius),
        0.0,
        math.pi / 3,
        false);
    path.arcTo(
        Rect.fromCircle(
            center: const Offset(0.0, 0.0),
            radius: sliderThemeData.thumbRadius),
        3 * math.pi / 2,
        -math.pi,
        false);
    path.arcTo(
        Rect.fromCircle(
            center: const Offset(0.0, 0.0),
            radius: sliderThemeData.thumbRadius),
        math.pi / 2,
        -math.pi,
        false);
    path.arcTo(
        Rect.fromCircle(center: bottomNeckCenter, radius: bottomNeckRadius),
        2 * math.pi / 3,
        math.pi / 3,
        false);
    return path;
  }

  /// Draws the tooltip based on the values passed in the arguments.
  @override
  void paint(PaintingContext context, Offset thumbCenter, Offset offset,
      TextPainter textPainter,
      {RenderBox parentBox,
      SfSliderThemeData sliderThemeData,
      Paint paint,
      Animation<double> animation,
      Rect trackRect}) {
    _drawPaddleTooltip(
        parentBox,
        textPainter,
        minPaddleTopCircleRadius,
        neckDifference,
        sliderThemeData,
        defaultThumbRadius,
        minBottomNeckRadius,
        textPadding,
        offset,
        moveNeckValue,
        thumbCenter,
        trackRect,
        context,
        animation,
        paint);
  }
}

/// A class which is used to render rectangular shape tooltip.
class SfRectangularTooltipShape extends SfTooltipShape {
  bool _isTooltipOverlapStroke(RenderBaseSlider parentBox) {
    return parentBox.showOverlappingTooltipStroke;
  }

  Path _updateRectangularTooltipWidth(
      Size textSize, double tooltipStartY, Rect trackRect, double dx) {
    final double dy = tooltipStartY + tooltipTriangleHeight;
    final double tooltipWidth =
        textSize.width < minTooltipWidth ? minTooltipWidth : textSize.width;
    final double tooltipHeight =
        textSize.height < minTooltipHeight ? minTooltipHeight : textSize.height;
    final double halfTooltipWidth = tooltipWidth / 2;

    double rightLineWidth = dx + halfTooltipWidth > trackRect.right
        ? trackRect.right - dx
        : halfTooltipWidth;
    final double leftLineWidth = dx - halfTooltipWidth < trackRect.left
        ? dx - trackRect.left
        : tooltipWidth - rightLineWidth;
    rightLineWidth = leftLineWidth < halfTooltipWidth
        ? halfTooltipWidth - leftLineWidth + rightLineWidth
        : rightLineWidth;
    const double halfTooltipTriangleWidth = tooltipTriangleWidth / 2;

    return _getRectangularPath(tooltipStartY, rightLineWidth,
        halfTooltipTriangleWidth, dy, tooltipHeight, leftLineWidth);
  }

  Path _getRectangularPath(
      double tooltipStartY,
      double rightLineWidth,
      double halfTooltipTriangleWidth,
      double dy,
      double tooltipHeight,
      double leftLineWidth) {
    final Path path = Path();
    path.moveTo(0, -tooltipStartY);
    //    /
    final bool canAdjustTooltipNose =
        rightLineWidth > halfTooltipTriangleWidth + cornerRadius / 2;
    path.lineTo(
        canAdjustTooltipNose ? halfTooltipTriangleWidth : rightLineWidth,
        -dy - (canAdjustTooltipNose ? 0 : cornerRadius / 2));
    //      ___
    //     /
    path.lineTo(rightLineWidth - cornerRadius, -dy);
    //      ___|
    //     /
    path.quadraticBezierTo(
        rightLineWidth, -dy, rightLineWidth, -dy - cornerRadius);
    path.lineTo(rightLineWidth, -dy - tooltipHeight + cornerRadius);
    //  _______
    //      ___|
    //     /
    path.quadraticBezierTo(rightLineWidth, -dy - tooltipHeight,
        rightLineWidth - cornerRadius, -dy - tooltipHeight);
    path.lineTo(-leftLineWidth + cornerRadius, -dy - tooltipHeight);
    //  _______
    // |    ___|
    //     /
    path.quadraticBezierTo(-leftLineWidth, -dy - tooltipHeight, -leftLineWidth,
        -dy - tooltipHeight + cornerRadius);
    path.lineTo(-leftLineWidth, -dy - cornerRadius);
    //  ________
    // |___  ___|
    //      /
    if (leftLineWidth > halfTooltipTriangleWidth) {
      path.quadraticBezierTo(
          -leftLineWidth, -dy, -leftLineWidth + cornerRadius, -dy);
      path.lineTo(-halfTooltipTriangleWidth, -dy);
    }
    //  ________
    // |___  ___|
    //     \/
    path.close();
    return path;
  }

  /// Draws the tooltip based on the values passed in the arguments.
  @override
  void paint(PaintingContext context, Offset thumbCenter, Offset offset,
      TextPainter textPainter,
      {RenderBox parentBox,
      SfSliderThemeData sliderThemeData,
      Paint paint,
      Animation<double> animation,
      Rect trackRect}) {
    final double leftPadding = tooltipTextPadding.dx / 2;
    final double minLeftX = trackRect.left;
    final Path path = _updateRectangularTooltipWidth(
        textPainter.size + tooltipTextPadding,
        offset.dy,
        trackRect,
        thumbCenter.dx);

    context.canvas.save();
    context.canvas.translate(thumbCenter.dx, thumbCenter.dy);
    context.canvas.scale(animation.value);
    if (_isTooltipOverlapStroke(parentBox) &&
        sliderThemeData.tooltipBackgroundColor != Colors.transparent) {
      final Paint strokePaint = Paint();
      if (sliderThemeData is SfRangeSliderThemeData) {
        strokePaint.color = sliderThemeData.overlappingTooltipStrokeColor;
        strokePaint.style = PaintingStyle.stroke;
        strokePaint.strokeWidth = 1.0;
      } else if (sliderThemeData is SfRangeSelectorThemeData) {
        strokePaint.color = sliderThemeData.overlappingTooltipStrokeColor;
        strokePaint.style = PaintingStyle.stroke;
        strokePaint.strokeWidth = 1.0;
      }
      context.canvas.drawPath(path, strokePaint);
    }

    context.canvas.drawPath(path, paint);

    final Rect pathRect = path.getBounds();
    final double halfPathWidth = pathRect.width / 2;
    final double halfTextPainterWidth = textPainter.width / 2;
    final double rectLeftPosition = thumbCenter.dx - halfPathWidth;
    final double dx = rectLeftPosition >= minLeftX
        ? thumbCenter.dx + halfTextPainterWidth + leftPadding > trackRect.right
            ? -halfTextPainterWidth -
                halfPathWidth +
                trackRect.right -
                thumbCenter.dx
            : -halfTextPainterWidth
        : -halfTextPainterWidth +
            halfPathWidth +
            trackRect.left -
            thumbCenter.dx;
    final double dy = offset.dy +
        tooltipTriangleHeight +
        (pathRect.size.height - tooltipTriangleHeight) / 2 +
        textPainter.height / 2;
    textPainter.paint(context.canvas, Offset(dx, -dy));
    context.canvas.restore();
  }
}
