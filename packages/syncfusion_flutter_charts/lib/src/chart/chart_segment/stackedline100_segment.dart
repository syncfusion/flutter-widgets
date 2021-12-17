import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/src/chart/common/common.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/stacked_series_base.dart';
import '../chart_series/xy_data_series.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for 100% stacked line series.
///
/// Generates the stacked line100 series points and has the [calculateSegmentPoints] method overrided to customize
/// the stacked line100 segment point calculation.
///
/// Gets the path and color from the `series`.
class StackedLine100Segment extends ChartSegment {
  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Paint _fillPaint = Paint();
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the stacked line100 series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the stacked line100 series should be less than or equal to 1.');
    if (segmentProperties.color != null) {
      _fillPaint.color = segmentProperties.pointColorMapper ??
          segmentProperties.color!
              .withOpacity(segmentProperties.series.opacity);
    }
    _fillPaint.strokeWidth = segmentProperties.strokeWidth!;
    _fillPaint.style = PaintingStyle.fill;
    segmentProperties.defaultFillColor = _fillPaint;
    return _fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Paint _strokePaint = Paint();
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the stacked line100 series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the stacked line100 series should be less than or equal to 1.');
    if (segmentProperties.strokeColor != null) {
      _strokePaint.color =
          segmentProperties.pointColorMapper ?? segmentProperties.strokeColor!;
      _strokePaint.color = (segmentProperties.series.opacity < 1 == true &&
              _strokePaint.color != Colors.transparent)
          ? _strokePaint.color.withOpacity(segmentProperties.series.opacity)
          : _strokePaint.color;
    }
    _strokePaint.strokeWidth = segmentProperties.strokeWidth!;
    _strokePaint.style = PaintingStyle.stroke;
    _strokePaint.strokeCap = StrokeCap.round;
    segmentProperties.defaultStrokeColor = _strokePaint;
    setShader(segmentProperties, _strokePaint);
    return _strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final SeriesRendererDetails segmentSeriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    final Rect rect = calculatePlotOffset(
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
    final ChartLocation _nextLocation = calculatePoint(
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
    segmentProperties.x2 = _nextLocation.x;
    segmentProperties.y2 = _nextLocation.y;
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
