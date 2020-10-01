part of charts;

class _SplineAreaChartPainter extends CustomPainter {
  _SplineAreaChartPainter(
      {this.chartState,
      this.seriesRenderer,
      this.isRepaint,
      this.animationController,
      ValueNotifier<num> notifier,
      this.painterKey})
      : chart = chartState._chart,
        super(repaint: notifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  final bool isRepaint;
  final AnimationController animationController;
  final SplineAreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for spline area series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    CartesianChartPoint<dynamic> prevPoint, point;
    _ChartLocation currentPoint, originPoint;
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer;
    Rect clipRect;
    final SplineAreaSeries<dynamic, dynamic> series = seriesRenderer._series;
    seriesRenderer?._drawControlPoints?.clear();
    final Path _path = Path();
    final Path _strokePath = Path();
    final List<Offset> _points = <Offset>[];
    final num crossesAt = _getCrossesAtValue(seriesRenderer, chartState);
    final num origin = crossesAt ?? 0;
    if (seriesRenderer._visible) {
      assert(
          series.animationDuration != null
              ? series.animationDuration >= 0
              : true,
          'The animation duration of the spline area series must be greater or equal to 0.');
      final List<CartesianChartPoint<dynamic>> dataPoints =
          seriesRenderer._dataPoints;
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer._storeSeriesProperties(chartState, seriesIndex);
      final bool isTransposed = seriesRenderer._chartState._requireInvertedAxis;
      final Rect axisClipRect = _calculatePlotOffset(
          chartState._chartAxis._axisClipRect,
          Offset(
              xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesRenderer._seriesAnimation != null
          ? seriesRenderer._seriesAnimation.value
          : 1;
      if (seriesRenderer._reAnimate ||
          ((!(chartState._widgetNeedUpdate || chartState._isLegendToggled) ||
                  !chartState._oldSeriesKeys.contains(series.key)) &&
              series.animationDuration > 0)) {
        _performLinearAnimation(
            chartState, xAxisRenderer._axis, canvas, animationFactor);
      }
      _calculateSplineAreaControlPoints(seriesRenderer);

      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer._calculateRegionData(
            chartState, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          currentPoint = _calculatePoint(point.xValue, point.yValue,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          originPoint = _calculatePoint(
              point.xValue,
              math_lib.max(yAxisRenderer._visibleRange.minimum, origin),
              xAxisRenderer,
              yAxisRenderer,
              isTransposed,
              series,
              axisClipRect);
          final num x = currentPoint.x;
          final num y = currentPoint.y;
          _points.add(Offset(currentPoint.x, currentPoint.y));
          final bool closed =
              series.emptyPointSettings.mode == EmptyPointMode.drop
                  ? _getSeriesVisibility(dataPoints, pointIndex)
                  : false;
          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            _path.moveTo(originPoint.x, originPoint.y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom ||
                series.borderDrawMode == BorderDrawMode.all) {
              if (dataPoints[pointIndex].isGap != true) {
                _strokePath.moveTo(originPoint.x, originPoint.y);
                _strokePath.lineTo(x, y);
              }
            } else if (series.borderDrawMode == BorderDrawMode.top) {
              _strokePath.moveTo(x, y);
            }
            _path.lineTo(x, y);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            _strokePath.cubicTo(point.startControl.x, point.startControl.y,
                point.endControl.x, point.endControl.y, x, y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
              _strokePath.lineTo(originPoint.x, originPoint.y);
            } else if (series.borderDrawMode == BorderDrawMode.all) {
              _strokePath.lineTo(originPoint.x, originPoint.y);
              _strokePath.close();
            }
            _path.cubicTo(point.startControl.x, point.startControl.y,
                point.endControl.x, point.endControl.y, x, y);
            _path.lineTo(originPoint.x, originPoint.y);
          } else {
            _strokePath.cubicTo(point.startControl.x, point.startControl.y,
                point.endControl.x, point.endControl.y, x, y);
            _path.cubicTo(point.startControl.x, point.startControl.y,
                point.endControl.x, point.endControl.y, x, y);

            if (closed) {
              _path.cubicTo(
                  point.startControl.x,
                  point.startControl.y,
                  point.endControl.x,
                  point.endControl.y,
                  originPoint.x,
                  originPoint.y);
              if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
                _strokePath.lineTo(originPoint.x, originPoint.y);
              } else if (series.borderDrawMode == BorderDrawMode.all) {
                _strokePath.cubicTo(
                    point.startControl.x,
                    point.startControl.y,
                    point.endControl.x,
                    point.endControl.y,
                    originPoint.x,
                    originPoint.y);
                _strokePath.close();
              }
            }
          }
          prevPoint = point;
        }
      }

      if (_path != null) {
        seriesRenderer._drawSegment(
            canvas,
            seriesRenderer._createSegments(
                painterKey.index, chart, animationFactor, _path, _strokePath));
      }

      clipRect = _calculatePlotOffset(
          Rect.fromLTRB(
              chartState._chartAxis._axisClipRect.left -
                  series.markerSettings.width,
              chartState._chartAxis._axisClipRect.top -
                  series.markerSettings.height,
              chartState._chartAxis._axisClipRect.right +
                  series.markerSettings.width,
              chartState._chartAxis._axisClipRect.bottom +
                  series.markerSettings.height),
          Offset(
              xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));
      canvas.restore();
      if ((series.animationDuration <= 0 ||
              !chartState._initialRender ||
              animationFactor >= chartState._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        assert(seriesRenderer != null,
            'The spline area series should be available to render a marker on it.');
        canvas.clipRect(clipRect);
        seriesRenderer._renderSeriesElements(
            chart, canvas, seriesRenderer._seriesElementAnimation);
      }
      if (animationFactor >= 1) {
        chartState._setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(_SplineAreaChartPainter oldDelegate) => isRepaint;

  /// It returns the visibility of area series
  bool _getSeriesVisibility(
      List<CartesianChartPoint<dynamic>> points, int index) {
    for (int i = index; i < points.length - 1; i++) {
      if (!points[i + 1].isDrop) {
        return false;
      }
    }
    return true;
  }
}
