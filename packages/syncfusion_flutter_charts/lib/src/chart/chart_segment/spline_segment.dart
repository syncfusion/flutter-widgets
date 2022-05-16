import 'package:flutter/material.dart';
import '../../../charts.dart';

import '../../common/user_interaction/selection_behavior.dart';
import '../axis/axis.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for spline series.
///
/// Generates the spline series points and has the [calculateSegmentPoints] method overrides to customize
/// the spline segment point calculation.
///
/// Gets the path and color from the `series`.
class SplineSegment extends ChartSegment {
  double? _oldX1, _oldY1, _oldX2, _oldY2, _oldX3, _oldY3, _oldX4, _oldY4;

  /// Start point X value.
  double? startControlX;

  /// Start point Y value.
  double? startControlY;

  /// End point X value.
  double? endControlX;

  /// End point Y value.
  double? endControlY;

  ChartLocation? _currentPointLocation, _nextPointLocation;
  late ChartAxisRendererDetails _xAxisRenderer, _yAxisRenderer;
  ChartAxisRenderer? _oldXAxisRenderer, _oldYAxisRenderer;
  late Rect _axisClipRect;
  SplineSegment? _currentSegment;
  SplineSegment? _oldSegment;
  late bool _needAnimate;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Paint fillPaint = Paint();
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the spline series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the spline series should be less than or equal to 1.');
    if (segmentProperties.strokeColor != null) {
      fillPaint.color = segmentProperties.strokeColor!
          .withOpacity(segmentProperties.series.opacity);
    }
    fillPaint.strokeWidth = segmentProperties.strokeWidth!;
    fillPaint.style = PaintingStyle.stroke;
    segmentProperties.defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final Paint strokePaint = Paint();
    assert(segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the spline series should be greater than or equal to 0.');
    assert(segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the spline series should be less than or equal to 1.');
    if (segmentProperties.strokeColor != null) {
      strokePaint.color = segmentProperties.pointColorMapper ??
          segmentProperties.strokeColor!
              .withOpacity(segmentProperties.series.opacity);
      strokePaint.color = (segmentProperties.series.opacity < 1 == true &&
              strokePaint.color != Colors.transparent)
          ? strokePaint.color.withOpacity(segmentProperties.series.opacity)
          : strokePaint.color;
    }
    strokePaint.strokeWidth = segmentProperties.strokeWidth!;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    segmentProperties.defaultStrokeColor = strokePaint;
    setShader(segmentProperties, strokePaint);
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final SeriesRendererDetails segmentSeriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    _xAxisRenderer = segmentSeriesRendererDetails.xAxisDetails!;
    _yAxisRenderer = segmentSeriesRendererDetails.yAxisDetails!;
    _axisClipRect = calculatePlotOffset(
        segmentProperties.stateProperties.chartAxis.axisClipRect,
        Offset(segmentSeriesRendererDetails.xAxisDetails!.axis.plotOffset,
            segmentSeriesRendererDetails.yAxisDetails!.axis.plotOffset));
    _currentPointLocation = calculatePoint(
        segmentProperties.currentPoint!.xValue,
        segmentProperties.currentPoint!.yValue,
        _xAxisRenderer,
        _yAxisRenderer,
        segmentProperties.stateProperties.requireInvertedAxis,
        segmentProperties.series,
        _axisClipRect);
    segmentProperties.x1 = _currentPointLocation!.x;
    segmentProperties.y1 = _currentPointLocation!.y;
    _nextPointLocation = calculatePoint(
        segmentProperties.nextPoint!.xValue,
        segmentProperties.nextPoint!.yValue,
        _xAxisRenderer,
        _yAxisRenderer,
        segmentProperties.stateProperties.requireInvertedAxis,
        segmentProperties.series,
        _axisClipRect);
    segmentProperties.x2 = _nextPointLocation!.x;
    segmentProperties.y2 = _nextPointLocation!.y;

    startControlX = segmentProperties.currentPoint!.startControl!.x;
    startControlY = segmentProperties.currentPoint!.startControl!.y;
    endControlX = segmentProperties.currentPoint!.endControl!.x;
    endControlY = segmentProperties.currentPoint!.endControl!.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(this);
    final SeriesRendererDetails segmentSeriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (segmentSeriesRendererDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          segmentSeriesRendererDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              segmentSeriesRendererDetails.segments[currentSegmentIndex!],
              segmentSeriesRendererDetails.chart);
    }
    late Rect rect;
    if (segmentSeriesRendererDetails.xAxisDetails != null &&
        segmentSeriesRendererDetails.yAxisDetails != null) {
      rect = calculatePlotOffset(
          segmentProperties.stateProperties.chartAxis.axisClipRect,
          Offset(segmentSeriesRendererDetails.xAxisDetails!.axis.plotOffset,
              segmentSeriesRendererDetails.yAxisDetails!.axis.plotOffset));
    }

    // Draw spline series.
    if (segmentProperties.series.animationDuration > 0 == true &&
        segmentSeriesRendererDetails.reAnimate == false &&
        segmentProperties.stateProperties.renderingDetails.widgetNeedUpdate ==
            true &&
        segmentProperties.stateProperties.renderingDetails.isLegendToggled ==
            false &&
        segmentProperties.stateProperties.oldSeriesRenderers.isNotEmpty ==
            true &&
        segmentProperties.oldSeries != null &&
        SeriesHelper.getSeriesRendererDetails(segmentProperties.oldSeriesRenderer!)
                .segments
                .isNotEmpty ==
            true &&
        SeriesHelper.getSeriesRendererDetails(segmentProperties.oldSeriesRenderer!)
            .segments[0] is SplineSegment &&
        segmentProperties.stateProperties.oldSeriesRenderers.length - 1 >=
                SegmentHelper.getSegmentProperties(segmentSeriesRendererDetails
                        .segments[currentSegmentIndex!])
                    .seriesIndex ==
            true &&
        SeriesHelper.getSeriesRendererDetails(SegmentHelper.getSegmentProperties(
                        segmentSeriesRendererDetails
                            .segments[currentSegmentIndex!])
                    .oldSeriesRenderer!)
                .segments
                .isNotEmpty ==
            true &&
        segmentProperties.currentPoint!.isGap != true &&
        segmentProperties.nextPoint!.isGap != true) {
      _currentSegment = segmentSeriesRendererDetails
          .segments[currentSegmentIndex!] as SplineSegment;
      final SegmentProperties currentSegmentProperties =
          SegmentHelper.getSegmentProperties(_currentSegment!);
      SegmentProperties? oldSegmentProperties;
      final SeriesRendererDetails currentOldSeriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              currentSegmentProperties.oldSeriesRenderer!);
      _oldSegment = (currentOldSeriesRendererDetails.segments.length - 1 >=
                  currentSegmentIndex! ==
              true)
          ? currentOldSeriesRendererDetails.segments[currentSegmentIndex!]
              as SplineSegment?
          : null;
      if (_oldSegment != null) {
        oldSegmentProperties = SegmentHelper.getSegmentProperties(_oldSegment!);
      }
      _oldX1 = oldSegmentProperties?.x1;
      _oldY1 = oldSegmentProperties?.y1;
      _oldX2 = oldSegmentProperties?.x2;
      _oldY2 = oldSegmentProperties?.y2;
      _oldX3 = _oldSegment?.startControlX;
      _oldY3 = _oldSegment?.startControlY;
      _oldX4 = _oldSegment?.endControlX;
      _oldY4 = _oldSegment?.endControlY;

      if (_oldSegment != null &&
          (_oldX1!.isNaN || _oldX2!.isNaN) &&
          segmentProperties.stateProperties.oldAxisRenderers.isNotEmpty ==
              true) {
        ChartLocation oldPoint;
        _oldXAxisRenderer = getOldAxisRenderer(
            segmentSeriesRendererDetails.xAxisDetails!.axisRenderer,
            segmentProperties.stateProperties.oldAxisRenderers);
        _oldYAxisRenderer = getOldAxisRenderer(
            segmentSeriesRendererDetails.yAxisDetails!.axisRenderer,
            segmentProperties.stateProperties.oldAxisRenderers);
        if (_oldYAxisRenderer != null && _oldXAxisRenderer != null) {
          final ChartAxisRendererDetails oldXAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldXAxisRenderer!);
          final ChartAxisRendererDetails oldYAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldYAxisRenderer!);
          _needAnimate = oldYAxisDetails.visibleRange!.minimum !=
                  segmentSeriesRendererDetails
                      .yAxisDetails!.visibleRange!.minimum ||
              oldYAxisDetails.visibleRange!.maximum !=
                  segmentSeriesRendererDetails
                      .yAxisDetails!.visibleRange!.maximum ||
              oldXAxisDetails.visibleRange!.minimum !=
                  segmentSeriesRendererDetails
                      .xAxisDetails!.visibleRange!.minimum ||
              oldXAxisDetails.visibleRange!.maximum !=
                  segmentSeriesRendererDetails
                      .xAxisDetails!.visibleRange!.maximum;
        }
        if (_needAnimate) {
          final ChartAxisRendererDetails oldXAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldXAxisRenderer!);
          final ChartAxisRendererDetails oldYAxisDetails =
              AxisHelper.getAxisRendererDetails(_oldYAxisRenderer!);
          oldPoint = calculatePoint(
              segmentProperties.currentPoint!.xValue,
              segmentProperties.currentPoint!.yValue,
              oldXAxisDetails,
              oldYAxisDetails,
              segmentProperties.stateProperties.requireInvertedAxis,
              segmentProperties.series,
              rect);
          _oldX1 = oldPoint.x;
          _oldY1 = oldPoint.y;
          oldPoint = calculatePoint(
              segmentProperties.nextPoint!.xValue,
              segmentProperties.nextPoint!.xValue,
              oldXAxisDetails,
              oldYAxisDetails,
              segmentProperties.stateProperties.requireInvertedAxis,
              segmentProperties.series,
              rect);
          _oldX2 = oldPoint.x;
          _oldY2 = oldPoint.y;
          oldPoint = calculatePoint(
              startControlX!,
              startControlY!,
              oldXAxisDetails,
              oldYAxisDetails,
              segmentProperties.stateProperties.requireInvertedAxis,
              segmentProperties.series,
              rect);
          _oldX3 = oldPoint.x;
          _oldY3 = oldPoint.y;
          oldPoint = calculatePoint(
              endControlX!,
              endControlY!,
              oldXAxisDetails,
              oldYAxisDetails,
              segmentProperties.stateProperties.requireInvertedAxis,
              segmentProperties.series,
              rect);
          _oldX4 = oldPoint.x;
          _oldY4 = oldPoint.y;
        }
      }
      animateLineTypeSeries(
        canvas,
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer),
        strokePaint!,
        animationFactor,
        currentSegmentProperties.x1,
        currentSegmentProperties.y1,
        currentSegmentProperties.x2,
        currentSegmentProperties.y2,
        _oldX1,
        _oldY1,
        _oldX2,
        _oldY2,
        _currentSegment!.startControlX,
        _currentSegment!.startControlY,
        _oldX3,
        _oldY3,
        _currentSegment!.endControlX,
        _currentSegment!.endControlY,
        _oldX4,
        _oldY4,
      );
    } else {
      final Path path = Path();
      path.moveTo(segmentProperties.x1, segmentProperties.y1);
      if (segmentProperties.currentPoint!.isGap != true &&
          segmentProperties.nextPoint!.isGap != true) {
        path.cubicTo(startControlX!, startControlY!, endControlX!, endControlY!,
            segmentProperties.x2, segmentProperties.y2);
        drawDashedLine(
            canvas, segmentProperties.series.dashArray, strokePaint!, path);
      }
    }
  }

  @override
  void dispose() {
    _currentPointLocation = null;
    _nextPointLocation = null;
    _currentSegment = null;
    _oldSegment = null;
    super.dispose();
  }
}
