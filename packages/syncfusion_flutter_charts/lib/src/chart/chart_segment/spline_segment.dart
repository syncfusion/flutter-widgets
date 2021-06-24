part of charts;

/// Creates the segments for spline series.
///
/// Generates the spline series points and has the [calculateSegmentPoints] method overrided to customize
/// the spline segment point calculation.
///
/// Gets the path and color from the `series`.
class SplineSegment extends ChartSegment {
  late double _x1, _y1, _x2, _y2;
  double? _oldX1, _oldY1, _oldX2, _oldY2, _oldX3, _oldY3, _oldX4, _oldY4;

  /// Start point X value
  double? startControlX;

  /// Start point Y value
  double? startControlY;

  /// End point X value
  double? endControlX;

  /// End point Y value
  double? endControlY;

  Color? _pointColorMapper;
  late _ChartLocation _currentPointLocation, _nextPointLocation;
  late ChartAxisRenderer _xAxisRenderer, _yAxisRenderer;
  ChartAxisRenderer? _oldXAxisRenderer, _oldYAxisRenderer;
  late Rect _axisClipRect;
  late SplineSegment _currentSegment;
  SplineSegment? _oldSegment;
  late bool _needAnimate;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint _fillPaint = Paint();
    assert(_series.opacity >= 0,
        'The opacity value of the spline series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the spline series should be less than or equal to 1.');
    if (_strokeColor != null) {
      _fillPaint.color = _strokeColor!.withOpacity(_series.opacity);
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
    assert(_series.opacity >= 0,
        'The opacity value of the spline series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the spline series should be less than or equal to 1.');
    if (_strokeColor != null) {
      _strokePaint.color =
          _pointColorMapper ?? _strokeColor!.withOpacity(_series.opacity);
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

    startControlX = _currentPoint!.startControl!.x;
    startControlY = _currentPoint!.startControl!.y;
    endControlX = _currentPoint!.endControl!.x;
    endControlY = _currentPoint!.endControl!.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (_seriesRenderer._isSelectionEnable) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          _seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer?._selectionRenderer?._checkWithSelectionState(
          _seriesRenderer._segments[currentSegmentIndex!],
          _seriesRenderer._chart);
    }
    final Rect rect = _calculatePlotOffset(
        _seriesRenderer._chartState!._chartAxis._axisClipRect,
        Offset(_seriesRenderer._xAxisRenderer!._axis.plotOffset,
            _seriesRenderer._yAxisRenderer!._axis.plotOffset));

    /// Draw spline series
    if (_series.animationDuration > 0 &&
        !_seriesRenderer._reAnimate &&
        _seriesRenderer._renderingDetails!.widgetNeedUpdate &&
        !_seriesRenderer._renderingDetails!.isLegendToggled &&
        _seriesRenderer._chartState!._oldSeriesRenderers.isNotEmpty &&
        _oldSeries != null &&
        _oldSeriesRenderer!._segments.isNotEmpty &&
        _oldSeriesRenderer!._segments[0] is SplineSegment &&
        _seriesRenderer._chartState!._oldSeriesRenderers.length - 1 >=
            _seriesRenderer._segments[currentSegmentIndex!]._seriesIndex &&
        _seriesRenderer._segments[currentSegmentIndex!]._oldSeriesRenderer!
            ._segments.isNotEmpty &&
        _currentPoint!.isGap != true &&
        _nextPoint!.isGap != true) {
      _currentSegment =
          _seriesRenderer._segments[currentSegmentIndex!] as SplineSegment;
      _oldSegment = (_currentSegment._oldSeriesRenderer!._segments.length - 1 >=
              currentSegmentIndex!)
          ? _currentSegment._oldSeriesRenderer!._segments[currentSegmentIndex!]
              as SplineSegment?
          : null;
      _oldX1 = _oldSegment?._x1;
      _oldY1 = _oldSegment?._y1;
      _oldX2 = _oldSegment?._x2;
      _oldY2 = _oldSegment?._y2;
      _oldX3 = _oldSegment?.startControlX;
      _oldY3 = _oldSegment?.startControlY;
      _oldX4 = _oldSegment?.endControlX;
      _oldY4 = _oldSegment?.endControlY;

      if (_oldSegment != null &&
          (_oldX1!.isNaN || _oldX2!.isNaN) &&
          _seriesRenderer._chartState!._oldAxisRenderers.isNotEmpty) {
        _ChartLocation _oldPoint;
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
          _oldPoint = _calculatePoint(
              _currentPoint!.xValue,
              _currentPoint!.yValue,
              _oldXAxisRenderer!,
              _oldYAxisRenderer!,
              _seriesRenderer._chartState!._requireInvertedAxis,
              _series,
              rect);
          _oldX1 = _oldPoint.x;
          _oldY1 = _oldPoint.y;
          _oldPoint = _calculatePoint(
              _nextPoint!.xValue,
              _nextPoint!.xValue,
              _oldXAxisRenderer!,
              _oldYAxisRenderer!,
              _seriesRenderer._chartState!._requireInvertedAxis,
              _series,
              rect);
          _oldX2 = _oldPoint.x;
          _oldY2 = _oldPoint.y;
          _oldPoint = _calculatePoint(
              startControlX!,
              startControlY!,
              _oldXAxisRenderer!,
              _oldYAxisRenderer!,
              _seriesRenderer._chartState!._requireInvertedAxis,
              _series,
              rect);
          _oldX3 = _oldPoint.x;
          _oldY3 = _oldPoint.y;
          _oldPoint = _calculatePoint(
              endControlX!,
              endControlY!,
              _oldXAxisRenderer!,
              _oldYAxisRenderer!,
              _seriesRenderer._chartState!._requireInvertedAxis,
              _series,
              rect);
          _oldX4 = _oldPoint.x;
          _oldY4 = _oldPoint.y;
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
        _currentSegment.startControlX,
        _currentSegment.startControlY,
        _oldX3,
        _oldY3,
        _currentSegment.endControlX,
        _currentSegment.endControlY,
        _oldX4,
        _oldY4,
      );
    } else {
      final Path path = Path();
      path.moveTo(_x1, _y1);
      if (_currentPoint!.isGap != true && _nextPoint!.isGap != true) {
        path.cubicTo(startControlX!, startControlY!, endControlX!, endControlY!,
            _x2, _y2);
        _drawDashedLine(canvas, _series.dashArray, strokePaint!, path);
      }
    }
  }
}
