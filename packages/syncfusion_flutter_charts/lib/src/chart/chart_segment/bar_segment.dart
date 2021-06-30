part of charts;

/// Creates the segments for bar series.
///
/// This generates the bar series points and has the [calculateSegmentPoints] override method
/// used to customize the bar series segment point calculation.
///
/// It gets the path, stroke color and fill color from the `series` to render the bar segment.
///
class BarSegment extends ChartSegment {
  late RRect _trackBarRect;

  Paint? _trackerFillPaint, _trackerStrokePaint;
  late Path _path;

  /// Rectangle of the segment this could be used to render the segment while overriding this segment
  late RRect segmentRect;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    if (_series.gradient == null) {
      fillPaint = Paint()
        ..color = _currentPoint!.isEmpty == true
            ? _series.emptyPointSettings.color
            : (_currentPoint!.pointColorMapper ?? _color!)
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = _getLinearGradientPaint(
          _series.gradient!,
          _currentPoint!.region!,
          _seriesRenderer._chartState!._requireInvertedAxis);
    }
    assert(_series.opacity >= 0,
        'The opacity value of the the bar series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the the bar series should be less than or equal to 1.');
    fillPaint!.color =
        (_series.opacity < 1 && fillPaint!.color != Colors.transparent)
            ? fillPaint!.color.withOpacity(_series.opacity)
            : fillPaint!.color;
    _defaultFillColor = fillPaint;
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _currentPoint!.isEmpty == true
          ? _series.emptyPointSettings.borderWidth
          : _strokeWidth!;
    (_series.borderGradient != null)
        ? strokePaint!.shader =
            _series.borderGradient!.createShader(_currentPoint!.region!)
        : strokePaint!.color = _currentPoint!.isEmpty == true
            ? _series.emptyPointSettings.borderColor
            : _strokeColor!;
    _series.borderWidth == 0
        ? strokePaint!.color = Colors.transparent
        : strokePaint!.color;
    _defaultStrokeColor = strokePaint;
    return strokePaint!;
  }

  /// Method to get series tracker fill.
  Paint _getTrackerFillPaint() {
    if (_series is BarSeries) {
      final BarSeries<dynamic, dynamic> barSeries =
          _series as BarSeries<dynamic, dynamic>;
      _trackerFillPaint = Paint()
        ..color = barSeries.trackColor
        ..style = PaintingStyle.fill;
    }
    return _trackerFillPaint!;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    final BarSeries<dynamic, dynamic> barSeries =
        _series as BarSeries<dynamic, dynamic>;
    _trackerStrokePaint = Paint()
      ..color = barSeries.trackBorderColor
      ..strokeWidth = barSeries.trackBorderWidth
      ..style = PaintingStyle.stroke;
    barSeries.trackBorderWidth == 0
        ? _trackerStrokePaint!.color = Colors.transparent
        : _trackerStrokePaint!.color;
    return _trackerStrokePaint!;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final BarSeries<dynamic, dynamic> barSeries =
        _series as BarSeries<dynamic, dynamic>;
    if (_trackerFillPaint != null && barSeries.isTrackVisible) {
      _drawSegmentRect(canvas, _trackBarRect, _trackerFillPaint!);
    }

    if (_trackerStrokePaint != null && barSeries.isTrackVisible) {
      _drawSegmentRect(canvas, _trackBarRect, _trackerStrokePaint!);
    }

    if (fillPaint != null) {
      _drawSegmentRect(canvas, segmentRect, fillPaint!);
    }
    if (strokePaint != null) {
      (_series.dashArray[0] != 0 && _series.dashArray[1] != 0)
          ? _drawDashedLine(canvas, _series.dashArray, strokePaint!, _path)
          : _drawSegmentRect(canvas, segmentRect, strokePaint!);
    }
  }

  /// To draw Segment rect of bar segment
  void _drawSegmentRect(Canvas canvas, RRect segmentRect, Paint paint) {
    (_series.animationDuration > 0)
        ? _animateRectSeries(
            canvas,
            _seriesRenderer,
            paint,
            segmentRect,
            _currentPoint!.yValue,
            animationFactor,
            _oldPoint?.region ?? _oldRegion,
            _oldPoint?.yValue,
            _oldSeriesVisible)
        : canvas.drawRRect(segmentRect, paint);
  }
}
