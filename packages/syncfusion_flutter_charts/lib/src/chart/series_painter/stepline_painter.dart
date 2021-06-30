part of charts;

class _StepLineChartPainter extends CustomPainter {
  _StepLineChartPainter(
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
  final StepLineSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for step line series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    final StepLineSeries<dynamic, dynamic> series =
        seriesRenderer._series as StepLineSeries<dynamic, dynamic>;
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRenderer._dataPoints;
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
          ((!(renderingDetails.widgetNeedUpdate ||
                      renderingDetails.isLegendToggled) ||
                  !chartState._oldSeriesKeys.contains(series.key)) &&
              series.animationDuration > 0)) {
        _performLinearAnimation(
            chartState, xAxisRenderer._axis, canvas, animationFactor);
      }
      int segmentIndex = -1;
      CartesianChartPoint<dynamic>? startPoint,
          endPoint,
          currentPoint,
          _nextPoint;
      num? midX, midY;

      if (seriesRenderer._visibleDataPoints == null ||
          seriesRenderer._visibleDataPoints!.isNotEmpty) {
        seriesRenderer._visibleDataPoints = <CartesianChartPoint<dynamic>>[];
      }

      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        currentPoint = dataPoints[pointIndex];
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
            midX = _nextPoint.xValue;
            midY = currentPoint.yValue;
          } else if (_nextPoint.isDrop) {
            _nextPoint = _getDropValue(dataPoints, pointIndex);
            midX = _nextPoint?.xValue;
            midY = currentPoint.yValue;
          }
        }
        seriesRenderer._calculateRegionData(
            chartState,
            seriesRenderer,
            seriesIndex,
            currentPoint,
            pointIndex,
            null,
            _nextPoint,
            midX,
            midY);
        if (startPoint != null &&
            endPoint != null &&
            midX != null &&
            midY != null) {
          seriesRenderer._drawSegment(
              canvas,
              seriesRenderer._createSegments(startPoint, midX, midY, endPoint,
                  segmentIndex += 1, seriesIndex, animationFactor));
          endPoint = startPoint = midX = midY = null;
        }
      }
      _drawSeries(canvas, animationFactor);
    }
  }

  ///Draw series elements and add cliprect
  void _drawSeries(Canvas canvas, double animationFactor) {
    final StepLineSeries<dynamic, dynamic> series =
        seriesRenderer._series as StepLineSeries<dynamic, dynamic>;
    final Rect clipRect = _calculatePlotOffset(
        Rect.fromLTRB(
            chartState._chartAxis._axisClipRect.left -
                series.markerSettings.width,
            chartState._chartAxis._axisClipRect.top -
                series.markerSettings.height,
            chartState._chartAxis._axisClipRect.right +
                series.markerSettings.width,
            chartState._chartAxis._axisClipRect.bottom +
                series.markerSettings.height),
        Offset(seriesRenderer._xAxisRenderer!._axis.plotOffset,
            seriesRenderer._yAxisRenderer!._axis.plotOffset));

    canvas.restore();
    if ((series.animationDuration <= 0 ||
            (!chartState._renderingDetails.initialRender! &&
                !seriesRenderer._needAnimateSeriesElements) ||
            animationFactor >= chartState._seriesDurationFactor) &&
        (series.markerSettings.isVisible ||
            series.dataLabelSettings.isVisible)) {
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'The step line series should be available to render a marker on it.');
      canvas.clipRect(clipRect);
      seriesRenderer._renderSeriesElements(
          chart, canvas, seriesRenderer._seriesElementAnimation);
    }
    if (seriesRenderer._visible! && animationFactor >= 1) {
      chartState._setPainterKey(painterKey.index, painterKey.name, true);
    }
  }

  /// To get point value in the drop mode
  CartesianChartPoint<dynamic>? _getDropValue(
      List<CartesianChartPoint<dynamic>> points, int pointIndex) {
    CartesianChartPoint<dynamic>? value;
    for (int i = pointIndex; i < points.length - 1; i++) {
      if (!points[i + 1].isDrop) {
        value = points[i + 1];
        break;
      }
    }
    return value;
  }

  @override
  bool shouldRepaint(_StepLineChartPainter oldDelegate) => isRepaint;
}
