part of charts;

/// Creates the segments for fast line series.
///
/// This generates the fast line series points and has the [calculateSegmentPoints] method overrided to customize
/// the fast line segment point calculation.
///
/// Gets the path and color from the `series`.
class FastLineSegment extends ChartSegment {
  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint _fillPaint = Paint();
    assert(_series.opacity >= 0,
        'The opacity value of the fast line series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the fast line series should be less than or equal to 1.');
    if (_color != null) {
      _fillPaint.color = _color!.withOpacity(_series.opacity);
    }
    _fillPaint.style = PaintingStyle.fill;
    _defaultFillColor = _fillPaint;
    return _fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final Paint _strokePaint = Paint();
    assert(_series.opacity >= 0,
        'The opacity value of the fast line series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the fast line series should be less than or equal to 1.');
    if (_series.gradient == null) {
      if (_strokeColor != null) {
        _strokePaint.color =
            (_series.opacity < 1 && _strokeColor != Colors.transparent)
                ? _strokeColor!.withOpacity(_series.opacity)
                : _strokeColor!;
      }
    } else {
      _strokePaint.shader = _series.gradient!
          .createShader(_seriesRenderer._segmentPath!.getBounds());
    }
    _strokePaint.strokeWidth = _strokeWidth!;
    _strokePaint.style = PaintingStyle.stroke;
    _strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = _strokePaint;
    return _strokePaint;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    // ignore: unnecessary_null_comparison
    _series.dashArray != null
        ? _drawDashedLine(canvas, _series.dashArray, strokePaint!,
            _seriesRenderer._segmentPath!)
        : canvas.drawPath(_seriesRenderer._segmentPath!, strokePaint!);
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}
}
