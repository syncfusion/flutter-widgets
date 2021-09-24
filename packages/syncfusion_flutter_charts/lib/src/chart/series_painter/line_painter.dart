import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../axis/axis.dart';
import '../base/chart_base.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_segment/line_segment.dart';
import '../chart_series/line_series.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for Line series
class LineSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of LineSeriesRenderer class.
  LineSeriesRenderer();

  late LineSegment _lineSegment, _segment;

  List<CartesianSeriesRenderer>? _oldSeriesRenderers;

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;

  /// To add line segments to segments list
  ChartSegment _createSegments(
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> _nextPoint,
      int pointIndex,
      int seriesIndex,
      double animateFactor) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    _segment = createSegment();
    SegmentHelper.setSegmentProperties(_segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, _segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(_segment);
    SegmentHelper.setSegmentProperties(_segment, segmentProperties);
    _oldSeriesRenderers =
        _currentSeriesDetails.stateProperties.oldSeriesRenderers;
    segmentProperties.series =
        _currentSeriesDetails.series as XyDataSeries<dynamic, dynamic>;
    segmentProperties.seriesRenderer = this;
    segmentProperties.seriesIndex = seriesIndex;
    segmentProperties.currentPoint = currentPoint;
    _segment.currentSegmentIndex = pointIndex;
    segmentProperties.nextPoint = _nextPoint;
    _segment.animationFactor = animateFactor;
    segmentProperties.pointColorMapper = currentPoint.pointColorMapper;
    _segmentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (_currentSeriesDetails
                .stateProperties.renderingDetails.widgetNeedUpdate ==
            true &&
        _oldSeriesRenderers != null &&
        _oldSeriesRenderers!.isNotEmpty &&
        _oldSeriesRenderers!.length - 1 >= segmentProperties.seriesIndex &&
        SeriesHelper.getSeriesRendererDetails(
                    _oldSeriesRenderers![segmentProperties.seriesIndex])
                .seriesName ==
            _segmentSeriesDetails.seriesName) {
      segmentProperties.oldSeriesRenderer =
          _oldSeriesRenderers![segmentProperties.seriesIndex];
      segmentProperties.oldSegmentIndex = getOldSegmentIndex(_segment);
    }
    _segment.calculateSegmentPoints();
    _segment.points.add(Offset(segmentProperties.x1, segmentProperties.y1));
    _segment.points.add(Offset(segmentProperties.x2, segmentProperties.y2));
    customizeSegment(_segment);
    _currentSeriesDetails.segments.add(_segment);
    return _segment;
  }

  /// To render line series segments
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment _segment) {
    if (_segmentSeriesDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          _segmentSeriesDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              _currentSeriesDetails.segments[_segment.currentSegmentIndex!],
              _currentSeriesDetails.chart);
    }
    _segment.onPaint(canvas);
  }

  /// Creates a _segment for a data point in the series.
  @override
  LineSegment createSegment() => LineSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment _segment) {
    _lineSegment = _segment as LineSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(_lineSegment);
    segmentProperties.color = segmentProperties.pointColorMapper ??
        segmentProperties.series.color ??
        _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = segmentProperties.pointColorMapper ??
        segmentProperties.series.color ??
        _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeWidth = segmentProperties.series.width;
    _lineSegment.strokePaint = _lineSegment.getStrokePaint();
    _lineSegment.fillPaint = _lineSegment.getFillPaint();
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
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

/// Represents the Line Chart painter
class LineChartPainter extends CustomPainter {
  /// Calling the default constructor of LineChartPainter class.
  LineChartPainter(
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

  /// Specifies the line series renderer
  final LineSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for line series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    Rect clipRect;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    if (!chart.legend.isVisible! &&
        !seriesRendererDetails.isSelectionEnable &&
        !chart.zoomPanBehavior.enableDoubleTapZooming &&
        !chart.zoomPanBehavior.enableMouseWheelZooming &&
        !chart.zoomPanBehavior.enablePanning &&
        !chart.zoomPanBehavior.enablePinching &&
        !chart.zoomPanBehavior.enableSelectionZooming) {
      seriesRendererDetails.dispose();
    }

    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    final LineSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as LineSeries<dynamic, dynamic>;
    if (seriesRendererDetails.visible! == true) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      canvas.save();
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
          ((!(renderingDetails.widgetNeedUpdate ||
                      renderingDetails.isLegendToggled) ||
                  !stateProperties.oldSeriesKeys.contains(series.key)) &&
              series.animationDuration > 0)) {
        performLinearAnimation(
            stateProperties, xAxisDetails.axis, canvas, animationFactor);
      }
      int segmentIndex = -1;
      CartesianChartPoint<dynamic>? currentPoint,
          _nextPoint,
          startPoint,
          endPoint;

      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        currentPoint = dataPoints[pointIndex];
        seriesRendererDetails.calculateRegionData(stateProperties,
            seriesRendererDetails, seriesIndex, currentPoint, pointIndex);
        if ((currentPoint.isVisible && !currentPoint.isGap) &&
            startPoint == null) {
          startPoint = currentPoint;
        }
        if (pointIndex + 1 < dataPoints.length) {
          _nextPoint = dataPoints[pointIndex + 1];
          if (startPoint != null && _nextPoint.isVisible && _nextPoint.isGap) {
            startPoint = null;
          } else if (_nextPoint.isVisible && !_nextPoint.isGap) {
            endPoint = _nextPoint;
          }
        }

        if (startPoint != null && endPoint != null) {
          seriesRendererDetails.drawSegment(
              canvas,
              seriesRenderer._createSegments(startPoint, endPoint,
                  segmentIndex += 1, seriesIndex, animationFactor));
          endPoint = startPoint = null;
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
            'The line series should be available to render a marker on it.');
        canvas.clipRect(clipRect);
        seriesRendererDetails.renderSeriesElements(
            chart, canvas, seriesRendererDetails.seriesElementAnimation);
      }
      if (animationFactor >= 1) {
        stateProperties.setPainterKey(seriesIndex, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => isRepaint;
}
