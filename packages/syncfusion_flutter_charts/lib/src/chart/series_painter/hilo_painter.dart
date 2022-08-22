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
import '../common/marker.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for hilo series.
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
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    Rect markerClipRect;
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
      markerClipRect = calculatePlotOffset(
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
      // ignore: unnecessary_null_comparison
      final bool isTooltipEnabled = chart.tooltipBehavior != null;
      final bool hasTooltip = isTooltipEnabled &&
          (chart.tooltipBehavior.enable ||
              seriesRendererDetails.series.onPointTap != null ||
              seriesRendererDetails.series.onPointDoubleTap != null ||
              seriesRendererDetails.series.onPointLongPress != null);
      final bool hasSeriesElements = seriesRendererDetails.visible! &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible ||
              (isTooltipEnabled &&
                  chart.tooltipBehavior.enable &&
                  (isTooltipEnabled &&
                      chart.tooltipBehavior.enable &&
                      series.enableTooltip)));
      seriesRendererDetails.sideBySideInfo = calculateSideBySideInfo(
          seriesRendererDetails.renderer, stateProperties);

      final bool showMarker = (series.animationDuration <= 0 ||
              animationFactor >= stateProperties.seriesDurationFactor) &&
          series.markerSettings.isVisible &&
          seriesRendererDetails.markerSettingsRenderer != null;
      late Size size;
      late DataMarkerType markerType;
      late bool hasPointColor;
      Color? seriesColor;
      canvas.clipRect(axisClipRect);
      if (showMarker) {
        seriesRendererDetails.markerShapes = <Path?>[];
        seriesRendererDetails.markerShapes2 = <Path?>[];
        assert(
            // ignore: unnecessary_null_comparison
            !(seriesRendererDetails.series.markerSettings.height != null) ||
                seriesRendererDetails.series.markerSettings.height >= 0,
            'The height of the marker should be greater than or equal to 0.');
        assert(
            // ignore: unnecessary_null_comparison
            !(seriesRendererDetails.series.markerSettings.width != null) ||
                seriesRendererDetails.series.markerSettings.width >= 0,
            'The width of the marker must be greater than or equal to 0.');

        hasPointColor = series.pointColorMapper != null;
      }
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        final bool withInXRange = withInRange(
            point.xValue, seriesRendererDetails.xAxisDetails!.visibleRange!);
        // ignore: unnecessary_null_comparison
        final bool withInHighLowRange = point != null &&
            point.high != null &&
            point.low != null &&
            (withInRange(point.high,
                    seriesRendererDetails.yAxisDetails!.visibleRange!) ||
                withInRange(point.low,
                    seriesRendererDetails.yAxisDetails!.visibleRange!));
        if (withInXRange || withInHighLowRange) {
          if (withInXRange) {
            seriesRendererDetails.visibleDataPoints!
                .add(seriesRendererDetails.dataPoints[pointIndex]);
            seriesRendererDetails.dataPoints[pointIndex].visiblePointIndex =
                seriesRendererDetails.visibleDataPoints!.length - 1;
          }
          if (point.high != null && point.low != null) {
            point.lowPoint = calculatePoint(
                point.xValue,
                point.low,
                seriesRendererDetails.xAxisDetails!,
                seriesRendererDetails.yAxisDetails!,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                axisClipRect);
            point.highPoint = calculatePoint(
                point.xValue,
                point.high,
                seriesRendererDetails.xAxisDetails!,
                seriesRendererDetails.yAxisDetails!,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                axisClipRect);
            ChartLocation? value1, value2;
            value1 = (point.low < point.high) == true
                ? point.highPoint
                : point.lowPoint;
            value2 = (point.low > point.high) == true
                ? point.highPoint
                : point.lowPoint;
            point.markerPoint = yAxisDetails.axis.isInversed ? value2 : value1;
            point.markerPoint2 = yAxisDetails.axis.isInversed ? value1 : value2;

            if (hasSeriesElements) {
              if (point.region == null ||
                  seriesRendererDetails.calculateRegion == true) {
                if (seriesRendererDetails.calculateRegion == true &&
                    dataPoints.length == pointIndex - 1) {
                  seriesRendererDetails.calculateRegion = false;
                }

                point.region = !stateProperties.requireInvertedAxis
                    ? Rect.fromLTWH(
                        point.markerPoint!.x,
                        point.markerPoint!.y,
                        seriesRendererDetails.series.borderWidth,
                        point.markerPoint2!.y - point.markerPoint!.y)
                    : Rect.fromLTWH(
                        point.markerPoint2!.x,
                        point.markerPoint2!.y,
                        (point.markerPoint!.x - point.markerPoint2!.x).abs(),
                        seriesRendererDetails.series.borderWidth);
              }
              if (hasTooltip) {
                calculateTooltipRegion(
                    point, seriesIndex, seriesRendererDetails, stateProperties);
              }
            }

            if (point.isVisible && !point.isGap) {
              seriesRenderer._drawSegment(
                  canvas,
                  seriesRenderer._createSegments(point, segmentIndex += 1,
                      painterKey.index, animationFactor));
            }
            if (showMarker) {
              MarkerRenderArgs? event;
              size = Size(
                  series.markerSettings.width, series.markerSettings.height);
              markerType = series.markerSettings.shape;
              seriesColor = seriesRendererDetails.seriesColor;
              seriesRendererDetails.markerSettingsRenderer!.borderColor =
                  series.markerSettings.borderColor ?? seriesColor;
              seriesRendererDetails.markerSettingsRenderer!.color =
                  series.markerSettings.color;
              seriesRendererDetails.markerSettingsRenderer!.borderWidth =
                  series.markerSettings.borderWidth;
              final bool isMarkerEventTriggered =
                  CartesianPointHelper.getIsMarkerEventTriggered(point);
              if (withInXRange &&
                  withInHighLowRange &&
                  seriesRendererDetails.chart.onMarkerRender != null &&
                  seriesRendererDetails.isMarkerRenderEvent == false) {
                if (seriesRendererDetails.seriesElementAnimation == null ||
                    ((seriesRendererDetails.seriesElementAnimation!.value ==
                                0.0 &&
                            !isMarkerEventTriggered &&
                            seriesRendererDetails
                                    .seriesElementAnimation!.status ==
                                AnimationStatus.forward) ||
                        (seriesRendererDetails.animationController.duration!
                                    .inMilliseconds ==
                                0 &&
                            !isMarkerEventTriggered))) {
                  CartesianPointHelper.setIsMarkerEventTriggered(point, true);
                  event = triggerMarkerRenderEvent(
                      seriesRendererDetails,
                      size,
                      markerType,
                      seriesRendererDetails
                          .dataPoints[pointIndex].visiblePointIndex!,
                      seriesRendererDetails.seriesElementAnimation)!;
                  markerType = event.shape;
                  seriesRendererDetails.markerSettingsRenderer?.borderColor =
                      event.borderColor;
                  seriesRendererDetails.markerSettingsRenderer?.color =
                      event.color;
                  seriesRendererDetails.markerSettingsRenderer?.borderWidth =
                      event.borderWidth;
                  size = Size(event.markerHeight, event.markerWidth);
                  CartesianPointHelper.setMarkerDetails(
                      point,
                      MarkerDetails(
                          markerType: markerType,
                          borderColor: seriesRendererDetails
                              .markerSettingsRenderer?.borderColor,
                          color: seriesRendererDetails
                              .markerSettingsRenderer?.color,
                          borderWidth: seriesRendererDetails
                              .markerSettingsRenderer?.borderWidth,
                          size: size));
                }
              }

              final double opacity =
                  (seriesRendererDetails.seriesElementAnimation != null &&
                          (seriesRendererDetails.stateProperties
                                      .renderingDetails.initialRender! ==
                                  true ||
                              seriesRendererDetails.needAnimateSeriesElements ==
                                  true))
                      ? seriesRendererDetails.seriesElementAnimation!.value
                      : 1;
              final MarkerDetails? pointMarkerDetails =
                  CartesianPointHelper.getMarkerDetails(point);
              seriesRendererDetails.markerShapes.add(getMarkerShapesPath(
                  pointMarkerDetails?.markerType ?? markerType,
                  Offset(point.markerPoint!.x, point.markerPoint!.y),
                  pointMarkerDetails?.size ?? size,
                  seriesRendererDetails,
                  pointIndex,
                  null,
                  seriesRendererDetails.seriesElementAnimation));
              seriesRendererDetails.markerShapes2.add(getMarkerShapesPath(
                  pointMarkerDetails?.markerType ?? markerType,
                  Offset(point.markerPoint2!.x, point.markerPoint2!.y),
                  pointMarkerDetails?.size ?? size,
                  seriesRendererDetails,
                  pointIndex,
                  null,
                  seriesRendererDetails.seriesElementAnimation));

              final Paint strokePaint =
                  seriesRendererDetails.markerSettingsRenderer!.getStrokePaint(
                      point,
                      series,
                      pointMarkerDetails,
                      opacity,
                      hasPointColor,
                      seriesColor,
                      markerType,
                      seriesRendererDetails,
                      seriesRendererDetails.seriesElementAnimation,
                      size);

              final Paint fillPaint =
                  seriesRendererDetails.markerSettingsRenderer!.getFillPaint(
                      point,
                      series,
                      seriesRendererDetails,
                      pointMarkerDetails,
                      opacity);

              // Render marker points.
              if (seriesRendererDetails.markerSettingsRenderer!.withInRect(
                      seriesRendererDetails, point.markerPoint, axisClipRect) &&
                  point.markerPoint != null &&
                  point.isGap != true &&
                  seriesRendererDetails.markerShapes[pointIndex] != null) {
                final bool needToClip = showMarker &&
                    (point.lowPoint!.x == axisClipRect.left ||
                        point.lowPoint!.x == axisClipRect.right ||
                        point.lowPoint!.y == axisClipRect.bottom ||
                        point.highPoint!.y == axisClipRect.top);
                if (needToClip) {
                  canvas.restore();
                  canvas.clipRect(markerClipRect);
                  canvas.save();
                }
                seriesRendererDetails.renderer.drawDataMarker(
                    pointIndex,
                    canvas,
                    fillPaint,
                    strokePaint,
                    point.markerPoint!.x,
                    point.markerPoint!.y,
                    seriesRendererDetails.renderer);
                if (series.markerSettings.shape == DataMarkerType.image) {
                  drawImageMarker(seriesRendererDetails, canvas,
                      point.markerPoint!.x, point.markerPoint!.y);
                  drawImageMarker(seriesRendererDetails, canvas,
                      point.markerPoint2!.x, point.markerPoint2!.y);
                }
                if (needToClip) {
                  canvas.clipRect(axisClipRect);
                }
              }
              seriesRendererDetails.markerSettingsRenderer
                  ?.setMarkerEventTrigged(point, seriesRendererDetails,
                      seriesRendererDetails.seriesElementAnimation);
            }
          }
        } else if (showMarker && !(withInXRange || withInHighLowRange)) {
          seriesRendererDetails.markerShapes.add(null);
          seriesRendererDetails.markerShapes2.add(null);
        }
      }

      canvas.restore();

      if (seriesRendererDetails.visible! == true && animationFactor >= 1) {
        stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(HiloPainter oldDelegate) => isRepaint;
}
