import 'package:flutter/material.dart';
import '../../common/event_args.dart';
import '../base/circular_base.dart';
import '../base/circular_state_properties.dart';
import '../renderer/chart_point.dart';
import '../renderer/common.dart';
import '../renderer/renderer_extension.dart';
import '../utils/helper.dart';

/// Represents the pie chart painter.
class PieChartPainter extends CustomPainter {
  /// Creates an instance of pie chart painter.
  PieChartPainter({
    required this.stateProperties,
    required this.index,
    required this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    required ValueNotifier<num> notifier,
  })  : chart = stateProperties.chart,
        super(repaint: notifier);

  /// Specifies the circular state properties.
  final CircularStateProperties stateProperties;

  /// Holds the circularchart.
  final SfCircularChart chart;

  /// Holds the index value.
  final int index;

  /// Specifies whether to repaint the series.
  final bool isRepaint;

  /// Holds the animation controller.
  final AnimationController? animationController;

  /// Specifies the series animation.
  final Animation<double>? seriesAnimation;

  /// Specifies the pie series renderer extension.
  late PieSeriesRendererExtension seriesRenderer;

  /// To paint series.
  @override
  void paint(Canvas canvas, Size size) {
    num? pointStartAngle;
    seriesRenderer = stateProperties.chartSeries.visibleSeriesRenderers[index]
        as PieSeriesRendererExtension;
    pointStartAngle = seriesRenderer.segmentRenderingValues['start'];
    seriesRenderer.pointRegions = <Region>[];
    bool isAnyPointNeedSelect = false;
    if (stateProperties.renderingDetails.initialRender!) {
      isAnyPointNeedSelect =
          checkIsAnyPointSelect(seriesRenderer, seriesRenderer.point, chart);
    }
    ChartPoint<dynamic>? oldPoint;
    ChartPoint<dynamic>? point = seriesRenderer.point;
    final PieSeriesRendererExtension? oldSeriesRenderer =
        (stateProperties.renderingDetails.widgetNeedUpdate &&
                !stateProperties.renderingDetails.isLegendToggled &&
                stateProperties.prevSeriesRenderer != null &&
                stateProperties.prevSeriesRenderer!.seriesType == 'pie')
            ? stateProperties.prevSeriesRenderer! as PieSeriesRendererExtension
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
                  stateProperties.prevSeriesRenderer?.seriesType == 'pie')
              ? stateProperties.oldPoints![i]
              : null);
      point.innerRadius = 0.0;
      pointStartAngle = seriesRenderer.circularRenderPoint(
          chart,
          seriesRenderer,
          point,
          pointStartAngle,
          point.innerRadius,
          point.outerRadius,
          canvas,
          index,
          i,
          seriesAnimation?.value ?? 1,
          seriesAnimation?.value ?? 1,
          isAnyPointNeedSelect,
          oldPoint,
          stateProperties.oldPoints);
    }
    if (seriesRenderer.renderList.isNotEmpty) {
      Shader? chartShader;
      if (chart.onCreateShader != null) {
        ChartShaderDetails chartShaderDetails;
        chartShaderDetails =
            ChartShaderDetails(seriesRenderer.renderList[1], null, 'series');
        chartShader = chart.onCreateShader!(chartShaderDetails);
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
  bool shouldRepaint(PieChartPainter oldDelegate) => isRepaint;
}
