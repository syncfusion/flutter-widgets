import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../axis/axis.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for spline series.
class SplineSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of SplineSeriesRenderer class.
  SplineSeriesRenderer();

  /// Spline segment is created here.
  ChartSegment _createSegments(
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> nextPoint,
      int pointIndex,
      int seriesIndex,
      double animateFactor) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final SplineSegment segment = createSegment() as SplineSegment;
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        seriesRendererDetails.stateProperties.oldSeriesRenderers;
    seriesRendererDetails.isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      final SegmentProperties segmentProperties =
          SegmentProperties(seriesRendererDetails.stateProperties, segment);
      SegmentHelper.setSegmentProperties(segment, segmentProperties);
      segment.animationFactor = animateFactor;
      segmentProperties.currentPoint = currentPoint;
      segmentProperties.nextPoint = nextPoint;
      segmentProperties.pointColorMapper = currentPoint.pointColorMapper;
      segment.currentSegmentIndex = pointIndex;
      segmentProperties.seriesIndex = seriesIndex;
      segmentProperties.series =
          seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
      segmentProperties.seriesRenderer = this;
      final SeriesRendererDetails seriesDetails =
          SeriesHelper.getSeriesRendererDetails(
              segmentProperties.seriesRenderer);
      if (seriesRendererDetails
                  .stateProperties.renderingDetails.widgetNeedUpdate ==
              true &&
          // ignore: unnecessary_null_comparison
          oldSeriesRenderers != null &&
          oldSeriesRenderers.isNotEmpty &&
          oldSeriesRenderers.length - 1 >= segmentProperties.seriesIndex &&
          SeriesHelper.getSeriesRendererDetails(
                      oldSeriesRenderers[segmentProperties.seriesIndex])
                  .seriesName ==
              seriesDetails.seriesName) {
        segmentProperties.oldSeriesRenderer =
            oldSeriesRenderers[segmentProperties.seriesIndex];
        segmentProperties.oldSeries = SeriesHelper.getSeriesRendererDetails(
                segmentProperties.oldSeriesRenderer!)
            .series as XyDataSeries<dynamic, dynamic>;
      }
      SegmentHelper.setSegmentProperties(segment, segmentProperties);
      segment.calculateSegmentPoints();
      segment.points.add(
          Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
      segment.points.add(Offset(segmentProperties.x2, segmentProperties.y2));

      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      seriesRendererDetails.segments.add(segment);
    }
    return segment;
  }

  /// To render spline series segments.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final SeriesRendererDetails seriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (seriesDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          seriesDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              seriesRendererDetails.segments[segment.currentSegmentIndex!],
              seriesRendererDetails.chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => SplineSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final SeriesRendererDetails seriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    segmentProperties.color = seriesDetails.seriesColor;
    segmentProperties.strokeColor = seriesDetails.seriesColor;
    segmentProperties.strokeWidth = segmentProperties.series.width;
  }

  /// Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer!);
    canvas.drawPath(seriesRendererDetails.markerShapes[index]!, fillPaint);
    canvas.drawPath(seriesRendererDetails.markerShapes[index]!, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}

/// Represents the spline Chart painter
class SplineChartPainter extends CustomPainter {
  /// Calling the default constructor of SplineChartPainter class.
  SplineChartPainter(
      {required this.stateProperties,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required ValueNotifier<num> notifier,
      required this.painterKey})
      : chart = stateProperties.chart,
        super(repaint: notifier);

  /// Represents the Cartesian state properties
  final CartesianStateProperties stateProperties;

  /// Represents the Cartesian chart.
  final SfCartesianChart chart;

  /// Specifies whether to repaint the series.
  final bool isRepaint;

  /// Specifies the value of animation controller.
  final AnimationController animationController;

  /// Specifies the spline series renderer
  final SplineSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for spline series
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);
    final SplineSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as SplineSeries<dynamic, dynamic>;
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    if (seriesRendererDetails.hasDataLabelTemplate == false) {
      seriesRendererDetails.drawControlPoints.clear();
    }

    /// Clip rect will be added for series.
    if (seriesRendererDetails.visible! == true) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
      animationFactor = seriesRendererDetails.seriesAnimation != null
          ? seriesRendererDetails.seriesAnimation!.value
          : 1;
      stateProperties.shader = null;
      if (series.onCreateShader != null) {
        stateProperties.shader = series.onCreateShader!(
            ShaderDetails(stateProperties.chartAxis.axisClipRect, 'series'));
      }
      final Rect axisClipRect = calculatePlotOffset(
          stateProperties.chartAxis.axisClipRect,
          Offset(xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset));
      canvas.clipRect(axisClipRect);
      if (seriesRendererDetails.reAnimate == true ||
          ((!(renderingDetails.widgetNeedUpdate ||
                      renderingDetails.isLegendToggled) ||
                  !stateProperties.oldSeriesKeys.contains(series.key)) &&
              series.animationDuration > 0)) {
        performLinearAnimation(
            stateProperties, xAxisDetails.axis, canvas, animationFactor);
      }
      if (seriesRendererDetails.hasDataLabelTemplate == false) {
        calculateSplineAreaControlPoints(seriesRenderer);
      }

      int segmentIndex = -1;

      CartesianChartPoint<dynamic>? point, nextPoint, startPoint, endPoint;

      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }

      seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
      //Draw spline for spline series
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        if (withInRange(seriesRendererDetails.dataPoints[pointIndex].xValue,
                seriesRendererDetails.xAxisDetails!.visibleRange!) ||
            (pointIndex < dataPoints.length - 1 &&
                withInRange(
                    seriesRendererDetails.dataPoints[pointIndex + 1].xValue,
                    seriesRendererDetails.xAxisDetails!.visibleRange!))) {
          seriesRendererDetails.calculateRegionData(stateProperties,
              seriesRendererDetails, painterKey.index, point, pointIndex);
          if ((point.isVisible && !point.isGap) && startPoint == null) {
            startPoint = point;
          }
          if (pointIndex + 1 < dataPoints.length) {
            nextPoint = dataPoints[pointIndex + 1];
            if (startPoint != null && !nextPoint.isVisible && nextPoint.isGap) {
              startPoint = null;
            } else if (nextPoint.isVisible && !nextPoint.isGap) {
              endPoint = nextPoint;
            }
          }
          if (startPoint != null &&
              endPoint != null &&
              startPoint != endPoint) {
            seriesRendererDetails.drawSegment(
                canvas,
                seriesRenderer._createSegments(startPoint, endPoint,
                    segmentIndex += 1, seriesIndex, animationFactor));
            endPoint = startPoint = null;
          }
        }
      }

      clipRect = calculatePlotOffset(
          Rect.fromLTRB(
              stateProperties.chartAxis.axisClipRect.left -
                  series.markerSettings.width,
              stateProperties.chartAxis.axisClipRect.top -
                  series.markerSettings.height,
              stateProperties.chartAxis.axisClipRect.right +
                  series.markerSettings.width,
              stateProperties.chartAxis.axisClipRect.bottom +
                  series.markerSettings.height),
          Offset(xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset));
      canvas.restore();

      if ((series.animationDuration <= 0 ||
              (!renderingDetails.initialRender! &&
                  seriesRendererDetails.needAnimateSeriesElements == false) ||
              animationFactor >= stateProperties.seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The spline series should be available to render a marker on it.');
        canvas.clipRect(clipRect);

        ///Draw marker and other elements for spline series
        seriesRendererDetails.renderSeriesElements(
            chart, canvas, seriesRendererDetails.seriesElementAnimation);
      }
      if (animationFactor >= 1) {
        stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(SplineChartPainter oldDelegate) => isRepaint;
}
