part of charts;

/// Creates the segments for stacked bar series.
///
/// Generates the stacked bar series points and has the [calculateSegmentPoints] method overrided to customize
/// the stacked bar segment point calculation.
///
/// Gets the path and color from the `series`.
class StackedBarSegment extends ChartSegment {
  /// Stacked values
  late double stackValues;

  /// Render path
  late Path _path;
  late RRect _trackRect;
  Paint? _trackerFillPaint, _trackerStrokePaint;
  late StackedBarSeries<dynamic, dynamic> _stackedBarSeries;

  /// Rectangle of the segment this could be used to render the segment while overriding this segment
  late RRect segmentRect;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    /// Get and set the paint options for column series.
    if (_series.gradient == null) {
      fillPaint = Paint()
        ..color = _currentPoint!.isEmpty != null && _currentPoint!.isEmpty!
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
        'The opacity value of the stacked bar series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the stacked bar series should be less than or equal to 1.');
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
      ..strokeWidth = _currentPoint!.isEmpty != null && _currentPoint!.isEmpty!
          ? _series.emptyPointSettings.borderWidth
          : _strokeWidth!;
    if (_series.borderGradient != null) {
      strokePaint!.shader =
          _series.borderGradient!.createShader(_currentPoint!.region!);
    } else if (_strokeColor != null) {
      strokePaint!.color =
          _currentPoint!.isEmpty != null && _currentPoint!.isEmpty!
              ? _series.emptyPointSettings.borderColor
              : _strokeColor!;
    }
    _defaultStrokeColor = strokePaint;
    _series.borderWidth == 0
        ? strokePaint!.color = Colors.transparent
        : strokePaint!.color;
    return strokePaint!;
  }

  /// Method to get series tracker fill.
  Paint _getTrackerFillPaint() {
    final StackedBarSeries<dynamic, dynamic> columnSeries =
        _series as StackedBarSeries<dynamic, dynamic>;
    _trackerFillPaint = Paint()
      ..color = columnSeries.trackColor
      ..style = PaintingStyle.fill;
    return _trackerFillPaint!;
  }

  /// Method to get _series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    _stackedBarSeries = _series as StackedBarSeries<dynamic, dynamic>;
    _trackerStrokePaint = Paint()
      ..color = _stackedBarSeries.trackBorderColor
      ..strokeWidth = _stackedBarSeries.trackBorderWidth
      ..style = PaintingStyle.stroke;
    _stackedBarSeries.trackBorderWidth == 0
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
    _stackedBarSeries = _series as StackedBarSeries<dynamic, dynamic>;
    if (_trackerFillPaint != null && _stackedBarSeries.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerFillPaint!);
    }

    if (_trackerStrokePaint != null && _stackedBarSeries.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerStrokePaint!);
    }

    _renderStackingRectSeries(
        fillPaint,
        strokePaint,
        _path,
        animationFactor,
        _seriesRenderer,
        canvas,
        segmentRect,
        _currentPoint!,
        currentSegmentIndex!);
  }
}
