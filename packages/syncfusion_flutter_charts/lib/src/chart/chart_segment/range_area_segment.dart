part of charts;

/// Creates the segments for range area series.
///
/// Generates the range area series points and has the [calculateSegmentPoints] method overrided to customize
/// the range area segment point calculation.
///
/// Gets the path and color from the `series`.
class RangeAreaSegment extends ChartSegment {
  late Path _path;
  Path? _borderPath;

  ///For storing the path in RangeAreaBorderMode.excludeSides mode
  Rect? _pathRect;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    fillPaint = Paint();
    if (_series.gradient == null) {
      if (_color != null) {
        fillPaint!.color = _color!;
        fillPaint!.style = PaintingStyle.fill;
      }
    } else {
      fillPaint = (_pathRect != null)
          ? _getLinearGradientPaint(_series.gradient!, _pathRect!,
              _seriesRenderer._chartState!._requireInvertedAxis)
          : fillPaint;
    }
    assert(_series.opacity >= 0,
        'The opacity value of the range area series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the range area series should be less than or equal to 1.');
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
    final Paint _strokePaint = Paint();
    _strokePaint
      ..style = PaintingStyle.stroke
      ..strokeWidth = _series.borderWidth;
    if (_series.borderGradient != null && _borderPath != null) {
      _strokePaint.shader =
          _series.borderGradient!.createShader(_borderPath!.getBounds());
    } else if (_strokeColor != null) {
      _strokePaint.color = _series.borderColor;
    }
    _series.borderWidth == 0
        ? _strokePaint.color = Colors.transparent
        : _strokePaint.color;
    _strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = _strokePaint;
    return _strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final RangeAreaSeries<dynamic, dynamic> _series =
        this._series as RangeAreaSeries<dynamic, dynamic>;
    _pathRect = _path.getBounds();
    canvas.drawPath(
        _path, (_series.gradient == null) ? fillPaint! : getFillPaint());
    strokePaint = getStrokePaint();
    if (strokePaint!.color != Colors.transparent) {
      _drawDashedLine(
          canvas,
          _series.dashArray,
          strokePaint!,
          _series.borderDrawMode == RangeAreaBorderMode.all
              ? _path
              : _borderPath!);
    }
  }
}
