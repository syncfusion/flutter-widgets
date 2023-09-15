import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import 'chart_segment.dart';

/// Creates the segments for hilo series.
///
/// Generates the hilo series points and has the [calculateSegmentPoints] method overrided to customize
/// the hilo segment point calculation.
///
/// Gets the path and color from the `series`.
class HiloSegment extends ChartSegment {
  late double _centerX, _highX, _lowX, _centerY, _highY, _lowY;

  late bool _showSameValue, _isTransposed;
  late HiloSeries<dynamic, dynamic> _hiloSeries;
  late HiloSegment _currentSegment;
  HiloSegment? _oldSegment;
  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();

    final Paint fillPaint = Paint();
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the Hilo series will not accept negative numbers.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the Hilo series must be less than or equal to 1.');
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
        'The opacity value of the Hilo series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the Hilo series should be less than or equal to 1.');
    if (_segmentProperties.strokeColor != null) {
      strokePaint.color = _segmentProperties.currentPoint!.isEmpty != null &&
              _segmentProperties.currentPoint!.isEmpty! == true
          ? _segmentProperties.series.emptyPointSettings.color
          : _segmentProperties.pointColorMapper ??
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
    _hiloSeries = _segmentProperties.series as HiloSeries<dynamic, dynamic>;
    _segmentProperties.x =
        _segmentProperties.high = _segmentProperties.low = double.nan;
    _segmentProperties.lowPoint = _segmentProperties.currentPoint!.lowPoint!;
    _segmentProperties.highPoint = _segmentProperties.currentPoint!.highPoint!;

    _isTransposed =
        SeriesHelper.getSeriesRendererDetails(_segmentProperties.seriesRenderer)
            .stateProperties
            .requireInvertedAxis;

    _segmentProperties.x = _segmentProperties.lowPoint.x;
    _segmentProperties.low = _segmentProperties.lowPoint.y;
    _segmentProperties.high = _segmentProperties.highPoint.y;

    _showSameValue = _hiloSeries.showIndicationForSameValues &&
        (!_isTransposed
            ? _segmentProperties.low == _segmentProperties.high
            : _segmentProperties.lowPoint.x == _segmentProperties.highPoint.x);

    if (_showSameValue) {
      if (_isTransposed) {
        _segmentProperties.x =
            _segmentProperties.lowPoint.x = _segmentProperties.lowPoint.x - 2;
        _segmentProperties.highPoint.x = _segmentProperties.highPoint.x + 2;
      } else {
        _segmentProperties.low =
            _segmentProperties.lowPoint.y = _segmentProperties.lowPoint.y - 2;
        _segmentProperties.high =
            _segmentProperties.highPoint.y = _segmentProperties.highPoint.y + 2;
      }
    }
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            _segmentProperties.seriesRenderer);
    if (_segmentProperties.series.animationDuration > 0 == true &&
        seriesRendererDetails
                .stateProperties.renderingDetails.isLegendToggled ==
            false) {
      if (seriesRendererDetails
                  .stateProperties.renderingDetails.widgetNeedUpdate ==
              false ||
          seriesRendererDetails.reAnimate == true) {
        if (_isTransposed) {
          _lowX = _segmentProperties.lowPoint.x;
          _highX = _segmentProperties.highPoint.x;
          _centerX = _highX + ((_lowX - _highX) / 2);
          _highX = _centerX + ((_centerX - _highX).abs() * animationFactor);
          _lowX = _centerX - ((_lowX - _centerX).abs() * animationFactor);
          canvas.drawLine(Offset(_lowX, _segmentProperties.lowPoint.y),
              Offset(_highX, _segmentProperties.highPoint.y), strokePaint!);
        } else {
          _centerY = _segmentProperties.high +
              ((_segmentProperties.low - _segmentProperties.high) / 2);
          _highY = _centerY -
              ((_centerY - _segmentProperties.high) * animationFactor);
          _lowY = _centerY +
              ((_segmentProperties.low - _centerY) * animationFactor);
          canvas.drawLine(Offset(_segmentProperties.lowPoint.x, _highY),
              Offset(_segmentProperties.highPoint.x, _lowY), strokePaint!);
        }
      } else {
        _currentSegment =
            seriesRendererDetails.segments[currentSegmentIndex!] as HiloSegment;
        final SeriesRendererDetails? oldSeriesDetails =
            _currentSegment._segmentProperties.oldSeriesRenderer != null
                ? SeriesHelper.getSeriesRendererDetails(
                    _currentSegment._segmentProperties.oldSeriesRenderer!)
                : null;
        _oldSegment = seriesRendererDetails.reAnimate == false &&
                (oldSeriesDetails != null &&
                    oldSeriesDetails.segments.isNotEmpty == true &&
                    oldSeriesDetails.segments[0] is HiloSegment &&
                    oldSeriesDetails.segments.length - 1 >=
                            currentSegmentIndex! ==
                        true)
            ? oldSeriesDetails.segments[currentSegmentIndex!] as HiloSegment?
            : null;
        animateHiloSeres(
            _isTransposed,
            _segmentProperties.lowPoint,
            _segmentProperties.highPoint,
            _oldSegment?._segmentProperties.lowPoint,
            _oldSegment?._segmentProperties.highPoint,
            animationFactor,
            strokePaint!,
            canvas,
            _segmentProperties.seriesRenderer);
      }
    } else {
      if (seriesRendererDetails.dashArray![0] != 0 &&
          seriesRendererDetails.dashArray![1] != 0) {
        _segmentProperties.path = Path();
        _segmentProperties.path
            .moveTo(_segmentProperties.lowPoint.x, _segmentProperties.high);
        _segmentProperties.path
            .lineTo(_segmentProperties.highPoint.x, _segmentProperties.low);
        drawDashedLine(canvas, seriesRendererDetails.dashArray!, strokePaint!,
            _segmentProperties.path);
      } else {
        canvas.drawLine(
            Offset(_segmentProperties.lowPoint.x, _segmentProperties.high),
            Offset(_segmentProperties.highPoint.x, _segmentProperties.low),
            strokePaint!);
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
