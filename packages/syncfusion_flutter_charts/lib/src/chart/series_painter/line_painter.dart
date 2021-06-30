part of charts;

class _LineChartPainter extends CustomPainter {
  _LineChartPainter(
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
  final LineSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for line series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    Rect clipRect;
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRenderer._dataPoints;
    final LineSeries<dynamic, dynamic> series =
        seriesRenderer._series as LineSeries<dynamic, dynamic>;
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
      int segmentIndex = -1;
      CartesianChartPoint<dynamic>? currentPoint,
          _nextPoint,
          startPoint,
          endPoint;

      if (seriesRenderer._visibleDataPoints == null ||
          seriesRenderer._visibleDataPoints!.isNotEmpty) {
        seriesRenderer._visibleDataPoints = <CartesianChartPoint<dynamic>>[];
      }
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        currentPoint = dataPoints[pointIndex];
        seriesRenderer._calculateRegionData(
            chartState, seriesRenderer, seriesIndex, currentPoint, pointIndex);
        if ((currentPoint.isVisible && !currentPoint.isGap) &&
            startPoint == null) {
          startPoint = currentPoint;
        }
        if (pointIndex + 1 < dataPoints.length) {
          _nextPoint = dataPoints[pointIndex + 1];
          if (startPoint != null && _nextPoint.isVisible && _nextPoint.isGap) {
            startPoint = null;
          } else if (_nextPoint.isVisible && !_nextPoint.isGap) {
            endPoint = _nextPoint;
          }
        }

        if (startPoint != null && endPoint != null) {
          seriesRenderer._drawSegment(
              canvas,
              seriesRenderer._createSegments(startPoint, endPoint,
                  segmentIndex += 1, seriesIndex, animationFactor));
          endPoint = startPoint = null;
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
            'The line series should be available to render a marker on it.');
        canvas.clipRect(clipRect);
        seriesRenderer._renderSeriesElements(
            chart, canvas, seriesRenderer._seriesElementAnimation);
      }
      if (animationFactor >= 1) {
        chartState._setPainterKey(seriesIndex, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) => isRepaint;
}
