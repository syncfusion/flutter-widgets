part of charts;

class _CandlePainter extends CustomPainter {
  _CandlePainter(
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
  List<_ChartLocation> currentChartLocations = <_ChartLocation>[];
  CandleSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for candle series
  @override
  void paint(Canvas canvas, Size size) {
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRenderer._dataPoints;
    Rect clipRect;
    double animationFactor;
    final CandleSeries<dynamic, dynamic> series =
        seriesRenderer._series as CandleSeries<dynamic, dynamic>;
    CartesianChartPoint<dynamic> point;
    if (seriesRenderer._visible!) {
      canvas.save();
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the bar series must be greater than or equal to 0.');
      final int seriesIndex = painterKey.index;
      seriesRenderer._storeSeriesProperties(chartState, seriesIndex);
      final Rect axisClipRect = _calculatePlotOffset(
          chartState._chartAxis._axisClipRect,
          Offset(
              xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesRenderer._seriesAnimation != null
          ? seriesRenderer._seriesAnimation!.value
          : 1;
      int segmentIndex = -1;
      if (seriesRenderer._visibleDataPoints == null ||
          seriesRenderer._visibleDataPoints!.isNotEmpty) {
        seriesRenderer._visibleDataPoints = <CartesianChartPoint<dynamic>>[];
      }

      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        if (_withInRange(seriesRenderer._dataPoints[pointIndex].xValue,
            seriesRenderer._xAxisRenderer!._visibleRange!)) {
          seriesRenderer._calculateRegionData(
              chartState,
              seriesRenderer,
              painterKey.index,
              point,
              pointIndex,
              seriesRenderer._sideBySideInfo);

          if (point.isVisible && !point.isGap) {
            seriesRenderer._drawSegment(
                canvas,
                seriesRenderer._createSegments(point, segmentIndex += 1,
                    painterKey.index, animationFactor));
          }
        }
      }
      clipRect = _calculatePlotOffset(
          Rect.fromLTWH(
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
              animationFactor >= chartState._seriesDurationFactor) &&
          series.dataLabelSettings.isVisible) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The candle series should be available to render a data label on it.');
        canvas.clipRect(clipRect);
        seriesRenderer._renderSeriesElements(
            chart, canvas, seriesRenderer._seriesElementAnimation);
      }
      if (seriesRenderer._visible! && animationFactor >= 1) {
        chartState._setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(_CandlePainter oldDelegate) => isRepaint;
}
