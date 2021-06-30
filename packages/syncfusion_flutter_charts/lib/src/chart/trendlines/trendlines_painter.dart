part of charts;

class _TrendlinePainter extends CustomPainter {
  _TrendlinePainter(
      {required this.chartState,
      required this.trendlineAnimations,
      required ValueNotifier<num> notifier})
      : super(repaint: notifier);
  final SfCartesianChartState chartState;
  final Map<String, Animation<double>> trendlineAnimations;

  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    Animation<double>? trendlineAnimation;
    for (int i = 0;
        i < chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final CartesianSeriesRenderer seriesRenderer =
          chartState._chartSeries.visibleSeriesRenderers[i];
      final _RenderingDetails renderingDetails = chartState._renderingDetails;
      final XyDataSeries<dynamic, dynamic> series =
          seriesRenderer._series as XyDataSeries<dynamic, dynamic>;
      TrendlineRenderer trendlineRenderer;
      Trendline trendline;
      List<Offset> controlPoints;
      if (series.trendlines != null) {
        for (int j = 0; j < series.trendlines!.length; j++) {
          trendline = series.trendlines![j];
          trendlineRenderer = seriesRenderer._trendlineRenderer[j];
          assert(trendline.width >= 0,
              'The width of the trendlines must be greater or equal to 0.');
          assert(trendline.animationDuration >= 0,
              'The animation duration time for trendlines should be greater than or equal to 0.');
          trendlineAnimation = trendlineAnimations['$i-$j'];
          if (trendlineRenderer._isNeedRender &&
              trendline.isVisible &&
              trendlineRenderer._pointsData != null &&
              trendlineRenderer._pointsData!.isNotEmpty) {
            canvas.save();
            animationFactor = (renderingDetails.isLegendToggled &&
                        (seriesRenderer._oldSeries == null)) &&
                    trendlineAnimation != null
                ? trendlineAnimation.value
                : 1;
            final Rect axisClipRect = _calculatePlotOffset(
                chartState._chartAxis._axisClipRect,
                Offset(seriesRenderer._xAxisRenderer!._axis.plotOffset,
                    seriesRenderer._yAxisRenderer!._axis.plotOffset));
            canvas.clipRect(axisClipRect);
            final Path path = Path();
            final Paint paint = Paint();
            paint.strokeWidth = trendline.width;
            if (seriesRenderer._reAnimate ||
                (trendline.animationDuration > 0 &&
                    seriesRenderer._oldSeries == null)) {
              _performLinearAnimation(
                  chartState,
                  seriesRenderer._xAxisRenderer!._axis,
                  canvas,
                  animationFactor);
            }
            renderTrendlineEvent(
                chartState._chart,
                trendline,
                series.trendlines!.indexOf(trendline),
                chartState._chartSeries.visibleSeriesRenderers
                    .indexOf(seriesRenderer),
                seriesRenderer._seriesName!);
            paint.color = trendlineRenderer._fillColor
                .withOpacity(trendlineRenderer._opacity);
            paint.style = PaintingStyle.stroke;
            if (trendline.type == TrendlineType.linear) {
              path.moveTo(trendlineRenderer._points[0].dx,
                  trendlineRenderer._points[0].dy);
              path.lineTo(trendlineRenderer._points[1].dx,
                  trendlineRenderer._points[1].dy);
            } else if (trendline.type == TrendlineType.exponential ||
                trendline.type == TrendlineType.power ||
                trendline.type == TrendlineType.logarithmic) {
              path.moveTo(trendlineRenderer._points[0].dx,
                  trendlineRenderer._points[0].dy);
              for (int i = 0; i < trendlineRenderer._points.length - 1; i++) {
                controlPoints = trendlineRenderer._getControlPoints(
                    trendlineRenderer._points, i);
                path.cubicTo(
                    controlPoints[0].dx,
                    controlPoints[0].dy,
                    controlPoints[1].dx,
                    controlPoints[1].dy,
                    trendlineRenderer._points[i + 1].dx,
                    trendlineRenderer._points[i + 1].dy);
              }
            } else if (trendline.type == TrendlineType.polynomial &&
                trendlineRenderer._pointsData != null &&
                trendlineRenderer._pointsData!.isNotEmpty) {
              final List<Offset> polynomialPoints =
                  trendlineRenderer.getPolynomialCurve(
                      trendlineRenderer._pointsData!,
                      seriesRenderer,
                      chartState);
              path.moveTo(polynomialPoints[0].dx, polynomialPoints[0].dy);
              for (int i = 1; i < polynomialPoints.length; i++) {
                path.lineTo(polynomialPoints[i].dx, polynomialPoints[i].dy);
              }
            } else if (trendline.type == TrendlineType.movingAverage) {
              path.moveTo(trendlineRenderer._points[0].dx,
                  trendlineRenderer._points[0].dy);
              for (int i = 1; i < trendlineRenderer._points.length; i++) {
                path.lineTo(trendlineRenderer._points[i].dx,
                    trendlineRenderer._points[i].dy);
              }
            }
            _drawTrendlineMarker(trendlineRenderer, trendline, seriesRenderer,
                animationFactor, canvas, path, paint);
          }
        }
      }
    }
  }

  ///To draw the marker on trendline
  void _drawTrendlineMarker(
    TrendlineRenderer trendlineRenderer,
    Trendline trendline,
    CartesianSeriesRenderer seriesRenderer,
    double animationFactor,
    Canvas canvas,
    Path path,
    Paint paint,
  ) {
    Rect clipRect;
    final Rect _axisClipRect = chartState._chartAxis._axisClipRect;
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
    (trendlineRenderer._dashArray != null)
        ? _drawDashedLine(canvas, trendlineRenderer._dashArray!, paint, path)
        : canvas.drawPath(path, paint);
    clipRect = _calculatePlotOffset(
        Rect.fromLTRB(
            _axisClipRect.left - trendline.markerSettings.width,
            _axisClipRect.top - trendline.markerSettings.height,
            _axisClipRect.right + trendline.markerSettings.width,
            _axisClipRect.bottom + trendline.markerSettings.height),
        Offset(seriesRenderer._xAxisRenderer!._axis.plotOffset,
            seriesRenderer._yAxisRenderer!._axis.plotOffset));
    canvas.restore();
    if (trendlineRenderer._visible &&
        (animationFactor > chartState._trendlineDurationFactor)) {
      canvas.clipRect(clipRect);

      if (trendline.markerSettings.isVisible) {
        for (final CartesianChartPoint<dynamic> point
            in trendlineRenderer._pointsData!) {
          if (point.isVisible && point.isGap != true) {
            if (trendline.markerSettings.shape == DataMarkerType.image) {
              _drawImageMarker(seriesRenderer, canvas, point.markerPoint!.x,
                  point.markerPoint!.y);
            }
            final Paint strokePaint = Paint()
              ..color = trendline.markerSettings.borderWidth == 0
                  ? Colors.transparent
                  : trendline.markerSettings.borderColor ??
                      trendlineRenderer._fillColor
              ..strokeWidth = trendline.markerSettings.borderWidth
              ..style = PaintingStyle.stroke;

            final Paint fillPaint = Paint()
              ..color = trendline.markerSettings.color ??
                  (renderingDetails.chartTheme.brightness == Brightness.light
                      ? Colors.white
                      : Colors.black)
              ..style = PaintingStyle.fill;
            final int index = trendlineRenderer._pointsData!.indexOf(point);
            canvas.drawPath(
                trendlineRenderer._markerShapes[index], strokePaint);
            canvas.drawPath(trendlineRenderer._markerShapes[index], fillPaint);
          }
        }
      }
    }
  }

  /// Setting the values of render trend line event
  void renderTrendlineEvent(SfCartesianChart chart, Trendline trendline,
      int trendlineIndex, int seriesIndex, String seriesName) {
    TrendlineRenderArgs args;
    final TrendlineRenderer trendlineRenderer = chartState._chartSeries
        .visibleSeriesRenderers[seriesIndex]._trendlineRenderer[trendlineIndex];
    if (chart.onTrendlineRender != null &&
        !trendlineRenderer._isTrendlineRenderEvent) {
      trendlineRenderer._isTrendlineRenderEvent = true;
      args = TrendlineRenderArgs(
          trendline.intercept,
          trendlineIndex,
          seriesIndex,
          trendlineRenderer._name!,
          seriesName,
          trendlineRenderer._pointsData!);
      args.color = trendlineRenderer._fillColor;
      args.opacity = trendlineRenderer._opacity;
      args.dashArray = trendlineRenderer._dashArray;
      chart.onTrendlineRender!(args);
      trendlineRenderer._fillColor = args.color;
      trendlineRenderer._opacity = args.opacity;
      trendlineRenderer._dashArray = args.dashArray;
    }
  }

  @override
  bool shouldRepaint(_TrendlinePainter oldDelegate) => true;
}
