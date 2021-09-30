import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../charts.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../axis/axis.dart';
import '../base/chart_base.dart';
import '../chart_segment/candle_segment.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/candle_series.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for Candle series
class CandleSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of CandleSeriesRenderer class.
  CandleSeriesRenderer();

  late CandleSegment _candleSegment, _segment;

  late CandleSeriesRenderer _candelSeriesRenderer;

  List<CartesianSeriesRenderer>? _oldSeriesRenderers;

  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;
  late SeriesRendererDetails _oldSeriesDetails;

  /// Range column _segment is created here
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
      _segmentSeriesDetails = SeriesHelper.getSeriesRendererDetails(
          segmentProperties.seriesRenderer);
      if (_currentSeriesDetails.stateProperties.renderingDetails.widgetNeedUpdate ==
              true &&
          _currentSeriesDetails
                  .stateProperties.renderingDetails.isLegendToggled ==
              false &&
          _oldSeriesRenderers != null &&
          _oldSeriesRenderers!.isNotEmpty &&
          _oldSeriesRenderers!.length - 1 >= segmentProperties.seriesIndex) {
        _oldSeriesDetails = SeriesHelper.getSeriesRendererDetails(
            _oldSeriesRenderers![segmentProperties.seriesIndex]);
        if (_oldSeriesDetails.seriesName == _segmentSeriesDetails.seriesName) {
          segmentProperties.oldSeriesRenderer =
              _oldSeriesRenderers![segmentProperties.seriesIndex];
          segmentProperties.oldSegmentIndex = getOldSegmentIndex(_segment);
        }
      }
      _segment.calculateSegmentPoints();
      //stores the points for rendering candle - high, low and rect points
      _segment.points
        ..add(
            Offset(currentPoint.markerPoint!.x, segmentProperties.highPoint.y))
        ..add(Offset(currentPoint.markerPoint!.x, segmentProperties.lowPoint.y))
        ..add(Offset(segmentProperties.openX, segmentProperties.topRectY))
        ..add(Offset(segmentProperties.closeX, segmentProperties.topRectY))
        ..add(Offset(segmentProperties.closeX, segmentProperties.bottomRectY))
        ..add(Offset(segmentProperties.openX, segmentProperties.bottomRectY));
      _candleSegment = _segment;
      customizeSegment(_segment);
      _segment.strokePaint = _segment.getStrokePaint();
      _segment.fillPaint = _segment.getFillPaint();
      _currentSeriesDetails.segments.add(_segment);
    }
    return _segment;
  }

  @override
  CandleSegment createSegment() => CandleSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment _segment) {
    _currentSeriesDetails.candleSeries =
        _currentSeriesDetails.series as CandleSeries<dynamic, dynamic>;
    _candelSeriesRenderer = SegmentHelper.getSegmentProperties(_segment)
        .seriesRenderer as CandleSeriesRenderer;
    _candleSegment = _candelSeriesRenderer._candleSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(_candleSegment);

    if (_currentSeriesDetails.candleSeries.enableSolidCandles! == true) {
      segmentProperties.isSolid = true;
      segmentProperties.color = segmentProperties.isBull == true
          ? _currentSeriesDetails.candleSeries.bullColor
          : _currentSeriesDetails.candleSeries.bearColor;
    } else {
      segmentProperties.isSolid = segmentProperties.isBull == false;
      final SeriesRendererDetails candleSeriesDetails =
          SeriesHelper.getSeriesRendererDetails(
              segmentProperties.seriesRenderer);
      _candleSegment.currentSegmentIndex! - 1 >= 0 &&
              (candleSeriesDetails
                          .dataPoints[_candleSegment.currentSegmentIndex! - 1]
                          .close >
                      candleSeriesDetails
                          .dataPoints[_candleSegment.currentSegmentIndex!]
                          .close) ==
                  true
          ? segmentProperties.color =
              _currentSeriesDetails.candleSeries.bearColor
          : segmentProperties.color =
              _currentSeriesDetails.candleSeries.bullColor;
    }
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
  }

  /// To draw candle series segments
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment _segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    if (_segmentSeriesDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          _segmentSeriesDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              seriesRendererDetails.segments[_segment.currentSegmentIndex!],
              seriesRendererDetails.chart);
    }
    _segment.onPaint(canvas);
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
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

/// Represents the candle series painter
class CandlePainter extends CustomPainter {
  /// Calling the default constructor of CandlePainter class.
  CandlePainter(
      {required this.stateProperties,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required ValueNotifier<num> notifier,
      required this.painterKey})
      : chart = stateProperties.chart,
        super(repaint: notifier);

  /// Represents the Cartesian state properties.
  final CartesianStateProperties stateProperties;

  /// Represents the Cartesian chart.
  final SfCartesianChart chart;

  /// Specifies whether to repaint the series.
  final bool isRepaint;

  /// Specifies the value of animation controller.
  final AnimationController animationController;

  /// Specifies the list of current chart location
  List<ChartLocation> currentChartLocations = <ChartLocation>[];

  /// Specifies the candle series renderer
  CandleSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for candle series
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
    final CandleSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as CandleSeries<dynamic, dynamic>;
    CartesianChartPoint<dynamic> point;
    if (seriesRendererDetails.visible! == true) {
      canvas.save();
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the bar series must be greater than or equal to 0.');
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
        if (withInRange(seriesRendererDetails.dataPoints[pointIndex].xValue,
            seriesRendererDetails.xAxisDetails!.visibleRange!)) {
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
                seriesRenderer._createSegments(point, segmentIndex += 1,
                    painterKey.index, animationFactor));
          }
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
          series.dataLabelSettings.isVisible) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The candle series should be available to render a data label on it.');
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
  bool shouldRepaint(CandlePainter oldDelegate) => isRepaint;
}
