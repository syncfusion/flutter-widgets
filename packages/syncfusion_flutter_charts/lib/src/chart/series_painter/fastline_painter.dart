part of charts;

class _FastLineChartPainter extends CustomPainter {
  _FastLineChartPainter(
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
  final FastLineSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for fast line series
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    final FastLineSeries<dynamic, dynamic> series =
        seriesRenderer._series as FastLineSeries<dynamic, dynamic>;
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
    final List<Offset> _points = <Offset>[];
    if (seriesRenderer._visible!) {
      canvas.save();
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
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
          (series.animationDuration > 0 &&
              !seriesRenderer._renderingDetails!.isLegendToggled)) {
        seriesRenderer._needAnimateSeriesElements =
            seriesRenderer._needsAnimation;
        _performLinearAnimation(
            chartState, xAxisRenderer._axis, canvas, animationFactor);
      }
      CartesianChartPoint<dynamic>? prevPoint, point;
      _ChartLocation currentLocation;
      final _VisibleRange xVisibleRange = xAxisRenderer._visibleRange!;
      final _VisibleRange yVisibleRange = yAxisRenderer._visibleRange!;
      final List<CartesianChartPoint<dynamic>> seriesPoints =
          seriesRenderer._dataPoints;
      assert(seriesPoints.isNotEmpty,
          'The data points should be available to render fast line series.');
      final Rect areaBounds =
          seriesRenderer._chartState!._chartAxis._axisClipRect;
      final num xTolerance = (xVisibleRange.delta / areaBounds.width).abs();
      final num yTolerance = (yVisibleRange.delta / areaBounds.height).abs();
      num prevXValue = (seriesPoints.isNotEmpty &&
              // ignore: unnecessary_null_comparison
              seriesPoints[0] != null &&
              (seriesPoints[0].xValue > xTolerance) == true)
          ? 0
          : xTolerance;
      num prevYValue = (seriesPoints.isNotEmpty &&
              // ignore: unnecessary_null_comparison
              seriesPoints[0] != null &&
              (seriesPoints[0].yValue > yTolerance) == true)
          ? 0
          : yTolerance;
      num xVal = 0;
      num yVal = 0;

      final List<CartesianChartPoint<dynamic>> dataPoints =
          <CartesianChartPoint<dynamic>>[];

      ///Eliminating nearest points
      CartesianChartPoint<dynamic> currentPoint;
      if (seriesRenderer._visibleDataPoints == null ||
          seriesRenderer._visibleDataPoints!.isNotEmpty) {
        seriesRenderer._visibleDataPoints = <CartesianChartPoint<dynamic>>[];
      }
      for (int pointIndex = 0;
          pointIndex < seriesRenderer._dataPoints.length;
          pointIndex++) {
        currentPoint = seriesRenderer._dataPoints[pointIndex];
        xVal = currentPoint.xValue ?? xVisibleRange.minimum;
        yVal = currentPoint.yValue ?? yVisibleRange.minimum;
        if ((prevXValue - xVal).abs() >= xTolerance ||
            (prevYValue - yVal).abs() >= yTolerance) {
          point = currentPoint;
          dataPoints.add(currentPoint);
          seriesRenderer._calculateRegionData(
              chartState, seriesRenderer, painterKey.index, point, pointIndex);
          if (point.isVisible) {
            currentLocation = _calculatePoint(
                xVal,
                yVal,
                xAxisRenderer,
                yAxisRenderer,
                seriesRenderer._chartState!._requireInvertedAxis,
                series,
                areaBounds);
            _points.add(Offset(currentLocation.x, currentLocation.y));
            if (prevPoint == null) {
              seriesRenderer._segmentPath!
                  .moveTo(currentLocation.x, currentLocation.y);
            } else if (seriesRenderer._dataPoints[pointIndex - 1].isVisible ==
                    false &&
                series.emptyPointSettings.mode == EmptyPointMode.gap) {
              seriesRenderer._segmentPath!
                  .moveTo(currentLocation.x, currentLocation.y);
            } else if (point.isGap != true &&
                seriesRenderer._dataPoints[pointIndex - 1].isGap != true &&
                seriesRenderer._dataPoints[pointIndex].isVisible == true) {
              seriesRenderer._segmentPath!
                  .lineTo(currentLocation.x, currentLocation.y);
            } else {
              seriesRenderer._segmentPath!
                  .moveTo(currentLocation.x, currentLocation.y);
            }
            prevPoint = point;
          }
          prevXValue = xVal;
          prevYValue = yVal;
        }
      }

      if (seriesRenderer._segmentPath != null) {
        seriesRenderer._dataPoints = dataPoints;
        seriesRenderer._drawSegment(
            canvas,
            seriesRenderer._createSegments(
                painterKey.index, chart, animationFactor, _points));
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
              animationFactor >= chartState._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The fast line series should be available to render a marker on it.');
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
  bool shouldRepaint(_FastLineChartPainter oldDelegate) => isRepaint;
}
