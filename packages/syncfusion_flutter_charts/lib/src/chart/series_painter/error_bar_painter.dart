import 'package:flutter/material.dart';

import './../axis/axis.dart';
import '../../../charts.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for error bar series.
class ErrorBarSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of ErrorBarSeriesRenderer class.
  ErrorBarSeriesRenderer();

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;

  /// To add error bar segments in segments list.
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    final ErrorBarSegment segment = createSegment() as ErrorBarSegment;
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final ErrorBarSeries<dynamic, dynamic> errorBarSeries =
        _currentSeriesDetails.series as ErrorBarSeries<dynamic, dynamic>;
    segmentProperties.seriesRenderer = this;
    segmentProperties.series = errorBarSeries;
    segmentProperties.seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.animationFactor = animateFactor;
    if (errorBarSeries.onRenderDetailsUpdate != null &&
        _currentSeriesDetails.animationController.status ==
            AnimationStatus.completed) {
      final ErrorBarRenderDetails errorBarRenderDetails = ErrorBarRenderDetails(
          currentPoint.visiblePointIndex,
          currentPoint.overallDataPointIndex,
          currentPoint.errorBarValues);
      errorBarSeries.onRenderDetailsUpdate!(errorBarRenderDetails);
    }
    segmentProperties.currentPoint = currentPoint;
    _segmentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    customizeSegment(segment);
    _currentSeriesDetails.segments.add(segment);
    return segment;
  }

  /// To draw error bar series segments.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => ErrorBarSegment();

  /// Changes the series color.
  @override
  void customizeSegment(ChartSegment segment) {
    final ErrorBarSegment errorBarSegment = segment as ErrorBarSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(errorBarSegment);
    segmentProperties.color =
        segmentProperties.currentPoint!.pointColorMapper ??
            _segmentSeriesDetails.seriesColor;
    errorBarSegment.strokePaint = errorBarSegment.getStrokePaint();
  }

  /// Data marker is not applicable for error bar series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {}

  /// Data label is not applicable for error bar series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
      double pointY, int angle, TextStyle style) {}
}

/// Represents the error bar chart painter.
class ErrorBarChartPainter extends CustomPainter {
  /// Calling the default constructor of ErrorBarChartPainter class.
  ErrorBarChartPainter(
      {required this.stateProperties,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required ValueNotifier<num> notifier,
      required this.painterKey})
      : chart = stateProperties.chart,
        super(repaint: notifier);

  /// Represents the cartesian state properties
  final CartesianStateProperties stateProperties;

  /// Represents the cartesian chart.
  final SfCartesianChart chart;

  /// Specifies whether to repaint the series.
  final bool isRepaint;

  /// Specifies the value of animation controller.
  final AnimationController animationController;

  /// Specifies the list of current chart location
  List<ChartLocation> currentChartLocations = <ChartLocation>[];

  /// Specifies the error bar series renderer
  ErrorBarSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for error bar series.
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
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    final ErrorBarSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as ErrorBarSeries<dynamic, dynamic>;
    if (seriesRendererDetails.visible! == true) {
      Rect axisClipRect;
      double animationFactor;
      CartesianChartPoint<dynamic> point;
      canvas.save();
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the error bar series must be greater than or equal to 0.');
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
      canvas.restore();
      if (animationFactor >= 1) {
        stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(ErrorBarChartPainter oldDelegate) => isRepaint;
}
