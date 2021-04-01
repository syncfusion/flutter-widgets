part of charts;

/// Creates the segments for  step area series.
///
/// Generates the step area series points and has the [calculateSegmentPoints] method overrided to customize
/// the step area segment point calculation.
///
/// Gets the path and color from the `series`.
class StepAreaSegment extends ChartSegment {
  late Path _path, _strokePath;
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
      // ignore: unnecessary_null_comparison
      fillPaint = (_pathRect != null)
          ? _getLinearGradientPaint(_series.gradient!, _pathRect!,
              _seriesRenderer._chartState!._requireInvertedAxis)
          : fillPaint;
    }
    assert(_series.opacity >= 0,
        'The opacity value of the the step area series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the the step area series should be less than or equal to 1.');
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
    final Paint strokePaint = Paint();
    if (_strokeColor != null) {
      strokePaint
        ..color = _series.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _series.borderWidth;
      _series.borderWidth == 0
          ? strokePaint.color = Colors.transparent
          : strokePaint.color;
    }
    strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _pathRect = _path.getBounds();
    canvas.drawPath(
        _path, (_series.gradient == null) ? fillPaint! : getFillPaint());

    if (strokePaint!.color != Colors.transparent) {
      _drawDashedLine(canvas, _series.dashArray, strokePaint!, _strokePath);
    }
  }
}
