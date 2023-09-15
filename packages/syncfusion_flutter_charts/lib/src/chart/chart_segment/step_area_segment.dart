import 'package:flutter/material.dart';
import '../common/common.dart';

import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for  step area series.
///
/// Generates the step area series points and has the [calculateSegmentPoints] method overrides to customize
/// the step area segment point calculation.
///
/// Gets the path and color from the `series`.
class StepAreaSegment extends ChartSegment {
  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    fillPaint = Paint();
    if (segmentProperties.series.gradient == null) {
      if (segmentProperties.color != null) {
        fillPaint!.color = segmentProperties.color!;
        fillPaint!.style = PaintingStyle.fill;
      }
    } else {
      // ignore: unnecessary_null_comparison
      fillPaint = (segmentProperties.pathRect != null)
          ? getLinearGradientPaint(
              segmentProperties.series.gradient!,
              segmentProperties.pathRect!,
              segmentProperties.stateProperties.requireInvertedAxis)
          : fillPaint;
    }
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the the step area series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the the step area series should be less than or equal to 1.');
    fillPaint!.color = (segmentProperties.series.opacity < 1 == true &&
            fillPaint!.color != Colors.transparent)
        ? fillPaint!.color.withOpacity(segmentProperties.series.opacity)
        : fillPaint!.color;
    segmentProperties.defaultFillColor = fillPaint;
    setShader(segmentProperties, fillPaint!);
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Paint strokePaint = Paint();
    if (segmentProperties.strokeColor != null) {
      strokePaint
        ..color = segmentProperties.series.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = segmentProperties.series.borderWidth;
      segmentProperties.series.borderWidth == 0
          ? strokePaint.color = Colors.transparent
          : strokePaint.color;
    }
    strokePaint.strokeCap = StrokeCap.round;
    segmentProperties.defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    segmentProperties.pathRect = segmentProperties.path.getBounds();
    canvas.drawPath(
        segmentProperties.path,
        (segmentProperties.series.gradient == null)
            ? fillPaint!
            : getFillPaint());

    if (strokePaint!.color != Colors.transparent) {
      drawDashedLine(canvas, segmentProperties.series.dashArray, strokePaint!,
          segmentProperties.strokePath!);
    }
  }
}
