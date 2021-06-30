part of charts;

class _SplineChartPainter extends CustomPainter {
  _SplineChartPainter(
      {required this.chartState,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required ValueNotifier<num> notifier,
      required this.painterKey})
      : chart = chartState._chart,
        super(repaint: notifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  final bool isRepaint;
  final AnimationController animationController;
  final SplineSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for spline series
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    final SplineSeries<dynamic, dynamic> series =
        seriesRenderer._series as SplineSeries<dynamic, dynamic>;
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRenderer._dataPoints;
    if (!seriesRenderer._hasDataLabelTemplate) {
      seriesRenderer._drawControlPoints.clear();
    }

    /// Clip rect will be added for series.
    if (seriesRenderer._visible!) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer._storeSeriesProperties(chartState, seriesIndex);
      animationFactor = seriesRenderer._seriesAnimation != null
          ? seriesRenderer._seriesAnimation!.value
          : 1;
      final Rect axisClipRect = _calculatePlotOffset(
          chartState._chartAxis._axisClipRect,
          Offset(
              xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));
      canvas.clipRect(axisClipRect);
      if (seriesRenderer._reAnimate ||
          ((!(renderingDetails.widgetNeedUpdate ||
                      renderingDetails.isLegendToggled) ||
                  !chartState._oldSeriesKeys.contains(series.key)) &&
              series.animationDuration > 0)) {
        _performLinearAnimation(
            chartState, xAxisRenderer._axis, canvas, animationFactor);
      }
      if (!seriesRenderer._hasDataLabelTemplate) {
        _calculateSplineAreaControlPoints(seriesRenderer);
      }

      int segmentIndex = -1;

      CartesianChartPoint<dynamic>? point, _nextPoint, startPoint, endPoint;

      if (seriesRenderer._visibleDataPoints == null ||
          seriesRenderer._visibleDataPoints!.isNotEmpty) {
        seriesRenderer._visibleDataPoints = <CartesianChartPoint<dynamic>>[];
      }

      ///Draw spline for spline series
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        if (_withInRange(seriesRenderer._dataPoints[pointIndex].xValue,
                seriesRenderer._xAxisRenderer!._visibleRange!) ||
            (pointIndex < dataPoints.length - 1 &&
                _withInRange(seriesRenderer._dataPoints[pointIndex + 1].xValue,
                    seriesRenderer._xAxisRenderer!._visibleRange!))) {
          seriesRenderer._calculateRegionData(
              chartState, seriesRenderer, painterKey.index, point, pointIndex);
          if ((point.isVisible && !point.isGap) && startPoint == null) {
            startPoint = point;
          }
          if (pointIndex + 1 < dataPoints.length) {
            _nextPoint = dataPoints[pointIndex + 1];
            if (startPoint != null &&
                _nextPoint.isVisible &&
                _nextPoint.isGap) {
              startPoint = null;
            } else if (_nextPoint.isVisible && !_nextPoint.isGap) {
              endPoint = _nextPoint;
            }
          }
          if (startPoint != null &&
              endPoint != null &&
              startPoint != endPoint) {
            seriesRenderer._drawSegment(
                canvas,
                seriesRenderer._createSegments(startPoint, endPoint,
                    segmentIndex += 1, seriesIndex, animationFactor));
            endPoint = startPoint = null;
          }
        }
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
              (!renderingDetails.initialRender! &&
                  !seriesRenderer._needAnimateSeriesElements) ||
              animationFactor >= chartState._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The spline series should be available to render a marker on it.');
        canvas.clipRect(clipRect);

        ///Draw marker and other elements for spline series
        seriesRenderer._renderSeriesElements(
            chart, canvas, seriesRenderer._seriesElementAnimation);
      }
      if (animationFactor >= 1) {
        chartState._setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(_SplineChartPainter oldDelegate) => isRepaint;
}
