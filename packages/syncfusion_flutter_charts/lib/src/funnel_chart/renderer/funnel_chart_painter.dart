import 'package:flutter/material.dart';
import '../../pyramid_chart/utils/common.dart';
import '../base/funnel_state_properties.dart';
import 'renderer_extension.dart';

/// Represents the funnel chart painter.
class FunnelChartPainter extends CustomPainter {
  /// Creates an instance of funnel chart painter.
  FunnelChartPainter({
    required this.stateProperties,
    required this.seriesIndex,
    required this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    required ValueNotifier<num> notifier,
  }) : super(repaint: notifier);

  /// Specifies the value of funnel state properties.
  final FunnelStateProperties stateProperties;

  /// Holds the series index details.
  final int seriesIndex;

  /// Specifies whether to repaint the chart.
  final bool isRepaint;

  /// Specifies the value of animation controller.
  final AnimationController? animationController;

  /// Specifies the value of series animation.
  final Animation<double>? seriesAnimation;

  /// Specifies the value of funnel series renderer extension.
  late FunnelSeriesRendererExtension seriesRenderer;

  /// Holds the point value.
  static late PointInfo<dynamic> point;

  @override
  void paint(Canvas canvas, Size size) {
    seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex];
    double animationFactor;
    double factor;
    double height;
    for (int pointIndex = 0;
        pointIndex < seriesRenderer.renderPoints.length;
        pointIndex++) {
      if (seriesRenderer.renderPoints[pointIndex].isVisible) {
        animationFactor = seriesAnimation != null ? seriesAnimation!.value : 1;
        if (seriesRenderer.series.animationDuration > 0 &&
            !stateProperties.renderingDetails.isLegendToggled) {
          factor = (stateProperties.renderingDetails.chartAreaRect.top +
                  stateProperties.renderingDetails.chartAreaRect.height) -
              animationFactor *
                  (stateProperties.renderingDetails.chartAreaRect.top +
                      stateProperties.renderingDetails.chartAreaRect.height);
          height = stateProperties.renderingDetails.chartAreaRect.top +
              stateProperties.renderingDetails.chartAreaRect.height -
              factor;
          canvas.clipRect(Rect.fromLTRB(
              0,
              stateProperties.renderingDetails.chartAreaRect.top +
                  stateProperties.renderingDetails.chartAreaRect.height -
                  height,
              stateProperties.renderingDetails.chartAreaRect.left +
                  stateProperties.renderingDetails.chartAreaRect.width,
              stateProperties.renderingDetails.chartAreaRect.top +
                  stateProperties.renderingDetails.chartAreaRect.height));
        }
        stateProperties.chartSeries
            .calculateFunnelSegments(canvas, pointIndex, seriesRenderer);
      }
    }
  }

  @override
  bool shouldRepaint(FunnelChartPainter oldDelegate) => true;
}
