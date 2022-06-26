import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/common.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for bubble series.
///
/// Generates the bubble series points and has the [calculateSegmentPoints] override method
/// used to customize the bubble series segment point calculation.
///
/// Gets the path, stroke color and fill color from the `series` to render the bubble series.
class BubbleSegment extends ChartSegment {
  /// Center position of the bubble and size.
  late double _centerX, _centerY, _radius, _size;

  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();
    final SegmentProperties bubbleSegmentProperties = _segmentProperties;
    final bool hasPointColor =
        bubbleSegmentProperties.series.pointColorMapper != null;
    if (bubbleSegmentProperties.series.gradient == null) {
      if (bubbleSegmentProperties.color != null) {
        fillPaint = Paint()
          ..color = (bubbleSegmentProperties.currentPoint!.isEmpty ?? false)
              ? bubbleSegmentProperties.series.emptyPointSettings.color
              : ((hasPointColor &&
                      bubbleSegmentProperties.currentPoint!.pointColorMapper !=
                          null)
                  ? bubbleSegmentProperties.currentPoint!.pointColorMapper!
                  : bubbleSegmentProperties.color!)
          ..style = PaintingStyle.fill;
      }
    } else {
      fillPaint = getLinearGradientPaint(
          bubbleSegmentProperties.series.gradient!,
          bubbleSegmentProperties.currentPoint!.region!,
          SeriesHelper.getSeriesRendererDetails(
                  bubbleSegmentProperties.seriesRenderer)
              .stateProperties
              .requireInvertedAxis);
    }
    assert(bubbleSegmentProperties.series.opacity >= 0,
        'The opacity value of the bubble series should be greater than or equal to 0.');
    assert(bubbleSegmentProperties.series.opacity <= 1,
        'The opacity value of the bubble series should be less than or equal to 1.');
    if (fillPaint?.color != null) {
      fillPaint!.color = (bubbleSegmentProperties.series.opacity < 1 &&
              fillPaint!.color != Colors.transparent)
          ? fillPaint!.color.withOpacity(bubbleSegmentProperties.series.opacity)
          : fillPaint!.color;
    }
    bubbleSegmentProperties.defaultFillColor = fillPaint;
    setShader(_segmentProperties, fillPaint!);
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    _setSegmentProperties();
    final SegmentProperties bubbleSegmentProperties = _segmentProperties;
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (bubbleSegmentProperties.currentPoint!.isEmpty ?? false)
          ? bubbleSegmentProperties.series.emptyPointSettings.borderWidth
          : bubbleSegmentProperties.strokeWidth!;
    bubbleSegmentProperties.series.borderGradient != null
        ? strokePaint.shader = bubbleSegmentProperties.series.borderGradient!
            .createShader(bubbleSegmentProperties.currentPoint!.region!)
        : strokePaint.color =
            (bubbleSegmentProperties.currentPoint!.isEmpty ?? false)
                ? bubbleSegmentProperties.series.emptyPointSettings.borderColor
                : bubbleSegmentProperties.strokeColor!;
    bubbleSegmentProperties.series.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    bubbleSegmentProperties.defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    _setSegmentProperties();

    final SegmentProperties bubbleSegmentProperties = _segmentProperties;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            bubbleSegmentProperties.seriesRenderer);
    _centerX = _centerY = double.nan;
    final Rect rect = calculatePlotOffset(
        seriesRendererDetails.stateProperties.chartAxis.axisClipRect,
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    final ChartLocation location = calculatePoint(
        bubbleSegmentProperties.currentPoint!.xValue,
        bubbleSegmentProperties.currentPoint!.yValue,
        seriesRendererDetails.xAxisDetails!,
        seriesRendererDetails.yAxisDetails!,
        seriesRendererDetails.stateProperties.requireInvertedAxis,
        bubbleSegmentProperties.series,
        rect);
    _centerX = location.x;
    _centerY = location.y;
    if (bubbleSegmentProperties.seriesRenderer is BubbleSeriesRenderer)
      _radius = calculateBubbleRadius(
          seriesRendererDetails,
          bubbleSegmentProperties.series,
          bubbleSegmentProperties.currentPoint!);
    bubbleSegmentProperties.currentPoint!.region = Rect.fromLTRB(
        location.x - 2 * _radius,
        location.y - 2 * _radius,
        location.x + 2 * _radius,
        location.y + 2 * _radius);
    _size = _radius = bubbleSegmentProperties.currentPoint!.region!.width / 2;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();

    final SegmentProperties bubbleSegmentProperties = _segmentProperties;
    bubbleSegmentProperties.segmentRect = RRect.fromRectAndRadius(
        bubbleSegmentProperties.currentPoint!.region!, Radius.zero);
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            bubbleSegmentProperties.seriesRenderer);
    if (seriesRendererDetails.stateProperties.renderingDetails.widgetNeedUpdate == true &&
        seriesRendererDetails.reAnimate == false &&
        seriesRendererDetails
                .stateProperties.renderingDetails.isLegendToggled ==
            false &&
        seriesRendererDetails.stateProperties.oldSeriesRenderers.isNotEmpty ==
            true &&
        bubbleSegmentProperties.oldSeriesRenderer != null &&
        SeriesHelper.getSeriesRendererDetails(
                    bubbleSegmentProperties.oldSeriesRenderer!)
                .segments
                .isNotEmpty ==
            true &&
        SeriesHelper.getSeriesRendererDetails(
                bubbleSegmentProperties.oldSeriesRenderer!)
            .segments[0] is BubbleSegment &&
        bubbleSegmentProperties.series.animationDuration > 0 &&
        bubbleSegmentProperties.oldPoint != null) {
      final BubbleSegment currentSegment =
          seriesRendererDetails.segments[currentSegmentIndex!] as BubbleSegment;
      final SegmentProperties seriesSegmentProperties =
          SegmentHelper.getSegmentProperties(currentSegment);
      final SeriesRendererDetails oldSeriesDetails =
          SeriesHelper.getSeriesRendererDetails(
              seriesSegmentProperties.oldSeriesRenderer!);
      final BubbleSegment? oldSegment =
          (oldSeriesDetails.segments.length - 1 >= currentSegmentIndex! == true)
              ? oldSeriesDetails.segments[currentSegmentIndex!]
                  as BubbleSegment?
              : null;
      animateBubbleSeries(
          canvas,
          _centerX,
          _centerY,
          oldSegment?._centerX,
          oldSegment?._centerY,
          oldSegment?._size,
          animationFactor,
          _radius,
          strokePaint!,
          fillPaint!,
          bubbleSegmentProperties.seriesRenderer);
    } else {
      canvas.drawCircle(
          Offset(_centerX, _centerY), _radius * animationFactor, fillPaint!);
      canvas.drawCircle(
          Offset(_centerX, _centerY), _radius * animationFactor, strokePaint!);
    }
  }

  /// Method to set segment properties.
  void _setSegmentProperties() {
    if (!_isInitialize) {
      _segmentProperties = SegmentHelper.getSegmentProperties(this);
      _isInitialize = true;
    }
  }
}
