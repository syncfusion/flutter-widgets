part of charts;

/// Creates the segments for Hilo series.
///
/// Generates the Hilo series points and has the [calculateSegmentPoints] method overrided to customize
/// the Hilo segment point calculation.
///
/// Gets the path and color from the `series`.
class HiloSegment extends ChartSegment {
  /// Current point X value
  //ignore: unused_field
  late double _x, _low, _high, _centerX, _highX, _lowX, _centerY, _highY, _lowY;
  Color? _pointColorMapper;

  /// Stores _low point location
  late _ChartLocation _lowPoint, _highPoint;

  /// Render path.
  late Path _path;
  late bool _showSameValue, _isTransposed;
  late HiloSeries<dynamic, dynamic> _hiloSeries;
  late HiloSegment _currentSegment;
  HiloSegment? _oldSegment;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint _fillPaint = Paint();
    assert(_series.opacity >= 0,
        'The opacity value of the Hilo series will not accept negative numbers.');
    assert(_series.opacity <= 1,
        'The opacity value of the Hilo series must be less than or equal to 1.');
    if (_color != null) {
      _fillPaint.color =
          _pointColorMapper ?? _color!.withOpacity(_series.opacity);
    }
    _fillPaint.strokeWidth = _strokeWidth!;
    _fillPaint.style = PaintingStyle.fill;
    _defaultFillColor = _fillPaint;
    return _fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final Paint _strokePaint = Paint();
    assert(_series.opacity >= 0,
        'The opacity value of the Hilo series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the Hilo series should be less than or equal to 1.');
    if (_strokeColor != null) {
      _strokePaint.color =
          _currentPoint!.isEmpty != null && _currentPoint!.isEmpty!
              ? _series.emptyPointSettings.color
              : _pointColorMapper ?? _strokeColor!;
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
    _hiloSeries = _series as HiloSeries<dynamic, dynamic>;
    _x = _high = _low = double.nan;
    _lowPoint = _currentPoint!.lowPoint!;
    _highPoint = _currentPoint!.highPoint!;

    _isTransposed = _seriesRenderer._chartState!._requireInvertedAxis;

    _x = _lowPoint.x;
    _low = _lowPoint.y;
    _high = _highPoint.y;

    _showSameValue = _hiloSeries.showIndicationForSameValues &&
        (!_isTransposed ? _low == _high : _lowPoint.x == _highPoint.x);

    if (_showSameValue) {
      if (_isTransposed) {
        _x = _lowPoint.x = _lowPoint.x - 2;
        _highPoint.x = _highPoint.x + 2;
      } else {
        _low = _lowPoint.y = _lowPoint.y - 2;
        _high = _highPoint.y = _highPoint.y + 2;
      }
    }
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (_series.animationDuration > 0 &&
        !_seriesRenderer._renderingDetails!.isLegendToggled) {
      if (!_seriesRenderer._renderingDetails!.widgetNeedUpdate ||
          _seriesRenderer._reAnimate) {
        if (_isTransposed) {
          _lowX = _lowPoint.x;
          _highX = _highPoint.x;
          _centerX = _highX + ((_lowX - _highX) / 2);
          _highX = _centerX + ((_centerX - _highX).abs() * animationFactor);
          _lowX = _centerX - ((_lowX - _centerX).abs() * animationFactor);
          canvas.drawLine(Offset(_lowX, _lowPoint.y),
              Offset(_highX, _highPoint.y), strokePaint!);
        } else {
          _centerY = _high + ((_low - _high) / 2);
          _highY = _centerY - ((_centerY - _high) * animationFactor);
          _lowY = _centerY + ((_low - _centerY) * animationFactor);
          canvas.drawLine(Offset(_lowPoint.x, _highY),
              Offset(_highPoint.x, _lowY), strokePaint!);
        }
      } else {
        _currentSegment =
            _seriesRenderer._segments[currentSegmentIndex!] as HiloSegment;
        _oldSegment = !_seriesRenderer._reAnimate &&
                (_currentSegment._oldSeriesRenderer != null &&
                    _currentSegment._oldSeriesRenderer!._segments.isNotEmpty &&
                    _currentSegment._oldSeriesRenderer!._segments[0]
                        is HiloSegment &&
                    _currentSegment._oldSeriesRenderer!._segments.length - 1 >=
                        currentSegmentIndex!)
            ? _currentSegment._oldSeriesRenderer!
                ._segments[currentSegmentIndex!] as HiloSegment?
            : null;
        _animateHiloSeries(
            _isTransposed,
            _lowPoint,
            _highPoint,
            _oldSegment?._lowPoint,
            _oldSegment?._highPoint,
            animationFactor,
            strokePaint!,
            canvas,
            _seriesRenderer);
      }
    } else {
      if (_series.dashArray[0] != 0 && _series.dashArray[1] != 0) {
        _path = Path();
        _path.moveTo(_lowPoint.x, _high);
        _path.lineTo(_highPoint.x, _low);
        _drawDashedLine(canvas, _series.dashArray, strokePaint!, _path);
      } else {
        canvas.drawLine(Offset(_lowPoint.x, _high), Offset(_highPoint.x, _low),
            strokePaint!);
      }
    }
  }
}
