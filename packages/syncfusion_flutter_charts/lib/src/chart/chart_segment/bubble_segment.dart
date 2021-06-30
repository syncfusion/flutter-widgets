part of charts;

/// Creates the segments for bubble series.
///
/// Generates the bubble series points and has the [calculateSegmentPoints] override method
/// used to customize the bubble series segment point calculation.
///
/// Gets the path, stroke color and fill color from the `series` to render the bubble series.
///

class BubbleSegment extends ChartSegment {
  ///Center position of the bubble and size
  late double _centerX, _centerY, _radius, _size;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final bool hasPointColor = _series.pointColorMapper != null;
    if (_series.gradient == null) {
      if (_color != null) {
        fillPaint = Paint()
          ..color = _currentPoint!.isEmpty == true
              ? _series.emptyPointSettings.color
              : ((hasPointColor && _currentPoint!.pointColorMapper != null)
                  ? _currentPoint!.pointColorMapper!
                  : _color!)
          ..style = PaintingStyle.fill;
      }
    } else {
      fillPaint = _getLinearGradientPaint(
          _series.gradient!,
          _currentPoint!.region!,
          _seriesRenderer._chartState!._requireInvertedAxis);
    }
    assert(_series.opacity >= 0,
        'The opacity value of the bubble series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the bubble series should be less than or equal to 1.');
    if (fillPaint?.color != null) {
      fillPaint!.color =
          (_series.opacity < 1 && fillPaint!.color != Colors.transparent)
              ? fillPaint!.color.withOpacity(_series.opacity)
              : fillPaint!.color;
    }
    _defaultFillColor = fillPaint;
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    final Paint _strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _currentPoint!.isEmpty == true
          ? _series.emptyPointSettings.borderWidth
          : _strokeWidth!;
    _series.borderGradient != null
        ? _strokePaint.shader =
            _series.borderGradient!.createShader(_currentPoint!.region!)
        : _strokePaint.color = _currentPoint!.isEmpty == true
            ? _series.emptyPointSettings.borderColor
            : _strokeColor!;
    _series.borderWidth == 0
        ? _strokePaint.color = Colors.transparent
        : _strokePaint.color;
    _defaultStrokeColor = _strokePaint;
    return _strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    _centerX = _centerY = double.nan;
    final Rect rect = _calculatePlotOffset(
        _seriesRenderer._chartState!._chartAxis._axisClipRect,
        Offset(_seriesRenderer._xAxisRenderer!._axis.plotOffset,
            _seriesRenderer._yAxisRenderer!._axis.plotOffset));
    final _ChartLocation localtion = _calculatePoint(
        _currentPoint!.xValue,
        _currentPoint!.yValue,
        _seriesRenderer._xAxisRenderer!,
        _seriesRenderer._yAxisRenderer!,
        _seriesRenderer._chartState!._requireInvertedAxis,
        _series,
        rect);
    _centerX = localtion.x;
    _centerY = localtion.y;
    if (_seriesRenderer is BubbleSeriesRenderer)
      _radius = _calculateBubbleRadius(_seriesRenderer as BubbleSeriesRenderer);
    _currentPoint!.region = Rect.fromLTRB(
        localtion.x - 2 * _radius,
        localtion.y - 2 * _radius,
        localtion.x + 2 * _radius,
        localtion.y + 2 * _radius);
    _size = _radius = _currentPoint!.region!.width / 2;
  }

  /// To calculate and return the bubble size
  double _calculateBubbleRadius(BubbleSeriesRenderer _seriesRenderer) {
    final BubbleSeries<dynamic, dynamic> bubbleSeries =
        _series as BubbleSeries<dynamic, dynamic>;
    num bubbleRadius, sizeRange, radiusRange, maxSize, minSize;
    maxSize = _seriesRenderer._maxSize!;
    minSize = _seriesRenderer._minSize!;
    sizeRange = maxSize - minSize;
    final double bubbleSize = ((_currentPoint!.bubbleSize) ?? 4).toDouble();
    assert(bubbleSeries.minimumRadius >= 0 && bubbleSeries.maximumRadius >= 0,
        'The min radius and max radius of the bubble should be greater than or equal to 0.');
    if (bubbleSeries.sizeValueMapper == null) {
      // ignore: unnecessary_null_comparison
      bubbleSeries.minimumRadius != null
          ? bubbleRadius = bubbleSeries.minimumRadius
          : bubbleRadius = bubbleSeries.maximumRadius;
    } else {
      if (sizeRange == 0) {
        bubbleRadius = bubbleSize == 0
            ? bubbleSeries.minimumRadius
            : bubbleSeries.maximumRadius;
      } else {
        radiusRange =
            (bubbleSeries.maximumRadius - bubbleSeries.minimumRadius) * 2;
        bubbleRadius =
            (((bubbleSize.abs() - minSize) * radiusRange) / sizeRange) +
                bubbleSeries.minimumRadius;
      }
    }
    return bubbleRadius.toDouble();
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _segmentRect = RRect.fromRectAndRadius(_currentPoint!.region!, Radius.zero);
    if (_seriesRenderer._renderingDetails!.widgetNeedUpdate &&
        !_seriesRenderer._reAnimate &&
        !_seriesRenderer._renderingDetails!.isLegendToggled &&
        _seriesRenderer._chartState!._oldSeriesRenderers.isNotEmpty &&
        _oldSeriesRenderer != null &&
        _oldSeriesRenderer!._segments.isNotEmpty &&
        _oldSeriesRenderer!._segments[0] is BubbleSegment &&
        _series.animationDuration > 0 &&
        _oldPoint != null) {
      final BubbleSegment currentSegment =
          _seriesRenderer._segments[currentSegmentIndex!] as BubbleSegment;
      final BubbleSegment? oldSegment =
          (currentSegment._oldSeriesRenderer!._segments.length - 1 >=
                  currentSegmentIndex!)
              ? currentSegment._oldSeriesRenderer!
                  ._segments[currentSegmentIndex!] as BubbleSegment?
              : null;
      _animateBubbleSeries(
          canvas,
          _centerX,
          _centerY,
          oldSegment?._centerX,
          oldSegment?._centerY,
          oldSegment?._size,
          animationFactor,
          _radius,
          strokePaint!,
          fillPaint!,
          _seriesRenderer);
    } else {
      canvas.drawCircle(
          Offset(_centerX, _centerY), _radius * animationFactor, fillPaint!);
      canvas.drawCircle(
          Offset(_centerX, _centerY), _radius * animationFactor, strokePaint!);
    }
  }
}
