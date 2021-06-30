part of charts;

/// Creates the segments for step line series.
///
/// Generates the step line series points and has the [calculateSegmentPoints] method overrided to customize
/// the step line segment point calculation.
///
/// Gets the path and color from the `series`.
class StepLineSegment extends ChartSegment {
  late double _x1, _y1, _x2, _y2, _x3, _y3;

  /// Render path
  late Path _path;

  late double _x1Pos, _y1Pos, _x2Pos, _y2Pos;
  late num _midX, _midY;

  double? _oldX1, _oldY1, _oldX2, _oldY2, _oldX3, _oldY3;
  Color? _pointColorMapper;
  late bool _needAnimate;
  ChartAxisRenderer? _oldXAxisRenderer, _oldYAxisRenderer;
  late _ChartLocation _currentLocation, _midLocation, _nextLocation;
  _ChartLocation? _oldLocation;
  late StepLineSegment _currentSegment;
  StepLineSegment? _oldSegment;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint _fillPaint = Paint();
    assert(_series.opacity >= 0,
        'The opacity value of the step line series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the step line series should be less than or equal to 1.');
    if (_color != null) {
      _fillPaint.color = _color!.withOpacity(_series.opacity);
    }
    _fillPaint.strokeWidth = _strokeWidth!;
    _fillPaint.style = PaintingStyle.stroke;
    _defaultFillColor = _fillPaint;
    return _fillPaint;
  }

  /// Gets the stroke color of the series.
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
    _strokePaint.strokeCap = StrokeCap.square;
    _defaultStrokeColor = _strokePaint;
    return _strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final ChartAxisRenderer _xAxisRenderer = _seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer _yAxisRenderer = _seriesRenderer._yAxisRenderer!;
    final Rect _axisClipRect = _calculatePlotOffset(
        _chartState._chartAxis._axisClipRect,
        Offset(_seriesRenderer._xAxisRenderer!._axis.plotOffset,
            _seriesRenderer._yAxisRenderer!._axis.plotOffset));
    _currentLocation = _calculatePoint(
        _currentPoint!.xValue,
        _currentPoint!.yValue,
        _xAxisRenderer,
        _yAxisRenderer,
        _seriesRenderer._chartState!._requireInvertedAxis,
        _seriesRenderer._series,
        _axisClipRect);
    _nextLocation = _calculatePoint(
        _nextPoint!.xValue,
        _nextPoint!.yValue,
        _xAxisRenderer,
        _yAxisRenderer,
        _seriesRenderer._chartState!._requireInvertedAxis,
        _seriesRenderer._series,
        _axisClipRect);
    _midLocation = _calculatePoint(
        _midX,
        _midY,
        _xAxisRenderer,
        _yAxisRenderer,
        _seriesRenderer._chartState!._requireInvertedAxis,
        _seriesRenderer._series,
        _axisClipRect);
    _x1 = _currentLocation.x;
    _y1 = _currentLocation.y;
    _x2 = _nextLocation.x;
    _y2 = _nextLocation.y;
    _x3 = _midLocation.x;
    _y3 = _midLocation.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final Rect _rect = _calculatePlotOffset(
        _seriesRenderer._chartState!._chartAxis._axisClipRect,
        Offset(_seriesRenderer._xAxisRenderer!._axis.plotOffset,
            _seriesRenderer._yAxisRenderer!._axis.plotOffset));
    _path = Path();
    if (_series.animationDuration > 0 &&
        !_seriesRenderer._reAnimate &&
        _seriesRenderer._renderingDetails!.widgetNeedUpdate &&
        !_seriesRenderer._renderingDetails!.isLegendToggled &&
        _seriesRenderer._chartState!._oldSeriesRenderers.isNotEmpty &&
        _oldSeriesRenderer != null &&
        _oldSeriesRenderer!._segments.isNotEmpty &&
        _oldSeriesRenderer!._segments[0] is StepLineSegment &&
        _seriesRenderer._chartState!._oldSeriesRenderers.length - 1 >=
            _seriesRenderer._segments[currentSegmentIndex!]._seriesIndex &&
        _seriesRenderer._segments[currentSegmentIndex!]._oldSeriesRenderer!
            ._segments.isNotEmpty) {
      _currentSegment =
          _seriesRenderer._segments[currentSegmentIndex!] as StepLineSegment;
      _oldSegment = (_currentSegment._oldSeriesRenderer!._segments.length - 1 >=
              currentSegmentIndex!)
          ? _currentSegment._oldSeriesRenderer!._segments[currentSegmentIndex!]
              as StepLineSegment?
          : null;
      _oldX1 = _oldSegment?._x1;
      _oldY1 = _oldSegment?._y1;
      _oldX2 = _oldSegment?._x2;
      _oldY2 = _oldSegment?._y2;
      _oldX3 = _oldSegment?._x3;
      _oldY3 = _oldSegment?._y3;

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
          _oldLocation = _calculatePoint(
              _x1Pos,
              _y1Pos,
              _oldXAxisRenderer!,
              _oldYAxisRenderer!,
              _seriesRenderer._chartState!._requireInvertedAxis,
              _series,
              _rect);
          _oldX1 = _oldLocation!.x;
          _oldY1 = _oldLocation!.y;

          _oldLocation = _calculatePoint(
              _x2Pos,
              _y2Pos,
              _oldXAxisRenderer!,
              _oldYAxisRenderer!,
              _seriesRenderer._chartState!._requireInvertedAxis,
              _series,
              _rect);
          _oldX2 = _oldLocation!.x;
          _oldY2 = _oldLocation!.y;
          _oldLocation = _calculatePoint(
              _midX,
              _midY,
              _oldXAxisRenderer!,
              _oldYAxisRenderer!,
              _seriesRenderer._chartState!._requireInvertedAxis,
              _series,
              _rect);
          _oldX3 = _oldLocation!.x;
          _oldY3 = _oldLocation!.y;
        }
      }
      _animateLineTypeSeries(
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
        _currentSegment._x3,
        _currentSegment._y3,
        _oldX3,
        _oldY3,
      );
    } else {
      if (_series.dashArray[0] != 0 && _series.dashArray[1] != 0) {
        _path.moveTo(_x1, _y1);
        _path.lineTo(_x3, _y3);
        _path.lineTo(_x2, _y2);
        _drawDashedLine(canvas, _series.dashArray, strokePaint!, _path);
      } else {
        canvas.drawLine(Offset(_x1, _y1), Offset(_x3, _y3), strokePaint!);
        canvas.drawLine(Offset(_x3, _y3), Offset(_x2, _y2), strokePaint!);
      }
    }
  }
}
