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

/// Creates series renderer for bar series.
class BarSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of BarSeriesRenderer class.
  BarSeriesRenderer();

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;

  /// To add bar segments to chart segments.
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    final BarSeries<dynamic, dynamic> barSeries =
        _currentSeriesDetails.series as BarSeries<dynamic, dynamic>;
    final BarSegment segment = createSegment();
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _currentSeriesDetails.stateProperties.oldSeriesRenderers;
    segmentProperties.series = barSeries;
    segmentProperties.seriesRenderer = this;
    segmentProperties.seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.points
        .add(Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
    segment.animationFactor = animateFactor;
    segmentProperties.currentPoint = currentPoint;
    _segmentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (_currentSeriesDetails
                .stateProperties.renderingDetails.widgetNeedUpdate ==
            true &&
        _currentSeriesDetails
                .stateProperties.renderingDetails.isLegendToggled ==
            false &&
        // ignore: unnecessary_null_comparison
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
              segmentOldSeriesDetails.segments[0] is BarSegment &&
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
      for (int i = 0;
          i < _currentSeriesDetails.stateProperties.segments.length;
          i++) {
        final BarSegment oldSegment =
            _currentSeriesDetails.stateProperties.segments[i] as BarSegment;
        if (oldSegment.currentSegmentIndex == segment.currentSegmentIndex &&
            SegmentHelper.getSegmentProperties(oldSegment).seriesIndex ==
                segmentProperties.seriesIndex) {
          segmentProperties.oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }
    segmentProperties.path =
        findingRectSeriesDashedBorder(currentPoint, barSeries.borderWidth);
    segment.segmentRect =
        getRRectFromRect(currentPoint.region!, barSeries.borderRadius);
    //Tracker rect
    if (barSeries.isTrackVisible) {
      segmentProperties.trackBarRect = getRRectFromRect(
          currentPoint.trackerRectRegion!, barSeries.borderRadius);
    }
    segmentProperties.segmentRect = segment.segmentRect;
    customizeSegment(segment);
    _currentSeriesDetails.segments.add(segment);
    return segment;
  }

  /// To draw bar segment.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    if (_segmentSeriesDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          _segmentSeriesDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              _currentSeriesDetails.segments[segment.currentSegmentIndex!],
              _currentSeriesDetails.stateProperties.chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  BarSegment createSegment() => BarSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final BarSegment barSegment = segment as BarSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(barSegment);
    segmentProperties.color = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = segmentProperties.series.borderColor;
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
    barSegment.strokePaint = barSegment.getStrokePaint();
    barSegment.fillPaint = barSegment.getFillPaint();
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
    canvas.drawPath(seriesRendererDetails.markerShapes[index]!, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}

/// Represents the bar chart painter
class BarChartPainter extends CustomPainter {
  /// Creates an instance of bar chart painter
  BarChartPainter(
      {required this.stateProperties,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required ValueNotifier<num> notifier,
      required this.painterKey})
      : chart = stateProperties.chart,
        super(repaint: notifier);

  /// Specifies the Cartesian state chart properties
  final CartesianStateProperties stateProperties;

  /// Specifies the Cartesian chart
  final SfCartesianChart chart;

  /// Specifies whether to repaint the segment
  final bool isRepaint;

  /// Specifies the value of animation controller
  final Animation<double> animationController;

  /// Specifies the value of bar series renderer
  final BarSeriesRenderer seriesRenderer;

  /// Represents the value of painter key
  final PainterKey painterKey;

  /// Painter method for bar series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    disposeOldSegments(chart, seriesRendererDetails);
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    final BarSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as BarSeries<dynamic, dynamic>;
    if (seriesRendererDetails.visible! == true) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the bar series must be greater than or equal to 0.');
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
        final bool withInYRange = point != null &&
            point.yValue != null &&
            withInRange(point.yValue,
                seriesRendererDetails.yAxisDetails!.visibleRange!);
        if (withInXRange || withInYRange) {
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
            'The bar series should be available to render a marker on it.');
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
  bool shouldRepaint(BarChartPainter oldDelegate) => isRepaint;
}
