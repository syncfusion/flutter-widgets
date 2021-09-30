import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../charts.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../axis/axis.dart';
import '../base/chart_base.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_segment/hilo_segment.dart';
import '../chart_series/hilo_series.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for Hilo series
class HiloSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of HiloSeriesRenderer class.
  HiloSeriesRenderer();

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;
  late SeriesRendererDetails _oldSeriesDetails;

  /// Hilo segment is created here
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    _currentSeriesDetails.isRectSeries = false;
    final HiloSegment segment = createSegment();
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _currentSeriesDetails.stateProperties.oldSeriesRenderers;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segmentProperties.seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.points.add(
          Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
      segment.points.add(
          Offset(currentPoint.markerPoint2!.x, currentPoint.markerPoint2!.y));
      segmentProperties.series =
          _currentSeriesDetails.series as XyDataSeries<dynamic, dynamic>;
      segmentProperties.seriesRenderer = this;
      segment.animationFactor = animateFactor;
      segmentProperties.pointColorMapper = currentPoint.pointColorMapper;
      segmentProperties.currentPoint = currentPoint;
      _segmentSeriesDetails = SeriesHelper.getSeriesRendererDetails(
          segmentProperties.seriesRenderer);
      if (_currentSeriesDetails
                  .stateProperties.renderingDetails.widgetNeedUpdate ==
              true &&
          _currentSeriesDetails
                  .stateProperties.renderingDetails.isLegendToggled ==
              false &&
          // ignore: unnecessary_null_comparison
          oldSeriesRenderers != null &&
          oldSeriesRenderers.isNotEmpty &&
          oldSeriesRenderers.length - 1 >= segmentProperties.seriesIndex) {
        _oldSeriesDetails = SeriesHelper.getSeriesRendererDetails(
            oldSeriesRenderers[segmentProperties.seriesIndex]);
        if (_oldSeriesDetails.seriesName == _segmentSeriesDetails.seriesName) {
          segmentProperties.oldSeriesRenderer =
              oldSeriesRenderers[segmentProperties.seriesIndex];
          segmentProperties.oldSegmentIndex = getOldSegmentIndex(segment);
        }
      }
      segment.calculateSegmentPoints();
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      _currentSeriesDetails.segments.add(segment);
    }
    return segment;
  }

  /// To render hilo series segments.
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
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    if (!((segmentProperties.currentPoint?.low ==
            segmentProperties.currentPoint?.high) &&
        //ignore: always_specify_types
        !(_currentSeriesDetails.series as HiloSeries)
            .showIndicationForSameValues)) {
      segment.onPaint(canvas);
    }
  }

  @override
  HiloSegment createSegment() => HiloSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    segmentProperties.color = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
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

/// Represents the Hilo series painter
class HiloPainter extends CustomPainter {
  /// Calling the default constructor of HiloPainter class.
  HiloPainter(
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

  /// Specifies the hilo series renderer
  HiloSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for Hilo series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    Rect clipRect;
    double animationFactor;
    final HiloSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as HiloSeries<dynamic, dynamic>;
    CartesianChartPoint<dynamic> point;
    if (seriesRendererDetails.visible! == true) {
      canvas.save();
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      final int seriesIndex = painterKey.index;
      seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
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
      int segmentIndex = -1;
      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRendererDetails.calculateRegionData(
            stateProperties,
            seriesRendererDetails,
            painterKey.index,
            point,
            pointIndex,
            seriesRendererDetails.sideBySideInfo);
        if (point.isVisible && !point.isGap) {
          seriesRenderer._drawSegment(
              canvas,
              seriesRenderer._createSegments(
                  point, segmentIndex += 1, painterKey.index, animationFactor));
        }
      }
      clipRect = calculatePlotOffset(
          Rect.fromLTWH(
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
              animationFactor >= stateProperties.seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The Hilo series should be available to render a marker on it.');
        canvas.clipRect(clipRect);
        seriesRendererDetails.renderSeriesElements(
            chart, canvas, seriesRendererDetails.seriesElementAnimation);
      }
      if (seriesRendererDetails.visible! == true && animationFactor >= 1) {
        stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(HiloPainter oldDelegate) => isRepaint;
}
