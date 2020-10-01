part of charts;

class _RangeAreaChartPainter extends CustomPainter {
  _RangeAreaChartPainter(
      {this.chartState,
      this.seriesRenderer,
      this.isRepaint,
      this.animationController,
      this.painterKey,
      ValueNotifier<num> notifier})
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
    final RangeAreaSeries<dynamic, dynamic> series = seriesRenderer._series;
    Rect clipRect;
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer;
    final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRenderer._dataPoints;
    CartesianChartPoint<dynamic> point, prevPoint;
    final Path _path = Path();
    _ChartLocation currentPointLow, currentPointHigh;
    double animationFactor;
    final Path _borderPath = Path();
    RangeAreaSegment rangeAreaSegment;
    final List<Offset> _points = <Offset>[];
    if (seriesRenderer._visible) {
      assert(
          series.animationDuration != null
              ? series.animationDuration >= 0
              : true,
          'The animation duration of the range area series must be greater or equal to 0.');
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer._storeSeriesProperties(chartState, seriesIndex);
      final bool isTransposed = chartState._requireInvertedAxis;
      final Rect axisClipRect = _calculatePlotOffset(
          chartState._chartAxis._axisClipRect,
          Offset(
              xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesRenderer._seriesAnimation != null
          ? seriesRenderer._seriesAnimation.value
          : 1;
      if (seriesRenderer._reAnimate ||
          ((!(chartState._widgetNeedUpdate || chartState._isLegendToggled) ||
                  !chartState._oldSeriesKeys.contains(series.key)) &&
              series.animationDuration > 0)) {
        _performLinearAnimation(
            chartState, xAxisRenderer._axis, canvas, animationFactor);
      }
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer._calculateRegionData(
            chartState, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          currentPointLow = _calculatePoint(point.xValue, point.low,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          currentPointHigh = _calculatePoint(point.xValue, point.high,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          _points.add(Offset(currentPointLow.x, currentPointLow.y));
          _points.add(Offset(currentPointHigh.x, currentPointHigh.y));
          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            _path.moveTo(currentPointLow.x, currentPointLow.y);
            _path.lineTo(currentPointHigh.x, currentPointHigh.y);
            _borderPath.moveTo(currentPointHigh.x, currentPointHigh.y);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            _path.lineTo(currentPointHigh.x, currentPointHigh.y);
            _path.lineTo(currentPointLow.x, currentPointLow.y);
            _borderPath.lineTo(currentPointHigh.x, currentPointHigh.y);
            _borderPath.moveTo(currentPointLow.x, currentPointLow.y);
          } else {
            _borderPath.lineTo(currentPointHigh.x, currentPointHigh.y);
            _path.lineTo(currentPointHigh.x, currentPointHigh.y);
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
          currentPointLow = _calculatePoint(point.xValue, point.low,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);
          currentPointHigh = _calculatePoint(point.xValue, point.high,
              xAxisRenderer, yAxisRenderer, isTransposed, series, axisClipRect);

          if (dataPoints[pointIndex + 1].isGap == true) {
            _borderPath.moveTo(currentPointLow.x, currentPointLow.y);
            _path.moveTo(currentPointLow.x, currentPointLow.y);
          } else if (dataPoints[pointIndex].isGap != true) {
            if (pointIndex + 1 == dataPoints.length - 1 &&
                dataPoints[pointIndex + 1].isDrop) {
              _borderPath.moveTo(currentPointLow.x, currentPointLow.y);
            } else {
              _borderPath.lineTo(currentPointLow.x, currentPointLow.y);
            }
            _path.lineTo(currentPointLow.x, currentPointLow.y);
          }

          prevPoint = point;
        }
      }

      if (_path != null &&
          seriesRenderer._segments != null &&
          seriesRenderer._segments.isNotEmpty) {
        rangeAreaSegment = seriesRenderer._segments[0];
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
              !chartState._initialRender ||
              animationFactor >= chartState._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
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
