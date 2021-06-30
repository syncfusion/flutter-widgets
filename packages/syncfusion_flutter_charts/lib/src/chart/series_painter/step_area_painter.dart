part of charts;

class _StepAreaChartPainter extends CustomPainter {
  _StepAreaChartPainter(
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
  final StepAreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for step area series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    CartesianChartPoint<dynamic>? prevPoint, point, oldChartPoint;
    _ChartLocation? currentPoint,
        originPoint,
        previousPoint,
        oldPoint,
        prevOldPoint;
    CartesianSeriesRenderer? oldSeriesRenderer;
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        chartState._oldSeriesRenderers;
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
    final StepAreaSeries<dynamic, dynamic> _series =
        seriesRenderer._series as StepAreaSeries<dynamic, dynamic>;
    final Path _path = Path(), _strokePath = Path();
    final List<Offset> _points = <Offset>[];
    final num? crossesAt = _getCrossesAtValue(seriesRenderer, chartState);
    final num origin = crossesAt ?? 0;

    /// Clip rect will be added for series.
    if (seriesRenderer._visible!) {
      assert(
          // ignore: unnecessary_null_comparison
          !(_series.animationDuration != null) ||
              _series.animationDuration >= 0,
          'The animation duration of the step area series must be greater or equal to 0.');
      canvas.save();
      final List<CartesianChartPoint<dynamic>> dataPoints =
          seriesRenderer._dataPoints;
      final int seriesIndex = painterKey.index;
      final StepAreaSeries<dynamic, dynamic> series =
          seriesRenderer._series as StepAreaSeries<dynamic, dynamic>;
      final Rect axisClipRect = _calculatePlotOffset(
          chartState._chartAxis._axisClipRect,
          Offset(seriesRenderer._xAxisRenderer!._axis.plotOffset,
              seriesRenderer._yAxisRenderer!._axis.plotOffset));
      canvas.clipRect(axisClipRect);

      oldSeriesRenderer = _getOldSeriesRenderer(
          chartState, seriesRenderer, seriesIndex, oldSeriesRenderers);

      seriesRenderer._storeSeriesProperties(chartState, seriesIndex);
      animationFactor = seriesRenderer._seriesAnimation != null
          ? seriesRenderer._seriesAnimation!.value
          : 1;
      if (seriesRenderer._reAnimate ||
          ((!(renderingDetails.widgetNeedUpdate ||
                      renderingDetails.isLegendToggled) ||
                  !chartState._oldSeriesKeys
                      .contains(seriesRenderer._series.key)) &&
              seriesRenderer._series.animationDuration > 0)) {
        _performLinearAnimation(chartState,
            seriesRenderer._xAxisRenderer!._axis, canvas, animationFactor);
      }

      if (seriesRenderer._visibleDataPoints == null ||
          seriesRenderer._visibleDataPoints!.isNotEmpty) {
        seriesRenderer._visibleDataPoints = <CartesianChartPoint<dynamic>>[];
      }
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer._calculateRegionData(
            chartState, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible) {
          oldChartPoint = _getOldChartPoint(
              chartState,
              seriesRenderer,
              StepAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          oldPoint = oldChartPoint != null
              ? _calculatePoint(
                  oldChartPoint.xValue,
                  oldChartPoint.yValue,
                  oldSeriesRenderer!._xAxisRenderer!,
                  oldSeriesRenderer._yAxisRenderer!,
                  chart.isTransposed,
                  oldSeriesRenderer._series,
                  axisClipRect)
              : null;
          currentPoint = _calculatePoint(
              point.xValue,
              point.yValue,
              xAxisRenderer,
              yAxisRenderer,
              seriesRenderer._chartState!._requireInvertedAxis,
              series,
              axisClipRect);
          previousPoint = prevPoint != null
              ? _calculatePoint(
                  prevPoint.xValue,
                  prevPoint.yValue,
                  xAxisRenderer,
                  yAxisRenderer,
                  seriesRenderer._chartState!._requireInvertedAxis,
                  series,
                  axisClipRect)
              : null;
          originPoint = _calculatePoint(
              point.xValue,
              math_lib.max(yAxisRenderer._visibleRange!.minimum, origin),
              xAxisRenderer,
              yAxisRenderer,
              seriesRenderer._chartState!._requireInvertedAxis,
              series,
              axisClipRect);
          _points.add(Offset(currentPoint.x, currentPoint.y));
          _drawStepAreaPath(
              _path,
              _strokePath,
              prevPoint,
              currentPoint,
              originPoint,
              previousPoint,
              oldPoint,
              prevOldPoint,
              pointIndex,
              animationFactor,
              _series);
          prevPoint = point;
          prevOldPoint = oldPoint;
        }
      }
      // ignore: unnecessary_null_comparison
      if (_path != null && _strokePath != null) {
        seriesRenderer._drawSegment(
            canvas,
            seriesRenderer._createSegments(_path, _strokePath, painterKey.index,
                animationFactor, _points));
      }
      _drawSeries(canvas, animationFactor);
    }
  }

  ///Draw series elements and add cliprect
  void _drawSeries(Canvas canvas, double animationFactor) {
    final StepAreaSeries<dynamic, dynamic> series =
        seriesRenderer._series as StepAreaSeries<dynamic, dynamic>;
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
            !chartState._renderingDetails.initialRender! ||
            animationFactor >= chartState._seriesDurationFactor) &&
        (series.markerSettings.isVisible ||
            series.dataLabelSettings.isVisible)) {
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'The step area series should be available to render a marker on it.');
      canvas.clipRect(clipRect);
      seriesRenderer._renderSeriesElements(
          chart, canvas, seriesRenderer._seriesElementAnimation);
    }
    if (animationFactor >= 1) {
      chartState._setPainterKey(painterKey.index, painterKey.name, true);
    }
  }

  @override
  bool shouldRepaint(_StepAreaChartPainter oldDelegate) => isRepaint;

  /// To draw the step area path
  void _drawStepAreaPath(
      Path _path,
      Path _strokePath,
      CartesianChartPoint<dynamic>? prevPoint,
      _ChartLocation currentPoint,
      _ChartLocation originPoint,
      _ChartLocation? previousPoint,
      _ChartLocation? oldPoint,
      _ChartLocation? prevOldPoint,
      int pointIndex,
      double animationFactor,
      StepAreaSeries<dynamic, dynamic> stepAreaSeries) {
    double x = currentPoint.x;
    double y = currentPoint.y;
    double? previousPointY = previousPoint?.y;
    final bool closed =
        stepAreaSeries.emptyPointSettings.mode == EmptyPointMode.drop &&
            _getSeriesVisibility(seriesRenderer._dataPoints, pointIndex);
    if (oldPoint != null) {
      if (chartState._chart.isTransposed) {
        x = _getAnimateValue(
            animationFactor, x, oldPoint.x, currentPoint.x, seriesRenderer);
      } else {
        y = _getAnimateValue(
            animationFactor, y, oldPoint.y, currentPoint.y, seriesRenderer);
        previousPointY = previousPointY != null
            ? _getAnimateValue(animationFactor, previousPointY, prevOldPoint?.y,
                previousPoint?.y, seriesRenderer)
            : previousPointY;
      }
    }
    if (prevPoint == null ||
        seriesRenderer._dataPoints[pointIndex - 1].isGap == true ||
        (seriesRenderer._dataPoints[pointIndex].isGap == true) ||
        (seriesRenderer._dataPoints[pointIndex - 1].isVisible == false &&
            stepAreaSeries.emptyPointSettings.mode == EmptyPointMode.gap)) {
      _path.moveTo(originPoint.x, originPoint.y);
      if (stepAreaSeries.borderDrawMode == BorderDrawMode.excludeBottom) {
        if (seriesRenderer._dataPoints[pointIndex].isGap != true) {
          _strokePath.moveTo(originPoint.x, originPoint.y);
          _strokePath.lineTo(x, y);
        }
      } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.all) {
        if (seriesRenderer._dataPoints[pointIndex].isGap != true) {
          _strokePath.moveTo(originPoint.x, originPoint.y);
          _strokePath.lineTo(x, y);
        }
      } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.top) {
        _strokePath.moveTo(x, y);
      }
      _path.lineTo(x, y);
    } else if (pointIndex == seriesRenderer._dataPoints.length - 1 ||
        seriesRenderer._dataPoints[pointIndex + 1].isGap == true) {
      _strokePath.lineTo(x, previousPointY!);
      _strokePath.lineTo(x, y);
      if (stepAreaSeries.borderDrawMode == BorderDrawMode.excludeBottom) {
        _strokePath.lineTo(originPoint.x, originPoint.y);
      } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.all) {
        _strokePath.lineTo(originPoint.x, originPoint.y);
        _strokePath.close();
      }
      _path.lineTo(x, previousPointY);
      _path.lineTo(x, y);
      _path.lineTo(originPoint.x, originPoint.y);
    } else {
      _path.lineTo(x, previousPointY!);
      _strokePath.lineTo(x, previousPointY);
      _strokePath.lineTo(x, y);
      _path.lineTo(x, y);
      if (closed) {
        _path.lineTo(originPoint.x, originPoint.y);
        if (stepAreaSeries.borderDrawMode == BorderDrawMode.excludeBottom) {
          _strokePath.lineTo(originPoint.x, originPoint.y);
        } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.all) {
          _strokePath.lineTo(originPoint.x, originPoint.y);
          _strokePath.close();
        }
      }
    }
  }

  /// To find the visibility of a series
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
