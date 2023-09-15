import 'dart:ui';

import 'package:flutter/material.dart';

import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/enum.dart';
import 'chart_segment.dart';

/// Creates the segments for fast line series.
///
/// This generates the fast line series points and has the [calculateSegmentPoints] method overrided to customize
/// the fast line segment point calculation.
///
/// Gets the path and color from the `series`.
class FastLineSegment extends ChartSegment {
  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();

    final Paint fillPaint = Paint();
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the fast line series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the fast line series should be less than or equal to 1.');
    if (_segmentProperties.color != null) {
      fillPaint.color = _segmentProperties.color!
          .withOpacity(_segmentProperties.series.opacity);
    }
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
        'The opacity value of the fast line series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the fast line series should be less than or equal to 1.');
    if (_segmentProperties.series.gradient == null) {
      if (_segmentProperties.strokeColor != null) {
        strokePaint.color = (_segmentProperties.series.opacity < 1 == true &&
                _segmentProperties.strokeColor != Colors.transparent)
            ? _segmentProperties.strokeColor!
                .withOpacity(_segmentProperties.series.opacity)
            : _segmentProperties.strokeColor!;
      }
    } else {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              _segmentProperties.seriesRenderer);
      strokePaint.shader = _segmentProperties.series.gradient!
          .createShader(seriesRendererDetails.segmentPath!.getBounds());
    }
    strokePaint.strokeWidth = _segmentProperties.strokeWidth!;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    _segmentProperties.defaultStrokeColor = strokePaint;
    setShader(_segmentProperties, strokePaint);
    return strokePaint;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            _segmentProperties.seriesRenderer);
    final bool isDashArray = seriesRendererDetails.dashArray![0] != 0 &&
        seriesRendererDetails.dashArray![1] != 0;
    if ((seriesRendererDetails.series.emptyPointSettings.mode ==
                EmptyPointMode.gap &&
            seriesRendererDetails.containsEmptyPoints) ||
        isDashArray) {
      isDashArray
          ? drawDashedLine(canvas, _segmentProperties.series.dashArray,
              strokePaint!, seriesRendererDetails.segmentPath!)
          : canvas.drawPath(seriesRendererDetails.segmentPath!, strokePaint!);
    } else {
      canvas.drawPoints(PointMode.polygon, points, strokePaint!);
    }
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Method to set segment properties.
  void _setSegmentProperties() {
    if (!_isInitialize) {
      _segmentProperties = SegmentHelper.getSegmentProperties(this);
      _isInitialize = true;
    }
  }
}
