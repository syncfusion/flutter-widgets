import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../axis/axis.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../user_interaction/zooming_panning.dart';
import '../utils/helper.dart';

/// Creates series renderer for waterfall series.
class WaterfallSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of WaterfallSeriesRenderer class.
  WaterfallSeriesRenderer();

  late WaterfallSeries<dynamic, dynamic> _waterfallSeries;

  /// To add waterfall segments in segments list.
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final WaterfallSegment segment = createSegment();
    final SegmentProperties segmentProperties =
        SegmentProperties(seriesRendererDetails.stateProperties, segment);
    SegmentHelper.setSegmentProperties(segment, segmentProperties);

    final List<CartesianSeriesRenderer>? oldSeriesRenderers =
        seriesRendererDetails.stateProperties.oldSeriesRenderers;
    _waterfallSeries =
        seriesRendererDetails.series as WaterfallSeries<dynamic, dynamic>;
    final BorderRadius borderRadius = _waterfallSeries.borderRadius;
    segmentProperties.seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.points
        .add(Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
    segmentProperties.seriesRenderer = this;
    segmentProperties.series = _waterfallSeries;
    segment.animationFactor = animateFactor;
    segmentProperties.currentPoint = currentPoint;
    if (seriesRendererDetails.stateProperties.renderingDetails.widgetNeedUpdate == true &&
        ZoomPanBehaviorHelper.getRenderingDetails(seriesRendererDetails
                    .stateProperties.zoomPanBehaviorRenderer)
                .isPinching !=
            true &&
        seriesRendererDetails
                .stateProperties.renderingDetails.isLegendToggled ==
            false &&
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
      final SeriesRendererDetails oldSeriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              segmentProperties.oldSeriesRenderer!);
      segmentProperties
          .oldPoint = (oldSeriesRendererDetails.segments.isNotEmpty == true &&
              oldSeriesRendererDetails.segments[0] is WaterfallSegment &&
              (oldSeriesRendererDetails.dataPoints.length - 1 >= pointIndex) ==
                  true)
          ? oldSeriesRendererDetails.dataPoints[pointIndex]
          : null;
      segmentProperties.oldSegmentIndex = getOldSegmentIndex(segment);
    } else if (seriesRendererDetails
                .stateProperties.renderingDetails.isLegendToggled ==
            true &&
        // ignore: unnecessary_null_comparison
        seriesRendererDetails.stateProperties.segments != null &&
        seriesRendererDetails.stateProperties.segments.isNotEmpty == true) {
      segmentProperties.oldSeriesVisible = seriesRendererDetails
          .stateProperties.oldSeriesVisible[segmentProperties.seriesIndex];
      WaterfallSegment oldSegment;
      for (int i = 0;
          i < seriesRendererDetails.stateProperties.segments.length;
          i++) {
        oldSegment = seriesRendererDetails.stateProperties.segments[i]
            as WaterfallSegment;
        if (oldSegment.currentSegmentIndex == segment.currentSegmentIndex &&
            SegmentHelper.getSegmentProperties(oldSegment).seriesIndex ==
                segmentProperties.seriesIndex) {
          segmentProperties.oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }
    segmentProperties.path = findingRectSeriesDashedBorder(
        currentPoint, _waterfallSeries.borderWidth);
    // ignore: unnecessary_null_comparison
    if (borderRadius != null) {
      segment.segmentRect =
          getRRectFromRect(currentPoint.region!, borderRadius);
    }
    segmentProperties.segmentRect = segment.segmentRect;
    customizeSegment(segment);
    seriesRendererDetails.segments.add(segment);
    return segment;
  }

  /// To render waterfall series segments.
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
  WaterfallSegment createSegment() => WaterfallSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final WaterfallSegment waterfallSegment = segment as WaterfallSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    segmentProperties.color =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .seriesColor;
    segmentProperties.negativePointsColor =
        _waterfallSeries.negativePointsColor;
    segmentProperties.intermediateSumColor =
        _waterfallSeries.intermediateSumColor;
    segmentProperties.totalSumColor = _waterfallSeries.totalSumColor;
    segmentProperties.strokeColor = segmentProperties.series.borderColor;
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
    waterfallSegment.strokePaint = waterfallSegment.getStrokePaint();
    waterfallSegment.fillPaint = waterfallSegment.getFillPaint();
    waterfallSegment.connectorLineStrokePaint =
        segmentProperties.getConnectorLineStrokePaint();
  }

  /// Draws the marker with different shapes and color of the appropriate data point in the series.
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

/// Represents the waterfall Chart painter
class WaterfallChartPainter extends CustomPainter {
  /// Calling the default constructor of WaterfallChartPainter class.
  WaterfallChartPainter(
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

  /// Specifies the list of current chart location
  List<ChartLocation> currentChartLocations = <ChartLocation>[];

  /// Specifies the Waterfall series renderer
  WaterfallSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for waterfall series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);

    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    final WaterfallSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as WaterfallSeries<dynamic, dynamic>;
    final num origin = math.max(yAxisDetails.visibleRange!.minimum, 0);
    num currentEndValue = 0, intermediateOrigin = 0, prevEndValue = 0;
    num originValue = 0;
    if (seriesRendererDetails.visible! == true) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      Rect axisClipRect;
      double animationFactor;
      CartesianChartPoint<dynamic>? point;
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
      axisClipRect = calculatePlotOffset(stateProperties.chartAxis.axisClipRect,
          Offset(xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesRendererDetails.seriesAnimation != null
          ? seriesRendererDetails.seriesAnimation!.value
          : 1;
      stateProperties.shader = null;
      if (series.onCreateShader != null) {
        stateProperties.shader = series.onCreateShader!(
            ShaderDetails(stateProperties.chartAxis.axisClipRect, 'series'));
      }
      int segmentIndex = -1;
      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }

      seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        currentEndValue +=
            (point.isIntermediateSum! || point.isTotalSum!) ? 0 : point.yValue;
        point.yValue =
            point.y = point.isTotalSum! ? currentEndValue : point.yValue;
        originValue = (point.isIntermediateSum ?? false)
            ? intermediateOrigin
            // ignore: unnecessary_null_comparison
            : ((prevEndValue != null) ? prevEndValue : origin);
        originValue = point.isTotalSum! ? 0 : originValue;
        point.yValue = point.y = point.isIntermediateSum!
            ? currentEndValue - originValue
            : point.yValue;
        point.endValue = currentEndValue;
        point.originValue = originValue;
        seriesRendererDetails.calculateRegionData(stateProperties,
            seriesRendererDetails, painterKey.index, point, pointIndex);
        if (renderingDetails.templates.isNotEmpty &&
            pointIndex < renderingDetails.templates.length) {
          renderingDetails.templates[pointIndex].location =
              Offset(point.markerPoint!.x, point.markerPoint!.y);
        }
        if (point.isVisible && !point.isGap) {
          seriesRendererDetails.drawSegment(
              canvas,
              seriesRenderer._createSegments(
                  point, segmentIndex += 1, painterKey.index, animationFactor));
        }
        if (point.isIntermediateSum!) {
          intermediateOrigin = currentEndValue;
        }
        prevEndValue = currentEndValue;
      }
      _drawSeries(canvas, animationFactor, seriesRendererDetails);
    }
  }

  ///Draw series elements and add cliprect
  void _drawSeries(Canvas canvas, double animationFactor,
      SeriesRendererDetails seriesRendererDetails) {
    final WaterfallSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as WaterfallSeries<dynamic, dynamic>;
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
          'The waterfall series should be available to render a marker on it.');
      canvas.clipRect(clipRect);
      seriesRendererDetails.renderSeriesElements(
          chart, canvas, seriesRendererDetails.seriesElementAnimation);
    }
    if (animationFactor >= 1) {
      stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
    }
  }

  @override
  bool shouldRepaint(WaterfallChartPainter oldDelegate) => isRepaint;
}
