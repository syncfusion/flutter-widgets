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

/// Creates series renderer for spline range area series.
class SplineRangeAreaSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of SplineRangeAreaSeriesRenderer class.
  SplineRangeAreaSeriesRenderer();

  /// Spline range area segment is created here.
  ChartSegment _createSegments(int seriesIndex, SfCartesianChart chart,
      double animateFactor, Path path, Path strokePath,
      [List<Offset>? points]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final SplineRangeAreaSegment segment = createSegment();
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(seriesRendererDetails.stateProperties, segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
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
      segmentProperties.oldSegmentIndex = 0;

      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      seriesRendererDetails.segments.add(segment);
    }
    return segment;
  }

  /// To render spline range area series segments.
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
              seriesRendererDetails.segments[0], seriesRendererDetails.chart);
    }
    segment.onPaint(canvas);
  }

  @override
  SplineRangeAreaSegment createSegment() => SplineRangeAreaSegment();

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
    canvas.drawPath(seriesRendererDetails.markerShapes2[index]!, fillPaint);
    canvas.drawPath(seriesRendererDetails.markerShapes[index]!, strokePaint);
    canvas.drawPath(seriesRendererDetails.markerShapes2[index]!, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}

/// Represents the SplineRangeArea Chart painter
class SplineRangeAreaChartPainter extends CustomPainter {
  /// Calling the default constructor of SplineRangeAreaChartPainter class.
  SplineRangeAreaChartPainter(
      {required this.stateProperties,
      required this.isRepaint,
      required this.animationController,
      required ValueNotifier<num> notifier,
      required this.painterKey,
      required this.seriesRenderer})
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

  /// Specifies the Spline range area series renderer
  final SplineRangeAreaSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for spline range area series
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    ChartLocation? currentPointLow, currentPointHigh, oldPointLow, oldPointHigh;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);

    final int pointsLength = seriesRendererDetails.dataPoints.length;
    CartesianChartPoint<dynamic>? prevPoint, point, oldChartPoint;
    final Path path = Path();
    final Path strokePath = Path();
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    CartesianSeriesRenderer? oldSeriesRenderer;

    final List<Offset> points = <Offset>[];
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        seriesRendererDetails.stateProperties.oldSeriesRenderers;
    double? currentPointLowX,
        currentPointLowY,
        currentPointHighX,
        currentPointHighY,
        startControlX,
        startControlY,
        endControlX,
        endControlY;
    seriesRendererDetails.drawHighControlPoints.clear();
    seriesRendererDetails.drawLowControlPoints.clear();

    // Clip rect will be added for series.
    if (seriesRendererDetails.visible! == true) {
      canvas.save();
      final int seriesIndex = painterKey.index;

      oldSeriesRenderer = getOldSeriesRenderer(stateProperties,
          seriesRendererDetails, seriesIndex, oldSeriesRenderers);

      seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
      final bool isTransposed = stateProperties.requireInvertedAxis;
      final SplineRangeAreaSeries<dynamic, dynamic> series =
          seriesRendererDetails.series
              as SplineRangeAreaSeries<dynamic, dynamic>;
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      SplineRangeAreaSegment splineRangeAreaSegment;
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
      for (int pointIndex = 0; pointIndex < pointsLength; pointIndex++) {
        point = seriesRendererDetails.dataPoints[pointIndex];
        seriesRendererDetails.calculateRegionData(stateProperties,
            seriesRendererDetails, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          oldChartPoint = getOldChartPoint(
              stateProperties,
              seriesRendererDetails,
              SplineRangeAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);

          oldPointHigh = (oldChartPoint != null)
              ? calculatePoint(
                  oldChartPoint.xValue,
                  oldChartPoint.high,
                  seriesRendererDetails.xAxisDetails!,
                  seriesRendererDetails.yAxisDetails!,
                  isTransposed,
                  series,
                  axisClipRect)
              : null;
          currentPointLow = calculatePoint(point.xValue, point.low,
              xAxisDetails, yAxisDetails, isTransposed, series, axisClipRect);
          currentPointHigh = calculatePoint(point.xValue, point.high,
              xAxisDetails, yAxisDetails, isTransposed, series, axisClipRect);
          points.add(Offset(currentPointLow.x, currentPointLow.y));
          points.add(Offset(currentPointHigh.x, currentPointHigh.y));

          currentPointLowX = currentPointLow.x;
          currentPointLowY = currentPointLow.y;

          if (oldPointHigh != null) {
            if (isTransposed) {
              currentPointHighX = getAnimateValue(
                  animationFactor,
                  currentPointHighX,
                  oldPointHigh.x,
                  currentPointHigh.x,
                  seriesRendererDetails);
              currentPointHighY = currentPointHigh.y;
            } else {
              currentPointHighX = currentPointHigh.x;
              currentPointHighY = getAnimateValue(
                  animationFactor,
                  currentPointHighY,
                  oldPointHigh.y,
                  currentPointHigh.y,
                  seriesRendererDetails);
            }
            if (point.highStartControl != null) {
              startControlX = getAnimateValue(
                  animationFactor,
                  startControlX,
                  oldChartPoint!.highStartControl!.x,
                  point.highStartControl!.x,
                  seriesRendererDetails);
              startControlY = getAnimateValue(
                  animationFactor,
                  startControlY,
                  oldChartPoint.highStartControl!.y,
                  point.highStartControl!.y,
                  seriesRendererDetails);
            } else {
              startControlX = startControlY = null;
            }
            if (point.highEndControl != null) {
              endControlX = getAnimateValue(
                  animationFactor,
                  endControlX,
                  oldChartPoint!.highEndControl!.x,
                  point.highEndControl!.x,
                  seriesRendererDetails);
              endControlY = getAnimateValue(
                  animationFactor,
                  endControlY,
                  oldChartPoint.highEndControl!.y,
                  point.highEndControl!.y,
                  seriesRendererDetails);
            } else {
              endControlX = endControlY = null;
            }
          } else {
            currentPointHighX = currentPointHigh.x;
            currentPointHighY = currentPointHigh.y;
            startControlX = point.highStartControl?.x;
            startControlY = point.highStartControl?.y;
            endControlX = point.highEndControl?.x;
            endControlY = point.highEndControl?.y;
          }
          // if (pointIndex == 3) print('$startControlX -- $startControlY,,,,$endControlX -- $endControlY');
          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            path.moveTo(currentPointLowX, currentPointLowY);
            path.lineTo(currentPointHighX, currentPointHighY);
            strokePath.moveTo(currentPointHighX, currentPointHighY);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            path.cubicTo(startControlX!, startControlY!, endControlX!,
                endControlY!, currentPointHighX, currentPointHighY);

            strokePath.cubicTo(startControlX, startControlY, endControlX,
                endControlY, currentPointHighX, currentPointHighY);

            path.lineTo(currentPointLowX, currentPointLowY);

            strokePath.lineTo(currentPointHighX, currentPointHighY);
            strokePath.moveTo(currentPointLowX, currentPointLowY);
          } else {
            path.cubicTo(startControlX!, startControlY!, endControlX!,
                endControlY!, currentPointHighX, currentPointHighY);

            strokePath.cubicTo(startControlX, startControlY, endControlX,
                endControlY, currentPointHighX, currentPointHighY);
          }

          prevPoint = point;
        }
        if (pointIndex >= dataPoints.length - 1) {
          seriesRenderer._createSegments(painterKey.index, chart,
              animationFactor, path, strokePath, points);
        }
      }

      for (int pointIndex = dataPoints.length - 2;
          pointIndex >= 0;
          pointIndex--) {
        point = dataPoints[pointIndex];
        if (point.isVisible && !point.isDrop) {
          oldChartPoint = getOldChartPoint(
              stateProperties,
              seriesRendererDetails,
              SplineRangeAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          if (oldChartPoint != null) {
            oldPointLow = calculatePoint(
                oldChartPoint.xValue,
                oldChartPoint.low,
                seriesRendererDetails.xAxisDetails!,
                seriesRendererDetails.yAxisDetails!,
                isTransposed,
                series,
                axisClipRect);
          } else {
            oldPointLow = null;
          }
          currentPointLow = calculatePoint(point.xValue, point.low,
              xAxisDetails, yAxisDetails, isTransposed, series, axisClipRect);
          currentPointHigh = calculatePoint(point.xValue, point.high,
              xAxisDetails, yAxisDetails, isTransposed, series, axisClipRect);

          if (oldPointLow != null) {
            if (isTransposed) {
              currentPointLowX = getAnimateValue(
                  animationFactor,
                  currentPointLowX,
                  oldPointLow.x,
                  currentPointLow.x,
                  seriesRendererDetails);
              currentPointLowY = currentPointLow.y;
            } else {
              currentPointLowX = currentPointLow.x;
              currentPointLowY = getAnimateValue(
                  animationFactor,
                  currentPointLowY,
                  oldPointLow.y,
                  currentPointLow.y,
                  seriesRendererDetails);
            }
            if (point.lowStartControl != null) {
              startControlX = getAnimateValue(
                  animationFactor,
                  startControlX,
                  oldChartPoint!.lowStartControl!.x,
                  point.lowStartControl!.x,
                  seriesRendererDetails);
              startControlY = getAnimateValue(
                  animationFactor,
                  startControlY,
                  oldChartPoint.lowStartControl!.y,
                  point.lowStartControl!.y,
                  seriesRendererDetails);
            } else {
              startControlX = startControlY = null;
            }
            if (point.lowEndControl != null) {
              endControlX = getAnimateValue(
                  animationFactor,
                  endControlX,
                  oldChartPoint!.lowEndControl!.x,
                  point.lowEndControl!.x,
                  seriesRendererDetails);
              endControlY = getAnimateValue(
                  animationFactor,
                  endControlY,
                  oldChartPoint.lowEndControl!.y,
                  point.lowEndControl!.y,
                  seriesRendererDetails);
            } else {
              endControlX = endControlY = null;
            }
          } else {
            currentPointLowX = currentPointLow.x;
            currentPointLowY = currentPointLow.y;
            startControlX = point.lowStartControl?.x;
            startControlY = point.lowStartControl?.y;
            endControlX = point.lowEndControl?.x;
            endControlY = point.lowEndControl?.y;
          }

          if (dataPoints[pointIndex + 1].isGap == true) {
            strokePath.moveTo(currentPointLowX, currentPointLowY);
            path.moveTo(currentPointLowX, currentPointLowY);
          } else if (dataPoints[pointIndex].isGap != true) {
            (pointIndex + 1 == dataPoints.length - 1 &&
                    dataPoints[pointIndex + 1].isDrop)
                ? strokePath.moveTo(currentPointLowX, currentPointLowY)
                : strokePath.cubicTo(endControlX!, endControlY!, startControlX!,
                    startControlY!, currentPointLowX, currentPointLowY);

            path.cubicTo(endControlX!, endControlY!, startControlX!,
                startControlY!, currentPointLowX, currentPointLowY);
          }
        }
      }

      /// Draw the spline range area series
      // ignore: unnecessary_null_comparison
      if (path != null &&
          // ignore: unnecessary_null_comparison
          seriesRendererDetails.segments.isNotEmpty) {
        splineRangeAreaSegment =
            seriesRendererDetails.segments[0] as SplineRangeAreaSegment;
        final SegmentProperties segmentProperties =
            SegmentHelper.getSegmentProperties(splineRangeAreaSegment);
        segmentProperties.path = path;
        segmentProperties.strokePath = strokePath;
        seriesRendererDetails.drawSegment(canvas, splineRangeAreaSegment);
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
            'The spline range area series should be available to render a marker on it.');
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
  bool shouldRepaint(SplineRangeAreaChartPainter oldDelegate) => isRepaint;
}
