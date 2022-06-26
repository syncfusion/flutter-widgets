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
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for hilo open close series.
class HiloOpenCloseSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of HiloOpenCloseSeriesRenderer class.
  HiloOpenCloseSeriesRenderer();

  late HiloOpenCloseSegment _segment;

  List<CartesianSeriesRenderer>? _oldSeriesRenderers;

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;
  late SeriesRendererDetails _oldSeriesDetails;

  /// Hilo open close _segment is created here.
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    _segment = createSegment();
    SegmentHelper.setSegmentProperties(_segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, _segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(_segment);
    _oldSeriesRenderers =
        _currentSeriesDetails.stateProperties.oldSeriesRenderers;
    _currentSeriesDetails.isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (_segment != null) {
      segmentProperties.seriesIndex = seriesIndex;
      _segment.currentSegmentIndex = pointIndex;
      segmentProperties.seriesRenderer = this;
      segmentProperties.series =
          _currentSeriesDetails.series as XyDataSeries<dynamic, dynamic>;
      _segment.animationFactor = animateFactor;
      segmentProperties.pointColorMapper = currentPoint.pointColorMapper;
      segmentProperties.currentPoint = currentPoint;
      if (_oldSeriesRenderers!.isNotEmpty &&
          _oldSeriesRenderers!.length > segmentProperties.seriesIndex) {
        _oldSeriesDetails = SeriesHelper.getSeriesRendererDetails(
            _oldSeriesRenderers![segmentProperties.seriesIndex]);
      }

      _segmentSeriesDetails = SeriesHelper.getSeriesRendererDetails(
          segmentProperties.seriesRenderer);
      if (_currentSeriesDetails.stateProperties.renderingDetails.widgetNeedUpdate ==
              true &&
          _currentSeriesDetails
                  .stateProperties.renderingDetails.isLegendToggled ==
              false &&
          _oldSeriesRenderers != null &&
          _oldSeriesRenderers!.isNotEmpty &&
          _oldSeriesRenderers!.length - 1 >= segmentProperties.seriesIndex &&
          _oldSeriesDetails.seriesName == _segmentSeriesDetails.seriesName) {
        segmentProperties.oldSeriesRenderer =
            _oldSeriesRenderers![segmentProperties.seriesIndex];
        segmentProperties.oldSegmentIndex = getOldSegmentIndex(_segment);
      }
      _segment.calculateSegmentPoints();
      //stores the points for rendering Hilo open close segment, High, low, open, close
      _segment.points
        ..add(
            Offset(currentPoint.markerPoint!.x, segmentProperties.highPoint.y))
        ..add(Offset(currentPoint.markerPoint!.x, segmentProperties.lowPoint.y))
        ..add(Offset(segmentProperties.openX, segmentProperties.openY))
        ..add(Offset(segmentProperties.closeX, segmentProperties.closeY));
      customizeSegment(_segment);
      _segment.strokePaint = _segment.getStrokePaint();
      _segment.fillPaint = _segment.getFillPaint();
      _currentSeriesDetails.segments.add(_segment);
    }
    return _segment;
  }

  /// To render hilo open close series segments.
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

  @override
  HiloOpenCloseSegment createSegment() => HiloOpenCloseSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    _currentSeriesDetails.hiloOpenCloseSeries =
        _currentSeriesDetails.series as HiloOpenCloseSeries<dynamic, dynamic>;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    segmentProperties.color = _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor =
        segment is HiloOpenCloseSegment && segmentProperties.isBull == true
            ? _currentSeriesDetails.hiloOpenCloseSeries.bullColor
            : _currentSeriesDetails.hiloOpenCloseSeries.bearColor;
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
  }

  /// Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {}

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}

/// Represents the HiloOpenClose series painter
class HiloOpenClosePainter extends CustomPainter {
  /// Calling the default constructor of HiloOpenClosePainter class.
  HiloOpenClosePainter(
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

  /// Specifies the Hilo open close series renderer
  HiloOpenCloseSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for Hilo open-close  series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    CartesianChartPoint<dynamic> point;
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
    final HiloOpenCloseSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as HiloOpenCloseSeries<dynamic, dynamic>;
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

      seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
      // ignore: unnecessary_null_comparison
      final bool isTooltipEnabled = chart.tooltipBehavior != null;
      final bool hasTooltip = isTooltipEnabled &&
          (chart.tooltipBehavior.enable ||
              seriesRendererDetails.series.onPointTap != null ||
              seriesRendererDetails.series.onPointDoubleTap != null ||
              seriesRendererDetails.series.onPointLongPress != null);
      final bool hasSeriesElements = seriesRendererDetails.visible! &&
          (series.dataLabelSettings.isVisible ||
              (isTooltipEnabled &&
                  chart.tooltipBehavior.enable &&
                  (isTooltipEnabled &&
                      chart.tooltipBehavior.enable &&
                      series.enableTooltip)));
      seriesRendererDetails.sideBySideInfo = calculateSideBySideInfo(
          seriesRendererDetails.renderer, stateProperties);
      final num? sideBySideMinimumVal =
          seriesRendererDetails.sideBySideInfo?.minimum;

      final num? sideBySideMaximumVal =
          seriesRendererDetails.sideBySideInfo?.maximum;
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        final bool withInXRange = withInRange(
            point.xValue, seriesRendererDetails.xAxisDetails!.visibleRange!);
        bool withInHighLowRange = false, withInOpenCloseRange = false;
        // ignore: unnecessary_null_comparison
        if (point != null &&
            point.high != null &&
            point.low != null &&
            point.open != null &&
            point.close != null) {
          withInHighLowRange = withInRange(point.high,
                  seriesRendererDetails.yAxisDetails!.visibleRange!) &&
              withInRange(
                  point.low, seriesRendererDetails.yAxisDetails!.visibleRange!);
          withInOpenCloseRange = withInRange(point.open,
                  seriesRendererDetails.yAxisDetails!.visibleRange!) &&
              withInRange(point.close,
                  seriesRendererDetails.yAxisDetails!.visibleRange!);

          if (withInXRange || (withInHighLowRange && withInOpenCloseRange)) {
            if (withInXRange) {
              seriesRendererDetails.visibleDataPoints!
                  .add(seriesRendererDetails.dataPoints[pointIndex]);
              seriesRendererDetails.dataPoints[pointIndex].visiblePointIndex =
                  seriesRendererDetails.visibleDataPoints!.length - 1;
            }
            point.openPoint = calculatePoint(
                point.xValue + sideBySideMinimumVal,
                point.open,
                seriesRendererDetails.xAxisDetails!,
                seriesRendererDetails.yAxisDetails!,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                axisClipRect);

            point.closePoint = calculatePoint(
                point.xValue + sideBySideMaximumVal,
                point.close,
                seriesRendererDetails.xAxisDetails!,
                seriesRendererDetails.yAxisDetails!,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                axisClipRect);
            point.lowPoint = calculatePoint(
                point.xValue + sideBySideMinimumVal,
                point.low,
                seriesRendererDetails.xAxisDetails!,
                seriesRendererDetails.yAxisDetails!,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                axisClipRect);
            point.highPoint = calculatePoint(
                point.xValue + sideBySideMaximumVal,
                point.high,
                seriesRendererDetails.xAxisDetails!,
                seriesRendererDetails.yAxisDetails!,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                axisClipRect);
            final num center = (point.xValue + sideBySideMinimumVal) +
                (((point.xValue + sideBySideMaximumVal) -
                        (point.xValue + sideBySideMinimumVal)) /
                    2);

            point.centerHighPoint = calculatePoint(
                center,
                point.high,
                seriesRendererDetails.xAxisDetails!,
                seriesRendererDetails.yAxisDetails!,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                axisClipRect);

            point.centerLowPoint = calculatePoint(
                center,
                point.low,
                seriesRendererDetails.xAxisDetails!,
                seriesRendererDetails.yAxisDetails!,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                axisClipRect);
            final num value1 =
                (point.low < point.high) == true ? point.high : point.low;
            final num value2 =
                (point.low > point.high) == true ? point.high : point.low;
            point.markerPoint = calculatePoint(
                point.xValue,
                yAxisDetails.axis.isInversed ? value2 : value1,
                xAxisDetails,
                yAxisDetails,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                axisClipRect);

            if (hasSeriesElements) {
              if (point.region == null ||
                  seriesRendererDetails.calculateRegion == true) {
                if (seriesRendererDetails.calculateRegion == true &&
                    dataPoints.length == pointIndex - 1) {
                  seriesRendererDetails.calculateRegion = false;
                }

                point.markerPoint2 = calculatePoint(
                    point.xValue,
                    yAxisDetails.axis.isInversed ? value1 : value2,
                    xAxisDetails,
                    yAxisDetails,
                    stateProperties.requireInvertedAxis,
                    seriesRendererDetails.series,
                    axisClipRect);
                if (seriesRendererDetails.series.dataLabelSettings.isVisible ==
                    true) {
                  point.centerOpenPoint = calculatePoint(
                      point.xValue,
                      point.open,
                      seriesRendererDetails.xAxisDetails!,
                      seriesRendererDetails.yAxisDetails!,
                      stateProperties.requireInvertedAxis,
                      seriesRendererDetails.series,
                      axisClipRect);

                  point.centerClosePoint = calculatePoint(
                      point.xValue,
                      point.close,
                      seriesRendererDetails.xAxisDetails!,
                      seriesRendererDetails.yAxisDetails!,
                      stateProperties.requireInvertedAxis,
                      seriesRendererDetails.series,
                      axisClipRect);
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
              seriesRendererDetails.drawSegment(
                  canvas,
                  seriesRenderer._createSegments(point, segmentIndex += 1,
                      painterKey.index, animationFactor));
            }
          }
        }
      }

      canvas.restore();
      if (seriesRendererDetails.visible! == true && animationFactor >= 1) {
        stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(HiloOpenClosePainter oldDelegate) => isRepaint;
}
