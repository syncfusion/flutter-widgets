import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/src/chart/common/segment_properties.dart';
import '../axis/axis.dart';
import '../chart_series/series.dart';
import '../chart_series/xy_data_series.dart';
import '../common/common.dart';
import '../common/renderer.dart';
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
    final Paint _fillPaint = Paint();
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the step line series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the step line series should be less than or equal to 1.');
    if (segmentProperties.color != null) {
      _fillPaint.color = segmentProperties.color!
          .withOpacity(segmentProperties.series.opacity);
    }
    _fillPaint.strokeWidth = segmentProperties.strokeWidth!;
    _fillPaint.style = PaintingStyle.stroke;
    segmentProperties.defaultFillColor = _fillPaint;
    return _fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Paint _strokePaint = Paint();
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
    _strokePaint.strokeCap = StrokeCap.square;
    segmentProperties.defaultStrokeColor = _strokePaint;
    setShader(segmentProperties, _strokePaint);
    return _strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final ChartAxisRendererDetails _xAxisRendererDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .xAxisDetails!;
    final ChartAxisRendererDetails _yAxisRendererDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .yAxisDetails!;
    final Rect _axisClipRect = calculatePlotOffset(
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
        _xAxisRendererDetails,
        _yAxisRendererDetails,
        segmentProperties.stateProperties.requireInvertedAxis,
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .series,
        _axisClipRect);
    _nextLocation = calculatePoint(
        segmentProperties.nextPoint!.xValue,
        segmentProperties.nextPoint!.yValue,
        _xAxisRendererDetails,
        _yAxisRendererDetails,
        segmentProperties.stateProperties.requireInvertedAxis,
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .series,
        _axisClipRect);
    _midLocation = calculatePoint(
        segmentProperties.midX,
        segmentProperties.midY,
        _xAxisRendererDetails,
        _yAxisRendererDetails,
        segmentProperties.stateProperties.requireInvertedAxis,
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .series,
        _axisClipRect);
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
    final Rect _rect = calculatePlotOffset(
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
      final SegmentProperties _currentSegmentProperties =
          SegmentHelper.getSegmentProperties(_currentSegment);
      SegmentProperties? _oldSegmentProperties;
      _oldSegment = (SeriesHelper.getSeriesRendererDetails(
                              _currentSegmentProperties.oldSeriesRenderer!)
                          .segments
                          .length -
                      1 >=
                  currentSegmentIndex! ==
              true)
          ? SeriesHelper.getSeriesRendererDetails(
                  _currentSegmentProperties.oldSeriesRenderer!)
              .segments[currentSegmentIndex!] as StepLineSegment?
          : null;
      if (_oldSegment != null) {
        _oldSegmentProperties =
            SegmentHelper.getSegmentProperties(_oldSegment!);
      }
      _oldX1 = _oldSegmentProperties?.x1;
      _oldY1 = _oldSegmentProperties?.y1;
      _oldX2 = _oldSegmentProperties?.x2;
      _oldY2 = _oldSegmentProperties?.y2;
      _oldX3 = _oldSegmentProperties?.x3;
      _oldY3 = _oldSegmentProperties?.y3;

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
        final ChartAxisRendererDetails _oldXAxisDetails =
            AxisHelper.getAxisRendererDetails(_oldXAxisRenderer!);
        final ChartAxisRendererDetails _oldYAxisDetails =
            AxisHelper.getAxisRendererDetails(_oldYAxisRenderer!);
        if (_oldYAxisRenderer != null && _oldXAxisRenderer != null) {
          _needAnimate = _oldYAxisDetails.visibleRange!.minimum !=
                  SeriesHelper.getSeriesRendererDetails(
                          segmentProperties.seriesRenderer)
                      .yAxisDetails!
                      .visibleRange!
                      .minimum ||
              _oldYAxisDetails.visibleRange!.maximum !=
                  SeriesHelper.getSeriesRendererDetails(
                          segmentProperties.seriesRenderer)
                      .yAxisDetails!
                      .visibleRange!
                      .maximum ||
              _oldXAxisDetails.visibleRange!.minimum !=
                  SeriesHelper.getSeriesRendererDetails(
                          segmentProperties.seriesRenderer)
                      .xAxisDetails!
                      .visibleRange!
                      .minimum ||
              _oldXAxisDetails.visibleRange!.maximum !=
                  SeriesHelper.getSeriesRendererDetails(
                          segmentProperties.seriesRenderer)
                      .xAxisDetails!
                      .visibleRange!
                      .maximum;
        }
        if (_needAnimate) {
          final ChartAxisRendererDetails _oldXAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldXAxisRenderer!);
          final ChartAxisRendererDetails _oldYAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldYAxisRenderer!);
          _oldLocation = calculatePoint(
              _x1Pos,
              _y1Pos,
              _oldXAxisDetails,
              _oldYAxisDetails,
              segmentProperties.stateProperties.requireInvertedAxis,
              segmentProperties.series,
              _rect);
          _oldX1 = _oldLocation!.x;
          _oldY1 = _oldLocation!.y;

          _oldLocation = calculatePoint(
              _x2Pos,
              _y2Pos,
              _oldXAxisDetails,
              _oldYAxisDetails,
              segmentProperties.stateProperties.requireInvertedAxis,
              segmentProperties.series,
              _rect);
          _oldX2 = _oldLocation!.x;
          _oldY2 = _oldLocation!.y;
          _oldLocation = calculatePoint(
              segmentProperties.midX,
              segmentProperties.midY,
              _oldXAxisDetails,
              _oldYAxisDetails,
              segmentProperties.stateProperties.requireInvertedAxis,
              segmentProperties.series,
              _rect);
          _oldX3 = _oldLocation!.x;
          _oldY3 = _oldLocation!.y;
        }
      }
      animateLineTypeSeries(
        canvas,
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer),
        strokePaint!,
        animationFactor,
        _currentSegmentProperties.x1,
        _currentSegmentProperties.y1,
        _currentSegmentProperties.x2,
        _currentSegmentProperties.y2,
        _oldX1,
        _oldY1,
        _oldX2,
        _oldY2,
        _currentSegmentProperties.x3,
        _currentSegmentProperties.y3,
        _oldX3,
        _oldY3,
      );
    } else {
      if (segmentProperties.series.dashArray[0] != 0 &&
          segmentProperties.series.dashArray[1] != 0) {
        segmentProperties.path
            .moveTo(segmentProperties.x1, segmentProperties.y1);
        segmentProperties.path
            .lineTo(segmentProperties.x3, segmentProperties.y3);
        segmentProperties.path
            .lineTo(segmentProperties.x2, segmentProperties.y2);
        drawDashedLine(canvas, segmentProperties.series.dashArray, strokePaint!,
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
