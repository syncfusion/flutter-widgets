import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../chart_series/series.dart';
import '../common/common.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for scatter series.
///
/// Generates the scatter series points and has the [calculateSegmentPoints] method overrides to customize
/// the scatter segment point calculation.
///
/// Gets the path and color from the `series`.
class ScatterSegment extends ChartSegment {
  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();
    final bool hasPointColor =
        _segmentProperties.series.pointColorMapper != null;
    if (_segmentProperties.series.gradient == null) {
      if (_segmentProperties.color != null) {
        fillPaint = Paint()
          ..color = (_segmentProperties.currentPoint!.isEmpty ?? false)
              ? _segmentProperties.series.emptyPointSettings.color
              : ((hasPointColor &&
                      _segmentProperties.currentPoint!.pointColorMapper != null)
                  ? _segmentProperties.currentPoint!.pointColorMapper
                  : _segmentProperties.series.markerSettings.isVisible == true
                      ? _segmentProperties.series.markerSettings.color ??
                          SeriesHelper.getSeriesRendererDetails(
                                  _segmentProperties.seriesRenderer)
                              .seriesColor!
                      : _segmentProperties.color)!
          ..style = PaintingStyle.fill;
      }
    } else {
      fillPaint = getLinearGradientPaint(
          _segmentProperties.series.gradient!,
          _segmentProperties.currentPoint!.region!,
          _segmentProperties.stateProperties.requireInvertedAxis);
    }
    _segmentProperties.defaultFillColor = fillPaint;
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the the scatter series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the the scatter series should be less than or equal to 1.');
    fillPaint!.color = (_segmentProperties.series.opacity < 1 == true &&
            fillPaint!.color != Colors.transparent)
        ? fillPaint!.color.withOpacity(_segmentProperties.series.opacity)
        : fillPaint!.color;
    setShader(_segmentProperties, fillPaint!);
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    _setSegmentProperties();
    final ScatterSeriesRenderer scatterRenderer =
        _segmentProperties.seriesRenderer as ScatterSeriesRenderer;
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (_segmentProperties.currentPoint!.isEmpty ?? false)
          ? _segmentProperties.series.emptyPointSettings.borderWidth
          : _segmentProperties.series.markerSettings.isVisible == true
              ? _segmentProperties.series.markerSettings.borderWidth
              : _segmentProperties.strokeWidth!;
    if (_segmentProperties.series.borderGradient != null) {
      strokePaint.shader = _segmentProperties.series.borderGradient!
          .createShader(_segmentProperties.currentPoint!.region!);
    } else {
      strokePaint.color = (_segmentProperties.currentPoint!.isEmpty ?? false)
          ? _segmentProperties.series.emptyPointSettings.borderColor
          : _segmentProperties.series.markerSettings.isVisible == true
              ? _segmentProperties.series.markerSettings.borderColor ??
                  SeriesHelper.getSeriesRendererDetails(
                          _segmentProperties.seriesRenderer)
                      .seriesColor!
              : _segmentProperties.strokeColor!;
    }
    (strokePaint.strokeWidth == 0 &&
            SeriesHelper.getSeriesRendererDetails(scatterRenderer).isLineType ==
                false)
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    _segmentProperties.defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();
    if (fillPaint != null) {
      const double defaultAnimationFactor = 1;
      animateScatterSeries(
          SeriesHelper.getSeriesRendererDetails(
              _segmentProperties.seriesRenderer),
          _segmentProperties.point!,
          _segmentProperties.oldPoint,
          _segmentProperties.series.animationDuration > 0 == true &&
                  _segmentProperties
                          .stateProperties.renderingDetails.isLegendToggled ==
                      false
              ? animationFactor
              : defaultAnimationFactor,
          canvas,
          fillPaint!,
          strokePaint!,
          currentSegmentIndex!,
          this);
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
