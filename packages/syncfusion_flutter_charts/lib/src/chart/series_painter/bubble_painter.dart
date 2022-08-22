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

/// Creates series renderer for bubble series.
class BubbleSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of BubbleSeriesRenderer class.
  BubbleSeriesRenderer();

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;

  /// To add bubble segments to segment list.
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    final BubbleSegment segment = createSegment();
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _currentSeriesDetails.stateProperties.oldSeriesRenderers;
    _currentSeriesDetails.isRectSeries = false;
    segmentProperties.seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.points
        .add(Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
    segmentProperties.seriesIndex = seriesIndex;
    segmentProperties.series =
        _currentSeriesDetails.series as XyDataSeries<dynamic, dynamic>;
    segment.animationFactor = animateFactor;
    segmentProperties.currentPoint = currentPoint;
    segmentProperties.seriesRenderer = this;
    _segmentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (_currentSeriesDetails
                .stateProperties.renderingDetails.widgetNeedUpdate ==
            true &&
        oldSeriesRenderers.isNotEmpty &&
        oldSeriesRenderers.length - 1 >= segmentProperties.seriesIndex &&
        SeriesHelper.getSeriesRendererDetails(
                    oldSeriesRenderers[segmentProperties.seriesIndex])
                .seriesName ==
            _segmentSeriesDetails.seriesName) {
      segmentProperties.oldSeriesRenderer =
          oldSeriesRenderers[segmentProperties.seriesIndex];
      final SeriesRendererDetails segmentOldSeriesDetails =
          SeriesHelper.getSeriesRendererDetails(
              segmentProperties.oldSeriesRenderer!);
      segmentProperties.oldPoint =
          (segmentOldSeriesDetails.dataPoints.length - 1 >= pointIndex) == true
              ? segmentOldSeriesDetails.dataPoints[pointIndex]
              : null;
      segmentProperties.oldSegmentIndex = getOldSegmentIndex(segment);
      if ((_currentSeriesDetails.stateProperties.selectedSegments.length - 1 >=
                  pointIndex) ==
              true &&
          SegmentHelper.getSegmentProperties(_currentSeriesDetails
                      .stateProperties.selectedSegments[pointIndex])
                  .oldSegmentIndex ==
              null) {
        final ChartSegment selectedSegment =
            _currentSeriesDetails.stateProperties.selectedSegments[pointIndex];
        final SegmentProperties selectedSegmentProperties =
            SegmentHelper.getSegmentProperties(selectedSegment);
        selectedSegmentProperties.oldSeriesRenderer =
            oldSeriesRenderers[selectedSegmentProperties.seriesIndex];
        selectedSegmentProperties.seriesRenderer = this;
        selectedSegmentProperties.oldSegmentIndex =
            getOldSegmentIndex(selectedSegment);
      }
    }
    segment.calculateSegmentPoints();
    customizeSegment(segment);
    segment.strokePaint = segment.getStrokePaint();
    segment.fillPaint = segment.getFillPaint();
    _currentSeriesDetails.segments.add(segment);
    return segment;
  }

  /// To draw bubble segments.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    if (_segmentSeriesDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          _segmentSeriesDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              _currentSeriesDetails.segments[segment.currentSegmentIndex!],
              _currentSeriesDetails.chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  BubbleSegment createSegment() => BubbleSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final BubbleSegment bubbleSegment = segment as BubbleSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(bubbleSegment);
    segmentProperties.color = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = segmentProperties.series.borderColor; // ??
    // bubbleSegment.segmentProperties.seriesRenderer.seriesRendererDetails.seriesColor;
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
    bubbleSegment.strokePaint = bubbleSegment.getStrokePaint();
    bubbleSegment.fillPaint = bubbleSegment.getFillPaint();
  }

  /// Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer!);
    // ignore: unnecessary_null_comparison
    if (seriesRenderer != null) {
      canvas.drawPath(seriesRendererDetails.markerShapes[index]!, fillPaint);
      canvas.drawPath(seriesRendererDetails.markerShapes[index]!, strokePaint);
    }
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}

/// Represents the bubble chart painter
class BubbleChartPainter extends CustomPainter {
  /// Creates an instance of bubble chart painter
  BubbleChartPainter(
      {required this.stateProperties,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required ValueNotifier<num> notifier,
      required this.painterKey})
      : chart = stateProperties.chart,
        super(repaint: notifier);

  /// Represents the Cartesian chart state properties
  final CartesianStateProperties stateProperties;

  /// Represents the Cartesian chart
  final SfCartesianChart chart;

  /// Specifies whether to repaint the segment
  final bool isRepaint;

  /// Specifies the value of animation controller
  final Animation<double> animationController;

  /// Specifies the bubble series renderer
  final BubbleSeriesRenderer seriesRenderer;

  /// Represents the painter key
  final PainterKey painterKey;

  /// Painter method for bubble series
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
    double animationFactor;
    final BubbleSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as BubbleSeries<dynamic, dynamic>;
    if (seriesRendererDetails.visible! == true) {
      canvas.save();
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the bar series must be greater than or equal to 0.');
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
        final bool withInXRange = withInRange(currentPoint.xValue,
            seriesRendererDetails.xAxisDetails!.visibleRange!);
        // ignore: unnecessary_null_comparison
        final bool withInYRange = currentPoint != null &&
            currentPoint.yValue != null &&
            withInRange(currentPoint.yValue,
                seriesRendererDetails.yAxisDetails!.visibleRange!);
        if (withInXRange || withInYRange) {
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
      canvas.restore();
      if ((series.animationDuration <= 0 ||
              (!renderingDetails.initialRender! &&
                  seriesRendererDetails.needAnimateSeriesElements == false) ||
              animationFactor >= stateProperties.seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The bubble series should be available to render a marker on it.');
        seriesRendererDetails.renderSeriesElements(
            chart, canvas, seriesRendererDetails.seriesElementAnimation);
      }
      if (animationFactor >= 1) {
        stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(BubbleChartPainter oldDelegate) => isRepaint;
}
