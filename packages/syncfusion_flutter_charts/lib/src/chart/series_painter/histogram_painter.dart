import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../axis/axis.dart';
import '../base/series_base.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for histogram series.
class HistogramSeriesRenderer extends XyDataSeriesRenderer {
  late HistogramSegment _segment;
  late HistogramSeries<dynamic, dynamic> _histogramSeries;
  BorderRadius? _borderRadius;

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;
  late SeriesRendererDetails _oldSeriesDetails;

  /// Find the path for distribution line in the histogram.
  Path _findNormalDistributionPath(
      HistogramSeries<dynamic, dynamic> series, SfCartesianChart chart) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final num min = seriesRendererDetails.xAxisDetails!.visibleRange!.minimum;
    final num max = seriesRendererDetails.xAxisDetails!.visibleRange!.maximum;
    num xValue, yValue;
    final Path path = Path();
    ChartLocation pointLocation;
    const num pointsCount = 500;
    final num del = (max - min) / (pointsCount - 1);
    for (int i = 0; i < pointsCount; i++) {
      xValue = min + i * del;
      yValue = math.exp(
              -(xValue - seriesRendererDetails.histogramValues.mean!) *
                  (xValue - seriesRendererDetails.histogramValues.mean!) /
                  (2 *
                      seriesRendererDetails.histogramValues.sDValue! *
                      seriesRendererDetails.histogramValues.sDValue!)) /
          (seriesRendererDetails.histogramValues.sDValue! *
              math.sqrt(2 * math.pi));
      pointLocation = calculatePoint(
          xValue,
          yValue *
              seriesRendererDetails.histogramValues.binWidth! *
              seriesRendererDetails.histogramValues.yValues!.length,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          series,
          seriesRendererDetails.stateProperties.chartAxis.axisClipRect);
      i == 0
          ? path.moveTo(pointLocation.x, pointLocation.y)
          : path.lineTo(pointLocation.x, pointLocation.y);
    }
    return path;
  }

  /// To add histogram segments to segments list.
  ChartSegment _createSegments(
      CartesianChartPoint<dynamic> currentPoint,
      int pointIndex,
      VisibleRange sideBySideInfo,
      int seriesIndex,
      double animateFactor) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    _segment = createSegment();
    SegmentHelper.setSegmentProperties(_segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, _segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(_segment);
    _currentSeriesDetails.oldSeriesRenderers =
        _currentSeriesDetails.stateProperties.oldSeriesRenderers;
    _histogramSeries =
        _currentSeriesDetails.series as HistogramSeries<dynamic, dynamic>;
    _borderRadius = _histogramSeries.borderRadius;
    segmentProperties.seriesRenderer = this;
    segmentProperties.series = _histogramSeries;
    segmentProperties.seriesIndex = seriesIndex;
    _segment.currentSegmentIndex = pointIndex;
    _segment.points
        .add(Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
    _segment.animationFactor = animateFactor;
    final num origin =
        math.max(_currentSeriesDetails.yAxisDetails!.visibleRange!.minimum, 0);
    currentPoint.region = calculateRectangle(
        currentPoint.xValue + sideBySideInfo.minimum,
        currentPoint.yValue,
        currentPoint.xValue + sideBySideInfo.maximum,
        math.max(_currentSeriesDetails.yAxisDetails!.visibleRange!.minimum, 0),
        this,
        _currentSeriesDetails.stateProperties);
    segmentProperties.currentPoint = currentPoint;
    _segmentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (_currentSeriesDetails.stateProperties.renderingDetails.widgetNeedUpdate ==
            true &&
        _currentSeriesDetails
                .stateProperties.renderingDetails.isLegendToggled ==
            false &&
        _currentSeriesDetails.oldSeriesRenderers != null &&
        _currentSeriesDetails.oldSeriesRenderers!.isNotEmpty == true &&
        (_currentSeriesDetails.oldSeriesRenderers!.length - 1 >=
                segmentProperties.seriesIndex) ==
            true) {
      _oldSeriesDetails = SeriesHelper.getSeriesRendererDetails(
          _currentSeriesDetails
              .oldSeriesRenderers![segmentProperties.seriesIndex]);
      if (_oldSeriesDetails.seriesName == _segmentSeriesDetails.seriesName) {
        segmentProperties.oldSeriesRenderer = _currentSeriesDetails
            .oldSeriesRenderers![segmentProperties.seriesIndex];
        final SeriesRendererDetails segmentOldSeriesDetails =
            SeriesHelper.getSeriesRendererDetails(
                segmentProperties.oldSeriesRenderer!);
        segmentProperties
            .oldPoint = (segmentOldSeriesDetails.segments.isNotEmpty == true &&
                segmentOldSeriesDetails.segments[0] is HistogramSegment &&
                (segmentOldSeriesDetails.dataPoints.length - 1 >= pointIndex) ==
                    true)
            ? segmentOldSeriesDetails.dataPoints[pointIndex]
            : null;
        segmentProperties.oldSegmentIndex = getOldSegmentIndex(_segment);
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
        final HistogramSegment oldSegment = _currentSeriesDetails
            .stateProperties.segments[i] as HistogramSegment;
        if (oldSegment.currentSegmentIndex == _segment.currentSegmentIndex &&
            SegmentHelper.getSegmentProperties(oldSegment).seriesIndex ==
                segmentProperties.seriesIndex) {
          segmentProperties.oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }
    segmentProperties.path = findingRectSeriesDashedBorder(
        currentPoint, _histogramSeries.borderWidth);
    if (_borderRadius != null) {
      _segment.segmentRect =
          getRRectFromRect(currentPoint.region!, _borderRadius!);
    }
    //Tracker rect
    if (_histogramSeries.isTrackVisible) {
      currentPoint.trackerRectRegion = calculateShadowRectangle(
          currentPoint.xValue + sideBySideInfo.minimum,
          currentPoint.yValue,
          currentPoint.xValue + sideBySideInfo.maximum,
          origin,
          this,
          _currentSeriesDetails.stateProperties,
          Offset(_segmentSeriesDetails.xAxisDetails!.axis.plotOffset,
              _segmentSeriesDetails.yAxisDetails!.axis.plotOffset));
      if (_borderRadius != null) {
        segmentProperties.trackRect =
            getRRectFromRect(currentPoint.trackerRectRegion!, _borderRadius!);
      }
    }
    segmentProperties.segmentRect = _segment.segmentRect;
    customizeSegment(_segment);
    _currentSeriesDetails.segments.add(_segment);
    return _segment;
  }

  /// Creates a segment for a data point in the series.
  @override
  HistogramSegment createSegment() => HistogramSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final HistogramSegment histogramSegment = segment as HistogramSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(histogramSegment);
    segmentProperties.color =
        segmentProperties.currentPoint!.pointColorMapper ??
            _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = segmentProperties.series.borderColor;
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
    histogramSegment.strokePaint = histogramSegment.getStrokePaint();
    histogramSegment.fillPaint = histogramSegment.getFillPaint();
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

/// Represents the Histogram Chart painter
class HistogramChartPainter extends CustomPainter {
  /// Calling the default constructor of HistogramChartPainter class.
  HistogramChartPainter(
      {required this.stateProperties,
      required this.seriesRenderer,
      required this.chartSeries,
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

  /// Specifies the histogram series renderer
  HistogramSeriesRenderer seriesRenderer;

  /// Holds the information of seriesBase class
  ChartSeriesPanel chartSeries;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for histogram series
  @override
  void paint(Canvas canvas, Size size) {
    Rect axisClipRect, clipRect;
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
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;

    /// Clip rect added
    if (seriesRendererDetails.visible! == true) {
      final HistogramSeries<dynamic, dynamic> series =
          seriesRendererDetails.series as HistogramSeries<dynamic, dynamic>;
      canvas.save();
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the fast line series must be greater or equal to 0.');
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

      /// side by side range calculated

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
          seriesRendererDetails.calculateRegionData(
              stateProperties,
              seriesRendererDetails,
              painterKey.index,
              point,
              pointIndex,
              seriesRendererDetails.sideBySideInfo);
          if (point.isVisible && !point.isGap) {
            seriesRendererDetails.drawSegment(
                canvas,
                seriesRenderer._createSegments(
                    point,
                    segmentIndex += 1,
                    seriesRendererDetails.sideBySideInfo!,
                    painterKey.index,
                    animationFactor));
          }
        }
      }
      if (series.showNormalDistributionCurve) {
        if (seriesRendererDetails.reAnimate == true ||
            ((!(renderingDetails.widgetNeedUpdate ||
                        renderingDetails.isLegendToggled) ||
                    !stateProperties.oldSeriesKeys.contains(series.key)) &&
                series.animationDuration > 0)) {
          performLinearAnimation(
              stateProperties, xAxisDetails.axis, canvas, animationFactor);
        }
        final Path path =
            seriesRenderer._findNormalDistributionPath(series, chart);
        final Paint paint = Paint()
          ..strokeWidth = series.curveWidth
          ..color = series.curveColor
          ..style = PaintingStyle.stroke;
        series.curveDashArray == null
            ? canvas.drawPath(path, paint)
            : drawDashedLine(canvas, series.curveDashArray!, paint, path);
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
              !renderingDetails.initialRender! ||
              animationFactor >= stateProperties.seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The histogram series should be available to render a marker on it.');
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
  bool shouldRepaint(HistogramChartPainter oldDelegate) => isRepaint;
}
