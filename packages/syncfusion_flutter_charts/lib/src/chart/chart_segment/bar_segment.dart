import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for bar series.
///
/// This generates the bar series points and has the [calculateSegmentPoints] override method
/// used to customize the bar series segment point calculation.
///
/// It gets the path, stroke color and fill color from the `series` to render the bar segment.
///
class BarSegment extends ChartSegment {
  /// The rectangle of the segment. This could be used to render a segment while overriding this segment.
  late RRect segmentRect;

  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();
    if (_segmentProperties.series.gradient == null) {
      fillPaint = Paint()
        ..color = (_segmentProperties.currentPoint!.isEmpty ?? false)
            ? _segmentProperties.series.emptyPointSettings.color
            : (_segmentProperties.currentPoint!.pointColorMapper ??
                _segmentProperties.color!)
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = getLinearGradientPaint(
          _segmentProperties.series.gradient!,
          _segmentProperties.currentPoint!.region!,
          SeriesHelper.getSeriesRendererDetails(
                  _segmentProperties.seriesRenderer)
              .stateProperties
              .requireInvertedAxis);
    }
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the the bar series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the the bar series should be less than or equal to 1.');
    fillPaint!.color = (_segmentProperties.series.opacity < 1 == true &&
            fillPaint!.color != Colors.transparent)
        ? fillPaint!.color.withOpacity(_segmentProperties.series.opacity)
        : fillPaint!.color;
    _segmentProperties.defaultFillColor = fillPaint;
    setShader(_segmentProperties, fillPaint!);
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    _setSegmentProperties();
    strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (_segmentProperties.currentPoint!.isEmpty ?? false)
          ? _segmentProperties.series.emptyPointSettings.borderWidth
          : _segmentProperties.strokeWidth!;
    (_segmentProperties.series.borderGradient != null)
        ? strokePaint!.shader = _segmentProperties.series.borderGradient!
            .createShader(_segmentProperties.currentPoint!.region!)
        : strokePaint!.color =
            (_segmentProperties.currentPoint!.isEmpty ?? false)
                ? _segmentProperties.series.emptyPointSettings.borderColor
                : _segmentProperties.strokeColor!;
    _segmentProperties.series.borderWidth == 0
        ? strokePaint!.color = Colors.transparent
        : strokePaint!.color;
    _segmentProperties.defaultStrokeColor = strokePaint;
    return strokePaint!;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();
    final BarSeries<dynamic, dynamic> barSeries =
        _segmentProperties.series as BarSeries<dynamic, dynamic>;
    if (_segmentProperties.trackerFillPaint != null &&
        barSeries.isTrackVisible) {
      _drawSegmentRect(canvas, _segmentProperties.trackBarRect,
          _segmentProperties.trackerFillPaint!);
    }

    if (_segmentProperties.trackerStrokePaint != null &&
        barSeries.isTrackVisible) {
      _drawSegmentRect(canvas, _segmentProperties.trackBarRect,
          _segmentProperties.trackerStrokePaint!);
    }

    if (fillPaint != null) {
      _drawSegmentRect(canvas, segmentRect, fillPaint!);
    }
    if (strokePaint != null) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              _segmentProperties.seriesRenderer);
      (seriesRendererDetails.dashArray![0] != 0 &&
              seriesRendererDetails.dashArray![1] != 0)
          ? drawDashedLine(canvas, seriesRendererDetails.dashArray!,
              strokePaint!, _segmentProperties.path)
          : _drawSegmentRect(canvas, segmentRect, strokePaint!);
    }
  }

  /// To draw Segment rect of bar segment.
  void _drawSegmentRect(Canvas canvas, RRect segmentRect, Paint paint) {
    (_segmentProperties.series.animationDuration > 0 == true)
        ? animateRectSeries(
            canvas,
            _segmentProperties.seriesRenderer,
            paint,
            segmentRect,
            _segmentProperties.currentPoint!.yValue,
            animationFactor,
            _segmentProperties.oldPoint?.region ?? _segmentProperties.oldRegion,
            _segmentProperties.oldPoint?.yValue,
            _segmentProperties.oldSeriesVisible)
        : canvas.drawRRect(segmentRect, paint);
  }

  /// Method to set segment properties.
  void _setSegmentProperties() {
    if (!_isInitialize) {
      _segmentProperties = SegmentHelper.getSegmentProperties(this);
      _isInitialize = true;
    }
  }
}
