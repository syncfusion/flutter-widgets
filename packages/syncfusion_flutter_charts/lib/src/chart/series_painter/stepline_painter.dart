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

/// Creates series renderer for step line series.
class StepLineSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of StepLineSeriesRenderer class.
  StepLineSeriesRenderer();

  /// Step line segment is created here.
  ChartSegment _createSegments(
      CartesianChartPoint<dynamic> currentPoint,
      num midX,
      num midY,
      CartesianChartPoint<dynamic> nextPoint,
      int pointIndex,
      int seriesIndex,
      double animateFactor) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final StepLineSegment segment = createSegment();
    final SegmentProperties segmentProperties =
        SegmentProperties(seriesRendererDetails.stateProperties, segment);
    SegmentHelper.setSegmentProperties(segment, segmentProperties);
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        seriesRendererDetails.stateProperties.oldSeriesRenderers;
    seriesRendererDetails.isRectSeries = false;
    segment.currentSegmentIndex = pointIndex;
    segmentProperties.seriesIndex = seriesIndex;
    segmentProperties.seriesRenderer = this;
    segmentProperties.series =
        seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
    segmentProperties.currentPoint = currentPoint;
    segmentProperties.midX = midX;
    segmentProperties.midY = midY;
    segmentProperties.nextPoint = nextPoint;
    segment.animationFactor = animateFactor;
    segmentProperties.pointColorMapper = currentPoint.pointColorMapper;
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
            SeriesHelper.getSeriesRendererDetails(
                    segmentProperties.seriesRenderer)
                .seriesName) {
      segmentProperties.oldSeriesRenderer =
          oldSeriesRenderers[segmentProperties.seriesIndex];
      segmentProperties.oldSegmentIndex = getOldSegmentIndex(segment);
    }
    segment.calculateSegmentPoints();
    segment.points.add(Offset(segmentProperties.x1, segmentProperties.y1));
    segment.points.add(Offset(segmentProperties.x2, segmentProperties.y2));
    customizeSegment(segment);
    segment.strokePaint = segment.getStrokePaint();
    segment.fillPaint = segment.getFillPaint();
    seriesRendererDetails.segments.add(segment);
    return segment;
  }

  /// To render step line series segments.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    if (seriesRendererDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          seriesRendererDetails.selectionBehaviorRenderer;
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
  StepLineSegment createSegment() => StepLineSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    segmentProperties.color = seriesRendererDetails.seriesColor;
    segmentProperties.strokeColor = seriesRendererDetails.seriesColor;
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

/// Represents the Step line chart painter
class StepLineChartPainter extends CustomPainter {
  /// Calling the default constructor of StepLineChartPainter class.
  StepLineChartPainter(
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
  final Animation<double> animationController;

  /// Specifies the step line series renderer
  final StepLineSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for step line series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);
    final StepLineSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as StepLineSeries<dynamic, dynamic>;
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    if (seriesRendererDetails.visible! == true) {
      canvas.save();
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
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
      int segmentIndex = -1;
      CartesianChartPoint<dynamic>? startPoint,
          endPoint,
          currentPoint,
          nextPoint;
      num? midX, midY;

      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }

      seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        currentPoint = dataPoints[pointIndex];
        bool withInXRange = withInRange(currentPoint.xValue,
            seriesRendererDetails.xAxisDetails!.visibleRange!);
        // ignore: unnecessary_null_comparison
        bool withInYRange = currentPoint != null &&
            currentPoint.yValue != null &&
            withInRange(currentPoint.yValue,
                seriesRendererDetails.yAxisDetails!.visibleRange!);
        bool inRange = withInXRange || withInYRange;
        if (!inRange && pointIndex + 1 < dataPoints.length) {
          final CartesianChartPoint<dynamic>? nextPoint =
              dataPoints[pointIndex + 1];
          withInXRange = withInRange(nextPoint!.xValue,
              seriesRendererDetails.xAxisDetails!.visibleRange!);
          // ignore: unnecessary_null_comparison
          withInYRange = nextPoint != null &&
              nextPoint.yValue != null &&
              withInRange(nextPoint.yValue,
                  seriesRendererDetails.yAxisDetails!.visibleRange!);

          inRange = withInXRange || withInYRange;
          if (!inRange && pointIndex - 1 >= 0) {
            final CartesianChartPoint<dynamic>? prevPoint =
                dataPoints[pointIndex - 1];
            withInXRange = withInRange(prevPoint!.xValue,
                seriesRendererDetails.xAxisDetails!.visibleRange!);
            // ignore: unnecessary_null_comparison
            withInYRange = prevPoint != null &&
                prevPoint.yValue != null &&
                withInRange(prevPoint.yValue,
                    seriesRendererDetails.yAxisDetails!.visibleRange!);
          }
        }
        if (withInXRange || withInYRange) {
          if ((currentPoint.isVisible && !currentPoint.isGap) &&
              startPoint == null) {
            startPoint = currentPoint;
          }
          if (pointIndex + 1 < dataPoints.length) {
            nextPoint = dataPoints[pointIndex + 1];

            if (startPoint != null && !nextPoint.isVisible && nextPoint.isGap) {
              startPoint = null;
            } else if (nextPoint.isVisible && !nextPoint.isGap) {
              endPoint = nextPoint;
              midX = nextPoint.xValue;
              midY = currentPoint.yValue;
            } else if (nextPoint.isDrop) {
              nextPoint = _getDropValue(dataPoints, pointIndex);
              midX = nextPoint?.xValue;
              midY = currentPoint.yValue;
            }
          }

          seriesRendererDetails.calculateRegionData(
              stateProperties,
              seriesRendererDetails,
              seriesIndex,
              currentPoint,
              pointIndex,
              null,
              nextPoint,
              midX,
              midY);
          if (startPoint != null &&
              endPoint != null &&
              midX != null &&
              midY != null) {
            seriesRendererDetails.drawSegment(
                canvas,
                seriesRenderer._createSegments(startPoint, midX, midY, endPoint,
                    segmentIndex += 1, seriesIndex, animationFactor));
            endPoint = startPoint = midX = midY = null;
          }
        }
      }
      _drawSeries(canvas, animationFactor, seriesRendererDetails);
    }
  }

  ///Draw series elements and add cliprect
  void _drawSeries(Canvas canvas, double animationFactor,
      SeriesRendererDetails seriesRendererDetails) {
    final StepLineSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as StepLineSeries<dynamic, dynamic>;
    final Rect clipRect = calculatePlotOffset(
        Rect.fromLTRB(
            stateProperties.chartAxis.axisClipRect.left -
                series.markerSettings.width,
            stateProperties.chartAxis.axisClipRect.top -
                series.markerSettings.height,
            stateProperties.chartAxis.axisClipRect.right +
                series.markerSettings.width,
            stateProperties.chartAxis.axisClipRect.bottom +
                series.markerSettings.height),
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));

    canvas.restore();
    if ((series.animationDuration <= 0 ||
            (!stateProperties.renderingDetails.initialRender! &&
                seriesRendererDetails.needAnimateSeriesElements == false) ||
            animationFactor >= stateProperties.seriesDurationFactor) &&
        (series.markerSettings.isVisible ||
            series.dataLabelSettings.isVisible)) {
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'The step line series should be available to render a marker on it.');
      canvas.clipRect(clipRect);
      seriesRendererDetails.renderSeriesElements(
          chart, canvas, seriesRendererDetails.seriesElementAnimation);
    }
    if (seriesRendererDetails.visible! == true && animationFactor >= 1) {
      stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
    }
  }

  /// To get point value in the drop mode
  CartesianChartPoint<dynamic>? _getDropValue(
      List<CartesianChartPoint<dynamic>> points, int pointIndex) {
    CartesianChartPoint<dynamic>? value;
    for (int i = pointIndex; i < points.length - 1; i++) {
      if (!points[i + 1].isDrop) {
        value = points[i + 1];
        break;
      }
    }
    return value;
  }

  @override
  bool shouldRepaint(StepLineChartPainter oldDelegate) => isRepaint;
}
