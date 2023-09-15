import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for range column series.
///
/// Generates the range column series points and has the [calculateSegmentPoints] method overrides to customize
/// the range column segment point calculation.
///
/// Gets the path and color from the `series`.
class RangeColumnSegment extends ChartSegment {
  // we can override this class and customize the range column segment by getting `segmentRect`.
  /// Rectangle of the segment.
  late RRect segmentRect;

  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();
    final bool hasPointColor =
        _segmentProperties.series.pointColorMapper != null;

    /// Get and set the paint options for range column series.
    if (_segmentProperties.series.gradient == null) {
      fillPaint = Paint()
        ..color = (_segmentProperties.currentPoint!.isEmpty ?? false)
            ? _segmentProperties.series.emptyPointSettings.color
            : ((hasPointColor &&
                    _segmentProperties.currentPoint!.pointColorMapper != null)
                ? _segmentProperties.currentPoint!.pointColorMapper
                : _segmentProperties.color)!
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = getLinearGradientPaint(
          _segmentProperties.series.gradient!,
          _segmentProperties.currentPoint!.region!,
          _segmentProperties.stateProperties.requireInvertedAxis);
    }
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the range column series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the range column series should be less than or equal to 1.');
    fillPaint!.color = (_segmentProperties.series.opacity < 1 == true &&
            fillPaint!.color != Colors.transparent)
        ? fillPaint!.color.withOpacity(_segmentProperties.series.opacity)
        : fillPaint!.color;
    _segmentProperties.defaultFillColor = fillPaint!;
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
    _segmentProperties.defaultStrokeColor = strokePaint;
    _segmentProperties.series.borderGradient != null
        ? strokePaint!.shader = _segmentProperties.series.borderGradient!
            .createShader(_segmentProperties.currentPoint!.region!)
        : strokePaint!.color =
            (_segmentProperties.currentPoint!.isEmpty ?? false)
                ? _segmentProperties.series.emptyPointSettings.borderColor
                : _segmentProperties.strokeColor!;
    _segmentProperties.series.borderWidth == 0
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
    _setSegmentProperties();
    final RangeColumnSeries<dynamic, dynamic> series =
        _segmentProperties.series as RangeColumnSeries<dynamic, dynamic>;

    if (_segmentProperties.trackerFillPaint != null && series.isTrackVisible) {
      canvas.drawRRect(
          _segmentProperties.trackRect, _segmentProperties.trackerFillPaint!);
    }

    if (_segmentProperties.trackerStrokePaint != null &&
        series.isTrackVisible) {
      canvas.drawRRect(
          _segmentProperties.trackRect, _segmentProperties.trackerStrokePaint!);
    }

    if (fillPaint != null) {
      (series.animationDuration > 0 &&
              _segmentProperties
                      .stateProperties.renderingDetails.isLegendToggled ==
                  false)
          ? animateRangeColumn(
              canvas,
              SeriesHelper.getSeriesRendererDetails(
                  _segmentProperties.seriesRenderer),
              fillPaint!,
              segmentRect,
              _segmentProperties.oldPoint != null
                  ? _segmentProperties.oldPoint!.region
                  : _segmentProperties.oldRegion,
              animationFactor)
          : canvas.drawRRect(segmentRect, fillPaint!);
    }
    if (strokePaint != null) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              _segmentProperties.seriesRenderer);
      (seriesRendererDetails.dashArray![0] != 0 &&
              seriesRendererDetails.dashArray![1] != 0)
          ? drawDashedLine(canvas, seriesRendererDetails.dashArray!,
              strokePaint!, _segmentProperties.path)
          : (series.animationDuration > 0 &&
                  _segmentProperties
                          .stateProperties.renderingDetails.isLegendToggled ==
                      false)
              ? animateRangeColumn(
                  canvas,
                  SeriesHelper.getSeriesRendererDetails(
                      _segmentProperties.seriesRenderer),
                  strokePaint!,
                  segmentRect,
                  _segmentProperties.oldPoint != null
                      ? _segmentProperties.oldPoint!.region
                      : _segmentProperties.oldRegion,
                  animationFactor)
              : canvas.drawRRect(segmentRect, strokePaint!);
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
