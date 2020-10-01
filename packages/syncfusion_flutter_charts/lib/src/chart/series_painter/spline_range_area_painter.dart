part of charts;

class _SplineRangeAreaChartPainter extends CustomPainter {
  _SplineRangeAreaChartPainter(
      {this.chartState,
      this.isRepaint,
      this.animationController,
      ValueNotifier<num> notifier,
      this.painterKey,
      this.seriesRenderer})
      : chart = chartState._chart,
        super(repaint: notifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  final bool isRepaint;
  final Animation<double> animationController;
  final SplineRangeAreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for spline range area series
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    _ChartLocation currentPointLow,
        currentPointHigh,
        renderPointlow,
        renderPointhigh;
    final int pointsLength = seriesRenderer._dataPoints.length;
    CartesianChartPoint<dynamic> prevPoint, point;
    List<_ControlPoints> controlPointslow;
    final Path _path = Path();
    final Path _strokePath = Path();
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRenderer._dataPoints;
    _ChartLocation renderControlPointlow1, renderControlPointlow2;
    final List<Offset> _points = <Offset>[];
    seriesRenderer?._drawHighControlPoints?.clear();
    seriesRenderer?._drawLowControlPoints?.clear();

    /// Clip rect will be added for series.
    if (seriesRenderer._visible) {
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer._storeSeriesProperties(chartState, seriesIndex);
      final bool isTransposed = chartState._requireInvertedAxis;
      final SplineRangeAreaSeries<dynamic, dynamic> series =
          seriesRenderer._series;
      assert(
          series.animationDuration != null
              ? series.animationDuration >= 0
              : true,
          'The animation duration of the spline range area series must be greater or equal to 0.');
      SplineRangeAreaSegment splineRangeAreaSegment;
      final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer;
      final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer;
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

      for (int pointIndex = 0; pointIndex < pointsLength; pointIndex++) {
        point = seriesRenderer._dataPoints[pointIndex];
        seriesRenderer._calculateRegionData(
            chartState, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          currentPointLow = _calculatePoint(point.xValue, point.low,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          currentPointHigh = _calculatePoint(point.xValue, point.high,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          renderPointhigh = _calculatePoint(point.xValue, point.high,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          _points.add(Offset(currentPointLow.x, currentPointLow.y));
          _points.add(Offset(currentPointHigh.x, currentPointHigh.y));
          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            _path.moveTo(currentPointLow.x, currentPointLow.y);
            _path.lineTo(currentPointHigh.x, currentPointHigh.y);
            _strokePath.moveTo(currentPointHigh.x, currentPointHigh.y);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            _path.cubicTo(
                point.highStartControl.x,
                point.highStartControl.y,
                point.highEndControl.x,
                point.highEndControl.y,
                renderPointhigh.x,
                renderPointhigh.y);

            _strokePath.cubicTo(
                point.highStartControl.x,
                point.highStartControl.y,
                point.highEndControl.x,
                point.highEndControl.y,
                renderPointhigh.x,
                renderPointhigh.y);

            _path.lineTo(currentPointLow.x, currentPointLow.y);

            _strokePath.lineTo(currentPointHigh.x, currentPointHigh.y);
            _strokePath.moveTo(currentPointLow.x, currentPointLow.y);
          } else {
            _path.cubicTo(
                point.highStartControl.x,
                point.highStartControl.y,
                point.highEndControl.x,
                point.highEndControl.y,
                renderPointhigh.x,
                renderPointhigh.y);

            _strokePath.cubicTo(
                point.highStartControl.x,
                point.highStartControl.y,
                point.highEndControl.x,
                point.highEndControl.y,
                renderPointhigh.x,
                renderPointhigh.y);
          }

          prevPoint = point;
        }
        if (pointIndex >= dataPoints.length - 1) {
          seriesRenderer._createSegments(painterKey.index, chart,
              animationFactor, _path, _strokePath, _points);
        }
      }

      for (int pointIndex = dataPoints.length - 2;
          pointIndex >= 0;
          pointIndex--) {
        point = dataPoints[pointIndex];
        if (point.isVisible && !point.isDrop) {
          currentPointLow = _calculatePoint(point.xValue, point.low,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          currentPointHigh = _calculatePoint(point.xValue, point.high,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);

          if (dataPoints[pointIndex + 1].isGap == true) {
            _strokePath.moveTo(currentPointLow.x, currentPointLow.y);
            _path.moveTo(currentPointLow.x, currentPointLow.y);
          } else if (dataPoints[pointIndex].isGap != true) {
            if (pointIndex + 1 == dataPoints.length - 1 &&
                dataPoints[pointIndex + 1].isDrop) {
              _strokePath.moveTo(currentPointLow.x, currentPointLow.y);
            } else {
              controlPointslow = seriesRenderer
                  ._drawLowControlPoints[
                      seriesRenderer._dataPoints.indexOf(point)]
                  ._listControlPoints;

              renderPointlow = _calculatePoint(
                  point.xValue,
                  point.low,
                  xAxisRenderer,
                  yAxisRenderer,
                  seriesRenderer._chartState._requireInvertedAxis,
                  series,
                  axisClipRect);

              renderControlPointlow1 = _calculatePoint(
                  controlPointslow[0].controlPoint1,
                  controlPointslow[0].controlPoint2,
                  xAxisRenderer,
                  yAxisRenderer,
                  seriesRenderer._chartState._requireInvertedAxis,
                  series,
                  axisClipRect);

              renderControlPointlow2 = _calculatePoint(
                  controlPointslow[1].controlPoint1,
                  controlPointslow[1].controlPoint2,
                  xAxisRenderer,
                  yAxisRenderer,
                  seriesRenderer._chartState._requireInvertedAxis,
                  series,
                  axisClipRect);
              _strokePath.cubicTo(
                  renderControlPointlow2.x,
                  renderControlPointlow2.y,
                  renderControlPointlow1.x,
                  renderControlPointlow1.y,
                  renderPointlow.x,
                  renderPointlow.y);
            }
            controlPointslow = seriesRenderer
                ._drawLowControlPoints[
                    seriesRenderer._dataPoints.indexOf(point)]
                ._listControlPoints;

            renderPointlow = _calculatePoint(
                point.xValue,
                point.low,
                xAxisRenderer,
                yAxisRenderer,
                seriesRenderer._chartState._requireInvertedAxis,
                series,
                axisClipRect);

            renderControlPointlow1 = _calculatePoint(
                controlPointslow[0].controlPoint1,
                controlPointslow[0].controlPoint2,
                xAxisRenderer,
                yAxisRenderer,
                seriesRenderer._chartState._requireInvertedAxis,
                series,
                axisClipRect);

            renderControlPointlow2 = _calculatePoint(
                controlPointslow[1].controlPoint1,
                controlPointslow[1].controlPoint2,
                xAxisRenderer,
                yAxisRenderer,
                seriesRenderer._chartState._requireInvertedAxis,
                series,
                axisClipRect);

            _path.cubicTo(
                renderControlPointlow2.x,
                renderControlPointlow2.y,
                renderControlPointlow1.x,
                renderControlPointlow1.y,
                renderPointlow.x,
                renderPointlow.y);
          }
        }
      }

      /// Draw the spline range area series
      if (_path != null &&
          seriesRenderer._segments != null &&
          seriesRenderer._segments.isNotEmpty) {
        splineRangeAreaSegment = seriesRenderer._segments[0];
        seriesRenderer._drawSegment(
            canvas,
            splineRangeAreaSegment
              .._path = _path
              .._strokePath = _strokePath);
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
              (!chartState._initialRender &&
                  !seriesRenderer._needAnimateSeriesElements) ||
              animationFactor >= chartState._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        assert(seriesRenderer != null,
            'The spline range area series should be available to render a marker on it.');
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
  bool shouldRepaint(_SplineRangeAreaChartPainter oldDelegate) => isRepaint;
}
