part of charts;

class _RangeAreaChartPainter extends CustomPainter {
  _RangeAreaChartPainter(
      {required this.chartState,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required this.painterKey,
      required ValueNotifier<num> notifier})
      : chart = chartState._chart,
        super(repaint: notifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  final bool isRepaint;
  final Animation<double> animationController;
  final RangeAreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for range area series
  @override
  void paint(Canvas canvas, Size size) {
    final RangeAreaSeries<dynamic, dynamic> series =
        seriesRenderer._series as RangeAreaSeries<dynamic, dynamic>;
    Rect clipRect;
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
    CartesianSeriesRenderer? oldSeriesRenderer;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRenderer._dataPoints;
    CartesianChartPoint<dynamic>? point, prevPoint, oldPoint;
    final Path _path = Path();
    _ChartLocation? currentPointLow,
        currentPointHigh,
        oldPointLow,
        oldPointHigh;
    double currentLowX, currentLowY, currentHighX, currentHighY;
    double animationFactor;
    final Path _borderPath = Path();
    RangeAreaSegment rangeAreaSegment;
    final List<Offset> _points = <Offset>[];
    if (seriesRenderer._visible!) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      final List<CartesianSeriesRenderer> oldSeriesRenderers =
          chartState._oldSeriesRenderers;
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer._storeSeriesProperties(chartState, seriesIndex);
      final bool isTransposed = chartState._requireInvertedAxis;
      final Rect axisClipRect = _calculatePlotOffset(
          chartState._chartAxis._axisClipRect,
          Offset(
              xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));
      canvas.clipRect(axisClipRect);

      oldSeriesRenderer = _getOldSeriesRenderer(
          chartState, seriesRenderer, seriesIndex, oldSeriesRenderers);

      animationFactor = seriesRenderer._seriesAnimation != null
          ? seriesRenderer._seriesAnimation!.value
          : 1;
      if (seriesRenderer._reAnimate ||
          ((!(renderingDetails.widgetNeedUpdate ||
                      renderingDetails.isLegendToggled) ||
                  !chartState._oldSeriesKeys.contains(series.key)) &&
              series.animationDuration > 0)) {
        _performLinearAnimation(
            chartState, xAxisRenderer._axis, canvas, animationFactor);
      }
      if (seriesRenderer._visibleDataPoints == null ||
          seriesRenderer._visibleDataPoints!.isNotEmpty) {
        seriesRenderer._visibleDataPoints = <CartesianChartPoint<dynamic>>[];
      }
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer._calculateRegionData(
            chartState, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          oldPoint = _getOldChartPoint(
              chartState,
              seriesRenderer,
              RangeAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          if (oldPoint != null) {
            oldPointLow = _calculatePoint(
                oldPoint.xValue,
                oldPoint.low,
                oldSeriesRenderer!._xAxisRenderer!,
                oldSeriesRenderer._yAxisRenderer!,
                isTransposed,
                oldSeriesRenderer._series,
                axisClipRect);
            oldPointHigh = _calculatePoint(
                oldPoint.xValue,
                oldPoint.high,
                oldSeriesRenderer._xAxisRenderer!,
                oldSeriesRenderer._yAxisRenderer!,
                isTransposed,
                oldSeriesRenderer._series,
                axisClipRect);
          } else {
            oldPointLow = oldPointHigh = null;
          }
          currentPointLow = _calculatePoint(point.xValue, point.low,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          currentPointHigh = _calculatePoint(point.xValue, point.high,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          _points.add(Offset(currentPointLow.x, currentPointLow.y));
          _points.add(Offset(currentPointHigh.x, currentPointHigh.y));

          currentLowX = currentPointLow.x;
          currentLowY = currentPointLow.y;
          currentHighX = currentPointHigh.x;
          currentHighY = currentPointHigh.y;
          if (oldPointLow != null) {
            if (chart.isTransposed) {
              currentLowX = _getAnimateValue(animationFactor, currentLowX,
                  oldPointLow.x, currentPointLow.x, seriesRenderer);
            } else {
              currentLowY = _getAnimateValue(animationFactor, currentLowY,
                  oldPointLow.y, currentPointLow.y, seriesRenderer);
            }
          }
          if (oldPointHigh != null) {
            if (chart.isTransposed) {
              currentHighX = _getAnimateValue(animationFactor, currentHighX,
                  oldPointHigh.x, currentPointHigh.x, seriesRenderer);
            } else {
              currentHighY = _getAnimateValue(animationFactor, currentHighY,
                  oldPointHigh.y, currentPointHigh.y, seriesRenderer);
            }
          }
          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            _path.moveTo(currentLowX, currentLowY);
            _path.lineTo(currentHighX, currentHighY);
            _borderPath.moveTo(currentHighX, currentHighY);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            _path.lineTo(currentHighX, currentHighY);
            _path.lineTo(currentLowX, currentLowY);
            _borderPath.lineTo(currentHighX, currentHighY);
            _borderPath.moveTo(currentLowX, currentLowY);
          } else {
            _borderPath.lineTo(currentHighX, currentHighY);
            _path.lineTo(currentHighX, currentHighY);
          }
          prevPoint = point;
        }
        if (pointIndex >= dataPoints.length - 1) {
          seriesRenderer._createSegments(
              painterKey.index, chart, animationFactor, _points);
        }
      }
      for (int pointIndex = dataPoints.length - 2;
          pointIndex >= 0;
          pointIndex--) {
        point = dataPoints[pointIndex];
        if (point.isVisible && !point.isDrop) {
          oldPoint = _getOldChartPoint(
              chartState,
              seriesRenderer,
              RangeAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          if (oldPoint != null) {
            oldPointLow = _calculatePoint(
                oldPoint.xValue,
                oldPoint.low,
                oldSeriesRenderer!._xAxisRenderer!,
                oldSeriesRenderer._yAxisRenderer!,
                isTransposed,
                oldSeriesRenderer._series,
                axisClipRect);
            oldPointHigh = _calculatePoint(
                oldPoint.xValue,
                oldPoint.high,
                oldSeriesRenderer._xAxisRenderer!,
                oldSeriesRenderer._yAxisRenderer!,
                isTransposed,
                oldSeriesRenderer._series,
                axisClipRect);
          } else {
            oldPointLow = oldPointHigh = null;
          }
          currentPointLow = _calculatePoint(point.xValue, point.low,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          currentPointHigh = _calculatePoint(point.xValue, point.high,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);

          currentLowX = currentPointLow.x;
          currentLowY = currentPointLow.y;
          currentHighX = currentPointHigh.x;
          currentHighY = currentPointHigh.y;

          if (oldPointLow != null) {
            if (chart.isTransposed) {
              currentLowX = _getAnimateValue(animationFactor, currentLowX,
                  oldPointLow.x, currentPointLow.x, seriesRenderer);
            } else {
              currentLowY = _getAnimateValue(animationFactor, currentLowY,
                  oldPointLow.y, currentPointLow.y, seriesRenderer);
            }
          }
          if (oldPointHigh != null) {
            if (chart.isTransposed) {
              currentHighX = _getAnimateValue(animationFactor, currentHighX,
                  oldPointHigh.x, currentPointHigh.x, seriesRenderer);
            } else {
              currentHighY = _getAnimateValue(animationFactor, currentHighY,
                  oldPointHigh.y, currentPointHigh.y, seriesRenderer);
            }
          }
          if (dataPoints[pointIndex + 1].isGap == true) {
            _borderPath.moveTo(currentLowX, currentLowY);
            _path.moveTo(currentLowX, currentLowY);
          } else if (dataPoints[pointIndex].isGap != true) {
            if (pointIndex + 1 == dataPoints.length - 1 &&
                dataPoints[pointIndex + 1].isDrop) {
              _borderPath.moveTo(currentLowX, currentLowY);
            } else {
              _borderPath.lineTo(currentLowX, currentLowY);
            }
            _path.lineTo(currentLowX, currentLowY);
          }

          prevPoint = point;
        }
      }
      // ignore: unnecessary_null_comparison
      if (_path != null &&
          // ignore: unnecessary_null_comparison
          seriesRenderer._segments != null &&
          seriesRenderer._segments.isNotEmpty) {
        rangeAreaSegment = seriesRenderer._segments[0] as RangeAreaSegment;
        seriesRenderer._drawSegment(
            canvas,
            rangeAreaSegment
              .._path = _path
              .._borderPath = _borderPath);
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
              !renderingDetails.initialRender! ||
              animationFactor >= chartState._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The range area series should be available to render a marker on it.');
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
  bool shouldRepaint(_RangeAreaChartPainter oldDelegate) => isRepaint;
}
