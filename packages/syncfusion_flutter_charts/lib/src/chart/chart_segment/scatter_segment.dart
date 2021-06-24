part of charts;

/// Creates the segments for scatter series.
///
/// Generates the scatter series points and has the [calculateSegmentPoints] method overrided to customize
/// the scatter segment point calculation.
///
/// Gets the path and color from the `series`.
class ScatterSegment extends ChartSegment {
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
                  ? _currentPoint!.pointColorMapper
                  : _color)!
          ..style = PaintingStyle.fill;
      }
    } else {
      fillPaint = _getLinearGradientPaint(
          _series.gradient!,
          _currentPoint!.region!,
          _seriesRenderer._chartState!._requireInvertedAxis);
    }
    _defaultFillColor = fillPaint;
    assert(_series.opacity >= 0,
        'The opacity value of the the scatter series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the the scatter series should be less than or equal to 1.');
    fillPaint!.color =
        (_series.opacity < 1 && fillPaint!.color != Colors.transparent)
            ? fillPaint!.color.withOpacity(_series.opacity)
            : fillPaint!.color;
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    final ScatterSeriesRenderer _scatterRenderer =
        _seriesRenderer as ScatterSeriesRenderer;
    final Paint strokePaint = Paint()
      ..color = _currentPoint!.isEmpty == true
          ? _series.emptyPointSettings.borderColor
          : _series.markerSettings.isVisible
              ? _series.markerSettings.borderColor ??
                  _seriesRenderer._seriesColor!
              : _strokeColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = _currentPoint!.isEmpty == true
          ? _series.emptyPointSettings.borderWidth
          : _strokeWidth!;
    (strokePaint.strokeWidth == 0 && !_scatterRenderer._isLineType)
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (fillPaint != null) {
      _series.animationDuration > 0 &&
              !_seriesRenderer._renderingDetails!.isLegendToggled
          ? _animateScatterSeries(
              _seriesRenderer,
              _point!,
              _oldPoint,
              animationFactor,
              canvas,
              fillPaint!,
              strokePaint!,
              currentSegmentIndex!,
              this)
          : _seriesRenderer.drawDataMarker(
              currentSegmentIndex!,
              canvas,
              fillPaint!,
              strokePaint!,
              _point!.markerPoint!.x,
              _point!.markerPoint!.y,
              _seriesRenderer);
    }
  }
}
