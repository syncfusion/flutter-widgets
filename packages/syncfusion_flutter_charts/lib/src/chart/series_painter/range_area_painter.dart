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

/// Creates series renderer for range area series.
class RangeAreaSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of RangeAreaSeriesRenderer class.
  RangeAreaSeriesRenderer();

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;

  /// Range area segment is created here.
  ChartSegment _createSegments(
      int seriesIndex, SfCartesianChart chart, double animateFactor,
      [List<Offset>? points]) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    final RangeAreaSegment segment = createSegment();
    SegmentHelper.setSegmentProperties(segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    _currentSeriesDetails.isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segmentProperties.seriesIndex = seriesIndex;
      segment.animationFactor = animateFactor;
      segmentProperties.seriesRenderer = this;
      segmentProperties.series =
          _currentSeriesDetails.series as XyDataSeries<dynamic, dynamic>;
      _segmentSeriesDetails = SeriesHelper.getSeriesRendererDetails(
          segmentProperties.seriesRenderer);
      if (points != null) {
        segment.points = points;
      }
      segment.currentSegmentIndex = 0;
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      segmentProperties.oldSegmentIndex = 0;
      _currentSeriesDetails.segments.add(segment);
    }
    return segment;
  }

  /// To render range area series segments.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    if (_segmentSeriesDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          _segmentSeriesDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              _currentSeriesDetails.segments[0], _currentSeriesDetails.chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  RangeAreaSegment createSegment() => RangeAreaSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    segmentProperties.color = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = segmentProperties.series.borderColor;
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

/// Represents the RangeArea Chart painter
class RangeAreaChartPainter extends CustomPainter {
  /// Calling the default constructor of RangeAreaChartPainter class.
  RangeAreaChartPainter(
      {required this.stateProperties,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required this.painterKey,
      required ValueNotifier<num> notifier})
      : chart = stateProperties.chart,
        super(repaint: notifier);

  /// Represents the Cartesian state properties
  final CartesianStateProperties stateProperties;

  /// Represents the Cartesian chart.
  final SfCartesianChart chart;

  /// Specifies whether to repaint the series.
  final bool isRepaint;

  /// Specifies the value of animation controller.
  final Animation<double> animationController;

  /// Specifies the range area series renderer
  final RangeAreaSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for range area series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);

    final RangeAreaSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as RangeAreaSeries<dynamic, dynamic>;
    Rect clipRect;
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    CartesianSeriesRenderer? oldSeriesRenderer;
    SeriesRendererDetails? oldSeriesRendererDetails;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    CartesianChartPoint<dynamic>? point, prevPoint, oldPoint;
    final Path path = Path();
    ChartLocation? currentPointLow, currentPointHigh, oldPointLow, oldPointHigh;
    double currentLowX, currentLowY, currentHighX, currentHighY;
    double animationFactor;
    final Path borderPath = Path();
    RangeAreaSegment rangeAreaSegment;
    final List<Offset> points = <Offset>[];
    if (seriesRendererDetails.visible! == true) {
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
      final List<CartesianSeriesRenderer> oldSeriesRenderers =
          stateProperties.oldSeriesRenderers;
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
      final bool isTransposed = stateProperties.requireInvertedAxis;
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

      animationFactor = seriesRendererDetails.seriesAnimation != null
          ? seriesRendererDetails.seriesAnimation!.value
          : 1;
      stateProperties.shader = null;
      if (series.onCreateShader != null) {
        stateProperties.shader = series.onCreateShader!(
            ShaderDetails(stateProperties.chartAxis.axisClipRect, 'series'));
      }
      if (seriesRendererDetails.reAnimate == true ||
          ((!(renderingDetails.widgetNeedUpdate ||
                      renderingDetails.isLegendToggled) ||
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
          oldPoint = getOldChartPoint(
              stateProperties,
              seriesRendererDetails,
              RangeAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          if (oldPoint != null) {
            oldPointLow = calculatePoint(
                oldPoint.xValue,
                oldPoint.low,
                oldSeriesRendererDetails!.xAxisDetails!,
                oldSeriesRendererDetails.yAxisDetails!,
                isTransposed,
                oldSeriesRendererDetails.series,
                axisClipRect);
            oldPointHigh = calculatePoint(
                oldPoint.xValue,
                oldPoint.high,
                oldSeriesRendererDetails.xAxisDetails!,
                oldSeriesRendererDetails.yAxisDetails!,
                isTransposed,
                oldSeriesRendererDetails.series,
                axisClipRect);
          } else {
            oldPointLow = oldPointHigh = null;
          }
          currentPointLow = calculatePoint(point.xValue, point.low,
              xAxisDetails, yAxisDetails, isTransposed, series, axisClipRect);
          currentPointHigh = calculatePoint(point.xValue, point.high,
              xAxisDetails, yAxisDetails, isTransposed, series, axisClipRect);
          points.add(Offset(currentPointLow.x, currentPointLow.y));
          points.add(Offset(currentPointHigh.x, currentPointHigh.y));

          currentLowX = currentPointLow.x;
          currentLowY = currentPointLow.y;
          currentHighX = currentPointHigh.x;
          currentHighY = currentPointHigh.y;
          if (oldPointLow != null) {
            if (chart.isTransposed) {
              currentLowX = getAnimateValue(animationFactor, currentLowX,
                  oldPointLow.x, currentPointLow.x, seriesRendererDetails);
            } else {
              currentLowY = getAnimateValue(animationFactor, currentLowY,
                  oldPointLow.y, currentPointLow.y, seriesRendererDetails);
            }
          }
          if (oldPointHigh != null) {
            if (chart.isTransposed) {
              currentHighX = getAnimateValue(animationFactor, currentHighX,
                  oldPointHigh.x, currentPointHigh.x, seriesRendererDetails);
            } else {
              currentHighY = getAnimateValue(animationFactor, currentHighY,
                  oldPointHigh.y, currentPointHigh.y, seriesRendererDetails);
            }
          }
          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            path.moveTo(currentLowX, currentLowY);
            path.lineTo(currentHighX, currentHighY);
            borderPath.moveTo(currentHighX, currentHighY);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            path.lineTo(currentHighX, currentHighY);
            path.lineTo(currentLowX, currentLowY);
            borderPath.lineTo(currentHighX, currentHighY);
            borderPath.moveTo(currentLowX, currentLowY);
          } else {
            borderPath.lineTo(currentHighX, currentHighY);
            path.lineTo(currentHighX, currentHighY);
          }
          prevPoint = point;
        }
        if (pointIndex >= dataPoints.length - 1) {
          seriesRenderer._createSegments(
              painterKey.index, chart, animationFactor, points);
        }
      }
      for (int pointIndex = dataPoints.length - 2;
          pointIndex >= 0;
          pointIndex--) {
        point = dataPoints[pointIndex];
        if (point.isVisible && !point.isDrop) {
          oldPoint = getOldChartPoint(
              stateProperties,
              seriesRendererDetails,
              RangeAreaSegment,
              seriesIndex,
              pointIndex,
              oldSeriesRenderer,
              oldSeriesRenderers);
          if (oldPoint != null) {
            oldPointLow = calculatePoint(
                oldPoint.xValue,
                oldPoint.low,
                oldSeriesRendererDetails!.xAxisDetails!,
                oldSeriesRendererDetails.yAxisDetails!,
                isTransposed,
                oldSeriesRendererDetails.series,
                axisClipRect);
            oldPointHigh = calculatePoint(
                oldPoint.xValue,
                oldPoint.high,
                oldSeriesRendererDetails.xAxisDetails!,
                oldSeriesRendererDetails.yAxisDetails!,
                isTransposed,
                oldSeriesRendererDetails.series,
                axisClipRect);
          } else {
            oldPointLow = oldPointHigh = null;
          }
          currentPointLow = calculatePoint(point.xValue, point.low,
              xAxisDetails, yAxisDetails, isTransposed, series, axisClipRect);
          currentPointHigh = calculatePoint(point.xValue, point.high,
              xAxisDetails, yAxisDetails, isTransposed, series, axisClipRect);

          currentLowX = currentPointLow.x;
          currentLowY = currentPointLow.y;
          currentHighX = currentPointHigh.x;
          currentHighY = currentPointHigh.y;

          if (oldPointLow != null) {
            if (chart.isTransposed) {
              currentLowX = getAnimateValue(animationFactor, currentLowX,
                  oldPointLow.x, currentPointLow.x, seriesRendererDetails);
            } else {
              currentLowY = getAnimateValue(animationFactor, currentLowY,
                  oldPointLow.y, currentPointLow.y, seriesRendererDetails);
            }
          }
          if (oldPointHigh != null) {
            if (chart.isTransposed) {
              currentHighX = getAnimateValue(animationFactor, currentHighX,
                  oldPointHigh.x, currentPointHigh.x, seriesRendererDetails);
            } else {
              currentHighY = getAnimateValue(animationFactor, currentHighY,
                  oldPointHigh.y, currentPointHigh.y, seriesRendererDetails);
            }
          }
          if (dataPoints[pointIndex + 1].isGap == true) {
            borderPath.moveTo(currentLowX, currentLowY);
            path.moveTo(currentLowX, currentLowY);
          } else if (dataPoints[pointIndex].isGap != true) {
            if (pointIndex + 1 == dataPoints.length - 1 &&
                dataPoints[pointIndex + 1].isDrop) {
              borderPath.moveTo(currentLowX, currentLowY);
            } else {
              borderPath.lineTo(currentLowX, currentLowY);
            }
            path.lineTo(currentLowX, currentLowY);
          }

          prevPoint = point;
        }
      }
      // ignore: unnecessary_null_comparison
      if (path != null &&
          // ignore: unnecessary_null_comparison
          seriesRendererDetails.segments != null &&
          seriesRendererDetails.segments.isNotEmpty == true) {
        rangeAreaSegment =
            seriesRendererDetails.segments[0] as RangeAreaSegment;
        SegmentHelper.getSegmentProperties(rangeAreaSegment)
          ..path = path
          ..borderPath = borderPath;
        seriesRendererDetails.drawSegment(canvas, rangeAreaSegment);
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
              !renderingDetails.initialRender! ||
              animationFactor >= stateProperties.seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The range area series should be available to render a marker on it.');
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
  bool shouldRepaint(RangeAreaChartPainter oldDelegate) => isRepaint;
}
