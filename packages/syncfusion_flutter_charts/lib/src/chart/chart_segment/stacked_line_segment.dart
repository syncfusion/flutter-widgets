import 'package:flutter/material.dart';

import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/stacked_series_base.dart';
import '../chart_series/xy_data_series.dart';
import '../common/common.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for 100% stacked line series.
///
/// Generates the stacked line100 series points and has the  [calculateSegmentPoints] method overrided to customize
/// the stacked line100 segment point calculation.
///
/// Gets the path and color from the `series`.
class StackedLineSegment extends ChartSegment {
  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Paint fillPaint = Paint();
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the stacked line series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the stacked line series should be less than or equal to 1.');
    if (segmentProperties.color != null) {
      fillPaint.color = segmentProperties.pointColorMapper ??
          segmentProperties.color!
              .withOpacity(segmentProperties.series.opacity);
    }
    fillPaint.strokeWidth = segmentProperties.strokeWidth!;
    fillPaint.style = PaintingStyle.fill;
    segmentProperties.defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Paint strokePaint = Paint();
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the stacked line series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the stacked line series should be less than or equal to 1.');
    if (segmentProperties.strokeColor != null) {
      strokePaint.color =
          segmentProperties.pointColorMapper ?? segmentProperties.strokeColor!;
      strokePaint.color = (segmentProperties.series.opacity < 1 == true &&
              strokePaint.color != Colors.transparent)
          ? strokePaint.color.withOpacity(segmentProperties.series.opacity)
          : strokePaint.color;
    }
    strokePaint.strokeWidth = segmentProperties.strokeWidth!;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    segmentProperties.defaultStrokeColor = strokePaint;
    setShader(segmentProperties, strokePaint);
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final SeriesRendererDetails segmentSeriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    late Rect rect;
    rect = calculatePlotOffset(
        segmentProperties.stateProperties.chartAxis.axisClipRect,
        Offset(segmentSeriesRendererDetails.xAxisDetails!.axis.plotOffset,
            segmentSeriesRendererDetails.yAxisDetails!.axis.plotOffset));

    final ChartLocation currentChartPoint = calculatePoint(
        segmentProperties.currentPoint!.xValue,
        segmentProperties.currentCummulativePos,
        segmentSeriesRendererDetails.xAxisDetails!,
        segmentSeriesRendererDetails.yAxisDetails!,
        segmentProperties.stateProperties.requireInvertedAxis,
        segmentProperties.series,
        rect);
    final ChartLocation nextLocation = calculatePoint(
        segmentProperties.nextPoint!.xValue,
        segmentProperties.nextCummulativePos,
        segmentSeriesRendererDetails.xAxisDetails!,
        segmentSeriesRendererDetails.yAxisDetails!,
        segmentProperties.stateProperties.requireInvertedAxis,
        segmentProperties.series,
        rect);

    final ChartLocation currentCummulativePoint = calculatePoint(
        segmentProperties.currentPoint!.xValue,
        segmentProperties.currentCummulativePos,
        segmentSeriesRendererDetails.xAxisDetails!,
        segmentSeriesRendererDetails.yAxisDetails!,
        segmentProperties.stateProperties.requireInvertedAxis,
        segmentProperties.series,
        rect);

    final ChartLocation nextCummulativePoint = calculatePoint(
        segmentProperties.nextPoint!.xValue,
        segmentProperties.nextCummulativePos,
        segmentSeriesRendererDetails.xAxisDetails!,
        segmentSeriesRendererDetails.yAxisDetails!,
        segmentProperties.stateProperties.requireInvertedAxis,
        segmentProperties.series,
        rect);

    segmentProperties.x1 = currentChartPoint.x;
    segmentProperties.y1 = currentChartPoint.y;
    segmentProperties.x2 = nextLocation.x;
    segmentProperties.y2 = nextLocation.y;
    segmentProperties.currentCummulativeValue = currentCummulativePoint.y;
    segmentProperties.nextCummulativeValue = nextCummulativePoint.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    renderStackedLineSeries(
        segmentProperties.series as StackedSeriesBase<dynamic, dynamic>,
        canvas,
        strokePaint!,
        segmentProperties.x1,
        segmentProperties.y1,
        segmentProperties.x2,
        segmentProperties.y2);
  }
}
