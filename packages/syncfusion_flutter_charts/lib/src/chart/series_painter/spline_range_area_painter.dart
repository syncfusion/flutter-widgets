part of charts;

class _SplineRangeAreaChartPainter extends CustomPainter {
  _SplineRangeAreaChartPainter(
      {required this.chartState,
      required this.isRepaint,
      required this.animationController,
      required ValueNotifier<num> notifier,
      required this.painterKey,
      required this.seriesRenderer})
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
    _ChartLocation? currentPointLow,
        currentPointHigh,
        oldPointLow,
        oldPointHigh;
    final int pointsLength = seriesRenderer._dataPoints.length;
    CartesianChartPoint<dynamic>? prevPoint, point, oldChartPoint;
    final Path _path = Path();
    final Path _strokePath = Path();
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRenderer._dataPoints;
    CartesianSeriesRenderer? oldSeriesRenderer;
    final List<Offset> _points = <Offset>[];
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        chartState._oldSeriesRenderers;
    double? currentPointLowX,
        currentPointLowY,
        currentPointHighX,
        currentPointHighY,
        startControlX,
        startControlY,
        endControlX,
        endControlY;
    seriesRenderer._drawHighControlPoints.clear();
    seriesRenderer._drawLowControlPoints.clear();

    /// Clip rect will be added for series.
    if (seriesRenderer._visible!) {
      canvas.save();
      final int seriesIndex = painterKey.index;

      oldSeriesRenderer = _getOldSeriesRenderer(
          chartState, seriesRenderer, seriesIndex, oldSeriesRenderers);

      seriesRenderer._storeSeriesProperties(chartState, seriesIndex);
      final bool isTransposed = chartState._requireInvertedAxis;
      final SplineRangeAreaSeries<dynamic, dynamic> series =
          seriesRenderer._series as SplineRangeAreaSeries<dynamic, dynamic>;
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      SplineRangeAreaSegment splineRangeAreaSegment;
      final Rect axisClipRect = _calculatePlotOffset(
          chartState._chartAxis._axisClipRect,
          Offset(
              xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));
      canvas.clipRect(axisClipRect);
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
      if (!seriesRenderer._hasDataLabelTemplate) {
        _calculateSplineAreaControlPoints(seriesRenderer);
      }

      if (seriesRenderer._visibleDataPoints == null ||
          seriesRenderer._visibleDataPoints!.isNotEmpty) {
        seriesRenderer._visibleDataPoints = <CartesianChartPoint<dynamic>>[];
      }
      for (int pointIndex = 0; pointIndex < pointsLength; pointIndex++) {
        point = seriesRenderer._dataPoints[pointIndex];
        seriesRenderer._calculateRegionData(
            chartState, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          oldChartPoint = _getOldChartPoint(
              chartState,
              seriesRenderer,
              SplineRangeAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);

          oldPointHigh = (oldChartPoint != null)
              ? _calculatePoint(
                  oldChartPoint.xValue,
                  oldChartPoint.high,
                  oldSeriesRenderer!._xAxisRenderer!,
                  oldSeriesRenderer._yAxisRenderer!,
                  isTransposed,
                  series,
                  axisClipRect)
              : null;
          currentPointLow = _calculatePoint(point.xValue, point.low,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          currentPointHigh = _calculatePoint(point.xValue, point.high,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          _points.add(Offset(currentPointLow.x, currentPointLow.y));
          _points.add(Offset(currentPointHigh.x, currentPointHigh.y));

          currentPointLowX = currentPointLow.x;
          currentPointLowY = currentPointLow.y;

          if (oldPointHigh != null) {
            if (isTransposed) {
              currentPointHighX = _getAnimateValue(
                  animationFactor,
                  currentPointHighX,
                  oldPointHigh.x,
                  currentPointHigh.x,
                  seriesRenderer);
              currentPointHighY = currentPointHigh.y;
            } else {
              currentPointHighX = currentPointHigh.x;
              currentPointHighY = _getAnimateValue(
                  animationFactor,
                  currentPointHighY,
                  oldPointHigh.y,
                  currentPointHigh.y,
                  seriesRenderer);
            }
            if (point.highStartControl != null) {
              startControlX = _getAnimateValue(
                  animationFactor,
                  startControlX,
                  oldChartPoint!.highStartControl!.x,
                  point.highStartControl!.x,
                  seriesRenderer);
              startControlY = _getAnimateValue(
                  animationFactor,
                  startControlY,
                  oldChartPoint.highStartControl!.y,
                  point.highStartControl!.y,
                  seriesRenderer);
            } else {
              startControlX = startControlY = null;
            }
            if (point.highEndControl != null) {
              endControlX = _getAnimateValue(
                  animationFactor,
                  endControlX,
                  oldChartPoint!.highEndControl!.x,
                  point.highEndControl!.x,
                  seriesRenderer);
              endControlY = _getAnimateValue(
                  animationFactor,
                  endControlY,
                  oldChartPoint.highEndControl!.y,
                  point.highEndControl!.y,
                  seriesRenderer);
            } else {
              endControlX = endControlY = null;
            }
          } else {
            currentPointHighX = currentPointHigh.x;
            currentPointHighY = currentPointHigh.y;
            startControlX = point.highStartControl?.x;
            startControlY = point.highStartControl?.y;
            endControlX = point.highEndControl?.x;
            endControlY = point.highEndControl?.y;
          }
          // if (pointIndex == 3) print('$startControlX -- $startControlY,,,,$endControlX -- $endControlY');
          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            _path.moveTo(currentPointLowX, currentPointLowY);
            _path.lineTo(currentPointHighX, currentPointHighY);
            _strokePath.moveTo(currentPointHighX, currentPointHighY);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            _path.cubicTo(startControlX!, startControlY!, endControlX!,
                endControlY!, currentPointHighX, currentPointHighY);

            _strokePath.cubicTo(startControlX, startControlY, endControlX,
                endControlY, currentPointHighX, currentPointHighY);

            _path.lineTo(currentPointLowX, currentPointLowY);

            _strokePath.lineTo(currentPointHighX, currentPointHighY);
            _strokePath.moveTo(currentPointLowX, currentPointLowY);
          } else {
            _path.cubicTo(startControlX!, startControlY!, endControlX!,
                endControlY!, currentPointHighX, currentPointHighY);

            _strokePath.cubicTo(startControlX, startControlY, endControlX,
                endControlY, currentPointHighX, currentPointHighY);
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
          oldChartPoint = _getOldChartPoint(
              chartState,
              seriesRenderer,
              SplineRangeAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          if (oldChartPoint != null) {
            oldPointLow = _calculatePoint(
                oldChartPoint.xValue,
                oldChartPoint.low,
                oldSeriesRenderer!._xAxisRenderer!,
                oldSeriesRenderer._yAxisRenderer!,
                isTransposed,
                series,
                axisClipRect);
          } else {
            oldPointLow = null;
          }
          currentPointLow = _calculatePoint(point.xValue, point.low,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          currentPointHigh = _calculatePoint(point.xValue, point.high,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);

          if (oldPointLow != null) {
            if (isTransposed) {
              currentPointLowX = _getAnimateValue(
                  animationFactor,
                  currentPointLowX,
                  oldPointLow.x,
                  currentPointLow.x,
                  seriesRenderer);
              currentPointLowY = currentPointLow.y;
            } else {
              currentPointLowX = currentPointLow.x;
              currentPointLowY = _getAnimateValue(
                  animationFactor,
                  currentPointLowY,
                  oldPointLow.y,
                  currentPointLow.y,
                  seriesRenderer);
            }
            if (point.lowStartControl != null) {
              startControlX = _getAnimateValue(
                  animationFactor,
                  startControlX,
                  oldChartPoint!.lowStartControl!.x,
                  point.lowStartControl!.x,
                  seriesRenderer);
              startControlY = _getAnimateValue(
                  animationFactor,
                  startControlY,
                  oldChartPoint.lowStartControl!.y,
                  point.lowStartControl!.y,
                  seriesRenderer);
            } else {
              startControlX = startControlY = null;
            }
            if (point.lowEndControl != null) {
              endControlX = _getAnimateValue(
                  animationFactor,
                  endControlX,
                  oldChartPoint!.lowEndControl!.x,
                  point.lowEndControl!.x,
                  seriesRenderer);
              endControlY = _getAnimateValue(
                  animationFactor,
                  endControlY,
                  oldChartPoint.lowEndControl!.y,
                  point.lowEndControl!.y,
                  seriesRenderer);
            } else {
              endControlX = endControlY = null;
            }
          } else {
            currentPointLowX = currentPointLow.x;
            currentPointLowY = currentPointLow.y;
            startControlX = point.lowStartControl?.x;
            startControlY = point.lowStartControl?.y;
            endControlX = point.lowEndControl?.x;
            endControlY = point.lowEndControl?.y;
          }

          if (dataPoints[pointIndex + 1].isGap == true) {
            _strokePath.moveTo(currentPointLowX, currentPointLowY);
            _path.moveTo(currentPointLowX, currentPointLowY);
          } else if (dataPoints[pointIndex].isGap != true) {
            (pointIndex + 1 == dataPoints.length - 1 &&
                    dataPoints[pointIndex + 1].isDrop)
                ? _strokePath.moveTo(currentPointLowX, currentPointLowY)
                : _strokePath.cubicTo(
                    endControlX!,
                    endControlY!,
                    startControlX!,
                    startControlY!,
                    currentPointLowX,
                    currentPointLowY);

            _path.cubicTo(endControlX!, endControlY!, startControlX!,
                startControlY!, currentPointLowX, currentPointLowY);
          }
        }
      }

      /// Draw the spline range area series
      // ignore: unnecessary_null_comparison
      if (_path != null &&
          // ignore: unnecessary_null_comparison
          seriesRenderer._segments != null &&
          seriesRenderer._segments.isNotEmpty) {
        splineRangeAreaSegment =
            seriesRenderer._segments[0] as SplineRangeAreaSegment;
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
              (!renderingDetails.initialRender! &&
                  !seriesRenderer._needAnimateSeriesElements) ||
              animationFactor >= chartState._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
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
