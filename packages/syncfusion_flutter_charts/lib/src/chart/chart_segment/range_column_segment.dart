part of charts;

/// Creates the segments for range column series.
///
/// Generates the range column series points and has the [calculateSegmentPoints] method overrided to customize
/// the range column segment point calculation.
///
/// Gets the path and color from the `series`.
class RangeColumnSegment extends ChartSegment {
  //ignore: unused_field
  late double _x1, _low1, _high1;

  ///Path of the series
  late Path _path;
  late RRect _trackRect;
  Paint? _trackerFillPaint, _trackerStrokePaint;

  //We are using `segmentRect` to draw the histogram segment in the series.
  //we can override this class and customize the column segment by getting `segmentRect`.
  /// Rectangle of the segment
  late RRect segmentRect;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final bool hasPointColor = _series.pointColorMapper != null;

    /// Get and set the paint options for range column series.
    if (_series.gradient == null) {
      fillPaint = Paint()
        ..color = _currentPoint!.isEmpty == true
            ? _series.emptyPointSettings.color
            : ((hasPointColor && _currentPoint!.pointColorMapper != null)
                ? _currentPoint!.pointColorMapper
                : _color)!
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = _getLinearGradientPaint(
          _series.gradient!,
          _currentPoint!.region!,
          _seriesRenderer._chartState!._requireInvertedAxis);
    }
    assert(_series.opacity >= 0,
        'The opacity value of the range column series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the range column series should be less than or equal to 1.');
    fillPaint!.color =
        (_series.opacity < 1 && fillPaint!.color != Colors.transparent)
            ? fillPaint!.color.withOpacity(_series.opacity)
            : fillPaint!.color;
    _defaultFillColor = fillPaint!;
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
    _defaultStrokeColor = strokePaint;
    _series.borderGradient != null
        ? strokePaint!.shader =
            _series.borderGradient!.createShader(_currentPoint!.region!)
        : strokePaint!.color = _currentPoint!.isEmpty == true
            ? _series.emptyPointSettings.borderColor
            : _strokeColor!;
    _series.borderWidth == 0
        ? strokePaint!.color = Colors.transparent
        : strokePaint!.color;
    return strokePaint!;
  }

  /// Method to get series tracker fill.
  Paint _getTrackerFillPaint() {
    final RangeColumnSeries<dynamic, dynamic> _series =
        this._series as RangeColumnSeries<dynamic, dynamic>;

    _trackerFillPaint = Paint()
      ..color = _series.trackColor
      ..style = PaintingStyle.fill;

    return _trackerFillPaint!;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    final RangeColumnSeries<dynamic, dynamic> _series =
        this._series as RangeColumnSeries<dynamic, dynamic>;
    _trackerStrokePaint = Paint()
      ..color = _series.trackBorderColor
      ..strokeWidth = _series.trackBorderWidth
      ..style = PaintingStyle.stroke;
    _series.trackBorderWidth == 0
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
    final RangeColumnSeries<dynamic, dynamic> _series =
        this._series as RangeColumnSeries<dynamic, dynamic>;

    if (_trackerFillPaint != null && _series.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerFillPaint!);
    }

    if (_trackerStrokePaint != null && _series.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerStrokePaint!);
    }

    if (fillPaint != null) {
      (_series.animationDuration > 0 &&
              !_seriesRenderer._renderingDetails!.isLegendToggled)
          ? _animateRangeColumn(
              canvas,
              _seriesRenderer,
              fillPaint!,
              segmentRect,
              _oldPoint != null ? _oldPoint!.region : _oldRegion,
              animationFactor)
          : canvas.drawRRect(segmentRect, fillPaint!);
    }
    if (strokePaint != null) {
      (_series.dashArray[0] != 0 && _series.dashArray[1] != 0)
          ? _drawDashedLine(canvas, _series.dashArray, strokePaint!, _path)
          : (_series.animationDuration > 0 &&
                  !_seriesRenderer._renderingDetails!.isLegendToggled)
              ? _animateRangeColumn(
                  canvas,
                  _seriesRenderer,
                  strokePaint!,
                  segmentRect,
                  _oldPoint != null ? _oldPoint!.region : _oldRegion,
                  animationFactor)
              : canvas.drawRRect(segmentRect, strokePaint!);
    }
  }
}
