part of charts;

class _SplineAreaChartPainter extends CustomPainter {
  _SplineAreaChartPainter(
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
  final SplineAreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for spline area series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    CartesianChartPoint<dynamic>? prevPoint, point, oldChartPoint;
    CartesianSeriesRenderer? oldSeriesRenderer;
    _ChartLocation? currentPoint, originPoint, oldPointLocation;
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
    Rect clipRect;
    final SplineAreaSeries<dynamic, dynamic> series =
        seriesRenderer._series as SplineAreaSeries<dynamic, dynamic>;
    if (!seriesRenderer._hasDataLabelTemplate) {
      seriesRenderer._drawControlPoints.clear();
    }
    final Path _path = Path();
    final Path _strokePath = Path();
    final List<Offset> _points = <Offset>[];
    final num? crossesAt = _getCrossesAtValue(seriesRenderer, chartState);
    final num origin = crossesAt ?? 0;
    double? startControlX, startControlY, endControlX, endControlY;
    if (seriesRenderer._visible!) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      final List<CartesianSeriesRenderer> oldSeriesRenderers =
          chartState._oldSeriesRenderers;
      final List<CartesianChartPoint<dynamic>> dataPoints =
          seriesRenderer._dataPoints;
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer._storeSeriesProperties(chartState, seriesIndex);
      final bool isTransposed =
          seriesRenderer._chartState!._requireInvertedAxis;
      final Rect axisClipRect = _calculatePlotOffset(
          chartState._chartAxis._axisClipRect,
          Offset(
              xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesRenderer._seriesAnimation != null
          ? seriesRenderer._seriesAnimation!.value
          : 1;

      oldSeriesRenderer = _getOldSeriesRenderer(
          chartState, seriesRenderer, seriesIndex, oldSeriesRenderers);

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
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer._calculateRegionData(
            chartState, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          //Stores the old data point details of the corresponding point index
          oldChartPoint = _getOldChartPoint(
              chartState,
              seriesRenderer,
              SplineAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          oldPointLocation = oldChartPoint != null
              ? _calculatePoint(
                  oldChartPoint.xValue,
                  oldChartPoint.yValue,
                  oldSeriesRenderer!._xAxisRenderer!,
                  oldSeriesRenderer._yAxisRenderer!,
                  isTransposed,
                  oldSeriesRenderer._series,
                  axisClipRect)
              : null;
          currentPoint = _calculatePoint(point.xValue, point.yValue,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          originPoint = _calculatePoint(
              point.xValue,
              math_lib.max(yAxisRenderer._visibleRange!.minimum, origin),
              xAxisRenderer,
              yAxisRenderer,
              isTransposed,
              series,
              axisClipRect);
          double x = currentPoint.x;
          double y = currentPoint.y;
          startControlX = startControlY = endControlX = endControlY = null;
          _points.add(Offset(currentPoint.x, currentPoint.y));
          final bool closed =
              series.emptyPointSettings.mode == EmptyPointMode.drop &&
                  _getSeriesVisibility(dataPoints, pointIndex);

          //calculates animation values for control points and data points
          if (oldPointLocation != null) {
            isTransposed
                ? x = _getAnimateValue(animationFactor, x, oldPointLocation.x,
                    currentPoint.x, seriesRenderer)
                : y = _getAnimateValue(animationFactor, y, oldPointLocation.y,
                    currentPoint.y, seriesRenderer);
            if (point.startControl != null) {
              startControlY = _getAnimateValue(
                  animationFactor,
                  startControlY,
                  oldChartPoint!.startControl!.y,
                  point.startControl!.y,
                  seriesRenderer);
              startControlX = _getAnimateValue(
                  animationFactor,
                  startControlX,
                  oldChartPoint.startControl!.x,
                  point.startControl!.x,
                  seriesRenderer);
            }
            if (point.endControl != null) {
              endControlX = _getAnimateValue(
                  animationFactor,
                  endControlX,
                  oldChartPoint!.endControl!.x,
                  point.endControl!.x,
                  seriesRenderer);
              endControlY = _getAnimateValue(
                  animationFactor,
                  endControlY,
                  oldChartPoint.endControl!.y,
                  point.endControl!.y,
                  seriesRenderer);
            }
          } else {
            if (point.startControl != null) {
              startControlX = point.startControl!.x;
              startControlY = point.startControl!.y;
            }
            if (point.endControl != null) {
              endControlX = point.endControl!.x;
              endControlY = point.endControl!.y;
            }
          }

          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            _path.moveTo(originPoint.x, originPoint.y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom ||
                series.borderDrawMode == BorderDrawMode.all) {
              if (dataPoints[pointIndex].isGap != true) {
                _strokePath.moveTo(originPoint.x, originPoint.y);
                _strokePath.lineTo(x, y);
              }
            } else if (series.borderDrawMode == BorderDrawMode.top) {
              _strokePath.moveTo(x, y);
            }
            _path.lineTo(x, y);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            _strokePath.cubicTo(startControlX!, startControlY!, endControlX!,
                endControlY!, x, y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
              _strokePath.lineTo(originPoint.x, originPoint.y);
            } else if (series.borderDrawMode == BorderDrawMode.all) {
              _strokePath.lineTo(originPoint.x, originPoint.y);
              _strokePath.close();
            }
            _path.cubicTo(
                startControlX, startControlY, endControlX, endControlY, x, y);
            _path.lineTo(originPoint.x, originPoint.y);
          } else {
            _strokePath.cubicTo(startControlX!, startControlY!, endControlX!,
                endControlY!, x, y);
            _path.cubicTo(
                startControlX, startControlY, endControlX, endControlY, x, y);

            if (closed) {
              _path.cubicTo(startControlX, startControlY, endControlX,
                  endControlY, originPoint.x, originPoint.y);
              if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
                _strokePath.lineTo(originPoint.x, originPoint.y);
              } else if (series.borderDrawMode == BorderDrawMode.all) {
                _strokePath.cubicTo(startControlX, startControlY, endControlX,
                    endControlY, originPoint.x, originPoint.y);
                _strokePath.close();
              }
            }
          }
          prevPoint = point;
        }
      }
      // ignore: unnecessary_null_comparison
      if (_path != null) {
        seriesRenderer._drawSegment(
            canvas,
            seriesRenderer._createSegments(
                painterKey.index, chart, animationFactor, _path, _strokePath));
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
              !renderingDetails.initialRender! ||
              animationFactor >= chartState._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The spline area series should be available to render a marker on it.');
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
  bool shouldRepaint(_SplineAreaChartPainter oldDelegate) => isRepaint;

  /// It returns the visibility of area series
  bool _getSeriesVisibility(
      List<CartesianChartPoint<dynamic>> points, int index) {
    for (int i = index; i < points.length - 1; i++) {
      if (!points[i + 1].isDrop) {
        return false;
      }
    }
    return true;
  }
}
