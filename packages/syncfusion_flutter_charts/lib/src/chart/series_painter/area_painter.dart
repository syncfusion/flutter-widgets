import 'dart:math' as math_lib;

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
import '../utils/helper.dart';

/// Creates series renderer for area series.
class AreaSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of AreaSeriesRenderer class.
  AreaSeriesRenderer();

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;

  /// Creates a segment for a data point in the series.
  ChartSegment _createSegments(
      Path path, Path strokePath, int seriesIndex, double animateFactor,
      [List<Offset>? points]) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    final AreaSegment segment = createSegment();
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _currentSeriesDetails.stateProperties.oldSeriesRenderers;
    segmentProperties.series =
        _currentSeriesDetails.series as XyDataSeries<dynamic, dynamic>;
    segment.currentSegmentIndex = 0;
    if (points != null) {
      segment.points = points;
    }
    segmentProperties.seriesRenderer = this;
    segmentProperties.seriesIndex = seriesIndex;
    segment.animationFactor = animateFactor;
    segmentProperties.path = path;
    segmentProperties.strokePath = strokePath;
    _segmentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (_currentSeriesDetails
                .stateProperties.renderingDetails.widgetNeedUpdate ==
            true &&
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
      segmentProperties.oldSegmentIndex = 0;
    }
    customizeSegment(segment);
    _currentSeriesDetails.segments.add(segment);
    return segment;
  }

  /// To draw area segments.
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

  /// To create area series segments.
  @override
  AreaSegment createSegment() => AreaSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final AreaSegment areaSegment = segment as AreaSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(areaSegment);
    segmentProperties.color = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeWidth = segmentProperties.series.width;
    areaSegment.strokePaint = areaSegment.getStrokePaint();
    areaSegment.fillPaint = areaSegment.getFillPaint();
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

/// Represents the area chart painter
class AreaChartPainter extends CustomPainter {
  /// Creates an instance of area chart painter
  AreaChartPainter(
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

  /// Represents the value of chart
  final SfCartesianChart chart;

  /// Specifies whether to repaint the series
  final bool isRepaint;

  /// Specifies the value of animation controller
  final Animation<double> animationController;

  /// Specifies the area series renderer
  final AreaSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for area series
  @override
  void paint(Canvas canvas, Size size) {
    final int seriesIndex = painterKey.index;
    Rect clipRect;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);

    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);

    final AreaSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as AreaSeries<dynamic, dynamic>;
    seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
    double animationFactor;
    CartesianChartPoint<dynamic>? prevPoint, point, oldChartPoint;
    ChartLocation? currentPoint, originPoint, oldPoint;
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    CartesianSeriesRenderer? oldSeriesRenderer;
    SeriesRendererDetails? oldSeriesRendererDetails;
    final Path path = Path();
    final Path strokePath = Path();
    final num? crossesAt = getCrossesAtValue(seriesRenderer, stateProperties);
    final num origin = crossesAt ?? 0;
    final List<Offset> points = <Offset>[];
    if (seriesRendererDetails.visible! == true) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the area series must be greater than or equal to 0.');
      final List<CartesianSeriesRenderer> oldSeriesRenderers =
          stateProperties.oldSeriesRenderers;
      final List<CartesianChartPoint<dynamic>> dataPoints =
          seriesRendererDetails.dataPoints;
      final bool widgetNeedUpdate = renderingDetails.widgetNeedUpdate;
      final bool isLegendToggled = renderingDetails.isLegendToggled;
      final bool isTransposed =
          seriesRendererDetails.stateProperties.requireInvertedAxis;
      canvas.save();
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

      oldSeriesRenderer = getOldSeriesRenderer(stateProperties,
          seriesRendererDetails, seriesIndex, oldSeriesRenderers);

      if (oldSeriesRenderer != null) {
        oldSeriesRendererDetails =
            SeriesHelper.getSeriesRendererDetails(oldSeriesRenderer);
      }

      if (seriesRendererDetails.reAnimate == true ||
          ((!(widgetNeedUpdate || isLegendToggled) ||
                  !stateProperties.oldSeriesKeys.contains(series.key)) &&
              series.animationDuration > 0)) {
        performLinearAnimation(
            stateProperties, xAxisDetails.axis, canvas, animationFactor);
      }
      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }

      seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRendererDetails.calculateRegionData(stateProperties,
            seriesRendererDetails, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          oldChartPoint = getOldChartPoint(
              stateProperties,
              seriesRendererDetails,
              AreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          oldPoint = oldChartPoint != null
              ? calculatePoint(
                  oldChartPoint.xValue,
                  oldChartPoint.yValue,
                  oldSeriesRendererDetails!.xAxisDetails!,
                  oldSeriesRendererDetails.yAxisDetails!,
                  isTransposed,
                  oldSeriesRendererDetails.series,
                  axisClipRect)
              : null;
          currentPoint = calculatePoint(point.xValue, point.yValue,
              xAxisDetails, yAxisDetails, isTransposed, series, axisClipRect);
          originPoint = calculatePoint(
              point.xValue,
              math_lib.max(yAxisDetails.visibleRange!.minimum, origin),
              xAxisDetails,
              yAxisDetails,
              isTransposed,
              series,
              axisClipRect);
          double x = currentPoint.x;
          double y = currentPoint.y;
          points.add(Offset(x, y));
          final bool closed =
              series.emptyPointSettings.mode == EmptyPointMode.drop &&
                  _getSeriesVisibility(dataPoints, pointIndex);
          if (oldPoint != null) {
            isTransposed
                ? x = getAnimateValue(animationFactor, x, oldPoint.x,
                    currentPoint.x, seriesRendererDetails)
                : y = getAnimateValue(animationFactor, y, oldPoint.y,
                    currentPoint.y, seriesRendererDetails);
          }
          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            path.moveTo(originPoint.x, originPoint.y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom ||
                series.borderDrawMode == BorderDrawMode.all) {
              if (dataPoints[pointIndex].isGap != true) {
                strokePath.moveTo(originPoint.x, originPoint.y);
                strokePath.lineTo(x, y);
              }
            } else if (series.borderDrawMode == BorderDrawMode.top) {
              strokePath.moveTo(x, y);
            }
            path.lineTo(x, y);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            strokePath.lineTo(x, y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
              strokePath.lineTo(originPoint.x, originPoint.y);
            } else if (series.borderDrawMode == BorderDrawMode.all) {
              strokePath.lineTo(originPoint.x, originPoint.y);
              strokePath.close();
            }
            path.lineTo(x, y);
            path.lineTo(originPoint.x, originPoint.y);
          } else {
            strokePath.lineTo(x, y);
            path.lineTo(x, y);

            if (closed) {
              path.lineTo(originPoint.x, originPoint.y);
              if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
                strokePath.lineTo(originPoint.x, originPoint.y);
              } else if (series.borderDrawMode == BorderDrawMode.all) {
                strokePath.lineTo(originPoint.x, originPoint.y);
                strokePath.close();
              }
            }
          }
          prevPoint = point;
        }
      }
      // ignore: unnecessary_null_comparison
      if (path != null) {
        seriesRendererDetails.drawSegment(
            canvas,
            seriesRenderer._createSegments(
                path, strokePath, painterKey.index, animationFactor, points));
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
            'The area series should be available to render a marker on it.');
        canvas.clipRect(clipRect);
        seriesRendererDetails.renderSeriesElements(
            chart, canvas, seriesRendererDetails.seriesElementAnimation);
      }
      if (animationFactor >= 1) {
        stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  /// It returns the visibility of area series.
  bool _getSeriesVisibility(
      List<CartesianChartPoint<dynamic>> points, int index) {
    for (int i = index; i < points.length - 1; i++) {
      if (!points[i + 1].isDrop) {
        return false;
      }
    }
    return true;
  }

  @override
  bool shouldRepaint(AreaChartPainter oldDelegate) => isRepaint;
}
