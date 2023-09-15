import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../axis/axis.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for step line series.
///
/// Generates the step line series points and has the [calculateSegmentPoints] method overrides to customize
/// the step line segment point calculation.
///
/// Gets the path and color from the `series`.
class StepLineSegment extends ChartSegment {
  late double _x1Pos, _y1Pos, _x2Pos, _y2Pos;

  double? _oldX1, _oldY1, _oldX2, _oldY2, _oldX3, _oldY3;
  late bool _needAnimate;
  ChartAxisRenderer? _oldXAxisRenderer, _oldYAxisRenderer;
  late ChartLocation _currentLocation, _midLocation, _nextLocation;
  ChartLocation? _oldLocation;
  late StepLineSegment _currentSegment;
  StepLineSegment? _oldSegment;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Paint fillPaint = Paint();
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the step line series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the step line series should be less than or equal to 1.');
    if (segmentProperties.color != null) {
      fillPaint.color = segmentProperties.color!
          .withOpacity(segmentProperties.series.opacity);
    }
    fillPaint.strokeWidth = segmentProperties.strokeWidth!;
    fillPaint.style = PaintingStyle.stroke;
    segmentProperties.defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Paint strokePaint = Paint();
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
    strokePaint.strokeCap = StrokeCap.square;
    segmentProperties.defaultStrokeColor = strokePaint;
    setShader(segmentProperties, strokePaint);
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final ChartAxisRendererDetails xAxisRendererDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .xAxisDetails!;
    final ChartAxisRendererDetails yAxisRendererDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .yAxisDetails!;
    final Rect axisClipRect = calculatePlotOffset(
        segmentProperties.stateProperties.chartAxis.axisClipRect,
        Offset(
            SeriesHelper.getSeriesRendererDetails(
                    segmentProperties.seriesRenderer)
                .xAxisDetails!
                .axis
                .plotOffset,
            SeriesHelper.getSeriesRendererDetails(
                    segmentProperties.seriesRenderer)
                .yAxisDetails!
                .axis
                .plotOffset));
    _currentLocation = calculatePoint(
        segmentProperties.currentPoint!.xValue,
        segmentProperties.currentPoint!.yValue,
        xAxisRendererDetails,
        yAxisRendererDetails,
        segmentProperties.stateProperties.requireInvertedAxis,
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .series,
        axisClipRect);
    _nextLocation = calculatePoint(
        segmentProperties.nextPoint!.xValue,
        segmentProperties.nextPoint!.yValue,
        xAxisRendererDetails,
        yAxisRendererDetails,
        segmentProperties.stateProperties.requireInvertedAxis,
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .series,
        axisClipRect);
    _midLocation = calculatePoint(
        segmentProperties.midX,
        segmentProperties.midY,
        xAxisRendererDetails,
        yAxisRendererDetails,
        segmentProperties.stateProperties.requireInvertedAxis,
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .series,
        axisClipRect);
    segmentProperties.x1 = _currentLocation.x;
    segmentProperties.y1 = _currentLocation.y;
    segmentProperties.x2 = _nextLocation.x;
    segmentProperties.y2 = _nextLocation.y;
    segmentProperties.x3 = _midLocation.x;
    segmentProperties.y3 = _midLocation.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Rect rect = calculatePlotOffset(
        segmentProperties.stateProperties.chartAxis.axisClipRect,
        Offset(
            SeriesHelper.getSeriesRendererDetails(
                    segmentProperties.seriesRenderer)
                .xAxisDetails!
                .axis
                .plotOffset,
            SeriesHelper.getSeriesRendererDetails(
                    segmentProperties.seriesRenderer)
                .yAxisDetails!
                .axis
                .plotOffset));
    segmentProperties.path = Path();
    if (segmentProperties.series.animationDuration > 0 == true &&
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer).reAnimate ==
            false &&
        segmentProperties.stateProperties.renderingDetails.widgetNeedUpdate ==
            true &&
        segmentProperties.stateProperties.renderingDetails.isLegendToggled ==
            false &&
        segmentProperties.stateProperties.oldSeriesRenderers.isNotEmpty ==
            true &&
        segmentProperties.oldSeriesRenderer != null &&
        SeriesHelper.getSeriesRendererDetails(segmentProperties.oldSeriesRenderer!)
                .segments
                .isNotEmpty ==
            true &&
        SeriesHelper.getSeriesRendererDetails(segmentProperties.oldSeriesRenderer!)
            .segments[0] is StepLineSegment &&
        segmentProperties.stateProperties.oldSeriesRenderers.length - 1 >=
                SegmentHelper.getSegmentProperties(SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer).segments[currentSegmentIndex!])
                    .seriesIndex ==
            true &&
        SeriesHelper.getSeriesRendererDetails(SegmentHelper.getSegmentProperties(
                        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
                            .segments[currentSegmentIndex!])
                    .oldSeriesRenderer!)
                .segments
                .isNotEmpty ==
            true) {
      _currentSegment = SeriesHelper.getSeriesRendererDetails(
              segmentProperties.seriesRenderer)
          .segments[currentSegmentIndex!] as StepLineSegment;
      final SegmentProperties currentSegmentProperties =
          SegmentHelper.getSegmentProperties(_currentSegment);
      SegmentProperties? oldSegmentProperties;
      _oldSegment = (SeriesHelper.getSeriesRendererDetails(
                              currentSegmentProperties.oldSeriesRenderer!)
                          .segments
                          .length -
                      1 >=
                  currentSegmentIndex! ==
              true)
          ? SeriesHelper.getSeriesRendererDetails(
                  currentSegmentProperties.oldSeriesRenderer!)
              .segments[currentSegmentIndex!] as StepLineSegment?
          : null;
      if (_oldSegment != null) {
        oldSegmentProperties = SegmentHelper.getSegmentProperties(_oldSegment!);
      }
      _oldX1 = oldSegmentProperties?.x1;
      _oldY1 = oldSegmentProperties?.y1;
      _oldX2 = oldSegmentProperties?.x2;
      _oldY2 = oldSegmentProperties?.y2;
      _oldX3 = oldSegmentProperties?.x3;
      _oldY3 = oldSegmentProperties?.y3;

      if (_oldSegment != null &&
          (_oldX1!.isNaN || _oldX2!.isNaN) &&
          segmentProperties.stateProperties.oldAxisRenderers.isNotEmpty ==
              false) {
        _oldXAxisRenderer = getOldAxisRenderer(
            SeriesHelper.getSeriesRendererDetails(
                    segmentProperties.seriesRenderer)
                .xAxisDetails!
                .axisRenderer,
            segmentProperties.stateProperties.oldAxisRenderers);
        _oldYAxisRenderer = getOldAxisRenderer(
            SeriesHelper.getSeriesRendererDetails(
                    segmentProperties.seriesRenderer)
                .yAxisDetails!
                .axisRenderer,
            segmentProperties.stateProperties.oldAxisRenderers);
        final ChartAxisRendererDetails oldXAxisDetails =
            AxisHelper.getAxisRendererDetails(_oldXAxisRenderer!);
        final ChartAxisRendererDetails oldYAxisDetails =
            AxisHelper.getAxisRendererDetails(_oldYAxisRenderer!);
        if (_oldYAxisRenderer != null && _oldXAxisRenderer != null) {
          _needAnimate = oldYAxisDetails.visibleRange!.minimum !=
                  SeriesHelper.getSeriesRendererDetails(
                          segmentProperties.seriesRenderer)
                      .yAxisDetails!
                      .visibleRange!
                      .minimum ||
              oldYAxisDetails.visibleRange!.maximum !=
                  SeriesHelper.getSeriesRendererDetails(
                          segmentProperties.seriesRenderer)
                      .yAxisDetails!
                      .visibleRange!
                      .maximum ||
              oldXAxisDetails.visibleRange!.minimum !=
                  SeriesHelper.getSeriesRendererDetails(
                          segmentProperties.seriesRenderer)
                      .xAxisDetails!
                      .visibleRange!
                      .minimum ||
              oldXAxisDetails.visibleRange!.maximum !=
                  SeriesHelper.getSeriesRendererDetails(
                          segmentProperties.seriesRenderer)
                      .xAxisDetails!
                      .visibleRange!
                      .maximum;
        }
        if (_needAnimate) {
          final ChartAxisRendererDetails oldXAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldXAxisRenderer!);
          final ChartAxisRendererDetails oldYAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldYAxisRenderer!);
          _oldLocation = calculatePoint(
              _x1Pos,
              _y1Pos,
              oldXAxisDetails,
              oldYAxisDetails,
              segmentProperties.stateProperties.requireInvertedAxis,
              segmentProperties.series,
              rect);
          _oldX1 = _oldLocation!.x;
          _oldY1 = _oldLocation!.y;

          _oldLocation = calculatePoint(
              _x2Pos,
              _y2Pos,
              oldXAxisDetails,
              oldYAxisDetails,
              segmentProperties.stateProperties.requireInvertedAxis,
              segmentProperties.series,
              rect);
          _oldX2 = _oldLocation!.x;
          _oldY2 = _oldLocation!.y;
          _oldLocation = calculatePoint(
              segmentProperties.midX,
              segmentProperties.midY,
              oldXAxisDetails,
              oldYAxisDetails,
              segmentProperties.stateProperties.requireInvertedAxis,
              segmentProperties.series,
              rect);
          _oldX3 = _oldLocation!.x;
          _oldY3 = _oldLocation!.y;
        }
      }
      animateLineTypeSeries(
        canvas,
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer),
        strokePaint!,
        animationFactor,
        currentSegmentProperties.x1,
        currentSegmentProperties.y1,
        currentSegmentProperties.x2,
        currentSegmentProperties.y2,
        _oldX1,
        _oldY1,
        _oldX2,
        _oldY2,
        currentSegmentProperties.x3,
        currentSegmentProperties.y3,
        _oldX3,
        _oldY3,
      );
    } else {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              segmentProperties.seriesRenderer);
      if (seriesRendererDetails.dashArray![0] != 0 &&
          seriesRendererDetails.dashArray![1] != 0) {
        segmentProperties.path
            .moveTo(segmentProperties.x1, segmentProperties.y1);
        segmentProperties.path
            .lineTo(segmentProperties.x3, segmentProperties.y3);
        segmentProperties.path
            .lineTo(segmentProperties.x2, segmentProperties.y2);
        drawDashedLine(canvas, seriesRendererDetails.dashArray!, strokePaint!,
            segmentProperties.path);
      } else {
        canvas.drawLine(Offset(segmentProperties.x1, segmentProperties.y1),
            Offset(segmentProperties.x3, segmentProperties.y3), strokePaint!);
        canvas.drawLine(Offset(segmentProperties.x3, segmentProperties.y3),
            Offset(segmentProperties.x2, segmentProperties.y2), strokePaint!);
      }
    }
  }
}
