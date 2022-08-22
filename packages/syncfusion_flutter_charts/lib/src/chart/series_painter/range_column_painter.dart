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

/// Creates series renderer for range column series
class RangeColumnSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of RangeColumnSeriesRenderer class.
  RangeColumnSeriesRenderer();

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;

  /// To add range column segments in segments list.
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    _currentSeriesDetails.isRectSeries = true;
    final RangeColumnSegment segment = createSegment();
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final List<CartesianSeriesRenderer>? oldSeriesRenderers =
        _currentSeriesDetails.stateProperties.oldSeriesRenderers;
    final RangeColumnSeries<dynamic, dynamic> rangeColumnSeries =
        _currentSeriesDetails.series as RangeColumnSeries<dynamic, dynamic>;
    final BorderRadius borderRadius = rangeColumnSeries.borderRadius;
    segmentProperties.seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.points
        .add(Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
    segment.points.add(
        Offset(currentPoint.markerPoint2!.x, currentPoint.markerPoint2!.y));
    segmentProperties.seriesRenderer = this;
    segmentProperties.series = rangeColumnSeries;
    segment.animationFactor = animateFactor;
    segmentProperties.currentPoint = currentPoint;
    _segmentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (_currentSeriesDetails.stateProperties.renderingDetails.widgetNeedUpdate == true &&
        ZoomPanBehaviorHelper.getRenderingDetails(_currentSeriesDetails
                    .stateProperties.zoomPanBehaviorRenderer)
                .isPinching !=
            true &&
        _currentSeriesDetails
                .stateProperties.renderingDetails.isLegendToggled ==
            false &&
        oldSeriesRenderers != null &&
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
      segmentProperties
          .oldPoint = (segmentOldSeriesDetails.segments.isNotEmpty == true &&
              segmentOldSeriesDetails.segments[0] is RangeColumnSegment &&
              (segmentOldSeriesDetails.dataPoints.length - 1 >= pointIndex) ==
                  true)
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
    } else if (_currentSeriesDetails
                .stateProperties.renderingDetails.isLegendToggled ==
            true &&
        // ignore: unnecessary_null_comparison
        _currentSeriesDetails.stateProperties.segments != null &&
        _currentSeriesDetails.stateProperties.segments.isNotEmpty == true) {
      segmentProperties.oldSeriesVisible = _currentSeriesDetails
          .stateProperties.oldSeriesVisible[segmentProperties.seriesIndex];
      RangeColumnSegment oldSegment;
      for (int i = 0;
          i < _currentSeriesDetails.stateProperties.segments.length;
          i++) {
        oldSegment = _currentSeriesDetails.stateProperties.segments[i]
            as RangeColumnSegment;
        if (oldSegment.currentSegmentIndex == segment.currentSegmentIndex &&
            SegmentHelper.getSegmentProperties(oldSegment).seriesIndex ==
                segmentProperties.seriesIndex) {
          segmentProperties.oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }
    segmentProperties.path = findingRectSeriesDashedBorder(
        currentPoint, rangeColumnSeries.borderWidth);
    // ignore: unnecessary_null_comparison
    if (borderRadius != null) {
      segment.segmentRect =
          getRRectFromRect(currentPoint.region!, borderRadius);

      //Tracker rect
      if (rangeColumnSeries.isTrackVisible) {
        segmentProperties.trackRect =
            getRRectFromRect(currentPoint.trackerRectRegion!, borderRadius);
      }
    }
    segmentProperties.segmentRect = segment.segmentRect;
    customizeSegment(segment);
    _currentSeriesDetails.segments.add(segment);
    return segment;
  }

  /// To render range column series segments.
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
  RangeColumnSegment createSegment() => RangeColumnSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final RangeColumnSegment rangeColumnSegment = segment as RangeColumnSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(rangeColumnSegment);
    segmentProperties.color = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = segmentProperties.series.borderColor;
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
    rangeColumnSegment.strokePaint = rangeColumnSegment.getStrokePaint();
    rangeColumnSegment.fillPaint = rangeColumnSegment.getFillPaint();
    segmentProperties.trackerFillPaint =
        segmentProperties.getTrackerFillPaint();
    segmentProperties.trackerStrokePaint =
        segmentProperties.getTrackerStrokePaint();
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

/// Represents the RangeColumn Chart painter
class RangeColumnChartPainter extends CustomPainter {
  /// Calling the default constructor of RangeColumnChartPainter class.
  RangeColumnChartPainter(
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

  /// Specifies the range column series renderer
  RangeColumnSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for range column series
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
    final RangeColumnSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as RangeColumnSeries<dynamic, dynamic>;
    if (seriesRendererDetails.visible! == true) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      Rect axisClipRect, clipRect;
      double animationFactor;
      CartesianChartPoint<dynamic> point;
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
        final bool withInXRange = withInRange(
            point.xValue, seriesRendererDetails.xAxisDetails!.visibleRange!);
        // ignore: unnecessary_null_comparison
        final bool withInHighLowRange = point != null &&
            point.high != null &&
            withInRange(point.high,
                seriesRendererDetails.yAxisDetails!.visibleRange!) &&
            point.low != null &&
            withInRange(
                point.low, seriesRendererDetails.yAxisDetails!.visibleRange!);
        if (withInXRange || withInHighLowRange) {
          seriesRendererDetails.calculateRegionData(stateProperties,
              seriesRendererDetails, painterKey.index, point, pointIndex);
          if (point.isVisible && !point.isGap) {
            seriesRendererDetails.drawSegment(
                canvas,
                seriesRenderer._createSegments(point, segmentIndex += 1,
                    painterKey.index, animationFactor));
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
            'The range column series should be available to render a marker on it.');
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
  bool shouldRepaint(RangeColumnChartPainter oldDelegate) => isRepaint;
}
