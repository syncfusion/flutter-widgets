import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'slider_base.dart';

/// Base class for [SfSlider], [SfRangeSlider] and [SfRangeSelector] track
/// shapes.
class SfTrackShape {
  /// Enables subclasses to provide constant constructors.
  const SfTrackShape();

  bool _isVertical(RenderBaseSlider parentBox) {
    return parentBox.sliderType == SliderType.vertical;
  }

  /// Returns the size based on the values passed to it.
  Rect getPreferredRect(
      RenderBox parentBox, SfSliderThemeData themeData, Offset offset,
      {bool? isActive}) {
    final Size overlayPreferredSize = (parentBox as RenderBaseSlider)
        .overlayShape
        .getPreferredSize(themeData);
    final Size thumbPreferredSize =
        parentBox.thumbShape.getPreferredSize(themeData);
    final Size tickPreferredSize =
        parentBox.tickShape.getPreferredSize(themeData);
    double maxRadius;
    if (_isVertical(parentBox)) {
      maxRadius = math.max(
          overlayPreferredSize.height / 2,
          math.max(
              thumbPreferredSize.height / 2, tickPreferredSize.height / 2));
    } else {
      maxRadius = math.max(overlayPreferredSize.width / 2,
          math.max(thumbPreferredSize.width / 2, tickPreferredSize.width / 2));
    }
    final double maxTrackHeight =
        math.max(themeData.activeTrackHeight, themeData.inactiveTrackHeight);
    // ignore: avoid_as
    if (_isVertical(parentBox)) {
      double left = offset.dx;
      if (isActive != null) {
        left += isActive
            ? (maxTrackHeight - themeData.activeTrackHeight) / 2
            : (maxTrackHeight - themeData.inactiveTrackHeight) / 2;
      }
      final double right = left +
          (isActive == null
              ? maxTrackHeight
              : (isActive
                  ? themeData.activeTrackHeight
                  : themeData.inactiveTrackHeight));
      final double top = offset.dy + maxRadius;
      final double bottom = top + parentBox.size.height - (2 * maxRadius);
      return Rect.fromLTRB(
          math.min(left, right), top, math.max(left, right), bottom);
    } else {
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
  }

  /// Paints the track based on the values passed to it.
  void paint(PaintingContext context, Offset offset, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Animation<double> enableAnimation,
      required Paint? inactivePaint,
      required Paint? activePaint,
      required TextDirection textDirection}) {
    final Radius radius = Radius.circular(themeData.trackCornerRadius!);
    final Rect inactiveTrackRect =
        getPreferredRect(parentBox, themeData, offset, isActive: false);
    final Rect activeTrackRect =
        getPreferredRect(parentBox, themeData, offset, isActive: true);

    if (inactivePaint == null) {
      inactivePaint = Paint();
      final ColorTween inactiveTrackColorTween = ColorTween(
          begin: themeData.disabledInactiveTrackColor,
          end: themeData.inactiveTrackColor);
      inactivePaint.color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    }

    if (activePaint == null) {
      activePaint = Paint();
      final ColorTween activeTrackColorTween = ColorTween(
          begin: themeData.disabledActiveTrackColor,
          end: themeData.activeTrackColor);
      activePaint.color = activeTrackColorTween.evaluate(enableAnimation)!;
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
        activeTrackRect,
        // ignore: avoid_as
        isVertical: _isVertical(parentBox as RenderBaseSlider),
        isInversed: parentBox.isInversed);
  }

  void _drawTrackRect(
    TextDirection? textDirection,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter,
    Paint activePaint,
    Paint inactivePaint,
    Rect inactiveTrackRect,
    Radius radius,
    PaintingContext context,
    Rect activeTrackRect, {
    required bool isVertical,
    required bool isInversed,
  }) {
    Offset? leftThumbCenter;
    Offset? rightThumbCenter;
    Paint? leftTrackPaint;
    Paint? rightTrackPaint;
    Rect? leftTrackRect;
    Rect? rightTrackRect;
    if (isInversed) {
      if (startThumbCenter != null) {
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
      if (startThumbCenter != null) {
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

    if (leftThumbCenter != null && rightThumbCenter != null) {
      // Drawing range slider track.
      _drawRangeSliderTrack(inactiveTrackRect, leftThumbCenter, radius, context,
          inactivePaint, activeTrackRect, rightThumbCenter, activePaint,
          isVertical: isVertical);
    } else {
      // Drawing slider track.
      _drawSliderTrack(leftTrackRect!, thumbCenter!, radius, context,
          leftTrackPaint!, rightTrackRect!, rightTrackPaint!,
          isVertical: isVertical);
    }
  }

  void _drawSliderTrack(
      Rect activeTrackRect,
      Offset thumbCenter,
      Radius radius,
      PaintingContext context,
      Paint activePaint,
      Rect inactiveTrackRect,
      Paint inactivePaint,
      {required bool isVertical}) {
    RRect inactiveTrackRRect;
    if (!isVertical) {
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
          topRight: radius, bottomRight: radius);

      context.canvas.drawRRect(inactiveTrackRRect, inactivePaint);
    } else {
      Rect trackRect = Rect.fromLTRB(activeTrackRect.left, thumbCenter.dy,
          activeTrackRect.right, activeTrackRect.bottom);
      final RRect activeTrackRRect = RRect.fromRectAndCorners(trackRect,
          bottomRight: radius, bottomLeft: radius);
      context.canvas.drawRRect(activeTrackRRect, activePaint);

      // Drawing inactive track.
      trackRect = Rect.fromLTRB(inactiveTrackRect.left, inactiveTrackRect.top,
          inactiveTrackRect.right, thumbCenter.dy);
      inactiveTrackRRect = RRect.fromRectAndCorners(trackRect,
          topLeft: radius, topRight: radius);
      context.canvas.drawRRect(inactiveTrackRRect, inactivePaint);
    }
  }

  void _drawRangeSliderTrack(
    Rect inactiveTrackRect,
    Offset startThumbCenter,
    Radius radius,
    PaintingContext context,
    Paint inactivePaint,
    Rect activeTrackRect,
    Offset endThumbCenter,
    Paint activePaint, {
    bool isVertical = false,
  }) {
    RRect inactiveTrackRRect;
    if (!isVertical) {
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
          topRight: radius, bottomRight: radius);
      context.canvas.drawRRect(inactiveTrackRRect, inactivePaint);
    } else {
      // Drawing inactive track
      Rect trackRect = Rect.fromLTRB(
          inactiveTrackRect.left,
          startThumbCenter.dy,
          inactiveTrackRect.right,
          inactiveTrackRect.bottom);
      inactiveTrackRRect = RRect.fromRectAndCorners(trackRect,
          bottomLeft: radius, bottomRight: radius);
      context.canvas.drawRRect(inactiveTrackRRect, inactivePaint);

      // Drawing active track.
      final Rect activeTrackRRect = Rect.fromLTRB(activeTrackRect.left,
          startThumbCenter.dy, activeTrackRect.right, endThumbCenter.dy);
      context.canvas.drawRect(activeTrackRRect, activePaint);

      // Drawing inactive track.
      trackRect = Rect.fromLTRB(inactiveTrackRect.left, inactiveTrackRect.top,
          inactiveTrackRect.right, endThumbCenter.dy);
      inactiveTrackRRect = RRect.fromRectAndCorners(trackRect,
          topLeft: radius, topRight: radius);
      context.canvas.drawRRect(inactiveTrackRRect, inactivePaint);
    }
  }
}

/// Base class for [SfSlider], [SfRangeSlider] and [SfRangeSelector] thumb
/// shapes.
class SfThumbShape {
  /// Enables subclasses to provide constant constructors.
  const SfThumbShape();

  bool _isThumbOverlapping(RenderBaseSlider parentBox) {
    return parentBox.showOverlappingThumbStroke;
  }

  /// Returns the size based on the values passed to it.
  Size getPreferredSize(SfSliderThemeData themeData) {
    return Size.fromRadius(themeData.thumbRadius);
  }

  /// Paints the thumb based on the values passed to it.
  void paint(PaintingContext context, Offset center,
      {required RenderBox parentBox,
      required RenderBox? child,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required SfThumb? thumb}) {
    final double radius = getPreferredSize(themeData).width / 2;
    final bool hasThumbStroke = themeData.thumbStrokeColor != null &&
        themeData.thumbStrokeColor != Colors.transparent &&
        themeData.thumbStrokeWidth != null &&
        themeData.thumbStrokeWidth! > 0;

    final bool showThumbShadow = themeData.thumbColor != Colors.transparent;
    // ignore: avoid_as
    final RenderBaseSlider parentRenderBox = parentBox as RenderBaseSlider;
    if (showThumbShadow) {
      final Path path = Path();
      final bool isThumbActive =
          (parentRenderBox.activeThumb == thumb || thumb == null) &&
              parentRenderBox.currentPointerType != null &&
              parentRenderBox.currentPointerType != PointerType.up;
      path.addOval(Rect.fromCircle(center: center, radius: radius));
      final double thumbElevation = isThumbActive
          ? parentRenderBox.thumbElevationTween.evaluate(enableAnimation)
          : defaultElevation;

      context.canvas.drawShadow(path, shadowColor, thumbElevation, true);
    }

    if (themeData is SfRangeSliderThemeData &&
        !hasThumbStroke &&
        _isThumbOverlapping(parentBox) &&
        themeData.thumbColor != Colors.transparent &&
        themeData.overlappingThumbStrokeColor != null) {
      context.canvas.drawCircle(
          center,
          radius,
          Paint()
            ..color = themeData.overlappingThumbStrokeColor!
            ..style = PaintingStyle.stroke
            ..isAntiAlias = true
            ..strokeWidth = 1.0);
    }

    if (paint == null) {
      paint = Paint();
      paint.isAntiAlias = true;
      paint.color = ColorTween(
              begin: themeData.disabledThumbColor, end: themeData.thumbColor)
          .evaluate(enableAnimation)!;
    }

    context.canvas.drawCircle(center, radius, paint);
    if (child != null) {
      context.paintChild(
          child,
          Offset(center.dx - (child.size.width) / 2,
              center.dy - (child.size.height) / 2));
    }

    if (themeData.thumbStrokeColor != null &&
        themeData.thumbStrokeWidth != null &&
        themeData.thumbStrokeWidth! > 0) {
      final Paint strokePaint = Paint()
        ..color = themeData.thumbStrokeColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = themeData.thumbStrokeWidth! > radius
            ? radius
            : themeData.thumbStrokeWidth!;
      context.canvas.drawCircle(
          center,
          themeData.thumbStrokeWidth! > radius
              ? radius / 2
              : radius - themeData.thumbStrokeWidth! / 2,
          strokePaint);
    }
  }
}

/// Base class for [SfSlider], [SfRangeSlider] and [SfRangeSelector] dividers
/// shapes.
class SfDividerShape {
  /// Enables subclasses to provide constant constructors.
  const SfDividerShape();

  bool _isVertical(RenderBaseSlider parentBox) {
    return parentBox.sliderType == SliderType.vertical;
  }

  /// Returns the size based on the values passed to it.
  Size getPreferredSize(SfSliderThemeData themeData, {bool? isActive}) {
    return Size.fromRadius(isActive != null
        ? (isActive
            ? themeData.activeDividerRadius!
            : themeData.inactiveDividerRadius!)
        : 0);
  }

  /// Paints the dividers based on the values passed to it.
  void paint(PaintingContext context, Offset center, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection}) {
    late bool isActive;
    final bool isVertical = _isVertical(parentBox as RenderBaseSlider);

    if (!isVertical) {
      // Added this condition to check whether consider single thumb or
      // two thumbs for finding active range.
      if (startThumbCenter != null) {
        if (!parentBox.isInversed) {
          isActive = center.dx >= startThumbCenter.dx &&
              center.dx <= endThumbCenter!.dx;
        } else {
          isActive = center.dx >= endThumbCenter!.dx &&
              center.dx <= startThumbCenter.dx;
        }
      } else {
        if (!parentBox.isInversed) {
          isActive = center.dx <= thumbCenter!.dx;
        } else {
          isActive = center.dx >= thumbCenter!.dx;
        }
      }
    } else {
      // Added this condition to check whether consider single thumb or
      // two thumbs for finding active range.
      if (startThumbCenter != null) {
        if (!parentBox.isInversed) {
          isActive = center.dy <= startThumbCenter.dy &&
              center.dy >= endThumbCenter!.dy;
        } else {
          isActive = center.dy >= startThumbCenter.dy &&
              center.dy <= endThumbCenter!.dy;
        }
      } else {
        if (!parentBox.isInversed) {
          isActive = center.dy >= thumbCenter!.dy;
        } else {
          isActive = center.dy <= thumbCenter!.dy;
        }
      }
    }

    if (paint == null) {
      paint = Paint();
      final Color begin = isActive
          ? themeData.disabledActiveDividerColor!
          : themeData.disabledInactiveDividerColor!;
      final Color end = isActive
          ? themeData.activeDividerColor!
          : themeData.inactiveDividerColor!;

      paint.color =
          ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;
    }

    final double dividerRadius =
        getPreferredSize(themeData, isActive: isActive).width / 2;
    context.canvas.drawCircle(center, dividerRadius, paint);

    final double? dividerStrokeWidth = isActive
        ? themeData.activeDividerStrokeWidth
        : themeData.inactiveDividerStrokeWidth;
    final Color? dividerStrokeColor = isActive
        ? themeData.activeDividerStrokeColor
        : themeData.inactiveDividerStrokeColor;

    if (dividerStrokeColor != null &&
        dividerStrokeWidth != null &&
        dividerStrokeWidth > 0) {
      // Drawing divider stroke
      context.canvas.drawCircle(
          center,
          dividerStrokeWidth > dividerRadius
              ? dividerRadius / 2
              : dividerRadius - dividerStrokeWidth / 2,
          paint
            ..color = dividerStrokeColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = dividerStrokeWidth > dividerRadius
                ? dividerRadius
                : dividerStrokeWidth);
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
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> animation,
      required SfThumb? thumb}) {
    final double radius = getPreferredSize(themeData).width / 2;
    final Tween<double> tween = Tween<double>(begin: 0.0, end: radius);

    if (paint == null) {
      paint = Paint();
      paint.color = themeData.overlayColor!;
    }
    context.canvas.drawCircle(center, tween.evaluate(animation), paint);
  }
}

/// Base class for [SfSlider], [SfRangeSlider] and [SfRangeSelector] major tick
/// shapes.
class SfTickShape {
  /// Enables subclasses to provide constant constructors.
  const SfTickShape();

  bool _isVertical(RenderBaseSlider parentBox) {
    return parentBox.sliderType == SliderType.vertical;
  }

  /// Returns the size based on the values passed to it.
  Size getPreferredSize(SfSliderThemeData themeData) {
    return Size.copy(themeData.tickSize!);
  }

  /// Paints the major ticks based on the values passed to it.
  void paint(PaintingContext context, Offset offset, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Animation<double> enableAnimation,
      required TextDirection textDirection}) {
    bool isInactive = false;
    final Size tickSize = getPreferredSize(themeData);
    final bool isVertical = _isVertical(parentBox as RenderBaseSlider);

    if (!isVertical) {
      // Added this condition to check whether consider single thumb or
      // two thumbs for finding active range.
      if (startThumbCenter != null) {
        if (!parentBox.isInversed) {
          isInactive =
              offset.dx < startThumbCenter.dx || offset.dx > endThumbCenter!.dx;
        } else {
          isInactive =
              offset.dx > startThumbCenter.dx || offset.dx < endThumbCenter!.dx;
        }
      } else {
        if (!parentBox.isInversed) {
          isInactive = offset.dx > thumbCenter!.dx;
        } else {
          isInactive = offset.dx < thumbCenter!.dx;
        }
      }
    } else {
      // Added this condition to check whether consider single thumb or
      // two thumbs for finding active range.
      if (startThumbCenter != null) {
        if (!parentBox.isInversed) {
          isInactive =
              offset.dy > startThumbCenter.dy || offset.dy < endThumbCenter!.dy;
        } else {
          isInactive =
              offset.dy < startThumbCenter.dy || offset.dy > endThumbCenter!.dy;
        }
      } else {
        if (!parentBox.isInversed) {
          isInactive = offset.dy < thumbCenter!.dy;
        } else {
          isInactive = offset.dy > thumbCenter!.dy;
        }
      }
    }

    final Color begin = isInactive
        ? themeData.disabledInactiveTickColor!
        : themeData.disabledActiveTickColor!;
    final Color end =
        isInactive ? themeData.inactiveTickColor! : themeData.activeTickColor!;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = _isVertical(parentBox) ? tickSize.height : tickSize.width
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;
    if (_isVertical(parentBox)) {
      context.canvas.drawLine(
          offset, Offset(offset.dx + tickSize.width, offset.dy), paint);
    } else {
      context.canvas.drawLine(
          offset, Offset(offset.dx, offset.dy + tickSize.height), paint);
    }
  }
}

/// A base class which is used to render rectangular or paddle shape tooltip.
abstract class SfTooltipShape {
  /// Enables subclasses to provide constant constructors.
  const SfTooltipShape();

  /// Draws the tooltip based on the values passed in the arguments.
  void paint(PaintingContext context, Offset thumbCenter, Offset offset,
      TextPainter textPainter,
      {required RenderBox parentBox,
      required SfSliderThemeData sliderThemeData,
      required Paint paint,
      required Animation<double> animation,
      required Rect trackRect});
}

/// Base class for [SfSlider], [SfRangeSlider] and [SfRangeSelector] minor tick
/// shapes.
class SfMinorTickShape extends SfTickShape {
  /// Enables subclasses to provide constant constructors.
  const SfMinorTickShape();
  @override
  Size getPreferredSize(SfSliderThemeData themeData) {
    return Size.copy(themeData.minorTickSize!);
  }

  @override
  void paint(PaintingContext context, Offset offset, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required SfSliderThemeData themeData,
      required Animation<double> enableAnimation,
      required TextDirection textDirection}) {
    bool isInactive;
    final Size minorTickSize = getPreferredSize(themeData);
    final bool isVertical = _isVertical(parentBox as RenderBaseSlider);

    if (!isVertical) {
      // Added this condition to check whether consider single thumb or
      // two thumbs for finding active range.
      if (startThumbCenter != null) {
        if (!parentBox.isInversed) {
          isInactive =
              offset.dx < startThumbCenter.dx || offset.dx > endThumbCenter!.dx;
        } else {
          isInactive =
              offset.dx > startThumbCenter.dx || offset.dx < endThumbCenter!.dx;
        }
      } else {
        if (!parentBox.isInversed) {
          isInactive = offset.dx > thumbCenter!.dx;
        } else {
          isInactive = offset.dx < thumbCenter!.dx;
        }
      }
    } else {
      // Added this condition to check whether consider single thumb or
      // two thumbs for finding active range.
      if (startThumbCenter != null) {
        if (!parentBox.isInversed) {
          isInactive =
              offset.dy > startThumbCenter.dy || offset.dy < endThumbCenter!.dy;
        } else {
          isInactive =
              offset.dy < startThumbCenter.dy || offset.dy > endThumbCenter!.dy;
        }
      } else {
        if (!parentBox.isInversed) {
          isInactive = offset.dy < thumbCenter!.dy;
        } else {
          isInactive = offset.dy > thumbCenter!.dy;
        }
      }
    }

    final Color begin = isInactive
        ? themeData.disabledInactiveMinorTickColor!
        : themeData.disabledActiveMinorTickColor!;
    final Color end = isInactive
        ? themeData.inactiveMinorTickColor!
        : themeData.activeMinorTickColor!;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth =
          _isVertical(parentBox) ? minorTickSize.height : minorTickSize.width
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;
    if (_isVertical(parentBox)) {
      context.canvas.drawLine(
          offset, Offset(offset.dx + minorTickSize.width, offset.dy), paint);
    } else {
      context.canvas.drawLine(
          offset, Offset(offset.dx, offset.dy + minorTickSize.height), paint);
    }
  }
}

/// A class which is used to render paddle shape tooltip.
class SfPaddleTooltipShape extends SfTooltipShape {
  /// Creates a [SfPaddleTooltipShape].
  ///
  /// A class which is used to render paddle shape tooltip.
  const SfPaddleTooltipShape();
  bool _hasTooltipOverlapStroke(RenderBaseSlider parentBox) {
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
      Paint? paint) {
    final double thumbRadius = (parentBox as RenderBaseSlider)
            .thumbShape
            .getPreferredSize(sliderThemeData)
            .width /
        2;
    final double paddleTopCircleRadius =
        textPainter.height > minPaddleTopCircleRadius
            ? textPainter.height
            : minPaddleTopCircleRadius;
    final double topNeckRadius = paddleTopCircleRadius - neckDifference;
    final double bottomNeckRadius = thumbRadius > defaultThumbRadius
        ? thumbRadius - neckDifference * 2
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
        -thumbRadius - bottomNeckRadius * (1.0 - moveNeckValue));
    final double leftShiftWidth = thumbCenter.dx - halfTextWidth;
    double shiftPaddleWidth =
        leftShiftWidth < trackRect.left ? leftShiftWidth : 0;
    final double rightShiftWidth = thumbCenter.dx + halfTextWidth;
    shiftPaddleWidth = rightShiftWidth > trackRect.right
        ? rightShiftWidth - trackRect.right
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
        thumbRadius,
        sliderThemeData);

    context.canvas.save();
    context.canvas.translate(thumbCenter.dx, thumbCenter.dy);
    context.canvas.scale(animation.value);
    final Paint strokePaint = Paint();
    if (_hasTooltipOverlapStroke(parentBox) &&
        sliderThemeData is SfRangeSliderThemeData &&
        sliderThemeData.tooltipBackgroundColor != Colors.transparent) {
      strokePaint
        ..color = sliderThemeData.overlappingTooltipStrokeColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
    }
    // This loop is used to avoid the improper rendering of tooltips in
    // web html rendering.
    else {
      strokePaint
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke;
    }
    context.canvas.drawPath(path, strokePaint);
    context.canvas.drawPath(path, paint!);
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
      double thumbRadius,
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
    path.arcTo(Rect.fromCircle(center: Offset.zero, radius: thumbRadius),
        3 * math.pi / 2, -math.pi, false);
    path.arcTo(Rect.fromCircle(center: Offset.zero, radius: thumbRadius),
        math.pi / 2, -math.pi, false);
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
      {required RenderBox parentBox,
      required SfSliderThemeData sliderThemeData,
      required Paint paint,
      required Animation<double> animation,
      required Rect trackRect}) {
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
  /// Creates a [SfRectangularTooltipShape].
  ///
  /// A class which is used to render rectangular shape tooltip.
  const SfRectangularTooltipShape();
  bool _hasTooltipOverlapStroke(RenderBaseSlider parentBox) {
    return parentBox.showOverlappingTooltipStroke;
  }

  bool _isVertical(RenderBaseSlider parentBox) {
    return parentBox.sliderType == SliderType.vertical;
  }

  bool _isLeftTooltip(RenderBaseSlider parentBox) {
    return parentBox.tooltipPosition == SliderTooltipPosition.left;
  }

  Path _updateRectangularTooltipWidth(
      Size textSize, double tooltipStartY, Rect trackRect, double dx,
      {required bool isVertical, bool? isLeftTooltip}) {
    final double dy = tooltipStartY + tooltipTriangleHeight;
    final double tooltipWidth =
        textSize.width < minTooltipWidth ? minTooltipWidth : textSize.width;
    final double tooltipHeight =
        textSize.height < minTooltipHeight ? minTooltipHeight : textSize.height;
    final double halfTooltipWidth = tooltipWidth / 2;
    final double halfTooltipHeight = tooltipHeight / 2;
    const double halfTooltipTriangleWidth = tooltipTriangleWidth / 2;
    if (isVertical) {
      if (isLeftTooltip!) {
        double topLineHeight = dx - halfTooltipHeight < trackRect.top
            ? dx - trackRect.top
            : halfTooltipHeight;
        final double bottomLineHeight =
            dx + halfTooltipHeight > trackRect.bottom
                ? trackRect.bottom - dx
                : tooltipHeight - topLineHeight;
        topLineHeight = bottomLineHeight < halfTooltipHeight
            ? halfTooltipHeight - bottomLineHeight + topLineHeight
            : topLineHeight;
        return _getRectangularPath(tooltipStartY, topLineHeight,
            halfTooltipTriangleWidth, dy, tooltipHeight, bottomLineHeight,
            isVertical: isVertical,
            toolTipWidth: tooltipWidth,
            isLeftTooltip: isLeftTooltip);
      } else {
        double topLineHeight = dx - halfTooltipHeight < trackRect.top
            ? dx - trackRect.top
            : halfTooltipHeight;
        final double bottomLineHeight =
            dx + halfTooltipHeight > trackRect.bottom
                ? trackRect.bottom - dx
                : tooltipHeight - topLineHeight;
        topLineHeight = bottomLineHeight < halfTooltipHeight
            ? halfTooltipHeight - bottomLineHeight + topLineHeight
            : topLineHeight;
        return _getRectangularPath(tooltipStartY, topLineHeight,
            halfTooltipTriangleWidth, dy, tooltipHeight, bottomLineHeight,
            isVertical: isVertical,
            toolTipWidth: tooltipWidth,
            isLeftTooltip: isLeftTooltip);
      }
    } else {
      double rightLineWidth = dx + halfTooltipWidth > trackRect.right
          ? trackRect.right - dx
          : halfTooltipWidth;
      final double leftLineWidth = isVertical
          ? tooltipWidth - rightLineWidth
          : dx - halfTooltipWidth < trackRect.left
              ? dx - trackRect.left
              : tooltipWidth - rightLineWidth;
      if (!isVertical) {
        rightLineWidth = leftLineWidth < halfTooltipWidth
            ? halfTooltipWidth - leftLineWidth + rightLineWidth
            : rightLineWidth;
      }
      return _getRectangularPath(tooltipStartY, rightLineWidth,
          halfTooltipTriangleWidth, dy, tooltipHeight, leftLineWidth,
          isVertical: isVertical);
    }
  }

  Path _getRectangularPath(
      double tooltipStartY,
      double rightLineWidth,
      double halfTooltipTriangleWidth,
      double dy,
      double tooltipHeight,
      double leftLineWidth,
      {required bool isVertical,
      double? toolTipWidth,
      bool? isLeftTooltip}) {
    final Path path = Path();
    if (isVertical && toolTipWidth != null) {
      if (isLeftTooltip!) {
        path.moveTo(-tooltipStartY, 0);
        //     /
        final bool canAdjustTooltipNose =
            rightLineWidth < halfTooltipTriangleWidth;
        path.lineTo(-dy,
            canAdjustTooltipNose ? -rightLineWidth : -halfTooltipTriangleWidth);
        //       /
        //     |
        if (!canAdjustTooltipNose) {
          path.lineTo(-dy, -rightLineWidth + cornerRadius / 2);
        }
        path.quadraticBezierTo(
            -dy,
            canAdjustTooltipNose
                ? -rightLineWidth
                : -rightLineWidth + cornerRadius / 2,
            -dy - cornerRadius / 2,
            -rightLineWidth);
        //            /
        // __________|

        path.lineTo(-dy - toolTipWidth + cornerRadius / 2, -rightLineWidth);
        path.quadraticBezierTo(
            -dy - toolTipWidth + cornerRadius / 2,
            -rightLineWidth,
            -dy - toolTipWidth,
            -rightLineWidth + cornerRadius / 2);
        // |
        // |           /
        // |__________|
        path.lineTo(-dy - toolTipWidth, leftLineWidth - cornerRadius / 2);
        path.quadraticBezierTo(
          -dy - toolTipWidth,
          leftLineWidth - cornerRadius / 2,
          -dy - toolTipWidth + cornerRadius / 2,
          leftLineWidth,
        );
        //  _________
        // /
        // |
        // |            /
        // |__________|
        path.lineTo(-dy - cornerRadius / 2, leftLineWidth);
        //  __________
        // |          |
        // |
        // |           /
        // |__________|
        if (leftLineWidth > halfTooltipTriangleWidth) {
          path.quadraticBezierTo(-dy - cornerRadius / 2, leftLineWidth, -dy,
              leftLineWidth - cornerRadius / 2);
          path.lineTo(-dy, halfTooltipTriangleWidth);
        }
        //  __________
        // |          |
        // |           \
        // |           /
        // |__________|

        path.close();
      } else {
        path.moveTo(tooltipStartY, 0);
        //       \
        final bool canAdjustTooltipNose =
            rightLineWidth < halfTooltipTriangleWidth;
        path.lineTo(dy,
            canAdjustTooltipNose ? -rightLineWidth : -halfTooltipTriangleWidth);
        //       \
        //        |
        if (!canAdjustTooltipNose) {
          path.lineTo(dy, -rightLineWidth + cornerRadius / 2);
        }
        //        \
        //         |__________
        path.quadraticBezierTo(
            dy,
            canAdjustTooltipNose
                ? -rightLineWidth
                : -rightLineWidth + cornerRadius / 2,
            dy + cornerRadius / 2,
            -rightLineWidth);
        path.lineTo(dy + toolTipWidth - cornerRadius / 2, -rightLineWidth);
        //                    |
        //        \           |
        //         |__________|
        path.quadraticBezierTo(
            dy + toolTipWidth - cornerRadius / 2,
            -rightLineWidth,
            dy + toolTipWidth,
            -rightLineWidth + cornerRadius / 2);
        path.lineTo(dy + toolTipWidth, leftLineWidth - cornerRadius / 2);
        //         ___________
        //                    |
        //                    |
        //        \           |
        //         |__________|
        path.quadraticBezierTo(
          dy + toolTipWidth,
          leftLineWidth - cornerRadius / 2,
          dy + toolTipWidth - cornerRadius / 2,
          leftLineWidth,
        );
        path.lineTo(dy + cornerRadius / 2, leftLineWidth);
        //         ___________
        //        |           |
        //                    |
        //      \             |
        //        |__________|
        if (leftLineWidth > halfTooltipTriangleWidth) {
          path.quadraticBezierTo(dy + cornerRadius / 2, leftLineWidth, dy,
              leftLineWidth - cornerRadius / 2);
          path.lineTo(dy, halfTooltipTriangleWidth);
        }
        //         ___________
        //        |           |
        //      |             |
        //      \             |
        //        |__________|
        path.close();
      }
    } else {
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
      path.quadraticBezierTo(-leftLineWidth, -dy - tooltipHeight,
          -leftLineWidth, -dy - tooltipHeight + cornerRadius);
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
    }
    return path;
  }

  /// Draws the tooltip based on the values passed in the arguments.
  @override
  void paint(PaintingContext context, Offset thumbCenter, Offset offset,
      TextPainter textPainter,
      {required RenderBox parentBox,
      required SfSliderThemeData sliderThemeData,
      required Paint paint,
      required Animation<double> animation,
      required Rect trackRect}) {
    final double leftPadding = tooltipTextPadding.dx / 2;
    final double minLeftX = trackRect.left;
    // ignore: avoid_as
    final Path path = (_isVertical(parentBox as RenderBaseSlider))
        ? _updateRectangularTooltipWidth(textPainter.size + tooltipTextPadding,
            offset.dy, trackRect, thumbCenter.dy,
            isVertical: _isVertical(parentBox),
            isLeftTooltip: _isLeftTooltip(parentBox))
        : _updateRectangularTooltipWidth(textPainter.size + tooltipTextPadding,
            offset.dy, trackRect, thumbCenter.dx,
            isVertical: _isVertical(parentBox));

    context.canvas.save();
    context.canvas.translate(thumbCenter.dx, thumbCenter.dy);
    context.canvas.scale(animation.value);
    final Paint strokePaint = Paint();
    if (_hasTooltipOverlapStroke(parentBox) &&
        sliderThemeData.tooltipBackgroundColor != Colors.transparent) {
      if (sliderThemeData is SfRangeSliderThemeData) {
        strokePaint.color = sliderThemeData.overlappingTooltipStrokeColor!;
        strokePaint.style = PaintingStyle.stroke;
        strokePaint.strokeWidth = 1.0;
      } else if (sliderThemeData is SfRangeSelectorThemeData) {
        strokePaint.color = sliderThemeData.overlappingTooltipStrokeColor!;
        strokePaint.style = PaintingStyle.stroke;
        strokePaint.strokeWidth = 1.0;
      }
    }
    // This loop is used to avoid the improper rendering of tooltips in
    // web html rendering.
    else {
      strokePaint
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke;
    }
    context.canvas.drawPath(path, strokePaint);
    context.canvas.drawPath(path, paint);

    final Rect pathRect = path.getBounds();
    final double halfPathWidth = pathRect.width / 2;
    final double halfTextPainterWidth = textPainter.width / 2;
    final double rectLeftPosition = thumbCenter.dx - halfPathWidth;
    if (_isVertical(parentBox)) {
      final double halfPathHeight = pathRect.height / 2;
      final double halfTextPainterHeight = textPainter.height / 2;
      final double rectTopPosition = thumbCenter.dy - halfPathHeight;
      if (_isLeftTooltip(parentBox)) {
        final double dx = -offset.dy -
            tooltipTriangleHeight -
            (pathRect.size.width - tooltipTriangleHeight) / 2 -
            textPainter.width / 2;
        final double dy = rectTopPosition >= trackRect.top
            ? thumbCenter.dy + halfPathHeight >= trackRect.bottom
                ? -halfTextPainterHeight -
                    halfPathHeight -
                    thumbCenter.dy +
                    trackRect.bottom
                : -halfTextPainterHeight
            : -halfTextPainterHeight +
                halfPathHeight -
                thumbCenter.dy +
                trackRect.top;
        textPainter.paint(context.canvas, Offset(dx, dy));
      } else {
        final double dx = offset.dy +
            tooltipTriangleHeight +
            (pathRect.size.width - tooltipTriangleHeight) / 2 -
            textPainter.width / 2;
        final double dy = rectTopPosition >= trackRect.top
            ? thumbCenter.dy + halfPathHeight >= trackRect.bottom
                ? -halfTextPainterHeight -
                    halfPathHeight -
                    thumbCenter.dy +
                    trackRect.bottom
                : -halfTextPainterHeight
            : -halfTextPainterHeight +
                halfPathHeight -
                thumbCenter.dy +
                trackRect.top;
        textPainter.paint(context.canvas, Offset(dx, dy));
      }
    } else {
      final double dx = rectLeftPosition >= minLeftX
          ? thumbCenter.dx + halfTextPainterWidth + leftPadding >
                  trackRect.right
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
    }
    context.canvas.restore();
  }
}
