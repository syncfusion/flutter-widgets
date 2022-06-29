import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import 'chart_segment.dart';

/// Creates the segments for hilo open close series.
///
/// Generates the hilo open close series points and has the [calculateSegmentPoints] method overrided to customize
/// the hilo open close segment point calculation.
///
/// Gets the path and color from the `series`.
class HiloOpenCloseSegment extends ChartSegment {
  late double _centerY,
      _highY,
      _centerX,
      _lowX,
      _highX,
      _centerHigh,
      _centerLow,
      _lowY;

  late ChartLocation _centerLowPoint, _centerHighPoint;
  late bool _showSameValue, _isTransposed;
  late HiloOpenCloseSegment _currentSegment;
  HiloOpenCloseSegment? _oldSegment;
  late HiloOpenCloseSeries<dynamic, dynamic> _hiloOpenCloseSeries;
  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();
    final Paint fillPaint = Paint();
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the Hilo open-close series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the Hilo open-close series should be less than or equal to 1.');
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

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    _setSegmentProperties();
    final Paint strokePaint = Paint();
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the Hilo open-close series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the Hilo open-close series should be less than or equal to 1.');
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
    _hiloOpenCloseSeries =
        _segmentProperties.series as HiloOpenCloseSeries<dynamic, dynamic>;
    _isTransposed =
        SeriesHelper.getSeriesRendererDetails(_segmentProperties.seriesRenderer)
            .stateProperties
            .requireInvertedAxis;
    _segmentProperties.isBull = _segmentProperties.currentPoint!.open <
        _segmentProperties.currentPoint!.close;
    _segmentProperties.lowPoint = _segmentProperties.currentPoint!.lowPoint!;
    _segmentProperties.highPoint = _segmentProperties.currentPoint!.highPoint!;
    _centerLowPoint = _segmentProperties.currentPoint!.centerLowPoint!;
    _centerHighPoint = _segmentProperties.currentPoint!.centerHighPoint!;
    _segmentProperties.x = _lowX = _segmentProperties.lowPoint.x;
    _segmentProperties.low = _segmentProperties.lowPoint.y;
    _segmentProperties.high = _segmentProperties.highPoint.y;
    _highX = _segmentProperties.highPoint.x;
    _centerHigh = _centerHighPoint.x;
    _highY = _centerHighPoint.y;
    _centerLow = _centerLowPoint.x;
    _lowY = _centerLowPoint.y;
    _segmentProperties.openX = _segmentProperties.currentPoint!.openPoint!.x;
    _segmentProperties.openY = _segmentProperties.currentPoint!.openPoint!.y;
    _segmentProperties.closeX = _segmentProperties.currentPoint!.closePoint!.x;
    _segmentProperties.closeY = _segmentProperties.currentPoint!.closePoint!.y;

    _showSameValue = _hiloOpenCloseSeries.showIndicationForSameValues &&
        (!_isTransposed
            ? _centerHighPoint.y == _centerLowPoint.y
            : _centerHighPoint.x == _centerLowPoint.x);

    if (_showSameValue) {
      if (_isTransposed) {
        _segmentProperties.x =
            _segmentProperties.lowPoint.x = _segmentProperties.lowPoint.x - 2;
        _segmentProperties.highPoint.x = _segmentProperties.highPoint.x + 2;
        _centerHigh = _centerHighPoint.x = _centerHighPoint.x + 2;
        _centerLow = _centerLowPoint.x = _centerLowPoint.x - 2;
      } else {
        _segmentProperties.low =
            _segmentProperties.lowPoint.y = _segmentProperties.lowPoint.y - 2;
        _segmentProperties.high =
            _segmentProperties.highPoint.y = _segmentProperties.highPoint.y + 2;
        _highY = _centerHighPoint.y = _centerHighPoint.y + 2;
        _lowY = _centerLowPoint.y = _centerLowPoint.y - 2;
      }
    }
  }

  /// Draws the _path between open and close values.
  void drawHiloOpenClosePath(Canvas canvas) {
    canvas.drawLine(
        Offset(_centerHigh, _highY), Offset(_centerLow, _lowY), strokePaint!);
    canvas.drawLine(
        Offset(_segmentProperties.openX, _segmentProperties.openY),
        Offset(_isTransposed ? _segmentProperties.openX : _centerHigh,
            _isTransposed ? _highY : _segmentProperties.openY),
        strokePaint!);
    canvas.drawLine(
        Offset(_segmentProperties.closeX, _segmentProperties.closeY),
        Offset(_isTransposed ? _segmentProperties.closeX : _centerLow,
            _isTransposed ? _highY : _segmentProperties.closeY),
        strokePaint!);
  }

  /// To draw dashed hilo open close path
  Path _drawDashedHiloOpenClosePath(Canvas canvas) {
    _segmentProperties.path.moveTo(_centerHigh, _highY);
    _segmentProperties.path.lineTo(_centerLow, _lowY);
    _segmentProperties.path
        .moveTo(_segmentProperties.openX, _segmentProperties.openY);
    _segmentProperties.path.lineTo(
        _isTransposed ? _segmentProperties.openX : _centerHigh,
        _isTransposed ? _highY : _segmentProperties.openY);
    _segmentProperties.path.moveTo(
        _isTransposed ? _segmentProperties.closeX : _centerLow,
        _isTransposed ? _highY : _segmentProperties.closeY);
    _segmentProperties.path
        .lineTo(_segmentProperties.closeX, _segmentProperties.closeY);
    return _segmentProperties.path;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            _segmentProperties.seriesRenderer);
    if (strokePaint != null) {
      _segmentProperties.path = Path();
      if (_segmentProperties.series.animationDuration > 0 == true &&
          _segmentProperties.stateProperties.renderingDetails.isLegendToggled ==
              false) {
        if (_segmentProperties
                    .stateProperties.renderingDetails.widgetNeedUpdate ==
                false ||
            seriesRendererDetails.reAnimate == true) {
          if (_isTransposed) {
            _centerX = _highX + ((_lowX - _highX) / 2);
            _segmentProperties.openX = _centerX -
                ((_centerX - _segmentProperties.currentPoint!.openPoint!.x) *
                    animationFactor);
            _segmentProperties.closeX = _centerX +
                ((_segmentProperties.currentPoint!.closePoint!.x - _centerX) *
                    animationFactor);
            _highX = _centerX + ((_centerX - _highX).abs() * animationFactor);
            _lowX = _centerX - ((_lowX - _centerX).abs() * animationFactor);
            canvas.drawLine(Offset(_lowX, _centerLowPoint.y),
                Offset(_highX, _centerHighPoint.y), strokePaint!);
            canvas.drawLine(
                Offset(_segmentProperties.openX, _segmentProperties.openY),
                Offset(_segmentProperties.openX, _highY),
                strokePaint!);
            canvas.drawLine(
                Offset(_segmentProperties.closeX, _lowY),
                Offset(_segmentProperties.closeX, _segmentProperties.closeY),
                strokePaint!);
          } else {
            _centerY = _segmentProperties.high +
                ((_segmentProperties.low - _segmentProperties.high) / 2);
            _segmentProperties.openY = _centerY -
                ((_centerY - _segmentProperties.currentPoint!.openPoint!.y) *
                    animationFactor);
            _segmentProperties.closeY = _centerY +
                ((_segmentProperties.currentPoint!.closePoint!.y - _centerY) *
                    animationFactor);
            _highY = _centerY -
                ((_centerY - _segmentProperties.high) * animationFactor);
            _lowY = _centerY +
                ((_segmentProperties.low - _centerY) * animationFactor);
            canvas.drawLine(Offset(_centerHigh, _highY),
                Offset(_centerLow, _lowY), strokePaint!);
            canvas.drawLine(
                Offset(_segmentProperties.openX, _segmentProperties.openY),
                Offset(_centerHigh, _segmentProperties.openY),
                strokePaint!);
            canvas.drawLine(
                Offset(_centerLow, _segmentProperties.closeY),
                Offset(_segmentProperties.closeX, _segmentProperties.closeY),
                strokePaint!);
          }
        } else {
          _currentSegment = seriesRendererDetails.segments[currentSegmentIndex!]
              as HiloOpenCloseSegment;
          final SeriesRendererDetails? oldSeriesDetails =
              SeriesHelper.getSeriesRendererDetails(
                  _currentSegment._segmentProperties.oldSeriesRenderer!);
          _oldSegment = seriesRendererDetails.reAnimate == false &&
                  (_currentSegment._segmentProperties.oldSeriesRenderer !=
                          null &&
                      oldSeriesDetails!.segments.isNotEmpty == true &&
                      oldSeriesDetails.segments[0] is HiloOpenCloseSegment &&
                      oldSeriesDetails.segments.length - 1 >=
                              currentSegmentIndex! ==
                          true)
              ? oldSeriesDetails.segments[currentSegmentIndex!]
                  as HiloOpenCloseSegment?
              : null;
          animateHiloOpenCloseSeries(
              _isTransposed,
              _isTransposed
                  ? _segmentProperties.lowPoint.x
                  : _segmentProperties.low,
              _isTransposed
                  ? _segmentProperties.highPoint.x
                  : _segmentProperties.high,
              _isTransposed
                  ? (_oldSegment != null
                      ? _oldSegment!._segmentProperties.lowPoint.x
                      : null)
                  : _oldSegment?._segmentProperties.low,
              _isTransposed
                  ? (_oldSegment != null
                      ? _oldSegment!._segmentProperties.highPoint.x
                      : null)
                  : _oldSegment?._segmentProperties.high,
              _segmentProperties.openX,
              _segmentProperties.openY,
              _segmentProperties.closeX,
              _segmentProperties.closeY,
              _isTransposed ? _centerLowPoint.y : _centerLow,
              _isTransposed ? _centerHighPoint.y : _centerHigh,
              _oldSegment?._segmentProperties.openX,
              _oldSegment?._segmentProperties.openY,
              _oldSegment?._segmentProperties.closeX,
              _oldSegment?._segmentProperties.closeY,
              _isTransposed
                  ? (_oldSegment != null
                      ? _oldSegment!._centerLowPoint.y
                      : null)
                  : _oldSegment?._centerLow,
              _isTransposed
                  ? (_oldSegment != null
                      ? _oldSegment!._centerHighPoint.y
                      : null)
                  : _oldSegment?._centerHigh,
              animationFactor,
              strokePaint!,
              canvas,
              SeriesHelper.getSeriesRendererDetails(
                  _segmentProperties.seriesRenderer));
        }
      } else {
        (seriesRendererDetails.dashArray![0] != 0 &&
                seriesRendererDetails.dashArray![1] != 0)
            ? drawDashedLine(canvas, seriesRendererDetails.dashArray!,
                strokePaint!, _drawDashedHiloOpenClosePath(canvas))
            : drawHiloOpenClosePath(canvas);
      }
    }
  }

  /// Method to set segment properties
  void _setSegmentProperties() {
    if (!_isInitialize) {
      _segmentProperties = SegmentHelper.getSegmentProperties(this);
      _isInitialize = true;
    }
  }
}
