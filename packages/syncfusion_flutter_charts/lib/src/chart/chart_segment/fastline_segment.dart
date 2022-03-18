import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/src/chart/chart_series/series_renderer_properties.dart';
import 'package:syncfusion_flutter_charts/src/chart/common/common.dart';
import '../chart_series/series.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
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

    final Paint _fillPaint = Paint();
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the fast line series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the fast line series should be less than or equal to 1.');
    if (_segmentProperties.color != null) {
      _fillPaint.color = _segmentProperties.color!
          .withOpacity(_segmentProperties.series.opacity);
    }
    _fillPaint.style = PaintingStyle.fill;
    _segmentProperties.defaultFillColor = _fillPaint;
    return _fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    _setSegmentProperties();

    final Paint _strokePaint = Paint();
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the fast line series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the fast line series should be less than or equal to 1.');
    if (_segmentProperties.series.gradient == null) {
      if (_segmentProperties.strokeColor != null) {
        _strokePaint.color = (_segmentProperties.series.opacity < 1 == true &&
                _segmentProperties.strokeColor != Colors.transparent)
            ? _segmentProperties.strokeColor!
                .withOpacity(_segmentProperties.series.opacity)
            : _segmentProperties.strokeColor!;
      }
    } else {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              _segmentProperties.seriesRenderer);
      _strokePaint.shader = _segmentProperties.series.gradient!
          .createShader(seriesRendererDetails.segmentPath!.getBounds());
    }
    _strokePaint.strokeWidth = _segmentProperties.strokeWidth!;
    _strokePaint.style = PaintingStyle.stroke;
    _strokePaint.strokeCap = StrokeCap.round;
    _segmentProperties.defaultStrokeColor = _strokePaint;
    setShader(_segmentProperties, _strokePaint);
    return _strokePaint;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            _segmentProperties.seriesRenderer);
    // ignore: unnecessary_null_comparison
    _segmentProperties.series.dashArray != null
        ? drawDashedLine(canvas, _segmentProperties.series.dashArray,
            strokePaint!, seriesRendererDetails.segmentPath!)
        : canvas.drawPath(seriesRendererDetails.segmentPath!, strokePaint!);
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
