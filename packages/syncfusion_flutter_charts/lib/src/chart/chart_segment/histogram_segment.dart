part of charts;

/// Creates the segments for column series.
///
/// This generates the column series points and has the [calculateSegmentPoints] override method
/// used to customize the column series segment point calculation.
///
/// It gets the path, stroke color and fill color from the `series` to render the column segment.
///
class HistogramSegment extends ChartSegment {
  /// Render path.
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
    // final bool hasPointColor = series.pointColorMapper != null ? true : false;

    /// Get and set the paint options for column series.
    if (_series.gradient == null) {
      if (_color != null) {
        fillPaint = Paint()
          ..color = _currentPoint!.isEmpty == true
              ? _series.emptyPointSettings.color
              : ((_currentPoint!.pointColorMapper != null)
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
        'The opacity value of the histogram series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the histogram series should be less than or equal to 1.');
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
    if (_series.borderGradient != null) {
      strokePaint!.shader =
          _series.borderGradient!.createShader(_currentPoint!.region!);
    } else if (_strokeColor != null) {
      strokePaint!.color = _currentPoint!.isEmpty == true
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
    final HistogramSeries<dynamic, dynamic> histogramSeries =
        _series as HistogramSeries<dynamic, dynamic>;
    if (_color != null) {
      _trackerFillPaint = Paint()
        ..color = histogramSeries.trackColor
        ..style = PaintingStyle.fill;
    }
    return _trackerFillPaint!;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    final HistogramSeries<dynamic, dynamic> histogramSeries =
        _series as HistogramSeries<dynamic, dynamic>;
    _trackerStrokePaint = Paint()
      ..color = histogramSeries.trackBorderColor
      ..strokeWidth = histogramSeries.trackBorderWidth
      ..style = PaintingStyle.stroke;
    histogramSeries.trackBorderWidth == 0
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
    final HistogramSeries<dynamic, dynamic> histogramSeries =
        _series as HistogramSeries<dynamic, dynamic>;

    if (_trackerFillPaint != null && histogramSeries.isTrackVisible) {
      _drawSegmentRect(_trackerFillPaint!, canvas, _trackRect);
    }

    if (_trackerStrokePaint != null && histogramSeries.isTrackVisible) {
      _drawSegmentRect(_trackerStrokePaint!, canvas, _trackRect);
    }

    if (fillPaint != null) {
      _drawSegmentRect(fillPaint!, canvas, segmentRect);
    }
    if (strokePaint != null) {
      (_series.dashArray[0] != 0 && _series.dashArray[1] != 0)
          ? _drawDashedLine(canvas, _series.dashArray, strokePaint!, _path)
          : _drawSegmentRect(strokePaint!, canvas, segmentRect);
    }
  }

  /// To draw the rect of a given segment
  void _drawSegmentRect(Paint getPaint, Canvas canvas, RRect getRect) {
    ((_renderingDetails.initialRender! ||
                _renderingDetails.isLegendToggled ||
                (_series.key != null &&
                    _chartState._oldSeriesKeys.contains(_series.key))) &&
            _series.animationDuration > 0)
        ? _animateRectSeries(
            canvas,
            _seriesRenderer,
            getPaint,
            getRect,
            _currentPoint!.yValue,
            animationFactor,
            _oldPoint != null ? _oldPoint!.region : _oldRegion,
            _oldPoint?.yValue,
            _oldSeriesVisible)
        : canvas.drawRRect(getRect, getPaint);
  }
}
