import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/stacked_series_base.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for stacked column series.
class StackedColumnSeriesRenderer extends StackedSeriesRenderer {
  /// Calling the default constructor of StackedColumnSeriesRenderer class.
  StackedColumnSeriesRenderer();

  /// Stacked column segment is created here.
  // ignore: unused_element
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final StackedColumnSegment segment = createSegment();
    final SegmentProperties segmentProperties =
        SegmentProperties(seriesRendererDetails.stateProperties, segment);
    SegmentHelper.setSegmentProperties(segment, segmentProperties);
    final StackedColumnSeries<dynamic, dynamic> stackedColumnSeries =
        seriesRendererDetails.series as StackedColumnSeries<dynamic, dynamic>;
    seriesRendererDetails.isRectSeries = true;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segmentProperties.seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.points.add(
          Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
      segmentProperties.seriesRenderer = this;
      segmentProperties.series = stackedColumnSeries;
      segmentProperties.currentPoint = currentPoint;
      segment.animationFactor = animateFactor;
      segmentProperties.path = findingRectSeriesDashedBorder(
          currentPoint, stackedColumnSeries.borderWidth);
      segment.segmentRect = getRRectFromRect(
          currentPoint.region!, stackedColumnSeries.borderRadius);

      // Tracker rect.
      if (stackedColumnSeries.isTrackVisible) {
        segmentProperties.trackRect = getRRectFromRect(
            currentPoint.trackerRectRegion!, stackedColumnSeries.borderRadius);
        segmentProperties.trackerFillPaint =
            segmentProperties.getTrackerFillPaint();
        segmentProperties.trackerStrokePaint =
            segmentProperties.getTrackerStrokePaint();
      }
      segmentProperties.segmentRect = segment.segmentRect;
      segmentProperties.oldSegmentIndex = getOldSegmentIndex(segment);
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      seriesRendererDetails.segments.add(segment);
    }
    return segment;
  }

  /// To render stacked column series segments.
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

  @override
  StackedColumnSegment createSegment() => StackedColumnSegment();

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

  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);

  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer!);
    canvas.drawPath(seriesRendererDetails.markerShapes[index]!, fillPaint);
    canvas.drawPath(seriesRendererDetails.markerShapes[index]!, strokePaint);
  }
}

/// Represents the StackedColumn Chart painter
class StackedColummnChartPainter extends CustomPainter {
  /// Calling the default constructor of StackedColummnChartPainter class.
  StackedColummnChartPainter(
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

  /// Specifies the Cartesian chart point.
  CartesianChartPoint<dynamic>? point;

  /// Specifies whether to repaint the series.
  final bool isRepaint;

  /// Specifies the value of animation controller.
  final AnimationController animationController;

  /// Specifies the list of current chart location
  List<ChartLocation> currentChartLocations = <ChartLocation>[];

  /// Specifies the StackedColumn series renderer
  final StackedColumnSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for stacked column series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    _stackedRectPainter(canvas, seriesRenderer, seriesRendererDetails,
        stateProperties, painterKey);
  }

  @override
  bool shouldRepaint(StackedColummnChartPainter oldDelegate) => isRepaint;
}

/// Creates series renderer for Stacked column 100 series
class StackedColumn100SeriesRenderer extends StackedSeriesRenderer {
  /// Calling the default constructor of StackedColumn100SeriesRenderer class.
  StackedColumn100SeriesRenderer();

  /// Stacked Column 100 segment is created here
  // ignore: unused_element
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final StackedColumn100Segment segment = createSegment();
    final SegmentProperties segmentProperties =
        SegmentProperties(seriesRendererDetails.stateProperties, segment);
    SegmentHelper.setSegmentProperties(segment, segmentProperties);
    final StackedColumn100Series<dynamic, dynamic> stackedColumn100Series =
        seriesRendererDetails.series
            as StackedColumn100Series<dynamic, dynamic>;
    seriesRendererDetails.isRectSeries = true;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segmentProperties.seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.points.add(
          Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
      segmentProperties.seriesRenderer = this;
      segmentProperties.series = stackedColumn100Series;
      segmentProperties.currentPoint = currentPoint;
      segment.animationFactor = animateFactor;
      segmentProperties.path = findingRectSeriesDashedBorder(
          currentPoint, stackedColumn100Series.borderWidth);
      segment.segmentRect = getRRectFromRect(
          currentPoint.region!, stackedColumn100Series.borderRadius);
      segmentProperties.segmentRect = segment.segmentRect;
      segmentProperties.oldSegmentIndex = getOldSegmentIndex(segment);
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      seriesRendererDetails.segments.add(segment);
    }
    return segment;
  }

  /// To render stacked column 100 series segments
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
  StackedColumn100Segment createSegment() => StackedColumn100Segment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final StackedColumn100Segment column100Segment =
        segment as StackedColumn100Segment;
    final SegmentProperties column100SegmentProperties =
        SegmentHelper.getSegmentProperties(column100Segment);
    column100SegmentProperties.color =
        column100SegmentProperties.currentPoint!.pointColorMapper ??
            SeriesHelper.getSeriesRendererDetails(
                    column100SegmentProperties.seriesRenderer)
                .seriesColor;
    column100SegmentProperties.strokeColor =
        column100SegmentProperties.series.borderColor;
    column100SegmentProperties.strokeWidth =
        column100SegmentProperties.series.borderWidth;
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);

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
}

/// Represents the StacedColumn100 Chart painter
class StackedColumn100ChartPainter extends CustomPainter {
  /// Calling the default constructor of StackedColumn100ChartPainter class.
  StackedColumn100ChartPainter({
    required this.stateProperties,
    required this.seriesRenderer,
    required this.isRepaint,
    required this.animationController,
    required this.painterKey,
    required ValueNotifier<num> notifier,
  })  : chart = stateProperties.chart,
        super(repaint: notifier);

  /// Represents the Cartesian state properties
  final CartesianStateProperties stateProperties;

  /// Represents the Cartesian chart.
  final SfCartesianChart chart;

  /// Specifies the Cartesian chart point.
  CartesianChartPoint<dynamic>? point;

  /// Specifies whether to repaint the series.
  final bool isRepaint;

  /// Specifies the value of animation controller.
  final AnimationController animationController;

  /// Specifies the list of current chart location
  List<ChartLocation> currentChartLocations = <ChartLocation>[];

  /// Specifies the StackedColumn100 series renderer
  final StackedColumn100SeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for stacked column 100 series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);
    _stackedRectPainter(canvas, seriesRenderer, seriesRendererDetails,
        stateProperties, painterKey);
  }

  @override
  bool shouldRepaint(StackedColumn100ChartPainter oldDelegate) => isRepaint;
}

/// Rect painter for stacked series
void _stackedRectPainter(
    Canvas canvas,
    dynamic seriesRenderer,
    SeriesRendererDetails seriesRendererDetails,
    CartesianStateProperties stateProperties,
    PainterKey painterKey) {
  if (seriesRendererDetails.visible! == true) {
    canvas.save();
    Rect clipRect, axisClipRect;
    CartesianChartPoint<dynamic> point;
    final XyDataSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final int seriesIndex = painterKey.index;
    final Animation<double> seriesAnimation =
        seriesRendererDetails.seriesAnimation!;
    final Animation<double> chartElementAnimation =
        seriesRendererDetails.seriesElementAnimation!;
    seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
    double animationFactor;
    // ignore: unnecessary_null_comparison
    animationFactor = seriesAnimation != null &&
            (seriesRendererDetails.reAnimate == true ||
                (!(renderingDetails.widgetNeedUpdate ||
                    renderingDetails.isLegendToggled)))
        ? seriesAnimation.value
        : 1;
    stateProperties.shader = null;
    if (series.onCreateShader != null) {
      stateProperties.shader = series.onCreateShader!(
          ShaderDetails(stateProperties.chartAxis.axisClipRect, 'series'));
    }
    // Clip rect will be added for series.
    axisClipRect = calculatePlotOffset(
        stateProperties.chartAxis.axisClipRect,
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    canvas.clipRect(axisClipRect);
    int segmentIndex = -1;
    if (seriesRendererDetails.visibleDataPoints == null ||
        seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
      seriesRendererDetails.visibleDataPoints =
          <CartesianChartPoint<dynamic>>[];
    }
    seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
    for (int pointIndex = 0;
        pointIndex < seriesRendererDetails.dataPoints.length;
        pointIndex++) {
      point = seriesRendererDetails.dataPoints[pointIndex];
      final bool withInXRange = withInRange(
          point.xValue, seriesRendererDetails.xAxisDetails!.visibleRange!);
      // ignore: unnecessary_null_comparison
      final bool withInYRange = point != null &&
          point.yValue != null &&
          withInRange(
              point.yValue, seriesRendererDetails.yAxisDetails!.visibleRange!);
      if (withInXRange || withInYRange) {
        seriesRendererDetails.calculateRegionData(stateProperties,
            seriesRendererDetails, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isGap) {
          seriesRendererDetails.drawSegment(
              canvas,
              seriesRenderer._createSegments(
                  point, segmentIndex += 1, painterKey.index, animationFactor));
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
      stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
    }
  }
}
