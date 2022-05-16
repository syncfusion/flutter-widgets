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

/// Creates series renderer for column series.
class ColumnSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of ColumnSeriesRenderer class.
  ColumnSeriesRenderer();

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;

  /// To add column segments in segments list.
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    final ColumnSegment segment = createSegment() as ColumnSegment;
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final CartesianStateProperties stateProperties =
        _currentSeriesDetails.stateProperties;
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _currentSeriesDetails.stateProperties.oldSeriesRenderers;
    final ColumnSeries<dynamic, dynamic> columnSeries =
        _currentSeriesDetails.series as ColumnSeries<dynamic, dynamic>;
    segmentProperties.seriesRenderer = this;
    segmentProperties.series = columnSeries;
    segmentProperties.seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.points
        .add(Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
    segment.animationFactor = animateFactor;
    segmentProperties.currentPoint = currentPoint;
    final ZoomingBehaviorDetails zoomingBehaviorDetails =
        ZoomPanBehaviorHelper.getRenderingDetails(
            stateProperties.zoomPanBehaviorRenderer);
    _segmentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (stateProperties.renderingDetails.widgetNeedUpdate &&
        zoomingBehaviorDetails.isPinching != true &&
        !stateProperties.renderingDetails.isLegendToggled &&
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
              segmentOldSeriesDetails.segments[0] is ColumnSegment &&
              (segmentOldSeriesDetails.dataPoints.length - 1 >= pointIndex) ==
                  true)
          ? segmentOldSeriesDetails.dataPoints[pointIndex]
          : null;
      segmentProperties.oldSegmentIndex = getOldSegmentIndex(segment);
      if ((stateProperties.selectedSegments.length - 1 >= pointIndex) &&
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
    } else if (stateProperties.renderingDetails.isLegendToggled &&
        // ignore: unnecessary_null_comparison
        stateProperties.segments != null &&
        stateProperties.segments.isNotEmpty) {
      segmentProperties.oldSeriesVisible =
          stateProperties.oldSeriesVisible[segmentProperties.seriesIndex];

      ColumnSegment oldSegment;
      for (int i = 0; i < stateProperties.segments.length; i++) {
        oldSegment = stateProperties.segments[i] as ColumnSegment;
        if (oldSegment.currentSegmentIndex == segment.currentSegmentIndex &&
            SegmentHelper.getSegmentProperties(oldSegment).seriesIndex ==
                segmentProperties.seriesIndex) {
          segmentProperties.oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }

    segmentProperties.path =
        findingRectSeriesDashedBorder(currentPoint, columnSeries.borderWidth);
    // ignore: unnecessary_null_comparison
    if (columnSeries.borderRadius != null) {
      segment.segmentRect =
          getRRectFromRect(currentPoint.region!, columnSeries.borderRadius);

      //Tracker rect
      if (columnSeries.isTrackVisible) {
        segmentProperties.trackRect = getRRectFromRect(
            currentPoint.trackerRectRegion!, columnSeries.borderRadius);
      }
    }
    segmentProperties.segmentRect = segment.segmentRect;
    customizeSegment(segment);
    _currentSeriesDetails.segments.add(segment);
    return segment;
  }

  /// To draw column series segments.
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
  ChartSegment createSegment() => ColumnSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final ColumnSegment columnSegment = segment as ColumnSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(columnSegment);
    segmentProperties.color =
        segmentProperties.currentPoint!.pointColorMapper ??
            _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = segmentProperties.series.borderColor;
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
    columnSegment.strokePaint = columnSegment.getStrokePaint();
    columnSegment.fillPaint = columnSegment.getFillPaint();
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

/// Represents the column Chart painter
class ColumnChartPainter extends CustomPainter {
  /// Calling the default constructor of ColumnChartPainter class.
  ColumnChartPainter(
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

  /// Specifies the column series renderer
  ColumnSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for column series
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
    final ColumnSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as ColumnSeries<dynamic, dynamic>;
    if (seriesRendererDetails.visible! == true) {
      Rect axisClipRect, clipRect;
      double animationFactor;
      CartesianChartPoint<dynamic> point;
      canvas.save();
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the bar series must be greater than or equal to 0.');
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
            'The column series should be available to render a marker on it.');
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
  bool shouldRepaint(ColumnChartPainter oldDelegate) => isRepaint;
}
