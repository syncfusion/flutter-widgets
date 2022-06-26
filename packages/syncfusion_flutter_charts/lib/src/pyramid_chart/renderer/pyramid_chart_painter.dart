import 'package:flutter/material.dart';
import '../base/pyramid_state_properties.dart';
import '../utils/common.dart';
import 'renderer_extension.dart';

/// Represents the pyramid chart painter.
class PyramidChartPainter extends CustomPainter {
  /// Creates an instance of pyramid chart painter.
  PyramidChartPainter({
    required this.stateProperties,
    required this.seriesIndex,
    required this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    required ValueNotifier<num> notifier,
  }) : super(repaint: notifier);

  /// Specifies the pyramid state properties.
  final PyramidStateProperties stateProperties;

  /// Specifies the series index value.
  final int seriesIndex;

  /// Specifies whether to repaint the series.
  final bool isRepaint;

  /// Specifies the animation controller of series.
  final AnimationController? animationController;

  /// Specifies the pyramid series animation.
  final Animation<double>? seriesAnimation;

  /// Specifies the pyramid series renderer.
  late PyramidSeriesRendererExtension seriesRenderer;

  /// Specifies the point info.
  static late PointInfo<dynamic> point;

  @override
  void paint(Canvas canvas, Size size) {
    seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex];

    double animationFactor, factor, height;
    for (int pointIndex = 0;
        pointIndex < seriesRenderer.renderPoints!.length;
        pointIndex++) {
      if (seriesRenderer.renderPoints![pointIndex].isVisible) {
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
            .calculatePyramidSegments(canvas, pointIndex, seriesRenderer);
      }
    }
  }

  @override
  bool shouldRepaint(PyramidChartPainter oldDelegate) => true;
}
