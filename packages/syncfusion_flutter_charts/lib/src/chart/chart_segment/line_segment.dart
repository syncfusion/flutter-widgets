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

/// Creates the segments for line series.
///
/// Line segment is a part of a line series that is bounded by two distinct end point.
/// Generates the line series points and has the [calculateSegmentPoints] override method
/// used to customize the line series segment point calculation.
///
/// Gets the path, stroke color and fill color from the `series`.
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class LineSegment extends ChartSegment {
  /// Old segment points.
  double? _oldX1, _oldY1, _oldX2, _oldY2;

  late bool _needAnimate, _newlyAddedSegment = false;

  late Rect _axisClipRect;

  late ChartLocation _first, _second, _currentPointLocation, _nextPointLocation;

  late ChartAxisRendererDetails _xAxisRenderer, _yAxisRenderer;
  ChartAxisRenderer? _oldXAxisRenderer, _oldYAxisRenderer;

  late LineSegment _currentSegment;
  LineSegment? _oldSegment;
  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();

    final Paint fillPaint = Paint();
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the line series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the line series should be less than or equal to 1.');
    if (_segmentProperties.color != null) {
      fillPaint.color = _segmentProperties.pointColorMapper ??
          _segmentProperties.color!
              .withOpacity(_segmentProperties.series.opacity);
    }
    fillPaint.strokeWidth = _segmentProperties.strokeWidth!;
    fillPaint.style = PaintingStyle.fill;
    _segmentProperties.defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    _setSegmentProperties();

    final Paint strokePaint = Paint();
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the line series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the line series should be less than or equal to 1.');
    if (_segmentProperties.strokeColor != null) {
      strokePaint.color = _segmentProperties.pointColorMapper ??
          _segmentProperties.strokeColor!;
      strokePaint.color = (_segmentProperties.series.opacity < 1 == true &&
              strokePaint.color != Colors.transparent)
          ? strokePaint.color.withOpacity(_segmentProperties.series.opacity)
          : strokePaint.color;
    }
    strokePaint.strokeWidth = _segmentProperties.strokeWidth!;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    _segmentProperties.defaultStrokeColor = strokePaint;
    setShader(_segmentProperties, strokePaint);
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    _setSegmentProperties();
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            _segmentProperties.seriesRenderer);
    _xAxisRenderer = seriesRendererDetails.xAxisDetails!;
    _yAxisRenderer = seriesRendererDetails.yAxisDetails!;
    _axisClipRect = calculatePlotOffset(
        _segmentProperties.stateProperties.chartAxis.axisClipRect,
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    _currentPointLocation = calculatePoint(
        _segmentProperties.currentPoint!.xValue,
        _segmentProperties.currentPoint!.yValue,
        _xAxisRenderer,
        _yAxisRenderer,
        _segmentProperties.stateProperties.requireInvertedAxis,
        _segmentProperties.series,
        _axisClipRect);
    _segmentProperties.x1 = _currentPointLocation.x;
    _segmentProperties.y1 = _currentPointLocation.y;
    _nextPointLocation = calculatePoint(
        _segmentProperties.nextPoint!.xValue,
        _segmentProperties.nextPoint!.yValue,
        _xAxisRenderer,
        _yAxisRenderer,
        _segmentProperties.stateProperties.requireInvertedAxis,
        _segmentProperties.series,
        _axisClipRect);
    _segmentProperties.x2 = _nextPointLocation.x;
    _segmentProperties.y2 = _nextPointLocation.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();
    double? prevX, prevY;
    LineSegment? prevSegment;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            _segmentProperties.seriesRenderer);

    final Rect rect = calculatePlotOffset(
        _segmentProperties.stateProperties.chartAxis.axisClipRect,
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    _segmentProperties.path = Path();
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(
            seriesRendererDetails.segments[currentSegmentIndex!]);
    if (_segmentProperties.series.animationDuration > 0 == true &&
        seriesRendererDetails.reAnimate == false &&
        _segmentProperties.oldSeriesRenderer != null &&
        SeriesHelper.getSeriesRendererDetails(
                    _segmentProperties.oldSeriesRenderer!)
                .segments
                .isNotEmpty ==
            true &&
        SeriesHelper.getSeriesRendererDetails(
                _segmentProperties.oldSeriesRenderer!)
            .segments[0] is LineSegment &&
        _segmentProperties.stateProperties.oldSeriesRenderers.length - 1 >=
                segmentProperties.seriesIndex ==
            true &&
        SeriesHelper.getSeriesRendererDetails(
                    segmentProperties.oldSeriesRenderer!)
                .segments
                .isNotEmpty ==
            true) {
      _currentSegment =
          seriesRendererDetails.segments[currentSegmentIndex!] as LineSegment;
      final SeriesRendererDetails oldSeriesDetails =
          SeriesHelper.getSeriesRendererDetails(
              SegmentHelper.getSegmentProperties(_currentSegment)
                  .oldSeriesRenderer!);
      _oldSegment =
          (oldSeriesDetails.segments.length - 1 >= currentSegmentIndex! == true)
              ? oldSeriesDetails.segments[currentSegmentIndex!] as LineSegment?
              : null;
      if (currentSegmentIndex! > 0) {
        prevSegment =
            (oldSeriesDetails.segments.length - 1 >= currentSegmentIndex! - 1 ==
                    true)
                ? oldSeriesDetails.segments[currentSegmentIndex! - 1]
                    as LineSegment?
                : null;
      }
      _oldX1 = _oldSegment?._segmentProperties.x1;
      _oldY1 = _oldSegment?._segmentProperties.y1;
      _oldX2 = _oldSegment?._segmentProperties.x2;
      _oldY2 = _oldSegment?._segmentProperties.y2;
      if (_oldSegment == null &&
          _segmentProperties
                  .stateProperties.renderingDetails.widgetNeedUpdate ==
              true) {
        _newlyAddedSegment = true;
        prevX = prevSegment?._segmentProperties.x2;
        prevY = prevSegment?._segmentProperties.y2;
      } else {
        _newlyAddedSegment = false;
      }
      if (_oldSegment != null &&
          (_oldX1!.isNaN || _oldX2!.isNaN) &&
          _segmentProperties.stateProperties.oldAxisRenderers.isNotEmpty ==
              true) {
        _oldXAxisRenderer = getOldAxisRenderer(
            seriesRendererDetails.xAxisDetails!.axisRenderer,
            _segmentProperties.stateProperties.oldAxisRenderers);
        _oldYAxisRenderer = getOldAxisRenderer(
            seriesRendererDetails.yAxisDetails!.axisRenderer,
            _segmentProperties.stateProperties.oldAxisRenderers);
        if (_oldYAxisRenderer != null && _oldXAxisRenderer != null) {
          final ChartAxisRendererDetails oldXAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldXAxisRenderer!);
          final ChartAxisRendererDetails oldYAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldYAxisRenderer!);
          _needAnimate = oldYAxisDetails.visibleRange!.minimum !=
                  seriesRendererDetails.yAxisDetails!.visibleRange!.minimum ||
              oldYAxisDetails.visibleRange!.maximum !=
                  seriesRendererDetails.yAxisDetails!.visibleRange!.maximum ||
              oldXAxisDetails.visibleRange!.minimum !=
                  seriesRendererDetails.xAxisDetails!.visibleRange!.minimum ||
              oldXAxisDetails.visibleRange!.maximum !=
                  seriesRendererDetails.xAxisDetails!.visibleRange!.maximum;
        }
        if (_needAnimate) {
          final ChartAxisRendererDetails oldXAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldXAxisRenderer!);
          final ChartAxisRendererDetails oldYAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldYAxisRenderer!);
          _first = calculatePoint(
              _segmentProperties.currentPoint!.xValue,
              _segmentProperties.currentPoint!.yValue,
              oldXAxisDetails,
              oldYAxisDetails,
              _segmentProperties.stateProperties.requireInvertedAxis,
              _segmentProperties.series,
              rect);
          _second = calculatePoint(
              _segmentProperties.nextPoint!.xValue,
              _segmentProperties.nextPoint!.yValue,
              oldXAxisDetails,
              oldYAxisDetails,
              _segmentProperties.stateProperties.requireInvertedAxis,
              _segmentProperties.series,
              rect);
          _oldX1 = _first.x;
          _oldX2 = _second.x;
          _oldY1 = _first.y;
          _oldY2 = _second.y;
        }
      }
      _newlyAddedSegment
          ? animateToPoint(
              canvas,
              SeriesHelper.getSeriesRendererDetails(
                  _segmentProperties.seriesRenderer),
              strokePaint!,
              animationFactor,
              _currentSegment._segmentProperties.x1,
              _currentSegment._segmentProperties.y1,
              _currentSegment._segmentProperties.x2,
              _currentSegment._segmentProperties.y2,
              prevX,
              prevY)
          : animateLineTypeSeries(
              canvas,
              SeriesHelper.getSeriesRendererDetails(
                  _segmentProperties.seriesRenderer),
              strokePaint!,
              animationFactor,
              _currentSegment._segmentProperties.x1,
              _currentSegment._segmentProperties.y1,
              _currentSegment._segmentProperties.x2,
              _currentSegment._segmentProperties.y2,
              _oldX1,
              _oldY1,
              _oldX2,
              _oldY2,
            );
    } else {
      if (seriesRendererDetails.dashArray![0] != 0 &&
          seriesRendererDetails.dashArray![1] != 0) {
        _segmentProperties.path
            .moveTo(_segmentProperties.x1, _segmentProperties.y1);
        _segmentProperties.path
            .lineTo(_segmentProperties.x2, _segmentProperties.y2);
        drawDashedLine(canvas, seriesRendererDetails.dashArray!, strokePaint!,
            _segmentProperties.path);
      } else {
        canvas.drawLine(Offset(_segmentProperties.x1, _segmentProperties.y1),
            Offset(_segmentProperties.x2, _segmentProperties.y2), strokePaint!);
      }
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
