import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for waterfall series.
///
/// Generates the waterfall series points and has the [calculateSegmentPoints] method overrided to customize
/// the waterfall segment point calculation.
///
/// Gets the path and color from the `series`.
class WaterfallSegment extends ChartSegment {
  /// To find the x and y values of connector lines between each data point.
  late double _x1, _y1, _x2, _y2;

  /// Get the connector line paint.
  Paint? connectorLineStrokePaint;

  /// We are using `segmentRect` to draw the bar segment in the series.
  /// we can override this class and customize the waterfall segment by getting `segmentRect`.
  late RRect segmentRect;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final CartesianChartPoint<dynamic>? currentPoint =
        segmentProperties.currentPoint;
    final bool hasPointColor =
        segmentProperties.series.pointColorMapper != null;

    /// Get and set the paint options for waterfall series.
    if (segmentProperties.series.gradient == null) {
      fillPaint = Paint()
        ..color = ((hasPointColor && currentPoint!.pointColorMapper != null)
            ? currentPoint.pointColorMapper
            : currentPoint!.isIntermediateSum!
                ? segmentProperties.intermediateSumColor ??
                    segmentProperties.color!
                : currentPoint.isTotalSum!
                    ? segmentProperties.totalSumColor ??
                        segmentProperties.color!
                    : currentPoint.yValue < 0 == true
                        ? segmentProperties.negativePointsColor ??
                            segmentProperties.color!
                        : segmentProperties.color!)!
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = getLinearGradientPaint(
          segmentProperties.series.gradient!,
          segmentProperties.currentPoint!.region!,
          segmentProperties.stateProperties.requireInvertedAxis);
    }
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the waterfall series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the waterfall series should be less than or equal to 1.');
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
      ..strokeWidth = segmentProperties.strokeWidth!;
    segmentProperties.defaultStrokeColor = strokePaint;
    segmentProperties.series.borderGradient != null
        ? strokePaint!.shader = segmentProperties.series.borderGradient!
            .createShader(segmentProperties.currentPoint!.region!)
        : strokePaint!.color = segmentProperties.strokeColor!;
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
    final WaterfallSeries<dynamic, dynamic> series =
        segmentProperties.series as WaterfallSeries<dynamic, dynamic>;
    CartesianChartPoint<dynamic> oldPaint;
    final Path linePath = Path();

    if (fillPaint != null) {
      (series.animationDuration > 0 &&
              segmentProperties
                      .stateProperties.renderingDetails.isLegendToggled ==
                  false)
          ? animateRangeColumn(
              canvas,
              SeriesHelper.getSeriesRendererDetails(
                  segmentProperties.seriesRenderer),
              fillPaint!,
              segmentRect,
              segmentProperties.oldPoint != null
                  ? segmentProperties.oldPoint!.region
                  : segmentProperties.oldRegion,
              animationFactor)
          : canvas.drawRRect(segmentRect, fillPaint!);
    }
    if (strokePaint != null) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              segmentProperties.seriesRenderer);
      (seriesRendererDetails.dashArray![0] != 0 &&
              seriesRendererDetails.dashArray![1] != 0)
          ? drawDashedLine(canvas, seriesRendererDetails.dashArray!,
              strokePaint!, segmentProperties.path)
          : (series.animationDuration > 0 &&
                  segmentProperties
                          .stateProperties.renderingDetails.isLegendToggled ==
                      false)
              ? animateRangeColumn(
                  canvas,
                  SeriesHelper.getSeriesRendererDetails(
                      segmentProperties.seriesRenderer),
                  strokePaint!,
                  segmentRect,
                  segmentProperties.oldPoint != null
                      ? segmentProperties.oldPoint!.region
                      : segmentProperties.oldRegion,
                  animationFactor)
              : canvas.drawRRect(segmentRect, strokePaint!);
    }
    if (connectorLineStrokePaint != null &&
        segmentProperties.currentPoint!.overallDataPointIndex! > 0 == true) {
      oldPaint = SeriesHelper.getSeriesRendererDetails(
                  segmentProperties.seriesRenderer)
              .dataPoints[
          segmentProperties.currentPoint!.overallDataPointIndex! - 1];
      _x1 = oldPaint.endValueRightPoint!.x;
      _y1 = oldPaint.endValueRightPoint!.y;
      if (segmentProperties.currentPoint!.isTotalSum! == true ||
          segmentProperties.currentPoint!.isIntermediateSum! == true) {
        _x2 = segmentProperties.currentPoint!.endValueLeftPoint!.x;
        _y2 = segmentProperties.currentPoint!.endValueLeftPoint!.y;
      } else {
        _x2 = segmentProperties.currentPoint!.originValueLeftPoint!.x;
        _y2 = segmentProperties.currentPoint!.originValueLeftPoint!.y;
      }
      if (series.animationDuration <= 0 ||
          animationFactor >=
              segmentProperties.stateProperties.seriesDurationFactor) {
        if (series.connectorLineSettings.dashArray![0] != 0 &&
            series.connectorLineSettings.dashArray![1] != 0) {
          linePath.moveTo(_x1, _y1);
          linePath.lineTo(_x2, _y2);
          drawDashedLine(canvas, series.connectorLineSettings.dashArray!,
              connectorLineStrokePaint!, linePath);
        } else {
          canvas.drawLine(
              Offset(_x1, _y1), Offset(_x2, _y2), connectorLineStrokePaint!);
        }
      }
    }
  }
}
