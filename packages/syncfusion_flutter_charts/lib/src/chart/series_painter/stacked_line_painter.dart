import 'package:flutter/material.dart';
import '../../../charts.dart';

import '../../common/rendering_details.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/stacked_series_base.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for stacked line series.
class StackedLineSeriesRenderer extends StackedSeriesRenderer {
  /// Calling the default constructor of StackedLineSeriesRenderer class.
  StackedLineSeriesRenderer();

  /// Stacked line segment is created here.
  // ignore: unused_element
  ChartSegment _createSegments(
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> nextPoint,
      int pointIndex,
      int seriesIndex,
      double animationFactor,
      double currentCummulativePos,
      double nextCummulativePos) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final StackedLineSegment segment = createSegment();
    final SegmentProperties segmentProperties =
        SegmentProperties(seriesRendererDetails.stateProperties, segment);
    SegmentHelper.setSegmentProperties(segment, segmentProperties);
    final List<CartesianSeriesRenderer>? oldSeriesRenderers =
        seriesRendererDetails.stateProperties.oldSeriesRenderers;
    seriesRendererDetails.isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segmentProperties.seriesRenderer = this;
      segmentProperties.series =
          seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
      segmentProperties.seriesIndex = seriesIndex;
      segmentProperties.currentPoint = currentPoint;
      segment.currentSegmentIndex = pointIndex;
      segmentProperties.nextPoint = nextPoint;
      segment.animationFactor = animationFactor;
      segmentProperties.pointColorMapper = currentPoint.pointColorMapper;
      segmentProperties.currentCummulativePos = currentCummulativePos;
      segmentProperties.nextCummulativePos = nextCummulativePos;
      if (seriesRendererDetails
                  .stateProperties.renderingDetails.widgetNeedUpdate ==
              true &&
          seriesRendererDetails.xAxisDetails!.zoomFactor == 1 &&
          seriesRendererDetails.yAxisDetails!.zoomFactor == 1 &&
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
        SegmentHelper.setSegmentProperties(segment, segmentProperties);
        segmentProperties.oldSegmentIndex = getOldSegmentIndex(segment);
      }
      segment.calculateSegmentPoints();
      final SegmentProperties currentSegmentProperties =
          SegmentHelper.getSegmentProperties(segment);
      segment.points.add(
          Offset(currentSegmentProperties.x1, currentSegmentProperties.y1));
      segment.points.add(
          Offset(currentSegmentProperties.x2, currentSegmentProperties.y2));
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      seriesRendererDetails.segments.add(segment);
    }
    return segment;
  }

  /// To render stacked line series segments.
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
  StackedLineSegment createSegment() => StackedLineSegment();

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

/// Represents the stacked line chart painter
class StackedLineChartPainter extends CustomPainter {
  /// Calling the default constructor of StackedLineChartPainter class.
  StackedLineChartPainter(
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

  /// Specifies the StacledLine series renderer
  final StackedLineSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for stacked line series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Clearing the old chart segments objects with a dispose call.
    disposeOldSegments(chart, seriesRendererDetails);
    _stackedLinePainter(
        canvas,
        seriesRenderer,
        seriesRendererDetails,
        seriesRendererDetails.seriesAnimation,
        stateProperties,
        seriesRendererDetails.seriesElementAnimation!,
        painterKey);
  }

  @override
  bool shouldRepaint(StackedLineChartPainter oldDelegate) => isRepaint;
}

/// Creates series renderer for Stacked line 100 series
class StackedLine100SeriesRenderer extends StackedSeriesRenderer {
  /// Calling the default constructor of StackedLine100SeriesRenderer class.
  StackedLine100SeriesRenderer();

  ///Stacked line segment is created here
  // ignore: unused_element
  ChartSegment _createSegments(
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> nextPoint,
      int pointIndex,
      int seriesIndex,
      double animationFactor,
      double currentCummulativePos,
      double nextCummulativePos) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final StackedLine100Segment segment = createSegment();
    final SegmentProperties segmentProperties =
        SegmentProperties(seriesRendererDetails.stateProperties, segment);
    SegmentHelper.setSegmentProperties(segment, segmentProperties);
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        seriesRendererDetails.stateProperties.oldSeriesRenderers;
    seriesRendererDetails.isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segmentProperties.seriesRenderer = this;
      segmentProperties.series =
          seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
      segmentProperties.seriesIndex = seriesIndex;
      segmentProperties.currentPoint = currentPoint;
      segment.currentSegmentIndex = pointIndex;
      segmentProperties.nextPoint = nextPoint;
      segment.animationFactor = animationFactor;
      segmentProperties.pointColorMapper = currentPoint.pointColorMapper;
      segmentProperties.currentCummulativePos = currentCummulativePos;
      segmentProperties.nextCummulativePos = nextCummulativePos;
      if (seriesRendererDetails
                  .stateProperties.renderingDetails.widgetNeedUpdate ==
              true &&
          seriesRendererDetails.xAxisDetails!.zoomFactor == 1 &&
          seriesRendererDetails.yAxisDetails!.zoomFactor == 1 &&
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
    }
    return segment;
  }

  /// To render stacked line 100 series segments
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
  StackedLine100Segment createSegment() => StackedLine100Segment();

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

  ///Draws marker with different shape and color of the appropriate data point in the series.
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

/// Represents the StackedLine100 Chart painter
class StackedLine100ChartPainter extends CustomPainter {
  /// Calling the default constructor of StackedLine100ChartPainter class.
  StackedLine100ChartPainter(
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

  /// Specifies the StackedLine100 series renderer
  final StackedLine100SeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for stacked line 100 series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);
    _stackedLinePainter(
        canvas,
        seriesRenderer,
        seriesRendererDetails,
        seriesRendererDetails.seriesAnimation,
        stateProperties,
        seriesRendererDetails.seriesElementAnimation!,
        painterKey);
  }

  @override
  bool shouldRepaint(StackedLine100ChartPainter oldDelegate) => isRepaint;
}

/// Painter for stacked line series
void _stackedLinePainter(
    Canvas canvas,
    dynamic seriesRenderer,
    SeriesRendererDetails seriesRendererDetails,
    Animation<double>? seriesAnimation,
    CartesianStateProperties stateProperties,
    Animation<double> chartElementAnimation,
    PainterKey painterKey) {
  Rect clipRect;
  double animationFactor;
  final RenderingDetails renderingDetails = stateProperties.renderingDetails;
  if (seriesRendererDetails.visible! == true) {
    final XyDataSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
    canvas.save();
    animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
    stateProperties.shader = null;
    if (series.onCreateShader != null) {
      stateProperties.shader = series.onCreateShader!(
          ShaderDetails(stateProperties.chartAxis.axisClipRect, 'series'));
    }
    final int seriesIndex = painterKey.index;
    StackedValues? stackedValues;
    seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
    if ((seriesRenderer is StackedLine100SeriesRenderer ||
            seriesRenderer is StackedLineSeriesRenderer) &&
        seriesRendererDetails.stackingValues.isNotEmpty == true) {
      stackedValues = seriesRendererDetails.stackingValues[0];
    }
    final Rect rect =
        seriesRendererDetails.stateProperties.chartAxis.axisClipRect;

    // Clip rect will be added for series.
    final Rect axisClipRect = calculatePlotOffset(
        rect,
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    canvas.clipRect(axisClipRect);
    if (seriesRendererDetails.reAnimate == true ||
        ((!(renderingDetails.widgetNeedUpdate ||
                    renderingDetails.isLegendToggled) ||
                !stateProperties.oldSeriesKeys.contains(series.key)) &&
            series.animationDuration > 0)) {
      performLinearAnimation(stateProperties,
          seriesRendererDetails.xAxisDetails!.axis, canvas, animationFactor);
    }

    int segmentIndex = -1;
    double? currentCummulativePos, nextCummulativePos;
    CartesianChartPoint<dynamic>? startPoint, endPoint, currentPoint, nextPoint;
    if (seriesRendererDetails.visibleDataPoints == null ||
        seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
      seriesRendererDetails.visibleDataPoints =
          <CartesianChartPoint<dynamic>>[];
    }

    seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
    for (int pointIndex = 0;
        pointIndex < seriesRendererDetails.dataPoints.length;
        pointIndex++) {
      currentPoint = seriesRendererDetails.dataPoints[pointIndex];
      bool withInXRange = withInRange(currentPoint.xValue,
          seriesRendererDetails.xAxisDetails!.visibleRange!);
      // ignore: unnecessary_null_comparison
      bool withInYRange = currentPoint != null &&
          currentPoint.yValue != null &&
          withInRange(currentPoint.yValue,
              seriesRendererDetails.yAxisDetails!.visibleRange!);

      bool inRange = withInXRange || withInYRange;
      if (!inRange &&
          pointIndex + 1 < seriesRendererDetails.dataPoints.length) {
        final CartesianChartPoint<dynamic>? nextPoint =
            seriesRendererDetails.dataPoints[pointIndex + 1];
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
              seriesRendererDetails.dataPoints[pointIndex - 1];
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
        seriesRendererDetails.calculateRegionData(stateProperties,
            seriesRendererDetails, seriesIndex, currentPoint, pointIndex);
        if ((currentPoint.isVisible && !currentPoint.isGap) &&
            startPoint == null &&
            stackedValues != null) {
          startPoint = currentPoint;
          currentCummulativePos = stackedValues.endValues[pointIndex];
        }
        if (pointIndex + 1 < seriesRendererDetails.dataPoints.length) {
          nextPoint = seriesRendererDetails.dataPoints[pointIndex + 1];
          if (startPoint != null && nextPoint.isGap) {
            startPoint = null;
          } else if (nextPoint.isVisible &&
              !nextPoint.isGap &&
              stackedValues != null) {
            endPoint = nextPoint;
            nextCummulativePos = stackedValues.endValues[pointIndex + 1];
          }
        }

        if (startPoint != null && endPoint != null) {
          seriesRendererDetails.drawSegment(
              canvas,
              seriesRenderer._createSegments(
                  startPoint,
                  endPoint,
                  segmentIndex += 1,
                  seriesIndex,
                  animationFactor,
                  currentCummulativePos!,
                  nextCummulativePos!));
          endPoint = startPoint = null;
        }
      }
    }
    clipRect = calculatePlotOffset(
        Rect.fromLTRB(
            rect.left - series.markerSettings.width,
            rect.top - series.markerSettings.height,
            rect.right + series.markerSettings.width,
            rect.bottom + series.markerSettings.height),
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    canvas.restore();
    if ((series.animationDuration <= 0 ||
            !renderingDetails.initialRender! ||
            animationFactor >= stateProperties.seriesDurationFactor) &&
        (series.markerSettings.isVisible ||
            series.dataLabelSettings.isVisible)) {
      canvas.clipRect(clipRect);
      seriesRendererDetails.renderSeriesElements(
          stateProperties.chart, canvas, chartElementAnimation);
    }
    if (animationFactor >= 1) {
      stateProperties.setPainterKey(seriesIndex, painterKey.name, true);
    }
  }
}
