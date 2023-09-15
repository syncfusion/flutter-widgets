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

export 'package:syncfusion_flutter_core/core.dart' show DataMarkerType;

/// Creates series renderer for scatter series
class ScatterSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of ScatterSeriesRenderer class.
  ScatterSeriesRenderer();

  // ignore:unused_field
  CartesianChartPoint<dynamic>? _point;

  ScatterSegment? _segment;

  /// Adds the points to the segments .
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final ScatterSegment segment = createSegment();
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(seriesRendererDetails.stateProperties, segment));

    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);

    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        seriesRendererDetails.stateProperties.oldSeriesRenderers;
    seriesRendererDetails.isRectSeries = false;

    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segmentProperties.seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segmentProperties.seriesRenderer = this;
      segmentProperties.series =
          seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
      segment.animationFactor = animateFactor;
      segmentProperties.point = currentPoint;
      segmentProperties.currentPoint = currentPoint;
      if (seriesRendererDetails
                  .stateProperties.renderingDetails.widgetNeedUpdate ==
              true &&
          seriesRendererDetails
                  .stateProperties.renderingDetails.isLegendToggled ==
              false &&
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
        final SeriesRendererDetails oldSeriesDetails =
            SeriesHelper.getSeriesRendererDetails(
                segmentProperties.oldSeriesRenderer!);
        segmentProperties.oldPoint = (oldSeriesDetails.segments.isNotEmpty ==
                    true &&
                oldSeriesDetails.segments[0] is ScatterSegment &&
                (oldSeriesDetails.dataPoints.length - 1 >= pointIndex) == true)
            ? oldSeriesDetails.dataPoints[pointIndex]
            : null;
        segmentProperties.oldSegmentIndex = getOldSegmentIndex(segment);
        if ((seriesRendererDetails.stateProperties.selectedSegments.length -
                        1 >=
                    pointIndex) ==
                true &&
            SegmentHelper.getSegmentProperties(seriesRendererDetails
                        .stateProperties.selectedSegments[pointIndex])
                    .oldSegmentIndex ==
                null) {
          final ChartSegment selectedSegment = seriesRendererDetails
              .stateProperties.selectedSegments[pointIndex];
          final SegmentProperties selectedSegmentProperties =
              SegmentHelper.getSegmentProperties(selectedSegment);
          selectedSegmentProperties.oldSeriesRenderer =
              oldSeriesRenderers[selectedSegmentProperties.seriesIndex];
          selectedSegmentProperties.seriesRenderer = this;
          selectedSegmentProperties.oldSegmentIndex =
              getOldSegmentIndex(selectedSegment);
        }
      }
      SegmentHelper.setSegmentProperties(segment, segmentProperties);
      final ChartLocation location = calculatePoint(
          currentPoint.xValue,
          currentPoint.yValue,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          seriesRendererDetails.stateProperties.chartAxis.axisClipRect);
      segment.points.add(Offset(location.x, location.y));
      segmentProperties.segmentRect =
          RRect.fromRectAndRadius(currentPoint.region!, Radius.zero);

      customizeSegment(segment);
      seriesRendererDetails.segments.add(segment);
      _segment = segment;
    }
    return segment;
  }

  /// To render scatter series segments.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final SeriesRendererDetails currentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (currentSeriesDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          currentSeriesDetails.selectionBehaviorRenderer;
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
  ScatterSegment createSegment() => ScatterSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final ScatterSegment scatterSegment = segment as ScatterSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(scatterSegment);
    segmentProperties.color =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .seriesColor;
    segmentProperties.strokeColor = segmentProperties.series.borderColor;
    segmentProperties.strokeWidth =
        ((segmentProperties.series.markerSettings.shape ==
                        DataMarkerType.verticalLine ||
                    segmentProperties.series.markerSettings.shape ==
                        DataMarkerType.horizontalLine) &&
                segmentProperties.series.borderWidth == 0)
            ? segmentProperties.series.markerSettings.borderWidth
            : segmentProperties.series.borderWidth;
    scatterSegment.strokePaint = scatterSegment.getStrokePaint();
    scatterSegment.fillPaint = scatterSegment.getFillPaint();
  }

  /// Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer!);
    final Size size = Size(seriesRendererDetails.series.markerSettings.width,
        seriesRendererDetails.series.markerSettings.height);
    final Path markerPath = getMarkerShapesPath(
        seriesRendererDetails.series.markerSettings.shape,
        Offset(pointX, pointY),
        size,
        seriesRendererDetails,
        index,
        null,
        seriesRendererDetails.seriesElementAnimation,
        _segment);
    canvas.drawPath(markerPath, strokePaint);
    canvas.drawPath(markerPath, fillPaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}

/// Represents the scatter Chart painter
class ScatterChartPainter extends CustomPainter {
  /// Calling the default constructor of ScatterChartPainter class.
  ScatterChartPainter(
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

  /// Specifies the scatter series renderer
  final ScatterSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for scatter series
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    double animationFactor;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);

    final ScatterSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as ScatterSeries<dynamic, dynamic>;
    if (seriesRendererDetails.visible! == true) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      final ChartAxisRendererDetails xAxisDetails =
          seriesRendererDetails.xAxisDetails!;
      final ChartAxisRendererDetails yAxisDetails =
          seriesRendererDetails.yAxisDetails!;
      final List<CartesianChartPoint<dynamic>> dataPoints =
          seriesRendererDetails.dataPoints;
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
      final int seriesIndex = painterKey.index;
      seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
      int segmentIndex = -1;
      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }

      seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        final CartesianChartPoint<dynamic> currentPoint =
            dataPoints[pointIndex];
        final bool withInXRange = withInRange(
            currentPoint.xValue, seriesRendererDetails.xAxisDetails!);
        // ignore: unnecessary_null_comparison
        final bool withInYRange = currentPoint != null &&
            currentPoint.yValue != null &&
            withInRange(
                currentPoint.yValue, seriesRendererDetails.yAxisDetails!);
        if (withInXRange && withInYRange) {
          seriesRendererDetails.calculateRegionData(
              stateProperties,
              seriesRendererDetails,
              painterKey.index,
              currentPoint,
              pointIndex);
          if (currentPoint.isVisible && !currentPoint.isGap) {
            seriesRendererDetails.drawSegment(
                canvas,
                seriesRenderer._createSegments(currentPoint, segmentIndex += 1,
                    seriesIndex, animationFactor));
          }
        }
      }
      if (series.animationDuration <= 0 ||
          animationFactor >= stateProperties.seriesDurationFactor) {
        seriesRendererDetails.renderSeriesElements(
            chart, canvas, seriesRendererDetails.seriesElementAnimation);
      }
      if (animationFactor >= 1) {
        stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(ScatterChartPainter oldDelegate) => isRepaint;
}
