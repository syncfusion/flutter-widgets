part of charts;

/// Creates the segments for waterfall series.
///
/// Generates the waterfall series points and has the [calculateSegmentPoints] method overrided to customize
/// the waterfall segment point calculation.
///
/// Gets the path and color from the `series`.
class WaterfallSegment extends ChartSegment {
  /// To find the x and y values of connector lines between each data point.
  late double _x1, _y1, _x2, _y2;

  ///Path of the series
  late Path _path;

  /// Get the connetor line paint
  Paint? connectorLineStrokePaint;

  /// Colors of the negative point, intermediate point and total point.
  Color? _negativePointsColor, _intermediateSumColor, _totalSumColor;

  /// We are using `segmentRect` to draw the bar segment in the series.
  /// we can override this class and customize the waterfall segment by getting `segmentRect`.
  late RRect segmentRect;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final bool hasPointColor = _series.pointColorMapper != null;

    /// Get and set the paint options for waterfall series.
    if (_series.gradient == null) {
      fillPaint = Paint()
        ..color = ((hasPointColor && _currentPoint!.pointColorMapper != null)
            ? _currentPoint!.pointColorMapper
            : _currentPoint!.isIntermediateSum!
                ? _intermediateSumColor ?? _color!
                : _currentPoint!.isTotalSum!
                    ? _totalSumColor ?? _color!
                    : _currentPoint!.yValue < 0 == true
                        ? _negativePointsColor ?? _color!
                        : _color!)!
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = _getLinearGradientPaint(
          _series.gradient!,
          _currentPoint!.region!,
          _seriesRenderer._chartState!._requireInvertedAxis);
    }
    assert(_series.opacity >= 0,
        'The opacity value of the waterfall series should be greater than or equal to 0.');
    assert(_series.opacity <= 1,
        'The opacity value of the waterfall series should be less than or equal to 1.');
    fillPaint!.color =
        (_series.opacity < 1 && fillPaint!.color != Colors.transparent)
            ? fillPaint!.color.withOpacity(_series.opacity)
            : fillPaint!.color;
    _defaultFillColor = fillPaint;
    return fillPaint!;
  }

  /// Get the color of connector lines.
  Paint _getConnectorLineStrokePaint() {
    final WaterfallSeries<dynamic, dynamic> series =
        _series as WaterfallSeries<dynamic, dynamic>;
    connectorLineStrokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = series.connectorLineSettings.width
      ..color = series.connectorLineSettings.color ??
          _renderingDetails.chartTheme.waterfallConnectorLineColor;
    return connectorLineStrokePaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth!;
    _defaultStrokeColor = strokePaint;
    _series.borderGradient != null
        ? strokePaint!.shader =
            _series.borderGradient!.createShader(_currentPoint!.region!)
        : strokePaint!.color = _strokeColor!;
    _series.borderWidth == 0
        ? strokePaint!.color = Colors.transparent
        : strokePaint!.color;
    return strokePaint!;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final WaterfallSeries<dynamic, dynamic> _series =
        this._series as WaterfallSeries<dynamic, dynamic>;
    CartesianChartPoint<dynamic> oldPaint;
    final Path linePath = Path();

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
    if (connectorLineStrokePaint != null &&
        _currentPoint!.overallDataPointIndex! > 0) {
      oldPaint = _seriesRenderer
          ._dataPoints[_currentPoint!.overallDataPointIndex! - 1];
      _x1 = oldPaint.endValueRightPoint!.x;
      _y1 = oldPaint.endValueRightPoint!.y;
      if (_currentPoint!.isTotalSum! || _currentPoint!.isIntermediateSum!) {
        _x2 = _currentPoint!.endValueLeftPoint!.x;
        _y2 = _currentPoint!.endValueLeftPoint!.y;
      } else {
        _x2 = _currentPoint!.originValueLeftPoint!.x;
        _y2 = _currentPoint!.originValueLeftPoint!.y;
      }
      if (_series.animationDuration <= 0 ||
          animationFactor >=
              _seriesRenderer._chartState!._seriesDurationFactor) {
        if (_series.connectorLineSettings.dashArray![0] != 0 &&
            _series.connectorLineSettings.dashArray![1] != 0) {
          linePath.moveTo(_x1, _y1);
          linePath.lineTo(_x2, _y2);
          _drawDashedLine(canvas, _series.connectorLineSettings.dashArray!,
              connectorLineStrokePaint!, linePath);
        } else {
          canvas.drawLine(
              Offset(_x1, _y1), Offset(_x2, _y2), connectorLineStrokePaint!);
        }
      }
    }
  }
}
