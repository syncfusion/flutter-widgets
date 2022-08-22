import 'package:flutter/material.dart';

import '../chart_series/financial_series_base.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import 'chart_segment.dart';

/// Creates the segments for candle series.
///
/// Generates the candle series points and has the [calculateSegmentPoints] override method
/// used to customize the candle series segment point calculation.
///
/// Gets the path and fill color from the `series` to render the candle segment.
///
class CandleSegment extends ChartSegment {
  // ignore: unused_field
  late double _highY,
      _centerHigh,
      _centerLow,
      _lowY,
      _centersY,
      _topLineY,
      _bottomLineY;
  // ignore: unused_field
  late Path _linePath;
  late bool _isTransposed, _showSameValue;
  late ChartLocation _centerLowPoint, _centerHighPoint;

  late CandleSegment _currentSegment;
  CandleSegment? _oldSegment;
  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();
    fillPaint = Paint()
      ..color = _segmentProperties.currentPoint!.isEmpty != null &&
              _segmentProperties.currentPoint!.isEmpty! == true
          ? _segmentProperties.series.emptyPointSettings.color
          : (_segmentProperties.currentPoint!.pointColorMapper ??
              _segmentProperties.color!);
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the candle series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the candle series should be less than or equal to 1.');
    fillPaint!.color = (_segmentProperties.series.opacity < 1 == true &&
            fillPaint!.color != Colors.transparent)
        ? fillPaint!.color.withOpacity(_segmentProperties.series.opacity)
        : fillPaint!.color;
    fillPaint!.strokeWidth = _segmentProperties.strokeWidth!;
    fillPaint!.style = _segmentProperties.isSolid == true
        ? PaintingStyle.fill
        : PaintingStyle.stroke;
    _segmentProperties.defaultFillColor = fillPaint;
    setShader(_segmentProperties, fillPaint!);
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    _setSegmentProperties();
    final SegmentProperties candleSegmentProperties = _segmentProperties;
    final Paint strokePaint = Paint();
    if (candleSegmentProperties.strokeColor != null) {
      strokePaint.color = _segmentProperties.pointColorMapper ??
          candleSegmentProperties.strokeColor!;
      strokePaint.color = (candleSegmentProperties.series.opacity < 1 &&
              strokePaint.color != Colors.transparent)
          ? strokePaint.color
              .withOpacity(candleSegmentProperties.series.opacity)
          : strokePaint.color;
    }
    strokePaint.strokeWidth = candleSegmentProperties.strokeWidth!;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    candleSegmentProperties.defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    _setSegmentProperties();
    _segmentProperties.isBull = _segmentProperties.currentPoint!.open <
        _segmentProperties.currentPoint!.close;
    _segmentProperties.x =
        _segmentProperties.high = _segmentProperties.low = double.nan;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            _segmentProperties.seriesRenderer);
    _isTransposed = seriesRendererDetails.stateProperties.requireInvertedAxis;
    _segmentProperties.lowPoint = _segmentProperties.currentPoint!.lowPoint!;
    _segmentProperties.highPoint = _segmentProperties.currentPoint!.highPoint!;
    _centerLowPoint = _segmentProperties.currentPoint!.centerLowPoint!;
    _centerHighPoint = _segmentProperties.currentPoint!.centerHighPoint!;
    _segmentProperties.x = _segmentProperties.lowPoint.x;
    _segmentProperties.low = _segmentProperties.lowPoint.y;
    _segmentProperties.high = _segmentProperties.highPoint.y;
    _centerHigh = _centerHighPoint.x;
    _highY = _centerHighPoint.y;
    _centerLow = _centerLowPoint.x;
    _lowY = _centerLowPoint.y;
    _segmentProperties.openX = _segmentProperties.currentPoint!.openPoint!.x;
    _segmentProperties.openY = _segmentProperties.currentPoint!.openPoint!.y;
    _segmentProperties.closeX = _segmentProperties.currentPoint!.closePoint!.x;
    _segmentProperties.closeY = _segmentProperties.currentPoint!.closePoint!.y;

    _showSameValue =
        (_segmentProperties.series as FinancialSeriesBase<dynamic, dynamic>)
                    .showIndicationForSameValues ==
                true &&
            (seriesRendererDetails.stateProperties.requireInvertedAxis == false
                ? _centerHighPoint.y == _centerLowPoint.y
                : _centerHighPoint.x == _centerLowPoint.x);

    _segmentProperties.x = _segmentProperties.lowPoint.x =
        (_showSameValue && _isTransposed)
            ? _segmentProperties.lowPoint.x - 2
            : _segmentProperties.lowPoint.x;
    _segmentProperties.highPoint.x = (_showSameValue && _isTransposed)
        ? _segmentProperties.highPoint.x + 2
        : _segmentProperties.highPoint.x;
    _segmentProperties.low = _segmentProperties.lowPoint.y =
        (_showSameValue && !_isTransposed)
            ? _segmentProperties.lowPoint.y - 2
            : _segmentProperties.lowPoint.y;
    _segmentProperties.high = _segmentProperties.highPoint.y =
        (_showSameValue && !_isTransposed)
            ? _segmentProperties.highPoint.y + 2
            : _segmentProperties.highPoint.y;
    _centerHigh = _centerHighPoint.x = (_showSameValue && _isTransposed)
        ? _centerHighPoint.x + 2
        : _centerHighPoint.x;
    _highY = _centerHighPoint.y = (_showSameValue && !_isTransposed)
        ? _centerHighPoint.y + 2
        : _centerHighPoint.y;
    _centerLow = _centerLowPoint.x = (_showSameValue && _isTransposed)
        ? _centerLowPoint.x - 2
        : _centerLowPoint.x;
    _lowY = _centerLowPoint.y = (_showSameValue && !_isTransposed)
        ? _centerLowPoint.y - 2
        : _centerLowPoint.y;
    _centersY = _segmentProperties.closeY +
        ((_segmentProperties.closeY - _segmentProperties.openY).abs() / 2);
    _segmentProperties.topRectY =
        _centersY - ((_centersY - _segmentProperties.closeY).abs() * 1);
    _segmentProperties.bottomRectY =
        _centersY + ((_centersY - _segmentProperties.openY).abs() * 1);
  }

  /// To draw rect path of candle segments.
  void _drawRectPath() {
    _segmentProperties.path.moveTo(
        !_isTransposed ? _segmentProperties.openX : _segmentProperties.topRectY,
        !_isTransposed
            ? _segmentProperties.topRectY
            : _segmentProperties.closeY);
    _segmentProperties.path.lineTo(
        !_isTransposed
            ? _segmentProperties.closeX
            : _segmentProperties.topRectY,
        !_isTransposed
            ? _segmentProperties.topRectY
            : _segmentProperties.openY);
    _segmentProperties.path.lineTo(
        !_isTransposed
            ? _segmentProperties.closeX
            : _segmentProperties.bottomRectY,
        !_isTransposed
            ? _segmentProperties.bottomRectY
            : _segmentProperties.openY);
    _segmentProperties.path.lineTo(
        !_isTransposed
            ? _segmentProperties.openX
            : _segmentProperties.bottomRectY,
        !_isTransposed
            ? _segmentProperties.bottomRectY
            : _segmentProperties.closeY);
    _segmentProperties.path.lineTo(
        !_isTransposed ? _segmentProperties.openX : _segmentProperties.topRectY,
        !_isTransposed
            ? _segmentProperties.topRectY
            : _segmentProperties.closeY);
    _segmentProperties.path.close();
  }

  void _drawLine(Canvas canvas) {
    canvas.drawLine(Offset(_centerHigh, _segmentProperties.topRectY),
        Offset(_centerHigh, _topLineY), fillPaint!);
    canvas.drawLine(Offset(_centerHigh, _segmentProperties.bottomRectY),
        Offset(_centerHigh, _bottomLineY), fillPaint!);
  }

  void _drawFillLine(Canvas canvas) {
    final bool isOpen = _segmentProperties.currentPoint!.open >
        _segmentProperties.currentPoint!.close;
    canvas.drawLine(
        Offset(_segmentProperties.topRectY, _highY),
        Offset(
            _segmentProperties.topRectY +
                ((isOpen
                            ? (_segmentProperties.openX - _centerHigh)
                            : (_segmentProperties.closeX - _centerHigh))
                        .abs() *
                    animationFactor),
            _highY),
        fillPaint!);
    canvas.drawLine(
        Offset(_segmentProperties.bottomRectY, _highY),
        Offset(
            _segmentProperties.bottomRectY -
                ((isOpen
                            ? (_segmentProperties.closeX - _centerLow)
                            : (_segmentProperties.openX - _centerLow))
                        .abs() *
                    animationFactor),
            _highY),
        fillPaint!);
  }

  void _calculateCandlePositions(num openX, num closeX) {
    _centersY = closeX + ((openX - closeX).abs() / 2);
    _segmentProperties.topRectY =
        _centersY + ((_centersY - openX).abs() * animationFactor);
    _segmentProperties.bottomRectY =
        _centersY - ((_centersY - closeX).abs() * animationFactor);
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            _segmentProperties.seriesRenderer);
    if (fillPaint != null &&
        (seriesRendererDetails.reAnimate == true ||
            !(seriesRendererDetails
                        .stateProperties.renderingDetails.widgetNeedUpdate ==
                    true &&
                seriesRendererDetails
                        .stateProperties.renderingDetails.isLegendToggled ==
                    false))) {
      _segmentProperties.path = Path();
      _linePath = Path();

      if (!_isTransposed &&
          _segmentProperties.currentPoint!.open >
                  _segmentProperties.currentPoint!.close ==
              true) {
        final double temp = _segmentProperties.closeY;
        _segmentProperties.closeY = _segmentProperties.openY;
        _segmentProperties.openY = temp;
      }

      if (seriesRendererDetails
              .stateProperties.renderingDetails.isLegendToggled ==
          true) {
        animationFactor = 1;
      }
      _centersY = _segmentProperties.closeY +
          ((_segmentProperties.closeY - _segmentProperties.openY).abs() / 2);
      _segmentProperties.topRectY = _centersY -
          ((_centersY - _segmentProperties.closeY).abs() * animationFactor);
      _topLineY = _segmentProperties.topRectY -
          ((_segmentProperties.topRectY - _highY).abs() * animationFactor);
      _segmentProperties.bottomRectY = _centersY +
          ((_centersY - _segmentProperties.openY).abs() * animationFactor);
      _bottomLineY = _segmentProperties.bottomRectY +
          ((_segmentProperties.bottomRectY - _lowY).abs() * animationFactor);

      _bottomLineY = _lowY < _segmentProperties.openY
          ? _segmentProperties.bottomRectY -
              ((_segmentProperties.openY - _lowY).abs() * animationFactor)
          : _bottomLineY;

      _topLineY = _highY > _segmentProperties.closeY
          ? _segmentProperties.topRectY +
              ((_segmentProperties.closeY - _highY).abs() * animationFactor)
          : _topLineY;

      if (_isTransposed) {
        _segmentProperties.currentPoint!.open >
                    _segmentProperties.currentPoint!.close ==
                true
            ? _calculateCandlePositions(
                _segmentProperties.openX, _segmentProperties.closeX)
            : _calculateCandlePositions(
                _segmentProperties.closeX, _segmentProperties.openX);

        if (_showSameValue) {
          canvas.drawLine(Offset(_centerHighPoint.x, _centerHighPoint.y),
              Offset(_centerLowPoint.x, _centerHighPoint.y), fillPaint!);
        } else {
          _segmentProperties.path.moveTo(_segmentProperties.topRectY, _highY);
          _centerHigh < _segmentProperties.closeX
              ? _segmentProperties.path.lineTo(
                  _segmentProperties.topRectY -
                      ((_segmentProperties.closeX - _centerHigh).abs() *
                          animationFactor),
                  _highY)
              : _segmentProperties.path.lineTo(
                  _segmentProperties.topRectY +
                      ((_segmentProperties.closeX - _centerHigh).abs() *
                          animationFactor),
                  _highY);
          _segmentProperties.path
              .moveTo(_segmentProperties.bottomRectY, _highY);
          _centerLow > _segmentProperties.openX
              ? _segmentProperties.path.lineTo(
                  _segmentProperties.bottomRectY +
                      ((_segmentProperties.openX - _centerLow).abs() *
                          animationFactor),
                  _highY)
              : _segmentProperties.path.lineTo(
                  _segmentProperties.bottomRectY -
                      ((_segmentProperties.openX - _centerLow).abs() *
                          animationFactor),
                  _highY);
          _linePath = _segmentProperties.path;
        }
        _segmentProperties.openX == _segmentProperties.closeX
            ? canvas.drawLine(
                Offset(_segmentProperties.openX, _segmentProperties.openY),
                Offset(_segmentProperties.closeX, _segmentProperties.closeY),
                fillPaint!)
            : _drawRectPath();
      } else {
        _showSameValue
            ? canvas.drawLine(
                Offset(_centerHighPoint.x, _segmentProperties.highPoint.y),
                Offset(_centerHighPoint.x, _segmentProperties.lowPoint.y),
                fillPaint!)
            : _drawLine(canvas);

        _segmentProperties.openY == _segmentProperties.closeY
            ? canvas.drawLine(
                Offset(_segmentProperties.openX, _segmentProperties.openY),
                Offset(_segmentProperties.closeX, _segmentProperties.closeY),
                fillPaint!)
            : _drawRectPath();
      }

      if (seriesRendererDetails.dashArray![0] != 0 &&
          seriesRendererDetails.dashArray![1] != 0 &&
          fillPaint!.style != PaintingStyle.fill &&
          _segmentProperties.series.animationDuration <= 0 == true) {
        drawDashedLine(canvas, seriesRendererDetails.dashArray!, fillPaint!,
            _segmentProperties.path);
      } else {
        canvas.drawPath(_segmentProperties.path, fillPaint!);
        if (fillPaint!.style == PaintingStyle.fill) {
          _isTransposed
              ? _showSameValue
                  ? canvas.drawLine(
                      Offset(_centerHighPoint.x, _centerHighPoint.y),
                      Offset(_centerLowPoint.x, _centerHighPoint.y),
                      fillPaint!)
                  : _drawFillLine(canvas)
              : _showSameValue
                  ? canvas.drawLine(
                      Offset(
                          _centerHighPoint.x, _segmentProperties.highPoint.y),
                      Offset(_centerHighPoint.x, _segmentProperties.lowPoint.y),
                      fillPaint!)
                  : _drawLine(canvas);
        }
      }
    } else if (seriesRendererDetails
            .stateProperties.renderingDetails.isLegendToggled ==
        false) {
      _currentSegment =
          seriesRendererDetails.segments[currentSegmentIndex!] as CandleSegment;
      final SegmentProperties currentSegmentProperties =
          SegmentHelper.getSegmentProperties(_currentSegment);
      SegmentProperties? oldSegmentProperties;
      final SeriesRendererDetails? oldRendererDetails =
          currentSegmentProperties.oldSeriesRenderer != null
              ? SeriesHelper.getSeriesRendererDetails(
                  currentSegmentProperties.oldSeriesRenderer!)
              : null;
      _oldSegment = seriesRendererDetails.reAnimate == false &&
              (oldRendererDetails != null &&
                  oldRendererDetails.segments.isNotEmpty == true &&
                  oldRendererDetails.segments[0] is CandleSegment &&
                  oldRendererDetails.segments.length - 1 >=
                          currentSegmentIndex! ==
                      true)
          ? oldRendererDetails.segments[currentSegmentIndex!] as CandleSegment?
          : null;
      if (_oldSegment != null) {
        oldSegmentProperties = SegmentHelper.getSegmentProperties(_oldSegment!);
      }
      animateCandleSeries(
          _showSameValue,
          _segmentProperties.high,
          _isTransposed,
          _segmentProperties.currentPoint!.open!.toDouble(),
          _segmentProperties.currentPoint!.close!.toDouble(),
          _lowY,
          _highY,
          _oldSegment?._lowY,
          _oldSegment?._highY,
          _segmentProperties.openX,
          _segmentProperties.openY,
          _segmentProperties.closeX,
          _segmentProperties.closeY,
          _centerLow,
          _centerHigh,
          oldSegmentProperties?.openX,
          oldSegmentProperties?.openY,
          oldSegmentProperties?.closeX,
          oldSegmentProperties?.closeY,
          _oldSegment?._centerLow,
          _oldSegment?._centerHigh,
          animationFactor,
          fillPaint!,
          canvas,
          SeriesHelper.getSeriesRendererDetails(
              _segmentProperties.seriesRenderer));
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
