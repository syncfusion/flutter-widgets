import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for column series.
///
/// This generates the column series points and has the [calculateSegmentPoints] override method
/// used to customize the column series segment point calculation.
///
/// It gets the path, stroke color and fill color from the `series` to render the column segment.
///
class HistogramSegment extends ChartSegment {
  // We are using `segmentRect` to draw the histogram segment in the series.
  // we can override this class and customize the histogram segment by getting `segmentRect`.
  /// Rectangle of the segment
  late RRect segmentRect;

  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();
    // final bool hasPointColor = series.pointColorMapper != null ? true : false;

    /// Get and set the paint options for column series.
    if (_segmentProperties.series.gradient == null) {
      if (_segmentProperties.color != null) {
        fillPaint = Paint()
          ..color = (_segmentProperties.currentPoint!.isEmpty ?? false)
              ? _segmentProperties.series.emptyPointSettings.color
              : ((_segmentProperties.currentPoint!.pointColorMapper != null)
                  ? _segmentProperties.currentPoint!.pointColorMapper!
                  : _segmentProperties.color!)
          ..style = PaintingStyle.fill;
      }
    } else {
      fillPaint = getLinearGradientPaint(
          _segmentProperties.series.gradient!,
          _segmentProperties.currentPoint!.region!,
          _segmentProperties.stateProperties.requireInvertedAxis);
    }
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the histogram series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the histogram series should be less than or equal to 1.');
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
    if (_segmentProperties.series.borderGradient != null) {
      strokePaint!.shader = _segmentProperties.series.borderGradient!
          .createShader(_segmentProperties.currentPoint!.region!);
    } else if (_segmentProperties.strokeColor != null) {
      strokePaint!.color = (_segmentProperties.currentPoint!.isEmpty ?? false)
          ? _segmentProperties.series.emptyPointSettings.borderColor
          : _segmentProperties.strokeColor!;
    }
    _segmentProperties.defaultStrokeColor = strokePaint;
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
    final HistogramSeries<dynamic, dynamic> histogramSeries =
        _segmentProperties.series as HistogramSeries<dynamic, dynamic>;

    if (_segmentProperties.trackerFillPaint != null &&
        histogramSeries.isTrackVisible) {
      _drawSegmentRect(_segmentProperties.trackerFillPaint!, canvas,
          _segmentProperties.trackRect);
    }

    if (_segmentProperties.trackerStrokePaint != null &&
        histogramSeries.isTrackVisible) {
      _drawSegmentRect(_segmentProperties.trackerStrokePaint!, canvas,
          _segmentProperties.trackRect);
    }

    if (fillPaint != null) {
      _drawSegmentRect(fillPaint!, canvas, segmentRect);
    }
    if (strokePaint != null) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              _segmentProperties.seriesRenderer);
      (seriesRendererDetails.dashArray![0] != 0 &&
              seriesRendererDetails.dashArray![1] != 0)
          ? drawDashedLine(canvas, seriesRendererDetails.dashArray!,
              strokePaint!, _segmentProperties.path)
          : _drawSegmentRect(strokePaint!, canvas, segmentRect);
    }
  }

  /// To draw the rect of a given segment.
  void _drawSegmentRect(Paint getPaint, Canvas canvas, RRect getRect) {
    ((_segmentProperties.stateProperties.renderingDetails.initialRender! ==
                    true ||
                _segmentProperties
                        .stateProperties.renderingDetails.isLegendToggled ==
                    true ||
                (_segmentProperties.series.key != null &&
                    _segmentProperties.stateProperties.oldSeriesKeys
                            .contains(_segmentProperties.series.key) ==
                        true)) &&
            _segmentProperties.series.animationDuration > 0 == true)
        ? animateRectSeries(
            canvas,
            _segmentProperties.seriesRenderer,
            getPaint,
            getRect,
            _segmentProperties.currentPoint!.yValue,
            animationFactor,
            _segmentProperties.oldPoint != null
                ? _segmentProperties.oldPoint!.region
                : _segmentProperties.oldRegion,
            _segmentProperties.oldPoint?.yValue,
            _segmentProperties.oldSeriesVisible)
        : canvas.drawRRect(getRect, getPaint);
  }

  /// Method to set segment properties.
  void _setSegmentProperties() {
    if (!_isInitialize) {
      _segmentProperties = SegmentHelper.getSegmentProperties(this);
      _isInitialize = true;
    }
  }
}
