part of charts;

class _BoxAndWhiskerPainter extends CustomPainter {
  _BoxAndWhiskerPainter(
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
  BoxAndWhiskerSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for box and whisker series
  @override
  void paint(Canvas canvas, Size size) {
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRenderer._dataPoints;
    assert(dataPoints.isNotEmpty,
        'The data points should be available to render the box and whisker series.');
    Rect clipRect;
    double animationFactor;
    final BoxAndWhiskerSeries<dynamic, dynamic> series =
        seriesRenderer._series as BoxAndWhiskerSeries<dynamic, dynamic>;
    CartesianChartPoint<dynamic>? point;
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
        assert(point.y != null,
            'The yValues of the box and whisker series should not be null.');
        (point.y).remove(null);
        (point.y).sort();
        seriesRenderer._findBoxPlotValues(point.y, point, series.boxPlotMode);
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
              seriesRenderer._createSegments(
                  point, segmentIndex += 1, painterKey.index, animationFactor));
        }
        if (point.outliers!.isNotEmpty) {
          final MarkerSettingsRenderer markerSettingsRenderer =
              MarkerSettingsRenderer(series.markerSettings);
          seriesRenderer._markerShapes = <Path?>[];
          point.outlierRegion = <Rect>[];
          point.outlierRegionPosition = <dynamic>[];
          for (int outlierIndex = 0;
              outlierIndex < point.outliers!.length;
              outlierIndex++) {
            point.outliersPoint.add(_calculatePoint(
                point.xValue,
                point.outliers![outlierIndex],
                seriesRenderer._xAxisRenderer!,
                seriesRenderer._yAxisRenderer!,
                seriesRenderer._chartState!._requireInvertedAxis,
                seriesRenderer._series,
                axisClipRect));
            _calculateOutlierRegion(point, point.outliersPoint[outlierIndex],
                series.markerSettings.width);
            point.outlierRegionPosition!.add(Offset(
                point.outliersPoint[outlierIndex].x,
                point.outliersPoint[outlierIndex].y));
            markerSettingsRenderer.renderMarker(
                seriesRenderer,
                point,
                seriesRenderer._seriesElementAnimation,
                canvas,
                pointIndex,
                outlierIndex);
          }
        }
        // ignore: unnecessary_null_comparison
        if (chart.tooltipBehavior != null && chart.tooltipBehavior.enable) {
          _calculateTooltipRegion(
              point, seriesIndex, seriesRenderer, chartState);
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
            'The box and whisker series should be available to render a data label on it.');
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
  bool shouldRepaint(_BoxAndWhiskerPainter oldDelegate) => isRepaint;
}
