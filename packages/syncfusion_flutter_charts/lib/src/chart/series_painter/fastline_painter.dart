import 'package:flutter/material.dart';

import '../../../charts.dart';
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

/// Creates series renderer for fastline series.
class FastLineSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of FastLineSeriesRenderer class.
  FastLineSeriesRenderer();

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;

  /// Adds the segment to the segments list.
  ChartSegment _createSegments(int seriesIndex, int pointIndex,
      SfCartesianChart chart, double animateFactor,
      [List<Offset>? points]) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    final FastLineSegment segment = createSegment();
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    segmentProperties.series =
        _currentSeriesDetails.series as XyDataSeries<dynamic, dynamic>;
    segmentProperties.seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segmentProperties.seriesRenderer = this;
    segment.animationFactor = animateFactor;
    _segmentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (points != null) {
      segment.points = points;
    }
    segmentProperties.oldSegmentIndex = 0;
    customizeSegment(segment);
    _currentSeriesDetails.segments.add(segment);
    return segment;
  }

  /// Renders the segment.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    if (_segmentSeriesDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          _segmentSeriesDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              _currentSeriesDetails.segments[0], _currentSeriesDetails.chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  FastLineSegment createSegment() => FastLineSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final FastLineSegment fastLineSegment = segment as FastLineSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(fastLineSegment);
    segmentProperties.color = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeWidth = segmentProperties.series.width;
    fastLineSegment.strokePaint = fastLineSegment.getStrokePaint();
    fastLineSegment.fillPaint = fastLineSegment.getFillPaint();
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

/// Represents the fastline Chart painter
class FastLineChartPainter extends CustomPainter {
  /// Calling the default constructor of FastLineChartPainter class.
  FastLineChartPainter(
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

  /// Specifies the fastline series renderer
  final FastLineSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for fast line series
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);
    final FastLineSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as FastLineSeries<dynamic, dynamic>;
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final List<Offset> points = <Offset>[];
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
          (series.animationDuration > 0 &&
              seriesRendererDetails
                      .stateProperties.renderingDetails.isLegendToggled ==
                  false)) {
        seriesRendererDetails.needAnimateSeriesElements =
            seriesRendererDetails.needsAnimation;
        performLinearAnimation(
            stateProperties, xAxisDetails.axis, canvas, animationFactor);
      }
      int segmentIndex = -1;
      CartesianChartPoint<dynamic>? prevPoint, point;
      ChartLocation currentLocation;
      final VisibleRange xVisibleRange = xAxisDetails.visibleRange!;
      final VisibleRange yVisibleRange = yAxisDetails.visibleRange!;
      final List<CartesianChartPoint<dynamic>> seriesPoints =
          seriesRendererDetails.dataPoints;
      assert(seriesPoints.isNotEmpty,
          'The data points should be available to render fast line series.');
      final Rect areaBounds =
          seriesRendererDetails.stateProperties.chartAxis.axisClipRect;
      final num xTolerance = (xVisibleRange.delta / areaBounds.width).abs();
      final num yTolerance = (yVisibleRange.delta / areaBounds.height).abs();
      num prevXValue = (seriesPoints.isNotEmpty &&
              // ignore: unnecessary_null_comparison
              seriesPoints[0] != null &&
              (seriesPoints[0].xValue > xTolerance) == true)
          ? 0
          : xTolerance;
      num prevYValue = (seriesPoints.isNotEmpty &&
              // ignore: unnecessary_null_comparison
              seriesPoints[0] != null &&
              (seriesPoints[0].yValue > yTolerance) == true)
          ? 0
          : yTolerance;
      num xVal = 0;
      num yVal = 0;

      final List<CartesianChartPoint<dynamic>> dataPoints =
          <CartesianChartPoint<dynamic>>[];

      ///Eliminating nearest points
      CartesianChartPoint<dynamic> currentPoint;
      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }
      // ignore: unnecessary_null_comparison
      final bool hasTooltipBehavior = chart.tooltipBehavior != null;
      final bool isPointTapEnabled =
          seriesRendererDetails.series.onPointTap != null ||
              seriesRendererDetails.series.onPointDoubleTap != null ||
              seriesRendererDetails.series.onPointLongPress != null;
      final bool hasSeriesElements = seriesRendererDetails.visible! &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible ||
              (hasTooltipBehavior &&
                  chart.tooltipBehavior.enable &&
                  (hasTooltipBehavior &&
                      chart.tooltipBehavior.enable &&
                      series.enableTooltip)) ||
              isPointTapEnabled);
      final bool isCalculateRegion =
          (hasTooltipBehavior && chart.tooltipBehavior.enable) ||
              isPointTapEnabled;
      for (int pointIndex = 0;
          pointIndex < seriesRendererDetails.dataPoints.length;
          pointIndex++) {
        currentPoint = seriesRendererDetails.dataPoints[pointIndex];
        xVal = currentPoint.xValue ?? xVisibleRange.minimum;
        yVal = currentPoint.yValue ?? yVisibleRange.minimum;
        if ((prevXValue - xVal).abs() >= xTolerance ||
            (prevYValue - yVal).abs() >= yTolerance) {
          point = currentPoint;
          dataPoints.add(currentPoint);
          bool withInXRange = withInRange(
              currentPoint.xValue, seriesRendererDetails.xAxisDetails!);
          // ignore: unnecessary_null_comparison
          bool withInYRange = currentPoint != null &&
              currentPoint.yValue != null &&
              withInRange(
                  currentPoint.yValue, seriesRendererDetails.yAxisDetails!);
          bool inRange = withInXRange || withInYRange;
          if (!inRange &&
              (pointIndex + 1 < seriesRendererDetails.dataPoints.length)) {
            final CartesianChartPoint<dynamic>? nextPoint =
                seriesRendererDetails.dataPoints[pointIndex + 1];
            withInXRange = withInRange(
                nextPoint!.xValue, seriesRendererDetails.xAxisDetails!);
            // ignore: unnecessary_null_comparison
            withInYRange = nextPoint != null &&
                nextPoint.yValue != null &&
                withInRange(
                    nextPoint.yValue, seriesRendererDetails.yAxisDetails!);
            inRange = withInXRange || withInYRange;
            if (!inRange && pointIndex - 1 >= 0) {
              final CartesianChartPoint<dynamic>? prevPoint =
                  seriesRendererDetails.dataPoints[pointIndex - 1];
              withInXRange = withInRange(
                  prevPoint!.xValue, seriesRendererDetails.xAxisDetails!);
              // ignore: unnecessary_null_comparison
              withInYRange = prevPoint != null &&
                  prevPoint.yValue != null &&
                  withInRange(
                      prevPoint.yValue, seriesRendererDetails.yAxisDetails!);
            }
          }
          if (withInXRange || withInYRange) {
            currentLocation = calculatePoint(
                xVal,
                yVal,
                xAxisDetails,
                yAxisDetails,
                seriesRendererDetails.stateProperties.requireInvertedAxis,
                series,
                areaBounds);
            if (withInXRange) {
              seriesRendererDetails.visibleDataPoints!.add(currentPoint);
              seriesRendererDetails.dataPoints[pointIndex].visiblePointIndex =
                  seriesRendererDetails.visibleDataPoints!.length - 1;
            }

            if (hasSeriesElements) {
              // ignore: unnecessary_null_comparison
              if (series.markerSettings != null) {
                final double markerHeight = series.markerSettings.height,
                    markerWidth = series.markerSettings.width;
                point.region = Rect.fromLTWH(
                    currentLocation.x - markerWidth,
                    currentLocation.y - markerHeight,
                    2 * markerWidth,
                    2 * markerHeight);
                point.markerPoint = currentLocation;
              }
              if (point.region == null) {
                if (seriesRendererDetails.calculateRegion == true &&
                    dataPoints.length == pointIndex - 1) {
                  seriesRendererDetails.calculateRegion = false;
                }
              }

              if (isCalculateRegion) {
                calculateTooltipRegion(
                    point, seriesIndex, seriesRendererDetails, stateProperties);
              }
            }

            if (point.isVisible) {
              points.add(Offset(currentLocation.x, currentLocation.y));
              if ((series.emptyPointSettings.mode == EmptyPointMode.gap &&
                      seriesRendererDetails.containsEmptyPoints) ||
                  (seriesRendererDetails.dashArray![0] != 0.0 &&
                      seriesRendererDetails.dashArray![1] != 0.0)) {
                if (prevPoint == null) {
                  seriesRendererDetails.segmentPath!
                      .moveTo(currentLocation.x, currentLocation.y);
                } else if (seriesRendererDetails
                            .dataPoints[pointIndex - 1].isVisible ==
                        false &&
                    series.emptyPointSettings.mode == EmptyPointMode.gap) {
                  seriesRendererDetails.segmentPath!
                      .moveTo(currentLocation.x, currentLocation.y);
                } else if (point.isGap != true &&
                    seriesRendererDetails.dataPoints[pointIndex - 1].isGap !=
                        true &&
                    seriesRendererDetails.dataPoints[pointIndex].isVisible ==
                        true) {
                  seriesRendererDetails.segmentPath!
                      .lineTo(currentLocation.x, currentLocation.y);
                } else {
                  seriesRendererDetails.segmentPath!
                      .moveTo(currentLocation.x, currentLocation.y);
                }
                prevPoint = point;
              }
            }
            prevXValue = xVal;
            prevYValue = yVal;
          }
        }
      }

      if (seriesRendererDetails.segmentPath != null) {
        seriesRendererDetails.sampledDataPoints = dataPoints;
        seriesRendererDetails.drawSegment(
            canvas,
            seriesRenderer._createSegments(painterKey.index, segmentIndex += 1,
                chart, animationFactor, points));
      }

      canvas.restore();

      if ((series.animationDuration <= 0 ||
              animationFactor >= stateProperties.seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The fast line series should be available to render a marker on it.');
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
  bool shouldRepaint(FastLineChartPainter oldDelegate) => isRepaint;
}
