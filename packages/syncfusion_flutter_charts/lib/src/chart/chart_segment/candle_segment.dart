part of charts;

/// Creates the segments for bubble series.
///
/// Generates the candle series points and has the [calculateSegmentPoints] override method
/// used to customize the candle series segment point calculation.
///
/// Gets the path and fill color from the `series` to render the candle segment.
///
class CandleSegment extends ChartSegment {
  // ignore: unused_field
  late double _x,
      _low,
      _high,
      _highY,
      _openX,
      _openY,
      _closeX,
      _closeY,
      _centerHigh,
      _centerLow,
      _lowY,
      _centersY,
      _topRectY,
      _topLineY,
      _bottomRectY,
      _bottomLineY;
  // ignore: unused_field
  late Path _path, _linePath;
  Color? _pointColorMapper;

  //ignore: prefer_final_fields
  late bool _isSolid = false, _isTransposed, _isBull = false, _showSameValue;
  late _ChartLocation _lowPoint, _highPoint, _centerLowPoint, _centerHighPoint;

  late CandleSeries<dynamic, dynamic> _candleSeries;
  late CandleSegment _currentSegment;
  CandleSegment? _oldSegment;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    fillPaint = Paint()
      ..color = _currentPoint!.isEmpty != null && _currentPoint!.isEmpty!
          ? _series.emptyPointSettings.color
          : (_currentPoint!.pointColorMapper ?? _color!);
    assert(_series.opacity >= 0,
        'The opacity value of the candle series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the candle series should be less than or equal to 1.');
    fillPaint!.color =
        (_series.opacity < 1 && fillPaint!.color != Colors.transparent)
            ? fillPaint!.color.withOpacity(_series.opacity)
            : fillPaint!.color;
    fillPaint!.strokeWidth = _strokeWidth!;
    fillPaint!.style = _isSolid ? PaintingStyle.fill : PaintingStyle.stroke;
    _defaultFillColor = fillPaint;
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    final Paint _strokePaint = Paint();
    if (_strokeColor != null) {
      _strokePaint.color = _pointColorMapper ?? _strokeColor!;
      _strokePaint.color =
          (_series.opacity < 1 && _strokePaint.color != Colors.transparent)
              ? _strokePaint.color.withOpacity(_series.opacity)
              : _strokePaint.color;
    }
    _strokePaint.strokeWidth = _strokeWidth!;
    _strokePaint.style = PaintingStyle.stroke;
    _strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = _strokePaint;
    return _strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    _candleSeries = _series as CandleSeries<dynamic, dynamic>;
    _isBull = _currentPoint!.open < _currentPoint!.close;
    _x = _high = _low = double.nan;
    _isTransposed = _seriesRenderer._chartState!._requireInvertedAxis;
    _lowPoint = _currentPoint!.lowPoint!;
    _highPoint = _currentPoint!.highPoint!;
    _centerLowPoint = _currentPoint!.centerLowPoint!;
    _centerHighPoint = _currentPoint!.centerHighPoint!;
    _x = _lowPoint.x;
    _low = _lowPoint.y;
    _high = _highPoint.y;
    _centerHigh = _centerHighPoint.x;
    _highY = _centerHighPoint.y;
    _centerLow = _centerLowPoint.x;
    _lowY = _centerLowPoint.y;
    _openX = _currentPoint!.openPoint!.x;
    _openY = _currentPoint!.openPoint!.y;
    _closeX = _currentPoint!.closePoint!.x;
    _closeY = _currentPoint!.closePoint!.y;

    _showSameValue = _candleSeries.showIndicationForSameValues &&
        (!_seriesRenderer._chartState!._requireInvertedAxis
            ? _centerHighPoint.y == _centerLowPoint.y
            : _centerHighPoint.x == _centerLowPoint.x);

    _x = _lowPoint.x =
        (_showSameValue && _isTransposed) ? _lowPoint.x - 2 : _lowPoint.x;
    _highPoint.x =
        (_showSameValue && _isTransposed) ? _highPoint.x + 2 : _highPoint.x;
    _low = _lowPoint.y =
        (_showSameValue && !_isTransposed) ? _lowPoint.y - 2 : _lowPoint.y;
    _high = _highPoint.y =
        (_showSameValue && !_isTransposed) ? _highPoint.y + 2 : _highPoint.y;
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
    _centersY = _closeY + ((_closeY - _openY).abs() / 2);
    _topRectY = _centersY - ((_centersY - _closeY).abs() * 1);
    _bottomRectY = _centersY + ((_centersY - _openY).abs() * 1);
  }

  /// To draw rect path of candle segments
  void _drawRectPath() {
    _path.moveTo(!_isTransposed ? _openX : _topRectY,
        !_isTransposed ? _topRectY : _closeY);
    _path.lineTo(!_isTransposed ? _closeX : _topRectY,
        !_isTransposed ? _topRectY : _openY);
    _path.lineTo(!_isTransposed ? _closeX : _bottomRectY,
        !_isTransposed ? _bottomRectY : _openY);
    _path.lineTo(!_isTransposed ? _openX : _bottomRectY,
        !_isTransposed ? _bottomRectY : _closeY);
    _path.lineTo(!_isTransposed ? _openX : _topRectY,
        !_isTransposed ? _topRectY : _closeY);
    _path.close();
  }

  void _drawLine(Canvas canvas) {
    canvas.drawLine(Offset(_centerHigh, _topRectY),
        Offset(_centerHigh, _topLineY), fillPaint!);
    canvas.drawLine(Offset(_centerHigh, _bottomRectY),
        Offset(_centerHigh, _bottomLineY), fillPaint!);
  }

  void _drawFillLine(Canvas canvas) {
    final bool isOpen = _currentPoint!.open > _currentPoint!.close;
    canvas.drawLine(
        Offset(_topRectY, _highY),
        Offset(
            _topRectY +
                ((isOpen ? (_openX - _centerHigh) : (_closeX - _centerHigh))
                        .abs() *
                    animationFactor),
            _highY),
        fillPaint!);
    canvas.drawLine(
        Offset(_bottomRectY, _highY),
        Offset(
            _bottomRectY -
                ((isOpen ? (_closeX - _centerLow) : (_openX - _centerLow))
                        .abs() *
                    animationFactor),
            _highY),
        fillPaint!);
  }

  void _calculateCandlePositions(num openX, num closeX) {
    _centersY = closeX + ((openX - closeX).abs() / 2);
    _topRectY = _centersY + ((_centersY - openX).abs() * animationFactor);
    _bottomRectY = _centersY - ((_centersY - closeX).abs() * animationFactor);
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (fillPaint != null &&
        (_seriesRenderer._reAnimate ||
            !(_seriesRenderer._renderingDetails!.widgetNeedUpdate &&
                !_seriesRenderer._renderingDetails!.isLegendToggled))) {
      _path = Path();
      _linePath = Path();

      if (!_isTransposed &&
          _currentPoint!.open > _currentPoint!.close == true) {
        final double temp = _closeY;
        _closeY = _openY;
        _openY = temp;
      }

      if (_seriesRenderer._renderingDetails!.isLegendToggled) {
        animationFactor = 1;
      }
      _centersY = _closeY + ((_closeY - _openY).abs() / 2);
      _topRectY = _centersY - ((_centersY - _closeY).abs() * animationFactor);
      _topLineY = _topRectY - ((_topRectY - _highY).abs() * animationFactor);
      _bottomRectY = _centersY + ((_centersY - _openY).abs() * animationFactor);
      _bottomLineY =
          _bottomRectY + ((_bottomRectY - _lowY).abs() * animationFactor);

      _bottomLineY = _lowY < _openY
          ? _bottomRectY - ((_openY - _lowY).abs() * animationFactor)
          : _bottomLineY;

      _topLineY = _highY > _closeY
          ? _topRectY + ((_closeY - _highY).abs() * animationFactor)
          : _topLineY;

      if (_isTransposed) {
        _currentPoint!.open > _currentPoint!.close == true
            ? _calculateCandlePositions(_openX, _closeX)
            : _calculateCandlePositions(_closeX, _openX);

        if (_showSameValue) {
          canvas.drawLine(Offset(_centerHighPoint.x, _centerHighPoint.y),
              Offset(_centerLowPoint.x, _centerHighPoint.y), fillPaint!);
        } else {
          _path.moveTo(_topRectY, _highY);
          _centerHigh < _closeX
              ? _path.lineTo(
                  _topRectY - ((_closeX - _centerHigh).abs() * animationFactor),
                  _highY)
              : _path.lineTo(
                  _topRectY + ((_closeX - _centerHigh).abs() * animationFactor),
                  _highY);
          _path.moveTo(_bottomRectY, _highY);
          _centerLow > _openX
              ? _path.lineTo(
                  _bottomRectY +
                      ((_openX - _centerLow).abs() * animationFactor),
                  _highY)
              : _path.lineTo(
                  _bottomRectY -
                      ((_openX - _centerLow).abs() * animationFactor),
                  _highY);
          _linePath = _path;
        }
        _openX == _closeX
            ? canvas.drawLine(
                Offset(_openX, _openY), Offset(_closeX, _closeY), fillPaint!)
            : _drawRectPath();
      } else {
        _showSameValue
            ? canvas.drawLine(Offset(_centerHighPoint.x, _highPoint.y),
                Offset(_centerHighPoint.x, _lowPoint.y), fillPaint!)
            : _drawLine(canvas);

        _openY == _closeY
            ? canvas.drawLine(
                Offset(_openX, _openY), Offset(_closeX, _closeY), fillPaint!)
            : _drawRectPath();
      }

      if (_series.dashArray[0] != 0 &&
          _series.dashArray[1] != 0 &&
          fillPaint!.style != PaintingStyle.fill &&
          _series.animationDuration <= 0) {
        _drawDashedLine(canvas, _series.dashArray, fillPaint!, _path);
      } else {
        canvas.drawPath(_path, fillPaint!);
        if (fillPaint!.style == PaintingStyle.fill) {
          _isTransposed
              ? _showSameValue
                  ? canvas.drawLine(
                      Offset(_centerHighPoint.x, _centerHighPoint.y),
                      Offset(_centerLowPoint.x, _centerHighPoint.y),
                      fillPaint!)
                  : _drawFillLine(canvas)
              : _showSameValue
                  ? canvas.drawLine(Offset(_centerHighPoint.x, _highPoint.y),
                      Offset(_centerHighPoint.x, _lowPoint.y), fillPaint!)
                  : _drawLine(canvas);
        }
      }
    } else if (!_seriesRenderer._renderingDetails!.isLegendToggled) {
      _currentSegment =
          _seriesRenderer._segments[currentSegmentIndex!] as CandleSegment;
      _oldSegment = !_seriesRenderer._reAnimate &&
              (_currentSegment._oldSeriesRenderer != null &&
                  _currentSegment._oldSeriesRenderer!._segments.isNotEmpty &&
                  _currentSegment._oldSeriesRenderer!._segments[0]
                      is CandleSegment &&
                  _currentSegment._oldSeriesRenderer!._segments.length - 1 >=
                      currentSegmentIndex!)
          ? _currentSegment._oldSeriesRenderer!._segments[currentSegmentIndex!]
              as CandleSegment?
          : null;
      _animateCandleSeries(
          _showSameValue,
          _high,
          _isTransposed,
          _currentPoint!.open!.toDouble(),
          _currentPoint!.close!.toDouble(),
          _lowY,
          _highY,
          _oldSegment?._lowY,
          _oldSegment?._highY,
          _openX,
          _openY,
          _closeX,
          _closeY,
          _centerLow,
          _centerHigh,
          _oldSegment?._openX,
          _oldSegment?._openY,
          _oldSegment?._closeX,
          _oldSegment?._closeY,
          _oldSegment?._centerLow,
          _oldSegment?._centerHigh,
          animationFactor,
          fillPaint!,
          canvas,
          _seriesRenderer);
    }
  }
}
