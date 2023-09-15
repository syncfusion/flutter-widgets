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

/// Creates series renderer for spline area series.
class SplineAreaSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of SplineAreaSeriesRenderer class.
  SplineAreaSeriesRenderer();

  /// Spline area segment is created here.
  ChartSegment _createSegments(int seriesIndex, SfCartesianChart chart,
      double animateFactor, Path path, Path strokePath,
      [List<Offset>? points]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final SplineAreaSegment segment = createSegment();
    final SegmentProperties segmentProperties =
        SegmentProperties(seriesRendererDetails.stateProperties, segment);
    seriesRendererDetails.isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segmentProperties.seriesIndex = seriesIndex;
      segment.currentSegmentIndex = 0;
      segment.animationFactor = animateFactor;
      segmentProperties.series =
          seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
      segmentProperties.seriesRenderer = this;
      if (points != null) {
        segment.points = points;
      }
      segmentProperties.path = path;
      segmentProperties.strokePath = strokePath;
      SegmentHelper.setSegmentProperties(segment, segmentProperties);
      customizeSegment(segment);
      segmentProperties.oldSegmentIndex = 0;
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      seriesRendererDetails.segments.add(segment);
    }
    return segment;
  }

  /// To render spline area series segments.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final SeriesRendererDetails currentDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (currentDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          currentDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              seriesRendererDetails.segments[0], seriesRendererDetails.chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  SplineAreaSegment createSegment() => SplineAreaSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
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

/// Represents the SplineArea Chart painter
class SplineAreaChartPainter extends CustomPainter {
  /// Calling the default constructor of SplineAreaChartPainter class.
  SplineAreaChartPainter(
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

  /// Specifies the spline area series renderer
  final SplineAreaSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for spline area series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    CartesianChartPoint<dynamic>? prevPoint, point, oldChartPoint;
    CartesianSeriesRenderer? oldSeriesRenderer;
    SeriesRendererDetails? oldSeriesRendererDetails;
    ChartLocation? currentPoint, originPoint, oldPointLocation;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);

    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    Rect clipRect;
    final SplineAreaSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as SplineAreaSeries<dynamic, dynamic>;
    if (seriesRendererDetails.hasDataLabelTemplate == false) {
      seriesRendererDetails.drawControlPoints.clear();
    }
    final Path path = Path();
    final Path strokePath = Path();
    final List<Offset> points = <Offset>[];
    final num? crossesAt = getCrossesAtValue(seriesRenderer, stateProperties);
    final num origin = crossesAt ?? 0;
    double? startControlX, startControlY, endControlX, endControlY;
    if (seriesRendererDetails.visible! == true) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      final List<CartesianSeriesRenderer> oldSeriesRenderers =
          stateProperties.oldSeriesRenderers;
      final List<CartesianChartPoint<dynamic>> dataPoints =
          seriesRendererDetails.dataPoints;
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
      final bool isTransposed =
          seriesRendererDetails.stateProperties.requireInvertedAxis;
      final Rect axisClipRect = calculatePlotOffset(
          stateProperties.chartAxis.axisClipRect,
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
      oldSeriesRenderer = getOldSeriesRenderer(stateProperties,
          seriesRendererDetails, seriesIndex, oldSeriesRenderers);

      oldSeriesRendererDetails = oldSeriesRenderer == null
          ? null
          : SeriesHelper.getSeriesRendererDetails(oldSeriesRenderer);

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
        if (point.isVisible && !point.isDrop) {
          //Stores the old data point details of the corresponding point index
          oldChartPoint = getOldChartPoint(
              stateProperties,
              seriesRendererDetails,
              SplineAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          oldPointLocation = oldChartPoint != null
              ? calculatePoint(
                  oldChartPoint.xValue,
                  oldChartPoint.yValue,
                  oldSeriesRendererDetails!.xAxisDetails!,
                  oldSeriesRendererDetails.yAxisDetails!,
                  isTransposed,
                  oldSeriesRendererDetails.series,
                  axisClipRect)
              : null;
          currentPoint = calculatePoint(point.xValue, point.yValue,
              xAxisDetails, yAxisDetails, isTransposed, series, axisClipRect);
          originPoint = calculatePoint(
              point.xValue,
              math_lib.max(yAxisDetails.visibleRange!.minimum, origin),
              xAxisDetails,
              yAxisDetails,
              isTransposed,
              series,
              axisClipRect);
          double x = currentPoint.x;
          double y = currentPoint.y;
          startControlX = startControlY = endControlX = endControlY = null;
          points.add(Offset(currentPoint.x, currentPoint.y));
          final bool closed =
              series.emptyPointSettings.mode == EmptyPointMode.drop &&
                  _getSeriesVisibility(dataPoints, pointIndex);

          //calculates animation values for control points and data points
          if (oldPointLocation != null) {
            isTransposed
                ? x = getAnimateValue(animationFactor, x, oldPointLocation.x,
                    currentPoint.x, seriesRendererDetails)
                : y = getAnimateValue(animationFactor, y, oldPointLocation.y,
                    currentPoint.y, seriesRendererDetails);
            if (point.startControl != null) {
              startControlY = getAnimateValue(
                  animationFactor,
                  startControlY,
                  oldChartPoint!.startControl!.y,
                  point.startControl!.y,
                  seriesRendererDetails);
              startControlX = getAnimateValue(
                  animationFactor,
                  startControlX,
                  oldChartPoint.startControl!.x,
                  point.startControl!.x,
                  seriesRendererDetails);
            }
            if (point.endControl != null) {
              endControlX = getAnimateValue(
                  animationFactor,
                  endControlX,
                  oldChartPoint!.endControl!.x,
                  point.endControl!.x,
                  seriesRendererDetails);
              endControlY = getAnimateValue(
                  animationFactor,
                  endControlY,
                  oldChartPoint.endControl!.y,
                  point.endControl!.y,
                  seriesRendererDetails);
            }
          } else {
            if (point.startControl != null) {
              startControlX = point.startControl!.x;
              startControlY = point.startControl!.y;
            }
            if (point.endControl != null) {
              endControlX = point.endControl!.x;
              endControlY = point.endControl!.y;
            }
          }

          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            path.moveTo(originPoint.x, originPoint.y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom ||
                series.borderDrawMode == BorderDrawMode.all) {
              if (dataPoints[pointIndex].isGap != true) {
                strokePath.moveTo(originPoint.x, originPoint.y);
                strokePath.lineTo(x, y);
              }
            } else if (series.borderDrawMode == BorderDrawMode.top) {
              strokePath.moveTo(x, y);
            }
            path.lineTo(x, y);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            strokePath.cubicTo(startControlX!, startControlY!, endControlX!,
                endControlY!, x, y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
              strokePath.lineTo(originPoint.x, originPoint.y);
            } else if (series.borderDrawMode == BorderDrawMode.all) {
              strokePath.lineTo(originPoint.x, originPoint.y);
              strokePath.close();
            }
            path.cubicTo(
                startControlX, startControlY, endControlX, endControlY, x, y);
            path.lineTo(originPoint.x, originPoint.y);
          } else {
            strokePath.cubicTo(startControlX!, startControlY!, endControlX!,
                endControlY!, x, y);
            path.cubicTo(
                startControlX, startControlY, endControlX, endControlY, x, y);

            if (closed) {
              path.cubicTo(startControlX, startControlY, endControlX,
                  endControlY, originPoint.x, originPoint.y);
              if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
                strokePath.lineTo(originPoint.x, originPoint.y);
              } else if (series.borderDrawMode == BorderDrawMode.all) {
                strokePath.cubicTo(startControlX, startControlY, endControlX,
                    endControlY, originPoint.x, originPoint.y);
                strokePath.close();
              }
            }
          }
          prevPoint = point;
        }
      }
      // ignore: unnecessary_null_comparison
      if (path != null) {
        seriesRenderer._drawSegment(
            canvas,
            seriesRenderer._createSegments(
                painterKey.index, chart, animationFactor, path, strokePath));
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
              !renderingDetails.initialRender! ||
              animationFactor >= stateProperties.seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The spline area series should be available to render a marker on it.');
        canvas.clipRect(clipRect);
        seriesRendererDetails.renderSeriesElements(
            chart, canvas, seriesRendererDetails.seriesElementAnimation);
      }
      if (animationFactor >= 1) {
        stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(SplineAreaChartPainter oldDelegate) => isRepaint;

  /// It returns the visibility of area series
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
