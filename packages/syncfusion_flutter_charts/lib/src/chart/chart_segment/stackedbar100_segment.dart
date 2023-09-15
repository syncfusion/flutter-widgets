import 'package:flutter/material.dart';
import '../common/common.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for 100% stacked bar series.
///
/// Generates the stacked bar100 series points and has the [calculateSegmentPoints] method overrides to customize
/// the stacked bar100 segment point calculation.
///
/// Gets the path and color from the `series`.
class StackedBar100Segment extends ChartSegment {
  /// Stacked value of the segments.
  late double stackValues;

  /// Rectangle of the segment
  late RRect segmentRect;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);

    /// Get and set the paint options for column series.
    if (segmentProperties.series.gradient == null) {
      fillPaint = Paint()
        ..color = segmentProperties.currentPoint!.isEmpty != null &&
                segmentProperties.currentPoint!.isEmpty! == true
            ? segmentProperties.series.emptyPointSettings.color
            : (segmentProperties.currentPoint!.pointColorMapper ??
                segmentProperties.color!)
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = getLinearGradientPaint(
          segmentProperties.series.gradient!,
          segmentProperties.currentPoint!.region!,
          segmentProperties.stateProperties.requireInvertedAxis);
    }
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the stacked bar 100 series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the stacked bar 100 series should be less than or equal to 1.');
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
    strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = segmentProperties.currentPoint!.isEmpty != null &&
              segmentProperties.currentPoint!.isEmpty! == true
          ? segmentProperties.series.emptyPointSettings.borderWidth
          : segmentProperties.strokeWidth!;
    if (segmentProperties.series.borderGradient != null) {
      strokePaint!.shader = segmentProperties.series.borderGradient!
          .createShader(segmentProperties.currentPoint!.region!);
    } else if (segmentProperties.strokeColor != null) {
      strokePaint!.color = segmentProperties.currentPoint!.isEmpty != null &&
              segmentProperties.currentPoint!.isEmpty! == true
          ? segmentProperties.series.emptyPointSettings.borderColor
          : segmentProperties.strokeColor!;
    }
    segmentProperties.defaultStrokeColor = strokePaint;
    segmentProperties.series.borderWidth == 0
        ? strokePaint!.color = Colors.transparent
        : strokePaint!.color;
    return strokePaint!;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    renderStackingRectSeries(
        fillPaint,
        strokePaint,
        segmentProperties.path,
        animationFactor,
        segmentProperties.seriesRenderer,
        canvas,
        segmentRect,
        segmentProperties.currentPoint!,
        currentSegmentIndex!);
  }
}
