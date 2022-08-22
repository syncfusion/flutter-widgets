import 'package:flutter/material.dart';
import '../../common/event_args.dart';
import '../../common/rendering_details.dart';
import '../base/chart_base.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../trendlines/trendlines.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

export 'package:syncfusion_flutter_core/core.dart'
    show DataMarkerType, TooltipAlignment;

/// Represents the trend line painter.
class TrendlinePainter extends CustomPainter {
  /// Creates an instance for trend line painter.
  TrendlinePainter(
      {required this.stateProperties,
      required this.trendlineAnimations,
      required ValueNotifier<num> notifier})
      : super(repaint: notifier);

  /// Holds the cartesian state properties value.
  final CartesianStateProperties stateProperties;

  /// Holds the list of trend line animation.
  final Map<String, Animation<double>> trendlineAnimations;

  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    Animation<double>? trendlineAnimation;
    for (int i = 0;
        i < stateProperties.chartSeries.visibleSeriesRenderers.length;
        i++) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              stateProperties.chartSeries.visibleSeriesRenderers[i]);
      final RenderingDetails renderingDetails =
          stateProperties.renderingDetails;
      final XyDataSeries<dynamic, dynamic> series =
          seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
      TrendlineRenderer trendlineRenderer;
      Trendline trendline;
      List<Offset> controlPoints;
      const int minimumDataLength = 2;
      if (series.trendlines != null) {
        for (int j = 0; j < series.trendlines!.length; j++) {
          trendline = series.trendlines![j];
          trendlineRenderer = seriesRendererDetails.trendlineRenderer[j];
          assert(trendline.width >= 0,
              'The width of the trendlines must be greater or equal to 0.');
          assert(trendline.animationDuration >= 0,
              'The animation duration time for trendlines should be greater than or equal to 0.');
          trendlineAnimation = trendlineAnimations['$i-$j'];
          if (trendlineRenderer.isNeedRender &&
              trendline.isVisible &&
              trendlineRenderer.pointsData != null &&
              trendlineRenderer.pointsData!.isNotEmpty) {
            canvas.save();
            animationFactor = (!renderingDetails.isLegendToggled &&
                        (seriesRendererDetails.oldSeries == null)) &&
                    trendlineAnimation != null
                ? trendlineAnimation.value
                : 1;
            final Rect axisClipRect = calculatePlotOffset(
                stateProperties.chartAxis.axisClipRect,
                Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
                    seriesRendererDetails.yAxisDetails!.axis.plotOffset));
            canvas.clipRect(axisClipRect);
            final Path path = Path();
            final Paint paint = Paint();
            paint.strokeWidth = trendline.width;
            if (seriesRendererDetails.reAnimate == true ||
                (trendline.animationDuration > 0 &&
                    seriesRendererDetails.oldSeries == null)) {
              performLinearAnimation(
                  stateProperties,
                  seriesRendererDetails.xAxisDetails!.axis,
                  canvas,
                  animationFactor);
            }
            renderTrendlineEvent(
                stateProperties.chart,
                trendline,
                series.trendlines!.indexOf(trendline),
                stateProperties.chartSeries.visibleSeriesRenderers
                    .indexOf(seriesRendererDetails.renderer),
                seriesRendererDetails.seriesName!);
            paint.color = trendlineRenderer.fillColor
                .withOpacity(trendlineRenderer.opacity);
            paint.style = PaintingStyle.stroke;
            // The first two points are always accessed to generate the linear trend line,
            // so a single data point throws an exception, thus ensured the data length is more than or equal to 2.
            if (trendline.type == TrendlineType.linear &&
                trendlineRenderer.points.length >= minimumDataLength) {
              path.moveTo(trendlineRenderer.points[0].dx,
                  trendlineRenderer.points[0].dy);
              path.lineTo(trendlineRenderer.points[1].dx,
                  trendlineRenderer.points[1].dy);
            } else if (trendline.type == TrendlineType.exponential ||
                trendline.type == TrendlineType.power ||
                trendline.type == TrendlineType.logarithmic) {
              path.moveTo(trendlineRenderer.points[0].dx,
                  trendlineRenderer.points[0].dy);
              for (int i = 0; i < trendlineRenderer.points.length - 1; i++) {
                controlPoints = trendlineRenderer.getControlPoints(
                    trendlineRenderer.points, i);
                path.cubicTo(
                    controlPoints[0].dx,
                    controlPoints[0].dy,
                    controlPoints[1].dx,
                    controlPoints[1].dy,
                    trendlineRenderer.points[i + 1].dx,
                    trendlineRenderer.points[i + 1].dy);
              }
            } else if (trendline.type == TrendlineType.polynomial) {
              path.moveTo(trendlineRenderer.points[0].dx,
                  trendlineRenderer.points[0].dy);
              for (int i = 0; i < trendlineRenderer.points.length - 1; i++) {
                controlPoints = trendlineRenderer.getControlPoints(
                    trendlineRenderer.points, i);
                path.cubicTo(
                    controlPoints[0].dx,
                    controlPoints[0].dy,
                    controlPoints[1].dx,
                    controlPoints[1].dy,
                    trendlineRenderer.points[i + 1].dx,
                    trendlineRenderer.points[i + 1].dy);
              }
            } else if (trendline.type == TrendlineType.polynomial &&
                trendlineRenderer.pointsData != null &&
                trendlineRenderer.pointsData!.isNotEmpty) {
              final List<Offset> polynomialPoints =
                  trendlineRenderer.getPolynomialCurve(
                      trendlineRenderer.pointsData!,
                      seriesRendererDetails,
                      stateProperties);
              path.moveTo(polynomialPoints[0].dx, polynomialPoints[0].dy);
              for (int i = 1; i < polynomialPoints.length; i++) {
                path.lineTo(polynomialPoints[i].dx, polynomialPoints[i].dy);
              }
            } else if (trendline.type == TrendlineType.movingAverage) {
              path.moveTo(trendlineRenderer.points[0].dx,
                  trendlineRenderer.points[0].dy);
              for (int i = 1; i < trendlineRenderer.points.length; i++) {
                path.lineTo(trendlineRenderer.points[i].dx,
                    trendlineRenderer.points[i].dy);
              }
            }
            _drawTrendlineMarker(trendlineRenderer, trendline,
                seriesRendererDetails, animationFactor, canvas, path, paint);
          }
        }
      }
    }
  }

  /// To draw the marker on trendline.
  void _drawTrendlineMarker(
    TrendlineRenderer trendlineRenderer,
    Trendline trendline,
    SeriesRendererDetails seriesRendererDetails,
    double animationFactor,
    Canvas canvas,
    Path path,
    Paint paint,
  ) {
    Rect clipRect;
    final Rect axisClipRect = stateProperties.chartAxis.axisClipRect;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    (trendlineRenderer.dashArray != null)
        ? drawDashedLine(canvas, trendlineRenderer.dashArray!, paint, path)
        : canvas.drawPath(path, paint);
    clipRect = calculatePlotOffset(
        Rect.fromLTRB(
            axisClipRect.left - trendline.markerSettings.width,
            axisClipRect.top - trendline.markerSettings.height,
            axisClipRect.right + trendline.markerSettings.width,
            axisClipRect.bottom + trendline.markerSettings.height),
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    canvas.restore();
    if (trendlineRenderer.visible &&
        (animationFactor > stateProperties.trendlineDurationFactor)) {
      canvas.clipRect(clipRect);

      if (trendline.markerSettings.isVisible) {
        for (final CartesianChartPoint<dynamic> point
            in trendlineRenderer.pointsData!) {
          if (point.isVisible && point.isGap != true) {
            if (trendline.markerSettings.shape == DataMarkerType.image) {
              drawImageMarker(seriesRendererDetails, canvas,
                  point.markerPoint!.x, point.markerPoint!.y);
            }
            final Paint strokePaint = Paint()
              ..color = trendline.markerSettings.borderWidth == 0
                  ? Colors.transparent
                  : trendline.markerSettings.borderColor ??
                      trendlineRenderer.fillColor
              ..strokeWidth = trendline.markerSettings.borderWidth
              ..style = PaintingStyle.stroke;

            final Paint fillPaint = Paint()
              ..color = trendline.markerSettings.color ??
                  (renderingDetails.chartTheme.brightness == Brightness.light
                      ? Colors.white
                      : Colors.black)
              ..style = PaintingStyle.fill;
            final int index = trendlineRenderer.pointsData!.indexOf(point);
            canvas.drawPath(trendlineRenderer.markerShapes[index], strokePaint);
            canvas.drawPath(trendlineRenderer.markerShapes[index], fillPaint);
          }
        }
      }
    }
  }

  /// Setting the values of render trend line event.
  void renderTrendlineEvent(SfCartesianChart chart, Trendline trendline,
      int trendlineIndex, int seriesIndex, String seriesName) {
    TrendlineRenderParams args;
    final TrendlineRenderer trendlineRenderer =
        SeriesHelper.getSeriesRendererDetails(
                stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex])
            .trendlineRenderer[trendlineIndex];

    final List<double>? slope = trendline.type == TrendlineType.polynomial
        ? trendlineRenderer.polynomialSlopesData
        : trendline.type == TrendlineType.movingAverage
            ? null
            : <double>[trendlineRenderer.slopeInterceptData.slope!.toDouble()];
    if (trendline.onRenderDetailsUpdate != null &&
        !trendlineRenderer.isTrendlineRenderEvent) {
      trendlineRenderer.isTrendlineRenderEvent = true;
      args = TrendlineRenderParams(
          trendlineRenderer.slopeIntercept.intercept?.toDouble(),
          seriesIndex,
          trendlineRenderer.name!,
          seriesName,
          trendlineRenderer.points,
          slope,
          getRSquaredValue(
              stateProperties.seriesRenderers[seriesIndex],
              trendline,
              slope,
              trendlineRenderer.slopeIntercept.intercept?.toDouble()));
      trendline.onRenderDetailsUpdate!(args);
    }
  }

  @override
  bool shouldRepaint(TrendlinePainter oldDelegate) => true;
}
