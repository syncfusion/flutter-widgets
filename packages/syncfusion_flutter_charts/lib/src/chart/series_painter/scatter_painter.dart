part of charts;

class _ScatterChartPainter extends CustomPainter {
  _ScatterChartPainter(
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
  final Animation<double> animationController;
  final ScatterSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for scatter series
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    double animationFactor;
    final ScatterSeries<dynamic, dynamic> series =
        seriesRenderer._series as ScatterSeries<dynamic, dynamic>;
    if (seriesRenderer._visible!) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
      final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
      final List<CartesianChartPoint<dynamic>> dataPoints =
          seriesRenderer._dataPoints;
      animationFactor = seriesRenderer._seriesAnimation != null
          ? seriesRenderer._seriesAnimation!.value
          : 1;
      final Rect axisClipRect = _calculatePlotOffset(
          chartState._chartAxis._axisClipRect,
          Offset(
              xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));
      canvas.clipRect(axisClipRect);
      final int seriesIndex = painterKey.index;
      seriesRenderer._storeSeriesProperties(chartState, seriesIndex);
      int segmentIndex = -1;
      if (seriesRenderer._visibleDataPoints == null ||
          seriesRenderer._visibleDataPoints!.isNotEmpty) {
        seriesRenderer._visibleDataPoints = <CartesianChartPoint<dynamic>>[];
      }
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        final CartesianChartPoint<dynamic> currentPoint =
            dataPoints[pointIndex];
        seriesRenderer._calculateRegionData(chartState, seriesRenderer,
            painterKey.index, currentPoint, pointIndex);
        if (currentPoint.isVisible && !currentPoint.isGap) {
          seriesRenderer._drawSegment(
              canvas,
              seriesRenderer._createSegments(currentPoint, segmentIndex += 1,
                  seriesIndex, animationFactor));
        }
      }
      if (series.animationDuration <= 0 ||
          animationFactor >= chartState._seriesDurationFactor) {
        seriesRenderer._renderSeriesElements(
            chart, canvas, seriesRenderer._seriesElementAnimation);
      }
      if (animationFactor >= 1) {
        chartState._setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScatterChartPainter oldDelegate) => isRepaint;
}
