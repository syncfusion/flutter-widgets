part of charts;

/// Creates the segments for 100% stacked line series.
///
/// Generates the stacked line100 series points and has the  [calculateSegmentPoints] method overrided to customize
/// the stacked line100 segment point calculation.
///
/// Gets the path and color from the `series`.
class StackedLineSegment extends ChartSegment {
  late double _x1,
      _y1,
      _x2,
      _y2,
      _currentCummulativePos,
      _nextCummulativePos,
      _currentCummulativeValue,
      _nextCummulativeValue;
  Color? _pointColorMapper;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint _fillPaint = Paint();
    assert(_series.opacity >= 0,
        'The opacity value of the stacked line series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the stacked line series should be less than or equal to 1.');
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
        'The opacity value of the stacked line series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the stacked line series should be less than or equal to 1.');
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
    final Rect rect = _calculatePlotOffset(
        _seriesRenderer._chartState!._chartAxis._axisClipRect,
        Offset(_seriesRenderer._xAxisRenderer!._axis.plotOffset,
            _seriesRenderer._yAxisRenderer!._axis.plotOffset));
    final _ChartLocation currentChartPoint = _calculatePoint(
        _currentPoint!.xValue,
        _currentCummulativePos,
        _seriesRenderer._xAxisRenderer!,
        _seriesRenderer._yAxisRenderer!,
        _seriesRenderer._chartState!._requireInvertedAxis,
        _series,
        rect);
    final _ChartLocation _nextLocation = _calculatePoint(
        _nextPoint!.xValue,
        _nextCummulativePos,
        _seriesRenderer._xAxisRenderer!,
        _seriesRenderer._yAxisRenderer!,
        _seriesRenderer._chartState!._requireInvertedAxis,
        _series,
        rect);

    final _ChartLocation currentCummulativePoint = _calculatePoint(
        _currentPoint!.xValue,
        _currentCummulativePos,
        _seriesRenderer._xAxisRenderer!,
        _seriesRenderer._yAxisRenderer!,
        _seriesRenderer._chartState!._requireInvertedAxis,
        _series,
        rect);

    final _ChartLocation nextCummulativePoint = _calculatePoint(
        _nextPoint!.xValue,
        _nextCummulativePos,
        _seriesRenderer._xAxisRenderer!,
        _seriesRenderer._yAxisRenderer!,
        _seriesRenderer._chartState!._requireInvertedAxis,
        _series,
        rect);

    _x1 = currentChartPoint.x;
    _y1 = currentChartPoint.y;
    _x2 = _nextLocation.x;
    _y2 = _nextLocation.y;
    _currentCummulativeValue = currentCummulativePoint.y;
    _nextCummulativeValue = nextCummulativePoint.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _renderStackedLineSeries(_series as _StackedSeriesBase<dynamic, dynamic>,
        canvas, strokePaint!, _x1, _y1, _x2, _y2);
  }
}
