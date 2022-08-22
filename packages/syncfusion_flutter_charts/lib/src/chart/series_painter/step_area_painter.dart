import 'dart:math' as math_lib;

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
import '../utils/helper.dart';

/// Creates series renderer for step area series.
class StepAreaSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of StepAreaSeriesRenderer class.
  StepAreaSeriesRenderer();

  /// Step area segment is created here.
  ChartSegment _createSegments(
      Path path, Path strokePath, int seriesIndex, double animateFactor,
      [List<Offset>? points]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final StepAreaSegment segment = createSegment();
    final SegmentProperties segmentProperties =
        SegmentProperties(seriesRendererDetails.stateProperties, segment);
    SegmentHelper.setSegmentProperties(segment, segmentProperties);
    seriesRendererDetails.isRectSeries = false;
    segmentProperties.path = path;
    segmentProperties.strokePath = strokePath;
    segmentProperties.seriesIndex = seriesIndex;
    segment.currentSegmentIndex = 0;
    segmentProperties.seriesRenderer = this;
    segmentProperties.series =
        seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
    if (points != null) {
      segment.points = points;
    }
    segment.animationFactor = animateFactor;
    segment.calculateSegmentPoints();
    segmentProperties.oldSegmentIndex = 0;
    customizeSegment(segment);
    segment.strokePaint = segment.getStrokePaint();
    segment.fillPaint = segment.getFillPaint();
    seriesRendererDetails.segments.add(segment);
    return segment;
  }

  /// To render step area series segments.
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
              seriesRendererDetails.segments[0], seriesRendererDetails.chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  StepAreaSegment createSegment() => StepAreaSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    segmentProperties.color = seriesRendererDetails.seriesColor;
    segmentProperties.strokeColor = segmentProperties.series.borderColor;
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
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

/// Represents the Step area chart painter
class StepAreaChartPainter extends CustomPainter {
  /// Calling the default constructor of StepAreaChartPainter class.
  StepAreaChartPainter(
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

  /// Specifies the Step area series renderer
  final StepAreaSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for step area series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    CartesianChartPoint<dynamic>? prevPoint, point, oldChartPoint;
    ChartLocation? currentPoint,
        originPoint,
        previousPoint,
        oldPoint,
        prevOldPoint;
    CartesianSeriesRenderer? oldSeriesRenderer;
    late SeriesRendererDetails oldSeriesRendererDetails;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);

    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        seriesRendererDetails.stateProperties.oldSeriesRenderers;
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final StepAreaSeries<dynamic, dynamic> stepAreaSeries =
        seriesRendererDetails.series as StepAreaSeries<dynamic, dynamic>;
    final Path path = Path(), strokePath = Path();
    final List<Offset> points = <Offset>[];
    final num? crossesAt = getCrossesAtValue(seriesRenderer, stateProperties);
    final num origin = crossesAt ?? 0;

    /// Clip rect will be added for series.
    if (seriesRendererDetails.visible! == true) {
      assert(
          // ignore: unnecessary_null_comparison
          !(stepAreaSeries.animationDuration != null) ||
              stepAreaSeries.animationDuration >= 0,
          'The animation duration of the step area series must be greater or equal to 0.');
      canvas.save();
      final List<CartesianChartPoint<dynamic>> dataPoints =
          seriesRendererDetails.dataPoints;
      final int seriesIndex = painterKey.index;
      final StepAreaSeries<dynamic, dynamic> series =
          seriesRendererDetails.series as StepAreaSeries<dynamic, dynamic>;
      final Rect axisClipRect = calculatePlotOffset(
          stateProperties.chartAxis.axisClipRect,
          Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
              seriesRendererDetails.yAxisDetails!.axis.plotOffset));
      canvas.clipRect(axisClipRect);

      oldSeriesRenderer = getOldSeriesRenderer(stateProperties,
          seriesRendererDetails, seriesIndex, oldSeriesRenderers);

      if (oldSeriesRenderer != null) {
        oldSeriesRendererDetails =
            SeriesHelper.getSeriesRendererDetails(oldSeriesRenderer);
      }

      seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
      animationFactor = seriesRendererDetails.seriesAnimation != null
          ? seriesRendererDetails.seriesAnimation!.value
          : 1;
      stateProperties.shader = null;
      if (series.onCreateShader != null) {
        stateProperties.shader = series.onCreateShader!(
            ShaderDetails(stateProperties.chartAxis.axisClipRect, 'series'));
      }
      if (seriesRendererDetails.reAnimate == true ||
          ((!(renderingDetails.widgetNeedUpdate ||
                      renderingDetails.isLegendToggled) ||
                  !stateProperties.oldSeriesKeys
                      .contains(seriesRendererDetails.series.key)) &&
              (seriesRendererDetails.series.animationDuration > 0) == true)) {
        performLinearAnimation(stateProperties,
            seriesRendererDetails.xAxisDetails!.axis, canvas, animationFactor);
      }

      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }

      seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRendererDetails.calculateRegionData(stateProperties,
            seriesRendererDetails, painterKey.index, point, pointIndex);
        if (point.isVisible) {
          oldChartPoint = getOldChartPoint(
              stateProperties,
              seriesRendererDetails,
              StepAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          oldPoint = oldChartPoint != null
              ? calculatePoint(
                  oldChartPoint.xValue,
                  oldChartPoint.yValue,
                  oldSeriesRendererDetails.xAxisDetails!,
                  oldSeriesRendererDetails.yAxisDetails!,
                  chart.isTransposed,
                  oldSeriesRendererDetails.series,
                  axisClipRect)
              : null;
          currentPoint = calculatePoint(
              point.xValue,
              point.yValue,
              xAxisDetails,
              yAxisDetails,
              seriesRendererDetails.stateProperties.requireInvertedAxis,
              series,
              axisClipRect);
          previousPoint = prevPoint != null
              ? calculatePoint(
                  prevPoint.xValue,
                  prevPoint.yValue,
                  xAxisDetails,
                  yAxisDetails,
                  seriesRendererDetails.stateProperties.requireInvertedAxis,
                  series,
                  axisClipRect)
              : null;
          originPoint = calculatePoint(
              point.xValue,
              math_lib.max(yAxisDetails.visibleRange!.minimum, origin),
              xAxisDetails,
              yAxisDetails,
              seriesRendererDetails.stateProperties.requireInvertedAxis,
              series,
              axisClipRect);
          points.add(Offset(currentPoint.x, currentPoint.y));
          _drawStepAreaPath(
              path,
              strokePath,
              prevPoint,
              currentPoint,
              originPoint,
              previousPoint,
              oldPoint,
              prevOldPoint,
              pointIndex,
              animationFactor,
              stepAreaSeries,
              seriesRendererDetails);
          prevPoint = point;
          prevOldPoint = oldPoint;
        }
      }
      // ignore: unnecessary_null_comparison
      if (path != null && strokePath != null) {
        seriesRenderer._drawSegment(
            canvas,
            seriesRenderer._createSegments(
                path, strokePath, painterKey.index, animationFactor, points));
      }
      _drawSeries(canvas, animationFactor, seriesRendererDetails);
    }
  }

  ///Draw series elements and add cliprect
  void _drawSeries(Canvas canvas, double animationFactor,
      SeriesRendererDetails seriesRendererDetails) {
    final StepAreaSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as StepAreaSeries<dynamic, dynamic>;
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
            !stateProperties.renderingDetails.initialRender! ||
            animationFactor >= stateProperties.seriesDurationFactor) &&
        (series.markerSettings.isVisible ||
            series.dataLabelSettings.isVisible)) {
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'The step area series should be available to render a marker on it.');
      canvas.clipRect(clipRect);
      seriesRendererDetails.renderSeriesElements(
          chart, canvas, seriesRendererDetails.seriesElementAnimation);
    }
    if (animationFactor >= 1) {
      stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
    }
  }

  @override
  bool shouldRepaint(StepAreaChartPainter oldDelegate) => isRepaint;

  /// To draw the step area path
  void _drawStepAreaPath(
      Path path,
      Path strokePath,
      CartesianChartPoint<dynamic>? prevPoint,
      ChartLocation currentPoint,
      ChartLocation originPoint,
      ChartLocation? previousPoint,
      ChartLocation? oldPoint,
      ChartLocation? prevOldPoint,
      int pointIndex,
      double animationFactor,
      StepAreaSeries<dynamic, dynamic> stepAreaSeries,
      SeriesRendererDetails seriesRendererDetails) {
    double x = currentPoint.x;
    double y = currentPoint.y;
    double? previousPointY = previousPoint?.y;
    final bool closed =
        stepAreaSeries.emptyPointSettings.mode == EmptyPointMode.drop &&
            _getSeriesVisibility(seriesRendererDetails.dataPoints, pointIndex);
    if (oldPoint != null) {
      if (stateProperties.chart.isTransposed) {
        x = getAnimateValue(animationFactor, x, oldPoint.x, currentPoint.x,
            seriesRendererDetails);
      } else {
        y = getAnimateValue(animationFactor, y, oldPoint.y, currentPoint.y,
            seriesRendererDetails);
        previousPointY = previousPointY != null
            ? getAnimateValue(animationFactor, previousPointY, prevOldPoint?.y,
                previousPoint?.y, seriesRendererDetails)
            : previousPointY;
      }
    }
    if (prevPoint == null ||
        seriesRendererDetails.dataPoints[pointIndex - 1].isGap == true ||
        (seriesRendererDetails.dataPoints[pointIndex].isGap == true) ||
        (seriesRendererDetails.dataPoints[pointIndex - 1].isVisible == false &&
            stepAreaSeries.emptyPointSettings.mode == EmptyPointMode.gap)) {
      path.moveTo(originPoint.x, originPoint.y);
      if (stepAreaSeries.borderDrawMode == BorderDrawMode.excludeBottom) {
        if (seriesRendererDetails.dataPoints[pointIndex].isGap != true) {
          strokePath.moveTo(originPoint.x, originPoint.y);
          strokePath.lineTo(x, y);
        }
      } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.all) {
        if (seriesRendererDetails.dataPoints[pointIndex].isGap != true) {
          strokePath.moveTo(originPoint.x, originPoint.y);
          strokePath.lineTo(x, y);
        }
      } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.top) {
        strokePath.moveTo(x, y);
      }
      path.lineTo(x, y);
    } else if (pointIndex == seriesRendererDetails.dataPoints.length - 1 ||
        seriesRendererDetails.dataPoints[pointIndex + 1].isGap == true) {
      strokePath.lineTo(x, previousPointY!);
      strokePath.lineTo(x, y);
      if (stepAreaSeries.borderDrawMode == BorderDrawMode.excludeBottom) {
        strokePath.lineTo(originPoint.x, originPoint.y);
      } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.all) {
        strokePath.lineTo(originPoint.x, originPoint.y);
        strokePath.close();
      }
      path.lineTo(x, previousPointY);
      path.lineTo(x, y);
      path.lineTo(originPoint.x, originPoint.y);
    } else {
      path.lineTo(x, previousPointY!);
      strokePath.lineTo(x, previousPointY);
      strokePath.lineTo(x, y);
      path.lineTo(x, y);
      if (closed) {
        path.lineTo(originPoint.x, originPoint.y);
        if (stepAreaSeries.borderDrawMode == BorderDrawMode.excludeBottom) {
          strokePath.lineTo(originPoint.x, originPoint.y);
        } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.all) {
          strokePath.lineTo(originPoint.x, originPoint.y);
          strokePath.close();
        }
      }
    }
  }

  /// To find the visibility of a series
  bool _getSeriesVisibility(
      List<CartesianChartPoint<dynamic>> points, int index) {
    for (int i = index; i < points.length - 1; i++) {
      if (!points[i + 1].isDrop) {
        return false;
      }
    }
    return true;
  }
}
