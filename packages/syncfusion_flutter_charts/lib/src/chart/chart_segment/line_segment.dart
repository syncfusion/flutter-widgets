part of charts;

/// Creates the segments for line series.
///
/// Line segment is a part of a line series that is bounded by two distinct end point.
/// Generates the line series points and has the [calculateSegmentPoints] override method
/// used to customize the line series segment point calculation.
///
/// Gets the path, stroke color and fill color from the `series`.
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class LineSegment extends ChartSegment {
  /// segment points & old segment points
  late double _x1, _y1, _x2, _y2;
  double? _oldX1, _oldY1, _oldX2, _oldY2;

  /// Render path
  late Path _path;

  Color? _pointColorMapper;

  late bool _needAnimate, _newlyAddedSegment = false;

  late Rect _axisClipRect;

  late _ChartLocation _first,
      _second,
      _currentPointLocation,
      _nextPointLocation;

  late ChartAxisRenderer _xAxisRenderer, _yAxisRenderer;
  ChartAxisRenderer? _oldXAxisRenderer, _oldYAxisRenderer;

  late LineSegment _currentSegment;
  LineSegment? _oldSegment;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint _fillPaint = Paint();
    assert(_series.opacity >= 0,
        'The opacity value of the line series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the line series should be less than or equal to 1.');
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
    final Paint strokePaint = Paint();
    assert(_series.opacity >= 0,
        'The opacity value of the line series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the line series should be less than or equal to 1.');
    if (_strokeColor != null) {
      strokePaint.color = _pointColorMapper ?? _strokeColor!;
      strokePaint.color =
          (_series.opacity < 1 && strokePaint.color != Colors.transparent)
              ? strokePaint.color.withOpacity(_series.opacity)
              : strokePaint.color;
    }
    strokePaint.strokeWidth = _strokeWidth!;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    _xAxisRenderer = _seriesRenderer._xAxisRenderer!;
    _yAxisRenderer = _seriesRenderer._yAxisRenderer!;
    _axisClipRect = _calculatePlotOffset(
        _chartState._chartAxis._axisClipRect,
        Offset(_seriesRenderer._xAxisRenderer!._axis.plotOffset,
            _seriesRenderer._yAxisRenderer!._axis.plotOffset));
    _currentPointLocation = _calculatePoint(
        _currentPoint!.xValue,
        _currentPoint!.yValue,
        _xAxisRenderer,
        _yAxisRenderer,
        _chartState._requireInvertedAxis,
        _series,
        _axisClipRect);
    _x1 = _currentPointLocation.x;
    _y1 = _currentPointLocation.y;
    _nextPointLocation = _calculatePoint(
        _nextPoint!.xValue,
        _nextPoint!.yValue,
        _xAxisRenderer,
        _yAxisRenderer,
        _chartState._requireInvertedAxis,
        _series,
        _axisClipRect);
    _x2 = _nextPointLocation.x;
    _y2 = _nextPointLocation.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    double? prevX, prevY;
    LineSegment? prevSegment;
    final Rect rect = _calculatePlotOffset(
        _seriesRenderer._chartState!._chartAxis._axisClipRect,
        Offset(_seriesRenderer._xAxisRenderer!._axis.plotOffset,
            _seriesRenderer._yAxisRenderer!._axis.plotOffset));
    _path = Path();
    if (_series.animationDuration > 0 &&
        !_seriesRenderer._reAnimate &&
        _oldSeriesRenderer != null &&
        _oldSeriesRenderer!._segments.isNotEmpty &&
        _oldSeriesRenderer!._segments[0] is LineSegment &&
        _seriesRenderer._chartState!._oldSeriesRenderers.length - 1 >=
            _seriesRenderer._segments[currentSegmentIndex!]._seriesIndex &&
        _seriesRenderer._segments[currentSegmentIndex!]._oldSeriesRenderer!
            ._segments.isNotEmpty) {
      _currentSegment =
          _seriesRenderer._segments[currentSegmentIndex!] as LineSegment;
      _oldSegment = (_currentSegment._oldSeriesRenderer!._segments.length - 1 >=
              currentSegmentIndex!)
          ? _currentSegment._oldSeriesRenderer!._segments[currentSegmentIndex!]
              as LineSegment?
          : null;
      if (currentSegmentIndex! > 0) {
        prevSegment =
            (_currentSegment._oldSeriesRenderer!._segments.length - 1 >=
                    currentSegmentIndex! - 1)
                ? _currentSegment._oldSeriesRenderer!
                    ._segments[currentSegmentIndex! - 1] as LineSegment?
                : null;
      }
      _oldX1 = _oldSegment?._x1;
      _oldY1 = _oldSegment?._y1;
      _oldX2 = _oldSegment?._x2;
      _oldY2 = _oldSegment?._y2;
      if (_oldSegment == null && _renderingDetails.widgetNeedUpdate) {
        _newlyAddedSegment = true;
        prevX = prevSegment?._x2;
        prevY = prevSegment?._y2;
      } else {
        _newlyAddedSegment = false;
      }
      if (_oldSegment != null &&
          (_oldX1!.isNaN || _oldX2!.isNaN) &&
          _seriesRenderer._chartState!._oldAxisRenderers.isNotEmpty) {
        _oldXAxisRenderer = _getOldAxisRenderer(_seriesRenderer._xAxisRenderer!,
            _seriesRenderer._chartState!._oldAxisRenderers);
        _oldYAxisRenderer = _getOldAxisRenderer(_seriesRenderer._yAxisRenderer!,
            _seriesRenderer._chartState!._oldAxisRenderers);
        if (_oldYAxisRenderer != null && _oldXAxisRenderer != null) {
          _needAnimate = _oldYAxisRenderer!._visibleRange!.minimum !=
                  _seriesRenderer._yAxisRenderer!._visibleRange!.minimum ||
              _oldYAxisRenderer!._visibleRange!.maximum !=
                  _seriesRenderer._yAxisRenderer!._visibleRange!.maximum ||
              _oldXAxisRenderer!._visibleRange!.minimum !=
                  _seriesRenderer._xAxisRenderer!._visibleRange!.minimum ||
              _oldXAxisRenderer!._visibleRange!.maximum !=
                  _seriesRenderer._xAxisRenderer!._visibleRange!.maximum;
        }
        if (_needAnimate) {
          _first = _calculatePoint(
              _currentPoint!.xValue,
              _currentPoint!.yValue,
              _oldXAxisRenderer!,
              _oldYAxisRenderer!,
              _seriesRenderer._chartState!._requireInvertedAxis,
              _series,
              rect);
          _second = _calculatePoint(
              _nextPoint!.xValue,
              _nextPoint!.yValue,
              _oldXAxisRenderer!,
              _oldYAxisRenderer!,
              _seriesRenderer._chartState!._requireInvertedAxis,
              _series,
              rect);
          _oldX1 = _first.x;
          _oldX2 = _second.x;
          _oldY1 = _first.y;
          _oldY2 = _second.y;
        }
      }
      _newlyAddedSegment
          ? _animateToPoint(
              canvas,
              _seriesRenderer,
              strokePaint!,
              animationFactor,
              _currentSegment._x1,
              _currentSegment._y1,
              _currentSegment._x2,
              _currentSegment._y2,
              prevX,
              prevY)
          : _animateLineTypeSeries(
              canvas,
              _seriesRenderer,
              strokePaint!,
              animationFactor,
              _currentSegment._x1,
              _currentSegment._y1,
              _currentSegment._x2,
              _currentSegment._y2,
              _oldX1,
              _oldY1,
              _oldX2,
              _oldY2,
            );
    } else {
      if (_series.dashArray[0] != 0 && _series.dashArray[1] != 0) {
        _path.moveTo(_x1, _y1);
        _path.lineTo(_x2, _y2);
        _drawDashedLine(canvas, _series.dashArray, strokePaint!, _path);
      } else {
        canvas.drawLine(Offset(_x1, _y1), Offset(_x2, _y2), strokePaint!);
      }
    }
  }
}
