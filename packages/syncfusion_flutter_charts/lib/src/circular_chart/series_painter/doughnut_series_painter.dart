import 'package:flutter/material.dart';
import '../../common/event_args.dart';
import '../base/circular_state_properties.dart';
import '../renderer/chart_point.dart';
import '../renderer/common.dart';
import '../renderer/renderer_extension.dart';
import '../utils/helper.dart';

/// Represents the painter of doughnut chart.
class DoughnutChartPainter extends CustomPainter {
  /// Creates the instance of doughnut chart painter.
  DoughnutChartPainter({
    required this.stateProperties,
    required this.index,
    required this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    required ValueNotifier<num> notifier,
  }) : super(repaint: notifier);

  /// Specifies the circular chart state.
  final CircularStateProperties stateProperties;

  /// Specifies the value of index.
  final int index;

  /// Specifies whether to repaint the series.
  final bool isRepaint;

  /// Specifies the value of animation controller.
  final AnimationController? animationController;

  /// Specifies the value of series animation.
  final Animation<double>? seriesAnimation;

  /// Specifies the value of series renderer.
  late DoughnutSeriesRendererExtension seriesRenderer;

  /// To paint series.
  @override
  void paint(Canvas canvas, Size size) {
    num? pointStartAngle;
    seriesRenderer = stateProperties.chartSeries.visibleSeriesRenderers[index]
        as DoughnutSeriesRendererExtension;
    pointStartAngle = seriesRenderer.segmentRenderingValues['start'];
    seriesRenderer.innerRadius =
        seriesRenderer.segmentRenderingValues['currentInnerRadius']!;
    seriesRenderer.radius =
        seriesRenderer.segmentRenderingValues['currentRadius']!;
    ChartPoint<dynamic> point;
    seriesRenderer.pointRegions = <Region>[];
    ChartPoint<dynamic>? oldPoint;
    final DoughnutSeriesRendererExtension? oldSeriesRenderer = (stateProperties
                .renderingDetails.widgetNeedUpdate &&
            !stateProperties.renderingDetails.isLegendToggled &&
            stateProperties.prevSeriesRenderer?.seriesType == 'doughnut')
        ? stateProperties.prevSeriesRenderer as DoughnutSeriesRendererExtension
        : null;
    seriesRenderer.renderPaths.clear();
    seriesRenderer.renderList.clear();
    for (int i = 0; i < seriesRenderer.renderPoints!.length; i++) {
      point = seriesRenderer.renderPoints![i];
      oldPoint = (oldSeriesRenderer != null &&
              oldSeriesRenderer.oldRenderPoints != null &&
              (oldSeriesRenderer.oldRenderPoints!.length - 1 >= i))
          ? oldSeriesRenderer.oldRenderPoints![i]
          : ((stateProperties.renderingDetails.isLegendToggled &&
                  stateProperties.prevSeriesRenderer?.seriesType == 'doughnut')
              ? stateProperties.oldPoints![i]
              : null);
      pointStartAngle = seriesRenderer.circularRenderPoint(
          stateProperties.chart,
          seriesRenderer,
          point,
          pointStartAngle,
          point.innerRadius,
          point.outerRadius,
          canvas,
          index,
          i,
          seriesAnimation?.value ?? 1,
          1,
          checkIsAnyPointSelect(seriesRenderer, point, stateProperties.chart),
          oldPoint,
          stateProperties.oldPoints);
    }

    if (seriesRenderer.renderList.isNotEmpty) {
      Shader? chartShader;
      if (stateProperties.chart.onCreateShader != null) {
        ChartShaderDetails chartShaderDetails;
        chartShaderDetails = ChartShaderDetails(seriesRenderer.renderList[1],
            seriesRenderer.renderList[2], 'series');
        chartShader = stateProperties.chart.onCreateShader!(chartShaderDetails);
      }
      for (int k = 0; k < seriesRenderer.renderPaths.length; k++) {
        drawPath(
            canvas,
            seriesRenderer.renderList[0],
            seriesRenderer.renderPaths[k],
            seriesRenderer.renderList[1],
            chartShader);
      }
      if (seriesRenderer.renderList[0].strokeColor != null &&
          seriesRenderer.renderList[0].strokeWidth != null &&
          seriesRenderer.renderList[0].strokeWidth > 0 == true) {
        final Paint paint = Paint();
        paint.color = seriesRenderer.renderList[0].strokeColor;
        paint.strokeWidth = seriesRenderer.renderList[0].strokeWidth;
        paint.style = PaintingStyle.stroke;
        for (int k = 0; k < seriesRenderer.renderPaths.length; k++) {
          canvas.drawPath(seriesRenderer.renderPaths[k], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(DoughnutChartPainter oldDelegate) => isRepaint;
}
